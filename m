Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:37961 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022Ab2EXPQB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 May 2012 11:16:01 -0400
Received: from euspt2 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M4J005PB92DT4@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 24 May 2012 16:15:49 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M4J005QE92L3E@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 24 May 2012 16:15:57 +0100 (BST)
Date: Thu, 24 May 2012 17:15:50 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 1/7] s5p-fimc: Fix bug in capture node open()
In-reply-to: <1337872556-26406-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	s.nawrocki@samsung.com
Message-id: <1337872556-26406-2-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1337872556-26406-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When video pipeline initialization fails, the ST_CAPT_BUSY flag
needs to be cleared before pm_runtime_put_sync is called.
Otherwise the runtime suspend routine tries to suspend device,
rather than just turning it off. Also fix potential null pointer
dereference in fimc_pipeline_shutdown().

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <s.nawrocki@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-capture.c |    2 +-
 drivers/media/video/s5p-fimc/fimc-mdevice.c |    6 +++++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index 3545745..7083107 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -499,10 +499,10 @@ static int fimc_capture_open(struct file *file)
 		if (ret < 0) {
 			dev_err(&fimc->pdev->dev,
 				"Video pipeline initialization failed\n");
+			clear_bit(ST_CAPT_BUSY, &fimc->state);
 			pm_runtime_put_sync(&fimc->pdev->dev);
 			fimc->vid_cap.refcnt--;
 			v4l2_fh_release(file);
-			clear_bit(ST_CAPT_BUSY, &fimc->state);
 			return ret;
 		}
 		ret = fimc_capture_ctrls_create(fimc);
diff --git a/drivers/media/video/s5p-fimc/fimc-mdevice.c b/drivers/media/video/s5p-fimc/fimc-mdevice.c
index 6753c45..7450dcd 100644
--- a/drivers/media/video/s5p-fimc/fimc-mdevice.c
+++ b/drivers/media/video/s5p-fimc/fimc-mdevice.c
@@ -193,9 +193,13 @@ int __fimc_pipeline_shutdown(struct fimc_pipeline *p)
 
 int fimc_pipeline_shutdown(struct fimc_pipeline *p)
 {
-	struct media_entity *me = &p->subdevs[IDX_SENSOR]->entity;
+	struct media_entity *me;
 	int ret;
 
+	if (!p || !p->subdevs[IDX_SENSOR])
+		return -EINVAL;
+
+	me = &p->subdevs[IDX_SENSOR]->entity;
 	mutex_lock(&me->parent->graph_mutex);
 	ret = __fimc_pipeline_shutdown(p);
 	mutex_unlock(&me->parent->graph_mutex);
-- 
1.7.10

