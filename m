Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:35465 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752683AbZCMKXB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Mar 2009 06:23:01 -0400
Received: from dbdp31.itg.ti.com ([172.24.170.98])
	by comal.ext.ti.com (8.13.7/8.13.7) with ESMTP id n2DAMrjA012817
	for <linux-media@vger.kernel.org>; Fri, 13 Mar 2009 05:22:59 -0500
From: chaithrika@ti.com
To: linux-media@vger.kernel.org
Cc: davinci-linux-open-source@linux.davincidsp.com,
	Chaithrika U S <chaithrika@ti.com>
Subject: [RFC 4/7] ARM: DaVinci: DM646x Video: Defintions for standards supported by display
Date: Fri, 13 Mar 2009 14:31:37 +0530
Message-Id: <1236934897-32160-1-git-send-email-chaithrika@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Chaithrika U S <chaithrika@ti.com>

Add defintions for Digital TV Standards supported by display driver

Signed-off-by: Chaithrika U S <chaithrika@ti.com>
---
Applies to v4l-dvb repository located at
http://linuxtv.org/hg/v4l-dvb/rev/1fd54a62abde

 include/linux/videodev2.h |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 7a8eafd..df4a622 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -704,6 +704,18 @@ typedef __u64 v4l2_std_id;
 #define V4L2_STD_ALL            (V4L2_STD_525_60	|\
 				 V4L2_STD_625_50)
 
+#define V4L2_STD_720P_60        ((v4l2_std_id)(0x0001000000000000ULL))
+#define V4L2_STD_1080I_30       ((v4l2_std_id)(0x0002000000000000ULL))
+#define V4L2_STD_1080I_25       ((v4l2_std_id)(0x0004000000000000ULL))
+#define V4L2_STD_480P_60        ((v4l2_std_id)(0x0008000000000000ULL))
+#define V4L2_STD_576P_50        ((v4l2_std_id)(0x0010000000000000ULL))
+#define V4L2_STD_720P_25        ((v4l2_std_id)(0x0020000000000000ULL))
+#define V4L2_STD_720P_30        ((v4l2_std_id)(0x0040000000000000ULL))
+#define V4L2_STD_720P_50        ((v4l2_std_id)(0x0080000000000000ULL))
+#define V4L2_STD_1080P_25       ((v4l2_std_id)(0x0100000000000000ULL))
+#define V4L2_STD_1080P_30       ((v4l2_std_id)(0x0200000000000000ULL))
+#define V4L2_STD_1080P_24       ((v4l2_std_id)(0x0400000000000000ULL))
+
 struct v4l2_standard {
 	__u32		     index;
 	v4l2_std_id          id;
-- 
1.5.6

