Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:38740 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751024Ab2KOWGv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Nov 2012 17:06:51 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com
Subject: [PATCH 2/4] v4l: Helper function for obtaining timestamps
Date: Fri, 16 Nov 2012 00:06:45 +0200
Message-Id: <1353017207-370-2-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <20121115220627.GB29863@valkosipuli.retiisi.org.uk>
References: <20121115220627.GB29863@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v4l2_get_timestamp() produces a monotonic timestamp but unlike
ktime_get_ts(), it uses struct timeval instead of struct timespec, saving
the drivers the conversion job when getting timestamps for v4l2_buffer's
timestamp field.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/v4l2-core/v4l2-common.c |   10 ++++++++++
 include/media/v4l2-common.h           |    2 ++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-common.c b/drivers/media/v4l2-core/v4l2-common.c
index 380ddd8..614316f 100644
--- a/drivers/media/v4l2-core/v4l2-common.c
+++ b/drivers/media/v4l2-core/v4l2-common.c
@@ -978,3 +978,13 @@ const struct v4l2_frmsize_discrete *v4l2_find_nearest_format(
 	return best;
 }
 EXPORT_SYMBOL_GPL(v4l2_find_nearest_format);
+
+void v4l2_get_timestamp(struct timeval *tv)
+{
+	struct timespec ts;
+
+	ktime_get_ts(&ts);
+	tv->tv_sec = ts.tv_sec;
+	tv->tv_usec = ts.tv_nsec / NSEC_PER_USEC;
+}
+EXPORT_SYMBOL_GPL(v4l2_get_timestamp);
diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
index 1a0b2db..ec7c9c0 100644
--- a/include/media/v4l2-common.h
+++ b/include/media/v4l2-common.h
@@ -225,4 +225,6 @@ bool v4l2_detect_gtf(unsigned frame_height, unsigned hfreq, unsigned vsync,
 
 struct v4l2_fract v4l2_calc_aspect_ratio(u8 hor_landscape, u8 vert_portrait);
 
+void v4l2_get_timestamp(struct timeval *tv);
+
 #endif /* V4L2_COMMON_H_ */
-- 
1.7.2.5

