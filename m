Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-1.cisco.com ([173.38.203.51]:16950 "EHLO
        aer-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752892AbeBULY6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Feb 2018 06:24:58 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Alexandre Courbot <acourbot@chromium.org>
From: Hans Verkuil <hansverk@cisco.com>
Subject: [ALPHA PATCH] vivid: add media device
Message-ID: <81a74bba-388c-634c-00df-06e2de4f668a@cisco.com>
Date: Wed, 21 Feb 2018 12:24:56 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for the media controller to the vivid driver.

Very preliminary, but enough to help out Alexandre.

I need to add other entities representing tuner and video receivers
and transmitters, i.e. give it a proper MC graph.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/drivers/media/platform/vivid/Kconfig b/drivers/media/platform/vivid/Kconfig
index 154de92dd809..86f29c9c2bc5 100644
--- a/drivers/media/platform/vivid/Kconfig
+++ b/drivers/media/platform/vivid/Kconfig
@@ -7,6 +7,7 @@ config VIDEO_VIVID
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
+	select MEDIA_CONTROLLER
 	select VIDEOBUF2_VMALLOC
 	select VIDEOBUF2_DMA_CONTIG
 	select VIDEO_V4L2_TPG
diff --git a/drivers/media/platform/vivid/vivid-core.c b/drivers/media/platform/vivid/vivid-core.c
index 82ec216f2ad8..9f944df5eaae 100644
--- a/drivers/media/platform/vivid/vivid-core.c
+++ b/drivers/media/platform/vivid/vivid-core.c
@@ -657,6 +657,13 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)

 	dev->inst = inst;

+	dev->v4l2_dev.mdev = &dev->mdev;
+
+	/* Initialize media device */
+	strlcpy(dev->mdev.model, VIVID_MODULE_NAME, sizeof(dev->mdev.model));
+	dev->mdev.dev = &pdev->dev;
+	media_device_init(&dev->mdev);
+
 	/* register v4l2_device */
 	snprintf(dev->v4l2_dev.name, sizeof(dev->v4l2_dev.name),
 			"%s-%03d", VIVID_MODULE_NAME, inst);
@@ -1173,6 +1180,11 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		vfd->lock = &dev->mutex;
 		video_set_drvdata(vfd, dev);

+		dev->vid_cap_pad.flags = MEDIA_PAD_FL_SINK;
+		ret = media_entity_pads_init(&vfd->entity, 1, &dev->vid_cap_pad);
+		if (ret)
+			goto unreg_dev;
+
 #ifdef CONFIG_VIDEO_VIVID_CEC
 		if (in_type_counter[HDMI]) {
 			struct cec_adapter *adap;
@@ -1225,6 +1237,11 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		vfd->lock = &dev->mutex;
 		video_set_drvdata(vfd, dev);

+		dev->vid_out_pad.flags = MEDIA_PAD_FL_SOURCE;
+		ret = media_entity_pads_init(&vfd->entity, 1, &dev->vid_out_pad);
+		if (ret)
+			goto unreg_dev;
+
 #ifdef CONFIG_VIDEO_VIVID_CEC
 		for (i = 0; i < dev->num_outputs; i++) {
 			struct cec_adapter *adap;
@@ -1274,6 +1291,11 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		vfd->tvnorms = tvnorms_cap;
 		video_set_drvdata(vfd, dev);

+		dev->vbi_cap_pad.flags = MEDIA_PAD_FL_SINK;
+		ret = media_entity_pads_init(&vfd->entity, 1, &dev->vbi_cap_pad);
+		if (ret)
+			goto unreg_dev;
+
 		ret = video_register_device(vfd, VFL_TYPE_VBI, vbi_cap_nr[inst]);
 		if (ret < 0)
 			goto unreg_dev;
@@ -1299,6 +1321,11 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		vfd->tvnorms = tvnorms_out;
 		video_set_drvdata(vfd, dev);

+		dev->vbi_out_pad.flags = MEDIA_PAD_FL_SOURCE;
+		ret = media_entity_pads_init(&vfd->entity, 1, &dev->vbi_out_pad);
+		if (ret)
+			goto unreg_dev;
+
 		ret = video_register_device(vfd, VFL_TYPE_VBI, vbi_out_nr[inst]);
 		if (ret < 0)
 			goto unreg_dev;
@@ -1322,6 +1349,11 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		vfd->lock = &dev->mutex;
 		video_set_drvdata(vfd, dev);

+		dev->sdr_cap_pad.flags = MEDIA_PAD_FL_SINK;
+		ret = media_entity_pads_init(&vfd->entity, 1, &dev->sdr_cap_pad);
+		if (ret)
+			goto unreg_dev;
+
 		ret = video_register_device(vfd, VFL_TYPE_SDR, sdr_cap_nr[inst]);
 		if (ret < 0)
 			goto unreg_dev;
@@ -1368,12 +1400,21 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 					  video_device_node_name(vfd));
 	}

