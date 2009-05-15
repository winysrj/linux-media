Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:56294 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753198AbZEOTG0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 May 2009 15:06:26 -0400
Date: Fri, 15 May 2009 21:06:40 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@skynet.be>
cc: Guillaume <Kowaio@gmail.com>, linux-media@vger.kernel.org
Subject: Re: V4L2 - Capturing uncompressed data
In-Reply-To: <200905151520.26540.laurent.pinchart@skynet.be>
Message-ID: <Pine.LNX.4.64.0905152101380.4658@axis700.grange>
References: <loom.20090515T125828-924@post.gmane.org>
 <200905151520.26540.laurent.pinchart@skynet.be>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 15 May 2009, Laurent Pinchart wrote:

> Hi Guillaume,
> 
> On Friday 15 May 2009 15:03:11 Guillaume wrote:

[snip]

> > My problem is, after the VIDIOC_S_FMT, the pixelformat field is set back to
> > JPEG FORMAT (and the colorspace too) and so, I don't get raw data, but
> > compressed jpeg data.
> >
> > I know that the VIDIOC_S_FMT try to change these fields but if the driver
> > don't authorise them, it will put the originals back.
> >
> > But, I really need to get the uncompressed data of the captured picture,
> > so is there by any chance, another solution to 'force' and capture the
> > images in an Uncompressed format ? Or is it really set by the driver and so,
> > no chance to have the raw ?
> 
> It depends on the camera.

...and the driver. I don't know much about various _web_cameras and their 
drivers, but I could well imagine, that you're asking for an unsupported 
YUV variation, whereas some other format would be supported. Why don't you 
use VIDIOC_ENUM_FMT to list all supported formats? Or even look in the 
driver source - it's open:-)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
