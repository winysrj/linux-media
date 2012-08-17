Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:28254 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197Ab2HQIVu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Aug 2012 04:21:50 -0400
Received: from eusync2.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M8W00LBT4L2OO70@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 17 Aug 2012 09:22:14 +0100 (BST)
Received: from [106.116.147.32] by eusync2.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0M8W00INL4KCTW10@eusync2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 17 Aug 2012 09:21:49 +0100 (BST)
Message-id: <502DFF1B.3000508@samsung.com>
Date: Fri, 17 Aug 2012 10:21:47 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	patches@linaro.org
Subject: Re: [PATCH-Trivial 1/2] [media] s5p-fimc: Replace asm/* headers with
 linux/*
References: <1345184907-8317-1-git-send-email-sachin.kamat@linaro.org>
In-reply-to: <1345184907-8317-1-git-send-email-sachin.kamat@linaro.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sachin,

On 08/17/2012 08:28 AM, Sachin Kamat wrote:
> Silences the following warning:
> WARNING: Use #include <linux/sizes.h> instead of <asm/sizes.h>
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>

Added both to my tree.

Thanks,
Sylwester
