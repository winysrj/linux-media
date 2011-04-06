Return-path: <mchehab@pedra>
Received: from mailout3.samsung.com ([203.254.224.33]:63310 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013Ab1DFH0h (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Apr 2011 03:26:37 -0400
Date: Wed, 06 Apr 2011 09:25:45 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH 5/7] v4l: s5p-fimc: add pm_runtime support
In-reply-to: <007c01cbf3f2$c6e7b420$54b71c60$%han@samsung.com>
To: 'Jonghun Han' <jonghun.han@samsung.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org
Cc: 'Kyungmin Park' <kyungmin.park@samsung.com>,
	Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	'Arnd Bergmann' <arnd@arndb.de>,
	'Kukjin Kim' <kgene.kim@samsung.com>,
	=?ks_c_5601-1987?B?J7DtwOe47Sc=?= <jemings@samsung.com>,
	'Marek Szyprowski' <m.szyprowski@samsung.com>
Message-id: <000001cbf42b$dbd9db90$938d92b0$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ks_c_5601-1987
Content-language: pl
Content-transfer-encoding: 7BIT
References: <1302012410-17984-1-git-send-email-m.szyprowski@samsung.com>
 <1302012410-17984-6-git-send-email-m.szyprowski@samsung.com>
 <007c01cbf3f2$c6e7b420$54b71c60$%han@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

On Wednesday, April 06, 2011 2:37 AM Jonghun Han wrote:

> runtime_pm is used to minimize current.
> In my opinion, the followings will be better.
> 1. Adds pm_runtime_get_sync before running of the first job.
>    IMO, dma_run callback function is the best place for calling in case of
> M2M.
> 2. And then in the ISR, call pm_runtime_put_sync in the ISR bottom-half if
> there is no remained job.

Right my pm_runtime implementation is very simple. I've just added it to test
if other subsystems are working.

Best regards
--
Marek Szyprowski
Samsung Poland R&D Center


