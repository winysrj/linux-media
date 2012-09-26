Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:38855 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150Ab2IZEWK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Sep 2012 00:22:10 -0400
Received: by vcbfo13 with SMTP id fo13so172149vcb.19
        for <linux-media@vger.kernel.org>; Tue, 25 Sep 2012 21:22:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <50621D5D.9020204@gmail.com>
References: <1348477595-28493-1-git-send-email-sachin.kamat@linaro.org>
	<50621D5D.9020204@gmail.com>
Date: Wed, 26 Sep 2012 09:52:09 +0530
Message-ID: <CAK9yfHyMgi_CD9Gpmp9sotbvMRwFcGE5C02PERu2MSDhA4TQ+A@mail.gmail.com>
Subject: Re: [PATCH] [media] s5p-fimc: Use the new linux/sizes.h header file
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	s.nawrocki@samsung.com, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On 26 September 2012 02:38, Sylwester Nawrocki
<sylvester.nawrocki@gmail.com> wrote:
> Hi Sachin,
>
>
> On 09/24/2012 11:06 AM, Sachin Kamat wrote:
>>
>> Replaces asm/sizes.h with linux/sizes.h.
>>
>> Signed-off-by: Sachin Kamat<sachin.kamat@linaro.org>
>
>
> Thanks, I have already applied similar patch to this one [1].

I just found that it is my own patch sent sometime in August for doing
the same thing and which is already in your tree.
Somehow I lost it from my tree and hence sent it again :). Sorry for the noise.

>
> You can see what's already queued at
> http://git.infradead.org/users/kmpark/linux-samsung
> branch v4l-next.
>
> As a side note, there is no need to Cc Mauro, please just send
> your patches to linux-media and a copy to me so I don't miss them.

Sure.

>
> Regards,
> Sylwester
>
> [1]
> http://git.infradead.org/users/kmpark/linux-samsung/commitdiff/9f3ad11ace7a41cd1b16f1e58601ac37513ad683



-- 
With warm regards,
Sachin
