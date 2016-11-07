Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:33593
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751750AbcKGXkR (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 7 Nov 2016 18:40:17 -0500
Subject: Re: [PATCH] media: s5p-mfc include buffer size in error message
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
References: <20161018004337.26831-1-shuahkh@osg.samsung.com>
 <CGME20161104100504eucas1p196456ab351847ffabb60f51e76eab707@eucas1p1.samsung.com>
 <b1a9fa02-6821-7637-881c-a31719e891c9@samsung.com>
Cc: kyungmin.park@samsung.com, kamil@wypas.org, jtp.park@samsung.com,
        a.hajda@samsung.com, mchehab@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <8078d0e6-246b-e8f3-ec62-41e9d543909f@osg.samsung.com>
Date: Mon, 7 Nov 2016 16:40:14 -0700
MIME-Version: 1.0
In-Reply-To: <b1a9fa02-6821-7637-881c-a31719e891c9@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/04/2016 04:05 AM, Sylwester Nawrocki wrote:
> On 10/18/2016 02:43 AM, Shuah Khan wrote:
>> Include buffer size in s5p_mfc_alloc_priv_buf() the error message when it
>> fails to allocate the buffer. Remove the debug message that does the same.
>>
>> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
>> ---
>>  drivers/media/platform/s5p-mfc/s5p_mfc_opr.c | 5 ++---
>>  1 file changed, 2 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr.c
>> index 1e72502..eee16a1 100644
>> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr.c
>> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr.c
>> @@ -40,12 +40,11 @@ void s5p_mfc_init_regs(struct s5p_mfc_dev *dev)
>>  int s5p_mfc_alloc_priv_buf(struct device *dev, dma_addr_t base,
>>  					struct s5p_mfc_priv_buf *b)
>>  {
>> -	mfc_debug(3, "Allocating priv: %zu\n", b->size);
> 
> How about keeping this debug message, I think it would be useful
> to leave that information in the debug logs.

Sent v2 with just the error message change.

thanks,
-- Shuah

> 
>>  	b->virt = dma_alloc_coherent(dev, b->size, &b->dma, GFP_KERNEL);
>>  
>>  	if (!b->virt) {
>> -		mfc_err("Allocating private buffer failed\n");
>> +		mfc_err("Allocating private buffer of size %zu failed\n",
>> +			b->size);
>>  		return -ENOMEM;
>>  	}
> 
> --
> Thanks,
> Sylwester
> 

