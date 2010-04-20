Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:50498 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983Ab0DTPU2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Apr 2010 11:20:28 -0400
Received: from vaebh105.NOE.Nokia.com (vaebh105.europe.nokia.com [10.160.244.31])
	by mgw-mx03.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o3KFJvsk029680
	for <linux-media@vger.kernel.org>; Tue, 20 Apr 2010 18:20:25 +0300
From: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
To: linux-media@vger.kernel.org, eduardo.valentin@nokia.com
Cc: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Subject: [PATCH 1/3] MFD: WL1273 FM Radio: MFD driver for the FM radio.
Date: Tue, 20 Apr 2010 18:20:05 +0300
Message-Id: <1271776807-2710-2-git-send-email-matti.j.aaltonen@nokia.com>
In-Reply-To: <1271776807-2710-1-git-send-email-matti.j.aaltonen@nokia.com>
References: <1271776807-2710-1-git-send-email-matti.j.aaltonen@nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a parent driver for two child drivers: the V4L2 driver and
the ALSA codec driver. The MFD part provides the I2C communication
to the device and the state handling.

Signed-off-by: Matti J. Aaltonen <matti.j.aaltonen@nokia.com>
---
 drivers/mfd/Kconfig             |    6 +
 drivers/mfd/Makefile            |    2 +
 drivers/mfd/wl1273-core.c       | 1825 +++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/wl1273-core.h |  265 ++++++
 4 files changed, 2098 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/wl1273-core.c
 create mode 100644 include/linux/mfd/wl1273-core.h

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 413576a..c16d500 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -135,6 +135,12 @@ config TWL4030_CODEC
 	select MFD_CORE
 	default n
 
+config WL1273_CORE
+	tristate
+	depends on I2C
+	select MFD_CORE
+	default n
+
 config MFD_TMIO
 	bool
 	default n
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 16a349f..5381cd3 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -30,6 +30,8 @@ obj-$(CONFIG_TWL4030_CORE)	+= twl-core.o twl4030-irq.o twl6030-irq.o
 obj-$(CONFIG_TWL4030_POWER)    += twl4030-power.o
 obj-$(CONFIG_TWL4030_CODEC)	+= twl4030-codec.o
 
+obj-$(CONFIG_WL1273_CORE)	+= wl1273-core.o
+
 obj-$(CONFIG_MFD_MC13783)	+= mc13783-core.o
 
 obj-$(CONFIG_MFD_CORE)		+= mfd-core.o
