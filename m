Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f181.google.com ([209.85.215.181]:38300 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860Ab3CMEJV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Mar 2013 00:09:21 -0400
MIME-Version: 1.0
In-Reply-To: <513F5171.40603@samsung.com>
References: <1362754765-2651-1-git-send-email-arun.kk@samsung.com>
	<1362754765-2651-13-git-send-email-arun.kk@samsung.com>
	<513F5171.40603@samsung.com>
Date: Wed, 13 Mar 2013 09:39:19 +0530
Message-ID: <CALt3h7_zXP9M5m+4VXFGhnfpaUO+6F20hTsnR8ATF8+=CNmcrA@mail.gmail.com>
Subject: Re: [RFC 12/12] mipi-csis: Enable all interrupts for fimc-is usage
From: Arun Kumar K <arunkk.samsung@gmail.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Arun Kumar K <arun.kk@samsung.com>,
	LMML <linux-media@vger.kernel.org>,
	linux-samsung-soc@vger.kernel.org,
	devicetree-discuss@lists.ozlabs.org, kgene.kim@samsung.com,
	kilyeon.im@samsung.com, shaik.ameer@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

>>
>>  /* Interrupt mask */
>>  #define S5PCSIS_INTMSK                       0x10
>> -#define S5PCSIS_INTMSK_EN_ALL                0xf000103f
>> +#define S5PCSIS_INTMSK_EN_ALL                0xfc00103f
>
> Do you know what interrupts are assigned to the CSIS_INTMSK
> bits 26, 27 ? In the documentation I have they are marked
> as reserved. I have tested this patch on Exynos4x12, it seems
> OK but you might want to merge it to the patch adding compatible
> property for exynos5.

The bits 26 and 27 are for Frame start and Frame end interrupts.
Yes this change can be merged with the MIPI-CSIS support for Exynos5.
Shaik will pick it up and merge it along with his patch series in v2.

>
> It would be good to know what these bits are for. And how
> enabling the interrupts actually help without modifying the
> interrupt handler ? Is it enough to just acknowledge those
> interrupts ? Or how it works ?
>

These interrupts are used by the FIMC-IS firmware possibly to check if the
sensor is working. Without enabling these, I get the error from firmware
on Sensor Open command.

Regards
Arun
