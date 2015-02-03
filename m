Return-path: <linux-media-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:23111 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965940AbbBCFwd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Feb 2015 00:52:33 -0500
Message-ID: <54D061A5.3000503@atmel.com>
Date: Tue, 3 Feb 2015 13:50:29 +0800
From: Josh Wu <josh.wu@atmel.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: <linux-media@vger.kernel.org>, <m.chehab@samsung.com>,
	<linux-arm-kernel@lists.infradead.org>, <voice.shen@atmel.com>,
	<nicolas.ferre@atmel.com>
Subject: Re: [PATCH] media: atmel-isi: increase the burst length to improve
 the performance
References: <1416907825-23826-1-git-send-email-josh.wu@atmel.com> <54CF4E52.6020901@atmel.com> <Pine.LNX.4.64.1502021122140.31366@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1502021122140.31366@axis700.grange>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Guennadi

On 2/2/2015 6:22 PM, Guennadi Liakhovetski wrote:
> Hi Josh,
>
> On Mon, 2 Feb 2015, Josh Wu wrote:
>
>> Hi, Guennadi
>>
>> Ping? what about the status of this patch?
> Right, got lost, sorry... Added to the queue now.
Thank you.

Best Regards,
Josh Wu

>
> Thanks
> Guennadi
>
>> Best Regards,
>> Josh Wu
>>
>> On 11/25/2014 5:30 PM, Josh Wu wrote:
>>> The burst length could be BEATS_4/8/16. Before this patch, isi use default
>>> value BEATS_4. To imporve the performance we could set it to BEATS_16.
>>>
>>> Otherwise sometime it would cause the ISI overflow error.
>>>
>>> Reported-by: Bo Shen <voice.shen@atmel.com>
>>> Signed-off-by: Josh Wu <josh.wu@atmel.com>
>>> ---
>>>    drivers/media/platform/soc_camera/atmel-isi.c | 2 ++
>>>    include/media/atmel-isi.h                     | 4 ++++
>>>    2 files changed, 6 insertions(+)
>>>
>>> diff --git a/drivers/media/platform/soc_camera/atmel-isi.c
>>> b/drivers/media/platform/soc_camera/atmel-isi.c
>>> index ee5650f..fda587b 100644
>>> --- a/drivers/media/platform/soc_camera/atmel-isi.c
>>> +++ b/drivers/media/platform/soc_camera/atmel-isi.c
>>> @@ -839,6 +839,8 @@ static int isi_camera_set_bus_param(struct
>>> soc_camera_device *icd)
>>>    	if (isi->pdata.full_mode)
>>>    		cfg1 |= ISI_CFG1_FULL_MODE;
>>>    +	cfg1 |= ISI_CFG1_THMASK_BEATS_16;
>>> +
>>>    	isi_writel(isi, ISI_CTRL, ISI_CTRL_DIS);
>>>    	isi_writel(isi, ISI_CFG1, cfg1);
>>>    diff --git a/include/media/atmel-isi.h b/include/media/atmel-isi.h
>>> index c2e5703..6008b09 100644
>>> --- a/include/media/atmel-isi.h
>>> +++ b/include/media/atmel-isi.h
>>> @@ -59,6 +59,10 @@
>>>    #define		ISI_CFG1_FRATE_DIV_MASK		(7 << 8)
>>>    #define ISI_CFG1_DISCR				(1 << 11)
>>>    #define ISI_CFG1_FULL_MODE			(1 << 12)
>>> +/* Definition for THMASK(ISI_V2) */
>>> +#define		ISI_CFG1_THMASK_BEATS_4		(0 << 13)
>>> +#define		ISI_CFG1_THMASK_BEATS_8		(1 << 13)
>>> +#define		ISI_CFG1_THMASK_BEATS_16	(2 << 13)
>>>      /* Bitfields in CFG2 */
>>>    #define ISI_CFG2_GRAYSCALE			(1 << 13)

