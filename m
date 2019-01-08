Return-Path: <SRS0=gjtM=PQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C5E5C43387
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 08:38:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D85220449
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 08:38:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727484AbfAHIis (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 8 Jan 2019 03:38:48 -0500
Received: from mail.bootlin.com ([62.4.15.54]:57640 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727368AbfAHIis (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 Jan 2019 03:38:48 -0500
Received: by mail.bootlin.com (Postfix, from userid 110)
        id 7B406209C2; Tue,  8 Jan 2019 09:38:45 +0100 (CET)
Received: from aptenodytes (aaubervilliers-681-1-29-148.w90-88.abo.wanadoo.fr [90.88.149.148])
        by mail.bootlin.com (Postfix) with ESMTPSA id 1B33A2078C;
        Tue,  8 Jan 2019 09:38:45 +0100 (CET)
Message-ID: <f982ef378a8ade075bc7077b93640e20ecebf9f4.camel@bootlin.com>
Subject: Re: [linux-sunxi] [PATCH v2 1/2] media: v4l: Add definitions for
 the HEVC slice format and controls
From:   Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To:     Ayaka <ayaka@soulik.info>
Cc:     Randy Li <randy.li@rock-chips.com>,
        Jernej =?UTF-8?Q?=C5=A0krabec?= <jernej.skrabec@gmail.com>,
        linux-sunxi@googlegroups.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-arm-kernel@lists.infradead.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        linux-rockchip@lists.infradead.org
Date:   Tue, 08 Jan 2019 09:38:44 +0100
In-Reply-To: <D8005130-F7FD-4CBD-8396-1BB08BB08E81@soulik.info>
References: <20181123130209.11696-1-paul.kocialkowski@bootlin.com>
         <20181123130209.11696-2-paul.kocialkowski@bootlin.com>
         <5515174.7lFZcYkk85@jernej-laptop>
         <ffe9c81db34b599f675ca5bbf02de360bf0a1608.camel@bootlin.com>
         <776e63c9-d4a5-342a-e0f7-200ef144ffc4@rock-chips.com>
         <64c793e08d61181b78125b3956ec38623fa5d261.camel@bootlin.com>
         <D8005130-F7FD-4CBD-8396-1BB08BB08E81@soulik.info>
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

On Tue, 2019-01-08 at 09:16 +0800, Ayaka wrote:
> 
> Sent from my iPad
> 
> > On Jan 7, 2019, at 5:57 PM, Paul Kocialkowski <paul.kocialkowski@bootlin.com> wrote:
> > 
> > Hi,
> > 
> > > On Mon, 2019-01-07 at 11:49 +0800, Randy Li wrote:
> > > > On 12/12/18 8:51 PM, Paul Kocialkowski wrote:
> > > > Hi,
> > > > 
> > > > On Wed, 2018-12-05 at 21:59 +0100, Jernej Škrabec wrote:
> > > > 
> > > > > > +
> > > > > > +#define V4L2_HEVC_DPB_ENTRY_RPS_ST_CURR_BEFORE    0x01
> > > > > > +#define V4L2_HEVC_DPB_ENTRY_RPS_ST_CURR_AFTER    0x02
> > > > > > +#define V4L2_HEVC_DPB_ENTRY_RPS_LT_CURR        0x03
> > > > > > +
> > > > > > +#define V4L2_HEVC_DPB_ENTRIES_NUM_MAX        16
> > > > > > +
> > > > > > +struct v4l2_hevc_dpb_entry {
> > > > > > +    __u32    buffer_tag;
> > > > > > +    __u8    rps;
> > > > > > +    __u8    field_pic;
> > > > > > +    __u16    pic_order_cnt[2];
> > > > > > +};
> > > 
> > > Please add a property for reference index, if that rps is not used for 
> > > this, some device would request that(not the rockchip one). And 
> > > Rockchip's VDPU1 and VDPU2 for AVC would request a similar property.
> > 
> > What exactly is that reference index? Is it a bitstream element or
> > something deduced from the bitstream?
> > 
> picture order count(POC) for HEVC and frame_num in AVC. I think it is
> the number used in list0(P slice and B slice) and list1(B slice).

The picture order count is already the last field of the DPB entry
structure. There is one for each field picture.

> > > Adding another buffer_tag for referring the memory of the motion vectors 
> > > for each frames. Or a better method is add a meta data to echo picture 
> > > buffer,  since the picture output is just the same as the original, 
> > > display won't care whether the motion vectors are written the button of 
> > > picture or somewhere else.
> > 
> > The motion vectors are passed as part of the raw bitstream data, in the
> > slices. Is there a case where the motion vectors are coded differently?
> No, it is an additional cache for decoder, even FFmpeg having such
> data, I think allwinner must output it into somewhere.

Ah yes I see what you mean! This is handled internally by our driver
and not exposed to userspace. I don't think it would be a good idea to
expose this cache or request that userspace allocates it like a video
buffer.

> > > > > > +
> > > > > > +struct v4l2_hevc_pred_weight_table {
> > > > > > +    __u8    luma_log2_weight_denom;
> > > > > > +    __s8    delta_chroma_log2_weight_denom;
> > > > > > +
> > > > > > +    __s8    delta_luma_weight_l0[V4L2_HEVC_DPB_ENTRIES_NUM_MAX];
> > > > > > +    __s8    luma_offset_l0[V4L2_HEVC_DPB_ENTRIES_NUM_MAX];
> > > > > > +    __s8    delta_chroma_weight_l0[V4L2_HEVC_DPB_ENTRIES_NUM_MAX][2];
> > > > > > +    __s8    chroma_offset_l0[V4L2_HEVC_DPB_ENTRIES_NUM_MAX][2];
> > > > > > +
> > > > > > +    __s8    delta_luma_weight_l1[V4L2_HEVC_DPB_ENTRIES_NUM_MAX];
> > > > > > +    __s8    luma_offset_l1[V4L2_HEVC_DPB_ENTRIES_NUM_MAX];
> > > > > > +    __s8    delta_chroma_weight_l1[V4L2_HEVC_DPB_ENTRIES_NUM_MAX][2];
> > > > > > +    __s8    chroma_offset_l1[V4L2_HEVC_DPB_ENTRIES_NUM_MAX][2];
> > > > > > +};
> > > > > > +
> > > Those properties I think are not necessary are applying for the 
> > > Rockchip's device, may not work for the others.
> > 
> > Yes, it's possible that some of the elements are not necessary for some
> > decoders. What we want is to cover all the elements that might be
> > required for a decoder.
> I wonder whether allwinner need that, those sao flag usually ignored
> by decoder in design. But more is better than less, it is hard to
> extend a v4l2 structure  in the future, maybe a new HEVC profile
> would bring a new property, it is still too early for HEVC.

Yes this is used by our decoder. The idea is to have all the basic
bitstream elements in the structures (even if some decoders don't use
them all) and add others for extension as separate controls later.

> > > > > > +struct v4l2_ctrl_hevc_slice_params {
> > > > > > +    __u32    bit_size;
> > > > > > +    __u32    data_bit_offset;
> > > > > > +
> > > > > > +    /* ISO/IEC 23008-2, ITU-T Rec. H.265: NAL unit header */
> > > > > > +    __u8    nal_unit_type;
> > > > > > +    __u8    nuh_temporal_id_plus1;
> > > > > > +
> > > > > > +    /* ISO/IEC 23008-2, ITU-T Rec. H.265: General slice segment header */
> > > > > > +    __u8    slice_type;
> > > > > > +    __u8    colour_plane_id;
> > > ----------------------------------------------------------------------------
> > > > > > +    __u16    slice_pic_order_cnt;
> > > > > > +    __u8    slice_sao_luma_flag;
> > > > > > +    __u8    slice_sao_chroma_flag;
> > > > > > +    __u8    slice_temporal_mvp_enabled_flag;
> > > > > > +    __u8    num_ref_idx_l0_active_minus1;
> > > > > > +    __u8    num_ref_idx_l1_active_minus1;
> > > Rockchip's decoder doesn't use this part.
> > > > > > +    __u8    mvd_l1_zero_flag;
> > > > > > +    __u8    cabac_init_flag;
> > > > > > +    __u8    collocated_from_l0_flag;
> > > > > > +    __u8    collocated_ref_idx;
> > > > > > +    __u8    five_minus_max_num_merge_cand;
> > > > > > +    __u8    use_integer_mv_flag;
> > > > > > +    __s8    slice_qp_delta;
> > > > > > +    __s8    slice_cb_qp_offset;
> > > > > > +    __s8    slice_cr_qp_offset;
> > > > > > +    __s8    slice_act_y_qp_offset;
> > > > > > +    __s8    slice_act_cb_qp_offset;
> > > > > > +    __s8    slice_act_cr_qp_offset;
> > > > > > +    __u8    slice_deblocking_filter_disabled_flag;
> > > > > > +    __s8    slice_beta_offset_div2;
> > > > > > +    __s8    slice_tc_offset_div2;
> > > > > > +    __u8    slice_loop_filter_across_slices_enabled_flag;
> > > > > > +
> > > > > > +    /* ISO/IEC 23008-2, ITU-T Rec. H.265: Picture timing SEI message */
> > > > > > +    __u8    pic_struct;
> > > I think the decoder doesn't care about this, it is used for display.
> > 
> > The purpose of this field is to indicate whether the current picture is
> > a progressive frame or an interlaced field picture, which is useful for
> > decoding.
> > 
> > At least our decoder has a register field to indicate frame/top
> > field/bottom field, so we certainly need to keep the info around.
> > Looking at the spec and the ffmpeg implementation, it looks like this
> > flag of the bitstream is the usual way to report field coding.
> It depends whether the decoder cares about scan type or more, I
> wonder prefer general_interlaced_source_flag for just scan type, it
> would be better than reading another SEL.

Well we still need a way to indicate if the current data is top or
bottom field for interlaced. I don't think that knowing that the whole
video is interlaced would be precise enough.

Cheers,

Paul

> > > > > > +
> > > > > > +    /* ISO/IEC 23008-2, ITU-T Rec. H.265: General slice segment header */
> > > > > > +    struct v4l2_hevc_dpb_entry dpb[V4L2_HEVC_DPB_ENTRIES_NUM_MAX];
> > > > > > +    __u8    num_active_dpb_entries;
> > > > > > +    __u8    ref_idx_l0[V4L2_HEVC_DPB_ENTRIES_NUM_MAX];
> > > > > > +    __u8    ref_idx_l1[V4L2_HEVC_DPB_ENTRIES_NUM_MAX];
> > > > > > +
> > > > > > +    __u8    num_rps_poc_st_curr_before;
> > > > > > +    __u8    num_rps_poc_st_curr_after;
> > > > > > +    __u8    num_rps_poc_lt_curr;
> > > > > > +
> > > > > > +    /* ISO/IEC 23008-2, ITU-T Rec. H.265: Weighted prediction parameter */
> > > > > > +    struct v4l2_hevc_pred_weight_table pred_weight_table;
> > > > > > +};
> > > > > > +
> > > > > >  #endif
> > -- 
> > Paul Kocialkowski, Bootlin (formerly Free Electrons)
> > Embedded Linux and kernel engineering
> > https://bootlin.com
> > 
-- 
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com

