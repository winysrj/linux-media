Return-Path: <SRS0=c0D3=QM=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BF21C282CC
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 20:25:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F02A02175B
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 20:25:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729131AbfBEUZL (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Feb 2019 15:25:11 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:41798 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729121AbfBEUZL (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Feb 2019 15:25:11 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: ezequiel)
        with ESMTPSA id D0DF82802E2
From:   Ezequiel Garcia <ezequiel@collabora.com>
To:     linux-media@vger.kernel.org
Cc:     Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        linux-rockchip@lists.infradead.org,
        Heiko Stuebner <heiko@sntech.de>,
        Jonas Karlman <jonas@kwiboo.se>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH 06/10] rockchip/vpu: Open-code media controller register
Date:   Tue,  5 Feb 2019 17:24:13 -0300
Message-Id: <20190205202417.16555-7-ezequiel@collabora.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190205202417.16555-1-ezequiel@collabora.com>
References: <20190205202417.16555-1-ezequiel@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

In preparation to support decoders, using a single memory-to-memory
device, we need to roll our own media controller entities registration.

Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 .../staging/media/rockchip/vpu/rockchip_vpu.h |  35 ++++
 .../media/rockchip/vpu/rockchip_vpu_drv.c     | 177 ++++++++++++++++--
 2 files changed, 200 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/media/rockchip/vpu/rockchip_vpu.h b/drivers/staging/media/rockchip/vpu/rockchip_vpu.h
index 76ee24abc141..084f58cadda1 100644
--- a/drivers/staging/media/rockchip/vpu/rockchip_vpu.h
+++ b/drivers/staging/media/rockchip/vpu/rockchip_vpu.h
@@ -71,6 +71,38 @@ enum rockchip_vpu_codec_mode {
 	RK_VPU_MODE_JPEG_ENC,
 };
 
