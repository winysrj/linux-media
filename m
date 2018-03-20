Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:33962 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753501AbeCTN3J (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Mar 2018 09:29:09 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Paul Menzel <pmenzel+linux-media@molgen.mpg.de>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        it+linux-media@molgen.mpg.de
Subject: Re: uvcvideo: Unknown video format,00000032-0002-0010-8000-00aa00389b71
Date: Tue, 20 Mar 2018 15:30:14 +0200
Message-ID: <6647791.pjJyibMGYG@avalon>
In-Reply-To: <8f7d4aef-84f7-ae22-8adc-cba4fa881675@molgen.mpg.de>
References: <8f7d4aef-84f7-ae22-8adc-cba4fa881675@molgen.mpg.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Paul,

On Tuesday, 20 March 2018 14:20:14 EET Paul Menzel wrote:
> Dear Linux folks,
> 
> 
> On the Dell XPS 13 9370, Linux 4.16-rc6 outputs the messages below.
> 
> ```
> [    2.338094] calling  uvc_init+0x0/0x1000 [uvcvideo] @ 295
> [    2.338569] calling  iTCO_wdt_init_module+0x0/0x1000 [iTCO_wdt] @ 280
> [    2.338570] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
> [    2.338713] iTCO_wdt: Found a Intel PCH TCO device (Version=4,
> TCOBASE=0x0400)
> [    2.338755] uvcvideo: Found UVC 1.00 device Integrated_Webcam_HD
> (0bda:58f4)
> [    2.338827] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
> [    2.338851] initcall iTCO_wdt_init_module+0x0/0x1000 [iTCO_wdt]
> returned 0 after 271 usecs
> [    2.340669] uvcvideo 1-5:1.0: Entity type for entity Extension 4 was
> not initialized!
> [    2.340670] uvcvideo 1-5:1.0: Entity type for entity Extension 7 was
> not initialized!
> [    2.340672] uvcvideo 1-5:1.0: Entity type for entity Processing 2 was
> not initialized!
> [    2.340673] uvcvideo 1-5:1.0: Entity type for entity Camera 1 was not
> initialized!
> [    2.340736] input: Integrated_Webcam_HD: Integrate as
> /devices/pci0000:00/0000:00:14.0/usb1/1-5/1-5:1.0/input/input9
> [    2.341447] uvcvideo: Unknown video format
> 00000032-0002-0010-8000-00aa00389b71
> [    2.341450] uvcvideo: Found UVC 1.00 device Integrated_Webcam_HD
> (0bda:58f4)
> [    2.343371] uvcvideo: Unable to create debugfs 1-2 directory.
> [    2.343420] uvcvideo 1-5:1.2: Entity type for entity Extension 10 was
> not initialized!
> [    2.343422] uvcvideo 1-5:1.2: Entity type for entity Extension 12 was
> not initialized!
> [    2.343423] uvcvideo 1-5:1.2: Entity type for entity Processing 9 was
> not initialized!
> [    2.343424] uvcvideo 1-5:1.2: Entity type for entity Camera 11 was
> not initialized!
> [    2.343472] input: Integrated_Webcam_HD: Integrate as
> /devices/pci0000:00/0000:00:14.0/usb1/1-5/1-5:1.2/input/input10
> [    2.343496] usbcore: registered new interface driver uvcvideo
> [    2.343496] USB Video Class driver (1.1.1)
> [    2.343501] initcall uvc_init+0x0/0x1000 [uvcvideo] returned 0 after
> 5275 usecs
> ```
> 
> Please tell me, what I can do to improve the situation.

Some vendors routinely implement new formats without bothering to send a patch 
for the uvcvideo driver. It would be easy to do so, but it requires knowing 
which format is meant by the GUID. Most format GUIDs are of the form 
32595559-0000-0010-8000-00aa00389b71 that starts with a 4CC, but that's not 
the case here.

Could you send me the output of

lsusb -v -d 0bda:58f4

running as root if possible ?

-- 
Regards,

Laurent Pinchart
