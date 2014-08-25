Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:49579 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932172AbaHYLwz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Aug 2014 07:52:55 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de
Subject: Re: [RFC] [media] v4l2: add V4L2 pixel format array and helper functions
Date: Mon, 25 Aug 2014 13:53:36 +0200
Message-ID: <3446937.ynTUdOVVZH@avalon>
In-Reply-To: <53FB2045.1020504@xs4all.nl>
References: <1408962839-25165-1-git-send-email-p.zabel@pengutronix.de> <53FB2045.1020504@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 25 August 2014 13:38:45 Hans Verkuil wrote:
> Hi Philipp,
> 
> I have to think a bit more about the format names, but in the meantime I
> have two other suggestions:
> 
> On 08/25/2014 12:33 PM, Philipp Zabel wrote:
> > This patch adds an array of V4L2 pixel formats and descriptions that can
> > be used by drivers so that each driver doesn't have to provide its own
> > slightly different format descriptions for VIDIOC_ENUM_FMT.

I've started working on this recently as well, so I can only agree with the 
idea.

> > Each array entry also includes two bits per pixel values (for a single
> > line and one for the whole image) that can be used to determine the
> > v4l2_pix_format bytesperline and sizeimage values and whether the format
> > is planar or compressed.
> > 
> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > ---
> > I have started to convert some drivers on a boring train ride, but it
> > occurred to me that I probably should get some feedback before carrying
> > on with this:
> > http://git.pengutronix.de/?p=pza/linux.git;a=shortlog;h=refs/heads/topic/
> > media-pixfmt
> > ---
> > 
> >  drivers/media/v4l2-core/v4l2-common.c | 488 +++++++++++++++++++++++++++++
> >  include/media/v4l2-common.h           |  44 +++
> >  2 files changed, 532 insertions(+)
> > 
> > diff --git a/drivers/media/v4l2-core/v4l2-common.c
> > b/drivers/media/v4l2-core/v4l2-common.c index ccaa38f..41692df 100644
> > --- a/drivers/media/v4l2-core/v4l2-common.c
> > +++ b/drivers/media/v4l2-core/v4l2-common.c
> > @@ -533,3 +533,491 @@ void v4l2_get_timestamp(struct timeval *tv)
> > 
> >  	tv->tv_usec = ts.tv_nsec / NSEC_PER_USEC;
> >  
> >  }
> >  EXPORT_SYMBOL_GPL(v4l2_get_timestamp);
> > 
> > +
> > +static const struct v4l2_pixfmt v4l2_pixfmts[] = {
> 
> <snip>
> 
> > +};
> > +
> > +const struct v4l2_pixfmt *v4l2_pixfmt_by_fourcc(u32 fourcc)
> > +{
> > +	int i;
> > +
> > +	for (i = 0; i < ARRAY_SIZE(v4l2_pixfmts); i++) {
> > +		if (v4l2_pixfmts[i].pixelformat == fourcc)
> > +			return v4l2_pixfmts + i;
> > +	}
> > +
> > +	return NULL;
> > +}
> > +EXPORT_SYMBOL_GPL(v4l2_pixfmt_by_fourcc);
> > +
> > +int v4l2_fill_fmtdesc(struct v4l2_fmtdesc *f, u32 fourcc)
> > +{
> > +	const struct v4l2_pixfmt *fmt;
> > +
> > +	fmt = v4l2_pixfmt_by_fourcc(fourcc);
> > +	if (!fmt)
> > +		return -EINVAL;
> > +
> > +	strlcpy((char *)f->description, fmt->name, sizeof(f->description));
> > +	f->pixelformat = fmt->pixelformat;
> > +	f->flags = (fmt->bpp_image == 0) ? V4L2_FMT_FLAG_COMPRESSED : 0;
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(v4l2_fill_fmtdesc);
> > diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
> > index 48f9748..27b084f 100644
> > --- a/include/media/v4l2-common.h
> > +++ b/include/media/v4l2-common.h
> > @@ -204,4 +204,48 @@ const struct v4l2_frmsize_discrete
> > *v4l2_find_nearest_format(> 
> >  void v4l2_get_timestamp(struct timeval *tv);
> > 
> > +/**
> > + * struct v4l2_pixfmt - internal V4L2 pixel format description
> > + * @name: format description to be returned by enum_fmt
> > + * @pixelformat: v4l2 pixel format fourcc
> > + * @bpp_line: bits per pixel, averaged over a line (of the first plane
> > + *            for planar formats), used to calculate bytesperline
> > + *            Zero for compressed and macroblock tiled formats.
> > + * @bpp_image: bits per pixel, averaged over the whole image. This is
> > used to
> > + *             calculate sizeimage for uncompressed formats.
> > + *             Zero for compressed formats.
> 
> I would add a 'planes' field as well for use with formats that use
> non-contiguous planes.
> 
> > + */
> > +struct v4l2_pixfmt {
> > +	const char	*name;
> > +	u32		pixelformat;
> > +	u8		bpp_line;
> > +	u8		bpp_image;
> > +};
> > +
> > +const struct v4l2_pixfmt *v4l2_pixfmt_by_fourcc(u32 fourcc);
> > +int v4l2_fill_fmtdesc(struct v4l2_fmtdesc *f, u32 fourcc);
> > +
> > +static inline unsigned int v4l2_bytesperline(const struct v4l2_pixfmt
> > *fmt, +					     unsigned int width)
> > +{
> > +	return width * fmt->bpp_line / 8;
> 
> Round up: return (width * fmt->bpp_line + 7) / 8;

DIV_ROUND_UP(width * fmt->bpp_line, 8) ?

> > +}
> > +
> > +static inline unsigned int v4l2_sizeimage(const struct v4l2_pixfmt *fmt,
> > +					  unsigned int width,
> > +					  unsigned int height)
> > +{
> > +	return width * height * fmt->bpp_image / 8;
> 
> Ditto: return height * v4l2_bytesperline(fmt, width);
>
> > +}
> > +
> > +static inline bool v4l2_pixfmt_is_planar(const struct v4l2_pixfmt *fmt)
> > +{
> > +	return fmt->bpp_line && (fmt->bpp_line != fmt->bpp_image);
> > +}
> > +
> > +static inline bool v4l2_pixfmt_is_compressed(const struct v4l2_pixfmt
> > *fmt)
> > +{
> > +	return fmt->bpp_image == 0;
> > +}
> > +
> > 
> >  #endif /* V4L2_COMMON_H_ */

-- 
Regards,

Laurent Pinchart

