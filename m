Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:58395 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1757285AbdEVJC4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 May 2017 05:02:56 -0400
Subject: Re: [PATCH] media: platform: s3c-camif: fix function prototype
To: "Gustavo A. R. Silva" <garsilva@embeddedor.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
References: <20170504214200.GA22855@embeddedgus>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <ea039557-023c-736d-5bfb-928cd87cc3e3@xs4all.nl>
Date: Mon, 22 May 2017 11:02:50 +0200
MIME-Version: 1.0
In-Reply-To: <20170504214200.GA22855@embeddedgus>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/04/2017 11:42 PM, Gustavo A. R. Silva wrote:
> Fix function prototype so the position of arguments camif->colorfx_cb and
> camif->colorfx_cr match the order of the parameters when calling
> camif_hw_set_effect() function.
> 
> Addresses-Coverity-ID: 1248800
> Addresses-Coverity-ID: 1269141
> Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
> Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
> ---
>  drivers/media/platform/s3c-camif/camif-regs.c | 2 +-
>  drivers/media/platform/s3c-camif/camif-regs.h | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/s3c-camif/camif-regs.c b/drivers/media/platform/s3c-camif/camif-regs.c
> index 812fb3a..d70ffef 100644
> --- a/drivers/media/platform/s3c-camif/camif-regs.c
> +++ b/drivers/media/platform/s3c-camif/camif-regs.c
> @@ -58,7 +58,7 @@ void camif_hw_set_test_pattern(struct camif_dev *camif, unsigned int pattern)
>  }
>  
>  void camif_hw_set_effect(struct camif_dev *camif, unsigned int effect,
> -			unsigned int cr, unsigned int cb)
> +			unsigned int cb, unsigned int cr)
>  {
>  	static const struct v4l2_control colorfx[] = {
>  		{ V4L2_COLORFX_NONE,		CIIMGEFF_FIN_BYPASS },

This will also affect this line:

cfg |= cr | (cb << 13);

cr and cb are now swapped so this will result in a different color.

Sylwester, who is wrong here: the prototype or how this function is called?

I suspect that Gustavo is right and that the prototype is wrong. But in that
case this patch should also change the cfg assignment.

Regards,

	Hans

> diff --git a/drivers/media/platform/s3c-camif/camif-regs.h b/drivers/media/platform/s3c-camif/camif-regs.h
> index 5ad36c1..dfb49a5 100644
> --- a/drivers/media/platform/s3c-camif/camif-regs.h
> +++ b/drivers/media/platform/s3c-camif/camif-regs.h
> @@ -255,7 +255,7 @@ void camif_hw_set_output_dma(struct camif_vp *vp);
>  void camif_hw_set_target_format(struct camif_vp *vp);
>  void camif_hw_set_test_pattern(struct camif_dev *camif, unsigned int pattern);
>  void camif_hw_set_effect(struct camif_dev *camif, unsigned int effect,
> -			unsigned int cr, unsigned int cb);
> +			unsigned int cb, unsigned int cr);
>  void camif_hw_set_output_addr(struct camif_vp *vp, struct camif_addr *paddr,
>  			      int index);
>  void camif_hw_dump_regs(struct camif_dev *camif, const char *label);
> 
