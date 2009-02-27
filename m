Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:61280 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755501AbZB0QcT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Feb 2009 11:32:19 -0500
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
To: linux-media@vger.kernel.org
Cc: video4linux-list@redhat.com, tuukka.o.toivonen@nokia.com,
	saaguirre@ti.com, antti.koskipaa@nokia.com, david.cohen@nokia.com,
	Sakari Ailus <sakari.ailus@nokia.com>
Subject: [PATCH 4/4] V4L: Int if: Add vidioc_int_querycap
Date: Fri, 27 Feb 2009 18:31:33 +0200
Message-Id: <1235752293-14452-4-git-send-email-sakari.ailus@maxwell.research.nokia.com>
In-Reply-To: <1235752293-14452-3-git-send-email-sakari.ailus@maxwell.research.nokia.com>
References: <49A81502.3090002@maxwell.research.nokia.com>
 <1235752293-14452-1-git-send-email-sakari.ailus@maxwell.research.nokia.com>
 <1235752293-14452-2-git-send-email-sakari.ailus@maxwell.research.nokia.com>
 <1235752293-14452-3-git-send-email-sakari.ailus@maxwell.research.nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@nokia.com>

Signed-off-by: Sakari Ailus <sakari.ailus@nokia.com>
---
 include/media/v4l2-int-device.h |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/include/media/v4l2-int-device.h b/include/media/v4l2-int-device.h
index 81f4863..2830ae1 100644
--- a/include/media/v4l2-int-device.h
+++ b/include/media/v4l2-int-device.h
@@ -173,7 +173,8 @@ enum v4l2_int_ioctl_num {
 	 * "Proper" V4L ioctls, as in struct video_device.
 	 *
 	 */
-	vidioc_int_enum_fmt_cap_num = 1,
+	vidioc_int_querycap_num = 1,
+	vidioc_int_enum_fmt_cap_num,
 	vidioc_int_g_fmt_cap_num,
 	vidioc_int_s_fmt_cap_num,
 	vidioc_int_try_fmt_cap_num,
@@ -278,6 +279,7 @@ enum v4l2_int_ioctl_num {
 		return desc;						\
 	}
 
+V4L2_INT_WRAPPER_1(querycap, struct v4l2_capability, *);
 V4L2_INT_WRAPPER_1(enum_fmt_cap, struct v4l2_fmtdesc, *);
 V4L2_INT_WRAPPER_1(g_fmt_cap, struct v4l2_format, *);
 V4L2_INT_WRAPPER_1(s_fmt_cap, struct v4l2_format, *);
-- 
1.5.6.5

