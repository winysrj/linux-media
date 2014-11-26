Return-path: <linux-media-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:5679 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbaKZCzx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Nov 2014 21:55:53 -0500
Message-ID: <547540F8.7040901@atmel.com>
Date: Wed, 26 Nov 2014 10:54:48 +0800
From: Josh Wu <josh.wu@atmel.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: <linux-media@vger.kernel.org>, <m.chehab@samsung.com>,
	<linux-arm-kernel@lists.infradead.org>, <voice.shen@atmel.com>,
	<nicolas.ferre@atmel.com>
Subject: Re: [PATCH] media: atmel-isi: increase the burst length to improve
 the performance
References: <1416907825-23826-1-git-send-email-josh.wu@atmel.com> <Pine.LNX.4.64.1411252319430.17362@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1411252319430.17362@axis700.grange>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Gunenadi

On 11/26/2014 6:21 AM, Guennadi Liakhovetski wrote:
> Hi Josh,
>
> On Tue, 25 Nov 2014, Josh Wu wrote:
>
>> The burst length could be BEATS_4/8/16. Before this patch, isi use default
>> value BEATS_4. To imporve the performance we could set it to BEATS_16.
>>
>> Otherwise sometime it would cause the ISI overflow error.
> Without looking at datasheets - what does this bit do? Change the transfer
> length?
Atmel ISI has two internal 32-bytes FIFOs, one for Preview, another for 
Codec.
This field is the threshold to trigger the FIFO transfer to AHB by DMA.
We can set the threshold to allow 4-bytes, 8-bytes or 16-bytes for a burst.
BEATS_4, means only allow 4-bytes in a burst.
BEATS_8, means only allow 4-bytes and 8-bytes in a burst.
BEATS_16, means allow 4-bytes, 8-bytes and 16-bytes in a burst.

So BEATS_16 will use the DMA more efficient if has lots of data to 
transfer. As we are allowed to use 16-bytes in a burst. That will 
trigger less burst than BEATS_4 to transfer same amount of data.

We found this patch can fix ISI FIFO overflow error when system is in a 
situation that with a very high memory load.
If we only allow 4-bytes in a burst, that need more burst to transfer 
data and less effective.

> What happens then if the data amount isn't a multiple of the
> transfer size?

BEATS_16 means allowed 4-bytes, 8-bytes and 16-bytes in a burst. So it 
still can perform a 4-bytes transfer if the data is not multiple of 16.
I think all the data transfer are aligned with 4 bytes. The DMA address 
should be aligned with 4 bytes as well.

Best Regards,
Josh Wu
>
> Thanks
> Guennadi
>
>> Reported-by: Bo Shen <voice.shen@atmel.com>
>> Signed-off-by: Josh Wu <josh.wu@atmel.com>
>> ---
>>   drivers/media/platform/soc_camera/atmel-isi.c | 2 ++
>>   include/media/atmel-isi.h                     | 4 ++++
>>   2 files changed, 6 insertions(+)
>>
>> diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
>> index ee5650f..fda587b 100644
>> --- a/drivers/media/platform/soc_camera/atmel-isi.c
>> +++ b/drivers/media/platform/soc_camera/atmel-isi.c
>> @@ -839,6 +839,8 @@ static int isi_camera_set_bus_param(struct soc_camera_device *icd)
>>   	if (isi->pdata.full_mode)
>>   		cfg1 |= ISI_CFG1_FULL_MODE;
>>   
>> +	cfg1 |= ISI_CFG1_THMASK_BEATS_16;
>> +
>>   	isi_writel(isi, ISI_CTRL, ISI_CTRL_DIS);
>>   	isi_writel(isi, ISI_CFG1, cfg1);
>>   
>> diff --git a/include/media/atmel-isi.h b/include/media/atmel-isi.h
>> index c2e5703..6008b09 100644
>> --- a/include/media/atmel-isi.h
>> +++ b/include/media/atmel-isi.h
>> @@ -59,6 +59,10 @@
>>   #define		ISI_CFG1_FRATE_DIV_MASK		(7 << 8)
>>   #define ISI_CFG1_DISCR				(1 << 11)
>>   #define ISI_CFG1_FULL_MODE			(1 << 12)
>> +/* Definition for THMASK(ISI_V2) */
>> +#define		ISI_CFG1_THMASK_BEATS_4		(0 << 13)
>> +#define		ISI_CFG1_THMASK_BEATS_8		(1 << 13)
>> +#define		ISI_CFG1_THMASK_BEATS_16	(2 << 13)
>>   
>>   /* Bitfields in CFG2 */
>>   #define ISI_CFG2_GRAYSCALE			(1 << 13)
>> -- 
>> 1.9.1
>>

