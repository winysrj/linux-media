Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcdn-iport-2.cisco.com ([173.37.86.73]:21028 "EHLO
	rcdn-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752996Ab3GDLhk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Jul 2013 07:37:40 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: Question: interaction between selection API, ENUM_FRAMESIZES and S_FMT?
Date: Thu, 4 Jul 2013 13:27:58 +0200
Cc: "linux-media" <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <201306241448.15187.hverkuil@xs4all.nl> <201306251102.51514.hverkuil@xs4all.nl> <20130703223746.GP2064@valkosipuli.retiisi.org.uk>
In-Reply-To: <20130703223746.GP2064@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201307041327.58820.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu 4 July 2013 00:37:46 Sakari Ailus wrote:
> Hi Hans,
> 
> On Tue, Jun 25, 2013 at 11:02:51AM +0200, Hans Verkuil wrote:
> > On Tue 25 June 2013 10:21:19 Sakari Ailus wrote:
> > > Hi Hans,
> > > 
> > > On Mon, Jun 24, 2013 at 02:48:15PM +0200, Hans Verkuil wrote:
> > > > Hi all,
> > > > 
> > > > While working on extending v4l2-compliance with cropping/selection test cases
> > > > I decided to add support for that to vivi as well (this would give applications
> > > > a good test driver to work with).
> > > > 
> > > > However, I ran into problems how this should be implemented for V4L2 devices
> > > > (we are not talking about complex media controller devices where the video
> > > > pipelines are setup manually).
> > > > 
> > > > There are two problems, one related to ENUM_FRAMESIZES and one to S_FMT.
> > > > 
> > > > The ENUM_FRAMESIZES issue is simple: if you have a sensor that has several
> > > > possible frame sizes, and that can crop, compose and/or scale, then you need
> > > > to be able to set the frame size. Currently this is decided by S_FMT which
> > > 
> > > Sensors have a single "frame size". Other sizes are achieved by using
> > > cropping and scaling (or binning) from the native pixel array size. The
> > > drivers should probably also expose these properties rather than advertise
> > > multiple frame sizes.
> > 
> > The problem is that from the point of view of a generic application you really
> > don't want to know about that. You have a number of possible framesizes and you
> > just want to pick one.
> > 
> > Also, the hardware may hide how each framesize was achieved and in the case of
> > vivi or mem2mem devices things are even murkier.
> > 
> > > > maps the format size to the closest valid frame size. This however makes
> > > > it impossible to e.g. scale up a frame, or compose the image into a larger
> > > > buffer.
> > > > 
> > > > For video receivers this issue doesn't exist: there the size of the incoming
> > > > video is decided by S_STD or S_DV_TIMINGS, but no equivalent exists for sensors.
> > > > 
> > > > I propose that a new selection target is added: V4L2_SEL_TGT_FRAMESIZE.
> > > 
> > > The smiapp (well, subdev) driver uses V4L2_SEL_TGT_CROP_BOUNDS rectangle for
> > > this purpose. It was agreed to use that instead of creating a separate
> > > "pixel array size" rectangle back then. Could it be used for the same
> > > purpose on video nodes, too? If not, then smiapp should also be switched to
> > > use the new "frame size" rectangle.
> > 
> > The problem with CROP_BOUNDS is that it may be larger than the actual framesize,
> > as it can include blanking (for video) or the additional border pixels in a
> > sensor.
> 
> I don't think it should include anything else than just the image.
> 
> Blanking isn't valid image data, and I'd also leave any possible borders
> out: this is hardly interesting to the user, nor is really part of the image.
> That's what the user expects, right? The rest can't be meaningfully
> processed in anyway by hardware blocks, which would mix badly with
> configuring the pipeline from the user space.

It's not so easy: I'm pretty sure bttv allows messing with the blanking area,
and in the case of analog it can be useful in case of misalignment of syncs.

The question is: does anyone actually still use it like that?

> A lower level mechanism is needed: frame descriptors.
> 
> > I would prefer a new selection target for this.
> 
> It was decided to use the crop bounds for the purpose a few years back, and
> I don't see a need to change it. (I actually was for having such a rectangle
> back then, but the rough concensus was different. :))
> 
> 

Regards,

	Hans
