Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:51965 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211Ab1IAHPd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Sep 2011 03:15:33 -0400
Date: Thu, 1 Sep 2011 09:15:20 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sakari Ailus <sakari.ailus@iki.fi>
cc: Bastian Hecht <hechtb@googlemail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] media: Add camera controls for the ov5642 driver
In-Reply-To: <20110831212010.GS12368@valkosipuli.localdomain>
Message-ID: <Pine.LNX.4.64.1109010911550.21309@axis700.grange>
References: <alpine.DEB.2.02.1108171553540.17550@ipanema>
 <201108282006.09790.laurent.pinchart@ideasonboard.com>
 <CABYn4sx5jQPyLC4d6OfVbX5SSuS4TiNsB_LPoCheaOSbwM9Pzw@mail.gmail.com>
 <20110831212010.GS12368@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 1 Sep 2011, Sakari Ailus wrote:

> On Wed, Aug 31, 2011 at 03:27:49PM +0000, Bastian Hecht wrote:
> > 2011/8/28 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
> [clip]
> > > If I'm not mistaken V4L2_CID_PRIVATE_BASE is deprecated.
> > 
> > I checked at http://v4l2spec.bytesex.org/spec/x542.htm, googled
> > "V4L2_CID_PRIVATE_BASE deprecated" and read
> > Documentation/feature-removal-schedule.txt. I couldn't find anything.
> 
> Hmm. Did you happen to check when that has been written? :)
> 
> Please use this one instead:
> 
> <URL:http://hverkuil.home.xs4all.nl/spec/media.html>

"Drivers can also implement their own custom controls using 
V4L2_CID_PRIVATE_BASE and higher values."

Which specific location describes V4L2_CID_PRIVATE_BASE differently there?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
