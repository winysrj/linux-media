Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52981 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932943Ab3HGSxS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Aug 2013 14:53:18 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 04/16] msi3101: add sampling mode control
Date: Wed,  7 Aug 2013 21:51:35 +0300
Message-Id: <1375901507-26661-5-git-send-email-crope@iki.fi>
In-Reply-To: <1375901507-26661-1-git-send-email-crope@iki.fi>
References: <1375901507-26661-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/staging/media/msi3101/sdr-msi3101.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/msi3101/sdr-msi3101.c b/drivers/staging/media/msi3101/sdr-msi3101.c
index 4de4f50..b6a8939 100644
--- a/drivers/staging/media/msi3101/sdr-msi3101.c
+++ b/drivers/staging/media/msi3101/sdr-msi3101.c
@@ -361,8 +361,9 @@ static const struct msi3101_gain msi3101_gain_lut_1000[] = {
 
 #define MAX_ISOC_ERRORS         20
 
-#define MSI3101_CID_SAMPLING_RATE         ((V4L2_CID_USER_BASE | 0xf000) + 0)
-#define MSI3101_CID_SAMPLING_RESOLUTION   ((V4L2_CID_USER_BASE | 0xf000) + 1)
+#define MSI3101_CID_SAMPLING_MODE         ((V4L2_CID_USER_BASE | 0xf000) + 0)
+#define MSI3101_CID_SAMPLING_RATE         ((V4L2_CID_USER_BASE | 0xf000) + 1)
+#define MSI3101_CID_SAMPLING_RESOLUTION   ((V4L2_CID_USER_BASE | 0xf000) + 2)
 #define MSI3101_CID_TUNER_RF              ((V4L2_CID_USER_BASE | 0xf000) + 10)
 #define MSI3101_CID_TUNER_BW              ((V4L2_CID_USER_BASE | 0xf000) + 11)
 #define MSI3101_CID_TUNER_IF              ((V4L2_CID_USER_BASE | 0xf000) + 12)
@@ -1418,6 +1419,7 @@ static int msi3101_s_ctrl(struct v4l2_ctrl *ctrl)
 			ctrl->minimum, ctrl->maximum, ctrl->step);
 
 	switch (ctrl->id) {
+	case MSI3101_CID_SAMPLING_MODE:
 	case MSI3101_CID_SAMPLING_RATE:
 	case MSI3101_CID_SAMPLING_RESOLUTION:
 		ret = 0;
@@ -1455,6 +1457,18 @@ static int msi3101_probe(struct usb_interface *intf,
 	struct usb_device *udev = interface_to_usbdev(intf);
 	struct msi3101_state *s = NULL;
 	int ret;
+	static const char * const ctrl_sampling_mode_qmenu_strings[] = {
+		"Quadrature Sampling",
+		NULL,
+	};
+	static const struct v4l2_ctrl_config ctrl_sampling_mode = {
+		.ops	= &msi3101_ctrl_ops,
+		.id	= MSI3101_CID_SAMPLING_MODE,
+		.type   = V4L2_CTRL_TYPE_MENU,
+		.flags  = V4L2_CTRL_FLAG_INACTIVE,
+		.name	= "Sampling Mode",
+		.qmenu  = ctrl_sampling_mode_qmenu_strings,
+	};
 	static const struct v4l2_ctrl_config ctrl_sampling_rate = {
 		.ops	= &msi3101_ctrl_ops,
 		.id	= MSI3101_CID_SAMPLING_RATE,
@@ -1553,7 +1567,8 @@ static int msi3101_probe(struct usb_interface *intf,
 	video_set_drvdata(&s->vdev, s);
 
 	/* Register controls */
-	v4l2_ctrl_handler_init(&s->ctrl_handler, 6);
+	v4l2_ctrl_handler_init(&s->ctrl_handler, 7);
+	v4l2_ctrl_new_custom(&s->ctrl_handler, &ctrl_sampling_mode, NULL);
 	s->ctrl_sampling_rate = v4l2_ctrl_new_custom(&s->ctrl_handler, &ctrl_sampling_rate, NULL);
 	v4l2_ctrl_new_custom(&s->ctrl_handler, &ctrl_sampling_resolution, NULL);
 	s->ctrl_tuner_rf = v4l2_ctrl_new_custom(&s->ctrl_handler, &ctrl_tuner_rf, NULL);
-- 
1.7.11.7

