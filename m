Return-path: <linux-media-owner@vger.kernel.org>
Received: from szxga07-in.huawei.com ([45.249.212.35]:43484 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726085AbeHXHJ3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Aug 2018 03:09:29 -0400
Message-ID: <5B7F7D49.10206@huawei.com>
Date: Fri, 24 Aug 2018 11:36:41 +0800
From: zhong jiang <zhongjiang@huawei.com>
MIME-Version: 1.0
To: Bing Bu Cao <bingbu.cao@linux.intel.com>
CC: <yong.zhi@intel.com>, <sakari.ailus@linux.intel.com>,
        <bingbu.cao@intel.com>, <mchehab@kernel.org>,
        <matthias.bgg@gmail.com>, <tian.shu.qiu@intel.com>,
        <jian.xu.zheng@intel.com>, <linux-kernel@vger.kernel.org>,
        <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/2] media: ipu3-cio2: Use dma_zalloc_coherent to replace
 dma_alloc_coherent + memset
References: <1534605415-11452-1-git-send-email-zhongjiang@huawei.com> <1534605415-11452-2-git-send-email-zhongjiang@huawei.com> <541b8c22-018f-4df6-85d1-82a72d9ab669@linux.intel.com>
In-Reply-To: <541b8c22-018f-4df6-85d1-82a72d9ab669@linux.intel.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2018/8/24 10:58, Bing Bu Cao wrote:
> Hi, Jiang
>
> This looks fine for me in ipu3-cio2.
> Actually, we already have this change locally, but I think we miss submit it to community.
> Thanks!
 It's ok,  Anyway,  Thank you for let me know that.

 Best wishes,
 zhong jiang
> On 08/18/2018 11:16 PM, zhong jiang wrote:
>> dma_zalloc_coherent has implemented the dma_alloc_coherent() + memset(),
>> We prefer to dma_zalloc_coherent instead of open-codeing.
>>
>> Signed-off-by: zhong jiang <zhongjiang@huawei.com>
>> ---
>>  drivers/media/pci/intel/ipu3/ipu3-cio2.c | 6 ++----
>>  1 file changed, 2 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/media/pci/intel/ipu3/ipu3-cio2.c b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
>> index 2902715..f0c6374 100644
>> --- a/drivers/media/pci/intel/ipu3/ipu3-cio2.c
>> +++ b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
>> @@ -218,13 +218,11 @@ static int cio2_fbpt_init(struct cio2_device *cio2, struct cio2_queue *q)
>>  {
>>  	struct device *dev = &cio2->pci_dev->dev;
>>  
>> -	q->fbpt = dma_alloc_coherent(dev, CIO2_FBPT_SIZE, &q->fbpt_bus_addr,
>> -				     GFP_KERNEL);
>> +	q->fbpt = dma_zalloc_coherent(dev, CIO2_FBPT_SIZE, &q->fbpt_bus_addr,
>> +				      GFP_KERNEL);
>>  	if (!q->fbpt)
>>  		return -ENOMEM;
>>  
>> -	memset(q->fbpt, 0, CIO2_FBPT_SIZE);
>> -
>>  	return 0;
>>  }
>>  
>
> .
>
