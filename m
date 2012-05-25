Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:47089 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485Ab2EYKaQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 May 2012 06:30:16 -0400
Received: from euspt2 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M4K007S0QJ9LI80@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 25 May 2012 11:30:45 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M4K00BUVQICKC@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 25 May 2012 11:30:13 +0100 (BST)
Date: Fri, 25 May 2012 12:30:14 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH 3/3] [media] s5p-fimc: Stop media entity pipeline if
 fimc_pipeline_validate fails
In-reply-to: <1337927380-4435-3-git-send-email-sachin.kamat@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	patches@linaro.org
Message-id: <4FBF5F36.8060903@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
References: <1337927380-4435-1-git-send-email-sachin.kamat@linaro.org>
 <1337927380-4435-3-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/25/2012 08:29 AM, Sachin Kamat wrote:
> Stops the media entity pipeline which was started earlier
> if fimc_pipeline_validate fails.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>

Applied that one too. Thanks.

--
Regards,
Sylwester
