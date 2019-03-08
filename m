Return-Path: <SRS0=k2dg=RL=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2B24C43381
	for <linux-media@archiver.kernel.org>; Fri,  8 Mar 2019 06:19:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE07120811
	for <linux-media@archiver.kernel.org>; Fri,  8 Mar 2019 06:19:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="fjT3XRS+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725766AbfCHGTN (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Mar 2019 01:19:13 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:43304 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbfCHGTN (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Mar 2019 01:19:13 -0500
Received: by mail-ot1-f68.google.com with SMTP id n71so16443833ota.10
        for <linux-media@vger.kernel.org>; Thu, 07 Mar 2019 22:19:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iLlgLT0V6NE3Smd491K7ogy0lugJ4hJnmCkW60+E6Lg=;
        b=fjT3XRS+c6TG+FeXGSZPJ3H3FzVOmAtfM1hd7W4aXxb41O1AzKyx+03K1mTDvUFf2F
         5rTqn8xYoT2EYQg4hjEFXohoAlmrxHZMOMitAV6K1YQWt53C0P7v0unCXW86nihOnsdl
         TzTFg6zS2ZFTPBG1UfYXJeU4I6ZR2kQPhyOxw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iLlgLT0V6NE3Smd491K7ogy0lugJ4hJnmCkW60+E6Lg=;
        b=aVlAcGcb8wKmi91aSDV75hyLHzmtvv6zNoMp0YvBzo/FTZoHQI/VZHR3Rw7tvqO/Vu
         g50pudIcK5ONTspODBocA3CbMEkeFmUd/G6zMnWTQVE0lTZiRq+smyc7sdzeccZ1XKDY
         177Jj8L/p0qro8edu55/QfvKbRS0wq7L7zU1BaS+xMkVjN9LDetEmsIQqxckDnj1uc1Z
         NSy2FX697DM8WwiTWfyXdSA7jfWUYkixbGkSemE9K7tGHC7C7IHBN2MedMKpH2Ns7pDK
         9gAMkAIN/Yy62sBa3OJinpBw0KYDNlLGsV00spq1xCOkqJCFCkWkniEVj66odMi5XuTi
         KABg==
X-Gm-Message-State: APjAAAVO9t4pb4hb4rI8vzEh4gVQwmw/2EvH0w5zmvJJPKjDrDIqIii3
        K7oRP7UThNqSrkAOg7I/64r7dy7NEZnctw==
X-Google-Smtp-Source: APXvYqwMDzCz+A8iCQsRTjpKqXRS56uglHFTcUYVDBAuBX0XVPN6qmOASBLUaRA5fKlyDvHCCtMLig==
X-Received: by 2002:a9d:63d1:: with SMTP id e17mr10788135otl.239.1552025951429;
        Thu, 07 Mar 2019 22:19:11 -0800 (PST)
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com. [209.85.210.51])
        by smtp.gmail.com with ESMTPSA id d10sm2732230otl.69.2019.03.07.22.19.11
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 07 Mar 2019 22:19:11 -0800 (PST)
Received: by mail-ot1-f51.google.com with SMTP id v20so16470494otk.7
        for <linux-media@vger.kernel.org>; Thu, 07 Mar 2019 22:19:11 -0800 (PST)
X-Received: by 2002:a9d:3f24:: with SMTP id m33mr10016043otc.147.1552025549038;
 Thu, 07 Mar 2019 22:12:29 -0800 (PST)
MIME-Version: 1.0
References: <cover.f011581516bfe7650c9d4c6054bb828e6227e309.1551964740.git-series.maxime.ripard@bootlin.com>
 <1d374e71ffcc396b71461ea916cac3d957f8d86c.1551964740.git-series.maxime.ripard@bootlin.com>
In-Reply-To: <1d374e71ffcc396b71461ea916cac3d957f8d86c.1551964740.git-series.maxime.ripard@bootlin.com>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Fri, 8 Mar 2019 15:12:18 +0900
X-Gmail-Original-Message-ID: <CAAFQd5AKXz5QmqnSEkChf8DqPkhEuUQg--q9dZKPmB1kBR1hzA@mail.gmail.com>
Message-ID: <CAAFQd5AKXz5QmqnSEkChf8DqPkhEuUQg--q9dZKPmB1kBR1hzA@mail.gmail.com>
Subject: Re: [PATCH v5 1/2] media: uapi: Add H264 low-level decoder API
 compound controls.
