Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-4.cisco.com ([144.254.224.147]:56410 "EHLO
	ams-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757397Ab2INLPq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Sep 2012 07:15:46 -0400
Received: from cobaltpc1.cisco.com (dhcp-10-54-92-107.cisco.com [10.54.92.107])
	by ams-core-2.cisco.com (8.14.5/8.14.5) with ESMTP id q8EBFghP000742
	for <linux-media@vger.kernel.org>; Fri, 14 Sep 2012 11:15:42 GMT
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Subject: [RFCv1 API PATCH 3/4] v4l2-ctrls: add a filter function to v4l2_ctrl_add_handler.
Date: Fri, 14 Sep 2012 13:15:35 +0200
Message-Id: <fdcaa41c6855681d4ddd0c258c17a420c321bb73.1347620872.git.hans.verkuil@cisco.com>
In-Reply-To: <1347621336-14108-1-git-send-email-hans.verkuil@cisco.com>
References: <1347621336-14108-1-git-send-email-hans.verkuil@cisco.com>
In-Reply-To: <da47f14735bb06321de298db1cb50172f8e1f480.1347620872.git.hans.verkuil@cisco.com>
References: <da47f14735bb06321de298db1cb50172f8e1f480.1347620872.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

With a filter function you can control more precisely which controls
are added. This is useful in particular for radio device nodes for
combined TV/Radio cards where you want to show just the radio-specific
controls and not controls like brightness.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/video4linux/v4l2-controls.txt    |    6 +++++-
 drivers/media/pci/cx88/cx88-blackbird.c        |    2 +-
 drivers/media/pci/cx88/cx88-video.c            |    2 +-
 drivers/media/platform/s5p-fimc/fimc-capture.c |    2 +-
 drivers/media/platform/soc_camera/soc_camera.c |    2 +-
 drivers/media/v4l2-core/v4l2-ctrls.c           |   25 +++++++++++++++++++++++-
 drivers/media/v4l2-core/v4l2-device.c          |    2 +-
 include/media/v4l2-ctrls.h                     |   18 +++++++++++++++--
 8 files changed, 50 insertions(+), 9 deletions(-)

diff --git a/Documentation/video4linux/v4l2-controls.txt b/Documentation/video4linux/v4l2-controls.txt
index cecaff8..cd4a26c 100644
--- a/Documentation/video4linux/v4l2-controls.txt
+++ b/Documentation/video4linux/v4l2-controls.txt
@@ -594,7 +594,11 @@ handler and finally add the first handler to the second. For example:
 	v4l2_ctrl_new_std(&radio_ctrl_handler, &radio_ops, V4L2_CID_AUDIO_MUTE, ...);
 	v4l2_ctrl_new_std(&video_ctrl_handler, &video_ops, V4L2_CID_BRIGHTNESS, ...);
 	v4l2_ctrl_new_std(&video_ctrl_handler, &video_ops, V4L2_CID_CONTRAST, ...);
-	v4l2_ctrl_add_handler(&video_ctrl_handler, &radio_ctrl_handler);
+	v4l2_ctrl_add_handler(&video_ctrl_handler, &radio_ctrl_handler, NULL);
+
+The last argument to v4l2_ctrl_add_handler() is a filter function that allows
+you to filter which controls will be added. Set it to NULL if you want to add
+all controls.
 
 Or you can add specific controls to a handler:
 
diff --git a/drivers/media/pci/cx88/cx88-blackbird.c b/drivers/media/pci/cx88/cx88-blackbird.c
index 843ffd9..def363f 100644
--- a/drivers/media/pci/cx88/cx88-blackbird.c
+++ b/drivers/media/pci/cx88/cx88-blackbird.c
@@ -1236,7 +1236,7 @@ static int cx8802_blackbird_probe(struct cx8802_driver *drv)
 	err = cx2341x_handler_init(&dev->cxhdl, 36);
 	if (err)
 		goto fail_core;
-	v4l2_ctrl_add_handler(&dev->cxhdl.hdl, &core->video_hdl);
+	v4l2_ctrl_add_handler(&dev->cxhdl.hdl, &core->video_hdl, NULL);
 
 	/* blackbird stuff */
 	printk("%s/2: cx23416 based mpeg encoder (blackbird reference design)\n",
diff --git a/drivers/media/pci/cx88/cx88-video.c b/drivers/media/pci/cx88/cx88-video.c
index f6fcc7e..a146d50 100644
--- a/drivers/media/pci/cx88/cx88-video.c
+++ b/drivers/media/pci/cx88/cx88-video.c
@@ -1795,7 +1795,7 @@ static int __devinit cx8800_initdev(struct pci_dev *pci_dev,
 		if (vc->id == V4L2_CID_CHROMA_AGC)
 			core->chroma_agc = vc;
 	}
-	v4l2_ctrl_add_handler(&core->video_hdl, &core->audio_hdl);
+	v4l2_ctrl_add_handler(&core->video_hdl, &core->audio_hdl, NULL);
 
 	/* load and configure helper modules */
 
diff --git a/drivers/media/platform/s5p-fimc/fimc-capture.c b/drivers/media/platform/s5p-fimc/fimc-capture.c
index 8e413dd..dde0901 100644
--- a/drivers/media/platform/s5p-fimc/fimc-capture.c
+++ b/drivers/media/platform/s5p-fimc/fimc-capture.c
@@ -472,7 +472,7 @@ int fimc_capture_ctrls_create(struct fimc_dev *fimc)
 		return ret;
 
 	return v4l2_ctrl_add_handler(&vid_cap->ctx->ctrls.handler,
-		    fimc->pipeline.subdevs[IDX_SENSOR]->ctrl_handler);
+		    fimc->pipeline.subdevs[IDX_SENSOR]->ctrl_handler, NULL);
 }
 
 static int fimc_capture_set_default_format(struct fimc_dev *fimc);
diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index f6b1c1f..3be9294 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -1184,7 +1184,7 @@ static int soc_camera_probe(struct soc_camera_device *icd)
 	sd->grp_id = soc_camera_grp_id(icd);
 	v4l2_set_subdev_hostdata(sd, icd);
 
-	if (v4l2_ctrl_add_handler(&icd->ctrl_handler, sd->ctrl_handler))
+	if (v4l2_ctrl_add_handler(&icd->ctrl_handler, sd->ctrl_handler, NULL))
 		goto ectrl;
 
 	/* At this point client .probe() should have run already */
diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 43061e1..b1b4660 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1689,7 +1689,8 @@ EXPORT_SYMBOL(v4l2_ctrl_add_ctrl);
 
 /* Add the controls from another handler to our own. */
 int v4l2_ctrl_add_handler(struct v4l2_ctrl_handler *hdl,
-			  struct v4l2_ctrl_handler *add)
+			  struct v4l2_ctrl_handler *add,
+			  bool (*filter)(const struct v4l2_ctrl *ctrl))
 {
 	struct v4l2_ctrl_ref *ref;
 	int ret = 0;
@@ -1709,6 +1710,9 @@ int v4l2_ctrl_add_handler(struct v4l2_ctrl_handler *hdl,
 		/* And control classes */
 		if (ctrl->type == V4L2_CTRL_TYPE_CTRL_CLASS)
 			continue;
+		/* Filter any unwanted controls */
+		if (filter && !filter(ctrl))
+			continue;
 		ret = handler_new_ref(hdl, ctrl);
 		if (ret)
 			break;
@@ -1718,6 +1722,25 @@ int v4l2_ctrl_add_handler(struct v4l2_ctrl_handler *hdl,
 }
 EXPORT_SYMBOL(v4l2_ctrl_add_handler);
 
+bool v4l2_ctrl_radio_filter(const struct v4l2_ctrl *ctrl)
+{
+	if (V4L2_CTRL_ID2CLASS(ctrl->id) == V4L2_CTRL_CLASS_FM_TX)
+		return true;
+	switch (ctrl->id) {
+	case V4L2_CID_AUDIO_MUTE:
+	case V4L2_CID_AUDIO_VOLUME:
+	case V4L2_CID_AUDIO_BALANCE:
+	case V4L2_CID_AUDIO_BASS:
+	case V4L2_CID_AUDIO_TREBLE:
+	case V4L2_CID_AUDIO_LOUDNESS:
+		return true;
+	default:
+		break;
+	}
+	return false;
+}
+EXPORT_SYMBOL(v4l2_ctrl_radio_filter);
+
 /* Cluster controls */
 void v4l2_ctrl_cluster(unsigned ncontrols, struct v4l2_ctrl **controls)
 {
diff --git a/drivers/media/v4l2-core/v4l2-device.c b/drivers/media/v4l2-core/v4l2-device.c
index 1f203b8..513969f 100644
--- a/drivers/media/v4l2-core/v4l2-device.c
+++ b/drivers/media/v4l2-core/v4l2-device.c
@@ -166,7 +166,7 @@ int v4l2_device_register_subdev(struct v4l2_device *v4l2_dev,
 	}
 
 	/* This just returns 0 if either of the two args is NULL */
-	err = v4l2_ctrl_add_handler(v4l2_dev->ctrl_handler, sd->ctrl_handler);
+	err = v4l2_ctrl_add_handler(v4l2_dev->ctrl_handler, sd->ctrl_handler, NULL);
 	if (err) {
 		if (sd->internal_ops && sd->internal_ops->unregistered)
 			sd->internal_ops->unregistered(sd);
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 4484fd3..2c486be 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -395,14 +395,28 @@ struct v4l2_ctrl *v4l2_ctrl_add_ctrl(struct v4l2_ctrl_handler *hdl,
   * @hdl:	The control handler.
   * @add:	The control handler whose controls you want to add to
   *		the @hdl control handler.
+  * @filter:	This function will filter which controls should be added.
   *
-  * Does nothing if either of the two is a NULL pointer.
+  * Does nothing if either of the two handlers is a NULL pointer.
+  * If @filter is NULL, then all controls are added. Otherwise only those
+  * controls for which @filter returns true will be added.
   * In case of an error @hdl->error will be set to the error code (if it
   * wasn't set already).
   */
 int v4l2_ctrl_add_handler(struct v4l2_ctrl_handler *hdl,
-			  struct v4l2_ctrl_handler *add);
+			  struct v4l2_ctrl_handler *add,
+			  bool (*filter)(const struct v4l2_ctrl *ctrl));
 
+/** v4l2_ctrl_radio_filter() - Standard filter for radio controls.
+  * @ctrl:	The control that is filtered.
+  *
+  * This will return true for any controls that are valid for radio device
+  * nodes. Those are all of the V4L2_CID_AUDIO_* user controls and all FM
+  * transmitter class controls.
+  *
+  * This function is to be used with v4l2_ctrl_add_handler().
+  */
+bool v4l2_ctrl_radio_filter(const struct v4l2_ctrl *ctrl);
 
 /** v4l2_ctrl_cluster() - Mark all controls in the cluster as belonging to that cluster.
   * @ncontrols:	The number of controls in this cluster.
-- 
1.7.10.4

