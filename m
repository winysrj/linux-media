Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:41804 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965474AbcA1JDQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jan 2016 04:03:16 -0500
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>,
	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Subject: [PATCH 5/12] TW686x: Fix handling of TV standard values
References: <m337tif6om.fsf@t19.piap.pl>
Date: Thu, 28 Jan 2016 10:03:15 +0100
In-Reply-To: <m337tif6om.fsf@t19.piap.pl> ("Krzysztof \=\?utf-8\?Q\?Ha\=C5\=82as\?\=
 \=\?utf-8\?Q\?a\=22's\?\= message of
	"Thu, 28 Jan 2016 09:29:29 +0100")
Message-ID: <m3d1smdqjw.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Krzysztof Hałasa <khalasa@piap.pl>

diff --git a/drivers/media/pci/tw686x/tw686x-video.c b/drivers/media/pci/tw686x/tw686x-video.c
index 78f4f55..c5d8f28 100644
--- a/drivers/media/pci/tw686x/tw686x-video.c
+++ b/drivers/media/pci/tw686x/tw686x-video.c
@@ -417,18 +417,14 @@ static int tw686x_querycap(struct file *file, void *priv,
 static int tw686x_s_std(struct file *file, void *priv, v4l2_std_id id)
 {
 	struct tw686x_video_channel *vc = video_drvdata(file);
-	unsigned std, count = 0;
-	u32 sdt, std_mask = 0;
-
-	for (std = 0; std > ARRAY_SIZE(video_standards); std++)
-		if (id & video_standards[std]) {
-			sdt = std;
-			std_mask |= 1 << std;
-			count++;
-		}
+	unsigned cnt;
+	u32 sdt = 0; /* default */
 
-	if (count != 1)
-		return -EINVAL; /* must request exactly one standard */
+	for (cnt = 0; cnt < ARRAY_SIZE(video_standards); cnt++)
+		if (id & video_standards[cnt]) {
+			sdt = cnt;
+			break;
+		}
 
 	reg_write(vc->dev, SDT[vc->ch], sdt);
 	vc->video_standard = video_standards[sdt];
@@ -658,12 +654,13 @@ int tw686x_video_init(struct tw686x_dev *dev)
 		vc->dev = dev;
 		vc->ch = ch;
 
-		/* default settings */
+		/* default settings: NTSC */
 		vc->format = &formats[0];
-		vc->video_standard = V4L2_STD_PAL;
-		vc->field = V4L2_FIELD_SEQ_TB;
+		vc->video_standard = V4L2_STD_NTSC;
+		reg_write(vc->dev, SDT[vc->ch], 0);
+		vc->field = V4L2_FIELD_SEQ_BT;
 		vc->width = 704;
-		vc->height = 576;
+		vc->height = 480;
 
 		for (n = 0; n < 2; n++) {
 			void *cpu;
@@ -733,8 +730,7 @@ int tw686x_video_init(struct tw686x_dev *dev)
 		vdev->release = video_device_release;
 		vdev->v4l2_dev = &dev->v4l2_dev;
 		vdev->queue = &vc->vidq;
-		vdev->tvnorms = V4L2_STD_PAL | V4L2_STD_NTSC | V4L2_STD_SECAM |
-			V4L2_STD_PAL_60;
+		vdev->tvnorms = V4L2_STD_ALL;
 		vdev->minor = -1;
 		vdev->lock = &vc->vb_mutex;
 
