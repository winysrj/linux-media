Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44368 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135Ab3KKCdX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Nov 2013 21:33:23 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Pawel Osciak <posciak@chromium.org>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v1 17/19] uvcvideo: Add UVC 1.5 Encoding Unit controls.
Date: Mon, 11 Nov 2013 03:33:57 +0100
Message-ID: <3606967.Vp4PGORXA1@avalon>
In-Reply-To: <1377829038-4726-18-git-send-email-posciak@chromium.org>
References: <1377829038-4726-1-git-send-email-posciak@chromium.org> <1377829038-4726-18-git-send-email-posciak@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pawel,

Thank you for the patch.

On Friday 30 August 2013 11:17:16 Pawel Osciak wrote:
> These controls allow modifying encoding parameters.
> 
> Signed-off-by: Pawel Osciak <posciak@chromium.org>
> ---
>  drivers/media/usb/uvc/uvc_ctrl.c | 445 ++++++++++++++++++++++++++++++++++++
>  include/uapi/linux/usb/video.h   |  23 ++
>  2 files changed, 468 insertions(+)
> 
> diff --git a/drivers/media/usb/uvc/uvc_ctrl.c
> b/drivers/media/usb/uvc/uvc_ctrl.c index a0493d6..cd02c99 100644
> --- a/drivers/media/usb/uvc/uvc_ctrl.c
> +++ b/drivers/media/usb/uvc/uvc_ctrl.c
> @@ -351,6 +351,167 @@ static struct uvc_control_info uvc_ctrls[] = {
> 
>  				| UVC_CTRL_FLAG_RESTORE
>  				| UVC_CTRL_FLAG_AUTO_UPDATE,
> 
>  	},
> +	/*
> +	 * All EU controls are marked as AUTO_UPDATE, because many are, and also
> +	 * we can't cache all of them as they are stream/layer dependent, which
> +	 * would be too slow/too much to cache.
> +	 */
> +	{
> +		.entity		= UVC_GUID_UVC_ENCODING,
> +		.selector	= UVC_EU_PROFILE_TOOLSET_CONTROL,
> +		.index		= 1,
> +		.size		= 6,

Doesn't UVC 1.5 document this control size as 5 bytes ?

> +		.flags		= UVC_CTRL_FLAG_SET_CUR | UVC_CTRL_FLAG_GET_CUR
> +				| UVC_CTRL_FLAG_GET_DEF
> +				| UVC_CTRL_FLAG_AUTO_UPDATE,
> +	},
> +	{
> +		.entity		= UVC_GUID_UVC_ENCODING,
> +		.selector	= UVC_EU_MIN_FRAME_INTERVAL_CONTROL,
> +		.index		= 3,
> +		.size		= 4,
> +		.flags		= UVC_CTRL_FLAG_SET_CUR | UVC_CTRL_FLAG_GET_CUR
> +				| UVC_CTRL_FLAG_GET_MIN | UVC_CTRL_FLAG_GET_MAX
> +				| UVC_CTRL_FLAG_GET_DEF
> +				| UVC_CTRL_FLAG_AUTO_UPDATE,
> +	},
> +	{
> +		.entity		= UVC_GUID_UVC_ENCODING,
> +		.selector	= UVC_EU_SLICE_MODE_CONTROL,
> +		.index		= 4,
> +		.size		= 4,
> +		.flags		= UVC_CTRL_FLAG_SET_CUR | UVC_CTRL_FLAG_GET_CUR
> +				| UVC_CTRL_FLAG_GET_MIN | UVC_CTRL_FLAG_GET_MAX
> +				| UVC_CTRL_FLAG_GET_DEF
> +				| UVC_CTRL_FLAG_AUTO_UPDATE,
> +	},
> +	{
> +		.entity		= UVC_GUID_UVC_ENCODING,
> +		.selector	= UVC_EU_RATE_CONTROL_MODE_CONTROL,
> +		.index		= 5,
> +		.size		= 1,
> +		.flags		= UVC_CTRL_FLAG_SET_CUR | UVC_CTRL_FLAG_GET_CUR
> +				| UVC_CTRL_FLAG_GET_DEF
> +				| UVC_CTRL_FLAG_AUTO_UPDATE,
> +	},
> +	{
> +		.entity		= UVC_GUID_UVC_ENCODING,
> +		.selector	= UVC_EU_AVERAGE_BITRATE_CONTROL,
> +		.index		= 6,
> +		.size		= 4,
> +		.flags		= UVC_CTRL_FLAG_SET_CUR
> +				| UVC_CTRL_FLAG_GET_RANGE
> +				| UVC_CTRL_FLAG_AUTO_UPDATE,
> +	},
> +	{
> +		.entity		= UVC_GUID_UVC_ENCODING,
> +		.selector	= UVC_EU_CPB_SIZE_CONTROL,
> +		.index		= 7,
> +		.size		= 4,
> +		.flags		= UVC_CTRL_FLAG_SET_CUR
> +				| UVC_CTRL_FLAG_GET_RANGE
> +				| UVC_CTRL_FLAG_AUTO_UPDATE,
> +	},
> +	{
> +		.entity		= UVC_GUID_UVC_ENCODING,
> +		.selector	= UVC_EU_PEAK_BIT_RATE_CONTROL,
> +		.index		= 8,
> +		.size		= 4,
> +		.flags		= UVC_CTRL_FLAG_SET_CUR
> +				| UVC_CTRL_FLAG_GET_RANGE
> +				| UVC_CTRL_FLAG_AUTO_UPDATE,
> +	},
> +	{
> +		.entity		= UVC_GUID_UVC_ENCODING,
> +		.selector	= UVC_EU_QUANTIZATION_PARAMS_CONTROL,
> +		.index		= 9,
> +		.size		= 6,
> +		.flags		= UVC_CTRL_FLAG_SET_CUR | UVC_CTRL_FLAG_GET_CUR
> +				| UVC_CTRL_FLAG_GET_MIN | UVC_CTRL_FLAG_GET_MAX
> +				| UVC_CTRL_FLAG_GET_DEF
> +				| UVC_CTRL_FLAG_AUTO_UPDATE,

According to the spec this one supports GET_RES as well, so you can use 
GET_RANGE.

> +	},
> +	{
> +		.entity		= UVC_GUID_UVC_ENCODING,
> +		.selector	= UVC_EU_SYNC_REF_FRAME_CONTROL,
> +		.index		= 10,
> +		.size		= 4,
> +		.flags		= UVC_CTRL_FLAG_SET_CUR | UVC_CTRL_FLAG_GET_CUR
> +				| UVC_CTRL_FLAG_GET_MIN | UVC_CTRL_FLAG_GET_MAX
> +				| UVC_CTRL_FLAG_AUTO_UPDATE,
> +	},
> +	{
> +		.entity		= UVC_GUID_UVC_ENCODING,
> +		.selector	= UVC_EU_LTR_BUFFER_CONTROL,
> +		.index		= 11,
> +		.size		= 2,
> +		.flags		= UVC_CTRL_FLAG_SET_CUR | UVC_CTRL_FLAG_GET_CUR
> +				| UVC_CTRL_FLAG_GET_MAX | UVC_CTRL_FLAG_GET_DEF
> +				| UVC_CTRL_FLAG_AUTO_UPDATE,
> +	},
> +	{
> +		.entity		= UVC_GUID_UVC_ENCODING,
> +		.selector	= UVC_EU_LTR_PICTURE_CONTROL,
> +		.index		= 12,
> +		.size		= 2,
> +		.flags		= UVC_CTRL_FLAG_SET_CUR | UVC_CTRL_FLAG_GET_CUR
> +				| UVC_CTRL_FLAG_GET_DEF
> +				| UVC_CTRL_FLAG_AUTO_UPDATE,
> +	},
> +	{
> +		.entity		= UVC_GUID_UVC_ENCODING,
> +		.selector	= UVC_EU_LTR_VALIDATION_CONTROL,
> +		.index		= 13,
> +		.size		= 2,
> +		.flags		= UVC_CTRL_FLAG_SET_CUR | UVC_CTRL_FLAG_GET_CUR
> +				| UVC_CTRL_FLAG_GET_DEF
> +				| UVC_CTRL_FLAG_AUTO_UPDATE,
> +	},
> +	{
> +		.entity		= UVC_GUID_UVC_ENCODING,
> +		.selector	= UVC_EU_LEVEL_IDC_LIMIT_CONTROL,
> +		.index		= 14,
> +		.size		= 1,
> +		.flags		= UVC_CTRL_FLAG_SET_CUR | UVC_CTRL_FLAG_GET_CUR
> +				| UVC_CTRL_FLAG_GET_MIN | UVC_CTRL_FLAG_GET_MAX
> +				| UVC_CTRL_FLAG_GET_DEF
> +				| UVC_CTRL_FLAG_AUTO_UPDATE,
> +	},
> +	{
> +		.entity		= UVC_GUID_UVC_ENCODING,
> +		.selector	= UVC_EU_SEI_PAYLOADTYPE_CONTROL,
> +		.index		= 15,
> +		.size		= 8,
> +		.flags		= UVC_CTRL_FLAG_SET_CUR | UVC_CTRL_FLAG_GET_CUR
> +				| UVC_CTRL_FLAG_GET_MAX | UVC_CTRL_FLAG_GET_DEF
> +				| UVC_CTRL_FLAG_AUTO_UPDATE,
> +	},
> +	{
> +		.entity		= UVC_GUID_UVC_ENCODING,
> +		.selector	= UVC_EU_QP_RANGE_CONTROL,
> +		.index		= 16,
> +		.size		= 2,
> +		.flags		= UVC_CTRL_FLAG_SET_CUR
> +				| UVC_CTRL_FLAG_GET_RANGE
> +				| UVC_CTRL_FLAG_AUTO_UPDATE,
> +	},
> +	{
> +		.entity		= UVC_GUID_UVC_ENCODING,
> +		.selector	= UVC_EU_PRIORITY_CONTROL,
> +		.index		= 17,
> +		.size		= 1,
> +		.flags		= UVC_CTRL_FLAG_SET_CUR | UVC_CTRL_FLAG_GET_CUR
> +				| UVC_CTRL_FLAG_AUTO_UPDATE,
> +	},
> +	{
> +		.entity		= UVC_GUID_UVC_ENCODING,
> +		.selector	= UVC_EU_ERROR_RESILIENCY_CONTROL,
> +		.index		= 19,
> +		.size		= 2,
> +		.flags		= UVC_CTRL_FLAG_SET_CUR | UVC_CTRL_FLAG_GET_CUR
> +				| UVC_CTRL_FLAG_GET_DEF | UVC_CTRL_FLAG_GET_RES
> +				| UVC_CTRL_FLAG_AUTO_UPDATE,

The spec doesn't mention GET_LEN and GET_INFO as supported requests for this 
control. Please please please tell me it's a mistake in the documentation...

> +	},
>  };
> 
>  static struct uvc_menu_info power_line_frequency_controls[] = {
> @@ -366,6 +527,32 @@ static struct uvc_menu_info exposure_auto_controls[] =
> { { 8, "Aperture Priority Mode" },
>  };
> 
> +static struct uvc_menu_info rate_control_mode_controls[] = {
> +	{ 1, "VBR" },
> +	{ 2, "CBR" },
> +	{ 3, "Constant QP" },
> +	{ 4, "GVBR" },
> +	{ 5, "VBRN" },
> +	{ 6, "GVBRN" },
> +};
> +
> +static struct uvc_menu_info encoder_vp8_sync_frame_type_controls[] = {
> +	{ 0, "Reset" },
> +	{ 1, "Generate Intra Frame" },
> +	{ 2, "GDR" },
> +	{ 3, "GDR and Update Golden" },
> +	{ 4, "GDR and Update Alt" },
> +	{ 5, "GDR and Update Golden + Alt" },
> +	{ 6, "Update Golden" },
> +	{ 7, "Update Alt" },
> +	{ 8, "Update Golden + Alt" },
> +};
> +
> +static struct uvc_menu_info encoder_vp8_slice_mode_controls[] = {
> +	{ 0, "No Partitioning" },
> +	{ 1, "DCT Partitions Per Frame" },
> +};
> +
>  static __s32 uvc_ctrl_get_zoom(struct uvc_control_mapping *mapping,
>  	__u8 query, const __u8 *data)
>  {
> @@ -686,6 +873,264 @@ static struct uvc_control_mapping uvc_ctrl_mappings[]
> = { .v4l2_type	= V4L2_CTRL_TYPE_BOOLEAN,
>  		.data_type	= UVC_CTRL_DATA_TYPE_BOOLEAN,
>  	},
> +	/* Encoder controls. */
> +	{
> +		.id		= V4L2_CID_ENCODER_H264_PROFILE_TOOLSET,
> +		.name		= "Encoder, H.264 profile/toolset",
> +		.entity		= UVC_GUID_UVC_ENCODING,
> +		.selector	= UVC_EU_PROFILE_TOOLSET_CONTROL,
> +		.size		= 40,

The get_le and set_le helpers only support up to 32 bits :-/

> +		.offset		= 0,
> +		.v4l2_type	= V4L2_CTRL_TYPE_INTEGER,
> +		.data_type	= UVC_CTRL_DATA_TYPE_UNSIGNED,

This UVC control is split in 3 fields. I don't think it would be a good idea 
to expose that as a single V4L2 control. We should either have 3 V4L2 controls 
(or actually 2, as wConstrainedToolset is reserved), or only expose this 
through the XU API.

> +	},
> +	{
> +		.id		= V4L2_CID_ENCODER_MIN_FRAME_INTERVAL,
> +		.name		= "Encoder, minimum frame interval",
> +		.entity		= UVC_GUID_UVC_ENCODING,
> +		.selector	= UVC_EU_MIN_FRAME_INTERVAL_CONTROL,
> +		.size		= 32,
> +		.offset		= 0,
> +		.v4l2_type	= V4L2_CTRL_TYPE_INTEGER,
> +		.data_type	= UVC_CTRL_DATA_TYPE_UNSIGNED,
> +	},
> +	{
> +		.id		= V4L2_CID_ENCODER_VP8_SLICE_MODE,
> +		.name		= "Encoder, VP8 slice mode",

How nice of them, redefining the meaning of the control for VP8... :-)

> +		.entity		= UVC_GUID_UVC_ENCODING,
> +		.selector	= UVC_EU_SLICE_MODE_CONTROL,
> +		.size		= 16,
> +		.offset		= 0,
> +		.v4l2_type	= V4L2_CTRL_TYPE_MENU,
> +		.data_type	= UVC_CTRL_DATA_TYPE_ENUM,
> +		.menu_info	= encoder_vp8_slice_mode_controls,
> +		.menu_count	= ARRAY_SIZE(encoder_vp8_slice_mode_controls),
> +	},
> +	{
> +		.id		= V4L2_CID_ENCODER_VP8_DCT_PARTS_PER_FRAME,
> +		.name		= "Encoder, VP8 DCT partns/frame",
> +		.entity		= UVC_GUID_UVC_ENCODING,
> +		.selector	= UVC_EU_SLICE_MODE_CONTROL,
> +		.size		= 16,
> +		.offset		= 16,
> +		.v4l2_type	= V4L2_CTRL_TYPE_INTEGER,
> +		.data_type	= UVC_CTRL_DATA_TYPE_UNSIGNED,
> +	},
> +	{
> +		.id		= V4L2_CID_ENCODER_RATE_CONTROL_MODE,
> +		.name		= "Encoder, rate control mode",
> +		.entity		= UVC_GUID_UVC_ENCODING,
> +		.selector	= UVC_EU_RATE_CONTROL_MODE_CONTROL,
> +		.size		= 4,
> +		.offset		= 0,
> +		.v4l2_type	= V4L2_CTRL_TYPE_MENU,
> +		.data_type	= UVC_CTRL_DATA_TYPE_ENUM,
> +		.menu_info	= rate_control_mode_controls,
> +		.menu_count	= ARRAY_SIZE(rate_control_mode_controls),
> +	},
> +	{
> +		.id		= V4L2_CID_ENCODER_AVERAGE_BITRATE,
> +		.name		= "Encoder, average bitrate",
> +		.entity		= UVC_GUID_UVC_ENCODING,
> +		.selector	= UVC_EU_AVERAGE_BITRATE_CONTROL,
> +		.size		= 32,
> +		.offset		= 0,
> +		.v4l2_type	= V4L2_CTRL_TYPE_INTEGER,
> +		.data_type	= UVC_CTRL_DATA_TYPE_UNSIGNED,
> +	},
> +	{
> +		.id		= V4L2_CID_ENCODER_CPB_SIZE,
> +		.name		= "Encoder, CPB size",
> +		.entity		= UVC_GUID_UVC_ENCODING,
> +		.selector	= UVC_EU_CPB_SIZE_CONTROL,
> +		.size		= 32,
> +		.offset		= 0,
> +		.v4l2_type	= V4L2_CTRL_TYPE_INTEGER,
> +		.data_type	= UVC_CTRL_DATA_TYPE_UNSIGNED,
> +	},
> +	{
> +		.id		= V4L2_CID_ENCODER_PEAK_BIT_RATE,
> +		.name		= "Encoder, peak bit rate",
> +		.entity		= UVC_GUID_UVC_ENCODING,
> +		.selector	= UVC_EU_PEAK_BIT_RATE_CONTROL,
> +		.size		= 32,
> +		.offset		= 0,
> +		.v4l2_type	= V4L2_CTRL_TYPE_INTEGER,
> +		.data_type	= UVC_CTRL_DATA_TYPE_UNSIGNED,
> +	},
> +	{
> +		.id		= V4L2_CID_ENCODER_QP_PARAM_I,
> +		.name		= "Encoder, QP param, I frames",
> +		.entity		= UVC_GUID_UVC_ENCODING,
> +		.selector	= UVC_EU_QUANTIZATION_PARAMS_CONTROL,
> +		.size		= 16,
> +		.offset		= 0,
> +		.v4l2_type	= V4L2_CTRL_TYPE_INTEGER,
> +		.data_type	= UVC_CTRL_DATA_TYPE_UNSIGNED,
> +	},
> +	{
> +		.id		= V4L2_CID_ENCODER_QP_PARAM_P,
> +		.name		= "Encoder, QP param, P frames",
> +		.entity		= UVC_GUID_UVC_ENCODING,
> +		.selector	= UVC_EU_QUANTIZATION_PARAMS_CONTROL,
> +		.size		= 16,
> +		.offset		= 16,
> +		.v4l2_type	= V4L2_CTRL_TYPE_INTEGER,
> +		.data_type	= UVC_CTRL_DATA_TYPE_UNSIGNED,
> +	},
> +	{
> +		.id		= V4L2_CID_ENCODER_QP_PARAM_BG,
> +		.name		= "Encoder, QP param, B/G frames",
> +		.entity		= UVC_GUID_UVC_ENCODING,
> +		.selector	= UVC_EU_QUANTIZATION_PARAMS_CONTROL,
> +		.size		= 16,
> +		.offset		= 32,
> +		.v4l2_type	= V4L2_CTRL_TYPE_INTEGER,
> +		.data_type	= UVC_CTRL_DATA_TYPE_UNSIGNED,
> +	},
> +	{
> +		.id		= V4L2_CID_ENCODER_VP8_SYNC_FRAME_TYPE,
> +		.name		= "Encoder, VP8 sync frame type",
> +		.entity		= UVC_GUID_UVC_ENCODING,
> +		.selector	= UVC_EU_SYNC_REF_FRAME_CONTROL,
> +		.size		= 8,
> +		.offset		= 0,
> +		.v4l2_type	= V4L2_CTRL_TYPE_MENU,
> +		.data_type	= UVC_CTRL_DATA_TYPE_ENUM,
> +		.menu_info	= encoder_vp8_sync_frame_type_controls,
> +		.menu_count	=
> +			ARRAY_SIZE(encoder_vp8_sync_frame_type_controls),
> +	},
> +	{
> +		.id		= V4L2_CID_ENCODER_SYNC_FRAME_INTERVAL,
> +		.name		= "Encoder, sync frame interval",
> +		.entity		= UVC_GUID_UVC_ENCODING,
> +		.selector	= UVC_EU_SYNC_REF_FRAME_CONTROL,
> +		.size		= 16,
> +		.offset		= 8,
> +		.v4l2_type	= V4L2_CTRL_TYPE_INTEGER,
> +		.data_type	= UVC_CTRL_DATA_TYPE_UNSIGNED,
> +	},
> +	{
> +		.id		= V4L2_CID_ENCODER_NUM_GDR_FRAMES,
> +		.name		= "Encoder, number of GDR frames",
> +		.entity		= UVC_GUID_UVC_ENCODING,
> +		.selector	= UVC_EU_SYNC_REF_FRAME_CONTROL,
> +		.size		= 8,
> +		.offset		= 24,
> +		.v4l2_type	= V4L2_CTRL_TYPE_INTEGER,
> +		.data_type	= UVC_CTRL_DATA_TYPE_UNSIGNED,
> +	},
> +	{
> +		.id		= V4L2_CID_ENCODER_LTR_BUFFER_CONTROL,
> +		.name		= "Encoder, LTR buffer control",
> +		.entity		= UVC_GUID_UVC_ENCODING,
> +		.selector	= UVC_EU_LTR_BUFFER_CONTROL,
> +		.size		= 8,
> +		.offset		= 0,
> +		.v4l2_type	= V4L2_CTRL_TYPE_INTEGER,
> +		.data_type	= UVC_CTRL_DATA_TYPE_UNSIGNED,
> +	},
> +	{
> +		.id		= V4L2_CID_ENCODER_LTR_BUFFER_TRUST_MODE,
> +		.name		= "Encoder, LTR buffer trust mode",
> +		.entity		= UVC_GUID_UVC_ENCODING,
> +		.selector	= UVC_EU_LTR_BUFFER_CONTROL,
> +		.size		= 8,
> +		.offset		= 8,
> +		.v4l2_type	= V4L2_CTRL_TYPE_INTEGER,
> +		.data_type	= UVC_CTRL_DATA_TYPE_UNSIGNED,
> +	},
> +	{
> +		.id		= V4L2_CID_ENCODER_LTR_PICTURE_POSITION,
> +		.name		= "Encoder, LTR picture position",
> +		.entity		= UVC_GUID_UVC_ENCODING,
> +		.selector	= UVC_EU_LTR_PICTURE_CONTROL,
> +		.size		= 8,
> +		.offset		= 0,
> +		.v4l2_type	= V4L2_CTRL_TYPE_INTEGER,
> +		.data_type	= UVC_CTRL_DATA_TYPE_UNSIGNED,
> +	},
> +	{
> +		.id		= V4L2_CID_ENCODER_LTR_PICTURE_MODE,
> +		.name		= "Encoder, LTR picture mode",
> +		.entity		= UVC_GUID_UVC_ENCODING,
> +		.selector	= UVC_EU_LTR_PICTURE_CONTROL,
> +		.size		= 8,
> +		.offset		= 8,
> +		.v4l2_type	= V4L2_CTRL_TYPE_INTEGER,
> +		.data_type	= UVC_CTRL_DATA_TYPE_UNSIGNED,
> +	},
> +	{
> +		.id		= V4L2_CID_ENCODER_LTR_VALIDATION,
> +		.name		= "Encoder, LTR validation",
> +		.entity		= UVC_GUID_UVC_ENCODING,
> +		.selector	= UVC_EU_LTR_VALIDATION_CONTROL,
> +		.size		= 16,
> +		.offset		= 0,
> +		.v4l2_type	= V4L2_CTRL_TYPE_BITMASK,
> +		.data_type	= UVC_CTRL_DATA_TYPE_BITMASK,
> +	},
> +	{
> +		.id		= V4L2_CID_ENCODER_H264_LEVEL_IDC_LIMIT,
> +		.name		= "Encoder, H.264 level IDC limit",
> +		.entity		= UVC_GUID_UVC_ENCODING,
> +		.selector	= UVC_EU_LEVEL_IDC_LIMIT_CONTROL,
> +		.size		= 8,
> +		.offset		= 0,
> +		.v4l2_type	= V4L2_CTRL_TYPE_INTEGER,
> +		.data_type	= UVC_CTRL_DATA_TYPE_UNSIGNED,
> +	},
> +	{
> +		.id		= V4L2_CID_ENCODER_H264_SEI_PAYLOAD_TYPE,
> +		.name		= "Encoder, H.264 SEI payload type",
> +		.entity		= UVC_GUID_UVC_ENCODING,
> +		.selector	= UVC_EU_SEI_PAYLOADTYPE_CONTROL,
> +		.size		= 64,
> +		.offset		= 0,
> +		.v4l2_type	= V4L2_CTRL_TYPE_BITMASK,
> +		.data_type	= UVC_CTRL_DATA_TYPE_BITMASK,
> +	},
> +	{
> +		.id		= V4L2_CID_ENCODER_MIN_QP,
> +		.name		= "Encoder, minimum QP param",
> +		.entity		= UVC_GUID_UVC_ENCODING,
> +		.selector	= UVC_EU_QP_RANGE_CONTROL,
> +		.size		= 8,
> +		.offset		= 0,
> +		.v4l2_type	= V4L2_CTRL_TYPE_INTEGER,
> +		.data_type	= UVC_CTRL_DATA_TYPE_SIGNED,

Are the QP values signed ?

> +	},
> +	{
> +		.id		= V4L2_CID_ENCODER_MAX_QP,
> +		.name		= "Encoder, maximum QP param",
> +		.entity		= UVC_GUID_UVC_ENCODING,
> +		.selector	= UVC_EU_QP_RANGE_CONTROL,
> +		.size		= 8,
> +		.offset		= 8,
> +		.v4l2_type	= V4L2_CTRL_TYPE_INTEGER,
> +		.data_type	= UVC_CTRL_DATA_TYPE_SIGNED,
> +	},
> +	{
> +		.id		= V4L2_CID_ENCODER_H264_LAYER_PRIORITY,
> +		.name		= "Encoder, H.264 layer priority",
> +		.entity		= UVC_GUID_UVC_ENCODING,
> +		.selector	= UVC_EU_PRIORITY_CONTROL,
> +		.size		= 8,
> +		.offset		= 0,
> +		.v4l2_type	= V4L2_CTRL_TYPE_INTEGER,
> +		.data_type	= UVC_CTRL_DATA_TYPE_UNSIGNED,
> +	},
> +	{
> +		.id		= V4L2_CID_ENCODER_ERROR_RESILIENCY,
> +		.name		= "Encoder, error resiliency",
> +		.entity		= UVC_GUID_UVC_ENCODING,
> +		.selector	= UVC_EU_ERROR_RESILIENCY_CONTROL,
> +		.size		= 16,
> +		.offset		= 0,
> +		.v4l2_type	= V4L2_CTRL_TYPE_BITMASK,
> +		.data_type	= UVC_CTRL_DATA_TYPE_BITMASK,
> +	},
>  };
> 
>  /* ------------------------------------------------------------------------
> diff --git a/include/uapi/linux/usb/video.h
> b/include/uapi/linux/usb/video.h index e09c50b..fd1d4b0 100644
> --- a/include/uapi/linux/usb/video.h
> +++ b/include/uapi/linux/usb/video.h
> @@ -127,6 +127,29 @@
>  #define UVC_PU_ANALOG_VIDEO_STANDARD_CONTROL		0x11
>  #define UVC_PU_ANALOG_LOCK_STATUS_CONTROL		0x12
> 
> +/* Encoding Unit Control Selectors */
> +#define UVC_EU_CONTROL_UNDEFINED			0x00
> +#define UVC_EU_SELECT_LAYER_CONTROL			0x01
> +#define UVC_EU_PROFILE_TOOLSET_CONTROL			0x02
> +#define UVC_EU_VIDEO_RESOLUTION_CONTROL			0x03
> +#define UVC_EU_MIN_FRAME_INTERVAL_CONTROL		0x04
> +#define UVC_EU_SLICE_MODE_CONTROL			0x05
> +#define UVC_EU_RATE_CONTROL_MODE_CONTROL		0x06
> +#define UVC_EU_AVERAGE_BITRATE_CONTROL			0x07
> +#define UVC_EU_CPB_SIZE_CONTROL				0x08
> +#define UVC_EU_PEAK_BIT_RATE_CONTROL			0x09
> +#define UVC_EU_QUANTIZATION_PARAMS_CONTROL		0x0a
> +#define UVC_EU_SYNC_REF_FRAME_CONTROL			0x0b
> +#define UVC_EU_LTR_BUFFER_CONTROL			0x0c
> +#define UVC_EU_LTR_PICTURE_CONTROL			0x0d
> +#define UVC_EU_LTR_VALIDATION_CONTROL			0x0e
> +#define UVC_EU_LEVEL_IDC_LIMIT_CONTROL			0x0f
> +#define UVC_EU_SEI_PAYLOADTYPE_CONTROL			0x10
> +#define UVC_EU_QP_RANGE_CONTROL				0x11
> +#define UVC_EU_PRIORITY_CONTROL				0x12
> +#define UVC_EU_START_OR_STOP_LAYER_CONTROL		0x13
> +#define UVC_EU_ERROR_RESILIENCY_CONTROL			0x14
> +
>  /* A.9.7. VideoStreaming Interface Control Selectors */
>  #define UVC_VS_CONTROL_UNDEFINED			0x00
>  #define UVC_VS_PROBE_CONTROL				0x01
-- 
Regards,

Laurent Pinchart

