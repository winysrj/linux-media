Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:49827 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932350AbaHYPqp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Aug 2014 11:46:45 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de
Subject: Re: [RFC] [media] v4l2: add V4L2 pixel format array and helper functions
Date: Mon, 25 Aug 2014 17:47:28 +0200
Message-ID: <3263560.xPJs935yYQ@avalon>
In-Reply-To: <1408981277.3191.80.camel@paszta.hi.pengutronix.de>
References: <1408962839-25165-1-git-send-email-p.zabel@pengutronix.de> <1794623.zNambAqeEh@avalon> <1408981277.3191.80.camel@paszta.hi.pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

On Monday 25 August 2014 17:41:17 Philipp Zabel wrote:
> Am Montag, den 25.08.2014, 17:13 +0200 schrieb Laurent Pinchart:
> [...]
> 
> >>>> +static inline unsigned int v4l2_sizeimage(const struct v4l2_pixfmt
> >>>> *fmt,
> >>>> +					  unsigned int width,
> >>>> +					  unsigned int height)
> >>>> +{
> >>>> +	return width * height * fmt->bpp_image / 8;
> >>> 
> >>> Ditto: return height * v4l2_bytesperline(fmt, width);
> >> 
> >> I can't use v4l2_bytesperline because that might be zero for macroblock
> >> tiled formats and uses the wrong bpp value for planar formats with
> >> subsampled chroma.
> >> 
> >> This nearly works:
> >>     return height * DIV_ROUND_UP(width * fmt->bpp_image, 8)
> > 
> > Isn't that exactly height * v4l2_bytesperline(fmt, width) ?
> 
> Only if bpp_image == bpp_line ...

Oops, I've missed that subtle difference, sorry.

> >> For the planar 4:2:0 subsampled formats and Y41P (bpp_image == 12),
> >> width has to be even, so that is ok.
> >> Most other formats have a bpp_image that is divisible by 8, but there
> >> are the 4:1:0 subsampled formats (bpp_image == 9). Those would round up
> >> width to a multiple of eight, even though it only has to be a multiple
> >> 
> >> of four. I'd fall back to:
> >>     if (fmt->bpp_image == fmt->bpp_line) {
> >>     
> >>         return height * DIV_ROUND_UP(width * fmt->bpp_image, 8);
> 
> ... as is the case here. I'll use v4l2_bytesperline, then.
> 
> >>     } else {
> >>     
> >>         /* we know that v4l2_bytesperline doesn't round for planar */
> >>         return height * width * fmt->bpp_image / 8;
> >>     
> >>     }
> > 
> > Isn't that growing slightly too big for an inline function ?
> 
> Yes, I think this is slightly over the edge. Is room for a function to
> accompany the preexisting v4l2_fill_pix_format (say,
> v4l2_fill_pix_format_size) to set both the bytesperline and sizeimage
> values in a struct v4l2_pix_format?

That sounds sensible to me, provided it would be used by drivers of course. I 
wouldn't remove v4l2_bytesperline() and v4l2_sizeimage(), as the values might 
be needed by drivers in places where a v4l2_pix_format structure isn't 
available.

> Also, is anybody bothered by the v4l2_pix_format / v4l2_pixfmt
> similarity in name?

How about renaming v4l2_pixfmt to v4l2_pix_format_info ?

-- 
Regards,

Laurent Pinchart

