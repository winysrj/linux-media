Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:2867 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754541Ab0DZHd4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Apr 2010 03:33:56 -0400
Message-Id: <726d8aa69a6dac2fb3226b13ad6b6be8c3a5544d.1272267137.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1272267136.git.hverkuil@xs4all.nl>
References: <cover.1272267136.git.hverkuil@xs4all.nl>
From: Hans Verkuil <hverkuil@xs4all.nl>
Date: Mon, 26 Apr 2010 09:33:54 +0200
Subject: [PATCH 08/15] [RFC] cx25840/ivtv: replace ugly priv control with s_config
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The cx25840 used a private control CX25840_CID_ENABLE_PVR150_WORKAROUND
to be told whether to enable a workaround for certain pvr150 cards.

This is really config data that it needs to get at load time.

Implemented this in cx25840 and ivtv.

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/cx25840/cx25840-core.c |   23 +++++++++++++++--------
 drivers/media/video/cx25840/cx25840-core.h |    8 --------
 drivers/media/video/ivtv/ivtv-driver.c     |    9 +--------
 drivers/media/video/ivtv/ivtv-i2c.c        |    7 +++++++
 include/media/cx25840.h                    |   11 +++++++++++
 5 files changed, 34 insertions(+), 24 deletions(-)

diff --git a/drivers/media/video/cx25840/cx25840-core.c b/drivers/media/video/cx25840/cx25840-core.c
index f2461cd..b8aa5d2 100644
--- a/drivers/media/video/cx25840/cx25840-core.c
+++ b/drivers/media/video/cx25840/cx25840-core.c
@@ -915,11 +915,6 @@ static int cx25840_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
 	switch (ctrl->id) {
-	case CX25840_CID_ENABLE_PVR150_WORKAROUND:
-		state->pvr150_workaround = ctrl->value;
-		set_input(client, state->vid_input, state->aud_input);
-		break;
-
 	case V4L2_CID_BRIGHTNESS:
 		if (ctrl->value < 0 || ctrl->value > 255) {
 			v4l_err(client, "invalid brightness setting %d\n",
@@ -982,9 +977,6 @@ static int cx25840_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
 	switch (ctrl->id) {
-	case CX25840_CID_ENABLE_PVR150_WORKAROUND:
-		ctrl->value = state->pvr150_workaround;
-		break;
 	case V4L2_CID_BRIGHTNESS:
 		ctrl->value = (s8)cx25840_read(client, 0x414) + 128;
 		break;
@@ -1601,10 +1593,25 @@ static int cx25840_log_status(struct v4l2_subdev *sd)
 	return 0;
 }
 
+static int cx25840_s_config(struct v4l2_subdev *sd, int irq, void *platform_data)
+{
+	struct cx25840_state *state = to_state(sd);
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+
+	if (platform_data) {
+		struct cx25840_platform_data *pdata = platform_data;
+
+		state->pvr150_workaround = pdata->pvr150_workaround;
+		set_input(client, state->vid_input, state->aud_input);
+	}
+	return 0;
+}
+
 /* ----------------------------------------------------------------------- */
 
 static const struct v4l2_subdev_core_ops cx25840_core_ops = {
 	.log_status = cx25840_log_status,
+	.s_config = cx25840_s_config,
 	.g_chip_ident = cx25840_g_chip_ident,
 	.g_ctrl = cx25840_g_ctrl,
 	.s_ctrl = cx25840_s_ctrl,
diff --git a/drivers/media/video/cx25840/cx25840-core.h b/drivers/media/video/cx25840/cx25840-core.h
index 5534544..50b7887 100644
--- a/drivers/media/video/cx25840/cx25840-core.h
+++ b/drivers/media/video/cx25840/cx25840-core.h
@@ -26,14 +26,6 @@
 #include <media/v4l2-chip-ident.h>
 #include <linux/i2c.h>
 
-/* ENABLE_PVR150_WORKAROUND activates a workaround for a hardware bug that is
-   present in Hauppauge PVR-150 (and possibly PVR-500) cards that have
-   certain NTSC tuners (tveeprom tuner model numbers 85, 99 and 112). The
-   audio autodetect fails on some channels for these models and the workaround
-   is to select the audio standard explicitly. Many thanks to Hauppauge for
-   providing this information. */
-#define CX25840_CID_ENABLE_PVR150_WORKAROUND (V4L2_CID_PRIVATE_BASE+0)
-
 struct cx25840_state {
 	struct i2c_client *c;
 	struct v4l2_subdev sd;
diff --git a/drivers/media/video/ivtv/ivtv-driver.c b/drivers/media/video/ivtv/ivtv-driver.c
index 1b79475..85aab0e 100644
--- a/drivers/media/video/ivtv/ivtv-driver.c
+++ b/drivers/media/video/ivtv/ivtv-driver.c
@@ -1253,15 +1253,8 @@ int ivtv_init_on_first_open(struct ivtv *itv)
 	IVTV_DEBUG_INFO("Getting firmware version..\n");
 	ivtv_firmware_versions(itv);
 
-	if (itv->card->hw_all & IVTV_HW_CX25840) {
-		struct v4l2_control ctrl;
-
+	if (itv->card->hw_all & IVTV_HW_CX25840)
 		v4l2_subdev_call(itv->sd_video, core, load_fw);
-		/* CX25840_CID_ENABLE_PVR150_WORKAROUND */
-		ctrl.id = V4L2_CID_PRIVATE_BASE;
-		ctrl.value = itv->pvr150_workaround;
-		v4l2_subdev_call(itv->sd_video, core, s_ctrl, &ctrl);
-	}
 
 	vf.tuner = 0;
 	vf.type = V4L2_TUNER_ANALOG_TV;
diff --git a/drivers/media/video/ivtv/ivtv-i2c.c b/drivers/media/video/ivtv/ivtv-i2c.c
index a5b92d1..d391bbd 100644
--- a/drivers/media/video/ivtv/ivtv-i2c.c
+++ b/drivers/media/video/ivtv/ivtv-i2c.c
@@ -63,6 +63,7 @@
 #include "ivtv-cards.h"
 #include "ivtv-gpio.h"
 #include "ivtv-i2c.h"
+#include <media/cx25840.h>
 
 /* i2c implementation for cx23415/6 chip, ivtv project.
  * Author: Kevin Thayer (nufan_wfk at yahoo.com)
@@ -292,6 +293,12 @@ int ivtv_i2c_register(struct ivtv *itv, unsigned idx)
 	if (hw == IVTV_HW_UPD64031A || hw == IVTV_HW_UPD6408X) {
 		sd = v4l2_i2c_new_subdev(&itv->v4l2_dev,
 				adap, mod, type, 0, I2C_ADDRS(hw_addrs[idx]));
+	} else if (hw == IVTV_HW_CX25840) {
+		struct cx25840_platform_data pdata;
+
+		pdata.pvr150_workaround = itv->pvr150_workaround;
+		sd = v4l2_i2c_new_subdev_cfg(&itv->v4l2_dev,
+				adap, mod, type, 0, &pdata, hw_addrs[idx], NULL);
 	} else {
 		sd = v4l2_i2c_new_subdev(&itv->v4l2_dev,
 				adap, mod, type, hw_addrs[idx], NULL);
diff --git a/include/media/cx25840.h b/include/media/cx25840.h
index 0b0cb17..df28412 100644
--- a/include/media/cx25840.h
+++ b/include/media/cx25840.h
@@ -97,4 +97,15 @@ enum cx25840_audio_input {
 	CX25840_AUDIO8,
 };
 
+/* pvr150_workaround activates a workaround for a hardware bug that is
+   present in Hauppauge PVR-150 (and possibly PVR-500) cards that have
+   certain NTSC tuners (tveeprom tuner model numbers 85, 99 and 112). The
+   audio autodetect fails on some channels for these models and the workaround
+   is to select the audio standard explicitly. Many thanks to Hauppauge for
+   providing this information.
+   This platform data only needs to be supplied by the ivtv driver. */
+struct cx25840_platform_data {
+	int pvr150_workaround;
+};
+
 #endif
-- 
1.6.4.2

