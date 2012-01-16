Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:26891 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754113Ab2APOJN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jan 2012 09:09:13 -0500
Received: from epcpsbgm1.samsung.com (mailout2.samsung.com [203.254.224.25])
 by mailout2.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LXW00I7W9Z7GNK0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 16 Jan 2012 23:09:11 +0900 (KST)
Received: from AMDN157 ([106.116.48.215])
 by mmp2.samsung.com (Oracle Communications Messaging Exchange Server 7u4-19.01
 64bit (built Sep  7 2010)) with ESMTPA id <0LXW005V99Z8N690@mmp2.samsung.com>
 for linux-media@vger.kernel.org; Mon, 16 Jan 2012 23:09:11 +0900 (KST)
From: Kamil Debski <k.debski@samsung.com>
To: 'Hans Verkuil' <hverkuil@xs4all.nl>,
	'linux-media' <linux-media@vger.kernel.org>,
	'Sakari Ailus' <sakari.ailus@iki.fi>
References: <201201161435.43652.hverkuil@xs4all.nl>
In-reply-to: <201201161435.43652.hverkuil@xs4all.nl>
Subject: RE: [RFC PATCH] Fixup control names to use consistent capitalization
Date: Mon, 16 Jan 2012 15:09:06 +0100
Message-id: <000201ccd458$6b3d6ce0$41b846a0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: en-gb
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

> From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
> Sent: 16 January 2012 14:36
> 
> Hi all,
> 
> This patch fixes several control names with inconsistent capitalization and
> other inconsistencies (and a spelling mistake in one name as well).
> 
> Kamil, Sakari, please take a look as most of the affected strings are either
> MPEG or Flash controls.

Thank you for your patch.
I've had a look at the codec controls and all seems fine.

> Note that I saw a few strings as well that are longer then 31 characters.
> Those will be cut off when returns in queryctrl. I'm not sure yet what to
> do about those.
> 

I think it's sensible to abbreviate them. You can find one suggestion below.

Best wishes,
--
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center

> diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-
> ctrls.c
> index da1f4c2..c860b06 100644
> --- a/drivers/media/video/v4l2-ctrls.c
> +++ b/drivers/media/video/v4l2-ctrls.c
> @@ -510,21 +510,21 @@ const char *v4l2_ctrl_get_name(u32 id)
>  	case V4L2_CID_MPEG_VIDEO_FRAME_RC_ENABLE:		return "Frame
Level
> Rate Control Enable";
>  	case V4L2_CID_MPEG_VIDEO_MB_RC_ENABLE:			return "H264 MB
> Level Rate Control";
>  	case V4L2_CID_MPEG_VIDEO_HEADER_MODE:			return "Sequence
> Header Mode";
> -	case V4L2_CID_MPEG_VIDEO_MAX_REF_PIC:			return "The Max
> Number of Reference Picture";
> +	case V4L2_CID_MPEG_VIDEO_MAX_REF_PIC:			return "Max
> Number of Reference Pictures";

This could be "Max Number of Reference Pics" or
"Max Number of Ref Pictures".

