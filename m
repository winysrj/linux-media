Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:36846 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387AbbDSSxG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Apr 2015 14:53:06 -0400
Received: by lagv1 with SMTP id v1so112436112lag.3
        for <linux-media@vger.kernel.org>; Sun, 19 Apr 2015 11:53:04 -0700 (PDT)
From: Vasily Khoruzhick <anarsoul@gmail.com>
To: Hans de Goede <hdegoede@redhat.com>, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Vasily Khoruzhick <anarsoul@gmail.com>
Subject: [PATCH 2/2] gspca: sn9c2028: Add gain and autogain controls Genius Videocam Live v2
Date: Sun, 19 Apr 2015 21:52:45 +0300
Message-Id: <1429469565-2695-2-git-send-email-anarsoul@gmail.com>
In-Reply-To: <1429469565-2695-1-git-send-email-anarsoul@gmail.com>
References: <1429469565-2695-1-git-send-email-anarsoul@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Autogain algorithm is very simple, if average luminance is low - increase gain,
if it's high - decrease gain. Gain granularity is low enough for this algo to
stabilize quickly.

Signed-off-by: Vasily Khoruzhick <anarsoul@gmail.com>
---
 drivers/media/usb/gspca/sn9c2028.c | 121 +++++++++++++++++++++++++++++++++++++
 drivers/media/usb/gspca/sn9c2028.h |  20 +++++-
 2 files changed, 138 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/gspca/sn9c2028.c b/drivers/media/usb/gspca/sn9c2028.c
index 317b02c..0ff390f 100644
--- a/drivers/media/usb/gspca/sn9c2028.c
+++ b/drivers/media/usb/gspca/sn9c2028.c
@@ -34,6 +34,16 @@ struct sd {
 	struct gspca_dev gspca_dev;  /* !! must be the first item */
 	u8 sof_read;
 	u16 model;
+
+#define MIN_AVG_LUM 8500
+#define MAX_AVG_LUM 10000
+	int avg_lum;
+	u8 avg_lum_l;
+
+	struct { /* autogain and gain control cluster */
+		struct v4l2_ctrl *autogain;
+		struct v4l2_ctrl *gain;
+	};
 };
 
 struct init_command {
@@ -252,6 +262,77 @@ static int run_start_commands(struct gspca_dev *gspca_dev,
 	return 0;
 }
 
+static void set_gain(struct gspca_dev *gspca_dev, s32 g)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	struct init_command genius_vcam_live_gain_cmds[] = {
+		{{0x1d, 0x25, 0x10, 0x20, 0xab, 0x00}, 0},
+	};
+	if (!gspca_dev->streaming)
+		return;
+
+	switch (sd->model) {
+	case 0x7003:
+		genius_vcam_live_gain_cmds[0].instruction[2] = g;
+		run_start_commands(gspca_dev, genius_vcam_live_gain_cmds,
+				   ARRAY_SIZE(genius_vcam_live_gain_cmds));
+		break;
+	default:
+		break;
+	}
+}
+
+static int sd_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct gspca_dev *gspca_dev =
+		container_of(ctrl->handler, struct gspca_dev, ctrl_handler);
+	struct sd *sd = (struct sd *)gspca_dev;
+
+	gspca_dev->usb_err = 0;
+
+	if (!gspca_dev->streaming)
+		return 0;
+
+	switch (ctrl->id) {
+	/* standalone gain control */
+	case V4L2_CID_GAIN:
+		set_gain(gspca_dev, ctrl->val);
+		break;
+	/* autogain */
+	case V4L2_CID_AUTOGAIN:
+		set_gain(gspca_dev, sd->gain->val);
+		break;
+	}
+	return gspca_dev->usb_err;
+}
+
+static const struct v4l2_ctrl_ops sd_ctrl_ops = {
+	.s_ctrl = sd_s_ctrl,
+};
+
+
+static int sd_init_controls(struct gspca_dev *gspca_dev)
+{
+	struct v4l2_ctrl_handler *hdl = &gspca_dev->ctrl_handler;
+	struct sd *sd = (struct sd *)gspca_dev;
+
+	gspca_dev->vdev.ctrl_handler = hdl;
+	v4l2_ctrl_handler_init(hdl, 2);
+
+	switch (sd->model) {
+	case 0x7003:
+		sd->gain = v4l2_ctrl_new_std(hdl, &sd_ctrl_ops,
+			V4L2_CID_GAIN, 0, 20, 1, 0);
+		sd->autogain = v4l2_ctrl_new_std(hdl, &sd_ctrl_ops,
+			V4L2_CID_AUTOGAIN, 0, 1, 1, 1);
+		break;
+	default:
+		break;
+	}
+
+	return 0;
+}
 static int start_spy_cam(struct gspca_dev *gspca_dev)
 {
 	struct init_command spy_start_commands[] = {
@@ -641,6 +722,9 @@ static int start_genius_videocam_live(struct gspca_dev *gspca_dev)
 	if (r < 0)
 		return r;
 
+	if (sd->gain)
+		set_gain(gspca_dev, v4l2_ctrl_g_ctrl(sd->gain));
+
 	return r;
 }
 
@@ -757,6 +841,8 @@ static int sd_start(struct gspca_dev *gspca_dev)
 		return -ENXIO;
 	}
 
