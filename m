Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:45019 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbcHQNmZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Aug 2016 09:42:25 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
	Takanari Hayama <taki@igel.co.jp>,
	Damian Hobson-Garcia <dhobsong@igel.co.jp>
Subject: [PATCH v2] v4l: vsp1: Report device model and rev through media device information
Date: Wed, 17 Aug 2016 16:42:36 +0300
Message-Id: <1471441356-12209-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of hardcoding the media device model and hardware revision to
"VSP1" and 0 respectively, report the actual hardware device model and
IP version number.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1.h     |  2 ++
 drivers/media/platform/vsp1/vsp1_drv.c | 21 +++++++++++++++------
 2 files changed, 17 insertions(+), 6 deletions(-)

Changes since v1:

- Report the hardware revision

diff --git a/drivers/media/platform/vsp1/vsp1.h b/drivers/media/platform/vsp1/vsp1.h
index 9dce3ea85252..0ba7521c01b4 100644
--- a/drivers/media/platform/vsp1/vsp1.h
+++ b/drivers/media/platform/vsp1/vsp1.h
@@ -55,6 +55,7 @@ struct vsp1_uds;
 
 struct vsp1_device_info {
 	u32 version;
+	const char *model;
 	unsigned int gen;
 	unsigned int features;
 	unsigned int rpf_count;
@@ -67,6 +68,7 @@ struct vsp1_device_info {
 struct vsp1_device {
 	struct device *dev;
 	const struct vsp1_device_info *info;
+	u32 version;
 
 	void __iomem *mmio;
 	struct rcar_fcp_device *fcp;
diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index 9684abf3ce3a..64d832ef9ef3 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -232,7 +232,8 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
 	int ret;
 
 	mdev->dev = vsp1->dev;
-	strlcpy(mdev->model, "VSP1", sizeof(mdev->model));
+	mdev->hw_revision = vsp1->version;
+	strlcpy(mdev->model, vsp1->info->model, sizeof(mdev->model));
 	snprintf(mdev->bus_info, sizeof(mdev->bus_info), "platform:%s",
 		 dev_name(mdev->dev));
 	media_device_init(mdev);
@@ -581,6 +582,7 @@ static const struct dev_pm_ops vsp1_pm_ops = {
 static const struct vsp1_device_info vsp1_device_infos[] = {
 	{
 		.version = VI6_IP_VERSION_MODEL_VSPS_H2,
+		.model = "VSP1-S",
 		.gen = 2,
 		.features = VSP1_HAS_BRU | VSP1_HAS_CLU | VSP1_HAS_HGO
 			  | VSP1_HAS_LUT | VSP1_HAS_SRU | VSP1_HAS_WPF_VFLIP,
@@ -591,6 +593,7 @@ static const struct vsp1_device_info vsp1_device_infos[] = {
 		.uapi = true,
 	}, {
 		.version = VI6_IP_VERSION_MODEL_VSPR_H2,
+		.model = "VSP1-R",
 		.gen = 2,
 		.features = VSP1_HAS_BRU | VSP1_HAS_SRU | VSP1_HAS_WPF_VFLIP,
 		.rpf_count = 5,
@@ -600,6 +603,7 @@ static const struct vsp1_device_info vsp1_device_infos[] = {
 		.uapi = true,
 	}, {
 		.version = VI6_IP_VERSION_MODEL_VSPD_GEN2,
+		.model = "VSP1-D",
 		.gen = 2,
 		.features = VSP1_HAS_BRU | VSP1_HAS_HGO | VSP1_HAS_LIF
 			  | VSP1_HAS_LUT,
@@ -610,6 +614,7 @@ static const struct vsp1_device_info vsp1_device_infos[] = {
 		.uapi = true,
 	}, {
 		.version = VI6_IP_VERSION_MODEL_VSPS_M2,
+		.model = "VSP1-S",
 		.gen = 2,
 		.features = VSP1_HAS_BRU | VSP1_HAS_CLU | VSP1_HAS_HGO
 			  | VSP1_HAS_LUT | VSP1_HAS_SRU | VSP1_HAS_WPF_VFLIP,
@@ -620,6 +625,7 @@ static const struct vsp1_device_info vsp1_device_infos[] = {
 		.uapi = true,
 	}, {
 		.version = VI6_IP_VERSION_MODEL_VSPI_GEN3,
+		.model = "VSP2-I",
 		.gen = 3,
 		.features = VSP1_HAS_CLU | VSP1_HAS_HGO | VSP1_HAS_LUT
 			  | VSP1_HAS_SRU | VSP1_HAS_WPF_HFLIP
@@ -630,6 +636,7 @@ static const struct vsp1_device_info vsp1_device_infos[] = {
 		.uapi = true,
 	}, {
 		.version = VI6_IP_VERSION_MODEL_VSPBD_GEN3,
+		.model = "VSP2-BD",
 		.gen = 3,
 		.features = VSP1_HAS_BRU | VSP1_HAS_WPF_VFLIP,
 		.rpf_count = 5,
@@ -638,6 +645,7 @@ static const struct vsp1_device_info vsp1_device_infos[] = {
 		.uapi = true,
 	}, {
 		.version = VI6_IP_VERSION_MODEL_VSPBC_GEN3,
+		.model = "VSP2-BC",
 		.gen = 3,
 		.features = VSP1_HAS_BRU | VSP1_HAS_CLU | VSP1_HAS_HGO
 			  | VSP1_HAS_LUT | VSP1_HAS_WPF_VFLIP,
@@ -647,6 +655,7 @@ static const struct vsp1_device_info vsp1_device_infos[] = {
 		.uapi = true,
 	}, {
 		.version = VI6_IP_VERSION_MODEL_VSPD_GEN3,
+		.model = "VSP2-D",
 		.gen = 3,
 		.features = VSP1_HAS_BRU | VSP1_HAS_LIF | VSP1_HAS_WPF_VFLIP,
 		.rpf_count = 5,
@@ -662,7 +671,6 @@ static int vsp1_probe(struct platform_device *pdev)
 	struct resource *irq;
 	struct resource *io;
 	unsigned int i;
-	u32 version;
 	int ret;
 
 	vsp1 = devm_kzalloc(&pdev->dev, sizeof(*vsp1), GFP_KERNEL);
@@ -713,11 +721,11 @@ static int vsp1_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto done;
 
-	version = vsp1_read(vsp1, VI6_IP_VERSION);
+	vsp1->version = vsp1_read(vsp1, VI6_IP_VERSION);
 	pm_runtime_put_sync(&pdev->dev);
 
 	for (i = 0; i < ARRAY_SIZE(vsp1_device_infos); ++i) {
-		if ((version & VI6_IP_VERSION_MODEL_MASK) ==
+		if ((vsp1->version & VI6_IP_VERSION_MODEL_MASK) ==
 		    vsp1_device_infos[i].version) {
 			vsp1->info = &vsp1_device_infos[i];
 			break;
@@ -725,12 +733,13 @@ static int vsp1_probe(struct platform_device *pdev)
 	}
 
 	if (!vsp1->info) {
-		dev_err(&pdev->dev, "unsupported IP version 0x%08x\n", version);
+		dev_err(&pdev->dev, "unsupported IP version 0x%08x\n",
+			vsp1->version);
 		ret = -ENXIO;
 		goto done;
 	}
 
-	dev_dbg(&pdev->dev, "IP version 0x%08x\n", version);
+	dev_dbg(&pdev->dev, "IP version 0x%08x\n", vsp1->version);
 
 	/* Instanciate entities */
 	ret = vsp1_create_entities(vsp1);
-- 
Regards,

Laurent Pinchart

