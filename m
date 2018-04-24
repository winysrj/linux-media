Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:23471 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750815AbeDXJB5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Apr 2018 05:01:57 -0400
Date: Tue, 24 Apr 2018 12:01:50 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Alexandre Courbot <acourbot@chromium.org>,
        Tomasz Figa <tfiga@chromium.org>
Subject: Re: [PATCH v2 05/10] media: v4l: Add definitions for MPEG2 frame
 format and header metadata
Message-ID: <20180424090150.rtbejfjaddd6wysk@paasikivi.fi.intel.com>
References: <20180419154124.17512-1-paul.kocialkowski@bootlin.com>
 <20180419154536.17846-1-paul.kocialkowski@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180419154536.17846-1-paul.kocialkowski@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Paul,

On Thu, Apr 19, 2018 at 05:45:31PM +0200, Paul Kocialkowski wrote:
> Stateless video decoding engines require both the MPEG slices and
> associated metadata from the video stream in order to decode frames.
> 
> This introduces definitions for a new pixel format, describing buffers
> with MPEG2 slice data, as well as a control structure for passing the
> frame header (metadata) to drivers.

What's the typical relationship between MPEG2 slice data and the header?

Are the two always used together, do they originate from the same source,
for instance? I have to admit I'm not very familiar with MPEG...

