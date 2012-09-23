Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:64663 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964Ab2IWN3g (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Sep 2012 09:29:36 -0400
Received: by weyx8 with SMTP id x8so2868102wey.19
        for <linux-media@vger.kernel.org>; Sun, 23 Sep 2012 06:29:35 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: hdegoede@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 2/4] gspca_pac7302: use registers 0x01 and 0x03 for red and blue balance controls
Date: Sun, 23 Sep 2012 15:29:43 +0200
Message-Id: <1348406983-3451-2-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1348406983-3451-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1348406983-3451-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently used registers 0xc5 and 0xc7 provide only a very coarse
adjustment possibility within a very small value range (0-3).
With registers 0x01 and 0x03, a fine grained adjustment with
255 steps is possible. This is also what the Windows driver does.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/gspca/pac7302.c |   51 +++++++++++++++++++++++++++++--------
 1 files changed, 40 insertions(+), 11 deletions(-)

diff --git a/drivers/media/usb/gspca/pac7302.c b/drivers/media/usb/gspca/pac7302.c
index 4894ac1..8a0f4d6 100644
--- a/drivers/media/usb/gspca/pac7302.c
+++ b/drivers/media/usb/gspca/pac7302.c
@@ -77,12 +77,12 @@
  *
  * Page | Register   | Function
  * -----+------------+---------------------------------------------------
+ *  0   | 0x01       | setredbalance()
+ *  0   | 0x03       | setbluebalance()
  *  0   | 0x0f..0x20 | setcolors()
  *  0   | 0xa2..0xab | setbrightcont()
  *  0   | 0xb6       | setsharpness()
- *  0   | 0xc5       | setredbalance()
  *  0   | 0xc6       | setwhitebalance()
- *  0   | 0xc7       | setbluebalance()
  *  0   | 0xdc       | setbrightcont(), setcolors()
  *  3   | 0x02       | setexposure()
  *  3   | 0x10, 0x12 | setgain()
@@ -98,10 +98,13 @@
 /* Include pac common sof detection functions */
 #include "pac_common.h"
 
-#define PAC7302_GAIN_DEFAULT      15
-#define PAC7302_GAIN_KNEE         42
-#define PAC7302_EXPOSURE_DEFAULT  66 /* 33 ms / 30 fps */
-#define PAC7302_EXPOSURE_KNEE    133 /* 66 ms / 15 fps */
+#define PAC7302_RGB_BALANCE_MIN		  0
+#define PAC7302_RGB_BALANCE_MAX		200
+#define PAC7302_RGB_BALANCE_DEFAULT	100
+#define PAC7302_GAIN_DEFAULT		 15
+#define PAC7302_GAIN_KNEE 		 42
+#define PAC7302_EXPOSURE_DEFAULT	 66 /* 33 ms / 30 fps */
+#define PAC7302_EXPOSURE_KNEE		133 /* 66 ms / 15 fps */
 
 MODULE_AUTHOR("Jean-Francois Moine <http://moinejf.free.fr>, "
 		"Thomas Kaiser thomas@kaiser-linux.li");
@@ -438,12 +441,31 @@ static void setwhitebalance(struct gspca_dev *gspca_dev)
 	reg_w(gspca_dev, 0xdc, 0x01);
 }
 
+static u8 rgbbalance_ctrl_to_reg_value(s32 rgb_ctrl_val)
+{
+	const unsigned int k = 1000;	/* precision factor */
+	unsigned int norm;
+
+	/* Normed value [0...k] */
+	norm = k * (rgb_ctrl_val - PAC7302_RGB_BALANCE_MIN)
+		    / (PAC7302_RGB_BALANCE_MAX - PAC7302_RGB_BALANCE_MIN);
+	/* Qudratic apporach improves control at small (register) values: */
+	return 64 * norm * norm / (k*k)  +  32 * norm / k  +  32;
+	/* Y = 64*X*X + 32*X + 32
+	 * => register values 0x20-0x80; Windows driver uses these limits */
+
+	/* NOTE: for full value range (0x00-0xff) use
+	 *         Y = 254*X*X + X
+	 *         => 254 * norm * norm / (k*k)  +  1 * norm / k	*/
+}
+
 static void setredbalance(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 
-	reg_w(gspca_dev, 0xff, 0x00);		/* page 0 */
-	reg_w(gspca_dev, 0xc5, sd->red_balance->val);
+	reg_w(gspca_dev, 0xff, 0x00);			/* page 0 */
+	reg_w(gspca_dev, 0x01,
+	      rgbbalance_ctrl_to_reg_value(sd->red_balance->val));
 
 	reg_w(gspca_dev, 0xdc, 0x01);
 }
@@ -453,7 +475,8 @@ static void setbluebalance(struct gspca_dev *gspca_dev)
 	struct sd *sd = (struct sd *) gspca_dev;
 
 	reg_w(gspca_dev, 0xff, 0x00);			/* page 0 */
-	reg_w(gspca_dev, 0xc7, sd->blue_balance->val);
+	reg_w(gspca_dev, 0x03,
+	      rgbbalance_ctrl_to_reg_value(sd->blue_balance->val));
 
 	reg_w(gspca_dev, 0xdc, 0x01);
 }
@@ -642,9 +665,15 @@ static int sd_init_controls(struct gspca_dev *gspca_dev)
 					V4L2_CID_WHITE_BALANCE_TEMPERATURE,
 					0, 255, 1, 55);
 	sd->red_balance = v4l2_ctrl_new_std(hdl, &sd_ctrl_ops,
-					V4L2_CID_RED_BALANCE, 0, 3, 1, 1);
+					V4L2_CID_RED_BALANCE,
+					PAC7302_RGB_BALANCE_MIN,
+					PAC7302_RGB_BALANCE_MAX,
+					1, PAC7302_RGB_BALANCE_DEFAULT);
 	sd->blue_balance = v4l2_ctrl_new_std(hdl, &sd_ctrl_ops,
-					V4L2_CID_BLUE_BALANCE, 0, 3, 1, 1);
+					V4L2_CID_BLUE_BALANCE,
+					PAC7302_RGB_BALANCE_MIN,
+					PAC7302_RGB_BALANCE_MAX,
+					1, PAC7302_RGB_BALANCE_DEFAULT);
 
 	gspca_dev->autogain = v4l2_ctrl_new_std(hdl, &sd_ctrl_ops,
 					V4L2_CID_AUTOGAIN, 0, 1, 1, 1);
-- 
1.7.7

