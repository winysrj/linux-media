Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:62338 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441Ab3DLPkt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Apr 2013 11:40:49 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-sh@vger.kernel.org,
	Magnus Damm <magnus.damm@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Prabhakar Lad <prabhakar.lad@ti.com>
Subject: [PATCH v9 15/20] sh-mobile-ceu-driver: support max width and height in DT
Date: Fri, 12 Apr 2013 17:40:35 +0200
Message-Id: <1365781240-16149-16-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1365781240-16149-1-git-send-email-g.liakhovetski@gmx.de>
References: <1365781240-16149-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some CEU implementations have non-standard (larger) maximum supported
width and height values. Add two OF properties to specify them.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 .../devicetree/bindings/media/sh_mobile_ceu.txt    |   18 +++++++++++++++
 .../platform/soc_camera/sh_mobile_ceu_camera.c     |   23 ++++++++++++++++++-
 2 files changed, 39 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/sh_mobile_ceu.txt

diff --git a/Documentation/devicetree/bindings/media/sh_mobile_ceu.txt b/Documentation/devicetree/bindings/media/sh_mobile_ceu.txt
new file mode 100644
index 0000000..1ce4e46
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/sh_mobile_ceu.txt
@@ -0,0 +1,18 @@
+Bindings, specific for the sh_mobile_ceu_camera.c driver:
+ - compatible: Should be "renesas,sh-mobile-ceu"
+ - reg: register base and size
+ - interrupts: the interrupt number
+ - interrupt-parent: the interrupt controller
+ - renesas,max-width: maximum image width, supported on this SoC
+ - renesas,max-height: maximum image height, supported on this SoC
+
+Example:
+
+ceu0: ceu@0xfe910000 {
+	compatible = "renesas,sh-mobile-ceu";
+	reg = <0xfe910000 0xa0>;
+	interrupt-parent = <&intcs>;
+	interrupts = <0x880>;
+	renesas,max-width = <8188>;
+	renesas,max-height = <8188>;
+};
diff --git a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
index fcc13d8..b0f0995 100644
--- a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
+++ b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
@@ -2116,11 +2116,30 @@ static int sh_mobile_ceu_probe(struct platform_device *pdev)
 
 	/* TODO: implement per-device bus flags */
 	if (pcdev->pdata) {
-		pcdev->max_width = pcdev->pdata->max_width ? : 2560;
-		pcdev->max_height = pcdev->pdata->max_height ? : 1920;
+		pcdev->max_width = pcdev->pdata->max_width;
+		pcdev->max_height = pcdev->pdata->max_height;
 		pcdev->flags = pcdev->pdata->flags;
 	}
 
+	if (!pcdev->max_width) {
+		unsigned int v;
+		err = of_property_read_u32(pdev->dev.of_node, "renesas,max-width", &v);
+		if (!err)
+			pcdev->max_width = v;
+
+		if (!pcdev->max_width)
+			pcdev->max_width = 2560;
+	}
+	if (!pcdev->max_height) {
+		unsigned int v;
+		err = of_property_read_u32(pdev->dev.of_node, "renesas,max-height", &v);
+		if (!err)
+			pcdev->max_height = v;
+
+		if (!pcdev->max_height)
+			pcdev->max_height = 1920;
+	}
+
 	base = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(base))
 		return PTR_ERR(base);
-- 
1.7.2.5

