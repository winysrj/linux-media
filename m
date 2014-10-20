Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:40018 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993AbaJTCwT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Oct 2014 22:52:19 -0400
From: Yoshihiro Kaneko <ykaneko0929@gmail.com>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Simon Horman <horms@verge.net.au>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Subject: [PATCH] media: soc_camera: rcar_vin: Add DT support for r8a7793 and r8a7794 SoCs
Date: Mon, 20 Oct 2014 11:51:29 +0900
Message-Id: <1413773489-18170-1-git-send-email-ykaneko0929@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Based on platform device work by Matsuoka-san.

Signed-off-by: Yoshihiro Kaneko <ykaneko0929@gmail.com>
---

Compile tested only.

This patch is against master branch of linuxtv.org/media_tree.git.

 Documentation/devicetree/bindings/media/rcar_vin.txt | 2 ++
 drivers/media/platform/soc_camera/rcar_vin.c         | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/media/rcar_vin.txt b/Documentation/devicetree/bindings/media/rcar_vin.txt
index ba61782..9dafe6b 100644
--- a/Documentation/devicetree/bindings/media/rcar_vin.txt
+++ b/Documentation/devicetree/bindings/media/rcar_vin.txt
@@ -6,6 +6,8 @@ family of devices. The current blocks are always slaves and suppot one input
 channel which can be either RGB, YUYV or BT656.
 
  - compatible: Must be one of the following
+   - "renesas,vin-r8a7794" for the R8A7794 device
+   - "renesas,vin-r8a7793" for the R8A7793 device
    - "renesas,vin-r8a7791" for the R8A7791 device
    - "renesas,vin-r8a7790" for the R8A7790 device
    - "renesas,vin-r8a7779" for the R8A7779 device
diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
index 234cf86..c023aab 100644
--- a/drivers/media/platform/soc_camera/rcar_vin.c
+++ b/drivers/media/platform/soc_camera/rcar_vin.c
@@ -1871,6 +1871,8 @@ static struct soc_camera_host_ops rcar_vin_host_ops = {
 
 #ifdef CONFIG_OF
 static struct of_device_id rcar_vin_of_table[] = {
+	{ .compatible = "renesas,vin-r8a7794", .data = (void *)RCAR_GEN2 },
+	{ .compatible = "renesas,vin-r8a7793", .data = (void *)RCAR_GEN2 },
 	{ .compatible = "renesas,vin-r8a7791", .data = (void *)RCAR_GEN2 },
 	{ .compatible = "renesas,vin-r8a7790", .data = (void *)RCAR_GEN2 },
 	{ .compatible = "renesas,vin-r8a7779", .data = (void *)RCAR_H1 },
-- 
1.9.1

