Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52439 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731571AbeK1EVv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Nov 2018 23:21:51 -0500
From: Jernej =?utf-8?B?xaBrcmFiZWM=?= <jernej.skrabec@gmail.com>
To: linux-sunxi@googlegroups.com, maxime.ripard@bootlin.com
Cc: hans.verkuil@cisco.com, acourbot@chromium.org,
        sakari.ailus@linux.intel.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        tfiga@chromium.org, posciak@chromium.org,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        nicolas.dufresne@collabora.com, jenskuske@gmail.com,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Guenter Roeck <groeck@chromium.org>
Subject: Re: [linux-sunxi] [PATCH v2 1/2] media: uapi: Add H264 low-level decoder API compound controls.
Date: Tue, 27 Nov 2018 18:23:10 +0100
Message-ID: <2123591.3TCVFQjlgd@jernej-laptop>
In-Reply-To: <20181115145650.9827-2-maxime.ripard@bootlin.com>
References: <20181115145650.9827-1-maxime.ripard@bootlin.com> <20181115145650.9827-2-maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

Dne =C4=8Detrtek, 15. november 2018 ob 15:56:49 CET je Maxime Ripard napisa=
l(a):
> From: Pawel Osciak <posciak@chromium.org>
>=20
> Stateless video codecs will require both the H264 metadata and slices in
> order to be able to decode frames.
>=20
> This introduces the definitions for a new pixel format for H264 slices th=
at
> have been parsed, as well as the structures used to pass the metadata from
> the userspace to the kernel.
>=20
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
>=20

<snip>

> @@ -1156,4 +1164,162 @@ struct v4l2_ctrl_mpeg2_quantization {
>  	__u8	chroma_non_intra_quantiser_matrix[64];
>  };
>=20
> +/* Compounds controls */
> +
> +#define V4L2_H264_SPS_CONSTRAINT_SET0_FLAG			0x01
> +#define V4L2_H264_SPS_CONSTRAINT_SET1_FLAG			0x02
> +#define V4L2_H264_SPS_CONSTRAINT_SET2_FLAG			0x04
> +#define V4L2_H264_SPS_CONSTRAINT_SET3_FLAG			0x08
> +#define V4L2_H264_SPS_CONSTRAINT_SET4_FLAG			0x10
> +#define V4L2_H264_SPS_CONSTRAINT_SET5_FLAG			0x20

How are these constraint flags meant to be used?

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
> +
> +struct v4l2_h264_weight_factors {
> +	__s8 luma_weight[32];
> +	__s8 luma_offset[32];
> +	__s8 chroma_weight[32][2];
> +	__s8 chroma_offset[32][2];
> +};

Regarding weight type __s8 - isn't too small just a bit?

ITU-T Rec. H264 (05/2003) says that this field has value between -128 to 12=
7 if=20
weight flag is set. That fits perfectly. However, when weight flag is 0, de=
fault=20
value is 2^luma_log2_weight_denom (for example). luma_log2_weight_denom can=
=20
have values between 0 and 7, which means that weight will have values from =
1=20
to 128. That is just slightly over the max value for __s8.

__s8 is fine for offsets, though.

Best regards,
Jernej

> +
> +struct v4l2_h264_pred_weight_table {
> +	__u8 luma_log2_weight_denom;
> +	__u8 chroma_log2_weight_denom;
> +	struct v4l2_h264_weight_factors weight_factors[2];
> +};