>  	case V4L2_CID_MPEG_VIDEO_H263_I_FRAME_QP:		return "H263
I-Frame
> QP Value";
> -	case V4L2_CID_MPEG_VIDEO_H263_P_FRAME_QP:		return "H263 P
frame
> QP Value";
> -	case V4L2_CID_MPEG_VIDEO_H263_B_FRAME_QP:		return "H263 B
frame
> QP Value";
> +	case V4L2_CID_MPEG_VIDEO_H263_P_FRAME_QP:		return "H263
P-Frame
> QP Value";
> +	case V4L2_CID_MPEG_VIDEO_H263_B_FRAME_QP:		return "H263
B-Frame
> QP Value";
>  	case V4L2_CID_MPEG_VIDEO_H263_MIN_QP:			return "H263
> Minimum QP Value";
>  	case V4L2_CID_MPEG_VIDEO_H263_MAX_QP:			return "H263
> Maximum QP Value";
>  	case V4L2_CID_MPEG_VIDEO_H264_I_FRAME_QP:		return "H264
I-Frame
> QP Value";
> -	case V4L2_CID_MPEG_VIDEO_H264_P_FRAME_QP:		return "H264 P
frame
> QP Value";
> -	case V4L2_CID_MPEG_VIDEO_H264_B_FRAME_QP:		return "H264 B
frame
> QP Value";
> +	case V4L2_CID_MPEG_VIDEO_H264_P_FRAME_QP:		return "H264
P-Frame
> QP Value";
> +	case V4L2_CID_MPEG_VIDEO_H264_B_FRAME_QP:		return "H264
B-Frame
> QP Value";
>  	case V4L2_CID_MPEG_VIDEO_H264_MAX_QP:			return "H264
> Maximum QP Value";
>  	case V4L2_CID_MPEG_VIDEO_H264_MIN_QP:			return "H264
> Minimum QP Value";
>  	case V4L2_CID_MPEG_VIDEO_H264_8X8_TRANSFORM:		return "H264 8x8
> Transform Enable";
>  	case V4L2_CID_MPEG_VIDEO_H264_CPB_SIZE:			return "H264 CPB
> Buffer Size";
> -	case V4L2_CID_MPEG_VIDEO_H264_ENTROPY_MODE:		return "H264
> Entorpy Mode";
> -	case V4L2_CID_MPEG_VIDEO_H264_I_PERIOD:			return "H264 I
> Period";
> +	case V4L2_CID_MPEG_VIDEO_H264_ENTROPY_MODE:		return "H264
> Entropy Mode";
> +	case V4L2_CID_MPEG_VIDEO_H264_I_PERIOD:			return "H264 I-
> Frame Period";
>  	case V4L2_CID_MPEG_VIDEO_H264_LEVEL:			return "H264
> Level";
>  	case V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_ALPHA:	return "H264
> Loop Filter Alpha Offset";
>  	case V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_BETA:		return "H264
> Loop Filter Beta Offset";
> @@ -535,16 +535,16 @@ const char *v4l2_ctrl_get_name(u32 id)
>  	case V4L2_CID_MPEG_VIDEO_H264_VUI_SAR_ENABLE:		return "Aspect
> Ratio VUI Enable";
>  	case V4L2_CID_MPEG_VIDEO_H264_VUI_SAR_IDC:		return "VUI
> Aspect Ratio IDC";
>  	case V4L2_CID_MPEG_VIDEO_MPEG4_I_FRAME_QP:		return "MPEG4 I-
> Frame QP Value";
> -	case V4L2_CID_MPEG_VIDEO_MPEG4_P_FRAME_QP:		return "MPEG4 P
> frame QP Value";
> -	case V4L2_CID_MPEG_VIDEO_MPEG4_B_FRAME_QP:		return "MPEG4 B
> frame QP Value";
> +	case V4L2_CID_MPEG_VIDEO_MPEG4_P_FRAME_QP:		return "MPEG4 P-
> Frame QP Value";
> +	case V4L2_CID_MPEG_VIDEO_MPEG4_B_FRAME_QP:		return "MPEG4 B-
> Frame QP Value";
>  	case V4L2_CID_MPEG_VIDEO_MPEG4_MIN_QP:			return "MPEG4
> Minimum QP Value";
>  	case V4L2_CID_MPEG_VIDEO_MPEG4_MAX_QP:			return "MPEG4
> Maximum QP Value";
>  	case V4L2_CID_MPEG_VIDEO_MPEG4_LEVEL:			return "MPEG4
> Level";
>  	case V4L2_CID_MPEG_VIDEO_MPEG4_PROFILE:			return "MPEG4
> Profile";
>  	case V4L2_CID_MPEG_VIDEO_MPEG4_QPEL:			return "Quarter
> Pixel Search Enable";
> -	case V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MAX_BYTES:		return "The
> Maximum Bytes Per Slice";
> -	case V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MAX_MB:		return "The
> Number of MB in a Slice";
> -	case V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MODE:		return "The
> Slice Partitioning Method";
> +	case V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MAX_BYTES:		return "Maximum
> Bytes in a Slice";
> +	case V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MAX_MB:		return "Number
> of MBs in a Slice";
> +	case V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MODE:		return "Slice
> Partitioning Method";
>  	case V4L2_CID_MPEG_VIDEO_VBV_SIZE:			return "VBV
Buffer
> Size";
> 
>  	/* CAMERA controls */
> @@ -588,24 +588,24 @@ const char *v4l2_ctrl_get_name(u32 id)
>  	case V4L2_CID_PILOT_TONE_ENABLED:	return "Pilot Tone Feature
> Enabled";
>  	case V4L2_CID_PILOT_TONE_DEVIATION:	return "Pilot Tone Deviation";
>  	case V4L2_CID_PILOT_TONE_FREQUENCY:	return "Pilot Tone Frequency";
> -	case V4L2_CID_TUNE_PREEMPHASIS:		return "Pre-emphasis
> settings";
> +	case V4L2_CID_TUNE_PREEMPHASIS:		return "Pre-Emphasis";
>  	case V4L2_CID_TUNE_POWER_LEVEL:		return "Tune Power Level";
>  	case V4L2_CID_TUNE_ANTENNA_CAPACITOR:	return "Tune Antenna
> Capacitor";
> 
>  	/* Flash controls */
> -	case V4L2_CID_FLASH_CLASS:		return "Flash controls";
> -	case V4L2_CID_FLASH_LED_MODE:		return "LED mode";
> -	case V4L2_CID_FLASH_STROBE_SOURCE:	return "Strobe source";
> +	case V4L2_CID_FLASH_CLASS:		return "Flash Controls";
> +	case V4L2_CID_FLASH_LED_MODE:		return "LED Mode";
> +	case V4L2_CID_FLASH_STROBE_SOURCE:	return "Strobe Source";
>  	case V4L2_CID_FLASH_STROBE:		return "Strobe";
> -	case V4L2_CID_FLASH_STROBE_STOP:	return "Stop strobe";
> -	case V4L2_CID_FLASH_STROBE_STATUS:	return "Strobe status";
> -	case V4L2_CID_FLASH_TIMEOUT:		return "Strobe timeout";
> -	case V4L2_CID_FLASH_INTENSITY:		return "Intensity, flash
> mode";
> -	case V4L2_CID_FLASH_TORCH_INTENSITY:	return "Intensity, torch
> mode";
> -	case V4L2_CID_FLASH_INDICATOR_INTENSITY: return "Intensity, indicator";
> +	case V4L2_CID_FLASH_STROBE_STOP:	return "Stop Strobe";
> +	case V4L2_CID_FLASH_STROBE_STATUS:	return "Strobe Status";
> +	case V4L2_CID_FLASH_TIMEOUT:		return "Strobe Timeout";
> +	case V4L2_CID_FLASH_INTENSITY:		return "Intensity, Flash
> Mode";
> +	case V4L2_CID_FLASH_TORCH_INTENSITY:	return "Intensity, Torch
> Mode";
> +	case V4L2_CID_FLASH_INDICATOR_INTENSITY: return "Intensity, Indicator";
>  	case V4L2_CID_FLASH_FAULT:		return "Faults";
>  	case V4L2_CID_FLASH_CHARGE:		return "Charge";
> -	case V4L2_CID_FLASH_READY:		return "Ready to strobe";
> +	case V4L2_CID_FLASH_READY:		return "Ready to Strobe";
> 
>  	default:
>  		return NULL;





