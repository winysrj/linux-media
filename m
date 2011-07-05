Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.171]:55985 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755888Ab1GELv7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Jul 2011 07:51:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH 7/8] ARM: integrate CMA with dma-mapping subsystem
Date: Tue, 5 Jul 2011 13:50:54 +0200
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org, linux-mm@kvack.org,
	linaro-mm-sig@lists.linaro.org,
	Michal Nazarewicz <mina86@mina86.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	Ankita Garg <ankita@in.ibm.com>,
	Daniel Walker <dwalker@codeaurora.org>,
	Mel Gorman <mel@csn.ul.ie>,
	Jesse Barker <jesse.barker@linaro.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Chunsang Jeong <chunsang.jeong@linaro.org>
References: <1309851710-3828-1-git-send-email-m.szyprowski@samsung.com> <1309851710-3828-8-git-send-email-m.szyprowski@samsung.com>
In-Reply-To: <1309851710-3828-8-git-send-email-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201107051350.54529.arnd@arndb.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tuesday 05 July 2011, Marek Szyprowski wrote:
> This patch adds support for CMA to dma-mapping subsystem for ARM
> architecture. By default a global CMA area is used, but specific devices
> are allowed to have their private memory areas if required (they can be
> created with dma_declare_contiguous() function during board
> initialization).
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
