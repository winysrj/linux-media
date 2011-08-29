Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:40753 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753928Ab1H2PHb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Aug 2011 11:07:31 -0400
Received: from dbdp20.itg.ti.com ([172.24.170.38])
	by devils.ext.ti.com (8.13.7/8.13.7) with ESMTP id p7TF7ROd031290
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Mon, 29 Aug 2011 10:07:29 -0500
From: Manjunath Hadli <manjunath.hadli@ti.com>
To: LMML <linux-media@vger.kernel.org>
CC: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>,
	Nagabhushana Netagunte <nagabhushana.netagunte@ti.com>
Subject: [PATCH v2 7/8] davinci: vpfe: v4l2 capture driver with media interface
Date: Mon, 29 Aug 2011 20:37:18 +0530
Message-ID: <1314630439-1122-8-git-send-email-manjunath.hadli@ti.com>
In-Reply-To: <1314630439-1122-1-git-send-email-manjunath.hadli@ti.com>
References: <1314630439-1122-1-git-send-email-manjunath.hadli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the vpfe capture driver which implements media controller
interface. The driver suports all the setup functionality for
all all units nnamely- ccdc, previewer, resizer, h3a, aew.
The driver supports both dm365 and Dm355.
The driver does isr registration, v4l2 device registration,
media registration and platform driver registrations.
It calls the appropriate subdevs from here to cerate the
appropriate subdevices and media entities.

Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
Signed-off-by: Nagabhushana Netagunte <nagabhushana.netagunte@ti.com>
---
 drivers/media/video/davinci/vpfe_capture.c |  793 ++++++++++++++++++
 drivers/media/video/davinci/vpfe_capture.h |  104 +++
 include/linux/davinci_vpfe.h               | 1223 ++++++++++++++++++++++++++++
 include/media/davinci/vpfe.h               |   91 ++
 4 files changed, 2211 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/davinci/vpfe_capture.c
 create mode 100644 drivers/media/video/davinci/vpfe_capture.h
 create mode 100644 include/linux/davinci_vpfe.h
 create mode 100644 include/media/davinci/vpfe.h

