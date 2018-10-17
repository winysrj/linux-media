Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:54158 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727787AbeJQP5C (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 17 Oct 2018 11:57:02 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Heng-Ruey Hsu <henryhsu@chromium.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        jcliang@chromium.org, tfiga@chromium.org
Subject: Re: [PATCH] media: uvcvideo: Add boottime clock support
Date: Wed, 17 Oct 2018 11:02:40 +0300
Message-ID: <13883852.6N9L7C0n48@avalon>
In-Reply-To: <20181017075242.21790-1-henryhsu@chromium.org>
References: <20181017075242.21790-1-henryhsu@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Heng-Ruey,

Thank you for the patch.

On Wednesday, 17 October 2018 10:52:42 EEST Heng-Ruey Hsu wrote:
> Android requires camera timestamps to be reported with
> CLOCK_BOOTTIME to sync timestamp with other sensor sources.

What's the rationale behind this, why can't CLOCK_MONOTONIC work ? If the 
monotonic clock has shortcomings that make its use impossible for proper 
synchronization, then we should consider switching to CLOCK_BOOTTIME globally 
in V4L2, not in selected drivers only.

> Signed-off-by: Heng-Ruey Hsu <henryhsu@chromium.org>
> ---
>  drivers/media/usb/uvc/uvc_driver.c | 4 ++++
>  drivers/media/usb/uvc/uvc_video.c  | 2 ++
>  2 files changed, 6 insertions(+)
> 
> diff --git a/drivers/media/usb/uvc/uvc_driver.c
> b/drivers/media/usb/uvc/uvc_driver.c index d46dc432456c..a9658f38c586
> 100644
> --- a/drivers/media/usb/uvc/uvc_driver.c
> +++ b/drivers/media/usb/uvc/uvc_driver.c
> @@ -2287,6 +2287,8 @@ static int uvc_clock_param_get(char *buffer, const
> struct kernel_param *kp) {
>  	if (uvc_clock_param == CLOCK_MONOTONIC)
>  		return sprintf(buffer, "CLOCK_MONOTONIC");
> +	else if (uvc_clock_param == CLOCK_BOOTTIME)
> +		return sprintf(buffer, "CLOCK_BOOTTIME");
>  	else
>  		return sprintf(buffer, "CLOCK_REALTIME");
>  }
> @@ -2298,6 +2300,8 @@ static int uvc_clock_param_set(const char *val, const
> struct kernel_param *kp)
> 
>  	if (strcasecmp(val, "monotonic") == 0)
>  		uvc_clock_param = CLOCK_MONOTONIC;
> +	else if (strcasecmp(val, "boottime") == 0)
> +		uvc_clock_param = CLOCK_BOOTTIME;
>  	else if (strcasecmp(val, "realtime") == 0)
>  		uvc_clock_param = CLOCK_REALTIME;
>  	else
> diff --git a/drivers/media/usb/uvc/uvc_video.c
> b/drivers/media/usb/uvc/uvc_video.c index 86a99f461fd8..d4248d5cd9cd 100644
> --- a/drivers/media/usb/uvc/uvc_video.c
> +++ b/drivers/media/usb/uvc/uvc_video.c
> @@ -425,6 +425,8 @@ static inline ktime_t uvc_video_get_time(void)
>  {
>  	if (uvc_clock_param == CLOCK_MONOTONIC)
>  		return ktime_get();
> +	else if (uvc_clock_param == CLOCK_BOOTTIME)
> +		return ktime_get_boottime();
>  	else
>  		return ktime_get_real();
>  }

-- 
Regards,

Laurent Pinchart
