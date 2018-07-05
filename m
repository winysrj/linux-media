Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:46063 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753660AbeGEQDo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Jul 2018 12:03:44 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Alexandre Courbot <acourbot@chromium.org>
Subject: [PATCHv16 10/34] v4l2-ctrls: v4l2_ctrl_add_handler: add from_other_dev
Date: Thu,  5 Jul 2018 18:03:13 +0200
Message-Id: <20180705160337.54379-11-hverkuil@xs4all.nl>
In-Reply-To: <20180705160337.54379-1-hverkuil@xs4all.nl>
References: <20180705160337.54379-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add a 'bool from_other_dev' argument: set to true if the two
handlers refer to different devices (e.g. it is true when
inheriting controls from a subdev into a main v4l2 bridge
driver).

This will be used later when implementing support for the
request API since we need to skip such controls.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
---
 drivers/media/dvb-frontends/rtl2832_sdr.c     |  5 +-
 drivers/media/pci/bt8xx/bttv-driver.c         |  2 +-
 drivers/media/pci/cx23885/cx23885-417.c       |  2 +-
 drivers/media/pci/cx88/cx88-blackbird.c       |  2 +-
 drivers/media/pci/cx88/cx88-video.c           |  2 +-
 drivers/media/pci/saa7134/saa7134-empress.c   |  4 +-
 drivers/media/pci/saa7134/saa7134-video.c     |  2 +-
 .../media/platform/exynos4-is/fimc-capture.c  |  2 +-
 drivers/media/platform/rcar-vin/rcar-core.c   |  2 +-
 drivers/media/platform/rcar_drif.c            |  2 +-
 .../media/platform/soc_camera/soc_camera.c    |  3 +-
 drivers/media/platform/vivid/vivid-ctrls.c    | 46 +++++++++----------
 drivers/media/usb/cx231xx/cx231xx-417.c       |  2 +-
 drivers/media/usb/cx231xx/cx231xx-video.c     |  4 +-
 drivers/media/usb/msi2500/msi2500.c           |  2 +-
 drivers/media/usb/tm6000/tm6000-video.c       |  2 +-
 drivers/media/v4l2-core/v4l2-ctrls.c          | 11 +++--
 drivers/media/v4l2-core/v4l2-device.c         |  3 +-
 drivers/staging/media/imx/imx-media-dev.c     |  2 +-
 drivers/staging/media/imx/imx-media-fim.c     |  2 +-
 include/media/v4l2-ctrls.h                    |  8 +++-
 21 files changed, 61 insertions(+), 49 deletions(-)

diff --git a/drivers/media/dvb-frontends/rtl2832_sdr.c b/drivers/media/dvb-frontends/rtl2832_sdr.c
index c6e78d870ccd..6064d28224e8 100644
--- a/drivers/media/dvb-frontends/rtl2832_sdr.c
+++ b/drivers/media/dvb-frontends/rtl2832_sdr.c
@@ -1394,7 +1394,8 @@ static int rtl2832_sdr_probe(struct platform_device *pdev)
 	case RTL2832_SDR_TUNER_E4000:
 		v4l2_ctrl_handler_init(&dev->hdl, 9);
 		if (subdev)
-			v4l2_ctrl_add_handler(&dev->hdl, subdev->ctrl_handler, NULL);
+			v4l2_ctrl_add_handler(&dev->hdl, subdev->ctrl_handler,
+					      NULL, true);
 		break;
 	case RTL2832_SDR_TUNER_R820T:
 	case RTL2832_SDR_TUNER_R828D:
@@ -1423,7 +1424,7 @@ static int rtl2832_sdr_probe(struct platform_device *pdev)
 		v4l2_ctrl_handler_init(&dev->hdl, 2);
 		if (subdev)
 			v4l2_ctrl_add_handler(&dev->hdl, subdev->ctrl_handler,
-					      NULL);
+					      NULL, true);
 		break;
 	default:
 		v4l2_ctrl_handler_init(&dev->hdl, 0);
diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index cf05e11da01b..e86154092558 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -4211,7 +4211,7 @@ static int bttv_probe(struct pci_dev *dev, const struct pci_device_id *pci_id)
 	/* register video4linux + input */
 	if (!bttv_tvcards[btv->c.type].no_video) {
 		v4l2_ctrl_add_handler(&btv->radio_ctrl_handler, hdl,
-				v4l2_ctrl_radio_filter);
+				v4l2_ctrl_radio_filter, false);
 		if (btv->radio_ctrl_handler.error) {
 			result = btv->radio_ctrl_handler.error;
 			goto fail2;
diff --git a/drivers/media/pci/cx23885/cx23885-417.c b/drivers/media/pci/cx23885/cx23885-417.c
index a71f3c7569ce..762823871c78 100644
--- a/drivers/media/pci/cx23885/cx23885-417.c
+++ b/drivers/media/pci/cx23885/cx23885-417.c
@@ -1527,7 +1527,7 @@ int cx23885_417_register(struct cx23885_dev *dev)
 	dev->cxhdl.priv = dev;
 	dev->cxhdl.func = cx23885_api_func;
 	cx2341x_handler_set_50hz(&dev->cxhdl, tsport->height == 576);
-	v4l2_ctrl_add_handler(&dev->ctrl_handler, &dev->cxhdl.hdl, NULL);
+	v4l2_ctrl_add_handler(&dev->ctrl_handler, &dev->cxhdl.hdl, NULL, false);
 
 	/* Allocate and initialize V4L video device */
 	dev->v4l_device = cx23885_video_dev_alloc(tsport,
diff --git a/drivers/media/pci/cx88/cx88-blackbird.c b/drivers/media/pci/cx88/cx88-blackbird.c
index 7a4876cf9f08..722dd101c9b0 100644
--- a/drivers/media/pci/cx88/cx88-blackbird.c
+++ b/drivers/media/pci/cx88/cx88-blackbird.c
@@ -1183,7 +1183,7 @@ static int cx8802_blackbird_probe(struct cx8802_driver *drv)
 	err = cx2341x_handler_init(&dev->cxhdl, 36);
 	if (err)
 		goto fail_core;
-	v4l2_ctrl_add_handler(&dev->cxhdl.hdl, &core->video_hdl, NULL);
+	v4l2_ctrl_add_handler(&dev->cxhdl.hdl, &core->video_hdl, NULL, false);
 
 	/* blackbird stuff */
 	pr_info("cx23416 based mpeg encoder (blackbird reference design)\n");
diff --git a/drivers/media/pci/cx88/cx88-video.c b/drivers/media/pci/cx88/cx88-video.c
index 7b113bad70d2..85e2b6c9fb1c 100644
--- a/drivers/media/pci/cx88/cx88-video.c
+++ b/drivers/media/pci/cx88/cx88-video.c
@@ -1378,7 +1378,7 @@ static int cx8800_initdev(struct pci_dev *pci_dev,
 		if (vc->id == V4L2_CID_CHROMA_AGC)
 			core->chroma_agc = vc;
 	}
-	v4l2_ctrl_add_handler(&core->video_hdl, &core->audio_hdl, NULL);
+	v4l2_ctrl_add_handler(&core->video_hdl, &core->audio_hdl, NULL, false);
 
 	/* load and configure helper modules */
 
diff --git a/drivers/media/pci/saa7134/saa7134-empress.c b/drivers/media/pci/saa7134/saa7134-empress.c
index 66acfd35ffc6..fc75ce00dbf8 100644
--- a/drivers/media/pci/saa7134/saa7134-empress.c
+++ b/drivers/media/pci/saa7134/saa7134-empress.c
@@ -265,9 +265,9 @@ static int empress_init(struct saa7134_dev *dev)
 		 "%s empress (%s)", dev->name,
 		 saa7134_boards[dev->board].name);
 	v4l2_ctrl_handler_init(hdl, 21);
-	v4l2_ctrl_add_handler(hdl, &dev->ctrl_handler, empress_ctrl_filter);
+	v4l2_ctrl_add_handler(hdl, &dev->ctrl_handler, empress_ctrl_filter, false);
 	if (dev->empress_sd)
-		v4l2_ctrl_add_handler(hdl, dev->empress_sd->ctrl_handler, NULL);
+		v4l2_ctrl_add_handler(hdl, dev->empress_sd->ctrl_handler, NULL, true);
 	if (hdl->error) {
 		video_device_release(dev->empress_dev);
 		return hdl->error;
diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index 1a50ec9d084f..41d46488d22e 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -2136,7 +2136,7 @@ int saa7134_video_init1(struct saa7134_dev *dev)
 		hdl = &dev->radio_ctrl_handler;
 		v4l2_ctrl_handler_init(hdl, 2);
 		v4l2_ctrl_add_handler(hdl, &dev->ctrl_handler,
-				v4l2_ctrl_radio_filter);
+				v4l2_ctrl_radio_filter, false);
 		if (hdl->error)
 			return hdl->error;
 	}
