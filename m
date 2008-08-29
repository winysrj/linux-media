Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7TNbuaL027588
	for <video4linux-list@redhat.com>; Fri, 29 Aug 2008 19:38:02 -0400
Received: from devils.ext.ti.com (devils.ext.ti.com [198.47.26.153])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7TNbiIK002448
	for <video4linux-list@redhat.com>; Fri, 29 Aug 2008 19:37:45 -0400
Received: from dlep95.itg.ti.com ([157.170.170.107])
	by devils.ext.ti.com (8.13.7/8.13.7) with ESMTP id m7TNbdqN023772
	for <video4linux-list@redhat.com>; Fri, 29 Aug 2008 18:37:44 -0500
Received: from dlee74.ent.ti.com (localhost [127.0.0.1])
	by dlep95.itg.ti.com (8.13.8/8.13.8) with ESMTP id m7TNbdxu020642
	for <video4linux-list@redhat.com>; Fri, 29 Aug 2008 18:37:39 -0500 (CDT)
From: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
To: "video4linux-list@redhat.com" <video4linux-list@redhat.com>
Date: Fri, 29 Aug 2008 18:37:38 -0500
Message-ID: <A24693684029E5489D1D202277BE89441191E33A@dlee02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 3/15] OMAP3 camera driver: V4L2: Add 10-bit RAW Bayer format
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

From: Sergio Aguirre <saaguirre@ti.com>
Subject: OMAP: CAMERA: Add 10-bit RAW Bayer format

Adding 10-bit RAW Bayer format, and also compressed to 8 bits version.

Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
---
 include/linux/videodev2.h |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-omap-2.6/include/linux/videodev2.h
===================================================================
--- linux-omap-2.6.orig/include/linux/videodev2.h	2008-08-22 09:56:56.000000000 -0500
+++ linux-omap-2.6/include/linux/videodev2.h	2008-08-22 09:59:09.000000000 -0500
@@ -315,6 +315,8 @@
 /* see http://www.siliconimaging.com/RGB%20Bayer.htm */
 #define V4L2_PIX_FMT_SBGGR8  v4l2_fourcc('B', 'A', '8', '1') /*  8  BGBG.. GRGR.. */
 #define V4L2_PIX_FMT_SGBRG8  v4l2_fourcc('G', 'B', 'R', 'G') /*  8  GBGB.. RGRG.. */
+#define V4L2_PIX_FMT_SGRBG10 v4l2_fourcc('B', 'A', '1', '0') /* 10bit raw bayer  */
+#define V4L2_PIX_FMT_SGRBG10DPCM8 v4l2_fourcc('B', 'D', '1', '0') /* 10bit raw bayer DPCM compressed to 8 bits */
 #define V4L2_PIX_FMT_SBGGR16 v4l2_fourcc('B', 'Y', 'R', '2') /* 16  BGBG.. GRGR.. */
 
 /* compressed formats */

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
