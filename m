Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:55259 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331AbZI1Vwl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Sep 2009 17:52:41 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Stefan.Kost@nokia.com
Subject: Re: [RFC] Global video buffers pool
Date: Mon, 28 Sep 2009 23:54:25 +0200
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	sakari.ailus@maxwell.research.nokia.com, david.cohen@nokia.com,
	antti.koskipaa@nokia.com, vimarsh.zutshi@nokia.com
References: <200909161746.39754.laurent.pinchart@ideasonboard.com> <D019E777779A4345963526A1797F28D409E78C5B57@NOK-EUMSG-02.mgdnok.nokia.com>
In-Reply-To: <D019E777779A4345963526A1797F28D409E78C5B57@NOK-EUMSG-02.mgdnok.nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909282354.25563.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Stefan,

On Monday 28 September 2009 16:04:58 Stefan.Kost@nokia.com wrote:
> hi,
> 
> >-----Original Message-----
> >From: ext Laurent Pinchart [mailto:laurent.pinchart@ideasonboard.com]
> >Sent: 16 September, 2009 18:47
> >To: linux-media@vger.kernel.org; Hans Verkuil; Sakari Ailus;
> >Cohen David.A (Nokia-D/Helsinki); Koskipaa Antti
> >(Nokia-D/Helsinki); Zutshi Vimarsh (Nokia-D/Helsinki); Kost
> >Stefan (Nokia-D/Helsinki)
> >Subject: [RFC] Global video buffers pool
> >
> > Hi everybody,
> >
> > I didn't want to miss this year's pretty flourishing RFC
> > season, so here's another one about a global video buffers pool.
> 
> Sorry for ther very late reply.

No worries, better late than never.

> I have been thinking about the problem on a bit broader scale and see the
> need for something more kernel wide. E.g. there is some work done from intel
> for graphics:
> http://keithp.com/blogs/gem_update/
> 
> and this is not so much embedded even. If there buffer pools are
> v4l2specific then we need to make all those other subsystems like xvideo,
> opengl, dsp-bridges become v4l2 media controllers.

The global video buffers pool topic has been discussed during the v4l2 mini-
summit at Portland last week, and we all agreed that it needs more research.

The idea of having pools at the media controller level has been dropped in 
favor of a kernel-wide video buffers pool. Whether we can make the buffers 
pool not v4l2-specific still needs to be tested. As you have pointed out, we 
currently have a GPU memory manager in the kernel, and being able to interact 
with it would be very interesting if we want to DMA video data to OpenGL 
texture buffers for instance. I'm not sure if that would be possible though, 
as the GPU and the video acquisition hardware might have different memory 
requirements, at least in the general case. I will contact the GEM guys at 
Intel to discuss the topic.

If we can't share the buffers between the GPU and the rest of the system, we 
could at least create a V4L2 wrapper on top of the DSP bridge core (which will 
require a major cleanup/restructuring), making it possible to share video 
buffers between the ISP and the DSP.

-- 
Regards,

Laurent Pinchart
