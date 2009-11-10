Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:42003 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756446AbZKJOgd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Nov 2009 09:36:33 -0500
Date: Tue, 10 Nov 2009 15:36:49 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: "Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: [PATCH/RFC 9/9 v2] mt9t031: make the use of the soc-camera client
 API optional
In-Reply-To: <200911101454.14124.laurent.pinchart@ideasonboard.com>
Message-ID: <Pine.LNX.4.64.0911101529450.5074@axis700.grange>
References: <Pine.LNX.4.64.0910301338140.4378@axis700.grange>
 <Pine.LNX.4.64.0911051753540.5620@axis700.grange>
 <A69FA2915331DC488A831521EAE36FE4015583406A@dlee06.ent.ti.com>
 <200911101454.14124.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 10 Nov 2009, Laurent Pinchart wrote:

> Hi Guennadi,
> 
> On Thursday 05 November 2009 18:07:09 Karicheri, Muralidharan wrote:
> > Guennadi,
> > 
> > >> in the v4l2_queryctrl struct.
> > >
> > >I think, this is unrelated. Muralidharan just complained about the
> > >soc_camera_find_qctrl() function being used in client subdev drivers, that
> > >were to be converted to v4l2-subdev, specifically, in mt9t031.c. And I
> > >just explained, that that's just a pretty trivial library function, that
> > >does not introduce any restrictions on how that subdev driver can be used
> > >in non-soc-camera configurations, apart from the need to build and load
> > >the soc-camera module. In other words, any v4l2-device bridge driver
> > >should be able to communicate with such a subdev driver, calling that
> > >function.
> > 
> > If soc_camera_find_qctrl() is such a generic function, why don't you
> > move it to v4l2-common.c so that other platforms doesn't have to build
> > SOC camera sub system to use this function? Your statement reinforce
> > this.
> 
> I second this. Hans is working on a controls framework that should (hopefully 
> :-)) make drivers simpler by handling common tasks in the v4l core.

Well, if you look at the function itself and at how it got replaced in 
this version of the patch by O(1) operations, you'll, probably, agree, 
that avoiding that function where possible is better than making it 
generic. But if there are any legitimate users for it - sure, can make it 
generic too.

> Do you have any plan to work on the bus hardware configuration API ? When that 
> will be available the mt9t031 driver could be made completely soc-camera-free.

I'd love to first push the proposed image-bus upstream. Even with just 
that many drivers can already be re-used. As for bus configuration, I 
thought there were enough people working on it already:-) If not, maybe I 
could have a look at it, but we better reach some agreement on that 
beforehand to avoid duplicating the effort.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
