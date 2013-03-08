Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:8578 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934443Ab3CHQqm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Mar 2013 11:46:42 -0500
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MJC002AOP95NYK0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Sat, 09 Mar 2013 01:46:41 +0900 (KST)
Received: from amdc1344.digital.local ([106.116.147.32])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MJC00BU5P8ZM870@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Sat, 09 Mar 2013 01:46:41 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org, swarren@wwwdotorg.org,
	shaik.samsung@gmail.com, arun.kk@samsung.com, a.hajda@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH RFC v5 5/6] s5p-fimc: Add device tree based sensors registration
Date: Fri, 08 Mar 2013 17:46:05 +0100
Message-id: <1362761166-5285-7-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1362761166-5285-1-git-send-email-s.nawrocki@samsung.com>
References: <1362761166-5285-1-git-send-email-s.nawrocki@samsung.com>
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

Changes since v4:
 - corrected typos in the bindings example,
 - FIMC input id definitions are now moved to an earlier (s5p-csis)
   patch where they are needed to determine the MIPI CSI-2 channel.

---
 .../devicetree/bindings/media/samsung-fimc.txt     |   88 ++++++++
 drivers/media/platform/s5p-fimc/fimc-mdevice.c     |  224 +++++++++++++++++---
 include/media/s5p_fimc.h                           |    3 +
 3 files changed, 290 insertions(+), 25 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/samsung-fimc.txt b/Documentation/devicetree/bindings/media/samsung-fimc.txt
index c4a0480..88181d0 100644
--- a/Documentation/devicetree/bindings/media/samsung-fimc.txt
+++ b/Documentation/devicetree/bindings/media/samsung-fimc.txt
@@ -57,18 +57,97 @@ Optional properties:
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
+I2C0) nodes and linked to a port node in the csis or the parallel-ports node
+using the common video interfaces bindings, defined in video-interfaces.txt.
+The implementation of this bindings requires clock-frequency property to be
+present in the sensor device nodes.
+
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
@@ -80,6 +159,15 @@ Example:
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
index 7fae4c9..b4c2ca8 100644
--- a/drivers/media/platform/s5p-fimc/fimc-mdevice.c
+++ b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
@@ -251,7 +251,7 @@ static struct v4l2_subdev *fimc_md_register_sensor(struct fimc_md *fmd,
 	sd->grp_id = GRP_ID_SENSOR;
 
 	v4l2_info(&fmd->v4l2_dev, "Registered sensor subdevice %s\n",
-		  s_info->pdata.board_info->type);
+		  sd->name);
 	return sd;
 }
 
@@ -263,13 +263,177 @@ static void fimc_md_unregister_sensor(struct v4l2_subdev *sd)
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
+	struct device_node *rem, *endpoint;
+	struct fimc_source_info *pd;
+	struct v4l2_of_endpoint bus_cfg;
+	u32 tmp, reg = 0;
+	int ret;
+
+	if (WARN_ON(of_property_read_u32(port, "reg", &reg) ||
+	    reg >= FIMC_MAX_SENSORS))
+		return -EINVAL;
+
+	pd = &fmd->sensor[index].pdata;
+	pd->mux_id = (reg - 1) & 0x1;
+
+	/* Assume here a port node can have only one endpoint node. */
+	endpoint = of_get_next_child(port, NULL);
+	if (!endpoint)
+		return 0;
+
+	rem = v4l2_of_get_remote_port_parent(endpoint);
+	of_node_put(endpoint);
+	if (rem == NULL) {
+		v4l2_info(&fmd->v4l2_dev, "Remote device at %s not found\n",
+			  endpoint->full_name);
+		return 0;
+	}
+	if (!of_property_read_u32(rem, "samsung,camclk-out", &tmp))
+		pd->clk_id = tmp;
+
+	if (!of_property_read_u32(rem, "clock-frequency", &tmp))
+		pd->clk_frequency = tmp;
+
+	if (pd->clk_frequency == 0) {
+		v4l2_err(&fmd->v4l2_dev, "Wrong clock frequency at node %s\n",
+			 rem->full_name);
+		of_node_put(rem);
+		return -EINVAL;
+	}
+
+	if (fimc_input_is_parallel(reg)) {
+		v4l2_of_parse_parallel_bus(endpoint, &bus_cfg);
+		if (bus_cfg.mbus.type == V4L2_MBUS_PARALLEL)
+			pd->sensor_bus_type = FIMC_BUS_TYPE_ITU_601;
+		else
+			pd->sensor_bus_type = FIMC_BUS_TYPE_ITU_656;
+		pd->flags = bus_cfg.mbus.flags;
+	} else if (fimc_input_is_mipi_csi(reg)) {
+		/*
+		 * MIPI CSI-2: only input mux selection
+		 * and sensor's clock frequency is needed.
+		 */
+		pd->sensor_bus_type = FIMC_BUS_TYPE_MIPI_CSI2;
+	} else {
+		v4l2_err(&fmd->v4l2_dev, "Wrong port id (%u) at node %s\n",
+			 reg, rem->full_name);
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
@@ -281,14 +445,17 @@ static int __of_get_csis_id(struct device_node *np)
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
@@ -299,34 +466,41 @@ static int fimc_md_register_sensor_entities(struct fimc_md *fmd)
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

