Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:49790 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754586AbaHYPM0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Aug 2014 11:12:26 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de
Subject: Re: [RFC] [media] v4l2: add V4L2 pixel format array and helper functions
Date: Mon, 25 Aug 2014 17:13:09 +0200
Message-ID: <1794623.zNambAqeEh@avalon>
In-Reply-To: <1408971053.3191.39.camel@paszta.hi.pengutronix.de>
References: <1408962839-25165-1-git-send-email-p.zabel@pengutronix.de> <53FB2045.1020504@xs4all.nl> <1408971053.3191.39.camel@paszta.hi.pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 25 August 2014 14:50:53 Philipp Zabel wrote:
> Hi Hans,
> 
> Am Montag, den 25.08.2014, 13:38 +0200 schrieb Hans Verkuil:
> > Hi Philipp,
> > 
> > I have to think a bit more about the format names, but in the meantime I
> > have
> > two other suggestions:
> Thank you, I haven't spent much thought about the actual descriptions
> yet. Most are just transcribed from the comments in videodev2.h without
> looking at the names used in the drivers.
> 
> [...]
> 
> > > +/**
> > > + * struct v4l2_pixfmt - internal V4L2 pixel format description
> > > + * @name: format description to be returned by enum_fmt
> > > + * @pixelformat: v4l2 pixel format fourcc
> > > + * @bpp_line: bits per pixel, averaged over a line (of the first plane
> > > + *            for planar formats), used to calculate bytesperline
> > > + *            Zero for compressed and macroblock tiled formats.
> > > + * @bpp_image: bits per pixel, averaged over the whole image. This is
> > > used to
> > > + *             calculate sizeimage for uncompressed formats.
> > > + *             Zero for compressed formats.
> > 
> > I would add a 'planes' field as well for use with formats that use
> > non-contiguous planes.
> 
> Good point, I'll add that.
> 
> [...]
> 
> > > +static inline unsigned int v4l2_bytesperline(const struct v4l2_pixfmt
> > > *fmt, +					     unsigned int width)
> > > +{
> > > +	return width * fmt->bpp_line / 8;
> > 
> > Round up: return (width * fmt->bpp_line + 7) / 8;
> 
> Right, I should use DIV_ROUND_UP(width * fmt->bpp_line, 8) here.
> 
> > > +}
> > > +
> > > +static inline unsigned int v4l2_sizeimage(const struct v4l2_pixfmt
> > > *fmt,
> > > +					  unsigned int width,
> > > +					  unsigned int height)
> > > +{
> > > +	return width * height * fmt->bpp_image / 8;
> > 
> > Ditto: return height * v4l2_bytesperline(fmt, width);
> 
> I can't use v4l2_bytesperline because that might be zero for macroblock
> tiled formats and uses the wrong bpp value for planar formats with
> subsampled chroma.
> 
> This nearly works:
>     return height * DIV_ROUND_UP(width * fmt->bpp_image, 8)

Isn't that exactly height * v4l2_bytesperline(fmt, width) ?

> For the planar 4:2:0 subsampled formats and Y41P (bpp_image == 12),
> width has to be even, so that is ok.
> Most other formats have a bpp_image that is divisible by 8, but there
> are the 4:1:0 subsampled formats (bpp_image == 9). Those would round up
> width to a multiple of eight, even though it only has to be a multiple
> of four. I'd fall back to:
> 
>     if (fmt->bpp_image == fmt->bpp_line) {
>         return height * DIV_ROUND_UP(width * fmt->bpp_image, 8);
>     } else {
>         /* we know that v4l2_bytesperline doesn't round for planar */
>         return height * width * fmt->bpp_image / 8;
>     }

Isn't that growing slightly too big for an inline function ?

-- 
Regards,

Laurent Pinchart

