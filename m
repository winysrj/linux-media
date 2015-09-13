Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52349 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755359AbbIMU5Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Sep 2015 16:57:16 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH 07/32] v4l: vsp1: Support VSP1 instances without any UDS
Date: Sun, 13 Sep 2015 23:56:45 +0300
Message-Id: <1442177830-24536-8-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1442177830-24536-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1442177830-24536-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Not all VSP1 instances include a UDS. Make the renesas,#uds DT property
optional and accept a number of UDS equal to 0 as valid.

Cc: devicetree@vger.kernel.org
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 Documentation/devicetree/bindings/media/renesas,vsp1.txt | 3 ++-
 drivers/media/platform/vsp1/vsp1_drv.c                   | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/renesas,vsp1.txt b/Documentation/devicetree/bindings/media/renesas,vsp1.txt
index 87fe08abf36d..674c8c30d046 100644
--- a/Documentation/devicetree/bindings/media/renesas,vsp1.txt
+++ b/Documentation/devicetree/bindings/media/renesas,vsp1.txt
@@ -13,12 +13,13 @@ Required properties:
   - clocks: A phandle + clock-specifier pair for the VSP1 functional clock.
 
   - renesas,#rpf: Number of Read Pixel Formatter (RPF) modules in the VSP1.
-  - renesas,#uds: Number of Up Down Scaler (UDS) modules in the VSP1.
   - renesas,#wpf: Number of Write Pixel Formatter (WPF) modules in the VSP1.
 
 
 Optional properties:
 
+  - renesas,#uds: Number of Up Down Scaler (UDS) modules in the VSP1. Defaults
+    to 0 if not present.
   - renesas,has-lif: Boolean, indicates that the LCD Interface (LIF) module is
     available.
   - renesas,has-lut: Boolean, indicates that the Look Up Table (LUT) module is
diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index de0b80e8d048..5f93cbdcb0f1 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -513,7 +513,7 @@ static int vsp1_parse_dt(struct vsp1_device *vsp1)
 		return -EINVAL;
 	}
 
-	if (pdata->uds_count <= 0 || pdata->uds_count > VSP1_MAX_UDS) {
+	if (pdata->uds_count > VSP1_MAX_UDS) {
 		dev_err(vsp1->dev, "invalid number of UDS (%u)\n",
 			pdata->uds_count);
 		return -EINVAL;
-- 
2.4.6

