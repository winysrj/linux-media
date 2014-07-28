Return-path: <linux-media-owner@vger.kernel.org>
Received: from nasmtp01.atmel.com ([192.199.1.245]:42577 "EHLO
	DVREDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751013AbaG1HZq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Jul 2014 03:25:46 -0400
From: Josh Wu <josh.wu@atmel.com>
To: <linux-media@vger.kernel.org>, <g.liakhovetski@gmx.de>
CC: <m.chehab@samsung.com>, <linux-arm-kernel@lists.infradead.org>,
	<laurent.pinchart@ideasonboard.com>, <grant.likely@linaro.org>,
	<galak@codeaurora.org>, <rob@landley.net>, <robh+dt@kernel.org>,
	<ijc+devicetree@hellion.org.uk>, <pawel.moll@arm.com>,
	<ben.dooks@codethink.co.uk>, Josh Wu <josh.wu@atmel.com>,
	<devicetree@vger.kernel.org>
Subject: [PATCH v4 3/3] media: atmel-isi: add primary DT support
Date: Mon, 28 Jul 2014 15:25:17 +0800
Message-ID: <1406532317-32701-1-git-send-email-josh.wu@atmel.com>
In-Reply-To: <1406532167-32655-1-git-send-email-josh.wu@atmel.com>
References: <1406532167-32655-1-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch add the DT support for Atmel ISI driver.
It use the same v4l2 DT interface that defined in video-interfaces.txt.

Signed-off-by: Josh Wu <josh.wu@atmel.com>
Cc: devicetree@vger.kernel.org
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
v3 -> v4:
  When bus width is 10, we support both 8 & 10 bits.
  Use of_match_ptr().
  refine the error message.

v2 -> v3:
  add bus-width property support.
  add error handling when calling atmel_isi_probe_dt().

v1 -> v2:
  refine the binding document.
  add port node description.
  removed the optional property.

 .../devicetree/bindings/media/atmel-isi.txt        | 51 +++++++++++++++++
 drivers/media/platform/soc_camera/atmel-isi.c      | 65 +++++++++++++++++++++-
 2 files changed, 114 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/atmel-isi.txt

diff --git a/Documentation/devicetree/bindings/media/atmel-isi.txt b/Documentation/devicetree/bindings/media/atmel-isi.txt
new file mode 100644
index 0000000..17e71b7
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/atmel-isi.txt
@@ -0,0 +1,51 @@
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
+				bus-width = <8>;
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
index 74af560..e5c1fcf 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.c
+++ b/drivers/media/platform/soc_camera/atmel-isi.c
@@ -25,6 +25,7 @@
 #include <media/atmel-isi.h>
 #include <media/soc_camera.h>
 #include <media/soc_mediabus.h>
+#include <media/v4l2-of.h>
 #include <media/videobuf2-dma-contig.h>
 
 #define MAX_BUFFER_NUM			32
@@ -33,6 +34,7 @@
 #define VID_LIMIT_BYTES			(16 * 1024 * 1024)
 #define MIN_FRAME_RATE			15
 #define FRAME_INTERVAL_MILLI_SEC	(1000 / MIN_FRAME_RATE)
+#define ISI_DEFAULT_MCLK_FREQ		25000000
 
 /* Frame buffer descriptor */
 struct fbd {
@@ -883,6 +885,51 @@ static int atmel_isi_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static int atmel_isi_probe_dt(struct atmel_isi *isi,
+			struct platform_device *pdev)
+{
+	struct device_node *np= pdev->dev.of_node;
+	struct v4l2_of_endpoint ep;
+	int err;
+
+	/* Default settings for ISI */
+	isi->pdata.full_mode = 1;
+	isi->pdata.mck_hz = ISI_DEFAULT_MCLK_FREQ;
+	isi->pdata.frate = ISI_CFG1_FRATE_CAPTURE_ALL;
+
+	np = of_graph_get_next_endpoint(np, NULL);
+	if (!np) {
+		dev_err(&pdev->dev, "Could not find the endpoint\n");
+		return -EINVAL;
+	}
+
+	err = v4l2_of_parse_endpoint(np, &ep);
+	if (err) {
+		dev_err(&pdev->dev, "Could not parse the endpoint\n");
+		goto err_probe_dt;
+	}
+
+	switch (ep.bus.parallel.bus_width) {
+	case 8:
+		isi->pdata.data_width_flags = ISI_DATAWIDTH_8;
+		break;
+	case 10:
+		isi->pdata.data_width_flags =
+				ISI_DATAWIDTH_8 | ISI_DATAWIDTH_10;
+		break;
+	default:
+		dev_err(&pdev->dev, "Unsupported bus width: %d\n",
+				ep.bus.parallel.bus_width);
+		err = -EINVAL;
+		goto err_probe_dt;
+	}
+
+err_probe_dt:
+	of_node_put(np);
+
+	return err;
+}
+
 static int atmel_isi_probe(struct platform_device *pdev)
 {
 	unsigned int irq;
@@ -894,7 +941,7 @@ static int atmel_isi_probe(struct platform_device *pdev)
 	struct isi_platform_data *pdata;
 
 	pdata = dev->platform_data;
-	if (!pdata || !pdata->data_width_flags) {
+	if ((!pdata || !pdata->data_width_flags) && !pdev->dev.of_node) {
 		dev_err(&pdev->dev,
 			"No config available for Atmel ISI\n");
 		return -EINVAL;
@@ -910,7 +957,14 @@ static int atmel_isi_probe(struct platform_device *pdev)
 	if (IS_ERR(isi->pclk))
 		return PTR_ERR(isi->pclk);
 
-	memcpy(&isi->pdata, pdata, sizeof(isi->pdata));
+	if (pdata) {
+		memcpy(&isi->pdata, pdata, sizeof(isi->pdata));
+	} else {
+		ret = atmel_isi_probe_dt(isi, pdev);
+		if (ret)
+			return ret;
+	}
+
 	isi->active = NULL;
 	spin_lock_init(&isi->lock);
 	INIT_LIST_HEAD(&isi->video_buffer_list);
@@ -1012,11 +1066,18 @@ err_alloc_ctx:
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
+		.of_match_table = of_match_ptr(atmel_isi_of_match),
 	},
 };
 
-- 
1.9.1

