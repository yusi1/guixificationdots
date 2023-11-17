#!/usr/bin/env bash
 
read -p "Enter OTP Provider name: " OTP_PROVIDER
read -p "Enter OTP Token: " OTP_TOKEN

URI="otpauth://totp/$OTP_PROVIDER?secret=$OTP_TOKEN&issuer=$OTP_PROVIDER"

echo $URI

[ $(command -v xclip) ] && [ "$XDG_SESSION_TYPE" == "x11" ] && echo $URI | tr -d '\n' | xclip -selection c
[ $(command -v termux-clipboard-set) ] && echo $URI | tr -d '\n' | termux-clipboard-set
[ $(command -v osc52.sh) ] && echo $URI | tr -d '\n' | osc52.sh

