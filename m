Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:35346 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756423AbaD1Twx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Apr 2014 15:52:53 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH v3] v4l: subdev: Move [gs]_std operation to video ops
Date: Mon, 28 Apr 2014 21:53:01 +0200
Message-Id: <1398714781-5165-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The g_std and s_std operations are video-related, move them to the video
ops where they belong.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/i2c/adv7180.c                     |  2 +-
 drivers/media/i2c/adv7183.c                     |  4 ++--
 drivers/media/i2c/adv7842.c                     |  4 ++--
 drivers/media/i2c/bt819.c                       |  2 +-
 drivers/media/i2c/cx25840/cx25840-core.c        |  4 ++--
 drivers/media/i2c/ks0127.c                      |  6 +-----
 drivers/media/i2c/ml86v7667.c                   |  2 +-
 drivers/media/i2c/msp3400-driver.c              |  2 +-
 drivers/media/i2c/saa6752hs.c                   |  2 +-
 drivers/media/i2c/saa7110.c                     |  2 +-
 drivers/media/i2c/saa7115.c                     |  2 +-
 drivers/media/i2c/saa717x.c                     |  2 +-
 drivers/media/i2c/saa7191.c                     |  2 +-
 drivers/media/i2c/soc_camera/tw9910.c           |  4 ++--
 drivers/media/i2c/sony-btf-mpx.c                | 10 +++++-----
 drivers/media/i2c/tvaudio.c                     |  6 +++++-
 drivers/media/i2c/tvp514x.c                     |  2 +-
 drivers/media/i2c/tvp5150.c                     |  2 +-
 drivers/media/i2c/tw2804.c                      |  2 +-
 drivers/media/i2c/tw9903.c                      |  2 +-
 drivers/media/i2c/tw9906.c                      |  2 +-
 drivers/media/i2c/vp27smpx.c                    |  6 +++++-
 drivers/media/i2c/vpx3220.c                     |  2 +-
 drivers/media/pci/bt8xx/bttv-driver.c           |  2 +-
 drivers/media/pci/cx18/cx18-av-core.c           |  2 +-
 drivers/media/pci/cx18/cx18-fileops.c           |  2 +-
 drivers/media/pci/cx18/cx18-gpio.c              |  6 +++++-
 drivers/media/pci/cx18/cx18-ioctl.c             |  2 +-
 drivers/media/pci/cx23885/cx23885-video.c       |  4 ++--
 drivers/media/pci/cx88/cx88-core.c              |  2 +-
 drivers/media/pci/ivtv/ivtv-fileops.c           |  2 +-
 drivers/media/pci/ivtv/ivtv-ioctl.c             |  2 +-
 drivers/media/pci/saa7134/saa7134-video.c       |  4 ++--
 drivers/media/pci/saa7146/mxb.c                 | 14 +++++++-------
 drivers/media/pci/sta2x11/sta2x11_vip.c         |  4 ++--
 drivers/media/pci/zoran/zoran_device.c          |  2 +-
 drivers/media/pci/zoran/zoran_driver.c          |  2 +-
 drivers/media/platform/blackfin/bfin_capture.c  |  4 ++--
 drivers/media/platform/davinci/vpfe_capture.c   |  2 +-
 drivers/media/platform/davinci/vpif_capture.c   |  2 +-
 drivers/media/platform/davinci/vpif_display.c   |  2 +-
 drivers/media/platform/fsl-viu.c                |  2 +-
 drivers/media/platform/soc_camera/soc_camera.c  |  4 ++--
 drivers/media/platform/timblogiw.c              |  2 +-
 drivers/media/platform/vino.c                   |  6 +++---
 drivers/media/usb/au0828/au0828-video.c         |  4 ++--
 drivers/media/usb/cx231xx/cx231xx-417.c         |  2 +-
 drivers/media/usb/cx231xx/cx231xx-video.c       |  6 +++---
 drivers/media/usb/em28xx/em28xx-video.c         |  4 ++--
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c         |  2 +-
 drivers/media/usb/stk1160/stk1160-v4l.c         |  4 ++--
 drivers/media/usb/tm6000/tm6000-cards.c         |  2 +-
 drivers/media/usb/tm6000/tm6000-video.c         |  2 +-
 drivers/media/usb/usbvision/usbvision-video.c   |  2 +-
 drivers/media/v4l2-core/tuner-core.c            |  6 +++++-
 drivers/staging/media/davinci_vpfe/vpfe_video.c |  2 +-
 drivers/staging/media/go7007/go7007-v4l2.c      |  2 +-
 drivers/staging/media/go7007/s2250-board.c      |  2 +-
 drivers/staging/media/go7007/saa7134-go7007.c   |  4 ++++
 include/media/v4l2-subdev.h                     |  6 +++---
 60 files changed, 107 insertions(+), 91 deletions(-)

Changes compared to v2:

- Picked Prabhakar's Acked-by tag

diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index 5e638b1..ac1cdbe 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -461,6 +461,7 @@ static int adv7180_g_mbus_config(struct v4l2_subdev *sd,
 }
 
 static const struct v4l2_subdev_video_ops adv7180_video_ops = {
+	.s_std = adv7180_s_std,
 	.querystd = adv7180_querystd,
 	.g_input_status = adv7180_g_input_status,
 	.s_routing = adv7180_s_routing,
@@ -472,7 +473,6 @@ static const struct v4l2_subdev_video_ops adv7180_video_ops = {
 };
 
 static const struct v4l2_subdev_core_ops adv7180_core_ops = {
-	.s_std = adv7180_s_std,
 	.s_power = adv7180_s_power,
 };
 
diff --git a/drivers/media/i2c/adv7183.c b/drivers/media/i2c/adv7183.c
index d45e0e3..df461b0 100644
--- a/drivers/media/i2c/adv7183.c
+++ b/drivers/media/i2c/adv7183.c
@@ -501,8 +501,6 @@ static const struct v4l2_ctrl_ops adv7183_ctrl_ops = {
 
 static const struct v4l2_subdev_core_ops adv7183_core_ops = {
 	.log_status = adv7183_log_status,
-	.g_std = adv7183_g_std,
-	.s_std = adv7183_s_std,
 	.reset = adv7183_reset,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register = adv7183_g_register,
@@ -511,6 +509,8 @@ static const struct v4l2_subdev_core_ops adv7183_core_ops = {
 };
 
 static const struct v4l2_subdev_video_ops adv7183_video_ops = {
+	.g_std = adv7183_g_std,
+	.s_std = adv7183_s_std,
 	.s_routing = adv7183_s_routing,
 	.querystd = adv7183_querystd,
 	.g_input_status = adv7183_g_input_status,
diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index 06c25c3..6a4d389 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -2873,8 +2873,6 @@ static const struct v4l2_ctrl_ops adv7842_ctrl_ops = {
 
 static const struct v4l2_subdev_core_ops adv7842_core_ops = {
 	.log_status = adv7842_log_status,
-	.g_std = adv7842_g_std,
-	.s_std = adv7842_s_std,
 	.ioctl = adv7842_ioctl,
 	.interrupt_service_routine = adv7842_isr,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
@@ -2884,6 +2882,8 @@ static const struct v4l2_subdev_core_ops adv7842_core_ops = {
 };
 
 static const struct v4l2_subdev_video_ops adv7842_video_ops = {
+	.g_std = adv7842_g_std,
+	.s_std = adv7842_s_std,
 	.s_routing = adv7842_s_routing,
 	.querystd = adv7842_querystd,
 	.g_input_status = adv7842_g_input_status,
diff --git a/drivers/media/i2c/bt819.c b/drivers/media/i2c/bt819.c
index 369cf6f..76b334a 100644
--- a/drivers/media/i2c/bt819.c
+++ b/drivers/media/i2c/bt819.c
@@ -387,10 +387,10 @@ static const struct v4l2_subdev_core_ops bt819_core_ops = {
 	.s_ctrl = v4l2_subdev_s_ctrl,
 	.queryctrl = v4l2_subdev_queryctrl,
 	.querymenu = v4l2_subdev_querymenu,
-	.s_std = bt819_s_std,
 };
 
 static const struct v4l2_subdev_video_ops bt819_video_ops = {
+	.s_std = bt819_s_std,
 	.s_routing = bt819_s_routing,
 	.s_stream = bt819_s_stream,
 	.querystd = bt819_querystd,
diff --git a/drivers/media/i2c/cx25840/cx25840-core.c b/drivers/media/i2c/cx25840/cx25840-core.c
index 2e3771d..e453a3f 100644
--- a/drivers/media/i2c/cx25840/cx25840-core.c
+++ b/drivers/media/i2c/cx25840/cx25840-core.c
@@ -5041,8 +5041,6 @@ static const struct v4l2_subdev_core_ops cx25840_core_ops = {
 	.g_ext_ctrls = v4l2_subdev_g_ext_ctrls,
 	.queryctrl = v4l2_subdev_queryctrl,
 	.querymenu = v4l2_subdev_querymenu,
-	.s_std = cx25840_s_std,
-	.g_std = cx25840_g_std,
 	.reset = cx25840_reset,
 	.load_fw = cx25840_load_fw,
 	.s_io_pin_config = common_s_io_pin_config,
@@ -5067,6 +5065,8 @@ static const struct v4l2_subdev_audio_ops cx25840_audio_ops = {
 };
 
 static const struct v4l2_subdev_video_ops cx25840_video_ops = {
+	.s_std = cx25840_s_std,
+	.g_std = cx25840_g_std,
 	.s_routing = cx25840_s_video_routing,
 	.s_mbus_fmt = cx25840_s_mbus_fmt,
 	.s_stream = cx25840_s_stream,
diff --git a/drivers/media/i2c/ks0127.c b/drivers/media/i2c/ks0127.c
index c3e94ae..25b81bc 100644
--- a/drivers/media/i2c/ks0127.c
+++ b/drivers/media/i2c/ks0127.c
@@ -648,11 +648,8 @@ static int ks0127_g_input_status(struct v4l2_subdev *sd, u32 *status)
 
 /* ----------------------------------------------------------------------- */
 
-static const struct v4l2_subdev_core_ops ks0127_core_ops = {
-	.s_std = ks0127_s_std,
-};
-
 static const struct v4l2_subdev_video_ops ks0127_video_ops = {
+	.s_std = ks0127_s_std,
 	.s_routing = ks0127_s_routing,
 	.s_stream = ks0127_s_stream,
 	.querystd = ks0127_querystd,
@@ -660,7 +657,6 @@ static const struct v4l2_subdev_video_ops ks0127_video_ops = {
 };
 
 static const struct v4l2_subdev_ops ks0127_ops = {
-	.core = &ks0127_core_ops,
 	.video = &ks0127_video_ops,
 };
 
diff --git a/drivers/media/i2c/ml86v7667.c b/drivers/media/i2c/ml86v7667.c
index a9110d8..2cace73 100644
--- a/drivers/media/i2c/ml86v7667.c
+++ b/drivers/media/i2c/ml86v7667.c
@@ -276,6 +276,7 @@ static const struct v4l2_ctrl_ops ml86v7667_ctrl_ops = {
 };
 
 static struct v4l2_subdev_video_ops ml86v7667_subdev_video_ops = {
+	.s_std = ml86v7667_s_std,
 	.querystd = ml86v7667_querystd,
 	.g_input_status = ml86v7667_g_input_status,
 	.enum_mbus_fmt = ml86v7667_enum_mbus_fmt,
@@ -286,7 +287,6 @@ static struct v4l2_subdev_video_ops ml86v7667_subdev_video_ops = {
 };
 
 static struct v4l2_subdev_core_ops ml86v7667_subdev_core_ops = {
-	.s_std = ml86v7667_s_std,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register = ml86v7667_g_register,
 	.s_register = ml86v7667_s_register,
diff --git a/drivers/media/i2c/msp3400-driver.c b/drivers/media/i2c/msp3400-driver.c
index 8190fec..4d9c6bc 100644
--- a/drivers/media/i2c/msp3400-driver.c
+++ b/drivers/media/i2c/msp3400-driver.c
@@ -649,10 +649,10 @@ static const struct v4l2_subdev_core_ops msp_core_ops = {
 	.s_ctrl = v4l2_subdev_s_ctrl,
 	.queryctrl = v4l2_subdev_queryctrl,
 	.querymenu = v4l2_subdev_querymenu,
-	.s_std = msp_s_std,
 };
 
 static const struct v4l2_subdev_video_ops msp_video_ops = {
+	.s_std = msp_s_std,
 	.querystd = msp_querystd,
 };
 
diff --git a/drivers/media/i2c/saa6752hs.c b/drivers/media/i2c/saa6752hs.c
index 8272c0b..04e9e55 100644
--- a/drivers/media/i2c/saa6752hs.c
+++ b/drivers/media/i2c/saa6752hs.c
@@ -643,10 +643,10 @@ static const struct v4l2_ctrl_ops saa6752hs_ctrl_ops = {
 
 static const struct v4l2_subdev_core_ops saa6752hs_core_ops = {
 	.init = saa6752hs_init,
-	.s_std = saa6752hs_s_std,
 };
 
 static const struct v4l2_subdev_video_ops saa6752hs_video_ops = {
+	.s_std = saa6752hs_s_std,
 	.s_mbus_fmt = saa6752hs_s_mbus_fmt,
 	.try_mbus_fmt = saa6752hs_try_mbus_fmt,
 	.g_mbus_fmt = saa6752hs_g_mbus_fmt,
diff --git a/drivers/media/i2c/saa7110.c b/drivers/media/i2c/saa7110.c
index ac43e92..99689ee 100644
--- a/drivers/media/i2c/saa7110.c
+++ b/drivers/media/i2c/saa7110.c
@@ -365,10 +365,10 @@ static const struct v4l2_subdev_core_ops saa7110_core_ops = {
 	.s_ctrl = v4l2_subdev_s_ctrl,
 	.queryctrl = v4l2_subdev_queryctrl,
 	.querymenu = v4l2_subdev_querymenu,
-	.s_std = saa7110_s_std,
 };
 
 static const struct v4l2_subdev_video_ops saa7110_video_ops = {
+	.s_std = saa7110_s_std,
 	.s_routing = saa7110_s_routing,
 	.s_stream = saa7110_s_stream,
 	.querystd = saa7110_querystd,
diff --git a/drivers/media/i2c/saa7115.c b/drivers/media/i2c/saa7115.c
index afdbcb0..35a4464 100644
--- a/drivers/media/i2c/saa7115.c
+++ b/drivers/media/i2c/saa7115.c
@@ -1582,7 +1582,6 @@ static const struct v4l2_subdev_core_ops saa711x_core_ops = {
 	.s_ctrl = v4l2_subdev_s_ctrl,
 	.queryctrl = v4l2_subdev_queryctrl,
 	.querymenu = v4l2_subdev_querymenu,
-	.s_std = saa711x_s_std,
 	.reset = saa711x_reset,
 	.s_gpio = saa711x_s_gpio,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
@@ -1601,6 +1600,7 @@ static const struct v4l2_subdev_audio_ops saa711x_audio_ops = {
 };
 
 static const struct v4l2_subdev_video_ops saa711x_video_ops = {
+	.s_std = saa711x_s_std,
 	.s_routing = saa711x_s_routing,
 	.s_crystal_freq = saa711x_s_crystal_freq,
 	.s_mbus_fmt = saa711x_s_mbus_fmt,
diff --git a/drivers/media/i2c/saa717x.c b/drivers/media/i2c/saa717x.c
index 401ca11..6922a9f 100644
--- a/drivers/media/i2c/saa717x.c
+++ b/drivers/media/i2c/saa717x.c
@@ -1198,7 +1198,6 @@ static const struct v4l2_subdev_core_ops saa717x_core_ops = {
 	.g_register = saa717x_g_register,
 	.s_register = saa717x_s_register,
 #endif
-	.s_std = saa717x_s_std,
 	.g_ext_ctrls = v4l2_subdev_g_ext_ctrls,
 	.try_ext_ctrls = v4l2_subdev_try_ext_ctrls,
 	.s_ext_ctrls = v4l2_subdev_s_ext_ctrls,
@@ -1216,6 +1215,7 @@ static const struct v4l2_subdev_tuner_ops saa717x_tuner_ops = {
 };
 
 static const struct v4l2_subdev_video_ops saa717x_video_ops = {
+	.s_std = saa717x_s_std,
 	.s_routing = saa717x_s_video_routing,
 	.s_mbus_fmt = saa717x_s_mbus_fmt,
 	.s_stream = saa717x_s_stream,
diff --git a/drivers/media/i2c/saa7191.c b/drivers/media/i2c/saa7191.c
index 606a4ba..8e96992 100644
--- a/drivers/media/i2c/saa7191.c
+++ b/drivers/media/i2c/saa7191.c
@@ -573,10 +573,10 @@ static int saa7191_g_input_status(struct v4l2_subdev *sd, u32 *status)
 static const struct v4l2_subdev_core_ops saa7191_core_ops = {
 	.g_ctrl = saa7191_g_ctrl,
 	.s_ctrl = saa7191_s_ctrl,
-	.s_std = saa7191_s_std,
 };
 
 static const struct v4l2_subdev_video_ops saa7191_video_ops = {
+	.s_std = saa7191_s_std,
 	.s_routing = saa7191_s_routing,
 	.querystd = saa7191_querystd,
 	.g_input_status = saa7191_g_input_status,
diff --git a/drivers/media/i2c/soc_camera/tw9910.c b/drivers/media/i2c/soc_camera/tw9910.c
index ab54628..059478a 100644
--- a/drivers/media/i2c/soc_camera/tw9910.c
+++ b/drivers/media/i2c/soc_camera/tw9910.c
@@ -814,8 +814,6 @@ done:
 }
 
 static struct v4l2_subdev_core_ops tw9910_subdev_core_ops = {
-	.s_std		= tw9910_s_std,
-	.g_std		= tw9910_g_std,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register	= tw9910_g_register,
 	.s_register	= tw9910_s_register,
@@ -873,6 +871,8 @@ static int tw9910_s_mbus_config(struct v4l2_subdev *sd,
 }
 
 static struct v4l2_subdev_video_ops tw9910_subdev_video_ops = {
+	.s_std		= tw9910_s_std,
+	.g_std		= tw9910_g_std,
 	.s_stream	= tw9910_s_stream,
 	.g_mbus_fmt	= tw9910_g_fmt,
 	.s_mbus_fmt	= tw9910_s_fmt,
diff --git a/drivers/media/i2c/sony-btf-mpx.c b/drivers/media/i2c/sony-btf-mpx.c
index 32d8232..1da8004 100644
--- a/drivers/media/i2c/sony-btf-mpx.c
+++ b/drivers/media/i2c/sony-btf-mpx.c
@@ -327,18 +327,18 @@ static int sony_btf_mpx_s_tuner(struct v4l2_subdev *sd, const struct v4l2_tuner
 
 /* --------------------------------------------------------------------------*/
 
-static const struct v4l2_subdev_core_ops sony_btf_mpx_core_ops = {
-	.s_std = sony_btf_mpx_s_std,
-};
-
 static const struct v4l2_subdev_tuner_ops sony_btf_mpx_tuner_ops = {
 	.s_tuner = sony_btf_mpx_s_tuner,
 	.g_tuner = sony_btf_mpx_g_tuner,
 };
 
+static const struct v4l2_subdev_video_ops sony_btf_mpx_video_ops = {
+	.s_std = sony_btf_mpx_s_std,
+};
+
 static const struct v4l2_subdev_ops sony_btf_mpx_ops = {
-	.core = &sony_btf_mpx_core_ops,
 	.tuner = &sony_btf_mpx_tuner_ops,
+	.video = &sony_btf_mpx_video_ops,
 };
 
 /* --------------------------------------------------------------------------*/
diff --git a/drivers/media/i2c/tvaudio.c b/drivers/media/i2c/tvaudio.c
index d76c53a8..070c152 100644
--- a/drivers/media/i2c/tvaudio.c
+++ b/drivers/media/i2c/tvaudio.c
@@ -1862,7 +1862,6 @@ static const struct v4l2_subdev_core_ops tvaudio_core_ops = {
 	.s_ctrl = v4l2_subdev_s_ctrl,
 	.queryctrl = v4l2_subdev_queryctrl,
 	.querymenu = v4l2_subdev_querymenu,
-	.s_std = tvaudio_s_std,
 };
 
 static const struct v4l2_subdev_tuner_ops tvaudio_tuner_ops = {
@@ -1876,10 +1875,15 @@ static const struct v4l2_subdev_audio_ops tvaudio_audio_ops = {
 	.s_routing = tvaudio_s_routing,
 };
 
+static const struct v4l2_subdev_video_ops tvaudio_video_ops = {
+	.s_std = tvaudio_s_std,
+};
+
 static const struct v4l2_subdev_ops tvaudio_ops = {
 	.core = &tvaudio_core_ops,
 	.tuner = &tvaudio_tuner_ops,
 	.audio = &tvaudio_audio_ops,
+	.video = &tvaudio_video_ops,
 };
 
 /* ----------------------------------------------------------------------- */
diff --git a/drivers/media/i2c/tvp514x.c b/drivers/media/i2c/tvp514x.c
index ca001178..b9dabc9 100644
--- a/drivers/media/i2c/tvp514x.c
+++ b/drivers/media/i2c/tvp514x.c
@@ -1010,10 +1010,10 @@ static const struct v4l2_subdev_core_ops tvp514x_core_ops = {
 	.s_ctrl = v4l2_subdev_s_ctrl,
 	.queryctrl = v4l2_subdev_queryctrl,
 	.querymenu = v4l2_subdev_querymenu,
-	.s_std = tvp514x_s_std,
 };
 
 static const struct v4l2_subdev_video_ops tvp514x_video_ops = {
+	.s_std = tvp514x_s_std,
 	.s_routing = tvp514x_s_routing,
 	.querystd = tvp514x_querystd,
 	.enum_mbus_fmt = tvp514x_enum_mbus_fmt,
diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index 4fd3688..efb1927 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -1063,7 +1063,6 @@ static const struct v4l2_ctrl_ops tvp5150_ctrl_ops = {
 
 static const struct v4l2_subdev_core_ops tvp5150_core_ops = {
 	.log_status = tvp5150_log_status,
-	.s_std = tvp5150_s_std,
 	.reset = tvp5150_reset,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register = tvp5150_g_register,
@@ -1076,6 +1075,7 @@ static const struct v4l2_subdev_tuner_ops tvp5150_tuner_ops = {
 };
 
 static const struct v4l2_subdev_video_ops tvp5150_video_ops = {
+	.s_std = tvp5150_s_std,
 	.s_routing = tvp5150_s_routing,
 	.enum_mbus_fmt = tvp5150_enum_mbus_fmt,
 	.s_mbus_fmt = tvp5150_mbus_fmt,
diff --git a/drivers/media/i2c/tw2804.c b/drivers/media/i2c/tw2804.c
index f58607d..7347480 100644
--- a/drivers/media/i2c/tw2804.c
+++ b/drivers/media/i2c/tw2804.c
@@ -342,12 +342,12 @@ static const struct v4l2_ctrl_ops tw2804_ctrl_ops = {
 };
 
 static const struct v4l2_subdev_video_ops tw2804_video_ops = {
+	.s_std = tw2804_s_std,
 	.s_routing = tw2804_s_video_routing,
 };
 
 static const struct v4l2_subdev_core_ops tw2804_core_ops = {
 	.log_status = tw2804_log_status,
-	.s_std = tw2804_s_std,
 };
 
 static const struct v4l2_subdev_ops tw2804_ops = {
diff --git a/drivers/media/i2c/tw9903.c b/drivers/media/i2c/tw9903.c
index 285b759..12c7d21 100644
--- a/drivers/media/i2c/tw9903.c
+++ b/drivers/media/i2c/tw9903.c
@@ -187,10 +187,10 @@ static const struct v4l2_ctrl_ops tw9903_ctrl_ops = {
 
 static const struct v4l2_subdev_core_ops tw9903_core_ops = {
 	.log_status = tw9903_log_status,
-	.s_std = tw9903_s_std,
 };
 
 static const struct v4l2_subdev_video_ops tw9903_video_ops = {
+	.s_std = tw9903_s_std,
 	.s_routing = tw9903_s_video_routing,
 };
 
diff --git a/drivers/media/i2c/tw9906.c b/drivers/media/i2c/tw9906.c
index f6bef25..2672d89 100644
--- a/drivers/media/i2c/tw9906.c
+++ b/drivers/media/i2c/tw9906.c
@@ -157,10 +157,10 @@ static const struct v4l2_ctrl_ops tw9906_ctrl_ops = {
 
 static const struct v4l2_subdev_core_ops tw9906_core_ops = {
 	.log_status = tw9906_log_status,
-	.s_std = tw9906_s_std,
 };
 
 static const struct v4l2_subdev_video_ops tw9906_video_ops = {
+	.s_std = tw9906_s_std,
 	.s_routing = tw9906_s_video_routing,
 };
 
diff --git a/drivers/media/i2c/vp27smpx.c b/drivers/media/i2c/vp27smpx.c
index 6a3a3ff..819ab6d 100644
--- a/drivers/media/i2c/vp27smpx.c
+++ b/drivers/media/i2c/vp27smpx.c
@@ -124,7 +124,6 @@ static int vp27smpx_log_status(struct v4l2_subdev *sd)
 
 static const struct v4l2_subdev_core_ops vp27smpx_core_ops = {
 	.log_status = vp27smpx_log_status,
-	.s_std = vp27smpx_s_std,
 };
 
 static const struct v4l2_subdev_tuner_ops vp27smpx_tuner_ops = {
@@ -133,9 +132,14 @@ static const struct v4l2_subdev_tuner_ops vp27smpx_tuner_ops = {
 	.g_tuner = vp27smpx_g_tuner,
 };
 
+static const struct v4l2_subdev_video_ops vp27smpx_video_ops = {
+	.s_std = vp27smpx_s_std,
+};
+
 static const struct v4l2_subdev_ops vp27smpx_ops = {
 	.core = &vp27smpx_core_ops,
 	.tuner = &vp27smpx_tuner_ops,
+	.video = &vp27smpx_video_ops,
 };
 
 /* ----------------------------------------------------------------------- */
diff --git a/drivers/media/i2c/vpx3220.c b/drivers/media/i2c/vpx3220.c
index ece90df..016e766 100644
--- a/drivers/media/i2c/vpx3220.c
+++ b/drivers/media/i2c/vpx3220.c
@@ -457,10 +457,10 @@ static const struct v4l2_subdev_core_ops vpx3220_core_ops = {
 	.s_ctrl = v4l2_subdev_s_ctrl,
 	.queryctrl = v4l2_subdev_queryctrl,
 	.querymenu = v4l2_subdev_querymenu,
-	.s_std = vpx3220_s_std,
 };
 
 static const struct v4l2_subdev_video_ops vpx3220_video_ops = {
+	.s_std = vpx3220_s_std,
 	.s_routing = vpx3220_s_routing,
 	.s_stream = vpx3220_s_stream,
 	.querystd = vpx3220_querystd,
diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index afcd53b..da780f4 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -1182,7 +1182,7 @@ set_tvnorm(struct bttv *btv, unsigned int norm)
 		break;
 	}
 	id = tvnorm->v4l2_id;
-	bttv_call_all(btv, core, s_std, id);
+	bttv_call_all(btv, video, s_std, id);
 
 	return 0;
 }
diff --git a/drivers/media/pci/cx18/cx18-av-core.c b/drivers/media/pci/cx18/cx18-av-core.c
index c4890a4..2d3afe0 100644
--- a/drivers/media/pci/cx18/cx18-av-core.c
+++ b/drivers/media/pci/cx18/cx18-av-core.c
@@ -1263,7 +1263,6 @@ static const struct v4l2_subdev_core_ops cx18_av_general_ops = {
 	.log_status = cx18_av_log_status,
 	.load_fw = cx18_av_load_fw,
 	.reset = cx18_av_reset,
-	.s_std = cx18_av_s_std,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register = cx18_av_g_register,
 	.s_register = cx18_av_s_register,
@@ -1283,6 +1282,7 @@ static const struct v4l2_subdev_audio_ops cx18_av_audio_ops = {
 };
 
 static const struct v4l2_subdev_video_ops cx18_av_video_ops = {
+	.s_std = cx18_av_s_std,
 	.s_routing = cx18_av_s_video_routing,
 	.s_stream = cx18_av_s_stream,
 	.s_mbus_fmt = cx18_av_s_mbus_fmt,
diff --git a/drivers/media/pci/cx18/cx18-fileops.c b/drivers/media/pci/cx18/cx18-fileops.c
index 4bfd865..76a3b4a 100644
--- a/drivers/media/pci/cx18/cx18-fileops.c
+++ b/drivers/media/pci/cx18/cx18-fileops.c
@@ -760,7 +760,7 @@ int cx18_v4l2_close(struct file *filp)
 		/* Mark that the radio is no longer in use */
 		clear_bit(CX18_F_I_RADIO_USER, &cx->i_flags);
 		/* Switch tuner to TV */
-		cx18_call_all(cx, core, s_std, cx->std);
+		cx18_call_all(cx, video, s_std, cx->std);
 		/* Select correct audio input (i.e. TV tuner or Line in) */
 		cx18_audio_set_io(cx);
 		if (atomic_read(&cx->ana_capturing) > 0) {
diff --git a/drivers/media/pci/cx18/cx18-gpio.c b/drivers/media/pci/cx18/cx18-gpio.c
index 5374aeb..38dc6b8 100644
--- a/drivers/media/pci/cx18/cx18-gpio.c
+++ b/drivers/media/pci/cx18/cx18-gpio.c
@@ -180,7 +180,6 @@ static int gpiomux_s_audio_routing(struct v4l2_subdev *sd,
 
 static const struct v4l2_subdev_core_ops gpiomux_core_ops = {
 	.log_status = gpiomux_log_status,
-	.s_std = gpiomux_s_std,
 };
 
 static const struct v4l2_subdev_tuner_ops gpiomux_tuner_ops = {
@@ -191,10 +190,15 @@ static const struct v4l2_subdev_audio_ops gpiomux_audio_ops = {
 	.s_routing = gpiomux_s_audio_routing,
 };
 
+static const struct v4l2_subdev_video_ops gpiomux_video_ops = {
+	.s_std = gpiomux_s_std,
+};
+
 static const struct v4l2_subdev_ops gpiomux_ops = {
 	.core = &gpiomux_core_ops,
 	.tuner = &gpiomux_tuner_ops,
 	.audio = &gpiomux_audio_ops,
+	.video = &gpiomux_video_ops,
 };
 
 /*
diff --git a/drivers/media/pci/cx18/cx18-ioctl.c b/drivers/media/pci/cx18/cx18-ioctl.c
index 1110bcb..fefb2cd 100644
--- a/drivers/media/pci/cx18/cx18-ioctl.c
+++ b/drivers/media/pci/cx18/cx18-ioctl.c
@@ -602,7 +602,7 @@ int cx18_s_std(struct file *file, void *fh, v4l2_std_id std)
 			(unsigned long long) cx->std);
 
 	/* Tuner */
-	cx18_call_all(cx, core, s_std, cx->std);
+	cx18_call_all(cx, video, s_std, cx->std);
 	return 0;
 }
 
diff --git a/drivers/media/pci/cx23885/cx23885-video.c b/drivers/media/pci/cx23885/cx23885-video.c
index 7891f34..e0a5952 100644
--- a/drivers/media/pci/cx23885/cx23885-video.c
+++ b/drivers/media/pci/cx23885/cx23885-video.c
@@ -326,7 +326,7 @@ int cx23885_set_tvnorm(struct cx23885_dev *dev, v4l2_std_id norm)
 
 	dev->tvnorm = norm;
 
-	call_all(dev, core, s_std, norm);
+	call_all(dev, video, s_std, norm);
 
 	return 0;
 }
@@ -1589,7 +1589,7 @@ static int cx23885_set_freq_via_ops(struct cx23885_dev *dev,
 		fe = &dev->ts1.analog_fe;
 
 	if (fe && fe->ops.tuner_ops.set_analog_params) {
-		call_all(dev, core, s_std, dev->tvnorm);
+		call_all(dev, video, s_std, dev->tvnorm);
 		fe->ops.tuner_ops.set_analog_params(fe, &params);
 	}
 	else
diff --git a/drivers/media/pci/cx88/cx88-core.c b/drivers/media/pci/cx88/cx88-core.c
index ad59dc9..e061c88 100644
--- a/drivers/media/pci/cx88/cx88-core.c
+++ b/drivers/media/pci/cx88/cx88-core.c
@@ -1012,7 +1012,7 @@ int cx88_set_tvnorm(struct cx88_core *core, v4l2_std_id norm)
 	set_tvaudio(core);
 
 	// tell i2c chips
-	call_all(core, core, s_std, norm);
+	call_all(core, video, s_std, norm);
 
 	/* The chroma_agc control should be inaccessible if the video format is SECAM */
 	v4l2_ctrl_grab(core->chroma_agc, cxiformat == VideoFormatSECAM);
diff --git a/drivers/media/pci/ivtv/ivtv-fileops.c b/drivers/media/pci/ivtv/ivtv-fileops.c
index 9caffd8..e5ff627 100644
--- a/drivers/media/pci/ivtv/ivtv-fileops.c
+++ b/drivers/media/pci/ivtv/ivtv-fileops.c
@@ -894,7 +894,7 @@ int ivtv_v4l2_close(struct file *filp)
 		/* Mark that the radio is no longer in use */
 		clear_bit(IVTV_F_I_RADIO_USER, &itv->i_flags);
 		/* Switch tuner to TV */
-		ivtv_call_all(itv, core, s_std, itv->std);
+		ivtv_call_all(itv, video, s_std, itv->std);
 		/* Select correct audio input (i.e. TV tuner or Line in) */
 		ivtv_audio_set_io(itv);
 		if (itv->hw_flags & IVTV_HW_SAA711X) {
diff --git a/drivers/media/pci/ivtv/ivtv-ioctl.c b/drivers/media/pci/ivtv/ivtv-ioctl.c
index 807b275..b3667a0 100644
--- a/drivers/media/pci/ivtv/ivtv-ioctl.c
+++ b/drivers/media/pci/ivtv/ivtv-ioctl.c
@@ -1090,7 +1090,7 @@ void ivtv_s_std_enc(struct ivtv *itv, v4l2_std_id std)
 		itv->vbi.sliced_decoder_line_size = itv->is_60hz ? 272 : 284;
 
 	/* Tuner */
-	ivtv_call_all(itv, core, s_std, itv->std);
+	ivtv_call_all(itv, video, s_std, itv->std);
 }
 
 void ivtv_s_std_dec(struct ivtv *itv, v4l2_std_id std)
diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index eb472b5..26082b4 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -506,10 +506,10 @@ void saa7134_set_tvnorm_hw(struct saa7134_dev *dev)
 	saa7134_set_decoder(dev);
 
 	if (card_in(dev, dev->ctl_input).tv)
-		saa_call_all(dev, core, s_std, dev->tvnorm->id);
+		saa_call_all(dev, video, s_std, dev->tvnorm->id);
 	/* Set the correct norm for the saa6752hs. This function
 	   does nothing if there is no saa6752hs. */
-	saa_call_empress(dev, core, s_std, dev->tvnorm->id);
+	saa_call_empress(dev, video, s_std, dev->tvnorm->id);
 }
 
 static void set_h_prescale(struct saa7134_dev *dev, int task, int prescale)
diff --git a/drivers/media/pci/saa7146/mxb.c b/drivers/media/pci/saa7146/mxb.c
index 33abe33..c4c8fce 100644
--- a/drivers/media/pci/saa7146/mxb.c
+++ b/drivers/media/pci/saa7146/mxb.c
@@ -357,7 +357,7 @@ static int mxb_init_done(struct saa7146_dev* dev)
 	tea6420_route(mxb, 6);
 
 	/* select video mode in saa7111a */
-	saa7111a_call(mxb, core, s_std, std);
+	saa7111a_call(mxb, video, s_std, std);
 
 	/* select tuner-output on saa7111a */
 	i = 0;
@@ -379,8 +379,8 @@ static int mxb_init_done(struct saa7146_dev* dev)
 	/* These two gpio calls set the GPIO pins that control the tda9820 */
 	saa7146_write(dev, GPIO_CTRL, 0x00404050);
 	saa7111a_call(mxb, core, s_gpio, 1);
-	saa7111a_call(mxb, core, s_std, std);
-	tuner_call(mxb, core, s_std, std);
+	saa7111a_call(mxb, video, s_std, std);
+	tuner_call(mxb, video, s_std, std);
 
 	/* switch to tuner-channel on tea6415c */
 	tea6415c_call(mxb, video, s_routing, 3, 17, 0);
@@ -771,9 +771,9 @@ static int std_callback(struct saa7146_dev *dev, struct saa7146_standard *standa
 		/* These two gpio calls set the GPIO pins that control the tda9820 */
 		saa7146_write(dev, GPIO_CTRL, 0x00404050);
 		saa7111a_call(mxb, core, s_gpio, 0);
-		saa7111a_call(mxb, core, s_std, std);
+		saa7111a_call(mxb, video, s_std, std);
 		if (mxb->cur_input == 0)
-			tuner_call(mxb, core, s_std, std);
+			tuner_call(mxb, video, s_std, std);
 	} else {
 		v4l2_std_id std = V4L2_STD_PAL_BG;
 
@@ -783,9 +783,9 @@ static int std_callback(struct saa7146_dev *dev, struct saa7146_standard *standa
 		/* These two gpio calls set the GPIO pins that control the tda9820 */
 		saa7146_write(dev, GPIO_CTRL, 0x00404050);
 		saa7111a_call(mxb, core, s_gpio, 1);
-		saa7111a_call(mxb, core, s_std, std);
+		saa7111a_call(mxb, video, s_std, std);
 		if (mxb->cur_input == 0)
-			tuner_call(mxb, core, s_std, std);
+			tuner_call(mxb, video, s_std, std);
 	}
 	return 0;
 }
diff --git a/drivers/media/pci/sta2x11/sta2x11_vip.c b/drivers/media/pci/sta2x11/sta2x11_vip.c
index 7559951..d2abd3b 100644
--- a/drivers/media/pci/sta2x11/sta2x11_vip.c
+++ b/drivers/media/pci/sta2x11/sta2x11_vip.c
@@ -444,7 +444,7 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id std)
 	int status;
 
 	if (V4L2_STD_ALL == std) {
-		v4l2_subdev_call(vip->decoder, core, s_std, std);
+		v4l2_subdev_call(vip->decoder, video, s_std, std);
 		ssleep(2);
 		v4l2_subdev_call(vip->decoder, video, querystd, &newstd);
 		v4l2_subdev_call(vip->decoder, video, g_input_status, &status);
@@ -467,7 +467,7 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id std)
 			vip->format = formats_50[0];
 	}
 
-	return v4l2_subdev_call(vip->decoder, core, s_std, std);
+	return v4l2_subdev_call(vip->decoder, video, s_std, std);
 }
 
 /**
diff --git a/drivers/media/pci/zoran/zoran_device.c b/drivers/media/pci/zoran/zoran_device.c
index 519164c..bf34b93 100644
--- a/drivers/media/pci/zoran/zoran_device.c
+++ b/drivers/media/pci/zoran/zoran_device.c
@@ -1572,7 +1572,7 @@ zoran_init_hardware (struct zoran *zr)
 	}
 
 	decoder_call(zr, core, init, 0);
-	decoder_call(zr, core, s_std, zr->norm);
+	decoder_call(zr, video, s_std, zr->norm);
 	decoder_call(zr, video, s_routing,
 		zr->card.input[zr->input].muxsel, 0, 0);
 
diff --git a/drivers/media/pci/zoran/zoran_driver.c b/drivers/media/pci/zoran/zoran_driver.c
index e7e9840..099d5fb 100644
--- a/drivers/media/pci/zoran/zoran_driver.c
+++ b/drivers/media/pci/zoran/zoran_driver.c
@@ -1469,7 +1469,7 @@ zoran_set_norm (struct zoran *zr,
 	if (on)
 		zr36057_overlay(zr, 0);
 
-	decoder_call(zr, core, s_std, norm);
+	decoder_call(zr, video, s_std, norm);
 	encoder_call(zr, video, s_std_output, norm);
 
 	if (on)
diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
index 16f643c..cf3d94f 100644
--- a/drivers/media/platform/blackfin/bfin_capture.c
+++ b/drivers/media/platform/blackfin/bfin_capture.c
@@ -631,7 +631,7 @@ static int bcap_s_std(struct file *file, void *priv, v4l2_std_id std)
 	if (vb2_is_busy(&bcap_dev->buffer_queue))
 		return -EBUSY;
 
-	ret = v4l2_subdev_call(bcap_dev->sd, core, s_std, std);
+	ret = v4l2_subdev_call(bcap_dev->sd, video, s_std, std);
 	if (ret < 0)
 		return ret;
 
@@ -1065,7 +1065,7 @@ static int bcap_probe(struct platform_device *pdev)
 	/* now we can probe the default state */
 	if (config->inputs[0].capabilities & V4L2_IN_CAP_STD) {
 		v4l2_std_id std;
-		ret = v4l2_subdev_call(bcap_dev->sd, core, g_std, &std);
+		ret = v4l2_subdev_call(bcap_dev->sd, video, g_std, &std);
 		if (ret) {
 			v4l2_err(&bcap_dev->v4l2_dev,
 					"Unable to get std\n");
diff --git a/drivers/media/platform/davinci/vpfe_capture.c b/drivers/media/platform/davinci/vpfe_capture.c
index ac6c8c6..a51bda2 100644
--- a/drivers/media/platform/davinci/vpfe_capture.c
+++ b/drivers/media/platform/davinci/vpfe_capture.c
@@ -1217,7 +1217,7 @@ static int vpfe_s_std(struct file *file, void *priv, v4l2_std_id std_id)
 	}
 
 	ret = v4l2_device_call_until_err(&vpfe_dev->v4l2_dev, sdinfo->grp_id,
-					 core, s_std, std_id);
+					 video, s_std, std_id);
 	if (ret < 0) {
 		v4l2_err(&vpfe_dev->v4l2_dev, "Failed to set standard\n");
 		goto unlock_out;
diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index d09a27a..98ae30a 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -1430,7 +1430,7 @@ static int vpif_s_std(struct file *file, void *priv, v4l2_std_id std_id)
 	vpif_config_format(ch);
 
 	/* set standard in the sub device */
-	ret = v4l2_subdev_call(ch->sd, core, s_std, std_id);
+	ret = v4l2_subdev_call(ch->sd, video, s_std, std_id);
 	if (ret && ret != -ENOIOCTLCMD && ret != -ENODEV) {
 		vpif_dbg(1, debug, "Failed to set standard for sub devices\n");
 		return ret;
diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index d03487f..905bc1a 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -1085,7 +1085,7 @@ static int vpif_s_std(struct file *file, void *priv, v4l2_std_id std_id)
 		return ret;
 	}
 
-	ret = v4l2_device_call_until_err(&vpif_obj.v4l2_dev, 1, core,
+	ret = v4l2_device_call_until_err(&vpif_obj.v4l2_dev, 1, video,
 							s_std, std_id);
 	if (ret < 0)
 		vpif_err("Failed to set standard for sub devices\n");
diff --git a/drivers/media/platform/fsl-viu.c b/drivers/media/platform/fsl-viu.c
index dbf0ce3..d5dc198 100644
--- a/drivers/media/platform/fsl-viu.c
+++ b/drivers/media/platform/fsl-viu.c
@@ -964,7 +964,7 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id id)
 	struct viu_fh *fh = priv;
 
 	fh->dev->std = id;
-	decoder_call(fh->dev, core, s_std, id);
+	decoder_call(fh->dev, video, s_std, id);
 	return 0;
 }
 
diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index 4b8c024..79bfbc6 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -314,7 +314,7 @@ static int soc_camera_s_std(struct file *file, void *priv, v4l2_std_id a)
 	struct soc_camera_device *icd = file->private_data;
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 
-	return v4l2_subdev_call(sd, core, s_std, a);
+	return v4l2_subdev_call(sd, video, s_std, a);
 }
 
 static int soc_camera_g_std(struct file *file, void *priv, v4l2_std_id *a)
@@ -322,7 +322,7 @@ static int soc_camera_g_std(struct file *file, void *priv, v4l2_std_id *a)
 	struct soc_camera_device *icd = file->private_data;
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 
-	return v4l2_subdev_call(sd, core, g_std, a);
+	return v4l2_subdev_call(sd, video, g_std, a);
 }
 
 static int soc_camera_enum_framesizes(struct file *file, void *fh,
diff --git a/drivers/media/platform/timblogiw.c b/drivers/media/platform/timblogiw.c
index ccdadd6..cc34eae 100644
--- a/drivers/media/platform/timblogiw.c
+++ b/drivers/media/platform/timblogiw.c
@@ -347,7 +347,7 @@ static int timblogiw_s_std(struct file *file, void  *priv, v4l2_std_id std)
 	mutex_lock(&lw->lock);
 
 	if (TIMBLOGIW_HAS_DECODER(lw))
-		err = v4l2_subdev_call(lw->sd_enc, core, s_std, std);
+		err = v4l2_subdev_call(lw->sd_enc, video, s_std, std);
 
 	if (!err)
 		fh->cur_norm = timblogiw_get_norm(std);
diff --git a/drivers/media/platform/vino.c b/drivers/media/platform/vino.c
index c6af974..470d353 100644
--- a/drivers/media/platform/vino.c
+++ b/drivers/media/platform/vino.c
@@ -2586,7 +2586,7 @@ static int vino_acquire_input(struct vino_channel_settings *vcs)
 			}
 			if (data_norm == 3)
 				data_norm = VINO_DATA_NORM_PAL;
-			ret = decoder_call(core, s_std, norm);
+			ret = decoder_call(video, s_std, norm);
 		}
 
 		spin_lock_irqsave(&vino_drvdata->input_lock, flags);
@@ -2675,7 +2675,7 @@ static int vino_set_input(struct vino_channel_settings *vcs, int input)
 				}
 				if (data_norm == 3)
 					data_norm = VINO_DATA_NORM_PAL;
-				ret = decoder_call(core, s_std, norm);
+				ret = decoder_call(video, s_std, norm);
 			}
 
 			spin_lock_irqsave(&vino_drvdata->input_lock, flags);
@@ -2809,7 +2809,7 @@ static int vino_set_data_norm(struct vino_channel_settings *vcs,
 		 * as it may take a while... */
 
 		norm = vino_data_norms[data_norm].std;
-		err = decoder_call(core, s_std, norm);
+		err = decoder_call(video, s_std, norm);
 
 		spin_lock_irqsave(&vino_drvdata->input_lock, *flags);
 
diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index f615454..9038194 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -1109,7 +1109,7 @@ static void au0828_init_tuner(struct au0828_dev *dev)
 	/* If we've never sent the standard in tuner core, do so now.
 	   We don't do this at device probe because we don't want to
 	   incur the cost of a firmware load */
-	v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_std, dev->std);
+	v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_std, dev->std);
 	v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_frequency, &f);
 	i2c_gate_ctrl(dev, 0);
 }
@@ -1368,7 +1368,7 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id norm)
 	   have to make the au0828 bridge adjust the size of its capture
 	   buffer, which is currently hardcoded at 720x480 */
 
-	v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_std, norm);
+	v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_std, norm);
 
 	i2c_gate_ctrl(dev, 0);
 
diff --git a/drivers/media/usb/cx231xx/cx231xx-417.c b/drivers/media/usb/cx231xx/cx231xx-417.c
index 2f63029..30a0c69 100644
--- a/drivers/media/usb/cx231xx/cx231xx-417.c
+++ b/drivers/media/usb/cx231xx/cx231xx-417.c
@@ -1516,7 +1516,7 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id id)
 		dev->ts1.height = 576;
 		cx2341x_handler_set_50hz(&dev->mpeg_ctrl_handler, true);
 	}
-	call_all(dev, core, s_std, dev->norm);
+	call_all(dev, video, s_std, dev->norm);
 	/* do mode control overrides */
 	cx231xx_do_mode_ctrl_overrides(dev);
 
diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
index 9906261..1f87513 100644
--- a/drivers/media/usb/cx231xx/cx231xx-video.c
+++ b/drivers/media/usb/cx231xx/cx231xx-video.c
@@ -1009,7 +1009,7 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id norm)
 	dev->width = 720;
 	dev->height = (dev->norm & V4L2_STD_625_50) ? 576 : 480;
 
-	call_all(dev, core, s_std, dev->norm);
+	call_all(dev, video, s_std, dev->norm);
 
 	/* We need to reset basic properties in the decoder related to
 	   resolution (since a standard change effects things like the number
@@ -1108,7 +1108,7 @@ int cx231xx_s_input(struct file *file, void *priv, unsigned int i)
 		/* There's a tuner, so reset the standard and put it on the
 		   last known frequency (since it was probably powered down
 		   until now */
-		call_all(dev, core, s_std, dev->norm);
+		call_all(dev, video, s_std, dev->norm);
 	}
 
 	return 0;
@@ -2099,7 +2099,7 @@ int cx231xx_register_analog_devices(struct cx231xx *dev)
 	/* Set the initial input */
 	video_mux(dev, dev->video_input);
 
-	call_all(dev, core, s_std, dev->norm);
+	call_all(dev, video, s_std, dev->norm);
 
 	v4l2_ctrl_handler_init(&dev->ctrl_handler, 10);
 	v4l2_ctrl_handler_init(&dev->radio_ctrl_handler, 5);
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index cdcd751..b5a4d89 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -1347,7 +1347,7 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id norm)
 	size_to_scale(dev, dev->width, dev->height, &dev->hscale, &dev->vscale);
 
 	em28xx_resolution_set(dev);
-	v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_std, dev->norm);
+	v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_std, dev->norm);
 
 	return 0;
 }
@@ -2345,7 +2345,7 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 
 	/* set default norm */
 	dev->norm = V4L2_STD_PAL;
-	v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_std, dev->norm);
+	v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_std, dev->norm);
 	dev->interlaced = EM28XX_INTERLACED_DEFAULT;
 
 	/* Analog specific initialization */
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
index ea05f67..9623b62 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
@@ -2910,7 +2910,7 @@ static void pvr2_subdev_update(struct pvr2_hdw *hdw)
 			v4l2_std_id vs;
 			vs = hdw->std_mask_cur;
 			v4l2_device_call_all(&hdw->v4l2_dev, 0,
-					     core, s_std, vs);
+					     video, s_std, vs);
 			pvr2_hdw_cx25840_vbi_hack(hdw);
 		}
 		hdw->tuner_signal_stale = !0;
diff --git a/drivers/media/usb/stk1160/stk1160-v4l.c b/drivers/media/usb/stk1160/stk1160-v4l.c
index 46e8a50..5461341 100644
--- a/drivers/media/usb/stk1160/stk1160-v4l.c
+++ b/drivers/media/usb/stk1160/stk1160-v4l.c
@@ -406,7 +406,7 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id norm)
 
 	stk1160_set_std(dev);
 
-	v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_std,
+	v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_std,
 			dev->norm);
 
 	return 0;
@@ -682,7 +682,7 @@ int stk1160_video_register(struct stk1160 *dev)
 	dev->fmt = &format[0];
 	stk1160_set_std(dev);
 
-	v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_std,
+	v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_std,
 			dev->norm);
 
 	video_set_drvdata(&dev->vdev, dev);
diff --git a/drivers/media/usb/tm6000/tm6000-cards.c b/drivers/media/usb/tm6000/tm6000-cards.c
index 1ccaadd..2e8c3af 100644
--- a/drivers/media/usb/tm6000/tm6000-cards.c
+++ b/drivers/media/usb/tm6000/tm6000-cards.c
@@ -1120,7 +1120,7 @@ static int tm6000_init_dev(struct tm6000_core *dev)
 	tm6000_config_tuner(dev);
 
 	/* Set video standard */
-	v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_std, dev->norm);
+	v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_std, dev->norm);
 
 	/* Set tuner frequency - also loads firmware on xc2028/xc3028 */
 	f.tuner = 0;
diff --git a/drivers/media/usb/tm6000/tm6000-video.c b/drivers/media/usb/tm6000/tm6000-video.c
index cc1aa14..e6b3d5d 100644
--- a/drivers/media/usb/tm6000/tm6000-video.c
+++ b/drivers/media/usb/tm6000/tm6000-video.c
@@ -1071,7 +1071,7 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id norm)
 	if (rc < 0)
 		return rc;
 
-	v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_std, dev->norm);
+	v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_std, dev->norm);
 
 	return 0;
 }
