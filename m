Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33653 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751442AbdFGIpC (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Jun 2017 04:45:02 -0400
Subject: Re: [PATCH v4 3/3] media: mtk-mdp: Fix mdp device tree
To: Minghsiu Tsai <minghsiu.tsai@mediatek.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        daniel.thompson@linaro.org, Rob Herring <robh+dt@kernel.org>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Pawel Osciak <posciak@chromium.org>,
        Houlong Wei <houlong.wei@mediatek.com>
Cc: srv_heupstream@mediatek.com,
        Eddie Huang <eddie.huang@mediatek.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Wu-Cheng Li <wuchengli@google.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-mediatek@lists.infradead.org
References: <1495509851-29159-1-git-send-email-minghsiu.tsai@mediatek.com>
 <1495509851-29159-4-git-send-email-minghsiu.tsai@mediatek.com>
From: Matthias Brugger <matthias.bgg@gmail.com>
Message-ID: <e7996ad5-03a1-7b53-5d61-ae171473581f@gmail.com>
Date: Wed, 7 Jun 2017 10:44:58 +0200
MIME-Version: 1.0
In-Reply-To: <1495509851-29159-4-git-send-email-minghsiu.tsai@mediatek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans, hi Mauro,

On 23/05/17 05:24, Minghsiu Tsai wrote:
> From: Daniel Kurtz <djkurtz@chromium.org>
> 
> If the mdp_* nodes are under an mdp sub-node, their corresponding
> platform device does not automatically get its iommu assigned properly.
> 
> Fix this by moving the mdp component nodes up a level such that they are
> siblings of mdp and all other SoC subsystems.  This also simplifies the
> device tree.
> 
> Although it fixes iommu assignment issue, it also break compatibility
> with old device tree. So, the patch in driver is needed to iterate over
> sibling mdp device nodes, not child ones, to keep driver work properly.
> 
> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
> Signed-off-by: Minghsiu Tsai <minghsiu.tsai@mediatek.com>
> Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
> 

Are you OK to take this patch, or do you have any further comments?

Regards,
Matthias

> ---
>   drivers/media/platform/mtk-mdp/mtk_mdp_core.c | 12 ++++++++++--
>   1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/mtk-mdp/mtk_mdp_core.c b/drivers/media/platform/mtk-mdp/mtk_mdp_core.c
> index 9e4eb7d..8134755 100644
> --- a/drivers/media/platform/mtk-mdp/mtk_mdp_core.c
> +++ b/drivers/media/platform/mtk-mdp/mtk_mdp_core.c
> @@ -103,7 +103,7 @@ static int mtk_mdp_probe(struct platform_device *pdev)
>   {
>   	struct mtk_mdp_dev *mdp;
>   	struct device *dev = &pdev->dev;
> -	struct device_node *node;
> +	struct device_node *node, *parent;
>   	int i, ret = 0;
>   
>   	mdp = devm_kzalloc(dev, sizeof(*mdp), GFP_KERNEL);
> @@ -117,8 +117,16 @@ static int mtk_mdp_probe(struct platform_device *pdev)
>   	mutex_init(&mdp->lock);
>   	mutex_init(&mdp->vpulock);
>   
> +	/* Old dts had the components as child nodes */
> +	if (of_get_next_child(dev->of_node, NULL)) {
> +		parent = dev->of_node;
> +		dev_warn(dev, "device tree is out of date\n");
> +	} else {
> +		parent = dev->of_node->parent;
> +	}
> +
>   	/* Iterate over sibling MDP function blocks */
> -	for_each_child_of_node(dev->of_node, node) {
> +	for_each_child_of_node(parent, node) {
>   		const struct of_device_id *of_id;
>   		enum mtk_mdp_comp_type comp_type;
>   		int comp_id;
> 
