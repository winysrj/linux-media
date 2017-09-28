Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f180.google.com ([209.85.192.180]:49629 "EHLO
        mail-pf0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752656AbdI1JvF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Sep 2017 05:51:05 -0400
Received: by mail-pf0-f180.google.com with SMTP id l188so608350pfc.6
        for <linux-media@vger.kernel.org>; Thu, 28 Sep 2017 02:51:05 -0700 (PDT)
From: Alexandre Courbot <acourbot@chromium.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexandre Courbot <acourbot@chromium.org>
Subject: [RFC PATCH 1/9] [media] v4l2-core: add v4l2_is_v4l2_file function
Date: Thu, 28 Sep 2017 18:50:19 +0900
Message-Id: <20170928095027.127173-2-acourbot@chromium.org>
In-Reply-To: <20170928095027.127173-1-acourbot@chromium.org>
References: <20170928095027.127173-1-acourbot@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a function that checks whether a given open file is a v4l2 device
instance. This will be useful for job queue creation as we are passed a
set of FDs and we need to make this check.

Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
---
 drivers/media/v4l2-core/v4l2-dev.c | 6 ++++++
 include/media/v4l2-dev.h           | 9 +++++++++
 2 files changed, 15 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index c647ba648805..5a7063886c93 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -470,6 +470,12 @@ static const struct file_operations v4l2_fops = {
 	.llseek = no_llseek,
 };
 
+bool v4l2_is_v4l2_file(struct file *filp)
+{
+	return filp->f_op == &v4l2_fops;
+}
+EXPORT_SYMBOL(v4l2_is_v4l2_file);
+
 /**
  * get_index - assign stream index number based on v4l2_dev
  * @vdev: video_device to assign index number to, vdev->v4l2_dev should be assigned
diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
index e657614521e3..b73d646980da 100644
--- a/include/media/v4l2-dev.h
+++ b/include/media/v4l2-dev.h
@@ -395,6 +395,15 @@ void video_device_release(struct video_device *vdev);
  */
 void video_device_release_empty(struct video_device *vdev);
 
+/**
+ * v4l2_is_v4l2_file - Check whether a file describes a V4L2 device
+ *
+ * @filp: opened file to check
+ *
+ * Returns true of the file is a V4L2 device, false otherwise.
+ */
+bool v4l2_is_v4l2_file(struct file *filp);
+
 /**
  * v4l2_is_known_ioctl - Checks if a given cmd is a known V4L ioctl
  *
-- 
2.14.2.822.g60be5d43e6-goog
