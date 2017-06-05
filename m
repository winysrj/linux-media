Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:12015 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751499AbdFEKHa (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Jun 2017 06:07:30 -0400
Subject: Re: [PATCH] media: platform: s3c-camif: fix arguments position in
 function call
To: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <593b0303-7273-758c-cb6e-c6f97f66a4b9@samsung.com>
Date: Mon, 05 Jun 2017 12:07:23 +0200
MIME-version: 1.0
In-reply-to: <20170602034341.GA5349@embeddedgus>
Content-type: text/plain; charset="utf-8"; format="flowed"
Content-language: en-GB
Content-transfer-encoding: 7bit
References: <CGME20170602034354epcas1p1bfea44bea994a5cbd8095a8f4da09cd0@epcas1p1.samsung.com>
        <20170602034341.GA5349@embeddedgus>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/02/2017 05:43 AM, Gustavo A. R. Silva wrote:
> Hi Sylwester,
> 
> Here is another patch in case you decide that it is
> better to apply this one.

Thanks, I applied this patch.  In future please put any comments only after
the scissors ("---") line, the comments can be then discarded automatically
and there will be no need for manually editing the patch before applying.

--
Regards,
Sylwester

> Fix the position of the arguments in function call.
> 
> Addresses-Coverity-ID: 1248800
> Addresses-Coverity-ID: 1269141
> Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
> ---
^^^^^

>   drivers/media/platform/s3c-camif/camif-capture.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/s3c-camif/camif-capture.c b/drivers/media/platform/s3c-camif/camif-capture.c
> index 1b30be72..25c7a7d 100644
> --- a/drivers/media/platform/s3c-camif/camif-capture.c
> +++ b/drivers/media/platform/s3c-camif/camif-capture.c
> @@ -80,7 +80,7 @@ static int s3c_camif_hw_init(struct camif_dev *camif, struct camif_vp *vp)
>   	camif_hw_set_test_pattern(camif, camif->test_pattern);
>   	if (variant->has_img_effect)
>   		camif_hw_set_effect(camif, camif->colorfx,
> -				camif->colorfx_cb, camif->colorfx_cr);
> +				camif->colorfx_cr, camif->colorfx_cb);
>   	if (variant->ip_revision == S3C6410_CAMIF_IP_REV)
>   		camif_hw_set_input_path(vp);
>   	camif_cfg_video_path(vp);
> @@ -364,7 +364,7 @@ irqreturn_t s3c_camif_irq_handler(int irq, void *priv)
>   		camif_hw_set_test_pattern(camif, camif->test_pattern);
>   		if (camif->variant->has_img_effect)
>   			camif_hw_set_effect(camif, camif->colorfx,
> -				    camif->colorfx_cb, camif->colorfx_cr);
> +				    camif->colorfx_cr, camif->colorfx_cb);
>   		vp->state &= ~ST_VP_CONFIG;
>   	}
>   unlock:
