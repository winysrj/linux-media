Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:4689 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382Ab0C0Ocj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Mar 2010 10:32:39 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Andy Walls <awalls@radix.net>
Subject: Re: Testers for the cpia2 driver wanted!
Date: Sat, 27 Mar 2010 15:32:56 +0100
Cc: linux-media@vger.kernel.org
References: <201003240855.50598.hverkuil@xs4all.nl> <1269692744.3079.17.camel@palomino.walls.org>
In-Reply-To: <1269692744.3079.17.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201003271532.56054.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 27 March 2010 13:25:44 Andy Walls wrote:
> On Wed, 2010-03-24 at 08:55 +0100, Hans Verkuil wrote:
> > Hi all,
> > 
> > I'm looking for someone who has hardware that can test the cpia2 driver.
> > 
> > I thought I had hardware for that, but it turned out that it used the gspca
> > mars driver instead.
> 
> A co-worker just gave me an Intel Play QX3 microscope:
> 
>         [ 1218.810045] usb 3-3: new full speed USB device using ohci_hcd and address 3
>         [ 1219.026373] usb 3-3: configuration #1 chosen from 1 choice
>         [ 1219.027352] usb 3-3: New USB device found, idVendor=0813, idProduct=0001
>         [ 1219.027358] usb 3-3: New USB device strings: Mfr=2, Product=1, SerialNumber=0
>         [ 1219.027363] usb 3-3: Product: Intel Play QX3 Microscope
>         [ 1219.027367] usb 3-3: Manufacturer: Mattel Inc.
>         [ 1219.145032] gspca: main v2.9.0 registered
>         [ 1219.152733] gspca: probing 0813:0001
>         [ 1219.152758] cpia1: cpia CPiA camera detected (vid/pid 0x0813:0x0001)
>         [ 1219.479599] cpia1: CPIA Version:             1.33 (2.10)
>         [ 1219.479614] cpia1: CPIA PnP-ID:              0813:0001:0106
>         [ 1219.479619] cpia1: VP-Version:               1.0 0100
>         [ 1219.481976] gspca: video2 created
>         [ 1219.482271] usbcore: registered new interface driver cpia1
>         [ 1219.484291] cpia1: registered
>         [ 1219.500235] V4L-Driver for Vision CPiA based cameras v1.2.3
>         [ 1219.500256] Since in-kernel colorspace conversion is not allowed, it is disabled by default now. Users should fix the applications in case they don't work without conversion reenabled by setting the 'colorspace_conv' module parameter to 1
>         [ 1219.508170] USB driver for Vision CPiA based cameras v1.2.3
>         [ 1219.508267] usbcore: registered new interface driver cpia
> 
> 
> But it looks like it is not supported by cpia2:
> 
> 	$ grep 'USB_DEVICE(.*813' cpia* cpia2/* gspca/* 
> 	cpia_usb.c:	{ USB_DEVICE(0x0813, 0x0001) },
> 	gspca/cpia1.c:	{USB_DEVICE(0x0813, 0x0001)},
> 	gspca/ov519.c:	{USB_DEVICE(0x0813, 0x0002), .driver_info = BRIDGE_OV511PLUS },
> 
> Is there any testing you need done with this device?

No, thanks. I think that the original QX3 had the cpia2 device, but that later
models switched to other sensors.

Thanks for looking at this!

	Hans

> 
> 
> Regards,
> Andy
> 
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
