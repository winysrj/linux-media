Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:20326 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754031Ab2IZIxZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Sep 2012 04:53:25 -0400
Received: from eusync2.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MAY00DM58PN0980@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 26 Sep 2012 09:53:47 +0100 (BST)
Received: from [106.116.147.32] by eusync2.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0MAY006PW8OZJT50@eusync2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 26 Sep 2012 09:53:23 +0100 (BST)
Message-id: <5062C282.9080508@samsung.com>
Date: Wed, 26 Sep 2012 10:53:22 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-media@vger.kernel.org, patches@linaro.org
Subject: Re: [PATCH Resend] [media] s5p-fimc: Fix incorrect condition in
 fimc_lite_reqbufs()
References: <1348631639-17432-1-git-send-email-sachin.kamat@linaro.org>
In-reply-to: <1348631639-17432-1-git-send-email-sachin.kamat@linaro.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/26/2012 05:53 AM, Sachin Kamat wrote:
> Fixes a typo in a conditional evaluation.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>

Applied, thanks!
