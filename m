Return-path: <mchehab@pedra>
Received: from devils.ext.ti.com ([198.47.26.153]:49045 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753135Ab1AJKW6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Jan 2011 05:22:58 -0500
From: Manjunath Hadli <manjunath.hadli@ti.com>
To: LMML <linux-media@vger.kernel.org>,
	Kevin Hilman <khilman@deeprootsystems.com>
Cc: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Manjunath Hadli <manjunath.hadli@ti.com>
Subject: [PATCH v13 4/8] davinci vpbe: VENC( Video Encoder) implementation
Date: Mon, 10 Jan 2011 15:52:42 +0530
Message-Id: <1294654962-1771-1-git-send-email-manjunath.hadli@ti.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This patch adds the VENC or the Video encoder, which is responsible
for the blending of all source planes and timing generation for Video
modes like NTSC, PAL and other digital outputs. the VENC implementation
currently supports COMPOSITE and COMPONENT outputs and NTSC and PAL
resolutions through the analog DACs. The venc block is implemented
as a subdevice, allowing for additional external and internal encoders
of other kind to plug-in.

Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
Acked-by: Muralidharan Karicheri <m-karicheri2@ti.com>
Acked-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/davinci/vpbe_venc.c      |  556 ++++++++++++++++++++++++++
 drivers/media/video/davinci/vpbe_venc_regs.h |  177 ++++++++
 include/media/davinci/vpbe_venc.h            |   41 ++
 3 files changed, 774 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/davinci/vpbe_venc.c
 create mode 100644 drivers/media/video/davinci/vpbe_venc_regs.h
 create mode 100644 include/media/davinci/vpbe_venc.h

diff --git a/drivers/media/video/davinci/vpbe_venc.c b/drivers/media/video/davinci/vpbe_venc.c
new file mode 100644
index 0000000..1131e2d
--- /dev/null
+++ b/drivers/media/video/davinci/vpbe_venc.c
@@ -0,0 +1,556 @@
+/*
+ * Copyright (C) 2010 Texas Instruments Inc
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation version 2.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/ctype.h>
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/videodev2.h>
+#include <linux/slab.h>
+
+#include <mach/hardware.h>
+#include <mach/mux.h>
+#include <mach/io.h>
+#include <mach/i2c.h>
+
+#include <linux/io.h>
+
+#include <media/davinci/vpbe_types.h>
+#include <media/davinci/vpbe_venc.h>
+#include <media/davinci/vpss.h>
+#include <media/v4l2-device.h>
+
+#include "vpbe_venc_regs.h"
+
+#define MODULE_NAME	VPBE_VENC_SUBDEV_NAME
+
+static int debug = 2;
+module_param(debug, int, 0644);
+MODULE_PARM_DESC(debug, "Debug level 0-2");
+
+struct venc_state {
+	struct v4l2_subdev sd;
+	struct venc_callback *callback;
+	struct venc_platform_data *pdata;
+	struct device *pdev;
+	u32 output;
+	v4l2_std_id std;
+	spinlock_t lock;
+	void __iomem *venc_base;
+	void __iomem *vdaccfg_reg;
+};
+
+static inline struct venc_state *to_state(struct v4l2_subdev *sd)
+{
+	return container_of(sd, struct venc_state, sd);
+}
+
+static inline u32 venc_read(struct v4l2_subdev *sd, u32 offset)
+{
+	struct venc_state *venc = to_state(sd);
+
+	return readl(venc->venc_base + offset);
+}
+
+static inline u32 venc_write(struct v4l2_subdev *sd, u32 offset, u32 val)
+{
+	struct venc_state *venc = to_state(sd);
+	writel(val, (venc->venc_base + offset));
+	return val;
+}
+
+static inline u32 venc_modify(struct v4l2_subdev *sd, u32 offset,
+				 u32 val, u32 mask)
+{
+	u32 new_val = (venc_read(sd, offset) & ~mask) | (val & mask);
+
+	venc_write(sd, offset, new_val);
+	return new_val;
+}
+
+static inline u32 vdaccfg_write(struct v4l2_subdev *sd, u32 val)
+{
+	struct venc_state *venc = to_state(sd);
+
+	writel(val, venc->vdaccfg_reg);
+
+	val = readl(venc->vdaccfg_reg);
+	return val;
+}
+
+/* This function sets the dac of the VPBE for various outputs
+ */
+static int venc_set_dac(struct v4l2_subdev *sd, u32 out_index)
+{
+	int ret = 0;
+
+	switch (out_index) {
+	case 0:
+		v4l2_dbg(debug, 1, sd, "Setting output to Composite\n");
+		venc_write(sd, VENC_DACSEL, 0);
+		break;
+	case 1:
+		v4l2_dbg(debug, 1, sd, "Setting output to S-Video\n");
+		venc_write(sd, VENC_DACSEL, 0x210);
+		break;
+	case  2:
+		venc_write(sd, VENC_DACSEL, 0x543);
+		break;
+	default:
+		ret = -EINVAL;
+	}
+	return ret;
+}
+
+static void venc_enabledigitaloutput(struct v4l2_subdev *sd, int benable)
+{
+	v4l2_dbg(debug, 2, sd, "venc_enabledigitaloutput\n");
+
+	if (benable) {
+		venc_write(sd, VENC_VMOD, 0);
+		venc_write(sd, VENC_CVBS, 0);
+		venc_write(sd, VENC_LCDOUT, 0);
+		venc_write(sd, VENC_HSPLS, 0);
+		venc_write(sd, VENC_HSTART, 0);
+		venc_write(sd, VENC_HVALID, 0);
+		venc_write(sd, VENC_HINT, 0);
+		venc_write(sd, VENC_VSPLS, 0);
+		venc_write(sd, VENC_VSTART, 0);
+		venc_write(sd, VENC_VVALID, 0);
+		venc_write(sd, VENC_VINT, 0);
+		venc_write(sd, VENC_YCCCTL, 0);
+		venc_write(sd, VENC_DACSEL, 0);
+
+	} else {
+		venc_write(sd, VENC_VMOD, 0);
+		/* disable VCLK output pin enable */
+		venc_write(sd, VENC_VIDCTL, 0x141);
+
+		/* Disable output sync pins */
+		venc_write(sd, VENC_SYNCCTL, 0);
+
+		/* Disable DCLOCK */
+		venc_write(sd, VENC_DCLKCTL, 0);
+		venc_write(sd, VENC_DRGBX1, 0x0000057C);
+
+		/* Disable LCD output control (accepting default polarity) */
+		venc_write(sd, VENC_LCDOUT, 0);
+		venc_write(sd, VENC_CMPNT, 0x100);
+		venc_write(sd, VENC_HSPLS, 0);
+		venc_write(sd, VENC_HINT, 0);
+		venc_write(sd, VENC_HSTART, 0);
+		venc_write(sd, VENC_HVALID, 0);
+
+		venc_write(sd, VENC_VSPLS, 0);
+		venc_write(sd, VENC_VINT, 0);
+		venc_write(sd, VENC_VSTART, 0);
+		venc_write(sd, VENC_VVALID, 0);
+
+		venc_write(sd, VENC_HSDLY, 0);
+		venc_write(sd, VENC_VSDLY, 0);
+
+		venc_write(sd, VENC_YCCCTL, 0);
+		venc_write(sd, VENC_VSTARTA, 0);
+
+		/* Set OSD clock and OSD Sync Adavance registers */
+		venc_write(sd, VENC_OSDCLK0, 1);
+		venc_write(sd, VENC_OSDCLK1, 2);
+	}
+}
+
+/*
+ * setting NTSC mode
+ */
+static int venc_set_ntsc(struct v4l2_subdev *sd)
+{
+	struct venc_state *venc = to_state(sd);
+	struct venc_platform_data *pdata = venc->pdata;
+
+	v4l2_dbg(debug, 2, sd, "venc_set_ntsc\n");
+
+	/* Setup clock at VPSS & VENC for SD */
+	vpss_enable_clock(VPSS_VENC_CLOCK_SEL, 1);
+	if (pdata->setup_clock(VPBE_ENC_STD, V4L2_STD_525_60) < 0)
+		return -EINVAL;
+
+	venc_enabledigitaloutput(sd, 0);
+
+	/* to set VENC CLK DIV to 1 - final clock is 54 MHz */
+	venc_modify(sd, VENC_VIDCTL, 0, 1 << 1);
+	/* Set REC656 Mode */
+	venc_write(sd, VENC_YCCCTL, 0x1);
+	venc_modify(sd, VENC_VDPRO, 0, VENC_VDPRO_DAFRQ);
+	venc_modify(sd, VENC_VDPRO, 0, VENC_VDPRO_DAUPS);
+
+	venc_write(sd, VENC_VMOD, 0);
+	venc_modify(sd, VENC_VMOD, (1 << VENC_VMOD_VIE_SHIFT),
+			VENC_VMOD_VIE);
+	venc_modify(sd, VENC_VMOD, (0 << VENC_VMOD_VMD), VENC_VMOD_VMD);
+	venc_modify(sd, VENC_VMOD, (0 << VENC_VMOD_TVTYP_SHIFT),
+			VENC_VMOD_TVTYP);
+	venc_write(sd, VENC_DACTST, 0x0);
+	venc_modify(sd, VENC_VMOD, VENC_VMOD_VENC, VENC_VMOD_VENC);
+	return 0;
+}
+
+/*
+ * setting PAL mode
+ */
+static int venc_set_pal(struct v4l2_subdev *sd)
+{
+	struct venc_state *venc = to_state(sd);
+
+	v4l2_dbg(debug, 2, sd, "venc_set_pal\n");
+
+	/* Setup clock at VPSS & VENC for SD */
+	vpss_enable_clock(VPSS_VENC_CLOCK_SEL, 1);
+	if (venc->pdata->setup_clock(VPBE_ENC_STD, V4L2_STD_625_50) < 0)
+		return -EINVAL;
+
+	venc_enabledigitaloutput(sd, 0);
+
+	/* to set VENC CLK DIV to 1 - final clock is 54 MHz */
+	venc_modify(sd, VENC_VIDCTL, 0, 1 << 1);
+	/* Set REC656 Mode */
+	venc_write(sd, VENC_YCCCTL, 0x1);
+
+	venc_modify(sd, VENC_SYNCCTL, 1 << VENC_SYNCCTL_OVD_SHIFT,
+			VENC_SYNCCTL_OVD);
+	venc_write(sd, VENC_VMOD, 0);
+	venc_modify(sd, VENC_VMOD,
+			(1 << VENC_VMOD_VIE_SHIFT),
+			VENC_VMOD_VIE);
+	venc_modify(sd, VENC_VMOD,
+			(0 << VENC_VMOD_VMD), VENC_VMOD_VMD);
+	venc_modify(sd, VENC_VMOD,
+			(1 << VENC_VMOD_TVTYP_SHIFT),
+			VENC_VMOD_TVTYP);
+	venc_write(sd, VENC_DACTST, 0x0);
+	venc_modify(sd, VENC_VMOD, VENC_VMOD_VENC, VENC_VMOD_VENC);
+	return 0;
+}
+
+/*
+ * venc_set_480p59_94
+ *
+ * This function configures the video encoder to EDTV(525p) component setting.
+ */
+static int venc_set_480p59_94(struct v4l2_subdev *sd)
+{
+	struct venc_state *venc = to_state(sd);
+	struct venc_platform_data *pdata = venc->pdata;
+
+	v4l2_dbg(debug, 2, sd, "venc_set_480p59_94\n");
+
+	/* Setup clock at VPSS & VENC for SD */
+	if (pdata->setup_clock(VPBE_ENC_DV_PRESET, V4L2_DV_480P59_94) < 0)
+		return -EINVAL;
+
+	venc_enabledigitaloutput(sd, 0);
+
+	venc_write(sd, VENC_OSDCLK0, 0);
+	venc_write(sd, VENC_OSDCLK1, 1);
+	venc_modify(sd, VENC_VDPRO, VENC_VDPRO_DAFRQ,
+		    VENC_VDPRO_DAFRQ);
+	venc_modify(sd, VENC_VDPRO, VENC_VDPRO_DAUPS,
+		    VENC_VDPRO_DAUPS);
+	venc_write(sd, VENC_VMOD, 0);
+	venc_modify(sd, VENC_VMOD, (1 << VENC_VMOD_VIE_SHIFT),
+		    VENC_VMOD_VIE);
+	venc_modify(sd, VENC_VMOD, VENC_VMOD_HDMD, VENC_VMOD_HDMD);
+	venc_modify(sd, VENC_VMOD, (HDTV_525P << VENC_VMOD_TVTYP_SHIFT),
+		    VENC_VMOD_TVTYP);
+	venc_modify(sd, VENC_VMOD, VENC_VMOD_VDMD_YCBCR8 <<
+		    VENC_VMOD_VDMD_SHIFT, VENC_VMOD_VDMD);
+
+	venc_modify(sd, VENC_VMOD, VENC_VMOD_VENC, VENC_VMOD_VENC);
+	return 0;
+}
+
+/*
+ * venc_set_625p
+ *
+ * This function configures the video encoder to HDTV(625p) component setting
+ */
+static int venc_set_576p50(struct v4l2_subdev *sd)
+{
+	struct venc_state *venc = to_state(sd);
+	struct venc_platform_data *pdata = venc->pdata;
+
+	v4l2_dbg(debug, 2, sd, "venc_set_576p50\n");
+
+	/* Setup clock at VPSS & VENC for SD */
+	if (pdata->setup_clock(VPBE_ENC_DV_PRESET, V4L2_DV_576P50) < 0)
+		return -EINVAL;
+
+	venc_enabledigitaloutput(sd, 0);
+
+	venc_write(sd, VENC_OSDCLK0, 0);
+	venc_write(sd, VENC_OSDCLK1, 1);
+
+	venc_modify(sd, VENC_VDPRO, VENC_VDPRO_DAFRQ,
+		    VENC_VDPRO_DAFRQ);
+	venc_modify(sd, VENC_VDPRO, VENC_VDPRO_DAUPS,
+		    VENC_VDPRO_DAUPS);
+
+	venc_write(sd, VENC_VMOD, 0);
+	venc_modify(sd, VENC_VMOD, (1 << VENC_VMOD_VIE_SHIFT),
+		    VENC_VMOD_VIE);
+	venc_modify(sd, VENC_VMOD, VENC_VMOD_HDMD, VENC_VMOD_HDMD);
+	venc_modify(sd, VENC_VMOD, (HDTV_625P << VENC_VMOD_TVTYP_SHIFT),
+		    VENC_VMOD_TVTYP);
+
+	venc_modify(sd, VENC_VMOD, VENC_VMOD_VDMD_YCBCR8 <<
+		    VENC_VMOD_VDMD_SHIFT, VENC_VMOD_VDMD);
+	venc_modify(sd, VENC_VMOD, VENC_VMOD_VENC, VENC_VMOD_VENC);
+	return 0;
+}
+
+static int venc_s_std_output(struct v4l2_subdev *sd, v4l2_std_id norm)
+{
+	v4l2_dbg(debug, 1, sd, "venc_s_std_output\n");
+
+	if (norm & V4L2_STD_525_60)
+		return venc_set_ntsc(sd);
+	else if (norm & V4L2_STD_625_50)
+		return venc_set_pal(sd);
+	return -EINVAL;
+}
+
+static int venc_s_dv_preset(struct v4l2_subdev *sd,
+			    struct v4l2_dv_preset *dv_preset)
+{
+	v4l2_dbg(debug, 1, sd, "venc_s_dv_preset\n");
+
+	if (dv_preset->preset == V4L2_DV_576P50)
+		return venc_set_576p50(sd);
+	else if (dv_preset->preset == V4L2_DV_480P59_94)
+		return venc_set_480p59_94(sd);
+	return -EINVAL;
+}
+
+static int venc_s_routing(struct v4l2_subdev *sd, u32 input, u32 output,
+			  u32 config)
+{
+	struct venc_state *venc = to_state(sd);
+	int max_output, lcd_out_index, ret = 0;
+
+	v4l2_dbg(debug, 1, sd, "venc_s_routing\n");
+
+	max_output = 2 + venc->pdata->num_lcd_outputs;
+	lcd_out_index = 3;
+
+	if (output >= max_output)
+		return -EINVAL;
+
+	if (output < lcd_out_index)
+		ret = venc_set_dac(sd, output);
+	if (!ret)
+		venc->output = output;
+	return ret;
+}
+
+static long venc_ioctl(struct v4l2_subdev *sd,
+			unsigned int cmd,
+			void *arg)
+{
+	u32 val;
+	switch (cmd) {
+	case VENC_GET_FLD:
+		val = venc_read(sd, VENC_VSTAT);
+		*((int *)arg) = ((val & VENC_VSTAT_FIDST) ==
+		VENC_VSTAT_FIDST);
+		break;
+	default:
+		v4l2_err(sd, "Wrong IOCTL cmd\n");
+		break;
+	}
+	return 0;
+}
+
+static const struct v4l2_subdev_core_ops venc_core_ops = {
+	.ioctl      = venc_ioctl,
+};
+
+static const struct v4l2_subdev_video_ops venc_video_ops = {
+	.s_routing = venc_s_routing,
+	.s_std_output = venc_s_std_output,
+	.s_dv_preset = venc_s_dv_preset,
+};
+
+static const struct v4l2_subdev_ops venc_ops = {
+	.core = &venc_core_ops,
+	.video = &venc_video_ops,
+};
+
+static int venc_initialize(struct v4l2_subdev *sd)
+{
+	struct venc_state *venc = to_state(sd);
+	int ret = 0;
+
+	/* Set default to output to composite and std to NTSC */
+	venc->output = 0;
+	venc->std = V4L2_STD_525_60;
+
+	ret = venc_s_routing(sd, 0, venc->output, 0);
+	if (ret < 0) {
+		v4l2_err(sd, "Error setting output during init\n");
+		return -EINVAL;
+	}
+
+	ret = venc_s_std_output(sd, venc->std);
+	if (ret < 0) {
+		v4l2_err(sd, "Error setting std during init\n");
+		return -EINVAL;
+	}
+	return ret;
+}
+
+static int venc_device_get(struct device *dev, void *data)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct venc_state **venc = data;
+
+	if (strcmp(MODULE_NAME, pdev->name) == 0)
+		*venc = platform_get_drvdata(pdev);
+	return 0;
+}
+
+struct v4l2_subdev *venc_sub_dev_init(struct v4l2_device *v4l2_dev,
+		const char *venc_name)
+{
+	struct venc_state *venc;
+	int err;
+
+	err = bus_for_each_dev(&platform_bus_type, NULL, &venc,
+			venc_device_get);
+	if (venc == NULL)
+		return NULL;
+
+	v4l2_subdev_init(&venc->sd, &venc_ops);
+
+	strcpy(venc->sd.name, venc_name);
+	if (v4l2_device_register_subdev(v4l2_dev, &venc->sd) < 0) {
+		v4l2_err(v4l2_dev,
+			"vpbe unable to register venc sub device\n");
+		return NULL;
+	}
+	if (venc_initialize(&venc->sd)) {
+		v4l2_err(v4l2_dev,
+			"vpbe venc initialization failed\n");
+		return NULL;
+	}
+	return &venc->sd;
+}
+EXPORT_SYMBOL(venc_sub_dev_init);
+
+static int venc_probe(struct platform_device *pdev)
+{
+	struct venc_state *venc;
+	struct resource *res;
+	int ret;
+
+	venc = kzalloc(sizeof(struct venc_state), GFP_KERNEL);
+	if (venc == NULL)
+		return -ENOMEM;
+
+	venc->pdev = &pdev->dev;
+	venc->pdata = pdev->dev.platform_data;
+	if (NULL == venc->pdata) {
+		dev_err(venc->pdev, "Unable to get platform data for"
+			" VENC sub device");
+		ret = -ENOENT;
+		goto free_mem;
+	}
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_err(venc->pdev,
+			"Unable to get VENC register address map\n");
+		ret = -ENODEV;
+		goto free_mem;
+	}
+
+	if (!request_mem_region(res->start, resource_size(res), "venc")) {
+		dev_err(venc->pdev, "Unable to reserve VENC MMIO region\n");
+		ret = -ENODEV;
+		goto free_mem;
+	}
+
+	venc->venc_base = ioremap_nocache(res->start, resource_size(res));
+	if (!venc->venc_base) {
+		dev_err(venc->pdev, "Unable to map VENC IO space\n");
+		ret = -ENODEV;
+		goto release_venc_mem_region;
+	}
+
+	spin_lock_init(&venc->lock);
+	platform_set_drvdata(pdev, venc);
+	dev_notice(venc->pdev, "VENC sub device probe success\n");
+	return 0;
+
+release_venc_mem_region:
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	release_mem_region(res->start, resource_size(res));
+free_mem:
+	kfree(venc);
+	return ret;
+}
+
+static int venc_remove(struct platform_device *pdev)
+{
+	struct venc_state *venc = platform_get_drvdata(pdev);
+	struct resource *res;
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	iounmap((void *)venc->venc_base);
+	release_mem_region(res->start, resource_size(res));
+	kfree(venc);
+	return 0;
+}
+
+static struct platform_driver venc_driver = {
+	.probe		= venc_probe,
+	.remove		= venc_remove,
+	.driver		= {
+		.name	= MODULE_NAME,
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int venc_init(void)
+{
+	if (platform_driver_register(&venc_driver)) {
+		printk(KERN_ERR "Unable to register venc driver\n");
+		return -ENODEV;
+	}
+	return 0;
+}
+
+static void venc_exit(void)
+{
+	platform_driver_unregister(&venc_driver);
+	return;
+}
+
+module_init(venc_init);
+module_exit(venc_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("VPBE VENC Driver");
+MODULE_AUTHOR("Texas Instruments");
diff --git a/drivers/media/video/davinci/vpbe_venc_regs.h b/drivers/media/video/davinci/vpbe_venc_regs.h
new file mode 100644
index 0000000..947cb15
--- /dev/null
+++ b/drivers/media/video/davinci/vpbe_venc_regs.h
@@ -0,0 +1,177 @@
+/*
+ * Copyright (C) 2006-2010 Texas Instruments Inc
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation version 2..
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ */
+#ifndef _VPBE_VENC_REGS_H
+#define _VPBE_VENC_REGS_H
+
+/* VPBE Video Encoder / Digital LCD Subsystem Registers (VENC) */
+#define VENC_VMOD				0x00
+#define VENC_VIDCTL				0x04
+#define VENC_VDPRO				0x08
+#define VENC_SYNCCTL				0x0C
+#define VENC_HSPLS				0x10
+#define VENC_VSPLS				0x14
+#define VENC_HINT				0x18
+#define VENC_HSTART				0x1C
+#define VENC_HVALID				0x20
+#define VENC_VINT				0x24
+#define VENC_VSTART				0x28
+#define VENC_VVALID				0x2C
+#define VENC_HSDLY				0x30
+#define VENC_VSDLY				0x34
+#define VENC_YCCCTL				0x38
+#define VENC_RGBCTL				0x3C
+#define VENC_RGBCLP				0x40
+#define VENC_LINECTL				0x44
+#define VENC_CULLLINE				0x48
+#define VENC_LCDOUT				0x4C
+#define VENC_BRTS				0x50
+#define VENC_BRTW				0x54
+#define VENC_ACCTL				0x58
+#define VENC_PWMP				0x5C
+#define VENC_PWMW				0x60
+#define VENC_DCLKCTL				0x64
+#define VENC_DCLKPTN0				0x68
+#define VENC_DCLKPTN1				0x6C
+#define VENC_DCLKPTN2				0x70
+#define VENC_DCLKPTN3				0x74
+#define VENC_DCLKPTN0A				0x78
+#define VENC_DCLKPTN1A				0x7C
+#define VENC_DCLKPTN2A				0x80
+#define VENC_DCLKPTN3A				0x84
+#define VENC_DCLKHS				0x88
+#define VENC_DCLKHSA				0x8C
+#define VENC_DCLKHR				0x90
+#define VENC_DCLKVS				0x94
+#define VENC_DCLKVR				0x98
+#define VENC_CAPCTL				0x9C
+#define VENC_CAPDO				0xA0
+#define VENC_CAPDE				0xA4
+#define VENC_ATR0				0xA8
+#define VENC_ATR1				0xAC
+#define VENC_ATR2				0xB0
+#define VENC_VSTAT				0xB8
+#define VENC_RAMADR				0xBC
+#define VENC_RAMPORT				0xC0
+#define VENC_DACTST				0xC4
+#define VENC_YCOLVL				0xC8
+#define VENC_SCPROG				0xCC
+#define VENC_CVBS				0xDC
+#define VENC_CMPNT				0xE0
+#define VENC_ETMG0				0xE4
+#define VENC_ETMG1				0xE8
+#define VENC_ETMG2				0xEC
+#define VENC_ETMG3				0xF0
+#define VENC_DACSEL				0xF4
+#define VENC_ARGBX0				0x100
+#define VENC_ARGBX1				0x104
+#define VENC_ARGBX2				0x108
+#define VENC_ARGBX3				0x10C
+#define VENC_ARGBX4				0x110
+#define VENC_DRGBX0				0x114
+#define VENC_DRGBX1				0x118
+#define VENC_DRGBX2				0x11C
+#define VENC_DRGBX3				0x120
+#define VENC_DRGBX4				0x124
+#define VENC_VSTARTA				0x128
+#define VENC_OSDCLK0				0x12C
+#define VENC_OSDCLK1				0x130
+#define VENC_HVLDCL0				0x134
+#define VENC_HVLDCL1				0x138
+#define VENC_OSDHADV				0x13C
+#define VENC_CLKCTL				0x140
+#define VENC_GAMCTL				0x144
+#define VENC_XHINTVL				0x174
+
+/* bit definitions */
+#define VPBE_PCR_VENC_DIV			(1 << 1)
+#define VPBE_PCR_CLK_OFF			(1 << 0)
+
+#define VENC_VMOD_VDMD_SHIFT			12
+#define VENC_VMOD_VDMD_YCBCR16			0
+#define VENC_VMOD_VDMD_YCBCR8			1
+#define VENC_VMOD_VDMD_RGB666			2
+#define VENC_VMOD_VDMD_RGB8			3
+#define VENC_VMOD_VDMD_EPSON			4
+#define VENC_VMOD_VDMD_CASIO			5
+#define VENC_VMOD_VDMD_UDISPQVGA		6
+#define VENC_VMOD_VDMD_STNLCD			7
+#define VENC_VMOD_VIE_SHIFT			1
+#define VENC_VMOD_VDMD				(7 << 12)
+#define VENC_VMOD_ITLCL				(1 << 11)
+#define VENC_VMOD_ITLC				(1 << 10)
+#define VENC_VMOD_NSIT				(1 << 9)
+#define VENC_VMOD_HDMD				(1 << 8)
+#define VENC_VMOD_TVTYP_SHIFT			6
+#define VENC_VMOD_TVTYP				(3 << 6)
+#define VENC_VMOD_SLAVE				(1 << 5)
+#define VENC_VMOD_VMD				(1 << 4)
+#define VENC_VMOD_BLNK				(1 << 3)
+#define VENC_VMOD_VIE				(1 << 1)
+#define VENC_VMOD_VENC				(1 << 0)
+
+/* VMOD TVTYP options for HDMD=0 */
+#define SDTV_NTSC				0
+#define SDTV_PAL				1
+/* VMOD TVTYP options for HDMD=1 */
+#define HDTV_525P				0
+#define HDTV_625P				1
+#define HDTV_1080I				2
+#define HDTV_720P				3
+
+#define VENC_VIDCTL_VCLKP			(1 << 14)
+#define VENC_VIDCTL_VCLKE_SHIFT			13
+#define VENC_VIDCTL_VCLKE			(1 << 13)
+#define VENC_VIDCTL_VCLKZ_SHIFT			12
+#define VENC_VIDCTL_VCLKZ			(1 << 12)
+#define VENC_VIDCTL_SYDIR_SHIFT			8
+#define VENC_VIDCTL_SYDIR			(1 << 8)
+#define VENC_VIDCTL_DOMD_SHIFT			4
+#define VENC_VIDCTL_DOMD			(3 << 4)
+#define VENC_VIDCTL_YCDIR_SHIFT			0
+#define VENC_VIDCTL_YCDIR			(1 << 0)
+
+#define VENC_VDPRO_ATYCC_SHIFT			5
+#define VENC_VDPRO_ATYCC			(1 << 5)
+#define VENC_VDPRO_ATCOM_SHIFT			4
+#define VENC_VDPRO_ATCOM			(1 << 4)
+#define VENC_VDPRO_DAFRQ			(1 << 3)
+#define VENC_VDPRO_DAUPS			(1 << 2)
+#define VENC_VDPRO_CUPS				(1 << 1)
+#define VENC_VDPRO_YUPS				(1 << 0)
+
+#define VENC_SYNCCTL_VPL_SHIFT			3
+#define VENC_SYNCCTL_VPL			(1 << 3)
+#define VENC_SYNCCTL_HPL_SHIFT			2
+#define VENC_SYNCCTL_HPL			(1 << 2)
+#define VENC_SYNCCTL_SYEV_SHIFT			1
+#define VENC_SYNCCTL_SYEV			(1 << 1)
+#define VENC_SYNCCTL_SYEH_SHIFT			0
+#define VENC_SYNCCTL_SYEH			(1 << 0)
+#define VENC_SYNCCTL_OVD_SHIFT			14
+#define VENC_SYNCCTL_OVD			(1 << 14)
+
+#define VENC_DCLKCTL_DCKEC_SHIFT		11
+#define VENC_DCLKCTL_DCKEC			(1 << 11)
+#define VENC_DCLKCTL_DCKPW_SHIFT		0
+#define VENC_DCLKCTL_DCKPW			(0x3f << 0)
+
+#define VENC_VSTAT_FIDST			(1 << 4)
+
+#define VENC_CMPNT_MRGB_SHIFT			14
+#define VENC_CMPNT_MRGB				(1 << 14)
+
+#endif				/* _VPBE_VENC_REGS_H */
diff --git a/include/media/davinci/vpbe_venc.h b/include/media/davinci/vpbe_venc.h
new file mode 100644
index 0000000..1e145f8
--- /dev/null
+++ b/include/media/davinci/vpbe_venc.h
@@ -0,0 +1,41 @@
+/*
+ * Copyright (C) 2010 Texas Instruments Inc
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation version 2.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ */
+#ifndef _VPBE_VENC_H
+#define _VPBE_VENC_H
+
+#include <media/v4l2-subdev.h>
+
+#define VPBE_VENC_SUBDEV_NAME "vpbe-venc"
+
+/* venc events */
+#define VENC_END_OF_FRAME	BIT(0)
+#define VENC_FIRST_FIELD	BIT(1)
+#define VENC_SECOND_FIELD	BIT(2)
+
+struct venc_platform_data {
+	enum vpbe_types venc_type;
+	int (*setup_clock)(enum vpbe_enc_timings_type type,
+			__u64 mode);
+	/* Number of LCD outputs supported */
+	int num_lcd_outputs;
+};
+
+enum venc_ioctls {
+	VENC_GET_FLD = 1,
+};
+
+#endif
-- 
1.6.2.4

