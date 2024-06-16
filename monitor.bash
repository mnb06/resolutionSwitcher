res=${1}x${2}
case "$XDG_CURRENT_DESKTOP" in
    sway)
        if [ -z $1 ]; then
            echo "output HDMI-A-1 resolution 1920x1080@240hz position 0,1080" > ~/.config/sway/config.d/output
            swaymsg reload
        else
            echo "output HDMI-A-1 resolution --custom $res@240hz position 0,1080" > ~/.config/sway/config.d/output
            swaymsg reload
        fi
        ;;
    Hyprland)
        if [ -z $1 ]; then
            echo "monitor = HDMI-A-1, 1920x1080@240hz, 0x500, 1" > ~/.config/hypr/output.conf
        else
            echo "monitor = HDMI-A-1, $res@240hz, 0x500, 1" > ~/.config/hypr/output.conf
        fi
        ;;
    i3)
        if [ -z $1 ]; then
            xrandr --output HDMI-1 --mode 1920x1080 --rate 240 --primary --left-of DP-2
        else
            cvt $1 $2 240 | grep Modeline | sed 's/\<Modeline\>//g' > ~/Scripts/x11
            newmode=$(sed 's/\"//g' ~/Scripts/x11)
            xrandr --newmode $newmode
            xrandr --addmode HDMI-1 ${res}_240.00
            xrandr --output HDMI-1 --mode ${res}_240.00 --rate 240 --primary --left-of DP-2
        fi
        ;;
esac
