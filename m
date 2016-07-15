Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7.mo3.mail-out.ovh.net ([46.105.57.200]:49892 "EHLO
	7.mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbcGOPiv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jul 2016 11:38:51 -0400
Received: from player734.ha.ovh.net (b7.ovh.net [213.186.33.57])
	by mo3.mail-out.ovh.net (Postfix) with ESMTP id C45BB102CE7A
	for <linux-media@vger.kernel.org>; Fri, 15 Jul 2016 15:13:32 +0200 (CEST)
Received: from [192.168.1.29] (LFbn-1-1866-70.w90-73.abo.wanadoo.fr [90.73.165.70])
	(Authenticated sender: charles-antoine.couret@nexvision.fr)
	by player734.ha.ovh.net (Postfix) with ESMTPSA id 760FF28006B
	for <linux-media@vger.kernel.org>; Fri, 15 Jul 2016 15:13:32 +0200 (CEST)
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Charles-Antoine Couret <charles-antoine.couret@nexvision.fr>
Subject: [PATCH 1/2 v2] SDI: add flag for SDI formats and SMPTE 125M
 definition
Message-ID: <d46d8b4a-e52b-9caa-9599-33fc98344b82@nexvision.fr>
Date: Fri, 15 Jul 2016 15:13:32 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>From c6b157259081bd40d881a5c642dd1a4a07195ca5 Mon Sep 17 00:00:00 2001
From: Charles-Antoine Couret <charles-antoine.couret@nexvision.fr>
Date: Fri, 15 Jul 2016 15:04:57 +0200
Subject: [PATCH 1/2] SDI: add flag for SDI formats and SMPTE 125M definition

Adding others generic flags, which could be used by many
components like GS1662.

Signed-off-by: Charles-Antoine Couret <charles-antoine.couret@nexvision.fr>
---
 include/uapi/linux/v4l2-dv-timings.h | 12 ++++++++++++
 include/uapi/linux/videodev2.h       |  5 +++++
 2 files changed, 17 insertions(+)

diff --git a/include/uapi/linux/v4l2-dv-timings.h b/include/uapi/linux/v4l2-dv-timings.h
index 086168e..eb7dd02 100644
--- a/include/uapi/linux/v4l2-dv-timings.h
+++ b/include/uapi/linux/v4l2-dv-timings.h
@@ -934,4 +934,16 @@
 		V4L2_DV_FL_REDUCED_BLANKING) \
 }
 
+/* SDI timings definitions */
+
+/* SMPTE-125M */
+#define V4L2_DV_BT_SDI_720X487I60 { \
+	.type = V4L2_DV_BT_656_1120, \
+	V4L2_INIT_BT_TIMINGS(720, 487, 1, \
+		V4L2_DV_HSYNC_POS_POL, \
+		13500000, 0, 137, 0, 0, 19, 2, 0, 17, 0, \
+		V4L2_DV_BT_STD_SDI, \
+		V4L2_DV_FIRST_FIELD_EXTRA_LINE) \
+}
+
 #endif
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 8f95191..4641f13 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -1259,6 +1259,7 @@ struct v4l2_bt_timings {
 #define V4L2_DV_BT_STD_DMT	(1 << 1)  /* VESA Discrete Monitor Timings */
 #define V4L2_DV_BT_STD_CVT	(1 << 2)  /* VESA Coordinated Video Timings */
 #define V4L2_DV_BT_STD_GTF	(1 << 3)  /* VESA Generalized Timings Formula */
+#define V4L2_DV_BT_STD_SDI	(1 << 4)  /* SDI Timings */
 
 /* Flags */
 
@@ -1363,6 +1364,8 @@ struct v4l2_bt_timings_cap {
 #define V4L2_DV_BT_CAP_REDUCED_BLANKING	(1 << 2)
 /* Supports custom formats */
 #define V4L2_DV_BT_CAP_CUSTOM		(1 << 3)
+/* In case of odd format, to know the field which has the extra line */
+#define V4L2_DV_FIRST_FIELD_EXTRA_LINE	(1 << 4)
 
 /** struct v4l2_dv_timings_cap - DV timings capabilities
  * @type:	the type of the timings (same as in struct v4l2_dv_timings)
@@ -1413,6 +1416,8 @@ struct v4l2_input {
 /* field 'status' - analog */
 #define V4L2_IN_ST_NO_H_LOCK   0x00000100  /* No horizontal sync lock */
 #define V4L2_IN_ST_COLOR_KILL  0x00000200  /* Color killer is active */
+#define V4L2_IN_ST_NO_V_LOCK   0x00000400  /* No vertical sync lock */
+#define V4L2_IN_ST_NO_STD_LOCK 0x00000800  /* No standard format lock */
 
 /* field 'status' - digital */
 #define V4L2_IN_ST_NO_SYNC     0x00010000  /* No synchronization lock */
-- 
2.7.4
