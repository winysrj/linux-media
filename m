Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:9864 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224Ab2LEIgH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Dec 2012 03:36:07 -0500
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MEJ00BMIUO1M130@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 05 Dec 2012 08:38:40 +0000 (GMT)
Received: from [106.116.147.88] by eusync4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTPA id <0MEJ00BJBUK1R450@eusync4.samsung.com> for
 linux-media@vger.kernel.org; Wed, 05 Dec 2012 08:36:01 +0000 (GMT)
Message-id: <50BF0770.50809@samsung.com>
Date: Wed, 05 Dec 2012 09:36:00 +0100
From: Andrzej Hajda <a.hajda@samsung.com>
MIME-version: 1.0
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-media@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Seung-Woo Kim <sw0312.kim@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH RFC 3/3] s5p-fimc: improved pipeline try format routine
References: <1353684150-24581-1-git-send-email-a.hajda@samsung.com>
 <1353684150-24581-4-git-send-email-a.hajda@samsung.com>
 <50BE1CF4.9080009@samsung.com>
In-reply-to: <50BE1CF4.9080009@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On 04.12.2012 16:55, Sylwester Nawrocki wrote:
> Hi Andrzej,
>
> On 11/23/2012 04:22 PM, Andrzej Hajda wrote:
>> Function support variable number of subdevs in pipe-line.
> I'm will be applying this patch with description changed to:
>
> Make the pipeline try format routine more generic to support any
> number of subdevs in the pipeline, rather than hard coding it for
> only a sensor, MIPI-CSIS and FIMC subdevs and the FIMC video node.
Seems better :)
>
>> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>>   drivers/media/platform/s5p-fimc/fimc-capture.c |  100 +++++++++++++++---------
>>   1 file changed, 64 insertions(+), 36 deletions(-)
>>
> ...
>>   /**
>>    * fimc_pipeline_try_format - negotiate and/or set formats at pipeline
>>    *                            elements
>> @@ -809,65 +824,78 @@ static int fimc_pipeline_try_format(struct fimc_ctx *ctx,
> ...
>>   		ffmt = fimc_find_format(NULL, mf->code != 0 ? &mf->code : NULL,
>>   					FMT_FLAGS_CAM, i++);
>> -		if (ffmt == NULL) {
>> -			/*
>> -			 * Notify user-space if common pixel code for
>> -			 * host and sensor does not exist.
>> -			 */
>> +		if (ffmt == NULL)
>>   			return -EINVAL;
>> -		}
>> +
> And as we agreed, with this chunk removed from the patch. Since the comment
> still stands.
OK.
>
> --
>
> Thank you!
> Sylwester
>

