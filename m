Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44175 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991Ab3KKBxU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Nov 2013 20:53:20 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Pawel Osciak <posciak@chromium.org>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v1 16/19] v4l: Add encoding camera controls.
Date: Mon, 11 Nov 2013 02:53:55 +0100
Message-ID: <6181616.lDOOnGtZml@avalon>
In-Reply-To: <1377829038-4726-17-git-send-email-posciak@chromium.org>
References: <1377829038-4726-1-git-send-email-posciak@chromium.org> <1377829038-4726-17-git-send-email-posciak@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pawel,

Thank you for the patch.

On Friday 30 August 2013 11:17:15 Pawel Osciak wrote:
> Add defines for controls found in UVC 1.5 encoding cameras.

In addition to the comments already sent by Hans, Kamil and Sylwester, I'll 
just point out that documentation is needed.

> Signed-off-by: Pawel Osciak <posciak@chromium.org>
> ---
>  drivers/media/v4l2-core/v4l2-ctrls.c | 29 +++++++++++++++++++++++++++++
>  include/uapi/linux/v4l2-controls.h   | 31 +++++++++++++++++++++++++++++++
>  2 files changed, 60 insertions(+)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c
> b/drivers/media/v4l2-core/v4l2-ctrls.c index c3f0803..0b3a632 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -781,6 +781,35 @@ const char *v4l2_ctrl_get_name(u32 id)
>  	case V4L2_CID_AUTO_FOCUS_STATUS:	return "Auto Focus, Status";
>  	case V4L2_CID_AUTO_FOCUS_RANGE:		return "Auto Focus, Range";
> 
> +	case V4L2_CID_ENCODER_MIN_FRAME_INTERVAL: return "Encoder, min. frame
> interval";
> +	case V4L2_CID_ENCODER_RATE_CONTROL_MODE: return "Encoder, rate control
> mode";
> +	case V4L2_CID_ENCODER_AVERAGE_BITRATE:	return "Encoder, average
> bitrate";
> +	case V4L2_CID_ENCODER_CPB_SIZE:		return "Encoder, CPB size";
> +	case V4L2_CID_ENCODER_PEAK_BIT_RATE:	return "Encoder, peak bit rate";
> +	case V4L2_CID_ENCODER_QP_PARAM_I:	return "Encoder, QP param for I 
frames";
> +	case V4L2_CID_ENCODER_QP_PARAM_P:	return "Encoder, QP param for P
> frames";
> +	case V4L2_CID_ENCODER_QP_PARAM_BG:	return "Encoder, QP param for B/G
> frames";
> +	case V4L2_CID_ENCODER_NUM_GDR_FRAMES:	return "Encoder, number of GDR
> frames";
> +	case V4L2_CID_ENCODER_LTR_BUFFER_CONTROL: return "Encoder, LTR buffer
> control";
> +	case V4L2_CID_ENCODER_LTR_BUFFER_TRUST_MODE: return "Encoder, LTR buffer
> trust mode";
> +	case V4L2_CID_ENCODER_LTR_PICTURE_POSITION: return "Encoder, LTR picture
> position";
> +	case V4L2_CID_ENCODER_LTR_PICTURE_MODE:	return "Encoder, LTR picture
> mode";
> +	case V4L2_CID_ENCODER_LTR_VALIDATION:	return "Encoder, LTR
> validation";
> +	case V4L2_CID_ENCODER_MIN_QP:		return "Encoder, minimum QP param";
> +	case V4L2_CID_ENCODER_MAX_QP:		return "Encoder, maximum QP param";
> +	case V4L2_CID_ENCODER_SYNC_FRAME_INTERVAL: return "Encoder, sync frame
> interval";
> +	case V4L2_CID_ENCODER_ERROR_RESILIENCY:	return "Encoder, error
> resiliency";
> +	case V4L2_CID_ENCODER_TEMPORAL_LAYER_ENABLE: return "Encoder, temporal
> layer enable";
> +
> +	case V4L2_CID_ENCODER_VP8_SLICE_MODE:	return "Encoder, VP8 slice
> mode";
> +	case V4L2_CID_ENCODER_VP8_SYNC_FRAME_TYPE: return "Encoder, VP8 sync
> frame type";
> +	case V4L2_CID_ENCODER_VP8_DCT_PARTS_PER_FRAME: return "Encoder,
> VP8, DCT partitions per frame";
> +
> +	case V4L2_CID_ENCODER_H264_PROFILE_TOOLSET: return "Encoder, H.264
> profile and toolset";
> +	case V4L2_CID_ENCODER_H264_LEVEL_IDC_LIMIT: return "Encoder, H.264 level
> IDC limit";
> +	case V4L2_CID_ENCODER_H264_SEI_PAYLOAD_TYPE: return "Encoder, H.264 SEI
> payload type";
> +	case V4L2_CID_ENCODER_H264_LAYER_PRIORITY: return "Encoder, H.264 layer
> priority";
> +
>  	/* FM Radio Modulator control */
>  	/* Keep the order of the 'case's the same as in videodev2.h! */
>  	case V4L2_CID_FM_TX_CLASS:		return "FM Radio Modulator Controls";
> diff --git a/include/uapi/linux/v4l2-controls.h
> b/include/uapi/linux/v4l2-controls.h index 083bb5a..ef3a30d 100644
> --- a/include/uapi/linux/v4l2-controls.h
> +++ b/include/uapi/linux/v4l2-controls.h
> @@ -729,6 +729,37 @@ enum v4l2_auto_focus_range {
>  	V4L2_AUTO_FOCUS_RANGE_INFINITY		= 3,
>  };
> 
> +/* Controls found in UVC 1.5 encoding cameras */
> +#define V4L2_CID_ENCODER_MIN_FRAME_INTERVAL	
(V4L2_CID_CAMERA_CLASS_BASE+32)
> +#define V4L2_CID_ENCODER_RATE_CONTROL_MODE	(V4L2_CID_CAMERA_CLASS_BASE+33)
> +#define V4L2_CID_ENCODER_AVERAGE_BITRATE	(V4L2_CID_CAMERA_CLASS_BASE+34)
> +#define V4L2_CID_ENCODER_CPB_SIZE		(V4L2_CID_CAMERA_CLASS_BASE+35)
> +#define V4L2_CID_ENCODER_PEAK_BIT_RATE		(V4L2_CID_CAMERA_CLASS_BASE+36)
> +#define V4L2_CID_ENCODER_QP_PARAM_I		(V4L2_CID_CAMERA_CLASS_BASE+37)
> +#define V4L2_CID_ENCODER_QP_PARAM_P		(V4L2_CID_CAMERA_CLASS_BASE+38)
> +#define V4L2_CID_ENCODER_QP_PARAM_BG		(V4L2_CID_CAMERA_CLASS_BASE+39)
> +#define V4L2_CID_ENCODER_NUM_GDR_FRAMES		
(V4L2_CID_CAMERA_CLASS_BASE+40)
> +#define
> V4L2_CID_ENCODER_LTR_BUFFER_CONTROL	(V4L2_CID_CAMERA_CLASS_BASE+41)
> +#define
> V4L2_CID_ENCODER_LTR_BUFFER_TRUST_MODE	(V4L2_CID_CAMERA_CLASS_BASE+42)
> +#define
> V4L2_CID_ENCODER_LTR_PICTURE_POSITION	(V4L2_CID_CAMERA_CLASS_BASE+43)
> +#define V4L2_CID_ENCODER_LTR_PICTURE_MODE	(V4L2_CID_CAMERA_CLASS_BASE+44)
> +#define V4L2_CID_ENCODER_LTR_VALIDATION		
(V4L2_CID_CAMERA_CLASS_BASE+45)
> +#define V4L2_CID_ENCODER_MIN_QP			(V4L2_CID_CAMERA_CLASS_BASE+46) 
+#define
> V4L2_CID_ENCODER_MAX_QP			(V4L2_CID_CAMERA_CLASS_BASE+47) +#define
> V4L2_CID_ENCODER_SYNC_FRAME_INTERVAL	(V4L2_CID_CAMERA_CLASS_BASE+48)
> +#define V4L2_CID_ENCODER_ERROR_RESILIENCY	(V4L2_CID_CAMERA_CLASS_BASE+49)
> +#define
> V4L2_CID_ENCODER_TEMPORAL_LAYER_ENABLE	(V4L2_CID_CAMERA_CLASS_BASE+50) +
> +/* VP8-specific controls */
> +#define V4L2_CID_ENCODER_VP8_SLICE_MODE		
(V4L2_CID_CAMERA_CLASS_BASE+51)
> +#define V4L2_CID_ENCODER_VP8_DCT_PARTS_PER_FRAME
> (V4L2_CID_CAMERA_CLASS_BASE+52) +#define
> V4L2_CID_ENCODER_VP8_SYNC_FRAME_TYPE	(V4L2_CID_CAMERA_CLASS_BASE+53) +
> +/* H.264-specific controls */
> +#define
> V4L2_CID_ENCODER_H264_PROFILE_TOOLSET	(V4L2_CID_CAMERA_CLASS_BASE+54)
> +#define
> V4L2_CID_ENCODER_H264_LEVEL_IDC_LIMIT	(V4L2_CID_CAMERA_CLASS_BASE+55)
> +#define
> V4L2_CID_ENCODER_H264_SEI_PAYLOAD_TYPE	(V4L2_CID_CAMERA_CLASS_BASE+56)
> +#define
> V4L2_CID_ENCODER_H264_LAYER_PRIORITY	(V4L2_CID_CAMERA_CLASS_BASE+57)
> 
>  /* FM Modulator class control IDs */
-- 
Regards,

Laurent Pinchart

