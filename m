Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47311 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233AbaFWXyG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jun 2014 19:54:06 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH v2 09/23] v4l: vsp1: Fix typos
Date: Tue, 24 Jun 2014 01:54:15 +0200
Message-Id: <1403567669-18539-10-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1403567669-18539-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1403567669-18539-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Several macros were mistakenly prefixed with VPS1 instead of VSP1. Fix
them.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1.h       | 12 ++++++------
 drivers/media/platform/vsp1/vsp1_drv.c   |  6 +++---
 drivers/media/platform/vsp1/vsp1_video.h |  2 +-
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1.h b/drivers/media/platform/vsp1/vsp1.h
index 6ca2cf2..3cfa393 100644
--- a/drivers/media/platform/vsp1/vsp1.h
+++ b/drivers/media/platform/vsp1/vsp1.h
@@ -36,9 +36,9 @@ struct vsp1_rwpf;
 struct vsp1_sru;
 struct vsp1_uds;
 
-#define VPS1_MAX_RPF		5
-#define VPS1_MAX_UDS		3
-#define VPS1_MAX_WPF		4
+#define VSP1_MAX_RPF		5
+#define VSP1_MAX_UDS		3
+#define VSP1_MAX_WPF		4
 
 struct vsp1_device {
 	struct device *dev;
@@ -55,10 +55,10 @@ struct vsp1_device {
 	struct vsp1_hsit *hst;
 	struct vsp1_lif *lif;
 	struct vsp1_lut *lut;
-	struct vsp1_rwpf *rpf[VPS1_MAX_RPF];
+	struct vsp1_rwpf *rpf[VSP1_MAX_RPF];
 	struct vsp1_sru *sru;
-	struct vsp1_uds *uds[VPS1_MAX_UDS];
-	struct vsp1_rwpf *wpf[VPS1_MAX_WPF];
+	struct vsp1_uds *uds[VSP1_MAX_UDS];
+	struct vsp1_rwpf *wpf[VSP1_MAX_WPF];
 
 	struct list_head entities;
 
diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index c69ee06..0c5e74c 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -440,19 +440,19 @@ static int vsp1_validate_platform_data(struct platform_device *pdev,
 		return -EINVAL;
 	}
 
-	if (pdata->rpf_count <= 0 || pdata->rpf_count > VPS1_MAX_RPF) {
+	if (pdata->rpf_count <= 0 || pdata->rpf_count > VSP1_MAX_RPF) {
 		dev_err(&pdev->dev, "invalid number of RPF (%u)\n",
 			pdata->rpf_count);
 		return -EINVAL;
 	}
 
-	if (pdata->uds_count <= 0 || pdata->uds_count > VPS1_MAX_UDS) {
+	if (pdata->uds_count <= 0 || pdata->uds_count > VSP1_MAX_UDS) {
 		dev_err(&pdev->dev, "invalid number of UDS (%u)\n",
 			pdata->uds_count);
 		return -EINVAL;
 	}
 
-	if (pdata->wpf_count <= 0 || pdata->wpf_count > VPS1_MAX_WPF) {
+	if (pdata->wpf_count <= 0 || pdata->wpf_count > VSP1_MAX_WPF) {
 		dev_err(&pdev->dev, "invalid number of WPF (%u)\n",
 			pdata->wpf_count);
 		return -EINVAL;
diff --git a/drivers/media/platform/vsp1/vsp1_video.h b/drivers/media/platform/vsp1/vsp1_video.h
index 7284320..cb5d9ef 100644
--- a/drivers/media/platform/vsp1/vsp1_video.h
+++ b/drivers/media/platform/vsp1/vsp1_video.h
@@ -73,7 +73,7 @@ struct vsp1_pipeline {
 
 	unsigned int num_video;
 	unsigned int num_inputs;
-	struct vsp1_rwpf *inputs[VPS1_MAX_RPF];
+	struct vsp1_rwpf *inputs[VSP1_MAX_RPF];
 	struct vsp1_rwpf *output;
 	struct vsp1_entity *bru;
 	struct vsp1_entity *lif;
-- 
1.8.5.5

