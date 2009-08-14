Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:51722 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932745AbZHNUCw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Aug 2009 16:02:52 -0400
Date: Fri, 14 Aug 2009 22:02:52 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Stefan Welker <swelker@informatik.uni-freiburg.de>
cc: Robert Jarzmik <robert.jarzmik@free.fr>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: pxa_camera / mt9m111
In-Reply-To: <c751214a0908140402j1ae4aea2y5b4874f42c8a3bff@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0908142200380.5980@axis700.grange>
References: <c751214a0908140402j1ae4aea2y5b4874f42c8a3bff@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(adding linux-media to the CC)

On Fri, 14 Aug 2009, Stefan Welker wrote:

> Hi there,
> 
> Im working with the  camera on the A780 Motorola mobile phone which
> uses the pxa_camera module to run  micron mt9m111 chip. In the chip
> documentation there is stated that it is possible to run the chip with
> Low-power mode (640 x 512) at 54 Mhz with a framerate of 30 hz.  Right
> now the Master clock is Limited by some Lines of code in pxa_camera to
> 26 Mhz which is lcdclk / 4  then a divisor is calculated which is in
> this case 1 .
> Im wondering if it is possible at all to get the 30 hz images (Im
> trying to do real time image processing with this camera , thus the
> latency would benefit a lot from a faster framerate. )  from the chip.
> 
> I already tried to set the mclk to 54 Mhz or 52 Mhz which calculates
> the divisor as 0 (dont know if that makes sense)
> but it gets the images at 30 hz then, unfortunately theres something
> wrong as the images get skewed, and also the U/V data somehow gets
> mixed up or something since there are now green stripes in the image.
> 
> Do you think there is a hardware limit that prevents the system from
> reading out the camera at 54 Mhz
> (or at least 52 Mhz) which would be lcdclk/2

The comment in the driver in mclk_get_divisor() says

	/* mclk <= ciclk / 4 (27.4.2) */

have you had a look at the datasheet section 27.4.2? Please look at it, 
then feel free to ask again on the mailing list, if you still have any 
questions.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
