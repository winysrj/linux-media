Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46376 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938Ab2ATEe3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Jan 2012 23:34:29 -0500
Received: by iagf6 with SMTP id f6so322342iag.19
        for <linux-media@vger.kernel.org>; Thu, 19 Jan 2012 20:34:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F182BCF.60303@redhat.com>
References: <CACGt9y=8FzimyQPx7gJQ=gVqDp7cRUojT53gJq2+TNKhH37Wpg@mail.gmail.com>
 <4F182BCF.60303@redhat.com>
From: =?UTF-8?Q?Denilson_Figueiredo_de_S=C3=A1?= <denilsonsa@gmail.com>
Date: Fri, 20 Jan 2012 02:34:08 -0200
Message-ID: <CACGt9ymVoDWyG8rt3psCT-PmZ7zeB_8YTjv5ZZQ-2Mx2-pteag@mail.gmail.com>
Subject: Re: Siano DVB USB device called "Smart Plus"
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jan 19, 2012 at 12:42, Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
>
> From the product page, it is a 1-seg device. So, it likely uses a sms1xxx
> chip.

Correct, Siano SMS1140.

> You'll likely need to add a new board entry there for it, and discover
> the GPIO pins linked to the leds and infrared (the numbers for .board_cfg
> and .led* on the above data structure). You can do it by either sniffing
> the USB board traffic or by opening the device and carefully examining the
> board tracks.

I've added two photos of the circuit here:
http://linuxtv.org/wiki/index.php/Smart_Plus

Considering there are these lines at sms-usb.c:
        { USB_DEVICE(0x187f, 0x0202),
                .driver_info = SMS1XXX_BOARD_SIANO_NICE },

I thought I didn't need to add a new board entry, just update the
current one. Then I added a few lines, as shown below, but it seems
the driver still tries to load "dvb_nova_12mhz_b0.inp" instead of
"isdbt_nova_12mhz_b0.inp".

If I rename (or symlink) the firmware file, the driver loads the
firmware. After smsdvb module gets loaded, then there is a /dev/dvb/
entry for my device, but still the programs I tried (w_scan and vlc)
don't find any channels.


About the GPIO pins: even on Windows, the only LED from this device
does not blink. So I don't care about LED feedback. Also, right now
I'm not worried about IR remote, so I'm leaving that out.

Anyway, I can supply some usb logs if they would help debugging this.


--- sms-cards.c.orig    2012-01-20 00:42:47.000000000 -0200
+++ sms-cards.c 2012-01-20 01:05:11.000000000 -0200
@@ -92,6 +92,8 @@
        /* 11 */
                .name = "Siano Nice Digital Receiver",
                .type = SMS_NOVA_B0,
+               .fw[DEVICE_MODE_ISDBT_BDA] = "isdbt_nova_12mhz_b0.inp",
+               .rc_codes = RC_MAP_HAUPPAUGE,
        },
        [SMS1XXX_BOARD_SIANO_VENICE] = {
        /* 12 */
@@ -299,6 +301,7 @@
        case SMS1XXX_BOARD_HAUPPAUGE_WINDHAM:
        case SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD:
        case SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD_R2:
+       case SMS1XXX_BOARD_SIANO_NICE:
                request_module("smsdvb");
                break;
        default:


-- 
Denilson Figueiredo de Sá
Belo Horizonte - Brasil
