Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:27047 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754435Ab2IZIug (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Sep 2012 04:50:36 -0400
Received: from eusync3.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MAY006158KV8700@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 26 Sep 2012 09:50:55 +0100 (BST)
Received: from [106.116.147.32] by eusync3.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0MAY00DQU8KAUS00@eusync3.samsung.com> for
 linux-media@vger.kernel.org; Wed, 26 Sep 2012 09:50:34 +0100 (BST)
Message-id: <5062C1D9.2090104@samsung.com>
Date: Wed, 26 Sep 2012 10:50:33 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>,
	linux-media@vger.kernel.org, patches@linaro.org
Subject: Re: [PATCH] [media] s5p-tv: Fix potential NULL pointer dereference
 error
References: <1348299559-20952-1-git-send-email-sachin.kamat@linaro.org>
 <50601F32.5080700@samsung.com>
In-reply-to: <50601F32.5080700@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/24/2012 10:52 AM, Tomasz Stanislawski wrote:
> On 09/22/2012 09:39 AM, Sachin Kamat wrote:
>> When mdev is NULL, the error print statement will try to dereference
>> the NULL pointer.
>>
>> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
>> ---
>>  drivers/media/platform/s5p-tv/mixer_drv.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/media/platform/s5p-tv/mixer_drv.c b/drivers/media/platform/s5p-tv/mixer_drv.c
>> index a15ca05..ca0f297 100644
>> --- a/drivers/media/platform/s5p-tv/mixer_drv.c
>> +++ b/drivers/media/platform/s5p-tv/mixer_drv.c
>> @@ -384,7 +384,7 @@ static int __devinit mxr_probe(struct platform_device *pdev)
>>  
>>  	mdev = kzalloc(sizeof *mdev, GFP_KERNEL);
>>  	if (!mdev) {
>> -		mxr_err(mdev, "not enough memory.\n");
>> +		dev_err(dev, "not enough memory.\n");
>>  		ret = -ENOMEM;
>>  		goto fail;
>>  	}
>>
> 
> Acked-by: Tomasz Stanislawski <t.stanislaws@samsung.com>

Applied, thanks!


Regards,
Sylwester