diff --git a/drivers/media/usb/usbvision/usbvision-video.c b/drivers/media/usb/usbvision/usbvision-video.c
index 5c9e312..68bc961 100644
--- a/drivers/media/usb/usbvision/usbvision-video.c
+++ b/drivers/media/usb/usbvision/usbvision-video.c
@@ -597,7 +597,7 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id id)
 
 	usbvision->tvnorm_id = id;
 
-	call_all(usbvision, core, s_std, usbvision->tvnorm_id);
+	call_all(usbvision, video, s_std, usbvision->tvnorm_id);
 	/* propagate the change to the decoder */
 	usbvision_muxsel(usbvision, usbvision->ctl_input);
 
diff --git a/drivers/media/v4l2-core/tuner-core.c b/drivers/media/v4l2-core/tuner-core.c
index 20c0922..06c18ba 100644
--- a/drivers/media/v4l2-core/tuner-core.c
+++ b/drivers/media/v4l2-core/tuner-core.c
@@ -1301,7 +1301,6 @@ static int tuner_command(struct i2c_client *client, unsigned cmd, void *arg)
 
 static const struct v4l2_subdev_core_ops tuner_core_ops = {
 	.log_status = tuner_log_status,
-	.s_std = tuner_s_std,
 	.s_power = tuner_s_power,
 };
 
