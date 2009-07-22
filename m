Return-path: <linux-media-owner@vger.kernel.org>
Received: from dscas1.ad.uiuc.edu ([128.174.68.119]:4992 "EHLO
	dscas1.ad.uiuc.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756177AbZGVDIX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Jul 2009 23:08:23 -0400
From: Stoyan Gaydarov <sgayda2@uiuc.edu>
To: linux-kernel@vger.kernel.org
CC: Stoyan Gaydarov <sgayda2@uiuc.edu>, moinejf@free.fr,
	linux-media@vger.kernel.org
Subject: [PATCH 3/7] [video] ARRAY_SIZE changes
Date: Tue, 21 Jul 2009 22:02:29 -0500
Message-ID: <1248231753-8344-4-git-send-email-sgayda2@uiuc.edu>
In-Reply-To: <1248231753-8344-3-git-send-email-sgayda2@uiuc.edu>
References: <1248231753-8344-1-git-send-email-sgayda2@uiuc.edu>
 <1248231753-8344-2-git-send-email-sgayda2@uiuc.edu>
 <1248231753-8344-3-git-send-email-sgayda2@uiuc.edu>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These changes were a direct result of using a semantic patch
More information can be found at http://www.emn.fr/x-info/coccinelle/

Signed-off-by: Stoyan Gaydarov <sgayda2@uiuc.edu>
---
 drivers/media/video/gspca/conex.c   |    2 +-
 drivers/media/video/gspca/etoms.c   |    4 ++--
 drivers/media/video/gspca/spca501.c |    2 +-
 drivers/media/video/gspca/spca506.c |    2 +-
 drivers/media/video/gspca/sunplus.c |    6 +++---
 drivers/media/video/gspca/zc3xx.c   |    2 +-
 drivers/media/video/tveeprom.c      |    4 ++--
 7 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/media/video/gspca/conex.c b/drivers/media/video/gspca/conex.c
index 219cfa6..11aa91d 100644
--- a/drivers/media/video/gspca/conex.c
+++ b/drivers/media/video/gspca/conex.c
@@ -820,7 +820,7 @@ static int sd_config(struct gspca_dev *gspca_dev,
 
 	cam = &gspca_dev->cam;
 	cam->cam_mode = vga_mode;
-	cam->nmodes = sizeof vga_mode / sizeof vga_mode[0];
+	cam->nmodes = ARRAY_SIZE(vga_mode);
 
 	sd->brightness = BRIGHTNESS_DEF;
 	sd->contrast = CONTRAST_DEF;
diff --git a/drivers/media/video/gspca/etoms.c b/drivers/media/video/gspca/etoms.c
index 2c20d06..c1461e6 100644
--- a/drivers/media/video/gspca/etoms.c
+++ b/drivers/media/video/gspca/etoms.c
@@ -635,10 +635,10 @@ static int sd_config(struct gspca_dev *gspca_dev,
 	sd->sensor = id->driver_info;
 	if (sd->sensor == SENSOR_PAS106) {
 		cam->cam_mode = sif_mode;
-		cam->nmodes = sizeof sif_mode / sizeof sif_mode[0];
+		cam->nmodes = ARRAY_SIZE(sif_mode);
 	} else {
 		cam->cam_mode = vga_mode;
-		cam->nmodes = sizeof vga_mode / sizeof vga_mode[0];
+		cam->nmodes = ARRAY_SIZE(vga_mode);
 		gspca_dev->ctrl_dis = (1 << COLOR_IDX);
 	}
 	sd->brightness = BRIGHTNESS_DEF;
diff --git a/drivers/media/video/gspca/spca501.c b/drivers/media/video/gspca/spca501.c
index d48b27c..b74a342 100644
--- a/drivers/media/video/gspca/spca501.c
+++ b/drivers/media/video/gspca/spca501.c
@@ -1923,7 +1923,7 @@ static int sd_config(struct gspca_dev *gspca_dev,
 
 	cam = &gspca_dev->cam;
 	cam->cam_mode = vga_mode;
-	cam->nmodes = sizeof vga_mode / sizeof vga_mode[0];
+	cam->nmodes = ARRAY_SIZE(vga_mode);
 	sd->subtype = id->driver_info;
 	sd->brightness = sd_ctrls[MY_BRIGHTNESS].qctrl.default_value;
 	sd->contrast = sd_ctrls[MY_CONTRAST].qctrl.default_value;
diff --git a/drivers/media/video/gspca/spca506.c b/drivers/media/video/gspca/spca506.c
index 3a0c893..a199298 100644
--- a/drivers/media/video/gspca/spca506.c
+++ b/drivers/media/video/gspca/spca506.c
@@ -286,7 +286,7 @@ static int sd_config(struct gspca_dev *gspca_dev,
 
 	cam = &gspca_dev->cam;
 	cam->cam_mode = vga_mode;
-	cam->nmodes = sizeof vga_mode / sizeof vga_mode[0];
+	cam->nmodes = ARRAY_SIZE(vga_mode);
 	sd->brightness = sd_ctrls[SD_BRIGHTNESS].qctrl.default_value;
 	sd->contrast = sd_ctrls[SD_CONTRAST].qctrl.default_value;
 	sd->colors = sd_ctrls[SD_COLOR].qctrl.default_value;
diff --git a/drivers/media/video/gspca/sunplus.c b/drivers/media/video/gspca/sunplus.c
index 9623f29..6ddffdc 100644
--- a/drivers/media/video/gspca/sunplus.c
+++ b/drivers/media/video/gspca/sunplus.c
@@ -840,15 +840,15 @@ static int sd_config(struct gspca_dev *gspca_dev,
 /*	case BRIDGE_SPCA504: */
 /*	case BRIDGE_SPCA536: */
 		cam->cam_mode = vga_mode;
-		cam->nmodes = sizeof vga_mode / sizeof vga_mode[0];
+		cam->nmodes = ARRAY_SIZE(vga_mode);
 		break;
 	case BRIDGE_SPCA533:
 		cam->cam_mode = custom_mode;
-		cam->nmodes = sizeof custom_mode / sizeof custom_mode[0];
+		cam->nmodes = ARRAY_SIZE(custom_mode);
 		break;
 	case BRIDGE_SPCA504C:
 		cam->cam_mode = vga_mode2;
-		cam->nmodes = sizeof vga_mode2 / sizeof vga_mode2[0];
+		cam->nmodes = ARRAY_SIZE(vga_mode2);
 		break;
 	}
 	sd->brightness = sd_ctrls[SD_BRIGHTNESS].qctrl.default_value;
diff --git a/drivers/media/video/gspca/zc3xx.c b/drivers/media/video/gspca/zc3xx.c
index 08422d3..02043ef 100644
--- a/drivers/media/video/gspca/zc3xx.c
+++ b/drivers/media/video/gspca/zc3xx.c
@@ -7572,7 +7572,7 @@ static int sd_get_jcomp(struct gspca_dev *gspca_dev,
 static const struct sd_desc sd_desc = {
 	.name = MODULE_NAME,
 	.ctrls = sd_ctrls,
-	.nctrls = sizeof sd_ctrls / sizeof sd_ctrls[0],
+	.nctrls = ARRAY_SIZE(sd_ctrls),
 	.config = sd_config,
 	.init = sd_init,
 	.start = sd_start,
diff --git a/drivers/media/video/tveeprom.c b/drivers/media/video/tveeprom.c
index ac02808..d533ea5 100644
--- a/drivers/media/video/tveeprom.c
+++ b/drivers/media/video/tveeprom.c
@@ -646,14 +646,14 @@ void tveeprom_hauppauge_analog(struct i2c_client *c, struct tveeprom *tvee,
 		tvee->has_radio = 1;
 	}
 
-	if (tuner1 < sizeof(hauppauge_tuner)/sizeof(struct HAUPPAUGE_TUNER)) {
+	if (tuner1 < ARRAY_SIZE(hauppauge_tuner)) {
 		tvee->tuner_type = hauppauge_tuner[tuner1].id;
 		t_name1 = hauppauge_tuner[tuner1].name;
 	} else {
 		t_name1 = "unknown";
 	}
 
-	if (tuner2 < sizeof(hauppauge_tuner)/sizeof(struct HAUPPAUGE_TUNER)) {
+	if (tuner2 < ARRAY_SIZE(hauppauge_tuner)) {
 		tvee->tuner2_type = hauppauge_tuner[tuner2].id;
 		t_name2 = hauppauge_tuner[tuner2].name;
 	} else {
-- 
1.6.3.3

