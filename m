Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:27928 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197Ab2HQITt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Aug 2012 04:19:49 -0400
Received: from eusync4.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M8W00LAC4HOOO70@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 17 Aug 2012 09:20:12 +0100 (BST)
Received: from [106.116.147.32] by eusync4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTPA id <0M8W003794GXNP10@eusync4.samsung.com> for
 linux-media@vger.kernel.org; Fri, 17 Aug 2012 09:19:47 +0100 (BST)
Message-id: <502DFEA0.8010309@samsung.com>
Date: Fri, 17 Aug 2012 10:19:44 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	k.debski@samsung.com, patches@linaro.org
Subject: Re: [PATCH-Trivial] [media] s5p-mfc: Add missing braces around sizeof
References: <1345184575-14035-1-git-send-email-sachin.kamat@linaro.org>
In-reply-to: <1345184575-14035-1-git-send-email-sachin.kamat@linaro.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sachin,

On 08/17/2012 08:22 AM, Sachin Kamat wrote:
> Silences the following warnings:
> WARNING: sizeof *ctx should be sizeof(*ctx)
> WARNING: sizeof *dev should be sizeof(*dev)
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>

I've added this one to my tree.

Thanks!
Sylwester
