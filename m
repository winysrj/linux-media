Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:36681 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752715AbcCGOPl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Mar 2016 09:15:41 -0500
Subject: Re: [RFT 1/2] [media] exynos4-is: Add missing endpoint of_node_put on
 error paths
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Kukjin Kim <kgene@kernel.org>, linux-media@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1453768906-28979-1-git-send-email-k.kozlowski@samsung.com>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Message-ID: <56DD8D02.3080504@osg.samsung.com>
Date: Mon, 7 Mar 2016 11:15:30 -0300
MIME-Version: 1.0
In-Reply-To: <1453768906-28979-1-git-send-email-k.kozlowski@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Krzysztof,

On 01/25/2016 09:41 PM, Krzysztof Kozlowski wrote:
> In fimc_md_parse_port_node() endpoint node is get with of_get_next_child()
> but it is not put on error path.
> 
> Fixes: 56fa1a6a6a7d ("[media] s5p-fimc: Change the driver directory name to exynos4-is")
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> 
> ---
> 
> Not tested on hardware, only built+static checkers.
> ---
>  drivers/media/platform/exynos4-is/media-dev.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
> index f3b2dd30ec77..de0977479327 100644
> --- a/drivers/media/platform/exynos4-is/media-dev.c
> +++ b/drivers/media/platform/exynos4-is/media-dev.c
> @@ -339,8 +339,10 @@ static int fimc_md_parse_port_node(struct fimc_md *fmd,
>  		return 0;
>  
>  	v4l2_of_parse_endpoint(ep, &endpoint);
> -	if (WARN_ON(endpoint.base.port == 0) || index >= FIMC_MAX_SENSORS)
> +	if (WARN_ON(endpoint.base.port == 0) || index >= FIMC_MAX_SENSORS) {
> +		of_node_put(ep);
>  		return -EINVAL;
> +	}
>  
>  	pd->mux_id = (endpoint.base.port - 1) & 0x1;
>  
> 

Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