> 
> Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> Signed-off-by: Florent Revest <florent.revest@free-electrons.com>
> ---
>  drivers/media/v4l2-core/v4l2-ctrls.c | 10 ++++++++++
>  drivers/media/v4l2-core/v4l2-ioctl.c |  1 +
>  include/uapi/linux/v4l2-controls.h   | 26 ++++++++++++++++++++++++++
>  include/uapi/linux/videodev2.h       |  3 +++
>  4 files changed, 40 insertions(+)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
> index ba05a8b9a095..fcdc12b9a9e0 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -761,6 +761,7 @@ const char *v4l2_ctrl_get_name(u32 id)
>  	case V4L2_CID_MPEG_VIDEO_MV_V_SEARCH_RANGE:		return "Vertical MV Search Range";
>  	case V4L2_CID_MPEG_VIDEO_REPEAT_SEQ_HEADER:		return "Repeat Sequence Header";
>  	case V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME:		return "Force Key Frame";
> +	case V4L2_CID_MPEG_VIDEO_MPEG2_FRAME_HDR:		return "MPEG2 Frame Header";
>  
>  	/* VPX controls */
>  	case V4L2_CID_MPEG_VIDEO_VPX_NUM_PARTITIONS:		return "VPX Number of Partitions";
> @@ -1152,6 +1153,9 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
>  	case V4L2_CID_RDS_TX_ALT_FREQS:
>  		*type = V4L2_CTRL_TYPE_U32;
>  		break;
> +	case V4L2_CID_MPEG_VIDEO_MPEG2_FRAME_HDR:
> +		*type = V4L2_CTRL_TYPE_MPEG2_FRAME_HDR;
> +		break;
>  	default:
>  		*type = V4L2_CTRL_TYPE_INTEGER;
>  		break;
> @@ -1472,6 +1476,9 @@ static int std_validate(const struct v4l2_ctrl *ctrl, u32 idx,
>  			return -ERANGE;
>  		return 0;
>  
> +	case V4L2_CTRL_TYPE_MPEG2_FRAME_HDR:
> +		return 0;
> +
>  	default:
>  		return -EINVAL;
>  	}
> @@ -2046,6 +2053,9 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
>  	case V4L2_CTRL_TYPE_U32:
>  		elem_size = sizeof(u32);
>  		break;
> +	case V4L2_CTRL_TYPE_MPEG2_FRAME_HDR:
> +		elem_size = sizeof(struct v4l2_ctrl_mpeg2_frame_hdr);
> +		break;
>  	default:
>  		if (type < V4L2_CTRL_COMPOUND_TYPES)
>  			elem_size = sizeof(s32);
> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
> index 468c3c65362d..8070203da5d2 100644
> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> @@ -1273,6 +1273,7 @@ static void v4l_fill_fmtdesc(struct v4l2_fmtdesc *fmt)
>  		case V4L2_PIX_FMT_VC1_ANNEX_L:	descr = "VC-1 (SMPTE 412M Annex L)"; break;
>  		case V4L2_PIX_FMT_VP8:		descr = "VP8"; break;
>  		case V4L2_PIX_FMT_VP9:		descr = "VP9"; break;
> +		case V4L2_PIX_FMT_MPEG2_FRAME:	descr = "MPEG2 Frame"; break;
>  		case V4L2_PIX_FMT_CPIA1:	descr = "GSPCA CPiA YUV"; break;
>  		case V4L2_PIX_FMT_WNVA:		descr = "WNVA"; break;
>  		case V4L2_PIX_FMT_SN9C10X:	descr = "GSPCA SN9C10X"; break;
> diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
> index cbbb750d87d1..8431b2a540c7 100644
> --- a/include/uapi/linux/v4l2-controls.h
> +++ b/include/uapi/linux/v4l2-controls.h
> @@ -557,6 +557,8 @@ enum v4l2_mpeg_video_mpeg4_profile {
>  };
>  #define V4L2_CID_MPEG_VIDEO_MPEG4_QPEL		(V4L2_CID_MPEG_BASE+407)
>  
> +#define V4L2_CID_MPEG_VIDEO_MPEG2_FRAME_HDR     (V4L2_CID_MPEG_BASE+450)
> +
>  /*  Control IDs for VP8 streams
>   *  Although VP8 is not part of MPEG we add these controls to the MPEG class
>   *  as that class is already handling other video compression standards
> @@ -985,4 +987,28 @@ enum v4l2_detect_md_mode {
>  #define V4L2_CID_DETECT_MD_THRESHOLD_GRID	(V4L2_CID_DETECT_CLASS_BASE + 3)
>  #define V4L2_CID_DETECT_MD_REGION_GRID		(V4L2_CID_DETECT_CLASS_BASE + 4)
>  
> +struct v4l2_ctrl_mpeg2_frame_hdr {
> +	__u32 slice_len;
> +	__u32 slice_pos;
> +	enum { MPEG1, MPEG2 } type;
> +
> +	__u16 width;
> +	__u16 height;
> +
> +	enum { PCT_I = 1, PCT_P, PCT_B, PCT_D } picture_coding_type;
> +	__u8 f_code[2][2];
> +
> +	__u8 intra_dc_precision;
> +	__u8 picture_structure;
> +	__u8 top_field_first;
> +	__u8 frame_pred_frame_dct;
> +	__u8 concealment_motion_vectors;
> +	__u8 q_scale_type;
> +	__u8 intra_vlc_format;
> +	__u8 alternate_scan;
> +
> +	__u8 backward_ref_index;
> +	__u8 forward_ref_index;
> +};

Besides the comments that have been given, please add
__attribute__((packed)) to the struct definition.

> +
>  #endif
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index 31b5728b56e9..4b8336f7bcf0 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -635,6 +635,7 @@ struct v4l2_pix_format {
>  #define V4L2_PIX_FMT_VC1_ANNEX_L v4l2_fourcc('V', 'C', '1', 'L') /* SMPTE 421M Annex L compliant stream */
>  #define V4L2_PIX_FMT_VP8      v4l2_fourcc('V', 'P', '8', '0') /* VP8 */
>  #define V4L2_PIX_FMT_VP9      v4l2_fourcc('V', 'P', '9', '0') /* VP9 */
> +#define V4L2_PIX_FMT_MPEG2_FRAME v4l2_fourcc('M', 'G', '2', 'F') /* MPEG2 frame */

This format needs documentation.

>  
>  /*  Vendor-specific formats   */
>  #define V4L2_PIX_FMT_CPIA1    v4l2_fourcc('C', 'P', 'I', 'A') /* cpia1 YUV */
> @@ -1586,6 +1587,7 @@ struct v4l2_ext_control {
>  		__u8 __user *p_u8;
>  		__u16 __user *p_u16;
>  		__u32 __user *p_u32;
> +		struct v4l2_ctrl_mpeg2_frame_hdr __user *p_mpeg2_frame_hdr;
>  		void __user *ptr;
>  	};
>  } __attribute__ ((packed));
> @@ -1631,6 +1633,7 @@ enum v4l2_ctrl_type {
>  	V4L2_CTRL_TYPE_U8	     = 0x0100,
>  	V4L2_CTRL_TYPE_U16	     = 0x0101,
>  	V4L2_CTRL_TYPE_U32	     = 0x0102,
> +	V4L2_CTRL_TYPE_MPEG2_FRAME_HDR = 0x0109,
>  };
>  
>  /*  Used in the VIDIOC_QUERYCTRL ioctl for querying controls */
> -- 
> 2.16.3
> 

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
