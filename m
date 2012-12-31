Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:15698 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400Ab2LaQED (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Dec 2012 11:04:03 -0500
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, grant.likely@secretlab.ca,
	rob.herring@calxeda.com, thomas.abraham@linaro.org,
	t.figa@samsung.com, sw0312.kim@samsung.com,
	kyungmin.park@samsung.com, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC v2 08/15] s5p-fimc: Add device tree based sensors
 registration
Date: Mon, 31 Dec 2012 17:03:06 +0100
Message-id: <1356969793-27268-9-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1356969793-27268-1-git-send-email-s.nawrocki@samsung.com>
References: <1356969793-27268-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The sensor (I2C and/or SPI client) devices are instantiated by their
corresponding control bus drivers. Since the I2C client's master clock
is often provided by a video bus receiver (host interface) or other
than I2C/SPI controller device, the drivers of those client devices
are not accessing hardware in their driver's probe() callback. Instead,
after enabling clock, the host driver calls back into a sub-device
when it wants to activate them. This pattern is used by some in-tree
drivers and this patch also uses it for DT case. This patch is
intended as a first step for adding device tree support to the
S5P/Exynos SoC camera drivers. The second one is adding support for
asynchronous sub-devices registration and clock control from
sub-device driver level. The bindings shall not change when
asynchronous probing support is added. The motivation behind this
approach is to have basic support for device tree based platforms
in the driver, while asynchronous subdev probing and related issues
are being discussed on LMML.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 .../devicetree/bindings/media/soc/samsung-fimc.txt |   75 +++++++
 drivers/media/platform/s5p-fimc/fimc-mdevice.c     |  237 +++++++++++++++++---
 include/media/s5p_fimc.h                           |   16 ++
 3 files changed, 299 insertions(+), 29 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/soc/samsung-fimc.txt b/Documentation/devicetree/bindings/media/soc/samsung-fimc.txt
index 5bbda07..82bd619 100644
--- a/Documentation/devicetree/bindings/media/soc/samsung-fimc.txt
+++ b/Documentation/devicetree/bindings/media/soc/samsung-fimc.txt
@@ -73,6 +73,15 @@ node. Aliases are in form of fimc-lite<n>, where <n> is an integer (0...N)
 specifying the IP's instance index.
 
 
+Image sensor nodes
+------------------
+
+The sensor device nodes should be added as their control bus controller
+(e.g. I2C0) child nodes and linked to a port created under csis or
+parallel-ports node, using common bindings for video input interfaces,
+.i.e. port/endpoint node pairs. The implementation of this binding requires
+at clock-frequency property to be present under sensor device nodes.
+
 Example:
 
 	aliases {
@@ -80,6 +89,47 @@ Example:
 		fimc0 = &fimc_0;
 	};
 
+	/* Parallel bus IF sensor */
+	i2c_0: i2c@13860000 {
+		s5k6aa: sensor@3c {
+			compatible = "samsung,s5k6aafx";
+			reg = <0x3c>;
+			vddio-supply = <...>;
+
+			clock-frequency = <24000000>;
+			clocks = <...>;
+			clock-names = "mclk";
+
+			port {
+				s5k6aa_ep: endpoint {
+					remote-endpoint = <&fimc0_ep>;
+					bus-width = <8>;
+					hsync-active = <0>;
+					hsync-active = <1>;
+					pclk-sample = <1>;
+				};
+			};
+		};
+	};
+
+	/* MIPI CSI-2 bus IF sensor */
+	s5c73m3: sensor@0x1a {
+		compatible = "samsung,s5c73m3";
+		reg = <0x1a>;
+		vddio-supply = <...>;
+
+		clock-frequency = <24000000>;
+		clocks = <...>;
+		clock-names = "mclk";
+
+		port {
+			s5c73m3_1: endpoint {
+				data-lanes = <1>, <2>, <3>, <4>;
+				remote-endpoint = <&csis0_ep>;
+			};
+		};
+	};
+
 	camera {
 		compatible = "samsung,fimc", "simple-bus";
 		#address-cells = <1>;
@@ -90,6 +140,21 @@ Example:
 		pinctrl-0 = <&cam_port_a_clk_active>;
 		pinctrl-1 = <&cam_port_a_clk_idle>;
 
+		/* parallel camera ports */
+		parallel-ports {
+			/* camera A input */
+			port@0 {
+				reg = <0>;
+				fimc0_ep: endpoint {
+					remote-endpoint = <&s5k6aa_ep>;
+					bus-width = <8>;
+					hsync-active = <0>;
+					hsync-active = <1>;
+					pclk-sample = <1>;
+				};
+			};
+		};
+
 		fimc_0: fimc@11800000 {
 			compatible = "samsung,exynos4210-fimc";
 			reg = <0x11800000 0x1000>;
@@ -102,6 +167,16 @@ Example:
 			reg = <0x11880000 0x1000>;
 			interrupts = <0 78 0>;
 			max-data-lanes = <4>;
+			/* camera C input */
+			port {
+				reg = <2>;
+				csis0_ep: endpoint {
+					remote-endpoint = <&s5c73m3_ep>;
+					data-lanes = <1>, <2>, <3>, <4>;
+					samsung,csis-hs-settle = <12>;
+					samsung,camclk-out = <0>;
+				};
+			};
 		};
 	};
 
