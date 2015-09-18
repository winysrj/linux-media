Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:30224 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963AbbIRO3h (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Sep 2015 10:29:37 -0400
Message-id: <55FC1FCE.1010208@samsung.com>
Date: Fri, 18 Sep 2015 16:29:34 +0200
From: Jacek Anaszewski <j.anaszewski@samsung.com>
MIME-version: 1.0
To: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Kukjin Kim <kgene@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: Re: [PATCH 1/4] s5p-jpeg: generalize clocks handling
References: <1442586060-23657-1-git-send-email-andrzej.p@samsung.com>
 <1442586060-23657-2-git-send-email-andrzej.p@samsung.com>
In-reply-to: <1442586060-23657-2-git-send-email-andrzej.p@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andrzej, Marek,

On 09/18/2015 04:20 PM, Andrzej Pietrasiewicz wrote:
> From: Marek Szyprowski <m.szyprowski@samsung.com>
>
> Allow jpeg codec variants declare clocks they need.
> Before this patch is applied jpeg-core gets jpeg->sclk
> "speculatively": if it is not there, we assume no problem.
>
> This patch eliminates this by explicitly declaring
> what clocks are needed for each variant.
>
> This is a preparation for adding Exynos 5433 variant support, which
> needs 4 clocks of names not compatible with any previous version of
> jpeg hw module.
>
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> [Rebase and commit message]
> Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
> ---
>   drivers/media/platform/s5p-jpeg/jpeg-core.c | 66 ++++++++++++++---------------
>   drivers/media/platform/s5p-jpeg/jpeg-core.h | 10 +++--
>   2 files changed, 37 insertions(+), 39 deletions(-)

Reviewed-by: Jacek Anaszewski <j.anaszewski@samsung.com>

-- 
Best Regards,
Jacek Anaszewski
