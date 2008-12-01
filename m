Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB1LOYZX025846
	for <video4linux-list@redhat.com>; Mon, 1 Dec 2008 16:24:36 -0500
Received: from smtp2-g19.free.fr (smtp2-g19.free.fr [212.27.42.28])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB1LG1I6017939
	for <video4linux-list@redhat.com>; Mon, 1 Dec 2008 16:16:38 -0500
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: g.liakhovetski@gmx.de
Date: Mon,  1 Dec 2008 22:15:58 +0100
Message-Id: <1228166159-18164-1-git-send-email-robert.jarzmik@free.fr>
Cc: video4linux-list@redhat.com
Subject: [PATCH] mt9m111: Add automatic white balance control
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

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 drivers/media/video/mt9m111.c |   28 +++++++++++++++++++++++++++-
 1 files changed, 27 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
index 9b9b377..208ec6c 100644
--- a/drivers/media/video/mt9m111.c
+++ b/drivers/media/video/mt9m111.c
@@ -90,7 +90,7 @@
 #define MT9M111_OUTPUT_FORMAT_CTRL2_B	0x19b
 
 #define MT9M111_OPMODE_AUTOEXPO_EN	(1 << 14)
-
+#define MT9M111_OPMODE_AUTOWHITEBAL_EN	(1 << 1)
 
 #define MT9M111_OUTFMT_PROCESSED_BAYER	(1 << 14)
 #define MT9M111_OUTFMT_BYPASS_IFP	(1 << 10)
@@ -163,6 +163,7 @@ struct mt9m111 {
 	unsigned int swap_rgb_red_blue:1;
 	unsigned int swap_yuv_y_chromas:1;
 	unsigned int swap_yuv_cb_cr:1;
+	unsigned int autowhitebalance:1;
 };
 
 static int reg_page_map_set(struct i2c_client *client, const u16 reg)
@@ -701,6 +702,23 @@ static int mt9m111_set_autoexposure(struct soc_camera_device *icd, int on)
 
 	return ret;
 }
+
+static int mt9m111_set_autowhitebalance(struct soc_camera_device *icd, int on)
+{
+	struct mt9m111 *mt9m111 = container_of(icd, struct mt9m111, icd);
+	int ret;
+
+	if (on)
+		ret = reg_set(OPER_MODE_CTRL, MT9M111_OPMODE_AUTOWHITEBAL_EN);
+	else
+		ret = reg_clear(OPER_MODE_CTRL, MT9M111_OPMODE_AUTOWHITEBAL_EN);
+
+	if (!ret)
+		mt9m111->autowhitebalance = on;
+
+	return ret;
+}
+
 static int mt9m111_get_control(struct soc_camera_device *icd,
 			       struct v4l2_control *ctrl)
 {
@@ -737,6 +755,9 @@ static int mt9m111_get_control(struct soc_camera_device *icd,
 	case V4L2_CID_EXPOSURE_AUTO:
 		ctrl->value = mt9m111->autoexposure;
 		break;
+	case V4L2_CID_AUTO_WHITE_BALANCE:
+		ctrl->value = mt9m111->autowhitebalance;
+		break;
 	}
 	return 0;
 }
@@ -770,6 +791,9 @@ static int mt9m111_set_control(struct soc_camera_device *icd,
 	case V4L2_CID_EXPOSURE_AUTO:
 		ret =  mt9m111_set_autoexposure(icd, ctrl->value);
 		break;
+	case V4L2_CID_AUTO_WHITE_BALANCE:
+		ret =  mt9m111_set_autowhitebalance(icd, ctrl->value);
+		break;
 	default:
 		ret = -EINVAL;
 	}
@@ -788,6 +812,7 @@ static int mt9m111_restore_state(struct soc_camera_device *icd)
 	mt9m111_set_flip(icd, mt9m111->vflip, MT9M111_RMB_MIRROR_ROWS);
 	mt9m111_set_global_gain(icd, icd->gain);
 	mt9m111_set_autoexposure(icd, mt9m111->autoexposure);
+	mt9m111_set_autowhitebalance(icd, mt9m111->autowhitebalance);
 	return 0;
 }
 
@@ -882,6 +907,7 @@ static int mt9m111_video_probe(struct soc_camera_device *icd)
 		goto eisis;
 
 	mt9m111->autoexposure = 1;
+	mt9m111->autowhitebalance = 1;
 
 	mt9m111->swap_rgb_even_odd = 1;
 	mt9m111->swap_rgb_red_blue = 1;
-- 
1.5.6.5

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
