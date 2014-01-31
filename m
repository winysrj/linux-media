Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4287 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932146AbaAaLMU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Jan 2014 06:12:20 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: detlev.casanova@gmail.com, laurent.pinchart@ideasonboard.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 1/2] v4l2-ctrls: add add_priv arg to v4l2_ctrl_add_handler
Date: Fri, 31 Jan 2014 12:12:05 +0100
Message-Id: <1391166726-27026-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1391166726-27026-1-git-send-email-hverkuil@xs4all.nl>
References: <1391166726-27026-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Make it possible to add private controls from the 'add' handler
to the target handler.

This patch just adds a new argument and updates all drivers to
just use 'false' for now.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/video4linux/v4l2-controls.txt      | 9 +++++----
 drivers/media/pci/bt8xx/bttv-driver.c            | 2 +-
 drivers/media/pci/cx88/cx88-blackbird.c          | 2 +-
 drivers/media/pci/cx88/cx88-video.c              | 2 +-
 drivers/media/pci/saa7134/saa7134-empress.c      | 6 ++++--
 drivers/media/pci/saa7134/saa7134-video.c        | 2 +-
 drivers/media/platform/exynos4-is/fimc-capture.c | 2 +-
 drivers/media/platform/soc_camera/soc_camera.c   | 3 ++-
 drivers/media/usb/cx231xx/cx231xx-417.c          | 2 +-
 drivers/media/usb/cx231xx/cx231xx-video.c        | 4 ++--
 drivers/media/usb/tm6000/tm6000-video.c          | 2 +-
 drivers/media/v4l2-core/v4l2-ctrls.c             | 5 +++--
 drivers/media/v4l2-core/v4l2-device.c            | 3 ++-
 include/media/v4l2-ctrls.h                       | 8 ++++++++
 14 files changed, 33 insertions(+), 19 deletions(-)

diff --git a/Documentation/video4linux/v4l2-controls.txt b/Documentation/video4linux/v4l2-controls.txt
index 06cf3ac..39b8c0f 100644
--- a/Documentation/video4linux/v4l2-controls.txt
+++ b/Documentation/video4linux/v4l2-controls.txt
@@ -619,11 +619,12 @@ handler and finally add the first handler to the second. For example:
 	v4l2_ctrl_new_std(&radio_ctrl_handler, &radio_ops, V4L2_CID_AUDIO_MUTE, ...);
 	v4l2_ctrl_new_std(&video_ctrl_handler, &video_ops, V4L2_CID_BRIGHTNESS, ...);
 	v4l2_ctrl_new_std(&video_ctrl_handler, &video_ops, V4L2_CID_CONTRAST, ...);
-	v4l2_ctrl_add_handler(&video_ctrl_handler, &radio_ctrl_handler, NULL);
+	v4l2_ctrl_add_handler(&video_ctrl_handler, &radio_ctrl_handler, false, NULL);
 
-The last argument to v4l2_ctrl_add_handler() is a filter function that allows
-you to filter which controls will be added. Set it to NULL if you want to add
-all controls.
+The last two arguments to v4l2_ctrl_add_handler() are a boolean that determines
+whether private controls should be added to the new handler (should normally be
+false) and a filter function that allows you to filter which controls will be
+added. Set it to NULL if you want to add all controls.
 
 Or you can add specific controls to a handler:
 
diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index afcd53b..9b34405 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -4196,7 +4196,7 @@ static int bttv_probe(struct pci_dev *dev, const struct pci_device_id *pci_id)
 	/* register video4linux + input */
 	if (!bttv_tvcards[btv->c.type].no_video) {
 		v4l2_ctrl_add_handler(&btv->radio_ctrl_handler, hdl,
-				v4l2_ctrl_radio_filter);
+				false, v4l2_ctrl_radio_filter);
 		if (btv->radio_ctrl_handler.error) {
 			result = btv->radio_ctrl_handler.error;
 			goto fail2;
diff --git a/drivers/media/pci/cx88/cx88-blackbird.c b/drivers/media/pci/cx88/cx88-blackbird.c
index 150bb76..abaf036 100644
--- a/drivers/media/pci/cx88/cx88-blackbird.c
+++ b/drivers/media/pci/cx88/cx88-blackbird.c
@@ -1237,7 +1237,7 @@ static int cx8802_blackbird_probe(struct cx8802_driver *drv)
 	err = cx2341x_handler_init(&dev->cxhdl, 36);
 	if (err)
 		goto fail_core;
-	v4l2_ctrl_add_handler(&dev->cxhdl.hdl, &core->video_hdl, NULL);
+	v4l2_ctrl_add_handler(&dev->cxhdl.hdl, &core->video_hdl, false, NULL);
 
 	/* blackbird stuff */
 	printk("%s/2: cx23416 based mpeg encoder (blackbird reference design)\n",
diff --git a/drivers/media/pci/cx88/cx88-video.c b/drivers/media/pci/cx88/cx88-video.c
index ed8cb90..c717238 100644
--- a/drivers/media/pci/cx88/cx88-video.c
+++ b/drivers/media/pci/cx88/cx88-video.c
@@ -1773,7 +1773,7 @@ static int cx8800_initdev(struct pci_dev *pci_dev,
 		if (vc->id == V4L2_CID_CHROMA_AGC)
 			core->chroma_agc = vc;
 	}
-	v4l2_ctrl_add_handler(&core->video_hdl, &core->audio_hdl, NULL);
+	v4l2_ctrl_add_handler(&core->video_hdl, &core->audio_hdl, false, NULL);
 
 	/* load and configure helper modules */
 
diff --git a/drivers/media/pci/saa7134/saa7134-empress.c b/drivers/media/pci/saa7134/saa7134-empress.c
index 0a9047e..6513e4b 100644
--- a/drivers/media/pci/saa7134/saa7134-empress.c
+++ b/drivers/media/pci/saa7134/saa7134-empress.c
@@ -328,9 +328,11 @@ static int empress_init(struct saa7134_dev *dev)
 		 saa7134_boards[dev->board].name);
 	set_bit(V4L2_FL_USE_FH_PRIO, &dev->empress_dev->flags);
 	v4l2_ctrl_handler_init(hdl, 21);
-	v4l2_ctrl_add_handler(hdl, &dev->ctrl_handler, empress_ctrl_filter);
+	v4l2_ctrl_add_handler(hdl, &dev->ctrl_handler,
+			      false, empress_ctrl_filter);
 	if (dev->empress_sd)
-		v4l2_ctrl_add_handler(hdl, dev->empress_sd->ctrl_handler, NULL);
+		v4l2_ctrl_add_handler(hdl, dev->empress_sd->ctrl_handler,
+				      false, NULL);
 	if (hdl->error) {
 		video_device_release(dev->empress_dev);
 		return hdl->error;
diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index eb472b5..e9a12c2 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -2223,7 +2223,7 @@ int saa7134_video_init1(struct saa7134_dev *dev)
 		hdl = &dev->radio_ctrl_handler;
 		v4l2_ctrl_handler_init(hdl, 2);
 		v4l2_ctrl_add_handler(hdl, &dev->ctrl_handler,
-				v4l2_ctrl_radio_filter);
+				false, v4l2_ctrl_radio_filter);
 		if (hdl->error)
 			return hdl->error;
 	}
diff --git a/drivers/media/platform/exynos4-is/fimc-capture.c b/drivers/media/platform/exynos4-is/fimc-capture.c
index 8a712ca..6fbff9e 100644
--- a/drivers/media/platform/exynos4-is/fimc-capture.c
+++ b/drivers/media/platform/exynos4-is/fimc-capture.c
@@ -1426,7 +1426,7 @@ static int fimc_link_setup(struct media_entity *entity,
 		return 0;
 
 	return v4l2_ctrl_add_handler(&vc->ctx->ctrls.handler,
-				     sensor->ctrl_handler, NULL);
+				     sensor->ctrl_handler, false, NULL);
 }
 
 static const struct media_entity_operations fimc_sd_media_ops = {
diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index 4b8c024..23d17f7 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -1277,7 +1277,8 @@ static int soc_camera_probe_finish(struct soc_camera_device *icd)
 	sd->grp_id = soc_camera_grp_id(icd);
 	v4l2_set_subdev_hostdata(sd, icd);
 
-	ret = v4l2_ctrl_add_handler(&icd->ctrl_handler, sd->ctrl_handler, NULL);
+	ret = v4l2_ctrl_add_handler(&icd->ctrl_handler, sd->ctrl_handler,
+				    false, NULL);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/media/usb/cx231xx/cx231xx-417.c b/drivers/media/usb/cx231xx/cx231xx-417.c
index 2f63029..26379a0 100644
--- a/drivers/media/usb/cx231xx/cx231xx-417.c
+++ b/drivers/media/usb/cx231xx/cx231xx-417.c
@@ -1964,7 +1964,7 @@ int cx231xx_417_register(struct cx231xx *dev)
 	dev->mpeg_ctrl_handler.ops = &cx231xx_ops;
 	if (dev->sd_cx25840)
 		v4l2_ctrl_add_handler(&dev->mpeg_ctrl_handler.hdl,
-				dev->sd_cx25840->ctrl_handler, NULL);
+				dev->sd_cx25840->ctrl_handler, false, NULL);
 	if (dev->mpeg_ctrl_handler.hdl.error) {
 		err = dev->mpeg_ctrl_handler.hdl.error;
 		dprintk(3, "%s: can't add cx25840 controls\n", dev->name);
diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
index 9906261..31e5370 100644
--- a/drivers/media/usb/cx231xx/cx231xx-video.c
+++ b/drivers/media/usb/cx231xx/cx231xx-video.c
@@ -2106,10 +2106,10 @@ int cx231xx_register_analog_devices(struct cx231xx *dev)
 
 	if (dev->sd_cx25840) {
 		v4l2_ctrl_add_handler(&dev->ctrl_handler,
-				dev->sd_cx25840->ctrl_handler, NULL);
+				dev->sd_cx25840->ctrl_handler, false, NULL);
 		v4l2_ctrl_add_handler(&dev->radio_ctrl_handler,
 				dev->sd_cx25840->ctrl_handler,
-				v4l2_ctrl_radio_filter);
+				false, v4l2_ctrl_radio_filter);
 	}
 
 	if (dev->ctrl_handler.error)
