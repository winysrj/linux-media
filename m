Return-path: <linux-media-owner@vger.kernel.org>
Received: from us01smtprelay-2.synopsys.com ([198.182.47.9]:35996 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731787AbeITRDz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Sep 2018 13:03:55 -0400
From: Luis Oliveira <Luis.Oliveira@synopsys.com>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Joao.Pinto@synopsys.com, festevam@gmail.com,
        Luis Oliveira <Luis.Oliveira@synopsys.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Luis Oliveira <luis.oliveira@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Jacob Chen <jacob-chen@iotwrt.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Thierry Reding <treding@nvidia.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Todor Tomov <todor.tomov@linaro.org>
Subject: [V2, 5/5] media: platform: dwc: Add MIPI CSI-2 controller driver
Date: Thu, 20 Sep 2018 13:16:43 +0200
Message-Id: <20180920111648.27000-6-lolivei@synopsys.com>
In-Reply-To: <20180920111648.27000-1-lolivei@synopsys.com>
References: <20180920111648.27000-1-lolivei@synopsys.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the Synopsys MIPI CSI-2 controller driver. This
controller driver is divided in platform dependent functions
and core functions. It also includes a platform for future
DesignWare drivers.

Signed-off-by: Luis Oliveira <lolivei@synopsys.com>
---
Changelog
v2:
- fix SDPX License to match: Documentation/process/license-rules.rst

 MAINTAINERS                              |  11 +
 drivers/media/platform/dwc/Kconfig       |  11 +
 drivers/media/platform/dwc/Makefile      |   2 +
 drivers/media/platform/dwc/dw-csi-plat.c | 508 +++++++++++++++++++++++++++++++
 drivers/media/platform/dwc/dw-csi-plat.h |  76 +++++
 drivers/media/platform/dwc/dw-mipi-csi.c | 490 +++++++++++++++++++++++++++++
 drivers/media/platform/dwc/dw-mipi-csi.h | 202 ++++++++++++
 include/media/dwc/dw-mipi-csi-pltfrm.h   | 101 ++++++
 8 files changed, 1401 insertions(+)
 create mode 100644 drivers/media/platform/dwc/dw-csi-plat.c
 create mode 100644 drivers/media/platform/dwc/dw-csi-plat.h
 create mode 100644 drivers/media/platform/dwc/dw-mipi-csi.c
 create mode 100644 drivers/media/platform/dwc/dw-mipi-csi.h
 create mode 100644 include/media/dwc/dw-mipi-csi-pltfrm.h

diff --git a/MAINTAINERS b/MAINTAINERS
index da2e509..fd5f1fc 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14032,6 +14032,16 @@ S:	Maintained
 F:	drivers/dma/dwi-axi-dmac/
 F:	Documentation/devicetree/bindings/dma/snps,dw-axi-dmac.txt
 
+SYNOPSYS DESIGNWARE MIPI CSI-2 HOST VIDEO PLATFORM
+M:	Luis Oliveira <luis.oliveira@synopsys.com>
+L:	linux-media@vger.kernel.org
+T:	git git://linuxtv.org/media_tree.git
+S:	Maintained
+F:	drivers/media/platform/dwc
+F:	include/media/dwc/dw-mipi-csi-pltfrm.h
+F:	Documentation/devicetree/bindings/media/snps,dw-csi-plat.txt
+F:	Documentation/devicetree/bindings/phy/snps,dphy-rx.txt
+
 SYNOPSYS DESIGNWARE DMAC DRIVER
 M:	Viresh Kumar <vireshk@kernel.org>
 R:	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
@@ -16217,3 +16227,4 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
 S:	Buried alive in reporters
 F:	*
 F:	*/
+
diff --git a/drivers/media/platform/dwc/Kconfig b/drivers/media/platform/dwc/Kconfig
index a573297..4b971a6 100644
--- a/drivers/media/platform/dwc/Kconfig
+++ b/drivers/media/platform/dwc/Kconfig
@@ -20,6 +20,17 @@ config DWC_MIPI_CSI2_HOST
 
 if DWC_MIPI_CSI2_HOST
 
+config DWC_MIPI_CSI2_HOST_PLATFORM
+	tristate "Platform bus based CSI-2 Host Controller support"
+	depends on HAS_DMA
+	help
+	 This selects the CSI-2 host controller support. Select this if
+	 you have an CSI-2 Host controller on Platform bus.
+
+	 If you have a controller with this interface, say Y or M here.
+
+	  If unsure, say N.
+
 config DWC_MIPI_TC_DPHY_G128
 	tristate "DesignWare platform support using a G128 Test Chip"
 	depends on DWC_MIPI_CSI2_HOST
diff --git a/drivers/media/platform/dwc/Makefile b/drivers/media/platform/dwc/Makefile
index 8be6f68..e19cede 100644
--- a/drivers/media/platform/dwc/Makefile
+++ b/drivers/media/platform/dwc/Makefile
@@ -1,2 +1,4 @@
+obj-$(CONFIG_DWC_MIPI_CSI2_HOST_PLATFORM)	+= dw-csi-platfrm.o
+dw-csi-platfrm-objs		:= dw-csi-plat.o dw-mipi-csi.o
 obj-$(CONFIG_DWC_MIPI_TC_DPHY_G128)	+= dw-dphy-platfrm.o
 dw-dphy-platfrm-objs	:= dw-dphy-plat.o dw-dphy-rx.o
diff --git a/drivers/media/platform/dwc/dw-csi-plat.c b/drivers/media/platform/dwc/dw-csi-plat.c
new file mode 100644
index 0000000..012830e
--- /dev/null
+++ b/drivers/media/platform/dwc/dw-csi-plat.c
@@ -0,0 +1,508 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * dw-csi-plat.c
+ *
+ * Copyright(c) 2018-present, Synopsys, Inc. and/or its affiliates.
+ * Luis Oliveira <Luis.Oliveira@synopsys.com>
+ *
+ */
+
+#include "dw-csi-plat.h"
+
+static const struct mipi_fmt *
+find_dw_mipi_csi_format(struct v4l2_mbus_framefmt *mf)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(dw_mipi_csi_formats); i++)
+		if (mf->code == dw_mipi_csi_formats[i].code)
+			return &dw_mipi_csi_formats[i];
+	return NULL;
+}
+
+static int dw_mipi_csi_enum_mbus_code(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_mbus_code_enum *code)
+{
+	if (code->index >= ARRAY_SIZE(dw_mipi_csi_formats))
+		return -EINVAL;
+
+	code->code = dw_mipi_csi_formats[code->index].code;
+	return 0;
+}
+
+static struct mipi_fmt const *
+dw_mipi_csi_try_format(struct v4l2_mbus_framefmt *mf)
+{
+	struct mipi_fmt const *fmt;
+
+	fmt = find_dw_mipi_csi_format(mf);
+	if (fmt == NULL)
+		fmt = &dw_mipi_csi_formats[0];
+
+	mf->code = fmt->code;
+	return fmt;
+}
+
+static struct v4l2_mbus_framefmt *
+dw_mipi_csi_get_format(struct mipi_csi_dev *dev,
+		struct v4l2_subdev_pad_config *cfg,
+		enum v4l2_subdev_format_whence which)
+{
+	if (which == V4L2_SUBDEV_FORMAT_TRY)
+		return cfg ? v4l2_subdev_get_try_format(&dev->sd, cfg,
+							0) : NULL;
+
+	return &dev->format;
+}
+
+static int
+dw_mipi_csi_set_fmt(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_format *fmt)
+{
+	struct mipi_csi_dev *dev = sd_to_mipi_csi_dev(sd);
+	struct mipi_fmt const *dev_fmt;
+	struct v4l2_mbus_framefmt *mf;
+	unsigned int i = 0;
+	const struct v4l2_bt_timings *bt_r = &v4l2_dv_timings_presets[0].bt;
+
+	mf = dw_mipi_csi_get_format(dev, cfg, fmt->which);
+
+	dev_fmt = dw_mipi_csi_try_format(&fmt->format);
+	if (dev_fmt) {
+		*mf = fmt->format;
+		if (fmt->which == V4L2_SUBDEV_FORMAT_ACTIVE)
+			dev->fmt = dev_fmt;
+		dw_mipi_csi_set_ipi_fmt(dev);
+	}
+	while (v4l2_dv_timings_presets[i].bt.width) {
+		const struct v4l2_bt_timings *bt =
+		    &v4l2_dv_timings_presets[i].bt;
+		if (mf->width == bt->width && mf->height == bt->width) {
+			dw_mipi_csi_fill_timings(dev, bt);
+			return 0;
+		}
+		i++;
+	}
+
+	dw_mipi_csi_fill_timings(dev, bt_r);
+	return 0;
+
+}
+
+static int
+dw_mipi_csi_get_fmt(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_format *fmt)
+{
+	struct mipi_csi_dev *dev = sd_to_mipi_csi_dev(sd);
+	struct v4l2_mbus_framefmt *mf;
+
+	mf = dw_mipi_csi_get_format(dev, cfg, fmt->which);
+	if (!mf)
+		return -EINVAL;
+
+	mutex_lock(&dev->lock);
+	fmt->format = *mf;
+	mutex_unlock(&dev->lock);
+	return 0;
+}
+
+static int
+dw_mipi_csi_s_power(struct v4l2_subdev *sd, int on)
+{
+	struct mipi_csi_dev *dev = sd_to_mipi_csi_dev(sd);
+
+	if (on) {
+		dw_mipi_csi_hw_stdby(dev);
+		dw_mipi_csi_start(dev);
+	} else {
+		phy_power_off(dev->phy);
+		dw_mipi_csi_mask_irq_power_off(dev);
+	}
+	return 0;
+}
+
+static int
+dw_mipi_csi_init_cfg(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cfg)
+{
+	struct v4l2_mbus_framefmt *format =
+	    v4l2_subdev_get_try_format(sd, cfg, 0);
+
+	format->colorspace = V4L2_COLORSPACE_SRGB;
+	format->code = dw_mipi_csi_formats[0].code;
+	format->width = MIN_WIDTH;
+	format->height = MIN_HEIGHT;
+	format->field = V4L2_FIELD_NONE;
+
+	return 0;
+}
+
+static struct v4l2_subdev_core_ops dw_mipi_csi_core_ops = {
+	.s_power = dw_mipi_csi_s_power,
+};
+
+static struct v4l2_subdev_pad_ops dw_mipi_csi_pad_ops = {
+	.init_cfg =	dw_mipi_csi_init_cfg,
+	.enum_mbus_code = dw_mipi_csi_enum_mbus_code,
+	.get_fmt = dw_mipi_csi_get_fmt,
+	.set_fmt = dw_mipi_csi_set_fmt,
+};
+
+static struct v4l2_subdev_ops dw_mipi_csi_subdev_ops = {
+	.core = &dw_mipi_csi_core_ops,
+	.pad = &dw_mipi_csi_pad_ops,
+};
+
+static irqreturn_t dw_mipi_csi_irq1(int irq, void *dev_id)
+{
+	struct mipi_csi_dev *csi_dev = dev_id;
+
+	dw_mipi_csi_irq_handler(csi_dev);
+
+	return IRQ_HANDLED;
+}
+
+static int
+dw_mipi_csi_parse_dt(struct platform_device *pdev, struct mipi_csi_dev *dev)
+{
+	struct device_node *node = pdev->dev.of_node;
+	struct v4l2_fwnode_endpoint endpoint;
+	int ret;
+
+	ret = of_property_read_u32(node, "snps,output-type", &dev->hw.output);
+	if (ret) {
+		dev_err(&pdev->dev, "Couldn't read output-type\n");
+		return ret;
+	}
+
+	ret = of_property_read_u32(node, "snps,ipi-mode", &dev->hw.ipi_mode);
+	if (ret) {
+		dev_err(&pdev->dev, "Couldn't read ipi-mode\n");
+		return ret;
+	}
+
+	ret = of_property_read_u32(node, "snps,ipi-auto-flush",
+				 &dev->hw.ipi_auto_flush);
+	if (ret) {
+		dev_err(&pdev->dev, "Couldn't read ipi-auto-flush\n");
+		return ret;
+	}
+
+	ret = of_property_read_u32(node, "snps,ipi-color-mode",
+				 &dev->hw.ipi_color_mode);
+	if (ret) {
+		dev_err(&pdev->dev, "Couldn't read ipi-color-mode\n");
+		return ret;
+	}
+
+	ret = of_property_read_u32(node, "snps,virtual-channel",
+				&dev->hw.virtual_ch);
+	if (ret) {
+		dev_err(&pdev->dev, "Couldn't read virtual-channel\n");
+		return ret;
+	}
+
+	node = of_graph_get_next_endpoint(node, NULL);
+	if (!node) {
+		dev_err(&pdev->dev, "No port node at %s\n",
+				pdev->dev.of_node->full_name);
+		return -EINVAL;
+	}
+
+	ret = v4l2_fwnode_endpoint_parse(of_fwnode_handle(node), &endpoint);
+	if (ret)
+		goto err;
+
+	dev->index = endpoint.base.port - 1;
+	if (dev->index >= CSI_MAX_ENTITIES) {
+		ret = -ENXIO;
+		goto err;
+	}
+	dev->hw.num_lanes = endpoint.bus.mipi_csi2.num_data_lanes;
+
+err:
+	of_node_put(node);
+	return ret;
+}
+
+static ssize_t csih_version_show(struct device *dev,
+						struct device_attribute *attr,
+						char *buf)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct v4l2_subdev *sd = platform_get_drvdata(pdev);
+	struct mipi_csi_dev *csi_dev = sd_to_mipi_csi_dev(sd);
+
+	char buffer[10];
+
+	snprintf(buffer, 10, "v.%d.%d*\n", csi_dev->hw_version_major,
+					csi_dev->hw_version_minor);
+
+	return strlcpy(buf, buffer, PAGE_SIZE);
+}
+
+static ssize_t n_lanes_store(struct device *dev, struct device_attribute *attr,
+				const char *buf, size_t count)
+{
+	int ret;
+	unsigned long lanes;
+
+	struct platform_device *pdev = to_platform_device(dev);
+	struct v4l2_subdev *sd = platform_get_drvdata(pdev);
+	struct mipi_csi_dev *csi_dev = sd_to_mipi_csi_dev(sd);
+
+	ret = kstrtoul(buf, 10, &lanes);
+	if (ret < 0)
+		return ret;
+
+	if (lanes > 8) {
+		dev_err(dev, "Invalid number of lanes %lu\n", lanes);
+		return count;
+	}
+
+	dev_info(dev, "Lanes %lu\n", lanes);
+	csi_dev->hw.num_lanes = lanes;
+
+	return count;
+}
+static ssize_t n_lanes_show(struct device *dev,
+		struct device_attribute *attr,
+		char *buf)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct v4l2_subdev *sd = platform_get_drvdata(pdev);
+	struct mipi_csi_dev *csi_dev = sd_to_mipi_csi_dev(sd);
+
+	char buffer[10];
+
+	snprintf(buffer, 10, "Lanes %d\n", csi_dev->hw.num_lanes);
+
+	return strlcpy(buf, buffer, PAGE_SIZE);
+}
+
+static ssize_t csih_reset_show(struct device *dev,
+		struct device_attribute *attr,
+		char *buf)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct v4l2_subdev *sd = platform_get_drvdata(pdev);
+	struct mipi_csi_dev *csi_dev = sd_to_mipi_csi_dev(sd);
+
+	char buffer[10];
+
+	/* Reset Controller and DPHY */
+	phy_reset(csi_dev->phy);
+	dw_mipi_csi_reset(csi_dev);
+
+	snprintf(buffer, 10, "Reset\n");
+
+	return strlcpy(buf, buffer, PAGE_SIZE);
+}
+
+static ssize_t dt_store(struct device *dev,
+		struct device_attribute *attr,
+		const char *buf, size_t count)
+{
+	int ret;
+	unsigned long dt;
+
+	struct platform_device *pdev = to_platform_device(dev);
+	struct v4l2_subdev *sd = platform_get_drvdata(pdev);
+	struct mipi_csi_dev *csi_dev = sd_to_mipi_csi_dev(sd);
+
+	ret = kstrtoul(buf, 16, &dt);
+	if (ret < 0)
+		return ret;
+
+	if ((dt < 0x18) || (dt > 0x2F)) {
+		dev_err(dev, "Invalid data type %lx\n", dt);
+		return count;
+	}
+
+	dev_info(dev, "Data type %lx\n", dt);
+	csi_dev->ipi_dt = dt;
+
+	return count;
+}
+
+static ssize_t dt_show(struct device *dev,
+		struct device_attribute *attr,
+		char *buf)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct v4l2_subdev *sd = platform_get_drvdata(pdev);
+	struct mipi_csi_dev *csi_dev = sd_to_mipi_csi_dev(sd);
+
+	char buffer[10];
+
+	snprintf(buffer, 10, "DT %x\n", csi_dev->ipi_dt);
+
+	return strlcpy(buf, buffer, PAGE_SIZE);
+}
+
+static DEVICE_ATTR_RO(csih_version);
+static DEVICE_ATTR_RO(csih_reset);
+static DEVICE_ATTR_RW(n_lanes);
+static DEVICE_ATTR_RW(dt);
+
+static const struct of_device_id dw_mipi_csi_of_match[];
+
+static int csi_plat_probe(struct platform_device *pdev)
+{
+	const struct of_device_id *of_id;
+	struct device *dev = &pdev->dev;
+	struct resource *res = NULL;
+	struct mipi_csi_dev *mipi_csi;
+	int ret = -ENOMEM;
+
+	mipi_csi = devm_kzalloc(dev, sizeof(*mipi_csi), GFP_KERNEL);
+	if (!dev)
+		return -ENOMEM;
+
+	mutex_init(&mipi_csi->lock);
+	spin_lock_init(&mipi_csi->slock);
+	mipi_csi->dev = dev;
+
+	of_id = of_match_node(dw_mipi_csi_of_match, dev->of_node);
+	if (WARN_ON(of_id == NULL))
+		return -EINVAL;
+
+	ret = dw_mipi_csi_parse_dt(pdev, mipi_csi);
+	if (ret < 0)
+		return ret;
+
+	mipi_csi->phy = devm_of_phy_get(dev, dev->of_node, NULL);
+	if (IS_ERR(mipi_csi->phy)) {
+		dev_err(dev, "No DPHY available\n");
+		return PTR_ERR(mipi_csi->phy);
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	mipi_csi->base_address = devm_ioremap_resource(dev, res);
+
+	if (IS_ERR(mipi_csi->base_address)) {
+		dev_err(dev, "Base address not set.\n");
+		return PTR_ERR(mipi_csi->base_address);
+	}
+
+	mipi_csi->ctrl_irq_number = platform_get_irq(pdev, 0);
+	if (mipi_csi->ctrl_irq_number <= 0) {
+		dev_err(dev, "IRQ number not set.\n");
+		return mipi_csi->ctrl_irq_number;
+	}
+
+	mipi_csi->rst = devm_reset_control_get_optional_shared(dev, NULL);
+	if (IS_ERR(mipi_csi->rst)) {
+		ret = PTR_ERR(mipi_csi->rst);
+		dev_err(dev, "error getting reset control %d\n", ret);
+		return ret;
+	}
+
+	ret = devm_request_irq(dev, mipi_csi->ctrl_irq_number,
+			       dw_mipi_csi_irq1, IRQF_SHARED,
+			       dev_name(dev), mipi_csi);
+	if (ret) {
+		dev_err(dev, "IRQ failed\n");
+		goto end;
+	}
+
+	v4l2_subdev_init(&mipi_csi->sd, &dw_mipi_csi_subdev_ops);
+	mipi_csi->sd.owner = THIS_MODULE;
+	snprintf(mipi_csi->sd.name, sizeof(mipi_csi->sd.name), "%s.%d",
+		 CSI_HOST_NAME, mipi_csi->index);
+	mipi_csi->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+	mipi_csi->fmt = &dw_mipi_csi_formats[0];
+
+	mipi_csi->format.code = dw_mipi_csi_formats[0].code;
+	mipi_csi->format.width = MIN_WIDTH;
+	mipi_csi->format.height = MIN_HEIGHT;
+
+	mipi_csi->sd.entity.function = MEDIA_ENT_F_IO_V4L;
+	mipi_csi->pads[CSI_PAD_SINK].flags = MEDIA_PAD_FL_SINK;
+	mipi_csi->pads[CSI_PAD_SOURCE].flags = MEDIA_PAD_FL_SOURCE;
+	ret = media_entity_pads_init(&mipi_csi->sd.entity,
+				     CSI_PADS_NUM, mipi_csi->pads);
+
+	if (ret < 0) {
+		dev_err(dev, "Media Entity init failed\n");
+		goto entity_cleanup;
+	}
+
+	v4l2_set_subdevdata(&mipi_csi->sd, pdev);
+
+	platform_set_drvdata(pdev, &mipi_csi->sd);
+
+	device_create_file(&pdev->dev, &dev_attr_csih_version);
+	device_create_file(&pdev->dev, &dev_attr_csih_reset);
+	device_create_file(&pdev->dev, &dev_attr_n_lanes);
+	device_create_file(&pdev->dev, &dev_attr_dt);
+
+	if (mipi_csi->rst)
+		reset_control_deassert(mipi_csi->rst);
+
+	dw_mipi_csi_get_version(mipi_csi);
+	dw_mipi_csi_specific_mappings(mipi_csi);
+	dw_mipi_csi_mask_irq_power_off(mipi_csi);
+
+	dev_info(dev, "DW MIPI CSI-2 Host registered successfully HW v%u.%u\n",
+		mipi_csi->hw_version_major, mipi_csi->hw_version_minor);
+	return 0;
+
+entity_cleanup:
+	media_entity_cleanup(&mipi_csi->sd.entity);
+end:
+	return ret;
+}
+
+/**
+ * @short Exit routine - Exit point of the driver
+ * @param[in] pdev pointer to the platform device structure
+ * @return 0 on success and a negative number on failure
+ * Refer to Linux errors.
+ */
+static int csi_plat_remove(struct platform_device *pdev)
+{
+	struct v4l2_subdev *sd = platform_get_drvdata(pdev);
+	struct mipi_csi_dev *mipi_csi = sd_to_mipi_csi_dev(sd);
+
+	dev_dbg(&pdev->dev, "Removing MIPI CSI-2 module\n");
+
+	if (mipi_csi->rst)
+		reset_control_assert(mipi_csi->rst);
+
+	media_entity_cleanup(&mipi_csi->sd.entity);
+
+	return 0;
+}
+
+/**
+ * @short of_device_id structure
+ */
+static const struct of_device_id dw_mipi_csi_of_match[] = {
+	{
+	 .compatible = "snps,dw-csi-plat"},
+	{ /* sentinel */ },
+};
+
+MODULE_DEVICE_TABLE(of, dw_mipi_csi_of_match);
+
+/**
+ * @short Platform driver structure
+ */
+static struct platform_driver __refdata dw_mipi_csi_pdrv = {
+	.remove = csi_plat_remove,
+	.probe = csi_plat_probe,
+	.driver = {
+		   .name = CSI_HOST_NAME,
+		   .owner = THIS_MODULE,
+		   .of_match_table = dw_mipi_csi_of_match,
+		   },
+};
+
+module_platform_driver(dw_mipi_csi_pdrv);
+
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Luis Oliveira <lolivei@synopsys.com>");
+MODULE_DESCRIPTION("Synopsys DesignWare MIPI CSI-2 Host Platform driver");
diff --git a/drivers/media/platform/dwc/dw-csi-plat.h b/drivers/media/platform/dwc/dw-csi-plat.h
new file mode 100644
index 0000000..d504f5d
--- /dev/null
+++ b/drivers/media/platform/dwc/dw-csi-plat.h
@@ -0,0 +1,76 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+/*
+ * dw-csi-plat.h
+ *
+ * Copyright(c) 2018-present, Synopsys, Inc. and/or its affiliates.
+ * Luis Oliveira <Luis.Oliveira@synopsys.com>
+ *
+ */
+
+#ifndef _DW_CSI_PLAT_H__
+#define _DW_CSI_PLAT_H__
+
+#include <linux/delay.h>
+#include <linux/errno.h>
+#include <linux/io.h>
+#include <linux/interrupt.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of_irq.h>
+#include <linux/of_graph.h>
+#include <linux/platform_device.h>
+#include <linux/ratelimit.h>
+#include <linux/reset.h>
+#include <linux/string.h>
+#include <linux/types.h>
+#include <linux/videodev2.h>
+#include <linux/wait.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-dv-timings.h>
+#include <media/v4l2-fwnode.h>
+#include <media/v4l2-subdev.h>
+
+#include "dw-mipi-csi.h"
+
+#define CSI_HOST_NAME	"dw-mipi-csi"
+
+/* Video formats supported by the MIPI CSI-2 */
+const struct mipi_fmt dw_mipi_csi_formats[] = {
+	{
+		/* RAW 8 */
+		.code = MEDIA_BUS_FMT_SBGGR8_1X8,
+		.depth = 8,
+	},
+	{
+		/* RAW 10 */
+		.code = MEDIA_BUS_FMT_SBGGR10_2X8_PADHI_BE,
+		.depth = 10,
+	},
+	{
+		/* RGB 565 */
+		.code = MEDIA_BUS_FMT_RGB565_2X8_BE,
+		.depth = 16,
+	},
+	{
+		/* BGR 565 */
+		.code = MEDIA_BUS_FMT_RGB565_2X8_LE,
+		.depth = 16,
+	},
+	{
+		/* RGB 888 */
+		.code = MEDIA_BUS_FMT_RGB888_2X12_LE,
+		.depth = 24,
+	},
+	{
+		/* BGR 888 */
+		.code = MEDIA_BUS_FMT_RGB888_2X12_BE,
+		.depth = 24,
+	},
+};
+
+static inline struct mipi_csi_dev *sd_to_mipi_csi_dev(struct v4l2_subdev *sdev)
+{
+	return container_of(sdev, struct mipi_csi_dev, sd);
+}
+
+#endif	/* _DW_CSI_PLAT_H__ */
diff --git a/drivers/media/platform/dwc/dw-mipi-csi.c b/drivers/media/platform/dwc/dw-mipi-csi.c
new file mode 100644
index 0000000..578998a
--- /dev/null
+++ b/drivers/media/platform/dwc/dw-mipi-csi.c
@@ -0,0 +1,490 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * dw-mipi-csi.c
+ *
+ * Copyright(c) 2018-present, Synopsys, Inc. and/or its affiliates.
+ * Luis Oliveira <Luis.Oliveira@synopsys.com>
+ *
+ */
+
+#include "dw-mipi-csi.h"
+
+static struct R_CSI2 reg = {
+	.VERSION = 0x00,
+	.N_LANES = 0x04,
+	.CTRL_RESETN = 0x08,
+	.INTERRUPT = 0x0C,
+	.DATA_IDS_1	= 0x10,
+	.DATA_IDS_2	= 0x14,
+	.IPI_MODE = 0x80,
+	.IPI_VCID = 0x84,
+	.IPI_DATA_TYPE = 0x88,
+	.IPI_MEM_FLUSH = 0x8C,
+	.IPI_HSA_TIME = 0x90,
+	.IPI_HBP_TIME = 0x94,
+	.IPI_HSD_TIME = 0x98,
+	.IPI_HLINE_TIME = 0x9C,
+	.IPI_SOFTRSTN = 0xA0,
+	.IPI_ADV_FEATURES = 0xAC,
+	.IPI_VSA_LINES = 0xB0,
+	.IPI_VBP_LINES = 0xB4,
+	.IPI_VFP_LINES = 0xB8,
+	.IPI_VACTIVE_LINES = 0xBC,
+	.INT_PHY_FATAL = 0xe0,
+	.MASK_INT_PHY_FATAL = 0xe4,
+	.FORCE_INT_PHY_FATAL = 0xe8,
+	.INT_PKT_FATAL = 0xf0,
+	.MASK_INT_PKT_FATAL = 0xf4,
+	.FORCE_INT_PKT_FATAL = 0xf8,
+	.INT_PHY = 0x110,
+	.MASK_INT_PHY = 0x114,
+	.FORCE_INT_PHY = 0x118,
+	.INT_LINE = 0x130,
+	.MASK_INT_LINE = 0x134,
+	.FORCE_INT_LINE = 0x138,
+	.INT_IPI = 0x140,
+	.MASK_INT_IPI = 0x144,
+	.FORCE_INT_IPI = 0x148,
+};
+struct interrupt_type csi_int = {
+	.PHY_FATAL = BIT(0),
+	.PKT_FATAL = BIT(1),
+	.PHY = BIT(16),
+};
+static void dw_mipi_csi_write(struct mipi_csi_dev *dev,
+		  unsigned int address, unsigned int data)
+{
+	iowrite32(data, dev->base_address + address);
+}
+
+static u32 dw_mipi_csi_read(struct mipi_csi_dev *dev, unsigned long address)
+{
+	return ioread32(dev->base_address + address);
+}
+
+void dw_mipi_csi_write_part(struct mipi_csi_dev *dev,
+		       unsigned long address, unsigned long data,
+		       unsigned char shift, unsigned char width)
+{
+	u32 mask = (1 << width) - 1;
+	u32 temp = dw_mipi_csi_read(dev, address);
+
+	temp &= ~(mask << shift);
+	temp |= (data & mask) << shift;
+	dw_mipi_csi_write(dev, address, temp);
+}
+
+void dw_mipi_csi_reset(struct mipi_csi_dev *csi_dev)
+{
+	dw_mipi_csi_write(csi_dev, reg.CTRL_RESETN, 0);
+	usleep_range(100, 200);
+	dw_mipi_csi_write(csi_dev, reg.CTRL_RESETN, 1);
+}
+
+int dw_mipi_csi_mask_irq_power_off(struct mipi_csi_dev *csi_dev)
+{
+	if ((csi_dev->hw_version_major) == 1) {
+
+		/* set only one lane (lane 0) as active (ON) */
+		dw_mipi_csi_write(csi_dev, reg.N_LANES, 0);
+		dw_mipi_csi_write(csi_dev, reg.MASK_INT_PHY_FATAL, 0);
+		dw_mipi_csi_write(csi_dev, reg.MASK_INT_PKT_FATAL, 0);
+		dw_mipi_csi_write(csi_dev, reg.MASK_INT_PHY, 0);
+		dw_mipi_csi_write(csi_dev, reg.MASK_INT_PKT, 0);
+		dw_mipi_csi_write(csi_dev, reg.MASK_INT_LINE, 0);
+		dw_mipi_csi_write(csi_dev, reg.MASK_INT_IPI, 0);
+
+		/* only for version 1.30 */
+		if ((csi_dev->hw_version_minor) == 30)
+			dw_mipi_csi_write(csi_dev, reg.MASK_INT_FRAME_FATAL, 0);
+
+		dw_mipi_csi_write(csi_dev, reg.CTRL_RESETN, 0);
+
+		/* only for version 1.40 */
+		if ((csi_dev->hw_version_minor) == 40) {
+			dw_mipi_csi_write(csi_dev,
+					reg.MSK_BNDRY_FRAME_FATAL, 0);
+			dw_mipi_csi_write(csi_dev, reg.MSK_SEQ_FRAME_FATAL, 0);
+			dw_mipi_csi_write(csi_dev, reg.MSK_CRC_FRAME_FATAL, 0);
+			dw_mipi_csi_write(csi_dev, reg.MSK_PLD_CRC_FATAL, 0);
+			dw_mipi_csi_write(csi_dev, reg.MSK_DATA_ID, 0);
+			dw_mipi_csi_write(csi_dev, reg.MSK_ECC_CORRECT, 0);
+		}
+	}
+
+	return 0;
+}
+
+int dw_mipi_csi_hw_stdby(struct mipi_csi_dev *csi_dev)
+{
+	if ((csi_dev->hw_version_major) == 1) {
+
+		/* set only one lane (lane 0) as active (ON) */
+		dw_mipi_csi_reset(csi_dev);
+		dw_mipi_csi_write(csi_dev, reg.N_LANES, 0);
+		phy_init(csi_dev->phy);
+
+		/* only for version 1.30 */
+		if ((csi_dev->hw_version_minor) == 30)
+			dw_mipi_csi_write(csi_dev,
+					reg.MASK_INT_FRAME_FATAL, 0xFFFFFFFF);
+
+		/* common */
+		dw_mipi_csi_write(csi_dev, reg.MASK_INT_PHY_FATAL, 0xFFFFFFFF);
+		dw_mipi_csi_write(csi_dev, reg.MASK_INT_PKT_FATAL, 0xFFFFFFFF);
+		dw_mipi_csi_write(csi_dev, reg.MASK_INT_PHY, 0xFFFFFFFF);
+		dw_mipi_csi_write(csi_dev, reg.MASK_INT_PKT, 0xFFFFFFFF);
+		dw_mipi_csi_write(csi_dev, reg.MASK_INT_LINE, 0xFFFFFFFF);
+		dw_mipi_csi_write(csi_dev, reg.MASK_INT_IPI, 0xFFFFFFFF);
+
+		/* only for version 1.40 */
+		if ((csi_dev->hw_version_minor) == 40) {
+			dw_mipi_csi_write(csi_dev,
+					reg.MSK_BNDRY_FRAME_FATAL, 0xFFFFFFFF);
+			dw_mipi_csi_write(csi_dev,
+					reg.MSK_SEQ_FRAME_FATAL, 0xFFFFFFFF);
+			dw_mipi_csi_write(csi_dev,
+					reg.MSK_CRC_FRAME_FATAL, 0xFFFFFFFF);
+			dw_mipi_csi_write(csi_dev,
+					reg.MSK_PLD_CRC_FATAL, 0xFFFFFFFF);
+			dw_mipi_csi_write(csi_dev, reg.MSK_DATA_ID, 0xFFFFFFFF);
+			dw_mipi_csi_write(csi_dev,
+					reg.MSK_ECC_CORRECT, 0xFFFFFFFF);
+		}
+	}
+	return 0;
+}
+
+void dw_mipi_csi_set_ipi_fmt(struct mipi_csi_dev *csi_dev)
+{
+	struct device *dev = csi_dev->dev;
+
+	if (csi_dev->ipi_dt)
+		dw_mipi_csi_write(csi_dev, reg.IPI_DATA_TYPE, csi_dev->ipi_dt);
+	else {
+		switch (csi_dev->fmt->code) {
+		case MEDIA_BUS_FMT_RGB565_2X8_BE:
+		case MEDIA_BUS_FMT_RGB565_2X8_LE:
+			dw_mipi_csi_write(csi_dev,
+					reg.IPI_DATA_TYPE, CSI_2_RGB565);
+			dev_dbg(dev, "DT: RGB 565");
+			break;
+
+		case MEDIA_BUS_FMT_RGB888_2X12_LE:
+		case MEDIA_BUS_FMT_RGB888_2X12_BE:
+			dw_mipi_csi_write(csi_dev,
+					reg.IPI_DATA_TYPE, CSI_2_RGB888);
+			dev_dbg(dev, "DT: RGB 888");
+			break;
+		case MEDIA_BUS_FMT_SBGGR10_2X8_PADHI_BE:
+			dw_mipi_csi_write(csi_dev,
+					reg.IPI_DATA_TYPE, CSI_2_RAW10);
+			dev_dbg(dev, "DT: RAW 10");
+			break;
+		case MEDIA_BUS_FMT_SBGGR8_1X8:
+			dw_mipi_csi_write(csi_dev,
+					reg.IPI_DATA_TYPE, CSI_2_RAW8);
+			dev_dbg(dev, "DT: RAW 8");
+			break;
+		default:
+			dw_mipi_csi_write(csi_dev,
+					reg.IPI_DATA_TYPE, CSI_2_RGB565);
+			dev_dbg(dev, "Error");
+			break;
+		}
+	}
+}
+
+void dw_mipi_csi_fill_timings(struct mipi_csi_dev *dev,
+			   const struct v4l2_bt_timings *bt)
+{
+	if (bt == NULL)
+		return;
+
+	dev->hw.hsa = bt->hsync;
+	dev->hw.hbp = bt->hbackporch;
+	dev->hw.hsd = bt->hsync;
+	dev->hw.htotal = bt->height + bt->vfrontporch +
+	    bt->vsync + bt->vbackporch;
+	dev->hw.vsa = bt->vsync;
+	dev->hw.vbp = bt->vbackporch;
+	dev->hw.vfp = bt->vfrontporch;
+	dev->hw.vactive = bt->height;
+}
+
+void dw_mipi_csi_start(struct mipi_csi_dev *csi_dev)
+{
+	const struct v4l2_bt_timings *bt = &v4l2_dv_timings_presets[0].bt;
+	struct device *dev = csi_dev->dev;
+
+	dw_mipi_csi_fill_timings(csi_dev, bt);
+	dw_mipi_csi_write(csi_dev, reg.N_LANES, (csi_dev->hw.num_lanes - 1));
+	dev_dbg(dev, "N Lanes: %d\n", csi_dev->hw.num_lanes);
+
+	/* IPI Related Configuration */
+	if ((csi_dev->hw.output == IPI_OUT)
+		|| (csi_dev->hw.output == BOTH_OUT)) {
+
+		if (csi_dev->hw_version_major >= 1) {
+			if (csi_dev->hw_version_minor >= 20)
+				dw_mipi_csi_write(csi_dev,
+					reg.IPI_ADV_FEATURES, 0x30000);
+
+			if (csi_dev->hw_version_minor >= 30)
+				dw_mipi_csi_write(csi_dev,
+					reg.IPI_SOFTRSTN, 0x1);
+		}
+		/*  address | data, | shift | width */
+		dw_mipi_csi_write_part(csi_dev, reg.IPI_MODE, 1, 24, 1);
+		dw_mipi_csi_write_part(csi_dev,
+					reg.IPI_MODE,
+					csi_dev->hw.ipi_mode,
+					0, 1);
+
+		dw_mipi_csi_write_part(csi_dev,
+					reg.IPI_MODE,
+					csi_dev->hw.ipi_color_mode,
+					8, 1);
+
+		dw_mipi_csi_write_part(csi_dev,
+					reg.IPI_VCID,
+					csi_dev->hw.virtual_ch,
+					0, 2);
+
+		dw_mipi_csi_write_part(csi_dev,
+					reg.IPI_MEM_FLUSH,
+					csi_dev->hw.ipi_auto_flush,
+					8, 1);
+
+		dw_mipi_csi_write(csi_dev,
+					reg.IPI_HSA_TIME, csi_dev->hw.hsa);
+
+		dw_mipi_csi_write(csi_dev,
+					reg.IPI_HBP_TIME, csi_dev->hw.hbp);
+
+		dw_mipi_csi_write(csi_dev,
+					reg.IPI_HSD_TIME, csi_dev->hw.hsd);
+
+		dev_dbg(dev, "IPI enable\n");
+		dev_dbg(dev, "IPI MODE: %d\n", csi_dev->hw.ipi_mode);
+		dev_dbg(dev, "Color Mode: %d\n", csi_dev->hw.ipi_color_mode);
+		dev_dbg(dev, "Virtual Channel: %d\n", csi_dev->hw.virtual_ch);
+		dev_dbg(dev, "Auto-flush: %d\n", csi_dev->hw.ipi_auto_flush);
+		dev_dbg(dev, "HSA: %d\n", csi_dev->hw.hsa);
+		dev_dbg(dev, "HBP: %d\n", csi_dev->hw.hbp);
+		dev_dbg(dev, "HSD: %d\n", csi_dev->hw.hsd);
+
+		if (csi_dev->hw.ipi_mode == AUTO_TIMING) {
+			dw_mipi_csi_write(csi_dev,
+				reg.IPI_HLINE_TIME, csi_dev->hw.htotal);
+			dw_mipi_csi_write(csi_dev,
+				reg.IPI_VSA_LINES, csi_dev->hw.vsa);
+			dw_mipi_csi_write(csi_dev,
+				reg.IPI_VBP_LINES, csi_dev->hw.vbp);
+			dw_mipi_csi_write(csi_dev,
+				reg.IPI_VFP_LINES, csi_dev->hw.vfp);
+			dw_mipi_csi_write(csi_dev,
+				reg.IPI_VACTIVE_LINES, csi_dev->hw.vactive);
+			dev_dbg(dev,
+				"Horizontal Total: %d\n", csi_dev->hw.htotal);
+			dev_dbg(dev,
+				"Vertical Sync Active: %d\n", csi_dev->hw.vsa);
+			dev_dbg(dev,
+				"Vertical Back Porch: %d\n", csi_dev->hw.vbp);
+			dev_dbg(dev,
+				"Vertical Front Porch: %d\n", csi_dev->hw.vfp);
+			dev_dbg(dev,
+				"Vertical Active: %d\n", csi_dev->hw.vactive);
+		}
+	}
+	phy_power_on(csi_dev->phy);
+}
+
+int dw_mipi_csi_irq_handler(struct mipi_csi_dev *csi_dev)
+{
+	struct device *dev = csi_dev->dev;
+	u32 global_int_status, i_sts;
+	unsigned long flags;
+
+	global_int_status = dw_mipi_csi_read(csi_dev, reg.INTERRUPT);
+	spin_lock_irqsave(&csi_dev->slock, flags);
+
+	if (global_int_status & csi_int.PHY_FATAL) {
+		i_sts = dw_mipi_csi_read(csi_dev, reg.INT_PHY_FATAL);
+		dev_err_ratelimited(dev,
+			"interrupt %08X: PHY FATAL: %08X\n",
+			reg.INT_PHY_FATAL, i_sts);
+	}
+
+	if (global_int_status & csi_int.PKT_FATAL) {
+		i_sts = dw_mipi_csi_read(csi_dev, reg.INT_PKT_FATAL);
+		dev_err_ratelimited(dev,
+			"interrupt %08X: PKT FATAL: %08X\n",
+			reg.INT_PKT_FATAL, i_sts);
+	}
+
+	if ((global_int_status & csi_int.FRAME_FATAL)
+	&& ((csi_dev->hw_version_major) == 1)
+	&& ((csi_dev->hw_version_minor) == 30)) {
+		i_sts = dw_mipi_csi_read(csi_dev, reg.INT_FRAME_FATAL);
+			dev_err_ratelimited(dev,
+			"interrupt %08X: FRAME FATAL: %08X\n",
+			reg.INT_FRAME_FATAL, i_sts);
+	}
+
+	if (global_int_status & csi_int.PHY) {
+		i_sts = dw_mipi_csi_read(csi_dev, reg.INT_PHY);
+		dev_err_ratelimited(dev,
+			"interrupt %08X: PHY: %08X\n",
+			reg.INT_PHY, i_sts);
+	}
+
+	if (global_int_status & csi_int.PKT) {
+		i_sts = dw_mipi_csi_read(csi_dev, reg.INT_PKT);
+		dev_err_ratelimited(dev,
+			"interrupt %08X: PKT: %08X\n",
+			reg.INT_PKT, i_sts);
+	}
+
+	if (global_int_status & csi_int.LINE) {
+		i_sts = dw_mipi_csi_read(csi_dev, reg.INT_LINE);
+		dev_err_ratelimited(dev,
+			"interrupt %08X: LINE: %08X\n",
+			reg.INT_LINE, i_sts);
+	}
+
+	if (global_int_status & csi_int.IPI) {
+		i_sts = dw_mipi_csi_read(csi_dev, reg.INT_IPI);
+		dev_err_ratelimited(dev,
+			"interrupt %08X: IPI: %08X\n",
+			reg.INT_IPI, i_sts);
+	}
+
+	if (global_int_status & csi_int.BNDRY_FRAME_FATAL) {
+		i_sts = dw_mipi_csi_read(csi_dev, reg.ST_BNDRY_FRAME_FATAL);
+		dev_err_ratelimited(dev,
+			"interrupt %08X: ST_BNDRY_FRAME_FATAL: %08X\n",
+			reg.ST_BNDRY_FRAME_FATAL, i_sts);
+	}
+
+	if (global_int_status & csi_int.SEQ_FRAME_FATAL) {
+		i_sts = dw_mipi_csi_read(csi_dev, reg.ST_SEQ_FRAME_FATAL);
+		dev_err_ratelimited(dev,
+			"interrupt %08X: ST_SEQ_FRAME_FATAL: %08X\n",
+			reg.ST_SEQ_FRAME_FATAL, i_sts);
+	}
+
+	if (global_int_status & csi_int.CRC_FRAME_FATAL) {
+		i_sts = dw_mipi_csi_read(csi_dev, reg.ST_CRC_FRAME_FATAL);
+		dev_err_ratelimited(dev,
+			"interrupt %08X: ST_CRC_FRAME_FATAL: %08X\n",
+			reg.ST_CRC_FRAME_FATAL, i_sts);
+	}
+
+	if (global_int_status & csi_int.PLD_CRC_FATAL) {
+		i_sts = dw_mipi_csi_read(csi_dev, reg.ST_PLD_CRC_FATAL);
+		dev_err_ratelimited(dev,
+			"interrupt %08X: ST_PLD_CRC_FATAL: %08X\n",
+			reg.ST_PLD_CRC_FATAL, i_sts);
+	}
+
+	if (global_int_status & csi_int.DATA_ID) {
+		i_sts = dw_mipi_csi_read(csi_dev, reg.ST_DATA_ID);
+		dev_err_ratelimited(dev,
+			"interrupt %08X: ST_DATA_ID: %08X\n",
+			reg.ST_DATA_ID, i_sts);
+	}
+
+	if (global_int_status & csi_int.ECC_CORRECTED) {
+		i_sts = dw_mipi_csi_read(csi_dev, reg.ST_ECC_CORRECT);
+		dev_err_ratelimited(dev,
+			"interrupt %08X: ST_ECC_CORRECT: %08X\n",
+			reg.ST_ECC_CORRECT, i_sts);
+	}
+
+	spin_unlock_irqrestore(&csi_dev->slock, flags);
+
+	return 1;
+}
+
+void dw_mipi_csi_get_version(struct mipi_csi_dev *csi_dev)
+{
+	uint32_t hw_version;
+
+	hw_version = dw_mipi_csi_read(csi_dev, reg.VERSION);
+	csi_dev->hw_version_major = (uint8_t) ((hw_version >> 24) - '0');
+	csi_dev->hw_version_minor = (uint8_t) ((hw_version >> 16) - '0');
+	csi_dev->hw_version_minor = csi_dev->hw_version_minor * 10;
+	csi_dev->hw_version_minor += (uint8_t) ((hw_version >> 8) - '0');
+}
+
+int dw_mipi_csi_specific_mappings(struct mipi_csi_dev *csi_dev)
+{
+	struct device *dev = csi_dev->dev;
+
+	if ((csi_dev->hw_version_major) == 1)
+		if ((csi_dev->hw_version_minor) == 30) {
+
+			dev_dbg(dev, "We are version 30");
+			/*
+			 * Hardware registers that were
+			 * exclusive to version < 1.40
+			 */
+			reg.INT_FRAME_FATAL = 0x100;
+			reg.MASK_INT_FRAME_FATAL = 0x104;
+			reg.FORCE_INT_FRAME_FATAL = 0x108;
+			reg.INT_PKT = 0x120;
+			reg.MASK_INT_PKT = 0x124;
+			reg.FORCE_INT_PKT = 0x128;
+
+			/* interrupt source present until this release */
+			csi_int.PKT = BIT(17);
+			csi_int.LINE = BIT(18);
+			csi_int.IPI = BIT(19);
+			csi_int.FRAME_FATAL = BIT(2);
+
+		} else if ((csi_dev->hw_version_minor) == 40) {
+			dev_dbg(dev, "We are version 40");
+			/*
+			 * HW registers that were added
+			 * to version 1.40
+			 */
+			reg.ST_BNDRY_FRAME_FATAL = 0x280;
+			reg.MSK_BNDRY_FRAME_FATAL = 0x284;
+			reg.FORCE_BNDRY_FRAME_FATAL	= 0x288;
+			reg.ST_SEQ_FRAME_FATAL = 0x290;
+			reg.MSK_SEQ_FRAME_FATAL	= 0x294;
+			reg.FORCE_SEQ_FRAME_FATAL = 0x298;
+			reg.ST_CRC_FRAME_FATAL = 0x2a0;
+			reg.MSK_CRC_FRAME_FATAL	= 0x2a4;
+			reg.FORCE_CRC_FRAME_FATAL = 0x2a8;
+			reg.ST_PLD_CRC_FATAL = 0x2b0;
+			reg.MSK_PLD_CRC_FATAL = 0x2b4;
+			reg.FORCE_PLD_CRC_FATAL = 0x2b8;
+			reg.ST_DATA_ID = 0x2c0;
+			reg.MSK_DATA_ID = 0x2c4;
+			reg.FORCE_DATA_ID = 0x2c8;
+			reg.ST_ECC_CORRECT = 0x2d0;
+			reg.MSK_ECC_CORRECT = 0x2d4;
+			reg.FORCE_ECC_CORRECT = 0x2d8;
+			reg.DATA_IDS_VC_1 = 0x0;
+			reg.DATA_IDS_VC_2 = 0x0;
+			reg.VC_EXTENSION = 0x0;
+
+			/* interrupts map were changed */
+			csi_int.LINE = BIT(17);
+			csi_int.IPI = BIT(18);
+			csi_int.BNDRY_FRAME_FATAL = BIT(2);
+			csi_int.SEQ_FRAME_FATAL	= BIT(3);
+			csi_int.CRC_FRAME_FATAL = BIT(4);
+			csi_int.PLD_CRC_FATAL = BIT(5);
+			csi_int.DATA_ID = BIT(6);
+			csi_int.ECC_CORRECTED = BIT(7);
+
+		} else
+			dev_info(dev, "Version minor not supported.");
+	else
+		dev_info(dev, "Version major not supported.");
+
+	return 0;
+}
diff --git a/drivers/media/platform/dwc/dw-mipi-csi.h b/drivers/media/platform/dwc/dw-mipi-csi.h
new file mode 100644
index 0000000..2119027
--- /dev/null
+++ b/drivers/media/platform/dwc/dw-mipi-csi.h
@@ -0,0 +1,202 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+/*
+ * DWC MIPI CSI-2 Host device driver
+ *
+ * Copyright (C) 2018 Synopsys, Inc. All rights reserved.
+ * Author: Luis Oliveira <Luis.Oliveira@synopsys.com>
+ *
+ */
+
+#ifndef _DW_MIPI_CSI_H__
+#define _DW_MIPI_CSI_H__
+
+#include <linux/delay.h>
+#include <linux/kernel.h>
+#include <linux/io.h>
+#include <linux/phy/phy.h>
+#include <media/v4l2-dv-timings.h>
+#include <media/dwc/dw-mipi-csi-pltfrm.h>
+
+/* DW MIPI CSI-2 register addresses*/
+
+struct R_CSI2 {
+	u16 VERSION;
+	u16 N_LANES;
+	u16 CTRL_RESETN;
+	u16 INTERRUPT;
+	u16 DATA_IDS_1;
+	u16 DATA_IDS_2;
+	u16 DATA_IDS_VC_1;
+	u16 DATA_IDS_VC_2;
+	u16 IPI_MODE;
+	u16 IPI_VCID;
+	u16 IPI_DATA_TYPE;
+	u16 IPI_MEM_FLUSH;
+	u16 IPI_HSA_TIME;
+	u16 IPI_HBP_TIME;
+	u16 IPI_HSD_TIME;
+	u16 IPI_HLINE_TIME;
+	u16 IPI_SOFTRSTN;
+	u16 IPI_ADV_FEATURES;
+	u16 IPI_VSA_LINES;
+	u16 IPI_VBP_LINES;
+	u16 IPI_VFP_LINES;
+	u16 IPI_VACTIVE_LINES;
+	u16 VC_EXTENSION;
+	u16 INT_PHY_FATAL;
+	u16 MASK_INT_PHY_FATAL;
+	u16 FORCE_INT_PHY_FATAL;
+	u16 INT_PKT_FATAL;
+	u16 MASK_INT_PKT_FATAL;
+	u16 FORCE_INT_PKT_FATAL;
+	u16 INT_FRAME_FATAL;
+	u16 MASK_INT_FRAME_FATAL;
+	u16 FORCE_INT_FRAME_FATAL;
+	u16 INT_PHY;
+	u16 MASK_INT_PHY;
+	u16 FORCE_INT_PHY;
+	u16 INT_PKT;
+	u16 MASK_INT_PKT;
+	u16 FORCE_INT_PKT;
+	u16 INT_LINE;
+	u16 MASK_INT_LINE;
+	u16 FORCE_INT_LINE;
+	u16 INT_IPI;
+	u16 MASK_INT_IPI;
+	u16 FORCE_INT_IPI;
+	u16 ST_BNDRY_FRAME_FATAL;
+	u16 MSK_BNDRY_FRAME_FATAL;
+	u16 FORCE_BNDRY_FRAME_FATAL;
+	u16 ST_SEQ_FRAME_FATAL;
+	u16 MSK_SEQ_FRAME_FATAL;
+	u16 FORCE_SEQ_FRAME_FATAL;
+	u16 ST_CRC_FRAME_FATAL;
+	u16 MSK_CRC_FRAME_FATAL;
+	u16 FORCE_CRC_FRAME_FATAL;
+	u16 ST_PLD_CRC_FATAL;
+	u16 MSK_PLD_CRC_FATAL;
+	u16 FORCE_PLD_CRC_FATAL;
+	u16 ST_DATA_ID;
+	u16 MSK_DATA_ID;
+	u16 FORCE_DATA_ID;
+	u16 ST_ECC_CORRECT;
+	u16 MSK_ECC_CORRECT;
+	u16 FORCE_ECC_CORRECT;
+};
+/* Interrupt Masks */
+struct interrupt_type {
+	u32 PHY_FATAL;
+	u32 PKT_FATAL;
+	u32 FRAME_FATAL;
+	u32 PHY;
+	u32 PKT;
+	u32 LINE;
+	u32 IPI;
+	u32 BNDRY_FRAME_FATAL;
+	u32 SEQ_FRAME_FATAL;
+	u32 CRC_FRAME_FATAL;
+	u32 PLD_CRC_FATAL;
+	u32 DATA_ID;
+	u32 ECC_CORRECTED;
+};
+
+/* IPI Data Types */
+enum data_type {
+	CSI_2_YUV420_8 = 0x18,
+	CSI_2_YUV420_10 = 0x19,
+	CSI_2_YUV420_8_LEG = 0x1A,
+	CSI_2_YUV420_8_SHIFT = 0x1C,
+	CSI_2_YUV420_10_SHIFT = 0x1D,
+	CSI_2_YUV422_8 = 0x1E,
+	CSI_2_YUV422_10 = 0x1F,
+	CSI_2_RGB444 = 0x20,
+	CSI_2_RGB555 = 0x21,
+	CSI_2_RGB565 = 0x22,
+	CSI_2_RGB666 = 0x23,
+	CSI_2_RGB888 = 0x24,
+	CSI_2_RAW6 = 0x28,
+	CSI_2_RAW7 = 0x29,
+	CSI_2_RAW8 = 0x2A,
+	CSI_2_RAW10 = 0x2B,
+	CSI_2_RAW12 = 0x2C,
+	CSI_2_RAW14 = 0x2D,
+};
+
+/* DWC MIPI CSI-2 output types */
+enum output {
+	IPI_OUT = 0,
+	IDI_OUT = 1,
+	BOTH_OUT = 2
+};
+
+/* IPI output types */
+enum ipi_output {
+	CAMERA_TIMING = 0,
+	AUTO_TIMING = 1
+};
+
+/* Format template */
+struct mipi_fmt {
+	u32 code;
+	u8 depth;
+};
+
+/* CSI specific configuration */
+struct csi_hw {
+
+	uint32_t num_lanes;
+	uint32_t output;
+	uint32_t ipi_mode;
+	uint32_t ipi_color_mode;
+	uint32_t ipi_auto_flush;
+	uint32_t virtual_ch;
+	uint32_t hsa;
+	uint32_t hbp;
+	uint32_t hsd;
+	uint32_t htotal;
+	uint32_t vsa;
+	uint32_t vbp;
+	uint32_t vfp;
+	uint32_t vactive;
+};
+
+/* Structure to embed device driver information */
+struct mipi_csi_dev {
+	struct v4l2_subdev sd;
+	struct video_device vdev;
+	struct device *dev;
+
+	struct mutex lock;
+	spinlock_t slock;
+	struct media_pad pads[CSI_PADS_NUM];
+	u8 index;
+
+	/* Store current format */
+	const struct mipi_fmt *fmt;
+	struct v4l2_mbus_framefmt format;
+
+	/* Device Tree Information */
+	void __iomem *base_address;
+	uint32_t ctrl_irq_number;
+
+	struct csi_hw hw;
+	struct phy *phy;
+	struct reset_control *rst;
+
+	u8 ipi_dt;
+	u8 hw_version_major;
+	u16 hw_version_minor;
+};
+
+void dw_mipi_csi_reset(struct mipi_csi_dev *csi_dev);
+int dw_mipi_csi_mask_irq_power_off(struct mipi_csi_dev *csi_dev);
+int dw_mipi_csi_hw_stdby(struct mipi_csi_dev *csi_dev);
+void dw_mipi_csi_set_ipi_fmt(struct mipi_csi_dev *csi_dev);
+void dw_mipi_csi_start(struct mipi_csi_dev *csi_dev);
+int dw_mipi_csi_irq_handler(struct mipi_csi_dev *csi_dev);
+void dw_mipi_csi_get_version(struct mipi_csi_dev *csi_dev);
+int dw_mipi_csi_specific_mappings(struct mipi_csi_dev *csi_dev);
+void dw_mipi_csi_fill_timings(struct mipi_csi_dev *dev,
+		const struct v4l2_bt_timings *bt);
+
+#endif /*_DW_MIPI_CSI_H__ */
diff --git a/include/media/dwc/dw-mipi-csi-pltfrm.h b/include/media/dwc/dw-mipi-csi-pltfrm.h
new file mode 100644
index 0000000..a7cc494
--- /dev/null
+++ b/include/media/dwc/dw-mipi-csi-pltfrm.h
@@ -0,0 +1,101 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+/*
+ * CSI-2 Video platform video library
+ *
+ * Copyright (C) 2018 Synopsys, Inc. All rights reserved.
+ * Author: Luis Oliveira <Luis.Oliveira@synopsys.com>
+ *
+ */
+
+#ifndef __DW_MIPI_CSI_PLTFRM_INCLUDES_H_
+#define __DW_MIPI_CSI_PLTFRM_INCLUDES_H_
+
+#include <media/media-entity.h>
+#include <media/v4l2-dev.h>
+#include <media/v4l2-mediabus.h>
+#include <media/v4l2-subdev.h>
+
+#define MAX_WIDTH	3280
+#define MAX_HEIGHT	1852
+#define MIN_WIDTH	640
+#define MIN_HEIGHT	480
+
+/* The subdevices' group IDs. */
+#define GRP_ID_SENSOR		(10)
+#define GRP_ID_CSI		(20)
+#define GRP_ID_VIF		(30)
+#define GRP_ID_VIDEODEV		(40)
+
+#define CSI_MAX_ENTITIES	(2)
+#define VIF_MAX_ENTITIES	(2)
+#define PLAT_MAX_SENSORS	(2)
+
+enum video_dev_pads {
+	VIDEO_DEV_SD_PAD_SINK_VIF1	= 0,
+	VIDEO_DEV_SD_PAD_SINK_VIF2	= 1,
+	VIDEO_DEV_SD_PAD_SOURCE_DMA	= 2,
+	VIDEO_DEV_SD_PADS_NUM		= 3,
+};
+enum vif_pads {
+	VIF_PAD_SINK_CSI		= 0,
+	VIF_PAD_SOURCE_DMA		= 1,
+	VIF_PADS_NUM			= 2,
+};
+
+enum mipi_csi_pads {
+	CSI_PAD_SINK			= 0,
+	CSI_PAD_SOURCE			= 1,
+	CSI_PADS_NUM			= 2,
+};
+
+struct plat_csi_source_info {
+	u16 flags;
+	u16 mux_id;
+};
+
+struct plat_csi_fmt {
+	char *name;
+	u32 mbus_code;
+	u32 fourcc;
+	u8 depth;
+};
+
+struct plat_csi_media_pipeline;
+
+/*
+ * Media pipeline operations to be called from within a video node,  i.e. the
+ * last entity within the pipeline. Implemented by related media device driver.
+ */
+struct plat_csi_media_pipeline_ops {
+	int (*prepare)(struct plat_csi_media_pipeline *p,
+		struct media_entity *me);
+	int (*unprepare)(struct plat_csi_media_pipeline *p);
+	int (*open)(struct plat_csi_media_pipeline *p, struct media_entity *me,
+		bool resume);
+	int (*close)(struct plat_csi_media_pipeline *p);
+	int (*set_stream)(struct plat_csi_media_pipeline *p, bool state);
+	int (*set_format)(struct plat_csi_media_pipeline *p,
+		struct v4l2_subdev_format *fmt);
+};
+
+struct plat_csi_video_entity {
+	struct video_device vdev;
+	struct plat_csi_media_pipeline *pipe;
+};
+
+struct plat_csi_media_pipeline {
+	struct media_pipeline mp;
+	const struct plat_csi_media_pipeline_ops *ops;
+};
+
+static inline struct plat_csi_video_entity
+*vdev_to_plat_csi_video_entity(struct video_device *vdev)
+{
+	return container_of(vdev, struct plat_csi_video_entity, vdev);
+}
+
+#define plat_csi_pipeline_call(ent, op, args...)			  \
+	(!(ent) ? -ENOENT : (((ent)->pipe->ops && (ent)->pipe->ops->op) ? \
+	(ent)->pipe->ops->op(((ent)->pipe), ##args) : -ENOIOCTLCMD))	  \
+
+#endif /* __DW_MIPI_CSI_PLTFRM_INCLUDES_H_ */
-- 
2.9.3
