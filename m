Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:58302 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728043AbeIJUcC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Sep 2018 16:32:02 -0400
Message-ID: <d58b839f60c07bef6e08184de243380550e75171.camel@collabora.com>
Subject: Re: [PATCH 2/2] vicodec: set state->info before calling the
 encode/decode funcs
From: Ezequiel Garcia <ezequiel@collabora.com>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Date: Mon, 10 Sep 2018 12:37:12 -0300
In-Reply-To: <20180910150040.39265-2-hverkuil@xs4all.nl>
References: <20180910150040.39265-1-hverkuil@xs4all.nl>
         <20180910150040.39265-2-hverkuil@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2018-09-10 at 17:00 +0200, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> state->info was NULL since I completely forgot to set state->info.
> Oops.
> 
> Reported-by: Ezequiel Garcia <ezequiel@collabora.com>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

For both patches:

Tested-by: Ezequiel Garcia <ezequiel@collabora.com>

With these changes, now this gstreamer pipeline no longer
crashes:

gst-launch-1.0 -v videotestsrc num-buffers=30 ! video/x-raw,width=1280,height=720 ! v4l2fwhtenc capture-io-mode=mmap output-io-mode=mmap ! v4l2fwhtdec
capture-io-mode=mmap output-io-mode=mmap ! fakesink

A few things:

  * You now need to mark "[PATCH] vicodec: fix sparse warning" as invalid.
  * v4l2fwhtenc/v4l2fwhtdec elements are not upstream yet.
  * Gstreamer doesn't end properly; and it seems to negotiate
    different sizes for encoded and decoded unless explicitly set.

Thanks!

>  drivers/media/platform/vicodec/vicodec-core.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
> index fdd77441a47b..5d42a8414283 100644
> --- a/drivers/media/platform/vicodec/vicodec-core.c
> +++ b/drivers/media/platform/vicodec/vicodec-core.c
> @@ -176,12 +176,15 @@ static int device_process(struct vicodec_ctx *ctx,
>  	}
>  
>  	if (ctx->is_enc) {
> -		unsigned int size = v4l2_fwht_encode(state, p_in, p_out);
> -
> -		vb2_set_plane_payload(&out_vb->vb2_buf, 0, size);
> +		state->info = q_out->info;
> +		ret = v4l2_fwht_encode(state, p_in, p_out);
> +		if (ret < 0)
> +			return ret;
> +		vb2_set_plane_payload(&out_vb->vb2_buf, 0, ret);
>  	} else {
> +		state->info = q_cap->info;
>  		ret = v4l2_fwht_decode(state, p_in, p_out);
> -		if (ret)
> +		if (ret < 0)
>  			return ret;
>  		vb2_set_plane_payload(&out_vb->vb2_buf, 0, q_cap->sizeimage);
>  	}
