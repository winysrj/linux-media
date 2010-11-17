Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.128.26]:48237 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934357Ab0KQOc0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Nov 2010 09:32:26 -0500
From: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
To: mchehab@redhat.com, hverkuil@xs4all.nl, sameo@linux.intel.com,
	linux-media@vger.kernel.org
Cc: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Subject: [PATCH v16 1/2] MFD: WL1273 FM Radio: MFD driver for the FM radio.
Date: Wed, 17 Nov 2010 15:42:00 +0200
Message-Id: <1290001321-6732-2-git-send-email-matti.j.aaltonen@nokia.com>
In-Reply-To: <1290001321-6732-1-git-send-email-matti.j.aaltonen@nokia.com>
References: <1290001321-6732-1-git-send-email-matti.j.aaltonen@nokia.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is the core of the WL1273 FM radio driver, it connects
the two child modules.

This is a parent for two child drivers:
drivers/media/radio/radio-wl1273.c and sound/soc/codecs/wl1273.c

Radio-wl1273 implements the V4L2 interface and the communication to the device.
The ALSA codec is for digital audio. Without the codec only analog audio
is available.

Signed-off-by: Matti J. Aaltonen <matti.j.aaltonen@nokia.com>
---
 drivers/mfd/Kconfig             |    6 +
 drivers/mfd/Makefile            |    1 +
 drivers/mfd/wl1273-core.c       |  154 ++++++++++++++++++++
 include/linux/mfd/wl1273-core.h |  298 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 459 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/wl1273-core.c
 create mode 100644 include/linux/mfd/wl1273-core.h

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 3a1493b..04c76c9 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -606,6 +606,12 @@ config MFD_VX855
 	  VIA VX855/VX875 south bridge. You will need to enable the vx855_spi
 	  and/or vx855_gpio drivers for this to do anything useful.
 
+config WL1273_CORE
+	tristate
+	depends on I2C
+	select MFD_CORE
+	default n
+
 endif # MFD_SUPPORT
 
 menu "Multimedia Capabilities Port drivers"
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index f54b365..0d549b4 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -81,3 +81,4 @@ obj-$(CONFIG_MFD_JANZ_CMODIO)	+= janz-cmodio.o
 obj-$(CONFIG_MFD_JZ4740_ADC)	+= jz4740-adc.o
 obj-$(CONFIG_MFD_TPS6586X)	+= tps6586x.o
 obj-$(CONFIG_MFD_VX855)		+= vx855.o
+obj-$(CONFIG_WL1273_CORE)	+= wl1273-core.o
diff --git a/drivers/mfd/wl1273-core.c b/drivers/mfd/wl1273-core.c
new file mode 100644
index 0000000..c900f35
--- /dev/null
+++ b/drivers/mfd/wl1273-core.c
@@ -0,0 +1,154 @@
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
+#include <linux/delay.h>
+#include <linux/mfd/wl1273-core.h>
+#include <linux/slab.h>
+#include <media/v4l2-common.h>
+
+#define DRIVER_DESC "WL1273 FM Radio Core"
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
+
+	dev_dbg(&client->dev, "%s\n", __func__);
+
+	mfd_remove_devices(&client->dev);
+	i2c_set_clientdata(client, NULL);
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
+	core->pdata = pdata;
+	core->client = client;
+	mutex_init(&core->lock);
+
+	i2c_set_clientdata(client, core);
+
+	/* the radio child must be first */
+	if (pdata->children & WL1273_RADIO_CHILD) {
+		struct mfd_cell *cell = &core->cells[children];
+		dev_dbg(&client->dev, "%s: Have V4L2.\n", __func__);
+		cell->name = "wl1273_fm_radio";
+		cell->platform_data = &core;
+		cell->data_size = sizeof(core);
+		children++;
+	} else {
+		dev_err(&client->dev, "Cannot function without radio child.\n");
+		r = -EINVAL;
+		goto err_radio_child;
+	}
+
+	if (pdata->children & WL1273_CODEC_CHILD) {
+		struct mfd_cell *cell = &core->cells[children];
+		dev_dbg(&client->dev, "%s: Have codec.\n", __func__);
+		cell->name = "wl1273-codec";
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
+err_radio_child:
+	i2c_set_clientdata(client, NULL);
+	pdata->free_resources();
+	kfree(core);
+
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
index 0000000..c2c44dc
--- /dev/null
+++ b/include/linux/mfd/wl1273-core.h
@@ -0,0 +1,298 @@
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
+#define WL1273_SCAN_SPACING_SET		56
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
+#define WL1273_RDS_OFF		0
+#define WL1273_RDS_ON		1
+#define WL1273_RDS_RESET	2
+
+#define WL1273_AUDIO_DIGITAL	0
+#define WL1273_AUDIO_ANALOG	1
+
+#define WL1273_MODE_RX		(1 << 0)
+#define WL1273_MODE_TX		(1 << 1)
+#define WL1273_MODE_OFF		(1 << 2)
+#define WL1273_MODE_SUSPENDED	(1 << 3)
+
+#define WL1273_RADIO_CHILD	(1 << 0)
+#define WL1273_CODEC_CHILD	(1 << 1)
+
+#define WL1273_RX_MONO		1
+#define WL1273_RX_STEREO	0
+#define WL1273_TX_MONO		0
+#define WL1273_TX_STEREO	1
+
+#define WL1273_MAX_VOLUME	0xffff
+#define WL1273_DEFAULT_VOLUME	0x78b8
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
+#define SCHAR_MIN (-128)
+#define SCHAR_MAX 127
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
+#define TUNER_MODE_STOP_SEARCH		0
+#define TUNER_MODE_PRESET		1
+#define TUNER_MODE_AUTO_SEEK		2
+#define TUNER_MODE_AF			3
+#define TUNER_MODE_AUTO_SEEK_PI		4
+#define TUNER_MODE_AUTO_SEEK_BULK	5
+
+#define RDS_BLOCK_SIZE	3
+
+struct wl1273_fm_platform_data {
+	int (*request_resources) (struct i2c_client *client);
+	void (*free_resources) (void);
+	void (*enable) (void);
+	void (*disable) (void);
+
+	u8 forbidden_modes;
+	unsigned int children;
+};
+
+#define WL1273_FM_CORE_CELLS	2
+
+#define WL1273_BAND_OTHER	0
+#define WL1273_BAND_JAPAN	1
+
+#define WL1273_BAND_JAPAN_LOW	76000
+#define WL1273_BAND_JAPAN_HIGH	90000
+#define WL1273_BAND_OTHER_LOW	87500
+#define WL1273_BAND_OTHER_HIGH	108000
+
+#define WL1273_BAND_TX_LOW	76000
+#define WL1273_BAND_TX_HIGH	108000
+
+struct wl1273_fw_packet{
+	int len;
+	__u8 *buf;
+};
+
+struct wl1273_core {
+	struct mfd_cell cells[WL1273_FM_CORE_CELLS];
+	struct wl1273_fm_platform_data *pdata;
+
+	unsigned int mode;
+	unsigned int i2s_mode;
+	unsigned int volume;
+	unsigned int audio_mode;
+	unsigned int channel_number;
+	struct mutex lock; /* for serializing fm radio operations */
+
+	struct i2c_client *client;
+
+	int (*write)(struct wl1273_core *core, u8, u16);
+	int (*set_audio)(struct wl1273_core *core, unsigned int);
+	int (*set_volume)(struct wl1273_core *core, unsigned int);
+};
+
+#endif	/* ifndef RADIO_WL1273_H */
-- 
1.6.1.3

