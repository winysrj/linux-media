Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-1-out2.atlantis.sk ([80.94.52.71]:50573 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759825Ab2EIPjS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 May 2012 11:39:18 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Bruno Martins <lists@skorzen.net>
Subject: Re: Dazzle DVC80 under FC16
Date: Wed, 9 May 2012 17:32:14 +0200
Cc: linux-media@vger.kernel.org
References: <4FAA57A3.2030701@skorzen.net> <4FAA75A7.5030807@skorzen.net>
In-Reply-To: <4FAA75A7.5030807@skorzen.net>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201205091732.18373.linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 09 May 2012, Bruno Martins wrote:
> Hello guys,
>
> Has anyone ever got this to working under any Linux distro, including
> Fedora?
>
> I have just plugged it in and I get this on dmesg:
>
> [ 1365.932522] usb 2-1.1: new full-speed USB device number 26 using ehci_hcd
> [ 1366.073145] usb 2-1.1: New USB device found, idVendor=07d0, idProduct=0004
> [ 1366.073153] usb 2-1.1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> [ 1366.091741] usbvision_probe: Dazzle Fusion Model DVC-80 Rev 1 (PAL) found
> [ 1366.092072] USBVision[0]: registered USBVision Video device video1 [v4l2]
> [ 1366.092091] usbvision_probe: Dazzle Fusion Model DVC-80 Rev 1 (PAL) found
> [ 1366.092149] USBVision[1]: registered USBVision Video device video2 [v4l2]
> [ 1366.092182] usbcore: registered new interface driver usbvision
> [ 1366.092184] USBVision USB Video Device Driver for Linux : 0.9.11
> [ 1366.189268] saa7115 15-0025: saa7113 found (1f7113d0e100000) @ 0x4a (usbvision-2-1.1)
> [ 1366.319647] usb 2-1.1: selecting invalid altsetting 1
> [ 1366.319658] usb 2-1.1: cannot change alternate number to 1 (error=-22)
>
> Device is recognized since it appears in lsusb:
>
> [skorzen@g62 ~]$ lsusb | grep DVC
> Bus 002 Device 026: ID 07d0:0004 Dazzle DVC-800 (PAL) Grabber
>
> However, I cannot make it work (my goal is to capture video from a
> camcorder).
> I've tried using cheese for this, but it just crashes and ABRT
> launches for me to fill a bug.
>
> Any ideas?

Please include the output of "lsusb -v" for this device (run the command as root).


-- 
Ondrej Zary
