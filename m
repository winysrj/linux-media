Return-path: <linux-media-owner@vger.kernel.org>
Received: from ms01.sssup.it ([193.205.80.99]:41196 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751094Ab0APUWJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Jan 2010 15:22:09 -0500
Message-ID: <4B521FE7.8000408@panicking.kicks-ass.org>
Date: Sat, 16 Jan 2010 21:21:59 +0100
From: Michael Trimarchi <michael@panicking.kicks-ass.org>
MIME-Version: 1.0
To: rath <mailings@web150.mis07.de>
CC: Jean-Francois Moine <moinejf@free.fr>, linux-media@vger.kernel.org
Subject: Re: camera with high framerate
References: <3A9AF82CE14046A794C61D83B70F62BB@pcvirus> <20100116191401.5296db70@tele> <6FC529251E9949CC9F6C4D99D6B55F46@pcvirus>
In-Reply-To: <6FC529251E9949CC9F6C4D99D6B55F46@pcvirus>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

rath wrote:
> Okay, are there some other cameras avaiable with 160x120 pixels or 
> output in rgb? I only have an ARM Cortex-A8 with 500MHz to process the 
> image data and converting between different pixelformats take a long 
> time. So it would be fine if a resolution of 160x120 pixels is supported 
> or the output is in rgb.

ov538-ov7690 solution

static const struct v4l2_pix_format vga_mode[] = {

        { 176, 144, V4L2_PIX_FMT_YUYV, V4L2_FIELD_NONE,
         .bytesperline = 176 * 2,
         .sizeimage = 176 * 144 * 2,
         .colorspace = V4L2_COLORSPACE_SRGB,
         .priv = size176_144 },

I think that it has the 160x120 resolution too, but I don't write the code for that.
The sensor arrive at 60 fps in QVGA mode

Michael

> 
> ----- Original Message ----- From: "Jean-Francois Moine" <moinejf@free.fr>
> To: "rath" <mailings@hardware-datenbank.de>
> Cc: <linux-media@vger.kernel.org>
> Sent: Saturday, January 16, 2010 7:14 PM
> Subject: Re: camera with high framerate
> 
> 
> On Sat, 16 Jan 2010 18:33:54 +0100
> "rath" <mailings@hardware-datenbank.de> wrote:
> 
>> I'm searching a v4l supported webcam with a framerate higher than
>> 30fps. I found the Playstation Eye and it seems to have a framerate
>> of up to 120fps @320x240 pixels.
>> Does this camera support a resolution of 160x120 pixels? How are the
>> images transfered over usb (jpeg, rgb, yuv)?
> 
> Hi Joern,
> 
> The resolutions are only 640x480 and 320x240. The images are transfered
> in YUYV (16 bits YUV 4:2:2).
> 
> Regards.
> 

