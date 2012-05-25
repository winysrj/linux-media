Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:46876 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413Ab2EYK2m (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 May 2012 06:28:42 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Received: from euspt2 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M4K006UYQGM3F80@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 25 May 2012 11:29:10 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M4K00I08QFQDC@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 25 May 2012 11:28:38 +0100 (BST)
Date: Fri, 25 May 2012 12:28:40 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH 2/3] [media] s5p-fimc: Fix compiler warning in
 fimc-capture.c file
In-reply-to: <1337927380-4435-2-git-send-email-sachin.kamat@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	patches@linaro.org
Message-id: <4FBF5ED8.9070506@samsung.com>
Content-transfer-encoding: 8BIT
References: <1337927380-4435-1-git-send-email-sachin.kamat@linaro.org>
 <1337927380-4435-2-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/25/2012 08:29 AM, Sachin Kamat wrote:
> drivers/media/video/s5p-fimc/fimc-capture.c: In function ‘fimc_cap_streamon’:
> drivers/media/video/s5p-fimc/fimc-capture.c:1053:29: warning: ignoring return
> value of ‘media_entity_pipeline_start’, declared with attribute warn_unused_result [-Wunused-result]
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>

Thanks, I've applied that one, with slightly extended commit message.

Regards,
Sylwester
