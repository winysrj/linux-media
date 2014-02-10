Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:4682 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084AbaBJJLu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Feb 2014 04:11:50 -0500
Message-ID: <52F897AC.4080003@xs4all.nl>
Date: Mon, 10 Feb 2014 10:11:08 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH 5/5] v4l2-ctl: implement list SDR buffers command
References: <1391925954-25975-1-git-send-email-crope@iki.fi> <1391925954-25975-6-git-send-email-crope@iki.fi>
In-Reply-To: <1391925954-25975-6-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/09/2014 07:05 AM, Antti Palosaari wrote:
> Cc: Hans Verkuil <hverkuil@xs4all.nl>
> Signed-off-by: Antti Palosaari <crope@iki.fi>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks!

	Hans

> ---
>  utils/v4l2-ctl/v4l2-ctl-streaming.cpp | 6 ++++++
>  utils/v4l2-ctl/v4l2-ctl.cpp           | 1 +
>  utils/v4l2-ctl/v4l2-ctl.h             | 1 +
>  3 files changed, 8 insertions(+)
> 
> diff --git a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
> index 13ee8ec..925d73d 100644
> --- a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
> +++ b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
> @@ -78,6 +78,8 @@ void streaming_usage(void)
>  	       "                     list all sliced VBI buffers [VIDIOC_QUERYBUF]\n"
>  	       "  --list-buffers-sliced-vbi-out\n"
>  	       "                     list all sliced VBI output buffers [VIDIOC_QUERYBUF]\n"
> +	       "  --list-buffers-sdr\n"
> +	       "                     list all SDR RX buffers [VIDIOC_QUERYBUF]\n"
>  	       );
>  }
>  
> @@ -986,4 +988,8 @@ void streaming_list(int fd)
>  	if (options[OptListBuffersSlicedVbiOut]) {
>  		list_buffers(fd, V4L2_BUF_TYPE_SLICED_VBI_OUTPUT);
>  	}
> +
> +	if (options[OptListBuffersSdr]) {
> +		list_buffers(fd, V4L2_BUF_TYPE_SDR_CAPTURE);
> +	}
>  }
> diff --git a/utils/v4l2-ctl/v4l2-ctl.cpp b/utils/v4l2-ctl/v4l2-ctl.cpp
> index 855613c..a602366 100644
> --- a/utils/v4l2-ctl/v4l2-ctl.cpp
> +++ b/utils/v4l2-ctl/v4l2-ctl.cpp
> @@ -198,6 +198,7 @@ static struct option long_options[] = {
>  	{"list-buffers-sliced-vbi", no_argument, 0, OptListBuffersSlicedVbi},
>  	{"list-buffers-vbi-out", no_argument, 0, OptListBuffersVbiOut},
>  	{"list-buffers-sliced-vbi-out", no_argument, 0, OptListBuffersSlicedVbiOut},
> +	{"list-buffers-sdr", no_argument, 0, OptListBuffersSdr},
>  	{"stream-count", required_argument, 0, OptStreamCount},
>  	{"stream-skip", required_argument, 0, OptStreamSkip},
>  	{"stream-loop", no_argument, 0, OptStreamLoop},
> diff --git a/utils/v4l2-ctl/v4l2-ctl.h b/utils/v4l2-ctl/v4l2-ctl.h
> index 108198d..1caac34 100644
> --- a/utils/v4l2-ctl/v4l2-ctl.h
> +++ b/utils/v4l2-ctl/v4l2-ctl.h
> @@ -139,6 +139,7 @@ enum Option {
>  	OptListBuffersSlicedVbi,
>  	OptListBuffersVbiOut,
>  	OptListBuffersSlicedVbiOut,
> +	OptListBuffersSdr,
>  	OptStreamCount,
>  	OptStreamSkip,
>  	OptStreamLoop,
> 