To:     Maxime Ripard <maxime.ripard@bootlin.com>
Cc:     Hans Verkuil <hans.verkuil@cisco.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pawel Osciak <posciak@chromium.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "list@263.net:IOMMU DRIVERS <iommu@lists.linux-foundation.org>, Joerg
        Roedel <joro@8bytes.org>," <linux-arm-kernel@lists.infradead.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        jenskuske@gmail.com, Jernej Skrabec <jernej.skrabec@gmail.com>,
        Jonas Karlman <jonas@kwiboo.se>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        linux-sunxi@googlegroups.com,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Guenter Roeck <groeck@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Maxime,

On Thu, Mar 7, 2019 at 10:20 PM Maxime Ripard <maxime.ripard@bootlin.com> wrote:
>
> From: Pawel Osciak <posciak@chromium.org>
>
> Stateless video codecs will require both the H264 metadata and slices in
> order to be able to decode frames.
>
> This introduces the definitions for a new pixel format for H264 slices that
> have been parsed, as well as the structures used to pass the metadata from
> the userspace to the kernel.
>
> Co-Developped-by: Maxime Ripard <maxime.ripard@bootlin.com>
> Signed-off-by: Pawel Osciak <posciak@chromium.org>
> Signed-off-by: Guenter Roeck <groeck@chromium.org>
> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> ---
>  Documentation/media/uapi/v4l/biblio.rst            |   9 +-
>  Documentation/media/uapi/v4l/ext-ctrls-codec.rst   | 549 ++++++++++++++-
>  Documentation/media/uapi/v4l/pixfmt-compressed.rst |  19 +-
>  Documentation/media/uapi/v4l/vidioc-queryctrl.rst  |  30 +-
>  Documentation/media/videodev2.h.rst.exceptions     |   5 +-
>  drivers/media/v4l2-core/v4l2-ctrls.c               |  42 +-
>  drivers/media/v4l2-core/v4l2-ioctl.c               |   1 +-
>  include/media/h264-ctrls.h                         | 190 +++++-
>  include/media/v4l2-ctrls.h                         |  13 +-
>  include/uapi/linux/videodev2.h                     |   1 +-
>  10 files changed, 858 insertions(+), 1 deletion(-)
>  create mode 100644 include/media/h264-ctrls.h
>

