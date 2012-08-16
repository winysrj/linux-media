Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:31467 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109Ab2HPLo7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Aug 2012 07:44:59 -0400
Received: from eusync1.samsung.com (mailout4.w1.samsung.com [210.118.77.14])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M8U00DIHJBZWD70@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 16 Aug 2012 12:45:35 +0100 (BST)
Received: from [106.116.147.32] by eusync1.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0M8U0005DJAX6H80@eusync1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 16 Aug 2012 12:44:57 +0100 (BST)
Message-id: <502CDD38.9040301@samsung.com>
Date: Thu, 16 Aug 2012 13:44:56 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: linux-media@vger.kernel.org
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH] s5p-fimc: Add pipeline ops to separate FIMC-LITE module
 (was  From: Sylwester Nawrocki <s.nawrocki@samsung.com>)
References: <1345113242-12992-1-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1345113242-12992-1-git-send-email-s.nawrocki@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/16/2012 12:34 PM, Sylwester Nawrocki wrote:

The patch's subject got wrong due to stray characters that snicked
in, the subject should read:

[PATCH] s5p-fimc: Add pipeline ops to separate FIMC-LITE module

My apologies for spamming.

Thanks,
Sylwester
> In order to reuse the FIMC-LITE module on Exynos4 and Exynos5
> SoC introduce a set of callbacks for the media pipeline control
> from within FIMC/FIMC-LITE video node. It lets us avoid symbol
> dependencies between FIMC-LITE and the whole media device driver,
> which simplifies the initialization sequences and doesn't
> introduce issues preventing common kernel image for exynos4 and
> exynos5 SoCs.
> 
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>



