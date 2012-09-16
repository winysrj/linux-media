Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:50076 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908Ab2IPQAm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Sep 2012 12:00:42 -0400
Received: by mail-wi0-f172.google.com with SMTP id hi8so1638679wib.1
        for <linux-media@vger.kernel.org>; Sun, 16 Sep 2012 09:00:41 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: hdegoede@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 4/4] gspca_pac7302: add support for green balance adjustment
Date: Sun, 16 Sep 2012 18:00:40 +0200
Message-Id: <1347811240-4000-4-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1347811240-4000-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1347811240-4000-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/gspca/pac7302.c |   23 ++++++++++++++++++++++-
 1 files changed, 22 insertions(+), 1 deletions(-)

diff --git a/drivers/media/usb/gspca/pac7302.c b/drivers/media/usb/gspca/pac7302.c
index 8a0f4d6..9b62b74 100644
--- a/drivers/media/usb/gspca/pac7302.c
+++ b/drivers/media/usb/gspca/pac7302.c
@@ -78,6 +78,7 @@
  * Page | Register   | Function
  * -----+------------+---------------------------------------------------
  *  0   | 0x01       | setredbalance()
+ *  0   | 0x02       | setgreenbalance()
  *  0   | 0x03       | setbluebalance()
  *  0   | 0x0f..0x20 | setcolors()
  *  0   | 0xa2..0xab | setbrightcont()
@@ -121,6 +122,7 @@ struct sd {
 	struct v4l2_ctrl *saturation;
 	struct v4l2_ctrl *white_balance;
 	struct v4l2_ctrl *red_balance;
+	struct v4l2_ctrl *green_balance;
 	struct v4l2_ctrl *blue_balance;
 	struct { /* flip cluster */
 		struct v4l2_ctrl *hflip;
@@ -470,6 +472,17 @@ static void setredbalance(struct gspca_dev *gspca_dev)
 	reg_w(gspca_dev, 0xdc, 0x01);
 }
 
+static void setgreenbalance(struct gspca_dev *gspca_dev)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	reg_w(gspca_dev, 0xff, 0x00);			/* page 0 */
+	reg_w(gspca_dev, 0x02,
+	      rgbbalance_ctrl_to_reg_value(sd->green_balance->val));
+
+	reg_w(gspca_dev, 0xdc, 0x01);
+}
+
 static void setbluebalance(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
@@ -620,6 +633,9 @@ static int sd_s_ctrl(struct v4l2_ctrl *ctrl)
 	case V4L2_CID_RED_BALANCE:
 		setredbalance(gspca_dev);
 		break;
+	case V4L2_CID_GREEN_BALANCE:
+		setgreenbalance(gspca_dev);
+		break;
 	case V4L2_CID_BLUE_BALANCE:
 		setbluebalance(gspca_dev);
 		break;
@@ -652,7 +668,7 @@ static int sd_init_controls(struct gspca_dev *gspca_dev)
 	struct v4l2_ctrl_handler *hdl = &gspca_dev->ctrl_handler;
 
 	gspca_dev->vdev.ctrl_handler = hdl;
-	v4l2_ctrl_handler_init(hdl, 12);
+	v4l2_ctrl_handler_init(hdl, 13);
 
 	sd->brightness = v4l2_ctrl_new_std(hdl, &sd_ctrl_ops,
 					V4L2_CID_BRIGHTNESS, 0, 32, 1, 16);
@@ -669,6 +685,11 @@ static int sd_init_controls(struct gspca_dev *gspca_dev)
 					PAC7302_RGB_BALANCE_MIN,
 					PAC7302_RGB_BALANCE_MAX,
 					1, PAC7302_RGB_BALANCE_DEFAULT);
+	sd->green_balance = v4l2_ctrl_new_std(hdl, &sd_ctrl_ops,
+					V4L2_CID_GREEN_BALANCE,
+					PAC7302_RGB_BALANCE_MIN,
+					PAC7302_RGB_BALANCE_MAX,
+					1, PAC7302_RGB_BALANCE_DEFAULT);
 	sd->blue_balance = v4l2_ctrl_new_std(hdl, &sd_ctrl_ops,
 					V4L2_CID_BLUE_BALANCE,
 					PAC7302_RGB_BALANCE_MIN,
-- 
1.7.7

