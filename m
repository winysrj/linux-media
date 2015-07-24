Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:49571 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752797AbbGXKW6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jul 2015 06:22:58 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@linux.intel.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 4/7] am437x-vpfe/fimc-capture: always return 0 on close
Date: Fri, 24 Jul 2015 12:21:33 +0200
Message-Id: <1437733296-38198-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1437733296-38198-1-git-send-email-hverkuil@xs4all.nl>
References: <1437733296-38198-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

When the filehandle is closed always return 0 and ignore the return
code from _vb2_fop_release().

Currently _vb2_fop_release() always returns 0, but this will change in
the next patch where _vb2_fop_release() will return a boolean telling the
caller if this was the last open filehandle that is closed.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/am437x/am437x-vpfe.c      | 5 ++---
 drivers/media/platform/exynos4-is/fimc-capture.c | 5 ++---
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/am437x/am437x-vpfe.c b/drivers/media/platform/am437x/am437x-vpfe.c
index c8447fa..210c779 100644
--- a/drivers/media/platform/am437x/am437x-vpfe.c
+++ b/drivers/media/platform/am437x/am437x-vpfe.c
@@ -1187,7 +1187,6 @@ static int vpfe_release(struct file *file)
 {
 	struct vpfe_device *vpfe = video_drvdata(file);
 	bool fh_singular;
-	int ret;
 
 	mutex_lock(&vpfe->lock);
 
@@ -1195,7 +1194,7 @@ static int vpfe_release(struct file *file)
 	fh_singular = v4l2_fh_is_singular_file(file);
 
 	/* the release helper will cleanup any on-going streaming */
-	ret = _vb2_fop_release(file, NULL);
+	_vb2_fop_release(file, NULL);
 
 	/*
 	 * If this was the last open file.
@@ -1206,7 +1205,7 @@ static int vpfe_release(struct file *file)
 
 	mutex_unlock(&vpfe->lock);
 
-	return ret;
+	return 0;
 }
 
 /*
diff --git a/drivers/media/platform/exynos4-is/fimc-capture.c b/drivers/media/platform/exynos4-is/fimc-capture.c
index cfebf29..f4458b0 100644
--- a/drivers/media/platform/exynos4-is/fimc-capture.c
+++ b/drivers/media/platform/exynos4-is/fimc-capture.c
@@ -538,7 +538,6 @@ static int fimc_capture_release(struct file *file)
 	struct fimc_dev *fimc = video_drvdata(file);
 	struct fimc_vid_cap *vc = &fimc->vid_cap;
 	bool close = v4l2_fh_is_singular_file(file);
-	int ret;
 
 	dbg("pid: %d, state: 0x%lx", task_pid_nr(current), fimc->state);
 
@@ -549,7 +548,7 @@ static int fimc_capture_release(struct file *file)
 		vc->streaming = false;
 	}
 
-	ret = _vb2_fop_release(file, NULL);
+	_vb2_fop_release(file, NULL);
 
 	if (close) {
 		clear_bit(ST_CAPT_BUSY, &fimc->state);
@@ -564,7 +563,7 @@ static int fimc_capture_release(struct file *file)
 	pm_runtime_put_sync(&fimc->pdev->dev);
 	mutex_unlock(&fimc->lock);
 
-	return ret;
+	return 0;
 }
 
 static const struct v4l2_file_operations fimc_capture_fops = {
-- 
2.1.4

