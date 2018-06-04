Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:40022 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752850AbeFDLrH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 4 Jun 2018 07:47:07 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv15 33/35] vivid: add mc
Date: Mon,  4 Jun 2018 13:46:46 +0200
Message-Id: <20180604114648.26159-34-hverkuil@xs4all.nl>
In-Reply-To: <20180604114648.26159-1-hverkuil@xs4all.nl>
References: <20180604114648.26159-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add support for the media_device to vivid. This is a prerequisite
for request support.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-core.c | 61 +++++++++++++++++++++++
 drivers/media/platform/vivid/vivid-core.h |  8 +++
 2 files changed, 69 insertions(+)

diff --git a/drivers/media/platform/vivid/vivid-core.c b/drivers/media/platform/vivid/vivid-core.c
index 82ec216f2ad8..69386b26d5dd 100644
--- a/drivers/media/platform/vivid/vivid-core.c
+++ b/drivers/media/platform/vivid/vivid-core.c
@@ -657,6 +657,15 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 
 	dev->inst = inst;
 
+#ifdef CONFIG_MEDIA_CONTROLLER
+	dev->v4l2_dev.mdev = &dev->mdev;
+
+	/* Initialize media device */
+	strlcpy(dev->mdev.model, VIVID_MODULE_NAME, sizeof(dev->mdev.model));
+	dev->mdev.dev = &pdev->dev;
+	media_device_init(&dev->mdev);
+#endif
+
 	/* register v4l2_device */
 	snprintf(dev->v4l2_dev.name, sizeof(dev->v4l2_dev.name),
 			"%s-%03d", VIVID_MODULE_NAME, inst);
@@ -1173,6 +1182,13 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		vfd->lock = &dev->mutex;
 		video_set_drvdata(vfd, dev);
 
+#ifdef CONFIG_MEDIA_CONTROLLER
+		dev->vid_cap_pad.flags = MEDIA_PAD_FL_SINK;
+		ret = media_entity_pads_init(&vfd->entity, 1, &dev->vid_cap_pad);
+		if (ret)
+			goto unreg_dev;
+#endif
+
 #ifdef CONFIG_VIDEO_VIVID_CEC
 		if (in_type_counter[HDMI]) {
 			struct cec_adapter *adap;
@@ -1225,6 +1241,13 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		vfd->lock = &dev->mutex;
 		video_set_drvdata(vfd, dev);
 
+#ifdef CONFIG_MEDIA_CONTROLLER
+		dev->vid_out_pad.flags = MEDIA_PAD_FL_SOURCE;
+		ret = media_entity_pads_init(&vfd->entity, 1, &dev->vid_out_pad);
+		if (ret)
+			goto unreg_dev;
+#endif
+
 #ifdef CONFIG_VIDEO_VIVID_CEC
 		for (i = 0; i < dev->num_outputs; i++) {
 			struct cec_adapter *adap;
@@ -1274,6 +1297,13 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		vfd->tvnorms = tvnorms_cap;
 		video_set_drvdata(vfd, dev);
 
+#ifdef CONFIG_MEDIA_CONTROLLER
+		dev->vbi_cap_pad.flags = MEDIA_PAD_FL_SINK;
+		ret = media_entity_pads_init(&vfd->entity, 1, &dev->vbi_cap_pad);
+		if (ret)
+			goto unreg_dev;
+#endif
+
 		ret = video_register_device(vfd, VFL_TYPE_VBI, vbi_cap_nr[inst]);
 		if (ret < 0)
 			goto unreg_dev;
@@ -1299,6 +1329,13 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		vfd->tvnorms = tvnorms_out;
 		video_set_drvdata(vfd, dev);
 
+#ifdef CONFIG_MEDIA_CONTROLLER
+		dev->vbi_out_pad.flags = MEDIA_PAD_FL_SOURCE;
+		ret = media_entity_pads_init(&vfd->entity, 1, &dev->vbi_out_pad);
+		if (ret)
+			goto unreg_dev;
+#endif
+
 		ret = video_register_device(vfd, VFL_TYPE_VBI, vbi_out_nr[inst]);
 		if (ret < 0)
 			goto unreg_dev;
@@ -1322,6 +1359,13 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		vfd->lock = &dev->mutex;
 		video_set_drvdata(vfd, dev);
 
+#ifdef CONFIG_MEDIA_CONTROLLER
+		dev->sdr_cap_pad.flags = MEDIA_PAD_FL_SINK;
+		ret = media_entity_pads_init(&vfd->entity, 1, &dev->sdr_cap_pad);
+		if (ret)
+			goto unreg_dev;
+#endif
+
 		ret = video_register_device(vfd, VFL_TYPE_SDR, sdr_cap_nr[inst]);
 		if (ret < 0)
 			goto unreg_dev;
@@ -1368,12 +1412,25 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 					  video_device_node_name(vfd));
 	}
 
+#ifdef CONFIG_MEDIA_CONTROLLER
+	/* Register the media device */
+	ret = media_device_register(&dev->mdev);
+	if (ret) {
+		dev_err(dev->mdev.dev,
+			"media device register failed (err=%d)\n", ret);
+		goto unreg_dev;
+	}
+#endif
+
 	/* Now that everything is fine, let's add it to device list */
 	vivid_devs[inst] = dev;
 
 	return 0;
 
 unreg_dev:
+#ifdef CONFIG_MEDIA_CONTROLLER
+	media_device_unregister(&dev->mdev);
+#endif
 	video_unregister_device(&dev->radio_tx_dev);
 	video_unregister_device(&dev->radio_rx_dev);
 	video_unregister_device(&dev->sdr_cap_dev);
@@ -1444,6 +1501,10 @@ static int vivid_remove(struct platform_device *pdev)
 		if (!dev)
 			continue;
 
+#ifdef CONFIG_MEDIA_CONTROLLER
+		media_device_unregister(&dev->mdev);
+#endif
+
 		if (dev->has_vid_cap) {
 			v4l2_info(&dev->v4l2_dev, "unregistering %s\n",
 				video_device_node_name(&dev->vid_cap_dev));
diff --git a/drivers/media/platform/vivid/vivid-core.h b/drivers/media/platform/vivid/vivid-core.h
index 477c80a4d44c..6ccd1f5c1d91 100644
--- a/drivers/media/platform/vivid/vivid-core.h
+++ b/drivers/media/platform/vivid/vivid-core.h
@@ -136,6 +136,14 @@ struct vivid_cec_work {
 struct vivid_dev {
 	unsigned			inst;
 	struct v4l2_device		v4l2_dev;
+#ifdef CONFIG_MEDIA_CONTROLLER
+	struct media_device		mdev;
+	struct media_pad		vid_cap_pad;
+	struct media_pad		vid_out_pad;
+	struct media_pad		vbi_cap_pad;
+	struct media_pad		vbi_out_pad;
+	struct media_pad		sdr_cap_pad;
+#endif
 	struct v4l2_ctrl_handler	ctrl_hdl_user_gen;
 	struct v4l2_ctrl_handler	ctrl_hdl_user_vid;
 	struct v4l2_ctrl_handler	ctrl_hdl_user_aud;
-- 
2.17.0
