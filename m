Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:63948 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756422Ab3ENIGq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 May 2013 04:06:46 -0400
From: Lad Prabhakar <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
	DLOS <davinci-linux-open-source@linux.davincidsp.com>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Grant Likely <grant.likely@secretlab.ca>,
	Rob Herring <rob.herring@calxeda.com>,
	Rob Landley <rob@landley.net>,
	devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org
Subject: [PATCH v2] media: i2c: tvp514x: add OF support
Date: Tue, 14 May 2013 13:36:31 +0530
Message-Id: <1368518791-26332-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Lad, Prabhakar <prabhakar.csengg@gmail.com>

add OF support for the tvp514x driver. Alongside this patch
removes unnecessary header file inclusion and sorts them alphabetically.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Rob Landley <rob@landley.net>
Cc: devicetree-discuss@lists.ozlabs.org
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: davinci-linux-open-source@linux.davincidsp.com
---
 Tested on da850-evm.

 RFC v1: https://patchwork.kernel.org/patch/2030061/
 RFC v2: https://patchwork.kernel.org/patch/2061811/

 Changes for current version from RFC v2:
 1: Fixed review comments pointed by Sylwester.

 Changes for v2:
 1: Listed all the compatible property values in the documentation text file.
 2: Removed "-decoder" from compatible property values.
 3: Added a reference to the V4L2 DT bindings documentation to explain
    what the port and endpoint nodes are for.
 4: Fixed some Nits pointed by Laurent.
 5: Removed unnecessary header file includes and sort them alphabetically.

 .../devicetree/bindings/media/i2c/tvp514x.txt      |   45 ++++++++++++
 drivers/media/i2c/tvp514x.c                        |   76 +++++++++++++++----
 2 files changed, 105 insertions(+), 16 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/tvp514x.txt

diff --git a/Documentation/devicetree/bindings/media/i2c/tvp514x.txt b/Documentation/devicetree/bindings/media/i2c/tvp514x.txt
new file mode 100644
index 0000000..cc09424
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/i2c/tvp514x.txt
@@ -0,0 +1,45 @@
+* Texas Instruments TVP514x video decoder
+
+The TVP5146/TVP5146m2/TVP5147/TVP5147m1 device is high quality, single-chip
+digital video decoder that digitizes and decodes all popular baseband analog
+video formats into digital video component. The tvp514x decoder supports analog-
+to-digital (A/D) conversion of component RGB and YPbPr signals as well as A/D
+conversion and decoding of NTSC, PAL and SECAM composite and S-video into
+component YCbCr.
+
+Required Properties :
+- compatible : value should be either one among the following
+	(a) "ti,tvp5146" for tvp5146 decoder.
+	(b) "ti,tvp5146m2" for tvp5146m2 decoder.
+	(c) "ti,tvp5147" for tvp5147 decoder.
+	(d) "ti,tvp5147m1" for tvp5147m1 decoder.
+
+- hsync-active: HSYNC Polarity configuration for endpoint.
+
+- vsync-active: VSYNC Polarity configuration for endpoint.
+
+- pclk-sample: Clock polarity of the endpoint.
+
+
+For further reading of port node refer Documentation/devicetree/bindings/media/
+video-interfaces.txt.
+
+Example:
+
+	i2c0@1c22000 {
+		...
+		...
+		tvp514x@5c {
+			compatible = "ti,tvp5146";
+			reg = <0x5c>;
+
+			port {
+				tvp514x_1: endpoint {
+					hsync-active = <1>;
+					vsync-active = <1>;
+					pclk-sample = <0>;
+				};
+			};
+		};
+		...
+	};
diff --git a/drivers/media/i2c/tvp514x.c b/drivers/media/i2c/tvp514x.c
index 887bd93..252fe9f 100644
--- a/drivers/media/i2c/tvp514x.c
+++ b/drivers/media/i2c/tvp514x.c
@@ -29,21 +29,18 @@
  *
  */
 
-#include <linux/i2c.h>
-#include <linux/slab.h>
 #include <linux/delay.h>
-#include <linux/videodev2.h>
+#include <linux/i2c.h>
 #include <linux/module.h>
-#include <linux/v4l2-mediabus.h>
+#include <linux/of_device.h>
+#include <linux/slab.h>
 