+	sd->avg_lum = -1;
+
 	return err_code;
 }
 
@@ -776,6 +862,39 @@ static void sd_stopN(struct gspca_dev *gspca_dev)
 		PERR("Camera Stop command failed");
 }
 
+static void do_autogain(struct gspca_dev *gspca_dev, int avg_lum)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	s32 cur_gain = v4l2_ctrl_g_ctrl(sd->gain);
+
+	if (avg_lum == -1)
+		return;
+
+	if (avg_lum < MIN_AVG_LUM) {
+		if (cur_gain == sd->gain->maximum)
+			return;
+		cur_gain++;
+		v4l2_ctrl_s_ctrl(sd->gain, cur_gain);
+	}
+	if (avg_lum > MAX_AVG_LUM) {
+		if (cur_gain == sd->gain->minimum)
+			return;
+		cur_gain--;
+		v4l2_ctrl_s_ctrl(sd->gain, cur_gain);
+	}
+
+}
+
+static void sd_dqcallback(struct gspca_dev *gspca_dev)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	if (sd->autogain == NULL || !v4l2_ctrl_g_ctrl(sd->autogain))
+		return;
+
+	do_autogain(gspca_dev, sd->avg_lum);
+}
+
 /* Include sn9c2028 sof detection functions */
 #include "sn9c2028.h"
 
@@ -810,8 +929,10 @@ static const struct sd_desc sd_desc = {
 	.name = MODULE_NAME,
 	.config = sd_config,
 	.init = sd_init,
+	.init_controls = sd_init_controls,
 	.start = sd_start,
 	.stopN = sd_stopN,
+	.dq_callback = sd_dqcallback,
 	.pkt_scan = sd_pkt_scan,
 };
 
diff --git a/drivers/media/usb/gspca/sn9c2028.h b/drivers/media/usb/gspca/sn9c2028.h
index 8fd1d3e..6f20c0f 100644
--- a/drivers/media/usb/gspca/sn9c2028.h
+++ b/drivers/media/usb/gspca/sn9c2028.h
@@ -21,8 +21,17 @@
  *
  */
 
-static const unsigned char sn9c2028_sof_marker[5] =
-	{ 0xff, 0xff, 0x00, 0xc4, 0xc4 };
+static const unsigned char sn9c2028_sof_marker[] = {
+	0xff, 0xff, 0x00, 0xc4, 0xc4, 0x96,
+	0x00,
+	0x00, /* seq */
+	0x00,
+	0x00,
+	0x00, /* avg luminance lower 8 bit */
+	0x00, /* avg luminance higher 8 bit */
+	0x00,
+	0x00,
+};
 
 static unsigned char *sn9c2028_find_sof(struct gspca_dev *gspca_dev,
 					unsigned char *m, int len)
@@ -32,8 +41,13 @@ static unsigned char *sn9c2028_find_sof(struct gspca_dev *gspca_dev,
 
 	/* Search for the SOF marker (fixed part) in the header */
 	for (i = 0; i < len; i++) {
-		if (m[i] == sn9c2028_sof_marker[sd->sof_read]) {
+		if ((m[i] == sn9c2028_sof_marker[sd->sof_read]) ||
+		    (sd->sof_read > 5)) {
 			sd->sof_read++;
+			if (sd->sof_read == 11)
+				sd->avg_lum_l = m[i];
+			if (sd->sof_read == 12)
+				sd->avg_lum = (m[i] << 8) + sd->avg_lum_l;
 			if (sd->sof_read == sizeof(sn9c2028_sof_marker)) {
 				PDEBUG(D_FRAM,
 					"SOF found, bytes to analyze: %u."
-- 
2.3.5

