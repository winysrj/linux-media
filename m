Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:56674
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751219AbdBXVTa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Feb 2017 16:19:30 -0500
Subject: Re: [PATCH] [media] exynos4-is: Add missing 'of_node_put'
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        kyungmin.park@samsung.com, s.nawrocki@samsung.com,
        mchehab@kernel.org, kgene@kernel.org, krzk@kernel.org
References: <20170123211656.11185-1-christophe.jaillet@wanadoo.fr>
Cc: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
From: Javier Martinez Canillas <javier@osg.samsung.com>
Message-ID: <2357ef6e-8d90-77d0-0399-21fec41389a1@osg.samsung.com>
Date: Fri, 24 Feb 2017 18:19:17 -0300
MIME-Version: 1.0
In-Reply-To: <20170123211656.11185-1-christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Christophe,

On 01/23/2017 06:16 PM, Christophe JAILLET wrote:
> It is likely that a "of_node_put(ep)" is missing here.
> There is one in the previous error handling code, and one a few lines
> below in the normal case as well.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  drivers/media/platform/exynos4-is/media-dev.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
> index e3a8709138fa..da5b76c1df98 100644
> --- a/drivers/media/platform/exynos4-is/media-dev.c
> +++ b/drivers/media/platform/exynos4-is/media-dev.c
> @@ -402,8 +402,10 @@ static int fimc_md_parse_port_node(struct fimc_md *fmd,
>  		return ret;
>  	}
>  
> -	if (WARN_ON(endpoint.base.port == 0) || index >= FIMC_MAX_SENSORS)
> +	if (WARN_ON(endpoint.base.port == 0) || index >= FIMC_MAX_SENSORS) {
> +		of_node_put(ep);
>  		return -EINVAL;
> +	}
>  
>  	pd->mux_id = (endpoint.base.port - 1) & 0x1;
>  
> 

Thanks for the patch, but Krzysztof sent the exact same patch before [0]. There
was feedback from Sylwester at the time that you can also look at [0]. Could you
please take that into account and post a patch according to what he suggested?

[0]: http://lists.infradead.org/pipermail/linux-arm-kernel/2016-March/415207.html

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
