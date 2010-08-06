Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:50754 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1761974Ab0HFUVk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 Aug 2010 16:21:40 -0400
Date: Fri, 6 Aug 2010 22:21:36 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH/RFC] V4L2: add a generic function to find the nearest
 discrete format
In-Reply-To: <201008061525.30646.laurent.pinchart@ideasonboard.com>
Message-ID: <Pine.LNX.4.64.1008062207470.18408@axis700.grange>
References: <Pine.LNX.4.64.1008051959330.26127@axis700.grange>
 <201008061525.30646.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 6 Aug 2010, Laurent Pinchart wrote:

> Hi Guennadi,
> 
> On Thursday 05 August 2010 20:03:46 Guennadi Liakhovetski wrote:
> > Many video drivers implement a discrete set of frame formats and thus face
> > a task of finding the best match for a user-requested format. Implementing
> > this in a generic function has also an advantage, that different drivers
> > with similar supported format sets will select the same format for the
> > user, which improves consistency across drivers.
> > 
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > ---
> > 
> > I'm currently away from my hardware, so, this is only compile tested and
> > run-time tested with a test application. In any case, reviews and
> > suggestions welcome.
> > 
> >  drivers/media/video/v4l2-common.c |   26 ++++++++++++++++++++++++++
> >  include/linux/videodev2.h         |   10 ++++++++++
> >  2 files changed, 36 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/media/video/v4l2-common.c
> > b/drivers/media/video/v4l2-common.c index 4e53b0b..90727e6 100644
> > --- a/drivers/media/video/v4l2-common.c
> > +++ b/drivers/media/video/v4l2-common.c
> > @@ -1144,3 +1144,29 @@ int v4l_fill_dv_preset_info(u32 preset, struct
> > v4l2_dv_enum_preset *info) return 0;
> >  }
> >  EXPORT_SYMBOL_GPL(v4l_fill_dv_preset_info);
> > +
> > +struct v4l2_frmsize_discrete *v4l2_find_nearest_format(struct
> > v4l2_discrete_probe *probe, +						       s32 width, s32 height)
> > +{
> > +	int i;
> > +	u32 error, min_error = ~0;
> > +	struct v4l2_frmsize_discrete *size, *best = NULL;
> > +
> > +	if (!probe)
> > +		return best;
> > +
> > +	for (i = 0, size = probe->sizes; i < probe->num_sizes; i++, size++) {
> > +		if (probe->probe && !probe->probe(probe))
> 
> What's this call for ?

Well, atm, I don't think I have a specific case right now, but I think, it 
can well be the case, that not all frame sizes are always usable in the 
driver, depending on other circumstances. E.g., depending on the pixel / 
fourcc code. So, in this case the driver just provides a probe method to 
filter out inapplicable sizes.

Thanks
Guennadi

> 
> > +			continue;
> > +		error = abs(size->width - width) + abs(size->height - height);
> > +		if (error < min_error) {
> > +			min_error = error;
> > +			best = size;
> > +		}
> > +		if (!error)
> > +			break;
> > +	}
> > +
> > +	return best;
> > +}
> > +EXPORT_SYMBOL_GPL(v4l2_find_nearest_format);
> > diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> > index 047f7e6..f622bba 100644
> > --- a/include/linux/videodev2.h
> > +++ b/include/linux/videodev2.h
> > @@ -394,6 +394,16 @@ struct v4l2_frmsize_discrete {
> >  	__u32			height;		/* Frame height [pixel] */
> >  };
> > 
> > +struct v4l2_discrete_probe {
> > +	struct v4l2_frmsize_discrete	*sizes;
> > +	int				num_sizes;
> > +	void				*priv;
> > +	bool				(*probe)(struct v4l2_discrete_probe *);
> > +};
> > +
> > +struct v4l2_frmsize_discrete *v4l2_find_nearest_format(struct
> > v4l2_discrete_probe *probe, +						       s32 width, s32 height);
> > +
> >  struct v4l2_frmsize_stepwise {
> >  	__u32			min_width;	/* Minimum frame width [pixel] */
> >  	__u32			max_width;	/* Maximum frame width [pixel] */
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
