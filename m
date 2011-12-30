Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:41439 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751934Ab1L3KBs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 05:01:48 -0500
Received: by lahd3 with SMTP id d3so2865505lah.19
        for <linux-media@vger.kernel.org>; Fri, 30 Dec 2011 02:01:47 -0800 (PST)
Message-ID: <1325239295.17039.2.camel@mint>
Subject: Re: em28xx: new board id [eb1a:5051]
From: Gareth Williams <gareth@garethwilliams.me.uk>
To: Reuben Stokes <okonomiyakisan@gohighspeed.com>
Cc: linux-media@vger.kernel.org
Date: Fri, 30 Dec 2011 10:01:35 +0000
In-Reply-To: <201112291513.16680.okonomiyakisan@gohighspeed.com>
References: <201112291513.16680.okonomiyakisan@gohighspeed.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2011-12-29 at 15:13 -0800, Reuben Stokes wrote:
> Hi,
> 
> Not nearly as linux-savvy as most of the users here, but I attempted to operate a "Raygo USB Video Recorder" (audio/video capture device). Don't know if my efforts qualify as a "test".
> 
> 
> Model Number: 
> R12-41373
> 
> Display name: 
> USB 2861 Device
> 
> lsusb: 
> Bus 001 Device 002: ID eb1a:5051 eMPIA Technology, Inc. 
> 
> dmesg:
> [ 7182.076058] usb 1-1: new high speed USB device using ehci_hcd and address 3
> [ 7182.212702] usb 1-1: New USB device found, idVendor=eb1a, idProduct=5051
> [ 7182.212714] usb 1-1: New USB device strings: Mfr=0, Product=1, SerialNumber=2
> [ 7182.212723] usb 1-1: Product: USB 2861 Device
> [ 7182.212729] usb 1-1: SerialNumber: 0
> 
> System:
> HP Pavilion dv6910 laptop
> AMD Turion X2 CPU (64 bit)
> Mepis 11; 64 bit( based on Debian Squeeze)
> 
> 
> Tried
> -------
> * Installed em28xx drivers using instructions found at linuxtv.org.
>   I note however that this particular vendor/product ID is not validated in the em28xx devices list.
> * As new drivers do not automatically load, I use command: modprobe em28xx
>    After this "modprobe -l | grep em28xx" yields
>         kernel/drivers/media/video/em28xx/em28xx-alsa.ko
>         kernel/drivers/media/video/em28xx/em28xx.ko
>         kernel/drivers/media/video/em28xx/em28xx-dvb.ko
> * Device comes with a driver CD for Windows which does work in Windows.
> 
> End result is the device is not recognized as a capture device option in any software tried including vlc, cheese, guvcview, kdenlive.
> 
> Any help getting this to work in Linux would be appreciated as it completely sucks in my bloated, memory-hogging, 32-bit Windows Vista.
> 
> Reuben <okonomiyakisan@gohighspeed.com>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Reuben,

If you're willing, then open up the device and see what the chips within
are.  You believe it's em28xx based, but there may well be additional
devices in there for audio and video.

Once you've found out what's inside it will be easier to get it working.
It may be as simple as getting the driver to recognise the USB Vendor ID
or it may require much more work.

Regards,

Gareth

