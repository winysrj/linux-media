Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:35382 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752275AbeDFPyv (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 6 Apr 2018 11:54:51 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 18/21] media: isppreview: fix __user annotations
Date: Fri, 06 Apr 2018 18:54:50 +0300
Message-ID: <9078125.KNKj9j4yVL@avalon>
In-Reply-To: <de3b0b55d826e597f2be27f79e6e8177c0022e6a.1523024380.git.mchehab@s-opensource.com>
References: <cover.1523024380.git.mchehab@s-opensource.com> <de3b0b55d826e597f2be27f79e6e8177c0022e6a.1523024380.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Thank you for the patch.

On Friday, 6 April 2018 17:23:19 EEST Mauro Carvalho Chehab wrote:
> That prevent those warnings:
>    drivers/media/platform/omap3isp/isppreview.c:893:45: warning: incorrect
> type in initializer (different address spaces)
> drivers/media/platform/omap3isp/isppreview.c:893:45:    expected void
> [noderef] <asn:1>*from drivers/media/platform/omap3isp/isppreview.c:893:45:
>    got void *[noderef] <asn:1><noident>
> drivers/media/platform/omap3isp/isppreview.c:893:47: warning: dereference
> of noderef expression

That's nice, but it would be even nicer to explain what the problem is and how 
you fix it, otherwise one might be left wondering if the fix is correct, or if 
it could be a false positive.

With the commit message updated,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  drivers/media/platform/omap3isp/isppreview.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/omap3isp/isppreview.c
> b/drivers/media/platform/omap3isp/isppreview.c index
> ac30a0f83780..c2ef5870b231 100644
> --- a/drivers/media/platform/omap3isp/isppreview.c
> +++ b/drivers/media/platform/omap3isp/isppreview.c
> @@ -890,7 +890,7 @@ static int preview_config(struct isp_prev_device *prev,
>  		params = &prev->params.params[!!(active & bit)];
> 
>  		if (cfg->flag & bit) {
> -			void __user *from = *(void * __user *)
> +			void __user *from = *(void __user **)
>  				((void *)cfg + attr->config_offset);
>  			void *to = (void *)params + attr->param_offset;
>  			size_t size = attr->param_size;

-- 
Regards,

Laurent Pinchart
