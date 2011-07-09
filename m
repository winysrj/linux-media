Return-path: <mchehab@localhost>
Received: from mail.kapsi.fi ([217.30.184.167]:38404 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756Ab1GIDsX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 8 Jul 2011 23:48:23 -0400
Message-ID: <4E17CF84.108@iki.fi>
Date: Sat, 09 Jul 2011 06:48:20 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: David <reality_es@yahoo.es>
CC: linux-media@vger.kernel.org
Subject: Re: Fwd: [PATCH] STV22 Dual USB DVB-T Tuner HDTV linux kernel support
References: <BANLkTi=SM+syVFQOs3_22tGZN1v+AcKGpQ@mail.gmail.com> <BANLkTimSqC3bAyJQneXkmM8Mae5Ono1JLA@mail.gmail.com>
In-Reply-To: <BANLkTimSqC3bAyJQneXkmM8Mae5Ono1JLA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

On 06/24/2011 12:37 AM, David wrote:
> Hello:
>
> I expect the patches finally are ok.

Hello and sorry for delay.
Your patch is not OK.

Biggest fault is that it does not increase .num_device_descs count. It 
will break some other device. Don't try to add new devices between 
existing devices. If you were added it correctly behind existing devices 
you must already find out something is broken since device was not detected.

See that example how to add device:
http://kerneltrap.org/mailarchive/git-commits-head/2010/5/20/34349/thread

Good place, for example, to add your device is behind: "AverMedia AVerTV 
Volar Black HD (A850)" device.

And here is example how to map remote:
http://www.mail-archive.com/linuxtv-commits@linuxtv.org/msg09016.html


Antti




>
> This patches add
>
> Signed-off-by: Emilio David Diaus Lopez<reality_es@yahoo.es>
> -----------------------------------------
>
> -- ./drivers/media/dvb/dvb-usb/af9015.c.orig    2011-06-21
> 12:39:44.000000000 +0200
> +++ ./drivers/media/dvb/dvb-usb/af9015.c        2011-06-22
> 12:05:28.000000000 +0200
> @@ -749,6 +749,8 @@ static const struct af9015_rc_setup af90
>                 RC_MAP_AZUREWAVE_AD_TU700 },
>         { (USB_VID_MSI_2<<  16) + USB_PID_MSI_DIGI_VOX_MINI_III,
>                 RC_MAP_MSI_DIGIVOX_III },
> +       { (USB_VID_KWORLD_2<<  16) + USB_PID_SVEON_STV22,
> +               RC_MAP_MSI_DIGIVOX_III },
>         { (USB_VID_LEADTEK<<  16) + USB_PID_WINFAST_DTV_DONGLE_GOLD,
>                 RC_MAP_LEADTEK_Y04G0051 },
>         { (USB_VID_AVERMEDIA<<  16) + USB_PID_AVERMEDIA_VOLAR_X,
> @@ -1309,6 +1311,7 @@ static struct usb_device_id af9015_usb_t
>                 USB_PID_TERRATEC_CINERGY_T_STICK_DUAL_RC)},
>   /* 35 */{USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_A850T)},
>         {USB_DEVICE(USB_VID_GTEK,      USB_PID_TINYTWIN_3)},
> +       {USB_DEVICE(USB_VID_KWORLD_2,  USB_PID_SVEON_STV22)},
>         {0},
>   };
>   MODULE_DEVICE_TABLE(usb, af9015_usb_table);
> @@ -1649,6 +1652,11 @@ static struct dvb_usb_device_properties
>                                 .warm_ids = {NULL},
>                         },
>                         {
> +                               .name = "Sveon STV22 Dual USB DVB-T
> Tuner HDTV ",
> +                               .cold_ids = {&af9015_usb_table[37], NULL},
> +                               .warm_ids = {NULL},
> +                       },
> +                       {
>                                 .name = "Leadtek WinFast DTV2000DS",
>                                 .cold_ids = {&af9015_usb_table[29], NULL},
>                                 .warm_ids = {NULL},
>
> ------------------------------
> --- ./drivers/media/dvb/dvb-usb/dvb-usb-ids.h.orig      2011-06-21
> 12:39:45.000000000 +0200
> +++ ./drivers/media/dvb/dvb-usb/dvb-usb-ids.h   2011-06-18
> 11:48:22.000000000 +0200
> @@ -128,6 +128,7 @@
>   #define USB_PID_INTEL_CE9500                           0x9500
>   #define USB_PID_KWORLD_399U                            0xe399
>   #define USB_PID_KWORLD_399U_2                          0xe400
> +#define USB_PID_SVEON_STV22                            0xe401
>   #define USB_PID_KWORLD_395U                            0xe396
>   #define USB_PID_KWORLD_395U_2                          0xe39b
>   #define USB_PID_KWORLD_395U_3                          0xe395
> ------------------------
> 1.1
> -----------------------
> Thanks for your time
>
> goodbye
> Emilio David Diaus López
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
http://palosaari.fi/
