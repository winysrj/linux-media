Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:57651 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752797AbbGXKXB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jul 2015 06:23:01 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@linux.intel.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 6/7] am437x/exynos4-is/marvell-ccic/sh_vou: simplify release()
Date: Fri, 24 Jul 2015 12:21:35 +0200
Message-Id: <1437733296-38198-7-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1437733296-38198-1-git-send-email-hverkuil@xs4all.nl>
References: <1437733296-38198-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Use the _vb2_fop_release() return code to determine if this was
the last close or not.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/am437x/am437x-vpfe.c      | 13 +++----------
 drivers/media/platform/exynos4-is/fimc-capture.c |  5 +----
 drivers/media/platform/marvell-ccic/mcam-core.c  |  5 +----
 drivers/media/platform/sh_vou.c                  |  5 +----
 4 files changed, 6 insertions(+), 22 deletions(-)

diff --git a/drivers/media/platform/am437x/am437x-vpfe.c b/drivers/media/platform/am437x/am437x-vpfe.c
index 210c779..14b9289 100644
--- a/drivers/media/platform/am437x/am437x-vpfe.c
+++ b/drivers/media/platform/am437x/am437x-vpfe.c
@@ -1186,21 +1186,14 @@ static int vpfe_initialize_device(struct vpfe_device *vpfe)
 static int vpfe_release(struct file *file)
 {
 	struct vpfe_device *vpfe = video_drvdata(file);
-	bool fh_singular;
 
 	mutex_lock(&vpfe->lock);
 
-	/* Save the singular status before we call the clean-up helper */
-	fh_singular = v4l2_fh_is_singular_file(file);
-
-	/* the release helper will cleanup any on-going streaming */
-	_vb2_fop_release(file, NULL);
-
 	/*
-	 * If this was the last open file.
-	 * Then de-initialize hw module.
+	 * The release helper will cleanup any on-going streaming.
+	 * If this was the last open file, then de-initialize hw module.
 	 */
-	if (fh_singular)
+	if (_vb2_fop_release(file, NULL))
 		vpfe_ccdc_close(&vpfe->ccdc, vpfe->pdev);
 
 	mutex_unlock(&vpfe->lock);
diff --git a/drivers/media/platform/exynos4-is/fimc-capture.c b/drivers/media/platform/exynos4-is/fimc-capture.c
index f4458b0..f654b1c 100644
--- a/drivers/media/platform/exynos4-is/fimc-capture.c
+++ b/drivers/media/platform/exynos4-is/fimc-capture.c
@@ -537,7 +537,6 @@ static int fimc_capture_release(struct file *file)
 {
 	struct fimc_dev *fimc = video_drvdata(file);
 	struct fimc_vid_cap *vc = &fimc->vid_cap;
-	bool close = v4l2_fh_is_singular_file(file);
 
 	dbg("pid: %d, state: 0x%lx", task_pid_nr(current), fimc->state);
 
@@ -548,9 +547,7 @@ static int fimc_capture_release(struct file *file)
 		vc->streaming = false;
 	}
 
-	_vb2_fop_release(file, NULL);
-
-	if (close) {
+	if (_vb2_fop_release(file, NULL)) {
 		clear_bit(ST_CAPT_BUSY, &fimc->state);
 		fimc_pipeline_call(&vc->ve, close);
 		clear_bit(ST_CAPT_SUSPENDED, &fimc->state);
diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index 5e2b4df..13d4f7f 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -1631,12 +1631,9 @@ out:
 static int mcam_v4l_release(struct file *filp)
 {
 	struct mcam_camera *cam = video_drvdata(filp);
-	bool last_open;
 
 	mutex_lock(&cam->s_mutex);
-	last_open = v4l2_fh_is_singular_file(filp);
-	_vb2_fop_release(filp, NULL);
-	if (last_open) {
+	if (_vb2_fop_release(filp, NULL)) {
 		mcam_disable_mipi(cam);
 		mcam_ctlr_power_down(cam);
 		if (cam->buffer_mode == B_vmalloc && alloc_bufs_at_read)
diff --git a/drivers/media/platform/sh_vou.c b/drivers/media/platform/sh_vou.c
index fe5c8ab..da1d78c 100644
--- a/drivers/media/platform/sh_vou.c
+++ b/drivers/media/platform/sh_vou.c
@@ -1157,12 +1157,9 @@ done_open:
 static int sh_vou_release(struct file *file)
 {
 	struct sh_vou_device *vou_dev = video_drvdata(file);
-	bool is_last;
 
 	mutex_lock(&vou_dev->fop_lock);
-	is_last = v4l2_fh_is_singular_file(file);
-	_vb2_fop_release(file, NULL);
-	if (is_last) {
+	if (_vb2_fop_release(file, NULL)) {
 		/* Last close */
 		vou_dev->status = SH_VOU_INITIALISING;
 		sh_vou_reg_a_set(vou_dev, VOUER, 0, 0x101);
-- 
2.1.4

