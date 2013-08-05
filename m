Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f42.google.com ([209.85.219.42]:50362 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392Ab3HELfL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Aug 2013 07:35:11 -0400
Received: by mail-oa0-f42.google.com with SMTP id i18so6029855oag.29
        for <linux-media@vger.kernel.org>; Mon, 05 Aug 2013 04:35:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51FF86E7.4000807@samsung.com>
References: <1375425134-17080-1-git-send-email-sachin.kamat@linaro.org>
	<1375425134-17080-2-git-send-email-sachin.kamat@linaro.org>
	<CAK9yfHyhDyoAphFC=MtDxtCedhN8-A=+gtXKZevsFg=JYq=ZUQ@mail.gmail.com>
	<51FF86E7.4000807@samsung.com>
Date: Mon, 5 Aug 2013 17:05:10 +0530
Message-ID: <CAK9yfHxv1JskCQH8D6T7VjxzQfZ7ek8bxPY0A-95wPX0QsnAqw@mail.gmail.com>
Subject: Re: [PATCH 2/3] [media] exynos4-is: Annotate unused functions
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-media@vger.kernel.org, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On 5 August 2013 16:35, Sylwester Nawrocki <s.nawrocki@samsung.com> wrote:
> Hi Sachin,
>
> On 08/05/2013 07:12 AM, Sachin Kamat wrote:
>> On 2 August 2013 12:02, Sachin Kamat <sachin.kamat@linaro.org> wrote:
>>> > __is_set_init_isp_aa and fimc_is_hw_set_tune currently do not have
>>> > any callers. However these functions may be used in the future. Hence
>>> > instead of deleting them, staticize and annotate them with __maybe_unused
>>> > flag to avoid compiler warnings.
>>> >
>>> > Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
>> Thanks for applying the other 2 patches in this series. What is your
>> opinion about this one?
>> Does this look good or do you prefer to delete the code altogether?
>
> Thanks for your work on this. I think it would be better to call those
> functions somewhere instead, e.g. in the fimc-is initialization routine,
> until there is a user interface available for this 3A control.
> fimc_is_hw_set_tune() just needs a private control a think. Let me see
> if I can come up with at least some intermediate patch to achieve this,
> so the warnings can be eliminated. I wouldn't like to take such steps
> backwards, marking those functions static an unused.

Marking it unused is just a stop gap solution to silence unnecessary warnings.
However if you can come up with some users for these functions, then
that would be great
and right thing to do.

-- 
With warm regards,
Sachin
