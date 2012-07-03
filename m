Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:48952 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754174Ab2GCKRN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Jul 2012 06:17:13 -0400
Received: from eusync3.samsung.com (mailout3.w1.samsung.com [210.118.77.13])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M6K00JZ6XXNOX60@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 03 Jul 2012 11:17:47 +0100 (BST)
Received: from [106.116.147.32] by eusync3.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0M6K00HO0XWMKL10@eusync3.samsung.com> for
 linux-media@vger.kernel.org; Tue, 03 Jul 2012 11:17:11 +0100 (BST)
Message-id: <4FF2C6A6.5050700@samsung.com>
Date: Tue, 03 Jul 2012 12:17:10 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-media@vger.kernel.org, andrzej.p@samsung.com,
	mchehab@infradead.org, patches@linaro.org
Subject: Re: [PATCH 1/1] [media] s5p-jpeg: Use module_platform_driver in
 jpeg-core.c file
References: <1341309273-1279-1-git-send-email-sachin.kamat@linaro.org>
In-reply-to: <1341309273-1279-1-git-send-email-sachin.kamat@linaro.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/03/2012 11:54 AM, Sachin Kamat wrote:
> module_platform_driver makes the code simpler by eliminating module_init
> and module_exit calls.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
