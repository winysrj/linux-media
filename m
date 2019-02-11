Return-Path: <SRS0=8Y7M=QS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1421C282CE
	for <linux-media@archiver.kernel.org>; Mon, 11 Feb 2019 15:16:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 93B17222A7
	for <linux-media@archiver.kernel.org>; Mon, 11 Feb 2019 15:16:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390879AbfBKPQq (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 11 Feb 2019 10:16:46 -0500
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:41254 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730437AbfBKPQp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Feb 2019 10:16:45 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id tDJugIsC9BDyItDJygTcCy; Mon, 11 Feb 2019 16:16:42 +0100
Subject: Re: [PATCH v3 1/2] media: uapi: Add H264 low-level decoder API
 compound controls.
To:     Maxime Ripard <maxime.ripard@bootlin.com>, hans.verkuil@cisco.com,
        acourbot@chromium.org, sakari.ailus@linux.intel.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     tfiga@chromium.org, posciak@chromium.org,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        nicolas.dufresne@collabora.com, jenskuske@gmail.com,
        jernej.skrabec@gmail.com, jonas@kwiboo.se, ezequiel@collabora.com,
        linux-sunxi@googlegroups.com,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Guenter Roeck <groeck@chromium.org>
References: <cover.d3bb4d93da91ed5668025354ee1fca656e7d5b8b.1549895062.git-series.maxime.ripard@bootlin.com>
 <562aefcd53a1a30d034e97f177096d70fb705f2b.1549895062.git-series.maxime.ripard@bootlin.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <716ae1ff-8e62-c723-5b5a-0b018cf6af6a@xs4all.nl>
Date:   Mon, 11 Feb 2019 16:16:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <562aefcd53a1a30d034e97f177096d70fb705f2b.1549895062.git-series.maxime.ripard@bootlin.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfFAu/GnxYrUnFVGlQVVvrQQozVb3j7PMOS/3TV/nk59Y/fYVVsrt9+0Bs4I3316ClEmMm4QtO+pjNOAVi3pahvLIFcSI+OqwHCrGgudOOP1RSsUYxUwd
 P14raKHX+7iEaPgjmZJRb6DCsSROX3mxTIjUXYq+ZMKrXLBpLy+Ia7O6E7aiwSNG8vRwlO0+j3Rp4c7RBSiNL1A5GVinW596KsYMouMkEZ2iysSD1wMMzccD
 awyzj1Qk3Cw0QJEnDTIPJk3EjU4IuziW33LTCabtuieDynTutI0/ZkKhXKErtKg4Xvs3SalzUHrZyfFk49XMGsR8d17ySiKMuHVD9VBH133wfkwlFh3j0YFu
 O9H1hQezA2WDnELbZWF+kHJFuDrxVFY2AlG+vVqRio0s5tHbHMjoip/pJupqIjTprKKNna5qiGDMG+tO3mf8+KDCiTqPqD+7K57++hNc456hng8LN2R4qw88
 75hDtg+/7CByvHtJ9Ww5brfsnEGbyUrRFu6ha49QczJk3tdrWswJYY0aLiUmkUs/n5JNBn+klkYgVy+ib2o5X61K5lNTtcglDJ9Hh1RB8Or9aHUn9Vfpnlhy
 3rVqpcZnCM8yoCuS9QXilXci3Be25b3K4JBgGyVTXExN4A9A4hTOxxb6Nz2FeeBbbD8D64FFi3DSp3JVzekQTAEuwYxnGNcPcjWT83P4sS3FCRhmPYWs4z1i
 6MsBjiNW3zK53tIFcNunFBZEHYGYrOyDpwIHHkqMOaLg1IvwJlwRGebcmhakJKXBq55vq4TBIdYcUxW6fKOjCIrlOKDPuvuon97Pr4h7mENB619hepRXnNmV
 pn8QLJFblLxSSCk2bW7hKp2SE63l0ZiMFPESw8+u/EG13BFEXR1oKQLchSFJ5Q==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Maxime,

A quick review below. Note that I am no expert on the codec details, so
I leave that to others. I'm mainly concentrating on the structs, flags, etc.

On 2/11/19 3:39 PM, Maxime Ripard wrote:
> From: Pawel Osciak <posciak@chromium.org>
> 
> Stateless video codecs will require both the H264 metadata and slices in
> order to be able to decode frames.
> 
> This introduces the definitions for a new pixel format for H264 slices that
> have been parsed, as well as the structures used to pass the metadata from
> the userspace to the kernel.
> 
> Co-Developed-by: Maxime Ripard <maxime.ripard@bootlin.com>
> Signed-off-by: Pawel Osciak <posciak@chromium.org>
> Signed-off-by: Guenter Roeck <groeck@chromium.org>
> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> ---
>  Documentation/media/uapi/v4l/biblio.rst            |   9 +-
>  Documentation/media/uapi/v4l/extended-controls.rst | 530 ++++++++++++++-
>  Documentation/media/uapi/v4l/pixfmt-compressed.rst |  20 +-
>  Documentation/media/uapi/v4l/vidioc-queryctrl.rst  |  30 +-
>  Documentation/media/videodev2.h.rst.exceptions     |   5 +-
>  drivers/media/v4l2-core/v4l2-ctrls.c               |  42 +-
>  drivers/media/v4l2-core/v4l2-ioctl.c               |   1 +-
>  include/media/h264-ctrls.h                         | 179 +++++-
>  include/media/v4l2-ctrls.h                         |  13 +-
>  include/uapi/linux/videodev2.h                     |   1 +-
>  10 files changed, 829 insertions(+), 1 deletion(-)
>  create mode 100644 include/media/h264-ctrls.h
> 
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
> diff --git a/Documentation/media/uapi/v4l/extended-controls.rst b/Documentation/media/uapi/v4l/extended-controls.rst
> index af4273aa5e85..7e306aa0d0a6 100644
> --- a/Documentation/media/uapi/v4l/extended-controls.rst
> +++ b/Documentation/media/uapi/v4l/extended-controls.rst
> @@ -1703,6 +1703,536 @@ enum v4l2_mpeg_video_h264_hierarchical_coding_type -
>  	non-intra-coded frames, in zigzag scanning order. Only relevant for
>  	non-4:2:0 YUV formats.
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
> +
> +    .. note::
> +
> +       This compound control is not yet part of the public kernel API and
> +       it is expected to change.
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
> +    * - __u8
> +      - ``redundant_pic_cnt``

This should be moved to just before 'frame_num' as per the actual struct.

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
> +    * - __u32
> +      - ``slice_group_change_cycle``
> +      -
> +    * - __u8
> +      - ``num_ref_idx_l0_active_minus1``
> +      -
> +    * - __u8
> +      - ``num_ref_idx_l1_active_minus1``

These two fields should be moved to just before the slice_group_change_cycle
field as per the actual struct.

> +      -
> +    * - __u8
> +      - ``ref_pic_list0[32]``
> +      -
> +    * - __u8
> +      - ``ref_pic_list1[32]``
> +      -
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
> +      -
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
> +    * - __s8
> +      - ``luma_weight[32]``
> +      -
> +    * - __s8
> +      - ``luma_offset[32]``
> +      -
> +    * - __s8
> +      - ``chroma_weight[32][2]``
> +      -
> +    * - __s8
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
> +    * - __u16
> +      - ``nal_ref_idc``
> +      - NAL reference ID value coming from the NAL Unit header
> +    * - __s32
> +      - ``top_field_order_cnt``
> +      - Picture Order Count for the coded top field
> +    * - __s32
> +      - ``bottom_field_order_cnt``
> +      - Picture Order Count for the coded bottom field
> +    * - struct :c:type:`v4l2_h264_dpb_entry`
> +      - ``dpb[16]``
> +      -
> +
> +.. c:type:: v4l2_h264_dpb_entry
> +
> +.. cssclass:: longtable
> +
> +.. flat-table:: struct v4l2_h264_dpb_entry
> +    :header-rows:  0
> +    :stub-columns: 0
> +    :widths:       1 1 2
> +
> +    * - __u32
> +      - ``tag``
> +      - tag to identify the buffer containing the reference frame

This is outdated: it's a __u64 timestamp.

You can copy the struct backward_ref_ts documentation from struct
v4l2_ctrl_mpeg2_slice_params and edit it a bit for H.264.

> +    * - __u16
> +      - ``frame_num``
> +      -
> +    * - __u16
> +      - ``pic_num``
> +      -
> +    * - __s32
> +      - ``top_field_order_cnt``
> +      -
> +    * - __s32
> +      - ``bottom_field_order_cnt``
> +      -
> +    * - __u32
> +      - ``flags``
> +      - See :ref:`DPB Entry Flags <h264_dpb_flags>`
> +
> +.. _h264_dpb_flags:
> +
> +``DPB Entries Flags``
> +
> +.. cssclass:: longtable
> +
> +.. flat-table::
> +    :header-rows:  0
> +    :stub-columns: 0
> +    :widths:       1 1 2
> +
> +    * - ``V4L2_H264_DPB_ENTRY_FLAG_VALID``
> +      - 0x00000001
> +      -
> +    * - ``V4L2_H264_DPB_ENTRY_FLAG_ACTIVE``
> +      - 0x00000002
> +      -
> +
>  MFC 5.1 MPEG Controls
>  ---------------------
>  
> diff --git a/Documentation/media/uapi/v4l/pixfmt-compressed.rst b/Documentation/media/uapi/v4l/pixfmt-compressed.rst
> index e4c5e456df59..95905b967693 100644
> --- a/Documentation/media/uapi/v4l/pixfmt-compressed.rst
> +++ b/Documentation/media/uapi/v4l/pixfmt-compressed.rst
> @@ -52,6 +52,26 @@ Compressed Formats
>        - ``V4L2_PIX_FMT_H264_MVC``
>        - 'M264'
>        - H264 MVC video elementary stream.
> +    * .. _V4L2-PIX-FMT-H264-SLICE:
> +
> +      - ``V4L2_PIX_FMT_H264_SLICE``
> +      - 'S264'
> +      - H264 parsed slice data, as extracted from the H264 bitstream.
> +	This format is adapted for stateless video decoders that
> +	implement an H264 pipeline (using the :ref:`codec` and
> +	:ref:`media-request-api`).  Metadata associated with the frame
> +	to decode are required to be passed through the
> +	``V4L2_CID_MPEG_VIDEO_H264_SPS``,
> +	``V4L2_CID_MPEG_VIDEO_H264_PPS``,
> +	``V4L2_CID_MPEG_VIDEO_H264_SLICE_PARAMS`` and
> +	``V4L2_CID_MPEG_VIDEO_H264_DECODE_PARAMS`` controls and
> +	scaling matrices can optionally be specified through the
> +	``V4L2_CID_MPEG_VIDEO_H264_SCALING_MATRIX`` control.  See the
> +	:ref:`associated Codec Control IDs <v4l2-mpeg-h264>`.
> +	Exactly one output and one capture buffer must be provided for
> +	use with this pixel format. The output buffer must contain the
> +	appropriate number of macroblocks to decode a full
> +	corresponding frame to the matching capture buffer.
>      * .. _V4L2-PIX-FMT-H263:
>  
>        - ``V4L2_PIX_FMT_H263``
> diff --git a/Documentation/media/uapi/v4l/vidioc-queryctrl.rst b/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
> index f824162d0ea9..bf29dc5b9758 100644
> --- a/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
> +++ b/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
> @@ -443,6 +443,36 @@ See also the examples in :ref:`control`.
>        - n/a
>        - A struct :c:type:`v4l2_ctrl_mpeg2_quantization`, containing MPEG-2
>  	quantization matrices for stateless video decoders.
> +    * - ``V4L2_CTRL_TYPE_H264_SPS``
> +      - n/a
> +      - n/a
> +      - n/a
> +      - A struct :c:type:`v4l2_ctrl_h264_sps`, containing H264
> +	sequence parameters for stateless video decoders.
> +    * - ``V4L2_CTRL_TYPE_H264_PPS``
> +      - n/a
> +      - n/a
> +      - n/a
> +      - A struct :c:type:`v4l2_ctrl_h264_pps`, containing H264
> +	picture parameters for stateless video decoders.
> +    * - ``V4L2_CTRL_TYPE_H264_SCALING_MATRIX``
> +      - n/a
> +      - n/a
> +      - n/a
> +      - A struct :c:type:`v4l2_ctrl_h264_scaling_matrix`, containing H264
> +	scaling matrices for stateless video decoders.
> +    * - ``V4L2_CTRL_TYPE_H264_SLICE_PARAMS``
> +      - n/a
> +      - n/a
> +      - n/a
> +      - A struct :c:type:`v4l2_ctrl_h264_slice_param`, containing H264
> +	slice parameters for stateless video decoders.
> +    * - ``V4L2_CTRL_TYPE_H264_DECODE_PARAMS``
> +      - n/a
> +      - n/a
> +      - n/a
> +      - A struct :c:type:`v4l2_ctrl_h264_decode_param`, containing H264
> +	decode parameters for stateless video decoders.
>  
>  .. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
>  
> diff --git a/Documentation/media/videodev2.h.rst.exceptions b/Documentation/media/videodev2.h.rst.exceptions
> index 64d348e67df9..55cbe324b9fc 100644
> --- a/Documentation/media/videodev2.h.rst.exceptions
> +++ b/Documentation/media/videodev2.h.rst.exceptions
> @@ -136,6 +136,11 @@ replace symbol V4L2_CTRL_TYPE_U32 :c:type:`v4l2_ctrl_type`
>  replace symbol V4L2_CTRL_TYPE_U8 :c:type:`v4l2_ctrl_type`
>  replace symbol V4L2_CTRL_TYPE_MPEG2_SLICE_PARAMS :c:type:`v4l2_ctrl_type`
>  replace symbol V4L2_CTRL_TYPE_MPEG2_QUANTIZATION :c:type:`v4l2_ctrl_type`
> +replace symbol V4L2_CTRL_TYPE_H264_SPS :c:type:`v4l2_ctrl_type`
> +replace symbol V4L2_CTRL_TYPE_H264_PPS :c:type:`v4l2_ctrl_type`
> +replace symbol V4L2_CTRL_TYPE_H264_SCALING_MATRIX :c:type:`v4l2_ctrl_type`
> +replace symbol V4L2_CTRL_TYPE_H264_SLICE_PARAMS :c:type:`v4l2_ctrl_type`
> +replace symbol V4L2_CTRL_TYPE_H264_DECODE_PARAMS :c:type:`v4l2_ctrl_type`
>  
>  # V4L2 capability defines
>  replace define V4L2_CAP_VIDEO_CAPTURE device-capabilities
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
> index e3bd441fa29a..fe9f9447caba 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -825,6 +825,11 @@ const char *v4l2_ctrl_get_name(u32 id)
>  	case V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING_LAYER:return "H264 Number of HC Layers";
>  	case V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING_LAYER_QP:
>  								return "H264 Set QP Value for HC Layers";
> +	case V4L2_CID_MPEG_VIDEO_H264_SPS:			return "H264 Sequence Parameter Set";
> +	case V4L2_CID_MPEG_VIDEO_H264_PPS:			return "H264 Picture Parameter Set";
> +	case V4L2_CID_MPEG_VIDEO_H264_SCALING_MATRIX:		return "H264 Scaling Matrix";
> +	case V4L2_CID_MPEG_VIDEO_H264_SLICE_PARAMS:		return "H264 Slice Parameters";
> +	case V4L2_CID_MPEG_VIDEO_H264_DECODE_PARAMS:		return "H264 Decode Parameters";
>  	case V4L2_CID_MPEG_VIDEO_MPEG4_I_FRAME_QP:		return "MPEG4 I-Frame QP Value";
>  	case V4L2_CID_MPEG_VIDEO_MPEG4_P_FRAME_QP:		return "MPEG4 P-Frame QP Value";
>  	case V4L2_CID_MPEG_VIDEO_MPEG4_B_FRAME_QP:		return "MPEG4 B-Frame QP Value";
> @@ -1300,6 +1305,21 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
>  	case V4L2_CID_MPEG_VIDEO_MPEG2_QUANTIZATION:
>  		*type = V4L2_CTRL_TYPE_MPEG2_QUANTIZATION;
>  		break;
> +	case V4L2_CID_MPEG_VIDEO_H264_SPS:
> +		*type = V4L2_CTRL_TYPE_H264_SPS;
> +		break;
> +	case V4L2_CID_MPEG_VIDEO_H264_PPS:
> +		*type = V4L2_CTRL_TYPE_H264_PPS;
> +		break;
> +	case V4L2_CID_MPEG_VIDEO_H264_SCALING_MATRIX:
> +		*type = V4L2_CTRL_TYPE_H264_SCALING_MATRIX;
> +		break;
> +	case V4L2_CID_MPEG_VIDEO_H264_SLICE_PARAMS:
> +		*type = V4L2_CTRL_TYPE_H264_SLICE_PARAMS;
> +		break;
> +	case V4L2_CID_MPEG_VIDEO_H264_DECODE_PARAMS:
> +		*type = V4L2_CTRL_TYPE_H264_DECODE_PARAMS;
> +		break;
>  	default:
>  		*type = V4L2_CTRL_TYPE_INTEGER;
>  		break;
> @@ -1666,6 +1686,13 @@ static int std_validate(const struct v4l2_ctrl *ctrl, u32 idx,
>  	case V4L2_CTRL_TYPE_MPEG2_QUANTIZATION:
>  		return 0;
>  
> +	case V4L2_CTRL_TYPE_H264_SPS:
> +	case V4L2_CTRL_TYPE_H264_PPS:
> +	case V4L2_CTRL_TYPE_H264_SCALING_MATRIX:
> +	case V4L2_CTRL_TYPE_H264_SLICE_PARAMS:
> +	case V4L2_CTRL_TYPE_H264_DECODE_PARAMS:
> +		return 0;
> +
>  	default:
>  		return -EINVAL;
>  	}
> @@ -2246,6 +2273,21 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
>  	case V4L2_CTRL_TYPE_MPEG2_QUANTIZATION:
>  		elem_size = sizeof(struct v4l2_ctrl_mpeg2_quantization);
>  		break;
> +	case V4L2_CTRL_TYPE_H264_SPS:
> +		elem_size = sizeof(struct v4l2_ctrl_h264_sps);
> +		break;
> +	case V4L2_CTRL_TYPE_H264_PPS:
> +		elem_size = sizeof(struct v4l2_ctrl_h264_pps);
> +		break;
> +	case V4L2_CTRL_TYPE_H264_SCALING_MATRIX:
> +		elem_size = sizeof(struct v4l2_ctrl_h264_scaling_matrix);
> +		break;
> +	case V4L2_CTRL_TYPE_H264_SLICE_PARAMS:
> +		elem_size = sizeof(struct v4l2_ctrl_h264_slice_param);
> +		break;
> +	case V4L2_CTRL_TYPE_H264_DECODE_PARAMS:
> +		elem_size = sizeof(struct v4l2_ctrl_h264_decode_param);
> +		break;
>  	default:
>  		if (type < V4L2_CTRL_COMPOUND_TYPES)
>  			elem_size = sizeof(s32);
> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
> index 1441a73ce64c..f42d6e7049eb 100644
> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> @@ -1313,6 +1313,7 @@ static void v4l_fill_fmtdesc(struct v4l2_fmtdesc *fmt)
>  		case V4L2_PIX_FMT_H264:		descr = "H.264"; break;
>  		case V4L2_PIX_FMT_H264_NO_SC:	descr = "H.264 (No Start Codes)"; break;
>  		case V4L2_PIX_FMT_H264_MVC:	descr = "H.264 MVC"; break;
> +		case V4L2_PIX_FMT_H264_SLICE:	descr = "H.264 Parsed Slice Data"; break;
>  		case V4L2_PIX_FMT_H263:		descr = "H.263"; break;
>  		case V4L2_PIX_FMT_MPEG1:	descr = "MPEG-1 ES"; break;
>  		case V4L2_PIX_FMT_MPEG2:	descr = "MPEG-2 ES"; break;
> diff --git a/include/media/h264-ctrls.h b/include/media/h264-ctrls.h
> new file mode 100644
> index 000000000000..7b0563dfa05f
> --- /dev/null
> +++ b/include/media/h264-ctrls.h
> @@ -0,0 +1,179 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * These are the H.264 state controls for use with stateless H.264
> + * codec drivers.
> + *
> + * It turns out that these structs are not stable yet and will undergo
> + * more changes. So keep them private until they are stable and ready to
> + * become part of the official public API.
> + */
> +
> +#ifndef _H264_CTRLS_H_
> +#define _H264_CTRLS_H_
> +
> +#define V4L2_CID_MPEG_VIDEO_H264_SPS		(V4L2_CID_MPEG_BASE+383)
> +#define V4L2_CID_MPEG_VIDEO_H264_PPS		(V4L2_CID_MPEG_BASE+384)
> +#define V4L2_CID_MPEG_VIDEO_H264_SCALING_MATRIX	(V4L2_CID_MPEG_BASE+385)
> +#define V4L2_CID_MPEG_VIDEO_H264_SLICE_PARAMS	(V4L2_CID_MPEG_BASE+386)
> +#define V4L2_CID_MPEG_VIDEO_H264_DECODE_PARAMS	(V4L2_CID_MPEG_BASE+387)
> +
> +/* enum v4l2_ctrl_type type values */
> +#define V4L2_CTRL_TYPE_H264_SPS 0x0105
> +#define	V4L2_CTRL_TYPE_H264_PPS 0x0106
> +#define	V4L2_CTRL_TYPE_H264_SCALING_MATRIX 0x0107
> +#define	V4L2_CTRL_TYPE_H264_SLICE_PARAMS 0x0108
> +#define	V4L2_CTRL_TYPE_H264_DECODE_PARAMS 0x0109
> +
> +#define V4L2_H264_SPS_CONSTRAINT_SET0_FLAG			0x01
> +#define V4L2_H264_SPS_CONSTRAINT_SET1_FLAG			0x02
> +#define V4L2_H264_SPS_CONSTRAINT_SET2_FLAG			0x04
> +#define V4L2_H264_SPS_CONSTRAINT_SET3_FLAG			0x08
> +#define V4L2_H264_SPS_CONSTRAINT_SET4_FLAG			0x10
> +#define V4L2_H264_SPS_CONSTRAINT_SET5_FLAG			0x20
> +
> +#define V4L2_H264_SPS_FLAG_SEPARATE_COLOUR_PLANE		0x01
> +#define V4L2_H264_SPS_FLAG_QPPRIME_Y_ZERO_TRANSFORM_BYPASS	0x02
> +#define V4L2_H264_SPS_FLAG_DELTA_PIC_ORDER_ALWAYS_ZERO		0x04
> +#define V4L2_H264_SPS_FLAG_GAPS_IN_FRAME_NUM_VALUE_ALLOWED	0x08
> +#define V4L2_H264_SPS_FLAG_FRAME_MBS_ONLY			0x10
> +#define V4L2_H264_SPS_FLAG_MB_ADAPTIVE_FRAME_FIELD		0x20
> +#define V4L2_H264_SPS_FLAG_DIRECT_8X8_INFERENCE			0x40
> +
> +struct v4l2_ctrl_h264_sps {
> +	__u8 profile_idc;
> +	__u8 constraint_set_flags;
> +	__u8 level_idc;
> +	__u8 seq_parameter_set_id;
> +	__u8 chroma_format_idc;
> +	__u8 bit_depth_luma_minus8;
> +	__u8 bit_depth_chroma_minus8;
> +	__u8 log2_max_frame_num_minus4;
> +	__u8 pic_order_cnt_type;
> +	__u8 log2_max_pic_order_cnt_lsb_minus4;
> +	__u8 max_num_ref_frames;
> +	__u8 num_ref_frames_in_pic_order_cnt_cycle;
> +	__s32 offset_for_ref_frame[255];

Where does 255 come from? Should this be a define?

If this is not based on the standard but instead a driver limitation, then
I think that should be documented. In that case I assume that if more is needed
in the future, then that will be done through additional controls.

> +	__s32 offset_for_non_ref_pic;
> +	__s32 offset_for_top_to_bottom_field;
> +	__u16 pic_width_in_mbs_minus1;
> +	__u16 pic_height_in_map_units_minus1;
> +	__u32 flags;
> +};
> +
> +#define V4L2_H264_PPS_FLAG_ENTROPY_CODING_MODE				0x0001
> +#define V4L2_H264_PPS_FLAG_BOTTOM_FIELD_PIC_ORDER_IN_FRAME_PRESENT	0x0002
> +#define V4L2_H264_PPS_FLAG_WEIGHTED_PRED				0x0004
> +#define V4L2_H264_PPS_FLAG_DEBLOCKING_FILTER_CONTROL_PRESENT		0x0008
> +#define V4L2_H264_PPS_FLAG_CONSTRAINED_INTRA_PRED			0x0010
> +#define V4L2_H264_PPS_FLAG_REDUNDANT_PIC_CNT_PRESENT			0x0020
> +#define V4L2_H264_PPS_FLAG_TRANSFORM_8X8_MODE				0x0040
> +#define V4L2_H264_PPS_FLAG_PIC_SCALING_MATRIX_PRESENT			0x0080
> +
> +struct v4l2_ctrl_h264_pps {
> +	__u8 pic_parameter_set_id;
> +	__u8 seq_parameter_set_id;
> +	__u8 num_slice_groups_minus1;
> +	__u8 num_ref_idx_l0_default_active_minus1;
> +	__u8 num_ref_idx_l1_default_active_minus1;
> +	__u8 weighted_bipred_idc;
> +	__s8 pic_init_qp_minus26;
> +	__s8 pic_init_qs_minus26;
> +	__s8 chroma_qp_index_offset;
> +	__s8 second_chroma_qp_index_offset;
> +	__u16 flags;
> +};
> +
> +struct v4l2_ctrl_h264_scaling_matrix {
> +	__u8 scaling_list_4x4[6][16];
> +	__u8 scaling_list_8x8[6][64];
> +};
> +
> +struct v4l2_h264_weight_factors {
> +	__s8 luma_weight[32];
> +	__s8 luma_offset[32];
> +	__s8 chroma_weight[32][2];
> +	__s8 chroma_offset[32][2];

Same question here.

> +};
> +
> +struct v4l2_h264_pred_weight_table {
> +	__u16 luma_log2_weight_denom;
> +	__u16 chroma_log2_weight_denom;
> +	struct v4l2_h264_weight_factors weight_factors[2];

I assume [0] is for luma and [1] is for chroma? Should be documented.

> +};
> +
> +#define V4L2_H264_SLICE_TYPE_P				0
> +#define V4L2_H264_SLICE_TYPE_B				1
> +#define V4L2_H264_SLICE_TYPE_I				2
> +#define V4L2_H264_SLICE_TYPE_SP				3
> +#define V4L2_H264_SLICE_TYPE_SI				4
> +
> +#define V4L2_H264_SLICE_FLAG_FIELD_PIC			0x01
> +#define V4L2_H264_SLICE_FLAG_BOTTOM_FIELD		0x02
> +#define V4L2_H264_SLICE_FLAG_DIRECT_SPATIAL_MV_PRED	0x04
> +#define V4L2_H264_SLICE_FLAG_SP_FOR_SWITCH		0x08
> +
> +struct v4l2_ctrl_h264_slice_param {
> +	/* Size in bytes, including header */
> +	__u32 size;
> +	/* Offset in bits to slice_data() from the beginning of this slice. */
> +	__u32 header_bit_size;
> +
> +	__u16 first_mb_in_slice;
> +	__u8 slice_type;
> +	__u8 pic_parameter_set_id;
> +	__u8 colour_plane_id;
> +	__u8 redundant_pic_cnt;
> +	__u16 frame_num;
> +	__u16 idr_pic_id;
> +	__u16 pic_order_cnt_lsb;
> +	__s32 delta_pic_order_cnt_bottom;
> +	__s32 delta_pic_order_cnt0;
> +	__s32 delta_pic_order_cnt1;
> +
> +	struct v4l2_h264_pred_weight_table pred_weight_table;
> +	/* Size in bits of dec_ref_pic_marking() syntax element. */
> +	__u32 dec_ref_pic_marking_bit_size;
> +	/* Size in bits of pic order count syntax. */
> +	__u32 pic_order_cnt_bit_size;
> +
> +	__u8 cabac_init_idc;
> +	__s8 slice_qp_delta;
> +	__s8 slice_qs_delta;
> +	__u8 disable_deblocking_filter_idc;
> +	__s8 slice_alpha_c0_offset_div2;
> +	__s8 slice_beta_offset_div2;
> +	__u8 num_ref_idx_l0_active_minus1;
> +	__u8 num_ref_idx_l1_active_minus1;
> +	__u32 slice_group_change_cycle;
> +
> +	/*  Entries on each list are indices
> +	 *  into v4l2_ctrl_h264_decode_param.dpb[]. */
> +	__u8 ref_pic_list0[32];
> +	__u8 ref_pic_list1[32];

Where does 32 come from?

> +
> +	__u32 flags;
> +};
> +
> +#define V4L2_H264_DPB_ENTRY_FLAG_VALID		0x01
> +#define V4L2_H264_DPB_ENTRY_FLAG_ACTIVE		0x02
> +
> +struct v4l2_h264_dpb_entry {
> +	__u64 timestamp;
> +	__u16 frame_num;
> +	__u16 pic_num;
> +	/* Note that field is indicated by v4l2_buffer.field */
> +	__s32 top_field_order_cnt;
> +	__s32 bottom_field_order_cnt;
> +	__u32 flags; /* V4L2_H264_DPB_ENTRY_FLAG_* */
> +};
> +
> +struct v4l2_ctrl_h264_decode_param {
> +	__u32 num_slices;
> +	__u16 idr_pic_flag;
> +	__u16 nal_ref_idc;
> +	__s32 top_field_order_cnt;
> +	__s32 bottom_field_order_cnt;
> +	struct v4l2_h264_dpb_entry dpb[16];

And 16?

Nothing special needs to be done for those constants that are based on the
standard. But if it isn't part of the standard but a driver constraint, then
that should be documented, and there should be an idea on how it can be
extended for future drivers without that constraint.

I think the API should be designed with 4k video in mind. So if some of
these constants would be too small when dealing with 4k (even if the
current HW doesn't support this yet), then these constants would have to
be increased.

And yes, I know 8k video is starting to appear, but I think it is OK
that additional control(s) would be needed to support 8k.

> +};
> +
> +#endif
> diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
> index d63cf227b0ab..22b6d09c4764 100644
> --- a/include/media/v4l2-ctrls.h
> +++ b/include/media/v4l2-ctrls.h
> @@ -23,10 +23,11 @@
>  #include <media/media-request.h>
>  
>  /*
> - * Include the mpeg2 stateless codec compound control definitions.
> + * Include the stateless codec compound control definitions.
>   * This will move to the public headers once this API is fully stable.
>   */
>  #include <media/mpeg2-ctrls.h>
> +#include <media/h264-ctrls.h>
>  
>  /* forward references */
>  struct file;
> @@ -49,6 +50,11 @@ struct poll_table_struct;
>   * @p_char:			Pointer to a string.
>   * @p_mpeg2_slice_params:	Pointer to a MPEG2 slice parameters structure.
>   * @p_mpeg2_quantization:	Pointer to a MPEG2 quantization data structure.
> + * @p_h264_sps:			Pointer to a struct v4l2_ctrl_h264_sps.
> + * @p_h264_pps:			Pointer to a struct v4l2_ctrl_h264_pps.
> + * @p_h264_scaling_matrix:	Pointer to a struct v4l2_ctrl_h264_scaling_matrix.
> + * @p_h264_slice_param:		Pointer to a struct v4l2_ctrl_h264_slice_param.
> + * @p_h264_decode_param:	Pointer to a struct v4l2_ctrl_h264_decode_param.
>   * @p:				Pointer to a compound value.
>   */
>  union v4l2_ctrl_ptr {
> @@ -60,6 +66,11 @@ union v4l2_ctrl_ptr {
>  	char *p_char;
>  	struct v4l2_ctrl_mpeg2_slice_params *p_mpeg2_slice_params;
>  	struct v4l2_ctrl_mpeg2_quantization *p_mpeg2_quantization;
> +	struct v4l2_ctrl_h264_sps *p_h264_sps;
> +	struct v4l2_ctrl_h264_pps *p_h264_pps;
> +	struct v4l2_ctrl_h264_scaling_matrix *p_h264_scaling_matrix;
> +	struct v4l2_ctrl_h264_slice_param *p_h264_slice_param;
> +	struct v4l2_ctrl_h264_decode_param *p_h264_decode_param;
>  	void *p;
>  };
>  
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index d6eed479c3a6..6fc955926bdb 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -645,6 +645,7 @@ struct v4l2_pix_format {
>  #define V4L2_PIX_FMT_H264     v4l2_fourcc('H', '2', '6', '4') /* H264 with start codes */
>  #define V4L2_PIX_FMT_H264_NO_SC v4l2_fourcc('A', 'V', 'C', '1') /* H264 without start codes */
>  #define V4L2_PIX_FMT_H264_MVC v4l2_fourcc('M', '2', '6', '4') /* H264 MVC */
> +#define V4L2_PIX_FMT_H264_SLICE v4l2_fourcc('S', '2', '6', '4') /* H264 parsed slices */
>  #define V4L2_PIX_FMT_H263     v4l2_fourcc('H', '2', '6', '3') /* H263          */
>  #define V4L2_PIX_FMT_MPEG1    v4l2_fourcc('M', 'P', 'G', '1') /* MPEG-1 ES     */
>  #define V4L2_PIX_FMT_MPEG2    v4l2_fourcc('M', 'P', 'G', '2') /* MPEG-2 ES     */
> 

Regards,

	Hans
