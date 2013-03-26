Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:46034 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965789Ab3CZQke (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Mar 2013 12:40:34 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, myungjoo.ham@samsung.com,
	dh09.lee@samsung.com, shaik.samsung@gmail.com, arun.kk@samsung.com,
	a.hajda@samsung.com, linux-samsung-soc@vger.kernel.org,
	devicetree-discuss@lists.ozlabs.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v5 5/6] s5p-fimc: Add device tree based sensors registration
Date: Tue, 26 Mar 2013 17:39:57 +0100
Message-id: <1364315998-19372-6-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1364315998-19372-1-git-send-email-s.nawrocki@samsung.com>
References: <1364315998-19372-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The sensor (I2C and/or SPI client) devices are instantiated by their
corresponding control bus drivers. Since the I2C client's master clock
is often provided by a video bus receiver (host interface) or other
than I2C/SPI controller device, the drivers of those client devices
are not accessing hardware in their driver's probe() callback. Instead,
after enabling clock, the host driver calls back into a sub-device
when it wants to activate them. This pattern is used by some in-tree
drivers and this patch also uses it for DT case. This patch is intended
as a first step for adding device tree support to the S5P/Exynos SoC
camera drivers. The second one is adding support for asynchronous
sub-devices registration and clock control from sub-device driver
level. The bindings shall not change when asynchronous probing support
is added.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---

Changes since v5:
 - Minor changes at the binding documentation.

Changes since v4:
 - Corrected typos in the bindings example.

fimc sensors
---
 .../devicetree/bindings/media/samsung-fimc.txt     |   87 +++++++
 drivers/media/platform/s5p-fimc/fimc-mdevice.c     |  238 +++++++++++++++++---
 include/media/s5p_fimc.h                           |    3 +
 3 files changed, 302 insertions(+), 26 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/samsung-fimc.txt b/Documentation/devicetree/bindings/media/samsung-fimc.txt
index 22e2889..7617b93 100644
--- a/Documentation/devicetree/bindings/media/samsung-fimc.txt
+++ b/Documentation/devicetree/bindings/media/samsung-fimc.txt
@@ -72,18 +72,96 @@ Optional properties:
   writeback input.
 
 
+
+'parallel-ports' node
+---------------------
+
+This node should contain child 'port' nodes specifying active parallel video
+input ports. It includes camera A and camera B inputs. 'reg' property in the
+port nodes specifies data input - 0, 1 indicates input A, B respectively.
+
+Optional properties
+
+- samsung,camclk-out : specifies clock output for remote sensor,
+		       0 - CAM_A_CLKOUT, 1 - CAM_B_CLKOUT;
+
+Image sensor nodes
+------------------
+
+The sensor device nodes should be added to their control bus controller (e.g.
+I2C0) nodes and linked to a port node in the csis or the parallel-ports node,
+using the common video interfaces bindings, defined in video-interfaces.txt.
+The implementation of this bindings requires clock-frequency property to be
+present in the sensor device nodes.
+
 Example:
 
 	aliases {
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
+					vsync-active = <1>;
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
+				data-lanes = <1 2 3 4>;
+				remote-endpoint = <&csis0_ep>;
+			};
+		};
+	};
+
 	camera {
 		compatible = "samsung,fimc", "simple-bus";
 		#address-cells = <1>;
 		#size-cells = <1>;
 		status = "okay";
 
+		/* parallel camera ports */
+		parallel-ports {
+			/* camera A input */
+			port@0 {
+				reg = <0>;
+				fimc0_ep: endpoint {
+					remote-endpoint = <&s5k6aa_ep>;
+					bus-width = <8>;
+					hsync-active = <0>;
+					vsync-active = <1>;
+					pclk-sample = <1>;
+				};
+			};
+		};
+
 		fimc_0: fimc@11800000 {
 			compatible = "samsung,exynos4210-fimc";
 			reg = <0x11800000 0x1000>;
@@ -95,6 +173,15 @@ Example:
 			compatible = "samsung,exynos4210-csis";
 			reg = <0x11880000 0x1000>;
 			interrupts = <0 78 0>;
+			/* camera C input */
+			port@3 {
+				reg = <3>;
+				csis0_ep: endpoint {
+					remote-endpoint = <&s5c73m3_ep>;
+					data-lanes = <1 2 3 4>;
+					samsung,csis-hs-settle = <12>;
+				};
+			};
 		};
 	};
 
diff --git a/drivers/media/platform/s5p-fimc/fimc-mdevice.c b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
index b62011d..d6d38b9 100644
--- a/drivers/media/platform/s5p-fimc/fimc-mdevice.c
+++ b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
@@ -251,7 +251,7 @@ static struct v4l2_subdev *fimc_md_register_sensor(struct fimc_md *fmd,
 	sd->grp_id = GRP_ID_SENSOR;
 
 	v4l2_info(&fmd->v4l2_dev, "Registered sensor subdevice %s\n",
-		  s_info->pdata.board_info->type);
+		  sd->name);
 	return sd;
 }
 
@@ -263,13 +263,189 @@ static void fimc_md_unregister_sensor(struct v4l2_subdev *sd)
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
 }
 
 #ifdef CONFIG_OF
