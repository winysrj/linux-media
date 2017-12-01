Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:36935 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752390AbdLAMr6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 1 Dec 2017 07:47:58 -0500
Subject: Re: [PATCH] media: imx: Remove incorrect check for queue state in
 start_streaming
To: Ian Jamison <ian.dev@arkver.com>, linux-media@vger.kernel.org,
        Steve Longerbeam <slongerbeam@gmail.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>
References: <37124a40f1388b0b0a2f2226661280962f23102d.1510942589.git.ian.dev@arkver.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <67dce84a-1bb9-9cab-221a-501244244d17@xs4all.nl>
Date: Fri, 1 Dec 2017 13:47:53 +0100
MIME-Version: 1.0
In-Reply-To: <37124a40f1388b0b0a2f2226661280962f23102d.1510942589.git.ian.dev@arkver.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/17/17 19:23, Ian Jamison wrote:
> It is possible to call STREAMON without the minimum number of
> buffers queued. In this case the vb2_queue state will be set to
> streaming but the start_streaming vb2_op will not be called.
> Later when enough buffers are queued, start_streaming will
> be called but vb2_is_streaming will already return true.
> 
> Signed-off-by: Ian Jamison <ian.dev@arkver.com>
> ---
>  drivers/staging/media/imx/imx-media-capture.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/staging/media/imx/imx-media-capture.c b/drivers/staging/media/imx/imx-media-capture.c
> index ddab4c249da2..34b492c2419c 100644
> --- a/drivers/staging/media/imx/imx-media-capture.c
> +++ b/drivers/staging/media/imx/imx-media-capture.c
> @@ -449,9 +449,6 @@ static int capture_start_streaming(struct vb2_queue *vq, unsigned int count)
>  	unsigned long flags;
>  	int ret;
>  
> -	if (vb2_is_streaming(vq))
> -		return 0;
> -
>  	ret = imx_media_pipeline_set_stream(priv->md, &priv->src_sd->entity,
>  					    true);
>  	if (ret) {
> 

Can you also remove this from capture_stop_streaming:

        if (!vb2_is_streaming(vq))
                return;

Both checks are wrong and pointless. The vb2 core will do all the right checks
and this shouldn't be done again (and wrongly) in the driver.

Regards,

	Hans
