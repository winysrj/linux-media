Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:52839 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751623AbaLXM4r (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Dec 2014 07:56:47 -0500
Message-ID: <549AB806.5030109@xs4all.nl>
Date: Wed, 24 Dec 2014 13:56:38 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: sadegh abbasi <sadegh612000@yahoo.co.uk>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: Looking for a suitable framework for my driver
References: <262680468.1060510.1419425058997.JavaMail.yahoo@jws11159.mail.ir2.yahoo.com>
In-Reply-To: <262680468.1060510.1419425058997.JavaMail.yahoo@jws11159.mail.ir2.yahoo.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 12/24/2014 01:44 PM, sadegh abbasi wrote:
> Hello everybody,
> 
> I need to write a driver for a video-in device and need
> to choose the best framework for it. I think V4L2 can be used but would like to
> know if any more suitable framework exists. Also if there is an existing similar
> driver under linux that you are aware of please let me know. The idea is not to
> waste people's time with the wrong approach or wrong subsystem.
> Here is a brief description of the hardware capabilities:
> 1. It captures digital video input and writes it to memory after optional colour space conversion (CSC) and scaling. 
> 2. It supports DVI/HDMI inputs, providing 20/24/30/48-bit RGB/YCbCr, and running at up to 1600x1280x75Hz.
> 3. It supports  frame sizes up to UHD 4096x2304, interlaced and progressive video, and range of RGB and YCbCr formats
> for input and output.
> 4. Both packed and planar formats are supported. The supported output  formats are as follows.
> 
> 444 YUV101010; 422 UYVY10101010; PL12Y10/422PL12UV10; PL12Y10/420PL12UV10; PL12Y8/422PL12UV8; PL12Y8/420PL12UV8; RGB121212.5. The CSC is applied to the RGB input performing a 3x3 Matrix multiply with
> programmable coefficients and programmable input and output offsets.  It can also adjust brightness, contrast,
> saturation and hue.
> 6. It has its own MMU and DMA.
>  
> Any suggestions is highly appreciated.
> 

V4L2 is the right and only framework for this.

The vivid driver emulates an HDMI input, so that's not a bad place to start.

Another template to use is Documentation/video4linux/v4l2-pci-skeleton.c.

You might have to make some additions to the framework to support deep color
formats (nobody needed it until now), but that's trivial and we can help with
that.

There is also no support yet for programmable CSC coefficients, but work is in
progress for that.

Regards,

	Hans
