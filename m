Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:49329 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750958AbZIMTNT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Sep 2009 15:13:19 -0400
Date: Sun, 13 Sep 2009 21:13:32 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Marek Vasut <marek.vasut@gmail.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/3] Add driver for OmniVision OV9640 sensor
In-Reply-To: <200909131843.18007.marek.vasut@gmail.com>
Message-ID: <Pine.LNX.4.64.0909132030530.9668@axis700.grange>
References: <200908220850.07435.marek.vasut@gmail.com>
 <200909042225.59000.marek.vasut@gmail.com> <Pine.LNX.4.64.0909102330070.4458@axis700.grange>
 <200909131843.18007.marek.vasut@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 13 Sep 2009, Marek Vasut wrote:

> Dne Pá 11. září 2009 23:51:44 Guennadi Liakhovetski napsal(a):
> > 
> > Ok, a couple more simple questions / remarks, In principle, there's just
> > one principle objection - if we agree, that the correct format is BGR565
> > and RGB565X, then we should change that. There's no BGR565 format
> > currently in the kernel, so, we'd have to add it (and the documentation
> > for the mercurial tree).
> 
> I dont think I understand you at all.

Your patch used RGB565X, which is the same as RGB565 but with _bytes_ 
swapped, whereas earlier you confirmed, that it's not a byte-swapped 
RGB565 but rather R and B _colours_ are swapped:

http://marc.info/?l=linux-arm-kernel&m=125220918005429&w=2

, i.e., it is a BGR565. Now it looks like you don't change anything in 
your RGB processing code, but you declare it as plain RGB555 and RGB565 
codes. So, are these really the normal unswapped formats or am I missing 
something? And you replaced VYUY with UYVY while also modifying register 
configuration, so, I hope, this has settled now and your current 
configuration works properly with the unmodified pxa270 for you, right?

Oh, damn, I see now, I put my signature above the patch, so, you didn't 
look below it, and there were a couple more comments there:-( Sorry! All 
of them should be pretty easy to fix, so, please have a look at them.

> Inlined is a new version of the patch (I did some lookup through the datasheet). 
> I might not need the BGR formats for now.
> 
> btw. weren't you planning to merge the ov96xx drivers into .31? I havent seen 
> any of them there.

Which ov96xx drivers? Do you mean the ov9655 driver from Stefan 
Herbrechtsmeier? My doubt with the latter one was (and still is), that we 
already have two drivers in the mainline (gspca/sn9c20x.c and 
gspca/ov534.c) that seem to claim support for that chip, so, I wanted to 
see, if we could reuse them. There's also an ov7670 from Jonathan Cameron 
with the same issue. And for that merge we have to come closer to 
v4l2-subdev, which is happening just now.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
