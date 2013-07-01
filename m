Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-3.cisco.com ([144.254.224.146]:64136 "EHLO
	ams-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942Ab3GAM5M (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Jul 2013 08:57:12 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: Question: interaction between selection API, ENUM_FRAMESIZES and S_FMT?
Date: Mon, 1 Jul 2013 14:56:58 +0200
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	"linux-media" <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <201306241448.15187.hverkuil@xs4all.nl> <51D09507.80501@gmail.com> <20130630175524.0b3fda91@infradead.org>
In-Reply-To: <20130630175524.0b3fda91@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201307011456.58788.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun 30 June 2013 22:55:24 Mauro Carvalho Chehab wrote:
> Em Sun, 30 Jun 2013 22:28:55 +0200
> Sylwester Nawrocki <sylvester.nawrocki@gmail.com> escreveu:
> 
> > Hi Hans,
> > 
> > On 06/24/2013 02:48 PM, Hans Verkuil wrote:
> > > Hi all,
> > >
> > > While working on extending v4l2-compliance with cropping/selection test cases
> > > I decided to add support for that to vivi as well (this would give applications
> > > a good test driver to work with).
> > >
> > > However, I ran into problems how this should be implemented for V4L2 devices
> > > (we are not talking about complex media controller devices where the video
> > > pipelines are setup manually).
> > >
> > > There are two problems, one related to ENUM_FRAMESIZES and one to S_FMT.
> > >
> > > The ENUM_FRAMESIZES issue is simple: if you have a sensor that has several
> > > possible frame sizes, and that can crop, compose and/or scale, then you need
> > > to be able to set the frame size. Currently this is decided by S_FMT which
> > > maps the format size to the closest valid frame size. This however makes
> > > it impossible to e.g. scale up a frame, or compose the image into a larger
> > > buffer.
> > >
> > > For video receivers this issue doesn't exist: there the size of the incoming
> > > video is decided by S_STD or S_DV_TIMINGS, but no equivalent exists for sensors.
> > >
> > > I propose that a new selection target is added: V4L2_SEL_TGT_FRAMESIZE.
> > 
> > V4L2_SEL_TGT_FRAMESIZE seems a bit imprecise to me, perhaps:
> > V4L2_SEL_TGT_SENSOR(_SIZE) or V4L2_SEL_TGT_SOURCE(_SIZE) ? The latter might
> > be a bit weird when referred to the subdev API though, not sure if defining
> > it as valid only on V4L2 device nodes makes any difference.
> 
> Both name proposals seem weird and confuse.
> 
> If the issue is only to do scale up, then why not create a VIDIOC_S_SCALEUP
> ioctl (or something similar), when we start having any real case where this
> is needed. Please, let's not overbloat the API just due to vivi driver issues.

It has nothing to do with vivi, that's just an example. I'm trying to write
tests for v4l2-compliance for S_SELECTION (both cropping and composing), and
to test that I want to use vivi since that would make a nice enhancement for
it. And the bottom line it, what the behavior should be when you combine
cropping, composing and optionally scaling is just undefined. Part of the reason
is that for drivers supporting ENUM_FRAMESIZES you need a way to tell the
driver which frame size should be used.

> In the specific case of vivi, I can't see why you would need something like
> that for crop/selection: it should just assume that the S_FMT represents the
> full frame, and crop/selection will apply on it.

OK, say I call S_FMT with 800x600 for vivi. That selects the 800x600 format.
Now I set the crop to a 400x300 rectangle at 100x100. Now what should happen?
Should it scale 400x300 up to 800x600? But vivi doesn't support scaling, so
should it modify the format to 400x300 instead? But what is S_FMT is called
again with that new 400x300 format? That would suddenly select a 400x300 frame.

Or should it compose the 400x300 rectangle into the 800x600 format? But
that's not allowed by the spec (or supported by any of todays applications).

Note that this issue is not vivi specific, it's true for any driver supporting
ENUM_FRAMESIZES that want to support cropping, composing and/or scaling. This
includes sensors (and I believe some of the soc-camera drivers can do upscaling
as well), codecs and virtual drivers like vivi.

> Btw, I can't remember a single (non-embedded) capture device that can do
> scaleup. On embedded devices, this is probably already solved by a mem2mem
> driver

mem2mem doesn't solve this.

> or via the media controller API.

This discussion only applies to drivers that use the V4L2 API (i.e. have the
capture or output capabilities set), not if you have to setup the pipeline
using the subdev API. In the case of the subdev API if you are dealing with a
pad that enumerates framesizes, then SUBDEV_S_FMT will indeed select which
framesize you are going to use, but in that case there cannot be any scaling,
cropping or composing between the sensor and the source pad (i.e. pad going
out of the sensor with the image data). If the sensor has a scaler, then that
becomes a separate subdev (Laurent, Sylwester, I hope I got that right).

In the V4L2 API you do not have that luxury.

Today you simply cannot use composing at all for devices with ENUM_FRAMESIZES,
and crop only if there is a scaler, or if the crop width/height is identical
to the capture format.

If we all decide that that is a limitation we can accept, then that's fine.
Then v4l2-compliance will verify that the driver implements that correctly.

But it seems very inconsistent behavior to me. All you need is a way to select
one of the possible frame sizes to fix it.

> 
> Ok, for output devices this could be more common.
> 
> Do you have any real case where this feature is needed?

There are no drivers at this moment where this is an issue, except perhaps
soc_camera to some extent, but I think that although soc_camera attempts to
support compose, none of the actual soc_camera drivers supports it.

But I do need to know what we are going to do for the v4l2-compliance checks.
Right now it is extremely fuzzy how enum_framesizes, s_crop, s_selection and
s_fmt are supposed to work together. And that makes it hard to write tests.

Regards,

	Hans

PS: this discussion works much better in person with a nice whiteboard to
draw on!