diff --git a/drivers/media/platform/s5p-fimc/fimc-mdevice.c b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
index 105bb91..3ac6ea8 100644
--- a/drivers/media/platform/s5p-fimc/fimc-mdevice.c
+++ b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
@@ -19,11 +19,15 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_platform.h>
+#include <linux/of_device.h>
+#include <linux/of_gpio.h>
+#include <linux/of_i2c.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/types.h>
 #include <linux/slab.h>
 #include <media/v4l2-ctrls.h>
+#include <media/v4l2-of.h>
 #include <media/media-device.h>
 #include <media/s5p_fimc.h>
 
@@ -248,7 +252,7 @@ static struct v4l2_subdev *fimc_md_register_sensor(struct fimc_md *fmd,
 	sd->grp_id = GRP_ID_SENSOR;
 
 	v4l2_info(&fmd->v4l2_dev, "Registered sensor subdevice %s\n",
-		  s_info->pdata.board_info->type);
+		  sd->name);
 	return sd;
 }
 
@@ -260,17 +264,183 @@ static void fimc_md_unregister_sensor(struct v4l2_subdev *sd)
 	if (!client)
 		return;
 	v4l2_device_unregister_subdev(sd);
-	adapter = client->adapter;
-	i2c_unregister_device(client);
-	if (adapter)
-		i2c_put_adapter(adapter);
+
+	if (!client->dev.of_node) {
+		adapter = client->adapter;
+		i2c_unregister_device(client);
+		if (adapter)
+			i2c_put_adapter(adapter);
+	}
+}
+
+#ifdef CONFIG_OF
+/* Register I2C client subdev associated with @node. */
+static int fimc_md_of_add_sensor(struct fimc_md *fmd,
+				 struct device_node *node, int index)
+{
+	struct fimc_sensor_info *si;
+	struct i2c_client *client;
+	struct v4l2_subdev *sd;
+	int ret;
+
+	if (index >= ARRAY_SIZE(fmd->sensor))
+		return -EINVAL;
+	si = &fmd->sensor[index];
+
+	client = of_find_i2c_device_by_node(node);
+	if (!client)
+		return -EPROBE_DEFER;
+
+	device_lock(&client->dev);
+
+	if (!client->driver ||
+	    !try_module_get(client->driver->driver.owner)) {
+		ret = -EAGAIN;
+		goto dev_put;
+	}
+
+	/* Enable sensor's master clock */
+	ret = __fimc_md_set_camclk(fmd, si, true);
+	if (ret < 0)
+		goto mod_put;
+	sd = i2c_get_clientdata(client);
+
+	ret = v4l2_device_register_subdev(&fmd->v4l2_dev, sd);
+	__fimc_md_set_camclk(fmd, si, false);
+	if (ret < 0)
+		goto mod_put;
+
+	v4l2_set_subdev_hostdata(sd, si);
+	sd->grp_id = GRP_ID_SENSOR;
+	si->subdev = sd;
+	v4l2_info(&fmd->v4l2_dev, "Registered sensor subdevice: %s (%d)\n",
+		  sd->name, fmd->num_sensors);
+	fmd->num_sensors++;
+
+mod_put:
+	module_put(client->driver->driver.owner);
+dev_put:
+	device_unlock(&client->dev);
+	put_device(&client->dev);
+	return ret;
 }
 
