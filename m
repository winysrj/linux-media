Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:41789 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753823AbZKWUkl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Nov 2009 15:40:41 -0500
Date: Mon, 23 Nov 2009 21:40:35 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kai Tiwisina <kai_tiwisina@gmx.de>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>
Subject: Re: image capture with ov9655 camera and intel pxa270C5C520
In-Reply-To: <20091123183928.206900@gmx.net>
Message-ID: <Pine.LNX.4.64.0911232131590.4207@axis700.grange>
References: <20091123183928.206900@gmx.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kai

On Mon, 23 Nov 2009, Kai Tiwisina wrote:

> Hello,
> 
> my name is Kai Tiwisina and i'm a student in germany and i'm trying to 
> communicate with a Omnivision ov9655 camera which is atteched with my 
> embedded linux system via the v4l commands.
> 
> I've written a small testprogram which should grow step by step while i'm 
> trying one ioctl after another.
> Everything worked fine until i tried to use the VIDIOC_S_FMT ioctl. It's 
> always giving me an "invalid argument" failure and i don't know why.

Since you don't seem to have the source of the driver at hand, I'd suggest 
to use the VIDIOC_ENUM_FMT http://v4l2spec.bytesex.org/spec/r8367.htm 
ioctl to enumerate all pixel formats supported be the driver. If the 
driver you're using is the same, that Stefan (cc'ed) has submitted to the 
list, then indeed it does not support the V4L2_PIX_FMT_RGB555 format, that 
you're requesting, only various YUV (and a Bayer?) formats.

> Perhaps someone of you is able to help me with this ioctl and give an 
> advice for a simple flow chart for a single frame image capture. Which 
> ioctl steps are neccessary and where do i need loops and for what, because 
> the capture-example.c from bytesex.org is way too general for my purpose.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
