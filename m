Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m96B8YaU002999
	for <video4linux-list@redhat.com>; Mon, 6 Oct 2008 07:08:34 -0400
Received: from mgw-mx03.nokia.com (smtp.nokia.com [192.100.122.230])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m96B8JW8008037
	for <video4linux-list@redhat.com>; Mon, 6 Oct 2008 07:08:20 -0400
From: Sakari Ailus <sakari.ailus@nokia.com>
To: video4linux-list@redhat.com
Date: Mon,  6 Oct 2008 14:07:49 +0300
Message-Id: <12232912721943-git-send-email-sakari.ailus@nokia.com>
In-Reply-To: <12232912722050-git-send-email-sakari.ailus@nokia.com>
References: <48E9F178.50507@nokia.com>
	<12232912722008-git-send-email-sakari.ailus@nokia.com>
	<12232912722050-git-send-email-sakari.ailus@nokia.com>
Cc: vimarsh.zutshi@nokia.com, tuukka.o.toivonen@nokia.com, hnagalla@ti.com
Subject: [PATCH] V4L: Add 10-bit RAW Bayer formats
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
