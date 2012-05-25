Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:25307 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932849Ab2EYTxL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 May 2012 15:53:11 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Fri, 25 May 2012 21:52:52 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [RFC/PATCH 13/13] media: s5p-fimc: Add parallel video port pin
 configuration
In-reply-to: <1337975573-27117-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	s.nawrocki@samsung.com, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org, b.zolnierkie@samsung.com
Message-id: <1337975573-27117-13-git-send-email-s.nawrocki@samsung.com>
References: <4FBFE1EC.9060209@samsung.com>
 <1337975573-27117-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds parsing of 'samsung,fimc-camport-a-gpios' and
'samsung,fimc-camport-b-gpios' properties from 'camera' node
and configuration of camera parallel port pins. It can be
in future replaced with equivalent pinctrl API calls.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyugmin Park <kyungmin.park@samsung.com>
---
 .../bindings/camera/soc/samsung-fimc.txt           |   12 +++
 drivers/media/video/s5p-fimc/fimc-mdevice.c        |   87 ++++++++++++++++++++
 drivers/media/video/s5p-fimc/fimc-mdevice.h        |   10 +++
 3 files changed, 109 insertions(+)

diff --git a/Documentation/devicetree/bindings/camera/soc/samsung-fimc.txt b/Documentation/devicetree/bindings/camera/soc/samsung-fimc.txt
index ffe09ac..efa5be5 100644
--- a/Documentation/devicetree/bindings/camera/soc/samsung-fimc.txt
+++ b/Documentation/devicetree/bindings/camera/soc/samsung-fimc.txt
@@ -23,6 +23,18 @@ Optional properties:
 - csi-rx-controllers : an array of phandles to 'csis' device nodes,
 		       it is required for sensors with MIPI-CSI2 bus;
 
+- samsung,camport-a-gpios, samsung,camport-b-gpios : gpio specifier list for
+			   the parallel camera ports A and B respectively;
+
+  For 'video-itu-601-bus' the list length must be 13, for 'video-itu-656-bus'
+  at least 10 and for 'video-mipi-csi2-bus' the array should contain at least
+  one gpio (CLKOUT). The meaning of the gpios is as following: DATA[7:0], PCLK,
+  VSYNC, HREF, CLKOUT, FIELD. It is not required to list gpios exactly in that
+  order. All gpios listed here will be configured into camera port function.
+  In case of ITU-R BT.656 bus the VSYNC, HREF, and FIELD pins remain unused,
+  hence don't need to be specified here.
+
+
 'fimc' device node
 ------------------
 
