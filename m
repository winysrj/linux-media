Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:38407 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbZKJNxb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Nov 2009 08:53:31 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
Subject: Re: [PATCH/RFC 9/9 v2] mt9t031: make the use of the soc-camera client API optional
Date: Tue, 10 Nov 2009 14:54:14 +0100
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
References: <Pine.LNX.4.64.0910301338140.4378@axis700.grange> <Pine.LNX.4.64.0911051753540.5620@axis700.grange> <A69FA2915331DC488A831521EAE36FE4015583406A@dlee06.ent.ti.com>
In-Reply-To: <A69FA2915331DC488A831521EAE36FE4015583406A@dlee06.ent.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911101454.14124.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Thursday 05 November 2009 18:07:09 Karicheri, Muralidharan wrote:
> Guennadi,
> 
> >> in the v4l2_queryctrl struct.
> >
> >I think, this is unrelated. Muralidharan just complained about the
> >soc_camera_find_qctrl() function being used in client subdev drivers, that
> >were to be converted to v4l2-subdev, specifically, in mt9t031.c. And I
> >just explained, that that's just a pretty trivial library function, that
> >does not introduce any restrictions on how that subdev driver can be used
> >in non-soc-camera configurations, apart from the need to build and load
> >the soc-camera module. In other words, any v4l2-device bridge driver
> >should be able to communicate with such a subdev driver, calling that
> >function.
> 
> If soc_camera_find_qctrl() is such a generic function, why don't you
> move it to v4l2-common.c so that other platforms doesn't have to build
> SOC camera sub system to use this function? Your statement reinforce
> this.

I second this. Hans is working on a controls framework that should (hopefully 
:-)) make drivers simpler by handling common tasks in the v4l core.

Do you have any plan to work on the bus hardware configuration API ? When that 
will be available the mt9t031 driver could be made completely soc-camera-free.

-- 
Regards,

Laurent Pinchart
