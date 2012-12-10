Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:17329 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338Ab2LJTqk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Dec 2012 14:46:40 -0500
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, grant.likely@secretlab.ca,
	rob.herring@calxeda.com, thomas.abraham@linaro.org,
	t.figa@samsung.com, sw0312.kim@samsung.com,
	kyungmin.park@samsung.com, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC 05/12] s5p-fimc: Add device tree based sensors registration
Date: Mon, 10 Dec 2012 20:45:59 +0100
Message-id: <1355168766-6068-6-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1355168766-6068-1-git-send-email-s.nawrocki@samsung.com>
References: <1355168766-6068-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The sensor (I2C and/or SPI client) devices are instantiated by their
corresponding control bus controllers. Since their master clock is
often provided by a video bus receiver (host interface) or other than
I2C/SPI controller device, the drivers of those client devices are
not accessing hardware in their driver's probe() callback. Instead,
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
 .../devicetree/bindings/media/soc/samsung-fimc.txt |   75 +++++++++
 drivers/media/platform/s5p-fimc/fimc-mdevice.c     |  168 +++++++++++++++++---
 2 files changed, 217 insertions(+), 26 deletions(-)

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
index 2657e90..ee718af 100644
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
 
@@ -260,17 +264,122 @@ static void fimc_md_unregister_sensor(struct v4l2_subdev *sd)
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
+}
+
+static int fimc_md_of_sensors_register(struct fimc_md *fmd,
+				       struct device_node *np)
+{
+	struct s5p_fimc_isp_info *pd;
+	struct device_node *node;
+	int ret, index = 0;
+
+	/* Attach sensors linked to MIPI CSI-2 receivers */
+	for_each_available_child_of_node(fmd->pdev->dev.of_node, node) {
+		struct device_node *port, *remote, *endpoint;
+		u32 tmp;
+
+		if (of_node_cmp(node->name, "csis"))
+			continue;
+		pd = &fmd->sensor[index].pdata;
+
+		if (!(port = of_get_child_by_name(node, "port")))
+			return -EINVAL;
+		if (of_property_read_u32(port, "reg", &tmp))
+			return -EINVAL;
+		pd->mux_id = tmp & 0x1;
+
+		if (!(endpoint = of_get_child_by_name(port, "endpoint")))
+			return -EINVAL;
+		if (!of_property_read_u32(endpoint, "samsung,camclk-out", &tmp))
+			pd->clk_id = tmp;
+		/*
+		 * For MIPI CSI-2 we need only sensor's clock frequency
+		 * from the remote endpoint node.
+		 */
+		remote = v4l2_of_get_remote(endpoint);
+		if (!remote)
+			return -EINVAL;
+		if (of_property_read_u32(remote, "clock-frequency", &tmp))
+			return -EINVAL;
+		pd->clk_frequency = tmp;
+
+		pd->bus_type = FIMC_MIPI_CSI2;
+		of_node_put(endpoint);
+
+		ret = fimc_md_of_add_sensor(fmd, remote, index);
+		of_node_put(remote);
+		if (ret < 0)
+			break;
+		index++;
+	}
+	/* TODO: Parse parallel-ports node */
+	return 0;
 }
 
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
@@ -281,34 +390,41 @@ static int fimc_md_register_sensor_entities(struct fimc_md *fmd)
 			fd = fmd->fimc[i];
 	if (!fd)
 		return -ENXIO;
+
 	ret = pm_runtime_get_sync(&fd->pdev->dev);
 	if (ret < 0)
 		return ret;
 
-	WARN_ON(pdata->num_clients > ARRAY_SIZE(fmd->sensor));
-	num_clients = min_t(u32, pdata->num_clients, ARRAY_SIZE(fmd->sensor));
-
-	fmd->num_sensors = num_clients;
-	for (i = 0; i < num_clients; i++) {
-		struct v4l2_subdev *sd;
+	if (of_node) {
+		fmd->num_sensors = 0;
+		ret = fimc_md_of_sensors_register(fmd, of_node);
+	} else if (pdata) {
+		WARN_ON(pdata->num_clients > ARRAY_SIZE(fmd->sensor));
+		num_clients = min_t(u32, pdata->num_clients,
+				    ARRAY_SIZE(fmd->sensor));
+		fmd->num_sensors = num_clients;
 
-		fmd->sensor[i].pdata = pdata->isp_info[i];
-		ret = __fimc_md_set_camclk(fmd, &fmd->sensor[i], true);
-		if (ret)
-			break;
-		sd = fimc_md_register_sensor(fmd, &fmd->sensor[i]);
-		ret = __fimc_md_set_camclk(fmd, &fmd->sensor[i], false);
+		for (i = 0; i < num_clients; i++) {
+			struct v4l2_subdev *sd;
 
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
@@ -995,7 +1111,7 @@ static int fimc_md_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_unlock;
 
-	if (pdev->dev.platform_data) {
+	if (pdev->dev.platform_data || pdev->dev.of_node) {
 		ret = fimc_md_register_sensor_entities(fmd);
 		if (ret)
 			goto err_unlock;
-- 
1.7.9.5

