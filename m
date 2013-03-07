Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:52360 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772Ab3CGM7T (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Mar 2013 07:59:19 -0500
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MJA00J3ZK2BT3T0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Thu, 07 Mar 2013 21:59:18 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] s5p-fimc: Do not attempt to disable not enabled media pipeline
Date: Thu, 07 Mar 2013 13:59:06 +0100
Message-id: <1362661146-11725-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This fixes following warnings when all links are being disconnected:

[   20.080000] WARNING: at drivers/media/platform/s5p-fimc/fimc-mdevice.c:1269 __fimc_md_set_camclk+0x208/0x20c()
[   20.090000] Modules linked in:
[   20.095000] [<c001603c>] (unwind_backtrace+0x0/0x13c) from [<c00246dc>] (warn_slowpath_common+0x54/0x64)
[   20.105000] [<c00246dc>] (warn_slowpath_common+0x54/0x64) from [<c0024708>] (warn_slowpath_null+0x1c/0x24)
[   20.115000] [<c0024708>] (warn_slowpath_null+0x1c/0x24) from [<c0323fe8>] (__fimc_md_set_camclk+0x208/0x20c)
[   20.125000] [<c0323fe8>] (__fimc_md_set_camclk+0x208/0x20c) from [<c0324368>] (__fimc_pipeline_close+0x38/0x48)
[   20.135000] [<c0324368>] (__fimc_pipeline_close+0x38/0x48) from [<c0325848>] (fimc_md_link_notify+0x10c/0x198)
[   20.145000] [<c0325848>] (fimc_md_link_notify+0x10c/0x198) from [<c02f9dd4>] (__media_entity_setup_link+0x1c0/0x1e8)
[   20.155000] [<c02f9dd4>] (__media_entity_setup_link+0x1c0/0x1e8) from [<c02f9710>] (media_device_ioctl+0x2c0/0x41c)
[   20.165000] [<c02f9710>] (media_device_ioctl+0x2c0/0x41c) from [<c02f9938>] (media_ioctl+0x30/0x34)
[   20.175000] [<c02f9938>] (media_ioctl+0x30/0x34) from [<c00cf0bc>] (do_vfs_ioctl+0x84/0x5e8)
[   20.185000] [<c00cf0bc>] (do_vfs_ioctl+0x84/0x5e8) from [<c00cf65c>] (sys_ioctl+0x3c/0x60)
[   20.190000] [<c00cf65c>] (sys_ioctl+0x3c/0x60) from [<c000f040>] (ret_fast_syscall+0x0/0x30)

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-fimc/fimc-mdevice.c |   39 ++++++++++++------------
 1 file changed, 19 insertions(+), 20 deletions(-)

diff --git a/drivers/media/platform/s5p-fimc/fimc-mdevice.c b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
index a17fcb2..9be0b7d 100644
--- a/drivers/media/platform/s5p-fimc/fimc-mdevice.c
+++ b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
@@ -827,7 +827,7 @@ static int fimc_md_link_notify(struct media_pad *source,
 	struct fimc_pipeline *pipeline;
 	struct v4l2_subdev *sd;
 	struct mutex *lock;
-	int ret = 0;
+	int i, ret = 0;
 	int ref_count;
 
 	if (media_entity_type(sink->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
@@ -854,29 +854,28 @@ static int fimc_md_link_notify(struct media_pad *source,
 		return 0;
 	}
 
+	mutex_lock(lock);
+	ref_count = fimc ? fimc->vid_cap.refcnt : fimc_lite->ref_count;
+
 	if (!(flags & MEDIA_LNK_FL_ENABLED)) {
-		int i;
-		mutex_lock(lock);
-		ret = __fimc_pipeline_close(pipeline);
+		if (ref_count > 0) {
+			ret = __fimc_pipeline_close(pipeline);
+			if (!ret)
+				fimc_ctrls_delete(fimc->vid_cap.ctx);
+		}
 		for (i = 0; i < IDX_MAX; i++)
 			pipeline->subdevs[i] = NULL;
-		if (fimc)
-			fimc_ctrls_delete(fimc->vid_cap.ctx);
-		mutex_unlock(lock);
-		return ret;
+	} else if (ref_count > 0) {
+		/*
+		 * Link activation. Enable power of pipeline elements only if
+		 * the pipeline is already in use, i.e. its video node is open.
+		 * Recreate the controls destroyed during the link deactivation.
+		 */
+		ret = __fimc_pipeline_open(pipeline,
+					   source->entity, true);
+		if (!ret && fimc)
+			ret = fimc_capture_ctrls_create(fimc);
 	}
-	/*
-	 * Link activation. Enable power of pipeline elements only if the
-	 * pipeline is already in use, i.e. its video node is opened.
-	 * Recreate the controls destroyed during the link deactivation.
-	 */
-	mutex_lock(lock);
-
-	ref_count = fimc ? fimc->vid_cap.refcnt : fimc_lite->ref_count;
-	if (ref_count > 0)
-		ret = __fimc_pipeline_open(pipeline, source->entity, true);
-	if (!ret && fimc)
-		ret = fimc_capture_ctrls_create(fimc);
 
 	mutex_unlock(lock);
 	return ret ? -EPIPE : ret;
-- 
1.7.9.5

