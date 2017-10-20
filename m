Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:47008 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752897AbdJTVua (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Oct 2017 17:50:30 -0400
From: Gustavo Padovan <gustavo@padovan.org>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Brian Starkey <brian.starkey@arm.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: [RFC v4 02/17] [media] v4l: use v4l2_subscribe_event_v4l2() on vtables
Date: Fri, 20 Oct 2017 19:49:57 -0200
Message-Id: <20171020215012.20646-3-gustavo@padovan.org>
In-Reply-To: <20171020215012.20646-1-gustavo@padovan.org>
References: <20171020215012.20646-1-gustavo@padovan.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Gustavo Padovan <gustavo.padovan@collabora.com>

In all places that we were calling v4l2_ctrl_subscribe event() we now call
v4l2_subscribe_event_v4l2() that embed v4l2_ctrl_subscribe event() and can
be expanded to support more events.

Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
---
 drivers/media/common/saa7146/saa7146_video.c                  | 4 ++--
 drivers/media/dvb-frontends/rtl2832_sdr.c                     | 2 +-
 drivers/media/pci/bt8xx/bttv-driver.c                         | 4 ++--
 drivers/media/pci/cx18/cx18-ioctl.c                           | 2 +-
 drivers/media/pci/cx23885/cx23885-video.c                     | 2 +-
 drivers/media/pci/cx25821/cx25821-video.c                     | 2 +-
 drivers/media/pci/cx88/cx88-blackbird.c                       | 2 +-
 drivers/media/pci/cx88/cx88-video.c                           | 4 ++--
 drivers/media/pci/meye/meye.c                                 | 2 +-
 drivers/media/pci/saa7134/saa7134-empress.c                   | 2 +-
 drivers/media/pci/saa7134/saa7134-video.c                     | 4 ++--
 drivers/media/pci/saa7164/saa7164-encoder.c                   | 2 +-
 drivers/media/pci/solo6x10/solo6x10-v4l2.c                    | 2 +-
 drivers/media/pci/sta2x11/sta2x11_vip.c                       | 2 +-
 drivers/media/pci/tw68/tw68-video.c                           | 2 +-
 drivers/media/pci/tw686x/tw686x-video.c                       | 2 +-
 drivers/media/pci/zoran/zoran_driver.c                        | 2 +-
 drivers/media/platform/am437x/am437x-vpfe.c                   | 2 +-
 drivers/media/platform/atmel/atmel-isc.c                      | 2 +-
 drivers/media/platform/atmel/atmel-isi.c                      | 2 +-
 drivers/media/platform/fsl-viu.c                              | 2 +-
 drivers/media/platform/marvell-ccic/mcam-core.c               | 2 +-
 drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c                  | 2 +-
 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c            | 2 +-
 drivers/media/platform/pxa_camera.c                           | 2 +-
 drivers/media/platform/qcom/venus/venc.c                      | 2 +-
 drivers/media/platform/rcar_drif.c                            | 2 +-
 drivers/media/platform/rcar_fdp1.c                            | 2 +-
 drivers/media/platform/rcar_jpu.c                             | 2 +-
 drivers/media/platform/s3c-camif/camif-capture.c              | 2 +-
 drivers/media/platform/sti/bdisp/bdisp-v4l2.c                 | 2 +-
 drivers/media/platform/sti/hva/hva-v4l2.c                     | 2 +-
 drivers/media/platform/stm32/stm32-dcmi.c                     | 2 +-
 drivers/media/platform/ti-vpe/cal.c                           | 2 +-
 drivers/media/platform/ti-vpe/vpe.c                           | 2 +-
 drivers/media/platform/vim2m.c                                | 2 +-
 drivers/media/radio/dsbr100.c                                 | 2 +-
 drivers/media/radio/radio-cadet.c                             | 2 +-
 drivers/media/radio/radio-isa.c                               | 2 +-
 drivers/media/radio/radio-keene.c                             | 2 +-
 drivers/media/radio/radio-ma901.c                             | 2 +-
 drivers/media/radio/radio-miropcm20.c                         | 2 +-
 drivers/media/radio/radio-mr800.c                             | 2 +-
 drivers/media/radio/radio-sf16fmi.c                           | 2 +-
 drivers/media/radio/radio-si476x.c                            | 2 +-
 drivers/media/radio/radio-tea5764.c                           | 2 +-
 drivers/media/radio/radio-tea5777.c                           | 2 +-
 drivers/media/radio/radio-timb.c                              | 2 +-
 drivers/media/radio/si470x/radio-si470x-common.c              | 2 +-
 drivers/media/radio/si4713/radio-platform-si4713.c            | 2 +-
 drivers/media/radio/si4713/radio-usb-si4713.c                 | 2 +-
 drivers/media/radio/tea575x.c                                 | 2 +-
 drivers/media/usb/airspy/airspy.c                             | 2 +-
 drivers/media/usb/au0828/au0828-video.c                       | 2 +-
 drivers/media/usb/cpia2/cpia2_v4l.c                           | 2 +-
 drivers/media/usb/cx231xx/cx231xx-417.c                       | 2 +-
 drivers/media/usb/cx231xx/cx231xx-video.c                     | 4 ++--
 drivers/media/usb/em28xx/em28xx-video.c                       | 4 ++--
 drivers/media/usb/gspca/gspca.c                               | 2 +-
 drivers/media/usb/hackrf/hackrf.c                             | 2 +-
 drivers/media/usb/hdpvr/hdpvr-video.c                         | 2 +-
 drivers/media/usb/msi2500/msi2500.c                           | 2 +-
 drivers/media/usb/pwc/pwc-v4l.c                               | 2 +-
 drivers/media/usb/s2255/s2255drv.c                            | 2 +-
 drivers/media/usb/stk1160/stk1160-v4l.c                       | 2 +-
 drivers/media/usb/stkwebcam/stk-webcam.c                      | 2 +-
 drivers/media/usb/tm6000/tm6000-video.c                       | 4 ++--
 drivers/media/usb/usbvision/usbvision-video.c                 | 4 ++--
 drivers/media/usb/zr364xx/zr364xx.c                           | 2 +-
 drivers/staging/vc04_services/bcm2835-camera/bcm2835-camera.c | 2 +-
 samples/v4l/v4l2-pci-skeleton.c                               | 2 +-
 71 files changed, 79 insertions(+), 79 deletions(-)

diff --git a/drivers/media/common/saa7146/saa7146_video.c b/drivers/media/common/saa7146/saa7146_video.c
index 51eeed830de4..a2b692e84530 100644
--- a/drivers/media/common/saa7146/saa7146_video.c
+++ b/drivers/media/common/saa7146/saa7146_video.c
@@ -1014,7 +1014,7 @@ const struct v4l2_ioctl_ops saa7146_video_ioctl_ops = {
 	.vidioc_streamon             = vidioc_streamon,
 	.vidioc_streamoff            = vidioc_streamoff,
 	.vidioc_g_parm 		     = vidioc_g_parm,
-	.vidioc_subscribe_event      = v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event	     = v4l2_subscribe_event_v4l2,
 	.vidioc_unsubscribe_event    = v4l2_event_unsubscribe,
 };
 
@@ -1031,7 +1031,7 @@ const struct v4l2_ioctl_ops saa7146_vbi_ioctl_ops = {
 	.vidioc_streamon             = vidioc_streamon,
 	.vidioc_streamoff            = vidioc_streamoff,
 	.vidioc_g_parm		     = vidioc_g_parm,
-	.vidioc_subscribe_event      = v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event	     = v4l2_subscribe_event_v4l2,
 	.vidioc_unsubscribe_event    = v4l2_event_unsubscribe,
 };
 
diff --git a/drivers/media/dvb-frontends/rtl2832_sdr.c b/drivers/media/dvb-frontends/rtl2832_sdr.c
index c6e78d870ccd..2af05249b65c 100644
--- a/drivers/media/dvb-frontends/rtl2832_sdr.c
+++ b/drivers/media/dvb-frontends/rtl2832_sdr.c
@@ -1236,7 +1236,7 @@ static const struct v4l2_ioctl_ops rtl2832_sdr_ioctl_ops = {
 	.vidioc_g_frequency       = rtl2832_sdr_g_frequency,
 	.vidioc_s_frequency       = rtl2832_sdr_s_frequency,
 
-	.vidioc_subscribe_event   = v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event	  = v4l2_subscribe_event_v4l2,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 	.vidioc_log_status        = v4l2_ctrl_log_status,
 };
diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index 227086a2e99c..718be81a20f6 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -3187,7 +3187,7 @@ static const struct v4l2_ioctl_ops bttv_ioctl_ops = {
 	.vidioc_s_frequency             = bttv_s_frequency,
 	.vidioc_log_status		= bttv_log_status,
 	.vidioc_querystd		= bttv_querystd,
-	.vidioc_subscribe_event		= v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event		= v4l2_subscribe_event_v4l2,
 	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.vidioc_g_register		= bttv_g_register,
@@ -3369,7 +3369,7 @@ static const struct v4l2_ioctl_ops radio_ioctl_ops = {
 	.vidioc_s_frequency     = bttv_s_frequency,
 	.vidioc_s_hw_freq_seek	= radio_s_hw_freq_seek,
 	.vidioc_enum_freq_bands	= radio_enum_freq_bands,
-	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event = v4l2_subscribe_event_v4l2,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
diff --git a/drivers/media/pci/cx18/cx18-ioctl.c b/drivers/media/pci/cx18/cx18-ioctl.c
index 80b902b12a78..b0f1dcf9b508 100644
--- a/drivers/media/pci/cx18/cx18-ioctl.c
+++ b/drivers/media/pci/cx18/cx18-ioctl.c
@@ -1115,7 +1115,7 @@ static const struct v4l2_ioctl_ops cx18_ioctl_ops = {
 	.vidioc_querybuf                = cx18_querybuf,
 	.vidioc_qbuf                    = cx18_qbuf,
 	.vidioc_dqbuf                   = cx18_dqbuf,
-	.vidioc_subscribe_event		= v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event		= v4l2_subscribe_event_v4l2,
 	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
 };
 
diff --git a/drivers/media/pci/cx23885/cx23885-video.c b/drivers/media/pci/cx23885/cx23885-video.c
index ecc580af0148..940bbae9b284 100644
--- a/drivers/media/pci/cx23885/cx23885-video.c
+++ b/drivers/media/pci/cx23885/cx23885-video.c
@@ -1138,7 +1138,7 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_enumaudio     = vidioc_enum_audinput,
 	.vidioc_g_audio       = vidioc_g_audinput,
 	.vidioc_s_audio       = vidioc_s_audinput,
-	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event = v4l2_subscribe_event_v4l2,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
diff --git a/drivers/media/pci/cx25821/cx25821-video.c b/drivers/media/pci/cx25821/cx25821-video.c
index dbaf42ec26cd..9802ae365b08 100644
--- a/drivers/media/pci/cx25821/cx25821-video.c
+++ b/drivers/media/pci/cx25821/cx25821-video.c
@@ -624,7 +624,7 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_g_input = cx25821_vidioc_g_input,
 	.vidioc_s_input = cx25821_vidioc_s_input,
 	.vidioc_log_status = vidioc_log_status,
-	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event = v4l2_subscribe_event_v4l2,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
diff --git a/drivers/media/pci/cx88/cx88-blackbird.c b/drivers/media/pci/cx88/cx88-blackbird.c
index e3101f04941c..3837f80ea1d5 100644
--- a/drivers/media/pci/cx88/cx88-blackbird.c
+++ b/drivers/media/pci/cx88/cx88-blackbird.c
@@ -1071,7 +1071,7 @@ static const struct v4l2_ioctl_ops mpeg_ioctl_ops = {
 	.vidioc_s_tuner       = vidioc_s_tuner,
 	.vidioc_g_std         = vidioc_g_std,
 	.vidioc_s_std         = vidioc_s_std,
-	.vidioc_subscribe_event      = v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event	     = v4l2_subscribe_event_v4l2,
 	.vidioc_unsubscribe_event    = v4l2_event_unsubscribe,
 };
 
diff --git a/drivers/media/pci/cx88/cx88-video.c b/drivers/media/pci/cx88/cx88-video.c
index 7d25ecd4404b..64f6f18850fa 100644
--- a/drivers/media/pci/cx88/cx88-video.c
+++ b/drivers/media/pci/cx88/cx88-video.c
@@ -1195,7 +1195,7 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_s_tuner       = vidioc_s_tuner,
 	.vidioc_g_frequency   = vidioc_g_frequency,
 	.vidioc_s_frequency   = vidioc_s_frequency,
-	.vidioc_subscribe_event      = v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event      = v4l2_subscribe_event_v4l2,
 	.vidioc_unsubscribe_event    = v4l2_event_unsubscribe,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.vidioc_g_register    = vidioc_g_register,
@@ -1257,7 +1257,7 @@ static const struct v4l2_ioctl_ops radio_ioctl_ops = {
 	.vidioc_s_tuner       = radio_s_tuner,
 	.vidioc_g_frequency   = vidioc_g_frequency,
 	.vidioc_s_frequency   = vidioc_s_frequency,
-	.vidioc_subscribe_event      = v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event      = v4l2_subscribe_event_v4l2,
 	.vidioc_unsubscribe_event    = v4l2_event_unsubscribe,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.vidioc_g_register    = vidioc_g_register,
diff --git a/drivers/media/pci/meye/meye.c b/drivers/media/pci/meye/meye.c
index 23999a8cef37..2ba588ca5ffa 100644
--- a/drivers/media/pci/meye/meye.c
+++ b/drivers/media/pci/meye/meye.c
@@ -1528,7 +1528,7 @@ static const struct v4l2_ioctl_ops meye_ioctl_ops = {
 	.vidioc_streamon	= vidioc_streamon,
 	.vidioc_streamoff	= vidioc_streamoff,
 	.vidioc_log_status	= v4l2_ctrl_log_status,
-	.vidioc_subscribe_event	= v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event = v4l2_subscribe_event_v4l2,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 	.vidioc_default		= vidioc_default,
 };
diff --git a/drivers/media/pci/saa7134/saa7134-empress.c b/drivers/media/pci/saa7134/saa7134-empress.c
index 66acfd35ffc6..72f84cb8b809 100644
--- a/drivers/media/pci/saa7134/saa7134-empress.c
+++ b/drivers/media/pci/saa7134/saa7134-empress.c
@@ -199,7 +199,7 @@ static const struct v4l2_ioctl_ops ts_ioctl_ops = {
 	.vidioc_g_std			= saa7134_g_std,
 	.vidioc_querystd		= saa7134_querystd,
 	.vidioc_log_status		= v4l2_ctrl_log_status,
-	.vidioc_subscribe_event		= v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event		= v4l2_subscribe_event_v4l2,
 	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
 };
 
diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index 51d42bbf969e..fbe3424d16ad 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -2012,7 +2012,7 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_s_register              = vidioc_s_register,
 #endif
 	.vidioc_log_status		= v4l2_ctrl_log_status,
-	.vidioc_subscribe_event		= v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event		= v4l2_subscribe_event_v4l2,
 	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
 };
 
@@ -2031,7 +2031,7 @@ static const struct v4l2_ioctl_ops radio_ioctl_ops = {
 	.vidioc_s_tuner		= radio_s_tuner,
 	.vidioc_g_frequency	= saa7134_g_frequency,
 	.vidioc_s_frequency	= saa7134_s_frequency,
-	.vidioc_subscribe_event	= v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event	= v4l2_subscribe_event_v4l2,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
diff --git a/drivers/media/pci/saa7164/saa7164-encoder.c b/drivers/media/pci/saa7164/saa7164-encoder.c
index f21c245a54f7..0009a1132db4 100644
--- a/drivers/media/pci/saa7164/saa7164-encoder.c
+++ b/drivers/media/pci/saa7164/saa7164-encoder.c
@@ -973,7 +973,7 @@ static const struct v4l2_ioctl_ops mpeg_ioctl_ops = {
 	.vidioc_try_fmt_vid_cap	 = vidioc_fmt_vid_cap,
 	.vidioc_s_fmt_vid_cap	 = vidioc_fmt_vid_cap,
 	.vidioc_log_status	 = v4l2_ctrl_log_status,
-	.vidioc_subscribe_event  = v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event	 = v4l2_subscribe_event_v4l2,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
diff --git a/drivers/media/pci/solo6x10/solo6x10-v4l2.c b/drivers/media/pci/solo6x10/solo6x10-v4l2.c
index 99ffd1ed4a73..5f8b5979ed39 100644
--- a/drivers/media/pci/solo6x10/solo6x10-v4l2.c
+++ b/drivers/media/pci/solo6x10/solo6x10-v4l2.c
@@ -626,7 +626,7 @@ static const struct v4l2_ioctl_ops solo_v4l2_ioctl_ops = {
 	.vidioc_streamoff		= vb2_ioctl_streamoff,
 	/* Logging and events */
 	.vidioc_log_status		= v4l2_ctrl_log_status,
-	.vidioc_subscribe_event		= v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event		= v4l2_subscribe_event_v4l2,
 	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
 };
 
diff --git a/drivers/media/pci/sta2x11/sta2x11_vip.c b/drivers/media/pci/sta2x11/sta2x11_vip.c
index eb5a9eae7c8e..33e03dfa62c6 100644
--- a/drivers/media/pci/sta2x11/sta2x11_vip.c
+++ b/drivers/media/pci/sta2x11/sta2x11_vip.c
@@ -750,7 +750,7 @@ static const struct v4l2_ioctl_ops vip_ioctl_ops = {
 	/* Log status ioctl */
 	.vidioc_log_status = v4l2_ctrl_log_status,
 	/* Event handling */
-	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event = v4l2_subscribe_event_v4l2,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
diff --git a/drivers/media/pci/tw68/tw68-video.c b/drivers/media/pci/tw68/tw68-video.c
index 8c1f4a049764..8b47a49e3e2c 100644
--- a/drivers/media/pci/tw68/tw68-video.c
+++ b/drivers/media/pci/tw68/tw68-video.c
@@ -908,7 +908,7 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_try_fmt_vid_cap		= tw68_try_fmt_vid_cap,
 	.vidioc_s_fmt_vid_cap		= tw68_s_fmt_vid_cap,
 	.vidioc_log_status		= vidioc_log_status,
-	.vidioc_subscribe_event		= v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event		= v4l2_subscribe_event_v4l2,
 	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.vidioc_g_register              = vidioc_g_register,
diff --git a/drivers/media/pci/tw686x/tw686x-video.c b/drivers/media/pci/tw686x/tw686x-video.c
index c3fafa97b2d0..66dd22cc0515 100644
--- a/drivers/media/pci/tw686x/tw686x-video.c
+++ b/drivers/media/pci/tw686x/tw686x-video.c
@@ -1087,7 +1087,7 @@ static const struct v4l2_ioctl_ops tw686x_video_ioctl_ops = {
 	.vidioc_prepare_buf		= vb2_ioctl_prepare_buf,
 
 	.vidioc_log_status		= v4l2_ctrl_log_status,
-	.vidioc_subscribe_event		= v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event		= v4l2_subscribe_event_v4l2,
 	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
 };
 
diff --git a/drivers/media/pci/zoran/zoran_driver.c b/drivers/media/pci/zoran/zoran_driver.c
index a11cb501c550..127030f9a955 100644
--- a/drivers/media/pci/zoran/zoran_driver.c
+++ b/drivers/media/pci/zoran/zoran_driver.c
@@ -2826,7 +2826,7 @@ static const struct v4l2_ioctl_ops zoran_ioctl_ops = {
 	.vidioc_try_fmt_vid_cap  	    = zoran_try_fmt_vid_cap,
 	.vidioc_try_fmt_vid_out 	    = zoran_try_fmt_vid_out,
 	.vidioc_try_fmt_vid_overlay 	    = zoran_try_fmt_vid_overlay,
-	.vidioc_subscribe_event             = v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event		    = v4l2_subscribe_event_v4l2,
 	.vidioc_unsubscribe_event           = v4l2_event_unsubscribe,
 };
 
diff --git a/drivers/media/platform/am437x/am437x-vpfe.c b/drivers/media/platform/am437x/am437x-vpfe.c
index dfcc484cab89..8a71624cf241 100644
--- a/drivers/media/platform/am437x/am437x-vpfe.c
+++ b/drivers/media/platform/am437x/am437x-vpfe.c
@@ -2279,7 +2279,7 @@ static const struct v4l2_ioctl_ops vpfe_ioctl_ops = {
 	.vidioc_streamoff		= vb2_ioctl_streamoff,
 
 	.vidioc_log_status		= v4l2_ctrl_log_status,
-	.vidioc_subscribe_event		= v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event		= v4l2_subscribe_event_v4l2,
 	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
 
 	.vidioc_cropcap			= vpfe_cropcap,
diff --git a/drivers/media/platform/atmel/atmel-isc.c b/drivers/media/platform/atmel/atmel-isc.c
index 2f8e345d297e..c0d0a66c5b7a 100644
--- a/drivers/media/platform/atmel/atmel-isc.c
+++ b/drivers/media/platform/atmel/atmel-isc.c
@@ -1174,7 +1174,7 @@ static const struct v4l2_ioctl_ops isc_ioctl_ops = {
 	.vidioc_enum_frameintervals	= isc_enum_frameintervals,
 
 	.vidioc_log_status		= v4l2_ctrl_log_status,
-	.vidioc_subscribe_event		= v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event		= v4l2_subscribe_event_v4l2,
 	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
 };
 
diff --git a/drivers/media/platform/atmel/atmel-isi.c b/drivers/media/platform/atmel/atmel-isi.c
index 463c0146915e..19d6b49d7baa 100644
--- a/drivers/media/platform/atmel/atmel-isi.c
+++ b/drivers/media/platform/atmel/atmel-isi.c
@@ -925,7 +925,7 @@ static const struct v4l2_ioctl_ops isi_ioctl_ops = {
 	.vidioc_streamoff		= vb2_ioctl_streamoff,
 
 	.vidioc_log_status		= v4l2_ctrl_log_status,
-	.vidioc_subscribe_event		= v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event		= v4l2_subscribe_event_v4l2,
 	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
 };
 
diff --git a/drivers/media/platform/fsl-viu.c b/drivers/media/platform/fsl-viu.c
index fb43025df573..f339f82926a8 100644
--- a/drivers/media/platform/fsl-viu.c
+++ b/drivers/media/platform/fsl-viu.c
@@ -1376,7 +1376,7 @@ static const struct v4l2_ioctl_ops viu_ioctl_ops = {
 	.vidioc_streamon      = vidioc_streamon,
 	.vidioc_streamoff     = vidioc_streamoff,
 	.vidioc_log_status    = v4l2_ctrl_log_status,
-	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event = v4l2_subscribe_event_v4l2,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index b07a251e8857..ba4855b8763b 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -1569,7 +1569,7 @@ static const struct v4l2_ioctl_ops mcam_v4l_ioctl_ops = {
 	.vidioc_s_parm		= mcam_vidioc_s_parm,
 	.vidioc_enum_framesizes = mcam_vidioc_enum_framesizes,
 	.vidioc_enum_frameintervals = mcam_vidioc_enum_frameintervals,
-	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event = v4l2_subscribe_event_v4l2,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.vidioc_g_register	= mcam_vidioc_g_register,
diff --git a/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c b/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c
index 583d47724ee8..27835f05d415 100644
--- a/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c
+++ b/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c
@@ -970,7 +970,7 @@ static const struct v4l2_ioctl_ops mtk_mdp_m2m_ioctl_ops = {
 	.vidioc_reqbufs			= mtk_mdp_m2m_reqbufs,
 	.vidioc_create_bufs		= v4l2_m2m_ioctl_create_bufs,
 	.vidioc_expbuf			= v4l2_m2m_ioctl_expbuf,
-	.vidioc_subscribe_event		= v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event		= v4l2_subscribe_event_v4l2,
 	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
 	.vidioc_querybuf		= v4l2_m2m_ioctl_querybuf,
 	.vidioc_qbuf			= v4l2_m2m_ioctl_qbuf,
diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
index 1b1a28abbf1f..d4d472d2ef40 100644
--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
@@ -732,7 +732,7 @@ const struct v4l2_ioctl_ops mtk_venc_ioctl_ops = {
 	.vidioc_try_fmt_vid_cap_mplane	= vidioc_try_fmt_vid_cap_mplane,
 	.vidioc_try_fmt_vid_out_mplane	= vidioc_try_fmt_vid_out_mplane,
 	.vidioc_expbuf			= v4l2_m2m_ioctl_expbuf,
-	.vidioc_subscribe_event		= v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event		= v4l2_subscribe_event_v4l2,
 	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
 
 	.vidioc_s_parm			= vidioc_venc_s_parm,
diff --git a/drivers/media/platform/pxa_camera.c b/drivers/media/platform/pxa_camera.c
index edca993c2b1f..0d544dd68fd6 100644
--- a/drivers/media/platform/pxa_camera.c
+++ b/drivers/media/platform/pxa_camera.c
@@ -2096,7 +2096,7 @@ static const struct v4l2_ioctl_ops pxa_camera_ioctl_ops = {
 	.vidioc_g_register		= pxac_vidioc_g_register,
 	.vidioc_s_register		= pxac_vidioc_s_register,
 #endif
-	.vidioc_subscribe_event		= v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event		= v4l2_subscribe_event_v4l2,
 	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
 };
 
diff --git a/drivers/media/platform/qcom/venus/venc.c b/drivers/media/platform/qcom/venus/venc.c
index 6f123a387cf9..e93e01551acd 100644
--- a/drivers/media/platform/qcom/venus/venc.c
+++ b/drivers/media/platform/qcom/venus/venc.c
@@ -616,7 +616,7 @@ static const struct v4l2_ioctl_ops venc_ioctl_ops = {
 	.vidioc_g_parm = venc_g_parm,
 	.vidioc_enum_framesizes = venc_enum_framesizes,
 	.vidioc_enum_frameintervals = venc_enum_frameintervals,
-	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event = v4l2_subscribe_event_v4l2,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
diff --git a/drivers/media/platform/rcar_drif.c b/drivers/media/platform/rcar_drif.c
index 2c6afd38b78a..0fdc33132bbd 100644
--- a/drivers/media/platform/rcar_drif.c
+++ b/drivers/media/platform/rcar_drif.c
@@ -1045,7 +1045,7 @@ static const struct v4l2_ioctl_ops rcar_drif_ioctl_ops = {
 	.vidioc_s_tuner		  = rcar_drif_s_tuner,
 	.vidioc_g_tuner		  = rcar_drif_g_tuner,
 	.vidioc_enum_freq_bands   = rcar_drif_enum_freq_bands,
-	.vidioc_subscribe_event   = v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event	  = v4l2_subscribe_event_v4l2,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 	.vidioc_log_status        = v4l2_ctrl_log_status,
 };
diff --git a/drivers/media/platform/rcar_fdp1.c b/drivers/media/platform/rcar_fdp1.c
index 3245bc45f4a0..c567645871d1 100644
--- a/drivers/media/platform/rcar_fdp1.c
+++ b/drivers/media/platform/rcar_fdp1.c
@@ -1754,7 +1754,7 @@ static const struct v4l2_ioctl_ops fdp1_ioctl_ops = {
 	.vidioc_streamon	= v4l2_m2m_ioctl_streamon,
 	.vidioc_streamoff	= v4l2_m2m_ioctl_streamoff,
 
-	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event = v4l2_subscribe_event_v4l2,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
diff --git a/drivers/media/platform/rcar_jpu.c b/drivers/media/platform/rcar_jpu.c
index 070bac36d766..dc5bf7dcf0b7 100644
--- a/drivers/media/platform/rcar_jpu.c
+++ b/drivers/media/platform/rcar_jpu.c
@@ -972,7 +972,7 @@ static const struct v4l2_ioctl_ops jpu_ioctl_ops = {
 	.vidioc_streamon		= jpu_streamon,
 	.vidioc_streamoff		= v4l2_m2m_ioctl_streamoff,
 
-	.vidioc_subscribe_event		= v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event		= v4l2_subscribe_event_v4l2,
 	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe
 };
 
diff --git a/drivers/media/platform/s3c-camif/camif-capture.c b/drivers/media/platform/s3c-camif/camif-capture.c
index 25c7a7d42292..0ced65d6527f 100644
--- a/drivers/media/platform/s3c-camif/camif-capture.c
+++ b/drivers/media/platform/s3c-camif/camif-capture.c
@@ -1065,7 +1065,7 @@ static const struct v4l2_ioctl_ops s3c_camif_ioctl_ops = {
 	.vidioc_dqbuf		  = s3c_camif_dqbuf,
 	.vidioc_streamon	  = s3c_camif_streamon,
 	.vidioc_streamoff	  = s3c_camif_streamoff,
-	.vidioc_subscribe_event	  = v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event	  = v4l2_subscribe_event_v4l2,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 	.vidioc_log_status	  = v4l2_ctrl_log_status,
 };
diff --git a/drivers/media/platform/sti/bdisp/bdisp-v4l2.c b/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
index 939da6da7644..db5a8d73ec32 100644
--- a/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
+++ b/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
@@ -1042,7 +1042,7 @@ static const struct v4l2_ioctl_ops bdisp_ioctl_ops = {
 	.vidioc_dqbuf                   = v4l2_m2m_ioctl_dqbuf,
 	.vidioc_streamon                = bdisp_streamon,
 	.vidioc_streamoff               = v4l2_m2m_ioctl_streamoff,
-	.vidioc_subscribe_event         = v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event		= v4l2_subscribe_event_v4l2,
 	.vidioc_unsubscribe_event       = v4l2_event_unsubscribe,
 };
 
diff --git a/drivers/media/platform/sti/hva/hva-v4l2.c b/drivers/media/platform/sti/hva/hva-v4l2.c
index 1c4fc33cbcb5..540570ed3f5a 100644
--- a/drivers/media/platform/sti/hva/hva-v4l2.c
+++ b/drivers/media/platform/sti/hva/hva-v4l2.c
@@ -602,7 +602,7 @@ static const struct v4l2_ioctl_ops hva_ioctl_ops = {
 	.vidioc_dqbuf			= v4l2_m2m_ioctl_dqbuf,
 	.vidioc_streamon		= v4l2_m2m_ioctl_streamon,
 	.vidioc_streamoff		= v4l2_m2m_ioctl_streamoff,
-	.vidioc_subscribe_event		= v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event		= v4l2_subscribe_event_v4l2,
 	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
 };
 
diff --git a/drivers/media/platform/stm32/stm32-dcmi.c b/drivers/media/platform/stm32/stm32-dcmi.c
index 35ba6f211b79..daffbf97eeaa 100644
--- a/drivers/media/platform/stm32/stm32-dcmi.c
+++ b/drivers/media/platform/stm32/stm32-dcmi.c
@@ -1283,7 +1283,7 @@ static const struct v4l2_ioctl_ops dcmi_ioctl_ops = {
 	.vidioc_streamoff		= vb2_ioctl_streamoff,
 
 	.vidioc_log_status		= v4l2_ctrl_log_status,
-	.vidioc_subscribe_event		= v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event		= v4l2_subscribe_event_v4l2,
 	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
 };
 
diff --git a/drivers/media/platform/ti-vpe/cal.c b/drivers/media/platform/ti-vpe/cal.c
index 42e383a48ffe..4944bfe50f7b 100644
--- a/drivers/media/platform/ti-vpe/cal.c
+++ b/drivers/media/platform/ti-vpe/cal.c
@@ -1416,7 +1416,7 @@ static const struct v4l2_ioctl_ops cal_ioctl_ops = {
 	.vidioc_streamon      = vb2_ioctl_streamon,
 	.vidioc_streamoff     = vb2_ioctl_streamoff,
 	.vidioc_log_status    = v4l2_ctrl_log_status,
-	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event = v4l2_subscribe_event_v4l2,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index 45bd10544189..d73ca22d7871 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -2011,7 +2011,7 @@ static const struct v4l2_ioctl_ops vpe_ioctl_ops = {
 	.vidioc_streamon		= v4l2_m2m_ioctl_streamon,
 	.vidioc_streamoff		= v4l2_m2m_ioctl_streamoff,
 
-	.vidioc_subscribe_event		= v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event		= v4l2_subscribe_event_v4l2,
 	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
 };
 
diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index b01fba020d5f..9a630f3a4ae2 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -713,7 +713,7 @@ static const struct v4l2_ioctl_ops vim2m_ioctl_ops = {
 	.vidioc_streamon	= v4l2_m2m_ioctl_streamon,
 	.vidioc_streamoff	= v4l2_m2m_ioctl_streamoff,
 
-	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event = v4l2_subscribe_event_v4l2,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
diff --git a/drivers/media/radio/dsbr100.c b/drivers/media/radio/dsbr100.c
index 8521bb2825e8..b6d96870a4ab 100644
--- a/drivers/media/radio/dsbr100.c
+++ b/drivers/media/radio/dsbr100.c
@@ -337,7 +337,7 @@ static const struct v4l2_ioctl_ops usb_dsbr100_ioctl_ops = {
 	.vidioc_g_frequency = vidioc_g_frequency,
 	.vidioc_s_frequency = vidioc_s_frequency,
 	.vidioc_log_status  = v4l2_ctrl_log_status,
-	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event = v4l2_subscribe_event_v4l2,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
diff --git a/drivers/media/radio/radio-cadet.c b/drivers/media/radio/radio-cadet.c
index 6888b7db449d..9c206783b1fd 100644
--- a/drivers/media/radio/radio-cadet.c
+++ b/drivers/media/radio/radio-cadet.c
@@ -518,7 +518,7 @@ static const struct v4l2_ioctl_ops cadet_ioctl_ops = {
 	.vidioc_s_frequency = vidioc_s_frequency,
 	.vidioc_enum_freq_bands = vidioc_enum_freq_bands,
 	.vidioc_log_status  = v4l2_ctrl_log_status,
-	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event = v4l2_subscribe_event_v4l2,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
diff --git a/drivers/media/radio/radio-isa.c b/drivers/media/radio/radio-isa.c
index 7312e469e850..a2b57e532ef0 100644
--- a/drivers/media/radio/radio-isa.c
+++ b/drivers/media/radio/radio-isa.c
@@ -165,7 +165,7 @@ static const struct v4l2_ioctl_ops radio_isa_ioctl_ops = {
 	.vidioc_g_frequency = radio_isa_g_frequency,
 	.vidioc_s_frequency = radio_isa_s_frequency,
 	.vidioc_log_status  = radio_isa_log_status,
-	.vidioc_subscribe_event   = v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event   = v4l2_subscribe_event_v4l2,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
diff --git a/drivers/media/radio/radio-keene.c b/drivers/media/radio/radio-keene.c
index f2ea8bc5f5ee..83c8b7242d87 100644
--- a/drivers/media/radio/radio-keene.c
+++ b/drivers/media/radio/radio-keene.c
@@ -287,7 +287,7 @@ static const struct v4l2_ioctl_ops usb_keene_ioctl_ops = {
 	.vidioc_g_frequency = vidioc_g_frequency,
 	.vidioc_s_frequency = vidioc_s_frequency,
 	.vidioc_log_status = v4l2_ctrl_log_status,
-	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event = v4l2_subscribe_event_v4l2,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
diff --git a/drivers/media/radio/radio-ma901.c b/drivers/media/radio/radio-ma901.c
index fdc481257efd..601bfa76550f 100644
--- a/drivers/media/radio/radio-ma901.c
+++ b/drivers/media/radio/radio-ma901.c
@@ -325,7 +325,7 @@ static const struct v4l2_ioctl_ops usb_ma901radio_ioctl_ops = {
 	.vidioc_g_frequency = vidioc_g_frequency,
 	.vidioc_s_frequency = vidioc_s_frequency,
 	.vidioc_log_status  = v4l2_ctrl_log_status,
-	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event = v4l2_subscribe_event_v4l2,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
diff --git a/drivers/media/radio/radio-miropcm20.c b/drivers/media/radio/radio-miropcm20.c
index 7b35e633118d..5f41fdcce53b 100644
--- a/drivers/media/radio/radio-miropcm20.c
+++ b/drivers/media/radio/radio-miropcm20.c
@@ -422,7 +422,7 @@ static const struct v4l2_ioctl_ops pcm20_ioctl_ops = {
 	.vidioc_g_frequency = vidioc_g_frequency,
 	.vidioc_s_frequency = vidioc_s_frequency,
 	.vidioc_log_status  = v4l2_ctrl_log_status,
-	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event = v4l2_subscribe_event_v4l2,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
diff --git a/drivers/media/radio/radio-mr800.c b/drivers/media/radio/radio-mr800.c
index c9f59129af79..7b175f7d6723 100644
--- a/drivers/media/radio/radio-mr800.c
+++ b/drivers/media/radio/radio-mr800.c
@@ -491,7 +491,7 @@ static const struct v4l2_ioctl_ops usb_amradio_ioctl_ops = {
 	.vidioc_s_frequency = vidioc_s_frequency,
 	.vidioc_s_hw_freq_seek = vidioc_s_hw_freq_seek,
 	.vidioc_log_status  = v4l2_ctrl_log_status,
-	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event = v4l2_subscribe_event_v4l2,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
diff --git a/drivers/media/radio/radio-sf16fmi.c b/drivers/media/radio/radio-sf16fmi.c
index 28a89466cddc..3b71d0ba28eb 100644
--- a/drivers/media/radio/radio-sf16fmi.c
+++ b/drivers/media/radio/radio-sf16fmi.c
@@ -223,7 +223,7 @@ static const struct v4l2_ioctl_ops fmi_ioctl_ops = {
 	.vidioc_g_frequency = vidioc_g_frequency,
 	.vidioc_s_frequency = vidioc_s_frequency,
 	.vidioc_log_status  = v4l2_ctrl_log_status,
-	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event = v4l2_subscribe_event_v4l2,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
diff --git a/drivers/media/radio/radio-si476x.c b/drivers/media/radio/radio-si476x.c
index 271f725b17e8..40dd19c49abd 100644
--- a/drivers/media/radio/radio-si476x.c
+++ b/drivers/media/radio/radio-si476x.c
@@ -1190,7 +1190,7 @@ static const struct v4l2_ioctl_ops si4761_ioctl_ops = {
 	.vidioc_s_hw_freq_seek		= si476x_radio_s_hw_freq_seek,
 	.vidioc_enum_freq_bands		= si476x_radio_enum_freq_bands,
 
-	.vidioc_subscribe_event		= v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event		= v4l2_subscribe_event_v4l2,
 	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
 
 #ifdef CONFIG_VIDEO_ADV_DEBUG
diff --git a/drivers/media/radio/radio-tea5764.c b/drivers/media/radio/radio-tea5764.c
index bc7e69e7e32e..5470a609a200 100644
--- a/drivers/media/radio/radio-tea5764.c
+++ b/drivers/media/radio/radio-tea5764.c
@@ -409,7 +409,7 @@ static const struct v4l2_ioctl_ops tea5764_ioctl_ops = {
 	.vidioc_g_frequency = vidioc_g_frequency,
 	.vidioc_s_frequency = vidioc_s_frequency,
 	.vidioc_log_status  = v4l2_ctrl_log_status,
-	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event = v4l2_subscribe_event_v4l2,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
diff --git a/drivers/media/radio/radio-tea5777.c b/drivers/media/radio/radio-tea5777.c
index 04ed1a5d1177..eaa28b63574a 100644
--- a/drivers/media/radio/radio-tea5777.c
+++ b/drivers/media/radio/radio-tea5777.c
@@ -527,7 +527,7 @@ static const struct v4l2_ioctl_ops tea575x_ioctl_ops = {
 	.vidioc_s_hw_freq_seek = vidioc_s_hw_freq_seek,
 	.vidioc_enum_freq_bands = vidioc_enum_freq_bands,
 	.vidioc_log_status  = v4l2_ctrl_log_status,
-	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event = v4l2_subscribe_event_v4l2,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
diff --git a/drivers/media/radio/radio-timb.c b/drivers/media/radio/radio-timb.c
index fc4d9a73ab17..bb13e3bc18cc 100644
--- a/drivers/media/radio/radio-timb.c
+++ b/drivers/media/radio/radio-timb.c
@@ -82,7 +82,7 @@ static const struct v4l2_ioctl_ops timbradio_ioctl_ops = {
 	.vidioc_g_frequency	= timbradio_vidioc_g_frequency,
 	.vidioc_s_frequency	= timbradio_vidioc_s_frequency,
 	.vidioc_log_status      = v4l2_ctrl_log_status,
-	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event = v4l2_subscribe_event_v4l2,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
diff --git a/drivers/media/radio/si470x/radio-si470x-common.c b/drivers/media/radio/si470x/radio-si470x-common.c
index cd76facc22f5..3117d3817690 100644
--- a/drivers/media/radio/si470x/radio-si470x-common.c
+++ b/drivers/media/radio/si470x/radio-si470x-common.c
@@ -741,7 +741,7 @@ static const struct v4l2_ioctl_ops si470x_ioctl_ops = {
 	.vidioc_s_frequency	= si470x_vidioc_s_frequency,
 	.vidioc_s_hw_freq_seek	= si470x_vidioc_s_hw_freq_seek,
 	.vidioc_enum_freq_bands = si470x_vidioc_enum_freq_bands,
-	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event = v4l2_subscribe_event_v4l2,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
diff --git a/drivers/media/radio/si4713/radio-platform-si4713.c b/drivers/media/radio/si4713/radio-platform-si4713.c
index 27339ec495f6..3fcaf1abac34 100644
--- a/drivers/media/radio/si4713/radio-platform-si4713.c
+++ b/drivers/media/radio/si4713/radio-platform-si4713.c
@@ -129,7 +129,7 @@ static struct v4l2_ioctl_ops radio_si4713_ioctl_ops = {
 	.vidioc_g_frequency	= radio_si4713_g_frequency,
 	.vidioc_s_frequency	= radio_si4713_s_frequency,
 	.vidioc_log_status      = v4l2_ctrl_log_status,
-	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event = v4l2_subscribe_event_v4l2,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 	.vidioc_default		= radio_si4713_default,
 };
diff --git a/drivers/media/radio/si4713/radio-usb-si4713.c b/drivers/media/radio/si4713/radio-usb-si4713.c
index a115db24667b..c02e86728839 100644
--- a/drivers/media/radio/si4713/radio-usb-si4713.c
+++ b/drivers/media/radio/si4713/radio-usb-si4713.c
@@ -127,7 +127,7 @@ static const struct v4l2_ioctl_ops usb_si4713_ioctl_ops = {
 	.vidioc_g_frequency	  = vidioc_g_frequency,
 	.vidioc_s_frequency	  = vidioc_s_frequency,
 	.vidioc_log_status	  = v4l2_ctrl_log_status,
-	.vidioc_subscribe_event   = v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event	  = v4l2_subscribe_event_v4l2,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
diff --git a/drivers/media/radio/tea575x.c b/drivers/media/radio/tea575x.c
index 4dc2067bce14..7b2197b2fc8e 100644
--- a/drivers/media/radio/tea575x.c
+++ b/drivers/media/radio/tea575x.c
@@ -493,7 +493,7 @@ static const struct v4l2_ioctl_ops tea575x_ioctl_ops = {
 	.vidioc_s_hw_freq_seek = vidioc_s_hw_freq_seek,
 	.vidioc_enum_freq_bands = vidioc_enum_freq_bands,
 	.vidioc_log_status  = v4l2_ctrl_log_status,
-	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event = v4l2_subscribe_event_v4l2,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
diff --git a/drivers/media/usb/airspy/airspy.c b/drivers/media/usb/airspy/airspy.c
index e70c9e2f3798..00b9f16b4357 100644
--- a/drivers/media/usb/airspy/airspy.c
+++ b/drivers/media/usb/airspy/airspy.c
@@ -844,7 +844,7 @@ static const struct v4l2_ioctl_ops airspy_ioctl_ops = {
 	.vidioc_s_frequency       = airspy_s_frequency,
 	.vidioc_enum_freq_bands   = airspy_enum_freq_bands,
 
-	.vidioc_subscribe_event   = v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event	  = v4l2_subscribe_event_v4l2,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 	.vidioc_log_status        = v4l2_ctrl_log_status,
 };
diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index 9342402b92f7..f70f1a60b122 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -1790,7 +1790,7 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_s_register          = vidioc_s_register,
 #endif
 	.vidioc_log_status	    = vidioc_log_status,
-	.vidioc_subscribe_event     = v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event	    = v4l2_subscribe_event_v4l2,
 	.vidioc_unsubscribe_event   = v4l2_event_unsubscribe,
 };
 
diff --git a/drivers/media/usb/cpia2/cpia2_v4l.c b/drivers/media/usb/cpia2/cpia2_v4l.c
index 3dedd83f0b19..4666a642b2f6 100644
--- a/drivers/media/usb/cpia2/cpia2_v4l.c
+++ b/drivers/media/usb/cpia2/cpia2_v4l.c
@@ -1058,7 +1058,7 @@ static const struct v4l2_ioctl_ops cpia2_ioctl_ops = {
 	.vidioc_g_parm			    = cpia2_g_parm,
 	.vidioc_enum_framesizes		    = cpia2_enum_framesizes,
 	.vidioc_enum_frameintervals	    = cpia2_enum_frameintervals,
-	.vidioc_subscribe_event		    = v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event		    = v4l2_subscribe_event_v4l2,
 	.vidioc_unsubscribe_event	    = v4l2_event_unsubscribe,
 };
 
diff --git a/drivers/media/usb/cx231xx/cx231xx-417.c b/drivers/media/usb/cx231xx/cx231xx-417.c
index d538fa407742..0c49ad29be9a 100644
--- a/drivers/media/usb/cx231xx/cx231xx-417.c
+++ b/drivers/media/usb/cx231xx/cx231xx-417.c
@@ -1881,7 +1881,7 @@ static const struct v4l2_ioctl_ops mpeg_ioctl_ops = {
 	.vidioc_g_register	 = cx231xx_g_register,
 	.vidioc_s_register	 = cx231xx_s_register,
 #endif
-	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event = v4l2_subscribe_event_v4l2,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
index 179b8481a870..51d827d95682 100644
--- a/drivers/media/usb/cx231xx/cx231xx-video.c
+++ b/drivers/media/usb/cx231xx/cx231xx-video.c
@@ -2112,7 +2112,7 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_g_register             = cx231xx_g_register,
 	.vidioc_s_register             = cx231xx_s_register,
 #endif
-	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event = v4l2_subscribe_event_v4l2,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
@@ -2144,7 +2144,7 @@ static const struct v4l2_ioctl_ops radio_ioctl_ops = {
 	.vidioc_g_register  = cx231xx_g_register,
 	.vidioc_s_register  = cx231xx_s_register,
 #endif
-	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event = v4l2_subscribe_event_v4l2,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 8d253a5df0a9..d6f245c90d35 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -2271,7 +2271,7 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_s_tuner             = vidioc_s_tuner,
 	.vidioc_g_frequency         = vidioc_g_frequency,
 	.vidioc_s_frequency         = vidioc_s_frequency,
-	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event = v4l2_subscribe_event_v4l2,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.vidioc_g_chip_info         = vidioc_g_chip_info,
@@ -2300,7 +2300,7 @@ static const struct v4l2_ioctl_ops radio_ioctl_ops = {
 	.vidioc_s_tuner       = radio_s_tuner,
 	.vidioc_g_frequency   = vidioc_g_frequency,
 	.vidioc_s_frequency   = vidioc_s_frequency,
-	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event = v4l2_subscribe_event_v4l2,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.vidioc_g_chip_info   = vidioc_g_chip_info,
diff --git a/drivers/media/usb/gspca/gspca.c b/drivers/media/usb/gspca/gspca.c
index 0f141762abf1..0a15c8d11b75 100644
--- a/drivers/media/usb/gspca/gspca.c
+++ b/drivers/media/usb/gspca/gspca.c
@@ -2000,7 +2000,7 @@ static const struct v4l2_ioctl_ops dev_ioctl_ops = {
 	.vidioc_g_register	= vidioc_g_register,
 	.vidioc_s_register	= vidioc_s_register,
 #endif
-	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event = v4l2_subscribe_event_v4l2,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
diff --git a/drivers/media/usb/hackrf/hackrf.c b/drivers/media/usb/hackrf/hackrf.c
index 7eb53517a82f..b3e8cb8f24ba 100644
--- a/drivers/media/usb/hackrf/hackrf.c
+++ b/drivers/media/usb/hackrf/hackrf.c
@@ -1247,7 +1247,7 @@ static const struct v4l2_ioctl_ops hackrf_ioctl_ops = {
 	.vidioc_g_frequency       = hackrf_g_frequency,
 	.vidioc_enum_freq_bands   = hackrf_enum_freq_bands,
 
-	.vidioc_subscribe_event   = v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event	  = v4l2_subscribe_event_v4l2,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 	.vidioc_log_status        = v4l2_ctrl_log_status,
 };
diff --git a/drivers/media/usb/hdpvr/hdpvr-video.c b/drivers/media/usb/hdpvr/hdpvr-video.c
index 7fb036d6a86e..95f3650dfb48 100644
--- a/drivers/media/usb/hdpvr/hdpvr-video.c
+++ b/drivers/media/usb/hdpvr/hdpvr-video.c
@@ -1124,7 +1124,7 @@ static const struct v4l2_ioctl_ops hdpvr_ioctl_ops = {
 	.vidioc_encoder_cmd	= vidioc_encoder_cmd,
 	.vidioc_try_encoder_cmd	= vidioc_try_encoder_cmd,
 	.vidioc_log_status	= v4l2_ctrl_log_status,
-	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event = v4l2_subscribe_event_v4l2,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
diff --git a/drivers/media/usb/msi2500/msi2500.c b/drivers/media/usb/msi2500/msi2500.c
index a097d3dbc141..d04165f5c39e 100644
--- a/drivers/media/usb/msi2500/msi2500.c
+++ b/drivers/media/usb/msi2500/msi2500.c
@@ -1128,7 +1128,7 @@ static const struct v4l2_ioctl_ops msi2500_ioctl_ops = {
 	.vidioc_s_frequency       = msi2500_s_frequency,
 	.vidioc_enum_freq_bands   = msi2500_enum_freq_bands,
 
-	.vidioc_subscribe_event   = v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event	  = v4l2_subscribe_event_v4l2,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 	.vidioc_log_status        = v4l2_ctrl_log_status,
 };
diff --git a/drivers/media/usb/pwc/pwc-v4l.c b/drivers/media/usb/pwc/pwc-v4l.c
index 043b2b97cee6..54ce52ade9fe 100644
--- a/drivers/media/usb/pwc/pwc-v4l.c
+++ b/drivers/media/usb/pwc/pwc-v4l.c
@@ -1046,6 +1046,6 @@ const struct v4l2_ioctl_ops pwc_ioctl_ops = {
 	.vidioc_enum_frameintervals	    = pwc_enum_frameintervals,
 	.vidioc_g_parm			    = pwc_g_parm,
 	.vidioc_s_parm			    = pwc_s_parm,
-	.vidioc_subscribe_event		    = v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event		    = v4l2_subscribe_event_v4l2,
 	.vidioc_unsubscribe_event	    = v4l2_event_unsubscribe,
 };
diff --git a/drivers/media/usb/s2255/s2255drv.c b/drivers/media/usb/s2255/s2255drv.c
index b2f239c4ba42..46d83ad37339 100644
--- a/drivers/media/usb/s2255/s2255drv.c
+++ b/drivers/media/usb/s2255/s2255drv.c
@@ -1570,7 +1570,7 @@ static const struct v4l2_ioctl_ops s2255_ioctl_ops = {
 	.vidioc_enum_framesizes = vidioc_enum_framesizes,
 	.vidioc_enum_frameintervals = vidioc_enum_frameintervals,
 	.vidioc_log_status  = v4l2_ctrl_log_status,
-	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event = v4l2_subscribe_event_v4l2,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
diff --git a/drivers/media/usb/stk1160/stk1160-v4l.c b/drivers/media/usb/stk1160/stk1160-v4l.c
index 77b759a0bcd9..ec6cb0bb972c 100644
--- a/drivers/media/usb/stk1160/stk1160-v4l.c
+++ b/drivers/media/usb/stk1160/stk1160-v4l.c
@@ -650,7 +650,7 @@ static const struct v4l2_ioctl_ops stk1160_ioctl_ops = {
 	.vidioc_expbuf        = vb2_ioctl_expbuf,
 
 	.vidioc_log_status  = v4l2_ctrl_log_status,
-	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event = v4l2_subscribe_event_v4l2,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 
 #ifdef CONFIG_VIDEO_ADV_DEBUG
diff --git a/drivers/media/usb/stkwebcam/stk-webcam.c b/drivers/media/usb/stkwebcam/stk-webcam.c
index c0bba773db25..7c571ff11065 100644
--- a/drivers/media/usb/stkwebcam/stk-webcam.c
+++ b/drivers/media/usb/stkwebcam/stk-webcam.c
@@ -1230,7 +1230,7 @@ static const struct v4l2_ioctl_ops v4l_stk_ioctl_ops = {
 	.vidioc_g_parm = stk_vidioc_g_parm,
 	.vidioc_enum_framesizes = stk_vidioc_enum_framesizes,
 	.vidioc_log_status = v4l2_ctrl_log_status,
-	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event = v4l2_subscribe_event_v4l2,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
diff --git a/drivers/media/usb/tm6000/tm6000-video.c b/drivers/media/usb/tm6000/tm6000-video.c
index ec8c4d2534dc..4034ae3f3c8a 100644
--- a/drivers/media/usb/tm6000/tm6000-video.c
+++ b/drivers/media/usb/tm6000/tm6000-video.c
@@ -1563,7 +1563,7 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_querybuf          = vidioc_querybuf,
 	.vidioc_qbuf              = vidioc_qbuf,
 	.vidioc_dqbuf             = vidioc_dqbuf,
-	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event = v4l2_subscribe_event_v4l2,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
@@ -1589,7 +1589,7 @@ static const struct v4l2_ioctl_ops radio_ioctl_ops = {
 	.vidioc_s_tuner		= radio_s_tuner,
 	.vidioc_g_frequency	= vidioc_g_frequency,
 	.vidioc_s_frequency	= vidioc_s_frequency,
-	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event = v4l2_subscribe_event_v4l2,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
diff --git a/drivers/media/usb/usbvision/usbvision-video.c b/drivers/media/usb/usbvision/usbvision-video.c
index 960272d3c924..21870283e35e 100644
--- a/drivers/media/usb/usbvision/usbvision-video.c
+++ b/drivers/media/usb/usbvision/usbvision-video.c
@@ -1182,7 +1182,7 @@ static const struct v4l2_ioctl_ops usbvision_ioctl_ops = {
 	.vidioc_g_frequency   = vidioc_g_frequency,
 	.vidioc_s_frequency   = vidioc_s_frequency,
 	.vidioc_log_status    = v4l2_ctrl_log_status,
-	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event = v4l2_subscribe_event_v4l2,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.vidioc_g_register    = vidioc_g_register,
@@ -1215,7 +1215,7 @@ static const struct v4l2_ioctl_ops usbvision_radio_ioctl_ops = {
 	.vidioc_g_frequency   = vidioc_g_frequency,
 	.vidioc_s_frequency   = vidioc_s_frequency,
 	.vidioc_log_status    = v4l2_ctrl_log_status,
-	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event = v4l2_subscribe_event_v4l2,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
diff --git a/drivers/media/usb/zr364xx/zr364xx.c b/drivers/media/usb/zr364xx/zr364xx.c
index 1d888661fd03..328d77819dea 100644
--- a/drivers/media/usb/zr364xx/zr364xx.c
+++ b/drivers/media/usb/zr364xx/zr364xx.c
@@ -1329,7 +1329,7 @@ static const struct v4l2_ioctl_ops zr364xx_ioctl_ops = {
 	.vidioc_qbuf            = zr364xx_vidioc_qbuf,
 	.vidioc_dqbuf           = zr364xx_vidioc_dqbuf,
 	.vidioc_log_status      = v4l2_ctrl_log_status,
-	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event = v4l2_subscribe_event_v4l2,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
diff --git a/drivers/staging/vc04_services/bcm2835-camera/bcm2835-camera.c b/drivers/staging/vc04_services/bcm2835-camera/bcm2835-camera.c
index be936b8fe317..38dbac531db6 100644
--- a/drivers/staging/vc04_services/bcm2835-camera/bcm2835-camera.c
+++ b/drivers/staging/vc04_services/bcm2835-camera/bcm2835-camera.c
@@ -1437,7 +1437,7 @@ static const struct v4l2_ioctl_ops camera0_ioctl_ops = {
 	.vidioc_streamoff = vb2_ioctl_streamoff,
 
 	.vidioc_log_status = v4l2_ctrl_log_status,
-	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event = v4l2_subscribe_event_v4l2,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
diff --git a/samples/v4l/v4l2-pci-skeleton.c b/samples/v4l/v4l2-pci-skeleton.c
index f520e3aef9c6..a86cab952791 100644
--- a/samples/v4l/v4l2-pci-skeleton.c
+++ b/samples/v4l/v4l2-pci-skeleton.c
@@ -726,7 +726,7 @@ static const struct v4l2_ioctl_ops skel_ioctl_ops = {
 	.vidioc_streamoff = vb2_ioctl_streamoff,
 
 	.vidioc_log_status = v4l2_ctrl_log_status,
-	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event = v4l2_subscribe_event_v4l2,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
-- 
2.13.6
