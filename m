Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m97GIpNL023448
	for <video4linux-list@redhat.com>; Tue, 7 Oct 2008 12:18:51 -0400
Received: from mgw-mx06.nokia.com (smtp.nokia.com [192.100.122.233])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m97GIcNN021757
	for <video4linux-list@redhat.com>; Tue, 7 Oct 2008 12:18:38 -0400
From: Sakari Ailus <sakari.ailus@nokia.com>
To: hverkuil@xs4all.nl, video4linux-list@redhat.com
Date: Tue,  7 Oct 2008 19:18:13 +0300
Message-Id: <12233962962104-git-send-email-sakari.ailus@nokia.com>
In-Reply-To: <1223396296101-git-send-email-sakari.ailus@nokia.com>
References: <48EB8BAC.90706@nokia.com>
	<12233962961256-git-send-email-sakari.ailus@nokia.com>
	<1223396296101-git-send-email-sakari.ailus@nokia.com>
Cc: vimarsh.zutshi@nokia.com, tuukka.o.toivonen@nokia.com, hnagalla@ti.com
Subject: [PATCH 3/6] V4L: Add 10-bit RAW Bayer formats
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Add 10-bit raw bayer format expanded to 16 bits. Adds also definition
for 10-bit raw bayer format dpcm-compressed to 8 bits.

Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
---
 include/linux/videodev2.h |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 303d93f..b80e5ca 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -315,6 +315,13 @@ struct v4l2_pix_format {
 /* see http://www.siliconimaging.com/RGB%20Bayer.htm */
 #define V4L2_PIX_FMT_SBGGR8  v4l2_fourcc('B', 'A', '8', '1') /*  8  BGBG.. GRGR.. */
 #define V4L2_PIX_FMT_SGBRG8  v4l2_fourcc('G', 'B', 'R', 'G') /*  8  GBGB.. RGRG.. */
+/*
+ * 10bit raw bayer, expanded to 16 bits
+ * xxxxrrrrrrrrrrxxxxgggggggggg xxxxggggggggggxxxxbbbbbbbbbb...
+ */
+#define V4L2_PIX_FMT_SGRBG10 v4l2_fourcc('B', 'A', '1', '0')
+/* 10bit raw bayer DPCM compressed to 8 bits */
+#define V4L2_PIX_FMT_SGRBG10DPCM8 v4l2_fourcc('B', 'D', '1', '0')
 #define V4L2_PIX_FMT_SBGGR16 v4l2_fourcc('B', 'Y', 'R', '2') /* 16  BGBG.. GRGR.. */
 
 /* compressed formats */
-- 
1.5.0.6

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
