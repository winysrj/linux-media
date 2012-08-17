Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f53.google.com ([209.85.216.53]:63749 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754886Ab2HQPWg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Aug 2012 11:22:36 -0400
Received: by mail-qa0-f53.google.com with SMTP id s11so1666648qaa.19
        for <linux-media@vger.kernel.org>; Fri, 17 Aug 2012 08:22:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <502DFF1B.3000508@samsung.com>
References: <1345184907-8317-1-git-send-email-sachin.kamat@linaro.org>
	<502DFF1B.3000508@samsung.com>
Date: Fri, 17 Aug 2012 20:52:35 +0530
Message-ID: <CAK9yfHwyXn6k-YZ_jvMdCPF3tpc68Q+n+WVa_u01tayqRZS_-g@mail.gmail.com>
Subject: Re: [PATCH-Trivial 1/2] [media] s5p-fimc: Replace asm/* headers with linux/*
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 17 August 2012 13:51, Sylwester Nawrocki <s.nawrocki@samsung.com> wrote:
> Hi Sachin,
>
> On 08/17/2012 08:28 AM, Sachin Kamat wrote:
>> Silences the following warning:
>> WARNING: Use #include <linux/sizes.h> instead of <asm/sizes.h>
>>
>> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
>
> Added both to my tree.

Thanks Sylwester.

>
> Thanks,
> Sylwester



-- 
With warm regards,
Sachin
