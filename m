Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52008 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627Ab2KPOq4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Nov 2012 09:46:56 -0500
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
	DLOS <davinci-linux-open-source@linux.davincidsp.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>,
	Prabhakar Lad <prabhakar.lad@ti.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2 03/12] davinci: vpfe: dm365: add IPIPEIF driver based on media framework
Date: Fri, 16 Nov 2012 20:15:05 +0530
Message-Id: <1353077114-19296-4-git-send-email-prabhakar.lad@ti.com>
In-Reply-To: <1353077114-19296-1-git-send-email-prabhakar.lad@ti.com>
References: <1353077114-19296-1-git-send-email-prabhakar.lad@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Manjunath Hadli <manjunath.hadli@ti.com>

add support for dm365 IPIPEIF driver based on media framework.
The IPIPEIF is exposed as a subdev, and it supports features
like fault pixel correction, dark frame subtraction and other
necessary hardware setup.

Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
---
 drivers/media/platform/davinci/dm365_ipipeif.c | 1063 ++++++++++++++++++++++++
 drivers/media/platform/davinci/dm365_ipipeif.h |  233 ++++++
 include/uapi/linux/Kbuild                      |    1 +
 include/uapi/linux/dm365_ipipeif.h             |   93 ++
 4 files changed, 1390 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/platform/davinci/dm365_ipipeif.c
 create mode 100644 drivers/media/platform/davinci/dm365_ipipeif.h
 create mode 100644 include/uapi/linux/dm365_ipipeif.h

