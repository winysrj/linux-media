Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:58889 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727405AbeGPQm5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Jul 2018 12:42:57 -0400
Message-ID: <1531757689.18173.24.camel@pengutronix.de>
Subject: Re: [PATCH] media: coda: add SPS fixup code for frame sizes that
 are not multiples of 16
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: kernel@pengutronix.de
Date: Mon, 16 Jul 2018 18:14:49 +0200
In-Reply-To: <00c884f5-3a7e-9515-ec4b-e9aa3bf64532@xs4all.nl>
References: <20180628164701.26936-1-p.zabel@pengutronix.de>
         <00c884f5-3a7e-9515-ec4b-e9aa3bf64532@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2018-07-02 at 10:53 +0200, Hans Verkuil wrote:
> On 28/06/18 18:47, Philipp Zabel wrote:
> > The CODA firmware does not set the VUI frame cropping fields to properly
> > describe coded h.264 streams with frame sizes that are not a multiple of
> > the macroblock size.
> > This adds RBSP parsing code and a SPS fixup routine to manually replace
> > the cropping information in the headers produced by the firmware with
> > the correct values.
> > 
> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > ---
> >  drivers/media/platform/coda/coda-bit.c  |  11 +
> >  drivers/media/platform/coda/coda-h264.c | 302 ++++++++++++++++++++++++
> >  drivers/media/platform/coda/coda.h      |   2 +
> >  3 files changed, 315 insertions(+)
> > 
> > diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
> > index 94ba3cc3bf14..d6380a10fa2c 100644
> > --- a/drivers/media/platform/coda/coda-bit.c
> > +++ b/drivers/media/platform/coda/coda-bit.c
> > @@ -1197,6 +1197,17 @@ static int coda_start_encoding(struct coda_ctx *ctx)
> >  		if (ret < 0)
> >  			goto out;
> >  
> > +		if ((q_data_src->rect.width % 16) ||
> > +		    (q_data_src->rect.height % 16)) {
> > +			ret = coda_sps_fixup(ctx, q_data_src->rect.width,
> > +					     q_data_src->rect.height,
> > +					     &ctx->vpu_header[0][0],
> > +					     &ctx->vpu_header_size[0],
> > +					     sizeof(ctx->vpu_header[0]));
> 
> You need to add a comment here why this is needed.
[...]
> > +int coda_sps_fixup(struct coda_ctx *ctx, int width, int height, char *buf,
> > +		   int *size, int max_size)
> 
> Same here: why it is needed and what does it do.

Thank you, I'll send a v2 with this fixed.

This function rewrites the h.264 SPS header to set the crop_right and
crop_bottom fields correctly, as these are always set to 0 by the
CODA7541 firmware.

Setting the crop_* fields is important for frame sizes that are not
multiples of the macroblock size: those fields are used together with
the pic_width_in_mbs_minus1 and pic_height_in_map_units_minus1 fields
to determine the visible frame width and height.

regards
Philipp
