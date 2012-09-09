Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:42428 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754217Ab2IISBp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 Sep 2012 14:01:45 -0400
Received: by mail-ee0-f46.google.com with SMTP id c1so640416eek.19
        for <linux-media@vger.kernel.org>; Sun, 09 Sep 2012 11:01:45 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: hdegoede@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 3/6] gspca_pac7302: add sharpness control
Date: Sun,  9 Sep 2012 20:02:21 +0200
Message-Id: <1347213744-8509-3-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1347213744-8509-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1347213744-8509-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Windows driver uses page 0 register 0xb6 for sharpness adjustment.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/gspca/pac7302.c |   25 ++++++++++++++++++++++++-
 1 files changed, 24 insertions(+), 1 deletions(-)

diff --git a/drivers/media/usb/gspca/pac7302.c b/drivers/media/usb/gspca/pac7302.c
index eb3c90e4..8c29613 100644
--- a/drivers/media/usb/gspca/pac7302.c
+++ b/drivers/media/usb/gspca/pac7302.c
@@ -26,6 +26,11 @@
 /*
  * Some documentation about various registers as determined by trial and error.
  *
+ * Register page 0:
+ *
+ * Address	Description
+ * 0xb6		Sharpness control (bits 0-4)
+ *
  * Register page 1:
  *
  * Address	Description
@@ -66,6 +71,7 @@
  * -----+------------+---------------------------------------------------
  *  0   | 0x0f..0x20 | setcolors()
  *  0   | 0xa2..0xab | setbrightcont()
+ *  0   | 0xb6       | setsharpness()
  *  0   | 0xc5       | setredbalance()
  *  0   | 0xc6       | setwhitebalance()
  *  0   | 0xc7       | setbluebalance()
@@ -109,6 +115,7 @@ struct sd {
 		struct v4l2_ctrl *hflip;
 		struct v4l2_ctrl *vflip;
 	};
+	struct v4l2_ctrl *sharpness;
 	u8 flags;
 #define FL_HFLIP 0x01		/* mirrored by default */
 #define FL_VFLIP 0x02		/* vertical flipped by default */
@@ -531,6 +538,16 @@ static void sethvflip(struct gspca_dev *gspca_dev)
 	reg_w(gspca_dev, 0x11, 0x01);
 }
 
+static void setsharpness(struct gspca_dev *gspca_dev)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	reg_w(gspca_dev, 0xff, 0x00);		/* page 0 */
+	reg_w(gspca_dev, 0xb6, sd->sharpness->val);
+
+	reg_w(gspca_dev, 0xdc, 0x01);
+}
+
 /* this function is called at probe and resume time for pac7302 */
 static int sd_init(struct gspca_dev *gspca_dev)
 {
@@ -584,6 +601,9 @@ static int sd_s_ctrl(struct v4l2_ctrl *ctrl)
 	case V4L2_CID_HFLIP:
 		sethvflip(gspca_dev);
 		break;
+	case V4L2_CID_SHARPNESS:
+		setsharpness(gspca_dev);
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -601,7 +621,7 @@ static int sd_init_controls(struct gspca_dev *gspca_dev)
 	struct v4l2_ctrl_handler *hdl = &gspca_dev->ctrl_handler;
 
 	gspca_dev->vdev.ctrl_handler = hdl;
-	v4l2_ctrl_handler_init(hdl, 11);
+	v4l2_ctrl_handler_init(hdl, 12);
 
 	sd->brightness = v4l2_ctrl_new_std(hdl, &sd_ctrl_ops,
 					V4L2_CID_BRIGHTNESS, 0, 32, 1, 16);
@@ -632,6 +652,9 @@ static int sd_init_controls(struct gspca_dev *gspca_dev)
 	sd->vflip = v4l2_ctrl_new_std(hdl, &sd_ctrl_ops,
 		V4L2_CID_VFLIP, 0, 1, 1, 0);
 
+	sd->sharpness = v4l2_ctrl_new_std(hdl, &sd_ctrl_ops,
+					V4L2_CID_SHARPNESS, 0, 15, 1, 8);
+
 	if (hdl->error) {
 		pr_err("Could not initialize controls\n");
 		return hdl->error;
-- 
1.7.7

