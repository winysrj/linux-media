Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:54489 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932868AbeCNCfA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Mar 2018 22:35:00 -0400
Subject: Re: [PATCH v8 03/13] [media] omap3isp: group device capabilities
To: Gustavo Padovan <gustavo@padovan.org>, linux-media@vger.kernel.org
Cc: kernel@collabora.com,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Brian Starkey <brian.starkey@arm.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
References: <20180309174920.22373-1-gustavo@padovan.org>
 <20180309174920.22373-4-gustavo@padovan.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5756fc2a-c2f6-0d14-d8fc-9dcc5f7b7d93@xs4all.nl>
Date: Tue, 13 Mar 2018 19:34:52 -0700
MIME-Version: 1.0
In-Reply-To: <20180309174920.22373-4-gustavo@padovan.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/09/2018 09:49 AM, Gustavo Padovan wrote:
> From: Gustavo Padovan <gustavo.padovan@collabora.com>
> 
> Instead of putting V4L2_CAP_STREAMING everywhere, set device_caps
> earlier with this value.
> 
> Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
> ---
>  drivers/media/platform/omap3isp/ispvideo.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
> index a751c89a3ea8..b4d4ef926749 100644
> --- a/drivers/media/platform/omap3isp/ispvideo.c
> +++ b/drivers/media/platform/omap3isp/ispvideo.c
> @@ -658,13 +658,14 @@ isp_video_querycap(struct file *file, void *fh, struct v4l2_capability *cap)
>  	strlcpy(cap->card, video->video.name, sizeof(cap->card));
>  	strlcpy(cap->bus_info, "media", sizeof(cap->bus_info));
>  
> -	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_VIDEO_OUTPUT
> -		| V4L2_CAP_STREAMING | V4L2_CAP_DEVICE_CAPS;
> +	cap->device_caps = V4L2_CAP_STREAMING;
> +	cap->capabilities = cap->device_caps | V4L2_CAP_VIDEO_CAPTURE |
> +		V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_DEVICE_CAPS;

Same as in patch 1: I'd move this down to after the if-else. It makes more
sense that way.

>  
>  	if (video->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
> -		cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
> +		cap->device_caps |= V4L2_CAP_VIDEO_CAPTURE;
>  	else
> -		cap->device_caps = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREAMING;
> +		cap->device_caps |= V4L2_CAP_VIDEO_OUTPUT;
>  
>  	return 0;
>  }
> 

Regards,

	Hans
