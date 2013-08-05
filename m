Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:65487 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754303Ab3HELFP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Aug 2013 07:05:15 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MR2002J51GO5K60@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 05 Aug 2013 12:05:14 +0100 (BST)
Message-id: <51FF86E7.4000807@samsung.com>
Date: Mon, 05 Aug 2013 13:05:11 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-media@vger.kernel.org, patches@linaro.org
Subject: Re: [PATCH 2/3] [media] exynos4-is: Annotate unused functions
References: <1375425134-17080-1-git-send-email-sachin.kamat@linaro.org>
 <1375425134-17080-2-git-send-email-sachin.kamat@linaro.org>
 <CAK9yfHyhDyoAphFC=MtDxtCedhN8-A=+gtXKZevsFg=JYq=ZUQ@mail.gmail.com>
In-reply-to: <CAK9yfHyhDyoAphFC=MtDxtCedhN8-A=+gtXKZevsFg=JYq=ZUQ@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sachin,

On 08/05/2013 07:12 AM, Sachin Kamat wrote:
> On 2 August 2013 12:02, Sachin Kamat <sachin.kamat@linaro.org> wrote:
>> > __is_set_init_isp_aa and fimc_is_hw_set_tune currently do not have
>> > any callers. However these functions may be used in the future. Hence
>> > instead of deleting them, staticize and annotate them with __maybe_unused
>> > flag to avoid compiler warnings.
>> >
>> > Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> Thanks for applying the other 2 patches in this series. What is your
> opinion about this one?
> Does this look good or do you prefer to delete the code altogether?

Thanks for your work on this. I think it would be better to call those
functions somewhere instead, e.g. in the fimc-is initialization routine,
until there is a user interface available for this 3A control.
fimc_is_hw_set_tune() just needs a private control a think. Let me see
if I can come up with at least some intermediate patch to achieve this,
so the warnings can be eliminated. I wouldn't like to take such steps
backwards, marking those functions static an unused.

Regards,
Sylwester
