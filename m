Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:23167 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbaE1KVI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 May 2014 06:21:08 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N6A00K644R5JF10@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 28 May 2014 11:21:05 +0100 (BST)
Content-transfer-encoding: 8BIT
Message-id: <5385B88B.6040005@samsung.com>
Date: Wed, 28 May 2014 12:20:59 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: Alexander Shiyan <shc_work@mail.ru>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Shawn Guo <shawn.guo@freescale.com>,
	Sascha Hauer <kernel@pengutronix.de>
Subject: Re: [PATCH 1/2] media: mx2-emmaprp: Add devicetree support
References: <1401176878-7318-1-git-send-email-shc_work@mail.ru>
 <5385B07E.5090709@samsung.com> <1401271373.216160251@f395.i.mail.ru>
In-reply-to: <1401271373.216160251@f395.i.mail.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 28/05/14 12:02, Alexander Shiyan wrote:
> Wed, 28 May 2014 11:46:38 +0200 от Sylwester Nawrocki <s.nawrocki@samsung.com>:
>> On 27/05/14 09:47, Alexander Shiyan wrote:
>>> This patch adds devicetree support for the Freescale enhanced Multimedia
>>> Accelerator (eMMA) video Pre-processor (PrP).
>>>
>>> Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
> ...
>
>> Could you also fix the remaining checkpatch warnings:
>>
>>
>> WARNING: Use a single space after To:
>> #35: 
>> To:	linux-media@vger.kernel.org
>>
>> WARNING: Use a single space after Cc:
>> #36: 
>> Cc:	Mauro Carvalho Chehab <m.chehab@samsung.com>,
>>
>> ERROR: DOS line endings
>> #67: FILE: drivers/media/platform/mx2_emmaprp.c:21:
>> +#include <linux/of.h>^M$
> ...
>> [PATCH 1_2] media: mx2-emmaprp: Add devicetree support.eml has style problems, please review.
> 
> ...support.eml ?
> 
> All of these warnings is a result of email export.

Indeed, sorry about that, should have used my usual script
to check it. This patch is fine then.

--
Thanks,
Sylwester
