Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:60374 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727177AbeHHSFW (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 8 Aug 2018 14:05:22 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 5/6] media: isp: fix a warning about a wrong struct initializer
Date: Wed, 08 Aug 2018 18:45:49 +0300
Message-ID: <1638882.BEPym44MaE@avalon>
In-Reply-To: <cf5719a1cb77e6322d8dd4c679529aec4c07ee27.1533739965.git.mchehab+samsung@kernel.org>
References: <577a6299b1881c011bb82adb8a321ce72599a33c.1533739965.git.mchehab+samsung@kernel.org> <cf5719a1cb77e6322d8dd4c679529aec4c07ee27.1533739965.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Thank you for the patch.

The subject line should be "media: omap3isp: ...".

On Wednesday, 8 August 2018 17:52:55 EEST Mauro Carvalho Chehab wrote:
> As sparse complains:
> 	drivers/media/platform/omap3isp/isp.c:303:39: warning: Using plain integer
> as NULL pointer
> 
> when a struct is initialized with { 0 }, actually the first
> element of the struct is initialized with zeros, initializing the
> other elements recursively. That can even generate gcc warnings
> on nested structs.
> 
> So, instead, use the gcc-specific syntax for that (with is used
> broadly inside the Kernel), initializing it with {};
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> ---
>  drivers/media/platform/omap3isp/isp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/omap3isp/isp.c
> b/drivers/media/platform/omap3isp/isp.c index 03354d513311..842e2235047d
> 100644
> --- a/drivers/media/platform/omap3isp/isp.c
> +++ b/drivers/media/platform/omap3isp/isp.c
> @@ -300,7 +300,7 @@ static struct clk *isp_xclk_src_get(struct
> of_phandle_args *clkspec, void *data) static int isp_xclk_init(struct
> isp_device *isp)
>  {
>  	struct device_node *np = isp->dev->of_node;
> -	struct clk_init_data init = { 0 };
> +	struct clk_init_data init = {};

How about = { NULL }; to avoid a gcc-specific syntax ?

>  	unsigned int i;
> 
>  	for (i = 0; i < ARRAY_SIZE(isp->xclks); ++i)

-- 
Regards,

Laurent Pinchart
