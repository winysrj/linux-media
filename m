Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-03v.sys.comcast.net ([96.114.154.162]:47084 "EHLO
	resqmta-po-03v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752541AbbGVWmm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jul 2015 18:42:42 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, hans.verkuil@cisco.com,
	laurent.pinchart@ideasonboard.com, tiwai@suse.de,
	sakari.ailus@linux.intel.com, perex@perex.cz, crope@iki.fi,
	arnd@arndb.de, stefanr@s5r6.in-berlin.de,
	ruchandani.tina@gmail.com, chehabrafael@gmail.com,
	dan.carpenter@oracle.com, prabhakar.csengg@gmail.com,
	chris.j.arges@canonical.com, agoode@google.com,
	pierre-louis.bossart@linux.intel.com, gtmkramer@xs4all.nl,
	clemens@ladisch.de, daniel@zonque.org, vladcatoi@gmail.com,
	misterpib@gmail.com, damien@zamaudio.com, pmatilai@laiskiainen.org,
	takamichiho@gmail.com, normalperson@yhbt.net,
	bugzilla.frnkcg@spamgourmet.com, joe@oampo.co.uk,
	calcprogrammer1@gmail.com, jussi@sonarnerd.net,
	kyungmin.park@samsung.com, s.nawrocki@samsung.com,
	kgene@kernel.org, hyun.kwon@xilinx.com, michal.simek@xilinx.com,
	soren.brinkmann@xilinx.com, pawel@osciak.com,
	m.szyprowski@samsung.com, gregkh@linuxfoundation.org,
	skd08@gmail.com, nsekhar@ti.com,
	boris.brezillon@free-electrons.com, Julia.Lawall@lip6.fr,
	elfring@users.sourceforge.net, p.zabel@pengutronix.de,
	ricardo.ribalda@gmail.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org, linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, devel@driverdev.osuosl.org
Subject: [PATCH v2 06/19] media: platform exynos4-is: Update graph_mutex to graph_lock spinlock
Date: Wed, 22 Jul 2015 16:42:07 -0600
Message-Id: <5a8cfe7719b00195cfca2d140ff1030eca5e9fbd.1437599281.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1437599281.git.shuahkh@osg.samsung.com>
References: <cover.1437599281.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1437599281.git.shuahkh@osg.samsung.com>
References: <cover.1437599281.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Update graph_mutex to graph_lock spinlock to be in sync with
the Media Conttroller change for the same.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/platform/exynos4-is/fimc-isp-video.c |  8 ++++----
 drivers/media/platform/exynos4-is/fimc-lite.c      |  8 ++++----
 drivers/media/platform/exynos4-is/media-dev.c      | 14 +++++++-------
 drivers/media/platform/exynos4-is/media-dev.h      |  4 ++--
 4 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-isp-video.c b/drivers/media/platform/exynos4-is/fimc-isp-video.c
index 76b6b4d..5ff0a54 100644
--- a/drivers/media/platform/exynos4-is/fimc-isp-video.c
+++ b/drivers/media/platform/exynos4-is/fimc-isp-video.c
@@ -288,7 +288,7 @@ static int isp_video_open(struct file *file)
 		goto rel_fh;
 
 	if (v4l2_fh_is_singular_file(file)) {
-		mutex_lock(&me->parent->graph_mutex);
+		spin_lock(&me->parent->graph_lock);
 
 		ret = fimc_pipeline_call(ve, open, me, true);
 
@@ -296,7 +296,7 @@ static int isp_video_open(struct file *file)
 		if (ret == 0)
 			me->use_count++;
 
-		mutex_unlock(&me->parent->graph_mutex);
+		spin_unlock(&me->parent->graph_lock);
 	}
 	if (!ret)
 		goto unlock;
@@ -326,9 +326,9 @@ static int isp_video_release(struct file *file)
 	if (v4l2_fh_is_singular_file(file)) {
 		fimc_pipeline_call(&ivc->ve, close);
 
-		mutex_lock(&mdev->graph_mutex);
+		spin_lock(&mdev->graph_lock);
 		entity->use_count--;
-		mutex_unlock(&mdev->graph_mutex);
+		spin_unlock(&mdev->graph_lock);
 	}
 
 	pm_runtime_put(&isp->pdev->dev);
diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
index ca6261a..cb1ea29 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite.c
@@ -500,7 +500,7 @@ static int fimc_lite_open(struct file *file)
 	    atomic_read(&fimc->out_path) != FIMC_IO_DMA)
 		goto unlock;
 