+/* Parse port node and register as a sub-device any sensor specified there. */
+static int fimc_md_parse_port_node(struct fimc_md *fmd,
+				   struct device_node *port,
+				   unsigned int index)
+{
+	struct device_node *rem, *endpoint;
+	struct s5p_fimc_isp_info *pd;
+	struct v4l2_of_endpoint bus_cfg;
+	u32 tmp, reg;
+	int ret;
+
+	if (index >= FIMC_MAX_SENSORS ||
+	    of_property_read_u32(port, "reg", &reg))
+		return -EINVAL;
+
+	pd = &fmd->sensor[index].pdata;
+	pd->mux_id = (reg - 1) & 0x1;
+
+	endpoint = of_get_child_by_name(port, "endpoint");
+	if (!endpoint)
+		return -EINVAL;
+
+	rem = v4l2_of_get_remote_port_parent(endpoint);
+	of_node_put(endpoint);
+	if (!rem)
+		return -EINVAL;
+
+	if (!of_property_read_u32(rem, "samsung,camclk-out", &tmp))
+		pd->clk_id = tmp;
+
+	if (!of_property_read_u32(rem, "clock-frequency", &tmp))
+		pd->clk_frequency = tmp;
+
+	if (pd->clk_frequency == 0) {
+		v4l2_err(&fmd->v4l2_dev,
+			 "Wrong or unspecified sensor clock frequency\n");
+		of_node_put(rem);
+		return -EINVAL;
+	}
+
+	if (fimc_input_is_parallel(reg)) {
+		v4l2_of_parse_parallel_bus(endpoint, &bus_cfg);
+		if (bus_cfg.mbus_type == V4L2_MBUS_PARALLEL)
+			pd->bus_type = FIMC_ITU_601;
+		else
+			pd->bus_type = FIMC_ITU_656;
+		pd->flags = bus_cfg.mbus_flags;
+	} else if (fimc_input_is_mipi_csi(reg)) {
+		/*
+		 * MIPI CSI-2: only input mux selection
+		 * and sensor's clock frequency is needed.
+		 */
+		pd->bus_type = FIMC_MIPI_CSI2;
+	} else {
+		v4l2_err(&fmd->v4l2_dev,
+			 "Wrong reg property value (%u) at node %s/endpoint\n",
+			 reg, rem->name);
+	}
+
+	ret = fimc_md_of_add_sensor(fmd, rem, index);
+	of_node_put(rem);
+
+	return ret;
+}
+
+/* Register all SoC external sub-devices */
+static int fimc_md_of_sensors_register(struct fimc_md *fmd,
+				       struct device_node *np)
+{
+	struct device_node *parent = fmd->pdev->dev.of_node;
+	struct device_node *node, *ports;
+	int index = 0;
+	int ret;
+
+	/* Attach sensors linked to MIPI CSI-2 receivers */
+	for_each_available_child_of_node(parent, node) {
+		struct device_node *port;
+
+		if (of_node_cmp(node->name, "csis"))
+			continue;
+
+		port = of_get_child_by_name(node, "port");
+		if (!port)
+			return -EINVAL;
+
+		ret = fimc_md_parse_port_node(fmd, port, index);
+		if (ret < 0)
+			return ret;
+		index++;
+	}
+
+	/* Attach sensors listed in the parallel-ports node */
+	ports = of_get_child_by_name(parent, "parallel-ports");
+	if (!ports)
+		return 0;
+
+	for_each_child_of_node(ports, node) {
+		ret = fimc_md_parse_port_node(fmd, node, index);
+		if (ret < 0)
+			break;
+		index++;
+	}
+
+	return 0;
+}
+#else
+#define fimc_md_of_sensors_register(fmd, np) (-ENOSYS)
+#endif
+
 static int fimc_md_register_sensor_entities(struct fimc_md *fmd)
 {
 	struct s5p_platform_fimc *pdata = fmd->pdev->dev.platform_data;
+	struct device_node *of_node = fmd->pdev->dev.of_node;
 	struct fimc_dev *fd = NULL;
-	int num_clients, ret, i;
+	int num_clients = 0;
+	int ret, i;
 
 	/*
 	 * Runtime resume one of the FIMC entities to make sure
@@ -281,34 +451,41 @@ static int fimc_md_register_sensor_entities(struct fimc_md *fmd)
 			fd = fmd->fimc[i];
 	if (!fd)
 		return -ENXIO;
+
 	ret = pm_runtime_get_sync(&fd->pdev->dev);
 	if (ret < 0)
 		return ret;
 
-	WARN_ON(pdata->num_clients > ARRAY_SIZE(fmd->sensor));
-	num_clients = min_t(u32, pdata->num_clients, ARRAY_SIZE(fmd->sensor));
+	if (of_node) {
+		fmd->num_sensors = 0;
+		ret = fimc_md_of_sensors_register(fmd, of_node);
+	} else if (pdata) {
+		WARN_ON(pdata->num_clients > ARRAY_SIZE(fmd->sensor));
+		num_clients = min_t(u32, pdata->num_clients,
+				    ARRAY_SIZE(fmd->sensor));
+		fmd->num_sensors = num_clients;
 
-	fmd->num_sensors = num_clients;
-	for (i = 0; i < num_clients; i++) {
-		struct v4l2_subdev *sd;
+		for (i = 0; i < num_clients; i++) {
+			struct v4l2_subdev *sd;
 
-		fmd->sensor[i].pdata = pdata->isp_info[i];
-		ret = __fimc_md_set_camclk(fmd, &fmd->sensor[i], true);
-		if (ret)
-			break;
-		sd = fimc_md_register_sensor(fmd, &fmd->sensor[i]);
-		ret = __fimc_md_set_camclk(fmd, &fmd->sensor[i], false);
-
-		if (!IS_ERR(sd)) {
+			fmd->sensor[i].pdata = pdata->isp_info[i];
+			ret = __fimc_md_set_camclk(fmd, &fmd->sensor[i], true);
+			if (ret)
+				break;
+			sd = fimc_md_register_sensor(fmd, &fmd->sensor[i]);
+			ret = __fimc_md_set_camclk(fmd, &fmd->sensor[i], false);
+
+			if (IS_ERR(sd)) {
+				fmd->sensor[i].subdev = NULL;
+				ret = PTR_ERR(sd);
+				break;
+			}
 			fmd->sensor[i].subdev = sd;
-		} else {
-			fmd->sensor[i].subdev = NULL;
-			ret = PTR_ERR(sd);
-			break;
+			if (ret)
+				break;
 		}
-		if (ret)
-			break;
 	}
+
 	pm_runtime_put(&fd->pdev->dev);
 	return ret;
 }
@@ -948,11 +1125,12 @@ static DEVICE_ATTR(subdev_conf_mode, S_IWUSR | S_IRUGO,
 
 static int fimc_md_probe(struct platform_device *pdev)
 {
+	struct device *dev = &pdev->dev;
 	struct v4l2_device *v4l2_dev;
 	struct fimc_md *fmd;
 	int ret;
 
-	fmd = devm_kzalloc(&pdev->dev, sizeof(*fmd), GFP_KERNEL);
+	fmd = devm_kzalloc(dev, sizeof(*fmd), GFP_KERNEL);
 	if (!fmd)
 		return -ENOMEM;
 
@@ -962,7 +1140,7 @@ static int fimc_md_probe(struct platform_device *pdev)
 	strlcpy(fmd->media_dev.model, "SAMSUNG S5P FIMC",
 		sizeof(fmd->media_dev.model));
 	fmd->media_dev.link_notify = fimc_md_link_notify;
-	fmd->media_dev.dev = &pdev->dev;
+	fmd->media_dev.dev = dev;
 
 	v4l2_dev = &fmd->v4l2_dev;
 	v4l2_dev->mdev = &fmd->media_dev;
@@ -970,7 +1148,7 @@ static int fimc_md_probe(struct platform_device *pdev)
 	strlcpy(v4l2_dev->name, "s5p-fimc-md", sizeof(v4l2_dev->name));
 
 
-	ret = v4l2_device_register(&pdev->dev, &fmd->v4l2_dev);
+	ret = v4l2_device_register(dev, &fmd->v4l2_dev);
 	if (ret < 0) {
 		v4l2_err(v4l2_dev, "Failed to register v4l2_device: %d\n", ret);
 		return ret;
@@ -997,11 +1175,12 @@ static int fimc_md_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_unlock;
 
-	if (pdev->dev.platform_data) {
+	if (dev->platform_data || dev->of_node) {
 		ret = fimc_md_register_sensor_entities(fmd);
 		if (ret)
 			goto err_unlock;
 	}
+
 	ret = fimc_md_create_links(fmd);
 	if (ret)
 		goto err_unlock;
diff --git a/include/media/s5p_fimc.h b/include/media/s5p_fimc.h
index eaea62a..e8e03cf 100644
--- a/include/media/s5p_fimc.h
+++ b/include/media/s5p_fimc.h
@@ -14,6 +14,22 @@
 
 #include <media/media-entity.h>
 
+/*
+ * Enumeration of data inputs to the camera subsystem.
+ */
+enum fimc_input {
+	FIMC_INPUT_PARALLEL_0	= 1,
+	FIMC_INPUT_PARALLEL_1,
+	FIMC_INPUT_MIPI_CSI2_0	= 3,
+	FIMC_INPUT_MIPI_CSI2_1,
+	FIMC_INPUT_WRITEBACK_A	= 5,
+	FIMC_INPUT_WRITEBACK_B,
+	FIMC_INPUT_WRITEBACK_ISP = 5,
+};
+
+#define fimc_input_is_parallel(x) ((x) == 1 || (x) == 2)
+#define fimc_input_is_mipi_csi(x) ((x) == 3 || (x) == 4)
+
 enum cam_bus_type {
 	FIMC_ITU_601 = 1,
 	FIMC_ITU_656,
-- 
1.7.9.5

