Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f49.google.com ([209.85.216.49]:56339 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844Ab2EZOzG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 May 2012 10:55:06 -0400
Received: by qabj40 with SMTP id j40so310972qab.1
        for <linux-media@vger.kernel.org>; Sat, 26 May 2012 07:55:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FC096D6.3040504@gmail.com>
References: <1337967533-22240-1-git-send-email-sachin.kamat@linaro.org>
	<4FC096D6.3040504@gmail.com>
Date: Sat, 26 May 2012 20:25:05 +0530
Message-ID: <CAK9yfHzfosCcTSShkV7cWs3ZztcsVnCegCuvhK9EMZrt4dA8ag@mail.gmail.com>
Subject: Re: [PATCH 1/4] [media] s5p-fimc: Add missing static storage class in
 fimc-lite-reg.c file
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Sylwester Nawrocki <snjw23@gmail.com>
Cc: linux-media@vger.kernel.org, s.nawrocki@samsung.com,
	mchehab@infradead.org, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On 26 May 2012 14:09, Sylwester Nawrocki <snjw23@gmail.com> wrote:
> Hi Sachin,
>
>
> On 05/25/2012 07:38 PM, Sachin Kamat wrote:
>>
>> Fixes the following sparse warning:
>> drivers/media/video/s5p-fimc/fimc-lite-reg.c:218:6: warning: symbol
>> 'flite_hw_set_out_order' was not declared. Should it be static?
>
>
> Thanks for the patches. However I'm inclined to squash this whole
> series into one patch, since it addresses same issue in one driver,
> just in different. I don't see a good reason to split those changes
> like this. Could you make it just one patch instead ?

Sure. I will send it on Monday.
In fact I too wanted to send it as a single patch but wasn't quite
sure if it was OK to do so.

>
>
> Regards,
> Sylwester



-- 
With warm regards,
Sachin
