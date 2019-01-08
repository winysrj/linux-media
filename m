Return-Path: <SRS0=gjtM=PQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69EFCC43444
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 09:53:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1BD3720827
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 09:53:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728278AbfAHJws (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 8 Jan 2019 04:52:48 -0500
Received: from kozue.soulik.info ([108.61.200.231]:41294 "EHLO
        kozue.soulik.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727236AbfAHJwr (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2019 04:52:47 -0500
Received: from misaki.sumomo.pri (unknown [IPv6:2001:470:b30d:2:c604:15ff:0:401])
        by kozue.soulik.info (Postfix) with ESMTPSA id 10F54100F34;
        Tue,  8 Jan 2019 18:53:19 +0900 (JST)
Date:   Tue, 8 Jan 2019 17:52:28 +0800
From:   Randy 'ayaka' Li <ayaka@soulik.info>
To:     Maxime Ripard <maxime.ripard@bootlin.com>
Cc:     hans.verkuil@cisco.com, acourbot@chromium.org,
        sakari.ailus@linux.intel.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        jenskuske@gmail.com, linux-sunxi@googlegroups.com,
        linux-kernel@vger.kernel.org, tfiga@chromium.org,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, posciak@chromium.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Guenter Roeck <groeck@chromium.org>,
        nicolas.dufresne@collabora.com,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v2 1/2] media: uapi: Add H264 low-level decoder API
 compound controls.
Message-ID: <20190108095228.GA5161@misaki.sumomo.pri>
References: <20181115145650.9827-1-maxime.ripard@bootlin.com>
 <20181115145650.9827-2-maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181115145650.9827-2-maxime.ripard@bootlin.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Thu, Nov 15, 2018 at 03:56:49PM +0100, Maxime Ripard wrote:
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
>  Documentation/media/uapi/v4l/biblio.rst       |   9 +
>  .../media/uapi/v4l/extended-controls.rst      | 364 ++++++++++++++++++
>  .../media/uapi/v4l/pixfmt-compressed.rst      |  20 +
>  .../media/uapi/v4l/vidioc-queryctrl.rst       |  30 ++
>  .../media/videodev2.h.rst.exceptions          |   5 +
>  drivers/media/v4l2-core/v4l2-ctrls.c          |  42 ++
>  drivers/media/v4l2-core/v4l2-ioctl.c          |   1 +
>  include/media/v4l2-ctrls.h                    |  10 +
>  include/uapi/linux/v4l2-controls.h            | 166 ++++++++
>  include/uapi/linux/videodev2.h                |  11 +
>  10 files changed, 658 insertions(+)
> 
> diff --git a/Documentation/media/uapi/v4l/biblio.rst b/Documentation/media/uapi/v4l/biblio.rst
> index 386d6cf83e9c..73aeb7ce47d2 100644
> --- a/Documentation/media/uapi/v4l/biblio.rst
> +++ b/Documentation/media/uapi/v4l/biblio.rst
> @@ -115,6 +115,15 @@ ITU BT.1119
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
> index 65a1d873196b..87c0d151577f 100644
> --- a/Documentation/media/uapi/v4l/extended-controls.rst
> +++ b/Documentation/media/uapi/v4l/extended-controls.rst
> @@ -1674,6 +1674,370 @@ enum v4l2_mpeg_video_h264_hierarchical_coding_type -
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
> +    specification for the documentation of these fields.
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
> +      - TODO
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
> +    * - __u8
> +      - ``flags``
> +      - TODO
> +
> +``V4L2_CID_MPEG_VIDEO_H264_PPS (struct)``
> +    Specifies the picture parameter set (as extracted from the
> +    bitstream) for the associated H264 slice data. This includes the
> +    necessary parameters for configuring a stateless hardware decoding
> +    pipeline for H264.  The bitstream parameters are defined according
> +    to :ref:`h264`. Unless there's a specific comment, refer to the
> +    specification for the documentation of these fields.
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
> +    * - __u8
> +      - ``flags``
> +      - TODO
> +
> +``V4L2_CID_MPEG_VIDEO_H264_SCALING_MATRIX (struct)``
> +    Specifies the scaling matrix (as extracted from the bitstream) for
> +    the associated H264 slice data. The bitstream parameters are
> +    defined according to :ref:`h264`. Unless there's a specific
> +    comment, refer to the specification for the documentation of these
> +    fields.
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
> +    specification for the documentation of these fields.
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
> +      -
> +    * - __u8
> +      - ``ref_pic_list0[32]``
> +      -
> +    * - __u8
> +      - ``ref_pic_list1[32]``
> +      -
> +    * - __u8
> +      - ``flags``
> +      - TODO
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
> +    * - __u8
> +      - ``luma_log2_weight_denom``
> +      -
> +    * - __u8
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
> +      -
> +    * - __u8
> +      - ``idr_pic_flag``
> +      -
> +    * - __u8
> +      - ``nal_ref_idc``
> +      -
> +    * - __s32
> +      - ``top_field_order_cnt``
> +      -
> +    * - __s32
> +      - ``bottom_field_order_cnt``
> +      -
> +    * - __u8
> +      - ``ref_pic_list_p0[32]``
> +      -
> +    * - __u8
> +      - ``ref_pic_list_b0[32]``
> +      -
> +    * - __u8
> +      - ``ref_pic_list_b1[32]``
> +      -
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
> +    * - __u8
> +      - ``flags``
> +      -
> +
>  MFC 5.1 MPEG Controls
>  ---------------------
>  
> diff --git a/Documentation/media/uapi/v4l/pixfmt-compressed.rst b/Documentation/media/uapi/v4l/pixfmt-compressed.rst
> index ba0f6c49d9bf..f15fc1c8d479 100644
> --- a/Documentation/media/uapi/v4l/pixfmt-compressed.rst
> +++ b/Documentation/media/uapi/v4l/pixfmt-compressed.rst
> @@ -45,6 +45,26 @@ Compressed Formats
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
> +	``V4L2_CID_MPEG_VIDEO_H264_PPS`` and
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
> index 258f5813f281..38a9c988124c 100644
> --- a/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
> +++ b/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
> @@ -436,6 +436,36 @@ See also the examples in :ref:`control`.
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
> index 1ec425a7c364..99f1bd2bc44c 100644
> --- a/Documentation/media/videodev2.h.rst.exceptions
> +++ b/Documentation/media/videodev2.h.rst.exceptions
> @@ -133,6 +133,11 @@ replace symbol V4L2_CTRL_TYPE_U32 :c:type:`v4l2_ctrl_type`
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
> index b854cceb19dc..e96c453208e8 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -825,6 +825,11 @@ const char *v4l2_ctrl_get_name(u32 id)
>  	case V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING_LAYER:return "H264 Number of HC Layers";
>  	case V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING_LAYER_QP:
>  								return "H264 Set QP Value for HC Layers";
> +	case V4L2_CID_MPEG_VIDEO_H264_SPS:			return "H264 SPS";
> +	case V4L2_CID_MPEG_VIDEO_H264_PPS:			return "H264 PPS";
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
> @@ -1665,6 +1685,13 @@ static int std_validate(const struct v4l2_ctrl *ctrl, u32 idx,
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
> @@ -2245,6 +2272,21 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
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
> index 49103787d19a..aa63f1794272 100644
> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> @@ -1309,6 +1309,7 @@ static void v4l_fill_fmtdesc(struct v4l2_fmtdesc *fmt)
>  		case V4L2_PIX_FMT_H264:		descr = "H.264"; break;
>  		case V4L2_PIX_FMT_H264_NO_SC:	descr = "H.264 (No Start Codes)"; break;
>  		case V4L2_PIX_FMT_H264_MVC:	descr = "H.264 MVC"; break;
> +		case V4L2_PIX_FMT_H264_SLICE:	descr = "H.264 Parsed Slice"; break;
>  		case V4L2_PIX_FMT_H263:		descr = "H.263"; break;
>  		case V4L2_PIX_FMT_MPEG1:	descr = "MPEG-1 ES"; break;
>  		case V4L2_PIX_FMT_MPEG2:	descr = "MPEG-2 ES"; break;
> diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
> index 83ce0593b275..b4ca95710d2d 100644
> --- a/include/media/v4l2-ctrls.h
> +++ b/include/media/v4l2-ctrls.h
> @@ -43,6 +43,11 @@ struct poll_table_struct;
>   * @p_char:			Pointer to a string.
>   * @p_mpeg2_slice_params:	Pointer to a MPEG2 slice parameters structure.
>   * @p_mpeg2_quantization:	Pointer to a MPEG2 quantization data structure.
> + * @p_h264_sps:			Pointer to a struct v4l2_ctrl_h264_sps.
> + * @p_h264_pps:			Pointer to a struct v4l2_ctrl_h264_pps.
> + * @p_h264_scal_mtrx:		Pointer to a struct v4l2_ctrl_h264_scaling_matrix.
> + * @p_h264_slice_param:		Pointer to a struct v4l2_ctrl_h264_slice_param.
> + * @p_h264_decode_param:	Pointer to a struct v4l2_ctrl_h264_decode_param.
>   * @p:				Pointer to a compound value.
>   */
>  union v4l2_ctrl_ptr {
> @@ -54,6 +59,11 @@ union v4l2_ctrl_ptr {
>  	char *p_char;
>  	struct v4l2_ctrl_mpeg2_slice_params *p_mpeg2_slice_params;
>  	struct v4l2_ctrl_mpeg2_quantization *p_mpeg2_quantization;
> +	struct v4l2_ctrl_h264_sps *p_h264_sps;
> +	struct v4l2_ctrl_h264_pps *p_h264_pps;
> +	struct v4l2_ctrl_h264_scaling_matrix *p_h264_scal_mtrx;
> +	struct v4l2_ctrl_h264_slice_param *p_h264_slice_param;
> +	struct v4l2_ctrl_h264_decode_param *p_h264_decode_param;
>  	void *p;
>  };
>  
> diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
> index 76f5322ec543..fb1469ec1b90 100644
> --- a/include/uapi/linux/v4l2-controls.h
> +++ b/include/uapi/linux/v4l2-controls.h
> @@ -50,6 +50,8 @@
>  #ifndef __LINUX_V4L2_CONTROLS_H
>  #define __LINUX_V4L2_CONTROLS_H
>  
> +#include <linux/types.h>
> +
>  /* Control classes */
>  #define V4L2_CTRL_CLASS_USER		0x00980000	/* Old-style 'user' controls */
>  #define V4L2_CTRL_CLASS_MPEG		0x00990000	/* MPEG-compression controls */
> @@ -534,6 +536,12 @@ enum v4l2_mpeg_video_h264_hierarchical_coding_type {
>  };
>  #define V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING_LAYER	(V4L2_CID_MPEG_BASE+381)
>  #define V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING_LAYER_QP	(V4L2_CID_MPEG_BASE+382)
> +#define V4L2_CID_MPEG_VIDEO_H264_SPS		(V4L2_CID_MPEG_BASE+383)
> +#define V4L2_CID_MPEG_VIDEO_H264_PPS		(V4L2_CID_MPEG_BASE+384)
> +#define V4L2_CID_MPEG_VIDEO_H264_SCALING_MATRIX	(V4L2_CID_MPEG_BASE+385)
> +#define V4L2_CID_MPEG_VIDEO_H264_SLICE_PARAMS	(V4L2_CID_MPEG_BASE+386)
> +#define V4L2_CID_MPEG_VIDEO_H264_DECODE_PARAMS	(V4L2_CID_MPEG_BASE+387)
> +
>  #define V4L2_CID_MPEG_VIDEO_MPEG4_I_FRAME_QP	(V4L2_CID_MPEG_BASE+400)
>  #define V4L2_CID_MPEG_VIDEO_MPEG4_P_FRAME_QP	(V4L2_CID_MPEG_BASE+401)
>  #define V4L2_CID_MPEG_VIDEO_MPEG4_B_FRAME_QP	(V4L2_CID_MPEG_BASE+402)
> @@ -1156,4 +1164,162 @@ struct v4l2_ctrl_mpeg2_quantization {
>  	__u8	chroma_non_intra_quantiser_matrix[64];
>  };
>  
> +/* Compounds controls */
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
> +	__s32 offset_for_non_ref_pic;
> +	__s32 offset_for_top_to_bottom_field;
> +	__u16 pic_width_in_mbs_minus1;
> +	__u16 pic_height_in_map_units_minus1;
> +	__u8 flags;
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
> +	__u8 flags;
> +};
> +
> +struct v4l2_ctrl_h264_scaling_matrix {
> +	__u8 scaling_list_4x4[6][16];
> +	__u8 scaling_list_8x8[6][64];
> +};

I wonder which decoder want this.
> +
> +struct v4l2_h264_weight_factors {
> +	__s8 luma_weight[32];
> +	__s8 luma_offset[32];
> +	__s8 chroma_weight[32][2];
> +	__s8 chroma_offset[32][2];
> +};


> +
> +struct v4l2_h264_pred_weight_table {
> +	__u8 luma_log2_weight_denom;
> +	__u8 chroma_log2_weight_denom;
> +	struct v4l2_h264_weight_factors weight_factors[2];
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
> +	__u16 frame_num;
> +	__u16 idr_pic_id;
> +	__u16 pic_order_cnt_lsb;
> +	__s32 delta_pic_order_cnt_bottom;
> +	__s32 delta_pic_order_cnt0;
> +	__s32 delta_pic_order_cnt1;
> +	__u8 redundant_pic_cnt;
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
> +	__u32 slice_group_change_cycle;
> +
> +	__u8 num_ref_idx_l0_active_minus1;
> +	__u8 num_ref_idx_l1_active_minus1;
> +	/*  Entries on each list are indices
> +	 *  into v4l2_ctrl_h264_decode_param.dpb[]. */
> +	__u8 ref_pic_list0[32];
> +	__u8 ref_pic_list1[32];
> +
> +	__u8 flags;
> +};
> +
We need some addtional properties or the Rockchip won't work.
1. u16 idr_pic_id for identifies IDR (instantaneous decoding refresh)
picture
2. u16 ref_pic_mk_len for length of decoded reference picture marking bits
3. u8 poc_length for length of picture order count field in stream

The last two are used for the hardware to skip a part stream.

> +#define V4L2_H264_DPB_ENTRY_FLAG_VALID		0x01
> +#define V4L2_H264_DPB_ENTRY_FLAG_ACTIVE		0x02
> +#define V4L2_H264_DPB_ENTRY_FLAG_LONG_TERM	0x04
> +
> +struct v4l2_h264_dpb_entry {
> +	__u32 tag;
> +	__u16 frame_num;
> +	__u16 pic_num;

Although the long term reference would use picture order count
and short term for frame num, but only one of them is used
for a entry of a dpb.

Besides, for a frame picture frame_num = pic_num * 2,
and frame_num = pic_num * 2 + 1 for a filed.
> +	/* Note that field is indicated by v4l2_buffer.field */
> +	__s32 top_field_order_cnt;
> +	__s32 bottom_field_order_cnt;
> +	__u8 flags; /* V4L2_H264_DPB_ENTRY_FLAG_* */
> +};
> +
> +struct v4l2_ctrl_h264_decode_param {
> +	__u32 num_slices;
> +	__u8 idr_pic_flag;
> +	__u8 nal_ref_idc;
> +	__s32 top_field_order_cnt;
> +	__s32 bottom_field_order_cnt;
> +	__u8 ref_pic_list_p0[32];
> +	__u8 ref_pic_list_b0[32];
> +	__u8 ref_pic_list_b1[32];
I would prefer to keep only two list, list0 and list 1.
Anyway P slice just use the list0 and B would use the both.
> +	struct v4l2_h264_dpb_entry dpb[16];
> +};
> +
>  #endif
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index 173a94d2cbef..dd028e0bf306 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -643,6 +643,7 @@ struct v4l2_pix_format {
>  #define V4L2_PIX_FMT_H264     v4l2_fourcc('H', '2', '6', '4') /* H264 with start codes */
>  #define V4L2_PIX_FMT_H264_NO_SC v4l2_fourcc('A', 'V', 'C', '1') /* H264 without start codes */
>  #define V4L2_PIX_FMT_H264_MVC v4l2_fourcc('M', '2', '6', '4') /* H264 MVC */
> +#define V4L2_PIX_FMT_H264_SLICE v4l2_fourcc('S', '2', '6', '4') /* H264 parsed slices */
>  #define V4L2_PIX_FMT_H263     v4l2_fourcc('H', '2', '6', '3') /* H263          */
>  #define V4L2_PIX_FMT_MPEG1    v4l2_fourcc('M', 'P', 'G', '1') /* MPEG-1 ES     */
>  #define V4L2_PIX_FMT_MPEG2    v4l2_fourcc('M', 'P', 'G', '2') /* MPEG-2 ES     */
> @@ -1631,6 +1632,11 @@ struct v4l2_ext_control {
>  		__u32 __user *p_u32;
>  		struct v4l2_ctrl_mpeg2_slice_params __user *p_mpeg2_slice_params;
>  		struct v4l2_ctrl_mpeg2_quantization __user *p_mpeg2_quantization;
> +		struct v4l2_ctrl_h264_sps __user *p_h264_sps;
> +		struct v4l2_ctrl_h264_pps __user *p_h264_pps;
> +		struct v4l2_ctrl_h264_scaling_matrix __user *p_h264_scal_mtrx;
> +		struct v4l2_ctrl_h264_slice_param __user *p_h264_slice_param;
> +		struct v4l2_ctrl_h264_decode_param __user *p_h264_decode_param;
>  		void __user *ptr;
>  	};
>  } __attribute__ ((packed));
> @@ -1678,6 +1684,11 @@ enum v4l2_ctrl_type {
>  	V4L2_CTRL_TYPE_U32	     = 0x0102,
>  	V4L2_CTRL_TYPE_MPEG2_SLICE_PARAMS = 0x0103,
>  	V4L2_CTRL_TYPE_MPEG2_QUANTIZATION = 0x0104,
> +	V4L2_CTRL_TYPE_H264_SPS      = 0x0105,
> +	V4L2_CTRL_TYPE_H264_PPS      = 0x0106,
> +	V4L2_CTRL_TYPE_H264_SCALING_MATRIX = 0x0107,
> +	V4L2_CTRL_TYPE_H264_SLICE_PARAMS = 0x0108,
> +	V4L2_CTRL_TYPE_H264_DECODE_PARAMS = 0x0109,
>  };
>  
>  /*  Used in the VIDIOC_QUERYCTRL ioctl for querying controls */