-	mutex_lock(&me->parent->graph_mutex);
+	spin_lock(&me->parent->graph_lock);
 
 	ret = fimc_pipeline_call(&fimc->ve, open, me, true);
 
@@ -508,7 +508,7 @@ static int fimc_lite_open(struct file *file)
 	if (ret == 0)
 		me->use_count++;
 
-	mutex_unlock(&me->parent->graph_mutex);
+	spin_unlock(&me->parent->graph_lock);
 
 	if (!ret) {
 		fimc_lite_clear_event_counters(fimc);
@@ -541,9 +541,9 @@ static int fimc_lite_release(struct file *file)
 		fimc_pipeline_call(&fimc->ve, close);
 		clear_bit(ST_FLITE_IN_USE, &fimc->state);
 
-		mutex_lock(&entity->parent->graph_mutex);
+		spin_lock(&entity->parent->graph_lock);
 		entity->use_count--;
-		mutex_unlock(&entity->parent->graph_mutex);
+		spin_unlock(&entity->parent->graph_lock);
 	}
 
 	_vb2_fop_release(file, NULL);
diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index 4f5586a..3e296e8 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -1046,7 +1046,7 @@ static int __fimc_md_modify_pipeline(struct media_entity *entity, bool enable)
 	return ret;
 }
 
-/* Locking: called with entity->parent->graph_mutex mutex held. */
+/* Locking: called with entity->parent->graph_lock lock held. */
 static int __fimc_md_modify_pipelines(struct media_entity *entity, bool enable)
 {
 	struct media_entity *entity_err = entity;
@@ -1305,7 +1305,7 @@ static int subdev_notifier_complete(struct v4l2_async_notifier *notifier)
 	struct fimc_md *fmd = notifier_to_fimc_md(notifier);
 	int ret;
 
-	mutex_lock(&fmd->media_dev.graph_mutex);
+	spin_lock(&fmd->media_dev.graph_lock);
 
 	ret = fimc_md_create_links(fmd);
 	if (ret < 0)
@@ -1313,7 +1313,7 @@ static int subdev_notifier_complete(struct v4l2_async_notifier *notifier)
 
 	ret = v4l2_device_register_subdev_nodes(&fmd->v4l2_dev);
 unlock:
-	mutex_unlock(&fmd->media_dev.graph_mutex);
+	spin_unlock(&fmd->media_dev.graph_lock);
 	return ret;
 }
 
@@ -1371,21 +1371,21 @@ static int fimc_md_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, fmd);
 
 	/* Protect the media graph while we're registering entities */
-	mutex_lock(&fmd->media_dev.graph_mutex);
+	spin_lock(&fmd->media_dev.graph_lock);
 
 	ret = fimc_md_register_platform_entities(fmd, dev->of_node);
 	if (ret) {
-		mutex_unlock(&fmd->media_dev.graph_mutex);
+		spin_unlock(&fmd->media_dev.graph_lock);
 		goto err_clk;
 	}
 
 	ret = fimc_md_register_sensor_entities(fmd);
 	if (ret) {
-		mutex_unlock(&fmd->media_dev.graph_mutex);
+		spin_unlock(&fmd->media_dev.graph_lock);
 		goto err_m_ent;
 	}
 
-	mutex_unlock(&fmd->media_dev.graph_mutex);
+	spin_unlock(&fmd->media_dev.graph_lock);
 
 	ret = device_create_file(&pdev->dev, &dev_attr_subdev_conf_mode);
 	if (ret)
diff --git a/drivers/media/platform/exynos4-is/media-dev.h b/drivers/media/platform/exynos4-is/media-dev.h
index 0321454..91edd9b 100644
--- a/drivers/media/platform/exynos4-is/media-dev.h
+++ b/drivers/media/platform/exynos4-is/media-dev.h
@@ -175,12 +175,12 @@ static inline struct fimc_md *notifier_to_fimc_md(struct v4l2_async_notifier *n)
 
 static inline void fimc_md_graph_lock(struct exynos_video_entity *ve)
 {
-	mutex_lock(&ve->vdev.entity.parent->graph_mutex);
+	spin_lock(&ve->vdev.entity.parent->graph_lock);
 }
 
 static inline void fimc_md_graph_unlock(struct exynos_video_entity *ve)
 {
-	mutex_unlock(&ve->vdev.entity.parent->graph_mutex);
+	spin_unlock(&ve->vdev.entity.parent->graph_lock);
 }
 
 int fimc_md_set_camclk(struct v4l2_subdev *sd, bool on);
-- 
2.1.4