diff --git a/drivers/media/usb/tm6000/tm6000-video.c b/drivers/media/usb/tm6000/tm6000-video.c
index cc1aa14..5b7ff79 100644
--- a/drivers/media/usb/tm6000/tm6000-video.c
+++ b/drivers/media/usb/tm6000/tm6000-video.c
@@ -1653,7 +1653,7 @@ int tm6000_v4l2_register(struct tm6000_core *dev)
 	v4l2_ctrl_new_std(&dev->ctrl_handler, &tm6000_ctrl_ops,
 			V4L2_CID_HUE, -128, 127, 1, 0);
 	v4l2_ctrl_add_handler(&dev->ctrl_handler,
-			&dev->radio_ctrl_handler, NULL);
+			&dev->radio_ctrl_handler, false, NULL);
 
 	if (dev->radio_ctrl_handler.error)
 		ret = dev->radio_ctrl_handler.error;
diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 6ff002b..f586383 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1861,6 +1861,7 @@ EXPORT_SYMBOL(v4l2_ctrl_add_ctrl);
 /* Add the controls from another handler to our own. */
 int v4l2_ctrl_add_handler(struct v4l2_ctrl_handler *hdl,
 			  struct v4l2_ctrl_handler *add,
+			  bool add_priv,
 			  bool (*filter)(const struct v4l2_ctrl *ctrl))
 {
 	struct v4l2_ctrl_ref *ref;
@@ -1875,8 +1876,8 @@ int v4l2_ctrl_add_handler(struct v4l2_ctrl_handler *hdl,
 	list_for_each_entry(ref, &add->ctrl_refs, node) {
 		struct v4l2_ctrl *ctrl = ref->ctrl;
 
-		/* Skip handler-private controls. */
-		if (ctrl->is_private)
+		/* Skip handler-private controls unless requested otherwise */
+		if (!add_priv && ctrl->is_private)
 			continue;
 		/* And control classes */
 		if (ctrl->type == V4L2_CTRL_TYPE_CTRL_CLASS)
diff --git a/drivers/media/v4l2-core/v4l2-device.c b/drivers/media/v4l2-core/v4l2-device.c
index 02d1b63..7045cb2 100644
--- a/drivers/media/v4l2-core/v4l2-device.c
+++ b/drivers/media/v4l2-core/v4l2-device.c
@@ -169,7 +169,8 @@ int v4l2_device_register_subdev(struct v4l2_device *v4l2_dev,
 	}
 
 	/* This just returns 0 if either of the two args is NULL */
-	err = v4l2_ctrl_add_handler(v4l2_dev->ctrl_handler, sd->ctrl_handler, NULL);
+	err = v4l2_ctrl_add_handler(v4l2_dev->ctrl_handler, sd->ctrl_handler,
+				    false, NULL);
 	if (err)
 		goto error_unregister;
 
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 16f7f26..0142123 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -442,9 +442,16 @@ struct v4l2_ctrl *v4l2_ctrl_add_ctrl(struct v4l2_ctrl_handler *hdl,
   * @hdl:	The control handler.
   * @add:	The control handler whose controls you want to add to
   *		the @hdl control handler.
+  * @add_priv:	If true, then add private controls as well, otherwise
+  *		skip private controls.
   * @filter:	This function will filter which controls should be added.
   *
   * Does nothing if either of the two handlers is a NULL pointer.
+  * The @add_priv argument determines if private controls in @add should
+  * be added to @hdl or not. Normally private controls should not be added,
+  * but in some cases it may be desirable to do so. Primarily devices with
+  * a simple video pipeline may want to expose the private sub-device controls
+  * in the video node as well.
   * If @filter is NULL, then all controls are added. Otherwise only those
   * controls for which @filter returns true will be added.
   * In case of an error @hdl->error will be set to the error code (if it
@@ -452,6 +459,7 @@ struct v4l2_ctrl *v4l2_ctrl_add_ctrl(struct v4l2_ctrl_handler *hdl,
   */
 int v4l2_ctrl_add_handler(struct v4l2_ctrl_handler *hdl,
 			  struct v4l2_ctrl_handler *add,
+			  bool add_priv,
 			  bool (*filter)(const struct v4l2_ctrl *ctrl));
 
 /** v4l2_ctrl_radio_filter() - Standard filter for radio controls.
-- 
1.8.5.2