diff --git a/drivers/media/video/davinci/vpfe_capture.c b/drivers/media/video/davinci/vpfe_capture.c
new file mode 100644
index 0000000..62f58e9
--- /dev/null
+++ b/drivers/media/video/davinci/vpfe_capture.c
@@ -0,0 +1,793 @@
+/*
+ * Copyright (C) 2011 Texas Instruments Inc
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ *
+ * Contributors:-
+ *	Manjunath Hadli <manjunath.hadli@ti.com>
+ *	Nagabhushana Netagunte <nagabhushana.netagunte@ti.com>
+ *
+ * Driver name : VPFE Capture driver
+ *    VPFE Capture driver allows applications to capture and stream video
+ *    frames on DaVinci SoCs (DM6446, DM355 etc) from a YUV source such as
+ *    TVP5146 or  Raw Bayer RGB image data from an image sensor
+ *    such as Microns' MT9T001, MT9T031 etc.
+ *
+ *    These SoCs have, in common, a Video Processing Subsystem (VPSS) that
+ *    consists of a Video Processing Front End (VPFE) for capturing
+ *    video/raw image data and Video Processing Back End (VPBE) for displaying
+ *    YUV data through an in-built analog encoder or Digital LCD port. This
+ *    driver is for capture through VPFE. A typical EVM using these SoCs have
+ *    following high level configuration.
+ *
+ *    decoder(TVP5146/		YUV/
+ *	MT9T001)   -->  Raw Bayer RGB ---> MUX -> VPFE (CCDC/ISIF)
+ *			data input              |      |
+ *							V      |
+ *						      SDRAM    |
+ *							       V
+ *							   Image Processor
+ *							       |
+ *							       V
+ *							     SDRAM
+ *    The data flow happens from a decoder connected to the VPFE over a
+ *    YUV embedded (BT.656/BT.1120) or separate sync or raw bayer rgb interface
+ *    and to the input of VPFE through an optional MUX (if more inputs are
+ *    to be interfaced on the EVM). The input data is first passed through
+ *    CCDC (CCD Controller, a.k.a Image Sensor Interface, ISIF). The CCDC
+ *    does very little or no processing on YUV data and does pre-process Raw
+ *    Bayer RGB data through modules such as Defect Pixel Correction (DFC)
+ *    Color Space Conversion (CSC), data gain/offset etc. After this, data
+ *    can be written to SDRAM or can be connected to the image processing
+ *    block such as IPIPE (on DM355/DM365 only).
+ *
+ *    Features supported
+ *		- MMAP IO
+ *		- USERPTR IO
+ *		- Capture using TVP5146 over BT.656
+ *		- Support for interfacing decoders using sub device model
+ *		- Work with DM365 or DM355 or DM6446 CCDC to do Raw Bayer
+ *		  RGB/YUV data capture to SDRAM.
+ *		- Chaining of Image Processor
+ *		- SINGLE-SHOT mode
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+#include <linux/version.h>
+#include <linux/io.h>
+#include <linux/slab.h>
+#include <media/v4l2-common.h>
+#include <media/media-entity.h>
+#include <media/media-device.h>
+#include "vpfe_capture.h"
+
+static int debug;
+static int interface;
+static u32 cont_bufoffset;
+static u32 cont_bufsize;
+static u32 en_serializer;
+
+module_param(interface, bool, S_IRUGO);
+module_param(debug, bool, 0644);
+module_param(cont_bufoffset, uint, S_IRUGO);
+module_param(cont_bufsize, uint, S_IRUGO);
+module_param(en_serializer, uint, S_IRUGO);
+
+/**
+ * VPFE capture can be used for capturing video such as from TVP5146 or TVP7002
+ * and for capture raw bayer data from camera sensors such as mt9p031. At this
+ * point there is problem in co-existence of mt9p031 and tvp5146 due to i2c
+ * address collision. So set the variable below from bootargs to do either video
+ * capture or camera capture.
+ * interface = 0 - video capture (from TVP514x or such),
+ * interface = 1 - Camera capture (from mt9p031 or such)
+ * Re-visit this when we fix the co-existence issue
+ */
+MODULE_PARM_DESC(interface, "interface 0-1 (default:0)");
+MODULE_PARM_DESC(debug, "Debug level 0-1");
+MODULE_PARM_DESC(cont_bufoffset, "Capture buffer offset (default 0)");
+MODULE_PARM_DESC(cont_bufsize, "Capture buffer size (default 0)");
+MODULE_PARM_DESC(en_serializer, "enable IPIPE serializer (default:0)");
+
+MODULE_DESCRIPTION("VPFE Video for Linux Capture Driver");
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Texas Instruments");
+
+/* map mbus_fmt to pixelformat */
+void mbus_to_pix(const struct v4l2_mbus_framefmt *mbus,
+			   struct v4l2_pix_format *pix)
+{
+	/* TODO: revisit for other format support*/
+	switch (mbus->code) {
+	case V4L2_MBUS_FMT_UYVY8_2X8:
+		pix->pixelformat = V4L2_PIX_FMT_UYVY;
+		pix->bytesperline = pix->width * 2;
+		break;
+	case V4L2_MBUS_FMT_YUYV8_2X8:
+		pix->pixelformat = V4L2_PIX_FMT_UYVY;
+		pix->bytesperline = pix->width * 2;
+		break;
+	case V4L2_MBUS_FMT_YUYV10_1X20:
+		pix->pixelformat = V4L2_PIX_FMT_UYVY;
+		pix->bytesperline = pix->width * 2;
+		break;
+	case V4L2_MBUS_FMT_SBGGR10_1X10:
+		pix->pixelformat = V4L2_PIX_FMT_SBGGR16;
+		pix->bytesperline = pix->width * 2;
+		break;
+	default:
+		printk(KERN_ERR "invalid mbus code\n");
+	}
+
+	/* pitch should be 32 bytes aligned */
+	pix->bytesperline = ALIGN(pix->bytesperline, 32);
+
+	pix->sizeimage = pix->bytesperline * pix->height;
+}
+
+/* ISR for VINT0*/
+static irqreturn_t vpfe_isr(int irq, void *dev_id)
+{
+	struct vpfe_device *vpfe_dev = dev_id;
+
+	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_isr\n");
+
+	ccdc_buffer_isr(&vpfe_dev->vpfe_ccdc);
+
+	prv_buffer_isr(&vpfe_dev->vpfe_previewer);
+
+	rsz_buffer_isr(&vpfe_dev->vpfe_resizer);
+
+	return IRQ_HANDLED;
+}
+
+/* vpfe_vdint1_isr - isr handler for VINT1 interrupt */
+static irqreturn_t vpfe_vdint1_isr(int irq, void *dev_id)
+{
+	struct vpfe_device *vpfe_dev = dev_id;
+
+	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_vdint1_isr\n");
+
+	ccdc_vidint1_isr(&vpfe_dev->vpfe_ccdc);
+
+	return IRQ_HANDLED;
+}
+
+/* ISR for ipipe dma completion */
+static irqreturn_t vpfe_imp_dma_isr(int irq, void *dev_id)
+{
+	struct vpfe_device *vpfe_dev = dev_id;
+
+	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_imp_dma_isr\n");
+
+	prv_dma_isr(&vpfe_dev->vpfe_previewer);
+
+	rsz_dma_isr(&vpfe_dev->vpfe_resizer);
+
+	return IRQ_HANDLED;
+}
+
+/* set user setting of serializer in ipipe */
+static void vpfe_initialize(void)
+{
+	/* inform user choice on serializer to ipipe */
+	enable_serializer(en_serializer);
+}
+
+/**
+ * vpfe_disable_clock() - Disable clocks for vpfe capture driver
+ * @vpfe_dev - ptr to vpfe capture device
+ *
+ * Disables clocks defined in vpfe configuration. The function
+ * assumes that at least one clock is to be defined which is
+ * true as of now.
+ */
+static void vpfe_disable_clock(struct vpfe_device *vpfe_dev)
+{
+	struct vpfe_config *vpfe_cfg = vpfe_dev->cfg;
+	int i;
+
+	for (i = 0; i < vpfe_cfg->num_clocks; i++) {
+		clk_disable(vpfe_dev->clks[i]);
+		clk_put(vpfe_dev->clks[i]);
+	}
+
+	kzfree(vpfe_dev->clks);
+	v4l2_info(vpfe_dev->pdev->driver, "vpfe capture clocks disabled\n");
+}
+
+/**
+ * vpfe_enable_clock() - Enable clocks for vpfe capture driver
+ * @vpfe_dev - ptr to vpfe capture device
+ *
+ * Enables clocks defined in vpfe configuration. The function
+ * assumes that at least one clock is to be defined which is
+ * true as of now.
+ */
+static int vpfe_enable_clock(struct vpfe_device *vpfe_dev)
+{
+	struct vpfe_config *vpfe_cfg = vpfe_dev->cfg;
+	int ret = -EFAULT;
+	int i;
+
+	if (!vpfe_cfg->num_clocks)
+		return 0;
+
+	vpfe_dev->clks = kzalloc(vpfe_cfg->num_clocks *
+				   sizeof(struct clock *), GFP_KERNEL);
+
+	if (NULL == vpfe_dev->clks) {
+		v4l2_err(vpfe_dev->pdev->driver, "Memory allocation failed\n");
+		return -ENOMEM;
+	}
+
+	for (i = 0; i < vpfe_cfg->num_clocks; i++) {
+		if (NULL == vpfe_cfg->clocks[i]) {
+			v4l2_err(vpfe_dev->pdev->driver,
+				"clock %s is not defined in vpfe config\n",
+				vpfe_cfg->clocks[i]);
+			goto out;
+		}
+
+		vpfe_dev->clks[i] = clk_get(vpfe_dev->pdev,
+					      vpfe_cfg->clocks[i]);
+		if (NULL == vpfe_dev->clks[i]) {
+			v4l2_err(vpfe_dev->pdev->driver,
+				"Failed to get clock %s\n",
+				vpfe_cfg->clocks[i]);
+			goto out;
+		}
+
+		if (clk_enable(vpfe_dev->clks[i])) {
+			v4l2_err(vpfe_dev->pdev->driver,
+				"vpfe clock %s not enabled\n",
+				vpfe_cfg->clocks[i]);
+			goto out;
+		}
+
+		v4l2_info(vpfe_dev->pdev->driver, "vpss clock %s enabled",
+			  vpfe_cfg->clocks[i]);
+	}
+
+	return 0;
+out:
+	for (i = 0; i < vpfe_cfg->num_clocks; i++) {
+		if (vpfe_dev->clks[i])
+			clk_put(vpfe_dev->clks[i]);
+	}
+
+	v4l2_err(vpfe_dev->pdev->driver,
+				"failed to enable clocks\n");
+
+	kzfree(vpfe_dev->clks);
+	return ret;
+}
+
+/**
+ * vpfe_detach_irq() - Detach IRQs for vpfe capture driver
+ * @vpfe_dev - ptr to vpfe capture device
+ *
+ * Detach all IRQs defined in vpfe configuration.
+ */
+static void vpfe_detach_irq(struct vpfe_device *vpfe_dev)
+{
+	free_irq(vpfe_dev->ccdc_irq0, vpfe_dev);
+	free_irq(vpfe_dev->ccdc_irq1, vpfe_dev);
+	free_irq(vpfe_dev->imp_dma_irq, vpfe_dev);
+}
+
+/**
+ * vpfe_attach_irq() - Attach IRQs for vpfe capture driver
+ * @vpfe_dev - ptr to vpfe capture device
+ *
+ * Attach all IRQs defined in vpfe configuration.
+ */
+static int vpfe_attach_irq(struct vpfe_device *vpfe_dev)
+{
+	int ret = 0;
+
+	ret = request_irq(vpfe_dev->ccdc_irq0, vpfe_isr, IRQF_DISABLED,
+			"vpfe_capture0", vpfe_dev);
+	if (ret < 0) {
+		v4l2_err(&vpfe_dev->v4l2_dev,
+			"Error: requesting VINT0 interrupt\n");
+		return ret;
+	}
+
+	ret = request_irq(vpfe_dev->ccdc_irq1,
+					vpfe_vdint1_isr,
+					IRQF_DISABLED,
+					"vpfe_capture1", vpfe_dev);
+	if (ret < 0) {
+		v4l2_err(&vpfe_dev->v4l2_dev,
+			"Error: requesting VINT1 interrupt\n");
+		free_irq(vpfe_dev->ccdc_irq0, vpfe_dev);
+		return ret;
+	}
+
+	ret = request_irq(vpfe_dev->imp_dma_irq,
+				vpfe_imp_dma_isr,
+				IRQF_DISABLED,
+				"Imp_Sdram_Irq",
+				vpfe_dev);
+	if (ret < 0) {
+		v4l2_err(&vpfe_dev->v4l2_dev,
+				"Error: requesting IMP"
+				" IRQ interrupt\n");
+		free_irq(vpfe_dev->ccdc_irq1, vpfe_dev);
+		free_irq(vpfe_dev->ccdc_irq0, vpfe_dev);
+		return ret;
+	}
+
+	return 0;
+}
+
+/**
+ * register_i2c_devices() - register all i2c v4l2 subdevs
+ * @vpfe_dev - ptr to vpfe capture device
+ *
+ * register all i2c v4l2 subdevs
+ */
+static int register_i2c_devices(struct vpfe_device *vpfe_dev)
+{
+	struct vpfe_ext_subdev_info *sdinfo;
+	struct vpfe_config *vpfe_cfg;
+	struct i2c_adapter *i2c_adap;
+	unsigned int num_subdevs;
+	int ret;
+	int i;
+	int k;
+
+	vpfe_cfg = vpfe_dev->cfg;
+
+	i2c_adap = i2c_get_adapter(1);
+	num_subdevs = vpfe_cfg->num_subdevs;
+
+	vpfe_dev->sd = kzalloc(sizeof(struct v4l2_subdev *) *num_subdevs,
+			       GFP_KERNEL);
+
+	if (NULL == vpfe_dev->sd) {
+		v4l2_err(&vpfe_dev->v4l2_dev,
+			"unable to allocate memory for subdevice pointers\n");
+		return -ENOMEM;
+	}
+
+	for (i = 0, k = 0; i < num_subdevs; i++) {
+		sdinfo = &vpfe_cfg->sub_devs[i];
+		/**
+		 * register subdevices based on interface setting. Currently
+		 * tvp5146 and mt9p031 cannot co-exists due to i2c address
+		 * conflicts. So only one of them is registered. Re-visit this
+		 * once we have support for i2c switch handling in i2c driver
+		 * framework
+		 */
+
+		if (interface == sdinfo->is_camera) {
+			/* setup input path */
+			if (vpfe_cfg->setup_input) {
+				if (vpfe_cfg->setup_input(sdinfo->grp_id) < 0) {
+					ret = -EFAULT;
+					v4l2_info(&vpfe_dev->v4l2_dev, "could"
+							" not setup input for %s\n",
+							sdinfo->module_name);
+					goto probe_sd_out;
+				}
+			}
+			/* Load up the subdevice */
+			vpfe_dev->sd[k] =
+				v4l2_i2c_new_subdev_board(
+						  &vpfe_dev->v4l2_dev,
+						  i2c_adap,
+						  &sdinfo->board_info,
+						  NULL,
+						1);
+			if (vpfe_dev->sd[k]) {
+				v4l2_info(&vpfe_dev->v4l2_dev,
+						"v4l2 sub device %s registered\n",
+						sdinfo->module_name);
+
+				vpfe_dev->sd[k]->grp_id = sdinfo->grp_id;
+				k++;
+
+				sdinfo->registered = 1;
+			}
+			} else {
+				v4l2_info(&vpfe_dev->v4l2_dev,
+						"v4l2 sub device %s is not registered\n",
+						sdinfo->module_name);
+			}
+	}
+
+	vpfe_dev->num_ext_subdevs = k;
+
+	return 0;
+
+probe_sd_out:
+	kzfree(vpfe_dev->sd);
+
+	return ret;
+}
+
+/**
+ * vpfe_register_entities() - register all v4l2 subdevs and media entities
+ * @vpfe_dev - ptr to vpfe capture device
+ *
+ * register all v4l2 subdevs, media entities, and creates links
+ * between entities
+ */
+static int vpfe_register_entities(struct vpfe_device *vpfe_dev)
+{
+	unsigned int flags = 0;
+	int ret;
+	int i;
+
+	/* register i2c devices first */
+	ret = register_i2c_devices(vpfe_dev);
+	if (ret)
+		return ret;
+
+	/* register rest of the sub-devs */
+	ret = vpfe_ccdc_register_entities(&vpfe_dev->vpfe_ccdc,
+					  &vpfe_dev->v4l2_dev);
+	if (ret)
+		return ret;
+
+	ret = vpfe_previewer_register_entities(&vpfe_dev->vpfe_previewer,
+					       &vpfe_dev->v4l2_dev);
+	if (ret)
+		goto out_ccdc_register;
+
+	ret = vpfe_resizer_register_entities(&vpfe_dev->vpfe_resizer,
+					     &vpfe_dev->v4l2_dev);
+	if (ret)
+		goto out_previewer_register;
+
+	ret = vpfe_aew_register_entities(&vpfe_dev->vpfe_aew,
+					 &vpfe_dev->v4l2_dev);
+	if (ret)
+		goto out_resizer_register;
+
+	ret = vpfe_af_register_entities(&vpfe_dev->vpfe_af,
+					&vpfe_dev->v4l2_dev);
+	if (ret)
+		goto out_aew_register;
+
+	/* create links now, starting with external(i2c) entities */
+	for (i = 0; i < vpfe_dev->num_ext_subdevs; i++) {
+		/* if entity has no pads (ex: amplifier),
+		   cant establish link */
+		if (vpfe_dev->sd[i]->entity.num_pads) {
+			ret = media_entity_create_link(&vpfe_dev->sd[i]->entity,
+				0, &vpfe_dev->vpfe_ccdc.subdev.entity,
+				0, flags);
+			if (ret < 0)
+				goto out_resizer_register;
+		}
+	}
+
+	ret = media_entity_create_link(&vpfe_dev->vpfe_ccdc.subdev.entity,
+					1, &vpfe_dev->vpfe_aew.subdev.entity,
+					0, flags);
+	if (ret < 0)
+		goto out_resizer_register;
+
+	ret = media_entity_create_link(&vpfe_dev->vpfe_ccdc.subdev.entity,
+					1, &vpfe_dev->vpfe_af.subdev.entity,
+					0, flags);
+	if (ret < 0)
+		goto out_resizer_register;
+
+	ret = media_entity_create_link(&vpfe_dev->vpfe_ccdc.subdev.entity,
+				       1,
+				       &vpfe_dev->vpfe_previewer.subdev.entity,
+				       0, flags);
+	if (ret < 0)
+		goto out_resizer_register;
+
+	ret = media_entity_create_link(&vpfe_dev->vpfe_previewer.subdev.entity,
+				       1, &vpfe_dev->vpfe_resizer.subdev.entity,
+				       0, flags);
+	if (ret < 0)
+		goto out_resizer_register;
+
+	return 0;
+
+out_aew_register:
+	vpfe_aew_unregister_entities(&vpfe_dev->vpfe_aew);
+out_resizer_register:
+	vpfe_resizer_unregister_entities(&vpfe_dev->vpfe_resizer);
+out_previewer_register:
+	vpfe_previewer_unregister_entities(&vpfe_dev->vpfe_previewer);
+out_ccdc_register:
+	vpfe_ccdc_unregister_entities(&vpfe_dev->vpfe_ccdc);
+	return ret;
+}
+
+/**
+ * vpfe_unregister_entities() - unregister all v4l2 subdevs and media entities
+ * @vpfe_dev - ptr to vpfe capture device
+ *
+ * unregister all v4l2 subdevs and media entities
+ */
+static void vpfe_unregister_entities(struct vpfe_device *vpfe_dev)
+{
+	vpfe_ccdc_unregister_entities(&vpfe_dev->vpfe_ccdc);
+	vpfe_previewer_unregister_entities(&vpfe_dev->vpfe_previewer);
+	vpfe_resizer_unregister_entities(&vpfe_dev->vpfe_resizer);
+	vpfe_aew_unregister_entities(&vpfe_dev->vpfe_aew);
+	vpfe_af_unregister_entities(&vpfe_dev->vpfe_af);
+}
+
+/**
+ * vpfe_cleanup_modules() - cleanup all non-i2c v4l2 subdevs
+ * @vpfe_dev - ptr to vpfe capture device
+ * @pdev - pointer to platform device
+ *
+ * cleanup all v4l2 subdevs
+ */
+static void vpfe_cleanup_modules(struct vpfe_device *vpfe_dev,
+				 struct platform_device *pdev)
+{
+	vpfe_ccdc_cleanup(pdev);
+	vpfe_previewer_cleanup(pdev);
+	vpfe_aew_cleanup();
+	vpfe_af_cleanup();
+}
+
+/**
+ * vpfe_initialize_modules() - initialize all non-i2c v4l2 subdevs
+ * @vpfe_dev - ptr to vpfe capture device
+ * @pdev - pointer to platform device
+ *
+ * intialize all v4l2 subdevs and media entities
+ */
+static int vpfe_initialize_modules(struct vpfe_device *vpfe_dev,
+				   struct platform_device *pdev)
+{
+	int ret;
+
+	ret = vpfe_ccdc_init(&vpfe_dev->vpfe_ccdc, pdev);
+	if (ret)
+		return ret;
+
+	ret = vpfe_previewer_init(&vpfe_dev->vpfe_previewer, pdev);
+	if (ret)
+		goto out_ccdc_init;
+
+	ret = vpfe_resizer_init(&vpfe_dev->vpfe_resizer, pdev);
+	if (ret)
+		goto out_previewer_init;
+
+	ret = vpfe_aew_init(&vpfe_dev->vpfe_aew, pdev);
+	if (ret)
+		goto out_previewer_init;
+
+	ret = vpfe_af_init(&vpfe_dev->vpfe_af, pdev);
+	if (ret)
+		goto out_aew_init;
+
+	return 0;
+
+out_aew_init:
+	vpfe_aew_cleanup();
+out_previewer_init:
+	vpfe_previewer_cleanup(pdev);
+out_ccdc_init:
+	vpfe_ccdc_cleanup(pdev);
+
+	return ret;
+}
+
+/**
+ * vpfe_probe : vpfe probe function
+ * @pdev: platform device pointer
+ *
+ * This function creates device entries by register itself to the V4L2 driver
+ * and initializes fields of each device objects
+ */
+static __devinit int vpfe_probe(struct platform_device *pdev)
+{
+	struct vpfe_device *vpfe_dev;
+	struct resource *res1;
+	unsigned long phys_end_kernel;
+	int ret = -ENOMEM;
+	int err;
+	size_t size;
+
+	vpfe_dev = kzalloc(sizeof(*vpfe_dev), GFP_KERNEL);
+	if (!vpfe_dev) {
+		v4l2_err(pdev->dev.driver,
+			"Failed to allocate memory for vpfe_dev\n");
+		return ret;
+	}
+
+	if (NULL == pdev->dev.platform_data) {
+		v4l2_err(pdev->dev.driver, "Unable to get vpfe config\n");
+		ret = -ENOENT;
+		goto probe_free_dev_mem;
+	}
+
+	vpfe_dev->cfg = pdev->dev.platform_data;
+
+	if (NULL == vpfe_dev->cfg->card_name ||
+	    NULL == vpfe_dev->cfg->sub_devs) {
+		v4l2_err(pdev->dev.driver, "null ptr in vpfe_cfg\n");
+		ret = -ENOENT;
+		goto probe_free_dev_mem;
+	}
+
+	/* Get VINT0 irq resource */
+	res1 = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (!res1) {
+		v4l2_err(pdev->dev.driver,
+			 "Unable to get interrupt for VINT0\n");
+		ret = -ENOENT;
+		goto probe_free_dev_mem;
+	}
+	vpfe_dev->ccdc_irq0 = res1->start;
+
+	/* Get VINT1 irq resource */
+	res1 = platform_get_resource(pdev,
+				IORESOURCE_IRQ, 1);
+	if (!res1) {
+		v4l2_err(pdev->dev.driver,
+			 "Unable to get interrupt for VINT1\n");
+		ret = -ENOENT;
+		goto probe_free_dev_mem;
+	}
+	vpfe_dev->ccdc_irq1 = res1->start;
+
+	/* Get DMA irq resource */
+	res1 = platform_get_resource(pdev,
+				IORESOURCE_IRQ, 2);
+	if (!res1) {
+		v4l2_err(pdev->dev.driver,
+			 "Unable to get interrupt for DMA\n");
+		ret = -ENOENT;
+		goto probe_free_dev_mem;
+	}
+	vpfe_dev->imp_dma_irq = res1->start;
+
+	vpfe_dev->pdev = &pdev->dev;
+
+	vpfe_initialize();
+
+	/* enable vpss clocks */
+	ret = vpfe_enable_clock(vpfe_dev);
+	if (ret)
+		goto probe_free_dev_mem;
+
+	if (vpfe_initialize_modules(vpfe_dev, pdev))
+		goto probe_disable_clock;
+
+	vpfe_dev->media_dev.dev = vpfe_dev->pdev;
+	strcpy((char *)&vpfe_dev->media_dev.model, "davinci-media");
+	ret = media_device_register(&vpfe_dev->media_dev);
+	if (ret) {
+		v4l2_err(pdev->dev.driver,
+			"Unable to register media device.\n");
+		goto probe_out_entities_cleanup;
+	}
+
+	vpfe_dev->v4l2_dev.mdev = &vpfe_dev->media_dev;
+
+	ret = v4l2_device_register(&pdev->dev, &vpfe_dev->v4l2_dev);
+	if (ret) {
+		v4l2_err(pdev->dev.driver,
+			"Unable to register v4l2 device.\n");
+		goto probe_out_media_unregister;
+	}
+	v4l2_info(&vpfe_dev->v4l2_dev, "v4l2 device registered\n");
+
+	/* set the driver data in platform device */
+	platform_set_drvdata(pdev, vpfe_dev);
+
+	/* register subdevs/entities */
+	if (vpfe_register_entities(vpfe_dev))
+		goto probe_out_v4l2_unregister;
+
+	ret = vpfe_attach_irq(vpfe_dev);
+	if (ret)
+		goto probe_out_entities_unregister;
+
+	if (cont_bufsize) {
+		/* attempt to determine the end of Linux kernel memory */
+		phys_end_kernel = virt_to_phys((void *)PAGE_OFFSET) +
+			(num_physpages << PAGE_SHIFT);
+		size = cont_bufsize;
+		phys_end_kernel += cont_bufoffset;
+		err = dma_declare_coherent_memory(&pdev->dev, phys_end_kernel,
+				phys_end_kernel, size,
+				DMA_MEMORY_MAP | DMA_MEMORY_EXCLUSIVE);
+		if (!err) {
+			dev_err(&pdev->dev, "Unable to declare MMAP memory.\n");
+			ret = -ENOENT;
+			goto probe_detach_irq;
+		}
+		vpfe_dev->video_limit = size;
+	}
+
+	return 0;
+
+probe_detach_irq:
+	vpfe_detach_irq(vpfe_dev);
+probe_out_entities_unregister:
+	vpfe_unregister_entities(vpfe_dev);
+	kzfree(vpfe_dev->sd);
+probe_out_v4l2_unregister:
+	v4l2_device_unregister(&vpfe_dev->v4l2_dev);
+probe_out_media_unregister:
+	media_device_unregister(&vpfe_dev->media_dev);
+probe_out_entities_cleanup:
+	vpfe_cleanup_modules(vpfe_dev, pdev);
+probe_disable_clock:
+	vpfe_disable_clock(vpfe_dev);
+probe_free_dev_mem:
+	kzfree(vpfe_dev);
+
+	return ret;
+}
+
+/*
+ * vpfe_remove : This function un-registers device from V4L2 driver
+ */
+static int vpfe_remove(struct platform_device *pdev)
+{
+	struct vpfe_device *vpfe_dev = platform_get_drvdata(pdev);
+
+	v4l2_info(pdev->dev.driver, "vpfe_remove\n");
+
+	kzfree(vpfe_dev->sd);
+	vpfe_detach_irq(vpfe_dev);
+	vpfe_unregister_entities(vpfe_dev);
+	vpfe_cleanup_modules(vpfe_dev, pdev);
+	v4l2_device_unregister(&vpfe_dev->v4l2_dev);
+	media_device_unregister(&vpfe_dev->media_dev);
+	vpfe_disable_clock(vpfe_dev);
+	kzfree(vpfe_dev);
+
+	return 0;
+}
+
+static struct platform_driver vpfe_driver = {
+	.driver = {
+		.name = CAPTURE_DRV_NAME,
+		.owner = THIS_MODULE,
+	},
+	.probe = vpfe_probe,
+	.remove = __devexit_p(vpfe_remove),
+};
+
+/**
+ * vpfe_init : This function registers device driver
+ */
+static __init int vpfe_init(void)
+{
+	/* Register driver to the kernel */
+	return platform_driver_register(&vpfe_driver);
+}
+
+/**
+ * vpfe_cleanup : This function un-registers device driver
+ */
+static void vpfe_cleanup(void)
+{
+	platform_driver_unregister(&vpfe_driver);
+}
+
+module_init(vpfe_init);
+module_exit(vpfe_cleanup);
diff --git a/drivers/media/video/davinci/vpfe_capture.h b/drivers/media/video/davinci/vpfe_capture.h
new file mode 100644
index 0000000..b6181e5
--- /dev/null
+++ b/drivers/media/video/davinci/vpfe_capture.h
@@ -0,0 +1,104 @@
+/*
+* Copyright (C) 2011 Texas Instruments Inc
+*
+* This program is free software; you can redistribute it and/or
+* modify it under the terms of the GNU General Public License as
+* published by the Free Software Foundation version 2.
+*
+* This program is distributed in the hope that it will be useful,
+* but WITHOUT ANY WARRANTY; without even the implied warranty of
+* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+* GNU General Public License for more details.
+*
+* You should have received a copy of the GNU General Public License
+* along with this program; if not, write to the Free Software
+* Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+*/
+
+#ifndef _VPFE_CAPTURE_H
+#define _VPFE_CAPTURE_H
+
+#ifdef __KERNEL__
+
+/* Header files */
+#include <media/v4l2-dev.h>
+#include <linux/v4l2-subdev.h>
+#include <linux/videodev2.h>
+
+#include <linux/clk.h>
+#include <linux/i2c.h>
+#include <media/v4l2-ioctl.h>
+#include <media/v4l2-device.h>
+#include <media/videobuf-dma-contig.h>
+#include "imp_hw_if.h"
+#include "dm3xx_ipipeif.h"
+#include "dm365_ipipe.h"
+#include <media/davinci/vpfe.h>
+#include "vpfe_video.h"
+#include "vpfe_ccdc.h"
+#include "vpfe_resizer.h"
+#include "vpfe_previewer.h"
+#include "vpfe_aew.h"
+#include "vpfe_af.h"
+
+/* Macros */
+#define VPFE_MAJOR_RELEASE              0
+#define VPFE_MINOR_RELEASE              0
+#define VPFE_BUILD                      1
+#define VPFE_CAPTURE_VERSION_CODE       ((VPFE_MAJOR_RELEASE << 16) | \
+					(VPFE_MINOR_RELEASE << 8)  | \
+					VPFE_BUILD)
+
+#define to_vpfe_device(ptr_module)				\
+	container_of(ptr_module, struct vpfe_device, vpfe_##ptr_module)
+#define to_device(ptr_module)						\
+	(to_vpfe_device(ptr_module)->dev)
+
+struct vpfe_device {
+	/* external registered sub devices */
+	struct v4l2_subdev		**sd;
+	/* number of registered external subdevs */
+	unsigned int			num_ext_subdevs;
+	/* vpfe cfg */
+	struct vpfe_config		*cfg;
+	/* clock ptrs for vpfe capture */
+	struct clk			**clks;
+	/* V4l2 device */
+	struct v4l2_device		v4l2_dev;
+	/* parent device */
+	struct device			*pdev;
+	/* IRQ number for DMA transfer completion at the image processor */
+	unsigned int			imp_dma_irq;
+	/* CCDC IRQs used when CCDC/ISIF output to SDRAM */
+	unsigned int			ccdc_irq0;
+	unsigned int			ccdc_irq1;
+	/* maximum video memory that is available*/
+	unsigned int			video_limit;
+	/* media device */
+	struct media_device		media_dev;
+	/* ccdc subdevice */
+	struct vpfe_ccdc_device		vpfe_ccdc;
+	/* resizer subdevice */
+	struct vpfe_resizer_device	vpfe_resizer;
+	/* previewer subdevice */
+	struct vpfe_previewer_device	vpfe_previewer;
+	/* aew subdevice */
+	struct vpfe_aew_device		vpfe_aew;
+	/* af subdevice */
+	struct vpfe_af_device		vpfe_af;
+};
+
+/* File handle structure */
+struct vpfe_fh {
+	struct vpfe_video_device *video;
+	/* Indicates whether this file handle is doing IO */
+	u8 io_allowed;
+	/* Used to keep track priority of this instance */
+	enum v4l2_priority prio;
+};
+
+void mbus_to_pix(const struct v4l2_mbus_framefmt *mbus,
+			   struct v4l2_pix_format *pix);
+
+#endif				/* End of __KERNEL__ */
+#endif				/* _DAVINCI_VPFE_H */
diff --git a/include/linux/davinci_vpfe.h b/include/linux/davinci_vpfe.h
new file mode 100644
index 0000000..87332ab
--- /dev/null
+++ b/include/linux/davinci_vpfe.h
@@ -0,0 +1,1223 @@
+/*
+* Copyright (C) 2011 Texas Instruments Inc
+*
+* This program is free software; you can redistribute it and/or
+* modify it under the terms of the GNU General Public License as
+* published by the Free Software Foundation version 2.
+*
+* This program is distributed in the hope that it will be useful,
+* but WITHOUT ANY WARRANTY; without even the implied warranty of
+* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+* GNU General Public License for more details.
+*
+* You should have received a copy of the GNU General Public License
+* along with this program; if not, write to the Free Software
+* Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+*/
+
+#ifndef _DAVINCI_VPFE_INCLUDE_H
+#define _DAVINCI_VPFE_INCLUDE_H
+
+#include <linux/dm3xx_ipipeif.h>
+
+#define IMP_MODE_CONTINUOUS	0
+#define IMP_MODE_SINGLE_SHOT	1
+#define IMP_MODE_INVALID	2
+#define IMP_MODE_NOT_CONFIGURED	4
+#define IMP_MAX_NAME_SIZE	40
+
+enum imp_data_paths {
+	IMP_RAW2RAW = 1,
+	IMP_RAW2YUV = 2,
+	IMP_YUV2YUV = 4
+};
+
+enum imp_pix_formats {
+	IMP_BAYER_8BIT_PACK,
+	IMP_BAYER_8BIT_PACK_ALAW,
+	IMP_BAYER_8BIT_PACK_DPCM,
+	IMP_BAYER_12BIT_PACK,
+	IMP_BAYER, /* 16 bit */
+	IMP_UYVY,
+	IMP_YUYV,
+	IMP_RGB565,
+	IMP_RGB888,
+	IMP_YUV420SP,
+	IMP_420SP_Y,
+	IMP_420SP_C,
+};
+
+struct imp_window {
+	/* horizontal size */
+	unsigned int width;
+	/* vertical size */
+	unsigned int height;
+	/* horizontal start position */
+	unsigned int hst;
+	/* vertical start position */
+	unsigned int vst;
+};
+
+/* structure used by application to query the modules
+ * available in the image processorr for preview the input
+ * image. Used for PREV_QUERY_CAP IOCTL
+ */
+struct prev_cap {
+	/* application use this to iterate over the available
+	 * modules. stop when -EINVAL return code is returned by
+	 * the driver
+	 */
+	unsigned short index;
+	/* Version of the preview module */
+	char version[IMP_MAX_NAME_SIZE];
+	/* Module IDs as defined above */
+	unsigned short module_id;
+	/* control operation allowed in continuous mode ?
+	 * 1 - allowed, 0 - not allowed
+	 */
+	char control;
+	/* path on which the module is sitting */
+	enum imp_data_paths path;
+	char module_name[IMP_MAX_NAME_SIZE];
+};
+
+/* struct to configure preview modules for which structures
+ * are defined above. Used by PREV_SET_PARAM or PREV_GET_PARAM IOCTLs.
+ */
+struct prev_module_param {
+	/* Version of the preview module */
+	char version[IMP_MAX_NAME_SIZE];
+	/* Length of the module config structure */
+	unsigned short len;
+	/* Module IDs as defined above */
+	unsigned short module_id;
+	/* Ptr to module config parameter. If SET command and is NULL
+	 * module is reset to power on reset values
+	 */
+	void *param;
+};
+
+/* Structure for configuring the previewer driver.
+ * Used in PREV_SET_CONFIG/PREV_GET_CONFIG IOCTLs
+ */
+struct prev_channel_config {
+	/* Length of the user configuration */
+	unsigned short len;
+	/* Ptr to either preview_single_shot_config or
+	 * preview_continuous_config depending on oper_mode
+	 */
+	void *config;
+};
+
+struct prev_control {
+	/* Version of the preview module */
+	char version[IMP_MAX_NAME_SIZE];
+	/* Length of the module config structure */
+	unsigned short len;
+	/* Module IDs as defined above */
+	unsigned short module_id;
+	/* Ptr to module config parameter. If SET command and is NULL
+	 * module is reset to power on reset values
+	 */
+	void *param;
+};
+
+/* Structure for RSZ_SET_CONFIG and RSZ_GET_CONFIG IOCTLs */
+struct rsz_channel_config {
+	/* Chain this resizer at the previewer output */
+	unsigned char chain;
+	/* Length of the user configuration */
+	unsigned short len;
+	/* ptr to either rsz_single_shot_config or rsz_continuous_config
+	 * depending on oper_mode
+	 */
+	void *config;
+};
+
+/* RSZ_RECONFIG IOCTL. Used for re-configuring resizer
+ * before doing RSZ_RESIZE. This is a IOCTL to do fast reconfiguration
+ * of resizer. This assumes that corresponding resizer is already enabled
+ * through SET_CONFIG. This is used when the input image to be resized
+ * is either Y or C plane of a YUV 420 image. Typically, when channel is
+ * first configured, it is set up to resize Y plane. Then if application
+ * needs to resize C plane, this ioctl is called to switch the channel
+ * to resize C plane.
+ */
+struct rsz_reconfig {
+	enum imp_pix_formats pix_format;
+};
+
+/* ioctls definition for previewer operations */
+#define PREV_IOC_BASE		'P'
+#define PREV_S_PARAM		_IOWR(PREV_IOC_BASE, 1,\
+					struct prev_module_param)
+#define PREV_G_PARAM		_IOWR(PREV_IOC_BASE, 2,\
+					struct prev_module_param)
+#define PREV_ENUM_CAP		_IOWR(PREV_IOC_BASE, 3, struct prev_cap)
+#define PREV_S_CONFIG		_IOWR(PREV_IOC_BASE, 4,\
+					struct prev_channel_config)
+#define PREV_G_CONFIG		_IOWR(PREV_IOC_BASE, 5,\
+					struct prev_channel_config)
+
+/* ioctls definitions for resizer operations */
+#define RSZ_IOC_BASE		'R'
+#define RSZ_S_CONFIG		_IOWR(RSZ_IOC_BASE, 1,\
+					struct rsz_channel_config)
+#define RSZ_G_CONFIG		_IOWR(RSZ_IOC_BASE, 2,\
+					struct rsz_channel_config)
+
+
+/**********************************************************************
+**      Previewer API Structures
+**********************************************************************/
+
+/* Previewer module IDs used in PREV_SET/GET_PARAM IOCTL. Some
+ * modules can be also be updated during IPIPE operation. They are
+ * marked as control ID
+ */
+/* LUT based Defect Pixel Correction */
+#define PREV_LUTDPC		1
+/* On the fly (OTF) Defect Pixel Correction */
+#define PREV_OTFDPC		2
+/* Noise Filter - 1 */
+#define PREV_NF1		3
+/* Noise Filter - 2 */
+#define PREV_NF2		4
+/* White Balance.  Also a control ID */
+#define PREV_WB			5
+/* 1st RGB to RBG Blend module */
+#define PREV_RGB2RGB_1		6
+/* 2nd RGB to RBG Blend module */
+#define PREV_RGB2RGB_2		7
+/* Gamma Correction */
+#define PREV_GAMMA		8
+/* 3D LUT color conversion */
+#define PREV_3D_LUT		9
+/* RGB to YCbCr module */
+#define PREV_RGB2YUV		10
+/* YUV 422 conversion module */
+#define PREV_YUV422_CONV	11
+/* Luminance Adjustment module.  Also a control ID */
+#define PREV_LUM_ADJ		12
+/* Edge Enhancement */
+#define PREV_YEE		13
+/* Green Imbalance Correction */
+#define PREV_GIC		14
+/* CFA Interpolation */
+#define PREV_CFA		15
+/* Chroma Artifact Reduction */
+#define PREV_CAR		16
+/* Chroma Gain Suppression */
+#define PREV_CGS		17
+/* Global brighness and contrast control */
+#define PREV_GBCE		18
+/* Last module ID */
+#define PREV_MAX_MODULES	18
+
+struct ipipe_float_u16 {
+	unsigned short integer;
+	unsigned short decimal;
+};
+
+struct ipipe_float_s16 {
+	short integer;
+	unsigned short decimal;
+};
+
+struct ipipe_float_u8 {
+	unsigned char integer;
+	unsigned char decimal;
+};
+
+struct ipipe_win {
+	/* vertical start line */
+	unsigned int vst;
+	/* horizontal start pixel */
+	unsigned int hst;
+	/* width */
+	unsigned int width;
+	/* height */
+	unsigned int height;
+};
+
+/* Copy method selection for vertical correction
+ *  Used when ipipe_dfc_corr_meth is PREV_DPC_CTORB_AFTER_HINT
+ */
+enum ipipe_dpc_corr_meth {
+	/* replace by black or white dot specified by repl_white */
+	IPIPE_DPC_REPL_BY_DOT = 0,
+	/* Copy from left */
+	IPIPE_DPC_CL,
+	/* Copy from right */
+	IPIPE_DPC_CR,
+	/* Horizontal interpolation */
+	IPIPE_DPC_H_INTP,
+	/* Vertical interpolation */
+	IPIPE_DPC_V_INTP,
+	/* Copy from top  */
+	IPIPE_DPC_CT,
+	/* Copy from bottom */
+	IPIPE_DPC_CB,
+	/* 2D interpolation */
+	IPIPE_DPC_2D_INTP,
+};
+
+struct ipipe_lutdpc_entry {
+	/* Horizontal position */
+	unsigned short horz_pos;
+	/* vertical position */
+	unsigned short vert_pos;
+	enum ipipe_dpc_corr_meth method;
+};
+
+#define MAX_SIZE_DPC 256
+/* Struct for configuring DPC module */
+struct prev_lutdpc {
+	/* 0 - disable, 1 - enable */
+	unsigned char en;
+	/* 0 - replace with black dot, 1 - white dot when correction
+	 * method is  IPIPE_DFC_REPL_BY_DOT=0,
+	 */
+	unsigned char repl_white;
+	/* number of entries in the correction table. Currently only
+	 * support upto 256 entries. infinite mode is not supported
+	 */
+	unsigned short dpc_size;
+	struct ipipe_lutdpc_entry *table;
+};
+
+enum ipipe_otfdpc_det_meth {
+	IPIPE_DPC_OTF_MIN_MAX,
+	IPIPE_DPC_OTF_MIN_MAX2
+};
+
+struct ipipe_otfdpc_thr {
+	unsigned short r;
+	unsigned short gr;
+	unsigned short gb;
+	unsigned short b;
+};
+
+enum ipipe_otfdpc_alg {
+	IPIPE_OTFDPC_2_0,
+	IPIPE_OTFDPC_3_0
+};
+
+struct prev_otfdpc_2_0 {
+	/* defect detection threshold for MIN_MAX2 method  (DPC 2.0 alg) */
+	struct ipipe_otfdpc_thr det_thr;
+	/* defect correction threshold for MIN_MAX2 method (DPC 2.0 alg) or
+	 * maximum value for MIN_MAX method
+	 */
+	struct ipipe_otfdpc_thr corr_thr;
+};
+
+struct prev_otfdpc_3_0 {
+	/* DPC3.0 activity adj shf. activity = (max2-min2) >> (6 -shf)
+	 */
+	unsigned char act_adj_shf;
+	/* DPC3.0 detection threshold, THR */
+	unsigned short det_thr;
+	/* DPC3.0 detection threshold slope, SLP */
+	unsigned short det_slp;
+	/* DPC3.0 detection threshold min, MIN */
+	unsigned short det_thr_min;
+	/* DPC3.0 detection threshold max, MAX */
+	unsigned short det_thr_max;
+	/* DPC3.0 correction threshold, THR */
+	unsigned short corr_thr;
+	/* DPC3.0 correction threshold slope, SLP */
+	unsigned short corr_slp;
+	/* DPC3.0 correction threshold min, MIN */
+	unsigned short corr_thr_min;
+	/* DPC3.0 correction threshold max, MAX */
+	unsigned short corr_thr_max;
+};
+
+struct prev_otfdpc {
+	/* 0 - disable, 1 - enable */
+	unsigned char en;
+	/* defect detection method */
+	enum ipipe_otfdpc_det_meth det_method;
+	/* Algorith used. Applicable only when IPIPE_DPC_OTF_MIN_MAX2 is
+	 * used
+	 */
+	enum ipipe_otfdpc_alg alg;
+	union {
+		/* if alg is IPIPE_OTFDPC_2_0 */
+		struct prev_otfdpc_2_0 dpc_2_0;
+		/* if alg is IPIPE_OTFDPC_3_0 */
+		struct prev_otfdpc_3_0 dpc_3_0;
+	} alg_cfg;
+};
+
+/* Threshold values table size */
+#define IPIPE_NF_THR_TABLE_SIZE 8
+/* Intensity values table size */
+#define IPIPE_NF_STR_TABLE_SIZE 8
+
+/* NF, sampling method for green pixels */
+enum ipipe_nf_sampl_meth {
+	/* Same as R or B */
+	IPIPE_NF_BOX,
+	/* Diamond mode */
+	IPIPE_NF_DIAMOND
+};
+
+/* Struct for configuring NF module */
+struct prev_nf {
+	/* 0 - disable, 1 - enable */
+	unsigned char en;
+	/* Sampling method for green pixels */
+	enum ipipe_nf_sampl_meth gr_sample_meth;
+	/* Down shift value in LUT reference address
+	 */
+	unsigned char shft_val;
+	/* Spread value in NF algorithm
+	 */
+	unsigned char spread_val;
+	/* Apply LSC gain to threshold. Enable this only if
+	 * LSC is enabled in ISIF
+	 */
+	unsigned char apply_lsc_gain;
+	/* Threshold values table */
+	unsigned short thr[IPIPE_NF_THR_TABLE_SIZE];
+	/* intensity values table */
+	unsigned char str[IPIPE_NF_STR_TABLE_SIZE];
+	/* Edge detection minimum threshold */
+	unsigned short edge_det_min_thr;
+	/* Edge detection maximum threshold */
+	unsigned short edge_det_max_thr;
+};
+
+enum ipipe_gic_alg {
+	IPIPE_GIC_ALG_CONST_GAIN,
+	IPIPE_GIC_ALG_ADAPT_GAIN
+};
+
+enum ipipe_gic_thr_sel {
+	IPIPE_GIC_THR_REG,
+	IPIPE_GIC_THR_NF
+};
+
+enum ipipe_gic_wt_fn_type {
+	/* Use difference as index */
+	IPIPE_GIC_WT_FN_TYP_DIF,
+	/* Use weight function as index */
+	IPIPE_GIC_WT_FN_TYP_HP_VAL
+};
+
+/* structure for Green Imbalance Correction */
+struct prev_gic {
+	/* 0 - disable, 1 - enable */
+	unsigned char en;
+	/* 0 - Constant gain , 1 - Adaptive gain algorithm */
+	enum ipipe_gic_alg gic_alg;
+	/* GIC gain or weight. Used for Constant gain and Adaptive algorithms
+	 */
+	unsigned short gain;
+	/* Threshold selection. GIC register values or NF2 thr table */
+	enum ipipe_gic_thr_sel thr_sel;
+	/* thr1. Used when thr_sel is  IPIPE_GIC_THR_REG */
+	unsigned short thr;
+	/* this value is used for thr2-thr1, thr3-thr2 or
+	 * thr4-thr3 when wt_fn_type is index. Otherwise it
+	 * is the
+	 */
+	unsigned short slope;
+	/* Apply LSC gain to threshold. Enable this only if
+	 * LSC is enabled in ISIF & thr_sel is IPIPE_GIC_THR_REG
+	 */
+	unsigned char apply_lsc_gain;
+	/* Multiply Nf2 threshold by this gain. Use this when thr_sel
+	 * is IPIPE_GIC_THR_NF
+	 */
+	struct ipipe_float_u8 nf2_thr_gain;
+	/* Weight function uses difference as index or high pass value.
+	 * Used for adaptive gain algorithm
+	 */
+	enum ipipe_gic_wt_fn_type wt_fn_type;
+};
+
+/* Struct for configuring WB module */
+struct prev_wb {
+	/* Offset (S12) for R */
+	short ofst_r;
+	/* Offset (S12) for Gr */
+	short ofst_gr;
+	/* Offset (S12) for Gb */
+	short ofst_gb;
+	/* Offset (S12) for B */
+	short ofst_b;
+	/* Gain (U13Q9) for Red */
+	struct ipipe_float_u16 gain_r;
+	/* Gain (U13Q9) for Gr */
+	struct ipipe_float_u16 gain_gr;
+	/* Gain (U13Q9) for Gb */
+	struct ipipe_float_u16 gain_gb;
+	/* Gain (U13Q9) for Blue */
+	struct ipipe_float_u16 gain_b;
+};
+
+enum ipipe_cfa_alg {
+	/* Algorithm is 2DirAC */
+	IPIPE_CFA_ALG_2DIRAC,
+	/* Algorithm is 2DirAC + Digital Antialiasing (DAA) */
+	IPIPE_CFA_ALG_2DIRAC_DAA,
+	/* Algorithm is DAA */
+	IPIPE_CFA_ALG_DAA
+};
+
+/* Structure for CFA Interpolation */
+struct prev_cfa {
+	/* 2DirAC or 2DirAC + DAA */
+	enum ipipe_cfa_alg alg;
+	/* 2Dir CFA HP value Low Threshold */
+	unsigned short hpf_thr_2dir;
+	/* 2Dir CFA HP value slope */
+	unsigned short hpf_slp_2dir;
+	/* 2Dir CFA HP mix threshold */
+	unsigned short hp_mix_thr_2dir;
+	/* 2Dir CFA HP mix slope */
+	unsigned short hp_mix_slope_2dir;
+	/* 2Dir Direction threshold */
+	unsigned short dir_thr_2dir;
+	/* 2Dir Direction slope */
+	unsigned short dir_slope_2dir;
+	/* 2Dir NonDirectional Weight */
+	unsigned short nd_wt_2dir;
+	/* DAA Mono Hue Fraction */
+	unsigned short hue_fract_daa;
+	/* DAA Mono Edge threshold */
+	unsigned short edge_thr_daa;
+	/* DAA Mono threshold minimum */
+	unsigned short thr_min_daa;
+	/* DAA Mono threshold slope */
+	unsigned short thr_slope_daa;
+	/* DAA Mono slope minimum */
+	unsigned short slope_min_daa;
+	/* DAA Mono slope slope */
+	unsigned short slope_slope_daa;
+	/* DAA Mono LP wight */
+	unsigned short lp_wt_daa;
+};
+
+/* Struct for configuring RGB2RGB blending module */
+struct prev_rgb2rgb {
+	/* Matrix coefficient for RR S12Q8 for ID = 1 and S11Q8 for ID = 2 */
+	struct ipipe_float_s16 coef_rr;
+	/* Matrix coefficient for GR S12Q8/S11Q8 */
+	struct ipipe_float_s16 coef_gr;
+	/* Matrix coefficient for BR S12Q8/S11Q8 */
+	struct ipipe_float_s16 coef_br;
+	/* Matrix coefficient for RG S12Q8/S11Q8 */
+	struct ipipe_float_s16 coef_rg;
+	/* Matrix coefficient for GG S12Q8/S11Q8 */
+	struct ipipe_float_s16 coef_gg;
+	/* Matrix coefficient for BG S12Q8/S11Q8 */
+	struct ipipe_float_s16 coef_bg;
+	/* Matrix coefficient for RB S12Q8/S11Q8 */
+	struct ipipe_float_s16 coef_rb;
+	/* Matrix coefficient for GB S12Q8/S11Q8 */
+	struct ipipe_float_s16 coef_gb;
+	/* Matrix coefficient for BB S12Q8/S11Q8 */
+	struct ipipe_float_s16 coef_bb;
+	/* Output offset for R S13/S11 */
+	int out_ofst_r;
+	/* Output offset for G S13/S11 */
+	int out_ofst_g;
+	/* Output offset for B S13/S11 */
+	int out_ofst_b;
+};
+
+#define MAX_SIZE_GAMMA 512
+
+enum ipipe_gamma_tbl_size {
+	IPIPE_GAMMA_TBL_SZ_64 = 64,
+	IPIPE_GAMMA_TBL_SZ_128 = 128,
+	IPIPE_GAMMA_TBL_SZ_256 = 256,
+	IPIPE_GAMMA_TBL_SZ_512 = 512
+};
+
+enum ipipe_gamma_tbl_sel {
+	IPIPE_GAMMA_TBL_RAM,
+	IPIPE_GAMMA_TBL_ROM
+};
+
+struct ipipe_gamma_entry {
+	/* 10 bit slope */
+	short slope;
+	/* 10 bit offset */
+	unsigned short offset;
+};
+
+/* Struct for configuring Gamma correction module */
+struct prev_gamma {
+	/* 0 - Enable Gamma correction for Red
+	 * 1 - bypass Gamma correction. Data is divided by 16
+	 */
+	unsigned char bypass_r;
+	/* 0 - Enable Gamma correction for Blue
+	 * 1 - bypass Gamma correction. Data is divided by 16
+	 */
+	unsigned char bypass_b;
+	/* 0 - Enable Gamma correction for Green
+	 * 1 - bypass Gamma correction. Data is divided by 16
+	 */
+	unsigned char bypass_g;
+	/* PREV_GAMMA_TBL_RAM or PREV_GAMMA_TBL_ROM */
+	enum ipipe_gamma_tbl_sel tbl_sel;
+	/* Table size for RAM gamma table.
+	 */
+	enum ipipe_gamma_tbl_size tbl_size;
+	/* R table */
+	struct ipipe_gamma_entry *table_r;
+	/* Blue table */
+	struct ipipe_gamma_entry *table_b;
+	/* Green table */
+	struct ipipe_gamma_entry *table_g;
+};
+
+#define MAX_SIZE_3D_LUT		(729)
+
+struct ipipe_3d_lut_entry {
+	/* 10 bit entry for red */
+	unsigned short r;
+	/* 10 bit entry for green */
+	unsigned short g;
+	/* 10 bit entry for blue */
+	unsigned short b;
+};
+
+/* structure for 3D-LUT */
+struct prev_3d_lut {
+	/* enable/disable 3D lut */
+	unsigned char en;
+	/* 3D - LUT table entry */
+	struct ipipe_3d_lut_entry *table;
+};
+
+/* Struct for configuring Luminance Adjustment module */
+struct prev_lum_adj {
+	/* Brightness adjustments */
+	unsigned char brightness;
+	/* contrast adjustments */
+	unsigned char contrast;
+};
+
+/* Struct for configuring rgb2ycbcr module */
+struct prev_rgb2yuv {
+	/* Matrix coefficient for RY S12Q8 */
+	struct ipipe_float_s16 coef_ry;
+	/* Matrix coefficient for GY S12Q8 */
+	struct ipipe_float_s16 coef_gy;
+	/* Matrix coefficient for BY S12Q8 */
+	struct ipipe_float_s16 coef_by;
+	/* Matrix coefficient for RCb S12Q8 */
+	struct ipipe_float_s16 coef_rcb;
+	/* Matrix coefficient for GCb S12Q8 */
+	struct ipipe_float_s16 coef_gcb;
+	/* Matrix coefficient for BCb S12Q8 */
+	struct ipipe_float_s16 coef_bcb;
+	/* Matrix coefficient for RCr S12Q8 */
+	struct ipipe_float_s16 coef_rcr;
+	/* Matrix coefficient for GCr S12Q8 */
+	struct ipipe_float_s16 coef_gcr;
+	/* Matrix coefficient for BCr S12Q8 */
+	struct ipipe_float_s16 coef_bcr;
+	/* Output offset for R S11 */
+	int out_ofst_y;
+	/* Output offset for Cb S11 */
+	int out_ofst_cb;
+	/* Output offset for Cr S11 */
+	int out_ofst_cr;
+};
+
+enum ipipe_gbce_type {
+	IPIPE_GBCE_Y_VAL_TBL,
+	IPIPE_GBCE_GAIN_TBL
+};
+
+#define MAX_SIZE_GBCE_LUT 1024
+
+/* structure for Global brighness and Contrast */
+struct prev_gbce {
+	/* enable/disable GBCE */
+	unsigned char en;
+	/* Y - value table or Gain table */
+	enum ipipe_gbce_type type;
+	/* ptr to LUT for GBCE with 1024 entries */
+	unsigned short *table;
+};
+
+/* Chrominance position. Applicable only for YCbCr input
+ * Applied after edge enhancement
+ */
+enum ipipe_chr_pos {
+	/* Cositing, same position with luminance */
+	IPIPE_YUV422_CHR_POS_COSITE,
+	/* Centering, In the middle of luminance */
+	IPIPE_YUV422_CHR_POS_CENTRE
+};
+
+/* Struct for configuring yuv422 conversion module */
+struct prev_yuv422_conv {
+	/* Max Chrominance value */
+	unsigned char en_chrom_lpf;
+	/* 1 - enable LPF for chrminance, 0 - disable */
+	enum ipipe_chr_pos chrom_pos;
+};
+
+#define MAX_SIZE_YEE_LUT 1024
+
+enum ipipe_yee_merge_meth {
+	IPIPE_YEE_ABS_MAX,
+	IPIPE_YEE_EE_ES
+};
+
+/* Struct for configuring YUV Edge Enhancement module */
+struct prev_yee {
+	/* 1 - enable enhancement, 0 - disable */
+	unsigned char en;
+	/* enable/disable halo reduction in edge sharpner */
+	unsigned char en_halo_red;
+	/* Merge method between Edge Enhancer and Edge sharpner */
+	enum ipipe_yee_merge_meth merge_meth;
+	/* HPF Shift length */
+	unsigned char hpf_shft;
+	/* HPF Coefficient 00, S10 */
+	short hpf_coef_00;
+	/* HPF Coefficient 01, S10 */
+	short hpf_coef_01;
+	/* HPF Coefficient 02, S10 */
+	short hpf_coef_02;
+	/* HPF Coefficient 10, S10 */
+	short hpf_coef_10;
+	/* HPF Coefficient 11, S10 */
+	short hpf_coef_11;
+	/* HPF Coefficient 12, S10 */
+	short hpf_coef_12;
+	/* HPF Coefficient 20, S10 */
+	short hpf_coef_20;
+	/* HPF Coefficient 21, S10 */
+	short hpf_coef_21;
+	/* HPF Coefficient 22, S10 */
+	short hpf_coef_22;
+	/* Lower threshold before refering to LUT */
+	unsigned short yee_thr;
+	/* Edge sharpener Gain */
+	unsigned short es_gain;
+	/* Edge sharpener lowe threshold */
+	unsigned short es_thr1;
+	/* Edge sharpener upper threshold */
+	unsigned short es_thr2;
+	/* Edge sharpener gain on gradient */
+	unsigned short es_gain_grad;
+	/* Edge sharpener offset on gradient */
+	unsigned short es_ofst_grad;
+	/* Ptr to EE table. Must have 1024 entries */
+	short *table;
+};
+
+enum ipipe_car_meth {
+	/* Chromatic Gain Control */
+	IPIPE_CAR_CHR_GAIN_CTRL,
+	/* Dynamic switching between CHR_GAIN_CTRL
+	 * and MED_FLTR
+	 */
+	IPIPE_CAR_DYN_SWITCH,
+	/* Median Filter */
+	IPIPE_CAR_MED_FLTR
+};
+
+enum ipipe_car_hpf_type {
+	IPIPE_CAR_HPF_Y,
+	IPIPE_CAR_HPF_H,
+	IPIPE_CAR_HPF_V,
+	IPIPE_CAR_HPF_2D,
+	/* 2D HPF from YUV Edge Enhancement */
+	IPIPE_CAR_HPF_2D_YEE
+};
+
+struct ipipe_car_gain {
+	/* csup_gain */
+	unsigned char gain;
+	/* csup_shf. */
+	unsigned char shft;
+	/* gain minimum */
+	unsigned short gain_min;
+};
+
+/* Structure for Chromatic Artifact Reduction */
+struct prev_car {
+	/* enable/disable */
+	unsigned char en;
+	/* Gain control or Dynamic switching */
+	enum ipipe_car_meth meth;
+	/* Gain1 function configuration for Gain control */
+	struct ipipe_car_gain gain1;
+	/* Gain2 function configuration for Gain control */
+	struct ipipe_car_gain gain2;
+	/* HPF type used for CAR */
+	enum ipipe_car_hpf_type hpf;
+	/* csup_thr: HPF threshold for Gain control */
+	unsigned char hpf_thr;
+	/* Down shift value for hpf. 2 bits */
+	unsigned char hpf_shft;
+	/* switch limit for median filter */
+	unsigned char sw0;
+	/* switch coefficient for Gain control */
+	unsigned char sw1;
+};
+
+/* structure for Chromatic Gain Suppression */
+struct prev_cgs {
+	/* enable/disable */
+	unsigned char en;
+	/* gain1 bright side threshold */
+	unsigned char h_thr;
+	/* gain1 bright side slope */
+	unsigned char h_slope;
+	/* gain1 down shift value for bright side */
+	unsigned char h_shft;
+	/* gain1 bright side minimum gain */
+	unsigned char h_min;
+};
+
+/* various pixel formats supported */
+enum ipipe_pix_formats {
+	IPIPE_BAYER_8BIT_PACK,
+	IPIPE_BAYER_8BIT_PACK_ALAW,
+	IPIPE_BAYER_8BIT_PACK_DPCM,
+	IPIPE_BAYER_12BIT_PACK,
+	IPIPE_BAYER,		/* 16 bit */
+	IPIPE_UYVY,
+	IPIPE_YUYV,
+	IPIPE_RGB565,
+	IPIPE_RGB888,
+	IPIPE_YUV420SP,
+	IPIPE_420SP_Y,
+	IPIPE_420SP_C
+};
+
+enum ipipe_dpaths_bypass_t {
+	IPIPE_BYPASS_OFF,
+	IPIPE_BYPASS_ON
+};
+
+enum ipipe_colpat_t {
+	IPIPE_RED,
+	IPIPE_GREEN_RED,
+	IPIPE_GREEN_BLUE,
+	IPIPE_BLUE
+};
+
+enum down_scale_ave_sz {
+	IPIPE_DWN_SCALE_1_OVER_2,
+	IPIPE_DWN_SCALE_1_OVER_4,
+	IPIPE_DWN_SCALE_1_OVER_8,
+	IPIPE_DWN_SCALE_1_OVER_16,
+	IPIPE_DWN_SCALE_1_OVER_32,
+	IPIPE_DWN_SCALE_1_OVER_64,
+	IPIPE_DWN_SCALE_1_OVER_128,
+	IPIPE_DWN_SCALE_1_OVER_256
+};
+
+/* Max pixels allowed in the input. If above this either decimation
+ * or frame division mode to be enabled
+ */
+#define IPIPE_MAX_INPUT_WIDTH 2600
+
+/* Max pixels in resizer - A output. In downscale
+ * (DSCALE) mode, image quality is better, but has lesser
+ * maximum width allowed
+ */
+#define IPIPE_MAX_OUTPUT1_WIDTH_NORMAL 2176
+#define IPIPE_MAX_OUTPUT1_WIDTH_DSCALE 1088
+
+/* Max pixels in resizer - B output. In downscale
+ * (DSCALE) mode, image quality is better, but has lesser
+ * maximum width allowed
+ */
+#define IPIPE_MAX_OUTPUT2_WIDTH_NORMAL 1088
+#define IPIPE_MAX_OUTPUT2_WIDTH_DSCALE 544
+
+/* Structure for configuring Single Shot mode in the previewer
+ *   channel
+ */
+struct prev_ss_input_spec {
+	/* width of the image in SDRAM. */
+	unsigned int image_width;
+	/* height of the image in SDRAM */
+	unsigned int image_height;
+	/* line length. This will allow application to set a
+	 * different line length than that calculated based on
+	 * width. Set it to zero, if not used,
+	 */
+	unsigned int line_length;
+	/* vertical start position of the image
+	 * data to IPIPE
+	 */
+	unsigned int vst;
+	/* horizontal start position of the image
+	 * data to IPIPE
+	 */
+	unsigned int hst;
+	/* Global frame HD rate */
+	unsigned int ppln;
+	/* Global frame VD rate */
+	unsigned int lpfr;
+	/* dpcm predicator selection */
+	enum ipipeif_dpcm_pred pred;
+	/* clock divide to bring down the pixel clock */
+	struct ipipeif_5_1_clkdiv clk_div;
+	/* Shift data as per image sensor capture format
+	 * only applicable for RAW Bayer inputs
+	 */
+	enum ipipeif_5_1_data_shift data_shift;
+	/* Enable decimation 1 - enable, 0 - disable
+	 * This is used when image width is greater than
+	 * ipipe line buffer size
+	 */
+	enum ipipeif_decimation dec_en;
+	/* used when en_dec = 1. Resize ratio for decimation
+	 * when frame size is  greater than what hw can handle.
+	 * 16 to 112. IPIPE input width is calculated as follows.
+	 * width = image_width * 16/ipipeif_rsz. For example
+	 * if image_width is 1920 and user want to scale it down
+	 * to 1280, use ipipeif_rsz = 24. 1920*16/24 = 1280
+	 */
+	unsigned char rsz;
+	/* When input image width is greater that line buffer
+	 * size, use this to do resize using frame division. The
+	 * frame is divided into two vertical slices and resize
+	 * is performed on each slice. Use either frame division
+	 *  mode or decimation, NOT both
+	 */
+	unsigned char frame_div_mode_en;
+	/* Enable/Disable avg filter at IPIPEIF.
+	 * 1 - enable, 0 - disable
+	 */
+	unsigned char avg_filter_en;
+	/* Simple defect pixel correction based on a threshold value */
+	struct ipipeif_dpc dpc;
+	/* gain applied to the ipipeif output */
+	unsigned short gain;
+	/* clipped to this value at the ipipeif */
+	unsigned short clip;
+	/* Align HSync and VSync to rsz_start */
+	unsigned char align_sync;
+	/* ipipeif resize start position */
+	unsigned int rsz_start;
+	/* Input pixels formats
+	 */
+	enum ipipe_pix_formats pix_fmt;
+	/* pix order for YUV */
+	enum ipipeif_pixel_order pix_order;
+	/* Color pattern for odd line, odd pixel */
+	enum ipipe_colpat_t colp_olop;
+	/* Color pattern for odd line, even pixel */
+	enum ipipe_colpat_t colp_olep;
+	/* Color pattern for even line, odd pixel */
+	enum ipipe_colpat_t colp_elop;
+	/* Color pattern for even line, even pixel */
+	enum ipipe_colpat_t colp_elep;
+};
+
+struct prev_ss_output_spec {
+	/* output pixel format */
+	enum ipipe_pix_formats pix_fmt;
+};
+
+struct prev_single_shot_config {
+	/* Bypass image processing. RAW -> RAW */
+	enum ipipe_dpaths_bypass_t bypass;
+	/* Input specification for the image data */
+	struct prev_ss_input_spec input;
+	/* Output specification for the image data */
+	struct prev_ss_output_spec output;
+};
+
+struct prev_cont_input_spec {
+	/* 1 - enable, 0 - disable df subtraction */
+	unsigned char en_df_sub;
+	/* DF gain enable */
+	unsigned char en_df_gain;
+	/* DF gain value */
+	unsigned int df_gain;
+	/* DF gain threshold value */
+	unsigned short df_gain_thr;
+	/* Enable decimation 1 - enable, 0 - disable
+	 * This is used for bringing down the line size
+	 * to that supported by IPIPE. DM355 IPIPE
+	 * can process only 1344 pixels per line.
+	 */
+	enum ipipeif_decimation dec_en;
+	/* used when en_dec = 1. Resize ratio for decimation
+	 * when frame size is  greater than what hw can handle.
+	 * 16 to 112. IPIPE input width is calculated as follows.
+	 * width = image_width * 16/ipipeif_rsz. For example
+	 * if image_width is 1920 and user want to scale it down
+	 * to 1280, use ipipeif_rsz = 24. 1920*16/24 = 1280
+	 */
+	unsigned char rsz;
+	/* Enable/Disable avg filter at IPIPEIF.
+	 * 1 - enable, 0 - disable
+	 */
+	unsigned char avg_filter_en;
+	/* Gain applied at IPIPEIF. 1 - 1023. divided by 512.
+	 * So can be from 1/512 to  1/1023.
+	 */
+	unsigned short gain;
+	/* clipped to this value at the output of IPIPEIF */
+	unsigned short clip;
+	/* Align HSync and VSync to rsz_start */
+	unsigned char align_sync;
+	/* ipipeif resize start position */
+	unsigned int rsz_start;
+	/* Simple defect pixel correction based on a threshold value */
+	struct ipipeif_dpc dpc;
+	/* Color pattern for odd line, odd pixel */
+	enum ipipe_colpat_t colp_olop;
+	/* Color pattern for odd line, even pixel */
+	enum ipipe_colpat_t colp_olep;
+	/* Color pattern for even line, odd pixel */
+	enum ipipe_colpat_t colp_elop;
+	/* Color pattern for even line, even pixel */
+	enum ipipe_colpat_t colp_elep;
+};
+
+/* Structure for configuring Continuous mode in the previewer
+ * channel . In continuous mode, only following parameters are
+ * available for configuration from user. Rest are configured
+ * through S_CROP and S_FMT IOCTLs in CCDC driver. In this mode
+ * data to IPIPEIF comes from CCDC
+ */
+struct prev_continuous_config {
+	/* Bypass image processing. RAW -> RAW */
+	enum ipipe_dpaths_bypass_t bypass;
+	/* Input specification for the image data */
+	struct prev_cont_input_spec input;
+};
+
+/*******************************************************************
+**  Resizer API structures
+*******************************************************************/
+/* Interpolation types used for horizontal rescale */
+enum rsz_intp_t {
+	RSZ_INTP_CUBIC,
+	RSZ_INTP_LINEAR
+};
+
+/* Horizontal LPF intensity selection */
+enum rsz_h_lpf_lse_t {
+	RSZ_H_LPF_LSE_INTERN,
+	RSZ_H_LPF_LSE_USER_VAL
+};
+
+/* Structure for configuring resizer in single shot mode.
+ * This structure is used when operation mode of the
+ * resizer is single shot. The related IOCTL is
+ * RSZ_S_CONFIG & RSZ_G_CONFIG. When chained, data to
+ * resizer comes from previewer. When not chained, only
+ * UYVY data input is allowed for resizer operation.
+ * To operate on RAW Bayer data from CCDC, chain resizer
+ * with previewer by setting chain field in the
+ * rsz_channel_config structure.
+ */
+
+struct rsz_ss_input_spec {
+	/* width of the image in SDRAM. */
+	unsigned int image_width;
+	/* height of the image in SDRAM */
+	unsigned int image_height;
+	/* line length. This will allow application to set a
+	 * different line length than that calculated based on
+	 * width. Set it to zero, if not used,
+	 */
+	unsigned int line_length;
+	/* vertical start position of the image
+	 * data to IPIPE
+	 */
+	unsigned int vst;
+	/* horizontal start position of the image
+	 * data to IPIPE
+	 */
+	unsigned int hst;
+	/* Global frame HD rate */
+	unsigned int ppln;
+	/* Global frame VD rate */
+	unsigned int lpfr;
+	/* clock divide to bring down the pixel clock */
+	struct ipipeif_5_1_clkdiv clk_div;
+	/* Enable decimation 1 - enable, 0 - disable.
+	 * Used when input image width is greater than ipipe
+	 * line buffer size, this is enabled to do resize
+	 * at the input of the IPIPE to clip the size
+	 */
+	enum ipipeif_decimation dec_en;
+	/* used when en_dec = 1. Resize ratio for decimation
+	 * when frame size is  greater than what hw can handle.
+	 * 16 to 112. IPIPE input width is calculated as follows.
+	 * width = image_width * 16/ipipeif_rsz. For example
+	 * if image_width is 1920 and user want to scale it down
+	 * to 1280, use ipipeif_rsz = 24. 1920*16/24 = 1280
+	 */
+	unsigned char rsz;
+	/* When input image width is greater that line buffer
+	 * size, use this to do resize using frame division. The
+	 * frame is divided into two vertical slices and resize
+	 * is performed on each slice
+	 */
+	unsigned char frame_div_mode_en;
+	/* Enable/Disable avg filter at IPIPEIF.
+	 * 1 - enable, 0 - disable
+	 */
+	unsigned char avg_filter_en;
+	/* Align HSync and VSync to rsz_start */
+	unsigned char align_sync;
+	/* ipipeif resize start position */
+	unsigned int rsz_start;
+	/* Input pixels formats
+	 */
+	enum ipipe_pix_formats pix_fmt;
+};
+
+struct rsz_output_spec {
+	/* enable the resizer output */
+	unsigned char enable;
+	/* output pixel format. Has to be UYVY */
+	enum ipipe_pix_formats pix_fmt;
+	/* enable horizontal flip */
+	unsigned char h_flip;
+	/* enable vertical flip */
+	unsigned char v_flip;
+	/* width in pixels. must be multiple of 16. */
+	unsigned int width;
+	/* height in lines */
+	unsigned int height;
+	/* line start offset for y. */
+	unsigned int vst_y;
+	/* line start offset for c. Only for 420 */
+	unsigned int vst_c;
+	/* vertical rescale interpolation type, YCbCr or Luminance */
+	enum rsz_intp_t v_typ_y;
+	/* vertical rescale interpolation type for Chrominance */
+	enum rsz_intp_t v_typ_c;
+	/* vertical lpf intensity - Luminance */
+	unsigned char v_lpf_int_y;
+	/* vertical lpf intensity - Chrominance */
+	unsigned char v_lpf_int_c;
+	/* horizontal rescale interpolation types, YCbCr or Luminance  */
+	enum rsz_intp_t h_typ_y;
+	/* horizontal rescale interpolation types, Chrominance */
+	enum rsz_intp_t h_typ_c;
+	/* horizontal lpf intensity - Luminance */
+	unsigned char h_lpf_int_y;
+	/* horizontal lpf intensity - Chrominance */
+	unsigned char h_lpf_int_c;
+	/* Use down scale mode for scale down */
+	unsigned char en_down_scale;
+	/* if downscale, set the downscale more average size for horizontal
+	 * direction. Used only if output width and height is less than
+	 * input sizes
+	 */
+	enum down_scale_ave_sz h_dscale_ave_sz;
+	/* if downscale, set the downscale more average size for vertical
+	 * direction. Used only if output width and height is less than
+	 * input sizes
+	 */
+	enum down_scale_ave_sz v_dscale_ave_sz;
+	/* Y offset. If set, the offset would be added to the base address
+	 */
+	unsigned int user_y_ofst;
+	/* C offset. If set, the offset would be added to the base address
+	 */
+	unsigned int user_c_ofst;
+};
+
+/* In continuous mode, few parameters are set by ccdc driver. So only
+ * part of the output spec is available for user configuration
+ */
+struct rsz_part_output_spec {
+	/* enable the resizer output */
+	unsigned char enable;
+	/* enable horizontal flip */
+	unsigned char h_flip;
+	/* vertical rescale interpolation type, YCbCr or Luminance */
+	unsigned char v_flip;
+	/* vertical rescale interpolation type for Chrominance */
+	enum rsz_intp_t v_typ_y;
+	/* vertical rescale interpolation types  */
+	enum rsz_intp_t v_typ_c;
+	/* vertical lpf intensity - Luminance */
+	unsigned char v_lpf_int_y;
+	/* horizontal rescale interpolation types, YCbCr or Luminance  */
+	unsigned char v_lpf_int_c;
+	/* horizontal rescale interpolation types, Chrominance */
+	enum rsz_intp_t h_typ_y;
+	/* vertical lpf intensity - Chrominance */
+	enum rsz_intp_t h_typ_c;
+	/* horizontal lpf intensity - Luminance */
+	unsigned char h_lpf_int_y;
+	/* Use down scale mode for scale down */
+	unsigned char h_lpf_int_c;
+	/* horizontal lpf intensity - Chrominance */
+	unsigned char en_down_scale;
+	/* if downscale, set the downscale more average size for horizontal
+	 * direction. Used only if output width and height is less than
+	 * input sizes
+	 */
+	enum down_scale_ave_sz h_dscale_ave_sz;
+	/* if downscale, set the downscale more average size for vertical
+	 * direction. Used only if output width and height is less than
+	 * input sizes
+	 */
+	enum down_scale_ave_sz v_dscale_ave_sz;
+	/* Y offset. If set, the offset would be added to the base address
+	 */
+	unsigned int user_y_ofst;
+	/* C offset. If set, the offset would be added to the base address
+	 */
+	unsigned int user_c_ofst;
+};
+
+struct rsz_single_shot_config {
+	/* input spec of the image data (UYVY). non-chained
+	 * mode. Only valid when not chained. For chained
+	 * operation, previewer settings are used
+	 */
+	struct rsz_ss_input_spec input;
+	/* output spec of the image data coming out of resizer - 0(UYVY).
+	 */
+	struct rsz_output_spec output1;
+	/* output spec of the image data coming out of resizer - 1(UYVY).
+	 */
+	struct rsz_output_spec output2;
+	/* 0 , chroma sample at odd pixel, 1 - even pixel */
+	unsigned char chroma_sample_even;
+	unsigned char yuv_y_min;
+	unsigned char yuv_y_max;
+	unsigned char yuv_c_min;
+	unsigned char yuv_c_max;
+	enum ipipe_chr_pos out_chr_pos;
+};
+
+struct rsz_continuous_config {
+	/* A subset of output spec is configured by application.
+	 * Others such as size, position etc are set by CCDC driver
+	 */
+	struct rsz_part_output_spec output1;
+	struct rsz_output_spec output2;
+	/* output spec of the image data coming out of resizer - 1(UYVY).
+	 */
+	unsigned char chroma_sample_even;
+	/* 0 , chroma sample at odd pixel, 1 - even pixel */
+	unsigned char yuv_y_min;
+	unsigned char yuv_y_max;
+	unsigned char yuv_c_min;
+	unsigned char yuv_c_max;
+	enum ipipe_chr_pos out_chr_pos;
+};
+
+#endif
diff --git a/include/media/davinci/vpfe.h b/include/media/davinci/vpfe.h
new file mode 100644
index 0000000..00d2b4d
--- /dev/null
+++ b/include/media/davinci/vpfe.h
@@ -0,0 +1,91 @@
+/*
+* Copyright (C) 2011 Texas Instruments Inc
+*
+* This program is free software; you can redistribute it and/or
+* modify it under the terms of the GNU General Public License as
+* published by the Free Software Foundation version 2.
+*
+* This program is distributed in the hope that it will be useful,
+* but WITHOUT ANY WARRANTY; without even the implied warranty of
+* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+* GNU General Public License for more details.
+*
+* You should have received a copy of the GNU General Public License
+* along with this program; if not, write to the Free Software
+* Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+*/
+
+#ifndef _VPFE_H
+#define _VPFE_H
+
+#ifdef __KERNEL__
+#include <linux/v4l2-subdev.h>
+#include <linux/i2c.h>
+
+#define CAPTURE_DRV_NAME	"vpfe-capture"
+
+struct vpfe_route {
+	__u32 input;
+	__u32 output;
+};
+
+enum vpfe_subdev_id {
+	VPFE_SUBDEV_TVP5146 = 1,
+	VPFE_SUBDEV_MT9T031 = 2,
+	VPFE_SUBDEV_TVP7002 = 3,
+	VPFE_SUBDEV_MT9P031 = 4,
+};
+
+enum vpfe_pin_pol {
+	VPFE_PINPOL_POSITIVE,
+	VPFE_PINPOL_NEGATIVE
+};
+
+/* interface description */
+struct vpfe_hw_if_param {
+	enum v4l2_mbus_pixelcode if_type;
+	enum vpfe_pin_pol hdpol;
+	enum vpfe_pin_pol vdpol;
+};
+
+struct vpfe_ext_subdev_info {
+	/* v4l2 subdev */
+	struct v4l2_subdev *subdev;
+	/* Sub device module name */
+	char module_name[32];
+	/* Sub device group id */
+	int grp_id;
+	/* Number of inputs supported */
+	int num_inputs;
+	/* inputs available at the sub device */
+	struct v4l2_input *inputs;
+	/* Sub dev routing information for each input */
+	struct vpfe_route *routes;
+	/* ccdc bus/interface configuration */
+	struct vpfe_hw_if_param ccdc_if_params;
+	/* i2c subdevice board info */
+	struct i2c_board_info board_info;
+	/* Is this a camera sub device ? */
+	unsigned is_camera:1;
+	/* check if sub dev supports routing */
+	unsigned can_route:1;
+	/* registered ? */
+	unsigned registered:1;
+};
+
+struct vpfe_config {
+	/* Number of sub devices connected to vpfe */
+	int num_subdevs;
+	/* information about each subdev */
+	struct vpfe_ext_subdev_info *sub_devs;
+	/* evm card info */
+	char *card_name;
+	/* setup function for the input path */
+	int (*setup_input)(enum vpfe_subdev_id id);
+	/* number of clocks */
+	int num_clocks;
+	/* clocks used for vpfe capture */
+	char *clocks[];
+};
+#endif
+#endif
-- 
1.6.2.4