+	/* Register the media device */
+	ret = media_device_register(&dev->mdev);
+	if (ret) {
+		dev_err(dev->mdev.dev,
+			"media device register failed (err=%d)\n", ret);
+		goto unreg_dev;
+	}
+
 	/* Now that everything is fine, let's add it to device list */
 	vivid_devs[inst] = dev;

 	return 0;

 unreg_dev:
+	media_device_unregister(&dev->mdev);
 	video_unregister_device(&dev->radio_tx_dev);
 	video_unregister_device(&dev->radio_rx_dev);
 	video_unregister_device(&dev->sdr_cap_dev);
@@ -1444,6 +1485,8 @@ static int vivid_remove(struct platform_device *pdev)
 		if (!dev)
 			continue;

+		media_device_unregister(&dev->mdev);
+
 		if (dev->has_vid_cap) {
 			v4l2_info(&dev->v4l2_dev, "unregistering %s\n",
 				video_device_node_name(&dev->vid_cap_dev));
diff --git a/drivers/media/platform/vivid/vivid-core.h b/drivers/media/platform/vivid/vivid-core.h
index 477c80a4d44c..376858e91334 100644
--- a/drivers/media/platform/vivid/vivid-core.h
+++ b/drivers/media/platform/vivid/vivid-core.h
@@ -136,6 +136,7 @@ struct vivid_cec_work {
 struct vivid_dev {
 	unsigned			inst;
 	struct v4l2_device		v4l2_dev;
+	struct media_device		mdev;
 	struct v4l2_ctrl_handler	ctrl_hdl_user_gen;
 	struct v4l2_ctrl_handler	ctrl_hdl_user_vid;
 	struct v4l2_ctrl_handler	ctrl_hdl_user_aud;
@@ -144,18 +145,23 @@ struct vivid_dev {
 	struct v4l2_ctrl_handler	ctrl_hdl_loop_cap;
 	struct v4l2_ctrl_handler	ctrl_hdl_fb;
 	struct video_device		vid_cap_dev;
+	struct media_pad 		vid_cap_pad;
 	struct v4l2_ctrl_handler	ctrl_hdl_vid_cap;
 	struct video_device		vid_out_dev;
+	struct media_pad 		vid_out_pad;
 	struct v4l2_ctrl_handler	ctrl_hdl_vid_out;
 	struct video_device		vbi_cap_dev;
+	struct media_pad 		vbi_cap_pad;
 	struct v4l2_ctrl_handler	ctrl_hdl_vbi_cap;
 	struct video_device		vbi_out_dev;
+	struct media_pad 		vbi_out_pad;
 	struct v4l2_ctrl_handler	ctrl_hdl_vbi_out;
 	struct video_device		radio_rx_dev;
 	struct v4l2_ctrl_handler	ctrl_hdl_radio_rx;
 	struct video_device		radio_tx_dev;
 	struct v4l2_ctrl_handler	ctrl_hdl_radio_tx;
 	struct video_device		sdr_cap_dev;
+	struct media_pad 		sdr_cap_pad;
 	struct v4l2_ctrl_handler	ctrl_hdl_sdr_cap;
 	spinlock_t			slock;
 	struct mutex			mutex;
