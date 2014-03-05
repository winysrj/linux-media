Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:40039 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756135AbaCET27 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Mar 2014 14:28:59 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH 4/6] v4l: vsp1: Add DT support
Date: Wed, 05 Mar 2014 20:30:27 +0100
Message-ID: <4542787.8JEGs6DclK@avalon>
In-Reply-To: <1394047444-30077-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1394047444-30077-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 .../devicetree/bindings/media/renesas,vsp1.txt     | 51 +++++++++++++++++++++
 drivers/media/platform/vsp1/vsp1_drv.c             | 52 ++++++++++++++++++----
 2 files changed, 95 insertions(+), 8 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/renesas,vsp1.txt

(With the DT mailing list CC'ed this time, sorry about that)

diff --git a/Documentation/devicetree/bindings/media/renesas,vsp1.txt b/Documentation/devicetree/bindings/media/renesas,vsp1.txt
new file mode 100644
index 0000000..3b828d4
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/renesas,vsp1.txt
@@ -0,0 +1,51 @@
+* Renesas VSP1 Video Processing Engine
+
+The VSP1 is a video processing engine that supports up-/down-scaling, alpha
+blending, color space conversion and various other image processing features.
+It can be found in the Renesas R-Car second generation SoCs.
+
+Required properties:
+
+  - compatible: Must contain "renesas,vsp1"
+
+  - reg: Base address and length of the registers block for the VSP1.
+  - interrupt-parent, interrupts: Specifier for the VSP1 interrupt.
+
+  - clocks: A list of phandle + clock-specifier pairs for the main VSP1 clock
+    and the optional auxiliary RT clock if needed. VSP1 instances that need an
+    auxiliary RT clock must specify the clock-names property.
+
+  - renesas,#rpf: Number of Read Pixel Formatter (RPF) modules in the VSP1.
+  - renesas,#uds: Number of Up Down Scaler (UDS) modules in the VSP1.
+  - renesas,#wpf: Number of Write Pixel Formatter (WPF) modules in the VSP1.
+
+
+Optional properties:
+
+  - clock-names: When the VSP1 requires an auxiliary RT clock this property
+    must be present and must contain "", "rt".
+
+  - renesas,has-lif: Boolean, indicates that the LCD Interface (LIF) module is
+    available.
+  - renesas,has-lut: Boolean, indicates that the Look Up Table (LUT) module is
+    available.
+  - renesas,has-sru: Boolean, indicates that the Super Resolution Unit (SRU)
+    module is available.
+
+
+Example: R8A7790 (R-Car H2) VSP1-S node
+
+	vsp1@fe928000 {
+		compatible = "renesas,vsp1";
+		reg = <0 0xfe928000 0 0x8000>;
+		interrupts = <0 267 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&mstp1_clks R8A7790_CLK_VSP1_SY>,
+			 <&mstp1_clks R8A7790_CLK_VSP1_RT>;
+		clock-names = "", "rt";
+
+		renesas,has-lut;
+		renesas,has-sru;
+		renesas,#rpf = <5>;
+		renesas,#uds = <3>;
+		renesas,#wpf = <4>;
+	};
diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index 5f774cc..b75ca84 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -16,6 +16,7 @@
 #include <linux/device.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
+#include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/videodev2.h>
 
@@ -458,34 +459,59 @@ static const struct dev_pm_ops vsp1_pm_ops = {
  * Platform Driver
  */
 
-static struct vsp1_platform_data *
-vsp1_get_platform_data(struct platform_device *pdev)
+static int vsp1_validate_platform_data(struct platform_device *pdev,
+				       struct vsp1_platform_data *pdata)
 {
-	struct vsp1_platform_data *pdata = pdev->dev.platform_data;
-
 	if (pdata == NULL) {
 		dev_err(&pdev->dev, "missing platform data\n");
-		return NULL;
+		return -EINVAL;
 	}
 
 	if (pdata->rpf_count <= 0 || pdata->rpf_count > VPS1_MAX_RPF) {
 		dev_err(&pdev->dev, "invalid number of RPF (%u)\n",
 			pdata->rpf_count);
-		return NULL;
+		return -EINVAL;
 	}
 
 	if (pdata->uds_count <= 0 || pdata->uds_count > VPS1_MAX_UDS) {
 		dev_err(&pdev->dev, "invalid number of UDS (%u)\n",
 			pdata->uds_count);
-		return NULL;
+		return -EINVAL;
 	}
 
 	if (pdata->wpf_count <= 0 || pdata->wpf_count > VPS1_MAX_WPF) {
 		dev_err(&pdev->dev, "invalid number of WPF (%u)\n",
 			pdata->wpf_count);
-		return NULL;
+		return -EINVAL;
 	}
 
+	return 0;
+}
+
+static struct vsp1_platform_data *
+vsp1_get_platform_data(struct platform_device *pdev)
+{
+	struct device_node *np = pdev->dev.of_node;
+	struct vsp1_platform_data *pdata;
+
+	if (!IS_ENABLED(CONFIG_OF) || np == NULL)
+		return pdev->dev.platform_data;
+
+	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
+	if (pdata == NULL)
+		return NULL;
+
+	if (of_property_read_bool(np, "renesas,has-lif"))
+		pdata->features |= VSP1_HAS_LIF;
+	if (of_property_read_bool(np, "renesas,has-lut"))
+		pdata->features |= VSP1_HAS_LUT;
+	if (of_property_read_bool(np, "renesas,has-sru"))
+		pdata->features |= VSP1_HAS_SRU;
+
+	of_property_read_u32(np, "renesas,#rpf", &pdata->rpf_count);
+	of_property_read_u32(np, "renesas,#uds", &pdata->uds_count);
+	of_property_read_u32(np, "renesas,#wpf", &pdata->wpf_count);
+
 	return pdata;
 }
 
@@ -508,6 +534,10 @@ static int vsp1_probe(struct platform_device *pdev)
 	if (vsp1->pdata == NULL)
 		return -ENODEV;
 
+	ret = vsp1_validate_platform_data(pdev, vsp1->pdata);
+	if (ret < 0)
+		return ret;
+
 	/* I/O, IRQ and clock resources */
 	io = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	vsp1->mmio = devm_ioremap_resource(&pdev->dev, io);
@@ -557,6 +587,11 @@ static int vsp1_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static const struct of_device_id vsp1_of_match[] = {
+	{ .compatible = "renesas,vsp1" },
+	{ },
+};
+
 static struct platform_driver vsp1_platform_driver = {
 	.probe		= vsp1_probe,
 	.remove		= vsp1_remove,
@@ -564,6 +599,7 @@ static struct platform_driver vsp1_platform_driver = {
 		.owner	= THIS_MODULE,
 		.name	= "vsp1",
 		.pm	= &vsp1_pm_ops,
+		.of_match_table = of_match_ptr(vsp1_of_match),
 	},
 };
 
-- 
1.8.3.2

