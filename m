Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44110 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbcGQK72 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2016 06:59:28 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
	Takanari Hayama <taki@igel.co.jp>,
	Damian Hobson-Garcia <dhobsong@igel.co.jp>
Subject: [PATCH] v4l: vsp1: Report device model through media device information
Date: Sun, 17 Jul 2016 13:59:24 +0300
Message-Id: <1468753164-20208-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of hardcoding the media device model to "VSP1", report the
actual hardware device model.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1.h     |  1 +
 drivers/media/platform/vsp1/vsp1_drv.c | 10 +++++++++-
 2 files changed, 10 insertions(+), 1 deletion(-)

This patch is currently untested as my Salvator-X board fails to boot for a
still unknown reason.

Hayama-san, Damian, could you please check if this patch properly addresses
the VSP identification issue you mentioned during our face to face meeting
last week ?

diff --git a/drivers/media/platform/vsp1/vsp1.h b/drivers/media/platform/vsp1/vsp1.h
index 06a2ec7e5ad4..19c91f63c627 100644
--- a/drivers/media/platform/vsp1/vsp1.h
+++ b/drivers/media/platform/vsp1/vsp1.h
@@ -53,6 +53,7 @@ struct vsp1_uds;
 
 struct vsp1_device_info {
 	u32 version;
+	const char *model;
 	unsigned int gen;
 	unsigned int features;
 	unsigned int rpf_count;
diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index e1377ffe3d68..b5fc04f25886 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -220,7 +220,7 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
 	int ret;
 
 	mdev->dev = vsp1->dev;
-	strlcpy(mdev->model, "VSP1", sizeof(mdev->model));
+	strlcpy(mdev->model, vsp1->info->model, sizeof(mdev->model));
 	snprintf(mdev->bus_info, sizeof(mdev->bus_info), "platform:%s",
 		 dev_name(mdev->dev));
 	media_device_init(mdev);
@@ -561,6 +561,7 @@ static const struct dev_pm_ops vsp1_pm_ops = {
 static const struct vsp1_device_info vsp1_device_infos[] = {
 	{
 		.version = VI6_IP_VERSION_MODEL_VSPS_H2,
+		.model = "VSP1-S",
 		.gen = 2,
 		.features = VSP1_HAS_BRU | VSP1_HAS_CLU | VSP1_HAS_LUT
 			  | VSP1_HAS_SRU | VSP1_HAS_WPF_VFLIP,
@@ -571,6 +572,7 @@ static const struct vsp1_device_info vsp1_device_infos[] = {
 		.uapi = true,
 	}, {
 		.version = VI6_IP_VERSION_MODEL_VSPR_H2,
+		.model = "VSP1-R",
 		.gen = 2,
 		.features = VSP1_HAS_BRU | VSP1_HAS_SRU | VSP1_HAS_WPF_VFLIP,
 		.rpf_count = 5,
@@ -580,6 +582,7 @@ static const struct vsp1_device_info vsp1_device_infos[] = {
 		.uapi = true,
 	}, {
 		.version = VI6_IP_VERSION_MODEL_VSPD_GEN2,
+		.model = "VSP1-D",
 		.gen = 2,
 		.features = VSP1_HAS_BRU | VSP1_HAS_LIF | VSP1_HAS_LUT,
 		.rpf_count = 4,
@@ -589,6 +592,7 @@ static const struct vsp1_device_info vsp1_device_infos[] = {
 		.uapi = true,
 	}, {
 		.version = VI6_IP_VERSION_MODEL_VSPS_M2,
+		.model = "VSP1-S",
 		.gen = 2,
 		.features = VSP1_HAS_BRU | VSP1_HAS_CLU | VSP1_HAS_LUT
 			  | VSP1_HAS_SRU | VSP1_HAS_WPF_VFLIP,
@@ -599,6 +603,7 @@ static const struct vsp1_device_info vsp1_device_infos[] = {
 		.uapi = true,
 	}, {
 		.version = VI6_IP_VERSION_MODEL_VSPI_GEN3,
+		.model = "VSP2-I",
 		.gen = 3,
 		.features = VSP1_HAS_CLU | VSP1_HAS_LUT | VSP1_HAS_SRU
 			  | VSP1_HAS_WPF_HFLIP | VSP1_HAS_WPF_VFLIP,
@@ -608,6 +613,7 @@ static const struct vsp1_device_info vsp1_device_infos[] = {
 		.uapi = true,
 	}, {
 		.version = VI6_IP_VERSION_MODEL_VSPBD_GEN3,
+		.model = "VSP2-BD",
 		.gen = 3,
 		.features = VSP1_HAS_BRU | VSP1_HAS_WPF_VFLIP,
 		.rpf_count = 5,
@@ -616,6 +622,7 @@ static const struct vsp1_device_info vsp1_device_infos[] = {
 		.uapi = true,
 	}, {
 		.version = VI6_IP_VERSION_MODEL_VSPBC_GEN3,
+		.model = "VSP2-BC",
 		.gen = 3,
 		.features = VSP1_HAS_BRU | VSP1_HAS_CLU | VSP1_HAS_LUT
 			  | VSP1_HAS_WPF_VFLIP,
@@ -625,6 +632,7 @@ static const struct vsp1_device_info vsp1_device_infos[] = {
 		.uapi = true,
 	}, {
 		.version = VI6_IP_VERSION_MODEL_VSPD_GEN3,
+		.model = "VSP2-D",
 		.gen = 3,
 		.features = VSP1_HAS_BRU | VSP1_HAS_LIF | VSP1_HAS_WPF_VFLIP,
 		.rpf_count = 5,
-- 
Regards,

Laurent Pinchart

