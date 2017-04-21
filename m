Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay2.synopsys.com ([198.182.60.111]:55294 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1037507AbdDUJyD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Apr 2017 05:54:03 -0400
From: Jose Abreu <Jose.Abreu@synopsys.com>
To: linux-media@vger.kernel.org
Cc: Jose Abreu <Jose.Abreu@synopsys.com>,
        Carlos Palminha <CARLOS.PALMINHA@synopsys.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-kernel@vger.kernel.org
Subject: [RFC 1/2] [media] platform: Add Synopsys Designware HDMI RX PHY e405 Driver
Date: Fri, 21 Apr 2017 10:53:20 +0100
Message-Id: <ffdf47e90c860b9328fdcd6136f91f3e8814e7d2.1492767176.git.joabreu@synopsys.com>
In-Reply-To: <cover.1492767176.git.joabreu@synopsys.com>
References: <cover.1492767176.git.joabreu@synopsys.com>
In-Reply-To: <cover.1492767176.git.joabreu@synopsys.com>
References: <cover.1492767176.git.joabreu@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This adds support for the Synopsys Designware HDMI RX PHY e405. This
phy receives and decodes HDMI video that is delivered to a controller.

Main features included in this driver are:
	- Equalizer algorithm that chooses the phy best settings
	according to the detected HDMI cable characteristics.
	- Support for scrambling
	- Support for HDMI 2.0 modes up to 6G (HDMI 4k@60Hz).

The driver was implemented as a standalone V4L2 subdevice and the
phy interface with the controller was implemented using V4L2 ioctls. I
do not know if this is the best option but it is not possible to use the
existing API functions directly as we need specific functions that will
be called by the controller at specific configuration stages.

There is also a bidirectional communication between controller and phy:
The phy must provide functions that the controller will call (i.e.
configuration functions) and the controller must provide read/write
callbacks, as well as other specific functions.

Signed-off-by: Jose Abreu <joabreu@synopsys.com>
Cc: Carlos Palminha <palminha@synopsys.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: linux-kernel@vger.kernel.org
Cc: linux-media@vger.kernel.org
---
 drivers/media/platform/Kconfig                |   2 +
 drivers/media/platform/Makefile               |   2 +
 drivers/media/platform/dwc/Kconfig            |   8 +
 drivers/media/platform/dwc/Makefile           |   1 +
 drivers/media/platform/dwc/dw-hdmi-phy-e405.c | 879 ++++++++++++++++++++++++++
 drivers/media/platform/dwc/dw-hdmi-phy-e405.h |  63 ++
 include/media/dwc/dw-hdmi-phy-pdata.h         |  64 ++
 7 files changed, 1019 insertions(+)
 create mode 100644 drivers/media/platform/dwc/Kconfig
 create mode 100644 drivers/media/platform/dwc/Makefile
 create mode 100644 drivers/media/platform/dwc/dw-hdmi-phy-e405.c
 create mode 100644 drivers/media/platform/dwc/dw-hdmi-phy-e405.h
 create mode 100644 include/media/dwc/dw-hdmi-phy-pdata.h

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index ac026ee..5178229 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -33,6 +33,8 @@ source "drivers/media/platform/omap/Kconfig"
 
 source "drivers/media/platform/blackfin/Kconfig"
 
+source "drivers/media/platform/dwc/Kconfig"
+
 config VIDEO_SH_VOU
 	tristate "SuperH VOU video output driver"
 	depends on MEDIA_CAMERA_SUPPORT
diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index 63303d6..50bc148 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -77,3 +77,5 @@ obj-$(CONFIG_VIDEO_MEDIATEK_VCODEC)	+= mtk-vcodec/
 obj-$(CONFIG_VIDEO_MEDIATEK_MDP)	+= mtk-mdp/
 
 obj-$(CONFIG_VIDEO_MEDIATEK_JPEG)	+= mtk-jpeg/
+
+obj-y	+= dwc/
diff --git a/drivers/media/platform/dwc/Kconfig b/drivers/media/platform/dwc/Kconfig
new file mode 100644
index 0000000..361d38d
--- /dev/null
+++ b/drivers/media/platform/dwc/Kconfig
@@ -0,0 +1,8 @@
+config VIDEO_DWC_HDMI_PHY_E405
+	tristate "Synopsys Designware HDMI RX PHY e405 driver"
+	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
+	help
+	  Support for Synopsys Designware HDMI RX PHY. Version is e405.
+
+	  To compile this driver as a module, choose M here. The module
+	  will be called dw-hdmi-phy-e405.
diff --git a/drivers/media/platform/dwc/Makefile b/drivers/media/platform/dwc/Makefile
new file mode 100644
index 0000000..fc3b62c
--- /dev/null
+++ b/drivers/media/platform/dwc/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_VIDEO_DWC_HDMI_PHY_E405) += dw-hdmi-phy-e405.o
diff --git a/drivers/media/platform/dwc/dw-hdmi-phy-e405.c b/drivers/media/platform/dwc/dw-hdmi-phy-e405.c
new file mode 100644
index 0000000..dc00677
--- /dev/null
+++ b/drivers/media/platform/dwc/dw-hdmi-phy-e405.c
@@ -0,0 +1,879 @@
+/*
+ * Synopsys Designware HDMI PHY E405 driver
+ *
+ * This Synopsys dw-phy-e405 software and associated documentation
+ * (hereinafter the "Software") is an unsupported proprietary work of
+ * Synopsys, Inc. unless otherwise expressly agreed to in writing between
+ * Synopsys and you. The Software IS NOT an item of Licensed Software or a
+ * Licensed Product under any End User Software License Agreement or
+ * Agreement for Licensed Products with Synopsys or any supplement thereto.
+ * Synopsys is a registered trademark of Synopsys, Inc. Other names included
+ * in the SOFTWARE may be the trademarks of their respective owners.
+ *
+ * The contents of this file are dual-licensed; you may select either version 2
+ * of the GNU General Public License (“GPL”) or the MIT license (“MIT”).
+ *
+ * Copyright (c) 2017 Synopsys, Inc. and/or its affiliates.
+ *
+ * THIS SOFTWARE IS PROVIDED "AS IS"  WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING, BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE, AND NONINFRINGEMENT. IN NO EVENT SHALL THE
+ * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
+ * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT, OR OTHERWISE
+ * ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE THE USE OR
+ * OTHER DEALINGS IN THE SOFTWARE.
+ */
+
+#include <linux/delay.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/types.h>
+#include <media/v4l2-subdev.h>
+#include <media/dwc/dw-hdmi-phy-pdata.h>
+#include "dw-hdmi-phy-e405.h"
+
+MODULE_AUTHOR("Jose Abreu <joabreu@synopsys.com>");
+MODULE_DESCRIPTION("Designware HDMI PHY e405 driver");
+MODULE_LICENSE("Dual MIT/GPL");
+MODULE_ALIAS("platform:" DW_PHY_E405_DRVNAME);
+
+#define PHY_EQ_WAIT_TIME_START			3
+#define PHY_EQ_SLEEP_TIME_CDR			30
+#define PHY_EQ_SLEEP_TIME_ACQ			1
+#define PHY_EQ_BOUNDSPREAD			20
+#define PHY_EQ_MIN_ACQ_STABLE			3
+#define PHY_EQ_ACC_LIMIT			360
+#define PHY_EQ_ACC_MIN_LIMIT			0
+#define PHY_EQ_MAX_SETTING			13
+#define PHY_EQ_SHORT_CABLE_SETTING		4
+#define PHY_EQ_ERROR_CABLE_SETTING		4
+#define PHY_EQ_MIN_SLOPE			50
+#define PHY_EQ_AVG_ACQ				5
+#define PHY_EQ_MINMAX_NTRIES			3
+#define PHY_EQ_EQUALIZED_COUNTER_VAL		512
+#define PHY_EQ_EQUALIZED_COUNTER_VAL_HDMI20	512
+#define PHY_EQ_MINMAX_MAXDIFF			4
+#define PHY_EQ_MINMAX_MAXDIFF_HDMI20		2
+#define PHY_EQ_FATBIT_MASK			0x0000
+#define PHY_EQ_FATBIT_MASK_4K			0x0c03
+#define PHY_EQ_FATBIT_MASK_HDMI20		0x0e03
+
+struct dw_phy_eq_ch {
+	u16 best_long_setting;
+	u8 valid_long_setting;
+	u16 best_short_setting;
+	u8 valid_short_setting;
+	u16 best_setting;
+	u16 acc;
+	u16 acq;
+	u16 last_acq;
+	u16 upper_bound_acq;
+	u16 lower_bound_acq;
+	u16 out_bound_acq;
+	u16 read_acq;
+};
+
+static const struct dw_phy_mpll_config {
+	u16 addr;
+	u16 val;
+} dw_phy_e405_mpll_cfg[] = {
+	{ 0x27, 0x1B94 },
+	{ 0x28, 0x16D2 },
+	{ 0x29, 0x12D9 },
+	{ 0x2A, 0x3249 },
+	{ 0x2B, 0x3653 },
+	{ 0x2C, 0x3436 },
+	{ 0x2D, 0x124D },
+	{ 0x2E, 0x0001 },
+	{ 0xCE, 0x0505 },
+	{ 0xCF, 0x0505 },
+	{ 0xD0, 0x0000 },
+	{ 0x00, 0x0000 },
+};
+
+struct dw_phy_dev {
+	struct device *dev;
+	struct dw_phy_pdata *config;
+	bool phy_enabled;
+	struct v4l2_subdev sd;
+	u16 mpll_status;
+	unsigned char res;
+	bool hdmi2;
+	bool scrambling;
+	struct mutex lock;
+};
+
+static inline struct dw_phy_dev *to_dw_dev(struct v4l2_subdev *sd)
+{
+	return container_of(sd, struct dw_phy_dev, sd);
+}
+
+static void phy_write(struct dw_phy_dev *dw_dev, u16 val, u16 addr)
+{
+	void *arg = dw_dev->config->funcs_arg;
+
+	dw_dev->config->funcs->write(arg, val, addr);
+}
+
+static u16 phy_read(struct dw_phy_dev *dw_dev, u16 addr)
+{
+	void *arg = dw_dev->config->funcs_arg;
+
+	return dw_dev->config->funcs->read(arg, addr);
+}
+
+static void phy_reset(struct dw_phy_dev *dw_dev, int enable)
+{
+	void *arg = dw_dev->config->funcs_arg;
+
+	dw_dev->config->funcs->reset(arg, enable);
+}
+
+static void phy_pddq(struct dw_phy_dev *dw_dev, int enable)
+{
+	void *arg = dw_dev->config->funcs_arg;
+
+	dw_dev->config->funcs->pddq(arg, enable);
+}
+
+static void phy_svsmode(struct dw_phy_dev *dw_dev, int enable)
+{
+	void *arg = dw_dev->config->funcs_arg;
+
+	dw_dev->config->funcs->svsmode(arg, enable);
+}
+
+static void phy_zcal_reset(struct dw_phy_dev *dw_dev)
+{
+	void *arg = dw_dev->config->funcs_arg;
+
+	dw_dev->config->funcs->zcal_reset(arg);
+}
+
+static bool phy_zcal_done(struct dw_phy_dev *dw_dev)
+{
+	void *arg = dw_dev->config->funcs_arg;
+
+	return dw_dev->config->funcs->zcal_done(arg);
+}
+
+static bool phy_tmds_valid(struct dw_phy_dev *dw_dev)
+{
+	void *arg = dw_dev->config->funcs_arg;
+
+	return dw_dev->config->funcs->tmds_valid(arg);
+}
+
+static int dw_phy_eq_test(struct dw_phy_dev *dw_dev,
+		u16 *fat_bit_mask, int *min_max_length)
+{
+	u16 main_fsm_status, val;
+	int i;
+
+	for (i = 0; i < PHY_EQ_WAIT_TIME_START; i++) {
+		main_fsm_status = phy_read(dw_dev, PHY_MAINFSM_STATUS1);
+		if (main_fsm_status & 0x100)
+			break;
+		mdelay(PHY_EQ_SLEEP_TIME_CDR);
+	}
+
+	if (i == PHY_EQ_WAIT_TIME_START) {
+		dev_err(dw_dev->dev, "phy start conditions not achieved\n");
+		return -ETIMEDOUT;
+	}
+
+	if (main_fsm_status & 0x400) {
+		dev_err(dw_dev->dev, "invalid pll rate\n");
+		return -EINVAL;
+	}
+
+	val = (phy_read(dw_dev, PHY_CDR_CTRL_CNT) & 0x300) >> 8;
+	if (val == 0x1) {
+		/* HDMI 2.0 */
+		*fat_bit_mask = PHY_EQ_FATBIT_MASK_HDMI20;
+		*min_max_length = PHY_EQ_MINMAX_MAXDIFF_HDMI20;
+		dev_dbg(dw_dev->dev, "[EQUALIZER] using HDMI 2.0 values\n");
+	} else if (!(main_fsm_status & 0x600)) {
+		/* HDMI 1.4 (pll rate = 0) */
+		*fat_bit_mask = PHY_EQ_FATBIT_MASK_4K;
+		*min_max_length = PHY_EQ_MINMAX_MAXDIFF;
+		dev_dbg(dw_dev->dev, "[EQUALIZER] using HDMI 1.4@4k values\n");
+	} else {
+		/* HDMI 1.4 */
+		*fat_bit_mask = PHY_EQ_FATBIT_MASK;
+		*min_max_length = PHY_EQ_MINMAX_MAXDIFF;
+		dev_dbg(dw_dev->dev, "[EQUALIZER] using HDMI 1.4 values\n");
+	}
+
+	return 0;
+}
+
+static void dw_phy_eq_default(struct dw_phy_dev *dw_dev)
+{
+	phy_write(dw_dev, 0x08A8, PHY_CH0_EQ_CTRL1);
+	phy_write(dw_dev, 0x0020, PHY_CH0_EQ_CTRL2);
+	phy_write(dw_dev, 0x08A8, PHY_CH1_EQ_CTRL1);
+	phy_write(dw_dev, 0x0020, PHY_CH1_EQ_CTRL2);
+	phy_write(dw_dev, 0x08A8, PHY_CH2_EQ_CTRL1);
+	phy_write(dw_dev, 0x0020, PHY_CH2_EQ_CTRL2);
+}
+
+static void dw_phy_eq_single(struct dw_phy_dev *dw_dev)
+{
+	phy_write(dw_dev, 0x0211, PHY_CH0_EQ_CTRL1);
+	phy_write(dw_dev, 0x0211, PHY_CH1_EQ_CTRL1);
+	phy_write(dw_dev, 0x0211, PHY_CH2_EQ_CTRL1);
+}
+
+static void dw_phy_eq_equal_setting(struct dw_phy_dev *dw_dev,
+		u16 lock_vector)
+{
+	phy_write(dw_dev, lock_vector, PHY_CH0_EQ_CTRL4);
+	phy_write(dw_dev, 0x0024, PHY_CH0_EQ_CTRL2);
+	phy_write(dw_dev, 0x0026, PHY_CH0_EQ_CTRL2);
+	phy_read(dw_dev, PHY_CH0_EQ_STATUS2);
+	phy_write(dw_dev, lock_vector, PHY_CH1_EQ_CTRL4);
+	phy_write(dw_dev, 0x0024, PHY_CH1_EQ_CTRL2);
+	phy_write(dw_dev, 0x0026, PHY_CH1_EQ_CTRL2);
+	phy_read(dw_dev, PHY_CH1_EQ_STATUS2);
+	phy_write(dw_dev, lock_vector, PHY_CH2_EQ_CTRL4);
+	phy_write(dw_dev, 0x0024, PHY_CH2_EQ_CTRL2);
+	phy_write(dw_dev, 0x0026, PHY_CH2_EQ_CTRL2);
+	phy_read(dw_dev, PHY_CH2_EQ_STATUS2);
+}
+
+static void dw_phy_eq_equal_setting_ch0(struct dw_phy_dev *dw_dev,
+		u16 lock_vector)
+{
+	phy_write(dw_dev, lock_vector, PHY_CH0_EQ_CTRL4);
+	phy_write(dw_dev, 0x0024, PHY_CH0_EQ_CTRL2);
+	phy_write(dw_dev, 0x0026, PHY_CH0_EQ_CTRL2);
+	phy_read(dw_dev, PHY_CH0_EQ_STATUS2);
+}
+
+static void dw_phy_eq_equal_setting_ch1(struct dw_phy_dev *dw_dev,
+		u16 lock_vector)
+{
+	phy_write(dw_dev, lock_vector, PHY_CH1_EQ_CTRL4);
+	phy_write(dw_dev, 0x0024, PHY_CH1_EQ_CTRL2);
+	phy_write(dw_dev, 0x0026, PHY_CH1_EQ_CTRL2);
+	phy_read(dw_dev, PHY_CH1_EQ_STATUS2);
+}
+
+static void dw_phy_eq_equal_setting_ch2(struct dw_phy_dev *dw_dev,
+		u16 lock_vector)
+{
+	phy_write(dw_dev, lock_vector, PHY_CH2_EQ_CTRL4);
+	phy_write(dw_dev, 0x0024, PHY_CH2_EQ_CTRL2);
+	phy_write(dw_dev, 0x0026, PHY_CH2_EQ_CTRL2);
+	phy_read(dw_dev, PHY_CH2_EQ_STATUS2);
+}
+
+static void dw_phy_eq_auto_calib(struct dw_phy_dev *dw_dev)
+{
+	phy_write(dw_dev, 0x1809, PHY_MAINFSM_CTRL);
+	phy_write(dw_dev, 0x1819, PHY_MAINFSM_CTRL);
+	phy_write(dw_dev, 0x1809, PHY_MAINFSM_CTRL);
+}
+
+static void dw_phy_eq_init_vars(struct dw_phy_eq_ch *ch)
+{
+	ch->acc = 0;
+	ch->acq = 0;
+	ch->last_acq = 0;
+	ch->valid_long_setting = 0;
+	ch->valid_short_setting = 0;
+	ch->best_setting = PHY_EQ_SHORT_CABLE_SETTING;
+}
+
+static bool dw_phy_eq_acquire_early_cnt(struct dw_phy_dev *dw_dev,
+		u16 setting, u16 acq, struct dw_phy_eq_ch *ch0,
+		struct dw_phy_eq_ch *ch1, struct dw_phy_eq_ch *ch2)
+{
+	u16 lock_vector = 0x1;
+	int i;
+
+	lock_vector <<= setting;
+	ch0->out_bound_acq = 0;
+	ch1->out_bound_acq = 0;
+	ch2->out_bound_acq = 0;
+	ch0->acq = 0;
+	ch1->acq = 0;
+	ch2->acq = 0;
+
+	dw_phy_eq_equal_setting(dw_dev, lock_vector);
+	dw_phy_eq_auto_calib(dw_dev);
+
+	mdelay(PHY_EQ_SLEEP_TIME_CDR);
+	if (!phy_tmds_valid(dw_dev))
+		dev_dbg(dw_dev->dev, "TMDS is NOT valid\n");
+
+	ch0->read_acq = phy_read(dw_dev, PHY_CH0_EQ_STATUS3);
+	ch1->read_acq = phy_read(dw_dev, PHY_CH1_EQ_STATUS3);
+	ch2->read_acq = phy_read(dw_dev, PHY_CH2_EQ_STATUS3);
+
+	ch0->acq += ch0->read_acq;
+	ch1->acq += ch1->read_acq;
+	ch2->acq += ch2->read_acq;
+
+	ch0->upper_bound_acq = ch0->read_acq + PHY_EQ_BOUNDSPREAD;
+	ch0->lower_bound_acq = ch0->read_acq - PHY_EQ_BOUNDSPREAD;
+	ch1->upper_bound_acq = ch1->read_acq + PHY_EQ_BOUNDSPREAD;
+	ch1->lower_bound_acq = ch1->read_acq - PHY_EQ_BOUNDSPREAD;
+	ch2->upper_bound_acq = ch2->read_acq + PHY_EQ_BOUNDSPREAD;
+	ch2->lower_bound_acq = ch2->read_acq - PHY_EQ_BOUNDSPREAD;
+
+	for (i = 1; i < acq; i++) {
+		dw_phy_eq_auto_calib(dw_dev);
+		mdelay(PHY_EQ_SLEEP_TIME_ACQ);
+
+		if ((ch0->read_acq > ch0->upper_bound_acq) ||
+				(ch0->read_acq < ch0->lower_bound_acq))
+			ch0->out_bound_acq++;
+		if ((ch1->read_acq > ch1->upper_bound_acq) ||
+				(ch1->read_acq < ch1->lower_bound_acq))
+			ch1->out_bound_acq++;
+		if ((ch2->read_acq > ch2->upper_bound_acq) ||
+				(ch2->read_acq < ch1->lower_bound_acq))
+			ch2->out_bound_acq++;
+
+		if (i == PHY_EQ_MIN_ACQ_STABLE) {
+			if ((ch0->out_bound_acq == 0) &&
+					(ch1->out_bound_acq == 0) &&
+					(ch2->out_bound_acq == 0)) {
+				acq = 3;
+				break;
+			}
+		}
+
+		ch0->read_acq = phy_read(dw_dev, PHY_CH0_EQ_STATUS3);
+		ch1->read_acq = phy_read(dw_dev, PHY_CH1_EQ_STATUS3);
+		ch2->read_acq = phy_read(dw_dev, PHY_CH2_EQ_STATUS3);
+
+		ch0->acq += ch0->read_acq;
+		ch1->acq += ch1->read_acq;
+		ch2->acq += ch2->read_acq;
+	}
+
+	ch0->acq = ch0->acq / acq;
+	ch1->acq = ch1->acq / acq;
+	ch2->acq = ch2->acq / acq;
+
+	return true;
+}
+
+static int dw_phy_eq_test_type(u16 setting, bool tmds_valid,
+		struct dw_phy_eq_ch *ch)
+{
+	u16 step_slope = 0;
+
+	if ((ch->acq < ch->last_acq) && tmds_valid) {
+		/* Long cable equalization */
+		ch->acc += ch->last_acq - ch->acq;
+		if ((ch->valid_long_setting == 0) && (ch->acq < 512) &&
+				(ch->acc > 0)) {
+			ch->best_long_setting = setting;
+			ch->valid_long_setting = 1;
+		}
+		step_slope = ch->last_acq - ch->acq;
+	}
+
+	if (tmds_valid && (ch->valid_short_setting == 0)) {
+		/* Short cable equalization */
+		if ((setting < PHY_EQ_SHORT_CABLE_SETTING) &&
+				(ch->acq < PHY_EQ_EQUALIZED_COUNTER_VAL)) {
+			ch->best_short_setting= setting;
+			ch->valid_short_setting = 1;
+		}
+
+		if (setting == PHY_EQ_SHORT_CABLE_SETTING) {
+			ch->best_short_setting = PHY_EQ_SHORT_CABLE_SETTING;
+			ch->valid_short_setting = 1;
+		}
+	}
+
+	if (ch->valid_long_setting && (ch->acc > PHY_EQ_ACC_LIMIT)) {
+		ch->best_setting = ch->best_long_setting;
+		return 1;
+	}
+
+	if ((setting == PHY_EQ_MAX_SETTING) && (ch->acc < PHY_EQ_ACC_LIMIT) &&
+			ch->valid_short_setting) {
+		ch->best_setting = ch->best_short_setting;
+		return 2;
+	}
+
+	if ((setting == PHY_EQ_MAX_SETTING) && tmds_valid &&
+			(ch->acc > PHY_EQ_ACC_LIMIT) &&
+			(step_slope > PHY_EQ_MIN_SLOPE)) {
+		ch->best_setting = PHY_EQ_MAX_SETTING;
+		return 3;
+	}
+
+	if (setting == PHY_EQ_MAX_SETTING) {
+		ch->best_setting = PHY_EQ_ERROR_CABLE_SETTING;
+		return 255;
+	}
+
+	return 0;
+}
+
+static bool dw_phy_eq_setting_finder(struct dw_phy_dev *dw_dev, u16 acq,
+		struct dw_phy_eq_ch *ch0, struct dw_phy_eq_ch *ch1,
+		struct dw_phy_eq_ch *ch2)
+{
+	u16 act = 0;
+	int ret_ch0 = 0, ret_ch1 = 0, ret_ch2 = 0;
+	bool tmds_valid = false;
+
+	dw_phy_eq_init_vars(ch0);
+	dw_phy_eq_init_vars(ch1);
+	dw_phy_eq_init_vars(ch2);
+
+	tmds_valid = dw_phy_eq_acquire_early_cnt(dw_dev, act, acq,
+			ch0, ch1, ch2);
+
+	while ((ret_ch0 == 0) || (ret_ch1 == 0) || (ret_ch2 == 0)) {
+		act++;
+
+		ch0->last_acq = ch0->acq;
+		ch1->last_acq = ch1->acq;
+		ch2->last_acq = ch2->acq;
+
+		tmds_valid = dw_phy_eq_acquire_early_cnt(dw_dev, act, acq,
+				ch0, ch1, ch2);
+
+		if (!ret_ch0)
+			ret_ch0 = dw_phy_eq_test_type(act, tmds_valid, ch0);
+		if (!ret_ch1)
+			ret_ch1 = dw_phy_eq_test_type(act, tmds_valid, ch1);
+		if (!ret_ch2)
+			ret_ch2 = dw_phy_eq_test_type(act, tmds_valid, ch2);
+	}
+
+	if ((ret_ch0 == 255) || (ret_ch1 == 255) || (ret_ch2 == 255))
+		return false;
+	return true;
+}
+
+static bool dw_phy_eq_maxvsmin(u16 ch0_setting, u16 ch1_setting,
+		u16 ch2_setting, u16 min_max_length)
+{
+	u16 min = ch0_setting, max = ch0_setting;
+
+	if (ch1_setting > max)
+		max = ch1_setting;
+	if (ch2_setting > max)
+		max = ch2_setting;
+	if (ch1_setting < min)
+		min = ch1_setting;
+	if (ch2_setting < min)
+		min = ch2_setting;
+
+	if ((max - min) > min_max_length)
+		return false;
+	return true;
+}
+
+static int dw_phy_eq_init(struct dw_phy_dev *dw_dev, u16 acq, bool force)
+{
+	struct dw_phy_pdata *phy = dw_dev->config;
+	struct dw_phy_eq_ch ch0, ch1, ch2;
+	u16 fat_bit_mask, lock_vector = 0x1;
+	int min_max_length, i, ret = 0;
+	u16 mpll_status;
+
+	if (phy->version < 401)
+		return ret;
+
+	mpll_status = phy_read(dw_dev, PHY_CLK_MPLL_STATUS);
+	if (mpll_status == dw_dev->mpll_status && !force)
+		return ret;
+	dw_dev->mpll_status = mpll_status;
+
+	phy_write(dw_dev, 0x00, PHY_MAINFSM_OVR2);
+	phy_write(dw_dev, 0x00, PHY_CH0_EQ_CTRL3);
+	phy_write(dw_dev, 0x00, PHY_CH1_EQ_CTRL3);
+	phy_write(dw_dev, 0x00, PHY_CH2_EQ_CTRL3);
+
+	ret = dw_phy_eq_test(dw_dev, &fat_bit_mask, &min_max_length);
+	if (ret) {
+		if (ret == -EINVAL) /* Means equalizer is not needed */
+			ret = 0;
+
+		/* Do not change values if we don't have clock */
+		if (ret != -ETIMEDOUT) {
+			dw_phy_eq_default(dw_dev);
+			phy_pddq(dw_dev, 1);
+			udelay(1);
+			phy_pddq(dw_dev, 0);
+			mdelay(3);
+		}
+	} else {
+		dw_phy_eq_single(dw_dev);
+		dw_phy_eq_equal_setting(dw_dev, 0x0001);
+		phy_write(dw_dev, fat_bit_mask, PHY_CH0_EQ_CTRL6);
+		phy_write(dw_dev, fat_bit_mask, PHY_CH1_EQ_CTRL6);
+		phy_write(dw_dev, fat_bit_mask, PHY_CH2_EQ_CTRL6);
+
+		for (i = 0; i < PHY_EQ_MINMAX_NTRIES; i++) {
+			if (dw_phy_eq_setting_finder(dw_dev, acq,
+						&ch0, &ch1, &ch2)) {
+				if (dw_phy_eq_maxvsmin(ch0.best_setting,
+							ch1.best_setting,
+							ch2.best_setting,
+							min_max_length))
+					break;
+			}
+
+			ch0.best_setting = PHY_EQ_ERROR_CABLE_SETTING;
+			ch1.best_setting = PHY_EQ_ERROR_CABLE_SETTING;
+			ch2.best_setting = PHY_EQ_ERROR_CABLE_SETTING;
+		}
+
+		dev_dbg(dw_dev->dev, "equalizer settings: "
+				"ch0=0x%x, ch1=0x%x, ch1=0x%x\n",
+				ch0.best_setting, ch1.best_setting,
+				ch2.best_setting);
+
+		if (i == PHY_EQ_MINMAX_NTRIES)
+			ret = -EINVAL;
+
+		lock_vector = 0x1;
+		lock_vector <<= ch0.best_setting;
+		dw_phy_eq_equal_setting_ch0(dw_dev, lock_vector);
+
+		lock_vector = 0x1;
+		lock_vector <<= ch1.best_setting;
+		dw_phy_eq_equal_setting_ch1(dw_dev, lock_vector);
+
+		lock_vector = 0x1;
+		lock_vector <<= ch2.best_setting;
+		dw_phy_eq_equal_setting_ch2(dw_dev, lock_vector);
+
+		phy_pddq(dw_dev, 1);
+		udelay(1);
+		phy_pddq(dw_dev, 0);
+		mdelay(3);
+	}
+
+	return ret;
+}
+
+static void dw_phy_set_res(struct dw_phy_dev *dw_dev, unsigned char res)
+{
+	u16 val, res_idx;
+
+	if (!dw_dev->phy_enabled)
+		return;
+	if (dw_dev->res == res)
+		return;
+
+	dev_dbg(dw_dev->dev, "%s: res=%d\n", __func__, res);
+
+	switch (res) {
+	case 8:
+		res_idx = 0x0;
+		break;
+	case 10:
+		res_idx = 0x1;
+		break;
+	case 12:
+		res_idx = 0x2;
+		break;
+	case 16:
+		res_idx = 0x3;
+		break;
+	default:
+		return;
+	}
+
+	/* Set phy in configuration mode */
+	phy_pddq(dw_dev, 1);
+
+	/* Color depth */
+	val = phy_read(dw_dev, PHY_SYSTEM_CONFIG);
+	val = (val & ~0x60) | (res_idx << 5);
+	phy_write(dw_dev, val, PHY_SYSTEM_CONFIG);
+
+	/* Enable phy */
+	phy_pddq(dw_dev, 0);
+
+	dw_dev->res = res;
+}
+
+static void dw_phy_set_hdmi2(struct dw_phy_dev *dw_dev, bool on)
+{
+	u16 val;
+
+	if (!dw_dev->phy_enabled)
+		return;
+	if (dw_dev->hdmi2 == on)
+		return;
+
+	dev_dbg(dw_dev->dev, "%s: on=%d\n", __func__, on);
+
+	/* Set phy in configuration mode */
+	phy_pddq(dw_dev, 1);
+
+	/* Operation for data rates between 3.4Gbps and 6Gbps */
+	val = phy_read(dw_dev, PHY_CDR_CTRL_CNT);
+	if (on)
+		val |= BIT(8);
+	else
+		val &= ~BIT(8);
+	phy_write(dw_dev, val, PHY_CDR_CTRL_CNT);
+
+	/* Enable phy */
+	phy_pddq(dw_dev, 0);
+
+	dw_dev->hdmi2 = on;
+}
+
+static void dw_phy_set_scrambling(struct dw_phy_dev *dw_dev, bool on)
+{
+	u16 val;
+
+	if (!dw_dev->phy_enabled)
+		return;
+	if (dw_dev->scrambling == on)
+		return;
+
+	dev_dbg(dw_dev->dev, "%s: on=%d\n", __func__, on);
+
+	/* Set phy in configuration mode */
+	phy_pddq(dw_dev, 1);
+
+	val = phy_read(dw_dev, PHY_OVL_PROT_CTRL);
+	if (on)
+		val |= GENMASK(7,6);
+	else
+		val &= ~GENMASK(7,6);
+	phy_write(dw_dev, val, PHY_OVL_PROT_CTRL);
+
+	/* Enable phy */
+	phy_pddq(dw_dev, 0);
+
+	dw_dev->scrambling = on;
+}
+
+static int dw_phy_init(struct dw_phy_dev *dw_dev, unsigned char res,
+		bool data_rate_6g, bool scrambling)
+{
+	struct device *dev = dw_dev->dev;
+	struct dw_phy_pdata *phy = dw_dev->config;
+	const struct dw_phy_mpll_config *mpll_cfg = dw_phy_e405_mpll_cfg;
+	bool zcal_done;
+	u16 val, res_idx;
+	int timeout = 100;
+
+	dev_dbg(dev, "configuring phy: res=%d, hdmi2=%d, scrambling=%d\n",
+			res, data_rate_6g, scrambling);
+
+	switch (res) {
+	case 8:
+		res_idx = 0x0;
+		break;
+	case 10:
+		res_idx = 0x1;
+		break;
+	case 12:
+		res_idx = 0x2;
+		break;
+	case 16:
+		res_idx = 0x3;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	phy_reset(dw_dev, 1);
+	phy_pddq(dw_dev, 1);
+	phy_svsmode(dw_dev, 1);
+
+	phy_zcal_reset(dw_dev);
+	do {
+		udelay(1000);
+		zcal_done = phy_zcal_done(dw_dev);
+	} while (!zcal_done && timeout--);
+
+	if (!zcal_done) {
+		dev_err(dw_dev->dev, "Zcal calibration failed\n");
+		return -ETIMEDOUT;
+	}
+
+	phy_reset(dw_dev, 0);
+
+	/* CMU */
+	val = (0x08 << 10) | (0x01 << 9);
+	val |= (phy->cfg_clk * 4) & GENMASK(8, 0);
+	phy_write(dw_dev, val, PHY_CMU_CONFIG);
+
+	/* Color Depth and enable fast switching */
+	val = phy_read(dw_dev, PHY_SYSTEM_CONFIG);
+	val = (val & ~0x60) | (res_idx << 5) | BIT(11);
+	phy_write(dw_dev, val, PHY_SYSTEM_CONFIG);
+
+	/* MPLL */
+	for (; mpll_cfg->addr != 0x0; mpll_cfg++)
+		phy_write(dw_dev, mpll_cfg->val, mpll_cfg->addr);
+
+	/* Operation for data rates between 3.4Gbps and 6Gbps */
+	val = phy_read(dw_dev, PHY_CDR_CTRL_CNT);
+	if (data_rate_6g)
+		val |= BIT(8);
+	else
+		val &= ~BIT(8);
+	phy_write(dw_dev, val, PHY_CDR_CTRL_CNT);
+
+	/* Scrambling */
+	val = phy_read(dw_dev, PHY_OVL_PROT_CTRL);
+	if (scrambling)
+		val |= GENMASK(7,6);
+	else
+		val &= ~GENMASK(7,6);
+	phy_write(dw_dev, val, PHY_OVL_PROT_CTRL);
+
+	/* Enable phy */
+	phy_pddq(dw_dev, 0);
+
+	dw_dev->res = res;
+	dw_dev->hdmi2 = data_rate_6g;
+	dw_dev->scrambling = scrambling;
+	return 0;
+}
+
+static void dw_phy_enable(struct dw_phy_dev *dw_dev)
+{
+	if (dw_dev->phy_enabled)
+		return;
+
+	dw_phy_init(dw_dev, 8, false, false);
+	phy_reset(dw_dev, 0);
+	phy_pddq(dw_dev, 0);
+	dw_dev->phy_enabled = true;
+}
+
+static void dw_phy_disable(struct dw_phy_dev *dw_dev)
+{
+	if (!dw_dev->phy_enabled)
+		return;
+
+	phy_reset(dw_dev, 1);
+	phy_pddq(dw_dev, 1);
+	phy_svsmode(dw_dev, 0);
+	dw_dev->mpll_status = 0xFFFF;
+	dw_dev->phy_enabled = false;
+}
+
+static long dw_phy_ioctl(struct v4l2_subdev *sd, unsigned int cmd, void *arg)
+{
+	struct dw_phy_dev *dw_dev = to_dw_dev(sd);
+	struct dw_phy_command *a = arg;
+	int ret = 0;
+
+	dev_dbg(dw_dev->dev, "%s: cmd=%d\n", __func__, cmd);
+
+	mutex_lock(&dw_dev->lock);
+	switch (cmd) {
+	case DW_PHY_IOCTL_EQ_INIT:
+		a->result = dw_phy_eq_init(dw_dev, a->nacq, a->force);
+		break;
+	case DW_PHY_IOCTL_SET_HDMI2:
+		dw_phy_set_hdmi2(dw_dev, a->hdmi2);
+		a->result = 0;
+		break;
+	case DW_PHY_IOCTL_SET_SCRAMBLING:
+		dw_phy_set_scrambling(dw_dev, a->scrambling);
+		a->result = 0;
+		break;
+	case DW_PHY_IOCTL_CONFIG:
+		dw_phy_enable(dw_dev);
+		dw_phy_set_res(dw_dev, a->res);
+		dw_phy_set_hdmi2(dw_dev, a->hdmi2);
+		dw_phy_set_scrambling(dw_dev, a->scrambling);
+		a->result = 0;
+		break;
+	default:
+		ret = -ENOIOCTLCMD;
+		break;
+	}
+	mutex_unlock(&dw_dev->lock);
+
+	return ret;
+}
+
+static int dw_phy_s_power(struct v4l2_subdev *sd, int on)
+{
+	struct dw_phy_dev *dw_dev = to_dw_dev(sd);
+
+	dev_dbg(dw_dev->dev, "%s: on=%d\n", __func__, on);
+
+	mutex_lock(&dw_dev->lock);
+	if (!on)
+		dw_phy_disable(dw_dev);
+	mutex_unlock(&dw_dev->lock);
+	return 0;
+}
+
+static const struct v4l2_subdev_core_ops dw_phy_core_ops = {
+	.ioctl = dw_phy_ioctl,
+	.s_power = dw_phy_s_power,
+};
+
+static const struct v4l2_subdev_ops dw_phy_sd_ops = {
+	.core = &dw_phy_core_ops,
+};
+
+static int dw_phy_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct dw_phy_dev *dw_dev;
+	struct dw_phy_pdata *pdata = pdev->dev.platform_data;
+	struct v4l2_subdev *sd;
+
+	dev_dbg(dev, "probe start\n");
+
+	/* Resource allocation */
+	dw_dev = devm_kzalloc(dev, sizeof(*dw_dev), GFP_KERNEL);
+	if (!dw_dev)
+		return -ENOMEM;
+
+	/* Resource initialization */
+	if (!pdata)
+		return -EINVAL;
+
+	dw_dev->dev = dev;
+	dw_dev->config = pdata;
+	mutex_init(&dw_dev->lock);
+
+	/* V4L2 initialization */
+	sd = &dw_dev->sd;
+	v4l2_subdev_init(sd, &dw_phy_sd_ops);
+	strlcpy(sd->name, dev_name(dev), sizeof(sd->name));
+
+	/* Phy initialization */
+	dw_phy_init(dw_dev, 8, false, false);
+
+	/* All done */
+	dev_set_drvdata(dev, sd);
+	dev_info(dev, "driver probed\n");
+	return 0;
+}
+
+static int dw_phy_remove(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+
+	dev_info(dev, "driver removed\n");
+	return 0;
+}
+
+static struct platform_driver dw_phy_e405_driver = {
+	.probe = dw_phy_probe,
+	.remove = dw_phy_remove,
+	.driver = {
+		.name = DW_PHY_E405_DRVNAME,
+	}
+};
+module_platform_driver(dw_phy_e405_driver);
diff --git a/drivers/media/platform/dwc/dw-hdmi-phy-e405.h b/drivers/media/platform/dwc/dw-hdmi-phy-e405.h
new file mode 100644
index 0000000..3e6c8da
--- /dev/null
+++ b/drivers/media/platform/dwc/dw-hdmi-phy-e405.h
@@ -0,0 +1,63 @@
+/*
+ * Synopsys Designware HDMI PHY E405 driver
+ *
+ * This Synopsys dw-phy-e405 software and associated documentation
+ * (hereinafter the "Software") is an unsupported proprietary work of
+ * Synopsys, Inc. unless otherwise expressly agreed to in writing between
+ * Synopsys and you. The Software IS NOT an item of Licensed Software or a
+ * Licensed Product under any End User Software License Agreement or
+ * Agreement for Licensed Products with Synopsys or any supplement thereto.
+ * Synopsys is a registered trademark of Synopsys, Inc. Other names included
+ * in the SOFTWARE may be the trademarks of their respective owners.
+ *
+ * The contents of this file are dual-licensed; you may select either version 2
+ * of the GNU General Public License (“GPL”) or the MIT license (“MIT”).
+ *
+ * Copyright (c) 2017 Synopsys, Inc. and/or its affiliates.
+ *
+ * THIS SOFTWARE IS PROVIDED "AS IS"  WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING, BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE, AND NONINFRINGEMENT. IN NO EVENT SHALL THE
+ * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
+ * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT, OR OTHERWISE
+ * ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE THE USE OR
+ * OTHER DEALINGS IN THE SOFTWARE.
+ */
+
+#ifndef __DW_HDMI_PHY_E405_H__
+#define __DW_HDMI_PHY_E405_H__
+
+#define PHY_CMU_CONFIG				0x02
+#define PHY_SYSTEM_CONFIG			0x03
+#define PHY_MAINFSM_CTRL			0x05
+#define PHY_MAINFSM_OVR2			0x08
+#define PHY_MAINFSM_STATUS1			0x09
+#define PHY_OVL_PROT_CTRL			0x0D
+#define PHY_CDR_CTRL_CNT			0x0E
+#define PHY_CLK_MPLL_STATUS			0x2F
+#define PHY_CH0_EQ_CTRL1			0x32
+#define PHY_CH0_EQ_CTRL2			0x33
+#define PHY_CH0_EQ_STATUS			0x34
+#define PHY_CH0_EQ_CTRL3			0x3E
+#define PHY_CH0_EQ_CTRL4			0x3F
+#define PHY_CH0_EQ_STATUS2			0x40
+#define PHY_CH0_EQ_STATUS3			0x42
+#define PHY_CH0_EQ_CTRL6			0x43
+#define PHY_CH1_EQ_CTRL1			0x52
+#define PHY_CH1_EQ_CTRL2			0x53
+#define PHY_CH1_EQ_STATUS			0x54
+#define PHY_CH1_EQ_CTRL3			0x5E
+#define PHY_CH1_EQ_CTRL4			0x5F
+#define PHY_CH1_EQ_STATUS2			0x60
+#define PHY_CH1_EQ_STATUS3			0x62
+#define PHY_CH1_EQ_CTRL6			0x63
+#define PHY_CH2_EQ_CTRL1			0x72
+#define PHY_CH2_EQ_CTRL2			0x73
+#define PHY_CH2_EQ_STATUS			0x74
+#define PHY_CH2_EQ_CTRL3			0x7E
+#define PHY_CH2_EQ_CTRL4			0x7F
+#define PHY_CH2_EQ_STATUS2			0x80
+#define PHY_CH2_EQ_STATUS3			0x82
+#define PHY_CH2_EQ_CTRL6			0x83
+
+#endif /* __DW_HDMI_PHY_E405_H__ */
diff --git a/include/media/dwc/dw-hdmi-phy-pdata.h b/include/media/dwc/dw-hdmi-phy-pdata.h
new file mode 100644
index 0000000..c2962ec
--- /dev/null
+++ b/include/media/dwc/dw-hdmi-phy-pdata.h
@@ -0,0 +1,64 @@
+/*
+ * Synopsys Designware HDMI PHY platform data
+ *
+ * This Synopsys dw-hdmi-phy software and associated documentation
+ * (hereinafter the "Software") is an unsupported proprietary work of
+ * Synopsys, Inc. unless otherwise expressly agreed to in writing between
+ * Synopsys and you. The Software IS NOT an item of Licensed Software or a
+ * Licensed Product under any End User Software License Agreement or
+ * Agreement for Licensed Products with Synopsys or any supplement thereto.
+ * Synopsys is a registered trademark of Synopsys, Inc. Other names included
+ * in the SOFTWARE may be the trademarks of their respective owners.
+ *
+ * The contents of this file are dual-licensed; you may select either version 2
+ * of the GNU General Public License (“GPL”) or the MIT license (“MIT”).
+ *
+ * Copyright (c) 2017 Synopsys, Inc. and/or its affiliates.
+ *
+ * THIS SOFTWARE IS PROVIDED "AS IS"  WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING, BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE, AND NONINFRINGEMENT. IN NO EVENT SHALL THE
+ * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
+ * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT, OR OTHERWISE
+ * ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE THE USE OR
+ * OTHER DEALINGS IN THE SOFTWARE.
+ */
+
+#ifndef __DW_HDMI_PHY_PDATA_H__
+#define __DW_HDMI_PHY_PDATA_H__
+
+#define DW_PHY_E405_DRVNAME	"dw-hdmi-phy-e405"
+
+#define DW_PHY_IOCTL_EQ_INIT		_IOW('R',1,int)
+#define DW_PHY_IOCTL_SET_HDMI2		_IOW('R',2,int)
+#define DW_PHY_IOCTL_SET_SCRAMBLING	_IOW('R',3,int)
+#define DW_PHY_IOCTL_CONFIG		_IOW('R',4,int)
+
+struct dw_phy_command {
+	int result;
+	unsigned char res;
+	bool hdmi2;
+	u16 nacq;
+	bool scrambling;
+	bool force;
+};
+
+struct dw_phy_funcs {
+	void (*write) (void *arg, u16 val, u16 addr);
+	u16 (*read) (void *arg, u16 addr);
+	void (*reset) (void *arg, int enable);
+	void (*pddq) (void *arg, int enable);
+	void (*svsmode) (void *arg, int enable);
+	void (*zcal_reset) (void *arg);
+	bool (*zcal_done) (void *arg);
+	bool (*tmds_valid) (void *arg);
+};
+
+struct dw_phy_pdata {
+	unsigned int version;
+	unsigned int cfg_clk;
+	const struct dw_phy_funcs *funcs;
+	void *funcs_arg;
+};
+
+#endif /* __DW_HDMI_PHY_PDATA_H__ */
-- 
1.9.1
