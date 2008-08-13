Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7DCt56Z006961
	for <video4linux-list@redhat.com>; Wed, 13 Aug 2008 08:55:05 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m7DCsfcQ002352
	for <video4linux-list@redhat.com>; Wed, 13 Aug 2008 08:54:41 -0400
Received: from lyakh (helo=localhost)
	by axis700.grange with local-esmtp (Exim 4.63)
	(envelope-from <g.liakhovetski@gmx.de>) id 1KTFsM-0001W3-KJ
	for video4linux-list@redhat.com; Wed, 13 Aug 2008 14:54:54 +0200
Date: Wed, 13 Aug 2008 14:54:54 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: video4linux-list@redhat.com
Message-ID: <Pine.LNX.4.64.0808131453300.5389@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Subject: [PATCH] mt9m001, mt9v022: Simplify return code checking
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

i2c_smbus_write_word_data() returns 0 or a negative error, hence no need to
check for "> 0".

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

I'm going to pull this through my hg-tree. Here for reference / review.

 drivers/media/video/mt9m001.c |   24 ++++++++++++------------
 drivers/media/video/mt9v022.c |   28 ++++++++++++++--------------
 2 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/drivers/media/video/mt9m001.c b/drivers/media/video/mt9m001.c
index 554d229..3531f93 100644
--- a/drivers/media/video/mt9m001.c
+++ b/drivers/media/video/mt9m001.c
@@ -119,16 +119,16 @@ static int mt9m001_init(struct soc_camera_device *icd)
 {
 	int ret;
 
-	/* Disable chip, synchronous option update */
 	dev_dbg(icd->vdev->parent, "%s\n", __func__);
 
 	ret = reg_write(icd, MT9M001_RESET, 1);
-	if (ret >= 0)
+	if (!ret)
 		ret = reg_write(icd, MT9M001_RESET, 0);
-	if (ret >= 0)
+	/* Disable chip, synchronous option update */
+	if (!ret)
 		ret = reg_write(icd, MT9M001_OUTPUT_CONTROL, 0);
 
-	return ret >= 0 ? 0 : -EIO;
+	return ret;
 }
 
 static int mt9m001_release(struct soc_camera_device *icd)
@@ -267,24 +267,24 @@ static int mt9m001_set_fmt_cap(struct soc_camera_device *icd,
 
 	/* Blanking and start values - default... */
 	ret = reg_write(icd, MT9M001_HORIZONTAL_BLANKING, hblank);
-	if (ret >= 0)
+	if (!ret)
 		ret = reg_write(icd, MT9M001_VERTICAL_BLANKING, vblank);
 
 	/* The caller provides a supported format, as verified per
 	 * call to icd->try_fmt_cap() */
-	if (ret >= 0)
+	if (!ret)
 		ret = reg_write(icd, MT9M001_COLUMN_START, rect->left);
-	if (ret >= 0)
+	if (!ret)
 		ret = reg_write(icd, MT9M001_ROW_START, rect->top);
-	if (ret >= 0)
+	if (!ret)
 		ret = reg_write(icd, MT9M001_WINDOW_WIDTH, rect->width - 1);
-	if (ret >= 0)
+	if (!ret)
 		ret = reg_write(icd, MT9M001_WINDOW_HEIGHT,
 				rect->height + icd->y_skip_top - 1);
-	if (ret >= 0 && mt9m001->autoexposure) {
+	if (!ret && mt9m001->autoexposure) {
 		ret = reg_write(icd, MT9M001_SHUTTER_WIDTH,
 				rect->height + icd->y_skip_top + vblank);
-		if (ret >= 0) {
+		if (!ret) {
 			const struct v4l2_queryctrl *qctrl =
 				soc_camera_find_qctrl(icd->ops,
 						      V4L2_CID_EXPOSURE);
@@ -295,7 +295,7 @@ static int mt9m001_set_fmt_cap(struct soc_camera_device *icd,
 		}
 	}
 
-	return ret < 0 ? ret : 0;
+	return ret;
 }
 
 static int mt9m001_try_fmt_cap(struct soc_camera_device *icd,
diff --git a/drivers/media/video/mt9v022.c b/drivers/media/video/mt9v022.c
index 56808cd..0f4b204 100644
--- a/drivers/media/video/mt9v022.c
+++ b/drivers/media/video/mt9v022.c
@@ -141,22 +141,22 @@ static int mt9v022_init(struct soc_camera_device *icd)
 	 * plus snapshot mode to disable scan for now */
 	mt9v022->chip_control |= 0x10;
 	ret = reg_write(icd, MT9V022_CHIP_CONTROL, mt9v022->chip_control);
-	if (ret >= 0)
-		reg_write(icd, MT9V022_READ_MODE, 0x300);
+	if (!ret)
+		ret = reg_write(icd, MT9V022_READ_MODE, 0x300);
 
 	/* All defaults */
-	if (ret >= 0)
+	if (!ret)
 		/* AEC, AGC on */
 		ret = reg_set(icd, MT9V022_AEC_AGC_ENABLE, 0x3);
-	if (ret >= 0)
+	if (!ret)
 		ret = reg_write(icd, MT9V022_MAX_TOTAL_SHUTTER_WIDTH, 480);
-	if (ret >= 0)
+	if (!ret)
 		/* default - auto */
 		ret = reg_clear(icd, MT9V022_BLACK_LEVEL_CALIB_CTRL, 1);
-	if (ret >= 0)
+	if (!ret)
 		ret = reg_write(icd, MT9V022_DIGITAL_TEST_PATTERN, 0);
 
-	return ret >= 0 ? 0 : -EIO;
+	return ret;
 }
 
 static int mt9v022_release(struct soc_camera_device *icd)
@@ -352,21 +352,21 @@ static int mt9v022_set_fmt_cap(struct soc_camera_device *icd,
 					rect->height + icd->y_skip_top + 43);
 	}
 	/* Setup frame format: defaults apart from width and height */
-	if (ret >= 0)
+	if (!ret)
 		ret = reg_write(icd, MT9V022_COLUMN_START, rect->left);
-	if (ret >= 0)
+	if (!ret)
 		ret = reg_write(icd, MT9V022_ROW_START, rect->top);
-	if (ret >= 0)
+	if (!ret)
 		/* Default 94, Phytec driver says:
 		 * "width + horizontal blank >= 660" */
 		ret = reg_write(icd, MT9V022_HORIZONTAL_BLANKING,
 				rect->width > 660 - 43 ? 43 :
 				660 - rect->width);
-	if (ret >= 0)
+	if (!ret)
 		ret = reg_write(icd, MT9V022_VERTICAL_BLANKING, 45);
-	if (ret >= 0)
+	if (!ret)
 		ret = reg_write(icd, MT9V022_WINDOW_WIDTH, rect->width);
-	if (ret >= 0)
+	if (!ret)
 		ret = reg_write(icd, MT9V022_WINDOW_HEIGHT,
 				rect->height + icd->y_skip_top);
 
@@ -717,7 +717,7 @@ static int mt9v022_video_probe(struct soc_camera_device *icd)
 			icd->num_formats = 1;
 	}
 
-	if (ret >= 0)
+	if (!ret)
 		ret = soc_camera_video_start(icd);
 	if (ret < 0)
 		goto eisis;
-- 
1.5.4

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
