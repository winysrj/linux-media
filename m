Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:9306 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030282Ab2KWJ65 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Nov 2012 04:58:57 -0500
Received: from eusync1.samsung.com (mailout4.w1.samsung.com [210.118.77.14])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MDX004HWQF10Z80@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 23 Nov 2012 09:59:25 +0000 (GMT)
Received: from [106.116.147.32] by eusync1.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0MDX00GRNQE65ZA0@eusync1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 23 Nov 2012 09:58:55 +0000 (GMT)
Message-id: <50AF48DE.8080501@samsung.com>
Date: Fri, 23 Nov 2012 10:58:54 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-media@vger.kernel.org, patches@linaro.org,
	Shaik Ameer Basha <shaik.ameer@samsung.com>
Subject: Re: [PATCH 1/4] [media] exynos-gsc: Rearrange error messages for valid
 prints
References: <1353645902-7467-1-git-send-email-sachin.kamat@linaro.org>
 <1353645902-7467-2-git-send-email-sachin.kamat@linaro.org>
 <50AF425E.9030203@samsung.com>
 <CAK9yfHzOs6B0=Z+EwwGt670tNLkpvFX0nkVELMzyyikpgzY=cw@mail.gmail.com>
In-reply-to: <CAK9yfHzOs6B0=Z+EwwGt670tNLkpvFX0nkVELMzyyikpgzY=cw@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/23/2012 10:47 AM, Sachin Kamat wrote:
>>> +err_clk_prepare:
>>>       gsc_clk_put(gsc);
>>
>> This call can be removed too. I would remove all labels and gotos in
>> this function. Since there is only one clock, you need to only call
>> clk_put when clk_prepare() fails, there is no need for gsc_clk_put().
> 
> I have removed gsc_clk_put() in the subsequent patch in this series.
> I will probably incorporate your previous comment and remove the label
> altogether (in patch 3) and send it again.

OK, sounds good to me that way too.
