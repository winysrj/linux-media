Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:4218 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908Ab0HGOUH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Aug 2010 10:20:07 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH/RFC] V4L2: add a generic function to find the nearest discrete format
Date: Sat, 7 Aug 2010 16:19:59 +0200
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <Pine.LNX.4.64.1008051959330.26127@axis700.grange> <201008071106.30955.hverkuil@xs4all.nl> <Pine.LNX.4.64.1008071505410.3798@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1008071505410.3798@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008071619.59158.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 07 August 2010 15:12:13 Guennadi Liakhovetski wrote:
> On Sat, 7 Aug 2010, Hans Verkuil wrote:
> 
> > On Friday 06 August 2010 22:21:36 Guennadi Liakhovetski wrote:
> > > On Fri, 6 Aug 2010, Laurent Pinchart wrote:
> > > 
> > > > Hi Guennadi,
> > > > 
> > > > On Thursday 05 August 2010 20:03:46 Guennadi Liakhovetski wrote:
> > > > > Many video drivers implement a discrete set of frame formats and thus face
> > > > > a task of finding the best match for a user-requested format. Implementing
> > > > > this in a generic function has also an advantage, that different drivers
> > > > > with similar supported format sets will select the same format for the
> > > > > user, which improves consistency across drivers.
> > > > > 
> > > > > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > > > > ---
> > > > > 
> > > > > I'm currently away from my hardware, so, this is only compile tested and
> > > > > run-time tested with a test application. In any case, reviews and
> > > > > suggestions welcome.
> > > > > 
> > > > >  drivers/media/video/v4l2-common.c |   26 ++++++++++++++++++++++++++
> > > > >  include/linux/videodev2.h         |   10 ++++++++++
> > > > >  2 files changed, 36 insertions(+), 0 deletions(-)
> > > > > 
> > > > > diff --git a/drivers/media/video/v4l2-common.c
> > > > > b/drivers/media/video/v4l2-common.c index 4e53b0b..90727e6 100644
> > > > > --- a/drivers/media/video/v4l2-common.c
> > > > > +++ b/drivers/media/video/v4l2-common.c
> > > > > @@ -1144,3 +1144,29 @@ int v4l_fill_dv_preset_info(u32 preset, struct
> > > > > v4l2_dv_enum_preset *info) return 0;
> > > > >  }
> > > > >  EXPORT_SYMBOL_GPL(v4l_fill_dv_preset_info);
> > > > > +
> > > > > +struct v4l2_frmsize_discrete *v4l2_find_nearest_format(struct
> > > > > v4l2_discrete_probe *probe, +						       s32 width, s32 height)
> > > > > +{
> > > > > +	int i;
> > > > > +	u32 error, min_error = ~0;
> > > > > +	struct v4l2_frmsize_discrete *size, *best = NULL;
> > > > > +
> > > > > +	if (!probe)
> > > > > +		return best;
> > > > > +
> > > > > +	for (i = 0, size = probe->sizes; i < probe->num_sizes; i++, size++) {
> > > > > +		if (probe->probe && !probe->probe(probe))
> > > > 
> > > > What's this call for ?
> > > 
> > > Well, atm, I don't think I have a specific case right now, but I think, it 
> > > can well be the case, that not all frame sizes are always usable in the 
> > > driver, depending on other circumstances. E.g., depending on the pixel / 
> > > fourcc code. So, in this case the driver just provides a probe method to 
> > > filter out inapplicable sizes.
> > 
> > Never add code just because you think it might be needed in the future. Especially
> > not for kernel internal code that you can change anyway if needed.
> 
> Yes and no. If it's pretty obvious, that a certain extension is going to 
> be needed in the future, then it can be better to prepare for it, because 
> otherwise developers can start implementing (ugly custom) local 
> workarounds and extensions, before someone comes up with the idea to 
> extend the API, and then you have to convert all those special solutions. 
> Whereas if you prepare such an API, even if it is not perfect, people are 
> more likely to modify and fix it, than to extend an "established API."

The problem is with the phrase 'pretty obvious'. In my career as programmer
I've seen (and made!) that mistake way too often: 'pretty obvious' future
extensions turn out not to be so obvious after all and you are stuck with code
that is unused, unmaintained, likely to cause bit-rot and future generations
of programmers will have a difficult time figuring out why that code is there
in the first place.

This always looks like such a good idea but in the long run it is a really,
really bad idea.

Regards,

	Hans

> But if in this case noone says - yes, my driver will need to be able to 
> filter certain sizes out, we can as well drop this callback.
> 
> > In this case you just want to give a simple const array with width and height
> > pairs ending at 0, 0 or pass in the length of the array, whatever you prefer,
> > and return the array index for the closest match.
> > 
> > Keep it simple.
> 
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
