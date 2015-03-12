Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48964 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753891AbbCLJ7S (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Mar 2015 05:59:18 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: dri-devel@lists.freedesktop.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: David Airlie <airlied@linux.ie>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Boris Brezillion <boris.brezillon@free-electrons.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Steve Longerbeam <slongerbeam@gmail.com>,
	Russell King <rmk+kernel@arm.linux.org.uk>,
	Emil Renner Berthing <kernel@esmil.dk>,
	linux-media@vger.kernel.org, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v3 08/10] drm/imx: imx-ldb: add drm_panel support
Date: Thu, 12 Mar 2015 10:58:14 +0100
Message-Id: <1426154296-30665-9-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1426154296-30665-1-git-send-email-p.zabel@pengutronix.de>
References: <1426154296-30665-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch allows to optionally attach the lvds-channel to a panel
supported by a drm_panel driver using of-graph bindings, instead of
supplying the modes via display-timings in the device tree.

This depends on of_graph_get_port_by_id and uses the OF graph to
link the optional DRM panel to the LDB lvds-channel. The output
port number is 1 on devices without the 4-port input multiplexer
(i.MX5) and 4 on devices with the mux (i.MX6).

Before:

	ldb {
		...

		lvds-channel@0 {
			...

			display-timings {
				native-timing = <&timing1>;
				timing1: etm0700g0dh6 {
					hactive = <800>;
					vactive = <480>;
					clock-frequency = <33260000>;
					hsync-len = <128>;
					hback-porch = <88>;
					hfront-porch = <40>;
					vsync-len = <2>;
					vback-porch = <33>;
					vfront-porch = <10>;
					hsync-active = <0>;
					vsync-active = <0>;
					...
				};
			};
			...
		};
	};

After:
	ldb {
		...

		lvds-channel@0 {
			...

			port@4 {
				reg = <4>;

				lvds_out: endpoint {
					remote_endpoint = <&panel_in>;
				};
			};
		};
	};

	panel {
		compatible = "edt,etm0700g0dh6", "simple-panel";
		...

		port {
			panel_in: endpoint {
				remote-endpoint = <&lvds_out>;
			};
		};
	};

[Fixed build error due to missing select on DRM_PANEL --rmk]
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
Changes since v2:
 - Improved documentation (wording, spelling and syntax fixes)
---
 Documentation/devicetree/bindings/drm/imx/ldb.txt | 62 ++++++++++++++++-------
 drivers/gpu/drm/imx/Kconfig                       |  1 +
 drivers/gpu/drm/imx/imx-ldb.c                     | 48 +++++++++++++++++-
 3 files changed, 90 insertions(+), 21 deletions(-)

diff --git a/Documentation/devicetree/bindings/drm/imx/ldb.txt b/Documentation/devicetree/bindings/drm/imx/ldb.txt
index 443bcb6..9a21366 100644
--- a/Documentation/devicetree/bindings/drm/imx/ldb.txt
+++ b/Documentation/devicetree/bindings/drm/imx/ldb.txt
@@ -44,23 +44,30 @@ Optional properties:
 LVDS Channel
 ============
 
-Each LVDS Channel has to contain a display-timings node that describes the
-video timings for the connected LVDS display. For detailed information, also
-have a look at Documentation/devicetree/bindings/video/display-timing.txt.
+Each LVDS Channel has to contain either an of graph link to a panel device node
+or a display-timings node that describes the video timings for the connected
+LVDS display as well as the fsl,data-mapping and fsl,data-width properties.
 
 Required properties:
  - reg : should be <0> or <1>
+ - port: Input and output port nodes with endpoint definitions as defined in
+   Documentation/devicetree/bindings/graph.txt.
+   On i.MX5, the internal two-input-multiplexer is used. Due to hardware
+   limitations, only one input port (port@[0,1]) can be used for each channel
+   (lvds-channel@[0,1], respectively).
+   On i.MX6, there should be four input ports (port@[0-3]) that correspond
+   to the four LVDS multiplexer inputs.
+   A single output port (port@2 on i.MX5, port@4 on i.MX6) must be connected
+   to a panel input port. Optionally, the output port can be left out if
+   display-timings are used instead.
+
+Optional properties (required if display-timings are used):
+ - display-timings : A node that describes the display timings as defined in
+   Documentation/devicetree/bindings/video/display-timing.txt.
  - fsl,data-mapping : should be "spwg" or "jeida"
                       This describes how the color bits are laid out in the
                       serialized LVDS signal.
  - fsl,data-width : should be <18> or <24>