diff --git a/drivers/media/platform/davinci/dm365_ipipeif.c b/drivers/media/platform/davinci/dm365_ipipeif.c
new file mode 100644
index 0000000..a63ee58
--- /dev/null
+++ b/drivers/media/platform/davinci/dm365_ipipeif.c
@@ -0,0 +1,1063 @@
+/*
+ * Copyright (C) 2012 Texas Instruments Inc
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
+ * Contributors:
+ *      Manjunath Hadli <manjunath.hadli@ti.com>
+ *      Prabhakar Lad <prabhakar.lad@ti.com>
+ */
+
+#include "dm365_ipipeif.h"
+#include "vpfe_mc_capture.h"
+
+static const unsigned int ipipeif_input_fmts[] = {
+	V4L2_MBUS_FMT_UYVY8_2X8,
+	V4L2_MBUS_FMT_SGRBG12_1X12,
+	V4L2_MBUS_FMT_Y8_1X8,
+	V4L2_MBUS_FMT_UV8_1X8,
+	V4L2_MBUS_FMT_YDYUYDYV8_1X16,
+	V4L2_MBUS_FMT_SBGGR8_1X8,
+};
+
+static const unsigned int ipipeif_output_fmts[] = {
+	V4L2_MBUS_FMT_UYVY8_2X8,
+	V4L2_MBUS_FMT_SGRBG12_1X12,
+	V4L2_MBUS_FMT_Y8_1X8,
+	V4L2_MBUS_FMT_UV8_1X8,
+	V4L2_MBUS_FMT_YDYUYDYV8_1X16,
+	V4L2_MBUS_FMT_SBGGR8_1X8,
+	V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8,
+	V4L2_MBUS_FMT_SGRBG10_ALAW8_1X8,
+};
+
+static int
+ipipeif_get_pack_mode(enum v4l2_mbus_pixelcode in_pix_fmt)
+{
+	switch (in_pix_fmt) {
+	case V4L2_MBUS_FMT_SBGGR8_1X8:
+	case V4L2_MBUS_FMT_Y8_1X8:
+	case V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8:
+	case V4L2_MBUS_FMT_UV8_1X8:
+		return IPIPEIF_5_1_PACK_8_BIT;
+
+	case V4L2_MBUS_FMT_SGRBG10_ALAW8_1X8:
+		return IPIPEIF_5_1_PACK_8_BIT_A_LAW;
+
+	case V4L2_MBUS_FMT_SGRBG12_1X12:
+		return IPIPEIF_5_1_PACK_16_BIT;
+
+	case V4L2_MBUS_FMT_SBGGR12_1X12:
+		return IPIPEIF_5_1_PACK_12_BIT;
+
+	default:
+		return IPIPEIF_5_1_PACK_16_BIT;
+	}
+}
+
+static inline u32 ipipeif_read(void *addr, u32 offset)
+{
+	return readl(addr + offset);
+}
+
+static inline void ipipeif_write(u32 val, void *addr, u32 offset)
+{
+	writel(val, addr + offset);
+}
+
+static void ipipeif_config_dpc(void *addr, struct ipipeif_dpc *dpc)
+{
+	u32 val = 0;
+
+	if (dpc->en) {
+		val = (dpc->en & 1) << IPIPEIF_DPC2_EN_SHIFT;
+		val |= dpc->thr & IPIPEIF_DPC2_THR_MASK;
+	}
+	ipipeif_write(val, addr, IPIPEIF_DPC2);
+}
+
+#define IPIPEIF_MODE_CONTINUOUS			0
+#define IPIPEIF_MODE_ONE_SHOT			1
+
+static int get_oneshot_mode(enum ipipeif_input_entity input)
+{
+	if (input == IPIPEIF_INPUT_MEMORY)
+		return IPIPEIF_MODE_ONE_SHOT;
+	else if (input == IPIPEIF_INPUT_ISIF)
+		return IPIPEIF_MODE_CONTINUOUS;
+
+	return -EINVAL;
+}
+
+static int
+ipipeif_get_cfg_src1(struct vpfe_ipipeif_device *ipipeif)
+{
+	struct v4l2_mbus_framefmt *informat;
+
+	informat = &ipipeif->formats[IPIPEIF_PAD_SINK];
+	if (ipipeif->input == IPIPEIF_INPUT_MEMORY &&
+	   (informat->code == V4L2_MBUS_FMT_Y8_1X8 ||
+	    informat->code == V4L2_MBUS_FMT_UV8_1X8))
+		return IPIPEIF_CCDC;
+
+	return IPIPEIF_SRC1_PARALLEL_PORT;
+}
+
+static int
+ipipeif_get_data_shift(struct vpfe_ipipeif_device *ipipeif)
+{
+	struct v4l2_mbus_framefmt *informat;
+
+	informat = &ipipeif->formats[IPIPEIF_PAD_SINK];
+
+	switch (informat->code) {
+	case V4L2_MBUS_FMT_SGRBG12_1X12:
+		return IPIPEIF_5_1_BITS11_0;
+
+	case V4L2_MBUS_FMT_Y8_1X8:
+	case V4L2_MBUS_FMT_UV8_1X8:
+		return IPIPEIF_5_1_BITS11_0;
+
+	default:
+		return IPIPEIF_5_1_BITS7_0;
+	}
+}
+
+static enum ipipeif_input_source
+ipipeif_get_source(struct vpfe_ipipeif_device *ipipeif)
+{
+	struct v4l2_mbus_framefmt *informat;
+
+	informat = &ipipeif->formats[IPIPEIF_PAD_SINK];
+	if (ipipeif->input == IPIPEIF_INPUT_ISIF)
+		return IPIPEIF_CCDC;
+
+	if (informat->code == V4L2_MBUS_FMT_UYVY8_2X8)
+		return IPIPEIF_SDRAM_YUV;
+
+	return IPIPEIF_SDRAM_RAW;
+}
+
+void vpfe_ipipeif_ss_buffer_isr(struct vpfe_ipipeif_device *ipipeif)
+{
+	struct vpfe_video_device *video_in = &ipipeif->video_in;
+
+	if (ipipeif->input != IPIPEIF_INPUT_MEMORY)
+		return;
+
+	spin_lock(&video_in->dma_queue_lock);
+	vpfe_video_process_buffer_complete(video_in);
+	video_in->state = VPFE_VIDEO_BUFFER_NOT_QUEUED;
+	vpfe_video_schedule_next_buffer(video_in);
+	spin_unlock(&video_in->dma_queue_lock);
+}
+
+int vpfe_ipipeif_decimation_enabled(struct vpfe_device *vpfe_dev)
+{
+	struct vpfe_ipipeif_device *ipipeif = &vpfe_dev->vpfe_ipipeif;
+
+	return ipipeif->config.decimation;
+}
+
+int vpfe_ipipeif_get_rsz(struct vpfe_device *vpfe_dev)
+{
+	struct vpfe_ipipeif_device *ipipeif = &vpfe_dev->vpfe_ipipeif;
+
+	return ipipeif->config.rsz;
+}
+
+#define RD_DATA_15_2		0x7
+
+/*
+ * ipipeif_hw_setup() - This function sets up IPIPEIF
+ * @sd: pointer to v4l2 subdev structure
+ * return -EINVAL or zero on success
+ */
+static int ipipeif_hw_setup(struct v4l2_subdev *sd)
+{
+	struct vpfe_ipipeif_device *ipipeif = v4l2_get_subdevdata(sd);
+	struct v4l2_mbus_framefmt *informat, *outformat;
+	struct ipipeif_params params = ipipeif->config;
+	enum ipipeif_input_source ipipeif_source;
+	enum v4l2_mbus_pixelcode isif_port_if;
+	void *ipipeif_base_addr;
+	unsigned int val;
+	int data_shift;
+	int pack_mode;
+	int source1;
+
+	ipipeif_base_addr = ipipeif->ipipeif_base_addr;
+
+	/* Enable clock to IPIPEIF and IPIPE */
+	vpss_enable_clock(VPSS_IPIPEIF_CLOCK, 1);
+
+	informat = &ipipeif->formats[IPIPEIF_PAD_SINK];
+	outformat = &ipipeif->formats[IPIPEIF_PAD_SOURCE];
+
+	/* Combine all the fields to make CFG1 register of IPIPEIF */
+	val = get_oneshot_mode(ipipeif->input);
+	if (val < 0) {
+		pr_err("ipipeif: links setup required");
+		return -EINVAL;
+	}
+	val = val << ONESHOT_SHIFT;
+
+	ipipeif_source = ipipeif_get_source(ipipeif);
+	val |= ipipeif_source << INPSRC_SHIFT;
+
+	val |= params.clock_select << CLKSEL_SHIFT;
+	val |= params.avg_filter << AVGFILT_SHIFT;
+	val |= params.decimation << DECIM_SHIFT;
+
+	pack_mode = ipipeif_get_pack_mode(informat->code);
+	val |= pack_mode << PACK8IN_SHIFT;
+
+	source1 = ipipeif_get_cfg_src1(ipipeif);
+	val |= source1 << INPSRC1_SHIFT;
+
+	data_shift = ipipeif_get_data_shift(ipipeif);
+	if (ipipeif_source != IPIPEIF_SDRAM_YUV)
+		val |= data_shift << DATASFT_SHIFT;
+	else
+		val &= ~(RD_DATA_15_2 << DATASFT_SHIFT);
+
+	ipipeif_write(val, ipipeif_base_addr, IPIPEIF_CFG1);
+
+	switch (ipipeif_source) {
+	case IPIPEIF_CCDC:
+		ipipeif_write(ipipeif->gain, ipipeif_base_addr, IPIPEIF_GAIN);
+		break;
+
+	case IPIPEIF_SDRAM_RAW:
+	case IPIPEIF_CCDC_DARKFM:
+		ipipeif_write(ipipeif->gain, ipipeif_base_addr, IPIPEIF_GAIN);
+		/* fall through */
+	case IPIPEIF_SDRAM_YUV:
+		val |= data_shift << DATASFT_SHIFT;
+		ipipeif_write(params.ppln, ipipeif_base_addr, IPIPEIF_PPLN);
+		ipipeif_write(params.lpfr, ipipeif_base_addr, IPIPEIF_LPFR);
+		ipipeif_write(informat->width, ipipeif_base_addr, IPIPEIF_HNUM);
+		ipipeif_write(informat->height,
+			      ipipeif_base_addr, IPIPEIF_VNUM);
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	/*check if decimation is enable or not */
+	if (params.decimation)
+		ipipeif_write(params.rsz, ipipeif_base_addr, IPIPEIF_RSZ);
+
+	/* Setup sync alignment and initial rsz position */
+	val = params.if_5_1.align_sync & 1;
+	val <<= IPIPEIF_INIRSZ_ALNSYNC_SHIFT;
+	val |= params.if_5_1.rsz_start & IPIPEIF_INIRSZ_MASK;
+	ipipeif_write(val, ipipeif_base_addr, IPIPEIF_INIRSZ);
+	isif_port_if = informat->code;
+
+	if (isif_port_if == V4L2_MBUS_FMT_Y8_1X8)
+		isif_port_if = V4L2_MBUS_FMT_YUYV8_1X16;
+	else if (isif_port_if == V4L2_MBUS_FMT_UV8_1X8)
+		isif_port_if = V4L2_MBUS_FMT_SGRBG12_1X12;
+
+	/* Enable DPCM decompression */
+	switch (ipipeif_source) {
+	case IPIPEIF_SDRAM_RAW:
+		val = 0;
+		if (outformat->code == V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8) {
+			val = 1;
+			val |= (IPIPEIF_DPCM_8BIT_10BIT & 1) <<
+				IPIPEIF_DPCM_BITS_SHIFT;
+			val |= (ipipeif->dpcm_predictor & 1) <<
+				IPIPEIF_DPCM_PRED_SHIFT;
+		}
+		ipipeif_write(val, ipipeif_base_addr, IPIPEIF_DPCM);
+
+		/* set DPC */
+		ipipeif_config_dpc(ipipeif_base_addr, &params.if_5_1.dpc);
+
+		ipipeif_write(params.if_5_1.clip,
+			      ipipeif_base_addr, IPIPEIF_OCLIP);
+
+		/* fall through for SDRAM YUV mode */
+		/* configure CFG2 */
+		val = ipipeif_read(ipipeif_base_addr, IPIPEIF_CFG2);
+		switch (isif_port_if) {
+		case V4L2_MBUS_FMT_YUYV8_1X16:
+		case V4L2_MBUS_FMT_UYVY8_2X8:
+		case V4L2_MBUS_FMT_Y8_1X8:
+			RESETBIT(val, IPIPEIF_CFG2_YUV8_SHIFT);
+			SETBIT(val, IPIPEIF_CFG2_YUV16_SHIFT);
+			ipipeif_write(val, ipipeif_base_addr, IPIPEIF_CFG2);
+			break;
+
+		default:
+			RESETBIT(val, IPIPEIF_CFG2_YUV8_SHIFT);
+			RESETBIT(val, IPIPEIF_CFG2_YUV16_SHIFT);
+			ipipeif_write(val, ipipeif_base_addr, IPIPEIF_CFG2);
+			break;
+		}
+
+	case IPIPEIF_SDRAM_YUV:
+		/* Set clock divider */
+		if (params.clock_select == IPIPEIF_SDRAM_CLK) {
+			val = ipipeif_read(ipipeif_base_addr, IPIPEIF_CLKDIV);
+			val |= (params.if_5_1.clk_div.m - 1) <<
+				IPIPEIF_CLKDIV_M_SHIFT;
+			val |= (params.if_5_1.clk_div.n - 1);
+			ipipeif_write(val, ipipeif_base_addr, IPIPEIF_CLKDIV);
+		}
+		break;
+
+	case IPIPEIF_CCDC:
+	case IPIPEIF_CCDC_DARKFM:
+		/* set DPC */
+		ipipeif_config_dpc(ipipeif_base_addr, &params.if_5_1.dpc);
+
+		/* Set DF gain & threshold control */
+		val = 0;
+		if (params.if_5_1.df_gain_en) {
+			val = params.if_5_1.df_gain_thr &
+				IPIPEIF_DF_GAIN_THR_MASK;
+			ipipeif_write(val, ipipeif_base_addr, IPIPEIF_DFSGTH);
+			val = (params.if_5_1.df_gain_en & 1) <<
+				IPIPEIF_DF_GAIN_EN_SHIFT;
+			val |= params.if_5_1.df_gain &
+				IPIPEIF_DF_GAIN_MASK;
+		}
+		ipipeif_write(val, ipipeif_base_addr, IPIPEIF_DFSGVL);
+		/* configure CFG2 */
+		val = VPFE_PINPOL_POSITIVE << IPIPEIF_CFG2_HDPOL_SHIFT;
+		val |= VPFE_PINPOL_POSITIVE << IPIPEIF_CFG2_VDPOL_SHIFT;
+
+		switch (isif_port_if) {
+		case V4L2_MBUS_FMT_YUYV8_1X16:
+		case V4L2_MBUS_FMT_YUYV10_1X20:
+			RESETBIT(val, IPIPEIF_CFG2_YUV8_SHIFT);
+			SETBIT(val, IPIPEIF_CFG2_YUV16_SHIFT);
+			break;
+
+		case V4L2_MBUS_FMT_YUYV8_2X8:
+		case V4L2_MBUS_FMT_UYVY8_2X8:
+		case V4L2_MBUS_FMT_Y8_1X8:
+		case V4L2_MBUS_FMT_YUYV10_2X10:
+			SETBIT(val, IPIPEIF_CFG2_YUV8_SHIFT);
+			SETBIT(val, IPIPEIF_CFG2_YUV16_SHIFT);
+			val |= IPIPEIF_CBCR_Y << IPIPEIF_CFG2_YUV8P_SHIFT;
+			break;
+
+		default:
+			/* Bayer */
+			ipipeif_write(params.if_5_1.clip, ipipeif_base_addr,
+				IPIPEIF_OCLIP);
+		}
+		ipipeif_write(val, ipipeif_base_addr, IPIPEIF_CFG2);
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int
+ipipeif_set_config(struct v4l2_subdev *sd, struct ipipeif_params *config)
+{
+	struct vpfe_ipipeif_device *ipipeif = v4l2_get_subdevdata(sd);
+	struct device *dev = ipipeif->subdev.v4l2_dev->dev;
+
+	if (!config) {
+		dev_err(dev, "Invalid configuration pointer\n");
+		return -EINVAL;
+	}
+
+	ipipeif->config.clock_select = config->clock_select;
+	ipipeif->config.ppln = config->ppln;
+	ipipeif->config.lpfr = config->lpfr;
+	ipipeif->config.rsz = config->rsz;
+	ipipeif->config.decimation = config->decimation;
+	if (ipipeif->config.decimation &&
+	   (ipipeif->config.rsz < IPIPEIF_RSZ_MIN ||
+	    ipipeif->config.rsz > IPIPEIF_RSZ_MAX)) {
+		dev_err(dev, "rsz range is %d to %d\n",
+			IPIPEIF_RSZ_MIN, IPIPEIF_RSZ_MAX);
+		return -EINVAL;
+	}
+
+	ipipeif->config.avg_filter = config->avg_filter;
+
+	ipipeif->config.if_5_1.df_gain_thr = config->if_5_1.df_gain_thr;
+	ipipeif->config.if_5_1.df_gain = config->if_5_1.df_gain;
+	ipipeif->config.if_5_1.df_gain_en = config->if_5_1.df_gain_en;
+
+	ipipeif->config.if_5_1.rsz_start = config->if_5_1.rsz_start;
+	ipipeif->config.if_5_1.align_sync = config->if_5_1.align_sync;
+	ipipeif->config.if_5_1.clip = config->if_5_1.clip;
+
+	ipipeif->config.if_5_1.dpc.en = config->if_5_1.dpc.en;
+	ipipeif->config.if_5_1.dpc.thr = config->if_5_1.dpc.thr;
+
+	ipipeif->config.if_5_1.clk_div.m = config->if_5_1.clk_div.m;
+	ipipeif->config.if_5_1.clk_div.n = config->if_5_1.clk_div.n;
+
+	return 0;
+}
+
+static int
+ipipeif_get_config(struct v4l2_subdev *sd, void __user *arg)
+{
+	struct vpfe_ipipeif_device *ipipeif = v4l2_get_subdevdata(sd);
+	struct ipipeif_params *config = (struct ipipeif_params *)arg;
+	struct device *dev = ipipeif->subdev.v4l2_dev->dev;
+
+	if (!arg) {
+		dev_err(dev, "Invalid configuration pointer\n");
+		return -EINVAL;
+	}
+
+	config->clock_select = ipipeif->config.clock_select;
+	config->ppln = ipipeif->config.ppln;
+	config->lpfr = ipipeif->config.lpfr;
+	config->rsz = ipipeif->config.rsz;
+	config->decimation = ipipeif->config.decimation;
+	config->avg_filter = ipipeif->config.avg_filter;
+
+	config->if_5_1.df_gain_thr = ipipeif->config.if_5_1.df_gain_thr;
+	config->if_5_1.df_gain = ipipeif->config.if_5_1.df_gain;
+	config->if_5_1.df_gain_en = ipipeif->config.if_5_1.df_gain_en;
+
+	config->if_5_1.rsz_start = ipipeif->config.if_5_1.rsz_start;
+	config->if_5_1.align_sync = ipipeif->config.if_5_1.align_sync;
+	config->if_5_1.clip = ipipeif->config.if_5_1.clip;
+
+	config->if_5_1.dpc.en = ipipeif->config.if_5_1.dpc.en;
+	config->if_5_1.dpc.thr = ipipeif->config.if_5_1.dpc.thr;
+
+	config->if_5_1.clk_div.m = ipipeif->config.if_5_1.clk_div.m;
+	config->if_5_1.clk_div.n = ipipeif->config.if_5_1.clk_div.n;
+
+	return 0;
+}
+
+/*
+ * ipipeif_ioctl() - Handle ipipeif module private ioctl's
+ * @sd: pointer to v4l2 subdev structure
+ * @cmd: configuration command
+ * @arg: configuration argument
+ */
+static long ipipeif_ioctl(struct v4l2_subdev *sd,
+			  unsigned int cmd, void *arg)
+{
+	struct ipipeif_params *config = (struct ipipeif_params *)arg;
+	int ret = -ENOIOCTLCMD;
+
+	switch (cmd) {
+	case VIDIOC_VPFE_IPIPEIF_S_CONFIG:
+		ret = ipipeif_set_config(sd, config);
+		break;
+
+	case VIDIOC_VPFE_IPIPEIF_G_CONFIG:
+		ret = ipipeif_get_config(sd, arg);
+		break;
+	}
+	return ret;
+}
+
+/*
+ * ipipeif_s_ctrl() - Handle set control subdev method
+ * @ctrl: pointer to v4l2 control structure
+ */
+static int ipipeif_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct vpfe_ipipeif_device *ipipeif =
+		container_of(ctrl->handler, struct vpfe_ipipeif_device, ctrls);
+
+	switch (ctrl->id) {
+	case V4L2_CID_DPCM_PREDICTOR:
+		ipipeif->dpcm_predictor = ctrl->val;
+		break;
+
+	case V4L2_CID_GAIN:
+		ipipeif->gain = ctrl->val;
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+#define ENABLE_IPIPEIF		0x1
+
+void vpfe_ipipeif_enable(struct vpfe_device *vpfe_dev)
+{
+	struct vpfe_ipipeif_device *ipipeif = &vpfe_dev->vpfe_ipipeif;
+	void *ipipeif_base_addr = ipipeif->ipipeif_base_addr;
+	unsigned char val;
+
+	if (ipipeif->input != IPIPEIF_INPUT_MEMORY)
+		return;
+
+	do {
+		val = ipipeif_read(ipipeif_base_addr, IPIPEIF_ENABLE);
+	} while (val & 0x1);
+
+	ipipeif_write(ENABLE_IPIPEIF, ipipeif_base_addr, IPIPEIF_ENABLE);
+}
+
+/*
+ * ipipeif_set_stream() - Enable/Disable streaming on ipipeif subdev
+ * @sd: pointer to v4l2 subdev structure
+ * @enable: 1 == Enable, 0 == Disable
+ */
+static int ipipeif_set_stream(struct v4l2_subdev *sd, int enable)
+{
+	struct vpfe_ipipeif_device *ipipeif = v4l2_get_subdevdata(sd);
+	struct vpfe_device *vpfe_dev = to_vpfe_device(ipipeif);
+	int ret = 0;
+
+	if (!enable)
+		return ret;
+
+	ret = ipipeif_hw_setup(sd);
+	if (!ret)
+		vpfe_ipipeif_enable(vpfe_dev);
+
+	return ret;
+}
+
+/*
+ * ipipeif_enum_mbus_code() - Handle pixel format enumeration
+ * @sd: pointer to v4l2 subdev structure
+ * @fh: V4L2 subdev file handle
+ * @code: pointer to v4l2_subdev_mbus_code_enum structure
+ * return -EINVAL or zero on success
+ */
+static int ipipeif_enum_mbus_code(struct v4l2_subdev *sd,
+				  struct v4l2_subdev_fh *fh,
+			struct v4l2_subdev_mbus_code_enum *code)
+{
+	switch (code->pad) {
+	case IPIPEIF_PAD_SINK:
+		if (code->index >= ARRAY_SIZE(ipipeif_input_fmts))
+			return -EINVAL;
+
+		code->code = ipipeif_input_fmts[code->index];
+		break;
+
+	case IPIPEIF_PAD_SOURCE:
+		if (code->index >= ARRAY_SIZE(ipipeif_output_fmts))
+			return -EINVAL;
+
+		code->code = ipipeif_output_fmts[code->index];
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/*
+ * ipipeif_get_format() - Handle get format by pads subdev method
+ * @sd: pointer to v4l2 subdev structure
+ * @fh: V4L2 subdev file handle
+ * @fmt: pointer to v4l2 subdev format structure
+ */
+static int
+ipipeif_get_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+		struct v4l2_subdev_format *fmt)
+{
+	struct vpfe_ipipeif_device *ipipeif = v4l2_get_subdevdata(sd);
+
+	if (fmt->which == V4L2_SUBDEV_FORMAT_ACTIVE)
+		fmt->format = ipipeif->formats[fmt->pad];
+	else
+		fmt->format = *(v4l2_subdev_get_try_format(fh, fmt->pad));
+
+	return 0;
+}
+
+#define MIN_OUT_WIDTH			32
+#define MIN_OUT_HEIGHT			32
+
+/*
+ * ipipeif_try_format() - Handle try format by pad subdev method
+ * @ipipeif: VPFE ipipeif device.
+ * @fh: V4L2 subdev file handle.
+ * @pad: pad num.
+ * @fmt: pointer to v4l2 format structure.
+ * @which : wanted subdev format
+ */
+static void
+ipipeif_try_format(struct vpfe_ipipeif_device *ipipeif,
+		   struct v4l2_subdev_fh *fh, unsigned int pad,
+		   struct v4l2_mbus_framefmt *fmt,
+		   enum v4l2_subdev_format_whence which)
+{
+	unsigned int max_out_height;
+	unsigned int max_out_width;
+	unsigned int i;
+
+	max_out_width = IPIPE_MAX_OUTPUT_WIDTH_A;
+	max_out_height = IPIPE_MAX_OUTPUT_HEIGHT_A;
+
+	if (pad == IPIPEIF_PAD_SINK) {
+		for (i = 0; i < ARRAY_SIZE(ipipeif_input_fmts); i++)
+			if (fmt->code == ipipeif_input_fmts[i])
+				break;
+
+		/* If not found, use SBGGR10 as default */
+		if (i >= ARRAY_SIZE(ipipeif_input_fmts))
+			fmt->code = V4L2_MBUS_FMT_SGRBG12_1X12;
+	} else if (pad == IPIPEIF_PAD_SOURCE) {
+		for (i = 0; i < ARRAY_SIZE(ipipeif_output_fmts); i++)
+			if (fmt->code == ipipeif_output_fmts[i])
+				break;
+
+		/* If not found, use UYVY as default */
+		if (i >= ARRAY_SIZE(ipipeif_output_fmts))
+			fmt->code = V4L2_MBUS_FMT_UYVY8_2X8;
+	}
+
+	fmt->width = clamp_t(u32, fmt->width, MIN_OUT_HEIGHT, max_out_width);
+	fmt->height = clamp_t(u32, fmt->height, MIN_OUT_WIDTH, max_out_height);
+}
+
+static int
+ipipeif_enum_frame_size(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+		     struct v4l2_subdev_frame_size_enum *fse)
+{
+	struct vpfe_ipipeif_device *ipipeif = v4l2_get_subdevdata(sd);
+	struct v4l2_mbus_framefmt format;
+
+	if (fse->index != 0)
+		return -EINVAL;
+
+	format.code = fse->code;
+	format.width = 1;
+	format.height = 1;
+	ipipeif_try_format(ipipeif, fh, fse->pad, &format,
+			   V4L2_SUBDEV_FORMAT_TRY);
+	fse->min_width = format.width;
+	fse->min_height = format.height;
+
+	if (format.code != fse->code)
+		return -EINVAL;
+
+	format.code = fse->code;
+	format.width = -1;
+	format.height = -1;
+	ipipeif_try_format(ipipeif, fh, fse->pad, &format,
+			   V4L2_SUBDEV_FORMAT_TRY);
+	fse->max_width = format.width;
+	fse->max_height = format.height;
+
+	return 0;
+}
+
+/*
+ * __ipipeif_get_format() - helper function for getting ipipeif format
+ * @ipipeif: pointer to ipipeif private structure.
+ * @pad: pad number.
+ * @fh: V4L2 subdev file handle.
+ * @which: wanted subdev format.
+ *
+ */
+static struct v4l2_mbus_framefmt *
+__ipipeif_get_format(struct vpfe_ipipeif_device *ipipeif,
+		       struct v4l2_subdev_fh *fh, unsigned int pad,
+		       enum v4l2_subdev_format_whence which)
+{
+	if (which == V4L2_SUBDEV_FORMAT_TRY)
+		return v4l2_subdev_get_try_format(fh, pad);
+
+	return &ipipeif->formats[pad];
+}
+
+/*
+ * ipipeif_set_format() - Handle set format by pads subdev method
+ * @sd: pointer to v4l2 subdev structure
+ * @fh: V4L2 subdev file handle
+ * @fmt: pointer to v4l2 subdev format structure
+ * return -EINVAL or zero on success
+ */
+static int
+ipipeif_set_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+		struct v4l2_subdev_format *fmt)
+{
+	struct vpfe_ipipeif_device *ipipeif = v4l2_get_subdevdata(sd);
+	struct v4l2_mbus_framefmt *format;
+
+	format = __ipipeif_get_format(ipipeif, fh, fmt->pad, fmt->which);
+	if (format == NULL)
+		return -EINVAL;
+
+	ipipeif_try_format(ipipeif, fh, fmt->pad, &fmt->format, fmt->which);
+	*format = fmt->format;
+
+	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY)
+		return 0;
+
+	if (fmt->pad == IPIPEIF_PAD_SINK &&
+	    ipipeif->input != IPIPEIF_INPUT_NONE)
+		ipipeif->formats[fmt->pad] = fmt->format;
+	else if (fmt->pad == IPIPEIF_PAD_SOURCE &&
+		 ipipeif->output != IPIPEIF_OUTPUT_NONE)
+		ipipeif->formats[fmt->pad] = fmt->format;
+	else
+		return -EINVAL;
+
+	return 0;
+}
+
+static void ipipeif_set_default_config(struct vpfe_ipipeif_device *ipipeif)
+{
+#define WIDTH_I			640
+#define HEIGHT_I		480
+
+	const struct ipipeif_params ipipeif_defaults = {
+		.clock_select = IPIPEIF_SDRAM_CLK,
+		.ppln = WIDTH_I + 8,
+		.lpfr = HEIGHT_I + 10,
+		.rsz = 16,	/* resize ratio 16/rsz */
+		.decimation = IPIPEIF_DECIMATION_OFF,
+		.avg_filter = IPIPEIF_AVG_OFF,
+		.if_5_1 = {
+			.clk_div = {
+				.m = 1,	/* clock = sdram clock * (m/n) */
+				.n = 6
+			},
+			.clip = 4095,
+		},
+	};
+	memset(&ipipeif->config, 0, sizeof(struct ipipeif_params));
+	memcpy(&ipipeif->config, &ipipeif_defaults,
+	       sizeof(struct ipipeif_params));
+}
+
+/*
+ * ipipeif_init_formats() - Initialize formats on all pads
+ * @sd: VPFE ipipeif V4L2 subdevice
+ * @fh: V4L2 subdev file handle
+ *
+ * Initialize all pad formats with default values. If fh is not NULL, try
+ * formats are initialized on the file handle. Otherwise active formats are
+ * initialized on the device.
+ */
+static int
+ipipeif_init_formats(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
+{
+	struct vpfe_ipipeif_device *ipipeif = v4l2_get_subdevdata(sd);
+	struct v4l2_subdev_format format;
+
+	memset(&format, 0, sizeof(format));
+	format.pad = IPIPEIF_PAD_SINK;
+	format.which = fh ? V4L2_SUBDEV_FORMAT_TRY : V4L2_SUBDEV_FORMAT_ACTIVE;
+	format.format.code = V4L2_MBUS_FMT_SGRBG12_1X12;
+	format.format.width = IPIPE_MAX_OUTPUT_WIDTH_A;
+	format.format.height = IPIPE_MAX_OUTPUT_HEIGHT_A;
+	ipipeif_set_format(sd, fh, &format);
+
+	memset(&format, 0, sizeof(format));
+	format.pad = IPIPEIF_PAD_SOURCE;
+	format.which = fh ? V4L2_SUBDEV_FORMAT_TRY : V4L2_SUBDEV_FORMAT_ACTIVE;
+	format.format.code = V4L2_MBUS_FMT_UYVY8_2X8;
+	format.format.width = IPIPE_MAX_OUTPUT_WIDTH_A;
+	format.format.height = IPIPE_MAX_OUTPUT_HEIGHT_A;
+	ipipeif_set_format(sd, fh, &format);
+
+	ipipeif_set_default_config(ipipeif);
+
+	return 0;
+}
+
+/*
+ * ipipeif_video_in_queue() - ipipeif video in queue
+ * @vpfe_dev: vpfe device pointer
+ * @addr: buffer address
+ */
+static int
+ipipeif_video_in_queue(struct vpfe_device *vpfe_dev, unsigned long addr)
+{
+	struct vpfe_ipipeif_device *ipipeif = &vpfe_dev->vpfe_ipipeif;
+	void *ipipeif_base_addr = ipipeif->ipipeif_base_addr;
+	unsigned int adofs;
+	u32 val;
+
+	if (ipipeif->input != IPIPEIF_INPUT_MEMORY)
+		return -EINVAL;
+
+	switch (ipipeif->formats[IPIPEIF_PAD_SINK].code) {
+	case V4L2_MBUS_FMT_Y8_1X8:
+	case V4L2_MBUS_FMT_UV8_1X8:
+	case V4L2_MBUS_FMT_YDYUYDYV8_1X16:
+		adofs = ipipeif->formats[IPIPEIF_PAD_SINK].width;
+		break;
+
+	default:
+		adofs = ipipeif->formats[IPIPEIF_PAD_SINK].width << 1;
+		break;
+	}
+
+	/* adjust the line len to be a multiple of 32 */
+	adofs += 31;
+	adofs &= ~0x1f;
+	val = (adofs >> 5) & IPIPEIF_ADOFS_LSB_MASK;
+	ipipeif_write(val, ipipeif_base_addr, IPIPEIF_ADOFS);
+
+	/* lower sixteen bit */
+	val = (addr >> IPIPEIF_ADDRL_SHIFT) & IPIPEIF_ADDRL_MASK;
+	ipipeif_write(val, ipipeif_base_addr, IPIPEIF_ADDRL);
+
+	/* upper next seven bit */
+	val = (addr >> IPIPEIF_ADDRU_SHIFT) & IPIPEIF_ADDRU_MASK;
+	ipipeif_write(val, ipipeif_base_addr, IPIPEIF_ADDRU);
+
+	return 0;
+}
+
+/* subdev core operations */
+static const struct v4l2_subdev_core_ops ipipeif_v4l2_core_ops = {
+	.ioctl = ipipeif_ioctl,
+};
+
+static const struct v4l2_ctrl_ops ipipeif_ctrl_ops = {
+	.s_ctrl = ipipeif_s_ctrl,
+};
+
+/* subdev file operations */
+static const struct v4l2_subdev_internal_ops ipipeif_v4l2_internal_ops = {
+	.open = ipipeif_init_formats,
+};
+
+/* subdev video operations */
+static const struct v4l2_subdev_video_ops ipipeif_v4l2_video_ops = {
+	.s_stream = ipipeif_set_stream,
+};
+
+/* subdev pad operations */
+static const struct v4l2_subdev_pad_ops ipipeif_v4l2_pad_ops = {
+	.enum_mbus_code = ipipeif_enum_mbus_code,
+	.enum_frame_size = ipipeif_enum_frame_size,
+	.get_fmt = ipipeif_get_format,
+	.set_fmt = ipipeif_set_format,
+};
+
+/* subdev operations */
+static const struct v4l2_subdev_ops ipipeif_v4l2_ops = {
+	.core = &ipipeif_v4l2_core_ops,
+	.video = &ipipeif_v4l2_video_ops,
+	.pad = &ipipeif_v4l2_pad_ops,
+};
+
+static const struct vpfe_video_operations video_in_ops = {
+	.queue = ipipeif_video_in_queue,
+};
+
+static int
+ipipeif_link_setup(struct media_entity *entity, const struct media_pad *local,
+		const struct media_pad *remote, u32 flags)
+{
+	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
+	struct vpfe_ipipeif_device *ipipeif = v4l2_get_subdevdata(sd);
+	struct vpfe_device *vpfe = to_vpfe_device(ipipeif);
+
+	switch (local->index | media_entity_type(remote->entity)) {
+	case IPIPEIF_PAD_SINK | MEDIA_ENT_T_DEVNODE:
+		/* Single shot mode */
+		if (!(flags & MEDIA_LNK_FL_ENABLED)) {
+			ipipeif->input = IPIPEIF_INPUT_NONE;
+			break;
+		}
+		ipipeif->input = IPIPEIF_INPUT_MEMORY;
+		break;
+
+	case IPIPEIF_PAD_SINK | MEDIA_ENT_T_V4L2_SUBDEV:
+		/* read from isif */
+		if (!(flags & MEDIA_LNK_FL_ENABLED)) {
+			ipipeif->input = IPIPEIF_INPUT_NONE;
+			break;
+		}
+		if (ipipeif->input != IPIPEIF_INPUT_NONE)
+			return -EBUSY;
+
+		ipipeif->input = IPIPEIF_INPUT_ISIF;
+		break;
+
+	case IPIPEIF_PAD_SOURCE | MEDIA_ENT_T_V4L2_SUBDEV:
+		if (!(flags & MEDIA_LNK_FL_ENABLED)) {
+			ipipeif->output = IPIPEIF_OUTPUT_NONE;
+			break;
+		}
+		if (remote->entity == &vpfe->vpfe_ipipe.subdev.entity)
+			/* connencted to ipipe */
+			ipipeif->output = IPIPEIF_OUTPUT_IPIPE;
+		else if (remote->entity == &vpfe->vpfe_resizer.
+			crop_resizer.subdev.entity)
+			/* connected to resizer */
+			ipipeif->output = IPIPEIF_OUTPUT_RESIZER;
+		else
+			return -EINVAL;
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static const struct media_entity_operations ipipeif_media_ops = {
+	.link_setup = ipipeif_link_setup,
+};
+
+/*
+ * vpfe_ipipeif_unregister_entities() - Unregister entity
+ * @ipipeif - pointer to ipipeif subdevice structure.
+ */
+void vpfe_ipipeif_unregister_entities(struct vpfe_ipipeif_device *ipipeif)
+{
+	/* unregister video device */
+	vpfe_video_unregister(&ipipeif->video_in);
+
+	/* cleanup entity */
+	media_entity_cleanup(&ipipeif->subdev.entity);
+	/* unregister subdev */
+	v4l2_device_unregister_subdev(&ipipeif->subdev);
+}
+
+int
+vpfe_ipipeif_register_entities(struct vpfe_ipipeif_device *ipipeif,
+			       struct v4l2_device *vdev)
+{
+	struct vpfe_device *vpfe_dev = to_vpfe_device(ipipeif);
+	unsigned int flags;
+	int ret;
+
+	/* Register the subdev */
+	ret = v4l2_device_register_subdev(vdev, &ipipeif->subdev);
+	if (ret < 0)
+		return ret;
+
+	ret = vpfe_video_register(&ipipeif->video_in, vdev);
+	if (ret) {
+		pr_err("Failed to register ipipeif video-in device\n");
+		goto fail;
+	}
+	ipipeif->video_in.vpfe_dev = vpfe_dev;
+
+	flags = 0;
+	ret = media_entity_create_link(&ipipeif->video_in.video_dev.entity, 0,
+					&ipipeif->subdev.entity, 0, flags);
+	if (ret < 0)
+		goto fail;
+
+	return 0;
+fail:
+	v4l2_device_unregister_subdev(&ipipeif->subdev);
+
+	return ret;
+}
+
+#define IPIPEIF_GAIN_HIGH		0x3ff
+#define IPIPEIF_DEFAULT_GAIN		0x200
+
+int vpfe_ipipeif_init(struct vpfe_ipipeif_device *ipipeif,
+		      struct platform_device *pdev)
+{
+	struct v4l2_subdev *sd = &ipipeif->subdev;
+	struct media_pad *pads = &ipipeif->pads[0];
+	struct media_entity *me = &sd->entity;
+	static resource_size_t  res_len;
+	struct resource *res;
+	int ret;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 3);
+	if (!res)
+		return -ENOENT;
+
+	res_len = resource_size(res);
+	res = request_mem_region(res->start, res_len, res->name);
+	if (!res)
+		return -EBUSY;
+
+	ipipeif->ipipeif_base_addr = ioremap_nocache(res->start, res_len);
+	if (!ipipeif->ipipeif_base_addr) {
+		ret =  -EBUSY;
+		goto fail;
+	}
+
+	v4l2_subdev_init(sd, &ipipeif_v4l2_ops);
+
+	sd->internal_ops = &ipipeif_v4l2_internal_ops;
+	strlcpy(sd->name, "DAVINCI IPIPEIF", sizeof(sd->name));
+	sd->grp_id = 1 << 16;	/* group ID for davinci subdevs */
+
+	v4l2_set_subdevdata(sd, ipipeif);
+
+	sd->flags |= V4L2_SUBDEV_FL_HAS_EVENTS | V4L2_SUBDEV_FL_HAS_DEVNODE;
+	pads[IPIPEIF_PAD_SINK].flags = MEDIA_PAD_FL_SINK;
+	pads[IPIPEIF_PAD_SOURCE].flags = MEDIA_PAD_FL_SOURCE;
+	ipipeif->input = IPIPEIF_INPUT_NONE;
+	ipipeif->output = IPIPEIF_OUTPUT_NONE;
+	me->ops = &ipipeif_media_ops;
+
+	ret = media_entity_init(me, IPIPEIF_NUM_PADS, pads, 0);
+	if (ret)
+		goto fail;
+
+	v4l2_ctrl_handler_init(&ipipeif->ctrls, 2);
+	v4l2_ctrl_new_std(&ipipeif->ctrls, &ipipeif_ctrl_ops,
+			  V4L2_CID_GAIN, 0,
+			  IPIPEIF_GAIN_HIGH, 1, IPIPEIF_DEFAULT_GAIN);
+	v4l2_ctrl_new_std_menu(&ipipeif->ctrls, &ipipeif_ctrl_ops,
+			V4L2_CID_DPCM_PREDICTOR,
+			V4L2_DPCM_PREDICTOR_ADVANCED, 0,
+			V4L2_DPCM_PREDICTOR_SIMPLE);
+	v4l2_ctrl_handler_setup(&ipipeif->ctrls);
+	sd->ctrl_handler = &ipipeif->ctrls;
+
+	ipipeif->video_in.ops = &video_in_ops;
+	ipipeif->video_in.type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
+	ret = vpfe_video_init(&ipipeif->video_in, "IPIPEIF");
+	if (ret) {
+		pr_err("Failed to init IPIPEIF video-in device\n");
+		goto fail;
+	}
+	ipipeif_set_default_config(ipipeif);
+	return 0;
+fail:
+	release_mem_region(res->start, res_len);
+	return ret;
+}
+
+void
+vpfe_ipipeif_cleanup(struct vpfe_ipipeif_device *ipipeif,
+		     struct platform_device *pdev)
+{
+	struct resource *res;
+
+	v4l2_ctrl_handler_free(&ipipeif->ctrls);
+	iounmap(ipipeif->ipipeif_base_addr);
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 3);
+	if (res)
+		release_mem_region(res->start,
+					res->end - res->start + 1);
+
+}
diff --git a/drivers/media/platform/davinci/dm365_ipipeif.h b/drivers/media/platform/davinci/dm365_ipipeif.h
new file mode 100644
index 0000000..dae204d
--- /dev/null
+++ b/drivers/media/platform/davinci/dm365_ipipeif.h
@@ -0,0 +1,233 @@
+/*
+ * Copyright (C) 2012 Texas Instruments Inc
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
+ * Contributors:
+ *      Manjunath Hadli <manjunath.hadli@ti.com>
+ *      Prabhakar Lad <prabhakar.lad@ti.com>
+ */
+
+#ifndef _DAVINCI_VPFE_DM365_IPIPEIF_H
+#define _DAVINCI_VPFE_DM365_IPIPEIF_H
+
+#include <linux/dm365_ipipeif.h>
+#include <linux/platform_device.h>
+
+#include <media/davinci/vpss.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-subdev.h>
+
+#include "vpfe_video.h"
+
+/* IPIPE base specific types */
+enum ipipeif_data_shift {
+	IPIPEIF_BITS15_2 = 0,
+	IPIPEIF_BITS14_1 = 1,
+	IPIPEIF_BITS13_0 = 2,
+	IPIPEIF_BITS12_0 = 3,
+	IPIPEIF_BITS11_0 = 4,
+	IPIPEIF_BITS10_0 = 5,
+	IPIPEIF_BITS9_0 = 6,
+};
+
+enum ipipeif_clkdiv {
+	IPIPEIF_DIVIDE_HALF = 0,
+	IPIPEIF_DIVIDE_THIRD = 1,
+	IPIPEIF_DIVIDE_FOURTH = 2,
+	IPIPEIF_DIVIDE_FIFTH = 3,
+	IPIPEIF_DIVIDE_SIXTH = 4,
+	IPIPEIF_DIVIDE_EIGHTH = 5,
+	IPIPEIF_DIVIDE_SIXTEENTH = 6,
+	IPIPEIF_DIVIDE_THIRTY = 7,
+};
+
+enum ipipeif_pack_mode  {
+	IPIPEIF_PACK_16_BIT = 0,
+	IPIPEIF_PACK_8_BIT = 1,
+};
+
+enum ipipeif_5_1_pack_mode  {
+	IPIPEIF_5_1_PACK_16_BIT = 0,
+	IPIPEIF_5_1_PACK_8_BIT = 1,
+	IPIPEIF_5_1_PACK_8_BIT_A_LAW = 2,
+	IPIPEIF_5_1_PACK_12_BIT = 3
+};
+
+enum  ipipeif_input_source {
+	IPIPEIF_CCDC = 0,
+	IPIPEIF_SDRAM_RAW = 1,
+	IPIPEIF_CCDC_DARKFM = 2,
+	IPIPEIF_SDRAM_YUV = 3,
+};
+
+enum ipipeif_ialaw {
+	IPIPEIF_ALAW_OFF = 0,
+	IPIPEIF_ALAW_ON = 1,
+};
+
+enum  ipipeif_input_src1 {
+	IPIPEIF_SRC1_PARALLEL_PORT = 0,
+	IPIPEIF_SRC1_SDRAM_RAW = 1,
+	IPIPEIF_SRC1_ISIF_DARKFM = 2,
+	IPIPEIF_SRC1_SDRAM_YUV = 3,
+};
+
+enum ipipeif_dfs_dir {
+	IPIPEIF_PORT_MINUS_SDRAM = 0,
+	IPIPEIF_SDRAM_MINUS_PORT = 1,
+};
+
+enum ipipeif_chroma_phase {
+	IPIPEIF_CBCR_Y = 0,
+	IPIPEIF_Y_CBCR = 1,
+};
+
+enum ipipeif_dpcm_type {
+	IPIPEIF_DPCM_8BIT_10BIT = 0,
+	IPIPEIF_DPCM_8BIT_12BIT = 1,
+};
+
+/* data shift for IPIPE 5.1 */
+enum ipipeif_5_1_data_shift {
+	IPIPEIF_5_1_BITS11_0 = 0,
+	IPIPEIF_5_1_BITS10_0 = 1,
+	IPIPEIF_5_1_BITS9_0 = 2,
+	IPIPEIF_5_1_BITS8_0 = 3,
+	IPIPEIF_5_1_BITS7_0 = 4,
+	IPIPEIF_5_1_BITS15_4 = 5,
+};
+
+#define IPIPEIF_PAD_SINK      0
+#define IPIPEIF_PAD_SOURCE    1
+
+#define IPIPEIF_NUM_PADS	2
+
+enum ipipeif_input_entity {
+	IPIPEIF_INPUT_NONE = 0,
+	IPIPEIF_INPUT_ISIF = 1,
+	IPIPEIF_INPUT_MEMORY = 2,
+};
+
+enum ipipeif_output_entity {
+	IPIPEIF_OUTPUT_NONE = 0,
+	IPIPEIF_OUTPUT_IPIPE = 1,
+	IPIPEIF_OUTPUT_RESIZER = 2,
+};
+
+struct vpfe_ipipeif_device {
+	struct v4l2_subdev subdev;
+	struct media_pad pads[IPIPEIF_NUM_PADS];
+	struct v4l2_mbus_framefmt formats[IPIPEIF_NUM_PADS];
+	enum ipipeif_input_entity input;
+	unsigned int output;
+	struct vpfe_video_device video_in;
+	struct v4l2_ctrl_handler ctrls;
+	void *__iomem ipipeif_base_addr;
+	struct ipipeif_params config;
+	int dpcm_predictor;
+	int gain;
+};
+
+/* IPIPEIF Register Offsets from the base address */
+#define IPIPEIF_ENABLE			0x00
+#define IPIPEIF_CFG1			0x04
+#define IPIPEIF_PPLN			0x08
+#define IPIPEIF_LPFR			0x0c
+#define IPIPEIF_HNUM			0x10
+#define IPIPEIF_VNUM			0x14
+#define IPIPEIF_ADDRU			0x18
+#define IPIPEIF_ADDRL			0x1c
+#define IPIPEIF_ADOFS			0x20
+#define IPIPEIF_RSZ			0x24
+#define IPIPEIF_GAIN			0x28
+
+/* Below registers are available only on IPIPE 5.1 */
+#define IPIPEIF_DPCM			0x2c
+#define IPIPEIF_CFG2			0x30
+#define IPIPEIF_INIRSZ			0x34
+#define IPIPEIF_OCLIP			0x38
+#define IPIPEIF_DTUDF			0x3c
+#define IPIPEIF_CLKDIV			0x40
+#define IPIPEIF_DPC1			0x44
+#define IPIPEIF_DPC2			0x48
+#define IPIPEIF_DFSGVL			0x4c
+#define IPIPEIF_DFSGTH			0x50
+#define IPIPEIF_RSZ3A			0x54
+#define IPIPEIF_INIRSZ3A		0x58
+#define IPIPEIF_RSZ_MIN			16
+#define IPIPEIF_RSZ_MAX			112
+#define IPIPEIF_RSZ_CONST		16
+#define SETBIT(reg, bit)   (reg = ((reg) | ((0x00000001)<<(bit))))
+#define RESETBIT(reg, bit) (reg = ((reg) & (~(0x00000001<<(bit)))))
+
+#define IPIPEIF_ADOFS_LSB_MASK		0x1ff
+#define IPIPEIF_ADOFS_LSB_SHIFT		5
+#define IPIPEIF_ADOFS_MSB_MASK		0x200
+#define IPIPEIF_ADDRU_MASK		0x7ff
+#define IPIPEIF_ADDRL_SHIFT		5
+#define IPIPEIF_ADDRL_MASK		0xffff
+#define IPIPEIF_ADDRU_SHIFT		21
+#define IPIPEIF_ADDRMSB_SHIFT		31
+#define IPIPEIF_ADDRMSB_LEFT_SHIFT	10
+
+/* CFG1 Masks and shifts */
+#define ONESHOT_SHIFT			0
+#define DECIM_SHIFT			1
+#define INPSRC_SHIFT			2
+#define CLKDIV_SHIFT			4
+#define AVGFILT_SHIFT			7
+#define PACK8IN_SHIFT			8
+#define IALAW_SHIFT			9
+#define CLKSEL_SHIFT			10
+#define DATASFT_SHIFT			11
+#define INPSRC1_SHIFT			14
+
+/* DPC2 */
+#define IPIPEIF_DPC2_EN_SHIFT		12
+#define IPIPEIF_DPC2_THR_MASK		0xfff
+/* Applicable for IPIPE 5.1 */
+#define IPIPEIF_DF_GAIN_EN_SHIFT	10
+#define IPIPEIF_DF_GAIN_MASK		0x3ff
+#define IPIPEIF_DF_GAIN_THR_MASK	0xfff
+/* DPCM */
+#define IPIPEIF_DPCM_BITS_SHIFT		2
+#define IPIPEIF_DPCM_PRED_SHIFT		1
+/* CFG2 */
+#define IPIPEIF_CFG2_HDPOL_SHIFT	1
+#define IPIPEIF_CFG2_VDPOL_SHIFT	2
+#define IPIPEIF_CFG2_YUV8_SHIFT		6
+#define IPIPEIF_CFG2_YUV16_SHIFT	3
+#define IPIPEIF_CFG2_YUV8P_SHIFT	7
+
+/* INIRSZ */
+#define IPIPEIF_INIRSZ_ALNSYNC_SHIFT	13
+#define IPIPEIF_INIRSZ_MASK		0x1fff
+
+/* CLKDIV */
+#define IPIPEIF_CLKDIV_M_SHIFT		8
+
+void vpfe_ipipeif_enable(struct vpfe_device *vpfe_dev);
+void vpfe_ipipeif_ss_buffer_isr(struct vpfe_ipipeif_device *ipipeif);
+int vpfe_ipipeif_decimation_enabled(struct vpfe_device *vpfe_dev);
+int vpfe_ipipeif_get_rsz(struct vpfe_device *vpfe_dev);
+void vpfe_ipipeif_cleanup(struct vpfe_ipipeif_device *ipipeif,
+			  struct platform_device *pdev);
+int vpfe_ipipeif_init(struct vpfe_ipipeif_device *ipipeif,
+		      struct platform_device *pdev);
+int vpfe_ipipeif_register_entities(struct vpfe_ipipeif_device *ipipeif,
+				   struct v4l2_device *vdev);
+void vpfe_ipipeif_unregister_entities(struct vpfe_ipipeif_device *ipipeif);
+
+#endif		/* _DAVINCI_VPFE_DM365_IPIPEIF_H */
diff --git a/include/uapi/linux/Kbuild b/include/uapi/linux/Kbuild
index 777d82e..47a01cf 100644
--- a/include/uapi/linux/Kbuild
+++ b/include/uapi/linux/Kbuild
@@ -95,6 +95,7 @@ header-y += dlm_device.h
 header-y += dlm_netlink.h
 header-y += dlm_plock.h
 header-y += dlmconstants.h
+header-y += dm365_ipipeif.h
 header-y += dm-ioctl.h
 header-y += dm-log-userspace.h
 header-y += dn.h
diff --git a/include/uapi/linux/dm365_ipipeif.h b/include/uapi/linux/dm365_ipipeif.h
new file mode 100644
index 0000000..e2a69b5
--- /dev/null
+++ b/include/uapi/linux/dm365_ipipeif.h
@@ -0,0 +1,93 @@
+/*
+ * Copyright (C) 2012 Texas Instruments Inc
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
+ * Contributors:
+ *      Manjunath Hadli <manjunath.hadli@ti.com>
+ *      Prabhakar Lad <prabhakar.lad@ti.com>
+ */
+
+#ifndef _DAVINCI_VPFE_DM365_IPIPEIF_USER_H
+#define _DAVINCI_VPFE_DM365_IPIPEIF_USER_H
+
+/* clockdiv for IPIPE 5.1 */
+struct ipipeif_5_1_clkdiv {
+	unsigned char m;
+	unsigned char n;
+};
+
+enum ipipeif_decimation {
+	IPIPEIF_DECIMATION_OFF,
+	IPIPEIF_DECIMATION_ON
+};
+
+/* DPC at the if for IPIPE 5.1 */
+struct ipipeif_dpc {
+	/* 0 - disable, 1 - enable */
+	unsigned char en;
+	/* threshold */
+	unsigned short thr;
+};
+
+enum ipipeif_clock {
+	IPIPEIF_PIXCEL_CLK,
+	IPIPEIF_SDRAM_CLK
+};
+
+enum  ipipeif_avg_filter {
+	IPIPEIF_AVG_OFF,
+	IPIPEIF_AVG_ON
+};
+
+struct ipipeif_5_1 {
+	struct ipipeif_5_1_clkdiv clk_div;
+	/* Defect pixel correction */
+	struct ipipeif_dpc dpc;
+	/* clipped to this value */
+	unsigned short clip;
+	/* Align HSync and VSync to rsz_start */
+	unsigned char align_sync;
+	/* resizer start position */
+	unsigned int rsz_start;
+	/* DF gain enable */
+	unsigned char df_gain_en;
+	/* DF gain value */
+	unsigned short df_gain;
+	/* DF gain threshold value */
+	unsigned short df_gain_thr;
+};
+
+struct ipipeif_params {
+	enum ipipeif_clock clock_select;
+	unsigned int ppln;
+	unsigned int lpfr;
+	unsigned char rsz;
+	enum ipipeif_decimation decimation;
+	enum ipipeif_avg_filter avg_filter;
+	/* IPIPE 5.1 */
+	struct ipipeif_5_1 if_5_1;
+};
+
+/*
+ * Private IOCTL
+ * VIDIOC_VPFE_IPIPEIF_S_CONFIG: Set IPIEIF configuration
+ * VIDIOC_VPFE_IPIPEIF_G_CONFIG: Get IPIEIF configuration
+ */
+#define VIDIOC_VPFE_IPIPEIF_S_CONFIG \
+	_IOWR('I', BASE_VIDIOC_PRIVATE + 1, struct ipipeif_params)
+#define VIDIOC_VPFE_IPIPEIF_G_CONFIG \
+	_IOWR('I', BASE_VIDIOC_PRIVATE + 2, struct ipipeif_params)
+
+#endif		/* _DAVINCI_VPFE_DM365_IPIPEIF_USER_H */
-- 
1.7.4.1