+/* Register I2C client subdev associated with @node. */
+static int fimc_md_of_add_sensor(struct fimc_md *fmd,
+				 struct device_node *node, int index)
+{
+	struct fimc_sensor_info *si;
+	struct i2c_client *client;
+	struct v4l2_subdev *sd;
+	int ret;
+
+	if (WARN_ON(index >= ARRAY_SIZE(fmd->sensor)))
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
+		ret = -EPROBE_DEFER;
+		v4l2_info(&fmd->v4l2_dev, "No driver found for %s\n",
+						node->full_name);
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
+}
+
+/* Parse port node and register as a sub-device any sensor specified there. */
+static int fimc_md_parse_port_node(struct fimc_md *fmd,
+				   struct device_node *port,
+				   unsigned int index)
+{
+	struct device_node *rem, *ep, *np;
+	struct fimc_source_info *pd;
+	struct v4l2_of_endpoint endpoint;
+	int ret;
+	u32 val;
+
+	pd = &fmd->sensor[index].pdata;
+
+	/* Assume here a port node can have only one endpoint node. */
+	ep = of_get_next_child(port, NULL);
+	if (!ep)
+		return 0;
+
+	v4l2_of_parse_endpoint(ep, &endpoint);
+	if (WARN_ON(endpoint.port == 0) || index >= FIMC_MAX_SENSORS)
+		return -EINVAL;
+
+	pd->mux_id = (endpoint.port - 1) & 0x1;
+
+	rem = v4l2_of_get_remote_port_parent(ep);
+	of_node_put(ep);
+	if (rem == NULL) {
+		v4l2_info(&fmd->v4l2_dev, "Remote device at %s not found\n",
+							ep->full_name);
+		return 0;
+	}
+	if (!of_property_read_u32(rem, "samsung,camclk-out", &val))
+		pd->clk_id = val;
+
+	if (!of_property_read_u32(rem, "clock-frequency", &val))
+		pd->clk_frequency = val;
+
+	if (pd->clk_frequency == 0) {
+		v4l2_err(&fmd->v4l2_dev, "Wrong clock frequency at node %s\n",
+			 rem->full_name);
+		of_node_put(rem);
+		return -EINVAL;
+	}
+
+	if (fimc_input_is_parallel(endpoint.port)) {
+		if (endpoint.bus_type == V4L2_MBUS_PARALLEL)
+			pd->sensor_bus_type = FIMC_BUS_TYPE_ITU_601;
+		else
+			pd->sensor_bus_type = FIMC_BUS_TYPE_ITU_656;
+		pd->flags = endpoint.bus.parallel.flags;
+	} else if (fimc_input_is_mipi_csi(endpoint.port)) {
+		/*
+		 * MIPI CSI-2: only input mux selection and
+		 * the sensor's clock frequency is needed.
+		 */
+		pd->sensor_bus_type = FIMC_BUS_TYPE_MIPI_CSI2;
+	} else {
+		v4l2_err(&fmd->v4l2_dev, "Wrong port id (%u) at node %s\n",
+			 endpoint.port, rem->full_name);
+	}
+	/*
+	 * For FIMC-IS handled sensors, that are placed under i2c-isp device
+	 * node, FIMC is connected to the FIMC-IS through its ISP Writeback
+	 * input. Sensors are attached to the FIMC-LITE hostdata interface
+	 * directly or through MIPI-CSIS, depending on the external media bus
+	 * used. This needs to be handled in a more reliable way, not by just
+	 * checking parent's node name.
+	 */
+	if ((np = of_get_parent(rem)) && !of_node_cmp(np->name, "i2c-isp"))
+		pd->fimc_bus_type = FIMC_BUS_TYPE_ISP_WRITEBACK;
+	else
+		pd->fimc_bus_type = pd->sensor_bus_type;
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
+		/* The csis node can have only port subnode. */
+		port = of_get_next_child(node, NULL);
+		if (!port)
+			continue;
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
+
 static int __of_get_csis_id(struct device_node *np)
 {
 	u32 reg = 0;
@@ -281,14 +457,17 @@ static int __of_get_csis_id(struct device_node *np)
 	return reg - FIMC_INPUT_MIPI_CSI2_0;
 }
 #else
+#define fimc_md_of_sensors_register(fmd, np) (-ENOSYS)
 #define __of_get_csis_id(np) (-ENOSYS)
 #endif
 
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
@@ -299,34 +478,41 @@ static int fimc_md_register_sensor_entities(struct fimc_md *fmd)
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
 
-		fmd->sensor[i].pdata = pdata->source_info[i];
-		ret = __fimc_md_set_camclk(fmd, &fmd->sensor[i], true);
-		if (ret)
-			break;
-		sd = fimc_md_register_sensor(fmd, &fmd->sensor[i]);
-		ret = __fimc_md_set_camclk(fmd, &fmd->sensor[i], false);
-
-		if (!IS_ERR(sd)) {
+			fmd->sensor[i].pdata = pdata->source_info[i];
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
@@ -1036,7 +1222,7 @@ static int fimc_md_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_unlock;
 
-	if (dev->platform_data) {
+	if (dev->platform_data || dev->of_node) {
 		ret = fimc_md_register_sensor_entities(fmd);
 		if (ret)
 			goto err_unlock;
diff --git a/include/media/s5p_fimc.h b/include/media/s5p_fimc.h
index e2c5989..e2434bb 100644
--- a/include/media/s5p_fimc.h
+++ b/include/media/s5p_fimc.h
@@ -45,6 +45,9 @@ enum fimc_bus_type {
 	FIMC_BUS_TYPE_ISP_WRITEBACK = FIMC_BUS_TYPE_LCD_WRITEBACK_B,
 };
 
+#define fimc_input_is_parallel(x) ((x) == 1 || (x) == 2)
+#define fimc_input_is_mipi_csi(x) ((x) == 3 || (x) == 4)
+
 struct i2c_board_info;
 
 /**
-- 
1.7.9.5