diff --git a/drivers/media/platform/exynos4-is/fimc-capture.c b/drivers/media/platform/exynos4-is/fimc-capture.c
index a3cdac188190..2164375f0ee0 100644
--- a/drivers/media/platform/exynos4-is/fimc-capture.c
+++ b/drivers/media/platform/exynos4-is/fimc-capture.c
@@ -1424,7 +1424,7 @@ static int fimc_link_setup(struct media_entity *entity,
 		return 0;
 
 	return v4l2_ctrl_add_handler(&vc->ctx->ctrls.handler,
-				     sensor->ctrl_handler, NULL);
+				     sensor->ctrl_handler, NULL, true);
 }
 
 static const struct media_entity_operations fimc_sd_media_ops = {
diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index 8843367cd339..08446d005e08 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -480,7 +480,7 @@ static int rvin_parallel_subdevice_attach(struct rvin_dev *vin,
 		return ret;
 
 	ret = v4l2_ctrl_add_handler(&vin->ctrl_handler, subdev->ctrl_handler,
-				    NULL);
+				    NULL, true);
 	if (ret < 0) {
 		v4l2_ctrl_handler_free(&vin->ctrl_handler);
 		return ret;
diff --git a/drivers/media/platform/rcar_drif.c b/drivers/media/platform/rcar_drif.c
index dc7e280c91b4..159c7d2c2066 100644
--- a/drivers/media/platform/rcar_drif.c
+++ b/drivers/media/platform/rcar_drif.c
@@ -1168,7 +1168,7 @@ static int rcar_drif_notify_complete(struct v4l2_async_notifier *notifier)
 	}
 
 	ret = v4l2_ctrl_add_handler(&sdr->ctrl_hdl,
-				    sdr->ep.subdev->ctrl_handler, NULL);
+				    sdr->ep.subdev->ctrl_handler, NULL, true);
 	if (ret) {
 		rdrif_err(sdr, "failed: ctrl add hdlr ret %d\n", ret);
 		goto error;
diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index 66d613629167..901c07f49351 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -1181,7 +1181,8 @@ static int soc_camera_probe_finish(struct soc_camera_device *icd)
 
 	v4l2_subdev_call(sd, video, g_tvnorms, &icd->vdev->tvnorms);
 
-	ret = v4l2_ctrl_add_handler(&icd->ctrl_handler, sd->ctrl_handler, NULL);
+	ret = v4l2_ctrl_add_handler(&icd->ctrl_handler, sd->ctrl_handler,
+				    NULL, true);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/media/platform/vivid/vivid-ctrls.c b/drivers/media/platform/vivid/vivid-ctrls.c
index 5429193fbb91..5655f39d8e76 100644
--- a/drivers/media/platform/vivid/vivid-ctrls.c
+++ b/drivers/media/platform/vivid/vivid-ctrls.c
@@ -1662,59 +1662,59 @@ int vivid_create_controls(struct vivid_dev *dev, bool show_ccs_cap,
 		v4l2_ctrl_auto_cluster(2, &dev->autogain, 0, true);
 
 	if (dev->has_vid_cap) {
-		v4l2_ctrl_add_handler(hdl_vid_cap, hdl_user_gen, NULL);
-		v4l2_ctrl_add_handler(hdl_vid_cap, hdl_user_vid, NULL);
-		v4l2_ctrl_add_handler(hdl_vid_cap, hdl_user_aud, NULL);
-		v4l2_ctrl_add_handler(hdl_vid_cap, hdl_streaming, NULL);
-		v4l2_ctrl_add_handler(hdl_vid_cap, hdl_sdtv_cap, NULL);
-		v4l2_ctrl_add_handler(hdl_vid_cap, hdl_loop_cap, NULL);
-		v4l2_ctrl_add_handler(hdl_vid_cap, hdl_fb, NULL);
+		v4l2_ctrl_add_handler(hdl_vid_cap, hdl_user_gen, NULL, false);
+		v4l2_ctrl_add_handler(hdl_vid_cap, hdl_user_vid, NULL, false);
+		v4l2_ctrl_add_handler(hdl_vid_cap, hdl_user_aud, NULL, false);
+		v4l2_ctrl_add_handler(hdl_vid_cap, hdl_streaming, NULL, false);
+		v4l2_ctrl_add_handler(hdl_vid_cap, hdl_sdtv_cap, NULL, false);
+		v4l2_ctrl_add_handler(hdl_vid_cap, hdl_loop_cap, NULL, false);
+		v4l2_ctrl_add_handler(hdl_vid_cap, hdl_fb, NULL, false);
 		if (hdl_vid_cap->error)
 			return hdl_vid_cap->error;
 		dev->vid_cap_dev.ctrl_handler = hdl_vid_cap;
 	}
 	if (dev->has_vid_out) {
-		v4l2_ctrl_add_handler(hdl_vid_out, hdl_user_gen, NULL);
-		v4l2_ctrl_add_handler(hdl_vid_out, hdl_user_aud, NULL);
-		v4l2_ctrl_add_handler(hdl_vid_out, hdl_streaming, NULL);
-		v4l2_ctrl_add_handler(hdl_vid_out, hdl_fb, NULL);
+		v4l2_ctrl_add_handler(hdl_vid_out, hdl_user_gen, NULL, false);
+		v4l2_ctrl_add_handler(hdl_vid_out, hdl_user_aud, NULL, false);
+		v4l2_ctrl_add_handler(hdl_vid_out, hdl_streaming, NULL, false);
+		v4l2_ctrl_add_handler(hdl_vid_out, hdl_fb, NULL, false);
 		if (hdl_vid_out->error)
 			return hdl_vid_out->error;
 		dev->vid_out_dev.ctrl_handler = hdl_vid_out;
 	}
 	if (dev->has_vbi_cap) {
-		v4l2_ctrl_add_handler(hdl_vbi_cap, hdl_user_gen, NULL);
-		v4l2_ctrl_add_handler(hdl_vbi_cap, hdl_streaming, NULL);
-		v4l2_ctrl_add_handler(hdl_vbi_cap, hdl_sdtv_cap, NULL);
-		v4l2_ctrl_add_handler(hdl_vbi_cap, hdl_loop_cap, NULL);
+		v4l2_ctrl_add_handler(hdl_vbi_cap, hdl_user_gen, NULL, false);
+		v4l2_ctrl_add_handler(hdl_vbi_cap, hdl_streaming, NULL, false);
+		v4l2_ctrl_add_handler(hdl_vbi_cap, hdl_sdtv_cap, NULL, false);
+		v4l2_ctrl_add_handler(hdl_vbi_cap, hdl_loop_cap, NULL, false);
 		if (hdl_vbi_cap->error)
 			return hdl_vbi_cap->error;
 		dev->vbi_cap_dev.ctrl_handler = hdl_vbi_cap;
 	}
 	if (dev->has_vbi_out) {
-		v4l2_ctrl_add_handler(hdl_vbi_out, hdl_user_gen, NULL);
-		v4l2_ctrl_add_handler(hdl_vbi_out, hdl_streaming, NULL);
+		v4l2_ctrl_add_handler(hdl_vbi_out, hdl_user_gen, NULL, false);
+		v4l2_ctrl_add_handler(hdl_vbi_out, hdl_streaming, NULL, false);
 		if (hdl_vbi_out->error)
 			return hdl_vbi_out->error;
 		dev->vbi_out_dev.ctrl_handler = hdl_vbi_out;
 	}
 	if (dev->has_radio_rx) {
-		v4l2_ctrl_add_handler(hdl_radio_rx, hdl_user_gen, NULL);
-		v4l2_ctrl_add_handler(hdl_radio_rx, hdl_user_aud, NULL);
+		v4l2_ctrl_add_handler(hdl_radio_rx, hdl_user_gen, NULL, false);
+		v4l2_ctrl_add_handler(hdl_radio_rx, hdl_user_aud, NULL, false);
 		if (hdl_radio_rx->error)
 			return hdl_radio_rx->error;
 		dev->radio_rx_dev.ctrl_handler = hdl_radio_rx;
 	}
 	if (dev->has_radio_tx) {
-		v4l2_ctrl_add_handler(hdl_radio_tx, hdl_user_gen, NULL);
-		v4l2_ctrl_add_handler(hdl_radio_tx, hdl_user_aud, NULL);
+		v4l2_ctrl_add_handler(hdl_radio_tx, hdl_user_gen, NULL, false);
+		v4l2_ctrl_add_handler(hdl_radio_tx, hdl_user_aud, NULL, false);
 		if (hdl_radio_tx->error)
 			return hdl_radio_tx->error;
 		dev->radio_tx_dev.ctrl_handler = hdl_radio_tx;
 	}
 	if (dev->has_sdr_cap) {
-		v4l2_ctrl_add_handler(hdl_sdr_cap, hdl_user_gen, NULL);
-		v4l2_ctrl_add_handler(hdl_sdr_cap, hdl_streaming, NULL);
+		v4l2_ctrl_add_handler(hdl_sdr_cap, hdl_user_gen, NULL, false);
+		v4l2_ctrl_add_handler(hdl_sdr_cap, hdl_streaming, NULL, false);
 		if (hdl_sdr_cap->error)
 			return hdl_sdr_cap->error;
 		dev->sdr_cap_dev.ctrl_handler = hdl_sdr_cap;
diff --git a/drivers/media/usb/cx231xx/cx231xx-417.c b/drivers/media/usb/cx231xx/cx231xx-417.c
index 2f3b0564d676..e3cb9eefd36a 100644
--- a/drivers/media/usb/cx231xx/cx231xx-417.c
+++ b/drivers/media/usb/cx231xx/cx231xx-417.c
@@ -1992,7 +1992,7 @@ int cx231xx_417_register(struct cx231xx *dev)
 	dev->mpeg_ctrl_handler.ops = &cx231xx_ops;
 	if (dev->sd_cx25840)
 		v4l2_ctrl_add_handler(&dev->mpeg_ctrl_handler.hdl,
-				dev->sd_cx25840->ctrl_handler, NULL);
+				dev->sd_cx25840->ctrl_handler, NULL, false);
 	if (dev->mpeg_ctrl_handler.hdl.error) {
 		err = dev->mpeg_ctrl_handler.hdl.error;
 		dprintk(3, "%s: can't add cx25840 controls\n", dev->name);
diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
index f7fcd733a2ca..2dedb18f63a0 100644
--- a/drivers/media/usb/cx231xx/cx231xx-video.c
+++ b/drivers/media/usb/cx231xx/cx231xx-video.c
@@ -2204,10 +2204,10 @@ int cx231xx_register_analog_devices(struct cx231xx *dev)
 
 	if (dev->sd_cx25840) {
 		v4l2_ctrl_add_handler(&dev->ctrl_handler,
-				dev->sd_cx25840->ctrl_handler, NULL);
+				dev->sd_cx25840->ctrl_handler, NULL, true);
 		v4l2_ctrl_add_handler(&dev->radio_ctrl_handler,
 				dev->sd_cx25840->ctrl_handler,
-				v4l2_ctrl_radio_filter);
+				v4l2_ctrl_radio_filter, true);
 	}
 
 	if (dev->ctrl_handler.error)
diff --git a/drivers/media/usb/msi2500/msi2500.c b/drivers/media/usb/msi2500/msi2500.c
index 65ef755adfdc..4aacd77a5d58 100644
--- a/drivers/media/usb/msi2500/msi2500.c
+++ b/drivers/media/usb/msi2500/msi2500.c
@@ -1278,7 +1278,7 @@ static int msi2500_probe(struct usb_interface *intf,
 	}
 
 	/* currently all controls are from subdev */
-	v4l2_ctrl_add_handler(&dev->hdl, sd->ctrl_handler, NULL);
+	v4l2_ctrl_add_handler(&dev->hdl, sd->ctrl_handler, NULL, true);
 
 	dev->v4l2_dev.ctrl_handler = &dev->hdl;
 	dev->vdev.v4l2_dev = &dev->v4l2_dev;
diff --git a/drivers/media/usb/tm6000/tm6000-video.c b/drivers/media/usb/tm6000/tm6000-video.c
index 96055de6e8ce..176abbf5fbba 100644
--- a/drivers/media/usb/tm6000/tm6000-video.c
+++ b/drivers/media/usb/tm6000/tm6000-video.c
@@ -1625,7 +1625,7 @@ int tm6000_v4l2_register(struct tm6000_core *dev)
 	v4l2_ctrl_new_std(&dev->ctrl_handler, &tm6000_ctrl_ops,
 			V4L2_CID_HUE, -128, 127, 1, 0);
 	v4l2_ctrl_add_handler(&dev->ctrl_handler,
-			&dev->radio_ctrl_handler, NULL);
+			&dev->radio_ctrl_handler, NULL, false);
 
 	if (dev->radio_ctrl_handler.error)
 		ret = dev->radio_ctrl_handler.error;
diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 599c1cbff3b9..404291f00715 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -2016,7 +2016,8 @@ EXPORT_SYMBOL(v4l2_ctrl_find);
 
 /* Allocate a new v4l2_ctrl_ref and hook it into the handler. */
 static int handler_new_ref(struct v4l2_ctrl_handler *hdl,
-			   struct v4l2_ctrl *ctrl)
+			   struct v4l2_ctrl *ctrl,
+			   bool from_other_dev)
 {
 	struct v4l2_ctrl_ref *ref;
 	struct v4l2_ctrl_ref *new_ref;
@@ -2040,6 +2041,7 @@ static int handler_new_ref(struct v4l2_ctrl_handler *hdl,
 	if (!new_ref)
 		return handler_set_err(hdl, -ENOMEM);
 	new_ref->ctrl = ctrl;
+	new_ref->from_other_dev = from_other_dev;
 	if (ctrl->handler == hdl) {
 		/* By default each control starts in a cluster of its own.
 		   new_ref->ctrl is basically a cluster array with one
@@ -2220,7 +2222,7 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
 		ctrl->type_ops->init(ctrl, idx, ctrl->p_new);
 	}
 
-	if (handler_new_ref(hdl, ctrl)) {
+	if (handler_new_ref(hdl, ctrl, false)) {
 		kvfree(ctrl);
 		return NULL;
 	}
@@ -2389,7 +2391,8 @@ EXPORT_SYMBOL(v4l2_ctrl_new_int_menu);
 /* Add the controls from another handler to our own. */
 int v4l2_ctrl_add_handler(struct v4l2_ctrl_handler *hdl,
 			  struct v4l2_ctrl_handler *add,
-			  bool (*filter)(const struct v4l2_ctrl *ctrl))
+			  bool (*filter)(const struct v4l2_ctrl *ctrl),
+			  bool from_other_dev)
 {
 	struct v4l2_ctrl_ref *ref;
 	int ret = 0;
@@ -2412,7 +2415,7 @@ int v4l2_ctrl_add_handler(struct v4l2_ctrl_handler *hdl,
 		/* Filter any unwanted controls */
 		if (filter && !filter(ctrl))
 			continue;
-		ret = handler_new_ref(hdl, ctrl);
+		ret = handler_new_ref(hdl, ctrl, from_other_dev);
 		if (ret)
 			break;
 	}
diff --git a/drivers/media/v4l2-core/v4l2-device.c b/drivers/media/v4l2-core/v4l2-device.c
index 3940e55c72f1..5189fb9f741f 100644
--- a/drivers/media/v4l2-core/v4l2-device.c
+++ b/drivers/media/v4l2-core/v4l2-device.c
@@ -178,7 +178,8 @@ int v4l2_device_register_subdev(struct v4l2_device *v4l2_dev,
 
 	sd->v4l2_dev = v4l2_dev;
 	/* This just returns 0 if either of the two args is NULL */
-	err = v4l2_ctrl_add_handler(v4l2_dev->ctrl_handler, sd->ctrl_handler, NULL);
+	err = v4l2_ctrl_add_handler(v4l2_dev->ctrl_handler, sd->ctrl_handler,
+				    NULL, true);
 	if (err)
 		goto error_module;
 
diff --git a/drivers/staging/media/imx/imx-media-dev.c b/drivers/staging/media/imx/imx-media-dev.c
index b0be80f05767..b03a4b7bb769 100644
--- a/drivers/staging/media/imx/imx-media-dev.c
+++ b/drivers/staging/media/imx/imx-media-dev.c
@@ -391,7 +391,7 @@ static int imx_media_inherit_controls(struct imx_media_dev *imxmd,
 
 		ret = v4l2_ctrl_add_handler(vfd->ctrl_handler,
 					    sd->ctrl_handler,
-					    NULL);
+					    NULL, true);
 		if (ret)
 			return ret;
 	}
diff --git a/drivers/staging/media/imx/imx-media-fim.c b/drivers/staging/media/imx/imx-media-fim.c
index 6df189135db8..8cf773eef9da 100644
--- a/drivers/staging/media/imx/imx-media-fim.c
+++ b/drivers/staging/media/imx/imx-media-fim.c
@@ -463,7 +463,7 @@ int imx_media_fim_add_controls(struct imx_media_fim *fim)
 {
 	/* add the FIM controls to the calling subdev ctrl handler */
 	return v4l2_ctrl_add_handler(fim->sd->ctrl_handler,
-				     &fim->ctrl_handler, NULL);
+				     &fim->ctrl_handler, NULL, false);
 }
 EXPORT_SYMBOL_GPL(imx_media_fim_add_controls);
 
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 5b445b5654f7..d26b8ddebb56 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -247,6 +247,8 @@ struct v4l2_ctrl {
  * @ctrl:	The actual control information.
  * @helper:	Pointer to helper struct. Used internally in
  *		``prepare_ext_ctrls`` function at ``v4l2-ctrl.c``.
+ * @from_other_dev: If true, then @ctrl was defined in another
+ *		device than the &struct v4l2_ctrl_handler.
  *
  * Each control handler has a list of these refs. The list_head is used to
  * keep a sorted-by-control-ID list of all controls, while the next pointer
@@ -257,6 +259,7 @@ struct v4l2_ctrl_ref {
 	struct v4l2_ctrl_ref *next;
 	struct v4l2_ctrl *ctrl;
 	struct v4l2_ctrl_helper *helper;
+	bool from_other_dev;
 };
 
 /**
@@ -633,6 +636,8 @@ typedef bool (*v4l2_ctrl_filter)(const struct v4l2_ctrl *ctrl);
  * @add:	The control handler whose controls you want to add to
  *		the @hdl control handler.
  * @filter:	This function will filter which controls should be added.
+ * @from_other_dev: If true, then the controls in @add were defined in another
+ *		device than @hdl.
  *
  * Does nothing if either of the two handlers is a NULL pointer.
  * If @filter is NULL, then all controls are added. Otherwise only those
@@ -642,7 +647,8 @@ typedef bool (*v4l2_ctrl_filter)(const struct v4l2_ctrl *ctrl);
  */
 int v4l2_ctrl_add_handler(struct v4l2_ctrl_handler *hdl,
 			  struct v4l2_ctrl_handler *add,
-			  v4l2_ctrl_filter filter);
+			  v4l2_ctrl_filter filter,
+			  bool from_other_dev);
 
 /**
  * v4l2_ctrl_radio_filter() - Standard filter for radio controls.
-- 
2.18.0