+#include <media/media-entity.h>
+#include <media/tvp514x.h>
 #include <media/v4l2-async.h>
-#include <media/v4l2-device.h>
-#include <media/v4l2-common.h>
-#include <media/v4l2-mediabus.h>
-#include <media/v4l2-chip-ident.h>
 #include <media/v4l2-ctrls.h>
-#include <media/tvp514x.h>
-#include <media/media-entity.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-of.h>
 
 #include "tvp514x_regs.h"
 
@@ -1056,6 +1053,40 @@ static struct tvp514x_decoder tvp514x_dev = {
 
 };
 
+static struct tvp514x_platform_data *
+tvp514x_get_pdata(struct i2c_client *client)
+{
+	struct tvp514x_platform_data *pdata;
+	struct v4l2_of_endpoint bus_cfg;
+	struct device_node *endpoint;
+	unsigned int flags;
+
+	if (!IS_ENABLED(CONFIG_OF) || !client->dev.of_node)
+		return client->dev.platform_data;
+
+	endpoint = v4l2_of_get_next_endpoint(client->dev.of_node, NULL);
+	if (!endpoint)
+		return NULL;
+
+	pdata = devm_kzalloc(&client->dev, sizeof(*pdata), GFP_KERNEL);
+	if (!pdata)
+		return NULL;
+
+	v4l2_of_parse_endpoint(endpoint, &bus_cfg);
+	flags = bus_cfg.bus.parallel.flags;
+
+	if (flags & V4L2_MBUS_HSYNC_ACTIVE_HIGH)
+		pdata->hs_polarity = 1;
+
+	if (flags & V4L2_MBUS_VSYNC_ACTIVE_HIGH)
+		pdata->vs_polarity = 1;
+
+	if (flags & V4L2_MBUS_PCLK_SAMPLE_RISING)
+		pdata->clk_polarity = 1;
+
+	return pdata;
+}
+
 /**
  * tvp514x_probe() - decoder driver i2c probe handler
  * @client: i2c driver client device structure
@@ -1067,19 +1098,20 @@ static struct tvp514x_decoder tvp514x_dev = {
 static int
 tvp514x_probe(struct i2c_client *client, const struct i2c_device_id *id)
 {
+	struct tvp514x_platform_data *pdata = tvp514x_get_pdata(client);
 	struct tvp514x_decoder *decoder;
 	struct v4l2_subdev *sd;
 	int ret;
 
+	if (pdata == NULL) {
+		dev_err(&client->dev, "No platform data\n");
+		return -EINVAL;
+	}
+
 	/* Check if the adapter supports the needed features */
 	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DATA))
 		return -EIO;
 
-	if (!client->dev.platform_data) {
-		v4l2_err(client, "No platform data!!\n");
-		return -ENODEV;
-	}
-
 	decoder = devm_kzalloc(&client->dev, sizeof(*decoder), GFP_KERNEL);
 	if (!decoder)
 		return -ENOMEM;
@@ -1091,7 +1123,7 @@ tvp514x_probe(struct i2c_client *client, const struct i2c_device_id *id)
 			sizeof(tvp514x_reg_list_default));
 
 	/* Copy board specific information here */
-	decoder->pdata = client->dev.platform_data;
+	decoder->pdata = pdata;
 
 	/**
 	 * Fetch platform specific data, and configure the
@@ -1240,8 +1272,20 @@ static const struct i2c_device_id tvp514x_id[] = {
 
 MODULE_DEVICE_TABLE(i2c, tvp514x_id);
 
+#if IS_ENABLED(CONFIG_OF)
+static const struct of_device_id tvp514x_of_match[] = {
+	{ .compatible = "ti,tvp5146", },
+	{ .compatible = "ti,tvp5146m2", },
+	{ .compatible = "ti,tvp5147", },
+	{ .compatible = "ti,tvp5147m1", },
+	{ /* sentinel */ },
+};
+MODULE_DEVICE_TABLE(of, tvp514x_of_match);
+#endif
+
 static struct i2c_driver tvp514x_driver = {
 	.driver = {
+		.of_match_table = of_match_ptr(tvp514x_of_match),
 		.owner = THIS_MODULE,
 		.name = TVP514X_MODULE_NAME,
 	},
-- 
1.7.4.1

