Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:46739 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751208AbdLAS7A (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Dec 2017 13:59:00 -0500
Received: by mail-pl0-f67.google.com with SMTP id i6so6763356plt.13
        for <linux-media@vger.kernel.org>; Fri, 01 Dec 2017 10:59:00 -0800 (PST)
Subject: Re: [PATCH v2] media: imx: Remove incorrect check for queue state in
 start/stop_streaming
To: Ian Jamison <ian.dev@arkver.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: Philipp Zabel <p.zabel@pengutronix.de>
References: <ac504a93b483b40a8b2f9087af8c6d25672c7d6c.1512154062.git.ian.dev@arkver.com>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <07fd2bff-03b4-dfbe-86e1-ddd7f5d98cf2@gmail.com>
Date: Fri, 1 Dec 2017 10:58:57 -0800
MIME-Version: 1.0
In-Reply-To: <ac504a93b483b40a8b2f9087af8c6d25672c7d6c.1512154062.git.ian.dev@arkver.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 12/01/2017 10:53 AM, Ian Jamison wrote:
> It is possible to call STREAMON without the minimum number of
> buffers queued. In this case the vb2_queue state will be set to
> streaming but the start_streaming vb2_op will not be called.
> Later when enough buffers are queued, start_streaming will
> be called but vb2_is_streaming will already return true.
>
> Also removed the queue state check in stop_streaming since it's
> not valid there either.

Reviewed-by: Steve Longerbeam <steve_longerbeam@mentor.com>

> Signed-off-by: Ian Jamison <ian.dev@arkver.com>
> ---
> Since v1:
>      Remove check in capture_stop_streaming as recommended by Hans.
>
>   drivers/staging/media/imx/imx-media-capture.c | 6 ------
>   1 file changed, 6 deletions(-)
>
> diff --git a/drivers/staging/media/imx/imx-media-capture.c b/drivers/staging/media/imx/imx-media-capture.c
> index ea145bafb880..7b6763802db8 100644
> --- a/drivers/staging/media/imx/imx-media-capture.c
> +++ b/drivers/staging/media/imx/imx-media-capture.c
> @@ -449,9 +449,6 @@ static int capture_start_streaming(struct vb2_queue *vq, unsigned int count)
>   	unsigned long flags;
>   	int ret;
>   
> -	if (vb2_is_streaming(vq))
> -		return 0;
> -
>   	ret = imx_media_pipeline_set_stream(priv->md, &priv->src_sd->entity,
>   					    true);
>   	if (ret) {
> @@ -480,9 +477,6 @@ static void capture_stop_streaming(struct vb2_queue *vq)
>   	unsigned long flags;
>   	int ret;
>   
> -	if (!vb2_is_streaming(vq))
> -		return;
> -
>   	spin_lock_irqsave(&priv->q_lock, flags);
>   	priv->stop = true;
>   	spin_unlock_irqrestore(&priv->q_lock, flags);
