Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32512 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933551Ab1JDTxb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 4 Oct 2011 15:53:31 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p94JrVBx027659
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 4 Oct 2011 15:53:31 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCHv2 6/8] [media] videodev2: Reorganize standard macros and add a few more
Date: Tue,  4 Oct 2011 16:53:18 -0300
Message-Id: <1317758000-21154-6-git-send-email-mchehab@redhat.com>
In-Reply-To: <1317758000-21154-5-git-send-email-mchehab@redhat.com>
References: <1317758000-21154-1-git-send-email-mchehab@redhat.com>
 <1317758000-21154-2-git-send-email-mchehab@redhat.com>
 <1317758000-21154-3-git-send-email-mchehab@redhat.com>
 <1317758000-21154-4-git-send-email-mchehab@redhat.com>
 <1317758000-21154-5-git-send-email-mchehab@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reorganize the standards macro and add a few more, that will be
used on msp3400 in order to allow it to detect the audio standard.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 include/linux/videodev2.h |   79 +++++++++++++++++++++++++++++++++-----------
 1 files changed, 59 insertions(+), 20 deletions(-)

diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 9d14523..225560c 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -759,10 +759,10 @@ typedef __u64 v4l2_std_id;
 #define V4L2_STD_PAL_Nc         ((v4l2_std_id)0x00000400)
 #define V4L2_STD_PAL_60         ((v4l2_std_id)0x00000800)
 
-#define V4L2_STD_NTSC_M         ((v4l2_std_id)0x00001000)
-#define V4L2_STD_NTSC_M_JP      ((v4l2_std_id)0x00002000)
+#define V4L2_STD_NTSC_M         ((v4l2_std_id)0x00001000)	/* BTSC */
+#define V4L2_STD_NTSC_M_JP      ((v4l2_std_id)0x00002000)	/* EIA-J */
 #define V4L2_STD_NTSC_443       ((v4l2_std_id)0x00004000)
-#define V4L2_STD_NTSC_M_KR      ((v4l2_std_id)0x00008000)
+#define V4L2_STD_NTSC_M_KR      ((v4l2_std_id)0x00008000)	/* FM A2 */
 
 #define V4L2_STD_SECAM_B        ((v4l2_std_id)0x00010000)
 #define V4L2_STD_SECAM_D        ((v4l2_std_id)0x00020000)
@@ -786,47 +786,86 @@ typedef __u64 v4l2_std_id;
    v4l2-common.c should be fixed.
  */
 
-/* some merged standards */
-#define V4L2_STD_MN	(V4L2_STD_PAL_M|V4L2_STD_PAL_N|V4L2_STD_PAL_Nc|V4L2_STD_NTSC)
-#define V4L2_STD_B	(V4L2_STD_PAL_B|V4L2_STD_PAL_B1|V4L2_STD_SECAM_B)
-#define V4L2_STD_GH	(V4L2_STD_PAL_G|V4L2_STD_PAL_H|V4L2_STD_SECAM_G|V4L2_STD_SECAM_H)
-#define V4L2_STD_DK	(V4L2_STD_PAL_DK|V4L2_STD_SECAM_DK)
+/*
+ * Some macros to merge video standards in order to make live easier for the
+ * drivers and V4L2 applications
+ */
 
-/* some common needed stuff */
-#define V4L2_STD_PAL_BG		(V4L2_STD_PAL_B		|\
-				 V4L2_STD_PAL_B1	|\
-				 V4L2_STD_PAL_G)
-#define V4L2_STD_PAL_DK		(V4L2_STD_PAL_D		|\
-				 V4L2_STD_PAL_D1	|\
-				 V4L2_STD_PAL_K)
-#define V4L2_STD_PAL		(V4L2_STD_PAL_BG	|\
-				 V4L2_STD_PAL_DK	|\
-				 V4L2_STD_PAL_H		|\
-				 V4L2_STD_PAL_I)
+/*
+ * "Common" NTSC/M - It should be noticed that V4L2_STD_NTSC_443 is
+ * Missing here.
+ */
 #define V4L2_STD_NTSC           (V4L2_STD_NTSC_M	|\
 				 V4L2_STD_NTSC_M_JP     |\
 				 V4L2_STD_NTSC_M_KR)
