Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:24824 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975AbcCKMbD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Mar 2016 07:31:03 -0500
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [RFT 1/2] [media] exynos4-is: Add missing endpoint of_node_put on
 error paths
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
References: <1453768906-28979-1-git-send-email-k.kozlowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Kukjin Kim <kgene@kernel.org>, linux-media@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org,
	Javier Martinez Canillas <javier@osg.samsung.com>
Message-id: <56E2BA7D.9050500@samsung.com>
Date: Fri, 11 Mar 2016 13:30:53 +0100
MIME-version: 1.0
In-reply-to: <1453768906-28979-1-git-send-email-k.kozlowski@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/26/2016 01:41 AM, Krzysztof Kozlowski wrote:
> In fimc_md_parse_port_node() endpoint node is get with of_get_next_child()
> but it is not put on error path.

"is get" doesn't sound right to me, how about rephrasing this to:

"In fimc_md_parse_port_node() reference count of the endpoint node
"is incremented by of_get_next_child() but it is not decremented
 on error path."

> Fixes: 56fa1a6a6a7d ("[media] s5p-fimc: Change the driver directory name to exynos4-is")
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---
> Not tested on hardware, only built+static checkers.
> ---
>  drivers/media/platform/exynos4-is/media-dev.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/exynos4-is/media-dev.c 
> b/drivers/media/platform/exynos4-is/media-dev.c
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

Thanks for the patch, it looks correct but it doesn't apply cleanly
due to patches already in media master branch [1]. Could you refresh
this patch and resend?
Also I don't quite like multiple calls to of_node_put(), how about
doing something like this instead:

---------------------------8<----------------------------------
diff --git a/drivers/media/platform/exynos4-is/media-dev.c
b/drivers/media/platform/exynos4-is/media-dev.c
index feb521f..663d32e 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -397,18 +397,19 @@ static int fimc_md_parse_port_node(struct fimc_md *fmd,
                return 0;

        ret = v4l2_of_parse_endpoint(ep, &endpoint);
-       if (ret) {
-               of_node_put(ep);
-               return ret;
+       if (!ret) {
+               if (WARN_ON(endpoint.base.port == 0) ||
+                           index >= FIMC_MAX_SENSORS) {
+                       ret = -EINVAL;
+               } else {
+                       pd->mux_id = (endpoint.base.port - 1) & 0x1;
+                       rem = of_graph_get_remote_port_parent(ep);
+               }
        }
-
-       if (WARN_ON(endpoint.base.port == 0) || index >= FIMC_MAX_SENSORS)
-               return -EINVAL;
-
-       pd->mux_id = (endpoint.base.port - 1) & 0x1;
-
-       rem = of_graph_get_remote_port_parent(ep);
        of_node_put(ep);
+       if (ret < 0)
+               return ret;
+
        if (rem == NULL) {
                v4l2_info(&fmd->v4l2_dev, "Remote device at %s not found\n",
                                                        ep->full_name);
---------------------------8<----------------------------------

-- 
Thanks,
Sylwester

[1] git://linuxtv.org/media_tree.git
