Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52539 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752631AbdJPOlm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Oct 2017 10:41:42 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Baoyou Xie <baoyou.xie@linaro.org>
Cc: mchehab@kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, baoyou.xie@gmail.com,
        xie.baoyou@zte.com.cn
Subject: Re: [PATCH v1] [media] uvcvideo: mark buffer error where overflow
Date: Mon, 16 Oct 2017 17:41:59 +0300
Message-ID: <14244403.6AF0m6muUx@avalon>
In-Reply-To: <1504753188-8766-1-git-send-email-baoyou.xie@linaro.org>
References: <1504753188-8766-1-git-send-email-baoyou.xie@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Baoyou,

Thank you for the patch.

On Thursday, 7 September 2017 05:59:48 EEST Baoyou Xie wrote:
> Some cameras post inaccurate frame where next frame data overlap
> it. this results in screen flicker, and it need to be prevented.
> 
> So this patch marks the buffer error to discard the frame where
> buffer overflow.

I've thought about this before and I wasn't sure how to handle this case. As 
such an overflow might not signal an erroneous buffer, as the buffer could 
contain a valid image. However, if you have seen erroneous buffer contents in 
this case, and given that overflows should not occur, I think we could decide 
to stay on the safe side and set the error flag.

> Signed-off-by: Baoyou Xie <baoyou.xie@linaro.org>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

I'll apply the patch to my tree.

> ---
>  drivers/media/usb/uvc/uvc_video.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/media/usb/uvc/uvc_video.c
> b/drivers/media/usb/uvc/uvc_video.c index fb86d6a..81a3530 100644
> --- a/drivers/media/usb/uvc/uvc_video.c
> +++ b/drivers/media/usb/uvc/uvc_video.c
> @@ -1077,6 +1077,7 @@ static void uvc_video_decode_data(struct uvc_streaming
> *stream, /* Complete the current frame if the buffer size was exceeded. */
> if (len > maxlen) {
>  		uvc_trace(UVC_TRACE_FRAME, "Frame complete (overflow).\n");
> +		buf->error = 1;
>  		buf->state = UVC_BUF_STATE_READY;
>  	}
>  }


-- 
Regards,

Laurent Pinchart
