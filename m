Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:47025 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757011Ab0EXMV5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 May 2010 08:21:57 -0400
From: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	eduardo.valentin@nokia.com
Cc: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Subject: [PATCH v3 1/4] V4L2: Add features to the interface.
Date: Mon, 24 May 2010 15:21:40 +0300
Message-Id: <1274703703-11670-2-git-send-email-matti.j.aaltonen@nokia.com>
In-Reply-To: <1274703703-11670-1-git-send-email-matti.j.aaltonen@nokia.com>
References: <1274703703-11670-1-git-send-email-matti.j.aaltonen@nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add fields spacing, level_min, level_max and level to struct v4l2_hw_freq_seek.
The level is used for determining which channels are considered receivable
during HW scan.

Add  VIDIOC_G_HW_FREQ_SEEK to IOCTL codes. This is used for getting the minimum and
maximum values for the level field in the v4l2_hw_freq_seek struct.

Signed-off-by: Matti J. Aaltonen <matti.j.aaltonen@nokia.com>
---
 include/linux/videodev2.h  |    6 +++++-
 include/media/v4l2-ioctl.h |    2 ++
 2 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 418dacf..7a81a9c 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -1377,7 +1377,11 @@ struct v4l2_hw_freq_seek {
 	enum v4l2_tuner_type  type;
 	__u32		      seek_upward;
 	__u32		      wrap_around;
-	__u32		      reserved[8];
+	__u32		      spacing;
+	__s32		      level_min;
+	__s32		      level_max;
+	__s32		      level;
+	__u32		      reserved[4];
 };
 
 /*
diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
index e8ba0f2..828cf13 100644
--- a/include/media/v4l2-ioctl.h
+++ b/include/media/v4l2-ioctl.h
@@ -220,6 +220,8 @@ struct v4l2_ioctl_ops {
 	/* Log status ioctl */
 	int (*vidioc_log_status)       (struct file *file, void *fh);
 
+	int (*vidioc_g_hw_freq_seek)   (struct file *file, void *fh,
+					struct v4l2_hw_freq_seek *a);
 	int (*vidioc_s_hw_freq_seek)   (struct file *file, void *fh,
 					struct v4l2_hw_freq_seek *a);
 
-- 
1.6.1.3