diff --git a/drivers/mfd/wl1273-core.c b/drivers/mfd/wl1273-core.c
new file mode 100644
index 0000000..77b9442
--- /dev/null
+++ b/drivers/mfd/wl1273-core.c
@@ -0,0 +1,1825 @@
+/*
+ * MFD driver for wl1273 FM radio and audio codec submodules.
+ *
+ * Author:	Matti Aaltonen <matti.j.aaltonen@nokia.com>
+ *
+ * Copyright:   (C) 2010 Nokia Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#undef DEBUG
+
+#include <asm/unaligned.h>
+#include <linux/completion.h>
+#include <linux/delay.h>
+#include <linux/firmware.h>
+#include <linux/i2c.h>
+#include <linux/interrupt.h>
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/fs.h>
+#include <linux/platform_device.h>
+#include <linux/mfd/core.h>
+#include <linux/mfd/wl1273-core.h>
+#include <media/v4l2-common.h>
+
+#define DRIVER_DESC "WL1273 FM Radio Core"
+
+#define WL1273_FR_EVENT			(1 << 0)
+#define WL1273_BL_EVENT			(1 << 1)
+#define WL1273_RDS_EVENT		(1 << 2)
+#define WL1273_BBLK_EVENT		(1 << 3)
+#define WL1273_LSYNC_EVENT		(1 << 4)
+#define WL1273_LEV_EVENT		(1 << 5)
+#define WL1273_IFFR_EVENT		(1 << 6)
+#define WL1273_PI_EVENT			(1 << 7)
+#define WL1273_PD_EVENT			(1 << 8)
+#define WL1273_STIC_EVENT		(1 << 9)
+#define WL1273_MAL_EVENT		(1 << 10)
+#define WL1273_POW_ENB_EVENT		(1 << 11)
+#define WL1273_SCAN_OVER_EVENT		(1 << 12)
+#define WL1273_ERROR_EVENT		(1 << 13)
+
+#define WL1273_IRQ_MASK	 (WL1273_FR_EVENT		|	\
+			  WL1273_POW_ENB_EVENT)
+
+/* I2S protocol, left channel first, data width 16 bits */
+#define WL1273_PCM_DEF_MODE		0x00
+
+/* Rx */
+#define WL1273_AUDIO_ENABLE_I2S		(1 << 0)
+#define WL1273_AUDIO_ENABLE_ANALOG	(1 << 1)
+
+/* Tx */
+#define WL1273_AUDIO_IO_SET_ANALOG	0
+#define WL1273_AUDIO_IO_SET_I2S		1
+
+#define WL1273_POWER_SET_OFF		0
+#define WL1273_POWER_SET_FM		(1 << 0)
+#define WL1273_POWER_SET_RDS		(1 << 1)
+#define WL1273_POWER_SET_RETENTION	(1 << 4)
+
+#define WL1273_PUPD_SET_OFF		0x00
+#define WL1273_PUPD_SET_ON		0x01
+#define WL1273_PUPD_SET_RETENTION	0x10
+
+#define TUNER_MODE_STOP_SEARCH	0
+#define TUNER_MODE_PRESET	1
+#define TUNER_MODE_AUTO_SEEK	2
+#define TUNER_MODE_AF		3
+
+/* I2S mode */
+#define WL1273_IS2_WIDTH_32	0x0
+#define WL1273_IS2_WIDTH_40	0x1
+#define WL1273_IS2_WIDTH_22_23	0x2
+#define WL1273_IS2_WIDTH_23_22	0x3
+#define WL1273_IS2_WIDTH_48	0x4
+#define WL1273_IS2_WIDTH_50	0x5
+#define WL1273_IS2_WIDTH_60	0x6
+#define WL1273_IS2_WIDTH_64	0x7
+#define WL1273_IS2_WIDTH_80	0x8
+#define WL1273_IS2_WIDTH_96	0x9
+#define WL1273_IS2_WIDTH_128	0xa
+#define WL1273_IS2_WIDTH	0xf
+
+#define WL1273_IS2_FORMAT_STD	(0x0 << 4)
+#define WL1273_IS2_FORMAT_LEFT	(0x1 << 4)
+#define WL1273_IS2_FORMAT_RIGHT	(0x2 << 4)
+#define WL1273_IS2_FORMAT_USER	(0x3 << 4)
+
+#define WL1273_IS2_MASTER	(0x0 << 6)
+#define WL1273_IS2_SLAVEW	(0x1 << 6)
+
+#define WL1273_IS2_TRI_AFTER_SENDING	(0x0 << 7)
+#define WL1273_IS2_TRI_ALWAYS_ACTIVE	(0x1 << 7)
+
+#define WL1273_IS2_SDOWS_RR	(0x0 << 8)
+#define WL1273_IS2_SDOWS_RF	(0x1 << 8)
+#define WL1273_IS2_SDOWS_FR	(0x2 << 8)
+#define WL1273_IS2_SDOWS_FF	(0x3 << 8)
+
+#define WL1273_IS2_TRI_OPT	(0x0 << 10)
+#define WL1273_IS2_TRI_ALWAYS	(0x1 << 10)
+
+#define WL1273_IS2_RATE_48K	(0x0 << 12)
+#define WL1273_IS2_RATE_44_1K	(0x1 << 12)
+#define WL1273_IS2_RATE_32K	(0x2 << 12)
+#define WL1273_IS2_RATE_22_05K	(0x4 << 12)
+#define WL1273_IS2_RATE_16K	(0x5 << 12)
+#define WL1273_IS2_RATE_12K	(0x8 << 12)
+#define WL1273_IS2_RATE_11_025	(0x9 << 12)
+#define WL1273_IS2_RATE_8K	(0xa << 12)
+#define WL1273_IS2_RATE		(0xf << 12)
+
+#define WL1273_I2S_DEF_MODE	(WL1273_IS2_WIDTH_32 | \
+				 WL1273_IS2_FORMAT_STD | \
+				 WL1273_IS2_MASTER | \
+				 WL1273_IS2_TRI_AFTER_SENDING | \
+				 WL1273_IS2_SDOWS_RR | \
+				 WL1273_IS2_TRI_OPT | \
+				 WL1273_IS2_RATE_48K)
+
+static const struct region_info regions[] = {
+	/* Japan */
+	{
+		.bottom_frequency	= 76000,
+		.top_frequency		= 90000,
+		.region			= 0,
+	},
+	/* USA & Europe */
+	{
+		.bottom_frequency	= 87500,
+		.top_frequency		= 108000,
+		.region			= 1,
+	},
+};
+
+/*
+ * static unsigned char radio_region - Region
+ *
+ * The regions are 0=Japan, 1=USA-Europe. USA-Europe is the default.
+ */
+static unsigned char radio_region = 1;
+module_param(radio_region, byte, 0);
+MODULE_PARM_DESC(radio_region, "Region: 0=Japan, 1=USA-Europe*");
+
+/*
+ * static unsigned int rds_buf - the number of RDS buffer blocks used.
+ *
+ * The default number is 100.
+ */
+static unsigned int rds_buf = 100;
+module_param(rds_buf, uint, 0);
+MODULE_PARM_DESC(rds_buf, "RDS buffer entries: *100*");
+
+int wl1273_fm_read_reg(struct wl1273_core *core, u8 reg, u16 *value)
+{
+	struct i2c_client *client = core->i2c_dev;
+	u8 b[2];
+	int r;
+
+	r = i2c_smbus_read_i2c_block_data(client, reg, 2, b);
+	if (r != 2) {
+		dev_err(&client->dev, "%s: Read: %d fails.\n", __func__, reg);
+		return -EREMOTEIO;
+	}
+
+	*value = (u16)b[0] << 8 | b[1];
+
+	return 0;
+}
+EXPORT_SYMBOL(wl1273_fm_read_reg);
+
+int wl1273_fm_write_cmd(struct wl1273_core *core, u8 cmd, u16 param)
+{
+	struct i2c_client *client = core->i2c_dev;
+	u8 buf[] = { (param >> 8) & 0xff, param & 0xff };
+	int r;
+
+	r = i2c_smbus_write_i2c_block_data(client, cmd, 2, buf);
+	if (r) {
+		dev_err(&client->dev, "%s: Cmd: %d fails.\n", __func__, cmd);
+		return r;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(wl1273_fm_write_cmd);
+
+int wl1273_fm_write_data(struct wl1273_core *core, u8 *data, u16 len)
+{
+	struct i2c_client *client = core->i2c_dev;
+	struct i2c_msg msg[1];
+	int r;
+
+	msg[0].addr = client->addr;
+	msg[0].flags = 0;
+	msg[0].buf = data;
+	msg[0].len = len;
+
+	r = i2c_transfer(client->adapter, msg, 1);
+
+	if (r != 1) {
+		dev_err(&client->dev, "%s: write error.\n", __func__);
+		return -EREMOTEIO;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(wl1273_fm_write_data);
+
+/**
+ * wl1273_fm_get_tx_ctune() -	Get the TX tuning capacitor value.
+ * @core:			A pointer to the device struct.
+ */
+unsigned int wl1273_fm_get_tx_ctune(struct wl1273_core *core)
+{
+	struct i2c_client *client = core->i2c_dev;
+	u16 val;
+	int r;
+
+	if (core->mode == WL1273_MODE_OFF ||
+	    core->mode == WL1273_MODE_SUSPENDED)
+		return -EPERM;
+
+	r = wl1273_fm_read_reg(core, WL1273_READ_FMANT_TUNE_VALUE, &val);
+	if (r) {
+		dev_err(&client->dev, "%s: I2C error: %d\n", __func__, r);
+		goto out;
+	}
+
+out:
+	return val;
+}
+EXPORT_SYMBOL(wl1273_fm_get_tx_ctune);
+
+/**
+ * wl1273_fm_get_tx_power() 	Get the transmission power value.
+ * @core:			A pointer to the device struct.
+ */
+unsigned int wl1273_fm_get_tx_power(struct wl1273_core *core)
+{
+	return core->tx_power;
+}
+EXPORT_SYMBOL(wl1273_fm_get_tx_power);
+
+/**
+ * wl1273_fm_set_tx_power() - 	Set the transmission power value.
+ * @core:			A pointer to the device struct.
+ * @power:			The new power value.
+ */
+int wl1273_fm_set_tx_power(struct wl1273_core *core, u16 power)
+{
+	int r;
+
+	if (core->mode == WL1273_MODE_OFF ||
+	    core->mode == WL1273_MODE_SUSPENDED)
+		return -EPERM;
+
+	mutex_lock(&core->lock);
+
+	r = wl1273_fm_write_cmd(core, WL1273_POWER_LEV_SET, power);
+	if (r)
+		goto out;
+
+	core->tx_power = power;
+
+out:
+	mutex_unlock(&core->lock);
+	return r;
+}
+EXPORT_SYMBOL(wl1273_fm_set_tx_power);
+
+/**
+ * wl1273_fm_get_search_level() - Get the signal threshold value that
+ *				  once reached will stop the automatic
+ *				  RX channel seek process.
+ * @core:			  A pointer to the device struct.
+ */
+int wl1273_fm_get_search_level(struct wl1273_core *core)
+{
+	return core->search_level;
+}
+EXPORT_SYMBOL(wl1273_fm_get_search_level);
+
+/**
+ * wl1273_fm_set_search_level() - Set the signal strength value that is
+ *				  used to decide if a channel has benn
+ *				  found in automatic seek.
+ * @core:			  A pointer to the device struct.
+ * @level:			  The threshold signal strengt, an eight bit
+ *				  signed value.
+ */
+int wl1273_fm_set_search_level(struct wl1273_core *core, s16 level)
+{
+	if (core->mode == WL1273_MODE_OFF ||
+	    core->mode == WL1273_MODE_SUSPENDED)
+		return -EPERM;
+
+	if (level < SCHAR_MIN || level > SCHAR_MAX)
+		return -ERANGE;
+
+	core->search_level = level;
+
+out:
+	return 0;
+}
+EXPORT_SYMBOL(wl1273_fm_set_search_level);
+
+/**
+ * wl1273_fm_get_preemphasis() - Get the current TX pre-emphasis value.
+ * @core:			 A pointer to the device struct.
+ */
+unsigned int wl1273_fm_get_preemphasis(struct wl1273_core *core)
+{
+	return core->preemphasis;
+}
+EXPORT_SYMBOL(wl1273_fm_get_preemphasis);
+
+/**
+ * wl1273_fm_set_preemphasis() - Set the TX pre-emphasis value.
+ * @core:			 A pointer to the device struct.
+ * @preemphasis:		 The new pre-amphasis value.
+ *
+ * Possible pre-emphasis values are: V4L2_PREEMPHASIS_DISABLED,
+ * V4L2_PREEMPHASIS_50_uS and V4L2_PREEMPHASIS_75_uS.
+ */
+int wl1273_fm_set_preemphasis(struct wl1273_core *core,
+			      unsigned int preemphasis)
+{
+	int r;
+	u16 em;
+
+	if (core->mode == WL1273_MODE_OFF ||
+	    core->mode == WL1273_MODE_SUSPENDED)
+		return -EPERM;
+
+	mutex_lock(&core->lock);
+
+	switch (preemphasis) {
+	case V4L2_PREEMPHASIS_DISABLED:
+		em = 1;
+		break;
+	case V4L2_PREEMPHASIS_50_uS:
+		em = 0;
+		break;
+	case V4L2_PREEMPHASIS_75_uS:
+		em = 2;
+		break;
+	default:
+		r = -EINVAL;
+		goto out;
+	}
+
+	r = wl1273_fm_write_cmd(core, WL1273_PREMPH_SET, em);
+	if (r)
+		goto out;
+
+	core->preemphasis = preemphasis;
+
+out:
+	mutex_unlock(&core->lock);
+	return r;
+}
+EXPORT_SYMBOL(wl1273_fm_set_preemphasis);
+
+/**
+ * wl1273_fm_get_audio() -	Get the current audio mode.
+ * @core:			A pointer to the device struct.
+ *
+ */
+unsigned int wl1273_fm_get_audio(struct wl1273_core *core)
+{
+	return core->audio_mode;
+}
+EXPORT_SYMBOL(wl1273_fm_get_audio);
+
+/**
+ * wl1273_fm_set_audio() -	Set audio mode.
+ * @core:			A pointer to the device struct.
+ * @new_mode:			The new audio mode.
+ *
+ * Audio modes are WL1273_AUDIO_DIGITAL and WL1273_AUDIO_ANALOG.
+ */
+int wl1273_fm_set_audio(struct wl1273_core *core, unsigned int new_mode)
+{
+	int r = 0;
+
+	if (core->mode == WL1273_MODE_OFF ||
+	    core->mode == WL1273_MODE_SUSPENDED)
+		return -EPERM;
+
+	if (core->mode == WL1273_MODE_RX && new_mode == WL1273_AUDIO_DIGITAL) {
+		if (!(core->allowed_modes & WL1273_RX_ALLOWED)) {
+			r = -EPERM;
+			goto out;
+		}
+
+		r = wl1273_fm_write_cmd(core, WL1273_PCM_MODE_SET,
+					WL1273_PCM_DEF_MODE);
+		if (r)
+			goto out;
+
+		r = wl1273_fm_write_cmd(core, WL1273_I2S_MODE_CONFIG_SET,
+					core->i2s_mode);
+		if (r)
+			goto out;
+
+		r = wl1273_fm_write_cmd(core, WL1273_AUDIO_ENABLE,
+					WL1273_AUDIO_ENABLE_I2S);
+		if (r)
+			goto out;
+
+	} else if (core->mode == WL1273_MODE_RX &&
+		   new_mode == WL1273_AUDIO_ANALOG) {
+		if (!(core->allowed_modes & WL1273_RX_ALLOWED)) {
+			r = -EPERM;
+			goto out;
+		}
+
+		r = wl1273_fm_write_cmd(core, WL1273_AUDIO_ENABLE,
+					WL1273_AUDIO_ENABLE_ANALOG);
+		if (r)
+			goto out;
+
+	} else if (core->mode == WL1273_MODE_TX &&
+		   new_mode == WL1273_AUDIO_DIGITAL) {
+		if (!(core->allowed_modes & WL1273_TX_ALLOWED)) {
+			r = -EPERM;
+			goto out;
+		}
+
+		r = wl1273_fm_write_cmd(core, WL1273_I2S_MODE_CONFIG_SET,
+					core->i2s_mode);
+		if (r)
+			goto out;
+
+		r = wl1273_fm_write_cmd(core, WL1273_AUDIO_IO_SET,
+					WL1273_AUDIO_IO_SET_I2S);
+		if (r)
+			goto out;
+
+	} else if (core->mode == WL1273_MODE_TX &&
+		   new_mode == WL1273_AUDIO_ANALOG) {
+		if (!(core->allowed_modes & WL1273_TX_ALLOWED)) {
+			r = -EPERM;
+			goto out;
+		}
+
+		r = wl1273_fm_write_cmd(core, WL1273_AUDIO_IO_SET,
+					WL1273_AUDIO_IO_SET_ANALOG);
+		if (r)
+			goto out;
+	}
+
+	core->audio_mode = new_mode;
+
+out:
+	return r;
+}
+EXPORT_SYMBOL(wl1273_fm_set_audio);
+
+/**
+ * wl1273_fm_tx_get_spacing() -	Get the current TX channel spacing.
+ * @core:			A pointer to the device struct.
+ */
+unsigned int wl1273_fm_tx_get_spacing(struct wl1273_core *core)
+{
+	return core->spacing;
+}
+EXPORT_SYMBOL(wl1273_fm_tx_get_spacing);
+
+/**
+ * wl1273_fm_tx_set_spacing() -	Get TX channel spacing.
+ * @core:			A pointer to the device struct.
+ * @spacing:			The new channel spacing value.
+ *
+ * Available spacing values are WL1273_SPACING_50KHZ, WL1273_SPACING_100KHZ
+ * and WL1273_SPACING_200KHZ.
+ */
+int wl1273_fm_tx_set_spacing(struct wl1273_core *core, unsigned int spacing)
+{
+	int r;
+
+	if (core->mode == WL1273_MODE_OFF ||
+	    core->mode == WL1273_MODE_SUSPENDED)
+		return -EPERM;
+
+	mutex_lock(&core->lock);
+
+	switch (spacing) {
+	case WL1273_SPACING_50KHZ:
+		r = wl1273_fm_write_cmd(core, WL1273_CHANL_BW_SET, 1);
+		if (r)
+			goto out;
+		break;
+	case WL1273_SPACING_100KHZ:
+		r = wl1273_fm_write_cmd(core, WL1273_CHANL_BW_SET, 2);
+		if (r)
+			goto out;
+		break;
+	case WL1273_SPACING_200KHZ:
+		r = wl1273_fm_write_cmd(core, WL1273_CHANL_BW_SET, 4);
+		if (r)
+			goto out;
+		break;
+	default:
+		r = -EINVAL;
+		goto out;
+		break;
+	}
+
+	core->spacing = spacing;
+
+out:
+	mutex_unlock(&core->lock);
+	return r;
+}
+EXPORT_SYMBOL(wl1273_fm_tx_set_spacing);
+
+/**
+ * wl1273_fm_upload_firmware_patch() -	Upload the firmware.
+ * @core:				A pointer to the device struct.
+ *
+ * The firmware file consists of arrays of bytes where the first byte
+ * gives the array length. The first byte in the file gives the
+ * number of these arrays.
+ */
+static int wl1273_fm_upload_firmware_patch(struct wl1273_core *core)
+{
+	unsigned int packet_num;
+	const struct firmware *fw_p;
+	const char *fw_name = "radio-wl1273-fw.bin";
+	struct i2c_client *client;
+	__u8 *ptr;
+	int i, n, len, r;
+	struct i2c_msg *msgs;
+
+	client = core->i2c_dev;
+	dev_dbg(&client->dev, "%s:\n", __func__);
+
+	if (request_firmware(&fw_p, fw_name, &client->dev)) {
+		dev_info(&client->dev, "%s - %s not found\n", __func__,
+			 fw_name);
+
+		return 0;
+	}
+
+	ptr = (__u8 *) fw_p->data;
+	packet_num = ptr[0];
+	dev_dbg(&client->dev, "%s: packets: %d\n", __func__, packet_num);
+
+	msgs = kmalloc((packet_num + 1)*sizeof(struct i2c_msg), GFP_KERNEL);
+	if (!msgs) {
+		r = -ENOMEM;
+		goto out;
+	}
+
+	i = 1;
+	for (n = 0; n <= packet_num; n++) {
+		len = ptr[i];
+
+		dev_dbg(&client->dev, "%s: len[%d]: %d\n",
+			__func__, n, len);
+
+		if (i + len + 1 <= fw_p->size) {
+			msgs[n].addr = client->addr;
+			msgs[n].flags = 0;
+			msgs[n].len = len;
+			msgs[n].buf = ptr + i + 1;
+		} else {
+			break;
+		}
+
+		i += len + 1;
+	}
+
+	r = i2c_transfer(client->adapter, msgs, packet_num);
+	kfree(msgs);
+
+	if (r != packet_num) {
+		dev_err(&client->dev, "FW upload error: %d\n", r);
+		dev_dbg(&client->dev, "%d != %d\n", packet_num, r);
+
+		r =  -EREMOTEIO;
+		goto out;
+	} else {
+		r = 0;
+	}
+
+	/* ignore possible error here */
+	wl1273_fm_write_cmd(core, WL1273_RESET, 0);
+	dev_dbg(&client->dev, "n: %d, i: %d\n", n, i);
+
+	if (n - 1  != packet_num)
+		dev_warn(&client->dev, "%s - incorrect firmware size.\n",
+			 __func__);
+
+	if (i != fw_p->size)
+		dev_warn(&client->dev, "%s - inconsistent firmware.\n",
+			 __func__);
+
+	dev_dbg(&client->dev, "%s - download OK, r: %d\n", __func__, r);
+
+out:
+	release_firmware(fw_p);
+	return r;
+}
+
+int wl1273_fm_rds_off(struct wl1273_core *core)
+{
+	struct device *dev = &core->i2c_dev->dev;
+	int r;
+
+	if (core->mode == WL1273_MODE_TX)
+		return 0;
+
+	wait_for_completion_timeout(&core->busy, msecs_to_jiffies(1000));
+
+	core->irq_flags &= ~WL1273_RDS_EVENT;
+
+	r = wl1273_fm_write_cmd(core, WL1273_INT_MASK_SET,
+				core->irq_flags);
+	if (r)
+		goto end;
+
+	/* stop rds reception */
+	cancel_delayed_work(&core->work);
+
+	/* Service pending read */
+	wake_up_interruptible(&core->read_queue);
+
+	dev_dbg(dev, "%s\n", __func__);
+
+	r = wl1273_fm_write_cmd(core, WL1273_POWER_SET, WL1273_POWER_SET_FM);
+
+end:
+	dev_dbg(dev, "%s: exiting...\n", __func__);
+
+	return r;
+}
+EXPORT_SYMBOL(wl1273_fm_rds_off);
+
+static int wl1273_fm_rds(struct wl1273_core *core)
+{
+	struct i2c_client *client = core->i2c_dev;
+	struct device *dev = &client->dev;
+	struct rds_status {
+		unsigned int block_id:3;
+		unsigned int error_status:2;
+		unsigned int fifo_status:1;
+		unsigned int frame_in_sync:1;
+		unsigned int spare:1;
+	} rsta;
+	u16 val;
+	u8 b0[] = { WL1273_RDS_DATA_GET };
+	u8 b1[] = { 0, 0, 0 };
+	struct i2c_msg msg[] = {
+		{
+			.addr = client->addr,
+			.flags = 0,
+			.buf = b0,
+			.len = 1
+		},
+		{
+			.addr = client->addr,
+			.flags = I2C_M_RD,
+			.buf = b1,
+			.len = 3
+		}
+	};
+	int r;
+
+	r = wl1273_fm_read_reg(core, WL1273_RDS_SYNC_GET, &val);
+	if (r)
+		return r;
+
+	if ((val & 0x01) == 0) {
+		/* RDS decoder not synchronized */
+		return -EAGAIN;
+	}
+
+	/* copy all four RDS blocks to internal buffer */
+	do {
+		r = i2c_transfer(client->adapter, msg, 2);
+		if (r != 2) {
+			dev_err(dev, WL1273_FM_DRIVER_NAME
+				": %s: read_rds error r == %i)\n",
+				__func__, r);
+		}
+
+		rsta = *(struct rds_status *) &b1[2];
+		if (rsta.fifo_status == 0)
+			break;
+
+		/* copy RDS block to internal buffer */
+		memcpy(&core->buffer[core->wr_index], &b1, 3);
+		core->wr_index += 3;
+
+		/* wrap write pointer */
+		if (core->wr_index >= core->buf_size)
+			core->wr_index = 0;
+
+		/* check for overflow & start over */
+		if (core->wr_index == core->rd_index) {
+			dev_dbg(dev, "RDS OVERFLOW");
+
+			core->rd_index = 0;
+			core->wr_index = 0;
+			break;
+		}
+	} while (rsta.fifo_status == 1);
+
+	/* wake up read queue */
+	if (core->wr_index != core->rd_index)
+		wake_up_interruptible(&core->read_queue);
+
+	return 0;
+}
+
+static void wl1273_fm_rds_work(struct wl1273_core *core)
+{
+	wl1273_fm_rds(core);
+}
+
+static irqreturn_t wl1273_fm_irq_thread_handler(int irq, void *dev_id)
+{
+	int r;
+	u16 flags;
+	struct wl1273_core *core = dev_id;
+
+	r = wl1273_fm_read_reg(core, WL1273_FLAG_GET, &flags);
+	if (r)
+		goto out;
+
+	if (flags & WL1273_BL_EVENT) {
+		core->irq_received = flags;
+		dev_dbg(&core->i2c_dev->dev, "IRQ: BL\n");
+	}
+
+	if (flags & WL1273_RDS_EVENT) {
+		msleep(200);
+
+		wl1273_fm_rds_work(core);
+	}
+
+	if (flags & WL1273_BBLK_EVENT)
+		dev_dbg(&core->i2c_dev->dev, "IRQ: BBLK\n");
+
+	if (flags & WL1273_LSYNC_EVENT)
+		dev_dbg(&core->i2c_dev->dev, "IRQ: LSYNC\n");
+
+	if (flags & WL1273_LEV_EVENT) {
+		u16 level;
+
+		r = wl1273_fm_read_reg(core, WL1273_RSSI_LVL_GET, &level);
+
+		if (r)
+			goto out;
+
+		if (level > 14)
+			dev_dbg(&core->i2c_dev->dev, "IRQ: LEV: 0x%x04\n",
+				level);
+	}
+
+	if (flags & WL1273_IFFR_EVENT)
+		dev_dbg(&core->i2c_dev->dev, "IRQ: IFFR\n");
+
+	if (flags & WL1273_PI_EVENT)
+		dev_dbg(&core->i2c_dev->dev, "IRQ: PI\n");
+
+	if (flags & WL1273_PD_EVENT)
+		dev_dbg(&core->i2c_dev->dev, "IRQ: PD\n");
+
+	if (flags & WL1273_STIC_EVENT)
+		dev_dbg(&core->i2c_dev->dev, "IRQ: STIC\n");
+
+	if (flags & WL1273_MAL_EVENT)
+		dev_dbg(&core->i2c_dev->dev, "IRQ: MAL\n");
+
+	if (flags & WL1273_POW_ENB_EVENT) {
+		complete(&core->busy);
+		dev_dbg(&core->i2c_dev->dev, "NOT BUSY\n");
+		dev_dbg(&core->i2c_dev->dev, "IRQ: POW_ENB\n");
+	}
+
+	if (flags & WL1273_SCAN_OVER_EVENT)
+		dev_dbg(&core->i2c_dev->dev, "IRQ: SCAN_OVER\n");
+
+	if (flags & WL1273_ERROR_EVENT)
+		dev_dbg(&core->i2c_dev->dev, "IRQ: ERROR\n");
+
+	if (flags & WL1273_FR_EVENT) {
+		u16 freq;
+
+		dev_dbg(&core->i2c_dev->dev, "IRQ: FR:\n");
+
+		if (core->mode == WL1273_MODE_RX) {
+			r = wl1273_fm_write_cmd(core, WL1273_TUNER_MODE_SET,
+						TUNER_MODE_STOP_SEARCH);
+			if (r) {
+				dev_err(&core->i2c_dev->dev,
+					"%s: TUNER_MODE_SET fails: %d\n",
+					__func__, r);
+				goto out;
+			}
+
+			r = wl1273_fm_read_reg(core, WL1273_FREQ_SET, &freq);
+			if (r)
+				goto out;
+
+			core->rx_frequency =
+				regions[core->region].bottom_frequency +
+				freq * 50;
+
+			/*
+			 *  The driver works better with this msleep,
+			 *  the documentation doesn't mention it.
+			 */
+			msleep(10);
+
+			dev_dbg(&core->i2c_dev->dev, "%dkHz\n",
+				core->rx_frequency);
+
+		} else {
+			r = wl1273_fm_read_reg(core, WL1273_CHANL_SET, &freq);
+			if (r)
+				goto out;
+
+			dev_dbg(&core->i2c_dev->dev, "%dkHz\n", freq);
+		}
+		dev_dbg(&core->i2c_dev->dev, "%s: NOT BUSY\n", __func__);
+	}
+
+out:
+	wl1273_fm_write_cmd(core, WL1273_INT_MASK_SET,
+			    core->irq_flags);
+	complete(&core->busy);
+
+	return IRQ_HANDLED;
+}
+
+int wl1273_fm_set_rx_freq(struct wl1273_core *core, unsigned int freq)
+{
+	int r;
+
+	if (freq < regions[core->region].bottom_frequency) {
+		dev_err(&core->i2c_dev->dev,
+			"Frequency out of range: %d < %d\n",
+			freq, regions[core->region].bottom_frequency);
+		r = -EDOM;
+		goto err;
+	}
+
+	if (freq > regions[core->region].top_frequency) {
+		dev_err(&core->i2c_dev->dev,
+			"Frequency out of range: %d > %d\n",
+			freq, regions[core->region].top_frequency);
+		r = -EDOM;
+		goto err;
+	}
+
+	dev_dbg(&core->i2c_dev->dev, "%s: %dkHz\n", __func__, freq);
+
+	wl1273_fm_write_cmd(core, WL1273_INT_MASK_SET,
+			    core->irq_flags);
+
+	r = wl1273_fm_write_cmd(core, WL1273_FREQ_SET,
+			       (freq - regions[core->region].bottom_frequency)
+				/ 50);
+	if (r)
+		goto err;
+
+	INIT_COMPLETION(core->busy);
+	r = wl1273_fm_write_cmd(core, WL1273_TUNER_MODE_SET,
+				TUNER_MODE_PRESET);
+	if (r) {
+		complete(&core->busy);
+		goto err;
+	}
+
+	r = wait_for_completion_timeout(&core->busy, msecs_to_jiffies(2000));
+	if (!r)
+		return -ETIMEDOUT;
+
+	core->rd_index = 0;
+	core->wr_index = 0;
+	core->rx_frequency = freq;
+	return 0;
+
+err:
+	return r;
+}
+EXPORT_SYMBOL(wl1273_fm_set_rx_freq);
+
+int wl1273_fm_set_tx_freq(struct wl1273_core *core, unsigned int freq)
+{
+	int r = 0;
+
+	if (freq < regions[core->region].bottom_frequency) {
+		dev_err(&core->i2c_dev->dev,
+			"Frequency out of range: %d < %d\n",
+			freq, regions[core->region].bottom_frequency);
+		return -EDOM;
+	}
+
+	if (freq > regions[core->region].top_frequency) {
+		dev_err(&core->i2c_dev->dev,
+			"Frequency out of range: %d > %d\n",
+			freq, regions[core->region].top_frequency);
+		return -EDOM;
+	}
+
+	/*
+	 *  The driver works better with this msleep,
+	 *  the documentation doesn't mention it.
+	 */
+	msleep(5);
+	dev_dbg(&core->i2c_dev->dev, "%s: freq: %d kHz\n", __func__, freq);
+
+	INIT_COMPLETION(core->busy);
+	/* Set the current tx channel */
+	r = wl1273_fm_write_cmd(core, WL1273_CHANL_SET, freq / 10);
+	if (r)
+		return r;
+
+	/* wait for the FR IRQ */
+	r = wait_for_completion_timeout(&core->busy, msecs_to_jiffies(1000));
+	if (!r)
+		return -ETIMEDOUT;
+
+	dev_dbg(&core->i2c_dev->dev, "WL1273_CHANL_SET: %d\n", r);
+
+	/* Enable the output power */
+	INIT_COMPLETION(core->busy);
+	r = wl1273_fm_write_cmd(core, WL1273_POWER_ENB_SET, 1);
+	if (r)
+		return r;
+
+	/* wait for the POWER_ENB IRQ */
+	r = wait_for_completion_timeout(&core->busy, msecs_to_jiffies(1000));
+	if (!r)
+		return -ETIMEDOUT;
+
+	core->tx_frequency = freq;
+	dev_dbg(&core->i2c_dev->dev, "WL1273_POWER_ENB_SET: %d\n", r);
+
+	return	0;
+}
+EXPORT_SYMBOL(wl1273_fm_set_tx_freq);
+
+int wl1273_fm_get_freq(struct wl1273_core *core)
+{
+	unsigned int freq;
+	u16 f;
+	int r;
+
+	if (core->mode == WL1273_MODE_RX) {
+		r = wl1273_fm_read_reg(core, WL1273_FREQ_SET, &f);
+		if (r)
+			return r;
+
+		dev_dbg(&core->i2c_dev->dev, "Freq get: 0x%04x\n", f);
+		freq = regions[core->region].bottom_frequency + 50 * f;
+	} else {
+		r = wl1273_fm_read_reg(core, WL1273_CHANL_SET, &f);
+		if (r)
+			return r;
+
+		freq = f * 10;
+	}
+
+	return freq;
+}
+EXPORT_SYMBOL(wl1273_fm_get_freq);
+
+/**
+ * wl1273_fm_get_region() -	Return the ID of the current region.
+ * @core:			A pointer to the device structure.
+ */
+u8 wl1273_fm_get_region(struct wl1273_core *core)
+{
+	return core->region;
+}
+EXPORT_SYMBOL(wl1273_fm_get_region);
+
+/**
+ * wl1273_fm_set_region() -	Change the current region.
+ * @core:			A pointer to the device structure.
+ * @region:			The ID of the new region.
+ *
+ * Wl1273 supports only two regions USA/Europe and Japan.
+ */
+int wl1273_fm_set_region(struct wl1273_core *core, unsigned int region)
+{
+	int r = 0;
+	unsigned int new_frequency = 0;
+
+	if (region == core->region)
+		return 0;
+
+	if (core->mode == WL1273_MODE_OFF ||
+	    core->mode == WL1273_MODE_SUSPENDED)
+		return -EPERM;
+
+	if (region >= ARRAY_SIZE(regions))
+		return -EINVAL;
+
+	mutex_lock(&core->lock);
+
+	core->region = region;
+
+	if (core->rx_frequency < regions[core->region].bottom_frequency)
+		new_frequency = regions[core->region].bottom_frequency;
+	else if (core->rx_frequency > regions[core->region].top_frequency)
+		new_frequency = regions[core->region].top_frequency;
+
+	if (new_frequency) {
+		core->rx_frequency = new_frequency;
+		if (core->mode == WL1273_MODE_RX) {
+			r = wl1273_fm_set_rx_freq(core, new_frequency);
+			if (r)
+				goto out;
+		}
+	}
+
+	new_frequency = 0;
+	if (core->tx_frequency < regions[core->region].bottom_frequency)
+		new_frequency = regions[core->region].bottom_frequency;
+	else if (core->tx_frequency > regions[core->region].top_frequency)
+		new_frequency = regions[core->region].top_frequency;
+
+	if (new_frequency) {
+		core->tx_frequency = new_frequency;
+
+		if (core->mode == WL1273_MODE_TX) {
+			r = wl1273_fm_set_tx_freq(core, new_frequency);
+			if (r)
+				goto out;
+		}
+	}
+
+out:
+	mutex_unlock(&core->lock);
+	return r;
+}
+EXPORT_SYMBOL(wl1273_fm_set_region);
+
+int wl1273_fm_set_seek(struct wl1273_core *core,
+		       unsigned int wrap_around,
+		       unsigned int seek_upward)
+{
+	int r;
+	unsigned int dir = (seek_upward == 0) ? 0 : 1;
+	unsigned int rx_frequency;
+
+	rx_frequency = core->rx_frequency;
+	dev_dbg(&core->i2c_dev->dev, "core->rx_frequency: %d\n",
+		rx_frequency);
+
+	if (dir)
+		r = wl1273_fm_set_rx_freq(core, rx_frequency + 100);
+	else
+		r = wl1273_fm_set_rx_freq(core, rx_frequency - 100);
+
+	if (r)
+		goto out;
+
+	INIT_COMPLETION(core->busy);
+	dev_dbg(&core->i2c_dev->dev, "%s: BUSY\n", __func__);
+
+	r = wl1273_fm_write_cmd(core, WL1273_INT_MASK_SET,
+				core->irq_flags);
+	if (r)
+		goto out;
+
+	dev_dbg(&core->i2c_dev->dev, "%s\n", __func__);
+
+	r = wl1273_fm_write_cmd(core, WL1273_SEARCH_LVL_SET,
+				core->search_level);
+	if (r)
+		goto out;
+
+	r = wl1273_fm_write_cmd(core, WL1273_SEARCH_DIR_SET, dir);
+	if (r)
+		goto out;
+
+	r = wl1273_fm_write_cmd(core, WL1273_TUNER_MODE_SET,
+				TUNER_MODE_AUTO_SEEK);
+	if (r)
+		goto out;
+
+	wait_for_completion_timeout(&core->busy, msecs_to_jiffies(1000));
+	if (!(core->irq_received & WL1273_BL_EVENT))
+		goto out;
+
+	core->irq_received &= ~WL1273_BL_EVENT;
+
+	if (!wrap_around)
+		goto out;
+
+	/* Wrap around */
+	dev_dbg(&core->i2c_dev->dev, "Wrap around in HW seek.\n");
+
+	if (seek_upward)
+		rx_frequency = regions[core->region].bottom_frequency;
+	else
+		rx_frequency = regions[core->region].top_frequency;
+
+	r = wl1273_fm_set_rx_freq(core, rx_frequency);
+	if (r)
+		goto out;
+
+	INIT_COMPLETION(core->busy);
+	dev_dbg(&core->i2c_dev->dev, "%s: BUSY\n", __func__);
+
+	r = wl1273_fm_write_cmd(core, WL1273_TUNER_MODE_SET,
+				TUNER_MODE_AUTO_SEEK);
+	if (r)
+		goto out;
+
+	wait_for_completion_timeout(&core->busy, msecs_to_jiffies(1000));
+out:
+	dev_dbg(&core->i2c_dev->dev, "%s: Err: %d\n", __func__, r);
+	return r;
+}
+EXPORT_SYMBOL(wl1273_fm_set_seek);
+
+int wl1273_fm_rds_on(struct wl1273_core *core)
+{
+	int r;
+
+	dev_dbg(&core->i2c_dev->dev, "%s\n", __func__);
+
+	if (core->mode == WL1273_MODE_TX)
+		return 0;
+
+	core->irq_flags |= WL1273_RDS_EVENT;
+
+	r = wl1273_fm_write_cmd(core, WL1273_INT_MASK_SET, core->irq_flags);
+	if (r)
+		goto err;
+
+	r = wl1273_fm_write_cmd(core, WL1273_POWER_SET,
+				WL1273_POWER_SET_FM | WL1273_POWER_SET_RDS);
+	if (r)
+		goto err;
+
+	r = wl1273_fm_set_rx_freq(core, core->rx_frequency);
+	if (r) {
+		dev_err(&core->i2c_dev->dev,
+			"set freq fails: %d.\n", r);
+		goto err;
+	}
+	return 0;
+
+err:
+	dev_err(&core->i2c_dev->dev, "%s: Err: %d\n", __func__, r);
+	return r;
+}
+EXPORT_SYMBOL(wl1273_fm_rds_on);
+
+static int wl1273_fm_stop(struct wl1273_core *core)
+{
+	struct i2c_client *client = core->i2c_dev;
+	struct wl1273_fm_platform_data *pdata =
+		client->dev.platform_data;
+	int r = 0;
+
+	if (core->mode == WL1273_MODE_RX)
+		r = wl1273_fm_write_cmd(core, WL1273_POWER_SET,
+					WL1273_POWER_SET_OFF);
+	else if (core->mode == WL1273_MODE_TX)
+		r = wl1273_fm_write_cmd(core, WL1273_PUPD_SET,
+					WL1273_PUPD_SET_OFF);
+	else
+		r = -EPERM;
+
+	if (r) {
+		dev_err(&core->i2c_dev->dev,
+			"%s: POWER_SET fails: %d\n", __func__, r);
+		goto out;
+	}
+
+	if (pdata->disable)
+		pdata->disable();
+
+	dev_dbg(&core->i2c_dev->dev, "Back to reset\n");
+
+out:
+	return r;
+}
+
+static int wl1273_fm_suspend(struct wl1273_core *core)
+{
+	int r = 0;
+	struct i2c_client *client = core->i2c_dev;
+	struct wl1273_fm_platform_data *pdata =
+		client->dev.platform_data;
+
+	/* Cannot go from OFF to SUSPENDED */
+	if (core->mode == WL1273_MODE_RX)
+		r = wl1273_fm_write_cmd(core, WL1273_POWER_SET,
+					WL1273_POWER_SET_RETENTION);
+	else if (core->mode == WL1273_MODE_TX)
+		r = wl1273_fm_write_cmd(core, WL1273_PUPD_SET,
+					WL1273_PUPD_SET_RETENTION);
+	else
+		r = -EINVAL;
+
+	if (r) {
+		dev_err(&core->i2c_dev->dev,
+			"%s: POWER_SET fails: %d\n", __func__, r);
+		goto out;
+	}
+
+out:
+	if (pdata->disable)
+		pdata->disable();
+
+	dev_dbg(&core->i2c_dev->dev, "Back to reset\n");
+
+	return r;
+}
+
+static int wl1273_fm_start(struct wl1273_core *core, int new_mode)
+{
+	struct i2c_client *client = core->i2c_dev;
+	struct wl1273_fm_platform_data *pdata =
+		client->dev.platform_data;
+	int r = -1;
+	u16 val;
+
+	if (pdata->enable) {
+		pdata->enable();
+		msleep(250);
+	}
+
+	if (new_mode == WL1273_MODE_RX) {
+		/* ignore if this fails */
+		r = wl1273_fm_write_cmd(core, WL1273_POWER_SET,
+					WL1273_POWER_SET_FM);
+		if (r)
+			msleep(100);
+
+		r = wl1273_fm_write_cmd(core, WL1273_POWER_SET,
+					WL1273_POWER_SET_FM);
+		if (r) {
+			dev_err(&client->dev, "%s: POWER_SET fails.\n",
+				__func__);
+			goto fail;
+		}
+
+		/* rds buffer configuration */
+		core->wr_index = 0;
+		core->rd_index = 0;
+
+	} else if (new_mode == WL1273_MODE_TX) {
+		/* ignore if this fails */
+		r = wl1273_fm_write_cmd(core, WL1273_PUPD_SET,
+					WL1273_PUPD_SET_ON);
+		if (r)
+			msleep(100);
+
+		r = wl1273_fm_write_cmd(core, WL1273_PUPD_SET,
+					WL1273_PUPD_SET_ON);
+		if (r) {
+			dev_err(&client->dev, "%s: PUPD_SET fails.\n",
+				__func__);
+			goto fail;
+		}
+
+	} else {
+		dev_warn(&client->dev, "%s: Illegal mode.\n", __func__);
+	}
+
+	if (core->mode == WL1273_MODE_OFF) {
+		dev_dbg(&core->i2c_dev->dev, "Out of reset\n");
+
+		r = wl1273_fm_upload_firmware_patch(core);
+		if (r)
+			dev_warn(&client->dev, "Firmware upload failed.\n");
+	}
+
+	r = wl1273_fm_read_reg(core, WL1273_ASIC_ID_GET, &val);
+	if (r)
+		dev_err(&client->dev, "%s: WL1273_ASIC_ID_GET fails.\n",
+			__func__);
+	else
+		dev_dbg(&client->dev, "%s: ASIC ID: 0x%04x\n", __func__, val);
+
+	r = wl1273_fm_read_reg(core, WL1273_ASIC_VER_GET, &val);
+	if (r)
+		dev_err(&client->dev, "%s: WL1273_ASIC_VER_GET fails.\n",
+			__func__);
+	else
+		dev_dbg(&client->dev, "%s: ASIC Version: 0x%04x\n", __func__,
+			val);
+
+	r = wl1273_fm_read_reg(core, WL1273_FIRM_VER_GET, &val);
+	if (r)
+		dev_err(&client->dev, "%s: WL1273_FIRM_VER_GET fails.\n",
+			__func__);
+	else
+		dev_dbg(&client->dev, "%s: FW version: %d(0x%04x)\n", __func__,
+			val, val);
+
+	r = wl1273_fm_read_reg(core, WL1273_INT_MASK_SET, &val);
+	if (r)
+		goto fail;
+
+	dev_dbg(&client->dev, "%s: Irq mask: 0x%04x\n", __func__, val);
+
+	return 0;
+fail:
+	if (pdata->disable)
+		pdata->disable();
+
+	dev_dbg(&client->dev, "%s: return: %d\n", __func__, r);
+	return r;
+}
+
+/**
+ * wl1273_fm_get_tx_rds() -	Get the currect TX RDS mode.
+ * @core:			A pointer to the device structure.
+ *
+ * Possible return values are: WL1273_RDS_TX_OFF and WL1273_RDS_TX_ON.
+ */
+int wl1273_fm_get_tx_rds(struct wl1273_core *core)
+{
+	return core->rds_tx_mode;
+}
+EXPORT_SYMBOL(wl1273_fm_get_tx_rds);
+
+/**
+ * wl1273_fm_set_tx_rds() -	Get the currect TX RDS mode.
+ * @core:			A pointer to the device structure.
+ * @new_mode:			Set the mode to new_mode.
+ *
+ * Possible values for new_mode are WL1273_RDS_TX_OFF, WL1273_RDS_TX_ON
+ * and WL1273_RDS_TX_RESET. WL1273_RDS_TX_RESET causes the RDS subsystem to
+ * reset but doesn't actually change the mode.
+ */
+int wl1273_fm_set_tx_rds(struct wl1273_core *core, unsigned int new_mode)
+{
+	int r = 0;
+	struct i2c_client *client = core->i2c_dev;
+
+	if (core->mode == WL1273_MODE_OFF ||
+	    core->mode == WL1273_MODE_SUSPENDED)
+		return -EPERM;
+
+	mutex_lock(&core->lock);
+
+	switch (new_mode) {
+	case WL1273_RDS_TX_OFF:
+		r = wl1273_fm_write_cmd(core, WL1273_RDS_DATA_ENB, 0);
+		core->rds_tx_mode = WL1273_RDS_TX_OFF;
+		break;
+
+	case WL1273_RDS_TX_ON:
+		r = wl1273_fm_write_cmd(core, WL1273_RDS_DATA_ENB, 1);
+		core->rds_tx_mode = WL1273_RDS_TX_ON;
+		break;
+
+	case WL1273_RDS_TX_RESET:
+		r = wl1273_fm_write_cmd(core, WL1273_RDS_CNTRL_SET, 1);
+		break;
+
+	default:
+		dev_err(&client->dev, "%s: Unknown mode: %d\n", __func__,
+			new_mode);
+		break;
+	}
+
+	mutex_unlock(&core->lock);
+	return r;
+}
+EXPORT_SYMBOL(wl1273_fm_set_tx_rds);
+
+/**
+ * wl1273_fm_set_mode()	- Set the mode of the device.
+ * @core:		  A pointer to the device struct.
+ * @mode:		  The new mode.
+ *
+ * The modes that can be used are WL1273_MODE_RX, WL1273_MODE_TX and
+ * WL1273_MODE_OFF.
+ */
+int wl1273_fm_set_mode(struct wl1273_core *core, int mode)
+{
+	int r;
+	int old_mode;
+
+	dev_dbg(&core->i2c_dev->dev, "%s\n", __func__);
+
+	if (core->mode == mode)
+		return 0;
+
+	mutex_lock(&core->lock);
+	old_mode = core->mode;
+
+	switch (mode) {
+	case WL1273_MODE_RX:
+	case WL1273_MODE_TX:
+		r = wl1273_fm_start(core, mode);
+		if (r) {
+			dev_err(&core->i2c_dev->dev, "%s: Cannot start.\n",
+				__func__);
+			wl1273_fm_stop(core);
+			core->mode = old_mode ;
+			goto out;
+		} else {
+			core->mode = mode;
+			r = wl1273_fm_set_audio(core, core->audio_mode);
+			if (r)
+				dev_err(&core->i2c_dev->dev,
+					"Cannot set audio mode.\n");
+		}
+
+		r = wl1273_fm_write_cmd(core, WL1273_INT_MASK_SET,
+					core->irq_flags);
+		if (r) {
+			dev_err(&core->i2c_dev->dev,
+				"INT_MASK_SET fails.\n");
+			goto out;
+		}
+
+		/* remember previous frequencies */
+		if (mode == WL1273_MODE_RX) {
+			r = wl1273_fm_set_rx_freq(core, core->rx_frequency);
+			if (r) {
+				dev_err(&core->i2c_dev->dev,
+					"set freq fails: %d.\n", r);
+				goto out;
+			}
+		} else {
+			r = wl1273_fm_set_tx_freq(core, core->tx_frequency);
+			if (r) {
+				dev_err(&core->i2c_dev->dev,
+					"set freq fails: %d.\n", r);
+				goto out;
+			}
+		}
+
+		break;
+
+	case WL1273_MODE_OFF:
+		r = wl1273_fm_stop(core);
+		if (r) {
+			dev_err(&core->i2c_dev->dev,
+				"%s: Off fails: %d\n", __func__, r);
+			core->mode = old_mode;
+		} else {
+			core->mode = WL1273_MODE_OFF;
+		}
+		break;
+
+	case WL1273_MODE_SUSPENDED:
+		r = wl1273_fm_suspend(core);
+		if (r) {
+			dev_err(&core->i2c_dev->dev,
+				"%s: Suspend fails: %d\n", __func__, r);
+			core->mode = old_mode;
+
+		} else {
+			core->mode = WL1273_MODE_SUSPENDED;
+		}
+		break;
+
+	default:
+		dev_err(&core->i2c_dev->dev, "%s: Unknown mode: %d\n",
+			__func__, mode);
+		r = -EINVAL;
+		break;
+	}
+
+out:
+	mutex_unlock(&core->lock);
+
+	return r;
+}
+EXPORT_SYMBOL(wl1273_fm_set_mode);
+
+/**
+ * wl1273_fm_get_mode() -	Returns the current device mode.
+ * @core:			A pointer to the device struct.
+ */
+unsigned int wl1273_fm_get_mode(struct wl1273_core *core)
+{
+	return core->mode;
+}
+EXPORT_SYMBOL(wl1273_fm_get_mode);
+
+int wl1273_fm_set_i2s_mode(struct wl1273_core *core, int rate, int width)
+{
+	struct device *dev = &core->i2c_dev->dev;
+	int r = 0;
+	u16 mode;
+
+	dev_dbg(dev, "rate: %d\n", rate);
+	dev_dbg(dev, "width: %d\n", width);
+
+	mutex_lock(&core->lock);
+
+	mode = core->i2s_mode & ~WL1273_IS2_WIDTH & ~WL1273_IS2_RATE;
+
+	switch (rate) {
+	case 48000:
+		mode |= WL1273_IS2_RATE_48K;
+		break;
+	case 44100:
+		mode |= WL1273_IS2_RATE_44_1K;
+		break;
+	case 32000:
+		mode |= WL1273_IS2_RATE_32K;
+		break;
+	case 22050:
+		mode |= WL1273_IS2_RATE_22_05K;
+		break;
+	case 16000:
+		mode |= WL1273_IS2_RATE_16K;
+		break;
+	case 12000:
+		mode |= WL1273_IS2_RATE_12K;
+		break;
+	case 11025:
+		mode |= WL1273_IS2_RATE_11_025;
+		break;
+	case 8000:
+		mode |= WL1273_IS2_RATE_8K;
+		break;
+	default:
+		dev_err(dev, "Sampling rate: %d not supported\n", rate);
+		r = -EINVAL;
+		goto out;
+	}
+
+	switch (width) {
+	case 16:
+		mode |= WL1273_IS2_WIDTH_32;
+		break;
+	case 20:
+		mode |= WL1273_IS2_WIDTH_40;
+		break;
+	case 24:
+		mode |= WL1273_IS2_WIDTH_48;
+		break;
+	case 25:
+		mode |= WL1273_IS2_WIDTH_50;
+		break;
+	case 30:
+		mode |= WL1273_IS2_WIDTH_60;
+		break;
+	case 32:
+		mode |= WL1273_IS2_WIDTH_64;
+		break;
+	case 40:
+		mode |= WL1273_IS2_WIDTH_80;
+		break;
+	case 48:
+		mode |= WL1273_IS2_WIDTH_96;
+		break;
+	case 64:
+		mode |= WL1273_IS2_WIDTH_128;
+		break;
+	default:
+		dev_err(dev, "Data width: %d not supported\n", width);
+		r = -EINVAL;
+		goto out;
+	}
+
+	dev_dbg(dev, "WL1273_I2S_DEF_MODE: 0x%04x\n",  WL1273_I2S_DEF_MODE);
+	dev_dbg(dev, "core->i2s_mode: 0x%04x\n", core->i2s_mode);
+	dev_dbg(dev, "mode: 0x%04x\n", mode);
+
+	if (core->i2s_mode != mode) {
+		r = wl1273_fm_write_cmd(core, WL1273_I2S_MODE_CONFIG_SET,
+					mode);
+		if (!r)
+			core->i2s_mode = mode;
+
+		r = wl1273_fm_write_cmd(core, WL1273_AUDIO_ENABLE,
+					WL1273_AUDIO_ENABLE_I2S);
+		if (r)
+			goto out;
+	}
+out:
+	mutex_unlock(&core->lock);
+
+	return r;
+}
+EXPORT_SYMBOL(wl1273_fm_set_i2s_mode);
+
+int wl1273_fm_set_channel_number(struct wl1273_core *core, int channel_number)
+{
+	struct i2c_client *client = core->i2c_dev;
+	struct device *dev = &client->dev;
+	int r = 0;
+
+	dev_dbg(dev, "%s\n", __func__);
+
+	mutex_lock(&core->lock);
+
+	if (core->channel_number == channel_number)
+		goto out;
+
+	if (channel_number == 1 && core->mode == WL1273_MODE_RX)
+		r = wl1273_fm_write_cmd(core, WL1273_MOST_MODE_SET,
+					WL1273_RX_MONO);
+	else if (channel_number == 1 && core->mode == WL1273_MODE_TX)
+		r = wl1273_fm_write_cmd(core, WL1273_MONO_SET,
+					WL1273_TX_MONO);
+	else if (channel_number == 2 && core->mode == WL1273_MODE_RX)
+		r = wl1273_fm_write_cmd(core, WL1273_MOST_MODE_SET,
+					WL1273_RX_STEREO);
+	else if (channel_number == 2 && core->mode == WL1273_MODE_TX)
+		r = wl1273_fm_write_cmd(core, WL1273_MONO_SET,
+					WL1273_TX_STEREO);
+	else
+		r = -EINVAL;
+out:
+	mutex_unlock(&core->lock);
+
+	return r;
+}
+EXPORT_SYMBOL(wl1273_fm_set_channel_number);
+
+static struct i2c_device_id wl1273_driver_id_table[] = {
+	{ WL1273_FM_DRIVER_NAME, 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, wl1273_driver_id_table);
+
+static int wl1273_core_remove(struct i2c_client *client)
+{
+	struct wl1273_core *core = i2c_get_clientdata(client);
+	struct wl1273_fm_platform_data *pdata =
+		client->dev.platform_data;
+
+	dev_dbg(&client->dev, "%s\n", __func__);
+
+	mfd_remove_devices(&client->dev);
+	i2c_set_clientdata(client, core);
+
+	free_irq(client->irq, core);
+	pdata->free_resources();
+
+	kfree(core->buffer);
+	kfree(core);
+
+	return 0;
+}
+
+static int __devinit wl1273_core_probe(struct i2c_client *client,
+				       const struct i2c_device_id *id)
+{
+	struct wl1273_fm_platform_data *pdata = client->dev.platform_data;
+	int r = 0;
+	struct wl1273_core *core;
+	int children = 0;
+
+	dev_dbg(&client->dev, "%s\n", __func__);
+
+	if (!pdata) {
+		dev_err(&client->dev, "No platform data.\n");
+		return -EINVAL;
+	}
+
+	core = kzalloc(sizeof(*core), GFP_KERNEL);
+	if (!core)
+		return -ENOMEM;
+
+	/* RDS buffer allocation */
+	core->buf_size = rds_buf * 3;
+	core->buffer = kmalloc(core->buf_size, GFP_KERNEL);
+	if (!core->buffer) {
+		dev_err(&client->dev,
+			"Cannot allocate memory for RDS buffer.\n");
+		r = -ENOMEM;
+		goto err_kmalloc;
+	}
+
+	core->irq_flags = WL1273_IRQ_MASK;
+	core->i2c_dev = client;
+	core->rds_tx_mode = WL1273_RDS_TX_OFF;
+	core->mode = WL1273_MODE_OFF;
+	core->tx_power = 4;
+	core->audio_mode = WL1273_AUDIO_ANALOG;
+	core->region = radio_region;
+	core->regions = regions;
+	core->i2s_mode = WL1273_I2S_DEF_MODE;
+	core->channel_number = 2;
+	core->search_level = 7;
+
+	core->rx_frequency = regions[core->region].bottom_frequency;
+	core->tx_frequency = regions[core->region].top_frequency;
+
+	dev_dbg(&client->dev, "radio_region: %d\n", radio_region);
+
+	mutex_init(&core->lock);
+
+	pdata = client->dev.platform_data;
+	if (pdata) {
+		r = pdata->request_resources(client);
+		if (r) {
+			dev_err(&client->dev, WL1273_FM_DRIVER_NAME
+				": Cannot get platform data\n");
+			goto err_new_mixer;
+		}
+
+		r = request_threaded_irq(client->irq, NULL,
+					 wl1273_fm_irq_thread_handler,
+					 IRQF_ONESHOT | IRQF_TRIGGER_FALLING,
+					 "wl1273-fm", core);
+		if (r < 0) {
+			dev_err(&client->dev, WL1273_FM_DRIVER_NAME
+				": Unable to register IRQ handler\n");
+			goto err_request_irq;
+		}
+		core->allowed_modes = pdata->modes;
+	} else {
+		dev_err(&client->dev, WL1273_FM_DRIVER_NAME ": Core WL1273 IRQ"
+			" not configured");
+		r = -EINVAL;
+		goto err_new_mixer;
+	}
+
+	init_completion(&core->busy);
+	init_waitqueue_head(&core->read_queue);
+
+	i2c_set_clientdata(client, core);
+
+	if (pdata->children & WL1273_RADIO_CHILD) {
+		struct mfd_cell *cell = &core->cells[children];
+		dev_dbg(&client->dev, "%s: Have V4L2.\n", __func__);
+		cell->name = "wl1273_fm_radio";
+		cell->platform_data = &core;
+		cell->data_size = sizeof(core);
+		children++;
+	}
+
+	if (pdata->children & WL1273_CODEC_CHILD) {
+		struct mfd_cell *cell = &core->cells[children];
+		dev_dbg(&client->dev, "%s: Have codec.\n", __func__);
+		cell->name = "wl1273_codec_audio";
+		cell->platform_data = &core;
+		cell->data_size = sizeof(core);
+		children++;
+	}
+
+	if (children) {
+		dev_dbg(&client->dev, "%s: Have children.\n", __func__);
+		r = mfd_add_devices(&client->dev, -1, core->cells,
+				    children, NULL, 0);
+	} else {
+		dev_err(&client->dev, "No platform data found for children.\n");
+		r = -ENODEV;
+	}
+
+	if (!r)
+		return 0;
+
+	i2c_set_clientdata(client, NULL);
+	kfree(core);
+	free_irq(client->irq, core);
+err_request_irq:
+	pdata->free_resources();
+err_new_mixer:
+	kfree(core->buffer);
+err_kmalloc:
+	kfree(core);
+	dev_dbg(&client->dev, "%s\n", __func__);
+
+	return r;
+}
+
+static struct i2c_driver wl1273_core_driver = {
+	.driver = {
+		.name = WL1273_FM_DRIVER_NAME,
+	},
+	.probe = wl1273_core_probe,
+	.id_table = wl1273_driver_id_table,
+	.remove = __devexit_p(wl1273_core_remove),
+};
+
+static int __init wl1273_core_init(void)
+{
+	int r;
+
+	r = i2c_add_driver(&wl1273_core_driver);
+	if (r) {
+		pr_err(WL1273_FM_DRIVER_NAME
+		       ": driver registration failed\n");
+		return r;
+	}
+
+	return 0;
+}
+
+static void __exit wl1273_core_exit(void)
+{
+	flush_scheduled_work();
+
+	i2c_del_driver(&wl1273_core_driver);
+}
+late_initcall(wl1273_core_init);
+module_exit(wl1273_core_exit);
+
+MODULE_AUTHOR("Matti Aaltonen <matti.j.aaltonen@nokia.com>");
+MODULE_DESCRIPTION(DRIVER_DESC);
+MODULE_LICENSE("GPL");
diff --git a/include/linux/mfd/wl1273-core.h b/include/linux/mfd/wl1273-core.h
new file mode 100644
index 0000000..c82c01c
--- /dev/null
+++ b/include/linux/mfd/wl1273-core.h
@@ -0,0 +1,265 @@
+/*
+ * include/media/radio/radio-wl1273.h
+ *
+ * Some definitions for the wl1273 radio receiver/transmitter chip.
+ *
+ * Copyright (C) Nokia Corporation
+ * Author: Matti J. Aaltonen <matti.j.aaltonen@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+
+#ifndef RADIO_WL1273_H
+#define RADIO_WL1273_H
+
+#include <linux/i2c.h>
+#include <linux/mfd/core.h>
+
+
+#define WL1273_FM_DRIVER_NAME	"wl1273-fm"
+#define RX71_FM_I2C_ADDR	0x22
+
+#define WL1273_STEREO_GET		0
+#define WL1273_RSSI_LVL_GET		1
+#define WL1273_IF_COUNT_GET		2
+#define WL1273_FLAG_GET			3
+#define WL1273_RDS_SYNC_GET		4
+#define WL1273_RDS_DATA_GET		5
+#define WL1273_FREQ_SET			10
+#define WL1273_AF_FREQ_SET		11
+#define WL1273_MOST_MODE_SET		12
+#define WL1273_MOST_BLEND_SET		13
+#define WL1273_DEMPH_MODE_SET		14
+#define WL1273_SEARCH_LVL_SET		15
+#define WL1273_BAND_SET			16
+#define WL1273_MUTE_STATUS_SET		17
+#define WL1273_RDS_PAUSE_LVL_SET	18
+#define WL1273_RDS_PAUSE_DUR_SET	19
+#define WL1273_RDS_MEM_SET		20
+#define WL1273_RDS_BLK_B_SET		21
+#define WL1273_RDS_MSK_B_SET		22
+#define WL1273_RDS_PI_MASK_SET		23
+#define WL1273_RDS_PI_SET		24
+#define WL1273_RDS_SYSTEM_SET		25
+#define WL1273_INT_MASK_SET		26
+#define WL1273_SEARCH_DIR_SET		27
+#define WL1273_VOLUME_SET		28
+#define WL1273_AUDIO_ENABLE		29
+#define WL1273_PCM_MODE_SET		30
+#define WL1273_I2S_MODE_CONFIG_SET	31
+#define WL1273_POWER_SET		32
+#define WL1273_INTX_CONFIG_SET		33
+#define WL1273_PULL_EN_SET		34
+#define WL1273_HILO_SET			35
+#define WL1273_SWITCH2FREF		36
+#define WL1273_FREQ_DRIFT_REPORT	37
+
+#define WL1273_PCE_GET			40
+#define WL1273_FIRM_VER_GET		41
+#define WL1273_ASIC_VER_GET		42
+#define WL1273_ASIC_ID_GET		43
+#define WL1273_MAN_ID_GET		44
+#define WL1273_TUNER_MODE_SET		45
+#define WL1273_STOP_SEARCH		46
+#define WL1273_RDS_CNTRL_SET		47
+
+#define WL1273_WRITE_HARDWARE_REG	100
+#define WL1273_CODE_DOWNLOAD		101
+#define WL1273_RESET			102
+
+#define WL1273_FM_POWER_MODE		254
+#define WL1273_FM_INTERRUPT		255
+
+/* Transmitter API */
+
+#define WL1273_CHANL_SET		55
+#define WL1273_CHANL_BW_SET		56
+#define WL1273_REF_SET			57
+#define WL1273_POWER_ENB_SET		90
+#define WL1273_POWER_ATT_SET		58
+#define WL1273_POWER_LEV_SET		59
+#define WL1273_AUDIO_DEV_SET		60
+#define WL1273_PILOT_DEV_SET		61
+#define WL1273_RDS_DEV_SET		62
+#define WL1273_PUPD_SET			91
+#define WL1273_AUDIO_IO_SET		63
+#define WL1273_PREMPH_SET		64
+#define WL1273_MONO_SET			66
+#define WL1273_MUTE			92
+#define WL1273_MPX_LMT_ENABLE		67
+#define WL1273_PI_SET			93
+#define WL1273_ECC_SET			69
+#define WL1273_PTY			70
+#define WL1273_AF			71
+#define WL1273_DISPLAY_MODE		74
+#define WL1273_RDS_REP_SET		77
+#define WL1273_RDS_CONFIG_DATA_SET	98
+#define WL1273_RDS_DATA_SET		99
+#define WL1273_RDS_DATA_ENB		94
+#define WL1273_TA_SET			78
+#define WL1273_TP_SET			79
+#define WL1273_DI_SET			80
+#define WL1273_MS_SET			81
+#define WL1273_PS_SCROLL_SPEED		82
+#define WL1273_TX_AUDIO_LEVEL_TEST	96
+#define WL1273_TX_AUDIO_LEVEL_TEST_THRESHOLD	73
+#define WL1273_TX_AUDIO_INPUT_LEVEL_RANGE_SET	54
+#define WL1273_RX_ANTENNA_SELECT	87
+#define WL1273_I2C_DEV_ADDR_SET		86
+#define WL1273_REF_ERR_CALIB_PARAM_SET		88
+#define WL1273_REF_ERR_CALIB_PERIODICITY_SET	89
+#define WL1273_SOC_INT_TRIGGER			52
+#define WL1273_SOC_AUDIO_PATH_SET		83
+#define WL1273_SOC_PCMI_OVERRIDE		84
+#define WL1273_SOC_I2S_OVERRIDE		85
+#define WL1273_RSSI_BLOCK_SCAN_FREQ_SET	95
+#define WL1273_RSSI_BLOCK_SCAN_START	97
+#define WL1273_RSSI_BLOCK_SCAN_DATA_GET	 5
+#define WL1273_READ_FMANT_TUNE_VALUE		104
+
+#define WL1273_RDS_TX_OFF	0
+#define WL1273_RDS_TX_ON	1
+#define WL1273_RDS_TX_RESET	2
+
+#define WL1273_AUDIO_DIGITAL	0
+#define WL1273_AUDIO_ANALOG	1
+
+#define WL1273_SPACING_50KHZ	0
+#define WL1273_SPACING_100KHZ	1
+#define WL1273_SPACING_200KHZ	2
+
+#define WL1273_MODE_RX		0
+#define WL1273_MODE_TX		1
+#define WL1273_MODE_OFF		2
+#define WL1273_MODE_SUSPENDED	3
+
+#define WL1273_RADIO_CHILD	(1 << 0)
+#define WL1273_CODEC_CHILD	(1 << 1)
+
+#define WL1273_RX_MONO		1
+#define WL1273_RX_STEREO	0
+#define WL1273_TX_MONO		0
+#define WL1273_TX_STEREO	1
+
+/* Private IOCTLS */
+#define WL1273_CID_FM_RADIO_MODE	(V4L2_CID_PRIVATE_BASE + 0)
+#define WL1273_CID_FM_AUDIO_MODE	(V4L2_CID_PRIVATE_BASE + 1)
+#define WL1273_CID_FM_REGION		(V4L2_CID_PRIVATE_BASE + 2)
+#define WL1273_CID_FM_CHAN_SPACING	(V4L2_CID_PRIVATE_BASE + 3)
+#define WL1273_CID_FM_RDS_CTRL		(V4L2_CID_PRIVATE_BASE + 4)
+#define WL1273_CID_FM_CTUNE_VAL		(V4L2_CID_PRIVATE_BASE + 5)
+#define WL1273_CID_TUNE_PREEMPHASIS	(V4L2_CID_PRIVATE_BASE + 6)
+#define WL1273_CID_TX_POWER		(V4L2_CID_PRIVATE_BASE + 7)
+#define WL1273_CID_SEARCH_LVL		(V4L2_CID_PRIVATE_BASE + 8)
+
+#define SCHAR_MIN (-128)
+#define SCHAR_MAX 127
+
+struct region_info {
+	u32 bottom_frequency;
+	u32 top_frequency;
+	u8 region;
+};
+
+struct wl1273_fm_platform_data {
+	int (*request_resources) (struct i2c_client *client);
+	void (*free_resources) (void);
+	void (*enable) (void);
+	void (*disable) (void);
+
+	u8 modes;
+	unsigned int children;
+};
+
+#define WL1273_FM_CORE_CELLS	2
+
+/* Allowed modes */
+#define WL1273_RX_ALLOWED	0x01
+#define WL1273_TX_ALLOWED	0x02
+#define WL1273_RXTX_ALLOWED	(WL1273_RX_ALLOWED | WL1273_TX_ALLOWED)
+
+struct wl1273_core {
+	struct mfd_cell cells[WL1273_FM_CORE_CELLS];
+	struct i2c_client *i2c_dev;
+
+	/* driver management */
+	u8 allowed_modes;
+	unsigned int mode;
+	unsigned int preemphasis;
+	unsigned int audio_mode;
+	unsigned int rds_tx_mode;
+	unsigned int tx_power;
+	unsigned int spacing;
+	unsigned int rx_frequency;
+	unsigned int tx_frequency;
+	unsigned int region;
+	unsigned int i2s_mode;
+	unsigned int channel_number;
+	int search_level;
+
+	const struct region_info *regions;
+
+	/* RDS */
+	struct delayed_work work;
+
+	wait_queue_head_t read_queue;
+	struct mutex lock; /* for serializing fm radio operations */
+	struct completion busy;
+
+	unsigned char *buffer;
+	unsigned int buf_size;
+	unsigned int rd_index;
+	unsigned int wr_index;
+
+	/* Selected interrupts */
+	u16 irq_flags;
+	u16 irq_received;
+};
+
+int wl1273_fm_write_cmd(struct wl1273_core *core, u8 cmd, u16 param);
+int wl1273_fm_write_data(struct wl1273_core *core, u8 *data, u16 len);
+int wl1273_fm_read_reg(struct wl1273_core *core, u8 reg, u16 *value);
+
+int wl1273_fm_rds_on(struct wl1273_core *core);
+int wl1273_fm_rds_off(struct wl1273_core *core);
+int wl1273_fm_get_freq(struct wl1273_core *core);
+int wl1273_fm_set_tx_freq(struct wl1273_core *core, unsigned int freq);
+int wl1273_fm_set_rx_freq(struct wl1273_core *core, unsigned int freq);
+int wl1273_fm_set_seek(struct wl1273_core *core,
+		       unsigned int wrap_around,
+		       unsigned int seek_upward);
+
+int wl1273_fm_set_channel_number(struct wl1273_core *core, int ch_num);
+int wl1273_fm_set_i2s_mode(struct wl1273_core *core, int rate, int width);
+
+unsigned int wl1273_fm_get_tx_ctune(struct wl1273_core *core);
+unsigned int wl1273_fm_get_audio(struct wl1273_core *core);
+int wl1273_fm_set_audio(struct wl1273_core *core, unsigned int mode);
+unsigned int wl1273_fm_tx_get_spacing(struct wl1273_core *core);
+int wl1273_fm_tx_set_spacing(struct wl1273_core *core, unsigned int spa);
+unsigned int wl1273_fm_get_preemphasis(struct wl1273_core *core);
+int wl1273_fm_set_preemphasis(struct wl1273_core *core, unsigned int emph);
+unsigned int wl1273_fm_get_tx_power(struct wl1273_core *core);
+int wl1273_fm_set_tx_power(struct wl1273_core *core, u16 p);
+unsigned int wl1273_fm_get_mode(struct wl1273_core *core);
+int wl1273_fm_set_mode(struct wl1273_core *core, int mode);
+u8 wl1273_fm_get_region(struct wl1273_core *core);
+int wl1273_fm_set_region(struct wl1273_core *core, unsigned int region);
+int wl1273_fm_get_tx_rds(struct wl1273_core *core);
+int wl1273_fm_set_tx_rds(struct wl1273_core *core, unsigned int mode);
+int wl1273_fm_get_search_level(struct wl1273_core *core);
+int wl1273_fm_set_search_level(struct wl1273_core *core, s16 level);
+
+#endif	/* ifndef RADIO_WL1273_H */
-- 
1.6.1.3

