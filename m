Return-path: <linux-media-owner@vger.kernel.org>
Received: from nasmtp02.atmel.com ([204.2.163.16]:17960 "EHLO
	SJOEDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753834AbaCYKuz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Mar 2014 06:50:55 -0400
From: Josh Wu <josh.wu@atmel.com>
To: <g.liakhovetski@gmx.de>
CC: <linux-media@vger.kernel.org>, <m.chehab@samsung.com>,
	<nicolas.ferre@atmel.com>, <linux-arm-kernel@lists.infradead.org>,
	<grant.likely@linaro.org>, <galak@codeaurora.org>,
	<rob@landley.net>, <mark.rutland@arm.com>, <robh+dt@kernel.org>,
	<ijc+devicetree@hellion.org.uk>, <pawel.moll@arm.com>,
	<devicetree@vger.kernel.org>, <laurent.pinchart@ideasonboard.com>,
	Josh Wu <josh.wu@atmel.com>
Subject: [PATCH v2 3/3] [media] atmel-isi: add primary DT support
Date: Tue, 25 Mar 2014 18:45:20 +0800
Message-ID: <1395744320-15025-1-git-send-email-josh.wu@atmel.com>
In-Reply-To: <1395744087-5753-1-git-send-email-josh.wu@atmel.com>
References: <1395744087-5753-1-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch add the DT support for Atmel ISI driver.
It use the same v4l2 DT interface that defined in video-interfaces.txt.

Signed-off-by: Josh Wu <josh.wu@atmel.com>
Cc: devicetree@vger.kernel.org
---
v1 --> v2:
 refine the binding document.
 add port node description.
 removed the optional property.

 .../devicetree/bindings/media/atmel-isi.txt        |   50 ++++++++++++++++++++
 drivers/media/platform/soc_camera/atmel-isi.c      |   31 +++++++++++-
 2 files changed, 79 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/atmel-isi.txt

diff --git a/Documentation/devicetree/bindings/media/atmel-isi.txt b/Documentation/devicetree/bindings/media/atmel-isi.txt
new file mode 100644
index 0000000..11c98ee
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/atmel-isi.txt
@@ -0,0 +1,50 @@
+Atmel Image Sensor Interface (ISI) SoC Camera Subsystem
+----------------------------------------------
+
+Required properties:
+- compatible: must be "atmel,at91sam9g45-isi"
+- reg: physical base address and length of the registers set for the device;
+- interrupts: should contain IRQ line for the ISI;
+- clocks: list of clock specifiers, corresponding to entries in
+          the clock-names property;
+- clock-names: must contain "isi_clk", which is the isi peripherial clock.
+
+ISI supports a single port node with parallel bus. It should contain one
+'port' child node with child 'endpoint' node. Please refer to the bindings
+defined in Documentation/devicetree/bindings/media/video-interfaces.txt.
+
+Example:
+	isi: isi@f0034000 {
+		compatible = "atmel,at91sam9g45-isi";
+		reg = <0xf0034000 0x4000>;
+		interrupts = <37 IRQ_TYPE_LEVEL_HIGH 5>;
+
+		clocks = <&isi_clk>;
+		clock-names = "isi_clk";
+
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_isi>;
+
+		port {
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			isi_0: endpoint {
+				remote-endpoint = <&ov2640_0>;
+			};
+		};
+	};
+
+	i2c1: i2c@f0018000 {
+		ov2640: camera@0x30 {
+			compatible = "omnivision,ov2640";
+			reg = <0x30>;
+
+			port {
+				ov2640_0: endpoint {
+					remote-endpoint = <&isi_0>;
+					bus-width = <8>;
+				};
+			};
+		};
+	};
diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index f4add0a..d6a1f7b 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.c
+++ b/drivers/media/platform/soc_camera/atmel-isi.c
@@ -19,6 +19,7 @@
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 
@@ -33,6 +34,7 @@
 #define VID_LIMIT_BYTES			(16 * 1024 * 1024)
 #define MIN_FRAME_RATE			15
 #define FRAME_INTERVAL_MILLI_SEC	(1000 / MIN_FRAME_RATE)
+#define ISI_DEFAULT_MCLK_FREQ		25000000
 
 /* Frame buffer descriptor */
 struct fbd {
@@ -885,6 +887,20 @@ static int atmel_isi_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static int atmel_isi_probe_dt(struct atmel_isi *isi,
+			struct platform_device *pdev)
+{
+	struct device_node *node = pdev->dev.of_node;
+
+	/* Default settings for ISI */
+	isi->pdata.full_mode = 1;
+	isi->pdata.mck_hz = ISI_DEFAULT_MCLK_FREQ;
+	isi->pdata.frate = ISI_CFG1_FRATE_CAPTURE_ALL;
+	isi->pdata.data_width_flags = ISI_DATAWIDTH_8 | ISI_DATAWIDTH_10;
+
+	return 0;
+}
+
 static int atmel_isi_probe(struct platform_device *pdev)
 {
 	unsigned int irq;
@@ -896,7 +912,7 @@ static int atmel_isi_probe(struct platform_device *pdev)
 	struct isi_platform_data *pdata;
 
 	pdata = dev->platform_data;
-	if (!pdata || !pdata->data_width_flags) {
+	if ((!pdata || !pdata->data_width_flags) && !pdev->dev.of_node) {
 		dev_err(&pdev->dev,
 			"No config available for Atmel ISI\n");
 		return -EINVAL;
@@ -912,7 +928,11 @@ static int atmel_isi_probe(struct platform_device *pdev)
 	if (IS_ERR(isi->pclk))
 		return PTR_ERR(isi->pclk);
 
-	memcpy(&isi->pdata, pdata, sizeof(struct isi_platform_data));
+	if (pdata)
+		memcpy(&isi->pdata, pdata, sizeof(struct isi_platform_data));
+	else	/* dt probe */
+		atmel_isi_probe_dt(isi, pdev);
+
 	isi->active = NULL;
 	spin_lock_init(&isi->lock);
 	INIT_LIST_HEAD(&isi->video_buffer_list);
@@ -1014,11 +1034,18 @@ err_alloc_ctx:
 	return ret;
 }
 
+static const struct of_device_id atmel_isi_of_match[] = {
+	{ .compatible = "atmel,at91sam9g45-isi" },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, atmel_isi_of_match);
+
 static struct platform_driver atmel_isi_driver = {
 	.remove		= atmel_isi_remove,
 	.driver		= {
 		.name = "atmel_isi",
 		.owner = THIS_MODULE,
+		.of_match_table = atmel_isi_of_match,
 	},
 };
 
-- 
1.7.9.5

