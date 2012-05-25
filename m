Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:39060 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753787Ab2EYK2V (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 May 2012 06:28:21 -0400
Received: from euspt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M4K00GMHQEWQ5@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 25 May 2012 11:28:08 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M4K00DQDQF6VX@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 25 May 2012 11:28:18 +0100 (BST)
Date: Fri, 25 May 2012 12:28:18 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH 2/3] [media] s5p-fimc: Fix compiler warning in
 fimc-capture.c file
In-reply-to: <1337927380-4435-2-git-send-email-sachin.kamat@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	patches@linaro.org
Message-id: <4FBF5EC2.5090801@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
References: <1337927380-4435-1-git-send-email-sachin.kamat@linaro.org>
 <1337927380-4435-2-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sachin,

On 05/25/2012 08:29 AM, Sachin Kamat wrote:
> drivers/media/video/s5p-fimc/fimc-capture.c: In function ‘fimc_cap_streamon’:
> drivers/media/video/s5p-fimc/fimc-capture.c:1053:29: warning: ignoring return
> value of ‘media_entity_pipeline_start’, declared with attribute warn_unused_result [-Wunused-result]
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>

Thanks for the patch. Sakari submitted a similar one
(http://patchwork.linuxtv.org/patch/10799) so I'd like to
apply that instead.

Regards,
Sylwester
