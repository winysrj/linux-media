Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:52179 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760261Ab3DCMbO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Apr 2013 08:31:14 -0400
Message-id: <515C210F.8030806@samsung.com>
Date: Wed, 03 Apr 2013 14:31:11 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Arun Kumar K <arunkk.samsung@gmail.com>
Cc: Arun Kumar K <arun.kk@samsung.com>,
	LMML <linux-media@vger.kernel.org>,
	linux-samsung-soc@vger.kernel.org,
	devicetree-discuss@lists.ozlabs.org, kgene.kim@samsung.com,
	kilyeon.im@samsung.com, shaik.ameer@samsung.com
Subject: Re: [RFC 12/12] mipi-csis: Enable all interrupts for fimc-is usage
References: <1362754765-2651-1-git-send-email-arun.kk@samsung.com>
 <1362754765-2651-13-git-send-email-arun.kk@samsung.com>
 <513F5171.40603@samsung.com>
 <CALt3h7_zXP9M5m+4VXFGhnfpaUO+6F20hTsnR8ATF8+=CNmcrA@mail.gmail.com>
In-reply-to: <CALt3h7_zXP9M5m+4VXFGhnfpaUO+6F20hTsnR8ATF8+=CNmcrA@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arun,

On 03/13/2013 05:09 AM, Arun Kumar K wrote:
> Hi Sylwester,
> 
>>>
>>>  /* Interrupt mask */
>>>  #define S5PCSIS_INTMSK                       0x10
>>> -#define S5PCSIS_INTMSK_EN_ALL                0xf000103f
>>> +#define S5PCSIS_INTMSK_EN_ALL                0xfc00103f
>>
>> Do you know what interrupts are assigned to the CSIS_INTMSK
>> bits 26, 27 ? In the documentation I have they are marked
>> as reserved. I have tested this patch on Exynos4x12, it seems
>> OK but you might want to merge it to the patch adding compatible
>> property for exynos5.
> 
> The bits 26 and 27 are for Frame start and Frame end interrupts.
> Yes this change can be merged with the MIPI-CSIS support for Exynos5.
> Shaik will pick it up and merge it along with his patch series in v2.

OK, thanks a lot for the clarification. I tested this patch on
Exynos4x12 and I could see twice as many interrupts from MIPI-CSIS as
there was captured frames from the sensor. Certainly we don't want to
see these interrupts when they are not needed. I have been thinking of
some interface that the MIPI-CSIS subdev would provide to the media
driver, so it can enable the interrupts when needed. I suppose a
private subdev ioctl might be good for that. But first I think there
is e.g. a subdev flag needed so a subdev driver can decide that it
doesn't want to have its non-standard ioctls called from user space.

I'll see if I can address those issues.

>> It would be good to know what these bits are for. And how
>> enabling the interrupts actually help without modifying the
>> interrupt handler ? Is it enough to just acknowledge those
>> interrupts ? Or how it works ?
>>
> 
> These interrupts are used by the FIMC-IS firmware possibly to check if the
> sensor is working. Without enabling these, I get the error from firmware
> on Sensor Open command.

Hm, interesting... Looks like the MIPI-CSIS interrupts get routed to the
FIMC-IS GIC. I was also wondering how the FIMC-IS receives Embedded Data
from the MIPI CSIS IP, which is sent by an image sensor. Presumably
FIMC-IS can memory map the Embedded Data buffer at the MIPI CSIS internal
memory, and then it reads from there. It's just a guess though.

Regards,
Sylwester
