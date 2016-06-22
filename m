Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:54515 "EHLO
	smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbcFVAWf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Jun 2016 20:22:35 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
To: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	mchehab@kernel.org, hans.verkuil@cisco.com,
	laurent.pinchart@ideasonboard.com
Cc: linux-samsung-soc@vger.kernel.org,
	mjpeg-users@lists.sourceforge.net, devel@driverdev.osuosl.org,
	lars@metafoo.de,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH 2/2] [media] v4l: subdev: move s_stream from v4l2_subdev_video_ops to v4l2_subdev_pad_ops
Date: Wed, 22 Jun 2016 02:19:25 +0200
Message-Id: <20160622001925.30077-3-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20160622001925.30077-1-niklas.soderlund+renesas@ragnatech.se>
References: <20160622001925.30077-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some devices (adv7482 for example) supports running two video pipelines
in parallel. To be able to stop and start streams on a pad basis the
s_stream operation needs to be extended with a 'pad' argument specifying
which pad to start or stop the stream for.

This patch moves the s_stream operation from struct
v4l2_subdev_video_ops to struct v4l2_subdev_pad_ops. It also updates all
users of s_stream to use the new function with pad number 0.

Suggested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/dvb-frontends/au8522_decoder.c       |   9 +-
 drivers/media/i2c/ad9389b.c                        |   7 +-
 drivers/media/i2c/adv7180.c                        |   5 +-
 drivers/media/i2c/adv7183.c                        |   5 +-
 drivers/media/i2c/adv7511.c                        |   7 +-
 drivers/media/i2c/ak881x.c                         |   5 +-
 drivers/media/i2c/bt819.c                          |   9 +-
 drivers/media/i2c/cx25840/cx25840-core.c           |   5 +-
 drivers/media/i2c/ks0127.c                         |   9 +-
 drivers/media/i2c/m5mols/m5mols_core.c             |  19 +--
 drivers/media/i2c/mt9m032.c                        |   5 +-
 drivers/media/i2c/mt9p031.c                        |   9 +-
 drivers/media/i2c/mt9t001.c                        |   9 +-
 drivers/media/i2c/mt9v032.c                        |   9 +-
 drivers/media/i2c/noon010pc30.c                    |   6 +-
 drivers/media/i2c/ov2659.c                         |   8 +-
 drivers/media/i2c/ov9650.c                         |   4 +-
 drivers/media/i2c/s5c73m3/s5c73m3-core.c           |   5 +-
 drivers/media/i2c/s5k4ecgx.c                       | 180 ++++++++++-----------
 drivers/media/i2c/s5k5baf.c                        |   4 +-
 drivers/media/i2c/s5k6aa.c                         |   4 +-
 drivers/media/i2c/saa7110.c                        |   9 +-
 drivers/media/i2c/saa7115.c                        |   5 +-
 drivers/media/i2c/saa7127.c                        |   9 +-
 drivers/media/i2c/saa717x.c                        |   5 +-
 drivers/media/i2c/smiapp/smiapp-core.c             |   9 +-
 drivers/media/i2c/soc_camera/imx074.c              |   5 +-
 drivers/media/i2c/soc_camera/mt9m001.c             |   5 +-
 drivers/media/i2c/soc_camera/mt9t031.c             |   5 +-
 drivers/media/i2c/soc_camera/mt9t112.c             |   5 +-
 drivers/media/i2c/soc_camera/mt9v022.c             |   5 +-
 drivers/media/i2c/soc_camera/ov2640.c              |   5 +-
 drivers/media/i2c/soc_camera/ov6650.c              |   5 +-
 drivers/media/i2c/soc_camera/ov772x.c              |   5 +-
 drivers/media/i2c/soc_camera/ov9640.c              |   5 +-
 drivers/media/i2c/soc_camera/ov9740.c              |   9 +-
 drivers/media/i2c/soc_camera/rj54n1cb0c.c          |   5 +-
 drivers/media/i2c/soc_camera/tw9910.c              |   5 +-
 drivers/media/i2c/tc358743.c                       |   5 +-
 drivers/media/i2c/ths7303.c                        |  10 +-
 drivers/media/i2c/ths8200.c                        |   9 +-
 drivers/media/i2c/tvp514x.c                        |  10 +-
 drivers/media/i2c/tvp5150.c                        |   5 +-
 drivers/media/i2c/tvp7002.c                        |   5 +-
 drivers/media/i2c/vpx3220.c                        |   9 +-
 drivers/media/i2c/vs6624.c                         |   5 +-
 drivers/media/pci/cobalt/cobalt-driver.c           |   2 +-
 drivers/media/pci/cx18/cx18-av-core.c              |   5 +-
 drivers/media/pci/ivtv/ivtv-driver.c               |   7 +-
 drivers/media/pci/ivtv/ivtv-streams.c              |   4 +-
 drivers/media/pci/ivtv/ivtvfb.c                    |   6 +-
 drivers/media/pci/zoran/zoran_card.c               |   2 +-
 drivers/media/pci/zoran/zoran_device.c             |   6 +-
 drivers/media/pci/zoran/zoran_driver.c             |   2 +-
 drivers/media/platform/am437x/am437x-vpfe.c        |   4 +-
 drivers/media/platform/blackfin/bfin_capture.c     |   4 +-
 drivers/media/platform/davinci/vpfe_capture.c      |   8 +-
 drivers/media/platform/davinci/vpif_capture.c      |   4 +-
 drivers/media/platform/exynos4-is/fimc-isp.c       |   7 +-
 drivers/media/platform/exynos4-is/fimc-lite.c      |   7 +-
 drivers/media/platform/exynos4-is/media-dev.c      |   4 +-
 drivers/media/platform/exynos4-is/mipi-csis.c      |   5 +-
 drivers/media/platform/omap3isp/isp.c              |  28 ++--
 drivers/media/platform/omap3isp/ispccdc.c          |  10 +-
 drivers/media/platform/omap3isp/ispccp2.c          |   9 +-
 drivers/media/platform/omap3isp/ispcsi2.c          |  10 +-
 drivers/media/platform/omap3isp/isph3a_aewb.c      |   4 +-
 drivers/media/platform/omap3isp/isph3a_af.c        |   4 +-
 drivers/media/platform/omap3isp/isphist.c          |   4 +-
 drivers/media/platform/omap3isp/isppreview.c       |  10 +-
 drivers/media/platform/omap3isp/ispresizer.c       |  10 +-
 drivers/media/platform/omap3isp/ispstat.c          |   3 +-
 drivers/media/platform/omap3isp/ispstat.h          |   3 +-
 drivers/media/platform/rcar-vin/rcar-dma.c         |   6 +-
 drivers/media/platform/s3c-camif/camif-capture.c   |   2 +-
 drivers/media/platform/s5p-tv/hdmi_drv.c           |  16 +-
 drivers/media/platform/s5p-tv/hdmiphy_drv.c        |   5 +-
 drivers/media/platform/s5p-tv/mixer_drv.c          |   4 +-
 drivers/media/platform/s5p-tv/sdo_drv.c            |   4 +-
 drivers/media/platform/s5p-tv/sii9234_drv.c        |   7 +-
 drivers/media/platform/sh_vou.c                    |   7 +-
 .../platform/soc_camera/sh_mobile_ceu_camera.c     |   4 +-
 drivers/media/platform/soc_camera/soc_camera.c     |   4 +-
 .../platform/soc_camera/soc_camera_platform.c      |   5 +-
 drivers/media/platform/ti-vpe/cal.c                |   4 +-
 drivers/media/platform/vsp1/vsp1_pipe.c            |   2 +-
 drivers/media/platform/vsp1/vsp1_wpf.c             |   7 +-
 drivers/media/platform/xilinx/xilinx-dma.c         |   2 +-
 drivers/media/platform/xilinx/xilinx-tpg.c         |   9 +-
 drivers/media/usb/au0828/au0828-video.c            |   6 +-
 drivers/media/usb/cx231xx/cx231xx-cards.c          |   2 +-
 drivers/media/usb/cx231xx/cx231xx-video.c          |   4 +-
 drivers/media/usb/em28xx/em28xx-video.c            |   6 +-
 drivers/media/usb/go7007/go7007-v4l2.c             |   4 +-
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c            |   2 +-
 drivers/media/usb/stk1160/stk1160-core.c           |   2 +-
 drivers/media/usb/stk1160/stk1160-v4l.c            |   4 +-
 drivers/media/usb/usbvision/usbvision-video.c      |   6 +-
 drivers/staging/media/davinci_vpfe/dm365_ipipe.c   |  10 +-
 drivers/staging/media/davinci_vpfe/dm365_ipipeif.c |  10 +-
 drivers/staging/media/davinci_vpfe/dm365_isif.c    |  10 +-
 drivers/staging/media/davinci_vpfe/dm365_resizer.c |  10 +-
 drivers/staging/media/davinci_vpfe/vpfe_video.c    |   4 +-
 drivers/staging/media/omap4iss/iss.c               |   4 +-
 drivers/staging/media/omap4iss/iss_csi2.c          |  10 +-
 drivers/staging/media/omap4iss/iss_ipipe.c         |  10 +-
 drivers/staging/media/omap4iss/iss_ipipeif.c       |  10 +-
 drivers/staging/media/omap4iss/iss_resizer.c       |  10 +-
 include/media/v4l2-subdev.h                        |   8 +-
 109 files changed, 427 insertions(+), 447 deletions(-)

diff --git a/drivers/media/dvb-frontends/au8522_decoder.c b/drivers/media/dvb-frontends/au8522_decoder.c
index add2463..d03d464 100644
--- a/drivers/media/dvb-frontends/au8522_decoder.c
+++ b/drivers/media/dvb-frontends/au8522_decoder.c
@@ -583,7 +583,8 @@ static void au8522_video_set(struct au8522_state *state)
 	}
 }
 
