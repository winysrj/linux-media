Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:49571 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752172AbbGXKWy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jul 2015 06:22:54 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@linux.intel.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 1/7] v4l2-fh: change int to bool for v4l2_fh_is_singular(_file)
Date: Fri, 24 Jul 2015 12:21:30 +0200
Message-Id: <1437733296-38198-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1437733296-38198-1-git-send-email-hverkuil@xs4all.nl>
References: <1437733296-38198-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This function really returns a bool, so use that as the return type
instead of int.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-fh.c |  6 +++---
 include/media/v4l2-fh.h           | 10 +++++-----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-fh.c b/drivers/media/v4l2-core/v4l2-fh.c
index c97067a..20c0a0c 100644
--- a/drivers/media/v4l2-core/v4l2-fh.c
+++ b/drivers/media/v4l2-core/v4l2-fh.c
@@ -110,13 +110,13 @@ int v4l2_fh_release(struct file *filp)
 }
 EXPORT_SYMBOL_GPL(v4l2_fh_release);
 
-int v4l2_fh_is_singular(struct v4l2_fh *fh)
+bool v4l2_fh_is_singular(struct v4l2_fh *fh)
 {
 	unsigned long flags;
-	int is_singular;
+	bool is_singular;
 
 	if (fh == NULL || fh->vdev == NULL)
-		return 0;
+		return false;
 	spin_lock_irqsave(&fh->vdev->fh_lock, flags);
 	is_singular = list_is_singular(&fh->list);
 	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
diff --git a/include/media/v4l2-fh.h b/include/media/v4l2-fh.h
index 8035167..13dcaae 100644
--- a/include/media/v4l2-fh.h
+++ b/include/media/v4l2-fh.h
@@ -91,15 +91,15 @@ void v4l2_fh_exit(struct v4l2_fh *fh);
  */
 int v4l2_fh_release(struct file *filp);
 /*
- * Returns 1 if this filehandle is the only filehandle opened for the
- * associated video_device. If fh is NULL, then it returns 0.
+ * Returns true if this filehandle is the only filehandle opened for the
+ * associated video_device. If fh is NULL, then it returns false.
  */
-int v4l2_fh_is_singular(struct v4l2_fh *fh);
+bool v4l2_fh_is_singular(struct v4l2_fh *fh);
 /*
  * Helper function with struct file as argument. If filp->private_data is
- * NULL, then it will return 0.
+ * NULL, then it will return false.
  */
-static inline int v4l2_fh_is_singular_file(struct file *filp)
+static inline bool v4l2_fh_is_singular_file(struct file *filp)
 {
 	return v4l2_fh_is_singular(filp->private_data);
 }
-- 
2.1.4

