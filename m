Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:35237 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755986Ab3ICUm4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Sep 2013 16:42:56 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Pawel Osciak <posciak@chromium.org>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v1 05/19] uvcvideo: Add support for UVC1.5 P&C control.
Date: Tue, 03 Sep 2013 22:42:57 +0200
Message-ID: <1725629.k3KbEmyqVG@avalon>
In-Reply-To: <1377829038-4726-6-git-send-email-posciak@chromium.org>
References: <1377829038-4726-1-git-send-email-posciak@chromium.org> <1377829038-4726-6-git-send-email-posciak@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pawel,

Thank you for the patch.

On Friday 30 August 2013 11:17:04 Pawel Osciak wrote:
> Add support for UVC 1.5 Probe & Commit control.
> 
> Signed-off-by: Pawel Osciak <posciak@chromium.org>
> ---
>  drivers/media/usb/uvc/uvc_video.c | 52 +++++++++++++++++++++++++++++++++---
>  include/uapi/linux/usb/video.h    |  7 ++++++
>  2 files changed, 55 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_video.c
> b/drivers/media/usb/uvc/uvc_video.c index 1198989..b4ebccd 100644
> --- a/drivers/media/usb/uvc/uvc_video.c
> +++ b/drivers/media/usb/uvc/uvc_video.c
> @@ -168,14 +168,25 @@ static void uvc_fixup_video_ctrl(struct uvc_streaming
> *stream, }
>  }
> 
> +int uvc_get_probe_ctrl_size(struct uvc_streaming *stream)
> +{
> +	if (stream->dev->uvc_version < 0x0110)
> +		return 26;
> +	else if (stream->dev->uvc_version < 0x0150)
> +		return 34;
> +	else
> +		return 48;
> +}
> +
>  static int uvc_get_video_ctrl(struct uvc_streaming *stream,
>  	struct uvc_streaming_control *ctrl, int probe, __u8 query)
>  {
>  	__u8 *data;
>  	__u16 size;
>  	int ret;
> +	int i;

Could you please make i unsigned, as it's used as an unsigned loop counter ?

> -	size = stream->dev->uvc_version >= 0x0110 ? 34 : 26;
> +	size = uvc_get_probe_ctrl_size(stream);
>  	if ((stream->dev->quirks & UVC_QUIRK_PROBE_DEF) &&
>  			query == UVC_GET_DEF)
>  		return -EIO;
> @@ -230,7 +241,7 @@ static int uvc_get_video_ctrl(struct uvc_streaming
> *stream, ctrl->dwMaxVideoFrameSize = get_unaligned_le32(&data[18]);
>  	ctrl->dwMaxPayloadTransferSize = get_unaligned_le32(&data[22]);
> 
> -	if (size == 34) {
> +	if (size >= 34) {
>  		ctrl->dwClockFrequency = get_unaligned_le32(&data[26]);
>  		ctrl->bmFramingInfo = data[30];
>  		ctrl->bPreferedVersion = data[31];
> @@ -244,6 +255,26 @@ static int uvc_get_video_ctrl(struct uvc_streaming
> *stream, ctrl->bMaxVersion = 0;
>  	}
> 
> +	if (size >= 48) {
> +		ctrl->bUsage = data[34];
> +		ctrl->bBitDepthLuma = data[35];
> +		ctrl->bmSetting = data[36];
> +		ctrl->bMaxNumberOfRefFramesPlus1 = data[37];
> +		ctrl->bmRateControlModes = get_unaligned_le16(&data[38]);
> +		for (i = 0; i < ARRAY_SIZE(ctrl->bmLayoutPerStream); ++i) {
> +			ctrl->bmLayoutPerStream[i] =
> +				get_unaligned_le16(&data[40 + i * 2]);
> +		}
> +	} else {
> +		ctrl->bUsage = 0;
> +		ctrl->bBitDepthLuma = 0;
> +		ctrl->bmSetting = 0;
> +		ctrl->bMaxNumberOfRefFramesPlus1 = 0;
> +		ctrl->bmRateControlModes = 0;
> +		for (i = 0; i < ARRAY_SIZE(ctrl->bmLayoutPerStream); ++i)
> +			ctrl->bmLayoutPerStream[i] = 0;
> +	}

I wonder whether we shouldn't just memset the whole structure to zero to start 
with. What do you think ?

> +
>  	/* Some broken devices return null or wrong dwMaxVideoFrameSize and
>  	 * dwMaxPayloadTransferSize fields. Try to get the value from the
>  	 * format and frame descriptors.
> @@ -262,8 +293,9 @@ static int uvc_set_video_ctrl(struct uvc_streaming
> *stream, __u8 *data;
>  	__u16 size;
>  	int ret;
> +	int i;

Unsigned here as well please.

> 
> -	size = stream->dev->uvc_version >= 0x0110 ? 34 : 26;
> +	size = uvc_get_probe_ctrl_size(stream);
>  	data = kzalloc(size, GFP_KERNEL);
>  	if (data == NULL)
>  		return -ENOMEM;
> @@ -280,7 +312,7 @@ static int uvc_set_video_ctrl(struct uvc_streaming
> *stream, put_unaligned_le32(ctrl->dwMaxVideoFrameSize, &data[18]);
>  	put_unaligned_le32(ctrl->dwMaxPayloadTransferSize, &data[22]);
> 
> -	if (size == 34) {
> +	if (size >= 34) {
>  		put_unaligned_le32(ctrl->dwClockFrequency, &data[26]);
>  		data[30] = ctrl->bmFramingInfo;
>  		data[31] = ctrl->bPreferedVersion;
> @@ -288,6 +320,18 @@ static int uvc_set_video_ctrl(struct uvc_streaming
> *stream, data[33] = ctrl->bMaxVersion;
>  	}
> 
> +	if (size >= 48) {
> +		data[34] = ctrl->bUsage;
> +		data[35] = ctrl->bBitDepthLuma;
> +		data[36] = ctrl->bmSetting;
> +		data[37] = ctrl->bMaxNumberOfRefFramesPlus1;
> +		*(__le16 *)&data[38] = cpu_to_le16(ctrl->bmRateControlModes);
> +		for (i = 0; i < ARRAY_SIZE(ctrl->bmLayoutPerStream); ++i) {
> +			*(__le16 *)&data[40 + i * 2] =
> +				cpu_to_le16(ctrl->bmLayoutPerStream[i]);
> +		}
> +	}
> +
>  	ret = __uvc_query_ctrl(stream->dev, UVC_SET_CUR, 0, stream->intfnum,
>  		probe ? UVC_VS_PROBE_CONTROL : UVC_VS_COMMIT_CONTROL, data,
>  		size, uvc_timeout_param);
> diff --git a/include/uapi/linux/usb/video.h b/include/uapi/linux/usb/video.h
> index 3b3b95e..331c071 100644
> --- a/include/uapi/linux/usb/video.h
> +++ b/include/uapi/linux/usb/video.h
> @@ -432,6 +432,7 @@ struct uvc_color_matching_descriptor {
>  #define UVC_DT_COLOR_MATCHING_SIZE			6
> 
>  /* 4.3.1.1. Video Probe and Commit Controls */
> +#define UVC_NUM_SIMULCAST_STREAMS			4
>  struct uvc_streaming_control {
>  	__u16 bmHint;
>  	__u8  bFormatIndex;
> @@ -449,6 +450,12 @@ struct uvc_streaming_control {
>  	__u8  bPreferedVersion;
>  	__u8  bMinVersion;
>  	__u8  bMaxVersion;
> +	__u8  bUsage;
> +	__u8  bBitDepthLuma;
> +	__u8  bmSetting;
> +	__u8  bMaxNumberOfRefFramesPlus1;
> +	__u16 bmRateControlModes;
> +	__u16 bmLayoutPerStream[UVC_NUM_SIMULCAST_STREAMS];
>  } __attribute__((__packed__));
> 
>  /* Uncompressed Payload - 3.1.1. Uncompressed Video Format Descriptor */
-- 
Regards,

Laurent Pinchart