@@ -1315,9 +1314,14 @@ static const struct v4l2_subdev_tuner_ops tuner_tuner_ops = {
 	.s_config = tuner_s_config,
 };
 
+static const struct v4l2_subdev_video_ops tuner_video_ops = {
+	.s_std = tuner_s_std,
+};
+
 static const struct v4l2_subdev_ops tuner_ops = {
 	.core = &tuner_core_ops,
 	.tuner = &tuner_tuner_ops,
+	.video = &tuner_video_ops,
 };
 
 /*
diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.c b/drivers/staging/media/davinci_vpfe/vpfe_video.c
index 7b213a7..425e2c8 100644
--- a/drivers/staging/media/davinci_vpfe/vpfe_video.c
+++ b/drivers/staging/media/davinci_vpfe/vpfe_video.c
@@ -944,7 +944,7 @@ static int vpfe_s_std(struct file *file, void *priv, v4l2_std_id std_id)
 		goto unlock_out;
 	}
 	ret = v4l2_device_call_until_err(&vpfe_dev->v4l2_dev, sdinfo->grp_id,
-					 core, s_std, std_id);
+					 video, s_std, std_id);
 	if (ret < 0) {
 		v4l2_err(&vpfe_dev->v4l2_dev, "Failed to set standard\n");
 		video->stdid = V4L2_STD_UNKNOWN;
diff --git a/drivers/staging/media/go7007/go7007-v4l2.c b/drivers/staging/media/go7007/go7007-v4l2.c
index 090b3e6e..da7b549 100644
--- a/drivers/staging/media/go7007/go7007-v4l2.c
+++ b/drivers/staging/media/go7007/go7007-v4l2.c
@@ -665,7 +665,7 @@ static int go7007_s_std(struct go7007 *go)
 		go->sensor_framerate = 30000;
 	}
 
-	call_all(&go->v4l2_dev, core, s_std, go->std);
+	call_all(&go->v4l2_dev, video, s_std, go->std);
 	set_capture_size(go, NULL, 0);
 	return 0;
 }
diff --git a/drivers/staging/media/go7007/s2250-board.c b/drivers/staging/media/go7007/s2250-board.c
index 696a807..eaa2b09 100644
--- a/drivers/staging/media/go7007/s2250-board.c
+++ b/drivers/staging/media/go7007/s2250-board.c
@@ -474,7 +474,6 @@ static const struct v4l2_ctrl_ops s2250_ctrl_ops = {
 
 static const struct v4l2_subdev_core_ops s2250_core_ops = {
 	.log_status = s2250_log_status,
-	.s_std = s2250_s_std,
 };
 
 static const struct v4l2_subdev_audio_ops s2250_audio_ops = {
@@ -482,6 +481,7 @@ static const struct v4l2_subdev_audio_ops s2250_audio_ops = {
 };
 
 static const struct v4l2_subdev_video_ops s2250_video_ops = {
+	.s_std = s2250_s_std,
 	.s_routing = s2250_s_video_routing,
 	.s_mbus_fmt = s2250_s_mbus_fmt,
 };
diff --git a/drivers/staging/media/go7007/saa7134-go7007.c b/drivers/staging/media/go7007/saa7134-go7007.c
index 6e2ca33..e40f7fb 100644
--- a/drivers/staging/media/go7007/saa7134-go7007.c
+++ b/drivers/staging/media/go7007/saa7134-go7007.c
@@ -434,11 +434,15 @@ static const struct v4l2_subdev_core_ops saa7134_go7007_core_ops = {
 	.g_ctrl = saa7134_go7007_g_ctrl,
 	.s_ctrl = saa7134_go7007_s_ctrl,
 	.queryctrl = saa7134_go7007_queryctrl,
+};
+
+static const struct v4l2_subdev_video_ops saa7134_go7007_video_ops = {
 	.s_std = saa7134_go7007_s_std,
 };
 
 static const struct v4l2_subdev_ops saa7134_go7007_sd_ops = {
 	.core = &saa7134_go7007_core_ops,
+	.video = &saa7134_go7007_video_ops,
 };
 
 /* --------------------------------------------------------------------------*/
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index ee1cb2d..2f1ca53 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -159,8 +159,6 @@ struct v4l2_subdev_core_ops {
 	int (*s_ext_ctrls)(struct v4l2_subdev *sd, struct v4l2_ext_controls *ctrls);
 	int (*try_ext_ctrls)(struct v4l2_subdev *sd, struct v4l2_ext_controls *ctrls);
 	int (*querymenu)(struct v4l2_subdev *sd, struct v4l2_querymenu *qm);
-	int (*g_std)(struct v4l2_subdev *sd, v4l2_std_id *norm);
-	int (*s_std)(struct v4l2_subdev *sd, v4l2_std_id norm);
 	long (*ioctl)(struct v4l2_subdev *sd, unsigned int cmd, void *arg);
 #ifdef CONFIG_COMPAT
 	long (*compat_ioctl32)(struct v4l2_subdev *sd, unsigned int cmd,
@@ -310,6 +308,8 @@ struct v4l2_mbus_frame_desc {
 struct v4l2_subdev_video_ops {
 	int (*s_routing)(struct v4l2_subdev *sd, u32 input, u32 output, u32 config);
 	int (*s_crystal_freq)(struct v4l2_subdev *sd, u32 freq, u32 flags);
+	int (*g_std)(struct v4l2_subdev *sd, v4l2_std_id *norm);
+	int (*s_std)(struct v4l2_subdev *sd, v4l2_std_id norm);
 	int (*s_std_output)(struct v4l2_subdev *sd, v4l2_std_id std);
 	int (*g_std_output)(struct v4l2_subdev *sd, v4l2_std_id *std);
 	int (*querystd)(struct v4l2_subdev *sd, v4l2_std_id *std);
@@ -685,7 +685,7 @@ void v4l2_subdev_init(struct v4l2_subdev *sd,
 /* Call an ops of a v4l2_subdev, doing the right checks against
    NULL pointers.
 
-   Example: err = v4l2_subdev_call(sd, core, s_std, norm);
+   Example: err = v4l2_subdev_call(sd, video, s_std, norm);
  */
 #define v4l2_subdev_call(sd, o, f, args...)				\
 	(!(sd) ? -ENODEV : (((sd)->ops->o && (sd)->ops->o->f) ?	\
-- 
Regards,

Laurent Pinchart