-static int au8522_s_stream(struct v4l2_subdev *sd, int enable)
+static int au8522_s_stream(struct v4l2_subdev *sd, unsigned int pad,
+			   int enable)
 {
 	struct au8522_state *state = to_state(sd);
 
@@ -706,15 +707,19 @@ static const struct v4l2_subdev_audio_ops au8522_audio_ops = {
 
 static const struct v4l2_subdev_video_ops au8522_video_ops = {
 	.s_routing = au8522_s_video_routing,
-	.s_stream = au8522_s_stream,
 	.s_std = au8522_s_std,
 };
 
+static const struct v4l2_subdev_pad_ops au8522_pad_ops = {
+	.s_stream = au8522_s_stream,
+};
+
 static const struct v4l2_subdev_ops au8522_ops = {
 	.core = &au8522_core_ops,
 	.tuner = &au8522_tuner_ops,
 	.audio = &au8522_audio_ops,
 	.video = &au8522_video_ops,
+	.pad = &au8522_pad_ops,
 };
 
 static const struct v4l2_ctrl_ops au8522_ctrl_ops = {
diff --git a/drivers/media/i2c/ad9389b.c b/drivers/media/i2c/ad9389b.c
index 0462f46..4587d2f 100644
--- a/drivers/media/i2c/ad9389b.c
+++ b/drivers/media/i2c/ad9389b.c
@@ -574,7 +574,8 @@ static const struct v4l2_subdev_core_ops ad9389b_core_ops = {
 /* ------------------------------ VIDEO OPS ------------------------------ */
 
 /* Enable/disable ad9389b output */
-static int ad9389b_s_stream(struct v4l2_subdev *sd, int enable)
+static int ad9389b_s_stream(struct v4l2_subdev *sd, unsigned int pad,
+			    int enable)
 {
 	v4l2_dbg(1, debug, sd, "%s: %sable\n", __func__, (enable ? "en" : "dis"));
 
@@ -667,7 +668,6 @@ static int ad9389b_dv_timings_cap(struct v4l2_subdev *sd,
 }
 
 static const struct v4l2_subdev_video_ops ad9389b_video_ops = {
-	.s_stream = ad9389b_s_stream,
 	.s_dv_timings = ad9389b_s_dv_timings,
 	.g_dv_timings = ad9389b_g_dv_timings,
 };
@@ -699,6 +699,7 @@ static const struct v4l2_subdev_pad_ops ad9389b_pad_ops = {
 	.get_edid = ad9389b_get_edid,
 	.enum_dv_timings = ad9389b_enum_dv_timings,
 	.dv_timings_cap = ad9389b_dv_timings_cap,
+	.s_stream = ad9389b_s_stream,
 };
 
 /* ------------------------------ AUDIO OPS ------------------------------ */
@@ -1208,7 +1209,7 @@ static int ad9389b_remove(struct i2c_client *client)
 	v4l2_dbg(1, debug, sd, "%s removed @ 0x%x (%s)\n", client->name,
 		 client->addr << 1, client->adapter->name);
 
-	ad9389b_s_stream(sd, false);
+	ad9389b_s_stream(sd, 0, false);
 	ad9389b_s_audio_stream(sd, false);
 	ad9389b_init_setup(sd);
 	cancel_delayed_work(&state->edid_handler);
diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index b77b0a4..abe2dfc 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -746,7 +746,8 @@ static int adv7180_g_tvnorms(struct v4l2_subdev *sd, v4l2_std_id *norm)
 	return 0;
 }
 
-static int adv7180_s_stream(struct v4l2_subdev *sd, int enable)
+static int adv7180_s_stream(struct v4l2_subdev *sd, unsigned int pad,
+			    int enable)
 {
 	struct adv7180_state *state = to_state(sd);
 	int ret;
@@ -789,7 +790,6 @@ static const struct v4l2_subdev_video_ops adv7180_video_ops = {
 	.g_mbus_config = adv7180_g_mbus_config,
 	.cropcap = adv7180_cropcap,
 	.g_tvnorms = adv7180_g_tvnorms,
-	.s_stream = adv7180_s_stream,
 };
 
 static const struct v4l2_subdev_core_ops adv7180_core_ops = {
@@ -802,6 +802,7 @@ static const struct v4l2_subdev_pad_ops adv7180_pad_ops = {
 	.enum_mbus_code = adv7180_enum_mbus_code,
 	.set_fmt = adv7180_set_pad_format,
 	.get_fmt = adv7180_get_pad_format,
+	.s_stream = adv7180_s_stream,
 };
 
 static const struct v4l2_subdev_ops adv7180_ops = {
diff --git a/drivers/media/i2c/adv7183.c b/drivers/media/i2c/adv7183.c
index 2bec737..33577f0 100644
--- a/drivers/media/i2c/adv7183.c
+++ b/drivers/media/i2c/adv7183.c
@@ -472,7 +472,8 @@ static int adv7183_get_fmt(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static int adv7183_s_stream(struct v4l2_subdev *sd, int enable)
+static int adv7183_s_stream(struct v4l2_subdev *sd, unsigned int pad,
+			    int enable)
 {
 	struct adv7183 *decoder = to_adv7183(sd);
 
@@ -518,13 +519,13 @@ static const struct v4l2_subdev_video_ops adv7183_video_ops = {
 	.s_routing = adv7183_s_routing,
 	.querystd = adv7183_querystd,
 	.g_input_status = adv7183_g_input_status,
-	.s_stream = adv7183_s_stream,
 };
 
 static const struct v4l2_subdev_pad_ops adv7183_pad_ops = {
 	.enum_mbus_code = adv7183_enum_mbus_code,
 	.get_fmt = adv7183_get_fmt,
 	.set_fmt = adv7183_set_fmt,
+	.s_stream = adv7183_s_stream,
 };
 
 static const struct v4l2_subdev_ops adv7183_ops = {
diff --git a/drivers/media/i2c/adv7511.c b/drivers/media/i2c/adv7511.c
index 39271c3..3f58189 100644
--- a/drivers/media/i2c/adv7511.c
+++ b/drivers/media/i2c/adv7511.c
@@ -736,7 +736,8 @@ static const struct v4l2_subdev_core_ops adv7511_core_ops = {
 /* ------------------------------ VIDEO OPS ------------------------------ */
 
 /* Enable/disable adv7511 output */
-static int adv7511_s_stream(struct v4l2_subdev *sd, int enable)
+static int adv7511_s_stream(struct v4l2_subdev *sd, unsigned int pad,
+			    int enable)
 {
 	struct adv7511_state *state = get_adv7511_state(sd);
 
@@ -815,7 +816,6 @@ static int adv7511_dv_timings_cap(struct v4l2_subdev *sd,
 }
 
 static const struct v4l2_subdev_video_ops adv7511_video_ops = {
-	.s_stream = adv7511_s_stream,
 	.s_dv_timings = adv7511_s_dv_timings,
 	.g_dv_timings = adv7511_g_dv_timings,
 };
@@ -1143,6 +1143,7 @@ static const struct v4l2_subdev_pad_ops adv7511_pad_ops = {
 	.set_fmt = adv7511_set_fmt,
 	.enum_dv_timings = adv7511_enum_dv_timings,
 	.dv_timings_cap = adv7511_dv_timings_cap,
+	.s_stream = adv7511_s_stream,
 };
 
 /* --------------------- SUBDEV OPS --------------------------------------- */
@@ -1440,7 +1441,7 @@ static void adv7511_init_setup(struct v4l2_subdev *sd)
 	memset(edid, 0, sizeof(struct adv7511_state_edid));
 	state->have_monitor = false;
 	adv7511_set_isr(sd, false);
-	adv7511_s_stream(sd, false);
+	adv7511_s_stream(sd, 0, false);
 	adv7511_s_audio_stream(sd, false);
 }
 
diff --git a/drivers/media/i2c/ak881x.c b/drivers/media/i2c/ak881x.c
index d9f2b6b..e5fc540 100644
--- a/drivers/media/i2c/ak881x.c
+++ b/drivers/media/i2c/ak881x.c
@@ -172,7 +172,8 @@ static int ak881x_s_std_output(struct v4l2_subdev *sd, v4l2_std_id std)
 	return 0;
 }
 
-static int ak881x_s_stream(struct v4l2_subdev *sd, int enable)
+static int ak881x_s_stream(struct v4l2_subdev *sd, unsigned int pad,
+			   int enable)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct ak881x *ak881x = to_ak881x(client);
@@ -209,13 +210,13 @@ static struct v4l2_subdev_core_ops ak881x_subdev_core_ops = {
 static struct v4l2_subdev_video_ops ak881x_subdev_video_ops = {
 	.cropcap	= ak881x_cropcap,
 	.s_std_output	= ak881x_s_std_output,
-	.s_stream	= ak881x_s_stream,
 };
 
 static const struct v4l2_subdev_pad_ops ak881x_subdev_pad_ops = {
 	.enum_mbus_code = ak881x_enum_mbus_code,
 	.set_fmt	= ak881x_fill_fmt,
 	.get_fmt	= ak881x_fill_fmt,
+	.s_stream	= ak881x_s_stream,
 };
 
 static struct v4l2_subdev_ops ak881x_subdev_ops = {
diff --git a/drivers/media/i2c/bt819.c b/drivers/media/i2c/bt819.c
index 7907bcf..28b2013 100644
--- a/drivers/media/i2c/bt819.c
+++ b/drivers/media/i2c/bt819.c
@@ -323,7 +323,8 @@ static int bt819_s_routing(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static int bt819_s_stream(struct v4l2_subdev *sd, int enable)
+static int bt819_s_stream(struct v4l2_subdev *sd, unsigned int pad,
+			  int enable)
 {
 	struct bt819 *decoder = to_bt819(sd);
 
@@ -382,13 +383,17 @@ static const struct v4l2_ctrl_ops bt819_ctrl_ops = {
 static const struct v4l2_subdev_video_ops bt819_video_ops = {
 	.s_std = bt819_s_std,
 	.s_routing = bt819_s_routing,
-	.s_stream = bt819_s_stream,
 	.querystd = bt819_querystd,
 	.g_input_status = bt819_g_input_status,
 };
 
+static const struct v4l2_subdev_pad_ops bt819_pad_ops = {
+	.s_stream = bt819_s_stream,
+};
+
 static const struct v4l2_subdev_ops bt819_ops = {
 	.video = &bt819_video_ops,
+	.pad = &bt819_pad_ops,
 };
 
 /* ----------------------------------------------------------------------- */
diff --git a/drivers/media/i2c/cx25840/cx25840-core.c b/drivers/media/i2c/cx25840/cx25840-core.c
index 07a3e71..07ab5a1 100644
--- a/drivers/media/i2c/cx25840/cx25840-core.c
+++ b/drivers/media/i2c/cx25840/cx25840-core.c
@@ -1708,7 +1708,8 @@ static int cx25840_s_audio_stream(struct v4l2_subdev *sd, int enable)
 	return 0;
 }
 
-static int cx25840_s_stream(struct v4l2_subdev *sd, int enable)
+static int cx25840_s_stream(struct v4l2_subdev *sd, unsigned int pad,
+			    int enable)
 {
 	struct cx25840_state *state = to_state(sd);
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
@@ -5076,7 +5077,6 @@ static const struct v4l2_subdev_video_ops cx25840_video_ops = {
 	.s_std = cx25840_s_std,
 	.g_std = cx25840_g_std,
 	.s_routing = cx25840_s_video_routing,
-	.s_stream = cx25840_s_stream,
 	.g_input_status = cx25840_g_input_status,
 };
 
@@ -5089,6 +5089,7 @@ static const struct v4l2_subdev_vbi_ops cx25840_vbi_ops = {
 
 static const struct v4l2_subdev_pad_ops cx25840_pad_ops = {
 	.set_fmt = cx25840_set_fmt,
+	.s_stream = cx25840_s_stream,
 };
 
 static const struct v4l2_subdev_ops cx25840_ops = {
diff --git a/drivers/media/i2c/ks0127.c b/drivers/media/i2c/ks0127.c
index 77551ba..97458ce 100644
--- a/drivers/media/i2c/ks0127.c
+++ b/drivers/media/i2c/ks0127.c
@@ -588,7 +588,8 @@ static int ks0127_s_std(struct v4l2_subdev *sd, v4l2_std_id std)
 	return 0;
 }
 
-static int ks0127_s_stream(struct v4l2_subdev *sd, int enable)
+static int ks0127_s_stream(struct v4l2_subdev *sd, unsigned int pad,
+			   int enable)
 {
 	v4l2_dbg(1, debug, sd, "s_stream(%d)\n", enable);
 	if (enable) {
@@ -651,13 +652,17 @@ static int ks0127_g_input_status(struct v4l2_subdev *sd, u32 *status)
 static const struct v4l2_subdev_video_ops ks0127_video_ops = {
 	.s_std = ks0127_s_std,
 	.s_routing = ks0127_s_routing,
-	.s_stream = ks0127_s_stream,
 	.querystd = ks0127_querystd,
 	.g_input_status = ks0127_g_input_status,
 };
 
+static const struct v4l2_subdev_pad_ops ks0127_pad_ops = {
+	.s_stream = ks0127_s_stream,
+};
+
 static const struct v4l2_subdev_ops ks0127_ops = {
 	.video = &ks0127_video_ops,
+	.pad = &ks0127_pad_ops,
 };
 
 /* ----------------------------------------------------------------------- */
diff --git a/drivers/media/i2c/m5mols/m5mols_core.c b/drivers/media/i2c/m5mols/m5mols_core.c
index acb804b..6432396 100644
--- a/drivers/media/i2c/m5mols/m5mols_core.c
+++ b/drivers/media/i2c/m5mols/m5mols_core.c
@@ -651,14 +651,6 @@ static int m5mols_enum_mbus_code(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static struct v4l2_subdev_pad_ops m5mols_pad_ops = {
-	.enum_mbus_code	= m5mols_enum_mbus_code,
-	.get_fmt	= m5mols_get_fmt,
-	.set_fmt	= m5mols_set_fmt,
-	.get_frame_desc	= m5mols_get_frame_desc,
-	.set_frame_desc	= m5mols_set_frame_desc,
-};
-
 /**
  * m5mols_restore_controls - Apply current control values to the registers
  *
@@ -707,7 +699,8 @@ static int m5mols_start_monitor(struct m5mols_info *info)
 	return ret;
 }
 
-static int m5mols_s_stream(struct v4l2_subdev *sd, int enable)
+static int m5mols_s_stream(struct v4l2_subdev *sd, unsigned int pad,
+			   int enable)
 {
 	struct m5mols_info *info = to_m5mols(sd);
 	u32 code;
@@ -731,7 +724,12 @@ static int m5mols_s_stream(struct v4l2_subdev *sd, int enable)
 	return ret;
 }
 
-static const struct v4l2_subdev_video_ops m5mols_video_ops = {
+static struct v4l2_subdev_pad_ops m5mols_pad_ops = {
+	.enum_mbus_code	= m5mols_enum_mbus_code,
+	.get_fmt	= m5mols_get_fmt,
+	.set_fmt	= m5mols_set_fmt,
+	.get_frame_desc	= m5mols_get_frame_desc,
+	.set_frame_desc	= m5mols_set_frame_desc,
 	.s_stream	= m5mols_s_stream,
 };
 
@@ -908,7 +906,6 @@ static const struct v4l2_subdev_internal_ops m5mols_subdev_internal_ops = {
 static const struct v4l2_subdev_ops m5mols_ops = {
 	.core		= &m5mols_core_ops,
 	.pad		= &m5mols_pad_ops,
-	.video		= &m5mols_video_ops,
 };
 
 static irqreturn_t m5mols_irq_handler(int irq, void *data)
diff --git a/drivers/media/i2c/mt9m032.c b/drivers/media/i2c/mt9m032.c
index da07679..7e2b09e 100644
--- a/drivers/media/i2c/mt9m032.c
+++ b/drivers/media/i2c/mt9m032.c
@@ -536,7 +536,8 @@ done:
 	return ret;
 }
 
-static int mt9m032_s_stream(struct v4l2_subdev *subdev, int streaming)
+static int mt9m032_s_stream(struct v4l2_subdev *subdev, unsigned int pad,
+			    int streaming)
 {
 	struct mt9m032 *sensor = to_mt9m032(subdev);
 	int ret;
@@ -686,7 +687,6 @@ static const struct v4l2_subdev_core_ops mt9m032_core_ops = {
 };
 
 static const struct v4l2_subdev_video_ops mt9m032_video_ops = {
-	.s_stream = mt9m032_s_stream,
 	.g_frame_interval = mt9m032_get_frame_interval,
 	.s_frame_interval = mt9m032_set_frame_interval,
 };
@@ -698,6 +698,7 @@ static const struct v4l2_subdev_pad_ops mt9m032_pad_ops = {
 	.set_fmt = mt9m032_set_pad_format,
 	.set_selection = mt9m032_set_pad_selection,
 	.get_selection = mt9m032_get_pad_selection,
+	.s_stream = mt9m032_s_stream,
 };
 
 static const struct v4l2_subdev_ops mt9m032_ops = {
diff --git a/drivers/media/i2c/mt9p031.c b/drivers/media/i2c/mt9p031.c
index 237737f..b0519e63 100644
--- a/drivers/media/i2c/mt9p031.c
+++ b/drivers/media/i2c/mt9p031.c
@@ -445,7 +445,8 @@ static int mt9p031_set_params(struct mt9p031 *mt9p031)
 	return ret;
 }
 
-static int mt9p031_s_stream(struct v4l2_subdev *subdev, int enable)
+static int mt9p031_s_stream(struct v4l2_subdev *subdev, unsigned int pad,
+			    int enable)
 {
 	struct mt9p031 *mt9p031 = to_mt9p031(subdev);
 	int ret;
@@ -976,10 +977,6 @@ static struct v4l2_subdev_core_ops mt9p031_subdev_core_ops = {
 	.s_power        = mt9p031_set_power,
 };
 
-static struct v4l2_subdev_video_ops mt9p031_subdev_video_ops = {
-	.s_stream       = mt9p031_s_stream,
-};
-
 static struct v4l2_subdev_pad_ops mt9p031_subdev_pad_ops = {
 	.enum_mbus_code = mt9p031_enum_mbus_code,
 	.enum_frame_size = mt9p031_enum_frame_size,
@@ -987,11 +984,11 @@ static struct v4l2_subdev_pad_ops mt9p031_subdev_pad_ops = {
 	.set_fmt = mt9p031_set_format,
 	.get_selection = mt9p031_get_selection,
 	.set_selection = mt9p031_set_selection,
+	.s_stream = mt9p031_s_stream,
 };
 
 static struct v4l2_subdev_ops mt9p031_subdev_ops = {
 	.core   = &mt9p031_subdev_core_ops,
-	.video  = &mt9p031_subdev_video_ops,
 	.pad    = &mt9p031_subdev_pad_ops,
 };
 
diff --git a/drivers/media/i2c/mt9t001.c b/drivers/media/i2c/mt9t001.c
index 702d562..7668ff6 100644
--- a/drivers/media/i2c/mt9t001.c
+++ b/drivers/media/i2c/mt9t001.c
@@ -271,7 +271,8 @@ __mt9t001_get_pad_crop(struct mt9t001 *mt9t001, struct v4l2_subdev_pad_config *c
 	}
 }
 
-static int mt9t001_s_stream(struct v4l2_subdev *subdev, int enable)
+static int mt9t001_s_stream(struct v4l2_subdev *subdev, unsigned int pad,
+			    int enable)
 {
 	const u16 mode = MT9T001_OUTPUT_CONTROL_CHIP_ENABLE;
 	struct i2c_client *client = v4l2_get_subdevdata(subdev);
@@ -815,10 +816,6 @@ static struct v4l2_subdev_core_ops mt9t001_subdev_core_ops = {
 	.s_power = mt9t001_set_power,
 };
 
-static struct v4l2_subdev_video_ops mt9t001_subdev_video_ops = {
-	.s_stream = mt9t001_s_stream,
-};
-
 static struct v4l2_subdev_pad_ops mt9t001_subdev_pad_ops = {
 	.enum_mbus_code = mt9t001_enum_mbus_code,
 	.enum_frame_size = mt9t001_enum_frame_size,
@@ -826,11 +823,11 @@ static struct v4l2_subdev_pad_ops mt9t001_subdev_pad_ops = {
 	.set_fmt = mt9t001_set_format,
 	.get_selection = mt9t001_get_selection,
 	.set_selection = mt9t001_set_selection,
+	.s_stream = mt9t001_s_stream,
 };
 
 static struct v4l2_subdev_ops mt9t001_subdev_ops = {
 	.core = &mt9t001_subdev_core_ops,
-	.video = &mt9t001_subdev_video_ops,
 	.pad = &mt9t001_subdev_pad_ops,
 };
 
diff --git a/drivers/media/i2c/mt9v032.c b/drivers/media/i2c/mt9v032.c
index 501b370..da04e09 100644
--- a/drivers/media/i2c/mt9v032.c
+++ b/drivers/media/i2c/mt9v032.c
@@ -419,7 +419,8 @@ __mt9v032_get_pad_crop(struct mt9v032 *mt9v032, struct v4l2_subdev_pad_config *c
 	}
 }
 
-static int mt9v032_s_stream(struct v4l2_subdev *subdev, int enable)
+static int mt9v032_s_stream(struct v4l2_subdev *subdev, unsigned int pad,
+			    int enable)
 {
 	const u16 mode = MT9V032_CHIP_CONTROL_MASTER_MODE
 		       | MT9V032_CHIP_CONTROL_DOUT_ENABLE
@@ -861,10 +862,6 @@ static struct v4l2_subdev_core_ops mt9v032_subdev_core_ops = {
 	.s_power	= mt9v032_set_power,
 };
 
-static struct v4l2_subdev_video_ops mt9v032_subdev_video_ops = {
-	.s_stream	= mt9v032_s_stream,
-};
-
 static struct v4l2_subdev_pad_ops mt9v032_subdev_pad_ops = {
 	.enum_mbus_code = mt9v032_enum_mbus_code,
 	.enum_frame_size = mt9v032_enum_frame_size,
@@ -872,11 +869,11 @@ static struct v4l2_subdev_pad_ops mt9v032_subdev_pad_ops = {
 	.set_fmt = mt9v032_set_format,
 	.get_selection = mt9v032_get_selection,
 	.set_selection = mt9v032_set_selection,
+	.s_stream = mt9v032_s_stream,
 };
 
 static struct v4l2_subdev_ops mt9v032_subdev_ops = {
 	.core	= &mt9v032_subdev_core_ops,
-	.video	= &mt9v032_subdev_video_ops,
 	.pad	= &mt9v032_subdev_pad_ops,
 };
 
diff --git a/drivers/media/i2c/noon010pc30.c b/drivers/media/i2c/noon010pc30.c
index 30cb90b..90c1cce 100644
--- a/drivers/media/i2c/noon010pc30.c
+++ b/drivers/media/i2c/noon010pc30.c
@@ -611,7 +611,7 @@ static int noon010_s_power(struct v4l2_subdev *sd, int on)
 	return ret;
 }
 
-static int noon010_s_stream(struct v4l2_subdev *sd, int on)
+static int noon010_s_stream(struct v4l2_subdev *sd, unsigned int pad, int on)
 {
 	struct noon010_info *info = to_noon010(sd);
 	int ret = 0;
@@ -668,16 +668,12 @@ static struct v4l2_subdev_pad_ops noon010_pad_ops = {
 	.enum_mbus_code	= noon010_enum_mbus_code,
 	.get_fmt	= noon010_get_fmt,
 	.set_fmt	= noon010_set_fmt,
-};
-
-static struct v4l2_subdev_video_ops noon010_video_ops = {
 	.s_stream	= noon010_s_stream,
 };
 
 static const struct v4l2_subdev_ops noon010_ops = {
 	.core	= &noon010_core_ops,
 	.pad	= &noon010_pad_ops,
-	.video	= &noon010_video_ops,
 };
 
 /* Return 0 if NOON010PC30L sensor type was detected or -ENODEV otherwise. */
diff --git a/drivers/media/i2c/ov2659.c b/drivers/media/i2c/ov2659.c
index 1f999e9..dbe8f86 100644
--- a/drivers/media/i2c/ov2659.c
+++ b/drivers/media/i2c/ov2659.c
@@ -1180,7 +1180,7 @@ static int ov2659_set_format(struct ov2659 *ov2659)
 	return ov2659_write_array(ov2659->client, ov2659->format_ctrl_regs);
 }
 
-static int ov2659_s_stream(struct v4l2_subdev *sd, int on)
+static int ov2659_s_stream(struct v4l2_subdev *sd, unsigned int pad, int on)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct ov2659 *ov2659 = to_ov2659(sd);
@@ -1283,21 +1283,17 @@ static const struct v4l2_subdev_core_ops ov2659_subdev_core_ops = {
 	.unsubscribe_event = v4l2_event_subdev_unsubscribe,
 };
 
-static const struct v4l2_subdev_video_ops ov2659_subdev_video_ops = {
-	.s_stream = ov2659_s_stream,
-};
-
 static const struct v4l2_subdev_pad_ops ov2659_subdev_pad_ops = {
 	.enum_mbus_code = ov2659_enum_mbus_code,
 	.enum_frame_size = ov2659_enum_frame_sizes,
 	.get_fmt = ov2659_get_fmt,
 	.set_fmt = ov2659_set_fmt,
+	.s_stream = ov2659_s_stream,
 };
 
 #ifdef CONFIG_VIDEO_V4L2_SUBDEV_API
 static const struct v4l2_subdev_ops ov2659_subdev_ops = {
 	.core  = &ov2659_subdev_core_ops,
-	.video = &ov2659_subdev_video_ops,
 	.pad   = &ov2659_subdev_pad_ops,
 };
 
diff --git a/drivers/media/i2c/ov9650.c b/drivers/media/i2c/ov9650.c
index be5a7fd..6de42f4 100644
--- a/drivers/media/i2c/ov9650.c
+++ b/drivers/media/i2c/ov9650.c
@@ -1317,7 +1317,7 @@ static int __ov965x_set_params(struct ov965x *ov965x)
 	return ov965x_set_banding_filter(ov965x, ctrls->light_freq->val);
 }
 
-static int ov965x_s_stream(struct v4l2_subdev *sd, int on)
+static int ov965x_s_stream(struct v4l2_subdev *sd, unsigned int pad, int on)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct ov965x *ov965x = to_ov965x(sd);
@@ -1372,10 +1372,10 @@ static const struct v4l2_subdev_pad_ops ov965x_pad_ops = {
 	.enum_frame_size = ov965x_enum_frame_sizes,
 	.get_fmt = ov965x_get_fmt,
 	.set_fmt = ov965x_set_fmt,
+	.s_stream = ov965x_s_stream,
 };
 
 static const struct v4l2_subdev_video_ops ov965x_video_ops = {
-	.s_stream = ov965x_s_stream,
 	.g_frame_interval = ov965x_g_frame_interval,
 	.s_frame_interval = ov965x_s_frame_interval,
 
diff --git a/drivers/media/i2c/s5c73m3/s5c73m3-core.c b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
index 08af58f..162afb8 100644
--- a/drivers/media/i2c/s5c73m3/s5c73m3-core.c
+++ b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
@@ -455,7 +455,8 @@ static int __s5c73m3_s_stream(struct s5c73m3 *state, struct v4l2_subdev *sd,
 	return s5c73m3_check_status(state, REG_STATUS_ISP_COMMAND_COMPLETED);
 }
 
-static int s5c73m3_oif_s_stream(struct v4l2_subdev *sd, int on)
+static int s5c73m3_oif_s_stream(struct v4l2_subdev *sd, unsigned int pad,
+				int on)
 {
 	struct s5c73m3 *state = oif_sd_to_s5c73m3(sd);
 	int ret;
@@ -1528,6 +1529,7 @@ static const struct v4l2_subdev_pad_ops s5c73m3_oif_pad_ops = {
 	.set_fmt		= s5c73m3_oif_set_fmt,
 	.get_frame_desc		= s5c73m3_oif_get_frame_desc,
 	.set_frame_desc		= s5c73m3_oif_set_frame_desc,
+	.s_stream		= s5c73m3_oif_s_stream,
 };
 
 static const struct v4l2_subdev_core_ops s5c73m3_oif_core_ops = {
@@ -1536,7 +1538,6 @@ static const struct v4l2_subdev_core_ops s5c73m3_oif_core_ops = {
 };
 
 static const struct v4l2_subdev_video_ops s5c73m3_oif_video_ops = {
-	.s_stream		= s5c73m3_oif_s_stream,
 	.g_frame_interval	= s5c73m3_oif_g_frame_interval,
 	.s_frame_interval	= s5c73m3_oif_s_frame_interval,
 };
diff --git a/drivers/media/i2c/s5k4ecgx.c b/drivers/media/i2c/s5k4ecgx.c
index 8a0f22d..09de207 100644
--- a/drivers/media/i2c/s5k4ecgx.c
+++ b/drivers/media/i2c/s5k4ecgx.c
@@ -616,10 +616,98 @@ static int s5k4ecgx_set_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_pad_confi
 	return ret;
 }
 
+static int __s5k4ecgx_s_params(struct s5k4ecgx *priv)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(&priv->sd);
+	const struct v4l2_rect *crop_rect = &priv->curr_frmsize->input_window;
+	int ret;
+
+	ret = s5k4ecgx_set_input_window(client, crop_rect);
+	if (!ret)
+		ret = s5k4ecgx_set_zoom_window(client, crop_rect);
+	if (!ret)
+		ret = s5k4ecgx_write(client, REG_G_INPUTS_CHANGE_REQ, 1);
+	if (!ret)
+		ret = s5k4ecgx_write(client, 0x70000a1e, 0x28);
+	if (!ret)
+		ret = s5k4ecgx_write(client, 0x70000ad4, 0x3c);
+	if (!ret)
+		ret = s5k4ecgx_set_output_framefmt(priv);
+	if (!ret)
+		ret = s5k4ecgx_write(client, REG_P_PVI_MASK(0), 0x52);
+	if (!ret)
+		ret = s5k4ecgx_write(client, REG_P_FR_TIME_TYPE(0),
+				     FR_TIME_DYNAMIC);
+	if (!ret)
+		ret = s5k4ecgx_write(client, REG_P_FR_TIME_Q_TYPE(0),
+				     FR_TIME_Q_BEST_FRRATE);
+	if (!ret)
+		ret = s5k4ecgx_write(client,  REG_P_MIN_FR_TIME(0),
+				     US_TO_FR_TIME(33300));
+	if (!ret)
+		ret = s5k4ecgx_write(client, REG_P_MAX_FR_TIME(0),
+				     US_TO_FR_TIME(66600));
+	if (!ret)
+		ret = s5k4ecgx_write(client, REG_P_PREV_MIRROR(0), 0);
+	if (!ret)
+		ret = s5k4ecgx_write(client, REG_P_CAP_MIRROR(0), 0);
+	if (!ret)
+		ret = s5k4ecgx_write(client, REG_G_ACTIVE_PREV_CFG, 0);
+	if (!ret)
+		ret = s5k4ecgx_write(client, REG_G_PREV_OPEN_AFTER_CH, 1);
+	if (!ret)
+		ret = s5k4ecgx_write(client, REG_G_NEW_CFG_SYNC, 1);
+	if (!ret)
+		ret = s5k4ecgx_write(client, REG_G_PREV_CFG_CHG, 1);
+
+	return ret;
+}
+
+static int __s5k4ecgx_s_stream(struct s5k4ecgx *priv, int on)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(&priv->sd);
+	int ret;
+
+	if (on && priv->set_params) {
+		ret = __s5k4ecgx_s_params(priv);
+		if (ret < 0)
+			return ret;
+		priv->set_params = 0;
+	}
+	/*
+	 * This enables/disables preview stream only. Capture requests
+	 * are not supported yet.
+	 */
+	ret = s5k4ecgx_write(client, REG_G_ENABLE_PREV, on);
+	if (ret < 0)
+		return ret;
+	return s5k4ecgx_write(client, REG_G_ENABLE_PREV_CHG, 1);
+}
+
+static int s5k4ecgx_s_stream(struct v4l2_subdev *sd, unsigned int pad, int on)
+{
+	struct s5k4ecgx *priv = to_s5k4ecgx(sd);
+	int ret = 0;
+
+	v4l2_dbg(1, debug, sd, "Turn streaming %s\n", on ? "on" : "off");
+
+	mutex_lock(&priv->lock);
+
+	if (priv->streaming == !on) {
+		ret = __s5k4ecgx_s_stream(priv, on);
+		if (!ret)
+			priv->streaming = on & 1;
+	}
+
+	mutex_unlock(&priv->lock);
+	return ret;
+}
+
 static const struct v4l2_subdev_pad_ops s5k4ecgx_pad_ops = {
 	.enum_mbus_code	= s5k4ecgx_enum_mbus_code,
 	.get_fmt	= s5k4ecgx_get_fmt,
 	.set_fmt	= s5k4ecgx_set_fmt,
+	.s_stream	= s5k4ecgx_s_stream,
 };
 
 /*
@@ -745,101 +833,9 @@ static const struct v4l2_subdev_core_ops s5k4ecgx_core_ops = {
 	.log_status	= s5k4ecgx_log_status,
 };
 
-static int __s5k4ecgx_s_params(struct s5k4ecgx *priv)
-{
-	struct i2c_client *client = v4l2_get_subdevdata(&priv->sd);
-	const struct v4l2_rect *crop_rect = &priv->curr_frmsize->input_window;
-	int ret;
-
-	ret = s5k4ecgx_set_input_window(client, crop_rect);
-	if (!ret)
-		ret = s5k4ecgx_set_zoom_window(client, crop_rect);
-	if (!ret)
-		ret = s5k4ecgx_write(client, REG_G_INPUTS_CHANGE_REQ, 1);
-	if (!ret)
-		ret = s5k4ecgx_write(client, 0x70000a1e, 0x28);
-	if (!ret)
-		ret = s5k4ecgx_write(client, 0x70000ad4, 0x3c);
-	if (!ret)
-		ret = s5k4ecgx_set_output_framefmt(priv);
-	if (!ret)
-		ret = s5k4ecgx_write(client, REG_P_PVI_MASK(0), 0x52);
-	if (!ret)
-		ret = s5k4ecgx_write(client, REG_P_FR_TIME_TYPE(0),
-				     FR_TIME_DYNAMIC);
-	if (!ret)
-		ret = s5k4ecgx_write(client, REG_P_FR_TIME_Q_TYPE(0),
-				     FR_TIME_Q_BEST_FRRATE);
-	if (!ret)
-		ret = s5k4ecgx_write(client,  REG_P_MIN_FR_TIME(0),
-				     US_TO_FR_TIME(33300));
-	if (!ret)
-		ret = s5k4ecgx_write(client, REG_P_MAX_FR_TIME(0),
-				     US_TO_FR_TIME(66600));
-	if (!ret)
-		ret = s5k4ecgx_write(client, REG_P_PREV_MIRROR(0), 0);
-	if (!ret)
-		ret = s5k4ecgx_write(client, REG_P_CAP_MIRROR(0), 0);
-	if (!ret)
-		ret = s5k4ecgx_write(client, REG_G_ACTIVE_PREV_CFG, 0);
-	if (!ret)
-		ret = s5k4ecgx_write(client, REG_G_PREV_OPEN_AFTER_CH, 1);
-	if (!ret)
-		ret = s5k4ecgx_write(client, REG_G_NEW_CFG_SYNC, 1);
-	if (!ret)
-		ret = s5k4ecgx_write(client, REG_G_PREV_CFG_CHG, 1);
-
-	return ret;
-}
-
-static int __s5k4ecgx_s_stream(struct s5k4ecgx *priv, int on)
-{
-	struct i2c_client *client = v4l2_get_subdevdata(&priv->sd);
-	int ret;
-
-	if (on && priv->set_params) {
-		ret = __s5k4ecgx_s_params(priv);
-		if (ret < 0)
-			return ret;
-		priv->set_params = 0;
-	}
-	/*
-	 * This enables/disables preview stream only. Capture requests
-	 * are not supported yet.
-	 */
-	ret = s5k4ecgx_write(client, REG_G_ENABLE_PREV, on);
-	if (ret < 0)
-		return ret;
-	return s5k4ecgx_write(client, REG_G_ENABLE_PREV_CHG, 1);
-}
-
-static int s5k4ecgx_s_stream(struct v4l2_subdev *sd, int on)
-{
-	struct s5k4ecgx *priv = to_s5k4ecgx(sd);
-	int ret = 0;
-
-	v4l2_dbg(1, debug, sd, "Turn streaming %s\n", on ? "on" : "off");
-
-	mutex_lock(&priv->lock);
-
-	if (priv->streaming == !on) {
-		ret = __s5k4ecgx_s_stream(priv, on);
-		if (!ret)
-			priv->streaming = on & 1;
-	}
-
-	mutex_unlock(&priv->lock);
-	return ret;
-}
-
-static const struct v4l2_subdev_video_ops s5k4ecgx_video_ops = {
-	.s_stream = s5k4ecgx_s_stream,
-};
-
 static const struct v4l2_subdev_ops s5k4ecgx_ops = {
 	.core = &s5k4ecgx_core_ops,
 	.pad = &s5k4ecgx_pad_ops,
-	.video = &s5k4ecgx_video_ops,
 };
 
 /*
diff --git a/drivers/media/i2c/s5k5baf.c b/drivers/media/i2c/s5k5baf.c
index db82ed0..d1a7cd8 100644
--- a/drivers/media/i2c/s5k5baf.c
+++ b/drivers/media/i2c/s5k5baf.c
@@ -1100,7 +1100,7 @@ static void s5k5baf_hw_set_stream(struct s5k5baf *state, int enable)
 	s5k5baf_write_seq(state, REG_G_ENABLE_PREV, enable, 1);
 }
 
-static int s5k5baf_s_stream(struct v4l2_subdev *sd, int on)
+static int s5k5baf_s_stream(struct v4l2_subdev *sd, unsigned int pad, int on)
 {
 	struct s5k5baf *state = to_s5k5baf(sd);
 	int ret;
@@ -1536,12 +1536,12 @@ static const struct v4l2_subdev_pad_ops s5k5baf_pad_ops = {
 	.set_fmt		= s5k5baf_set_fmt,
 	.get_selection		= s5k5baf_get_selection,
 	.set_selection		= s5k5baf_set_selection,
+	.s_stream		= s5k5baf_s_stream,
 };
 
 static const struct v4l2_subdev_video_ops s5k5baf_video_ops = {
 	.g_frame_interval	= s5k5baf_g_frame_interval,
 	.s_frame_interval	= s5k5baf_s_frame_interval,
-	.s_stream		= s5k5baf_s_stream,
 };
 
 /*
diff --git a/drivers/media/i2c/s5k6aa.c b/drivers/media/i2c/s5k6aa.c
index faee113..e6bf573 100644
--- a/drivers/media/i2c/s5k6aa.c
+++ b/drivers/media/i2c/s5k6aa.c
@@ -910,7 +910,7 @@ static int __s5k6aa_stream(struct s5k6aa *s5k6aa, int enable)
 	return ret;
 }
 
-static int s5k6aa_s_stream(struct v4l2_subdev *sd, int on)
+static int s5k6aa_s_stream(struct v4l2_subdev *sd, unsigned int pad, int on)
 {
 	struct s5k6aa *s5k6aa = to_s5k6aa(sd);
 	int ret = 0;
@@ -1234,12 +1234,12 @@ static const struct v4l2_subdev_pad_ops s5k6aa_pad_ops = {
 	.set_fmt		= s5k6aa_set_fmt,
 	.get_selection		= s5k6aa_get_selection,
 	.set_selection		= s5k6aa_set_selection,
+	.s_stream		= s5k6aa_s_stream,
 };
 
 static const struct v4l2_subdev_video_ops s5k6aa_video_ops = {
 	.g_frame_interval	= s5k6aa_g_frame_interval,
 	.s_frame_interval	= s5k6aa_s_frame_interval,
-	.s_stream		= s5k6aa_s_stream,
 };
 
 /*
diff --git a/drivers/media/i2c/saa7110.c b/drivers/media/i2c/saa7110.c
index 6f49886..cfb692c 100644
--- a/drivers/media/i2c/saa7110.c
+++ b/drivers/media/i2c/saa7110.c
@@ -316,7 +316,8 @@ static int saa7110_s_routing(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static int saa7110_s_stream(struct v4l2_subdev *sd, int enable)
+static int saa7110_s_stream(struct v4l2_subdev *sd, unsigned int pad,
+			    int enable)
 {
 	struct saa7110 *decoder = to_saa7110(sd);
 
@@ -360,13 +361,17 @@ static const struct v4l2_ctrl_ops saa7110_ctrl_ops = {
 static const struct v4l2_subdev_video_ops saa7110_video_ops = {
 	.s_std = saa7110_s_std,
 	.s_routing = saa7110_s_routing,
-	.s_stream = saa7110_s_stream,
 	.querystd = saa7110_querystd,
 	.g_input_status = saa7110_g_input_status,
 };
 
+static const struct v4l2_subdev_pad_ops saa7110_pad_ops = {
+	.s_stream = saa7110_s_stream,
+};
+
 static const struct v4l2_subdev_ops saa7110_ops = {
 	.video = &saa7110_video_ops,
+	.pad = &saa7110_pad_ops,
 };
 
 /* ----------------------------------------------------------------------- */
diff --git a/drivers/media/i2c/saa7115.c b/drivers/media/i2c/saa7115.c
index bd3526b..572c77d 100644
--- a/drivers/media/i2c/saa7115.c
+++ b/drivers/media/i2c/saa7115.c
@@ -1366,7 +1366,8 @@ static int saa711x_s_gpio(struct v4l2_subdev *sd, u32 val)
 	return 0;
 }
 
-static int saa711x_s_stream(struct v4l2_subdev *sd, int enable)
+static int saa711x_s_stream(struct v4l2_subdev *sd, unsigned int pad,
+			    int enable)
 {
 	struct saa711x_state *state = to_state(sd);
 
@@ -1613,7 +1614,6 @@ static const struct v4l2_subdev_video_ops saa711x_video_ops = {
 	.s_std = saa711x_s_std,
 	.s_routing = saa711x_s_routing,
 	.s_crystal_freq = saa711x_s_crystal_freq,
-	.s_stream = saa711x_s_stream,
 	.querystd = saa711x_querystd,
 	.g_input_status = saa711x_g_input_status,
 };
@@ -1628,6 +1628,7 @@ static const struct v4l2_subdev_vbi_ops saa711x_vbi_ops = {
 
 static const struct v4l2_subdev_pad_ops saa711x_pad_ops = {
 	.set_fmt = saa711x_set_fmt,
+	.s_stream = saa711x_s_stream,
 };
 
 static const struct v4l2_subdev_ops saa711x_ops = {
diff --git a/drivers/media/i2c/saa7127.c b/drivers/media/i2c/saa7127.c
index 8d94dcb..e03a043 100644
--- a/drivers/media/i2c/saa7127.c
+++ b/drivers/media/i2c/saa7127.c
@@ -616,7 +616,8 @@ static int saa7127_s_routing(struct v4l2_subdev *sd,
 	return rc;
 }
 
-static int saa7127_s_stream(struct v4l2_subdev *sd, int enable)
+static int saa7127_s_stream(struct v4l2_subdev *sd, unsigned int pad,
+			    int enable)
 {
 	struct saa7127_state *state = to_state(sd);
 
@@ -705,7 +706,6 @@ static const struct v4l2_subdev_core_ops saa7127_core_ops = {
 static const struct v4l2_subdev_video_ops saa7127_video_ops = {
 	.s_std_output = saa7127_s_std_output,
 	.s_routing = saa7127_s_routing,
-	.s_stream = saa7127_s_stream,
 };
 
 static const struct v4l2_subdev_vbi_ops saa7127_vbi_ops = {
@@ -713,10 +713,15 @@ static const struct v4l2_subdev_vbi_ops saa7127_vbi_ops = {
 	.g_sliced_fmt = saa7127_g_sliced_fmt,
 };
 
+static const struct v4l2_subdev_pad_ops saa7127_pad_ops = {
+	.s_stream = saa7127_s_stream,
+};
+
 static const struct v4l2_subdev_ops saa7127_ops = {
 	.core = &saa7127_core_ops,
 	.video = &saa7127_video_ops,
 	.vbi = &saa7127_vbi_ops,
+	.pad = &saa7127_pad_ops,
 };
 
 /* ----------------------------------------------------------------------- */
diff --git a/drivers/media/i2c/saa717x.c b/drivers/media/i2c/saa717x.c
index 1baca37..cd8154f 100644
--- a/drivers/media/i2c/saa717x.c
+++ b/drivers/media/i2c/saa717x.c
@@ -1096,7 +1096,8 @@ static int saa717x_s_audio_routing(struct v4l2_subdev *sd,
 	return -ERANGE;
 }
 
-static int saa717x_s_stream(struct v4l2_subdev *sd, int enable)
+static int saa717x_s_stream(struct v4l2_subdev *sd, unsigned int pad,
+			    int enable)
 {
 	struct saa717x_state *decoder = to_state(sd);
 
@@ -1216,7 +1217,6 @@ static const struct v4l2_subdev_tuner_ops saa717x_tuner_ops = {
 static const struct v4l2_subdev_video_ops saa717x_video_ops = {
 	.s_std = saa717x_s_std,
 	.s_routing = saa717x_s_video_routing,
-	.s_stream = saa717x_s_stream,
 };
 
 static const struct v4l2_subdev_audio_ops saa717x_audio_ops = {
@@ -1225,6 +1225,7 @@ static const struct v4l2_subdev_audio_ops saa717x_audio_ops = {
 
 static const struct v4l2_subdev_pad_ops saa717x_pad_ops = {
 	.set_fmt = saa717x_set_fmt,
+	.s_stream = saa717x_s_stream,
 };
 
 static const struct v4l2_subdev_ops saa717x_ops = {
diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 3dfe387..2732de2 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -1537,7 +1537,8 @@ out:
  * V4L2 subdev video operations
  */
 
-static int smiapp_set_stream(struct v4l2_subdev *subdev, int enable)
+static int smiapp_set_stream(struct v4l2_subdev *subdev, unsigned int pad,
+			     int enable)
 {
 	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
 	int rval;
@@ -2883,10 +2884,6 @@ static int smiapp_close(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
 	return smiapp_set_power(sd, 0);
 }
 
-static const struct v4l2_subdev_video_ops smiapp_video_ops = {
-	.s_stream = smiapp_set_stream,
-};
-
 static const struct v4l2_subdev_core_ops smiapp_core_ops = {
 	.s_power = smiapp_set_power,
 };
@@ -2897,6 +2894,7 @@ static const struct v4l2_subdev_pad_ops smiapp_pad_ops = {
 	.set_fmt = smiapp_set_format,
 	.get_selection = smiapp_get_selection,
 	.set_selection = smiapp_set_selection,
+	.s_stream = smiapp_set_stream,
 };
 
 static const struct v4l2_subdev_sensor_ops smiapp_sensor_ops = {
@@ -2906,7 +2904,6 @@ static const struct v4l2_subdev_sensor_ops smiapp_sensor_ops = {
 
 static const struct v4l2_subdev_ops smiapp_ops = {
 	.core = &smiapp_core_ops,
-	.video = &smiapp_video_ops,
 	.pad = &smiapp_pad_ops,
 	.sensor = &smiapp_sensor_ops,
 };
diff --git a/drivers/media/i2c/soc_camera/imx074.c b/drivers/media/i2c/soc_camera/imx074.c
index f68c235..11cc992 100644
--- a/drivers/media/i2c/soc_camera/imx074.c
+++ b/drivers/media/i2c/soc_camera/imx074.c
@@ -248,7 +248,8 @@ static int imx074_enum_mbus_code(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static int imx074_s_stream(struct v4l2_subdev *sd, int enable)
+static int imx074_s_stream(struct v4l2_subdev *sd, unsigned int pad,
+			   int enable)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
@@ -277,7 +278,6 @@ static int imx074_g_mbus_config(struct v4l2_subdev *sd,
 }
 
 static struct v4l2_subdev_video_ops imx074_subdev_video_ops = {
-	.s_stream	= imx074_s_stream,
 	.g_crop		= imx074_g_crop,
 	.cropcap	= imx074_cropcap,
 	.g_mbus_config	= imx074_g_mbus_config,
@@ -291,6 +291,7 @@ static const struct v4l2_subdev_pad_ops imx074_subdev_pad_ops = {
 	.enum_mbus_code = imx074_enum_mbus_code,
 	.get_fmt	= imx074_get_fmt,
 	.set_fmt	= imx074_set_fmt,
+	.s_stream	= imx074_s_stream,
 };
 
 static struct v4l2_subdev_ops imx074_subdev_ops = {
diff --git a/drivers/media/i2c/soc_camera/mt9m001.c b/drivers/media/i2c/soc_camera/mt9m001.c
index 69becc3..888b2d9 100644
--- a/drivers/media/i2c/soc_camera/mt9m001.c
+++ b/drivers/media/i2c/soc_camera/mt9m001.c
@@ -161,7 +161,8 @@ static int mt9m001_init(struct i2c_client *client)
 	return ret;
 }
 
-static int mt9m001_s_stream(struct v4l2_subdev *sd, int enable)
+static int mt9m001_s_stream(struct v4l2_subdev *sd, unsigned int pad,
+			    int enable)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
@@ -624,7 +625,6 @@ static int mt9m001_s_mbus_config(struct v4l2_subdev *sd,
 }
 
 static struct v4l2_subdev_video_ops mt9m001_subdev_video_ops = {
-	.s_stream	= mt9m001_s_stream,
 	.s_crop		= mt9m001_s_crop,
 	.g_crop		= mt9m001_g_crop,
 	.cropcap	= mt9m001_cropcap,
@@ -640,6 +640,7 @@ static const struct v4l2_subdev_pad_ops mt9m001_subdev_pad_ops = {
 	.enum_mbus_code = mt9m001_enum_mbus_code,
 	.get_fmt	= mt9m001_get_fmt,
 	.set_fmt	= mt9m001_set_fmt,
+	.s_stream	= mt9m001_s_stream,
 };
 
 static struct v4l2_subdev_ops mt9m001_subdev_ops = {
diff --git a/drivers/media/i2c/soc_camera/mt9t031.c b/drivers/media/i2c/soc_camera/mt9t031.c
index 5c8e3ff..26ca451 100644
--- a/drivers/media/i2c/soc_camera/mt9t031.c
+++ b/drivers/media/i2c/soc_camera/mt9t031.c
@@ -161,7 +161,8 @@ static int mt9t031_idle(struct i2c_client *client)
 	return ret >= 0 ? 0 : -EIO;
 }
 
-static int mt9t031_s_stream(struct v4l2_subdev *sd, int enable)
+static int mt9t031_s_stream(struct v4l2_subdev *sd, unsigned int pad,
+			    int enable)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	int ret;
@@ -720,7 +721,6 @@ static int mt9t031_s_mbus_config(struct v4l2_subdev *sd,
 }
 
 static struct v4l2_subdev_video_ops mt9t031_subdev_video_ops = {
-	.s_stream	= mt9t031_s_stream,
 	.s_crop		= mt9t031_s_crop,
 	.g_crop		= mt9t031_g_crop,
 	.cropcap	= mt9t031_cropcap,
@@ -736,6 +736,7 @@ static const struct v4l2_subdev_pad_ops mt9t031_subdev_pad_ops = {
 	.enum_mbus_code = mt9t031_enum_mbus_code,
 	.get_fmt	= mt9t031_get_fmt,
 	.set_fmt	= mt9t031_set_fmt,
+	.s_stream	= mt9t031_s_stream,
 };
 
 static struct v4l2_subdev_ops mt9t031_subdev_ops = {
diff --git a/drivers/media/i2c/soc_camera/mt9t112.c b/drivers/media/i2c/soc_camera/mt9t112.c
index 6a1b2a9..2a257f5 100644
--- a/drivers/media/i2c/soc_camera/mt9t112.c
+++ b/drivers/media/i2c/soc_camera/mt9t112.c
@@ -785,7 +785,8 @@ static struct v4l2_subdev_core_ops mt9t112_subdev_core_ops = {
 /************************************************************************
 			v4l2_subdev_video_ops
 ************************************************************************/
-static int mt9t112_s_stream(struct v4l2_subdev *sd, int enable)
+static int mt9t112_s_stream(struct v4l2_subdev *sd, unsigned int pad,
+			    int enable)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct mt9t112_priv *priv = to_mt9t112(client);
@@ -1023,7 +1024,6 @@ static int mt9t112_s_mbus_config(struct v4l2_subdev *sd,
 }
 
 static struct v4l2_subdev_video_ops mt9t112_subdev_video_ops = {
-	.s_stream	= mt9t112_s_stream,
 	.cropcap	= mt9t112_cropcap,
 	.g_crop		= mt9t112_g_crop,
 	.s_crop		= mt9t112_s_crop,
@@ -1035,6 +1035,7 @@ static const struct v4l2_subdev_pad_ops mt9t112_subdev_pad_ops = {
 	.enum_mbus_code = mt9t112_enum_mbus_code,
 	.get_fmt	= mt9t112_get_fmt,
 	.set_fmt	= mt9t112_set_fmt,
+	.s_stream	= mt9t112_s_stream,
 };
 
 /************************************************************************
diff --git a/drivers/media/i2c/soc_camera/mt9v022.c b/drivers/media/i2c/soc_camera/mt9v022.c
index 2721e58..de1eb50 100644
--- a/drivers/media/i2c/soc_camera/mt9v022.c
+++ b/drivers/media/i2c/soc_camera/mt9v022.c
@@ -239,7 +239,8 @@ static int mt9v022_init(struct i2c_client *client)
 	return ret;
 }
 
-static int mt9v022_s_stream(struct v4l2_subdev *sd, int enable)
+static int mt9v022_s_stream(struct v4l2_subdev *sd, unsigned int pad,
+			    int enable)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct mt9v022 *mt9v022 = to_mt9v022(client);
@@ -852,7 +853,6 @@ static int mt9v022_s_mbus_config(struct v4l2_subdev *sd,
 }
 
 static struct v4l2_subdev_video_ops mt9v022_subdev_video_ops = {
-	.s_stream	= mt9v022_s_stream,
 	.s_crop		= mt9v022_s_crop,
 	.g_crop		= mt9v022_g_crop,
 	.cropcap	= mt9v022_cropcap,
@@ -868,6 +868,7 @@ static const struct v4l2_subdev_pad_ops mt9v022_subdev_pad_ops = {
 	.enum_mbus_code = mt9v022_enum_mbus_code,
 	.get_fmt	= mt9v022_get_fmt,
 	.set_fmt	= mt9v022_set_fmt,
+	.s_stream	= mt9v022_s_stream,
 };
 
 static struct v4l2_subdev_ops mt9v022_subdev_ops = {
diff --git a/drivers/media/i2c/soc_camera/ov2640.c b/drivers/media/i2c/soc_camera/ov2640.c
index 9b4f5de..2127882 100644
--- a/drivers/media/i2c/soc_camera/ov2640.c
+++ b/drivers/media/i2c/soc_camera/ov2640.c
@@ -679,7 +679,8 @@ err:
 /*
  * soc_camera_ops functions
  */
-static int ov2640_s_stream(struct v4l2_subdev *sd, int enable)
+static int ov2640_s_stream(struct v4l2_subdev *sd, unsigned int pad,
+			   int enable)
 {
 	return 0;
 }
@@ -1023,7 +1024,6 @@ static int ov2640_g_mbus_config(struct v4l2_subdev *sd,
 }
 
 static struct v4l2_subdev_video_ops ov2640_subdev_video_ops = {
-	.s_stream	= ov2640_s_stream,
 	.cropcap	= ov2640_cropcap,
 	.g_crop		= ov2640_g_crop,
 	.g_mbus_config	= ov2640_g_mbus_config,
@@ -1033,6 +1033,7 @@ static const struct v4l2_subdev_pad_ops ov2640_subdev_pad_ops = {
 	.enum_mbus_code = ov2640_enum_mbus_code,
 	.get_fmt	= ov2640_get_fmt,
 	.set_fmt	= ov2640_set_fmt,
+	.s_stream	= ov2640_s_stream,
 };
 
 static struct v4l2_subdev_ops ov2640_subdev_ops = {
diff --git a/drivers/media/i2c/soc_camera/ov6650.c b/drivers/media/i2c/soc_camera/ov6650.c
index 1f8af1e..57632c2 100644
--- a/drivers/media/i2c/soc_camera/ov6650.c
+++ b/drivers/media/i2c/soc_camera/ov6650.c
@@ -300,7 +300,8 @@ static struct ov6650 *to_ov6650(const struct i2c_client *client)
 }
 
 /* Start/Stop streaming from the device */
-static int ov6650_s_stream(struct v4l2_subdev *sd, int enable)
+static int ov6650_s_stream(struct v4l2_subdev *sd, unsigned int pad,
+			   int enable)
 {
 	return 0;
 }
@@ -942,7 +943,6 @@ static int ov6650_s_mbus_config(struct v4l2_subdev *sd,
 }
 
 static struct v4l2_subdev_video_ops ov6650_video_ops = {
-	.s_stream	= ov6650_s_stream,
 	.cropcap	= ov6650_cropcap,
 	.g_crop		= ov6650_g_crop,
 	.s_crop		= ov6650_s_crop,
@@ -956,6 +956,7 @@ static const struct v4l2_subdev_pad_ops ov6650_pad_ops = {
 	.enum_mbus_code = ov6650_enum_mbus_code,
 	.get_fmt	= ov6650_get_fmt,
 	.set_fmt	= ov6650_set_fmt,
+	.s_stream	= ov6650_s_stream,
 };
 
 static struct v4l2_subdev_ops ov6650_subdev_ops = {
diff --git a/drivers/media/i2c/soc_camera/ov772x.c b/drivers/media/i2c/soc_camera/ov772x.c
index a43410c..450cbfe 100644
--- a/drivers/media/i2c/soc_camera/ov772x.c
+++ b/drivers/media/i2c/soc_camera/ov772x.c
@@ -553,7 +553,8 @@ static int ov772x_reset(struct i2c_client *client)
  * soc_camera_ops function
  */
 
-static int ov772x_s_stream(struct v4l2_subdev *sd, int enable)
+static int ov772x_s_stream(struct v4l2_subdev *sd, unsigned int pad,
+			   int enable)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct ov772x_priv *priv = to_ov772x(sd);
@@ -1029,7 +1030,6 @@ static int ov772x_g_mbus_config(struct v4l2_subdev *sd,
 }
 
 static struct v4l2_subdev_video_ops ov772x_subdev_video_ops = {
-	.s_stream	= ov772x_s_stream,
 	.cropcap	= ov772x_cropcap,
 	.g_crop		= ov772x_g_crop,
 	.g_mbus_config	= ov772x_g_mbus_config,
@@ -1039,6 +1039,7 @@ static const struct v4l2_subdev_pad_ops ov772x_subdev_pad_ops = {
 	.enum_mbus_code = ov772x_enum_mbus_code,
 	.get_fmt	= ov772x_get_fmt,
 	.set_fmt	= ov772x_set_fmt,
+	.s_stream	= ov772x_s_stream,
 };
 
 static struct v4l2_subdev_ops ov772x_subdev_ops = {
diff --git a/drivers/media/i2c/soc_camera/ov9640.c b/drivers/media/i2c/soc_camera/ov9640.c
index 8caae1c..9cf7fcf 100644
--- a/drivers/media/i2c/soc_camera/ov9640.c
+++ b/drivers/media/i2c/soc_camera/ov9640.c
@@ -261,7 +261,8 @@ static int ov9640_reset(struct i2c_client *client)
 }
 
 /* Start/Stop streaming from the device */
-static int ov9640_s_stream(struct v4l2_subdev *sd, int enable)
+static int ov9640_s_stream(struct v4l2_subdev *sd, unsigned int pad,
+			   int enable)
 {
 	return 0;
 }
@@ -666,7 +667,6 @@ static int ov9640_g_mbus_config(struct v4l2_subdev *sd,
 }
 
 static struct v4l2_subdev_video_ops ov9640_video_ops = {
-	.s_stream	= ov9640_s_stream,
 	.cropcap	= ov9640_cropcap,
 	.g_crop		= ov9640_g_crop,
 	.g_mbus_config	= ov9640_g_mbus_config,
@@ -675,6 +675,7 @@ static struct v4l2_subdev_video_ops ov9640_video_ops = {
 static const struct v4l2_subdev_pad_ops ov9640_pad_ops = {
 	.enum_mbus_code = ov9640_enum_mbus_code,
 	.set_fmt	= ov9640_set_fmt,
+	.s_stream	= ov9640_s_stream,
 };
 
 static struct v4l2_subdev_ops ov9640_subdev_ops = {
diff --git a/drivers/media/i2c/soc_camera/ov9740.c b/drivers/media/i2c/soc_camera/ov9740.c
index 03a7fc7..8e8e0b1 100644
--- a/drivers/media/i2c/soc_camera/ov9740.c
+++ b/drivers/media/i2c/soc_camera/ov9740.c
@@ -502,7 +502,8 @@ static int ov9740_reg_write_array(struct i2c_client *client,
 }
 
 /* Start/Stop streaming from the device */
-static int ov9740_s_stream(struct v4l2_subdev *sd, int enable)
+static int ov9740_s_stream(struct v4l2_subdev *sd, unsigned int pad,
+			   int enable)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct ov9740_priv *priv = to_ov9740(sd);
@@ -796,11 +797,11 @@ static int ov9740_s_power(struct v4l2_subdev *sd, int on)
 
 		if (priv->current_enable) {
 			ov9740_s_fmt(sd, &priv->current_mf);
-			ov9740_s_stream(sd, 1);
+			ov9740_s_stream(sd, 0, 1);
 		}
 	} else {
 		if (priv->current_enable) {
-			ov9740_s_stream(sd, 0);
+			ov9740_s_stream(sd, 0, 0);
 			priv->current_enable = true;
 		}
 
@@ -913,7 +914,6 @@ static int ov9740_g_mbus_config(struct v4l2_subdev *sd,
 }
 
 static struct v4l2_subdev_video_ops ov9740_video_ops = {
-	.s_stream	= ov9740_s_stream,
 	.cropcap	= ov9740_cropcap,
 	.g_crop		= ov9740_g_crop,
 	.g_mbus_config	= ov9740_g_mbus_config,
@@ -930,6 +930,7 @@ static struct v4l2_subdev_core_ops ov9740_core_ops = {
 static const struct v4l2_subdev_pad_ops ov9740_pad_ops = {
 	.enum_mbus_code = ov9740_enum_mbus_code,
 	.set_fmt	= ov9740_set_fmt,
+	.s_stream	= ov9740_s_stream,
 };
 
 static struct v4l2_subdev_ops ov9740_subdev_ops = {
diff --git a/drivers/media/i2c/soc_camera/rj54n1cb0c.c b/drivers/media/i2c/soc_camera/rj54n1cb0c.c
index aa7bfbb..fac90f37 100644
--- a/drivers/media/i2c/soc_camera/rj54n1cb0c.c
+++ b/drivers/media/i2c/soc_camera/rj54n1cb0c.c
@@ -496,7 +496,8 @@ static int rj54n1_enum_mbus_code(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static int rj54n1_s_stream(struct v4l2_subdev *sd, int enable)
+static int rj54n1_s_stream(struct v4l2_subdev *sd, unsigned int pad,
+			   int enable)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
@@ -1245,7 +1246,6 @@ static int rj54n1_s_mbus_config(struct v4l2_subdev *sd,
 }
 
 static struct v4l2_subdev_video_ops rj54n1_subdev_video_ops = {
-	.s_stream	= rj54n1_s_stream,
 	.g_crop		= rj54n1_g_crop,
 	.s_crop		= rj54n1_s_crop,
 	.cropcap	= rj54n1_cropcap,
@@ -1257,6 +1257,7 @@ static const struct v4l2_subdev_pad_ops rj54n1_subdev_pad_ops = {
 	.enum_mbus_code = rj54n1_enum_mbus_code,
 	.get_fmt	= rj54n1_get_fmt,
 	.set_fmt	= rj54n1_set_fmt,
+	.s_stream	= rj54n1_s_stream,
 };
 
 static struct v4l2_subdev_ops rj54n1_subdev_ops = {
diff --git a/drivers/media/i2c/soc_camera/tw9910.c b/drivers/media/i2c/soc_camera/tw9910.c
index 06aff81..3d8580c 100644
--- a/drivers/media/i2c/soc_camera/tw9910.c
+++ b/drivers/media/i2c/soc_camera/tw9910.c
@@ -456,7 +456,8 @@ static const struct tw9910_scale_ctrl *tw9910_select_norm(v4l2_std_id norm,
 /*
  * subdevice operations
  */
-static int tw9910_s_stream(struct v4l2_subdev *sd, int enable)
+static int tw9910_s_stream(struct v4l2_subdev *sd, unsigned int pad,
+			   int enable)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct tw9910_priv *priv = to_tw9910(client);
@@ -920,7 +921,6 @@ static int tw9910_g_tvnorms(struct v4l2_subdev *sd, v4l2_std_id *norm)
 static struct v4l2_subdev_video_ops tw9910_subdev_video_ops = {
 	.s_std		= tw9910_s_std,
 	.g_std		= tw9910_g_std,
-	.s_stream	= tw9910_s_stream,
 	.cropcap	= tw9910_cropcap,
 	.g_crop		= tw9910_g_crop,
 	.g_mbus_config	= tw9910_g_mbus_config,
@@ -932,6 +932,7 @@ static const struct v4l2_subdev_pad_ops tw9910_subdev_pad_ops = {
 	.enum_mbus_code = tw9910_enum_mbus_code,
 	.get_fmt	= tw9910_get_fmt,
 	.set_fmt	= tw9910_set_fmt,
+	.s_stream	= tw9910_s_stream,
 };
 
 static struct v4l2_subdev_ops tw9910_subdev_ops = {
diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
index 6cf6d06..ebd8969 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -1466,7 +1466,8 @@ static int tc358743_g_mbus_config(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static int tc358743_s_stream(struct v4l2_subdev *sd, int enable)
+static int tc358743_s_stream(struct v4l2_subdev *sd, unsigned int pad,
+			     int enable)
 {
 	enable_stream(sd, enable);
 
@@ -1640,7 +1641,6 @@ static const struct v4l2_subdev_video_ops tc358743_video_ops = {
 	.g_dv_timings = tc358743_g_dv_timings,
 	.query_dv_timings = tc358743_query_dv_timings,
 	.g_mbus_config = tc358743_g_mbus_config,
-	.s_stream = tc358743_s_stream,
 };
 
 static const struct v4l2_subdev_pad_ops tc358743_pad_ops = {
@@ -1650,6 +1650,7 @@ static const struct v4l2_subdev_pad_ops tc358743_pad_ops = {
 	.set_edid = tc358743_s_edid,
 	.enum_dv_timings = tc358743_enum_dv_timings,
 	.dv_timings_cap = tc358743_dv_timings_cap,
+	.s_stream = tc358743_s_stream,
 };
 
 static const struct v4l2_subdev_ops tc358743_ops = {
diff --git a/drivers/media/i2c/ths7303.c b/drivers/media/i2c/ths7303.c
index 71a3135..ed6fe96 100644
--- a/drivers/media/i2c/ths7303.c
+++ b/drivers/media/i2c/ths7303.c
@@ -183,7 +183,8 @@ static int ths7303_config(struct v4l2_subdev *sd)
 
 }
 
-static int ths7303_s_stream(struct v4l2_subdev *sd, int enable)
+static int ths7303_s_stream(struct v4l2_subdev *sd, unsigned int pad,
+			    int enable)
 {
 	struct ths7303_state *state = to_state(sd);
 
@@ -208,11 +209,15 @@ static int ths7303_s_dv_timings(struct v4l2_subdev *sd,
 }
 
 static const struct v4l2_subdev_video_ops ths7303_video_ops = {
-	.s_stream	= ths7303_s_stream,
 	.s_std_output	= ths7303_s_std_output,
 	.s_dv_timings   = ths7303_s_dv_timings,
 };
 
+
+static const struct v4l2_subdev_pad_ops ths7303_pad_ops = {
+	.s_stream       = ths7303_s_stream,
+};
+
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 
 static int ths7303_g_register(struct v4l2_subdev *sd,
@@ -320,6 +325,7 @@ static const struct v4l2_subdev_core_ops ths7303_core_ops = {
 static const struct v4l2_subdev_ops ths7303_ops = {
 	.core	= &ths7303_core_ops,
 	.video 	= &ths7303_video_ops,
+	.pad	= &ths7303_pad_ops,
 };
 
 static int ths7303_probe(struct i2c_client *client,
diff --git a/drivers/media/i2c/ths8200.c b/drivers/media/i2c/ths8200.c
index 73fc42b..5d4a3fd 100644
--- a/drivers/media/i2c/ths8200.c
+++ b/drivers/media/i2c/ths8200.c
@@ -169,7 +169,8 @@ static const struct v4l2_subdev_core_ops ths8200_core_ops = {
  * V4L2 subdev video operations
  */
 
-static int ths8200_s_stream(struct v4l2_subdev *sd, int enable)
+static int ths8200_s_stream(struct v4l2_subdev *sd, unsigned int pad,
+			    int enable)
 {
 	struct ths8200_state *state = to_state(sd);
 
@@ -219,7 +220,7 @@ static void ths8200_setup(struct v4l2_subdev *sd, struct v4l2_bt_timings *bt)
 
 	/*** System ****/
 	/* Set chip in reset while it is configured */
-	ths8200_s_stream(sd, false);
+	ths8200_s_stream(sd, 0, false);
 
 	/* configure video output timings */
 	ths8200_write(sd, THS8200_DTG1_SPEC_A, bt->hsync);
@@ -349,7 +350,7 @@ static void ths8200_setup(struct v4l2_subdev *sd, struct v4l2_bt_timings *bt)
 	ths8200_write(sd, THS8200_DTG2_CNTL, 0x44 | polarity);
 
 	/* leave reset */
-	ths8200_s_stream(sd, true);
+	ths8200_s_stream(sd, 0, true);
 
 	v4l2_dbg(1, debug, sd, "%s: frame %dx%d, polarity %d\n"
 		 "horizontal: front porch %d, back porch %d, sync %d\n"
@@ -419,7 +420,6 @@ static int ths8200_dv_timings_cap(struct v4l2_subdev *sd,
 
 /* Specific video subsystem operation handlers */
 static const struct v4l2_subdev_video_ops ths8200_video_ops = {
-	.s_stream = ths8200_s_stream,
 	.s_dv_timings = ths8200_s_dv_timings,
 	.g_dv_timings = ths8200_g_dv_timings,
 };
@@ -427,6 +427,7 @@ static const struct v4l2_subdev_video_ops ths8200_video_ops = {
 static const struct v4l2_subdev_pad_ops ths8200_pad_ops = {
 	.enum_dv_timings = ths8200_enum_dv_timings,
 	.dv_timings_cap = ths8200_dv_timings_cap,
+	.s_stream = ths8200_s_stream,
 };
 
 /* V4L2 top level operation handlers */
diff --git a/drivers/media/i2c/tvp514x.c b/drivers/media/i2c/tvp514x.c
index 7cdd948..5025134 100644
--- a/drivers/media/i2c/tvp514x.c
+++ b/drivers/media/i2c/tvp514x.c
@@ -86,7 +86,8 @@ struct tvp514x_std_info {
 
 static struct tvp514x_reg tvp514x_reg_list_default[0x40];
 
-static int tvp514x_s_stream(struct v4l2_subdev *sd, int enable);
+static int tvp514x_s_stream(struct v4l2_subdev *sd, unsigned int pad,
+			    int enable);
 /**
  * struct tvp514x_decoder - TVP5146/47 decoder object
  * @sd: Subdevice Slave handle
@@ -550,7 +551,7 @@ static int tvp514x_querystd(struct v4l2_subdev *sd, v4l2_std_id *std_id)
 
 	/* To query the standard the TVP514x must power on the ADCs. */
 	if (!decoder->streaming) {
-		tvp514x_s_stream(sd, 1);
+		tvp514x_s_stream(sd, 0, 1);
 		msleep(LOCK_RETRY_DELAY);
 	}
 
@@ -818,7 +819,8 @@ tvp514x_s_parm(struct v4l2_subdev *sd, struct v4l2_streamparm *a)
  *
  * Sets streaming to enable or disable, if possible.
  */
-static int tvp514x_s_stream(struct v4l2_subdev *sd, int enable)
+static int tvp514x_s_stream(struct v4l2_subdev *sd, unsigned int pad,
+			    int enable)
 {
 	int err = 0;
 	struct tvp514x_decoder *decoder = to_decoder(sd);
@@ -963,13 +965,13 @@ static const struct v4l2_subdev_video_ops tvp514x_video_ops = {
 	.querystd = tvp514x_querystd,
 	.g_parm = tvp514x_g_parm,
 	.s_parm = tvp514x_s_parm,
-	.s_stream = tvp514x_s_stream,
 };
 
 static const struct v4l2_subdev_pad_ops tvp514x_pad_ops = {
 	.enum_mbus_code = tvp514x_enum_mbus_code,
 	.get_fmt = tvp514x_get_pad_format,
 	.set_fmt = tvp514x_set_pad_format,
+	.s_stream = tvp514x_s_stream,
 };
 
 static const struct v4l2_subdev_ops tvp514x_ops = {
diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index 0b6d46c..71d2347 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -1046,7 +1046,8 @@ static const struct media_entity_operations tvp5150_sd_media_ops = {
 			I2C Command
  ****************************************************************************/
 
-static int tvp5150_s_stream(struct v4l2_subdev *sd, int enable)
+static int tvp5150_s_stream(struct v4l2_subdev *sd, unsigned int pad,
+			    int enable)
 {
 	struct tvp5150 *decoder = to_tvp5150(sd);
 	/* Output format: 8-bit ITU-R BT.656 with embedded syncs */
@@ -1231,7 +1232,6 @@ static const struct v4l2_subdev_tuner_ops tvp5150_tuner_ops = {
 
 static const struct v4l2_subdev_video_ops tvp5150_video_ops = {
 	.s_std = tvp5150_s_std,
-	.s_stream = tvp5150_s_stream,
 	.s_routing = tvp5150_s_routing,
 	.s_crop = tvp5150_s_crop,
 	.g_crop = tvp5150_g_crop,
@@ -1251,6 +1251,7 @@ static const struct v4l2_subdev_pad_ops tvp5150_pad_ops = {
 	.enum_frame_size = tvp5150_enum_frame_size,
 	.set_fmt = tvp5150_fill_fmt,
 	.get_fmt = tvp5150_fill_fmt,
+	.s_stream = tvp5150_s_stream,
 };
 
 static const struct v4l2_subdev_ops tvp5150_ops = {
diff --git a/drivers/media/i2c/tvp7002.c b/drivers/media/i2c/tvp7002.c
index 4df640c..6bc701b 100644
--- a/drivers/media/i2c/tvp7002.c
+++ b/drivers/media/i2c/tvp7002.c
@@ -728,7 +728,8 @@ static int tvp7002_s_register(struct v4l2_subdev *sd,
  *
  * Sets streaming to enable or disable, if possible.
  */
-static int tvp7002_s_stream(struct v4l2_subdev *sd, int enable)
+static int tvp7002_s_stream(struct v4l2_subdev *sd, unsigned int pad,
+			    int enable)
 {
 	struct tvp7002 *device = to_tvp7002(sd);
 	int error;
@@ -872,7 +873,6 @@ static const struct v4l2_subdev_video_ops tvp7002_video_ops = {
 	.g_dv_timings = tvp7002_g_dv_timings,
 	.s_dv_timings = tvp7002_s_dv_timings,
 	.query_dv_timings = tvp7002_query_dv_timings,
-	.s_stream = tvp7002_s_stream,
 };
 
 /* media pad related operation handlers */
@@ -881,6 +881,7 @@ static const struct v4l2_subdev_pad_ops tvp7002_pad_ops = {
 	.get_fmt = tvp7002_get_pad_format,
 	.set_fmt = tvp7002_set_pad_format,
 	.enum_dv_timings = tvp7002_enum_dv_timings,
+	.s_stream = tvp7002_s_stream,
 };
 
 /* V4L2 top level operation handlers */
diff --git a/drivers/media/i2c/vpx3220.c b/drivers/media/i2c/vpx3220.c
index 90b693f..2afee8c 100644
--- a/drivers/media/i2c/vpx3220.c
+++ b/drivers/media/i2c/vpx3220.c
@@ -412,7 +412,8 @@ static int vpx3220_s_routing(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static int vpx3220_s_stream(struct v4l2_subdev *sd, int enable)
+static int vpx3220_s_stream(struct v4l2_subdev *sd, unsigned int pad,
+			    int enable)
 {
 	v4l2_dbg(1, debug, sd, "s_stream %s\n", enable ? "on" : "off");
 
@@ -455,14 +456,18 @@ static const struct v4l2_subdev_core_ops vpx3220_core_ops = {
 static const struct v4l2_subdev_video_ops vpx3220_video_ops = {
 	.s_std = vpx3220_s_std,
 	.s_routing = vpx3220_s_routing,
-	.s_stream = vpx3220_s_stream,
 	.querystd = vpx3220_querystd,
 	.g_input_status = vpx3220_g_input_status,
 };
 
+static const struct v4l2_subdev_pad_ops vpx3220_pad_ops = {
+	.s_stream = vpx3220_s_stream,
+};
+
 static const struct v4l2_subdev_ops vpx3220_ops = {
 	.core = &vpx3220_core_ops,
 	.video = &vpx3220_video_ops,
+	.pad = &vpx3220_pad_ops,
 };
 
 /* -----------------------------------------------------------------------
diff --git a/drivers/media/i2c/vs6624.c b/drivers/media/i2c/vs6624.c
index 4c72a18..c3fccda 100644
--- a/drivers/media/i2c/vs6624.c
+++ b/drivers/media/i2c/vs6624.c
@@ -705,7 +705,8 @@ static int vs6624_s_parm(struct v4l2_subdev *sd, struct v4l2_streamparm *parms)
 	return 0;
 }
 
-static int vs6624_s_stream(struct v4l2_subdev *sd, int enable)
+static int vs6624_s_stream(struct v4l2_subdev *sd, unsigned int pad,
+			   int enable)
 {
 	if (enable)
 		vs6624_write(sd, VS6624_USER_CMD, 0x2);
@@ -744,13 +745,13 @@ static const struct v4l2_subdev_core_ops vs6624_core_ops = {
 static const struct v4l2_subdev_video_ops vs6624_video_ops = {
 	.s_parm = vs6624_s_parm,
 	.g_parm = vs6624_g_parm,
-	.s_stream = vs6624_s_stream,
 };
 
 static const struct v4l2_subdev_pad_ops vs6624_pad_ops = {
 	.enum_mbus_code = vs6624_enum_mbus_code,
 	.get_fmt = vs6624_get_fmt,
 	.set_fmt = vs6624_set_fmt,
+	.s_stream = vs6624_s_stream,
 };
 
 static const struct v4l2_subdev_ops vs6624_ops = {
diff --git a/drivers/media/pci/cobalt/cobalt-driver.c b/drivers/media/pci/cobalt/cobalt-driver.c
index 8d6f04f..6f09af3 100644
--- a/drivers/media/pci/cobalt/cobalt-driver.c
+++ b/drivers/media/pci/cobalt/cobalt-driver.c
@@ -664,7 +664,7 @@ static int cobalt_subdevs_hsma_init(struct cobalt *cobalt)
 				COBALT_SYS_CTRL_VIDEO_TX_RESETN_BIT, 1);
 		cobalt->have_hsma_tx = true;
 		v4l2_subdev_call(s->sd, core, s_power, 1);
-		v4l2_subdev_call(s->sd, video, s_stream, 1);
+		v4l2_subdev_call(s->sd, pad, s_stream, 0, 1);
 		v4l2_subdev_call(s->sd, audio, s_stream, 1);
 		v4l2_ctrl_s_ctrl(v4l2_ctrl_find(s->sd->ctrl_handler,
 				 V4L2_CID_DV_TX_MODE), V4L2_DV_TX_MODE_HDMI);
diff --git a/drivers/media/pci/cx18/cx18-av-core.c b/drivers/media/pci/cx18/cx18-av-core.c
index 30bbe8d..24959ac 100644
--- a/drivers/media/pci/cx18/cx18-av-core.c
+++ b/drivers/media/pci/cx18/cx18-av-core.c
@@ -1022,7 +1022,8 @@ static int cx18_av_set_fmt(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static int cx18_av_s_stream(struct v4l2_subdev *sd, int enable)
+static int cx18_av_s_stream(struct v4l2_subdev *sd, unsigned int pad,
+			    int enable)
 {
 	struct cx18 *cx = v4l2_get_subdevdata(sd);
 
@@ -1290,7 +1291,6 @@ static const struct v4l2_subdev_audio_ops cx18_av_audio_ops = {
 static const struct v4l2_subdev_video_ops cx18_av_video_ops = {
 	.s_std = cx18_av_s_std,
 	.s_routing = cx18_av_s_video_routing,
-	.s_stream = cx18_av_s_stream,
 };
 
 static const struct v4l2_subdev_vbi_ops cx18_av_vbi_ops = {
@@ -1302,6 +1302,7 @@ static const struct v4l2_subdev_vbi_ops cx18_av_vbi_ops = {
 
 static const struct v4l2_subdev_pad_ops cx18_av_pad_ops = {
 	.set_fmt = cx18_av_set_fmt,
+	.s_stream = cx18_av_s_stream,
 };
 
 static const struct v4l2_subdev_ops cx18_av_ops = {
diff --git a/drivers/media/pci/ivtv/ivtv-driver.c b/drivers/media/pci/ivtv/ivtv-driver.c
index 374033a..91a6027 100644
--- a/drivers/media/pci/ivtv/ivtv-driver.c
+++ b/drivers/media/pci/ivtv/ivtv-driver.c
@@ -1253,7 +1253,7 @@ static int ivtv_probe(struct pci_dev *pdev, const struct pci_device_id *pci_id)
 		/* Turn off the output signal. The mpeg decoder is not yet
 		   active so without this you would get a green image until the
 		   mpeg decoder becomes active. */
-		ivtv_call_hw(itv, IVTV_HW_SAA7127, video, s_stream, 0);
+		ivtv_call_hw(itv, IVTV_HW_SAA7127, pad, s_stream, 0, 0);
 	}
 
 	/* clear interrupt mask, effectively disabling interrupts */
@@ -1373,7 +1373,7 @@ int ivtv_init_on_first_open(struct ivtv *itv)
 		/* Turn on the TV-out: ivtv_init_mpeg_decoder() initializes
 		   the mpeg decoder so now the saa7127 receives a proper
 		   signal. */
-		ivtv_call_hw(itv, IVTV_HW_SAA7127, video, s_stream, 1);
+		ivtv_call_hw(itv, IVTV_HW_SAA7127, pad, s_stream, 0, 1);
 		ivtv_init_mpeg_decoder(itv);
 	}
 
@@ -1422,7 +1422,8 @@ static void ivtv_remove(struct pci_dev *pdev)
 
 		/* Turn off the TV-out */
 		if (itv->v4l2_cap & V4L2_CAP_VIDEO_OUTPUT)
-			ivtv_call_hw(itv, IVTV_HW_SAA7127, video, s_stream, 0);
+			ivtv_call_hw(itv, IVTV_HW_SAA7127, pad, s_stream, 0,
+				     0);
 		if (atomic_read(&itv->decoding) > 0) {
 			int type;
 
diff --git a/drivers/media/pci/ivtv/ivtv-streams.c b/drivers/media/pci/ivtv/ivtv-streams.c
index d27c6df..3675364 100644
--- a/drivers/media/pci/ivtv/ivtv-streams.c
+++ b/drivers/media/pci/ivtv/ivtv-streams.c
@@ -611,10 +611,10 @@ int ivtv_start_v4l2_encode_stream(struct ivtv_stream *s)
 		/* Avoid tinny audio problem - ensure audio clocks are going */
 		v4l2_subdev_call(itv->sd_audio, audio, s_stream, 1);
 		/* Avoid unpredictable PCI bus hang - disable video clocks */
-		v4l2_subdev_call(itv->sd_video, video, s_stream, 0);
+		v4l2_subdev_call(itv->sd_video, pad, s_stream, 0, 0);
 		ivtv_msleep_timeout(300, 0);
 		ivtv_vapi(itv, CX2341X_ENC_INITIALIZE_INPUT, 0);
-		v4l2_subdev_call(itv->sd_video, video, s_stream, 1);
+		v4l2_subdev_call(itv->sd_video, pad, s_stream, 0, 1);
 	}
 
 	/* begin_capture */
diff --git a/drivers/media/pci/ivtv/ivtvfb.c b/drivers/media/pci/ivtv/ivtvfb.c
index 8b95eef..6e05b80 100644
--- a/drivers/media/pci/ivtv/ivtvfb.c
+++ b/drivers/media/pci/ivtv/ivtvfb.c
@@ -923,16 +923,16 @@ static int ivtvfb_blank(int blank_mode, struct fb_info *info)
 	switch (blank_mode) {
 	case FB_BLANK_UNBLANK:
 		ivtv_vapi(itv, CX2341X_OSD_SET_STATE, 1, 1);
-		ivtv_call_hw(itv, IVTV_HW_SAA7127, video, s_stream, 1);
+		ivtv_call_hw(itv, IVTV_HW_SAA7127, pad, s_stream, 0, 1);
 		break;
 	case FB_BLANK_NORMAL:
 	case FB_BLANK_HSYNC_SUSPEND:
 	case FB_BLANK_VSYNC_SUSPEND:
 		ivtv_vapi(itv, CX2341X_OSD_SET_STATE, 1, 0);
-		ivtv_call_hw(itv, IVTV_HW_SAA7127, video, s_stream, 1);
+		ivtv_call_hw(itv, IVTV_HW_SAA7127, pad, s_stream, 0, 1);
 		break;
 	case FB_BLANK_POWERDOWN:
-		ivtv_call_hw(itv, IVTV_HW_SAA7127, video, s_stream, 0);
+		ivtv_call_hw(itv, IVTV_HW_SAA7127, pad, s_stream, 0, 0);
 		ivtv_vapi(itv, CX2341X_OSD_SET_STATE, 1, 0);
 		break;
 	}
diff --git a/drivers/media/pci/zoran/zoran_card.c b/drivers/media/pci/zoran/zoran_card.c
index 9d2697f..13cfb9d 100644
--- a/drivers/media/pci/zoran/zoran_card.c
+++ b/drivers/media/pci/zoran/zoran_card.c
@@ -1067,7 +1067,7 @@ static int zr36057_init (struct zoran *zr)
 		detect_guest_activity(zr);
 	test_interrupts(zr);
 	if (!pass_through) {
-		decoder_call(zr, video, s_stream, 0);
+		decoder_call(zr, pad, s_stream, 0, 0);
 		encoder_call(zr, video, s_routing, 2, 0, 0);
 	}
 
diff --git a/drivers/media/pci/zoran/zoran_device.c b/drivers/media/pci/zoran/zoran_device.c
index 4d47dda..902b2ad 100644
--- a/drivers/media/pci/zoran/zoran_device.c
+++ b/drivers/media/pci/zoran/zoran_device.c
@@ -982,7 +982,7 @@ zr36057_enable_jpg (struct zoran          *zr,
 		 * the video bus direction set to input.
 		 */
 		set_videobus_dir(zr, 0);
-		decoder_call(zr, video, s_stream, 1);
+		decoder_call(zr, pad, s_stream, 0, 1);
 		encoder_call(zr, video, s_routing, 0, 0, 0);
 
 		/* Take the JPEG codec and the VFE out of sleep */
@@ -1029,7 +1029,7 @@ zr36057_enable_jpg (struct zoran          *zr,
 		/* In motion decompression mode, the decoder output must be disabled, and
 		 * the video bus direction set to output.
 		 */
-		decoder_call(zr, video, s_stream, 0);
+		decoder_call(zr, pad, s_stream, 0, 0);
 		set_videobus_dir(zr, 1);
 		encoder_call(zr, video, s_routing, 1, 0, 0);
 
@@ -1075,7 +1075,7 @@ zr36057_enable_jpg (struct zoran          *zr,
 		jpeg_codec_sleep(zr, 1);
 		zr36057_adjust_vfe(zr, mode);
 
-		decoder_call(zr, video, s_stream, 1);
+		decoder_call(zr, pad, s_stream, 0, 1);
 		encoder_call(zr, video, s_routing, 0, 0, 0);
 
 		dprintk(2, KERN_INFO "%s: enable_jpg(IDLE)\n", ZR_DEVNAME(zr));
diff --git a/drivers/media/pci/zoran/zoran_driver.c b/drivers/media/pci/zoran/zoran_driver.c
index 80caa70..dab8e51 100644
--- a/drivers/media/pci/zoran/zoran_driver.c
+++ b/drivers/media/pci/zoran/zoran_driver.c
@@ -1026,7 +1026,7 @@ zoran_close(struct file  *file)
 		zoran_set_pci_master(zr, 0);
 
 		if (!pass_through) {	/* Switch to color bar */
-			decoder_call(zr, video, s_stream, 0);
+			decoder_call(zr, pad, s_stream, 0, 0);
 			encoder_call(zr, video, s_routing, 2, 0, 0);
 		}
 	}
diff --git a/drivers/media/platform/am437x/am437x-vpfe.c b/drivers/media/platform/am437x/am437x-vpfe.c
index e749eb7..6a6fb64 100644
--- a/drivers/media/platform/am437x/am437x-vpfe.c
+++ b/drivers/media/platform/am437x/am437x-vpfe.c
@@ -2017,7 +2017,7 @@ static int vpfe_start_streaming(struct vb2_queue *vq, unsigned int count)
 
 	vpfe_pcr_enable(&vpfe->ccdc, 1);
 
-	ret = v4l2_subdev_call(sdinfo->sd, video, s_stream, 1);
+	ret = v4l2_subdev_call(sdinfo->sd, pad, s_stream, 0, 1);
 	if (ret < 0) {
 		vpfe_err(vpfe, "Error in attaching interrupt handle\n");
 		goto err;
@@ -2053,7 +2053,7 @@ static void vpfe_stop_streaming(struct vb2_queue *vq)
 	vpfe_detach_irq(vpfe);
 
 	sdinfo = vpfe->current_subdev;
-	ret = v4l2_subdev_call(sdinfo->sd, video, s_stream, 0);
+	ret = v4l2_subdev_call(sdinfo->sd, pad, s_stream, 0, 0);
 	if (ret && ret != -ENOIOCTLCMD && ret != -ENODEV)
 		vpfe_dbg(1, vpfe, "stream off failed in subdev\n");
 
diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
index d0092da..15d3e8b 100644
--- a/drivers/media/platform/blackfin/bfin_capture.c
+++ b/drivers/media/platform/blackfin/bfin_capture.c
@@ -272,7 +272,7 @@ static int bcap_start_streaming(struct vb2_queue *vq, unsigned int count)
 	int ret;
 
 	/* enable streamon on the sub device */
-	ret = v4l2_subdev_call(bcap_dev->sd, video, s_stream, 1);
+	ret = v4l2_subdev_call(bcap_dev->sd, pad, s_stream, 0, 1);
 	if (ret && (ret != -ENOIOCTLCMD)) {
 		v4l2_err(&bcap_dev->v4l2_dev, "stream on failed in subdev\n");
 		goto err;
@@ -363,7 +363,7 @@ static void bcap_stop_streaming(struct vb2_queue *vq)
 	wait_for_completion(&bcap_dev->comp);
 	ppi->ops->stop(ppi);
 	ppi->ops->detach_irq(ppi);
-	ret = v4l2_subdev_call(bcap_dev->sd, video, s_stream, 0);
+	ret = v4l2_subdev_call(bcap_dev->sd, pad, s_stream, 0, 0);
 	if (ret && (ret != -ENOIOCTLCMD))
 		v4l2_err(&bcap_dev->v4l2_dev,
 				"stream off failed in subdev\n");
diff --git a/drivers/media/platform/davinci/vpfe_capture.c b/drivers/media/platform/davinci/vpfe_capture.c
index 7767e07..de17ef0 100644
--- a/drivers/media/platform/davinci/vpfe_capture.c
+++ b/drivers/media/platform/davinci/vpfe_capture.c
@@ -725,8 +725,8 @@ static int vpfe_release(struct file *file)
 		if (vpfe_dev->started) {
 			sdinfo = vpfe_dev->current_subdev;
 			ret = v4l2_device_call_until_err(&vpfe_dev->v4l2_dev,
-							 sdinfo->grp_id,
-							 video, s_stream, 0);
+							 sdinfo->grp_id, pad,
+							 s_stream, 0, 0);
 			if (ret && (ret != -ENOIOCTLCMD))
 				v4l2_err(&vpfe_dev->v4l2_dev,
 				"stream off failed in subdev\n");
@@ -1498,7 +1498,7 @@ static int vpfe_streamon(struct file *file, void *priv,
 
 	sdinfo = vpfe_dev->current_subdev;
 	ret = v4l2_device_call_until_err(&vpfe_dev->v4l2_dev, sdinfo->grp_id,
-					video, s_stream, 1);
+					 pad, s_stream, 0, 1);
 
 	if (ret && (ret != -ENOIOCTLCMD)) {
 		v4l2_err(&vpfe_dev->v4l2_dev, "stream on failed in subdev\n");
@@ -1594,7 +1594,7 @@ static int vpfe_streamoff(struct file *file, void *priv,
 
 	sdinfo = vpfe_dev->current_subdev;
 	ret = v4l2_device_call_until_err(&vpfe_dev->v4l2_dev, sdinfo->grp_id,
-					video, s_stream, 0);
+					 pad, s_stream, 0, 0);
 
 	if (ret && (ret != -ENOIOCTLCMD))
 		v4l2_err(&vpfe_dev->v4l2_dev, "stream off failed in subdev\n");
diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index 08f7028..425f20e 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -194,7 +194,7 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
 		}
 	}
 
-	ret = v4l2_subdev_call(ch->sd, video, s_stream, 1);
+	ret = v4l2_subdev_call(ch->sd, pad, s_stream, 0, 1);
 	if (ret && ret != -ENOIOCTLCMD && ret != -ENODEV) {
 		vpif_dbg(1, debug, "stream on failed in subdev\n");
 		goto err;
@@ -282,7 +282,7 @@ static void vpif_stop_streaming(struct vb2_queue *vq)
 
 	ycmux_mode = 0;
 
-	ret = v4l2_subdev_call(ch->sd, video, s_stream, 0);
+	ret = v4l2_subdev_call(ch->sd, pad, s_stream, 0, 0);
 	if (ret && ret != -ENOIOCTLCMD && ret != -ENODEV)
 		vpif_dbg(1, debug, "stream off failed in subdev\n");
 
diff --git a/drivers/media/platform/exynos4-is/fimc-isp.c b/drivers/media/platform/exynos4-is/fimc-isp.c
index 293b807..2a857be 100644
--- a/drivers/media/platform/exynos4-is/fimc-isp.c
+++ b/drivers/media/platform/exynos4-is/fimc-isp.c
@@ -252,7 +252,8 @@ static int fimc_isp_subdev_set_fmt(struct v4l2_subdev *sd,
 	return ret;
 }
 
-static int fimc_isp_subdev_s_stream(struct v4l2_subdev *sd, int on)
+static int fimc_isp_subdev_s_stream(struct v4l2_subdev *sd, unsigned int pad,
+				    int on)
 {
 	struct fimc_isp *isp = v4l2_get_subdevdata(sd);
 	struct fimc_is *is = fimc_isp_to_is(isp);
@@ -423,9 +424,6 @@ static const struct v4l2_subdev_pad_ops fimc_is_subdev_pad_ops = {
 	.enum_mbus_code = fimc_is_subdev_enum_mbus_code,
 	.get_fmt = fimc_isp_subdev_get_fmt,
 	.set_fmt = fimc_isp_subdev_set_fmt,
-};
-
-static const struct v4l2_subdev_video_ops fimc_is_subdev_video_ops = {
 	.s_stream = fimc_isp_subdev_s_stream,
 };
 
@@ -435,7 +433,6 @@ static const struct v4l2_subdev_core_ops fimc_is_core_ops = {
 
 static struct v4l2_subdev_ops fimc_is_subdev_ops = {
 	.core = &fimc_is_core_ops,
-	.video = &fimc_is_subdev_video_ops,
 	.pad = &fimc_is_subdev_pad_ops,
 };
 
diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
index 27cb620..0c76f18 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite.c
@@ -1213,7 +1213,8 @@ static int fimc_lite_subdev_set_selection(struct v4l2_subdev *sd,
 	return ret;
 }
 
-static int fimc_lite_subdev_s_stream(struct v4l2_subdev *sd, int on)
+static int fimc_lite_subdev_s_stream(struct v4l2_subdev *sd, unsigned int pad,
+				     int on)
 {
 	struct fimc_lite *fimc = v4l2_get_subdevdata(sd);
 	unsigned long flags;
@@ -1354,9 +1355,6 @@ static const struct v4l2_subdev_pad_ops fimc_lite_subdev_pad_ops = {
 	.set_selection = fimc_lite_subdev_set_selection,
 	.get_fmt = fimc_lite_subdev_get_fmt,
 	.set_fmt = fimc_lite_subdev_set_fmt,
-};
-
-static const struct v4l2_subdev_video_ops fimc_lite_subdev_video_ops = {
 	.s_stream = fimc_lite_subdev_s_stream,
 };
 
@@ -1366,7 +1364,6 @@ static const struct v4l2_subdev_core_ops fimc_lite_core_ops = {
 
 static struct v4l2_subdev_ops fimc_lite_subdev_ops = {
 	.core = &fimc_lite_core_ops,
-	.video = &fimc_lite_subdev_video_ops,
 	.pad = &fimc_lite_subdev_pad_ops,
 };
 
diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index 891625e..85d2b2a 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -332,7 +332,7 @@ static int __fimc_pipeline_s_stream(struct exynos_media_pipeline *ep, bool on)
 	for (i = 0; i < IDX_MAX; i++) {
 		unsigned int idx = seq[on][i];
 
-		ret = v4l2_subdev_call(p->subdevs[idx], video, s_stream, on);
+		ret = v4l2_subdev_call(p->subdevs[idx], pad, s_stream, 0, on);
 
 		if (ret < 0 && ret != -ENOIOCTLCMD && ret != -ENODEV)
 			goto error;
@@ -343,7 +343,7 @@ error:
 	fimc_pipeline_s_power(p, !on);
 	for (; i >= 0; i--) {
 		unsigned int idx = seq[on][i];
-		v4l2_subdev_call(p->subdevs[idx], video, s_stream, !on);
+		v4l2_subdev_call(p->subdevs[idx], pad, s_stream, 0, !on);
 	}
 	return ret;
 }
diff --git a/drivers/media/platform/exynos4-is/mipi-csis.c b/drivers/media/platform/exynos4-is/mipi-csis.c
index bf95442..912a05f 100644
--- a/drivers/media/platform/exynos4-is/mipi-csis.c
+++ b/drivers/media/platform/exynos4-is/mipi-csis.c
@@ -502,7 +502,8 @@ static int s5pcsis_s_power(struct v4l2_subdev *sd, int on)
 	return pm_runtime_put_sync(dev);
 }
 
-static int s5pcsis_s_stream(struct v4l2_subdev *sd, int enable)
+static int s5pcsis_s_stream(struct v4l2_subdev *sd, unsigned int pad,
+			    int enable)
 {
 	struct csis_state *state = sd_to_csis_state(sd);
 	int ret = 0;
@@ -675,11 +676,11 @@ static struct v4l2_subdev_pad_ops s5pcsis_pad_ops = {
 	.enum_mbus_code = s5pcsis_enum_mbus_code,
 	.get_fmt = s5pcsis_get_fmt,
 	.set_fmt = s5pcsis_set_fmt,
+	.s_stream = s5pcsis_s_stream,
 };
 
 static struct v4l2_subdev_video_ops s5pcsis_video_ops = {
 	.s_rx_buffer = s5pcsis_s_rx_buffer,
-	.s_stream = s5pcsis_s_stream,
 };
 
 static struct v4l2_subdev_ops s5pcsis_subdev_ops = {
diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 5d54e2c..78c9bb5 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -709,17 +709,17 @@ static int isp_pipeline_enable(struct isp_pipeline *pipe,
 		entity = pad->entity;
 		subdev = media_entity_to_v4l2_subdev(entity);
 
-		ret = v4l2_subdev_call(subdev, video, s_stream, mode);
+		ret = v4l2_subdev_call(subdev, pad, s_stream, 0, mode);
 		if (ret < 0 && ret != -ENOIOCTLCMD)
 			return ret;
 
 		if (subdev == &isp->isp_ccdc.subdev) {
-			v4l2_subdev_call(&isp->isp_aewb.subdev, video,
-					s_stream, mode);
-			v4l2_subdev_call(&isp->isp_af.subdev, video,
-					s_stream, mode);
-			v4l2_subdev_call(&isp->isp_hist.subdev, video,
-					s_stream, mode);
+			v4l2_subdev_call(&isp->isp_aewb.subdev, pad, s_stream,
+					 0, mode);
+			v4l2_subdev_call(&isp->isp_af.subdev, pad, s_stream,
+					 0, mode);
+			v4l2_subdev_call(&isp->isp_hist.subdev, pad, s_stream,
+					 0, mode);
 			pipe->do_propagation = true;
 		}
 	}
@@ -799,15 +799,15 @@ static int isp_pipeline_disable(struct isp_pipeline *pipe)
 		subdev = media_entity_to_v4l2_subdev(entity);
 
 		if (subdev == &isp->isp_ccdc.subdev) {
-			v4l2_subdev_call(&isp->isp_aewb.subdev,
-					 video, s_stream, 0);
-			v4l2_subdev_call(&isp->isp_af.subdev,
-					 video, s_stream, 0);
-			v4l2_subdev_call(&isp->isp_hist.subdev,
-					 video, s_stream, 0);
+			v4l2_subdev_call(&isp->isp_aewb.subdev, pad, s_stream,
+					 0, 0);
+			v4l2_subdev_call(&isp->isp_af.subdev, pad, s_stream,
+					 0, 0);
+			v4l2_subdev_call(&isp->isp_hist.subdev, pad, s_stream,
+					 0, 0);
 		}
 
-		ret = v4l2_subdev_call(subdev, video, s_stream, 0);
+		ret = v4l2_subdev_call(subdev, pad, s_stream, 0, 0);
 
 		if (subdev == &isp->isp_res.subdev)
 			ret |= isp_pipeline_wait(isp, isp_pipeline_wait_resizer);
diff --git a/drivers/media/platform/omap3isp/ispccdc.c b/drivers/media/platform/omap3isp/ispccdc.c
index 882310e..4dfe030 100644
--- a/drivers/media/platform/omap3isp/ispccdc.c
+++ b/drivers/media/platform/omap3isp/ispccdc.c
@@ -1883,7 +1883,8 @@ static int ccdc_unsubscribe_event(struct v4l2_subdev *sd, struct v4l2_fh *fh,
  *
  * When not writing to memory enable the CCDC immediately.
  */
-static int ccdc_set_stream(struct v4l2_subdev *sd, int enable)
+static int ccdc_set_stream(struct v4l2_subdev *sd, unsigned int pad,
+			   int enable)
 {
 	struct isp_ccdc_device *ccdc = v4l2_get_subdevdata(sd);
 	struct isp_device *isp = to_isp_device(ccdc);
@@ -2465,11 +2466,6 @@ static const struct v4l2_subdev_core_ops ccdc_v4l2_core_ops = {
 	.unsubscribe_event = ccdc_unsubscribe_event,
 };
 
-/* V4L2 subdev video operations */
-static const struct v4l2_subdev_video_ops ccdc_v4l2_video_ops = {
-	.s_stream = ccdc_set_stream,
-};
-
 /* V4L2 subdev pad operations */
 static const struct v4l2_subdev_pad_ops ccdc_v4l2_pad_ops = {
 	.enum_mbus_code = ccdc_enum_mbus_code,
@@ -2479,12 +2475,12 @@ static const struct v4l2_subdev_pad_ops ccdc_v4l2_pad_ops = {
 	.get_selection = ccdc_get_selection,
 	.set_selection = ccdc_set_selection,
 	.link_validate = ccdc_link_validate,
+	.s_stream = ccdc_set_stream,
 };
 
 /* V4L2 subdev operations */
 static const struct v4l2_subdev_ops ccdc_v4l2_ops = {
 	.core = &ccdc_v4l2_core_ops,
-	.video = &ccdc_v4l2_video_ops,
 	.pad = &ccdc_v4l2_pad_ops,
 };
 
diff --git a/drivers/media/platform/omap3isp/ispccp2.c b/drivers/media/platform/omap3isp/ispccp2.c
index ca09523..11c9967 100644
--- a/drivers/media/platform/omap3isp/ispccp2.c
+++ b/drivers/media/platform/omap3isp/ispccp2.c
@@ -822,7 +822,7 @@ static int ccp2_init_formats(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
  * @enable: 1 == Enable, 0 == Disable
  * return zero
  */
-static int ccp2_s_stream(struct v4l2_subdev *sd, int enable)
+static int ccp2_s_stream(struct v4l2_subdev *sd, unsigned int pad, int enable)
 {
 	struct isp_ccp2_device *ccp2 = v4l2_get_subdevdata(sd);
 	struct isp_device *isp = to_isp_device(ccp2);
@@ -892,22 +892,17 @@ static int ccp2_s_stream(struct v4l2_subdev *sd, int enable)
 	return 0;
 }
 
-/* subdev video operations */
-static const struct v4l2_subdev_video_ops ccp2_sd_video_ops = {
-	.s_stream = ccp2_s_stream,
-};
-
 /* subdev pad operations */
 static const struct v4l2_subdev_pad_ops ccp2_sd_pad_ops = {
 	.enum_mbus_code = ccp2_enum_mbus_code,
 	.enum_frame_size = ccp2_enum_frame_size,
 	.get_fmt = ccp2_get_format,
 	.set_fmt = ccp2_set_format,
+	.s_stream = ccp2_s_stream,
 };
 
 /* subdev operations */
 static const struct v4l2_subdev_ops ccp2_sd_ops = {
-	.video = &ccp2_sd_video_ops,
 	.pad = &ccp2_sd_pad_ops,
 };
 
diff --git a/drivers/media/platform/omap3isp/ispcsi2.c b/drivers/media/platform/omap3isp/ispcsi2.c
index f75a1be..431bbd0 100644
--- a/drivers/media/platform/omap3isp/ispcsi2.c
+++ b/drivers/media/platform/omap3isp/ispcsi2.c
@@ -1050,7 +1050,8 @@ static int csi2_init_formats(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
  *
  * Return 0 on success or a negative error code otherwise.
  */
-static int csi2_set_stream(struct v4l2_subdev *sd, int enable)
+static int csi2_set_stream(struct v4l2_subdev *sd, unsigned int pad,
+			   int enable)
 {
 	struct isp_csi2_device *csi2 = v4l2_get_subdevdata(sd);
 	struct isp_device *isp = csi2->isp;
@@ -1101,22 +1102,17 @@ static int csi2_set_stream(struct v4l2_subdev *sd, int enable)
 	return 0;
 }
 
-/* subdev video operations */
-static const struct v4l2_subdev_video_ops csi2_video_ops = {
-	.s_stream = csi2_set_stream,
-};
-
 /* subdev pad operations */
 static const struct v4l2_subdev_pad_ops csi2_pad_ops = {
 	.enum_mbus_code = csi2_enum_mbus_code,
 	.enum_frame_size = csi2_enum_frame_size,
 	.get_fmt = csi2_get_format,
 	.set_fmt = csi2_set_format,
+	.s_stream = csi2_set_stream,
 };
 
 /* subdev operations */
 static const struct v4l2_subdev_ops csi2_ops = {
-	.video = &csi2_video_ops,
 	.pad = &csi2_pad_ops,
 };
 
diff --git a/drivers/media/platform/omap3isp/isph3a_aewb.c b/drivers/media/platform/omap3isp/isph3a_aewb.c
index ccaf92f..97f68a7 100644
--- a/drivers/media/platform/omap3isp/isph3a_aewb.c
+++ b/drivers/media/platform/omap3isp/isph3a_aewb.c
@@ -273,13 +273,13 @@ static const struct v4l2_subdev_core_ops h3a_aewb_subdev_core_ops = {
 	.unsubscribe_event = omap3isp_stat_unsubscribe_event,
 };
 
-static const struct v4l2_subdev_video_ops h3a_aewb_subdev_video_ops = {
+static const struct v4l2_subdev_pad_ops h3a_aewb_subdev_pad_ops = {
 	.s_stream = omap3isp_stat_s_stream,
 };
 
 static const struct v4l2_subdev_ops h3a_aewb_subdev_ops = {
 	.core = &h3a_aewb_subdev_core_ops,
-	.video = &h3a_aewb_subdev_video_ops,
+	.pad = &h3a_aewb_subdev_pad_ops,
 };
 
 /*
diff --git a/drivers/media/platform/omap3isp/isph3a_af.c b/drivers/media/platform/omap3isp/isph3a_af.c
index 92937f7..1fcb556 100644
--- a/drivers/media/platform/omap3isp/isph3a_af.c
+++ b/drivers/media/platform/omap3isp/isph3a_af.c
@@ -338,13 +338,13 @@ static const struct v4l2_subdev_core_ops h3a_af_subdev_core_ops = {
 	.unsubscribe_event = omap3isp_stat_unsubscribe_event,
 };
 
-static const struct v4l2_subdev_video_ops h3a_af_subdev_video_ops = {
+static const struct v4l2_subdev_pad_ops h3a_af_subdev_pad_ops = {
 	.s_stream = omap3isp_stat_s_stream,
 };
 
 static const struct v4l2_subdev_ops h3a_af_subdev_ops = {
 	.core = &h3a_af_subdev_core_ops,
-	.video = &h3a_af_subdev_video_ops,
+	.pad = &h3a_af_subdev_pad_ops,
 };
 
 /* Function to register the AF character device driver. */
diff --git a/drivers/media/platform/omap3isp/isphist.c b/drivers/media/platform/omap3isp/isphist.c
index 7138b04..19922976 100644
--- a/drivers/media/platform/omap3isp/isphist.c
+++ b/drivers/media/platform/omap3isp/isphist.c
@@ -461,13 +461,13 @@ static const struct v4l2_subdev_core_ops hist_subdev_core_ops = {
 	.unsubscribe_event = omap3isp_stat_unsubscribe_event,
 };
 
-static const struct v4l2_subdev_video_ops hist_subdev_video_ops = {
+static const struct v4l2_subdev_pad_ops hist_subdev_pad_ops = {
 	.s_stream = omap3isp_stat_s_stream,
 };
 
 static const struct v4l2_subdev_ops hist_subdev_ops = {
 	.core = &hist_subdev_core_ops,
-	.video = &hist_subdev_video_ops,
+	.pad = &hist_subdev_pad_ops,
 };
 
 /*
diff --git a/drivers/media/platform/omap3isp/isppreview.c b/drivers/media/platform/omap3isp/isppreview.c
index ac30a0f..6063374 100644
--- a/drivers/media/platform/omap3isp/isppreview.c
+++ b/drivers/media/platform/omap3isp/isppreview.c
@@ -1628,7 +1628,8 @@ static long preview_ioctl(struct v4l2_subdev *sd, unsigned int cmd, void *arg)
  * @enable: 1 == Enable, 0 == Disable
  * return -EINVAL or zero on success
  */
-static int preview_set_stream(struct v4l2_subdev *sd, int enable)
+static int preview_set_stream(struct v4l2_subdev *sd, unsigned int pad,
+			      int enable)
 {
 	struct isp_prev_device *prev = v4l2_get_subdevdata(sd);
 	struct isp_video *video_out = &prev->video_out;
@@ -2099,11 +2100,6 @@ static const struct v4l2_subdev_core_ops preview_v4l2_core_ops = {
 	.ioctl = preview_ioctl,
 };
 
-/* subdev video operations */
-static const struct v4l2_subdev_video_ops preview_v4l2_video_ops = {
-	.s_stream = preview_set_stream,
-};
-
 /* subdev pad operations */
 static const struct v4l2_subdev_pad_ops preview_v4l2_pad_ops = {
 	.enum_mbus_code = preview_enum_mbus_code,
@@ -2112,12 +2108,12 @@ static const struct v4l2_subdev_pad_ops preview_v4l2_pad_ops = {
 	.set_fmt = preview_set_format,
 	.get_selection = preview_get_selection,
 	.set_selection = preview_set_selection,
+	.s_stream = preview_set_stream,
 };
 
 /* subdev operations */
 static const struct v4l2_subdev_ops preview_v4l2_ops = {
 	.core = &preview_v4l2_core_ops,
-	.video = &preview_v4l2_video_ops,
 	.pad = &preview_v4l2_pad_ops,
 };
 
diff --git a/drivers/media/platform/omap3isp/ispresizer.c b/drivers/media/platform/omap3isp/ispresizer.c
index 0b6a875..5aaea52 100644
--- a/drivers/media/platform/omap3isp/ispresizer.c
+++ b/drivers/media/platform/omap3isp/ispresizer.c
@@ -1130,7 +1130,8 @@ static const struct isp_video_operations resizer_video_ops = {
  * any buffer queued yet, just update the state field and return immediately.
  * The resizer will be enabled in resizer_video_queue().
  */
-static int resizer_set_stream(struct v4l2_subdev *sd, int enable)
+static int resizer_set_stream(struct v4l2_subdev *sd, unsigned int pad,
+			      int enable)
 {
 	struct isp_res_device *res = v4l2_get_subdevdata(sd);
 	struct isp_video *video_out = &res->video_out;
@@ -1578,11 +1579,6 @@ static int resizer_init_formats(struct v4l2_subdev *sd,
 	return 0;
 }
 
-/* subdev video operations */
-static const struct v4l2_subdev_video_ops resizer_v4l2_video_ops = {
-	.s_stream = resizer_set_stream,
-};
-
 /* subdev pad operations */
 static const struct v4l2_subdev_pad_ops resizer_v4l2_pad_ops = {
 	.enum_mbus_code = resizer_enum_mbus_code,
@@ -1592,11 +1588,11 @@ static const struct v4l2_subdev_pad_ops resizer_v4l2_pad_ops = {
 	.get_selection = resizer_get_selection,
 	.set_selection = resizer_set_selection,
 	.link_validate = resizer_link_validate,
+	.s_stream = resizer_set_stream,
 };
 
 /* subdev operations */
 static const struct v4l2_subdev_ops resizer_v4l2_ops = {
-	.video = &resizer_v4l2_video_ops,
 	.pad = &resizer_v4l2_pad_ops,
 };
 
diff --git a/drivers/media/platform/omap3isp/ispstat.c b/drivers/media/platform/omap3isp/ispstat.c
index 1b9217d..a19aae6 100644
--- a/drivers/media/platform/omap3isp/ispstat.c
+++ b/drivers/media/platform/omap3isp/ispstat.c
@@ -792,7 +792,8 @@ int omap3isp_stat_enable(struct ispstat *stat, u8 enable)
 	return 0;
 }
 
-int omap3isp_stat_s_stream(struct v4l2_subdev *subdev, int enable)
+int omap3isp_stat_s_stream(struct v4l2_subdev *subdev, unsigned int pad,
+			   int enable)
 {
 	struct ispstat *stat = v4l2_get_subdevdata(subdev);
 
diff --git a/drivers/media/platform/omap3isp/ispstat.h b/drivers/media/platform/omap3isp/ispstat.h
index 6d9b024..acacb17 100644
--- a/drivers/media/platform/omap3isp/ispstat.h
+++ b/drivers/media/platform/omap3isp/ispstat.h
@@ -139,7 +139,8 @@ int omap3isp_stat_subscribe_event(struct v4l2_subdev *subdev,
 int omap3isp_stat_unsubscribe_event(struct v4l2_subdev *subdev,
 				    struct v4l2_fh *fh,
 				    struct v4l2_event_subscription *sub);
-int omap3isp_stat_s_stream(struct v4l2_subdev *subdev, int enable);
+int omap3isp_stat_s_stream(struct v4l2_subdev *subdev, unsigned int pad,
+			   int enable);
 
 int omap3isp_stat_busy(struct ispstat *stat);
 int omap3isp_stat_pcr_busy(struct ispstat *stat);
diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
index dad3b03..bbd630a 100644
--- a/drivers/media/platform/rcar-vin/rcar-dma.c
+++ b/drivers/media/platform/rcar-vin/rcar-dma.c
@@ -1035,7 +1035,7 @@ static int rvin_start_streaming(struct vb2_queue *vq, unsigned int count)
 	int ret;
 
 	sd = vin_to_source(vin);
-	v4l2_subdev_call(sd, video, s_stream, 1);
+	v4l2_subdev_call(sd, pad, s_stream, 0, 1);
 
 	spin_lock_irqsave(&vin->qlock, flags);
 
@@ -1060,7 +1060,7 @@ out:
 	/* Return all buffers if something went wrong */
 	if (ret) {
 		return_all_buffers(vin, VB2_BUF_STATE_QUEUED);
-		v4l2_subdev_call(sd, video, s_stream, 0);
+		v4l2_subdev_call(sd, pad, s_stream, 0, 0);
 	}
 
 	spin_unlock_irqrestore(&vin->qlock, flags);
@@ -1111,7 +1111,7 @@ static void rvin_stop_streaming(struct vb2_queue *vq)
 	spin_unlock_irqrestore(&vin->qlock, flags);
 
 	sd = vin_to_source(vin);
-	v4l2_subdev_call(sd, video, s_stream, 0);
+	v4l2_subdev_call(sd, pad, s_stream, 0, 0);
 
 	/* disable interrupts */
 	rvin_disable_interrupts(vin);
diff --git a/drivers/media/platform/s3c-camif/camif-capture.c b/drivers/media/platform/s3c-camif/camif-capture.c
index bd060ef..1106cf8 100644
--- a/drivers/media/platform/s3c-camif/camif-capture.c
+++ b/drivers/media/platform/s3c-camif/camif-capture.c
@@ -132,7 +132,7 @@ static int sensor_set_streaming(struct camif_dev *camif, int on)
 	int err = 0;
 
 	if (camif->sensor.stream_count == !on)
-		err = v4l2_subdev_call(sensor->sd, video, s_stream, on);
+		err = v4l2_subdev_call(sensor->sd, pad, s_stream, 0, on);
 	if (!err)
 		sensor->stream_count += on ? 1 : -1;
 
diff --git a/drivers/media/platform/s5p-tv/hdmi_drv.c b/drivers/media/platform/s5p-tv/hdmi_drv.c
index e71b13e..ca36629 100644
--- a/drivers/media/platform/s5p-tv/hdmi_drv.c
+++ b/drivers/media/platform/s5p-tv/hdmi_drv.c
@@ -505,7 +505,7 @@ static int hdmi_streamon(struct hdmi_device *hdev)
 	if (ret)
 		return ret;
 
-	ret = v4l2_subdev_call(hdev->phy_sd, video, s_stream, 1);
+	ret = v4l2_subdev_call(hdev->phy_sd, pad, s_stream, 0, 1);
 	if (ret)
 		return ret;
 
@@ -519,15 +519,15 @@ static int hdmi_streamon(struct hdmi_device *hdev)
 	/* steady state not achieved */
 	if (tries == 0) {
 		dev_err(dev, "hdmiphy's pll could not reach steady state.\n");
-		v4l2_subdev_call(hdev->phy_sd, video, s_stream, 0);
+		v4l2_subdev_call(hdev->phy_sd, pad, s_stream, 0, 0);
 		hdmi_dumpregs(hdev, "hdmiphy - s_stream");
 		return -EIO;
 	}
 
 	/* starting MHL */
-	ret = v4l2_subdev_call(hdev->mhl_sd, video, s_stream, 1);
+	ret = v4l2_subdev_call(hdev->mhl_sd, pad, s_stream, 0, 1);
 	if (hdev->mhl_sd && ret) {
-		v4l2_subdev_call(hdev->phy_sd, video, s_stream, 0);
+		v4l2_subdev_call(hdev->phy_sd, pad, s_stream, 0, 0);
 		hdmi_dumpregs(hdev, "mhl - s_stream");
 		return -EIO;
 	}
@@ -559,14 +559,14 @@ static int hdmi_streamoff(struct hdmi_device *hdev)
 	clk_set_parent(res->sclk_hdmi, res->sclk_pixel);
 	clk_enable(res->sclk_hdmi);
 
-	v4l2_subdev_call(hdev->mhl_sd, video, s_stream, 0);
-	v4l2_subdev_call(hdev->phy_sd, video, s_stream, 0);
+	v4l2_subdev_call(hdev->mhl_sd, pad, s_stream, 0, 0);
+	v4l2_subdev_call(hdev->phy_sd, pad, s_stream, 0, 0);
 
 	hdmi_dumpregs(hdev, "streamoff");
 	return 0;
 }
 
-static int hdmi_s_stream(struct v4l2_subdev *sd, int enable)
+static int hdmi_s_stream(struct v4l2_subdev *sd, unsigned int pad, int enable)
 {
 	struct hdmi_device *hdev = sd_to_hdmi_dev(sd);
 	struct device *dev = hdev->dev;
@@ -717,13 +717,13 @@ static const struct v4l2_subdev_core_ops hdmi_sd_core_ops = {
 static const struct v4l2_subdev_video_ops hdmi_sd_video_ops = {
 	.s_dv_timings = hdmi_s_dv_timings,
 	.g_dv_timings = hdmi_g_dv_timings,
-	.s_stream = hdmi_s_stream,
 };
 
 static const struct v4l2_subdev_pad_ops hdmi_sd_pad_ops = {
 	.enum_dv_timings = hdmi_enum_dv_timings,
 	.dv_timings_cap = hdmi_dv_timings_cap,
 	.get_fmt = hdmi_get_fmt,
+	.s_stream = hdmi_s_stream,
 };
 
 static const struct v4l2_subdev_ops hdmi_sd_ops = {
diff --git a/drivers/media/platform/s5p-tv/hdmiphy_drv.c b/drivers/media/platform/s5p-tv/hdmiphy_drv.c
index aae6523..006f453 100644
--- a/drivers/media/platform/s5p-tv/hdmiphy_drv.c
+++ b/drivers/media/platform/s5p-tv/hdmiphy_drv.c
@@ -236,7 +236,8 @@ static int hdmiphy_dv_timings_cap(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static int hdmiphy_s_stream(struct v4l2_subdev *sd, int enable)
+static int hdmiphy_s_stream(struct v4l2_subdev *sd, unsigned int pad,
+			    int enable)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct device *dev = &client->dev;
@@ -262,11 +263,11 @@ static const struct v4l2_subdev_core_ops hdmiphy_core_ops = {
 
 static const struct v4l2_subdev_video_ops hdmiphy_video_ops = {
 	.s_dv_timings = hdmiphy_s_dv_timings,
-	.s_stream =  hdmiphy_s_stream,
 };
 
 static const struct v4l2_subdev_pad_ops hdmiphy_pad_ops = {
 	.dv_timings_cap = hdmiphy_dv_timings_cap,
+	.s_stream = hdmiphy_s_stream,
 };
 
 static const struct v4l2_subdev_ops hdmiphy_ops = {
diff --git a/drivers/media/platform/s5p-tv/mixer_drv.c b/drivers/media/platform/s5p-tv/mixer_drv.c
index 8a5d194..3f7082e 100644
--- a/drivers/media/platform/s5p-tv/mixer_drv.c
+++ b/drivers/media/platform/s5p-tv/mixer_drv.c
@@ -81,7 +81,7 @@ void mxr_streamer_get(struct mxr_device *mdev)
 
 		ret = v4l2_subdev_call(sd, pad, get_fmt, NULL, &fmt);
 		WARN(ret, "failed to get mbus_fmt for output %s\n", sd->name);
-		ret = v4l2_subdev_call(sd, video, s_stream, 1);
+		ret = v4l2_subdev_call(sd, pad, s_stream, 0, 1);
 		WARN(ret, "starting stream failed for output %s\n", sd->name);
 
 		mxr_reg_set_mbus_fmt(mdev, mbus_fmt);
@@ -107,7 +107,7 @@ void mxr_streamer_put(struct mxr_device *mdev)
 		/* vsync applies Mixer setup */
 		ret = mxr_reg_wait4vsync(mdev);
 		WARN(ret, "failed to get vsync (%d) from output\n", ret);
-		ret = v4l2_subdev_call(sd, video, s_stream, 0);
+		ret = v4l2_subdev_call(sd, pad, s_stream, 0, 0);
 		WARN(ret, "stopping stream failed for output %s\n", sd->name);
 	}
 	WARN(mdev->n_streamer < 0, "negative number of streamers (%d)\n",
diff --git a/drivers/media/platform/s5p-tv/sdo_drv.c b/drivers/media/platform/s5p-tv/sdo_drv.c
index c75d435..4986285 100644
--- a/drivers/media/platform/s5p-tv/sdo_drv.c
+++ b/drivers/media/platform/s5p-tv/sdo_drv.c
@@ -246,7 +246,7 @@ static int sdo_streamoff(struct sdo_device *sdev)
 	return tries ? 0 : -EIO;
 }
 
-static int sdo_s_stream(struct v4l2_subdev *sd, int on)
+static int sdo_s_stream(struct v4l2_subdev *sd, unsigned int pad, int on)
 {
 	struct sdo_device *sdev = sd_to_sdev(sd);
 	return on ? sdo_streamon(sdev) : sdo_streamoff(sdev);
@@ -260,11 +260,11 @@ static const struct v4l2_subdev_video_ops sdo_sd_video_ops = {
 	.s_std_output = sdo_s_std_output,
 	.g_std_output = sdo_g_std_output,
 	.g_tvnorms_output = sdo_g_tvnorms_output,
-	.s_stream = sdo_s_stream,
 };
 
 static const struct v4l2_subdev_pad_ops sdo_sd_pad_ops = {
 	.get_fmt = sdo_get_fmt,
+	.s_stream = sdo_s_stream,
 };
 
 static const struct v4l2_subdev_ops sdo_sd_ops = {
diff --git a/drivers/media/platform/s5p-tv/sii9234_drv.c b/drivers/media/platform/s5p-tv/sii9234_drv.c
index 0a97f9a..d7fe710 100644
--- a/drivers/media/platform/s5p-tv/sii9234_drv.c
+++ b/drivers/media/platform/s5p-tv/sii9234_drv.c
@@ -292,7 +292,8 @@ static int sii9234_s_power(struct v4l2_subdev *sd, int on)
 	return ret < 0 ? ret : 0;
 }
 
-static int sii9234_s_stream(struct v4l2_subdev *sd, int enable)
+static int sii9234_s_stream(struct v4l2_subdev *sd, unsigned int pad,
+			    int enable)
 {
 	struct sii9234_context *ctx = sd_to_context(sd);
 
@@ -305,13 +306,13 @@ static const struct v4l2_subdev_core_ops sii9234_core_ops = {
 	.s_power =  sii9234_s_power,
 };
 
-static const struct v4l2_subdev_video_ops sii9234_video_ops = {
+static const struct v4l2_subdev_pad_ops sii9234_pad_ops = {
 	.s_stream =  sii9234_s_stream,
 };
 
 static const struct v4l2_subdev_ops sii9234_ops = {
 	.core = &sii9234_core_ops,
-	.video = &sii9234_video_ops,
+	.pad = &sii9234_pad_ops,
 };
 
 static int sii9234_probe(struct i2c_client *client,
diff --git a/drivers/media/platform/sh_vou.c b/drivers/media/platform/sh_vou.c
index 1157404..ae70128 100644
--- a/drivers/media/platform/sh_vou.c
+++ b/drivers/media/platform/sh_vou.c
@@ -301,8 +301,8 @@ static int sh_vou_start_streaming(struct vb2_queue *vq, unsigned int count)
 	int ret;
 
 	vou_dev->sequence = 0;
-	ret = v4l2_device_call_until_err(&vou_dev->v4l2_dev, 0,
-					 video, s_stream, 1);
+	ret = v4l2_device_call_until_err(&vou_dev->v4l2_dev, 0, pad, s_stream,
+					 0, 1);
 	if (ret < 0 && ret != -ENOIOCTLCMD) {
 		list_for_each_entry_safe(buf, node, &vou_dev->buf_list, list) {
 			vb2_buffer_done(&buf->vb.vb2_buf,
@@ -348,8 +348,7 @@ static void sh_vou_stop_streaming(struct vb2_queue *vq)
 	struct sh_vou_buffer *buf, *node;
 	unsigned long flags;
 
-	v4l2_device_call_until_err(&vou_dev->v4l2_dev, 0,
-					 video, s_stream, 0);
+	v4l2_device_call_until_err(&vou_dev->v4l2_dev, 0, pad, s_stream, 0, 0);
 	/* disable output */
 	sh_vou_reg_a_set(vou_dev, VOUER, 0, 1);
 	/* ...but the current frame will complete */
diff --git a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
index b9f369c..5ed58a4 100644
--- a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
+++ b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
@@ -1596,7 +1596,7 @@ static int sh_mobile_ceu_set_livecrop(struct soc_camera_device *icd,
 	/* Wait for frame */
 	ret = wait_for_completion_interruptible(&pcdev->complete);
 	/* Stop the client */
-	ret = v4l2_subdev_call(sd, video, s_stream, 0);
+	ret = v4l2_subdev_call(sd, pad, s_stream, 0, 0);
 	if (ret < 0)
 		dev_warn(icd->parent,
 			 "Client failed to stop the stream: %d\n", ret);
@@ -1634,7 +1634,7 @@ static int sh_mobile_ceu_set_livecrop(struct soc_camera_device *icd,
 	sh_mobile_ceu_capture(pcdev);
 	spin_unlock_irq(&pcdev->lock);
 	/* Start the client */
-	ret = v4l2_subdev_call(sd, video, s_stream, 1);
+	ret = v4l2_subdev_call(sd, pad, s_stream, 0, 1);
 	return ret;
 }
 
diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index 46c7186..e39a2eb 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -990,7 +990,7 @@ static int soc_camera_streamon(struct file *file, void *priv,
 		ret = vb2_streamon(&icd->vb2_vidq, i);
 
 	if (!ret)
-		v4l2_subdev_call(sd, video, s_stream, 1);
+		v4l2_subdev_call(sd, pad, s_stream, 0, 1);
 
 	return ret;
 }
@@ -1020,7 +1020,7 @@ static int soc_camera_streamoff(struct file *file, void *priv,
 	else
 		ret = vb2_streamoff(&icd->vb2_vidq, i);
 
-	v4l2_subdev_call(sd, video, s_stream, 0);
+	v4l2_subdev_call(sd, pad, s_stream, 0, 0);
 
 	return ret;
 }
diff --git a/drivers/media/platform/soc_camera/soc_camera_platform.c b/drivers/media/platform/soc_camera/soc_camera_platform.c
index a51d2a4..daa43b1 100644
--- a/drivers/media/platform/soc_camera/soc_camera_platform.c
+++ b/drivers/media/platform/soc_camera/soc_camera_platform.c
@@ -30,7 +30,8 @@ static struct soc_camera_platform_priv *get_priv(struct platform_device *pdev)
 	return container_of(subdev, struct soc_camera_platform_priv, subdev);
 }
 
-static int soc_camera_platform_s_stream(struct v4l2_subdev *sd, int enable)
+static int soc_camera_platform_s_stream(struct v4l2_subdev *sd,
+					unsigned int pad, int enable)
 {
 	struct soc_camera_platform_info *p = v4l2_get_subdevdata(sd);
 	return p->set_capture(p, enable);
@@ -119,7 +120,6 @@ static int soc_camera_platform_g_mbus_config(struct v4l2_subdev *sd,
 }
 
 static struct v4l2_subdev_video_ops platform_subdev_video_ops = {
-	.s_stream	= soc_camera_platform_s_stream,
 	.cropcap	= soc_camera_platform_cropcap,
 	.g_crop		= soc_camera_platform_g_crop,
 	.g_mbus_config	= soc_camera_platform_g_mbus_config,
@@ -129,6 +129,7 @@ static const struct v4l2_subdev_pad_ops platform_subdev_pad_ops = {
 	.enum_mbus_code = soc_camera_platform_enum_mbus_code,
 	.get_fmt	= soc_camera_platform_fill_fmt,
 	.set_fmt	= soc_camera_platform_fill_fmt,
+	.s_stream	= soc_camera_platform_s_stream,
 };
 
 static struct v4l2_subdev_ops platform_subdev_ops = {
diff --git a/drivers/media/platform/ti-vpe/cal.c b/drivers/media/platform/ti-vpe/cal.c
index 82001e6..20da31b 100644
--- a/drivers/media/platform/ti-vpe/cal.c
+++ b/drivers/media/platform/ti-vpe/cal.c
@@ -1327,7 +1327,7 @@ static int cal_start_streaming(struct vb2_queue *vq, unsigned int count)
 	cal_wr_dma_addr(ctx, addr);
 	csi2_ppi_enable(ctx);
 
-	ret = v4l2_subdev_call(ctx->sensor, video, s_stream, 1);
+	ret = v4l2_subdev_call(ctx->sensor, pad, s_stream, 0, 1);
 	if (ret) {
 		ctx_err(ctx, "stream on failed in subdev\n");
 		cal_runtime_put(ctx->dev);
@@ -1354,7 +1354,7 @@ static void cal_stop_streaming(struct vb2_queue *vq)
 	struct cal_buffer *buf, *tmp;
 	unsigned long flags;
 
-	if (v4l2_subdev_call(ctx->sensor, video, s_stream, 0))
+	if (v4l2_subdev_call(ctx->sensor, pad, s_stream, 0, 0))
 		ctx_err(ctx, "stream off failed in subdev\n");
 
 	csi2_ppi_disable(ctx);
diff --git a/drivers/media/platform/vsp1/vsp1_pipe.c b/drivers/media/platform/vsp1/vsp1_pipe.c
index 4f3b4a1..0267427 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.c
+++ b/drivers/media/platform/vsp1/vsp1_pipe.c
@@ -261,7 +261,7 @@ int vsp1_pipeline_stop(struct vsp1_pipeline *pipe)
 				   VI6_DPR_NODE_UNUSED);
 	}
 
-	v4l2_subdev_call(&pipe->output->entity.subdev, video, s_stream, 0);
+	v4l2_subdev_call(&pipe->output->entity.subdev, pad, s_stream, 0, 0);
 
 	return ret;
 }
diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index 75fe7de..81f98eb 100644
--- a/drivers/media/platform/vsp1/vsp1_wpf.c
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -40,7 +40,8 @@ static inline void vsp1_wpf_write(struct vsp1_rwpf *wpf,
  * V4L2 Subdevice Core Operations
  */
 
-static int wpf_s_stream(struct v4l2_subdev *subdev, int enable)
+static int wpf_s_stream(struct v4l2_subdev *subdev, unsigned int pad,
+			int enable)
 {
 	struct vsp1_rwpf *wpf = to_rwpf(subdev);
 	struct vsp1_device *vsp1 = wpf->entity.vsp1;
@@ -70,14 +71,10 @@ const struct v4l2_subdev_pad_ops vsp1_wpf_pad_ops = {
 	.set_fmt = vsp1_rwpf_set_format,
 	.get_selection = vsp1_rwpf_get_selection,
 	.set_selection = vsp1_rwpf_set_selection,
-};
-
-static struct v4l2_subdev_video_ops wpf_video_ops = {
 	.s_stream = wpf_s_stream,
 };
 
 static struct v4l2_subdev_ops wpf_ops = {
-	.video	= &wpf_video_ops,
 	.pad    = &vsp1_wpf_pad_ops,
 };
 
diff --git a/drivers/media/platform/xilinx/xilinx-dma.c b/drivers/media/platform/xilinx/xilinx-dma.c
index 7f6898b..99e1727 100644
--- a/drivers/media/platform/xilinx/xilinx-dma.c
+++ b/drivers/media/platform/xilinx/xilinx-dma.c
@@ -118,7 +118,7 @@ static int xvip_pipeline_start_stop(struct xvip_pipeline *pipe, bool start)
 		entity = pad->entity;
 		subdev = media_entity_to_v4l2_subdev(entity);
 
-		ret = v4l2_subdev_call(subdev, video, s_stream, start);
+		ret = v4l2_subdev_call(subdev, pad, s_stream, 0, start);
 		if (start && ret < 0 && ret != -ENOIOCTLCMD)
 			return ret;
 	}
diff --git a/drivers/media/platform/xilinx/xilinx-tpg.c b/drivers/media/platform/xilinx/xilinx-tpg.c
index 2ec1f6c..44a7485 100644
--- a/drivers/media/platform/xilinx/xilinx-tpg.c
+++ b/drivers/media/platform/xilinx/xilinx-tpg.c
@@ -167,7 +167,8 @@ static void xtpg_update_pattern_control(struct xtpg_device *xtpg,
  * V4L2 Subdevice Video Operations
  */
 
-static int xtpg_s_stream(struct v4l2_subdev *subdev, int enable)
+static int xtpg_s_stream(struct v4l2_subdev *subdev, unsigned int pad,
+			 int enable)
 {
 	struct xtpg_device *xtpg = to_tpg(subdev);
 	unsigned int width = xtpg->formats[0].width;
@@ -463,20 +464,16 @@ static const struct v4l2_ctrl_ops xtpg_ctrl_ops = {
 static struct v4l2_subdev_core_ops xtpg_core_ops = {
 };
 
-static struct v4l2_subdev_video_ops xtpg_video_ops = {
-	.s_stream = xtpg_s_stream,
-};
-
 static struct v4l2_subdev_pad_ops xtpg_pad_ops = {
 	.enum_mbus_code		= xvip_enum_mbus_code,
 	.enum_frame_size	= xtpg_enum_frame_size,
 	.get_fmt		= xtpg_get_format,
 	.set_fmt		= xtpg_set_format,
+	.s_stream		= xtpg_s_stream,
 };
 
 static struct v4l2_subdev_ops xtpg_ops = {
 	.core   = &xtpg_core_ops,
-	.video  = &xtpg_video_ops,
 	.pad    = &xtpg_pad_ops,
 };
 
diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index 7d0ec4c..ce4a0cf 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -854,8 +854,8 @@ int au0828_start_analog_streaming(struct vb2_queue *vq, unsigned int count)
 		}
 
 		if (vq->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
-			v4l2_device_call_all(&dev->v4l2_dev, 0, video,
-						s_stream, 1);
+			v4l2_device_call_all(&dev->v4l2_dev, 0, pad, s_stream,
+					     0, 1);
 			dev->vid_timeout_running = 1;
 			mod_timer(&dev->vid_timeout, jiffies + (HZ / 10));
 		} else if (vq->type == V4L2_BUF_TYPE_VBI_CAPTURE) {
@@ -878,7 +878,7 @@ static void au0828_stop_streaming(struct vb2_queue *vq)
 	if (dev->streaming_users-- == 1)
 		au0828_uninit_isoc(dev);
 
-	v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_stream, 0);
+	v4l2_device_call_all(&dev->v4l2_dev, 0, pad, s_stream, 0, 0);
 	dev->vid_timeout_running = 0;
 	del_timer_sync(&dev->vid_timeout);
 
diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
index c63248a..71df6ab 100644
--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -1164,7 +1164,7 @@ void cx231xx_config_i2c(struct cx231xx *dev)
 {
 	/* u32 input = INPUT(dev->video_input)->vmux; */
 
-	call_all(dev, video, s_stream, 1);
+	call_all(dev, pad, s_stream, 0, 1);
 }
 
 static void cx231xx_unregister_media_device(struct cx231xx *dev)
diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
index 6414188..46ebe56 100644
--- a/drivers/media/usb/cx231xx/cx231xx-video.c
+++ b/drivers/media/usb/cx231xx/cx231xx-video.c
@@ -1519,7 +1519,7 @@ static int vidioc_streamon(struct file *file, void *priv,
 	if (likely(rc >= 0))
 		rc = videobuf_streamon(&fh->vb_vidq);
 
-	call_all(dev, video, s_stream, 1);
+	call_all(dev, pad, s_stream, 0, 1);
 
 	return rc;
 }
@@ -1538,7 +1538,7 @@ static int vidioc_streamoff(struct file *file, void *priv,
 	if (type != fh->type)
 		return -EINVAL;
 
-	cx25840_call(dev, video, s_stream, 0);
+	cx25840_call(dev, pad, s_stream, 0, 0);
 
 	videobuf_streamoff(&fh->vb_vidq);
 	res_free(fh);
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 44834b2..8162347 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -1107,7 +1107,7 @@ int em28xx_start_analog_streaming(struct vb2_queue *vq, unsigned int count)
 				     0, tuner, s_frequency, &f);
 
 		/* Enable video stream at TV decoder */
-		v4l2_device_call_all(&v4l2->v4l2_dev, 0, video, s_stream, 1);
+		v4l2_device_call_all(&v4l2->v4l2_dev, 0, pad, s_stream, 0, 1);
 	}
 
 	v4l2->streaming_users++;
@@ -1128,7 +1128,7 @@ static void em28xx_stop_streaming(struct vb2_queue *vq)
 
 	if (v4l2->streaming_users-- == 1) {
 		/* Disable video stream at TV decoder */
-		v4l2_device_call_all(&v4l2->v4l2_dev, 0, video, s_stream, 0);
+		v4l2_device_call_all(&v4l2->v4l2_dev, 0, pad, s_stream, 0, 0);
 
 		/* Last active user, so shutdown all the URBS */
 		em28xx_uninit_usb_xfer(dev, EM28XX_ANALOG_MODE);
@@ -1163,7 +1163,7 @@ void em28xx_stop_vbi_streaming(struct vb2_queue *vq)
 
 	if (v4l2->streaming_users-- == 1) {
 		/* Disable video stream at TV decoder */
-		v4l2_device_call_all(&v4l2->v4l2_dev, 0, video, s_stream, 0);
+		v4l2_device_call_all(&v4l2->v4l2_dev, 0, pad, s_stream, 0, 0);
 
 		/* Last active user, so shutdown all the URBS */
 		em28xx_uninit_usb_xfer(dev, EM28XX_ANALOG_MODE);
diff --git a/drivers/media/usb/go7007/go7007-v4l2.c b/drivers/media/usb/go7007/go7007-v4l2.c
index ea01ee5..a050f5f 100644
--- a/drivers/media/usb/go7007/go7007-v4l2.c
+++ b/drivers/media/usb/go7007/go7007-v4l2.c
@@ -442,7 +442,7 @@ static int go7007_start_streaming(struct vb2_queue *q, unsigned int count)
 		q->streaming = 0;
 		return ret;
 	}
-	call_all(&go->v4l2_dev, video, s_stream, 1);
+	call_all(&go->v4l2_dev, pad, s_stream, 0, 1);
 	v4l2_ctrl_grab(go->mpeg_video_gop_size, true);
 	v4l2_ctrl_grab(go->mpeg_video_gop_closure, true);
 	v4l2_ctrl_grab(go->mpeg_video_bitrate, true);
@@ -463,7 +463,7 @@ static void go7007_stop_streaming(struct vb2_queue *q)
 	mutex_lock(&go->hw_lock);
 	go7007_reset_encoder(go);
 	mutex_unlock(&go->hw_lock);
-	call_all(&go->v4l2_dev, video, s_stream, 0);
+	call_all(&go->v4l2_dev, pad, s_stream, 0, 0);
 
 	spin_lock_irqsave(&go->spinlock, flags);
 	INIT_LIST_HEAD(&go->vidq_active);
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
index 83e9a3e..b0ec39c 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
@@ -1681,7 +1681,7 @@ static int pvr2_decoder_enable(struct pvr2_hdw *hdw,int enablefl)
 	   command... */
 	pvr2_trace(PVR2_TRACE_CHIPS, "subdev v4l2 stream=%s",
 		   (enablefl ? "on" : "off"));
-	v4l2_device_call_all(&hdw->v4l2_dev, 0, video, s_stream, enablefl);
+	v4l2_device_call_all(&hdw->v4l2_dev, 0, pad, s_stream, 0, enablefl);
 	v4l2_device_call_all(&hdw->v4l2_dev, 0, audio, s_stream, enablefl);
 	if (hdw->decoder_client_id) {
 		/* We get here if the encoder has been noticed.  Otherwise
diff --git a/drivers/media/usb/stk1160/stk1160-core.c b/drivers/media/usb/stk1160/stk1160-core.c
index bc02947..b7fe186 100644
--- a/drivers/media/usb/stk1160/stk1160-core.c
+++ b/drivers/media/usb/stk1160/stk1160-core.c
@@ -365,7 +365,7 @@ static int stk1160_probe(struct usb_interface *interface,
 
 	/* i2c reset saa711x */
 	v4l2_device_call_all(&dev->v4l2_dev, 0, core, reset, 0);
-	v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_stream, 0);
+	v4l2_device_call_all(&dev->v4l2_dev, 0, pad, s_stream, 0, 0);
 
 	/* reset stk1160 to default values */
 	stk1160_reg_reset(dev);
diff --git a/drivers/media/usb/stk1160/stk1160-v4l.c b/drivers/media/usb/stk1160/stk1160-v4l.c
index 77131fd..46f2038 100644
--- a/drivers/media/usb/stk1160/stk1160-v4l.c
+++ b/drivers/media/usb/stk1160/stk1160-v4l.c
@@ -251,7 +251,7 @@ static int stk1160_start_streaming(struct stk1160 *dev)
 	}
 
 	/* Start saa711x */
-	v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_stream, 1);
+	v4l2_device_call_all(&dev->v4l2_dev, 0, pad, s_stream, 0, 1);
 
 	dev->sequence = 0;
 
@@ -293,7 +293,7 @@ static void stk1160_stop_hw(struct stk1160 *dev)
 	stk1160_write_reg(dev, STK1160_DCTRL+3, 0x00);
 
 	/* Stop saa711x */
-	v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_stream, 0);
+	v4l2_device_call_all(&dev->v4l2_dev, 0, pad, s_stream, 0, 0);
 }
 
 static int stk1160_stop_streaming(struct stk1160 *dev)
diff --git a/drivers/media/usb/usbvision/usbvision-video.c b/drivers/media/usb/usbvision/usbvision-video.c
index ad2f3d2..b468295 100644
--- a/drivers/media/usb/usbvision/usbvision-video.c
+++ b/drivers/media/usb/usbvision/usbvision-video.c
@@ -799,7 +799,7 @@ static int vidioc_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
 	struct usb_usbvision *usbvision = video_drvdata(file);
 
 	usbvision->streaming = stream_on;
-	call_all(usbvision, video, s_stream, 1);
+	call_all(usbvision, pad, s_stream, 0, 1);
 
 	return 0;
 }
@@ -815,7 +815,7 @@ static int vidioc_streamoff(struct file *file,
 	if (usbvision->streaming == stream_on) {
 		usbvision_stream_interrupt(usbvision);
 		/* Stop all video streamings */
-		call_all(usbvision, video, s_stream, 0);
+		call_all(usbvision, pad, s_stream, 0, 0);
 	}
 	usbvision_empty_framequeues(usbvision);
 
@@ -933,7 +933,7 @@ static ssize_t usbvision_read(struct file *file, char __user *buf,
 	if (usbvision->streaming != stream_on) {
 		/* no stream is running, make it running ! */
 		usbvision->streaming = stream_on;
-		call_all(usbvision, video, s_stream, 1);
+		call_all(usbvision, pad, s_stream, 0, 1);
 	}
 
 	/* Then, enqueue as many frames as possible
diff --git a/drivers/staging/media/davinci_vpfe/dm365_ipipe.c b/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
index ff47a8f3..d6d447e 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
@@ -1389,7 +1389,8 @@ void vpfe_ipipe_enable(struct vpfe_device *vpfe_dev, int en)
  * @sd: pointer to v4l2 subdev structure
  * @enable: 1 == Enable, 0 == Disable
  */
-static int ipipe_set_stream(struct v4l2_subdev *sd, int enable)
+static int ipipe_set_stream(struct v4l2_subdev *sd, unsigned int pad,
+			    int enable)
 {
 	struct vpfe_ipipe_device *ipipe = v4l2_get_subdevdata(sd);
 	struct vpfe_device *vpfe_dev = to_vpfe_device(ipipe);
@@ -1665,23 +1666,18 @@ static const struct  v4l2_subdev_internal_ops ipipe_v4l2_internal_ops = {
 	.open = ipipe_init_formats,
 };
 
-/* subdev video operations */
-static const struct v4l2_subdev_video_ops ipipe_v4l2_video_ops = {
-	.s_stream = ipipe_set_stream,
-};
-
 /* subdev pad operations */
 static const struct v4l2_subdev_pad_ops ipipe_v4l2_pad_ops = {
 	.enum_mbus_code = ipipe_enum_mbus_code,
 	.enum_frame_size = ipipe_enum_frame_size,
 	.get_fmt = ipipe_get_format,
 	.set_fmt = ipipe_set_format,
+	.s_stream = ipipe_set_stream,
 };
 
 /* v4l2 subdev operation */
 static const struct v4l2_subdev_ops ipipe_v4l2_ops = {
 	.core = &ipipe_v4l2_core_ops,
-	.video = &ipipe_v4l2_video_ops,
 	.pad = &ipipe_v4l2_pad_ops,
 };
 
diff --git a/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c b/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c
index 46fd2c7..e9d4be0 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c
@@ -525,7 +525,8 @@ void vpfe_ipipeif_enable(struct vpfe_device *vpfe_dev)
  * @sd: pointer to v4l2 subdev structure
  * @enable: 1 == Enable, 0 == Disable
  */
-static int ipipeif_set_stream(struct v4l2_subdev *sd, int enable)
+static int ipipeif_set_stream(struct v4l2_subdev *sd, unsigned int pad,
+			      int enable)
 {
 	struct vpfe_ipipeif_device *ipipeif = v4l2_get_subdevdata(sd);
 	struct vpfe_device *vpfe_dev = to_vpfe_device(ipipeif);
@@ -855,23 +856,18 @@ static const struct v4l2_subdev_internal_ops ipipeif_v4l2_internal_ops = {
 	.open = ipipeif_init_formats,
 };
 
-/* subdev video operations */
-static const struct v4l2_subdev_video_ops ipipeif_v4l2_video_ops = {
-	.s_stream = ipipeif_set_stream,
-};
-
 /* subdev pad operations */
 static const struct v4l2_subdev_pad_ops ipipeif_v4l2_pad_ops = {
 	.enum_mbus_code = ipipeif_enum_mbus_code,
 	.enum_frame_size = ipipeif_enum_frame_size,
 	.get_fmt = ipipeif_get_format,
 	.set_fmt = ipipeif_set_format,
+	.s_stream = ipipeif_set_stream,
 };
 
 /* subdev operations */
 static const struct v4l2_subdev_ops ipipeif_v4l2_ops = {
 	.core = &ipipeif_v4l2_core_ops,
-	.video = &ipipeif_v4l2_video_ops,
 	.pad = &ipipeif_v4l2_pad_ops,
 };
 
diff --git a/drivers/staging/media/davinci_vpfe/dm365_isif.c b/drivers/staging/media/davinci_vpfe/dm365_isif.c
index ae9202d..fffca15 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_isif.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_isif.c
@@ -1366,7 +1366,8 @@ static int isif_configure(struct v4l2_subdev *sd, int mode)
  * @sd: VPFE ISIF V4L2 subdevice
  * @enable: Enable/disable stream
  */
-static int isif_set_stream(struct v4l2_subdev *sd, int enable)
+static int isif_set_stream(struct v4l2_subdev *sd, unsigned int pad,
+			   int enable)
 {
 	struct vpfe_isif_device *isif = v4l2_get_subdevdata(sd);
 	int ret;
@@ -1664,11 +1665,6 @@ static const struct v4l2_subdev_internal_ops isif_v4l2_internal_ops = {
 	.open = isif_init_formats,
 };
 
-/* subdev video operations */
-static const struct v4l2_subdev_video_ops isif_v4l2_video_ops = {
-	.s_stream = isif_set_stream,
-};
-
 /* subdev pad operations */
 static const struct v4l2_subdev_pad_ops isif_v4l2_pad_ops = {
 	.enum_mbus_code = isif_enum_mbus_code,
@@ -1677,12 +1673,12 @@ static const struct v4l2_subdev_pad_ops isif_v4l2_pad_ops = {
 	.set_fmt = isif_set_format,
 	.set_selection = isif_pad_set_selection,
 	.get_selection = isif_pad_get_selection,
+	.s_stream = isif_set_stream,
 };
 
 /* subdev operations */
 static const struct v4l2_subdev_ops isif_v4l2_ops = {
 	.core = &isif_v4l2_core_ops,
-	.video = &isif_v4l2_video_ops,
 	.pad = &isif_v4l2_pad_ops,
 };
 
diff --git a/drivers/staging/media/davinci_vpfe/dm365_resizer.c b/drivers/staging/media/davinci_vpfe/dm365_resizer.c
index 3cd56cc..fdd9753 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_resizer.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_resizer.c
@@ -1256,7 +1256,8 @@ static int resizer_do_hw_setup(struct vpfe_resizer_device *resizer)
  * @sd: pointer to v4l2 subdev structure
  * @enable: 1 == Enable, 0 == Disable
  */
-static int resizer_set_stream(struct v4l2_subdev *sd, int enable)
+static int resizer_set_stream(struct v4l2_subdev *sd, unsigned int pad,
+			      int enable)
 {
 	struct vpfe_resizer_device *resizer = v4l2_get_subdevdata(sd);
 
@@ -1609,23 +1610,18 @@ static const struct v4l2_subdev_internal_ops resizer_v4l2_internal_ops = {
 	.open = resizer_init_formats,
 };
 
-/* subdev video operations */
-static const struct v4l2_subdev_video_ops resizer_v4l2_video_ops = {
-	.s_stream = resizer_set_stream,
-};
-
 /* subdev pad operations */
 static const struct v4l2_subdev_pad_ops resizer_v4l2_pad_ops = {
 	.enum_mbus_code = resizer_enum_mbus_code,
 	.enum_frame_size = resizer_enum_frame_size,
 	.get_fmt = resizer_get_format,
 	.set_fmt = resizer_set_format,
+	.s_stream = resizer_set_stream,
 };
 
 /* subdev operations */
 static const struct v4l2_subdev_ops resizer_v4l2_ops = {
 	.core = &resizer_v4l2_core_ops,
-	.video = &resizer_v4l2_video_ops,
 	.pad = &resizer_v4l2_pad_ops,
 };
 
diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.c b/drivers/staging/media/davinci_vpfe/vpfe_video.c
index ea3ddec..7bfb1cd 100644
--- a/drivers/staging/media/davinci_vpfe/vpfe_video.c
+++ b/drivers/staging/media/davinci_vpfe/vpfe_video.c
@@ -310,7 +310,7 @@ static int vpfe_pipeline_enable(struct vpfe_pipeline *pipe)
 		if (!is_media_entity_v4l2_subdev(entity))
 			continue;
 		subdev = media_entity_to_v4l2_subdev(entity);
-		ret = v4l2_subdev_call(subdev, video, s_stream, 1);
+		ret = v4l2_subdev_call(subdev, pad, s_stream, 0, 1);
 		if (ret < 0 && ret != -ENOIOCTLCMD)
 			break;
 	}
@@ -353,7 +353,7 @@ static int vpfe_pipeline_disable(struct vpfe_pipeline *pipe)
 		if (!is_media_entity_v4l2_subdev(entity))
 			continue;
 		subdev = media_entity_to_v4l2_subdev(entity);
-		ret = v4l2_subdev_call(subdev, video, s_stream, 0);
+		ret = v4l2_subdev_call(subdev, pad, s_stream, 0, 0);
 		if (ret < 0 && ret != -ENOIOCTLCMD)
 			break;
 	}
diff --git a/drivers/staging/media/omap4iss/iss.c b/drivers/staging/media/omap4iss/iss.c
index 6ceb4eb..d2cac41 100644
--- a/drivers/staging/media/omap4iss/iss.c
+++ b/drivers/staging/media/omap4iss/iss.c
@@ -404,7 +404,7 @@ static int iss_pipeline_disable(struct iss_pipeline *pipe,
 			break;
 
 		subdev = media_entity_to_v4l2_subdev(entity);
-		ret = v4l2_subdev_call(subdev, video, s_stream, 0);
+		ret = v4l2_subdev_call(subdev, pad, s_stream, 0, 0);
 		if (ret < 0) {
 			dev_warn(iss->dev, "%s: module stop timeout.\n",
 				 subdev->name);
@@ -469,7 +469,7 @@ static int iss_pipeline_enable(struct iss_pipeline *pipe,
 		entity = pad->entity;
 		subdev = media_entity_to_v4l2_subdev(entity);
 
-		ret = v4l2_subdev_call(subdev, video, s_stream, mode);
+		ret = v4l2_subdev_call(subdev, pad, s_stream, 0, mode);
 		if (ret < 0 && ret != -ENOIOCTLCMD) {
 			iss_pipeline_disable(pipe, entity);
 			return ret;
diff --git a/drivers/staging/media/omap4iss/iss_csi2.c b/drivers/staging/media/omap4iss/iss_csi2.c
index aaca39d..4d4df5d 100644
--- a/drivers/staging/media/omap4iss/iss_csi2.c
+++ b/drivers/staging/media/omap4iss/iss_csi2.c
@@ -1066,7 +1066,8 @@ static int csi2_init_formats(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
  *
  * Return 0 on success or a negative error code otherwise.
  */
-static int csi2_set_stream(struct v4l2_subdev *sd, int enable)
+static int csi2_set_stream(struct v4l2_subdev *sd, unsigned int pad,
+			   int enable)
 {
 	struct iss_csi2_device *csi2 = v4l2_get_subdevdata(sd);
 	struct iss_device *iss = csi2->iss;
@@ -1126,11 +1127,6 @@ static int csi2_set_stream(struct v4l2_subdev *sd, int enable)
 	return ret;
 }
 
-/* subdev video operations */
-static const struct v4l2_subdev_video_ops csi2_video_ops = {
-	.s_stream = csi2_set_stream,
-};
-
 /* subdev pad operations */
 static const struct v4l2_subdev_pad_ops csi2_pad_ops = {
 	.enum_mbus_code = csi2_enum_mbus_code,
@@ -1138,11 +1134,11 @@ static const struct v4l2_subdev_pad_ops csi2_pad_ops = {
 	.get_fmt = csi2_get_format,
 	.set_fmt = csi2_set_format,
 	.link_validate = csi2_link_validate,
+	.s_stream = csi2_set_stream,
 };
 
 /* subdev operations */
 static const struct v4l2_subdev_ops csi2_ops = {
-	.video = &csi2_video_ops,
 	.pad = &csi2_pad_ops,
 };
 
diff --git a/drivers/staging/media/omap4iss/iss_ipipe.c b/drivers/staging/media/omap4iss/iss_ipipe.c
index d38782e..10d8055 100644
--- a/drivers/staging/media/omap4iss/iss_ipipe.c
+++ b/drivers/staging/media/omap4iss/iss_ipipe.c
@@ -129,7 +129,8 @@ static void ipipe_configure(struct iss_ipipe_device *ipipe)
  * @sd: ISP IPIPE V4L2 subdevice
  * @enable: Enable/disable stream
  */
-static int ipipe_set_stream(struct v4l2_subdev *sd, int enable)
+static int ipipe_set_stream(struct v4l2_subdev *sd, unsigned int pad,
+			    int enable)
 {
 	struct iss_ipipe_device *ipipe = v4l2_get_subdevdata(sd);
 	struct iss_device *iss = to_iss_device(ipipe);
@@ -401,11 +402,6 @@ static int ipipe_init_formats(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
 	return 0;
 }
 
-/* V4L2 subdev video operations */
-static const struct v4l2_subdev_video_ops ipipe_v4l2_video_ops = {
-	.s_stream = ipipe_set_stream,
-};
-
 /* V4L2 subdev pad operations */
 static const struct v4l2_subdev_pad_ops ipipe_v4l2_pad_ops = {
 	.enum_mbus_code = ipipe_enum_mbus_code,
@@ -413,11 +409,11 @@ static const struct v4l2_subdev_pad_ops ipipe_v4l2_pad_ops = {
 	.get_fmt = ipipe_get_format,
 	.set_fmt = ipipe_set_format,
 	.link_validate = ipipe_link_validate,
+	.s_stream = ipipe_set_stream,
 };
 
 /* V4L2 subdev operations */
 static const struct v4l2_subdev_ops ipipe_v4l2_ops = {
-	.video = &ipipe_v4l2_video_ops,
 	.pad = &ipipe_v4l2_pad_ops,
 };
 
diff --git a/drivers/staging/media/omap4iss/iss_ipipeif.c b/drivers/staging/media/omap4iss/iss_ipipeif.c
index 23de833..4c86b9c 100644
--- a/drivers/staging/media/omap4iss/iss_ipipeif.c
+++ b/drivers/staging/media/omap4iss/iss_ipipeif.c
@@ -303,7 +303,8 @@ static const struct iss_video_operations ipipeif_video_ops = {
  * @sd: ISP IPIPEIF V4L2 subdevice
  * @enable: Enable/disable stream
  */
-static int ipipeif_set_stream(struct v4l2_subdev *sd, int enable)
+static int ipipeif_set_stream(struct v4l2_subdev *sd, unsigned int pad,
+			      int enable)
 {
 	struct iss_ipipeif_device *ipipeif = v4l2_get_subdevdata(sd);
 	struct iss_device *iss = to_iss_device(ipipeif);
@@ -617,11 +618,6 @@ static int ipipeif_init_formats(struct v4l2_subdev *sd,
 	return 0;
 }
 
-/* V4L2 subdev video operations */
-static const struct v4l2_subdev_video_ops ipipeif_v4l2_video_ops = {
-	.s_stream = ipipeif_set_stream,
-};
-
 /* V4L2 subdev pad operations */
 static const struct v4l2_subdev_pad_ops ipipeif_v4l2_pad_ops = {
 	.enum_mbus_code = ipipeif_enum_mbus_code,
@@ -629,11 +625,11 @@ static const struct v4l2_subdev_pad_ops ipipeif_v4l2_pad_ops = {
 	.get_fmt = ipipeif_get_format,
 	.set_fmt = ipipeif_set_format,
 	.link_validate = ipipeif_link_validate,
+	.s_stream = ipipeif_set_stream,
 };
 
 /* V4L2 subdev operations */
 static const struct v4l2_subdev_ops ipipeif_v4l2_ops = {
-	.video = &ipipeif_v4l2_video_ops,
 	.pad = &ipipeif_v4l2_pad_ops,
 };
 
diff --git a/drivers/staging/media/omap4iss/iss_resizer.c b/drivers/staging/media/omap4iss/iss_resizer.c
index f1d352c..781fc1f 100644
--- a/drivers/staging/media/omap4iss/iss_resizer.c
+++ b/drivers/staging/media/omap4iss/iss_resizer.c
@@ -351,7 +351,8 @@ static const struct iss_video_operations resizer_video_ops = {
  * @sd: ISP RESIZER V4L2 subdevice
  * @enable: Enable/disable stream
  */
-static int resizer_set_stream(struct v4l2_subdev *sd, int enable)
+static int resizer_set_stream(struct v4l2_subdev *sd, unsigned int pad,
+			      int enable)
 {
 	struct iss_resizer_device *resizer = v4l2_get_subdevdata(sd);
 	struct iss_device *iss = to_iss_device(resizer);
@@ -671,11 +672,6 @@ static int resizer_init_formats(struct v4l2_subdev *sd,
 	return 0;
 }
 
-/* V4L2 subdev video operations */
-static const struct v4l2_subdev_video_ops resizer_v4l2_video_ops = {
-	.s_stream = resizer_set_stream,
-};
-
 /* V4L2 subdev pad operations */
 static const struct v4l2_subdev_pad_ops resizer_v4l2_pad_ops = {
 	.enum_mbus_code = resizer_enum_mbus_code,
@@ -683,11 +679,11 @@ static const struct v4l2_subdev_pad_ops resizer_v4l2_pad_ops = {
 	.get_fmt = resizer_get_format,
 	.set_fmt = resizer_set_format,
 	.link_validate = resizer_link_validate,
+	.s_stream = resizer_set_stream,
 };
 
 /* V4L2 subdev operations */
 static const struct v4l2_subdev_ops resizer_v4l2_ops = {
-	.video = &resizer_v4l2_video_ops,
 	.pad = &resizer_v4l2_pad_ops,
 };
 
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 32fc7a4..acdc437 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -356,9 +356,6 @@ struct v4l2_mbus_frame_desc {
  * @g_input_status: get input status. Same as the status field in the v4l2_input
  *	struct.
  *
- * @s_stream: used to notify the driver that a video stream will start or has
- *	stopped.
- *
  * @cropcap: callback for VIDIOC_CROPCAP ioctl handler code.
  *
  * @g_crop: callback for VIDIOC_G_CROP ioctl handler code.
@@ -402,7 +399,6 @@ struct v4l2_subdev_video_ops {
 	int (*g_tvnorms)(struct v4l2_subdev *sd, v4l2_std_id *std);
 	int (*g_tvnorms_output)(struct v4l2_subdev *sd, v4l2_std_id *std);
 	int (*g_input_status)(struct v4l2_subdev *sd, u32 *status);
-	int (*s_stream)(struct v4l2_subdev *sd, int enable);
 	int (*cropcap)(struct v4l2_subdev *sd, struct v4l2_cropcap *cc);
 	int (*g_crop)(struct v4l2_subdev *sd, struct v4l2_crop *crop);
 	int (*s_crop)(struct v4l2_subdev *sd, const struct v4l2_crop *crop);
@@ -606,6 +602,9 @@ struct v4l2_subdev_pad_config {
  *
  * @set_frame_desc: set the low level media bus frame parameters, @fd array
  *                  may be adjusted by the subdev driver to device capabilities.
+ * @s_stream: used to notify the driver that a video stream will start or has
+ *	      stopped.
+ *
  */
 struct v4l2_subdev_pad_ops {
 	int (*init_cfg)(struct v4l2_subdev *sd,
@@ -646,6 +645,7 @@ struct v4l2_subdev_pad_ops {
 			      struct v4l2_mbus_frame_desc *fd);
 	int (*set_frame_desc)(struct v4l2_subdev *sd, unsigned int pad,
 			      struct v4l2_mbus_frame_desc *fd);
+	int (*s_stream)(struct v4l2_subdev *sd, unsigned int pad, int enable);
 };
 
 struct v4l2_subdev_ops {
-- 
2.8.3

