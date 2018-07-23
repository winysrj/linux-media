Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:48287 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387840AbeGWIbu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Jul 2018 04:31:50 -0400
Message-ID: <1532331117.3501.2.camel@pengutronix.de>
Subject: Re: [PATCH 16/16] media: imx: add mem2mem device
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        linux-media@vger.kernel.org
Cc: kernel@pengutronix.de
Date: Mon, 23 Jul 2018 09:31:57 +0200
In-Reply-To: <0d10c8dc-1406-1ba6-f615-d60ae9c20c58@gmail.com>
References: <20180622155217.29302-1-p.zabel@pengutronix.de>
         <20180622155217.29302-17-p.zabel@pengutronix.de>
         <8b4ea4ab-0500-9daa-e6e1-031e7d7a0517@mentor.com>
         <1531750331.18173.21.camel@pengutronix.de>
         <0d10c8dc-1406-1ba6-f615-d60ae9c20c58@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2018-07-22 at 11:02 -0700, Steve Longerbeam wrote:
> On 07/16/2018 07:12 AM, Philipp Zabel wrote:
[...]
> > > > +		/*
> > > > +		 * The IC burst reads 8 pixels at a time. Reading beyond the
> > > > +		 * end of the line is usually acceptable. Those pixels are
> > > > +		 * ignored, unless the IC has to write the scaled line in
> > > > +		 * reverse.
> > > > +		 */
> > > > +		if (!ipu_rot_mode_is_irt(ctx->rot_mode) &&
> > > > +		    ctx->rot_mode && IPU_ROT_BIT_HFLIP)
> > > > +			walign = 3;
> > > 
> > > This looks wrong. Do you mean:
> > > 
> > > if (ipu_rot_mode_is_irt(ctx->rot_mode) || (ctx->rot_mode & IPU_ROT_BIT_HFLIP))
> > >       walign = 3;
> > > else
> > >       walign = 1;
[...]
> > No, I specifically meant (!IRT && HFLIP).
> 
> Right, but there is still a typo:
> 
> if (!ipu_rot_mode_is_irt(ctx->rot_mode) && ctx->rot_mode && IPU_ROT_BIT_HFLIP)
>
> should be:
> 
> if (!ipu_rot_mode_is_irt(ctx->rot_mode) && (ctx->rot_mode & IPU_ROT_BIT_HFLIP))

Ow, yes, thank you.

> > The rotator itself doesn't cause any input alignment restrictions, we
> > just have to make sure that the intermediate tiles after scaling are 8x8
> > aligned.
> > 
> > > Also, why not simply call ipu_image_convert_adjust() in
> > > mem2mem_try_fmt()? If there is something missing in the former
> > > function, then it should be added there, instead of adding the
> > > missing checks in mem2mem_try_fmt().
> > 
> > ipu_image_convert_adjust tries to adjust both input and output image at
> > the same time, here we just have the format of either input or output
> > image. Do you suggest to split this function into an input and an output
> > version?
> 
> See b4362162c0 ("media: imx: mem2mem: Use ipu_image_convert_adjust
> in try format")

Alright, this looks fine to me. I was worried about inter-format
limitations, but the only one seems to be the output size lower bound to
1/4 of the input size. Should S_FMT(OUT) also update the capture format
if adjustments were made to keep a consistent state?

regards
Philipp
