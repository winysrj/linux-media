Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp23.services.sfr.fr ([93.17.128.22]:61704 "EHLO
	smtp23.services.sfr.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163Ab0HGJrc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Aug 2010 05:47:32 -0400
Received: from filter.sfr.fr (localhost [127.0.0.1])
	by msfrf2316.sfr.fr (SMTP Server) with ESMTP id A11027000090
	for <linux-media@vger.kernel.org>; Sat,  7 Aug 2010 11:47:30 +0200 (CEST)
Received: from smtp-in.softsystem.co.uk (81.148.200-77.rev.gaoland.net [77.200.148.81])
	by msfrf2316.sfr.fr (SMTP Server) with SMTP id 50A71700008D
	for <linux-media@vger.kernel.org>; Sat,  7 Aug 2010 11:47:30 +0200 (CEST)
Received: FROM [192.168.1.62] (gagarin [192.168.1.62])
	BY smtp-in.softsystem.co.uk [77.200.148.81] (SoftMail 1.0.5, www.softsystem.co.uk) WITH ESMTP
	FOR <linux-media@vger.kernel.org>; Sat, 07 Aug 2010 11:47:27 +0200
Subject: Re: [PATCH/RFC] V4L2: add a generic function to find the nearest
 discrete format
From: lawrence rust <lawrence@softsystem.co.uk>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
In-Reply-To: <Pine.LNX.4.64.1008062207470.18408@axis700.grange>
References: <Pine.LNX.4.64.1008051959330.26127@axis700.grange>
	 <201008061525.30646.laurent.pinchart@ideasonboard.com>
	 <Pine.LNX.4.64.1008062207470.18408@axis700.grange>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 07 Aug 2010 11:47:26 +0200
Message-ID: <1281174446.1363.104.camel@gagarin>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2010-08-06 at 22:21 +0200, Guennadi Liakhovetski wrote:
> On Fri, 6 Aug 2010, Laurent Pinchart wrote:
> 
> > Hi Guennadi,
> > 
> > On Thursday 05 August 2010 20:03:46 Guennadi Liakhovetski wrote:
> > > Many video drivers implement a discrete set of frame formats and thus face
> > > a task of finding the best match for a user-requested format. Implementing
> > > this in a generic function has also an advantage, that different drivers
> > > with similar supported format sets will select the same format for the
> > > user, which improves consistency across drivers.
> > > 
> > > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > > ---
> > > 
> > > I'm currently away from my hardware, so, this is only compile tested and
> > > run-time tested with a test application. In any case, reviews and
> > > suggestions welcome.
> > > 
> > >  drivers/media/video/v4l2-common.c |   26 ++++++++++++++++++++++++++
> > >  include/linux/videodev2.h         |   10 ++++++++++
> > >  2 files changed, 36 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/drivers/media/video/v4l2-common.c
> > > b/drivers/media/video/v4l2-common.c index 4e53b0b..90727e6 100644
> > > --- a/drivers/media/video/v4l2-common.c
> > > +++ b/drivers/media/video/v4l2-common.c
> > > @@ -1144,3 +1144,29 @@ int v4l_fill_dv_preset_info(u32 preset, struct
> > > v4l2_dv_enum_preset *info) return 0;
> > >  }
> > >  EXPORT_SYMBOL_GPL(v4l_fill_dv_preset_info);
> > > +
> > > +struct v4l2_frmsize_discrete *v4l2_find_nearest_format(struct
> > > v4l2_discrete_probe *probe, +						       s32 width, s32 height)
> > > +{
> > > +	int i;
> > > +	u32 error, min_error = ~0;
> > > +	struct v4l2_frmsize_discrete *size, *best = NULL;
> > > +
> > > +	if (!probe)
> > > +		return best;
> > > +
> > > +	for (i = 0, size = probe->sizes; i < probe->num_sizes; i++, size++) {
> > > +		if (probe->probe && !probe->probe(probe))
> > 
> > What's this call for ?
> 
> Well, atm, I don't think I have a specific case right now, but I think, it 
> can well be the case, that not all frame sizes are always usable in the 
> driver, depending on other circumstances. E.g., depending on the pixel / 
> fourcc code. So, in this case the driver just provides a probe method to 
> filter out inapplicable sizes.

To be useful as a filter callback function the arguments need to include
either the current size or the index i.e.

		if (probe->probe && !probe->probe(probe->priv, size))

Maybe renaming probe->probe to probe->filter would give more idea of
functionality.

> Thanks
> Guennadi
> 
> > 
> > > +			continue;
> > > +		error = abs(size->width - width) + abs(size->height - height);

In c99, abs is declared:
int abs( int);

but you are passing in the difference of a __u32 and a s32, which is a
s32, which may or may not fit an int.  To accommodate all architectures
I think this might be better:

	#include <limits.h>
	...
	long error, min_error = LONG_MAX;
	...
		error = labs( (long)size->width - (long)width) + labs( (long)size->height - (long)height);

Since long is guaranteed to be at least 31 bits + sign.

A mean squared error metric such as hypot() could be better but requires
FP.  An integer only version wouldn't be too difficult.

> > > +		if (error < min_error) {
> > > +			min_error = error;
> > > +			best = size;
> > > +		}
> > > +		if (!error)
> > > +			break;
> > > +	}
> > > +
> > > +	return best;
> > > +}
> > > +EXPORT_SYMBOL_GPL(v4l2_find_nearest_format);
> > > diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> > > index 047f7e6..f622bba 100644
> > > --- a/include/linux/videodev2.h
> > > +++ b/include/linux/videodev2.h
> > > @@ -394,6 +394,16 @@ struct v4l2_frmsize_discrete {
> > >  	__u32			height;		/* Frame height [pixel] */
> > >  };
> > > 
> > > +struct v4l2_discrete_probe {
> > > +	struct v4l2_frmsize_discrete	*sizes;

This gives the compiler more scope for optimising:

	const struct v4l2_frmsize_discrete *sizes;

> > > +	int				num_sizes;
> > > +	void				*priv;
> > > +	bool				(*probe)(struct v4l2_discrete_probe *);

Re. comment about the filter callback above, this becomes:

	int				(*filter)( void*, const struct v4l2_frmsize_discrete*);

IMHO an int return is preferred since it is ANSI c89, whereas _Bool is
c99 and bool is c++/gnuc.

> > > +};
> > > +
> > > +struct v4l2_frmsize_discrete *v4l2_find_nearest_format(struct
> > > v4l2_discrete_probe *probe, +						       s32 width, s32 height);
> > > +
> > >  struct v4l2_frmsize_stepwise {
> > >  	__u32			min_width;	/* Minimum frame width [pixel] */
> > >  	__u32			max_width;	/* Maximum frame width [pixel] */
> > 
> > -- 
> > Regards,
> > 
> > Laurent Pinchart
> > 
> 
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/

-- Lawrence Rust