- - port: A port node with endpoint definitions as defined in
-   Documentation/devicetree/bindings/media/video-interfaces.txt.
-   On i.MX5, the internal two-input-multiplexer is used.
-   Due to hardware limitations, only one port (port@[0,1])
-   can be used for each channel (lvds-channel@[0,1], respectively)
-   On i.MX6, there should be four ports (port@[0-3]) that correspond
-   to the four LVDS multiplexer inputs.
 
 example:
 
@@ -73,23 +80,21 @@ ldb: ldb@53fa8008 {
 	#size-cells = <0>;
 	compatible = "fsl,imx53-ldb";
 	gpr = <&gpr>;
-	clocks = <&clks 122>, <&clks 120>,
-		 <&clks 115>, <&clks 116>,
-		 <&clks 123>, <&clks 85>;
+	clocks = <&clks IMX5_CLK_LDB_DI0_SEL>,
+		 <&clks IMX5_CLK_LDB_DI1_SEL>,
+		 <&clks IMX5_CLK_IPU_DI0_SEL>,
+		 <&clks IMX5_CLK_IPU_DI1_SEL>,
+		 <&clks IMX5_CLK_LDB_DI0_GATE>,
+		 <&clks IMX5_CLK_LDB_DI1_GATE>;
 	clock-names = "di0_pll", "di1_pll",
 		      "di0_sel", "di1_sel",
 		      "di0", "di1";
 
+	/* Using an of-graph endpoint link to connect the panel */
 	lvds-channel@0 {
 		#address-cells = <1>;
 		#size-cells = <0>;
 		reg = <0>;
-		fsl,data-mapping = "spwg";
-		fsl,data-width = <24>;
-
-		display-timings {
-			/* ... */
-		};
 
 		port@0 {
 			reg = <0>;
@@ -98,8 +103,17 @@ ldb: ldb@53fa8008 {
 				remote-endpoint = <&ipu_di0_lvds0>;
 			};
 		};
+
+		port@2 {
+			reg = <2>;
+
+			lvds0_out: endpoint {
+				remote-endpoint = <&panel_in>;
+			};
+		};
 	};
 
+	/* Using display-timings and fsl,data-mapping/width instead */
 	lvds-channel@1 {
 		#address-cells = <1>;
 		#size-cells = <0>;
@@ -120,3 +134,13 @@ ldb: ldb@53fa8008 {
 		};
 	};
 };
+
+panel: lvds-panel {
+	/* ... */
+
+	port {
+		panel_in: endpoint {
+			remote-endpoint = <&lvds0_out>;
+		};
+	};
+};
diff --git a/drivers/gpu/drm/imx/Kconfig b/drivers/gpu/drm/imx/Kconfig
index 33cdddf..2b81a41 100644
--- a/drivers/gpu/drm/imx/Kconfig
+++ b/drivers/gpu/drm/imx/Kconfig
@@ -36,6 +36,7 @@ config DRM_IMX_TVE
 config DRM_IMX_LDB
 	tristate "Support for LVDS displays"
 	depends on DRM_IMX && MFD_SYSCON
+	select DRM_PANEL
 	help
 	  Choose this to enable the internal LVDS Display Bridge (LDB)
 	  found on i.MX53 and i.MX6 processors.
diff --git a/drivers/gpu/drm/imx/imx-ldb.c b/drivers/gpu/drm/imx/imx-ldb.c
index cd062b1..4286399 100644
--- a/drivers/gpu/drm/imx/imx-ldb.c
+++ b/drivers/gpu/drm/imx/imx-ldb.c
@@ -19,10 +19,11 @@
 #include <drm/drmP.h>
 #include <drm/drm_fb_helper.h>
 #include <drm/drm_crtc_helper.h>
+#include <drm/drm_panel.h>
 #include <linux/mfd/syscon.h>
 #include <linux/mfd/syscon/imx6q-iomuxc-gpr.h>
-#include <linux/of_address.h>
 #include <linux/of_device.h>
+#include <linux/of_graph.h>
 #include <video/of_videomode.h>
 #include <linux/regmap.h>
 #include <linux/videodev2.h>