Thanks for addressing my comments! Few more inline. (Sorry, missed
some previously. :()

> diff --git a/Documentation/media/uapi/v4l/biblio.rst b/Documentation/media/uapi/v4l/biblio.rst
> index ec33768c055e..3fc3f7ff338a 100644
> --- a/Documentation/media/uapi/v4l/biblio.rst
> +++ b/Documentation/media/uapi/v4l/biblio.rst
> @@ -122,6 +122,15 @@ ITU BT.1119
>
>  :author:    International Telecommunication Union (http://www.itu.ch)
>
> +.. _h264:
> +
> +ITU H.264
> +=========
> +
> +:title:     ITU-T Recommendation H.264 "Advanced Video Coding for Generic Audiovisual Services"
> +
> +:author:    International Telecommunication Union (http://www.itu.ch)
> +
>  .. _jfif:
>
>  JFIF
> diff --git a/Documentation/media/uapi/v4l/ext-ctrls-codec.rst b/Documentation/media/uapi/v4l/ext-ctrls-codec.rst
> index 54b3797b67dd..685942f0300e 100644
> --- a/Documentation/media/uapi/v4l/ext-ctrls-codec.rst
> +++ b/Documentation/media/uapi/v4l/ext-ctrls-codec.rst
> @@ -1343,6 +1343,555 @@ enum v4l2_mpeg_video_h264_hierarchical_coding_type -
>        - Layer number
>
>
> +.. _v4l2-mpeg-h264:
> +
> +``V4L2_CID_MPEG_VIDEO_H264_SPS (struct)``
> +    Specifies the sequence parameter set (as extracted from the
> +    bitstream) for the associated H264 slice data. This includes the
> +    necessary parameters for configuring a stateless hardware decoding
> +    pipeline for H264.  The bitstream parameters are defined according
> +    to :ref:`h264`. Unless there's a specific comment, refer to the
> +    specification for the documentation of these fields, section 7.4.2.1.1
> +    "Sequence Parameter Set Data Semantics".

I don't see this section being added by this patch. Where does it come from?

> +
> +    .. note::
> +
> +       This compound control is not yet part of the public kernel API and
> +       it is expected to change.
> +
> +.. c:type:: v4l2_ctrl_h264_sps
> +
> +.. cssclass:: longtable
> +
> +.. flat-table:: struct v4l2_ctrl_h264_sps
> +    :header-rows:  0
> +    :stub-columns: 0
> +    :widths:       1 1 2
> +
> +    * - __u8
> +      - ``profile_idc``
> +      -
> +    * - __u8
> +      - ``constraint_set_flags``
> +      - See :ref:`Sequence Parameter Set Constraints Set Flags <h264_sps_constraints_set_flags>`
> +    * - __u8
> +      - ``level_idc``
> +      -
> +    * - __u8
> +      - ``seq_parameter_set_id``
> +      -
> +    * - __u8
> +      - ``chroma_format_idc``
> +      -
> +    * - __u8
> +      - ``bit_depth_luma_minus8``
> +      -
> +    * - __u8
> +      - ``bit_depth_chroma_minus8``
> +      -
> +    * - __u8
> +      - ``log2_max_frame_num_minus4``
> +      -
> +    * - __u8
> +      - ``pic_order_cnt_type``
> +      -
> +    * - __u8
> +      - ``log2_max_pic_order_cnt_lsb_minus4``
> +      -
> +    * - __u8
> +      - ``max_num_ref_frames``
> +      -
> +    * - __u8
> +      - ``num_ref_frames_in_pic_order_cnt_cycle``
> +      -
> +    * - __s32
> +      - ``offset_for_ref_frame[255]``
> +      -
> +    * - __s32
> +      - ``offset_for_non_ref_pic``
> +      -
> +    * - __s32
> +      - ``offset_for_top_to_bottom_field``
> +      -
> +    * - __u16
> +      - ``pic_width_in_mbs_minus1``
> +      -
> +    * - __u16
> +      - ``pic_height_in_map_units_minus1``
> +      -
> +    * - __u32
> +      - ``flags``
> +      - See :ref:`Sequence Parameter Set Flags <h264_sps_flags>`
> +
> +.. _h264_sps_constraints_set_flags:
> +
> +``Sequence Parameter Set Constraints Set Flags``
> +
> +.. cssclass:: longtable
> +
> +.. flat-table::
> +    :header-rows:  0
> +    :stub-columns: 0
> +    :widths:       1 1 2
> +
> +    * - ``V4L2_H264_SPS_CONSTRAINT_SET0_FLAG``
> +      - 0x00000001
> +      -
> +    * - ``V4L2_H264_SPS_CONSTRAINT_SET1_FLAG``
> +      - 0x00000002
> +      -
> +    * - ``V4L2_H264_SPS_CONSTRAINT_SET2_FLAG``
> +      - 0x00000004
> +      -
> +    * - ``V4L2_H264_SPS_CONSTRAINT_SET3_FLAG``
> +      - 0x00000008
> +      -
> +    * - ``V4L2_H264_SPS_CONSTRAINT_SET4_FLAG``
> +      - 0x00000010
> +      -
> +    * - ``V4L2_H264_SPS_CONSTRAINT_SET5_FLAG``
> +      - 0x00000020
> +      -
> +
> +.. _h264_sps_flags:
> +
> +``Sequence Parameter Set Flags``
> +
> +.. cssclass:: longtable
> +
> +.. flat-table::
> +    :header-rows:  0
> +    :stub-columns: 0
> +    :widths:       1 1 2
> +
> +    * - ``V4L2_H264_SPS_FLAG_SEPARATE_COLOUR_PLANE``
> +      - 0x00000001
> +      -
> +    * - ``V4L2_H264_SPS_FLAG_QPPRIME_Y_ZERO_TRANSFORM_BYPASS``
> +      - 0x00000002
> +      -
> +    * - ``V4L2_H264_SPS_FLAG_DELTA_PIC_ORDER_ALWAYS_ZERO``
> +      - 0x00000004
> +      -
> +    * - ``V4L2_H264_SPS_FLAG_GAPS_IN_FRAME_NUM_VALUE_ALLOWED``
> +      - 0x00000008
> +      -
> +    * - ``V4L2_H264_SPS_FLAG_FRAME_MBS_ONLY``
> +      - 0x00000010
> +      -
> +    * - ``V4L2_H264_SPS_FLAG_MB_ADAPTIVE_FRAME_FIELD``
> +      - 0x00000020
> +      -
> +    * - ``V4L2_H264_SPS_FLAG_DIRECT_8X8_INFERENCE``
> +      - 0x00000040
> +      -
> +
> +``V4L2_CID_MPEG_VIDEO_H264_PPS (struct)``
> +    Specifies the picture parameter set (as extracted from the
> +    bitstream) for the associated H264 slice data. This includes the
> +    necessary parameters for configuring a stateless hardware decoding
> +    pipeline for H264.  The bitstream parameters are defined according
> +    to :ref:`h264`. Unless there's a specific comment, refer to the
> +    specification for the documentation of these fields, section 7.4.2.2
> +    "Picture Parameter Set RBSP Semantics".

Ditto.

> +
> +    .. note::
> +
> +       This compound control is not yet part of the public kernel API and
> +       it is expected to change.
> +
> +.. c:type:: v4l2_ctrl_h264_pps
> +
> +.. cssclass:: longtable
> +
> +.. flat-table:: struct v4l2_ctrl_h264_pps
> +    :header-rows:  0
> +    :stub-columns: 0
> +    :widths:       1 1 2
> +
> +    * - __u8
> +      - ``pic_parameter_set_id``
> +      -
> +    * - __u8
> +      - ``seq_parameter_set_id``
> +      -
> +    * - __u8
> +      - ``num_slice_groups_minus1``
> +      -
> +    * - __u8
> +      - ``num_ref_idx_l0_default_active_minus1``
> +      -
> +    * - __u8
> +      - ``num_ref_idx_l1_default_active_minus1``
> +      -
> +    * - __u8
> +      - ``weighted_bipred_idc``
> +      -
> +    * - __s8
> +      - ``pic_init_qp_minus26``
> +      -
> +    * - __s8
> +      - ``pic_init_qs_minus26``
> +      -
> +    * - __s8
> +      - ``chroma_qp_index_offset``
> +      -
> +    * - __s8
> +      - ``second_chroma_qp_index_offset``
> +      -
> +    * - __u16
> +      - ``flags``
> +      - See :ref:`Picture Parameter Set Flags <h264_pps_flags>`
> +
> +.. _h264_pps_flags:
> +
> +``Picture Parameter Set Flags``
> +
> +.. cssclass:: longtable
> +
> +.. flat-table::
> +    :header-rows:  0
> +    :stub-columns: 0
> +    :widths:       1 1 2
> +
> +    * - ``V4L2_H264_PPS_FLAG_ENTROPY_CODING_MODE``
> +      - 0x00000001
> +      -
> +    * - ``V4L2_H264_PPS_FLAG_BOTTOM_FIELD_PIC_ORDER_IN_FRAME_PRESENT``
> +      - 0x00000002
> +      -
> +    * - ``V4L2_H264_PPS_FLAG_WEIGHTED_PRED``
> +      - 0x00000004
> +      -
> +    * - ``V4L2_H264_PPS_FLAG_DEBLOCKING_FILTER_CONTROL_PRESENT``
> +      - 0x00000008
> +      -
> +    * - ``V4L2_H264_PPS_FLAG_CONSTRAINED_INTRA_PRED``
> +      - 0x00000010
> +      -
> +    * - ``V4L2_H264_PPS_FLAG_REDUNDANT_PIC_CNT_PRESENT``
> +      - 0x00000020
> +      -
> +    * - ``V4L2_H264_PPS_FLAG_TRANSFORM_8X8_MODE``
> +      - 0x00000040
> +      -
> +    * - ``V4L2_H264_PPS_FLAG_PIC_SCALING_MATRIX_PRESENT``
> +      - 0x00000080
> +      -
> +
> +``V4L2_CID_MPEG_VIDEO_H264_SCALING_MATRIX (struct)``
> +    Specifies the scaling matrix (as extracted from the bitstream) for
> +    the associated H264 slice data. The bitstream parameters are
> +    defined according to :ref:`h264`. Unless there's a specific
> +    comment, refer to the specification for the documentation of these
> +    fields, section 7.4.2.1.1.1  "Scaling List Semantics".

Ditto.

> +
> +    .. note::
> +
> +       This compound control is not yet part of the public kernel API and
> +       it is expected to change.
> +
> +.. c:type:: v4l2_ctrl_h264_scaling_matrix
> +
> +.. cssclass:: longtable
> +
> +.. flat-table:: struct v4l2_ctrl_h264_scaling_matrix
> +    :header-rows:  0
> +    :stub-columns: 0
> +    :widths:       1 1 2
> +
> +    * - __u8
> +      - ``scaling_list_4x4[6][16]``
> +      -
> +    * - __u8
> +      - ``scaling_list_8x8[6][64]``
> +      -
> +
> +``V4L2_CID_MPEG_VIDEO_H264_SLICE_PARAMS (struct)``
> +    Specifies the slice parameters (as extracted from the bitstream)
> +    for the associated H264 slice data. This includes the necessary
> +    parameters for configuring a stateless hardware decoding pipeline
> +    for H264.  The bitstream parameters are defined according to
> +    :ref:`h264`. Unless there's a specific comment, refer to the
> +    specification for the documentation of these fields, section 7.4.3
> +    "Slice Header Semantics".

Ditto.

> +
> +    .. note::
> +
> +       This compound control is not yet part of the public kernel API
> +       and it is expected to change.
> +
> +       This structure is expected to be passed as an array, with one
> +       entry for each slice included in the bitstream buffer.
> +
> +.. c:type:: v4l2_ctrl_h264_slice_param
> +
> +.. cssclass:: longtable
> +
> +.. flat-table:: struct v4l2_ctrl_h264_slice_param
> +    :header-rows:  0
> +    :stub-columns: 0
> +    :widths:       1 1 2
> +
> +    * - __u32
> +      - ``size``
> +      -
> +    * - __u32
> +      - ``header_bit_size``
> +      -
> +    * - __u16
> +      - ``first_mb_in_slice``
> +      -
> +    * - __u8
> +      - ``slice_type``
> +      -
> +    * - __u8
> +      - ``pic_parameter_set_id``
> +      -
> +    * - __u8
> +      - ``colour_plane_id``
> +      -
> +    * - __u8
> +      - ``redundant_pic_cnt``
> +      -
> +    * - __u16
> +      - ``frame_num``
> +      -
> +    * - __u16
> +      - ``idr_pic_id``
> +      -
> +    * - __u16
> +      - ``pic_order_cnt_lsb``
> +      -
> +    * - __s32
> +      - ``delta_pic_order_cnt_bottom``
> +      -
> +    * - __s32
> +      - ``delta_pic_order_cnt0``
> +      -
> +    * - __s32
> +      - ``delta_pic_order_cnt1``
> +      -
> +    * - struct :c:type:`v4l2_h264_pred_weight_table`
> +      - ``pred_weight_table``
> +      -
> +    * - __u32
> +      - ``dec_ref_pic_marking_bit_size``
> +      -
> +    * - __u32
> +      - ``pic_order_cnt_bit_size``
> +      -
> +    * - __u8
> +      - ``cabac_init_idc``
> +      -
> +    * - __s8
> +      - ``slice_qp_delta``
> +      -
> +    * - __s8
> +      - ``slice_qs_delta``
> +      -
> +    * - __u8
> +      - ``disable_deblocking_filter_idc``
> +      -
> +    * - __s8
> +      - ``slice_alpha_c0_offset_div2``
> +      -
> +    * - __s8
> +      - ``slice_beta_offset_div2``
> +      -
> +    * - __u8
> +      - ``num_ref_idx_l0_active_minus1``
> +      -
> +    * - __u8
> +      - ``num_ref_idx_l1_active_minus1``
> +      -
> +    * - __u32
> +      - ``slice_group_change_cycle``
> +      -
> +    * - __u8
> +      - ``ref_pic_list0[32]``
> +      - Reference picture list after applying the per-slic modifications
> +    * - __u8
> +      - ``ref_pic_list1[32]``
> +      - Reference picture list after applying the per-slic modifications

typo: per-slice

> +    * - __u32
> +      - ``flags``
> +      - See :ref:`Slice Parameter Flags <h264_slice_flags>`
> +
> +.. _h264_slice_flags:
> +
> +``Slice Parameter Set Flags``
> +
> +.. cssclass:: longtable
> +
> +.. flat-table::
> +    :header-rows:  0
> +    :stub-columns: 0
> +    :widths:       1 1 2
> +
> +    * - ``V4L2_H264_SLICE_FLAG_FIELD_PIC``
> +      - 0x00000001
> +      -
> +    * - ``V4L2_H264_SLICE_FLAG_BOTTOM_FIELD``
> +      - 0x00000002
> +      -
> +    * - ``V4L2_H264_SLICE_FLAG_DIRECT_SPATIAL_MV_PRED``
> +      - 0x00000004
> +      -
> +    * - ``V4L2_H264_SLICE_FLAG_SP_FOR_SWITCH``
> +      - 0x00000008
> +      -
> +
> +``Prediction Weight Table``
> +
> +    Unless there's a specific comment, refer to the specification for
> +    the documentation of these fields, section 7.4.3.2 "Prediction
> +    Weight Table Semantics".

Ditto.

> +
> +.. c:type:: v4l2_h264_pred_weight_table
> +
> +.. cssclass:: longtable
> +
> +.. flat-table:: struct v4l2_h264_pred_weight_table
> +    :header-rows:  0
> +    :stub-columns: 0
> +    :widths:       1 1 2
> +
> +    * - __u16
> +      - ``luma_log2_weight_denom``
> +      -
> +    * - __u16
> +      - ``chroma_log2_weight_denom``
> +      -
> +    * - struct :c:type:`v4l2_h264_weight_factors`
> +      - ``weight_factors[2]``
> +      - The weight factors at index 0 are the weight factors for the reference
> +        list 0, the one at index 1 for the reference list 1.
> +
> +.. c:type:: v4l2_h264_weight_factors
> +
> +.. cssclass:: longtable
> +
> +.. flat-table:: struct v4l2_h264_weight_factors
> +    :header-rows:  0
> +    :stub-columns: 0
> +    :widths:       1 1 2
> +
> +    * - __s16
> +      - ``luma_weight[32]``
> +      -
> +    * - __s16
> +      - ``luma_offset[32]``
> +      -
> +    * - __s16
> +      - ``chroma_weight[32][2]``
> +      -
> +    * - __s16
> +      - ``chroma_offset[32][2]``
> +      -
> +
> +``V4L2_CID_MPEG_VIDEO_H264_DECODE_PARAMS (struct)``
> +    Specifies the decode parameters (as extracted from the bitstream)
> +    for the associated H264 slice data. This includes the necessary
> +    parameters for configuring a stateless hardware decoding pipeline
> +    for H264.  The bitstream parameters are defined according to
> +    :ref:`h264`. Unless there's a specific comment, refer to the
> +    specification for the documentation of these fields.
> +
> +    .. note::
> +
> +       This compound control is not yet part of the public kernel API and
> +       it is expected to change.
> +
> +.. c:type:: v4l2_ctrl_h264_decode_param
> +
> +.. cssclass:: longtable
> +
> +.. flat-table:: struct v4l2_ctrl_h264_decode_param
> +    :header-rows:  0
> +    :stub-columns: 0
> +    :widths:       1 1 2
> +
> +    * - __u32
> +      - ``num_slices``
> +      - Number of slices needed to decode the current frame
> +    * - __u16
> +      - ``idr_pic_flag``
> +      - Is the picture an IDR picture?

Sounds like this could be made a flag to be consistent with how this
kind of fields are represented in the other structs.

Best regards,
Tomasz
