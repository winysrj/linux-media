Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:50731 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292Ab3CBT3S (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Mar 2013 14:29:18 -0500
Date: Sat, 2 Mar 2013 20:29:16 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Rafael Coutinho <rafael.coutinho@phiinnovations.com>
cc: linux-media@vger.kernel.org
Subject: Re: V4L on android
In-Reply-To: <CAB0d6EeZJu983yP3wMwbZtniDwWgoAuxAzifZvo_RZpO4Dio8Q@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1303022026140.30447@axis700.grange>
References: <CAB0d6EdexHb_sLh3m_xRf36N9SUrr1axogxidyp+64-ROKDHjw@mail.gmail.com>
 <CAB0d6EeZJu983yP3wMwbZtniDwWgoAuxAzifZvo_RZpO4Dio8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rafael

On Wed, 27 Feb 2013, Rafael Coutinho wrote:

> Hi,
> 
> I'm having issues to get my video capture board to work. I see that
> when I connect it is successfully mapped with the video driver:

This is good, however, android out of the box doesn't support V4L. On this

http://open-technology.de/pages/camera-HAL.html

page you can find a short description of my work in this area and a couple 
of links.

Thanks
Guennadi

> <3>[   11.210876] em28xx #0: board has no eeprom
> <6>[   11.244746] em28xx #0: found i2c device @ 0x4a [saa7113h]
> <3>[   11.278498] em28xx #0: Your board has no unique USB ID.
> <3>[   11.278504] em28xx #0: A hint were successfully done, based on
> i2c devicelist hash.
> <3>[   11.278509] em28xx #0: This method is not 100% failproof.
> <3>[   11.278513] em28xx #0: If the board were missdetected, please
> email this log to:
> <3>[   11.278518] em28xx #0: 	V4L Mailing List  <linux-media@vger.kernel.org>
> <3>[   11.278523] em28xx #0: Board detected as EM2860/SAA711X Reference Design
> <6>[   11.370027] em28xx #0: Identified as EM2860/SAA711X Reference
> Design (card=19)
> <6>[   11.370033] em28xx #0: Registering snapshot button...
> <6>[   11.370366] input: em28xx snapshot button as
> /devices/pci0000:00/0000:00:1d.7/usb1/1-6/input/input8
> <6>[   12.020506] saa7115 15-0025: saa7113 found (1f7113d0e100000) @
> 0x4a (em28xx #0)
> <6>[   13.300245] em28xx #0: Config register raw data: 0x10
> <4>[   13.340250] em28xx #0: AC97 vendor ID = 0x83847652
> <4>[   13.360249] em28xx #0: AC97 features = 0x6a90
> <6>[   13.360255] em28xx #0: Sigmatel audio processor detected(stac 9752)
> <6>[   14.120032] em28xx #0: v4l2 driver version 0.1.2
> <6>[   15.820615] em28xx #0: V4L2 video device registered as video1
> <6>[   15.820623] em28xx #0: V4L2 VBI device registered as vbi0
> <3>[   15.820678] em28xx audio device (eb1a:2861): interface 1, class 1
> <3>[   15.820704] em28xx audio device (eb1a:2861): interface 2, class 1
> <6>[   15.820953] usbcore: registered new interface driver em28xx
> <6>[   15.820960] em28xx driver loaded
> 
> However when I try to use androids app for camera it gives me a blank screen...
> Do you have any suggestions on how I could debug it? I've been looking
> for any android command line programs to take snap shots but nothing
> so far. An advice is welcome.
> 
> Thanks a lot.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
