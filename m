Return-path: <linux-media-owner@vger.kernel.org>
Received: from mis07.de ([93.186.196.80]:50539 "EHLO mis07.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753356Ab0APUEd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Jan 2010 15:04:33 -0500
Message-ID: <6FC529251E9949CC9F6C4D99D6B55F46@pcvirus>
From: "rath" <mailings@hardware-datenbank.de>
To: "Jean-Francois Moine" <moinejf@free.fr>
Cc: <linux-media@vger.kernel.org>
References: <3A9AF82CE14046A794C61D83B70F62BB@pcvirus> <20100116191401.5296db70@tele>
Subject: Re: camera with high framerate
Date: Sat, 16 Jan 2010 21:03:24 +0100
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="UTF-8";
	reply-type=original
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Okay, are there some other cameras avaiable with 160x120 pixels or output in 
rgb? I only have an ARM Cortex-A8 with 500MHz to process the image data and 
converting between different pixelformats take a long time. So it would be 
fine if a resolution of 160x120 pixels is supported or the output is in rgb.

----- Original Message ----- 
From: "Jean-Francois Moine" <moinejf@free.fr>
To: "rath" <mailings@hardware-datenbank.de>
Cc: <linux-media@vger.kernel.org>
Sent: Saturday, January 16, 2010 7:14 PM
Subject: Re: camera with high framerate


On Sat, 16 Jan 2010 18:33:54 +0100
"rath" <mailings@hardware-datenbank.de> wrote:

> I'm searching a v4l supported webcam with a framerate higher than
> 30fps. I found the Playstation Eye and it seems to have a framerate
> of up to 120fps @320x240 pixels.
> Does this camera support a resolution of 160x120 pixels? How are the
> images transfered over usb (jpeg, rgb, yuv)?

Hi Joern,

The resolutions are only 640x480 and 320x240. The images are transfered
in YUYV (16 bits YUV 4:2:2).

Regards.

-- 
Ken ar c'hentañ |       ** Breizh ha Linux atav! **
Jef | http://moinejf.free.fr/

