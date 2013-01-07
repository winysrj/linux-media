Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:37959 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019Ab3AGKCH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Jan 2013 05:02:07 -0500
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MG900LLS2H0WJ90@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 07 Jan 2013 10:02:04 +0000 (GMT)
Received: from [106.116.147.32] by eusync1.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0MG9008VC2JF0M90@eusync1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 07 Jan 2013 10:02:04 +0000 (GMT)
Message-id: <50EA9D19.6090107@samsung.com>
Date: Mon, 07 Jan 2013 11:02:01 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: LMML <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/3] [media] s5p-mfc: use mfc_err instead of printk
References: <1356689908-6866-1-git-send-email-sachin.kamat@linaro.org>
 <007401cde917$38c58200$aa508600$%debski@samsung.com>
 <CAK9yfHzbMKvo-WYED9hPdzCccjvKcXgtq=SqOLPEGuaGhMwqCw@mail.gmail.com>
In-reply-to: <CAK9yfHzbMKvo-WYED9hPdzCccjvKcXgtq=SqOLPEGuaGhMwqCw@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sachin,

On 01/07/2013 05:09 AM, Sachin Kamat wrote:
> Hi Sylwester,
> 
> On 3 January 2013 00:00, Kamil Debski <k.debski@samsung.com> wrote:
>> Hi Sachin,
>>
>> Thank you for your patch.
>>
>> Best wishes,
>> --
>> Kamil Debski
>> Linux Platform Group
>> Samsung Poland R&D Center
>>
>>> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
>>> owner@vger.kernel.org] On Behalf Of Sachin Kamat
>>> Sent: Friday, December 28, 2012 11:18 AM
>>> To: linux-media@vger.kernel.org
>>> Cc: k.debski@samsung.com; s.nawrocki@samsung.com;
>>> sylvester.nawrocki@gmail.com; sachin.kamat@linaro.org;
>>> patches@linaro.org
>>> Subject: [PATCH 1/3] [media] s5p-mfc: use mfc_err instead of printk
>>>
>>> Use mfc_err for consistency. Also silences checkpatch warning.
>>>
>>
>> Acked-by: Kamil Debski <k.debski@samsung.com>
>>
>>> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
>>> ---
> 
> Probably you missed to apply this patch to your tree.

Hmm, not really, I intended it for a second v3.9 pull request.
However I checked it yesterday and it doesn't apply any more.
Since one of Kamil's patches includes same change.

Thanks,
Sylwester
