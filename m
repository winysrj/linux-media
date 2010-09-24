Return-path: <mchehab@pedra>
Received: from mgw-sa02.nokia.com ([147.243.1.48]:56204 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754879Ab0IXL4K (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Sep 2010 07:56:10 -0400
From: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	eduardo.valentin@nokia.com, mchehab@redhat.com
Cc: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Subject: [PATCH v10 3/4] V4L2: WL1273 FM Radio: Controls for the FM radio.
Date: Fri, 24 Sep 2010 14:55:31 +0300
Message-Id: <1285329332-4380-4-git-send-email-matti.j.aaltonen@nokia.com>
In-Reply-To: <1285329332-4380-3-git-send-email-matti.j.aaltonen@nokia.com>
References: <1285329332-4380-1-git-send-email-matti.j.aaltonen@nokia.com>
 <1285329332-4380-2-git-send-email-matti.j.aaltonen@nokia.com>
 <1285329332-4380-3-git-send-email-matti.j.aaltonen@nokia.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This driver implements V4L2 controls for the Texas Instruments
WL1273 FM Radio.

Signed-off-by: Matti J. Aaltonen <matti.j.aaltonen@nokia.com>
---
 drivers/media/radio/Kconfig        |   15 +
 drivers/media/radio/Makefile       |    1 +
 drivers/media/radio/radio-wl1273.c | 1859 ++++++++++++++++++++++++++++++++++++
 drivers/mfd/Kconfig                |    5 +
 drivers/mfd/Makefile               |    2 +
 5 files changed, 1882 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/radio/radio-wl1273.c

diff --git a/drivers/media/radio/Kconfig b/drivers/media/radio/Kconfig
index 83567b8..209fd37 100644
--- a/drivers/media/radio/Kconfig
+++ b/drivers/media/radio/Kconfig
@@ -452,4 +452,19 @@ config RADIO_TIMBERDALE
 	  found behind the Timberdale FPGA on the Russellville board.
 	  Enabling this driver will automatically select the DSP and tuner.
 
+config RADIO_WL1273
+	tristate "Texas Instruments WL1273 I2C FM Radio"
+        depends on I2C && VIDEO_V4L2 && SND
+	select FW_LOADER
+	---help---
+	  Choose Y here if you have this FM radio chip.
+
+	  In order to control your radio card, you will need to use programs
+	  that are compatible with the Video For Linux 2 API.  Information on
+	  this API and pointers to "v4l2" programs may be found at
+	  <file:Documentation/video4linux/API.html>.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called radio-wl1273.
+
 endif # RADIO_ADAPTERS
diff --git a/drivers/media/radio/Makefile b/drivers/media/radio/Makefile
index f615583..d297074 100644
--- a/drivers/media/radio/Makefile
+++ b/drivers/media/radio/Makefile
@@ -26,5 +26,6 @@ obj-$(CONFIG_RADIO_TEA5764) += radio-tea5764.o
 obj-$(CONFIG_RADIO_SAA7706H) += saa7706h.o
 obj-$(CONFIG_RADIO_TEF6862) += tef6862.o
 obj-$(CONFIG_RADIO_TIMBERDALE) += radio-timb.o
+obj-$(CONFIG_RADIO_WL1273) += radio-wl1273.o
 
 EXTRA_CFLAGS += -Isound
diff --git a/drivers/media/radio/radio-wl1273.c b/drivers/media/radio/radio-wl1273.c
new file mode 100644
index 0000000..382eeac
--- /dev/null
+++ b/drivers/media/radio/radio-wl1273.c
@@ -0,0 +1,1859 @@
+/*
+ * Driver for the Texas Instruments WL1273 FM radio.
+ *
+ * Copyright (C) Nokia Corporation
+ * Author: Matti J. Aaltonen <matti.j.aaltonen@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ */
+
+#include <linux/delay.h>
+#include <linux/firmware.h>
+#include <linux/mfd/wl1273-core.h>
+#include <linux/slab.h>
+#include <media/v4l2-common.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-ioctl.h>
+
+#define DRIVER_DESC "Wl1273 FM Radio"
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
+#define WL1273_FREQ(x)		(x * 10000 / 625)
+#define WL1273_INV_FREQ(x)	(x * 625 / 10000)
+
+/*
+ * static int radio_nr - The number of the radio device
+ *
+ * The default is 0.
+ */
+static int radio_nr = -1;
+module_param(radio_nr, int, 0);
+MODULE_PARM_DESC(radio_nr, "Radio Nr");
+
+struct wl1273_device {
+	struct v4l2_ctrl_handler ctrl_handler;
+	struct v4l2_device v4l2dev;
+	struct video_device videodev;
+	struct device *dev;
+	struct wl1273_core *core;
+	struct file *owner;
+	char *write_buf;
+	unsigned int rds_users;
+};
+
+static int wl1273_fm_set_tx_freq(struct wl1273_core *core, unsigned int freq)
+{
+	int r = 0;
+
+	if (freq < WL1273_BAND_TX_LOW) {
+		dev_err(&core->i2c_dev->dev,
+			"Frequency out of range: %d < %d\n", freq,
+			WL1273_BAND_TX_LOW);
+		return -ERANGE;
+	}
+
+	if (freq > WL1273_BAND_TX_HIGH) {
+		dev_err(&core->i2c_dev->dev,
+			"Frequency out of range: %d > %d\n", freq,
+			WL1273_BAND_TX_HIGH);
+		return -ERANGE;
+	}
+
+	/*
+	 *  The driver works better with this sleep,
+	 *  the documentation doesn't mention it.
+	 */
+	usleep_range(5000, 10000);
+
+	dev_dbg(&core->i2c_dev->dev, "%s: freq: %d kHz\n", __func__, freq);
+
+	INIT_COMPLETION(core->busy);
+	/* Set the current tx channel */
+	r = wl1273_fm_write_cmd(core, WL1273_CHANL_SET, freq / 10);
+	if (r)
+		return r;
+
+	/* wait for the FR IRQ */
+	r = wait_for_completion_timeout(&core->busy, msecs_to_jiffies(2000));
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
+
+static int wl1273_fm_set_rx_freq(struct wl1273_core *core, unsigned int freq)
+{
+	int r, f;
+
+	if (freq < core->rangelow) {
+		dev_err(&core->i2c_dev->dev,
+			"Frequency out of range: %d < %d\n", freq,
+			core->rangelow);
+		r = -ERANGE;
+		goto err;
+	}
+
+	if (freq > core->rangehigh) {
+		dev_err(&core->i2c_dev->dev,
+			"Frequency out of range: %d > %d\n", freq,
+			core->rangehigh);
+		r = -ERANGE;
+		goto err;
+	}
+
+	dev_dbg(&core->i2c_dev->dev, "%s: %dkHz\n", __func__, freq);
+
+	wl1273_fm_write_cmd(core, WL1273_INT_MASK_SET, core->irq_flags);
+
+	if (core->band == WL1273_BAND_JAPAN)
+		f = (freq - WL1273_BAND_JAPAN_LOW) / 50;
+	else
+		f = (freq - WL1273_BAND_OTHER_LOW) / 50;
+
+	r = wl1273_fm_write_cmd(core, WL1273_FREQ_SET, f);
+	if (r) {
+		dev_err(&core->i2c_dev->dev, "FREQ_SET fails\n");
+		goto err;
+	}
+
+	INIT_COMPLETION(core->busy);
+	r = wl1273_fm_write_cmd(core, WL1273_TUNER_MODE_SET, TUNER_MODE_PRESET);
+	if (r) {
+		dev_err(&core->i2c_dev->dev, "TUNER_MODE_SET fails\n");
+		complete(&core->busy);
+		goto err;
+	}
+
+	r = wait_for_completion_timeout(&core->busy, msecs_to_jiffies(2000));
+	if (!r) {
+		dev_err(&core->i2c_dev->dev, "TIMEOUT\n");
+		return -ETIMEDOUT;
+	}
+
+	core->rd_index = 0;
+	core->wr_index = 0;
+	core->rx_frequency = freq;
+	return 0;
+err:
+	return r;
+}
+
+static int wl1273_fm_get_freq(struct wl1273_core *core)
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
+		if (core->band == WL1273_BAND_JAPAN)
+			freq = WL1273_BAND_JAPAN_LOW + 50 * f;
+		else
+			freq = WL1273_BAND_OTHER_LOW + 50 * f;
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
+	struct device *dev = &core->i2c_dev->dev;
+	__u8 *ptr;
+	int i, n, len, r;
+	struct i2c_msg *msgs;
+
+	dev_dbg(dev, "%s:\n", __func__);
+
+	if (request_firmware(&fw_p, fw_name, dev)) {
+		dev_info(dev, "%s - %s not found\n", __func__, fw_name);
+
+		return 0;
+	}
+
+	ptr = (__u8 *) fw_p->data;
+	packet_num = ptr[0];
+	dev_dbg(dev, "%s: packets: %d\n", __func__, packet_num);
+
+	msgs = kmalloc((packet_num + 1) * sizeof(struct i2c_msg), GFP_KERNEL);
+	if (!msgs) {
+		r = -ENOMEM;
+		goto out;
+	}
+
+	i = 1;
+	for (n = 0; n <= packet_num; n++) {
+		len = ptr[i];
+
+		dev_dbg(dev, "%s: len[%d]: %d\n", __func__, n, len);
+
+		if (i + len + 1 <= fw_p->size) {
+			msgs[n].addr = core->i2c_dev->addr;
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
+	r = i2c_transfer(core->i2c_dev->adapter, msgs, packet_num);
+	kfree(msgs);
+
+	if (r != packet_num) {
+		dev_err(dev, "FW upload error: %d\n", r);
+		dev_dbg(dev, "%d != %d\n", packet_num, r);
+
+		r =  -EREMOTEIO;
+		goto out;
+	} else {
+		r = 0;
+	}
+
+	/* ignore possible error here */
+	wl1273_fm_write_cmd(core, WL1273_RESET, 0);
+	dev_dbg(dev, "n: %d, i: %d\n", n, i);
+
+	if (n - 1  != packet_num)
+		dev_warn(dev, "%s - incorrect firmware size.\n",  __func__);
+
+	if (i != fw_p->size)
+		dev_warn(dev, "%s - inconsistent firmware.\n", __func__);
+
+	dev_dbg(dev, "%s - download OK, r: %d\n", __func__, r);
+
+out:
+	release_firmware(fw_p);
+	return r;
+}
+
+static int wl1273_fm_stop(struct wl1273_core *core)
+{
+	struct wl1273_fm_platform_data *pdata =
+		 core->i2c_dev->dev.platform_data;
+
+	if (core->mode == WL1273_MODE_RX) {
+		int r = wl1273_fm_write_cmd(core, WL1273_POWER_SET,
+					    WL1273_POWER_SET_OFF);
+		if (r)
+			dev_err(&core->i2c_dev->dev,
+				"%s: POWER_SET fails: %d\n", __func__, r);
+	} else if (core->mode == WL1273_MODE_TX) {
+		int r = wl1273_fm_write_cmd(core, WL1273_PUPD_SET,
+					    WL1273_PUPD_SET_OFF);
+		if (r)
+			dev_err(&core->i2c_dev->dev,
+				"%s: PUPD_SET fails: %d\n", __func__, r);
+	}
+
+	if (pdata->disable) {
+		pdata->disable();
+		dev_dbg(&core->i2c_dev->dev, "Back to reset\n");
+	}
+
+	return 0;
+}
+
+static int wl1273_fm_start(struct wl1273_core *core, int new_mode)
+{
+	struct wl1273_fm_platform_data *pdata =
+		 core->i2c_dev->dev.platform_data;
+	struct device *dev = &core->i2c_dev->dev;
+	int r = -EINVAL;
+
+	if (pdata->enable && core->mode == WL1273_MODE_OFF) {
+		dev_dbg(dev, "Out of reset\n");
+
+		pdata->enable();
+		msleep(250);
+	}
+
+	if (new_mode == WL1273_MODE_RX) {
+		u16 val = WL1273_POWER_SET_FM;
+
+		if (core->rds_on)
+			val |= WL1273_POWER_SET_RDS;
+
+		/* If this fails try again */
+		r = wl1273_fm_write_cmd(core, WL1273_POWER_SET, val);
+		if (r) {
+			msleep(100);
+
+			r = wl1273_fm_write_cmd(core, WL1273_POWER_SET, val);
+			if (r) {
+				dev_err(dev, "%s: POWER_SET fails\n", __func__);
+				goto fail;
+			}
+		}
+
+		/* rds buffer configuration */
+		core->wr_index = 0;
+		core->rd_index = 0;
+
+	} else if (new_mode == WL1273_MODE_TX) {
+		/* If this fails try again */
+		r = wl1273_fm_write_cmd(core, WL1273_PUPD_SET,
+					WL1273_PUPD_SET_ON);
+		if (r) {
+			msleep(100);
+			r = wl1273_fm_write_cmd(core, WL1273_PUPD_SET,
+						WL1273_PUPD_SET_ON);
+			if (r) {
+				dev_err(dev, "%s: PUPD_SET fails\n", __func__);
+				goto fail;
+			}
+		}
+
+		if (core->rds_on)
+			r = wl1273_fm_write_cmd(core, WL1273_RDS_DATA_ENB, 1);
+		else
+			r = wl1273_fm_write_cmd(core, WL1273_RDS_DATA_ENB, 0);
+	} else {
+		dev_warn(dev, "%s: Illegal mode.\n", __func__);
+	}
+
+	if (core->mode == WL1273_MODE_OFF) {
+		r = wl1273_fm_upload_firmware_patch(core);
+		if (r)
+			dev_warn(dev, "Firmware upload failed.\n");
+
+		/*
+		 * Sometimes the chip is in a wrong power state at this point.
+		 * So we set the power once again.
+		 */
+		if (new_mode == WL1273_MODE_RX) {
+			u16 val = WL1273_POWER_SET_FM;
+
+			if (core->rds_on)
+				val |= WL1273_POWER_SET_RDS;
+
+			r = wl1273_fm_write_cmd(core, WL1273_POWER_SET, val);
+			if (r) {
+				dev_err(dev, "%s: POWER_SET fails\n", __func__);
+				goto fail;
+			}
+		} else if (new_mode == WL1273_MODE_TX) {
+			r = wl1273_fm_write_cmd(core, WL1273_PUPD_SET,
+						WL1273_PUPD_SET_ON);
+			if (r) {
+				dev_err(dev, "%s: PUPD_SET fails\n", __func__);
+				goto fail;
+			}
+		}
+	}
+
+	return 0;
+fail:
+	if (pdata->disable)
+		pdata->disable();
+
+	dev_dbg(dev, "%s: return: %d\n", __func__, r);
+	return r;
+}
+
+static int wl1273_fm_suspend(struct wl1273_core *core)
+{
+	int r = 0;
+	struct device *dev = &core->i2c_dev->dev;
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
+		dev_err(dev, "%s: POWER_SET fails: %d\n", __func__, r);
+		goto out;
+	}
+
+out:
+	return r;
+}
+
+static int wl1273_fm_set_mode(struct wl1273_core *core, int mode)
+{
+	int r;
+	int old_mode;
+	struct device *dev = &core->i2c_dev->dev;
+
+	dev_dbg(dev, "%s\n", __func__);
+	dev_dbg(dev, "Forbidden modes: 0x%02x\n", core->forbidden);
+
+	old_mode = core->mode;
+	if (mode & core->forbidden) {
+		r = -EPERM;
+		goto out;
+	}
+
+	switch (mode) {
+	case WL1273_MODE_RX:
+	case WL1273_MODE_TX:
+		r = wl1273_fm_start(core, mode);
+		if (r) {
+			dev_err(dev, "%s: Cannot start.\n", __func__);
+			wl1273_fm_stop(core);
+			goto out;
+		}
+
+		core->mode = mode;
+		r = wl1273_fm_write_cmd(core, WL1273_INT_MASK_SET,
+					core->irq_flags);
+		if (r) {
+			dev_err(dev, "INT_MASK_SET fails.\n");
+			goto out;
+		}
+
+		/* remember previous settings */
+		if (mode == WL1273_MODE_RX) {
+			r = wl1273_fm_set_rx_freq(core, core->rx_frequency);
+			if (r) {
+				dev_err(dev, "set freq fails: %d.\n", r);
+				goto out;
+			}
+
+			r = wl1273_fm_set_volume(core, core->volume);
+			if (r) {
+				dev_err(dev, "set volume fails: %d.\n", r);
+				goto out;
+			}
+
+			dev_dbg(dev, "%s: Set vol: %d.\n", __func__,
+				core->volume);
+		} else {
+			r = wl1273_fm_set_tx_freq(core, core->tx_frequency);
+			if (r) {
+				dev_err(dev, "set freq fails: %d.\n", r);
+				goto out;
+			}
+		}
+
+		dev_dbg(dev, "%s: Set audio mode.\n", __func__);
+
+		r = wl1273_fm_set_audio(core, core->audio_mode);
+		if (r)
+			dev_err(dev, "Cannot set audio mode.\n");
+		break;
+
+	case WL1273_MODE_OFF:
+		r = wl1273_fm_stop(core);
+		if (r)
+			dev_err(dev, "%s: Off fails: %d\n", __func__, r);
+		else
+			core->mode = WL1273_MODE_OFF;
+
+		break;
+
+	case WL1273_MODE_SUSPENDED:
+		r = wl1273_fm_suspend(core);
+		if (r)
+			dev_err(dev, "%s: Suspend fails: %d\n", __func__, r);
+		else
+			core->mode = WL1273_MODE_SUSPENDED;
+
+		break;
+
+	default:
+		dev_err(dev, "%s: Unknown mode: %d\n", __func__, mode);
+		r = -EINVAL;
+		break;
+	}
+
+out:
+	if (r)
+		core->mode = old_mode;
+
+	return r;
+}
+
+static int wl1273_fm_set_seek(struct wl1273_core *core,
+			      unsigned int wrap_around,
+			      unsigned int seek_upward,
+			      int level)
+{
+	int r = 0;
+	unsigned int dir = (seek_upward == 0) ? 0 : 1;
+	unsigned int f;
+
+	f = core->rx_frequency;
+	dev_dbg(&core->i2c_dev->dev, "rx_frequency: %d\n", f);
+
+	if (dir && f + core->spacing <= core->rangehigh)
+		r = wl1273_fm_set_rx_freq(core, f + core->spacing);
+	else if (dir && wrap_around)
+		r = wl1273_fm_set_rx_freq(core, core->rangelow);
+	else if (f - core->spacing >= core->rangelow)
+		r = wl1273_fm_set_rx_freq(core, f - core->spacing);
+	else if (wrap_around)
+		r = wl1273_fm_set_rx_freq(core, core->rangehigh);
+
+	if (r)
+		goto out;
+
+	if (level < SCHAR_MIN || level > SCHAR_MAX)
+		return -EINVAL;
+
+	INIT_COMPLETION(core->busy);
+	dev_dbg(&core->i2c_dev->dev, "%s: BUSY\n", __func__);
+
+	r = wl1273_fm_write_cmd(core, WL1273_INT_MASK_SET, core->irq_flags);
+	if (r)
+		goto out;
+
+	dev_dbg(&core->i2c_dev->dev, "%s\n", __func__);
+
+	r = wl1273_fm_write_cmd(core, WL1273_SEARCH_LVL_SET, level);
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
+		f = core->rangelow;
+	else
+		f = core->rangehigh;
+
+	r = wl1273_fm_set_rx_freq(core, f);
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
+
+/**
+ * wl1273_fm_get_tx_ctune() -	Get the TX tuning capacitor value.
+ * @core:			A pointer to the device struct.
+ */
+static unsigned int wl1273_fm_get_tx_ctune(struct wl1273_core *core)
+{
+	struct device *dev = &core->i2c_dev->dev;
+	u16 val;
+	int r;
+
+	if (core->mode == WL1273_MODE_OFF ||
+	    core->mode == WL1273_MODE_SUSPENDED)
+		return -EPERM;
+
+	r = wl1273_fm_read_reg(core, WL1273_READ_FMANT_TUNE_VALUE, &val);
+	if (r) {
+		dev_err(dev, "%s: I2C error: %d\n", __func__, r);
+		goto out;
+	}
+
+out:
+	return val;
+}
+
+/**
+ * wl1273_fm_set_preemphasis() - Set the TX pre-emphasis value.
+ * @core:			 A pointer to the device struct.
+ * @preemphasis:		 The new pre-amphasis value.
+ *
+ * Possible pre-emphasis values are: V4L2_PREEMPHASIS_DISABLED,
+ * V4L2_PREEMPHASIS_50_uS and V4L2_PREEMPHASIS_75_uS.
+ */
+static int wl1273_fm_set_preemphasis(struct wl1273_core *core,
+				     unsigned int preemphasis)
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
+
+static int wl1273_fm_rds_on(struct wl1273_core *core)
+{
+	int r;
+
+	dev_dbg(&core->i2c_dev->dev, "%s\n", __func__);
+	if (core->rds_on)
+		return 0;
+
+	r = wl1273_fm_write_cmd(core, WL1273_POWER_SET,
+				WL1273_POWER_SET_FM | WL1273_POWER_SET_RDS);
+	if (r)
+		goto out;
+
+	r = wl1273_fm_set_rx_freq(core, core->rx_frequency);
+	if (r)
+		dev_err(&core->i2c_dev->dev, "set freq fails: %d.\n", r);
+out:
+	return r;
+}
+
+static int wl1273_fm_rds_off(struct wl1273_core *core)
+{
+	struct device *dev = &core->i2c_dev->dev;
+	int r;
+
+	if (!core->rds_on)
+		return 0;
+
+	core->irq_flags &= ~WL1273_RDS_EVENT;
+
+	r = wl1273_fm_write_cmd(core, WL1273_INT_MASK_SET, core->irq_flags);
+	if (r)
+		goto out;
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
+	if (r)
+		goto out;
+
+	r = wl1273_fm_set_rx_freq(core, core->rx_frequency);
+	if (r)
+		dev_err(&core->i2c_dev->dev, "set freq fails: %d.\n", r);
+
+out:
+	dev_dbg(dev, "%s: exiting...\n", __func__);
+
+	return r;
+}
+
+static int wl1273_fm_set_rds(struct wl1273_core *core, unsigned int new_mode)
+{
+	int r = 0;
+	struct device *dev = &core->i2c_dev->dev;
+
+	if (core->mode == WL1273_MODE_OFF ||
+	    core->mode == WL1273_MODE_SUSPENDED)
+		return -EPERM;
+
+	if (new_mode == WL1273_RDS_RESET) {
+		r = wl1273_fm_write_cmd(core, WL1273_RDS_CNTRL_SET, 1);
+		return r;
+	}
+
+	if (core->mode == WL1273_MODE_TX && new_mode == WL1273_RDS_OFF) {
+		r = wl1273_fm_write_cmd(core, WL1273_RDS_DATA_ENB, 0);
+	} else if (core->mode == WL1273_MODE_TX && new_mode == WL1273_RDS_ON) {
+		r = wl1273_fm_write_cmd(core, WL1273_RDS_DATA_ENB, 1);
+	} else if (core->mode == WL1273_MODE_RX && new_mode == WL1273_RDS_OFF) {
+		r = wl1273_fm_rds_off(core);
+	} else if (core->mode == WL1273_MODE_RX && new_mode == WL1273_RDS_ON) {
+		r = wl1273_fm_rds_on(core);
+	} else {
+		dev_err(dev, "%s: Unknown mode: %d\n", __func__, new_mode);
+		r = -EINVAL;
+	}
+
+	if (!r)
+		core->rds_on = (new_mode == WL1273_RDS_ON) ? true : false;
+
+	return r;
+}
+
+static ssize_t wl1273_fm_fops_write(struct file *file, const char __user *buf,
+				    size_t count, loff_t *ppos)
+{
+	struct wl1273_device *radio = video_get_drvdata(video_devdata(file));
+	u16 val;
+	int r;
+
+	dev_dbg(radio->dev, "%s\n", __func__);
+
+	if (radio->core->mode != WL1273_MODE_TX)
+		return count;
+
+	if (radio->rds_users == 0) {
+		dev_warn(radio->dev, "%s: RDS not on.\n", __func__);
+		return 0;
+	}
+
+	if (mutex_lock_interruptible(&radio->core->lock))
+		return -EINTR;
+	/*
+	 * Multiple processes can open the device, but only
+	 * one gets to write to it.
+	 */
+	if (radio->owner && radio->owner != file) {
+		r = -EBUSY;
+		goto out;
+	}
+	radio->owner = file;
+
+	/* Manual Mode */
+	if (count > 255)
+		val = 255;
+	else
+		val = count;
+
+	wl1273_fm_write_cmd(radio->core, WL1273_RDS_CONFIG_DATA_SET, val);
+
+	if (copy_from_user(radio->write_buf + 1, buf, val)) {
+		r = -EFAULT;
+		goto out;
+	}
+
+	dev_dbg(radio->dev, "Count: %d\n", val);
+	dev_dbg(radio->dev, "From user: \"%s\"\n", radio->write_buf);
+
+	radio->write_buf[0] = WL1273_RDS_DATA_SET;
+	wl1273_fm_write_data(radio->core, radio->write_buf, val + 1);
+
+	r = val;
+out:
+	mutex_unlock(&radio->core->lock);
+
+	return r;
+}
+
+static unsigned int wl1273_fm_fops_poll(struct file *file,
+					struct poll_table_struct *pts)
+{
+	struct wl1273_device *radio = video_get_drvdata(video_devdata(file));
+	struct wl1273_core *core = radio->core;
+
+	if (radio->owner && radio->owner != file)
+		return -EBUSY;
+
+	radio->owner = file;
+
+	if (core->mode == WL1273_MODE_RX) {
+		poll_wait(file, &core->read_queue, pts);
+
+		if (core->rd_index != core->wr_index)
+			return POLLIN | POLLRDNORM;
+
+	} else if (core->mode == WL1273_MODE_TX) {
+		return POLLOUT | POLLWRNORM;
+	}
+
+	return 0;
+}
+
+static int wl1273_fm_fops_open(struct file *file)
+{
+	struct wl1273_device *radio = video_get_drvdata(video_devdata(file));
+	struct wl1273_core *core = radio->core;
+	int r = 0;
+
+	dev_dbg(radio->dev, "%s\n", __func__);
+
+	if (core->mode == WL1273_MODE_RX && core->rds_on && !radio->rds_users) {
+		dev_dbg(radio->dev, "%s: Mode: %d\n", __func__, core->mode);
+
+		if (mutex_lock_interruptible(&core->lock))
+			return -EINTR;
+
+		core->irq_flags |= WL1273_RDS_EVENT;
+
+		r = wl1273_fm_write_cmd(core, WL1273_INT_MASK_SET,
+					core->irq_flags);
+		if (r) {
+			mutex_unlock(&core->lock);
+			goto out;
+		}
+
+		radio->rds_users++;
+
+		mutex_unlock(&core->lock);
+	}
+out:
+	return r;
+}
+
+static int wl1273_fm_fops_release(struct file *file)
+{
+	struct wl1273_device *radio = video_get_drvdata(video_devdata(file));
+	struct wl1273_core *core = radio->core;
+	int r = 0;
+
+	dev_dbg(radio->dev, "%s\n", __func__);
+
+	if (radio->rds_users > 0) {
+		radio->rds_users--;
+		if (radio->rds_users == 0) {
+			if (mutex_lock_interruptible(&core->lock))
+				return -EINTR;
+
+			core->irq_flags &= ~WL1273_RDS_EVENT;
+
+			if (core->mode == WL1273_MODE_RX) {
+				dev_dbg(radio->dev, "%s: A'\n", __func__);
+				r = wl1273_fm_write_cmd(core,
+							WL1273_INT_MASK_SET,
+							core->irq_flags);
+				if (r) {
+					mutex_unlock(&core->lock);
+					goto out;
+				}
+			}
+			mutex_unlock(&core->lock);
+		}
+	}
+
+	if (file == radio->owner)
+		radio->owner = NULL;
+out:
+	return r;
+}
+
+static ssize_t wl1273_fm_fops_read(struct file *file, char __user *buf,
+				   size_t count, loff_t *ppos)
+{
+	int r = 0;
+	struct wl1273_device *radio = video_get_drvdata(video_devdata(file));
+	struct wl1273_core *core = radio->core;
+	unsigned int block_count = 0;
+	u16 val;
+
+	dev_dbg(radio->dev, "%s\n", __func__);
+
+	if (radio->core->mode != WL1273_MODE_RX)
+		return 0;
+
+	if (radio->rds_users == 0) {
+		dev_warn(radio->dev, "%s: RDS not on.\n", __func__);
+		return 0;
+	}
+
+	if (mutex_lock_interruptible(&core->lock))
+		return -EINTR;
+
+	/*
+	 * Multiple processes can open the device, but only
+	 * one gets to read from it.
+	 */
+	if (radio->owner && radio->owner != file) {
+		r = -EBUSY;
+		goto out;
+	}
+	radio->owner = file;
+
+	r = wl1273_fm_read_reg(core, WL1273_RDS_SYNC_GET, &val);
+	if (r) {
+		dev_err(radio->dev, "%s: Get RDS_SYNC fails.\n", __func__);
+		goto out;
+	} else if (val == 0) {
+		dev_info(radio->dev, "RDS_SYNC: Not synchronized\n");
+		r = -ENODATA;
+		goto out;
+	}
+
+	/* block if no new data available */
+	while (core->wr_index == core->rd_index) {
+		if (file->f_flags & O_NONBLOCK) {
+			r = -EWOULDBLOCK;
+			goto out;
+		}
+
+		dev_dbg(radio->dev, "%s: Wait for RDS data.\n", __func__);
+		if (wait_event_interruptible(core->read_queue,
+					     core->wr_index !=
+					     core->rd_index) < 0) {
+			r = -EINTR;
+			goto out;
+		}
+	}
+
+	/* calculate block count from byte count */
+	count /= 3;
+
+	/* copy RDS blocks from the internal buffer and to user buffer */
+	while (block_count < count) {
+		if (core->rd_index == core->wr_index)
+			break;
+
+		/* always transfer complete RDS blocks */
+		if (copy_to_user(buf, &core->buffer[core->rd_index], 3))
+			break;
+
+		/* increment and wrap the read pointer */
+		core->rd_index += 3;
+		if (core->rd_index >= core->buf_size)
+			core->rd_index = 0;
+
+		/* increment counters */
+		block_count++;
+		buf += 3;
+		r += 3;
+	}
+
+out:
+	dev_dbg(radio->dev, "%s: exit\n", __func__);
+	mutex_unlock(&core->lock);
+
+	return r;
+}
+
+static const struct v4l2_file_operations wl1273_fops = {
+	.owner		= THIS_MODULE,
+	.read		= wl1273_fm_fops_read,
+	.write		= wl1273_fm_fops_write,
+	.poll		= wl1273_fm_fops_poll,
+	.ioctl		= video_ioctl2,
+	.open		= wl1273_fm_fops_open,
+	.release	= wl1273_fm_fops_release,
+};
+
+static int wl1273_fm_vidioc_querycap(struct file *file, void *priv,
+				     struct v4l2_capability *capability)
+{
+	struct wl1273_device *radio = video_get_drvdata(video_devdata(file));
+
+	dev_dbg(radio->dev, "%s\n", __func__);
+
+	strlcpy(capability->driver, WL1273_FM_DRIVER_NAME,
+		sizeof(capability->driver));
+	strlcpy(capability->card, "Texas Instruments Wl1273 FM Radio",
+		sizeof(capability->card));
+	strlcpy(capability->bus_info, "I2C", sizeof(capability->bus_info));
+
+	capability->capabilities = V4L2_CAP_HW_FREQ_SEEK |
+		V4L2_CAP_TUNER | V4L2_CAP_RADIO | V4L2_CAP_AUDIO |
+		V4L2_CAP_RDS_CAPTURE | V4L2_CAP_MODULATOR |
+		V4L2_CAP_RDS_OUTPUT | V4L2_TUNER_CAP_RDS_BLOCK_IO;
+
+	return 0;
+}
+
+static int wl1273_fm_vidioc_g_input(struct file *file, void *priv,
+				    unsigned int *i)
+{
+	struct wl1273_device *radio = video_get_drvdata(video_devdata(file));
+
+	dev_dbg(radio->dev, "%s\n", __func__);
+
+	*i = 0;
+
+	return 0;
+}
+
+static int wl1273_fm_vidioc_s_input(struct file *file, void *priv,
+				    unsigned int i)
+{
+	struct wl1273_device *radio = video_get_drvdata(video_devdata(file));
+
+	dev_dbg(radio->dev, "%s\n", __func__);
+
+	if (i != 0)
+		return -EINVAL;
+
+	return 0;
+}
+
+/**
+ * wl1273_fm_set_tx_power() -	Set the transmission power value.
+ * @core:			A pointer to the device struct.
+ * @power:			The new power value.
+ */
+static int wl1273_fm_set_tx_power(struct wl1273_core *core, u16 power)
+{
+	int r;
+
+	if (core->mode == WL1273_MODE_OFF ||
+	    core->mode == WL1273_MODE_SUSPENDED)
+		return -EPERM;
+
+	mutex_lock(&core->lock);
+
+	/* Convert the dBuV value to chip presentation */
+	r = wl1273_fm_write_cmd(core, WL1273_POWER_LEV_SET, 122 - power);
+	if (r)
+		goto out;
+
+	core->tx_power = power;
+
+out:
+	mutex_unlock(&core->lock);
+	return r;
+}
+
+#define WL1273_SPACING_50kHz	1
+#define WL1273_SPACING_100kHz	2
+#define WL1273_SPACING_200kHz	4
+
+static int wl1273_fm_tx_set_spacing(struct wl1273_core *core,
+				    unsigned int spacing)
+{
+	int r;
+
+	if (spacing == 0) {
+		r = wl1273_fm_write_cmd(core, WL1273_SCAN_SPACING_SET,
+					WL1273_SPACING_100kHz);
+		core->spacing = 100;
+	} else if (spacing - 50000 < 25000) {
+		r = wl1273_fm_write_cmd(core, WL1273_SCAN_SPACING_SET,
+					WL1273_SPACING_50kHz);
+		core->spacing = 50;
+	} else if (spacing - 100000 < 50000) {
+		r = wl1273_fm_write_cmd(core, WL1273_SCAN_SPACING_SET,
+					WL1273_SPACING_100kHz);
+		core->spacing = 100;
+	} else {
+		r = wl1273_fm_write_cmd(core, WL1273_SCAN_SPACING_SET,
+					WL1273_SPACING_200kHz);
+		core->spacing = 200;
+	}
+
+	return r;
+}
+
+static int wl1273_fm_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct wl1273_device *radio = ctrl->priv;
+	struct wl1273_core *core = radio->core;
+
+	dev_dbg(radio->dev, "%s\n", __func__);
+
+	if (mutex_lock_interruptible(&core->lock))
+		return -EINTR;
+
+	switch (ctrl->id) {
+	case  V4L2_CID_TUNE_ANTENNA_CAPACITOR:
+		ctrl->val = wl1273_fm_get_tx_ctune(core);
+		break;
+
+	default:
+		dev_warn(radio->dev, "%s: Unknown IOCTL: %d\n",
+			 __func__, ctrl->id);
+		break;
+	}
+
+	mutex_unlock(&core->lock);
+
+	return 0;
+}
+
+#define WL1273_MUTE_SOFT_ENABLE    (1 << 0)
+#define WL1273_MUTE_AC             (1 << 1)
+#define WL1273_MUTE_HARD_LEFT      (1 << 2)
+#define WL1273_MUTE_HARD_RIGHT     (1 << 3)
+#define WL1273_MUTE_SOFT_FORCE     (1 << 4)
+
+static inline struct wl1273_device *to_radio(struct v4l2_ctrl *ctrl)
+{
+	return container_of(ctrl->handler, struct wl1273_device, ctrl_handler);
+}
+
+static int wl1273_fm_vidioc_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct wl1273_device *radio = to_radio(ctrl);
+	struct wl1273_core *core = radio->core;
+	int r = 0;
+
+	dev_dbg(radio->dev, "%s\n", __func__);
+
+	switch (ctrl->id) {
+	case V4L2_CID_AUDIO_MUTE:
+		if (mutex_lock_interruptible(&core->lock))
+			return -EINTR;
+
+		if (core->mode == WL1273_MODE_RX && ctrl->val)
+			r = wl1273_fm_write_cmd(core,
+						WL1273_MUTE_STATUS_SET,
+						WL1273_MUTE_HARD_LEFT |
+						WL1273_MUTE_HARD_RIGHT);
+		else if (core->mode == WL1273_MODE_RX)
+			r = wl1273_fm_write_cmd(core,
+						WL1273_MUTE_STATUS_SET, 0x0);
+		else if (core->mode == WL1273_MODE_TX && ctrl->val)
+			r = wl1273_fm_write_cmd(core, WL1273_MUTE, 1);
+		else if (core->mode == WL1273_MODE_TX)
+			r = wl1273_fm_write_cmd(core, WL1273_MUTE, 0);
+
+		mutex_unlock(&core->lock);
+		break;
+
+	case V4L2_CID_AUDIO_VOLUME:
+		if (ctrl->val == 0)
+			r = wl1273_fm_set_mode(core, WL1273_MODE_OFF);
+		else
+			r =  wl1273_fm_set_volume(core, core->volume);
+		break;
+
+	case V4L2_CID_TUNE_PREEMPHASIS:
+		r = wl1273_fm_set_preemphasis(core, ctrl->val);
+		break;
+
+	case V4L2_CID_TUNE_POWER_LEVEL:
+		r = wl1273_fm_set_tx_power(core, ctrl->val);
+		break;
+
+	default:
+		dev_warn(radio->dev, "%s: Unknown IOCTL: %d\n",
+			 __func__, ctrl->id);
+		break;
+	}
+
+	dev_dbg(radio->dev, "%s\n", __func__);
+	return r;
+}
+
+static int wl1273_fm_vidioc_g_audio(struct file *file, void *priv,
+				    struct v4l2_audio *audio)
+{
+	struct wl1273_device *radio = video_get_drvdata(video_devdata(file));
+
+	dev_dbg(radio->dev, "%s\n", __func__);
+
+	if (audio->index > 1)
+		return -EINVAL;
+
+	strlcpy(audio->name, "Radio", sizeof(audio->name));
+	audio->capability = V4L2_AUDCAP_STEREO;
+
+	return 0;
+}
+
+static int wl1273_fm_vidioc_s_audio(struct file *file, void *priv,
+				    struct v4l2_audio *audio)
+{
+	struct wl1273_device *radio = video_get_drvdata(video_devdata(file));
+
+	dev_dbg(radio->dev, "%s\n", __func__);
+
+	if (audio->index != 0)
+		return -EINVAL;
+
+	return 0;
+}
+
+#define WL1273_RDS_NOT_SYNCHRONIZED 0
+#define WL1273_RDS_SYNCHRONIZED 1
+
+static int wl1273_fm_vidioc_g_tuner(struct file *file, void *priv,
+				    struct v4l2_tuner *tuner)
+{
+	struct wl1273_device *radio = video_get_drvdata(video_devdata(file));
+	struct wl1273_core *core = radio->core;
+	u16 val;
+	int r;
+
+	dev_dbg(radio->dev, "%s\n", __func__);
+
+	if (tuner->index > 0)
+		return -EINVAL;
+
+	strlcpy(tuner->name, WL1273_FM_DRIVER_NAME, sizeof(tuner->name));
+	tuner->type = V4L2_TUNER_RADIO;
+
+	tuner->rangelow	= WL1273_FREQ(WL1273_BAND_JAPAN_LOW);
+	tuner->rangehigh = WL1273_FREQ(WL1273_BAND_OTHER_HIGH);
+
+	tuner->capability = V4L2_TUNER_CAP_LOW | V4L2_TUNER_CAP_RDS |
+		V4L2_TUNER_CAP_STEREO;
+
+	if (core->stereo)
+		tuner->audmode = V4L2_TUNER_MODE_STEREO;
+	else
+		tuner->audmode = V4L2_TUNER_MODE_MONO;
+
+	if (core->mode != WL1273_MODE_RX)
+		return 0;
+
+	if (mutex_lock_interruptible(&core->lock))
+		return -EINTR;
+
+	r = wl1273_fm_read_reg(core, WL1273_STEREO_GET, &val);
+	if (r)
+		goto out;
+
+	if (val == 1)
+		tuner->rxsubchans = V4L2_TUNER_SUB_STEREO;
+	else
+		tuner->rxsubchans = V4L2_TUNER_SUB_MONO;
+
+	r = wl1273_fm_read_reg(core, WL1273_RSSI_LVL_GET, &val);
+	if (r)
+		goto out;
+
+	tuner->signal = (s16) val;
+	dev_dbg(radio->dev, "Signal: %d\n", tuner->signal);
+
+	tuner->afc = 0;
+
+	r = wl1273_fm_read_reg(core, WL1273_RDS_SYNC_GET, &val);
+	if (r)
+		goto out;
+
+	if (val == WL1273_RDS_SYNCHRONIZED)
+		tuner->rxsubchans |= V4L2_TUNER_SUB_RDS;
+out:
+	mutex_unlock(&core->lock);
+
+	return r;
+}
+
+static int wl1273_fm_vidioc_s_tuner(struct file *file, void *priv,
+				    struct v4l2_tuner *tuner)
+{
+	struct wl1273_device *radio = video_get_drvdata(video_devdata(file));
+	struct wl1273_core *core = radio->core;
+	int r = 0;
+
+	dev_dbg(radio->dev, "%s\n", __func__);
+	dev_dbg(radio->dev, "tuner->index: %d\n", tuner->index);
+	dev_dbg(radio->dev, "tuner->name: %s\n", tuner->name);
+	dev_dbg(radio->dev, "tuner->capability: 0x%04x\n", tuner->capability);
+	dev_dbg(radio->dev, "tuner->rxsubchans: 0x%04x\n", tuner->rxsubchans);
+	dev_dbg(radio->dev, "tuner->rangelow: %d\n", tuner->rangelow);
+	dev_dbg(radio->dev, "tuner->rangehigh: %d\n", tuner->rangehigh);
+
+	if (tuner->index > 0)
+		return -EINVAL;
+
+	if (mutex_lock_interruptible(&core->lock))
+		return -EINTR;
+
+	r = wl1273_fm_set_mode(core, WL1273_MODE_RX);
+	if (r)
+		goto out;
+
+	if (tuner->rxsubchans & V4L2_TUNER_SUB_RDS)
+		r = wl1273_fm_set_rds(core, WL1273_RDS_ON);
+	else
+		r = wl1273_fm_set_rds(core, WL1273_RDS_OFF);
+
+	if (r)
+		dev_warn(radio->dev, "%s: RDS fails: %d\n", __func__, r);
+
+	if (tuner->audmode == V4L2_TUNER_MODE_MONO) {
+		r = wl1273_fm_write_cmd(core, WL1273_MOST_MODE_SET,
+					WL1273_RX_MONO);
+		if (r < 0) {
+			dev_warn(radio->dev, "%s: MOST_MODE fails: %d\n",
+				 __func__, r);
+			goto out;
+		}
+		core->stereo = false;
+	} else if (tuner->audmode == V4L2_TUNER_MODE_MONO) {
+		r = wl1273_fm_write_cmd(core, WL1273_MOST_MODE_SET,
+					WL1273_RX_STEREO);
+		if (r < 0) {
+			dev_warn(radio->dev, "%s: MOST_MODE fails: %d\n",
+				 __func__, r);
+			goto out;
+		}
+		core->stereo = true;
+	} else {
+		dev_err(radio->dev, "%s: tuner->audmode: %d\n",
+			 __func__, tuner->audmode);
+		r = -EINVAL;
+		goto out;
+	}
+
+out:
+	mutex_unlock(&core->lock);
+
+	return r;
+}
+
+static int wl1273_fm_vidioc_g_frequency(struct file *file, void *priv,
+					struct v4l2_frequency *freq)
+{
+	struct wl1273_device *radio = video_get_drvdata(video_devdata(file));
+	struct wl1273_core *core = radio->core;
+
+	dev_dbg(radio->dev, "%s\n", __func__);
+
+	if (mutex_lock_interruptible(&core->lock))
+		return -EINTR;
+
+	freq->type = V4L2_TUNER_RADIO;
+	freq->frequency = WL1273_FREQ(wl1273_fm_get_freq(core));
+
+	mutex_unlock(&core->lock);
+
+	return 0;
+}
+
+static int wl1273_fm_vidioc_s_frequency(struct file *file, void *priv,
+					struct v4l2_frequency *freq)
+{
+	struct wl1273_device *radio = video_get_drvdata(video_devdata(file));
+	struct wl1273_core *core = radio->core;
+	int r;
+
+	dev_dbg(radio->dev, "%s: %d\n", __func__, freq->frequency);
+
+	if (freq->type != V4L2_TUNER_RADIO) {
+		dev_dbg(radio->dev,
+			"freq->type != V4L2_TUNER_RADIO: %d\n", freq->type);
+		return -EINVAL;
+	}
+
+	if (mutex_lock_interruptible(&core->lock))
+		return -EINTR;
+
+	if (core->mode == WL1273_MODE_RX) {
+		dev_dbg(radio->dev, "freq: %d\n", freq->frequency);
+
+		r = wl1273_fm_set_rx_freq(core,
+					  WL1273_INV_FREQ(freq->frequency));
+		if (r)
+			dev_warn(radio->dev, WL1273_FM_DRIVER_NAME
+				 ": set frequency failed with %d\n", r);
+	} else {
+		r = wl1273_fm_set_tx_freq(core,
+					  WL1273_INV_FREQ(freq->frequency));
+		if (r)
+			dev_warn(radio->dev, WL1273_FM_DRIVER_NAME
+				 ": set frequency failed with %d\n", r);
+	}
+
+	mutex_unlock(&core->lock);
+
+	dev_dbg(radio->dev, "wl1273_vidioc_s_frequency: DONE\n");
+	return r;
+}
+
+#define WL1273_DEFAULT_SEEK_LEVEL	7
+
+static int wl1273_fm_vidioc_s_hw_freq_seek(struct file *file, void *priv,
+					   struct v4l2_hw_freq_seek *seek)
+{
+	struct wl1273_device *radio = video_get_drvdata(video_devdata(file));
+	struct wl1273_core *core = radio->core;
+	int r;
+
+	dev_dbg(radio->dev, "%s\n", __func__);
+
+	if (seek->tuner != 0 || seek->type != V4L2_TUNER_RADIO)
+		return -EINVAL;
+
+	if (mutex_lock_interruptible(&core->lock))
+		return -EINTR;
+
+	r = wl1273_fm_set_mode(core, WL1273_MODE_RX);
+	if (r)
+		goto out;
+
+	r = wl1273_fm_tx_set_spacing(core, seek->spacing);
+	if (r)
+		dev_warn(radio->dev, "HW seek failed: %d\n", r);
+
+	r = wl1273_fm_set_seek(core, seek->wrap_around, seek->seek_upward,
+			       WL1273_DEFAULT_SEEK_LEVEL);
+	if (r)
+		dev_warn(radio->dev, "HW seek failed: %d\n", r);
+
+out:
+	mutex_unlock(&core->lock);
+	return r;
+}
+
+static int wl1273_fm_vidioc_s_modulator(struct file *file, void *priv,
+					struct v4l2_modulator *modulator)
+{
+	struct wl1273_device *radio = video_get_drvdata(video_devdata(file));
+	struct wl1273_core *core = radio->core;
+	int r = 0;
+
+	dev_dbg(radio->dev, "%s\n", __func__);
+
+	if (modulator->index > 0)
+		return -EINVAL;
+
+	if (mutex_lock_interruptible(&core->lock))
+		return -EINTR;
+
+	r = wl1273_fm_set_mode(core, WL1273_MODE_TX);
+	if (r)
+		goto out;
+
+	if (modulator->txsubchans & V4L2_TUNER_SUB_RDS)
+		r = wl1273_fm_set_rds(core, WL1273_RDS_ON);
+	else
+		r = wl1273_fm_set_rds(core, WL1273_RDS_OFF);
+
+	if (modulator->txsubchans & V4L2_TUNER_SUB_MONO)
+		r = wl1273_fm_write_cmd(core, WL1273_MONO_SET, WL1273_TX_MONO);
+	else
+		r = wl1273_fm_write_cmd(core, WL1273_MONO_SET,
+					WL1273_RX_STEREO);
+	if (r < 0)
+		dev_warn(radio->dev, WL1273_FM_DRIVER_NAME
+			 "MONO_SET fails: %d\n", r);
+out:
+	mutex_unlock(&core->lock);
+
+	return r;
+}
+
+static int wl1273_fm_vidioc_g_modulator(struct file *file, void *priv,
+					struct v4l2_modulator *modulator)
+{
+	struct wl1273_device *radio = video_get_drvdata(video_devdata(file));
+	struct wl1273_core *core = radio->core;
+	u16 val;
+	int r;
+
+	dev_dbg(radio->dev, "%s\n", __func__);
+
+	strlcpy(modulator->name, WL1273_FM_DRIVER_NAME,
+		sizeof(modulator->name));
+
+	modulator->rangelow = WL1273_FREQ(WL1273_BAND_JAPAN_LOW);
+	modulator->rangehigh = WL1273_FREQ(WL1273_BAND_OTHER_HIGH);
+
+	modulator->capability =  V4L2_TUNER_CAP_LOW | V4L2_TUNER_CAP_RDS |
+		V4L2_TUNER_CAP_STEREO;
+
+	if (core->mode != WL1273_MODE_TX)
+		return 0;
+
+	if (mutex_lock_interruptible(&core->lock))
+		return -EINTR;
+
+	r = wl1273_fm_read_reg(core, WL1273_MONO_SET, &val);
+	if (r)
+		goto out;
+
+	if (val == WL1273_TX_STEREO)
+		modulator->txsubchans = V4L2_TUNER_SUB_STEREO;
+	else
+		modulator->txsubchans = V4L2_TUNER_SUB_MONO;
+
+	if (core->rds_on)
+		modulator->txsubchans |= V4L2_TUNER_SUB_RDS;
+out:
+	mutex_unlock(&core->lock);
+
+	return 0;
+}
+
+static int wl1273_fm_vidioc_log_status(struct file *file, void *priv)
+{
+	struct wl1273_device *radio = video_get_drvdata(video_devdata(file));
+	struct wl1273_core *core = radio->core;
+	struct device *dev = radio->dev;
+	u16 val;
+	int r;
+
+	dev_info(dev, DRIVER_DESC);
+
+	if (core->mode == WL1273_MODE_OFF) {
+		dev_info(dev, "Mode: Off\n");
+		return 0;
+	}
+
+	if (core->mode == WL1273_MODE_SUSPENDED) {
+		dev_info(dev, "Mode: Suspended\n");
+		return 0;
+	}
+
+	r = wl1273_fm_read_reg(core, WL1273_ASIC_ID_GET, &val);
+	if (r)
+		dev_err(dev, "%s: Get ASIC_ID fails.\n", __func__);
+	else
+		dev_info(dev, "ASIC_ID: 0x%04x\n", val);
+
+	r = wl1273_fm_read_reg(core, WL1273_ASIC_VER_GET, &val);
+	if (r)
+		dev_err(dev, "%s: Get ASIC_VER fails.\n", __func__);
+	else
+		dev_info(dev, "ASIC Version: 0x%04x\n", val);
+
+	r = wl1273_fm_read_reg(core, WL1273_FIRM_VER_GET, &val);
+	if (r)
+		dev_err(dev, "%s: Get FIRM_VER fails.\n", __func__);
+	else
+		dev_info(dev, "FW version: %d(0x%04x)\n", val, val);
+
+	r = wl1273_fm_read_reg(core, WL1273_BAND_SET, &val);
+	if (r)
+		dev_err(dev, "%s: Get BAND fails.\n", __func__);
+	else
+		dev_info(dev, "BAND: %d\n", val);
+
+	if (core->mode == WL1273_MODE_TX) {
+		r = wl1273_fm_read_reg(core, WL1273_PUPD_SET, &val);
+		if (r)
+			dev_err(dev, "%s: Get PUPD fails.\n", __func__);
+		else
+			dev_info(dev, "PUPD: 0x%04x\n", val);
+
+		r = wl1273_fm_read_reg(core, WL1273_CHANL_SET, &val);
+		if (r)
+			dev_err(dev, "%s: Get CHANL fails.\n", __func__);
+		else
+			dev_info(dev, "Tx frequency: %dkHz\n", val*10);
+	} else if (core->mode == WL1273_MODE_RX) {
+		int bf = core->rangelow;
+
+		r = wl1273_fm_read_reg(core, WL1273_FREQ_SET, &val);
+		if (r)
+			dev_err(dev, "%s: Get FREQ fails.\n", __func__);
+		else
+			dev_info(dev, "RX Frequency: %dkHz\n", bf + val*50);
+
+		r = wl1273_fm_read_reg(core, WL1273_MOST_MODE_SET, &val);
+		if (r)
+			dev_err(dev, "%s: Get MOST_MODE fails.\n",
+				__func__);
+		else if (val == 0)
+			dev_info(dev, "MOST_MODE: Stereo according to blend\n");
+		else if (val == 1)
+			dev_info(dev, "MOST_MODE: Force mono output\n");
+		else
+			dev_info(dev, "MOST_MODE: Unexpected value: %d\n", val);
+
+		r = wl1273_fm_read_reg(core, WL1273_MOST_BLEND_SET, &val);
+		if (r)
+			dev_err(dev, "%s: Get MOST_BLEND fails.\n", __func__);
+		else if (val == 0)
+			dev_info(dev,
+				 "MOST_BLEND: Switched blend & hysteresis.\n");
+		else if (val == 1)
+			dev_info(dev, "MOST_BLEND: Soft blend.\n");
+		else
+			dev_info(dev, "MOST_BLEND: Unexpected val: %d\n", val);
+
+		r = wl1273_fm_read_reg(core, WL1273_STEREO_GET, &val);
+		if (r)
+			dev_err(dev, "%s: Get STEREO fails.\n", __func__);
+		else if (val == 0)
+			dev_info(dev, "STEREO: Not detected\n");
+		else if (val == 1)
+			dev_info(dev, "STEREO: Detected\n");
+		else
+			dev_info(dev, "STEREO: Unexpected value: %d\n", val);
+
+		r = wl1273_fm_read_reg(core, WL1273_RSSI_LVL_GET, &val);
+		if (r)
+			dev_err(dev, "%s: Get RSSI_LVL fails.\n", __func__);
+		else
+			dev_info(dev, "RX signal strength: %d\n", (s16) val);
+
+		r = wl1273_fm_read_reg(core, WL1273_POWER_SET, &val);
+		if (r)
+			dev_err(dev, "%s: Get POWER fails.\n", __func__);
+		else
+			dev_info(dev, "POWER: 0x%04x\n", val);
+
+		r = wl1273_fm_read_reg(core, WL1273_INT_MASK_SET, &val);
+		if (r)
+			dev_err(dev, "%s: Get INT_MASK fails.\n", __func__);
+		else
+			dev_info(dev, "INT_MASK: 0x%04x\n", val);
+
+		r = wl1273_fm_read_reg(core, WL1273_RDS_SYNC_GET, &val);
+		if (r)
+			dev_err(dev, "%s: Get RDS_SYNC fails.\n",
+				__func__);
+		else if (val == 0)
+			dev_info(dev, "RDS_SYNC: Not synchronized\n");
+
+		else if (val == 1)
+			dev_info(dev, "RDS_SYNC: Synchronized\n");
+		else
+			dev_info(dev, "RDS_SYNC: Unexpected value: %d\n", val);
+
+		r = wl1273_fm_read_reg(core, WL1273_I2S_MODE_CONFIG_SET, &val);
+		if (r)
+			dev_err(dev, "%s: Get I2S_MODE_CONFIG fails.\n",
+				__func__);
+		else
+			dev_info(dev, "I2S_MODE_CONFIG: 0x%04x\n", val);
+
+		r = wl1273_fm_read_reg(core, WL1273_VOLUME_SET, &val);
+		if (r)
+			dev_err(dev, "%s: Get VOLUME fails.\n", __func__);
+		else
+			dev_info(dev, "VOLUME: 0x%04x\n", val);
+	}
+
+	return 0;
+}
+
+static void wl1273_vdev_release(struct video_device *dev)
+{
+}
+
+static const struct v4l2_ctrl_ops wl1273_ctrl_ops = {
+	.s_ctrl = wl1273_fm_vidioc_s_ctrl,
+	.g_volatile_ctrl = wl1273_fm_g_volatile_ctrl,
+};
+
+static const struct v4l2_ioctl_ops wl1273_ioctl_ops = {
+	.vidioc_querycap	= wl1273_fm_vidioc_querycap,
+	.vidioc_g_input		= wl1273_fm_vidioc_g_input,
+	.vidioc_s_input		= wl1273_fm_vidioc_s_input,
+	.vidioc_g_audio		= wl1273_fm_vidioc_g_audio,
+	.vidioc_s_audio		= wl1273_fm_vidioc_s_audio,
+	.vidioc_g_tuner		= wl1273_fm_vidioc_g_tuner,
+	.vidioc_s_tuner		= wl1273_fm_vidioc_s_tuner,
+	.vidioc_g_frequency	= wl1273_fm_vidioc_g_frequency,
+	.vidioc_s_frequency	= wl1273_fm_vidioc_s_frequency,
+	.vidioc_s_hw_freq_seek	= wl1273_fm_vidioc_s_hw_freq_seek,
+	.vidioc_g_modulator	= wl1273_fm_vidioc_g_modulator,
+	.vidioc_s_modulator	= wl1273_fm_vidioc_s_modulator,
+	.vidioc_log_status      = wl1273_fm_vidioc_log_status,
+};
+
+static struct video_device wl1273_viddev_template = {
+	.fops			= &wl1273_fops,
+	.ioctl_ops		= &wl1273_ioctl_ops,
+	.name			= WL1273_FM_DRIVER_NAME,
+	.release		= wl1273_vdev_release,
+};
+
+static int wl1273_fm_radio_remove(struct platform_device *pdev)
+{
+	struct wl1273_device *radio = platform_get_drvdata(pdev);;
+
+	dev_info(&pdev->dev, "%s.\n", __func__);
+
+	v4l2_ctrl_handler_free(&radio->ctrl_handler);
+	video_unregister_device(&radio->videodev);
+	v4l2_device_unregister(&radio->v4l2dev);
+	kfree(radio->write_buf);
+	kfree(radio);
+
+	return 0;
+}
+
+static int __devinit wl1273_fm_radio_probe(struct platform_device *pdev)
+{
+	struct wl1273_core **pdata = pdev->dev.platform_data;
+	struct wl1273_device *radio;
+	struct v4l2_ctrl *ctrl;
+	int r = 0;
+
+	dev_dbg(&pdev->dev, "%s\n", __func__);
+
+	if (!pdata) {
+		dev_err(&pdev->dev, "No platform data.\n");
+		r = -EINVAL;
+		goto pdata_err;
+	}
+
+	radio = kzalloc(sizeof(*radio), GFP_KERNEL);
+	if (!radio) {
+		r = -ENOMEM;
+		goto pdata_err;
+	}
+
+	radio->write_buf = kmalloc(256, GFP_KERNEL);
+	if (!radio->write_buf) {
+		r = -ENOMEM;
+		goto write_buf_err;
+	}
+
+	radio->core = *pdata;
+	radio->dev = &pdev->dev;
+	radio->v4l2dev.ctrl_handler = &radio->ctrl_handler;
+	radio->rds_users = 0;
+
+	r = v4l2_device_register(&pdev->dev, &radio->v4l2dev);
+	if (r) {
+		dev_err(&pdev->dev, "Cannot register v4l2_device.\n");
+		goto device_register_err;
+	}
+
+	/* V4L2 configuration */
+	memcpy(&radio->videodev, &wl1273_viddev_template,
+	       sizeof(wl1273_viddev_template));
+
+	radio->videodev.v4l2_dev = &radio->v4l2dev;
+
+	v4l2_ctrl_handler_init(&radio->ctrl_handler, 6);
+	/* add in ascending ID order */
+	v4l2_ctrl_new_std(&radio->ctrl_handler, &wl1273_ctrl_ops,
+			  V4L2_CID_AUDIO_VOLUME, 0, WL1273_MAX_VOLUME, 1,
+			  WL1273_DEFAULT_VOLUME);
+
+	v4l2_ctrl_new_std(&radio->ctrl_handler, &wl1273_ctrl_ops,
+			  V4L2_CID_AUDIO_MUTE, 0, 1, 1, 1);
+
+	v4l2_ctrl_new_std(&radio->ctrl_handler, &wl1273_ctrl_ops,
+			  V4L2_CID_TUNE_PREEMPHASIS, V4L2_PREEMPHASIS_DISABLED,
+			  V4L2_PREEMPHASIS_75_uS, 1, V4L2_PREEMPHASIS_50_uS);
+
+	v4l2_ctrl_new_std(&radio->ctrl_handler, &wl1273_ctrl_ops,
+			  V4L2_CID_TUNE_POWER_LEVEL, 91, 122, 1, 118);
+
+	ctrl = v4l2_ctrl_new_std(&radio->ctrl_handler, &wl1273_ctrl_ops,
+				 V4L2_CID_TUNE_ANTENNA_CAPACITOR,
+				 0, 255, 1, 255);
+	if (ctrl)
+		ctrl->is_volatile = 1;
+
+	if (radio->ctrl_handler.error) {
+		r = radio->ctrl_handler.error;
+		goto handler_init_err;
+	}
+
+	video_set_drvdata(&radio->videodev, radio);
+	platform_set_drvdata(pdev, radio);
+
+	/* register video device */
+	r = video_register_device(&radio->videodev, VFL_TYPE_RADIO, radio_nr);
+	if (r) {
+		dev_err(&pdev->dev, WL1273_FM_DRIVER_NAME
+			": Could not register video device\n");
+		goto handler_init_err;
+	}
+
+	return 0;
+
+handler_init_err:
+	v4l2_ctrl_handler_free(&radio->ctrl_handler);
+	v4l2_device_unregister(&radio->v4l2dev);
+device_register_err:
+	kfree(radio->write_buf);
+write_buf_err:
+	kfree(radio);
+pdata_err:
+	return r;
+}
+
+MODULE_ALIAS("platform:wl1273_fm_radio");
+
+static struct platform_driver wl1273_fm_radio_driver = {
+	.probe		= wl1273_fm_radio_probe,
+	.remove		= __devexit_p(wl1273_fm_radio_remove),
+	.driver		= {
+		.name	= "wl1273_fm_radio",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init wl1273_fm_module_init(void)
+{
+	pr_info("%s\n", __func__);
+	return platform_driver_register(&wl1273_fm_radio_driver);
+}
+module_init(wl1273_fm_module_init);
+
+static void __exit wl1273_fm_module_exit(void)
+{
+	flush_scheduled_work();
+	platform_driver_unregister(&wl1273_fm_radio_driver);
+	pr_info(DRIVER_DESC ", Exiting.\n");
+}
+module_exit(wl1273_fm_module_exit);
+
+MODULE_AUTHOR("Matti Aaltonen <matti.j.aaltonen@nokia.com>");
+MODULE_DESCRIPTION(DRIVER_DESC);
+MODULE_LICENSE("GPL");
diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index db51ea1..ffb88c6 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -228,6 +228,11 @@ config MFD_TC35892
 	  This driver provides common support for accessing the device,
 	  additional drivers must be enabled in order to use the
 	  functionality of the device.
+config WL1273_CORE
+	tristate
+	depends on I2C
+	select MFD_CORE
+	default n
 
 config MFD_TMIO
 	bool
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index feaeeae..c43ab14 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -39,6 +39,8 @@ obj-$(CONFIG_TWL4030_POWER)    += twl4030-power.o
 obj-$(CONFIG_TWL4030_CODEC)	+= twl4030-codec.o
 obj-$(CONFIG_TWL6030_PWM)	+= twl6030-pwm.o
 
+obj-$(CONFIG_WL1273_CORE)	+= wl1273-core.o
+
 obj-$(CONFIG_MFD_MC13783)	+= mc13783-core.o
 
 obj-$(CONFIG_MFD_CORE)		+= mfd-core.o
-- 
1.6.1.3

