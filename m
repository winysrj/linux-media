Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:54560 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726753AbeHDPbI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 4 Aug 2018 11:31:08 -0400
Subject: Re: [PATCH v6 1/8] media: v4l: Add definitions for MPEG2 slice format
 and metadata
To: Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devel@driverdev.osuosl.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        linux-sunxi@googlegroups.com,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Randy Li <ayaka@soulik.info>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
References: <20180725100256.22833-1-paul.kocialkowski@bootlin.com>
 <20180725100256.22833-2-paul.kocialkowski@bootlin.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <57d8c895-ad9f-5105-e923-9666fdf909d9@xs4all.nl>
Date: Sat, 4 Aug 2018 15:30:18 +0200
MIME-Version: 1.0
In-Reply-To: <20180725100256.22833-2-paul.kocialkowski@bootlin.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/25/2018 12:02 PM, Paul Kocialkowski wrote:
> Stateless video decoding engines require both the MPEG slices and
> associated metadata from the video stream in order to decode frames.
> 
> This introduces definitions for a new pixel format, describing buffers
> with MPEG2 slice data, as well as a control structure for passing the
> frame metadata to drivers.
> 
> This is based on work from both Florent Revest and Hugues Fruchet.
> 
> Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> ---
>  .../media/uapi/v4l/extended-controls.rst      | 122 ++++++++++++++++++
>  .../media/uapi/v4l/pixfmt-compressed.rst      |   5 +
>  drivers/media/v4l2-core/v4l2-ctrls.c          |  54 ++++++++
>  drivers/media/v4l2-core/v4l2-ioctl.c          |   1 +
>  include/media/v4l2-ctrls.h                    |  18 ++-
>  include/uapi/linux/v4l2-controls.h            |  43 ++++++
>  include/uapi/linux/videodev2.h                |   5 +
>  7 files changed, 241 insertions(+), 7 deletions(-)
> 
> diff --git a/Documentation/media/uapi/v4l/extended-controls.rst b/Documentation/media/uapi/v4l/extended-controls.rst
> index 9f7312bf3365..4a29d89fd9ac 100644
> --- a/Documentation/media/uapi/v4l/extended-controls.rst
> +++ b/Documentation/media/uapi/v4l/extended-controls.rst
> @@ -1497,6 +1497,128 @@ enum v4l2_mpeg_video_h264_hierarchical_coding_type -
>  
>  
>  
> +.. _v4l2-mpeg-mpeg2:
> +
> +``V4L2_CID_MPEG_VIDEO_MPEG2_SLICE_PARAMS (struct)``
> +    Specifies the slice parameters (also known as slice header) for the
> +    associated MPEG-2 slice data. This includes all the necessary
> +    parameters for configuring a hardware decoder pipeline for MPEG-2.
> +
> +.. tabularcolumns:: |p{2.0cm}|p{4.0cm}|p{11.0cm}|
> +
> +.. c:type:: v4l2_ctrl_mpeg2_slice_params
> +
> +.. cssclass:: longtable
> +
> +.. flat-table:: struct v4l2_ctrl_mpeg2_slice_params
> +    :header-rows:  0
> +    :stub-columns: 0
> +    :widths:       1 1 2
> +
> +    * - __u32
> +      - ``slice_len``
> +      - Length (in bits) of the current slice data.
> +    * - __u32
> +      - ``slice_pos``
> +      - Position (in bits) of the current slice data, relative to the
> +        frame start.
> +    * - __u16
> +      - ``width``
> +      - Width of the corresponding output frame for the current slice.
> +    * - __u16
> +      - ``height``
> +      - Height of the corresponding output frame for the current slice.
> +    * - __u8
> +      - ``slice_type``
> +      - Picture coding type for the frame covered by the current slice
> +        (V4L2_MPEG2_SLICE_TYPE_I, V4L2_MPEG2_SLICE_TYPE_P or
> +        V4L2_MPEG2_SLICE_PCT_B).
> +    * - __u8
> +      - ``f_code[2][2]``
> +      - Motion vector codes.
> +    * - __u8
> +      - ``intra_dc_precision``
> +      - Precision of Discrete Cosine transform (0: 8 bits precision,
> +        1: 9 bits precision, 2: 10 bits precision, 11: 11 bits precision).
> +    * - __u8
> +      - ``picture_structure``
> +      - Picture structure (1: interlaced top field,
> +        2: interlaced bottom field, 3: progressive frame).
> +    * - __u8
> +      - ``top_field_first``
> +      - If set to 1 and interlaced stream, top field is output first.
> +    * - __u8
> +      - ``frame_pred_frame_dct``
> +      - If set to 1, only frame-DCT and frame prediction are used.
> +    * - __u8
> +      - ``concealment_motion_vectors``
> +      -  If set to 1, motion vectors are coded for intra macroblocks.
> +    * - __u8
> +      - ``q_scale_type``
> +      - This flag affects the inverse quantisation process.
> +    * - __u8
> +      - ``intra_vlc_format``
> +      - This flag affects the decoding of transform coefficient data.
> +    * - __u8
> +      - ``alternate_scan``
> +      - This flag affects the decoding of transform coefficient data.
> +    * - __u8
> +      - ``backward_ref_index``
> +      - Index for the V4L2 buffer to use as backward reference, used with
> +        B-coded and P-coded frames.
> +    * - __u8
> +      - ``forward_ref_index``
> +      - Index for the V4L2 buffer to use as forward reference, used with
> +        P-coded frames.
> +    * - :cspan:`2`
> +
> +``V4L2_CID_MPEG_VIDEO_MPEG2_QUANTIZATION (struct)``
> +    Specifies quantization matrices for the associated MPEG-2 slice data.
> +
> +.. tabularcolumns:: |p{2.0cm}|p{4.0cm}|p{11.0cm}|
> +
> +.. c:type:: v4l2_ctrl_mpeg2_quantization
> +
> +.. cssclass:: longtable
> +
> +.. flat-table:: struct v4l2_ctrl_mpeg2_quantization
> +    :header-rows:  0
> +    :stub-columns: 0
> +    :widths:       1 1 2
> +
> +    * - __u8
> +      - ``load_intra_quantiser_matrix``
> +      - One bit to indicate whether to load the intra quantiser matrix.
> +    * - __u32
> +      - ``load_non_intra_quantiser_matrix``
> +      - One bit to indicate whether to load the non-intra quantiser matrix.
> +    * - __u32
> +      - ``load_chroma_intra_quantiser_matrix``
> +      - One bit to indicate whether to load the chroma intra quantiser matrix,
> +        only relevant for non-4:2:0 YUV formats.
> +    * - __u32
> +      - ``load_chroma_non_intra_quantiser_matrix``
> +      - One bit to indicate whether to load the non-chroma intra quantiser
> +        matrix, only relevant for non-4:2:0 YUV formats.
> +    * - __u32
> +      - ``intra_quantiser_matrix[64]``
> +      - The intra quantiser matrix coefficients, in zigzag scanning order.
> +        It is relevant for both luma and chroma components, although it can be
> +        superseded by the chroma-specific matrix for non-4:2:0 YUV formats.
> +    * - __u32
> +      - ``non_intra_quantiser_matrix[64]``
> +      - The non-intra quantiser matrix coefficients, in zigzag scanning order.
> +        It is relevant for both luma and chroma components, although it can be
> +        superseded by the chroma-specific matrix for non-4:2:0 YUV formats.
> +    * - __u32
> +      - ``chroma_intra_quantiser_matrix[64]``
> +      - The intra quantiser matrix coefficients for the chroma YUV component,
> +        in zigzag scanning order. Only relevant for non-4:2:0 YUV formats.
> +    * - __u32
> +      - ``chroma_non_intra_quantiser_matrix[64]``
> +      - The non-intra quantiser matrix coefficients for the chroma YUV component,
> +        in zigzag scanning order. Only relevant for non-4:2:0 YUV formats.
> +    * - :cspan:`2`
>  
>  MFC 5.1 MPEG Controls
>  ---------------------
> diff --git a/Documentation/media/uapi/v4l/pixfmt-compressed.rst b/Documentation/media/uapi/v4l/pixfmt-compressed.rst
> index abec03937bb3..4e73f62b5163 100644
> --- a/Documentation/media/uapi/v4l/pixfmt-compressed.rst
> +++ b/Documentation/media/uapi/v4l/pixfmt-compressed.rst
> @@ -60,6 +60,11 @@ Compressed Formats
>        - ``V4L2_PIX_FMT_MPEG2``
>        - 'MPG2'
>        - MPEG2 video elementary stream.
> +    * .. _V4L2-PIX-FMT-MPEG2-SLICE:
> +
> +      - ``V4L2_PIX_FMT_MPEG2_SLICE``
> +      - 'MG2S'
> +      - MPEG2 parsed slice data, as extracted from the MPEG2 bitstream.

