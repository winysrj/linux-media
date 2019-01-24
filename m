Return-Path: <SRS0=42/h=QA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A3DBC282C3
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 13:10:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5BC42218AF
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 13:10:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727831AbfAXNKi (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 24 Jan 2019 08:10:38 -0500
Received: from mail.bootlin.com ([62.4.15.54]:37276 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726105AbfAXNKi (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Jan 2019 08:10:38 -0500
Received: by mail.bootlin.com (Postfix, from userid 110)
        id 2B14D209B6; Thu, 24 Jan 2019 14:10:35 +0100 (CET)
Received: from aptenodytes (aaubervilliers-681-1-87-206.w90-88.abo.wanadoo.fr [90.88.29.206])
        by mail.bootlin.com (Postfix) with ESMTPSA id AB8DC20654;
        Thu, 24 Jan 2019 14:10:24 +0100 (CET)
Message-ID: <4f25de5bbcb7bf196fe4925f54e3335b50670bd2.camel@bootlin.com>
Subject: Re: [PATCH v2 2/2] media: cedrus: Add HEVC/H.265 decoding support
From:   Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To:     Maxime Ripard <maxime.ripard@bootlin.com>
Cc:     linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-arm-kernel@lists.infradead.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-sunxi@googlegroups.com, Randy Li <ayaka@soulik.info>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Date:   Thu, 24 Jan 2019 14:10:25 +0100
In-Reply-To: <20181127082119.xdemdwgclai7kj3r@flea>
References: <20181123130209.11696-1-paul.kocialkowski@bootlin.com>
         <20181123130209.11696-3-paul.kocialkowski@bootlin.com>
         <20181127082119.xdemdwgclai7kj3r@flea>
Organization: Bootlin
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi,

On Tue, 2018-11-27 at 09:21 +0100, Maxime Ripard wrote:
> Hi!
> 
> On Fri, Nov 23, 2018 at 02:02:09PM +0100, Paul Kocialkowski wrote:
> > This introduces support for HEVC/H.265 to the Cedrus VPU driver, with
> > both uni-directional and bi-directional prediction modes supported.
> > 
> > Field-coded (interlaced) pictures, custom quantization matrices and
> > 10-bit output are not supported at this point.
> > 
> > Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> 
> Output from checkpatch:
> total: 0 errors, 68 warnings, 14 checks, 999 lines checked

Looks like many of the "line over 80 chars" are due to macros. I don't
think it would be a good idea to break them down or to change the
macros names since they are directly inherited from the bitstream
elements.

What do you think?

> > +/*
> > + * Note: Neighbor info buffer size is apparently doubled for H6, which may be
> > + * related to 10 bit H265 support.
> > + */
> > +#define CEDRUS_H265_NEIGHBOR_INFO_BUF_SIZE	(397 * SZ_1K)
> > +#define CEDRUS_H265_ENTRY_POINTS_BUF_SIZE	(4 * SZ_1K)
> > +#define CEDRUS_H265_MV_COL_BUF_UNIT_CTB_SIZE	160
> 
> Having some information on where this is coming from would be useful.

Yes, definitely.

> > +static void cedrus_h265_sram_write_data(struct cedrus_dev *dev, u32 *data,
> 
> Since the data pointer is pretty much an opaque structure, you should
> have a void pointer here, that would avoid the type casting you're
> doing when calling that function.

Sure, that would make more sense.

[...]

> > +	/* Output frame. */
> > +
> > +	output_pic_list_index = V4L2_HEVC_DPB_ENTRIES_NUM_MAX;
> > +	pic_order_cnt[0] = pic_order_cnt[1] = slice_params->slice_pic_order_cnt;
> > +	mv_col_buf_addr[0] = cedrus_h265_frame_info_mv_col_buf_addr(ctx,
> > +		run->dst->vb2_buf.index, 0) - PHYS_OFFSET;
> > +	mv_col_buf_addr[1] = cedrus_h265_frame_info_mv_col_buf_addr(ctx,
> > +		run->dst->vb2_buf.index, 1) - PHYS_OFFSET;
> > +	dst_luma_addr = cedrus_dst_buf_addr(ctx, run->dst->vb2_buf.index, 0) -
> > +			PHYS_OFFSET;
> > +	dst_chroma_addr = cedrus_dst_buf_addr(ctx, run->dst->vb2_buf.index, 1) -
> > +			PHYS_OFFSET;
> > +
> > +	cedrus_h265_frame_info_write_single(dev, output_pic_list_index,
> > +					    slice_params->pic_struct != 0,
> > +					    pic_order_cnt, mv_col_buf_addr,
> > +					    dst_luma_addr, dst_chroma_addr);
> 
> You can only pass the run and slice_params pointers to that function.

The point is to make it independent from the context, so that the same
function can be called with either the slice_params or the dpb info.
I don't think making two variants or even two wrappers would bring any
significant benefit.

> > +
> > +	cedrus_write(dev, VE_DEC_H265_OUTPUT_FRAME_IDX, output_pic_list_index);
> > +
> > +	/* Reference picture list 0 (for P/B frames). */
> > +	if (slice_params->slice_type != V4L2_HEVC_SLICE_TYPE_I) {
> > +		cedrus_h265_ref_pic_list_write(dev, slice_params->ref_idx_l0,
> > +			slice_params->num_ref_idx_l0_active_minus1 + 1,
> > +			slice_params->dpb, slice_params->num_active_dpb_entries,
> > +			VE_DEC_H265_SRAM_OFFSET_REF_PIC_LIST0);
> > +
> 
> slice_params is enough.

The rationale is similar to the one above: being able to use the same
helper with either L0 or L1, which implies passing the relevant
elements directly.

> > +		if (pps->weighted_pred_flag || pps->weighted_bipred_flag)
> > +			cedrus_h265_pred_weight_write(dev,
> > +				pred_weight_table->delta_luma_weight_l0,
> > +				pred_weight_table->luma_offset_l0,
> > +				pred_weight_table->delta_chroma_weight_l0,
> > +				pred_weight_table->chroma_offset_l0,
> > +				slice_params->num_ref_idx_l0_active_minus1 + 1,
> > +				VE_DEC_H265_SRAM_OFFSET_PRED_WEIGHT_LUMA_L0,
> > +				VE_DEC_H265_SRAM_OFFSET_PRED_WEIGHT_CHROMA_L0);
> 
> Ditto, that function should only take the pred_weight_table and
> slice_params pointers

And same rational as well.

> > +	}
> > +
> > +	/* Reference picture list 1 (for B frames). */
> > +	if (slice_params->slice_type == V4L2_HEVC_SLICE_TYPE_B) {
> > +		cedrus_h265_ref_pic_list_write(dev, slice_params->ref_idx_l1,
> > +			slice_params->num_ref_idx_l1_active_minus1 + 1,
> > +			slice_params->dpb,
> > +			slice_params->num_active_dpb_entries,
> > +			VE_DEC_H265_SRAM_OFFSET_REF_PIC_LIST1);
> > +
> > +		if (pps->weighted_bipred_flag)
> > +			cedrus_h265_pred_weight_write(dev,
> > +				pred_weight_table->delta_luma_weight_l1,
> > +				pred_weight_table->luma_offset_l1,
> > +				pred_weight_table->delta_chroma_weight_l1,
> > +				pred_weight_table->chroma_offset_l1,
> > +				slice_params->num_ref_idx_l1_active_minus1 + 1,
> > +				VE_DEC_H265_SRAM_OFFSET_PRED_WEIGHT_LUMA_L1,
> > +				VE_DEC_H265_SRAM_OFFSET_PRED_WEIGHT_CHROMA_L1);
> > +	}
> 
> Ditto
> 
> Looks good otherwise, thanks!

Thanks for the review!

Cheers,

Paul

-- 
Paul Kocialkowski, Bootlin
Embedded Linux and kernel engineering
https://bootlin.com

