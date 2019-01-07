Return-Path: <SRS0=8vfi=PP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D261C43387
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 09:57:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA1AB20854
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 09:57:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726746AbfAGJ5b (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 7 Jan 2019 04:57:31 -0500
Received: from mail.bootlin.com ([62.4.15.54]:59447 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726448AbfAGJ5a (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 7 Jan 2019 04:57:30 -0500
Received: by mail.bootlin.com (Postfix, from userid 110)
        id 4711120802; Mon,  7 Jan 2019 10:57:28 +0100 (CET)
Received: from aptenodytes (aaubervilliers-681-1-29-148.w90-88.abo.wanadoo.fr [90.88.149.148])
        by mail.bootlin.com (Postfix) with ESMTPSA id C958120714;
        Mon,  7 Jan 2019 10:57:17 +0100 (CET)
Message-ID: <64c793e08d61181b78125b3956ec38623fa5d261.camel@bootlin.com>
Subject: Re: [linux-sunxi] [PATCH v2 1/2] media: v4l: Add definitions for
 the HEVC slice format and controls
From:   Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To:     Randy Li <randy.li@rock-chips.com>
Cc:     Jernej =?UTF-8?Q?=C5=A0krabec?= <jernej.skrabec@gmail.com>,
        linux-sunxi@googlegroups.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-arm-kernel@lists.infradead.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Randy Li <ayaka@soulik.info>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        linux-rockchip@lists.infradead.org
Date:   Mon, 07 Jan 2019 10:57:17 +0100
In-Reply-To: <776e63c9-d4a5-342a-e0f7-200ef144ffc4@rock-chips.com>
References: <20181123130209.11696-1-paul.kocialkowski@bootlin.com>
         <20181123130209.11696-2-paul.kocialkowski@bootlin.com>
         <5515174.7lFZcYkk85@jernej-laptop>
         <ffe9c81db34b599f675ca5bbf02de360bf0a1608.camel@bootlin.com>
         <776e63c9-d4a5-342a-e0f7-200ef144ffc4@rock-chips.com>
Organization: Bootlin
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.3 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi,

On Mon, 2019-01-07 at 11:49 +0800, Randy Li wrote:
> On 12/12/18 8:51 PM, Paul Kocialkowski wrote:
> > Hi,
> > 
> > On Wed, 2018-12-05 at 21:59 +0100, Jernej Škrabec wrote:
> > 
> > > > +
> > > > +#define V4L2_HEVC_DPB_ENTRY_RPS_ST_CURR_BEFORE	0x01
> > > > +#define V4L2_HEVC_DPB_ENTRY_RPS_ST_CURR_AFTER	0x02
> > > > +#define V4L2_HEVC_DPB_ENTRY_RPS_LT_CURR		0x03
> > > > +
> > > > +#define V4L2_HEVC_DPB_ENTRIES_NUM_MAX		16
> > > > +
> > > > +struct v4l2_hevc_dpb_entry {
> > > > +	__u32	buffer_tag;
> > > > +	__u8	rps;
> > > > +	__u8	field_pic;
> > > > +	__u16	pic_order_cnt[2];
> > > > +};
> 
> Please add a property for reference index, if that rps is not used for 
> this, some device would request that(not the rockchip one). And 
> Rockchip's VDPU1 and VDPU2 for AVC would request a similar property.

What exactly is that reference index? Is it a bitstream element or
something deduced from the bitstream?

> Adding another buffer_tag for referring the memory of the motion vectors 
> for each frames. Or a better method is add a meta data to echo picture 
> buffer,  since the picture output is just the same as the original, 
> display won't care whether the motion vectors are written the button of 
> picture or somewhere else.

The motion vectors are passed as part of the raw bitstream data, in the
slices. Is there a case where the motion vectors are coded differently?

> > > > +
> > > > +struct v4l2_hevc_pred_weight_table {
> > > > +	__u8	luma_log2_weight_denom;
> > > > +	__s8	delta_chroma_log2_weight_denom;
> > > > +
> > > > +	__s8	delta_luma_weight_l0[V4L2_HEVC_DPB_ENTRIES_NUM_MAX];
> > > > +	__s8	luma_offset_l0[V4L2_HEVC_DPB_ENTRIES_NUM_MAX];
> > > > +	__s8	delta_chroma_weight_l0[V4L2_HEVC_DPB_ENTRIES_NUM_MAX][2];
> > > > +	__s8	chroma_offset_l0[V4L2_HEVC_DPB_ENTRIES_NUM_MAX][2];
> > > > +
> > > > +	__s8	delta_luma_weight_l1[V4L2_HEVC_DPB_ENTRIES_NUM_MAX];
> > > > +	__s8	luma_offset_l1[V4L2_HEVC_DPB_ENTRIES_NUM_MAX];
> > > > +	__s8	delta_chroma_weight_l1[V4L2_HEVC_DPB_ENTRIES_NUM_MAX][2];
> > > > +	__s8	chroma_offset_l1[V4L2_HEVC_DPB_ENTRIES_NUM_MAX][2];
> > > > +};
> > > > +
> Those properties I think are not necessary are applying for the 
> Rockchip's device, may not work for the others.

Yes, it's possible that some of the elements are not necessary for some
decoders. What we want is to cover all the elements that might be
required for a decoder.

> > > > +struct v4l2_ctrl_hevc_slice_params {
> > > > +	__u32	bit_size;
> > > > +	__u32	data_bit_offset;
> > > > +
> > > > +	/* ISO/IEC 23008-2, ITU-T Rec. H.265: NAL unit header */
> > > > +	__u8	nal_unit_type;
> > > > +	__u8	nuh_temporal_id_plus1;
> > > > +
> > > > +	/* ISO/IEC 23008-2, ITU-T Rec. H.265: General slice segment header */
> > > > +	__u8	slice_type;
> > > > +	__u8	colour_plane_id;
> ----------------------------------------------------------------------------
> > > > +	__u16	slice_pic_order_cnt;
> > > > +	__u8	slice_sao_luma_flag;
> > > > +	__u8	slice_sao_chroma_flag;
> > > > +	__u8	slice_temporal_mvp_enabled_flag;
> > > > +	__u8	num_ref_idx_l0_active_minus1;
> > > > +	__u8	num_ref_idx_l1_active_minus1;
> Rockchip's decoder doesn't use this part.
> > > > +	__u8	mvd_l1_zero_flag;
> > > > +	__u8	cabac_init_flag;
> > > > +	__u8	collocated_from_l0_flag;
> > > > +	__u8	collocated_ref_idx;
> > > > +	__u8	five_minus_max_num_merge_cand;
> > > > +	__u8	use_integer_mv_flag;
> > > > +	__s8	slice_qp_delta;
> > > > +	__s8	slice_cb_qp_offset;
> > > > +	__s8	slice_cr_qp_offset;
> > > > +	__s8	slice_act_y_qp_offset;
> > > > +	__s8	slice_act_cb_qp_offset;
> > > > +	__s8	slice_act_cr_qp_offset;
> > > > +	__u8	slice_deblocking_filter_disabled_flag;
> > > > +	__s8	slice_beta_offset_div2;
> > > > +	__s8	slice_tc_offset_div2;
> > > > +	__u8	slice_loop_filter_across_slices_enabled_flag;
> > > > +
> > > > +	/* ISO/IEC 23008-2, ITU-T Rec. H.265: Picture timing SEI message */
> > > > +	__u8	pic_struct;
> I think the decoder doesn't care about this, it is used for display.

The purpose of this field is to indicate whether the current picture is
a progressive frame or an interlaced field picture, which is useful for
decoding.

At least our decoder has a register field to indicate frame/top
field/bottom field, so we certainly need to keep the info around.
Looking at the spec and the ffmpeg implementation, it looks like this
flag of the bitstream is the usual way to report field coding.

Cheers,

Paul

> > > > +
> > > > +	/* ISO/IEC 23008-2, ITU-T Rec. H.265: General slice segment header */
> > > > +	struct v4l2_hevc_dpb_entry dpb[V4L2_HEVC_DPB_ENTRIES_NUM_MAX];
> > > > +	__u8	num_active_dpb_entries;
> > > > +	__u8	ref_idx_l0[V4L2_HEVC_DPB_ENTRIES_NUM_MAX];
> > > > +	__u8	ref_idx_l1[V4L2_HEVC_DPB_ENTRIES_NUM_MAX];
> > > > +
> > > > +	__u8	num_rps_poc_st_curr_before;
> > > > +	__u8	num_rps_poc_st_curr_after;
> > > > +	__u8	num_rps_poc_lt_curr;
> > > > +
> > > > +	/* ISO/IEC 23008-2, ITU-T Rec. H.265: Weighted prediction parameter */
> > > > +	struct v4l2_hevc_pred_weight_table pred_weight_table;
> > > > +};
> > > > +
> > > >   #endif
-- 
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com