This does not mention that this requires the use of the Request API and which controls
are compulsory in the request.

>      * .. _V4L2-PIX-FMT-MPEG4:
>  
>        - ``V4L2_PIX_FMT_MPEG4``
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
> index 3610dce3a4f8..22483d894259 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -844,6 +844,8 @@ const char *v4l2_ctrl_get_name(u32 id)
>  	case V4L2_CID_MPEG_VIDEO_MV_V_SEARCH_RANGE:		return "Vertical MV Search Range";
>  	case V4L2_CID_MPEG_VIDEO_REPEAT_SEQ_HEADER:		return "Repeat Sequence Header";
>  	case V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME:		return "Force Key Frame";
> +	case V4L2_CID_MPEG_VIDEO_MPEG2_SLICE_PARAMS:		return "MPEG2 Slice Header";
> +	case V4L2_CID_MPEG_VIDEO_MPEG2_QUANTIZATION:		return "MPEG2 Quantization Matrices";

Use MPEG-2 instead of MPEG2 in these two descriptions.

Regards,

	Hans

>  
>  	/* VPX controls */
>  	case V4L2_CID_MPEG_VIDEO_VPX_NUM_PARTITIONS:		return "VPX Number of Partitions";
> @@ -1292,6 +1294,12 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
>  	case V4L2_CID_RDS_TX_ALT_FREQS:
>  		*type = V4L2_CTRL_TYPE_U32;
>  		break;
> +	case V4L2_CID_MPEG_VIDEO_MPEG2_SLICE_PARAMS:
> +		*type = V4L2_CTRL_TYPE_MPEG2_SLICE_PARAMS;
> +		break;
> +	case V4L2_CID_MPEG_VIDEO_MPEG2_QUANTIZATION:
> +		*type = V4L2_CTRL_TYPE_MPEG2_QUANTIZATION;
> +		break;
>  	default:
>  		*type = V4L2_CTRL_TYPE_INTEGER;
>  		break;
> @@ -1550,6 +1558,7 @@ static void std_log(const struct v4l2_ctrl *ctrl)
>  static int std_validate(const struct v4l2_ctrl *ctrl, u32 idx,
>  			union v4l2_ctrl_ptr ptr)
>  {
> +	struct v4l2_ctrl_mpeg2_slice_params *p_mpeg2_slice_params;
>  	size_t len;
>  	u64 offset;
>  	s64 val;
> @@ -1612,6 +1621,45 @@ static int std_validate(const struct v4l2_ctrl *ctrl, u32 idx,
>  			return -ERANGE;
>  		return 0;
>  
> +	case V4L2_CTRL_TYPE_MPEG2_SLICE_PARAMS:
> +		p_mpeg2_slice_params = ptr.p;
> +
> +		switch (p_mpeg2_slice_params->intra_dc_precision) {
> +		case 0: /* 8 bits */
> +		case 1: /* 9 bits */
> +		case 11: /* 11 bits */
> +			break;
> +		default:
> +			return -EINVAL;
> +		}
> +
> +		switch (p_mpeg2_slice_params->picture_structure) {
> +		case 1: /* interlaced top field */
> +		case 2: /* interlaced bottom field */
> +		case 3: /* progressive */
> +			break;
> +		default:
> +			return -EINVAL;
> +		}
> +
> +		switch (p_mpeg2_slice_params->slice_type) {
> +		case V4L2_MPEG2_SLICE_TYPE_I:
> +		case V4L2_MPEG2_SLICE_TYPE_P:
> +		case V4L2_MPEG2_SLICE_TYPE_B:
> +			break;
> +		default:
> +			return -EINVAL;
> +		}
> +
> +		if (p_mpeg2_slice_params->backward_ref_index > VIDEO_MAX_FRAME ||
> +		    p_mpeg2_slice_params->forward_ref_index > VIDEO_MAX_FRAME)
> +			return -EINVAL;
> +
> +		return 0;
> +
> +	case V4L2_CTRL_TYPE_MPEG2_QUANTIZATION:
> +		return 0;
> +
>  	default:
>  		return -EINVAL;
>  	}
> @@ -2186,6 +2234,12 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
>  	case V4L2_CTRL_TYPE_U32:
>  		elem_size = sizeof(u32);
>  		break;
> +	case V4L2_CTRL_TYPE_MPEG2_SLICE_PARAMS:
> +		elem_size = sizeof(struct v4l2_ctrl_mpeg2_slice_params);
> +		break;
> +	case V4L2_CTRL_TYPE_MPEG2_QUANTIZATION:
> +		elem_size = sizeof(struct v4l2_ctrl_mpeg2_quantization);
> +		break;
>  	default:
>  		if (type < V4L2_CTRL_COMPOUND_TYPES)
>  			elem_size = sizeof(s32);
> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
> index 44fc0102221f..68e914b83a03 100644
> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> @@ -1304,6 +1304,7 @@ static void v4l_fill_fmtdesc(struct v4l2_fmtdesc *fmt)
>  		case V4L2_PIX_FMT_H263:		descr = "H.263"; break;
>  		case V4L2_PIX_FMT_MPEG1:	descr = "MPEG-1 ES"; break;
>  		case V4L2_PIX_FMT_MPEG2:	descr = "MPEG-2 ES"; break;
> +		case V4L2_PIX_FMT_MPEG2_SLICE:	descr = "MPEG-2 parsed slice data"; break;
>  		case V4L2_PIX_FMT_MPEG4:	descr = "MPEG-4 part 2 ES"; break;
>  		case V4L2_PIX_FMT_XVID:		descr = "Xvid"; break;
>  		case V4L2_PIX_FMT_VC1_ANNEX_G:	descr = "VC-1 (SMPTE 412M Annex G)"; break;
> diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
> index 34ee3167d7dd..83eff6f91ed2 100644
> --- a/include/media/v4l2-ctrls.h
> +++ b/include/media/v4l2-ctrls.h
> @@ -35,13 +35,15 @@ struct poll_table_struct;
>  
>  /**
>   * union v4l2_ctrl_ptr - A pointer to a control value.
> - * @p_s32:	Pointer to a 32-bit signed value.
> - * @p_s64:	Pointer to a 64-bit signed value.
> - * @p_u8:	Pointer to a 8-bit unsigned value.
> - * @p_u16:	Pointer to a 16-bit unsigned value.
> - * @p_u32:	Pointer to a 32-bit unsigned value.
> - * @p_char:	Pointer to a string.
> - * @p:		Pointer to a compound value.
> + * @p_s32:			Pointer to a 32-bit signed value.
> + * @p_s64:			Pointer to a 64-bit signed value.
> + * @p_u8:			Pointer to a 8-bit unsigned value.
> + * @p_u16:			Pointer to a 16-bit unsigned value.
> + * @p_u32:			Pointer to a 32-bit unsigned value.
> + * @p_char:			Pointer to a string.
> + * @p_mpeg2_slice_params:	Pointer to a MPEG2 slice parameters structure.
> + * @p_mpeg2_quantization:	Pointer to a MPEG2 quantization data structure.
> + * @p:				Pointer to a compound value.
>   */
>  union v4l2_ctrl_ptr {
>  	s32 *p_s32;
> @@ -50,6 +52,8 @@ union v4l2_ctrl_ptr {
>  	u16 *p_u16;
>  	u32 *p_u32;
>  	char *p_char;
> +	struct v4l2_ctrl_mpeg2_slice_params *p_mpeg2_slice_params;
> +	struct v4l2_ctrl_mpeg2_quantization *p_mpeg2_quantization;
>  	void *p;
>  };
>  
> diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
> index e4ee10ee917d..ce6de781037a 100644
> --- a/include/uapi/linux/v4l2-controls.h
> +++ b/include/uapi/linux/v4l2-controls.h
> @@ -557,6 +557,9 @@ enum v4l2_mpeg_video_mpeg4_profile {
>  };
>  #define V4L2_CID_MPEG_VIDEO_MPEG4_QPEL		(V4L2_CID_MPEG_BASE+407)
>  
> +#define V4L2_CID_MPEG_VIDEO_MPEG2_SLICE_PARAMS	(V4L2_CID_MPEG_BASE+450)
> +#define V4L2_CID_MPEG_VIDEO_MPEG2_QUANTIZATION	(V4L2_CID_MPEG_BASE+451)
> +
>  /*  Control IDs for VP8 streams
>   *  Although VP8 is not part of MPEG we add these controls to the MPEG class
>   *  as that class is already handling other video compression standards
> @@ -1092,4 +1095,44 @@ enum v4l2_detect_md_mode {
>  #define V4L2_CID_DETECT_MD_THRESHOLD_GRID	(V4L2_CID_DETECT_CLASS_BASE + 3)
>  #define V4L2_CID_DETECT_MD_REGION_GRID		(V4L2_CID_DETECT_CLASS_BASE + 4)
>  
> +#define V4L2_MPEG2_SLICE_TYPE_I			1
> +#define V4L2_MPEG2_SLICE_TYPE_P			2
> +#define V4L2_MPEG2_SLICE_TYPE_B			3
> +#define V4L2_MPEG2_SLICE_TYPE_D			4
> +
> +struct v4l2_ctrl_mpeg2_slice_params {
> +	__u32	slice_len;
> +	__u32	slice_pos;
> +
> +	__u16	width;
> +	__u16	height;
> +
> +	__u8	slice_type;
> +	__u8	f_code[2][2];
> +
> +	__u8	intra_dc_precision;
> +	__u8	picture_structure;
> +	__u8	top_field_first;
> +	__u8	frame_pred_frame_dct;
> +	__u8	concealment_motion_vectors;
> +	__u8	q_scale_type;
> +	__u8	intra_vlc_format;
> +	__u8	alternate_scan;
> +
> +	__u8	backward_ref_index;
> +	__u8	forward_ref_index;
> +};
> +
> +struct v4l2_ctrl_mpeg2_quantization {
> +	__u8	load_intra_quantiser_matrix : 1;
> +	__u8	load_non_intra_quantiser_matrix : 1;
> +	__u8	load_chroma_intra_quantiser_matrix : 1;
> +	__u8	load_chroma_non_intra_quantiser_matrix : 1;
> +
> +	__u8	intra_quantiser_matrix[64];
> +	__u8	non_intra_quantiser_matrix[64];
> +	__u8	chroma_intra_quantiser_matrix[64];
> +	__u8	chroma_non_intra_quantiser_matrix[64];
> +};
> +
>  #endif
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index 1f6c4b52baae..d171361ed9b3 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -629,6 +629,7 @@ struct v4l2_pix_format {
>  #define V4L2_PIX_FMT_H263     v4l2_fourcc('H', '2', '6', '3') /* H263          */
>  #define V4L2_PIX_FMT_MPEG1    v4l2_fourcc('M', 'P', 'G', '1') /* MPEG-1 ES     */
>  #define V4L2_PIX_FMT_MPEG2    v4l2_fourcc('M', 'P', 'G', '2') /* MPEG-2 ES     */
> +#define V4L2_PIX_FMT_MPEG2_SLICE v4l2_fourcc('M', 'G', '2', 'S') /* MPEG-2 parsed slice data */
>  #define V4L2_PIX_FMT_MPEG4    v4l2_fourcc('M', 'P', 'G', '4') /* MPEG-4 part 2 ES */
>  #define V4L2_PIX_FMT_XVID     v4l2_fourcc('X', 'V', 'I', 'D') /* Xvid           */
>  #define V4L2_PIX_FMT_VC1_ANNEX_G v4l2_fourcc('V', 'C', '1', 'G') /* SMPTE 421M Annex G compliant stream */
> @@ -1587,6 +1588,8 @@ struct v4l2_ext_control {
>  		__u8 __user *p_u8;
>  		__u16 __user *p_u16;
>  		__u32 __user *p_u32;
> +		struct v4l2_ctrl_mpeg2_slice_params __user *p_mpeg2_slice_params;
> +		struct v4l2_ctrl_mpeg2_quantization __user *p_mpeg2_quantization;
>  		void __user *ptr;
>  	};
>  } __attribute__ ((packed));
> @@ -1632,6 +1635,8 @@ enum v4l2_ctrl_type {
>  	V4L2_CTRL_TYPE_U8	     = 0x0100,
>  	V4L2_CTRL_TYPE_U16	     = 0x0101,
>  	V4L2_CTRL_TYPE_U32	     = 0x0102,
> +	V4L2_CTRL_TYPE_MPEG2_SLICE_PARAMS = 0x0103,
> +	V4L2_CTRL_TYPE_MPEG2_QUANTIZATION = 0x0104,
>  };
>  
>  /*  Used in the VIDIOC_QUERYCTRL ioctl for querying controls */
> 
