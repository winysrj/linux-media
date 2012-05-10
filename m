Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:31383 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753340Ab2EJNTi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 May 2012 09:19:38 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Thu, 10 May 2012 15:19:35 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH] drivers: cma: don't fail if migration returns -EAGAIN
In-reply-to: <1333462221-3987-1-git-send-email-m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org, linux-mm@kvack.org,
	linaro-mm-sig@lists.linaro.org
Cc: Michal Nazarewicz <mina86@mina86.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Russell King <linux@arm.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	Daniel Walker <dwalker@codeaurora.org>,
	Mel Gorman <mel@csn.ul.ie>, Arnd Bergmann <arnd@arndb.de>,
	Jesse Barker <jesse.barker@linaro.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Chunsang Jeong <chunsang.jeong@linaro.org>,
	Dave Hansen <dave@linux.vnet.ibm.com>,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	Rob Clark <rob.clark@linaro.org>,
	Ohad Ben-Cohen <ohad@wizery.com>,
	Sandeep Patil <psandeep.s@gmail.com>
Message-id: <1336655975-15729-1-git-send-email-m.szyprowski@samsung.com>
References: <1333462221-3987-1-git-send-email-m.szyprowski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

alloc_contig_range() function might return -EAGAIN if migrate_pages() call
fails for some temporarily locked pages. Such case should not be fatal
to dma_alloc_from_contiguous(), which should retry allocation like in case
of -EBUSY error.

Reported-by: Haojian Zhuang <haojian.zhuang@gmail.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/base/dma-contiguous.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/base/dma-contiguous.c b/drivers/base/dma-contiguous.c
index 78efb03..e46e2fb 100644
--- a/drivers/base/dma-contiguous.c
+++ b/drivers/base/dma-contiguous.c
@@ -346,7 +346,7 @@ struct page *dma_alloc_from_contiguous(struct device *dev, int count,
 		if (ret == 0) {
 			bitmap_set(cma->bitmap, pageno, count);
 			break;
-		} else if (ret != -EBUSY) {
+		} else if (ret != -EBUSY && ret != -EAGAIN) {
 			goto error;
 		}
 		pr_debug("%s(): memory range at %p is busy, retrying\n",
-- 
1.7.1.569.g6f426

