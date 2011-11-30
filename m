Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:16199 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753412Ab1K3Jt2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Nov 2011 04:49:28 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LVG00G2NWMEE240@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 30 Nov 2011 09:49:26 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LVG0080KWMDA8@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 30 Nov 2011 09:49:26 +0000 (GMT)
Date: Wed, 30 Nov 2011 10:49:21 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH] s5p-fimc: Prevent deadlock caused by incomplete H/W
 initialization
To: linux-media@vger.kernel.org
Cc: riverful.kim@samsung.com, sw0312.kim@samsung.com,
	m.szyprowski@samsung.com, s.nawrocki@samsung.com
Message-id: <1322646561-5528-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following ioctl sequence causes fimc_dma_run() to start processing without
complete scaler and DMA initialization which causes missing interrupt and
blocking on DQBUF:
S_FMT, STREAMON, QBUF, DQBUF, STREAMOFF, STREAMON, QBUF, DQBUF.

Fix this regression caused by moving pm_runtime* calls to start/stop_streaming
callback by making sure the fimc_m2m_resume() is always invoked when expected.

Reported-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <s.nawrocki@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-core.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index 07c6254..567e9ea 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -1709,9 +1709,8 @@ static int fimc_runtime_resume(struct device *dev)
 	/* Resume the capture or mem-to-mem device */
 	if (fimc_capture_busy(fimc))
 		return fimc_capture_resume(fimc);
-	else if (fimc_m2m_pending(fimc))
-		return fimc_m2m_resume(fimc);
-	return 0;
+
+	return fimc_m2m_resume(fimc);
 }
 
 static int fimc_runtime_suspend(struct device *dev)
-- 
1.7.7.2

