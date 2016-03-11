Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:24396 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299AbcCKMiA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Mar 2016 07:38:00 -0500
Subject: Re: [RFT 2/2] [media] exynos4-is: Add missing port parent of_node_put
 on error paths
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	linux-samsung-soc@vger.kernel.org
References: <1453768906-28979-1-git-send-email-k.kozlowski@samsung.com>
 <1453768906-28979-2-git-send-email-k.kozlowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Kukjin Kim <kgene@kernel.org>, linux-media@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Javier Martinez Canillas <javier@osg.samsung.com>
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <56E2BC1F.1090805@samsung.com>
Date: Fri, 11 Mar 2016 13:37:51 +0100
MIME-version: 1.0
In-reply-to: <1453768906-28979-2-git-send-email-k.kozlowski@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/26/2016 01:41 AM, Krzysztof Kozlowski wrote:
> In fimc_md_parse_port_node() remote port parent node is get with
> of_graph_get_remote_port_parent() but it is not put on error path.
> 
> Fixes: fa91f1056f17 ("[media] exynos4-is: Add support for 
> asynchronous subdevices registration")
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Thanks, patch applied with s/is get/is acquired/.

> ---
> 
> Not tested on hardware, only built+static checkers.
> ---
>  drivers/media/platform/exynos4-is/media-dev.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/exynos4-is/media-dev.c 
> b/drivers/media/platform/exynos4-is/media-dev.c
> index de0977479327..d2e564878e06 100644
> --- a/drivers/media/platform/exynos4-is/media-dev.c
> +++ b/drivers/media/platform/exynos4-is/media-dev.c
> @@ -385,8 +385,10 @@ static int fimc_md_parse_port_node(struct fimc_md *fmd,
>  	else
>  		pd->fimc_bus_type = pd->sensor_bus_type;
>  
> -	if (WARN_ON(index >= ARRAY_SIZE(fmd->sensor)))
> +	if (WARN_ON(index >= ARRAY_SIZE(fmd->sensor))) {
> +		of_node_put(rem);
>  		return -EINVAL;
> +	}
>  
>  	fmd->sensor[index].asd.match_type = V4L2_ASYNC_MATCH_OF;
>  	fmd->sensor[index].asd.match.of.node = rem;

-- 
Regards,
Sylwester