diff --git a/drivers/media/video/s5p-fimc/fimc-mdevice.c b/drivers/media/video/s5p-fimc/fimc-mdevice.c
index faf5665..31bf852 100644
--- a/drivers/media/video/s5p-fimc/fimc-mdevice.c
+++ b/drivers/media/video/s5p-fimc/fimc-mdevice.c
@@ -1108,6 +1108,87 @@ static ssize_t fimc_md_sysfs_store(struct device *dev,
 static DEVICE_ATTR(subdev_conf_mode, S_IWUSR | S_IRUGO,
 		   fimc_md_sysfs_show, fimc_md_sysfs_store);
 
+static int __fimc_md_get_gpios(struct device_node *np,
+			       struct fimc_video_port *port,
+			       const char *prop_name)
+{
+	int i, err = -EINVAL;
+
+	for (i = 0; i < FIMC_MAX_PARALLEL_PORT_PINS; i++) {
+		port->gpios[i] = of_get_named_gpio(np, prop_name, i);
+		if (port->gpios[i] == -ENOENT && i > 0)
+			return 0;
+
+		if (gpio_is_valid(port->gpios[i])) {
+			err = gpio_request(port->gpios[i], "fimc");
+			if (!err)
+				continue;
+		}
+
+		pr_err("Failed to configure gpios: %s\n", prop_name);
+
+		while (--i >= 0) {
+			gpio_free(port->gpios[i]);
+			port->gpios[i] = -EINVAL;
+		}
+		break;
+	}
+
+	return err;
+}
+
+static int fimc_md_camport_setup(struct fimc_md *fmd, struct device_node *np)
+{
+	const char *gpio_props[] = { "samsung,camport-a-gpios",
+				     "samsung,camport-b-gpios" };
+	struct fimc_video_port *pport;
+	unsigned int ret;
+	int i;
+
+	pport = devm_kzalloc(&fmd->pdev->dev, FIMC_MAX_PARALLEL_PORTS *
+			     sizeof(*pport), GFP_KERNEL);
+	if (pport == NULL)
+		return -ENOMEM;
+
+	for (i = 0; i < ARRAY_SIZE(gpio_props); i++) {
+		if (!of_find_property(np, gpio_props[i], NULL))
+			continue;
+		ret = __fimc_md_get_gpios(np, &pport[i], gpio_props[i]);
+		if (ret < 0)
+			return ret;
+	}
+
+	fmd->parallel_ports = pport;
+	return ret;
+}
+
+static void fimc_md_camport_release(struct fimc_md *fmd)
+{
+	struct fimc_video_port *pport = fmd->parallel_ports;
+	int port, i;
+
+	if (pport == NULL)
+		return;
+
+	for (port = 0; port < FIMC_MAX_PARALLEL_PORTS; port++, pport++) {
+		for (i = 0; i < FIMC_MAX_PARALLEL_PORT_PINS; i++) {
+			if (!gpio_is_valid(pport->gpios[i]))
+				continue;
+			gpio_free(pport->gpios[i]);
+		}
+	}
+}
+
+static int fimc_md_parse_dt(struct fimc_md *fmd)
+{
+	struct device_node *np = fmd->pdev->dev.of_node;
+
+	if (np == NULL)
+		return 0;
+
+	return fimc_md_camport_setup(fmd, np);
+}
+
 static int fimc_md_probe(struct platform_device *pdev)
 {
 	struct v4l2_device *v4l2_dev;
@@ -1155,11 +1236,16 @@ static int fimc_md_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_unlock;
 
+	ret = fimc_md_parse_dt(fmd);
+	if (ret < 0)
+		goto err_unlock;
+
 	if (pdev->dev.platform_data || pdev->dev.of_node) {
 		ret = fimc_md_register_sensor_entities(fmd);
 		if (ret)
 			goto err_unlock;
 	}
+
 	ret = fimc_md_create_links(fmd);
 	if (ret)
 		goto err_unlock;
@@ -1196,6 +1282,7 @@ static int __devexit fimc_md_remove(struct platform_device *pdev)
 	fimc_md_unregister_entities(fmd);
 	media_device_unregister(&fmd->media_dev);
 	fimc_md_put_clocks(fmd);
+	fimc_md_camport_release(fmd);
 	return 0;
 }
 
diff --git a/drivers/media/video/s5p-fimc/fimc-mdevice.h b/drivers/media/video/s5p-fimc/fimc-mdevice.h
index bba85bf..1f7ebf8 100644
--- a/drivers/media/video/s5p-fimc/fimc-mdevice.h
+++ b/drivers/media/video/s5p-fimc/fimc-mdevice.h
@@ -30,6 +30,10 @@
 
 #define FIMC_MAX_SENSORS	8
 #define FIMC_MAX_CAMCLKS	2
+/* Maximum number of supported parallel video ports */
+#define FIMC_MAX_PARALLEL_PORTS		2
+/* Maximum number of pins per 8-bit parallel port */
+#define FIMC_MAX_PARALLEL_PORT_PINS	13
 
 struct fimc_csis_info {
 	struct v4l2_subdev *sd;
@@ -58,8 +62,13 @@ struct fimc_sensor_info {
 	bool clk_on;
 };
 
+struct fimc_video_port {
+	int gpios[FIMC_MAX_PARALLEL_PORT_PINS];
+};
+
 /**
  * struct fimc_md - fimc media device information
+ * @parallel_ports: parallel video ports data
  * @csis: MIPI CSIS subdevs data
  * @sensor: array of registered sensor subdevs
  * @num_sensors: actual number of registered sensors
@@ -72,6 +81,7 @@ struct fimc_sensor_info {
  * @slock: spinlock protecting @sensor array
  */
 struct fimc_md {
+	struct fimc_video_port *parallel_ports;
 	struct fimc_csis_info csis[CSIS_MAX_ENTITIES];
 	struct fimc_sensor_info sensor[FIMC_MAX_SENSORS];
 	int num_sensors;
-- 
1.7.10

