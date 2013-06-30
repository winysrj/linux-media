Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46223 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392Ab3F3Uzj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Jun 2013 16:55:39 -0400
Date: Sun, 30 Jun 2013 17:55:24 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	linux-media <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: Question: interaction between selection API, ENUM_FRAMESIZES
 and S_FMT?
Message-ID: <20130630175524.0b3fda91@infradead.org>
In-Reply-To: <51D09507.80501@gmail.com>
References: <201306241448.15187.hverkuil@xs4all.nl>
	<51D09507.80501@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 30 Jun 2013 22:28:55 +0200
Sylwester Nawrocki <sylvester.nawrocki@gmail.com> escreveu:

> Hi Hans,
> 
> On 06/24/2013 02:48 PM, Hans Verkuil wrote:
> > Hi all,
> >
> > While working on extending v4l2-compliance with cropping/selection test cases
> > I decided to add support for that to vivi as well (this would give applications
> > a good test driver to work with).
> >
> > However, I ran into problems how this should be implemented for V4L2 devices
> > (we are not talking about complex media controller devices where the video
> > pipelines are setup manually).
> >
> > There are two problems, one related to ENUM_FRAMESIZES and one to S_FMT.
> >
> > The ENUM_FRAMESIZES issue is simple: if you have a sensor that has several
> > possible frame sizes, and that can crop, compose and/or scale, then you need
> > to be able to set the frame size. Currently this is decided by S_FMT which
> > maps the format size to the closest valid frame size. This however makes
> > it impossible to e.g. scale up a frame, or compose the image into a larger
> > buffer.
> >
> > For video receivers this issue doesn't exist: there the size of the incoming
> > video is decided by S_STD or S_DV_TIMINGS, but no equivalent exists for sensors.
> >
> > I propose that a new selection target is added: V4L2_SEL_TGT_FRAMESIZE.
> 
> V4L2_SEL_TGT_FRAMESIZE seems a bit imprecise to me, perhaps:
> V4L2_SEL_TGT_SENSOR(_SIZE) or V4L2_SEL_TGT_SOURCE(_SIZE) ? The latter might
> be a bit weird when referred to the subdev API though, not sure if defining
> it as valid only on V4L2 device nodes makes any difference.

Both name proposals seem weird and confuse.

If the issue is only to do scale up, then why not create a VIDIOC_S_SCALEUP
ioctl (or something similar), when we start having any real case where this
is needed. Please, let's not overbloat the API just due to vivi driver issues.

In the specific case of vivi, I can't see why you would need something like
that for crop/selection: it should just assume that the S_FMT represents the
full frame, and crop/selection will apply on it.

Btw, I can't remember a single (non-embedded) capture device that can do
scaleup. On embedded devices, this is probably already solved by a mem2mem
driver or via the media controller API.

Ok, for output devices this could be more common.

Do you have any real case where this feature is needed?

Regards,
Mauro