+/* Secam macros */
 #define V4L2_STD_SECAM_DK      	(V4L2_STD_SECAM_D	|\
 				 V4L2_STD_SECAM_K	|\
 				 V4L2_STD_SECAM_K1)
+/* All Secam Standards */
 #define V4L2_STD_SECAM		(V4L2_STD_SECAM_B	|\
 				 V4L2_STD_SECAM_G	|\
 				 V4L2_STD_SECAM_H	|\
 				 V4L2_STD_SECAM_DK	|\
 				 V4L2_STD_SECAM_L       |\
 				 V4L2_STD_SECAM_LC)
+/* PAL macros */
+#define V4L2_STD_PAL_BG		(V4L2_STD_PAL_B		|\
+				 V4L2_STD_PAL_B1	|\
+				 V4L2_STD_PAL_G)
+#define V4L2_STD_PAL_DK		(V4L2_STD_PAL_D		|\
+				 V4L2_STD_PAL_D1	|\
+				 V4L2_STD_PAL_K)
+/*
+ * "Common" PAL - This macro is there to be compatible with the old
+ * V4L1 concept of "PAL": /BGDKHI.
+ * Several PAL standards are mising here: /M, /N and /Nc
+ */
+#define V4L2_STD_PAL		(V4L2_STD_PAL_BG	|\
+				 V4L2_STD_PAL_DK	|\
+				 V4L2_STD_PAL_H		|\
+				 V4L2_STD_PAL_I)
+/* Chroma "agnostic" standards */
+#define V4L2_STD_B		(V4L2_STD_PAL_B		|\
+				 V4L2_STD_PAL_B1	|\
+				 V4L2_STD_SECAM_B)
+#define V4L2_STD_G		(V4L2_STD_PAL_G		|\
+				 V4L2_STD_SECAM_G)
+#define V4L2_STD_H		(V4L2_STD_PAL_H		|\
+				 V4L2_STD_SECAM_H)
+#define V4L2_STD_L		(V4L2_STD_SECAM_L	|\
+				 V4L2_STD_SECAM_LC)
+#define V4L2_STD_GH		(V4L2_STD_G		|\
+				 V4L2_STD_H)
+#define V4L2_STD_DK		(V4L2_STD_PAL_DK	|\
+				 V4L2_STD_SECAM_DK)
+#define V4L2_STD_BG		(V4L2_STD_B		|\
+				 V4L2_STD_G)
+#define V4L2_STD_MN		(V4L2_STD_PAL_M		|\
+				 V4L2_STD_PAL_N		|\
+				 V4L2_STD_PAL_Nc	|\
+				 V4L2_STD_NTSC)
 
+/* Standards where MTS/BTSC stereo could be found */
+#define V4L2_STD_MTS		(V4L2_STD_NTSC_M	|\
+				 V4L2_STD_PAL_M		|\
+				 V4L2_STD_PAL_N		|\
+				 V4L2_STD_PAL_Nc)
+
+/* Standards for Countries with 60Hz Line frequency */
 #define V4L2_STD_525_60		(V4L2_STD_PAL_M		|\
 				 V4L2_STD_PAL_60	|\
 				 V4L2_STD_NTSC		|\
 				 V4L2_STD_NTSC_443)
+/* Standards for Countries with 50Hz Line frequency */
 #define V4L2_STD_625_50		(V4L2_STD_PAL		|\
 				 V4L2_STD_PAL_N		|\
 				 V4L2_STD_PAL_Nc	|\
 				 V4L2_STD_SECAM)
+
 #define V4L2_STD_ATSC           (V4L2_STD_ATSC_8_VSB    |\
 				 V4L2_STD_ATSC_16_VSB)
-
+/* Macros with none and all analog standards */
 #define V4L2_STD_UNKNOWN        0
 #define V4L2_STD_ALL            (V4L2_STD_525_60	|\
 				 V4L2_STD_625_50)
-- 
1.7.6.4