+/*
+ * struct rockchip_vpu_mc - media controller data
+ *
+ * @source:		&struct media_entity pointer with the source entity
+ *			Used only when the M2M device is registered via
+ *			v4l2_m2m_unregister_media_controller().
+ * @source_pad:		&struct media_pad with the source pad.
+ *			Used only when the M2M device is registered via
+ *			v4l2_m2m_unregister_media_controller().
+ * @sink:		&struct media_entity pointer with the sink entity
+ *			Used only when the M2M device is registered via
+ *			v4l2_m2m_unregister_media_controller().
+ * @sink_pad:		&struct media_pad with the sink pad.
+ *			Used only when the M2M device is registered via
+ *			v4l2_m2m_unregister_media_controller().
+ * @proc:		&struct media_entity pointer with the M2M device itself.
+ * @proc_pads:		&struct media_pad with the @proc pads.
+ *			Used only when the M2M device is registered via
+ *			v4l2_m2m_unregister_media_controller().
+ * @intf_devnode:	&struct media_intf devnode pointer with the interface
+ *			with controls the M2M device.
+ */
+struct rockchip_vpu_mc {
+	struct media_entity	*source;
+	struct media_pad	source_pad;
+	struct media_entity	sink;
+	struct media_pad	sink_pad;
+	struct media_entity	proc;
+	struct media_pad	proc_pads[2];
+	struct media_intf_devnode *intf_devnode;
+};
+
 /**
  * struct rockchip_vpu_dev - driver data
  * @v4l2_dev:		V4L2 device to register video devices for.
@@ -78,6 +110,8 @@ enum rockchip_vpu_codec_mode {
  * @mdev:		media device associated to this device.
  * @vfd_enc:		Video device for encoder.
  * @pdev:		Pointer to VPU platform device.
+ * @mc:			Array of media controller topology structs
+ *			for encoder and decoder.
  * @dev:		Pointer to device for convenient logging using
  *			dev_ macros.
  * @clocks:		Array of clock handles.
@@ -95,6 +129,7 @@ struct rockchip_vpu_dev {
 	struct media_device mdev;
 	struct video_device *vfd_enc;
 	struct platform_device *pdev;
+	struct rockchip_vpu_mc mc[2];
 	struct device *dev;
 	struct clk_bulk_data clocks[ROCKCHIP_VPU_MAX_CLOCKS];
 	void __iomem *base;
diff --git a/drivers/staging/media/rockchip/vpu/rockchip_vpu_drv.c b/drivers/staging/media/rockchip/vpu/rockchip_vpu_drv.c
index 962748ae3822..28e9e97ff257 100644
--- a/drivers/staging/media/rockchip/vpu/rockchip_vpu_drv.c
+++ b/drivers/staging/media/rockchip/vpu/rockchip_vpu_drv.c
@@ -332,7 +332,7 @@ static int rockchip_vpu_video_device_register(struct rockchip_vpu_dev *vpu)
 {
 	const struct of_device_id *match;
 	struct video_device *vfd;
-	int function, ret;
+	int ret;
 
 	match = of_match_node(of_rockchip_vpu_match, vpu->dev->of_node);
 	vfd = video_device_alloc();
@@ -359,21 +359,165 @@ static int rockchip_vpu_video_device_register(struct rockchip_vpu_dev *vpu)
 	}
 	v4l2_info(&vpu->v4l2_dev, "registered as /dev/video%d\n", vfd->num);
 
-	function = MEDIA_ENT_F_PROC_VIDEO_ENCODER;
-	ret = v4l2_m2m_register_media_controller(vpu->m2m_dev, vfd, function);
-	if (ret) {
-		v4l2_err(&vpu->v4l2_dev, "Failed to init mem2mem media controller\n");
-		goto err_unreg_video;
-	}
 	return 0;
-
-err_unreg_video:
-	video_unregister_device(vfd);
 err_free_dev:
 	video_device_release(vfd);
 	return ret;
 }
 
+static int rockchip_vpu_register_entity(struct media_device *mdev,
+	struct media_entity *entity, const char *entity_name,
+	struct media_pad *pads, int num_pads, int function,
+	struct video_device *vdev)
+{
+	unsigned int len;
+	char *name;
+	int ret;
+
+	entity->obj_type = MEDIA_ENTITY_TYPE_BASE;
+	if (function == MEDIA_ENT_F_IO_V4L) {
+		entity->info.dev.major = VIDEO_MAJOR;
+		entity->info.dev.minor = vdev->minor;
+	}
+	len = strlen(vdev->name) + 2 + strlen(entity_name);
+	name = kmalloc(len, GFP_KERNEL);
+	if (!name)
+		return -ENOMEM;
+	snprintf(name, len, "%s-%s", vdev->name, entity_name);
+	entity->name = name;
+	entity->function = function;
+
+	ret = media_entity_pads_init(entity, num_pads, pads);
+	if (ret)
+		return ret;
+	ret = media_device_register_entity(mdev, entity);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static int rockchip_register_mc(struct media_device *mdev,
+				struct rockchip_vpu_mc *mc,
+				struct video_device *vdev,
+				int function)
+{
+	struct media_link *link;
+	int ret;
+
+	/* Create the three encoder entities with their pads */
+	mc->source = &vdev->entity;
+	ret = rockchip_vpu_register_entity(mdev, mc->source,
+			"source", &mc->source_pad, 1, MEDIA_ENT_F_IO_V4L, vdev);
+	if (ret)
+		return ret;
+
+	ret = rockchip_vpu_register_entity(mdev, &mc->proc,
+			"proc", mc->proc_pads, 2, function, vdev);
+	if (ret)
+		goto err_rel_entity0;
+
+	ret = rockchip_vpu_register_entity(mdev, &mc->sink,
+			"sink", &mc->sink_pad, 1, MEDIA_ENT_F_IO_V4L, vdev);
+	if (ret)
+		goto err_rel_entity1;
+
+	/* Connect the three entities */
+	ret = media_create_pad_link(mc->source, 0, &mc->proc, 1,
+			MEDIA_LNK_FL_IMMUTABLE | MEDIA_LNK_FL_ENABLED);
+	if (ret)
+		goto err_rel_entity2;
+
+	ret = media_create_pad_link(&mc->proc, 0, &mc->sink, 0,
+			MEDIA_LNK_FL_IMMUTABLE | MEDIA_LNK_FL_ENABLED);
+	if (ret)
+		goto err_rm_links0;
+
+	/* Create video interface */
+	mc->intf_devnode = media_devnode_create(mdev,
+			MEDIA_INTF_T_V4L_VIDEO, 0,
+			VIDEO_MAJOR, vdev->minor);
+	if (!mc->intf_devnode) {
+		ret = -ENOMEM;
+		goto err_rm_links1;
+	}
+
+	/* Connect the two DMA engines to the interface */
+	link = media_create_intf_link(mc->source,
+			&mc->intf_devnode->intf,
+			MEDIA_LNK_FL_IMMUTABLE | MEDIA_LNK_FL_ENABLED);
+	if (!link) {
+		ret = -ENOMEM;
+		goto err_rm_devnode;
+	}
+
+	link = media_create_intf_link(&mc->sink,
+			&mc->intf_devnode->intf,
+			MEDIA_LNK_FL_IMMUTABLE | MEDIA_LNK_FL_ENABLED);
+	if (!link) {
+		ret = -ENOMEM;
+		goto err_rm_intf_link;
+	}
+	return 0;
+
+err_rm_intf_link:
+	media_remove_intf_links(&mc->intf_devnode->intf);
+err_rm_devnode:
+	media_devnode_remove(mc->intf_devnode);
+err_rm_links1:
+	media_entity_remove_links(&mc->sink);
+err_rm_links0:
+	media_entity_remove_links(&mc->proc);
+	media_entity_remove_links(mc->source);
+err_rel_entity2:
+	media_device_unregister_entity(&mc->proc);
+	kfree(mc->proc.name);
+err_rel_entity1:
+	media_device_unregister_entity(&mc->sink);
+	kfree(mc->sink.name);
+err_rel_entity0:
+	media_device_unregister_entity(mc->source);
+	kfree(mc->source->name);
+	return ret;
+}
+
+static void rockchip_unregister_mc(struct rockchip_vpu_mc *mc)
+{
+	media_remove_intf_links(&mc->intf_devnode->intf);
+	media_devnode_remove(mc->intf_devnode);
+	media_entity_remove_links(mc->source);
+	media_entity_remove_links(&mc->sink);
+	media_entity_remove_links(&mc->proc);
+	media_device_unregister_entity(mc->source);
+	media_device_unregister_entity(&mc->sink);
+	media_device_unregister_entity(&mc->proc);
+	kfree(mc->source->name);
+	kfree(mc->sink.name);
+	kfree(mc->proc.name);
+}
+
+static int rockchip_register_media_controller(struct rockchip_vpu_dev *vpu)
+{
+	int ret;
+
+	/* We have one memory-to-memory device, to hold a single queue
+	 * of memory-to-memory serialized jobs.
+	 * There is a set of pads and processing entities for the encoder,
+	 * and another set for the decoder.
+	 * Also, there are two V4L interface, one for each set of entities.
+	 */
+
+	if (vpu->vfd_enc) {
+		ret = rockchip_register_mc(&vpu->mdev, &vpu->mc[0],
+					   vpu->vfd_enc,
+					   MEDIA_ENT_F_PROC_VIDEO_ENCODER);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
 static int rockchip_vpu_probe(struct platform_device *pdev)
 {
 	const struct of_device_id *match;
@@ -472,12 +616,21 @@ static int rockchip_vpu_probe(struct platform_device *pdev)
 		goto err_m2m_rel;
 	}
 
+	ret = rockchip_register_media_controller(vpu);
+	if (ret) {
+		v4l2_err(&vpu->v4l2_dev, "Failed to register media controller\n");
+		goto err_video_dev_unreg;
+	}
+
 	ret = media_device_register(&vpu->mdev);
 	if (ret) {
 		v4l2_err(&vpu->v4l2_dev, "Failed to register mem2mem media device\n");
-		goto err_video_dev_unreg;
+		goto err_mc_unreg;
 	}
 	return 0;
+err_mc_unreg:
+	if (vpu->vfd_enc)
+		rockchip_unregister_mc(&vpu->mc[0]);
 err_video_dev_unreg:
 	if (vpu->vfd_enc) {
 		video_unregister_device(vpu->vfd_enc);
@@ -500,10 +653,10 @@ static int rockchip_vpu_remove(struct platform_device *pdev)
 	v4l2_info(&vpu->v4l2_dev, "Removing %s\n", pdev->name);
 
 	media_device_unregister(&vpu->mdev);
-	v4l2_m2m_unregister_media_controller(vpu->m2m_dev);
 	v4l2_m2m_release(vpu->m2m_dev);
 	media_device_cleanup(&vpu->mdev);
 	if (vpu->vfd_enc) {
+		rockchip_unregister_mc(&vpu->mc[0]);
 		video_unregister_device(vpu->vfd_enc);
 		video_device_release(vpu->vfd_enc);
 	}
-- 
2.20.1

