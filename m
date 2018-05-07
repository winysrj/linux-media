Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:53458 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750881AbeEGNpz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 7 May 2018 09:45:55 -0400
Subject: Re: [PATCH v9 07/15] v4l: mark unordered formats
To: Ezequiel Garcia <ezequiel@collabora.com>,
        linux-media@vger.kernel.org
Cc: kernel@collabora.com,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Brian Starkey <brian.starkey@arm.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
References: <20180504200612.8763-1-ezequiel@collabora.com>
 <20180504200612.8763-8-ezequiel@collabora.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <967f1373-c1e2-674c-bd94-3243c20e986b@xs4all.nl>
Date: Mon, 7 May 2018 15:45:53 +0200
MIME-Version: 1.0
In-Reply-To: <20180504200612.8763-8-ezequiel@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/05/18 22:06, Ezequiel Garcia wrote:
> From: Gustavo Padovan <gustavo.padovan@collabora.com>
> 
> Now that we've introduced the V4L2_FMT_FLAG_UNORDERED flag,
> mark the appropriate formats.
> 
> Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
> ---
>  drivers/media/v4l2-core/v4l2-ioctl.c | 55 ++++++++++++++++++++----------------
>  1 file changed, 30 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
> index f48c505550e0..f75ad954a6f2 100644
> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> @@ -1260,20 +1260,6 @@ static void v4l_fill_fmtdesc(struct v4l2_fmtdesc *fmt)
>  		case V4L2_PIX_FMT_MJPEG:	descr = "Motion-JPEG"; break;
>  		case V4L2_PIX_FMT_JPEG:		descr = "JFIF JPEG"; break;
>  		case V4L2_PIX_FMT_DV:		descr = "1394"; break;
> -		case V4L2_PIX_FMT_MPEG:		descr = "MPEG-1/2/4"; break;
> -		case V4L2_PIX_FMT_H264:		descr = "H.264"; break;
> -		case V4L2_PIX_FMT_H264_NO_SC:	descr = "H.264 (No Start Codes)"; break;
> -		case V4L2_PIX_FMT_H264_MVC:	descr = "H.264 MVC"; break;
> -		case V4L2_PIX_FMT_H263:		descr = "H.263"; break;
> -		case V4L2_PIX_FMT_MPEG1:	descr = "MPEG-1 ES"; break;
> -		case V4L2_PIX_FMT_MPEG2:	descr = "MPEG-2 ES"; break;
> -		case V4L2_PIX_FMT_MPEG4:	descr = "MPEG-4 part 2 ES"; break;
> -		case V4L2_PIX_FMT_XVID:		descr = "Xvid"; break;
> -		case V4L2_PIX_FMT_VC1_ANNEX_G:	descr = "VC-1 (SMPTE 412M Annex G)"; break;
> -		case V4L2_PIX_FMT_VC1_ANNEX_L:	descr = "VC-1 (SMPTE 412M Annex L)"; break;
> -		case V4L2_PIX_FMT_VP8:		descr = "VP8"; break;
> -		case V4L2_PIX_FMT_VP9:		descr = "VP9"; break;
> -		case V4L2_PIX_FMT_HEVC:		descr = "HEVC"; break; /* aka H.265 */
>  		case V4L2_PIX_FMT_CPIA1:	descr = "GSPCA CPiA YUV"; break;
>  		case V4L2_PIX_FMT_WNVA:		descr = "WNVA"; break;
>  		case V4L2_PIX_FMT_SN9C10X:	descr = "GSPCA SN9C10X"; break;
> @@ -1294,17 +1280,36 @@ static void v4l_fill_fmtdesc(struct v4l2_fmtdesc *fmt)
>  		case V4L2_PIX_FMT_S5C_UYVY_JPG:	descr = "S5C73MX interleaved UYVY/JPEG"; break;
>  		case V4L2_PIX_FMT_MT21C:	descr = "Mediatek Compressed Format"; break;
>  		default:
> -			WARN(1, "Unknown pixelformat 0x%08x\n", fmt->pixelformat);
> -			if (fmt->description[0])
> -				return;
> -			flags = 0;
> -			snprintf(fmt->description, sz, "%c%c%c%c%s",
> -					(char)(fmt->pixelformat & 0x7f),
> -					(char)((fmt->pixelformat >> 8) & 0x7f),
> -					(char)((fmt->pixelformat >> 16) & 0x7f),
> -					(char)((fmt->pixelformat >> 24) & 0x7f),
> -					(fmt->pixelformat & (1 << 31)) ? "-BE" : "");
> -			break;
> +			/* Unordered formats */
> +			flags = V4L2_FMT_FLAG_UNORDERED;

I realized that this is a problem since this function is called *after*
the driver. So the driver has no chance to clear this flag if it knows
that the queue is always ordered.

I think this needs to be split: first set the UNORDERED flag for the selected
formats, then call the driver, then fill in the rest.

Note that this function sets fmt->flags, this should become |=. Otherwise
the UNORDERED flag would be overwritten.

It's a bit messy, but I don't see a better approach. Except by setting the
UNORDERED flag in the drivers, but I prefer this more defensive approach
(i.e. presumed unordered, unless stated otherwise).

Regards,

	Hans

> +			switch (fmt->pixelformat) {
> +			case V4L2_PIX_FMT_MPEG:		descr = "MPEG-1/2/4"; break;
> +			case V4L2_PIX_FMT_H264:		descr = "H.264"; break;
> +			case V4L2_PIX_FMT_H264_NO_SC:	descr = "H.264 (No Start Codes)"; break;
> +			case V4L2_PIX_FMT_H264_MVC:	descr = "H.264 MVC"; break;
> +			case V4L2_PIX_FMT_H263:		descr = "H.263"; break;
> +			case V4L2_PIX_FMT_MPEG1:	descr = "MPEG-1 ES"; break;
> +			case V4L2_PIX_FMT_MPEG2:	descr = "MPEG-2 ES"; break;
> +			case V4L2_PIX_FMT_MPEG4:	descr = "MPEG-4 part 2 ES"; break;
> +			case V4L2_PIX_FMT_XVID:		descr = "Xvid"; break;
> +			case V4L2_PIX_FMT_VC1_ANNEX_G:	descr = "VC-1 (SMPTE 412M Annex G)"; break;
> +			case V4L2_PIX_FMT_VC1_ANNEX_L:	descr = "VC-1 (SMPTE 412M Annex L)"; break;
> +			case V4L2_PIX_FMT_VP8:		descr = "VP8"; break;
> +			case V4L2_PIX_FMT_VP9:		descr = "VP9"; break;
> +			case V4L2_PIX_FMT_HEVC:		descr = "HEVC"; break; /* aka H.265 */
> +			default:
> +				WARN(1, "Unknown pixelformat 0x%08x\n", fmt->pixelformat);
> +				if (fmt->description[0])
> +					return;
> +				flags = 0;
> +				snprintf(fmt->description, sz, "%c%c%c%c%s",
> +						(char)(fmt->pixelformat & 0x7f),
> +						(char)((fmt->pixelformat >> 8) & 0x7f),
> +						(char)((fmt->pixelformat >> 16) & 0x7f),
> +						(char)((fmt->pixelformat >> 24) & 0x7f),
> +						(fmt->pixelformat & (1 << 31)) ? "-BE" : "");
> +				break;
> +			}
>  		}
>  	}
>  
> 
