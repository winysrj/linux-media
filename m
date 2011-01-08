Return-path: <mchehab@pedra>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:2639 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542Ab1AHNhE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Jan 2011 08:37:04 -0500
Received: from localhost.localdomain (43.80-203-71.nextgentel.com [80.203.71.43])
	(authenticated bits=0)
	by smtp-vbr8.xs4all.nl (8.13.8/8.13.8) with ESMTP id p08Dalk3015112
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sat, 8 Jan 2011 14:37:02 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [RFCv3 PATCH 06/16] v4l2-fh: add v4l2_fh_is_singular
Date: Sat,  8 Jan 2011 14:36:31 +0100
Message-Id: <6ff819f4f20e59c96eb502857d0a4b50e82e5c60.1294493428.git.hverkuil@xs4all.nl>
In-Reply-To: <1294493801-17406-1-git-send-email-hverkuil@xs4all.nl>
References: <1294493801-17406-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1d57787db3bd1a76d292bd80d91ba9e10c07af68.1294493427.git.hverkuil@xs4all.nl>
References: <1d57787db3bd1a76d292bd80d91ba9e10c07af68.1294493427.git.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Several drivers need to do something when the first filehandle is opened
or the last filehandle is closed. Most implement some use count mechanism,
but if they use v4l2_fh, then you can also just check if this is the only
filehandle for the device node. A simple helper function can do this.

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/v4l2-fh.c |   14 ++++++++++++++
 include/media/v4l2-fh.h       |   13 +++++++++++++
 2 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/v4l2-fh.c b/drivers/media/video/v4l2-fh.c
index 27242e5..543b3fe 100644
--- a/drivers/media/video/v4l2-fh.c
+++ b/drivers/media/video/v4l2-fh.c
@@ -109,3 +109,17 @@ int v4l2_fh_release(struct file *filp)
 	return 0;
 }
 EXPORT_SYMBOL_GPL(v4l2_fh_release);
+
+int v4l2_fh_is_singular(struct v4l2_fh *fh)
+{
+	unsigned long flags;
+	int is_singular;
+
+	if (fh == NULL || fh->vdev == NULL)
+		return 0;
+	spin_lock_irqsave(&fh->vdev->fh_lock, flags);
+	is_singular = list_is_singular(&fh->list);
+	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
+	return is_singular;
+}
+EXPORT_SYMBOL_GPL(v4l2_fh_is_singular);
diff --git a/include/media/v4l2-fh.h b/include/media/v4l2-fh.h
index 5657881..0206aa5 100644
--- a/include/media/v4l2-fh.h
+++ b/include/media/v4l2-fh.h
@@ -77,5 +77,18 @@ void v4l2_fh_exit(struct v4l2_fh *fh);
  * v4l2_fh struct) is NULL. This function always returns 0.
  */
 int v4l2_fh_release(struct file *filp);
+/*
+ * Returns 1 if this filehandle is the only filehandle opened for the
+ * associated video_device. If fh is NULL, then it returns 0.
+ */
+int v4l2_fh_is_singular(struct v4l2_fh *fh);
+/*
+ * Helper function with struct file as argument. If filp->private_data is
+ * NULL, then it will return 0.
+ */
+static inline int v4l2_fh_is_singular_file(struct file *filp)
+{
+	return v4l2_fh_is_singular(filp->private_data);
+}
 
 #endif /* V4L2_EVENT_H */
-- 
1.7.0.4