@@ -55,6 +56,7 @@ struct imx_ldb_channel {
 	struct imx_ldb *ldb;
 	struct drm_connector connector;
 	struct drm_encoder encoder;
+	struct drm_panel *panel;
 	struct device_node *child;
 	int chno;
 	void *edid;
@@ -91,6 +93,13 @@ static int imx_ldb_connector_get_modes(struct drm_connector *connector)
 	struct imx_ldb_channel *imx_ldb_ch = con_to_imx_ldb_ch(connector);
 	int num_modes = 0;
 
+	if (imx_ldb_ch->panel && imx_ldb_ch->panel->funcs &&
+	    imx_ldb_ch->panel->funcs->get_modes) {
+		num_modes = imx_ldb_ch->panel->funcs->get_modes(imx_ldb_ch->panel);
+		if (num_modes > 0)
+			return num_modes;
+	}
+
 	if (imx_ldb_ch->edid) {
 		drm_mode_connector_update_edid_property(connector,
 							imx_ldb_ch->edid);
@@ -190,6 +199,8 @@ static void imx_ldb_encoder_commit(struct drm_encoder *encoder)
 	int dual = ldb->ldb_ctrl & LDB_SPLIT_MODE_EN;
 	int mux = imx_drm_encoder_get_mux_id(imx_ldb_ch->child, encoder);
 
+	drm_panel_prepare(imx_ldb_ch->panel);
+
 	if (dual) {
 		clk_prepare_enable(ldb->clk[0]);
 		clk_prepare_enable(ldb->clk[1]);
@@ -223,6 +234,8 @@ static void imx_ldb_encoder_commit(struct drm_encoder *encoder)
 	}
 
 	regmap_write(ldb->regmap, IOMUXC_GPR2, ldb->ldb_ctrl);
+
+	drm_panel_enable(imx_ldb_ch->panel);
 }
 
 static void imx_ldb_encoder_mode_set(struct drm_encoder *encoder,
@@ -287,6 +300,8 @@ static void imx_ldb_encoder_disable(struct drm_encoder *encoder)
 		 (ldb->ldb_ctrl & LDB_CH1_MODE_EN_MASK) == 0)
 		return;
 
+	drm_panel_disable(imx_ldb_ch->panel);
+
 	if (imx_ldb_ch == &ldb->channel[0])
 		ldb->ldb_ctrl &= ~LDB_CH0_MODE_EN_MASK;
 	else if (imx_ldb_ch == &ldb->channel[1])
@@ -298,6 +313,8 @@ static void imx_ldb_encoder_disable(struct drm_encoder *encoder)
 		clk_disable_unprepare(ldb->clk[0]);
 		clk_disable_unprepare(ldb->clk[1]);
 	}
+
+	drm_panel_unprepare(imx_ldb_ch->panel);
 }
 
 static struct drm_connector_funcs imx_ldb_connector_funcs = {
@@ -371,6 +388,9 @@ static int imx_ldb_register(struct drm_device *drm,
 	drm_connector_init(drm, &imx_ldb_ch->connector,
 			   &imx_ldb_connector_funcs, DRM_MODE_CONNECTOR_LVDS);
 
+	if (imx_ldb_ch->panel)
+		drm_panel_attach(imx_ldb_ch->panel, &imx_ldb_ch->connector);
+
 	drm_mode_connector_attach_encoder(&imx_ldb_ch->connector,
 			&imx_ldb_ch->encoder);
 
@@ -485,6 +505,7 @@ static int imx_ldb_bind(struct device *dev, struct device *master, void *data)
 
 	for_each_child_of_node(np, child) {
 		struct imx_ldb_channel *channel;
+		struct device_node *port;
 
 		ret = of_property_read_u32(child, "reg", &i);
 		if (ret || i < 0 || i > 1)
@@ -503,11 +524,34 @@ static int imx_ldb_bind(struct device *dev, struct device *master, void *data)
 		channel->chno = i;
 		channel->child = child;
 
+		/*
+		 * The output port is port@4 with an external 4-port mux or
+		 * port@2 with the internal 2-port mux.
+		 */
+		port = of_graph_get_port_by_id(child, imx_ldb->lvds_mux ? 4 : 2);
+		if (port) {
+			struct device_node *endpoint, *remote;
+
+			endpoint = of_get_child_by_name(port, "endpoint");
+			if (endpoint) {
+				remote = of_graph_get_remote_port_parent(endpoint);
+				if (remote)
+					channel->panel = of_drm_find_panel(remote);
+				else
+					return -EPROBE_DEFER;
+				if (!channel->panel) {
+					dev_err(dev, "panel not found: %s\n",
+						remote->full_name);
+					return -EPROBE_DEFER;
+				}
+			}
+		}
+
 		edidp = of_get_property(child, "edid", &channel->edid_len);
 		if (edidp) {
 			channel->edid = kmemdup(edidp, channel->edid_len,
 						GFP_KERNEL);
-		} else {
+		} else if (!channel->panel) {
 			ret = of_get_drm_display_mode(child, &channel->mode, 0);
 			if (!ret)
 				channel->mode_valid = 1;
-- 
2.1.4

