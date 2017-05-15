Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35539 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751536AbdEOH14 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 15 May 2017 03:27:56 -0400
Subject: Re: [PATCH v3 3/3] media: mtk-mdp: Fix mdp device tree
To: Minghsiu Tsai <minghsiu.tsai@mediatek.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>, daniel.thompson@linaro.org,
        Rob Herring <robh+dt@kernel.org>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Pawel Osciak <posciak@chromium.org>,
        Houlong Wei <houlong.wei@mediatek.com>,
        srv_heupstream@mediatek.com,
        Eddie Huang <eddie.huang@mediatek.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Wu-Cheng Li <wuchengli@google.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-mediatek@lists.infradead.org
References: <1494559361-42835-1-git-send-email-minghsiu.tsai@mediatek.com>
 <1494559361-42835-4-git-send-email-minghsiu.tsai@mediatek.com>
 <60f89b9a-f068-25a7-3f8b-d13b19357361@gmail.com>
 <1494815512.31916.11.camel@mtksdaap41>
From: Matthias Brugger <matthias.bgg@gmail.com>
Message-ID: <79df594b-33cb-e606-5ace-66f450f839e9@gmail.com>
Date: Mon, 15 May 2017 09:27:52 +0200
MIME-Version: 1.0
In-Reply-To: <1494815512.31916.11.camel@mtksdaap41>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 15/05/17 04:31, Minghsiu Tsai wrote:
> On Fri, 2017-05-12 at 17:05 +0200, Matthias Brugger wrote:
>>
>> On 12/05/17 05:22, Minghsiu Tsai wrote:
>>> From: Daniel Kurtz <djkurtz@chromium.org>
>>>
>>> If the mdp_* nodes are under an mdp sub-node, their corresponding
>>> platform device does not automatically get its iommu assigned properly.
>>>
>>> Fix this by moving the mdp component nodes up a level such that they are
>>> siblings of mdp and all other SoC subsystems.  This also simplifies the
>>> device tree.
>>>
>>> Although it fixes iommu assignment issue, it also break compatibility
>>> with old device tree. So, the patch in driver is needed to iterate over
>>> sibling mdp device nodes, not child ones, to keep driver work properly.
>>>
>>
>> Couldn't we preserve backwards compatibility by doing something like this:
>> diff --git a/drivers/media/platform/mtk-mdp/mtk_mdp_core.c
>> b/drivers/media/platform/mtk-mdp/mtk_mdp_core.c
>> index 9e4eb7dcc424..277d8fe6eb76 100644
>> --- a/drivers/media/platform/mtk-mdp/mtk_mdp_core.c
>> +++ b/drivers/media/platform/mtk-mdp/mtk_mdp_core.c
>> @@ -103,7 +103,7 @@ static int mtk_mdp_probe(struct platform_device *pdev)
>>    {
>>    	struct mtk_mdp_dev *mdp;
>>    	struct device *dev = &pdev->dev;
>> -	struct device_node *node;
>> +	struct device_node *node, *parent;
>>    	int i, ret = 0;
>>
>>    	mdp = devm_kzalloc(dev, sizeof(*mdp), GFP_KERNEL);
>> @@ -117,8 +117,14 @@ static int mtk_mdp_probe(struct platform_device *pdev)
>>    	mutex_init(&mdp->lock);
>>    	mutex_init(&mdp->vpulock);
>>
>> +	/* Old dts had the components as child nodes */
>> +	if (of_get_next_child(dev->of_node, NULL))
>> +		parent = dev->of_node;
>> +	else
>> +		parent = dev->of_node->parent;
>> +
>>    	/* Iterate over sibling MDP function blocks */
>> -	for_each_child_of_node(dev->of_node, node) {
>> +	for_each_child_of_node(parent, node) {
>>    		const struct of_device_id *of_id;
>>    		enum mtk_mdp_comp_type comp_type;
>>    		int comp_id;
>>
>> Maybe even by putting a warning in the if branch to make sure, people
>> are aware of their out-of-date device tree blobs.
>>
>> Regards,
>> Matthias
>>
> 
> Hi Matthias,
> 
> It is a good idea to do compatible in such a way and put a warning the
> device tree is out of date. People can find out cause soon if device
> tree is old.
> 
> I modify the code as below:
> 
> +	/* Old dts had the components as child nodes */
> +	if (of_get_next_child(dev->of_node, NULL)) {
> +		parent = dev->of_node;
> +		dev_warn(dev, "device tree is out of date\n");
> +	} else {
> +		parent = dev->of_node->parent;
> +	}
> 
> Will you upload it in a separate patch?
> If not, I can merge it in my patch series and upload v4.
> 

Please integrate it into your patch series.

Mauro, are you ok with the dev_warn about the out-of-date device-tree?

Regards,
Matthias


> 
> Best Regards,
> 
> Ming Hsiu
> 
>>> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
>>> Signed-off-by: Minghsiu Tsai <minghsiu.tsai@mediatek.com>
>>>
>>> ---
>>>    drivers/media/platform/mtk-mdp/mtk_mdp_core.c | 2 +-
>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/media/platform/mtk-mdp/mtk_mdp_core.c b/drivers/media/platform/mtk-mdp/mtk_mdp_core.c
>>> index 9e4eb7d..a5ad586 100644
>>> --- a/drivers/media/platform/mtk-mdp/mtk_mdp_core.c
>>> +++ b/drivers/media/platform/mtk-mdp/mtk_mdp_core.c
>>> @@ -118,7 +118,7 @@ static int mtk_mdp_probe(struct platform_device *pdev)
>>>    	mutex_init(&mdp->vpulock);
>>>    
>>>    	/* Iterate over sibling MDP function blocks */
>>> -	for_each_child_of_node(dev->of_node, node) {
>>> +	for_each_child_of_node(dev->of_node->parent, node) {
>>>    		const struct of_device_id *of_id;
>>>    		enum mtk_mdp_comp_type comp_type;
>>>    		int comp_id;
>>>
> 
> 
