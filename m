Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBHIlHsO025378
	for <video4linux-list@redhat.com>; Wed, 17 Dec 2008 13:47:17 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mBHIjTN0014199
	for <video4linux-list@redhat.com>; Wed, 17 Dec 2008 13:45:30 -0500
Received: from lyakh (helo=localhost)
	by axis700.grange with local-esmtp (Exim 4.63)
	(envelope-from <g.liakhovetski@gmx.de>) id 1LD1Or-0002MB-3B
	for video4linux-list@redhat.com; Wed, 17 Dec 2008 19:45:37 +0100
Date: Wed, 17 Dec 2008 19:45:37 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: video4linux-list@redhat.com
Message-ID: <Pine.LNX.4.64.0812171938460.8733@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Subject: [PATCH 3/4] soc-camera: add new bus width and signal polarity flags
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

In preparation for i.MX31 camera host driver add flags for 4 and 15 bit bus
widths and for data lines polarity inversion.

Signed-off-by: Guennadi Liakhovetski <lg@denx.de>
---

Careful, soc_camera_bus_param_compatible() is more selective with this 
patch, some configurations might break.

 include/media/soc_camera.h |   29 ++++++++++++++++++-----------
 1 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index 0ca446a..b6f4d0f 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -219,28 +219,35 @@ static inline struct v4l2_queryctrl const *soc_camera_find_qctrl(
 #define SOCAM_HSYNC_ACTIVE_LOW		(1 << 3)
 #define SOCAM_VSYNC_ACTIVE_HIGH		(1 << 4)
 #define SOCAM_VSYNC_ACTIVE_LOW		(1 << 5)
-#define SOCAM_DATAWIDTH_8		(1 << 6)
-#define SOCAM_DATAWIDTH_9		(1 << 7)
-#define SOCAM_DATAWIDTH_10		(1 << 8)
-#define SOCAM_DATAWIDTH_16		(1 << 9)
-#define SOCAM_PCLK_SAMPLE_RISING	(1 << 10)
-#define SOCAM_PCLK_SAMPLE_FALLING	(1 << 11)
-
-#define SOCAM_DATAWIDTH_MASK (SOCAM_DATAWIDTH_8 | SOCAM_DATAWIDTH_9 | \
-			      SOCAM_DATAWIDTH_10 | SOCAM_DATAWIDTH_16)
+#define SOCAM_DATAWIDTH_4		(1 << 6)
+#define SOCAM_DATAWIDTH_8		(1 << 7)
+#define SOCAM_DATAWIDTH_9		(1 << 8)
+#define SOCAM_DATAWIDTH_10		(1 << 9)
+#define SOCAM_DATAWIDTH_15		(1 << 10)
+#define SOCAM_DATAWIDTH_16		(1 << 11)
+#define SOCAM_PCLK_SAMPLE_RISING	(1 << 12)
+#define SOCAM_PCLK_SAMPLE_FALLING	(1 << 13)
+#define SOCAM_DATA_ACTIVE_HIGH		(1 << 14)
+#define SOCAM_DATA_ACTIVE_LOW		(1 << 15)
+
+#define SOCAM_DATAWIDTH_MASK (SOCAM_DATAWIDTH_4 | SOCAM_DATAWIDTH_8 | \
+			      SOCAM_DATAWIDTH_9 | SOCAM_DATAWIDTH_10 | \
+			      SOCAM_DATAWIDTH_15 | SOCAM_DATAWIDTH_16)
 
 static inline unsigned long soc_camera_bus_param_compatible(
 			unsigned long camera_flags, unsigned long bus_flags)
 {
-	unsigned long common_flags, hsync, vsync, pclk;
+	unsigned long common_flags, hsync, vsync, pclk, data, buswidth;
 
 	common_flags = camera_flags & bus_flags;
 
 	hsync = common_flags & (SOCAM_HSYNC_ACTIVE_HIGH | SOCAM_HSYNC_ACTIVE_LOW);
 	vsync = common_flags & (SOCAM_VSYNC_ACTIVE_HIGH | SOCAM_VSYNC_ACTIVE_LOW);
 	pclk = common_flags & (SOCAM_PCLK_SAMPLE_RISING | SOCAM_PCLK_SAMPLE_FALLING);
+	data = common_flags & (SOCAM_DATA_ACTIVE_HIGH | SOCAM_DATA_ACTIVE_LOW);
+	buswidth = common_flags & SOCAM_DATAWIDTH_MASK;
 
-	return (!hsync || !vsync || !pclk) ? 0 : common_flags;
+	return (!hsync || !vsync || !pclk || !data || !buswidth) ? 0 : common_flags;
 }
 
 /**
-- 
1.5.4

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
