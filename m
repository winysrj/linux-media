Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp205.alice.it ([82.57.200.101]:36370 "EHLO smtp205.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751514Ab2EPVmy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 16 May 2012 17:42:54 -0400
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Antonio Ospite <ospite@studenti.unina.it>,
	Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Jean-Francois Moine <moinejf@free.fr>
Subject: [PATCH 2/3] gspca_ov534: make AGC and AWB controls independent
Date: Wed, 16 May 2012 23:42:45 +0200
Message-Id: <1337204566-2212-3-git-send-email-ospite@studenti.unina.it>
In-Reply-To: <1337204566-2212-1-git-send-email-ospite@studenti.unina.it>
References: <1337204566-2212-1-git-send-email-ospite@studenti.unina.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Even if the best results are indeed achieved with both AGC and AWB
enabled, the webcam is capable of setting these independently, and the
user can see the difference of any of the 4 combinations of these two
boolean controls.

Removing the dependency from one another simplifies the code and gives
more control to the user.

Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
---
 drivers/media/video/gspca/ov534.c |   31 ++-----------------------------
 1 file changed, 2 insertions(+), 29 deletions(-)

diff --git a/drivers/media/video/gspca/ov534.c b/drivers/media/video/gspca/ov534.c
index b5acb1e..c16bd1b 100644
--- a/drivers/media/video/gspca/ov534.c
+++ b/drivers/media/video/gspca/ov534.c
@@ -96,7 +96,7 @@ static void setbrightness(struct gspca_dev *gspca_dev);
 static void setcontrast(struct gspca_dev *gspca_dev);
 static void setgain(struct gspca_dev *gspca_dev);
 static void setexposure(struct gspca_dev *gspca_dev);
-static int sd_setagc(struct gspca_dev *gspca_dev, __s32 val);
+static void setagc(struct gspca_dev *gspca_dev);
 static void setawb(struct gspca_dev *gspca_dev);
 static void setaec(struct gspca_dev *gspca_dev);
 static void setsharpness(struct gspca_dev *gspca_dev);
@@ -189,7 +189,7 @@ static const struct ctrl sd_ctrls[] = {
 			.step    = 1,
 			.default_value = 1,
 		},
-		.set = sd_setagc
+		.set_control = setagc
 	},
 [AWB] = {
 		{
@@ -1242,10 +1242,6 @@ static int sd_config(struct gspca_dev *gspca_dev,
 
 	cam->ctrls = sd->ctrls;
 
-	/* the auto white balance control works only when auto gain is set */
-	if (sd_ctrls[AGC].qctrl.default_value == 0)
-		gspca_dev->ctrl_inac |= (1 << AWB);
-
 	cam->cam_mode = ov772x_mode;
 	cam->nmodes = ARRAY_SIZE(ov772x_mode);
 
@@ -1486,29 +1482,6 @@ scan_next:
 	} while (remaining_len > 0);
 }
 
-static int sd_setagc(struct gspca_dev *gspca_dev, __s32 val)
-{
-	struct sd *sd = (struct sd *) gspca_dev;
-
-	sd->ctrls[AGC].val = val;
-
-	/* the auto white balance control works only
-	 * when auto gain is set */
-	if (val) {
-		gspca_dev->ctrl_inac &= ~(1 << AWB);
-	} else {
-		gspca_dev->ctrl_inac |= (1 << AWB);
-		if (sd->ctrls[AWB].val) {
-			sd->ctrls[AWB].val = 0;
-			if (gspca_dev->streaming)
-				setawb(gspca_dev);
-		}
-	}
-	if (gspca_dev->streaming)
-		setagc(gspca_dev);
-	return gspca_dev->usb_err;
-}
-
 static int sd_querymenu(struct gspca_dev *gspca_dev,
 		struct v4l2_querymenu *menu)
 {
-- 
1.7.10

