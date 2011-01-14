Return-path: <mchehab@pedra>
Received: from arroyo.ext.ti.com ([192.94.94.40]:40423 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753935Ab1ANN3d (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Jan 2011 08:29:33 -0500
From: Manjunath Hadli <manjunath.hadli@ti.com>
To: LMML <linux-media@vger.kernel.org>,
	Kevin Hilman <khilman@deeprootsystems.com>
Cc: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Manjunath Hadli <manjunath.hadli@ti.com>
Subject: [PATCH v14 2/6] davinci vpbe: VPBE display driver
Date: Fri, 14 Jan 2011 18:59:15 +0530
Message-Id: <1295011756-32654-1-git-send-email-manjunath.hadli@ti.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This patch implements the core functionality of the dislay driver,
mainly controlling the VENC and other encoders, and acting as
the one point interface for the main V4L2 driver. This implements
the core of each of the V4L2 IOCTLs.

Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
Acked-by: Muralidharan Karicheri <m-karicheri2@ti.com>
Acked-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/davinci/vpbe.c |  826 ++++++++++++++++++++++++++++++++++++
 include/media/davinci/vpbe.h       |  185 ++++++++
 2 files changed, 1011 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/davinci/vpbe.c
 create mode 100644 include/media/davinci/vpbe.h

diff --git a/drivers/media/video/davinci/vpbe.c b/drivers/media/video/davinci/vpbe.c
new file mode 100644
index 0000000..d3aaf1e
--- /dev/null
+++ b/drivers/media/video/davinci/vpbe.c
@@ -0,0 +1,826 @@
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
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/errno.h>
+#include <linux/fs.h>
+#include <linux/string.h>
+#include <linux/wait.h>
+#include <linux/time.h>
+#include <linux/platform_device.h>
+#include <linux/io.h>
+#include <linux/slab.h>
+#include <linux/clk.h>
+#include <linux/err.h>
+
+#include <media/v4l2-device.h>
+#include <media/davinci/vpbe_types.h>
+#include <media/davinci/vpbe.h>
+#include <media/davinci/vpss.h>
+
+#define VPBE_DEFAULT_OUTPUT	"Composite"
+#define VPBE_DEFAULT_MODE	"ntsc"
+
+static char *def_output = VPBE_DEFAULT_OUTPUT;
+static char *def_mode = VPBE_DEFAULT_MODE;
+static  struct osd_state *osd_device;
+static struct venc_platform_data *venc_device;
+static int debug;
+
+module_param(def_output, charp, S_IRUGO);
+module_param(def_mode, charp, S_IRUGO);
+module_param(debug, int, 0644);
+
+MODULE_PARM_DESC(def_output, "vpbe output name (default:Composite)");
+MODULE_PARM_DESC(def_mode, "vpbe output mode name (default:ntsc");
+MODULE_PARM_DESC(debug, "Debug level 0-1");
+
+MODULE_DESCRIPTION("TI DMXXX VPBE Display controller");
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Texas Instruments");
+
+/**
+ * vpbe_current_encoder_info - Get config info for current encoder
+ * @vpbe_dev - vpbe device ptr
+ *
+ * Return ptr to current encoder config info
+ */
+static struct encoder_config_info*
+vpbe_current_encoder_info(struct vpbe_device *vpbe_dev)
+{
+	struct vpbe_display_config *vpbe_config = vpbe_dev->cfg;
+	int index = vpbe_dev->current_sd_index;
+
+	return ((index == 0) ? &vpbe_config->venc :
+				&vpbe_config->ext_encoders[index-1]);
+}
+
+/**
+ * vpbe_find_encoder_sd_index - Given a name find encoder sd index
+ *
+ * @vpbe_config - ptr to vpbe cfg
+ * @output_index - index used by application
+ *
+ * Return sd index of the encoder
+ */
+static int vpbe_find_encoder_sd_index(struct vpbe_display_config *vpbe_config,
+			     int index)
+{
+	char *encoder_name = vpbe_config->outputs[index].subdev_name;
+	int i;
+
+	/* Venc is always first	*/
+	if (!strcmp(encoder_name, vpbe_config->venc.module_name))
+		return 0;
+
+	for (i = 0; i < vpbe_config->num_ext_encoders; i++) {
+		if (!strcmp(encoder_name,
+		     vpbe_config->ext_encoders[i].module_name))
+			return i+1;
+	}
+	return -EINVAL;
+}
+
+/**
+ * vpbe_g_cropcap - Get crop capabilities of the display
+ * @vpbe_dev - vpbe device ptr
+ * @cropcap - cropcap is a ptr to struct v4l2_cropcap
+ *
+ * Update the crop capabilities in crop cap for current
+ * mode
+ */
+static int vpbe_g_cropcap(struct vpbe_device *vpbe_dev,
+			  struct v4l2_cropcap *cropcap)
+{
+	if (NULL == cropcap)
+		return -EINVAL;
+	cropcap->bounds.left = 0;
+	cropcap->bounds.top = 0;
+	cropcap->bounds.width = vpbe_dev->current_timings.xres;
+	cropcap->bounds.height = vpbe_dev->current_timings.yres;
+	cropcap->defrect = cropcap->bounds;
+	return 0;
+}
+
+/**
+ * vpbe_enum_outputs - enumerate outputs
+ * @vpbe_dev - vpbe device ptr
+ * @output - ptr to v4l2_output structure
+ *
+ * Enumerates the outputs available at the vpbe display
+ * returns the status, -EINVAL if end of output list
+ */
+static int vpbe_enum_outputs(struct vpbe_device *vpbe_dev,
+			     struct v4l2_output *output)
+{
+	struct vpbe_display_config *vpbe_config = vpbe_dev->cfg;
+	int temp_index = output->index;
+
+	if (temp_index >= vpbe_config->num_outputs)
+		return -EINVAL;
+
+	*output = vpbe_config->outputs[temp_index].output;
+	output->index = temp_index;
+	return 0;
+}
+
+static int vpbe_get_mode_info(struct vpbe_device *vpbe_dev, char *mode)
+{
+	struct vpbe_display_config *cfg = vpbe_dev->cfg;
+	struct vpbe_enc_mode_info var;
+	int curr_output = vpbe_dev->current_out_index, i;
+
+	if (NULL == mode)
+		return -EINVAL;
+
+	for (i = 0; i < cfg->outputs[curr_output].num_modes; i++) {
+		var = cfg->outputs[curr_output].modes[i];
+		if (!strcmp(mode, var.name)) {
+			vpbe_dev->current_timings = var;
+			return 0;
+		}
+	}
+	return -EINVAL;
+}
+
+static int vpbe_get_current_mode_info(struct vpbe_device *vpbe_dev,
+				      struct vpbe_enc_mode_info *mode_info)
+{
+	if (NULL == mode_info)
+		return -EINVAL;
+
+	*mode_info = vpbe_dev->current_timings;
+	return 0;
+}
+
+static int vpbe_get_dv_preset_info(struct vpbe_device *vpbe_dev,
+				   unsigned int dv_preset)
+{
+	struct vpbe_display_config *cfg = vpbe_dev->cfg;
+	struct vpbe_enc_mode_info var;
+	int curr_output = vpbe_dev->current_out_index, i;
+
+	for (i = 0; i < vpbe_dev->cfg->outputs[curr_output].num_modes; i++) {
+		var = cfg->outputs[curr_output].modes[i];
+		if ((var.timings_type & VPBE_ENC_DV_PRESET) &&
+		  (var.timings.dv_preset == dv_preset)) {
+			vpbe_dev->current_timings = var;
+			return 0;
+		}
+	}
+	return -EINVAL;
+}
+
+/* Get std by std id */
+static int vpbe_get_std_info(struct vpbe_device *vpbe_dev,
+			     v4l2_std_id std_id)
+{
+	struct vpbe_display_config *cfg = vpbe_dev->cfg;
+	struct vpbe_enc_mode_info var;
+	int curr_output = vpbe_dev->current_out_index, i;
+
+	for (i = 0; i < vpbe_dev->cfg->outputs[curr_output].num_modes; i++) {
+		var = cfg->outputs[curr_output].modes[i];
+		if ((var.timings_type & VPBE_ENC_STD) &&
+		  (var.timings.std_id & std_id)) {
+			vpbe_dev->current_timings = var;
+			return 0;
+		}
+	}
+	return -EINVAL;
+}
+
+static int vpbe_get_std_info_by_name(struct vpbe_device *vpbe_dev,
+				char *std_name)
+{
+	struct vpbe_display_config *cfg = vpbe_dev->cfg;
+	struct vpbe_enc_mode_info var;
+	int curr_output = vpbe_dev->current_out_index, i;
+
+	for (i = 0; i < vpbe_dev->cfg->outputs[curr_output].num_modes; i++) {
+		var = cfg->outputs[curr_output].modes[i];
+		if (!strcmp(var.name, std_name)) {
+			vpbe_dev->current_timings = var;
+			return 0;
+		}
+	}
+	return -EINVAL;
+}
+
+/**
+ * vpbe_set_output - Set output
+ * @vpbe_dev - vpbe device ptr
+ * @index - index of output
+ *
+ * Set vpbe output to the output specified by the index
+ */
+static int vpbe_set_output(struct vpbe_device *vpbe_dev, int index)
+{
+	struct vpbe_display_config *vpbe_config = vpbe_dev->cfg;
+	struct encoder_config_info *curr_enc_info =
+			vpbe_current_encoder_info(vpbe_dev);
+	int ret = 0, enc_out_index = 0, sd_index;
+
+	if (index >= vpbe_config->num_outputs)
+		return -EINVAL;
+
+	mutex_lock(&vpbe_dev->lock);
+
+	sd_index = vpbe_dev->current_sd_index;
+	enc_out_index = vpbe_config->outputs[index].output.index;
+	/*
+	 * Currently we switch the encoder based on output selected
+	 * by the application. If media controller is implemented later
+	 * there is will be an API added to setup_link between venc
+	 * and external encoder. So in that case below comparison always
+	 * match and encoder will not be switched. But if application
+	 * chose not to use media controller, then this provides current
+	 * way of switching encoder at the venc output.
+	 */
+	if (strcmp(curr_enc_info->module_name,
+		   vpbe_config->outputs[index].subdev_name)) {
+		/* Need to switch the encoder at the output */
+		sd_index = vpbe_find_encoder_sd_index(vpbe_config, index);
+		if (sd_index < 0) {
+			ret = -EINVAL;
+			goto out;
+		}
+
+		if (ret)
+			goto out;
+	}
+
+	/* Set output at the encoder */
+	ret = v4l2_subdev_call(vpbe_dev->encoders[sd_index], video,
+				       s_routing, 0, enc_out_index, 0);
+	if (ret)
+		goto out;
+
+	/*
+	 * It is assumed that venc or extenal encoder will set a default
+	 * mode in the sub device. For external encoder or LCD pannel output,
+	 * we also need to set up the lcd port for the required mode. So setup
+	 * the lcd port for the default mode that is configured in the board
+	 * arch/arm/mach-davinci/board-dm355-evm.setup file for the external
+	 * encoder.
+	 */
+	ret = vpbe_get_mode_info(vpbe_dev,
+				 vpbe_config->outputs[index].default_mode);
+	if (!ret) {
+		osd_device->ops.set_left_margin(osd_device,
+			vpbe_dev->current_timings.left_margin);
+		osd_device->ops.set_top_margin(osd_device,
+		vpbe_dev->current_timings.upper_margin);
+		vpbe_dev->current_sd_index = sd_index;
+		vpbe_dev->current_out_index = index;
+	}
+out:
+	mutex_unlock(&vpbe_dev->lock);
+	return ret;
+}
+
+static int vpbe_set_default_output(struct vpbe_device *vpbe_dev)
+{
+	struct vpbe_display_config *vpbe_config = vpbe_dev->cfg;
+	int i, ret = 0;
+
+	for (i = 0; i < vpbe_config->num_outputs; i++) {
+		if (!strcmp(def_output,
+			    vpbe_config->outputs[i].output.name)) {
+			ret = vpbe_set_output(vpbe_dev, i);
+			if (!ret)
+				vpbe_dev->current_out_index = i;
+			return ret;
+		}
+	}
+	return ret;
+}
+
+/**
+ * vpbe_get_output - Get output
+ * @vpbe_dev - vpbe device ptr
+ *
+ * return current vpbe output to the the index
+ */
+static unsigned int vpbe_get_output(struct vpbe_device *vpbe_dev)
+{
+	return vpbe_dev->current_out_index;
+}
+
+/**
+ * vpbe_s_dv_preset - Set the given preset timings in the encoder
+ *
+ * Sets the preset if supported by the current encoder. Return the status.
+ * 0 - success & -EINVAL on error
+ */
+static int vpbe_s_dv_preset(struct vpbe_device *vpbe_dev,
+		     struct v4l2_dv_preset *dv_preset)
+{
+	struct vpbe_display_config *vpbe_config = vpbe_dev->cfg;
+	int sd_index = vpbe_dev->current_sd_index;
+	int out_index = vpbe_dev->current_out_index, ret;
+
+
+	if (!(vpbe_config->outputs[out_index].output.capabilities &
+	    V4L2_OUT_CAP_PRESETS))
+		return -EINVAL;
+
+	ret = vpbe_get_dv_preset_info(vpbe_dev, dv_preset->preset);
+
+	if (ret)
+		return ret;
+
+	mutex_lock(&vpbe_dev->lock);
+
+
+	ret = v4l2_subdev_call(vpbe_dev->encoders[sd_index], video,
+					s_dv_preset, dv_preset);
+	/* set the lcd controller output for the given mode */
+	if (!ret) {
+		osd_device->ops.set_left_margin(osd_device,
+		vpbe_dev->current_timings.left_margin);
+		osd_device->ops.set_top_margin(osd_device,
+		vpbe_dev->current_timings.upper_margin);
+	}
+	mutex_unlock(&vpbe_dev->lock);
+	return ret;
+}
+
+/**
+ * vpbe_g_dv_preset - Get the preset in the current encoder
+ *
+ * Get the preset in the current encoder. Return the status. 0 - success
+ * -EINVAL on error
+ */
+static int vpbe_g_dv_preset(struct vpbe_device *vpbe_dev,
+		     struct v4l2_dv_preset *dv_preset)
+{
+	if (vpbe_dev->current_timings.timings_type &
+	  VPBE_ENC_DV_PRESET) {
+		dv_preset->preset = vpbe_dev->current_timings.timings.dv_preset;
+		return 0;
+	}
+	return -EINVAL;
+}
+
+/**
+ * vpbe_enum_dv_presets - Enumerate the dv presets in the current encoder
+ *
+ * Get the preset in the current encoder. Return the status. 0 - success
+ * -EINVAL on error
+ */
+static int vpbe_enum_dv_presets(struct vpbe_device *vpbe_dev,
+			 struct v4l2_dv_enum_preset *preset_info)
+{
+	struct vpbe_display_config *vpbe_config = vpbe_dev->cfg;
+	int out_index = vpbe_dev->current_out_index;
+	struct vpbe_output *output = &vpbe_config->outputs[out_index];
+	int i, j = 0;
+
+	if (!(output->output.capabilities & V4L2_OUT_CAP_PRESETS))
+		return -EINVAL;
+
+	for (i = 0; i < output->num_modes; i++) {
+		if (output->modes[i].timings_type == VPBE_ENC_DV_PRESET) {
+			if (j == preset_info->index)
+				break;
+			j++;
+		}
+	}
+
+	if (i == output->num_modes)
+		return -EINVAL;
+
+	return v4l_fill_dv_preset_info(output->modes[i].timings.dv_preset,
+					preset_info);
+}
+
+/**
+ * vpbe_s_std - Set the given standard in the encoder
+ *
+ * Sets the standard if supported by the current encoder. Return the status.
+ * 0 - success & -EINVAL on error
+ */
+static int vpbe_s_std(struct vpbe_device *vpbe_dev, v4l2_std_id *std_id)
+{
+	struct vpbe_display_config *vpbe_config = vpbe_dev->cfg;
+	int sd_index = vpbe_dev->current_sd_index, out_index =
+			vpbe_dev->current_out_index, ret;
+
+	if (!(vpbe_config->outputs[out_index].output.capabilities &
+		V4L2_OUT_CAP_STD))
+		return -EINVAL;
+
+	ret = vpbe_get_std_info(vpbe_dev, *std_id);
+	if (ret)
+		return ret;
+
+	mutex_lock(&vpbe_dev->lock);
+
+	ret = v4l2_subdev_call(vpbe_dev->encoders[sd_index], video,
+			       s_std_output, *std_id);
+	/* set the lcd controller output for the given mode */
+	if (!ret) {
+		osd_device->ops.set_left_margin(osd_device,
+		vpbe_dev->current_timings.left_margin);
+		osd_device->ops.set_top_margin(osd_device,
+		vpbe_dev->current_timings.upper_margin);
+	}
+	mutex_unlock(&vpbe_dev->lock);
+	return ret;
+}
+
+/**
+ * vpbe_g_std - Get the standard in the current encoder
+ *
+ * Get the standard in the current encoder. Return the status. 0 - success
+ * -EINVAL on error
+ */
+static int vpbe_g_std(struct vpbe_device *vpbe_dev, v4l2_std_id *std_id)
+{
+	struct vpbe_enc_mode_info cur_timings = vpbe_dev->current_timings;
+
+	if (cur_timings.timings_type & VPBE_ENC_STD) {
+		*std_id = cur_timings.timings.std_id;
+		return 0;
+	}
+	return -EINVAL;
+}
+
+/**
+ * vpbe_set_mode - Set mode in the current encoder using mode info
+ *
+ * Use the mode string to decide what timings to set in the encoder
+ * This is typically useful when fbset command is used to change the current
+ * timings by specifying a string to indicate the timings.
+ */
+static int vpbe_set_mode(struct vpbe_device *vpbe_dev,
+			 struct vpbe_enc_mode_info *mode_info)
+{
+	struct vpbe_display_config *vpbe_config = vpbe_dev->cfg;
+	int out_index = vpbe_dev->current_out_index, ret = 0, i;
+	struct vpbe_enc_mode_info *preset_mode = NULL;
+	struct v4l2_dv_preset dv_preset;
+
+	if ((NULL == mode_info) || (NULL == mode_info->name))
+		return -EINVAL;
+
+	for (i = 0; i < vpbe_config->outputs[out_index].num_modes; i++) {
+		if (!strcmp(mode_info->name,
+		     vpbe_config->outputs[out_index].modes[i].name)) {
+			preset_mode = &vpbe_config->outputs[out_index].modes[i];
+			/*
+			 * it may be one of the 3 timings type. Check and
+			 * invoke right API
+			 */
+			if (preset_mode->timings_type & VPBE_ENC_STD)
+				return vpbe_s_std(vpbe_dev,
+						 &preset_mode->timings.std_id);
+			if (preset_mode->timings_type & VPBE_ENC_DV_PRESET) {
+				dv_preset.preset =
+					preset_mode->timings.dv_preset;
+				return vpbe_s_dv_preset(vpbe_dev, &dv_preset);
+			}
+		}
+	}
+
+	/* Only custom timing should reach here */
+	if (preset_mode == NULL)
+		return -EINVAL;
+
+	mutex_lock(&vpbe_dev->lock);
+
+	if (!ret) {
+		vpbe_dev->current_timings = *preset_mode;
+		osd_device->ops.set_left_margin(osd_device,
+			vpbe_dev->current_timings.left_margin);
+		osd_device->ops.set_top_margin(osd_device,
+			vpbe_dev->current_timings.upper_margin);
+	}
+	mutex_unlock(&vpbe_dev->lock);
+	return ret;
+}
+
+static int vpbe_set_default_mode(struct vpbe_device *vpbe_dev)
+{
+	int ret;
+
+	ret = vpbe_get_std_info_by_name(vpbe_dev, def_mode);
+	if (ret)
+		return ret;
+	/* set the default mode in the encoder */
+	return vpbe_set_mode(vpbe_dev, &vpbe_dev->current_timings);
+}
+
+static int platform_device_get(struct device *dev, void *data)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	if (strcmp("vpbe-osd", pdev->name) == 0)
+		osd_device = platform_get_drvdata(pdev);
+	if (strcmp("vpbe-venc", pdev->name) == 0)
+		venc_device = dev_get_platdata(&pdev->dev);
+
+	return 0;
+}
+
+/**
+ * vpbe_initialize() - Initialize the vpbe display controller
+ * @vpbe_dev - vpbe device ptr
+ *
+ * Master frame buffer device drivers calls this to initialize vpbe
+ * display controller. This will then registers v4l2 device and the sub
+ * devices and sets a current encoder sub device for display. v4l2 display
+ * device driver is the master and frame buffer display device driver is
+ * the slave. Frame buffer display driver checks the initialized during
+ * probe and exit if not initialized. Returns status.
+ */
+static int vpbe_initialize(struct device *dev, struct vpbe_device *vpbe_dev)
+{
+	struct encoder_config_info *enc_info;
+	struct v4l2_subdev **enc_subdev;
+	int i, ret = 0, num_encoders;
+	struct i2c_adapter *i2c_adap;
+	int output_index;
+	int err;
+
+	/*
+	 * v4l2 abd FBDev frame buffer devices will get the vpbe_dev pointer
+	 * from the platform device by iteration of platform drivers and
+	 * matching with device name
+	 */
+	if (NULL == vpbe_dev || NULL == dev) {
+		printk(KERN_ERR "Null device pointers.\n");
+		return -ENODEV;
+	}
+
+	if (vpbe_dev->initialized)
+		return 0;
+
+	mutex_lock(&vpbe_dev->lock);
+
+	if (strcmp(vpbe_dev->cfg->module_name, "dm644x-vpbe-display") != 0) {
+		/* We have dac clock available for platform */
+		vpbe_dev->dac_clk = clk_get(vpbe_dev->pdev, "vpss_dac");
+		if (IS_ERR(vpbe_dev->dac_clk)) {
+			ret =  PTR_ERR(vpbe_dev->dac_clk);
+			goto vpbe_unlock;
+		}
+		if (clk_enable(vpbe_dev->dac_clk)) {
+			ret =  -ENODEV;
+			goto vpbe_unlock;
+		}
+	}
+
+	/* first enable vpss clocks */
+	vpss_enable_clock(VPSS_VPBE_CLOCK, 1);
+
+	/* First register a v4l2 device */
+	ret = v4l2_device_register(dev, &vpbe_dev->v4l2_dev);
+	if (ret) {
+		v4l2_err(dev->driver,
+			"Unable to register v4l2 device.\n");
+		goto vpbe_fail_clock;
+	}
+	v4l2_info(&vpbe_dev->v4l2_dev, "vpbe v4l2 device registered\n");
+
+	err = bus_for_each_dev(&platform_bus_type, NULL, NULL,
+			       platform_device_get);
+	if (err < 0)
+		return err;
+
+	vpbe_dev->venc = venc_sub_dev_init(&vpbe_dev->v4l2_dev,
+					   vpbe_dev->cfg->venc.module_name);
+	/* register venc sub device */
+	if (vpbe_dev->venc == NULL) {
+		v4l2_err(&vpbe_dev->v4l2_dev,
+			"vpbe unable to init venc sub device\n");
+		ret = -ENODEV;
+		goto vpbe_fail_v4l2_device;
+	}
+	/* initialize osd device */
+	if (NULL != osd_device->ops.initialize) {
+		err = osd_device->ops.initialize(osd_device);
+		if (err) {
+			v4l2_err(&vpbe_dev->v4l2_dev,
+				 "unable to initialize the OSD device");
+			err = -ENOMEM;
+			goto vpbe_fail_v4l2_device;
+		}
+	}
+
+	/*
+	 * Register any external encoders that are configured. At index 0 we
+	 * store venc sd index.
+	 */
+	num_encoders = vpbe_dev->cfg->num_ext_encoders + 1;
+	vpbe_dev->encoders = kmalloc(
+				sizeof(struct v4l2_subdev *)*num_encoders,
+				GFP_KERNEL);
+	if (NULL == vpbe_dev->encoders) {
+		v4l2_err(&vpbe_dev->v4l2_dev,
+			"unable to allocate memory for encoders sub devices");
+		ret = -ENOMEM;
+		goto vpbe_fail_v4l2_device;
+	}
+
+	i2c_adap = i2c_get_adapter(vpbe_dev->cfg->i2c_adapter_id);
+	for (i = 0; i < (vpbe_dev->cfg->num_ext_encoders + 1); i++) {
+		if (i == 0) {
+			/* venc is at index 0 */
+			enc_subdev = &vpbe_dev->encoders[i];
+			*enc_subdev = vpbe_dev->venc;
+			continue;
+		}
+		enc_info = &vpbe_dev->cfg->ext_encoders[i];
+		if (enc_info->is_i2c) {
+			enc_subdev = &vpbe_dev->encoders[i];
+			*enc_subdev = v4l2_i2c_new_subdev_board(
+						&vpbe_dev->v4l2_dev, i2c_adap,
+						&enc_info->board_info, NULL);
+			if (*enc_subdev)
+				v4l2_info(&vpbe_dev->v4l2_dev,
+					  "v4l2 sub device %s registered\n",
+					  enc_info->module_name);
+			else {
+				v4l2_err(&vpbe_dev->v4l2_dev, "encoder %s"
+					 " failed to register",
+					 enc_info->module_name);
+				ret = -ENODEV;
+				goto vpbe_fail_sd_register;
+			}
+		} else
+			v4l2_warn(&vpbe_dev->v4l2_dev, "non-i2c encoders"
+				 " currently not supported");
+	}
+
+	/* set the current encoder and output to that of venc by default */
+	vpbe_dev->current_sd_index = 0;
+	vpbe_dev->current_out_index = 0;
+	output_index = 0;
+
+	mutex_unlock(&vpbe_dev->lock);
+
+	printk(KERN_NOTICE "Setting default output to %s\n", def_output);
+	ret = vpbe_set_default_output(vpbe_dev);
+	if (ret) {
+		v4l2_err(&vpbe_dev->v4l2_dev, "Failed to set default output %s",
+			 def_output);
+		return ret;
+	}
+
+	printk(KERN_NOTICE "Setting default mode to %s\n", def_mode);
+	ret = vpbe_set_default_mode(vpbe_dev);
+	if (ret) {
+		v4l2_err(&vpbe_dev->v4l2_dev, "Failed to set default mode %s",
+			 def_mode);
+		return ret;
+	}
+	vpbe_dev->initialized = 1;
+	/* TBD handling of bootargs for default output and mode */
+	return 0;
+
+vpbe_fail_sd_register:
+	kfree(vpbe_dev->encoders);
+vpbe_fail_v4l2_device:
+	v4l2_device_unregister(&vpbe_dev->v4l2_dev);
+vpbe_fail_clock:
+	if (strcmp(vpbe_dev->cfg->module_name, "dm644x-vpbe-display") != 0)
+		clk_put(vpbe_dev->dac_clk);
+vpbe_unlock:
+	mutex_unlock(&vpbe_dev->lock);
+	return ret;
+}
+
+/**
+ * vpbe_deinitialize() - de-initialize the vpbe display controller
+ * @dev - Master and slave device ptr
+ *
+ * vpbe_master and slave frame buffer devices calls this to de-initialize
+ * the display controller. It is called when master and slave device
+ * driver modules are removed and no longer requires the display controller.
+ */
+void vpbe_deinitialize(struct device *dev, struct vpbe_device *vpbe_dev)
+{
+	v4l2_device_unregister(&vpbe_dev->v4l2_dev);
+	if (strcmp(vpbe_dev->cfg->module_name, "dm644x-vpbe-display") != 0)
+		clk_put(vpbe_dev->dac_clk);
+
+	kfree(vpbe_dev->encoders);
+	vpbe_dev->initialized = 0;
+	/* disaable vpss clocks */
+	vpss_enable_clock(VPSS_VPBE_CLOCK, 0);
+}
+
+static struct vpbe_device_ops vpbe_dev_ops = {
+	.g_cropcap = vpbe_g_cropcap,
+	.enum_outputs = vpbe_enum_outputs,
+	.set_output = vpbe_set_output,
+	.get_output = vpbe_get_output,
+	.s_dv_preset = vpbe_s_dv_preset,
+	.g_dv_preset = vpbe_g_dv_preset,
+	.enum_dv_presets = vpbe_enum_dv_presets,
+	.s_std = vpbe_s_std,
+	.g_std = vpbe_g_std,
+	.initialize = vpbe_initialize,
+	.deinitialize = vpbe_deinitialize,
+	.get_mode_info = vpbe_get_current_mode_info,
+	.set_mode = vpbe_set_mode,
+};
+
+static __init int vpbe_probe(struct platform_device *pdev)
+{
+	struct vpbe_display_config *vpbe_config;
+	struct vpbe_device *vpbe_dev;
+
+	int ret = -EINVAL;
+
+	if (pdev->dev.platform_data == NULL) {
+		v4l2_err(pdev->dev.driver, "No platform data\n");
+		return -ENODEV;
+	}
+	vpbe_config = pdev->dev.platform_data;
+
+	if (!vpbe_config->module_name[0] ||
+	    !vpbe_config->osd.module_name[0] ||
+	    !vpbe_config->venc.module_name[0]) {
+		v4l2_err(pdev->dev.driver, "vpbe display module names not"
+			 " defined\n");
+		return ret;
+	}
+
+	vpbe_dev = kzalloc(sizeof(*vpbe_dev), GFP_KERNEL);
+	if (vpbe_dev == NULL) {
+		v4l2_err(pdev->dev.driver, "Unable to allocate memory"
+			 " for vpbe_device\n");
+		return -ENOMEM;
+	}
+	vpbe_dev->cfg = vpbe_config;
+	vpbe_dev->ops = vpbe_dev_ops;
+	vpbe_dev->pdev = &pdev->dev;
+
+	if (vpbe_config->outputs->num_modes > 0)
+		vpbe_dev->current_timings = vpbe_dev->cfg->outputs[0].modes[0];
+	else
+		return -ENODEV;
+
+	/* set the driver data in platform device */
+	platform_set_drvdata(pdev, vpbe_dev);
+	mutex_init(&vpbe_dev->lock);
+	return 0;
+}
+
+static int vpbe_remove(struct platform_device *device)
+{
+	struct vpbe_device *vpbe_dev = platform_get_drvdata(device);
+
+	kfree(vpbe_dev);
+	return 0;
+}
+
+static struct platform_driver vpbe_driver = {
+	.driver	= {
+		.name	= "vpbe_controller",
+		.owner	= THIS_MODULE,
+	},
+	.probe = vpbe_probe,
+	.remove = vpbe_remove,
+};
+
+/**
+ * vpbe_init: initialize the vpbe driver
+ *
+ * This function registers device and driver to the kernel
+ */
+static __init int vpbe_init(void)
+{
+	return platform_driver_register(&vpbe_driver);
+}
+
+/**
+ * vpbe_cleanup : cleanup function for vpbe driver
+ *
+ * This will un-registers the device and driver to the kernel
+ */
+static void vpbe_cleanup(void)
+{
+	platform_driver_unregister(&vpbe_driver);
+}
+
+/* Function for module initialization and cleanup */
+module_init(vpbe_init);
+module_exit(vpbe_cleanup);
diff --git a/include/media/davinci/vpbe.h b/include/media/davinci/vpbe.h
new file mode 100644
index 0000000..45b38c3
--- /dev/null
+++ b/include/media/davinci/vpbe.h
@@ -0,0 +1,185 @@
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
+#ifndef _VPBE_H
+#define _VPBE_H
+
+#include <linux/videodev2.h>
+#include <linux/i2c.h>
+
+#include <media/v4l2-dev.h>
+#include <media/v4l2-ioctl.h>
+#include <media/v4l2-device.h>
+#include <media/davinci/vpbe_osd.h>
+#include <media/davinci/vpbe_venc.h>
+
+/* OSD configuration info */
+struct osd_config_info {
+	char module_name[32];
+};
+
+struct vpbe_output {
+	struct v4l2_output output;
+	/*
+	 * If output capabilities include dv_preset, list supported presets
+	 * below
+	 */
+	char *subdev_name;
+	/*
+	 * defualt_mode identifies the default timings set at the venc or
+	 * external encoder.
+	 */
+	char *default_mode;
+	/*
+	 * Fields below are used for supporting multiple modes. For example,
+	 * LCD panel might support different modes and they are listed here.
+	 * Similarly for supporting external encoders, lcd controller port
+	 * requires a set of non-standard timing values to be listed here for
+	 * each supported mode since venc is used in non-standard timing mode
+	 * for interfacing with external encoder similar to configuring lcd
+	 * panel timings
+	 */
+	unsigned int num_modes;
+	struct vpbe_enc_mode_info *modes;
+	/*
+	 * Bus configuration goes here for external encoders. Some encoders
+	 * may require multiple interface types for each of the output. For
+	 * example, SD modes would use YCC8 where as HD mode would use YCC16.
+	 * Not sure if this is needed on a per mode basis instead of per
+	 * output basis. If per mode is needed, we may have to move this to
+	 * mode_info structure
+	 */
+};
+
+/* encoder configuration info */
+struct encoder_config_info {
+	char module_name[32];
+	/* Is this an i2c device ? */
+	unsigned int is_i2c:1;
+	/* i2c subdevice board info */
+	struct i2c_board_info board_info;
+};
+
+/* structure for defining vpbe display subsystem components */
+struct vpbe_display_config {
+	char module_name[32];
+	/* i2c bus adapter no */
+	int i2c_adapter_id;
+	struct osd_config_info osd;
+	struct encoder_config_info venc;
+	/* external encoder information goes here */
+	int num_ext_encoders;
+	struct encoder_config_info *ext_encoders;
+	int num_outputs;
+	/* Order is venc outputs followed by LCD and then external encoders */
+	struct vpbe_output *outputs;
+};
+
+struct vpbe_device;
+
+struct vpbe_device_ops {
+	/* crop cap for the display */
+	int (*g_cropcap)(struct vpbe_device *vpbe_dev,
+			 struct v4l2_cropcap *cropcap);
+
+	/* Enumerate the outputs */
+	int (*enum_outputs)(struct vpbe_device *vpbe_dev,
+			    struct v4l2_output *output);
+
+	/* Set output to the given index */
+	int (*set_output)(struct vpbe_device *vpbe_dev,
+			 int index);
+
+	/* Get current output */
+	unsigned int (*get_output)(struct vpbe_device *vpbe_dev);
+
+	/* Set DV preset at current output */
+	int (*s_dv_preset)(struct vpbe_device *vpbe_dev,
+			   struct v4l2_dv_preset *dv_preset);
+
+	/* Get DV presets supported at the output */
+	int (*g_dv_preset)(struct vpbe_device *vpbe_dev,
+			   struct v4l2_dv_preset *dv_preset);
+
+	/* Enumerate the DV Presets supported at the output */
+	int (*enum_dv_presets)(struct vpbe_device *vpbe_dev,
+			       struct v4l2_dv_enum_preset *preset_info);
+
+	/* Set std at the output */
+	int (*s_std)(struct vpbe_device *vpbe_dev, v4l2_std_id *std_id);
+
+	/* Get the current std at the output */
+	int (*g_std)(struct vpbe_device *vpbe_dev, v4l2_std_id *std_id);
+
+	/* initialize the device */
+	int (*initialize)(struct device *dev, struct vpbe_device *vpbe_dev);
+
+	/* De-initialize the device */
+	void (*deinitialize)(struct device *dev, struct vpbe_device *vpbe_dev);
+
+	/* Get the current mode info */
+	int (*get_mode_info)(struct vpbe_device *vpbe_dev,
+			     struct vpbe_enc_mode_info*);
+
+	/*
+	 * Set the current mode in the encoder. Alternate way of setting
+	 * standard or DV preset or custom timings in the encoder
+	 */
+	int (*set_mode)(struct vpbe_device *vpbe_dev,
+			struct vpbe_enc_mode_info*);
+	/* Power management operations */
+	int (*suspend)(struct vpbe_device *vpbe_dev);
+	int (*resume)(struct vpbe_device *vpbe_dev);
+};
+
+/* struct for vpbe device */
+struct vpbe_device {
+	/* V4l2 device */
+	struct v4l2_device v4l2_dev;
+	/* vpbe dispay controller cfg */
+	struct vpbe_display_config *cfg;
+	/* parent device */
+	struct device *pdev;
+	/* external encoder v4l2 sub devices */
+	struct v4l2_subdev **encoders;
+	/* current encoder index */
+	int current_sd_index;
+	struct mutex lock;
+	/* device initialized */
+	int initialized;
+	/* vpbe dac clock */
+	struct clk *dac_clk;
+
+	/*
+	 * fields below are accessed by users of vpbe_device. Not the
+	 * ones above
+	 */
+
+	/* current output */
+	int current_out_index;
+	/* lock used by caller to do atomic operation on vpbe device */
+	/* current timings set in the controller */
+	struct vpbe_enc_mode_info current_timings;
+	/* venc sub device */
+	struct v4l2_subdev *venc;
+	/* device operations below */
+	struct vpbe_device_ops ops;
+};
+
+/* exported functions */
+struct v4l2_subdev *venc_sub_dev_init(struct v4l2_device *v4l2_dev,
+		const char *venc_name);
+#endif
-- 
1.6.2.4

