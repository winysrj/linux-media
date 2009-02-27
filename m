Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:61276 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755208AbZB0QcS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Feb 2009 11:32:18 -0500
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
To: linux-media@vger.kernel.org
Cc: video4linux-list@redhat.com, tuukka.o.toivonen@nokia.com,
	saaguirre@ti.com, antti.koskipaa@nokia.com, david.cohen@nokia.com,
	Sakari Ailus <sakari.ailus@nokia.com>
Subject: [PATCH 3/4] V4L: int device: add support for VIDIOC_QUERYMENU
Date: Fri, 27 Feb 2009 18:31:32 +0200
Message-Id: <1235752293-14452-3-git-send-email-sakari.ailus@maxwell.research.nokia.com>
In-Reply-To: <1235752293-14452-2-git-send-email-sakari.ailus@maxwell.research.nokia.com>
References: <49A81502.3090002@maxwell.research.nokia.com>
 <1235752293-14452-1-git-send-email-sakari.ailus@maxwell.research.nokia.com>
 <1235752293-14452-2-git-send-email-sakari.ailus@maxwell.research.nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@nokia.com>

Signed-off-by: Tuukka Toivonen <tuukka.o.toivonen@nokia.com>
---
 include/media/v4l2-int-device.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/media/v4l2-int-device.h b/include/media/v4l2-int-device.h
index 5d254c4..81f4863 100644
--- a/include/media/v4l2-int-device.h
+++ b/include/media/v4l2-int-device.h
@@ -178,6 +178,7 @@ enum v4l2_int_ioctl_num {
 	vidioc_int_s_fmt_cap_num,
 	vidioc_int_try_fmt_cap_num,
 	vidioc_int_queryctrl_num,
+	vidioc_int_querymenu_num,
 	vidioc_int_g_ctrl_num,
 	vidioc_int_s_ctrl_num,
 	vidioc_int_cropcap_num,
@@ -282,6 +283,7 @@ V4L2_INT_WRAPPER_1(g_fmt_cap, struct v4l2_format, *);
 V4L2_INT_WRAPPER_1(s_fmt_cap, struct v4l2_format, *);
 V4L2_INT_WRAPPER_1(try_fmt_cap, struct v4l2_format, *);
 V4L2_INT_WRAPPER_1(queryctrl, struct v4l2_queryctrl, *);
+V4L2_INT_WRAPPER_1(querymenu, struct v4l2_querymenu, *);
 V4L2_INT_WRAPPER_1(g_ctrl, struct v4l2_control, *);
 V4L2_INT_WRAPPER_1(s_ctrl, struct v4l2_control, *);
 V4L2_INT_WRAPPER_1(cropcap, struct v4l2_cropcap, *);
-- 
1.5.6.5

