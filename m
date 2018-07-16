Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:49835 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726390AbeGPOju (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Jul 2018 10:39:50 -0400
Message-ID: <1531750331.18173.21.camel@pengutronix.de>
Subject: Re: [PATCH 16/16] media: imx: add mem2mem device
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <steve_longerbeam@mentor.com>,
        linux-media@vger.kernel.org
Cc: kernel@pengutronix.de, Steve Longerbeam <slongerbeam@gmail.com>
Date: Mon, 16 Jul 2018 16:12:11 +0200
In-Reply-To: <8b4ea4ab-0500-9daa-e6e1-031e7d7a0517@mentor.com>
References: <20180622155217.29302-1-p.zabel@pengutronix.de>
         <20180622155217.29302-17-p.zabel@pengutronix.de>
         <8b4ea4ab-0500-9daa-e6e1-031e7d7a0517@mentor.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steve,

On Thu, 2018-07-05 at 15:09 -0700, Steve Longerbeam wrote:
[...]
> > +static int mem2mem_try_fmt(struct file *file, void *priv,
> > +			   struct v4l2_format *f)
> > +{
[...]
> > +	/*
> > +	 * Horizontally/vertically chroma subsampled formats must have even
> > +	 * width/height.
> > +	 */
> > +	switch (f->fmt.pix.pixelformat) {
> > +	case V4L2_PIX_FMT_YUV420:
> > +	case V4L2_PIX_FMT_YVU420:
> > +	case V4L2_PIX_FMT_NV12:
> > +		walign = 1;
> > +		halign = 1;
> > +		break;
> > +	case V4L2_PIX_FMT_YUV422P:
> > +	case V4L2_PIX_FMT_NV16:
> > +		walign = 1;
> > +		halign = 0;
> > +		break;
> > +	default:
> 
> The default case should init walign, otherwise for OUTPUT direction,
> walign may not get initialized at all, see below...

Yes, thank you.

> > +		halign = 0;
> > +		break;
> > +	}
> > +	if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
> > +		/*
> > +		 * The IC burst reads 8 pixels at a time. Reading beyond the
> > +		 * end of the line is usually acceptable. Those pixels are
> > +		 * ignored, unless the IC has to write the scaled line in
> > +		 * reverse.
> > +		 */
> > +		if (!ipu_rot_mode_is_irt(ctx->rot_mode) &&
> > +		    ctx->rot_mode && IPU_ROT_BIT_HFLIP)
> > +			walign = 3;
> 
> This looks wrong. Do you mean:
> 
> if (ipu_rot_mode_is_irt(ctx->rot_mode) || (ctx->rot_mode & IPU_ROT_BIT_HFLIP))
>      walign = 3;
> else
>      walign = 1;

The input DMA burst width alignment is only necessary if the lines are
scanned from right to left (that is, if HF is enabled) in the scaling
step.
If the rotator is used, the flipping is done in the rotation step
instead, so the alignment restriction would be on the width of the
intermediate tile (and thus on the output height). This is already
covered by the rotator 8x8 pixel block alignment.

> That is, require 8 byte width alignment for IRT or if HFLIP is enabled.

No, I specifically meant (!IRT && HFLIP).

The rotator itself doesn't cause any input alignment restrictions, we
just have to make sure that the intermediate tiles after scaling are 8x8
aligned.

> Also, why not simply call ipu_image_convert_adjust() in
> mem2mem_try_fmt()? If there is something missing in the former
> function, then it should be added there, instead of adding the
> missing checks in mem2mem_try_fmt().

ipu_image_convert_adjust tries to adjust both input and output image at
the same time, here we just have the format of either input or output
image. Do you suggest to split this function into an input and an output
version?

regards
Philipp
