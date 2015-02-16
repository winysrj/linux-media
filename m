Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:60574 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774AbbBPTun (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Feb 2015 14:50:43 -0500
Received: by mail-wg0-f52.google.com with SMTP id x12so21378960wgg.11
        for <linux-media@vger.kernel.org>; Mon, 16 Feb 2015 11:50:42 -0800 (PST)
From: Philip Downer <pdowner@prospero-tech.com>
To: linux-media@vger.kernel.org
Cc: Philip Downer <pdowner@prospero-tech.com>
Subject: [RFC PATCH 1/1] [media] pci: Add support for DVB PCIe cards from Prospero Technologies Ltd.
Date: Mon, 16 Feb 2015 19:48:46 +0000
Message-Id: <1424116126-14052-2-git-send-email-pdowner@prospero-tech.com>
In-Reply-To: <1424116126-14052-1-git-send-email-pdowner@prospero-tech.com>
References: <1424116126-14052-1-git-send-email-pdowner@prospero-tech.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds support for the Vortex 1 PCIe card from Prospero
Technologies Ltd. The Vortex 1 supports up to 8 tuner modules and
currently ships with 8xDibcom 7090p tuners. The card also has raw
infra-red support and a hardware demuxer.

Signed-off-by: Philip Downer <pdowner@prospero-tech.com>
---
 drivers/media/pci/Kconfig                     |    1 +
 drivers/media/pci/Makefile                    |    2 +
 drivers/media/pci/prospero/Kconfig            |    7 +
 drivers/media/pci/prospero/Makefile           |    7 +
 drivers/media/pci/prospero/prospero_common.h  |  264 ++++
 drivers/media/pci/prospero/prospero_fe.h      |    5 +
 drivers/media/pci/prospero/prospero_fe_main.c |  466 ++++++
 drivers/media/pci/prospero/prospero_i2c.c     |  449 ++++++
 drivers/media/pci/prospero/prospero_i2c.h     |    3 +
 drivers/media/pci/prospero/prospero_ir.c      |  150 ++
 drivers/media/pci/prospero/prospero_ir.h      |    4 +
 drivers/media/pci/prospero/prospero_main.c    | 2086 +++++++++++++++++++++++++
 12 files changed, 3444 insertions(+)
 create mode 100644 drivers/media/pci/prospero/Kconfig
 create mode 100644 drivers/media/pci/prospero/Makefile
 create mode 100644 drivers/media/pci/prospero/prospero_common.h
 create mode 100644 drivers/media/pci/prospero/prospero_fe.h
 create mode 100644 drivers/media/pci/prospero/prospero_fe_main.c
 create mode 100644 drivers/media/pci/prospero/prospero_i2c.c
 create mode 100644 drivers/media/pci/prospero/prospero_i2c.h
 create mode 100644 drivers/media/pci/prospero/prospero_ir.c
 create mode 100644 drivers/media/pci/prospero/prospero_ir.h
 create mode 100644 drivers/media/pci/prospero/prospero_main.c

diff --git a/drivers/media/pci/Kconfig b/drivers/media/pci/Kconfig
index 218144a..5c7c356 100644
--- a/drivers/media/pci/Kconfig
+++ b/drivers/media/pci/Kconfig
@@ -46,6 +46,7 @@ source "drivers/media/pci/pt3/Kconfig"
 source "drivers/media/pci/mantis/Kconfig"
 source "drivers/media/pci/ngene/Kconfig"
 source "drivers/media/pci/ddbridge/Kconfig"
+source "drivers/media/pci/prospero/Kconfig"
 source "drivers/media/pci/smipcie/Kconfig"
 endif
 
diff --git a/drivers/media/pci/Makefile b/drivers/media/pci/Makefile
index 0baf0d2..d792604 100644
--- a/drivers/media/pci/Makefile
+++ b/drivers/media/pci/Makefile
@@ -11,6 +11,7 @@ obj-y        +=	ttpci/		\
 		mantis/		\
 		ngene/		\
 		ddbridge/	\
+		prospero/	\
 		saa7146/	\
 		smipcie/
 
@@ -26,4 +27,5 @@ obj-$(CONFIG_VIDEO_SAA7164) += saa7164/
 obj-$(CONFIG_VIDEO_TW68) += tw68/
 obj-$(CONFIG_VIDEO_MEYE) += meye/
 obj-$(CONFIG_STA2X11_VIP) += sta2x11/
+obj-$(CONFIG_PROSPERO) += prospero/
 obj-$(CONFIG_VIDEO_SOLO6X10) += solo6x10/
diff --git a/drivers/media/pci/prospero/Kconfig b/drivers/media/pci/prospero/Kconfig
new file mode 100644
index 0000000..960f370
--- /dev/null
+++ b/drivers/media/pci/prospero/Kconfig
@@ -0,0 +1,7 @@
+config DVB_PROSPERO
+	tristate "Prospero cards"
+	depends on DVB_CORE && PCI
+	help
+      Support for PCIe DVB-T cards from Prospero Technologies Ltd.
+
+	  Say Y or M if you own such a device and want to use it.
diff --git a/drivers/media/pci/prospero/Makefile b/drivers/media/pci/prospero/Makefile
new file mode 100644
index 0000000..ea35912
--- /dev/null
+++ b/drivers/media/pci/prospero/Makefile
@@ -0,0 +1,7 @@
+obj-m := prospero.o
+prospero-objs := prospero_main.o prospero_fe_main.o prospero_i2c.o prospero_ir.o
+
+ccflags-y += -Idrivers/media/common/tuners
+ccflags-y += -Idrivers/media/dvb-core
+ccflags-y += -Idrivers/media/dvb-frontends
+ccflags-y += -Idrivers/media/pci/prospero
diff --git a/drivers/media/pci/prospero/prospero_common.h b/drivers/media/pci/prospero/prospero_common.h
new file mode 100644
index 0000000..f8aece1
--- /dev/null
+++ b/drivers/media/pci/prospero/prospero_common.h
@@ -0,0 +1,264 @@
+#ifndef PROSPERO_COMMON
+
+#define PROSPERO_COMMON
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/mutex.h>
+#include <linux/dma-mapping.h>
+#include <linux/firmware.h>
+#include <linux/kobject.h>
+#include <linux/list.h>
+#include <linux/timer.h>
+
+#include "demux.h"
+#include "dmxdev.h"
+#include "dvb_demux.h"
+#include "dvb_frontend.h"
+#include "dvb_net.h"
+#include "dvbdev.h"
+
+#define MAXIMUM_NUM_OF_FE 8
+
+#define MAX_NUM_OF_DEMUXS 8
+#define DEMUX_PER_FE 1
+
+#define STREAMS_PER_DEMUX 30
+
+#define MAX_STREAMS (STREAMS_PER_DEMUX * MAX_NUM_OF_DEMUXS)
+
+#define WILD_PID 0x2000
+
+#define PROSPERO_REGISTER_BASE 0x000
+
+#define PID_TABLE_START (PROSPERO_REGISTER_BASE + 0x40000)
+
+#define I2C_RESETS  (PROSPERO_REGISTER_BASE + 0x70)
+
+#define TS_CAP_ENABLE (PROSPERO_REGISTER_BASE + 0x74)
+
+#define INTERRUPT_ENABLE  (PROSPERO_REGISTER_BASE + 0x78)
+#define INTERRUPT_CONTROL  (PROSPERO_REGISTER_BASE + 0x40)
+
+#define PID_TABLE_SLOT_SIZE 0x04
+
+#define CONTROL_BITS_OFFSET 0x00
+
+/*Control bit masks*/
+#define NULL_PACKET 0x8
+#define INTERRUPT_ENABLED 0x4
+#define GUARD_VALUE 0x2
+#define CHANNEL_ENABLED 0x1
+
+#define INTERRUPT_FIFO 0x44
+#define GUARD_BAND_FIFO 0x48
+
+#define FIFO_BUFF_PTR_MASK 0x3F
+#define FIFO_TUNER_NUM_MASK 0x700
+#define FIFO_NUM_ENTRIES_MASK 0x1FF0000
+
+#define LED_OFFSET 0x0
+
+#define BUFFER_BASE_ADDRESS 0x04
+#define BUFFER_END_ADDRESS 0x08
+#define GUARD_A 0x0C
+#define INT_TRIGGER_ADDRESS 0x10
+#define CURRENT_WP_A  0x14
+
+#define BUFFER_SLOT_SIZE 0x20
+
+#define BIT_MASK_26 0x3FFFFFF
+#define BIT_MASK_22 0x3FFFFF
+#define BIT_MASK_20 0xFFFFF
+
+#define MAX_PIDS_PER_STREAM 32
+
+#define PIDS_START 1
+
+#define FIRMWARE_VERSION 0x3FC
+
+/*Flash reprogramming registers*/
+#define FLASH_ERASE 0x80
+#define FLASH_WRITE 0x84
+#define FLASH_ADDRESS 0x88
+#define FLASH_DATA 0x90
+#define FLASH_BUSY 0x80
+
+enum card_type {
+	PRO_UNK = 0,
+	PRO_DIBCOM,
+};
+
+struct prospero_fifo {
+	u8 buffer_pointer;
+	u8 tuner_number;
+	u16 num_entries;
+};
+
+struct channel_control_bits {
+
+	bool null_packets;
+	bool interrupt_enabled;
+	bool guard_value_enabled;
+	bool channel_enabled;
+
+};
+
+struct prospero_pid_table {
+
+	int pid;
+	u8 bdp;
+	bool pid_enabled;
+
+};
+
+struct stream_data {
+
+	int buffnum;
+	u32 buffer_base_address;
+	u32 sub_base_address;
+	u32 buffer_end_address;
+	u32 last_read;
+	long byte_count;
+	int pids[MAX_PIDS_PER_STREAM + 1];
+	int active;
+	int serviced;
+	struct dvb_demux_feed *feed;
+
+};
+
+struct stream_link {
+	unsigned long buffer_pointer;
+	int demux_id;
+	int count;
+};
+
+enum fifos {
+	GUARD,
+	INTERRUPT,
+};
+
+struct prospero_i2c_adapter {
+	struct prospero_device *p;
+	struct i2c_adapter i2c_adap;
+
+	u8 no_base_addr;
+	int id;
+	int I2C_Command_reg;
+	int I2C_TxRx_reg;
+
+};
+
+struct prospero_demux {
+	u8 *ts_membuf_ptr;
+	u8 *wildcard_membuf_ptr;
+	dma_addr_t ts_cdma;
+	dma_addr_t wildcard_cdma;
+	int Pid_Table_Offset;
+	int Buffer_Definition_Ram;
+	int buffer1_ptr;
+	int buffer2_ptr;
+	int buffers[MAX_STREAMS];
+	int num_pids;
+};
+
+/* Control structure for data definitions */
+struct prospero_device {
+	/* general */
+	struct device *dev;	/* for firmware_class */
+
+#define P_STATE_DVB_INIT 0x01
+#define P_STATE_I2C_INIT 0x02
+#define P_STATE_FE_INIT  0x04
+	int init_state;
+
+	/* dvb stuff */
+	struct dvb_adapter dvb_adapter;
+	struct dvb_frontend *fe[MAXIMUM_NUM_OF_FE];
+	struct dvb_net dvbnet;
+
+	struct timer_list timer;
+
+	int num_init;
+	int num_demuxs;
+	int num_frontends;
+	int flash_in_progress;
+	int demux_link[MAX_NUM_OF_DEMUXS];
+
+	struct stream_link *stream_links[MAX_STREAMS];
+
+	int command_seqno;
+
+	struct dvb_demux demux[MAX_NUM_OF_DEMUXS];
+	struct dmxdev dmxdev[MAX_NUM_OF_DEMUXS];
+
+	struct dmx_frontend hw_frontend[MAXIMUM_NUM_OF_FE];
+	struct dmx_frontend dmx_only;
+	int (*fe_sleep)(struct dvb_frontend *);
+
+	struct module *owner;
+
+	void *bus_specific;
+
+	struct stream_data *streams[MAX_STREAMS];
+
+	struct prospero_i2c_adapter p_i2c_adap[MAXIMUM_NUM_OF_FE];
+	struct mutex i2c_mutex;
+
+	struct prospero_demux p_demux[MAXIMUM_NUM_OF_FE];
+
+	/*debugging fifo */
+	int sequence_track;
+	int seqstart;
+	int entry_count;
+	int int_buffer;
+	/*end debugging fifo */
+
+	struct prospero_IR *ir;
+
+	int wild_buffer_increment;
+	int wild_interrupt_increment;
+	int channel_buffer_size;
+	int buffer_increment;
+	int interrupt_increment;
+
+};
+
+struct prospero_dma {
+	struct pci_dev *pdev;
+
+	u8 *cpu_addr0;
+	dma_addr_t dma_addr0;
+	u8 *cpu_addr1;
+	dma_addr_t dma_addr1;
+	u32 size;		/* size of each address in bytes */
+};
+
+struct prospero_pci {
+
+	struct pci_dev *pcidev;
+
+#define P_PCI_INIT     0x01
+#define P_PCI_DMA_INIT 0x02
+	int init_state;
+
+	void __iomem *io_mem;
+	void __iomem *BAR0;
+	u32 irq;
+
+	struct prospero_dma dma;
+
+	int count;
+	int count_prev;
+	int stream_problem;
+
+	spinlock_t irq_lock;
+	unsigned long last_irq;
+
+	struct delayed_work irq_check_work;
+	struct prospero_device *p_dev;
+};
+
+#endif
diff --git a/drivers/media/pci/prospero/prospero_fe.h b/drivers/media/pci/prospero/prospero_fe.h
new file mode 100644
index 0000000..c2aefa3
--- /dev/null
+++ b/drivers/media/pci/prospero/prospero_fe.h
@@ -0,0 +1,5 @@
+
+#include <linux/dvb/frontend.h>
+#include "dvb_frontend.h"
+
+extern int prospero_frontend_init(struct prospero_device *p);
diff --git a/drivers/media/pci/prospero/prospero_fe_main.c b/drivers/media/pci/prospero/prospero_fe_main.c
new file mode 100644
index 0000000..65f10d6
--- /dev/null
+++ b/drivers/media/pci/prospero/prospero_fe_main.c
@@ -0,0 +1,466 @@
+/*
+ *  Driver for the frontend modules from Prospero Technology Ltd.
+ *
+ *  Copyright Prospero Technology Ltd. 2014
+ *  Written/Maintained by Philip Downer
+ *  Contact: pdowner@prospero-tech.com
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program;
+ *
+ */
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/mutex.h>
+#include <linux/dma-mapping.h>
+#include <linux/firmware.h>
+#include <linux/kobject.h>
+
+#include "dvb_frontend.h"
+#include "prospero_common.h"
+#include "prospero_fe.h"
+#include "prospero_i2c.h"
+#include "dib7000p.h"
+#include "dib0090.h"
+
+int ADDRESS_TABLE_START = 0x81000;
+
+struct prospero_adapter_state {
+	int (*set_param_save)(struct dvb_frontend *);
+	struct dib7000p_ops dib7000p_ops;
+} pro_state;
+
+static int dib7090_agc_restart(struct dvb_frontend *fe, u8 restart)
+{
+	pr_debug("agc restart\n");
+	/* before AGC startup */
+	if (restart == 0)
+		dib0090_set_dc_servo(fe, 1);
+
+	return 0;
+}
+
+/* NIM7090 */
+struct dib7090p_best_adc {
+	u32 timf;
+	u32 pll_loopdiv;
+	u32 pll_prediv;
+};
+
+static int dib7090p_get_best_sampling(struct dvb_frontend *fe, struct dib7090p_best_adc *adc)
+{
+	u8 spur = 0, prediv = 0, loopdiv = 0, min_prediv = 1, max_prediv = 1;
+
+	u16 xtal = 12000;
+	u32 fcp_min = 1900;	/* PLL Minimum Frequency comparator KHz */
+	u32 fcp_max = 20000;	/* PLL Maximum Frequency comparator KHz */
+	u32 fdem_max = 76000;
+	u32 fdem_min = 69500;
+	u32 fcp = 0, fs = 0, fdem = 0;
+	u32 harmonic_id = 0;
+
+	adc->pll_loopdiv = loopdiv;
+	adc->pll_prediv = prediv;
+	adc->timf = 0;
+
+	pr_debug("bandwidth = %d fdem_min =%d", fe->dtv_property_cache.bandwidth_hz, fdem_min);
+
+	/* Find Min and Max prediv */
+	while ((xtal / max_prediv) >= fcp_min)
+		max_prediv++;
+
+	max_prediv--;
+	min_prediv = max_prediv;
+	while ((xtal / min_prediv) <= fcp_max) {
+		min_prediv--;
+		if (min_prediv == 1)
+			break;
+	}
+	pr_debug("MIN prediv = %d : MAX prediv = %d", min_prediv, max_prediv);
+
+	min_prediv = 2;
+
+	for (prediv = min_prediv; prediv < max_prediv; prediv++) {
+		fcp = xtal / prediv;
+		if (fcp > fcp_min && fcp < fcp_max) {
+			for (loopdiv = 1; loopdiv < 64; loopdiv++) {
+				fdem = ((xtal / prediv) * loopdiv);
+				fs = fdem / 4;
+				/* test min/max system restrictions */
+
+				if ((fdem >= fdem_min) && (fdem <= fdem_max) && (fs >= fe->dtv_property_cache.bandwidth_hz / 1000)) {
+					spur = 0;
+					/* test fs harmonics positions */
+					for (harmonic_id = (fe->dtv_property_cache.frequency / (1000 * fs)); harmonic_id <= ((fe->dtv_property_cache.frequency / (1000 * fs)) + 1); harmonic_id++) {
+						if (((fs * harmonic_id) >= ((fe->dtv_property_cache.frequency / 1000) - (fe->dtv_property_cache.bandwidth_hz / 2000)))
+						    && ((fs * harmonic_id) <= ((fe->dtv_property_cache.frequency / 1000) + (fe->dtv_property_cache.bandwidth_hz / 2000)))) {
+							spur = 1;
+							break;
+						}
+					}
+
+					if (!spur) {
+						adc->pll_loopdiv = loopdiv;
+						adc->pll_prediv = prediv;
+						adc->timf = 2396745143UL / fdem * (1 << 9);
+						adc->timf += ((2396745143UL % fdem) << 9) / fdem;
+						pr_debug("loopdiv=%i prediv=%i timf=%i", loopdiv, prediv, adc->timf);
+						break;
+					}
+				}
+			}
+		}
+		if (!spur)
+			break;
+	}
+
+	if (adc->pll_loopdiv == 0 && adc->pll_prediv == 0)
+		return -EINVAL;
+	else
+		return 0;
+}
+
+static int dib7090_agc_startup(struct dvb_frontend *fe)
+{
+
+	struct dibx000_bandwidth_config pll;
+	u16 target;
+	struct dib7090p_best_adc adc;
+	int ret;
+
+	ret = pro_state.set_param_save(fe);
+	if (ret < 0)
+		return ret;
+
+	memset(&pll, 0, sizeof(struct dibx000_bandwidth_config));
+	dib0090_pwm_gain_reset(fe);
+	target = (dib0090_get_wbd_offset(fe) * 8 + 1) / 2;
+	pro_state.dib7000p_ops.set_wbd_ref(fe, target);
+
+	if (dib7090p_get_best_sampling(fe, &adc) == 0) {
+		pll.pll_ratio = adc.pll_loopdiv;
+		pll.pll_prediv = adc.pll_prediv;
+
+		pro_state.dib7000p_ops.update_pll(fe, &pll);
+		pro_state.dib7000p_ops.ctrl_timf(fe, DEMOD_TIMF_SET, adc.timf);
+	}
+	return 0;
+}
+
+static int dib_update_lna_prospero(struct dvb_frontend *fe, uint16_t agc_gloabl)
+{
+
+	pr_debug("called: UPDATE LNA!\n");
+
+	return 0;
+
+}
+
+static struct dibx000_bandwidth_config dib7090_clock_config_12_mhz = {
+	60000, 15000,
+	1, 5, 0, 0, 0,
+	0, 0, 1, 1, 2,
+	(3 << 14) | (1 << 12) | (524 << 0),
+	(0 << 25) | 0,
+	20452225,
+	15000000,
+};
+
+struct dibx000_agc_config dib7090_agc_config[2] = {
+	{
+	 .band_caps = BAND_UHF,
+	 /* P_agc_use_sd_mod1=0, P_agc_use_sd_mod2=0, P_agc_freq_pwm_div=1, P_agc_inv_pwm1=0, P_agc_inv_pwm2=0,
+	  * P_agc_inh_dc_rv_est=0, P_agc_time_est=3, P_agc_freeze=0, P_agc_nb_est=5, P_agc_write=0 */
+	 .setup = (0 << 15) | (0 << 14) | (5 << 11) | (0 << 10) | (0 << 9) | (0 << 8) | (3 << 5) | (0 << 4) | (5 << 1) | (0 << 0),
+
+	 .inv_gain = 687,
+	 .time_stabiliz = 10,
+
+	 .alpha_level = 0,
+	 .thlock = 118,
+
+	 .wbd_inv = 0,
+	 .wbd_ref = 1200,
+	 .wbd_sel = 3,
+	 .wbd_alpha = 5,
+
+	 .agc1_max = 65535,
+	 .agc1_min = 0,
+
+	 .agc2_max = 65535,
+	 .agc2_min = 0,
+
+	 .agc1_pt1 = 0,
+	 .agc1_pt2 = 32,
+	 .agc1_pt3 = 114,
+	 .agc1_slope1 = 143,
+	 .agc1_slope2 = 144,
+	 .agc2_pt1 = 114,
+	 .agc2_pt2 = 227,
+	 .agc2_slope1 = 116,
+	 .agc2_slope2 = 117,
+
+	 .alpha_mant = 18,
+	 .alpha_exp = 0,
+	 .beta_mant = 20,
+	 .beta_exp = 59,
+
+	 .perform_agc_softsplit = 0,
+	 }, {
+	     .band_caps = BAND_FM | BAND_VHF | BAND_CBAND,
+	     /* P_agc_use_sd_mod1=0, P_agc_use_sd_mod2=0, P_agc_freq_pwm_div=1, P_agc_inv_pwm1=0, P_agc_inv_pwm2=0,
+	      * P_agc_inh_dc_rv_est=0, P_agc_time_est=3, P_agc_freeze=0, P_agc_nb_est=5, P_agc_write=0 */
+	     .setup = (0 << 15) | (0 << 14) | (5 << 11) | (0 << 10) | (0 << 9) | (0 << 8) | (3 << 5) | (0 << 4) | (5 << 1) | (0 << 0),
+
+	     .inv_gain = 732,
+	     .time_stabiliz = 10,
+
+	     .alpha_level = 0,
+	     .thlock = 118,
+
+	     .wbd_inv = 0,
+	     .wbd_ref = 1200,
+	     .wbd_sel = 3,
+	     .wbd_alpha = 5,
+
+	     .agc1_max = 65535,
+	     .agc1_min = 0,
+
+	     .agc2_max = 65535,
+	     .agc2_min = 0,
+
+	     .agc1_pt1 = 0,
+	     .agc1_pt2 = 0,
+	     .agc1_pt3 = 98,
+	     .agc1_slope1 = 0,
+	     .agc1_slope2 = 167,
+	     .agc2_pt1 = 98,
+	     .agc2_pt2 = 255,
+	     .agc2_slope1 = 104,
+	     .agc2_slope2 = 0,
+
+	     .alpha_mant = 18,
+	     .alpha_exp = 0,
+	     .beta_mant = 20,
+	     .beta_exp = 59,
+
+	     .perform_agc_softsplit = 0,
+	     }
+};
+
+static struct dib7000p_config nim7090_dib7000p_config = {
+	.output_mpeg2_in_188_bytes = 1,
+	.hostbus_diversity = 1,
+	.tuner_is_baseband = 1,
+	.update_lna = dib_update_lna_prospero,
+
+	.agc_config_count = 2,
+	.agc = dib7090_agc_config,
+
+	.bw = &dib7090_clock_config_12_mhz,
+
+	.gpio_dir = DIB7000P_GPIO_DEFAULT_DIRECTIONS,
+	.gpio_val = DIB7000P_GPIO_DEFAULT_VALUES,
+	.gpio_pwm_pos = DIB7000P_GPIO_DEFAULT_PWM_POS,
+
+	.pwm_freq_div = 0,
+
+	.agc_control = dib7090_agc_restart,
+
+	.spur_protect = 0,
+	.disable_sample_and_hold = 0,
+	.enable_current_mirror = 0,
+	.diversity_delay = 0,
+
+	.output_mode = OUTMODE_MPEG2_SERIAL,
+	.enMpegOutput = 1,
+	.default_i2c_addr = 0x20,
+};
+
+static struct dib0090_wbd_slope dib7090_wbd_table[] = {
+	{380, 81, 850, 64, 540, 4},
+	{860, 51, 866, 21, 375, 4},
+	{1700, 0, 250, 0, 100, 6},
+	{2600, 0, 250, 0, 100, 6},
+	{0xFFFF, 0, 0, 0, 0, 0},
+};
+
+static struct dib0090_config nim7090_dib0090_config = {
+	.io.clock_khz = 12000,
+	.io.pll_bypass = 0,
+	.io.pll_range = 0,
+	.io.pll_prediv = 3,
+	.io.pll_loopdiv = 6,
+	.io.adc_clock_ratio = 0,
+	.io.pll_int_loop_filt = 0,
+
+	.freq_offset_khz_uhf = 0,
+	.freq_offset_khz_vhf = 0,
+
+	.clkouttobamse = 1,
+	.analog_output = 0,
+
+	.wbd_vhf_offset = 0,
+	.wbd_cband_offset = 0,
+	.use_pwm_agc = 1,
+	.clkoutdrive = 0,
+
+	.fref_clock_ratio = 0,
+
+	.wbd = dib7090_wbd_table,
+
+	.ls_cfg_pad_drv = 0,
+	.data_tx_drv = 0,
+	.low_if = NULL,
+	.in_soc = 1,
+};
+
+int prodib_fe_attach(struct i2c_adapter *i2c_adap, int fenum)
+{
+
+	struct prospero_i2c_adapter *p_i2c = i2c_get_adapdata(i2c_adap);
+	struct prospero_device *p = p_i2c->p;
+
+	pr_debug("attach dibcom as fe %d\n", fenum);
+
+	if (!dvb_attach(dib7000p_attach, &pro_state.dib7000p_ops))
+		return -ENODEV;
+
+	p->p_demux[fenum].num_pids = PIDS_START;
+	p->p_demux[fenum].Pid_Table_Offset = PROSPERO_REGISTER_BASE + PID_TABLE_START + (fenum * 0x8000);
+	p->p_demux[fenum].Buffer_Definition_Ram = p->p_demux[fenum].Pid_Table_Offset + 0x4000;
+	p->p_demux[fenum].buffer1_ptr = ADDRESS_TABLE_START + (fenum * 0x8) + (fenum * 0x8);
+	p->p_demux[fenum].buffer2_ptr = p->p_demux[fenum].buffer1_ptr + 0x8;
+
+	if (pro_state.dib7000p_ops.i2c_enumeration(i2c_adap, 1, 0x20, &nim7090_dib7000p_config) != 0) {
+		dev_info(p->dev, "%s: state->dib7000p_ops.i2c_enumeration failed.  Cannot continue\n", __func__);
+		/*dvb_detach(&pro_state.dib7000p_ops);*/
+		return -ENODEV;
+	}
+
+	p->fe[fenum] = pro_state.dib7000p_ops.init(i2c_adap, 0x80, &nim7090_dib7000p_config);
+
+	dev_info(p->dev, "successfully attached the dib7000\n");
+
+	pr_debug("fe pointer = %p\n", p->fe[fenum]);
+	pr_debug("sub i2c driver = %p\n", (&i2c_adap->dev)->p);
+
+	return p->fe[fenum] == NULL ? -ENODEV : 0;
+
+}
+
+static int prodib_tuner_attach(struct i2c_adapter *i2c_adap, int fenum)
+{
+	struct prospero_i2c_adapter *p_i2c = i2c_get_adapdata(i2c_adap);
+	struct prospero_device *p = p_i2c->p;
+
+	struct i2c_adapter *tun_i2c = pro_state.dib7000p_ops.get_i2c_tuner(p->fe[fenum]);
+
+	if (dvb_attach(dib0090_register, p->fe[fenum], tun_i2c, &nim7090_dib0090_config) == NULL)
+		return -ENODEV;
+
+	pro_state.dib7000p_ops.set_gpio(p->fe[fenum], 8, 0, 1);
+
+	pro_state.set_param_save = p->fe[fenum]->ops.tuner_ops.set_params;
+	p->fe[fenum]->ops.tuner_ops.set_params = dib7090_agc_startup;
+	return 0;
+}
+
+static struct {
+	enum card_type type;
+	int (*attach)(struct i2c_adapter *i2c_adap, int fenum);
+	int (*tuner_attach)(struct i2c_adapter *i2c_adap, int fenum);
+
+} prospero_frontends[] = {
+	{
+	PRO_DIBCOM, prodib_fe_attach, prodib_tuner_attach}
+};
+
+int prospero_frontend_init(struct prospero_device *p)
+{
+
+	int ret = 0;
+	int i = 0;
+	int x = 0;
+
+	struct prospero_pci *p_pci = p->bus_specific;
+
+	p->num_frontends = 0;
+
+	pr_debug("reset all tuners\n");
+	iowrite8(0xFF, p_pci->io_mem + I2C_RESETS);
+	usleep_range(5000, 10000);
+	iowrite8(0x00, p_pci->io_mem + I2C_RESETS);
+	usleep_range(5000, 10000);
+	iowrite8(0xFF, p_pci->io_mem + I2C_RESETS);
+	pr_debug("finished high low high reset");
+	usleep_range(5000, 10000);
+
+	for (i = 0; i < MAXIMUM_NUM_OF_FE; i++) {
+		for (x = 0; x < ARRAY_SIZE(prospero_frontends); x++) {
+			usleep_range(1000, 5000);
+
+			if (prospero_frontends[x].attach(&p->p_i2c_adap[i].i2c_adap, i) < 0) {
+				pr_debug("detach fe\n");
+				if (p->fe[i]) {
+					dvb_frontend_detach(p->fe[i]);
+					p->fe[i] = NULL;
+				}
+				continue;
+			}
+
+			pr_debug("fe attached\n");
+
+			p->fe[i]->id = i;
+
+			ret = dvb_register_frontend(&p->dvb_adapter, p->fe[i]);
+			if (ret < 0)
+				goto exit;
+
+			if (prospero_frontends[x].tuner_attach(&p->p_i2c_adap[i].i2c_adap, i) < 0) {
+				dev_info(p->dev, "tuner init for fe %d failed, detach fe\n", i);
+				if (p->fe[i]) {
+					dvb_frontend_detach(p->fe[i]);
+					p->fe[i] = NULL;
+				}
+				continue;
+
+			}
+
+			p->num_frontends++;
+			break;
+
+		}
+	}
+
+	return ret;
+
+ exit:
+	dvb_unregister_frontend(p->fe[i]);
+	dvb_frontend_detach(p->fe[i]);
+	if (p->num_frontends > 0) {
+		dev_info(p->dev, "found %d DVB frontends\n", p->num_frontends);
+		return 0;
+	}
+
+	return -1;
+
+}
+EXPORT_SYMBOL(prospero_frontend_init);
+
+MODULE_DESCRIPTION("Prospero Frontend");
+MODULE_AUTHOR("Philip Downer");
+MODULE_LICENSE("GPL");
diff --git a/drivers/media/pci/prospero/prospero_i2c.c b/drivers/media/pci/prospero/prospero_i2c.c
new file mode 100644
index 0000000..831197d
--- /dev/null
+++ b/drivers/media/pci/prospero/prospero_i2c.c
@@ -0,0 +1,449 @@
+/*
+ *  I2c driver for PCIe DVB cards from Prospero Technology Ltd.
+ *
+ *  Copyright Prospero Technology Ltd. 2014
+ *  Written/Maintained by Philip Downer
+ *  Contact: pdowner@prospero-tech.com
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program;
+ *
+ */
+
+#include "prospero_i2c.h"
+
+#include <linux/delay.h>
+
+MODULE_LICENSE("GPL");
+
+#define I2C_COMMAND_START	    0x01
+#define I2C_COMMAND_WRITE	    0x02
+#define I2C_COMMAND_READ_ACK	    0x04
+#define I2C_COMMAND_STOP	    0x08
+#define I2C_COMMAND_READ_NACK       0x10
+
+static void read_i2c_command(uint8_t *buffer, struct i2c_adapter *i2c_adap)
+{
+	struct prospero_pci *p_pci;
+	int offset;
+	struct prospero_i2c_adapter *p_i2c = i2c_get_adapdata(i2c_adap);
+
+	p_pci = p_i2c->p->bus_specific;
+	offset = p_i2c->I2C_Command_reg;
+
+	*buffer = (ioread8(p_pci->io_mem + offset) & 0x30);
+	pr_debug("ctrl: i2c command (reg %x) is set to: %d\n", offset, *buffer);
+
+}
+
+static void write_i2c_command(uint8_t command, struct i2c_adapter *i2c_adap)
+{
+
+	struct prospero_i2c_adapter *p_i2c = i2c_get_adapdata(i2c_adap);
+	struct prospero_pci *p_pci = p_i2c->p->bus_specific;
+	int offset = p_i2c->I2C_Command_reg;
+
+	pr_debug("ctrl: user wrote %x to i2c command (reg %x)\n", command, offset);
+
+	iowrite8(command, p_pci->io_mem + offset);
+
+}
+
+static void write_i2c_write(uint8_t command, struct i2c_adapter *i2c_adap)
+{
+	struct prospero_i2c_adapter *p_i2c = i2c_get_adapdata(i2c_adap);
+	struct prospero_pci *p_pci = p_i2c->p->bus_specific;
+	int offset = p_i2c->I2C_TxRx_reg;
+
+	pr_debug("user wrote %x to i2c write (reg %x)\n", command, offset);
+
+	iowrite8(command, p_pci->io_mem + offset);
+
+}
+
+static void read_i2c_read(uint8_t *buffer, struct i2c_adapter *i2c_adap)
+{
+	struct prospero_i2c_adapter *p_i2c = i2c_get_adapdata(i2c_adap);
+	struct prospero_pci *p_pci = p_i2c->p->bus_specific;
+	int offset = p_i2c->I2C_TxRx_reg;
+
+	*buffer = ioread8(p_pci->io_mem + offset);
+
+	pr_debug("i2c read (reg %x) is set to: %d\n", offset, *buffer);
+
+}
+
+bool busy_wait(struct i2c_adapter *i2c_adap)
+{
+	uint8_t rByte;
+	uint8_t busy = 0x10;
+	uint8_t device_busy;
+
+	int count;
+
+	for (count = 0; count < 20; count++) {
+		read_i2c_command(&rByte, i2c_adap);
+		device_busy = rByte & busy;
+
+		if (device_busy == 0)
+			return true;
+
+		udelay(200);
+
+	}
+
+	return false;
+
+}
+
+static void StartI2C(struct i2c_adapter *i2c_adap)
+{
+	pr_debug("i2cdbg: Send Start Bit\n");
+
+	/* there needs to be at least a 40 microsecond delay
+	here or the dibcom 7090 can miss the start bit
+	in a conversation */
+	udelay(40);
+	write_i2c_command(I2C_COMMAND_START, i2c_adap);
+
+}
+
+static void StopI2C(struct i2c_adapter *i2c_adap)
+{
+	pr_debug("i2cdbg: Send Stop Bit\n");
+	write_i2c_command(I2C_COMMAND_STOP, i2c_adap);
+}
+
+bool CheckTransferOk(struct i2c_adapter *i2c_adap)
+{
+	uint8_t rByte;
+	uint8_t error = 0x20;
+	bool RetVal;
+
+	RetVal = false;
+	read_i2c_command(&rByte, i2c_adap);
+	if ((rByte & error) == 0)
+		RetVal = true;
+
+	return RetVal;
+}
+
+bool WriteToWire(uint8_t tuner, uint8_t Data, struct i2c_adapter *i2c_adap)
+{
+	bool RetVal;
+
+	RetVal = false;
+	pr_debug("i2cdbg: write 0x%x\n", Data);
+
+	write_i2c_write(Data, i2c_adap);
+	write_i2c_command(I2C_COMMAND_WRITE, i2c_adap);
+	if (busy_wait(i2c_adap) && (CheckTransferOk(i2c_adap)))
+		RetVal = true;
+
+	return RetVal;
+}
+
+bool ReadFromWire(uint8_t *buffer, struct i2c_adapter *i2c_adap, bool ack)
+{
+	bool RetVal;
+	int command = I2C_COMMAND_READ_NACK;
+
+	RetVal = false;
+
+	if (ack)
+		command = I2C_COMMAND_READ_ACK;
+
+	write_i2c_command(command, i2c_adap);
+	if (busy_wait(i2c_adap) && (CheckTransferOk(i2c_adap))) {
+		read_i2c_read(buffer, i2c_adap);
+		RetVal = true;
+	}
+
+	pr_debug("i2cdbg: read 0x%x\n", *buffer);
+	return RetVal;
+}
+
+bool WriteToI2c_msg(u8 addr, uint8_t *buffer, uint8_t len, struct i2c_adapter *i2c_adap)
+{
+
+	uint8_t Cnt;
+	uint8_t tuner;
+	bool RetVal;
+	char dstring[50] = "0x";
+	char tstring[7];
+	char vstring[50] = "0x";
+
+	RetVal = false;
+	tuner = 0x0;
+
+	if (busy_wait(i2c_adap)) {
+		RetVal = false;
+		StartI2C(i2c_adap);
+		if (WriteToWire(tuner, addr, i2c_adap)) {
+
+			for (Cnt = 0; Cnt < len; Cnt++) {
+				sprintf(tstring, "%02x", buffer[Cnt]);
+
+				if (Cnt < 2)
+					strcat(dstring, tstring);
+				else
+					strcat(vstring, tstring);
+
+				if (!WriteToWire(tuner, buffer[Cnt], i2c_adap)) {
+					StopI2C(i2c_adap);
+					break;
+				}
+			}
+			StopI2C(i2c_adap);
+			RetVal = true;
+		}
+	}
+	pr_debug("i2cdbg2: wrote to reg %s value %s i2c address 0x%x\n", dstring, vstring, addr);
+
+	return RetVal;
+}
+
+bool WriteToI2cImmediate(u8 iDeviceAddr, u8 *bData, uint8_t len, struct i2c_adapter *i2c_adap)
+{
+	uint8_t Cnt;
+	uint8_t tuner = 0x0;
+	bool RetVal;
+	char dstring[50] = "0x";
+	char tstring[7];
+	char vstring[50] = "0x";
+
+	RetVal = false;
+
+	StartI2C(i2c_adap);
+	if (WriteToWire(tuner, iDeviceAddr, i2c_adap)) {
+		for (Cnt = 0; Cnt < len; Cnt++) {
+			sprintf(tstring, "%02x", bData[Cnt]);
+
+			if (Cnt < 2)
+				strcat(dstring, tstring);
+			else
+				strcat(vstring, tstring);
+
+			RetVal = false;
+			if (WriteToWire(tuner, bData[Cnt], i2c_adap))
+				RetVal = true;
+
+			if (!RetVal)
+				break;
+		}
+	}
+
+	StopI2C(i2c_adap);
+	pr_debug("i2cdbg2: wrote to reg %s value %s i2c address 0x%x\n", dstring, vstring, iDeviceAddr);
+
+	return RetVal;
+}
+
+static int ReadFromI2cImmediate(u8 iDeviceAddr, u8 regAddr, u8 *bBuffer, u8 len, struct i2c_adapter *i2c_adap)
+{
+	uint8_t tuner = 0x0;
+	int RetVal = -1;
+
+	StartI2C(i2c_adap);
+
+	if (!WriteToWire(tuner, iDeviceAddr, i2c_adap))
+		goto exit;
+
+	if (!WriteToWire(tuner, regAddr, i2c_adap))
+		goto exit;
+
+	StartI2C(i2c_adap);
+
+	if (!WriteToWire(tuner, iDeviceAddr | 0x01, i2c_adap))
+		goto exit;
+
+	if (!ReadFromWire(&bBuffer[0], i2c_adap, 0))
+		goto exit;
+
+	StopI2C(i2c_adap);
+	RetVal = 1;
+
+ exit:
+	pr_debug("i2cdbg2: *immediate* Read 0x%02x from %02x i2c address %02x; retval = %d",
+		bBuffer[0], regAddr, iDeviceAddr, RetVal);
+	return RetVal;
+}
+
+static int ReadFromI2c_msg(u8 addr, u8 *uRegIndex, u8 *buffer, u8 len, struct i2c_adapter *i2c_adap)
+{
+
+	/*16 bit register address read routine*/
+	bool ack = 0;
+	u8 Cnt = -1;
+	u8 tuner = 0x0;
+	bool RetVal;
+
+	RetVal = false;
+
+	if (!busy_wait(i2c_adap))
+		goto exit;
+
+	StartI2C(i2c_adap);
+
+	if (!WriteToWire(tuner, addr, i2c_adap))
+		goto exit;
+
+	if (!WriteToWire(tuner, uRegIndex[0], i2c_adap))
+		goto exit;
+
+	if (!WriteToWire(tuner, uRegIndex[1], i2c_adap))
+		goto exit;
+
+	StopI2C(i2c_adap);
+
+	StartI2C(i2c_adap);
+
+	if (!WriteToWire(tuner, addr | 0x01, i2c_adap))
+		goto exit;
+
+	for (Cnt = 0; Cnt < len; Cnt++) {
+		if (Cnt < (len - 1)) {
+									/* send an ack if we aren't finished reading*/
+			ack = 1;
+		} else {
+			ack = 0;
+		}
+
+		if (ReadFromWire(&buffer[Cnt], i2c_adap, ack))
+			pr_debug("RFI: 7\n");
+		else
+			break;
+
+	}
+
+
+ exit:
+	if (Cnt == 2)
+		pr_debug("i2cdbg2: Read 0x%02x%02x from 0x%02x%02x i2c address 0x%02x\n", buffer[0], buffer[1], uRegIndex[0], uRegIndex[1], addr);
+
+	return Cnt;
+}
+
+static int prospero_i2c_msg(int busywait, struct i2c_adapter *i2c_adap, uint8_t addr, uint8_t *wbuf, u16 wlen, uint8_t *rbuf, u16 rlen)
+{
+	int wo = (rbuf == NULL || rlen == 0);
+	int retval = -1;
+
+	if (wo) {
+		if (busywait)
+			retval = WriteToI2c_msg(addr, wbuf, wlen, i2c_adap);
+		else
+			retval = WriteToI2cImmediate(addr, wbuf, wlen, i2c_adap);
+
+		pr_debug("i2c: wrote 0x%x to i2c to address 0x%x\n", *wbuf, addr);
+
+	} else {
+		if (busywait)
+			retval = ReadFromI2c_msg(addr, wbuf, rbuf, rlen, i2c_adap);
+		else
+			retval = ReadFromI2cImmediate(addr, *wbuf, rbuf, rlen, i2c_adap);
+
+	}
+	return retval;
+}
+
+/* master xfer callback for demodulator */
+static int prospero_master_xfer(struct i2c_adapter *i2c_adap, struct i2c_msg msgs[], int num)
+{
+	struct prospero_i2c_adapter *i2c = i2c_get_adapdata(i2c_adap);
+	int i;
+
+	for (i = 0; i < num; i++) {
+		if (i + 1 < num && (msgs[i].flags & I2C_M_RD) == 0 && (msgs[i + 1].flags & I2C_M_RD)) {
+			/* reading */
+			if ((msgs[i].flags & I2C_M_IGNORE_NAK) || (msgs[i + 1].flags & I2C_M_IGNORE_NAK)) {
+				if (prospero_i2c_msg(0, i2c_adap, msgs[i].addr, msgs[i].buf, msgs[i].len, msgs[i + 1].buf, msgs[i + 1].len) < 0)
+					break;
+
+			} else {
+
+				if (prospero_i2c_msg(1, i2c_adap, msgs[i].addr, msgs[i].buf, msgs[i].len, msgs[i + 1].buf, msgs[i + 1].len) < 0)
+					break;
+
+			}
+
+			i = i + 2;	/* skip the following message */
+
+		} else {
+			/* writing */
+			if (msgs[i].flags & I2C_M_IGNORE_NAK) {
+				if (prospero_i2c_msg(0, i2c_adap, msgs[i].addr, msgs[i].buf, msgs[i].len, NULL, 0) < 0)
+					break;
+
+			} else {
+				if (prospero_i2c_msg(1, i2c_adap, msgs[i].addr, msgs[i].buf, msgs[i].len, NULL, 0) < 0)
+					break;
+
+			}
+		}
+	}
+
+	mutex_unlock(&i2c->p->i2c_mutex);
+
+	return (i - 1);
+}
+
+static u32 prospero_i2c_func(struct i2c_adapter *adapter)
+{
+	return I2C_FUNC_I2C;
+}
+
+static struct i2c_algorithm prospero_algo = {
+	.master_xfer = prospero_master_xfer,
+	.functionality = prospero_i2c_func,
+};
+
+int prospero_i2c_init(struct prospero_device *p)
+{
+	int ret;
+	int i;
+
+	mutex_init(&p->i2c_mutex);
+
+	for (i = 0; i < MAXIMUM_NUM_OF_FE; i++) {
+
+		p->p_i2c_adap[i].p = p;
+
+		strlcpy(p->p_i2c_adap[i].i2c_adap.name, "Prospero I2C to demod", sizeof(p->p_i2c_adap[i].i2c_adap.name));
+
+		i2c_set_adapdata(&p->p_i2c_adap[i].i2c_adap, &p->p_i2c_adap[i]);
+
+		p->p_i2c_adap[i].i2c_adap.algo = &prospero_algo;
+		p->p_i2c_adap[i].i2c_adap.algo_data = NULL;
+		p->p_i2c_adap[i].i2c_adap.dev.parent = p->dev;
+
+		p->p_i2c_adap[i].I2C_Command_reg = PROSPERO_REGISTER_BASE + (i * 8);
+		p->p_i2c_adap[i].I2C_TxRx_reg = p->p_i2c_adap[i].I2C_Command_reg + 0x04;
+
+		ret = i2c_add_adapter(&p->p_i2c_adap[i].i2c_adap);
+		if (ret < 0)
+			return ret;
+
+	}
+
+	p->init_state |= P_STATE_I2C_INIT;
+	return 0;
+}
+
+void prospero_i2c_exit(struct prospero_device *p)
+{
+	if (p->init_state & P_STATE_I2C_INIT)
+		i2c_del_adapter(&p->p_i2c_adap[0].i2c_adap);
+
+	p->init_state &= ~P_STATE_I2C_INIT;
+}
diff --git a/drivers/media/pci/prospero/prospero_i2c.h b/drivers/media/pci/prospero/prospero_i2c.h
new file mode 100644
index 0000000..19f65d2
--- /dev/null
+++ b/drivers/media/pci/prospero/prospero_i2c.h
@@ -0,0 +1,3 @@
+#include "prospero_common.h"
+
+int prospero_i2c_init(struct prospero_device *p);
diff --git a/drivers/media/pci/prospero/prospero_ir.c b/drivers/media/pci/prospero/prospero_ir.c
new file mode 100644
index 0000000..01e5204
--- /dev/null
+++ b/drivers/media/pci/prospero/prospero_ir.c
@@ -0,0 +1,150 @@
+/*
+ *  Infra-red driver for PCIe DVB cards from Prospero Technology Ltd.
+ *
+ *  Copyright Prospero Technology Ltd. 2014
+ *  Written/Maintained by Philip Downer
+ *  Contact: pdowner@prospero-tech.com
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ */
+
+#include <media/rc-core.h>
+#include "prospero_ir.h"
+
+#define DURATION_MASK 0x7FFFF
+#define PULSE_MASK 0x1000000
+#define FIFO_FILL_MASK 0xFF
+
+#define FIFO_FILL 0x60
+#define FIFO 0x64
+
+struct prospero_IR {
+	struct prospero_device *pdev;
+	struct rc_dev *dev;
+
+	int users;
+
+	char name[32];
+	char phys[32];
+};
+
+static int prospero_ir_open(struct rc_dev *rc)
+{
+	struct prospero_device *p = rc->priv;
+
+	p->ir->users++;
+	return 0;
+
+}
+
+static void prospero_ir_close(struct rc_dev *rc)
+{
+	struct prospero_device *p = rc->priv;
+
+	p->ir->users--;
+
+}
+
+void ir_interrupt(struct prospero_pci *p_pci)
+{
+
+	struct prospero_device *p = p_pci->p_dev;
+	struct prospero_IR *ir = p->ir;
+	struct ir_raw_event ev;
+	int tmp = 0;
+	int fill = 0;
+	int pulse = 0;
+	int duration = 0;
+
+	pr_debug("Infra: Interrupt!\n");
+
+	tmp = ioread32(p_pci->io_mem + FIFO_FILL);
+	fill = tmp & FIFO_FILL_MASK;
+
+	init_ir_raw_event(&ev);
+
+	while (fill > 0) {
+
+		pr_debug("Infra: fifo fill = %d\n", fill);
+
+		tmp = ioread32(p_pci->io_mem + FIFO);
+		pr_debug("Infra: raw dump = 0x%x\n", tmp);
+		pulse = (tmp & PULSE_MASK) >> 24;
+		duration = (tmp & DURATION_MASK) * 1000;	/* Convert uS to nS */
+
+		pr_debug("Infra: pulse = %d; duration = %d\n", pulse, duration);
+
+		ev.pulse = pulse;
+		ev.duration = duration;
+		ir_raw_event_store_with_filter(ir->dev, &ev);
+		fill--;
+	}
+	ir_raw_event_handle(ir->dev);
+
+}
+
+int prospero_ir_init(struct prospero_device *p)
+{
+
+	struct prospero_pci *p_pci = p->bus_specific;
+	struct pci_dev *pci = p_pci->pcidev;
+	struct prospero_IR *ir;
+	struct rc_dev *dev;
+	int err = -ENOMEM;
+
+	ir = kzalloc(sizeof(*ir), GFP_KERNEL);
+
+	dev = rc_allocate_device();
+
+	if (!ir || !dev)
+		goto err_out_free;
+
+	ir->dev = dev;
+
+	snprintf(ir->name, sizeof(ir->name), "prospero IR");
+	snprintf(ir->phys, sizeof(ir->phys), "pci-%s/ir0", pci_name(pci));
+
+	dev->input_name = ir->name;
+	dev->input_phys = ir->phys;
+	dev->input_id.bustype = BUS_PCI;
+	dev->input_id.version = 1;
+	dev->input_id.vendor = pci->vendor;
+	dev->input_id.product = pci->device;
+
+	dev->dev.parent = &pci->dev;
+	dev->map_name = RC_MAP_LIRC;
+
+	dev->driver_name = "prospero";
+	dev->priv = p;
+	dev->open = prospero_ir_open;
+	dev->close = prospero_ir_close;
+	dev->driver_type = RC_DRIVER_IR_RAW;
+	dev->timeout = 10 * 1000 * 1000;
+
+	iowrite32(0x12000, p_pci->io_mem + FIFO_FILL);
+
+	ir->pdev = p;
+	p->ir = ir;
+
+	err = rc_register_device(dev);
+	if (err)
+		goto err_out_free;
+
+	return 0;
+
+ err_out_free:
+	rc_free_device(dev);
+	p->ir = NULL;
+	kfree(ir);
+	return -ENOMEM;
+
+}
diff --git a/drivers/media/pci/prospero/prospero_ir.h b/drivers/media/pci/prospero/prospero_ir.h
new file mode 100644
index 0000000..fa8cee3
--- /dev/null
+++ b/drivers/media/pci/prospero/prospero_ir.h
@@ -0,0 +1,4 @@
+#include "prospero_common.h"
+
+void ir_interrupt(struct prospero_pci *p_pci);
+int prospero_ir_init(struct prospero_device *p);
diff --git a/drivers/media/pci/prospero/prospero_main.c b/drivers/media/pci/prospero/prospero_main.c
new file mode 100644
index 0000000..89a1dd2
--- /dev/null
+++ b/drivers/media/pci/prospero/prospero_main.c
@@ -0,0 +1,2086 @@
+/*
+ *  Driver for PCIe DVB cards from Prospero Technology Ltd.
+ *
+ *  Copyright Prospero Technology Ltd. 2014
+ *  Written/Maintained by Philip Downer
+ *  Contact: pdowner@prospero-tech.com
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ */
+
+#include <linux/interrupt.h>
+#include <linux/dma-mapping.h>
+#include <linux/time.h>
+#include <asm/byteorder.h>
+#include <linux/kfifo.h>
+#include <linux/errno.h>
+
+#include "prospero_common.h"
+#include "prospero_fe.h"
+#include "prospero_i2c.h"
+#include "prospero_ir.h"
+
+DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
+
+static struct prospero_device *pro;
+
+MODULE_LICENSE("GPL");
+
+#define P_LOG_PREFIX "prospero"
+
+#define DRIVER_VERSION "0.1"
+#define DRIVER_NAME "Prospero Technologies Digital Video Broadcast PCI Driver"
+#define DRIVER_AUTHOR "Philip Downer <pdowner@prospero-tech.com>"
+
+#define DMX_WRITE_LOCATION 0x58
+#define DMX_WRITE_CTRL 0x5C
+
+int DVB_INT_STATUS_MASK = 0x1;
+int IR_INT_FIFO_FILLING_MASK = 0x2;
+int IR_INT_TIMEOUT_MASK = 0x4;
+int PCI_INTERRUPTS = 0x80050;
+
+int ts_buffer_size = 4194304;
+int wildcard_buffer_size = 1048476;
+
+module_param(ts_buffer_size, int, 0);
+MODULE_PARM_DESC(ts_buffer_size, "Change the transport stream buffer size.");
+
+module_param(wildcard_buffer_size, int, 0);
+MODULE_PARM_DESC(wildcard_buffer_size, "Change the wildcard transport stream buffer size.");
+
+struct prospero_device *prospero_device_kmalloc(size_t bus_specific_len)
+{
+	void *bus;
+	struct prospero_device *p = kzalloc(sizeof(struct prospero_device),
+					    GFP_KERNEL);
+	if (!p)
+		return NULL;
+
+	bus = kzalloc(bus_specific_len, GFP_KERNEL);
+	if (!bus) {
+		kfree(p);
+		return NULL;
+	}
+
+	p->bus_specific = bus;
+
+	return p;
+}
+
+static int prospero_get_fifo(struct device *dev, struct prospero_fifo *fifo, enum fifos fifo_type)
+{
+
+	struct prospero_device *pdev = dev_get_drvdata(dev);
+
+	struct prospero_pci *p_pci = pdev->bus_specific;
+
+	int offset;
+
+	u32 tmp;
+
+	switch (fifo_type) {
+	case GUARD:
+		pr_debug("guard fifo read\n");
+		offset = GUARD_BAND_FIFO;
+		break;
+	case INTERRUPT:
+		pr_debug("interrupt fifo read\n");
+		offset = INTERRUPT_FIFO;
+		break;
+	default:
+		return -EIO;
+	};
+
+	tmp = ioread32(p_pci->io_mem + offset);
+
+	fifo->buffer_pointer = tmp & FIFO_BUFF_PTR_MASK;
+	fifo->tuner_number = ((tmp & FIFO_TUNER_NUM_MASK) >> 8);
+	fifo->num_entries = (tmp & FIFO_NUM_ENTRIES_MASK) >> 16;
+
+	return 0;
+
+}
+
+static int prospero_get_buffer_details(struct device *dev, int buffnum, u32 *buf, u8 buf_offset, int stream_id)
+{
+
+	struct prospero_device *pdev = dev_get_drvdata(dev);
+	struct prospero_pci *p_pci = pdev->bus_specific;
+	struct stream_link *stream_l = pdev->stream_links[stream_id];
+	int demux_id = stream_l->demux_id;
+	int fenum = pdev->demux_link[demux_id];
+	int offset = pdev->p_demux[fenum].Buffer_Definition_Ram + (CONTROL_BITS_OFFSET + (BUFFER_SLOT_SIZE * buffnum)) + buf_offset;
+
+	*buf = (ioread32(p_pci->io_mem + offset));
+	return 0;
+
+}
+
+static int prospero_set_buffer_details(struct device *dev, u32 buf, u8 buf_offset, int stream_id)
+{
+
+	struct prospero_device *pdev = dev_get_drvdata(dev);
+	struct prospero_pci *p_pci = pdev->bus_specific;
+	struct stream_link *stream_l = pdev->stream_links[stream_id];
+	int demux_id = stream_l->demux_id;
+	int fenum = pdev->demux_link[demux_id];
+	int buffnum = pdev->streams[stream_id]->buffnum;
+	int offset = pdev->p_demux[fenum].Buffer_Definition_Ram + (CONTROL_BITS_OFFSET + (BUFFER_SLOT_SIZE * buffnum)) + buf_offset;
+
+	iowrite32(buf, p_pci->io_mem + offset);
+	pr_debug("set buffer_details at offset %x to %x\n", offset, buf);
+	return 0;
+
+}
+
+static int prospero_get_buffer_base_address(struct device *dev, u32 *buf, int stream_id)
+{
+
+	struct prospero_device *pdev = dev_get_drvdata(dev);
+	struct prospero_pci *p_pci = pdev->bus_specific;
+	struct stream_link *stream_l = pdev->stream_links[stream_id];
+	int demux_id = stream_l->demux_id;
+	int fenum = pdev->demux_link[demux_id];
+	u32 tmp;
+	int buffnum = pdev->streams[stream_id]->buffnum;
+	int offset = pdev->p_demux[fenum].Buffer_Definition_Ram + (CONTROL_BITS_OFFSET + (BUFFER_SLOT_SIZE * buffnum)) + BUFFER_BASE_ADDRESS;
+
+	tmp = (ioread32(p_pci->io_mem + offset));
+
+	*buf = tmp & BIT_MASK_26;
+
+	pr_debug("buffer_base_address(%p) = %x\n", p_pci->io_mem + offset, *buf);
+
+	return 0;
+
+}
+
+static int prospero_set_buffer_base_address(struct device *dev, u32 buf, int stream_id)
+{
+
+	struct prospero_device *pdev = dev_get_drvdata(dev);
+	struct prospero_pci *p_pci = pdev->bus_specific;
+	int ret = 0;
+	struct stream_link *stream_l = pdev->stream_links[stream_id];
+	int demux_id = stream_l->demux_id;
+	int fenum = pdev->demux_link[demux_id];
+	int buffnum = pdev->streams[stream_id]->buffnum;
+	int offset = pdev->p_demux[fenum].Buffer_Definition_Ram + (CONTROL_BITS_OFFSET + (BUFFER_SLOT_SIZE * buffnum)) + BUFFER_BASE_ADDRESS;
+
+	if (buf > BIT_MASK_26) {
+		ret = -EIO;
+		pr_err("Error (prospero_set_buffer_base_address) the value passed in is too large\n");
+
+	} else {
+		iowrite32(buf, p_pci->io_mem + offset);
+		pr_debug("set buffer_details at offset %x to %x\n", offset, buf);
+
+	}
+
+	return ret;
+
+}
+
+static int prospero_set_buffer_end_address(struct device *dev, u32 buf, int stream_id)
+{
+
+	int ret = 0;
+
+	/* the buffer end address is one packet (188 bytes) less than the
+	 * buffer size */
+
+	buf = buf - 188;
+	pr_debug("buffer %d end address = %x  bit_mask_20 = %x", stream_id, buf, BIT_MASK_22);
+	ret = prospero_set_buffer_details(dev, buf, BUFFER_END_ADDRESS, stream_id);
+
+	return ret;
+
+}
+
+static int prospero_get_guard_value_A(struct device *dev, int buffnum, u32 *buf, int stream_id)
+{
+
+	u32 tmp;
+	int ret;
+
+	ret = prospero_get_buffer_details(dev, buffnum, &tmp, GUARD_A, stream_id);
+	*buf = tmp & BIT_MASK_22;
+
+	return ret;
+
+}
+
+static int prospero_set_guard_value_A(struct device *dev, u32 buf, int stream_id)
+{
+
+	int ret = 0;
+
+	if (buf > BIT_MASK_22) {
+		ret = -EIO;
+		pr_err("Error (prospero_set_guard_value_A) the value passed in is too large\n");
+
+	} else {
+		ret = prospero_set_buffer_details(dev, buf, GUARD_A, stream_id);
+
+	}
+
+	return ret;
+
+}
+
+static int prospero_get_int_trigger_address(struct device *dev, int buffnum, u32 *buf, int stream_id)
+{
+
+	u32 tmp;
+	int ret;
+
+	ret = prospero_get_buffer_details(dev, buffnum, &tmp, INT_TRIGGER_ADDRESS, stream_id);
+	*buf = tmp & BIT_MASK_22;
+
+	return ret;
+
+}
+
+static int prospero_set_int_trigger_address(struct device *dev, int buffnum, u32 buf, int stream_id)
+{
+
+	int ret = 0;
+
+	if (buf > BIT_MASK_22) {
+		ret = -EIO;
+		pr_err("Error (prospero_set_int_trigger_address) the value passed in is too large\n");
+	} else {
+		pr_debug("set interrupt trigger: buf = %x, id = %d", buf, stream_id);
+		ret = prospero_set_buffer_details(dev, buf, INT_TRIGGER_ADDRESS, stream_id);
+
+	}
+
+	return ret;
+
+}
+
+static int prospero_get_current_write_pointer_A(struct device *dev, int buffnum, u32 *buf, int stream_id)
+{
+
+	u32 tmp = 0;
+	int ret = 0;
+
+	ret = prospero_get_buffer_details(dev, buffnum, &tmp, CURRENT_WP_A, stream_id);
+	*buf = tmp & BIT_MASK_22;
+
+	return ret;
+
+}
+
+static int prospero_set_current_write_pointer_A(struct device *dev, int buffnum, u32 buf, int stream_id)
+{
+
+	int ret = 0;
+
+	ret = prospero_set_buffer_details(dev, buf, CURRENT_WP_A, stream_id);
+
+	return ret;
+
+}
+
+static int prospero_get_control_bits(struct device *dev, struct channel_control_bits *cbits, int buffer, int stream_id)
+{
+
+	struct prospero_device *pdev = dev_get_drvdata(dev);
+	struct prospero_pci *p_pci = pdev->bus_specific;
+	u32 temp;
+	struct stream_link *stream_l = pdev->stream_links[stream_id];
+	int demux_id = stream_l->demux_id;
+	int fenum = pdev->demux_link[demux_id];
+	int offset;
+
+	offset = pdev->p_demux[fenum].Buffer_Definition_Ram + (CONTROL_BITS_OFFSET + (BUFFER_SLOT_SIZE * buffer));
+
+	temp = (ioread32(p_pci->io_mem + offset)) & 0xF;
+
+	cbits->null_packets = temp & NULL_PACKET;
+	cbits->interrupt_enabled = temp & INTERRUPT_ENABLED;
+	cbits->guard_value_enabled = temp & GUARD_VALUE;
+	cbits->channel_enabled = temp & CHANNEL_ENABLED;
+
+	return 0;
+}
+
+static int prospero_set_channel_interrupt(struct device *dev, u32 cb, int stream_id)
+{
+
+	struct prospero_device *pdev = dev_get_drvdata(dev);
+	struct prospero_pci *p_pci = pdev->bus_specific;
+	struct stream_link *stream_l = pdev->stream_links[stream_id];
+	int demux_id = stream_l->demux_id;
+	u32 temp;
+	int fenum = pdev->demux_link[demux_id];
+	int buffnum = pdev->streams[stream_id]->buffnum;
+	int offset;
+
+	offset = pdev->p_demux[fenum].Buffer_Definition_Ram + (CONTROL_BITS_OFFSET + (BUFFER_SLOT_SIZE * buffnum));
+	temp = (ioread32(p_pci->io_mem + offset)) & 0xB;
+	temp = (cb << 2) | temp;
+	iowrite32(temp, p_pci->io_mem + offset);
+
+	return 0;
+
+}
+
+static int prospero_set_guard_value_enabled(struct device *dev, u32 cb, int stream_id)
+{
+
+	struct prospero_device *pdev = dev_get_drvdata(dev);
+	struct prospero_pci *p_pci = pdev->bus_specific;
+	u32 temp;
+	struct stream_link *stream_l = pdev->stream_links[stream_id];
+	int demux_id = stream_l->demux_id;
+	int fenum = pdev->demux_link[demux_id];
+	int buffnum = pdev->streams[stream_id]->buffnum;
+	int offset = pdev->p_demux[fenum].Buffer_Definition_Ram + (CONTROL_BITS_OFFSET + (BUFFER_SLOT_SIZE * buffnum));
+
+	temp = (ioread32(p_pci->io_mem + offset)) & 0xD;
+	temp = (cb << 1) | temp;
+	iowrite32(temp, p_pci->io_mem + offset);
+
+	return 0;
+
+}
+
+static int prospero_set_channel_enabled(struct device *dev, u32 cb, int stream_id)
+{
+
+	struct prospero_device *pdev = dev_get_drvdata(dev);
+	struct prospero_pci *p_pci = pdev->bus_specific;
+	u32 temp;
+	u32 temp1;
+	struct stream_link *stream_l = pdev->stream_links[stream_id];
+	int demux_id = stream_l->demux_id;
+	int fenum = pdev->demux_link[demux_id];
+	int buffnum = pdev->streams[stream_id]->buffnum;
+	int offset = pdev->p_demux[fenum].Buffer_Definition_Ram + (CONTROL_BITS_OFFSET + (BUFFER_SLOT_SIZE * buffnum));
+
+	temp = (ioread32(p_pci->io_mem + offset)) & 0xE;
+	temp = cb | temp;
+
+	iowrite32(temp, p_pci->io_mem + offset);
+	temp1 = ioread32(p_pci->io_mem + offset);
+
+	pr_debug("pid, wrote %x to control bits at mem %p", temp, (p_pci->io_mem + offset));
+	return 0;
+
+}
+
+static int prospero_get_pid_table(struct device *dev, int stream_id, struct prospero_pid_table *pid_table, int i)
+{
+
+	struct prospero_device *pdev = dev_get_drvdata(dev);
+	struct prospero_pci *p_pci = pdev->bus_specific;
+	u32 tmp_pid;
+	struct stream_link *stream_l = pdev->stream_links[stream_id];
+	int demux_id = stream_l->demux_id;
+	int fenum = pdev->demux_link[demux_id];
+
+	tmp_pid = (ioread32(p_pci->io_mem + pdev->p_demux[fenum].Pid_Table_Offset + (PID_TABLE_SLOT_SIZE * i)));
+	pid_table->pid = tmp_pid & 0x3FFF;
+	pid_table->pid_enabled = (tmp_pid & 0x4000) >> 14;
+	pid_table->bdp = (tmp_pid & 0x3F0000) >> 16;
+
+	return 0;
+
+}
+
+static int prospero_get_pid_slot(struct device *dev, int stream_id, u16 pid, int *slot)
+{
+
+	struct prospero_device *pdev = dev_get_drvdata(dev);
+	int i;
+	int z;
+	struct prospero_pid_table tmp_pid;
+	int free_slot = -1;
+	int ret = 0;
+	struct dvb_frontend *fe;
+	struct stream_link *stream_l = pdev->stream_links[stream_id];
+	int demux_id = stream_l->demux_id;
+	int fenum = pdev->demux_link[demux_id];
+
+	fe = pdev->fe[fenum];
+
+	for (i = PIDS_START; i <= pdev->p_demux[fenum].num_pids; i++) {
+		prospero_get_pid_table(dev, stream_id, &tmp_pid, i);
+
+		if ((tmp_pid.pid_enabled == 0) && (free_slot < 0)) {
+			free_slot = i;
+
+		} else if ((tmp_pid.pid == pid) && (tmp_pid.pid_enabled)) {
+			for (z = PIDS_START; z <= pdev->p_demux[fenum].num_pids; z++)
+				prospero_get_pid_table(dev, stream_id, &tmp_pid, z);
+
+			ret = -EIO;
+		}
+	}
+
+	if (free_slot < 0) {
+		pr_err("Error! no free slots available for pid %d on tuner %d\n", pid, fenum);
+		ret = -EIO;
+	} else {
+		pr_debug("pid %d allocated to free slot = %d on tuner %d\n", pid, free_slot, fenum);
+		*slot = free_slot;
+	}
+
+	return ret;
+}
+
+static int get_stream_id(struct prospero_device *p, int *stream_id, unsigned long buff_id)
+{
+
+	int i;
+
+	for (i = 0; i < MAX_STREAMS; i++) {
+		if (p->stream_links[i] == NULL)
+			goto exit;
+
+
+		if (p->stream_links[i]->buffer_pointer == buff_id) {
+			*stream_id = i;
+
+			return 0;
+		}
+	}
+
+ exit:
+	return -EIO;
+
+}
+
+static int set_stream_id(struct prospero_device *p, int *stream_id, unsigned long buff_id, int demux_id)
+{
+
+	int i;
+	struct stream_link *s_link;
+	int ret = -EIO;
+
+	ret = get_stream_id(p, stream_id, buff_id);
+	if (ret >= 0) {
+		ret = 0;
+		goto exit;
+	}
+
+	for (i = 0; i < MAX_STREAMS; i++) {
+
+		if (p->stream_links[i] == NULL) {
+
+			p->stream_links[i] = kmalloc(sizeof(struct stream_link), GFP_KERNEL);
+			if (p->stream_links[i] == NULL) {
+				ret = -ENOMEM;
+				goto exit;
+			}
+
+			s_link = p->stream_links[i];
+			s_link->buffer_pointer = buff_id;
+			s_link->demux_id = demux_id;
+			s_link->count = 1;
+
+			*stream_id = i;
+			ret = 0;
+			goto exit;
+
+		} else if (p->stream_links[i]->buffer_pointer == 0) {
+
+			s_link = p->stream_links[i];
+			s_link->buffer_pointer = buff_id;
+			s_link->count = 1;
+			s_link->demux_id = demux_id;
+			*stream_id = i;
+			ret = 0;
+			goto exit;
+
+		}
+	}
+
+ exit:
+	return ret;
+
+}
+
+static int prospero_find_pid(struct device *dev, int stream_id, u16 pid, int *slot)
+{
+
+	struct prospero_device *pdev = dev_get_drvdata(dev);
+	int i;
+	struct prospero_pid_table tmp_pid;
+	struct dvb_frontend *fe;
+	struct stream_link *stream_l = pdev->stream_links[stream_id];
+	int demux_id = stream_l->demux_id;
+	int fenum = pdev->demux_link[demux_id];
+
+	fe = pdev->fe[fenum];
+	i = PIDS_START;
+	prospero_get_pid_table(dev, stream_id, &tmp_pid, i);
+
+	while (tmp_pid.pid >= 0) {
+		if ((tmp_pid.pid == pid) && (tmp_pid.pid_enabled)) {
+			*slot = i;
+			return 0;
+		}
+
+		i++;
+		prospero_get_pid_table(dev, stream_id, &tmp_pid, i);
+
+	}
+
+	pr_err("Error couldn't find pid!\n");
+	return -EIO;
+
+}
+
+static int prospero_disable_pid(struct device *dev, struct dvb_demux_feed *feed)
+{
+
+	struct prospero_device *pdev = dev_get_drvdata(dev);
+	struct prospero_pci *p_pci = pdev->bus_specific;
+	struct dmx_ts_feed *ts_feed;
+	struct dmx_section_feed *sec_feed;
+	struct dmxdev_filter *dmxdevfilter;
+	struct dmxdev *demux_dev;
+	struct dvb_device *dvbdev;
+	u32 tmp;
+	int slot = 0;
+	u32 demux_id;
+	int offset;
+	int ret = 0;
+	int fenum = 0;
+	int stream_id = 0;
+	unsigned long buff_id = 0;
+
+	if (feed->type == DMX_TYPE_TS) {
+		ts_feed = (struct dmx_ts_feed *)feed;
+		dmxdevfilter = ts_feed->priv;
+
+	} else if (feed->type == DMX_TYPE_SEC) {
+		sec_feed = (struct dmx_section_feed *)feed;
+		dmxdevfilter = sec_feed->priv;
+
+	} else {
+		return -ENOTSUPP;
+	}
+
+	demux_dev = dmxdevfilter->dev;
+	dvbdev = demux_dev->dvbdev;
+	demux_id = dvbdev->id;
+	fenum = pdev->demux_link[demux_id];
+	buff_id = (long)&dmxdevfilter->buffer;
+
+	ret = get_stream_id(pdev, &stream_id, buff_id);
+	pr_debug("prospero_disable_pid demux device id = %d", stream_id);
+
+	ret = prospero_find_pid(dev, stream_id, feed->pid, &slot);
+
+	if (ret == 0) {
+		if (feed->pid != WILD_PID)
+			pdev->p_demux[fenum].num_pids--;
+
+
+		offset = pdev->p_demux[fenum].Pid_Table_Offset + (PID_TABLE_SLOT_SIZE * slot);
+		tmp = ioread32(p_pci->io_mem + offset);
+		tmp = tmp & 0x3F3FFF;
+		iowrite32(tmp, p_pci->io_mem + offset);
+
+	}
+
+	return ret;
+}
+
+static int prospero_set_pid(struct device *dev, struct dvb_demux_feed *feed)
+{
+
+	struct prospero_device *pdev = dev_get_drvdata(dev);
+	struct prospero_pci *p_pci = pdev->bus_specific;
+	struct dmx_section_feed *sec_feed;
+	struct dmx_ts_feed *ts_feed;
+	struct dmxdev_filter *dmxdevfilter;
+	struct dmxdev *demux_dev;
+	struct dvb_device *dvbdev;
+	struct stream_data *stream;
+	u32 tmp;
+	int slot = -1;
+	u32 demux_id = 0;
+	int offset;
+	int ret = 0;
+	int i;
+	struct prospero_pid_table tmp_pid_table;
+	int fenum = 0;
+	int stream_id = 0;
+	unsigned long buff_id;
+
+	if (feed->type == DMX_TYPE_TS) {
+
+		ts_feed = (struct dmx_ts_feed *)feed;
+		dmxdevfilter = ts_feed->priv;
+
+	} else if (feed->type == DMX_TYPE_SEC) {
+
+		sec_feed = (struct dmx_section_feed *)feed;
+		dmxdevfilter = sec_feed->priv;
+
+	} else {
+		return -ENOTSUPP;
+	}
+
+	demux_dev = dmxdevfilter->dev;
+	dvbdev = demux_dev->dvbdev;
+	demux_id = dvbdev->id;
+	fenum = pdev->demux_link[demux_id];
+	buff_id = (long)&dmxdevfilter->buffer;
+
+	ret = get_stream_id(pdev, &stream_id, buff_id);
+	stream = pdev->streams[stream_id];
+
+	pr_debug("set pid to %x\n", feed->pid);
+
+	if (feed->pid == WILD_PID) {
+		pr_debug("Wildcard PID!\n");
+		slot = 0;
+		stream->pids[0] = slot;
+
+	} else {
+		ret = prospero_get_pid_slot(dev, stream_id, feed->pid, &slot);
+		if (ret == 0) {
+			pdev->p_demux[fenum].num_pids++;
+			for (i = 0; i < MAX_PIDS_PER_STREAM; i++) {
+				if (stream->pids[i] < 0) {
+					stream->pids[i] = slot;
+					goto done;
+				}
+			}
+		}
+	}
+
+ done:
+	if (slot >= 0) {
+
+		offset = pdev->p_demux[fenum].Pid_Table_Offset + (PID_TABLE_SLOT_SIZE * slot);
+
+		/* set the PID to enabled. */
+		tmp = feed->pid | 0x4000 | (stream->buffnum << 16);
+
+		iowrite32(tmp, p_pci->io_mem + offset);
+		prospero_get_pid_table(dev, stream_id, &tmp_pid_table, slot);
+
+	}
+
+	return ret;
+
+}
+
+void prospero_device_kfree(struct prospero_device *p)
+{
+	kfree(p->bus_specific);
+	kfree(p);
+}
+
+static int prospero_clear_interrupt(struct prospero_pci *p_pci, int device)
+{
+
+	int offset = INTERRUPT_CONTROL;
+
+	iowrite8(device, p_pci->io_mem + offset);
+	return 0;
+
+}
+
+static void tsCopy(u8 *ptr, size_t bytes, struct dvb_demux_feed *dvbdmxfeed, int fenum)
+{
+
+	int b = 641644;
+	u8 *wptr;
+	u8 *end;
+
+	struct dmx_ts_feed *feed = &dvbdmxfeed->feed.ts;
+	struct dmxdev_filter *dmxdevfilter = feed->priv;
+
+	if (dmxdevfilter->params.pes.output == DMX_OUT_TAP || dmxdevfilter->params.pes.output == DMX_OUT_TSDEMUX_TAP) {
+		pr_debug("mtune copy\n");
+		dvbdmxfeed->cb.ts(ptr, bytes, 0, 0, &dvbdmxfeed->feed.ts, 0);
+
+	} else {
+
+		if (bytes <= b) {
+			pr_debug("normal copy %d\n", bytes);
+			dvbdmxfeed->cb.ts(ptr, bytes, 0, 0, &dvbdmxfeed->feed.ts, 0);
+
+		} else {
+
+			pr_debug("wildcard copy\n");
+			wptr = ptr;
+			end = ptr + bytes;
+
+			while ((wptr + b) < end) {
+				pr_debug("wcp copy from %p, copy %d bytes, end = %p\n", wptr, b, (wptr + b));
+
+				dvbdmxfeed->cb.ts(wptr, b, 0, 0, &dvbdmxfeed->feed.ts, 0);
+				wptr += b;
+			}
+
+			pr_debug("wcp END! copy from %p, copy %d bytes, end = %p\n", wptr, (end - wptr), (end));
+			dvbdmxfeed->cb.ts(wptr, (end - wptr), 0, 0, &dvbdmxfeed->feed.ts, 0);
+
+		}
+	}
+}
+
+static void get_data(struct prospero_device *pdev, int fenum, int buffnum)
+{
+
+	struct stream_data *stream;
+	struct device *dev = pdev->dev;
+	struct dvb_demux *demux;
+	struct dvb_demux_feed *dvbdmxfeed;
+	u8 *bufferptr = 0;
+	u8 *ptr = 0;
+	uint32_t tempgp;
+	struct timeval tv;
+	size_t bytes;
+	u32 byte_count = 0;
+	u32 bba;
+	u32 interrupt_address;
+	u32 curr_write = 0;
+	u32 curr_write1;
+	int buffer_size;
+	int demux_id = fenum;
+	int stream_id = pdev->p_demux[fenum].buffers[buffnum];
+
+	demux = &pdev->demux[demux_id];
+	stream = pdev->streams[stream_id];
+	dvbdmxfeed = stream->feed;
+
+	bytes = 0;
+	byte_count = 0;
+
+	/* The wildcard pid uses the whole buffer, normal pids have their own
+	 * channel buffer which is within the larger buffer
+	 */
+
+	if (dvbdmxfeed->pid == WILD_PID)
+		buffer_size = wildcard_buffer_size;
+	else
+		buffer_size = pdev->channel_buffer_size;
+
+	do_gettimeofday(&tv);
+
+	pr_debug("prospero: interrupt for buffer %x", buffnum);
+
+	prospero_get_current_write_pointer_A(dev, buffnum, &curr_write, stream_id);
+	prospero_get_current_write_pointer_A(dev, buffnum, &curr_write1, 0);
+	prospero_get_current_write_pointer_A(dev, buffnum, &curr_write, stream_id);
+
+	pr_debug("prospero: Current Write Pointer for id %d = %x\n", stream_id, curr_write);
+
+	prospero_get_buffer_base_address(dev, &bba, stream_id);
+
+	if (dvbdmxfeed->pid == WILD_PID) {
+		bufferptr = pdev->p_demux[fenum].wildcard_membuf_ptr;
+		pr_debug("buffer = %p : wildcard\n", bufferptr);
+	} else {
+		bufferptr = pdev->p_demux[fenum].ts_membuf_ptr;
+		pr_debug("buffer = %p : normal\n", bufferptr);
+	}
+
+	pr_debug("last_read = %d, curr_write = %d\n", stream->last_read, curr_write);
+
+	prospero_get_guard_value_A(dev, buffnum, &tempgp, stream_id);
+	prospero_get_int_trigger_address(dev, buffnum, &interrupt_address, stream_id);
+
+	if (curr_write > stream->last_read) {
+
+		bytes = curr_write - stream->last_read;
+		byte_count = bytes;
+		ptr = bufferptr + stream->last_read;
+
+		pr_debug("cp1 stream_id = %d: copy from %p, copy %d bytes, end = %p\n", stream_id, ptr, bytes, (ptr + bytes));
+
+		tsCopy(ptr, bytes, dvbdmxfeed, fenum);
+
+	} else if (curr_write != stream->last_read) {
+
+		bytes = (buffer_size - (stream->last_read - stream->sub_base_address));
+		byte_count = bytes;
+		ptr = bufferptr + stream->last_read;
+		pr_debug("cp2 stream_id = %d: copy from %p, copy %d bytes, end = %p\n", stream_id, ptr, bytes, (ptr + bytes));
+		tsCopy(ptr, bytes, dvbdmxfeed, fenum);
+
+		if (curr_write > stream->sub_base_address) {
+
+			bytes = (curr_write - stream->sub_base_address);
+			byte_count += bytes;
+			ptr = (bufferptr + stream->sub_base_address);
+			pr_debug("cp3 stream_id = %d: copy from %p, copy %d bytes, end = %p\n", stream_id, ptr, bytes, (ptr + bytes));
+			tsCopy(ptr, bytes, dvbdmxfeed, fenum);
+
+		} else {
+			pr_debug("skip copy 3 tempgp = %d; curr_write = %d; base= %d\n", tempgp, curr_write, stream->sub_base_address);
+		}
+
+		pr_debug("stream %d bytes copied = %d\n", stream_id, byte_count);
+
+	}
+
+	stream->byte_count += byte_count;
+
+	pr_debug("stream %d total bytes copied = %ld : 0x%lx\n", stream_id, stream->byte_count, stream->byte_count);
+
+	stream->last_read = curr_write;
+
+	if (dvbdmxfeed->pid == WILD_PID) {
+		tempgp = ((curr_write + pdev->wild_buffer_increment) % buffer_size) + stream->sub_base_address;
+		interrupt_address = ((curr_write + pdev->wild_interrupt_increment) % buffer_size) + stream->sub_base_address;
+
+	} else {
+		tempgp = ((curr_write + pdev->buffer_increment) % buffer_size) + stream->sub_base_address;
+		interrupt_address = ((curr_write + pdev->interrupt_increment) % buffer_size) + stream->sub_base_address;
+
+	}
+
+	prospero_set_guard_value_A(dev, tempgp, stream_id);
+	prospero_set_int_trigger_address(dev, buffnum, interrupt_address, stream_id);
+
+}
+
+void prospero_irq_tasklet(unsigned long pdev)
+{
+
+	struct prospero_device *p = (struct prospero_device *)(*((struct prospero_device **)pdev));
+	struct dvb_frontend *fe;
+	int stream_id;
+	struct prospero_fifo guard_fifo;
+	int cleared = 0;
+
+	int interrupt_buffer = p->int_buffer;
+	int zero = 0;
+	int i = 0;
+
+	struct timeval tv;
+
+	do_gettimeofday(&tv);
+
+	pr_debug("tasklet! %ld\n", tv.tv_usec);
+
+	p->entry_count = 0;
+
+	pr_debug("\nstart irq\n");
+	do {
+		if (i > 10)
+			pr_debug("gfifo num_entries is %d!\n", i);
+
+		prospero_get_fifo(p->dev, &guard_fifo, GUARD);
+		pr_debug("guard buffer = %d; guard_tuner = %d; int buffer=%d\n", guard_fifo.buffer_pointer, guard_fifo.tuner_number, interrupt_buffer);
+		if (guard_fifo.buffer_pointer == interrupt_buffer)
+			cleared = 1;
+
+
+		if (guard_fifo.num_entries > 0) {
+			if (i == 0)
+				p->entry_count = guard_fifo.num_entries;
+
+			else if (guard_fifo.num_entries != (p->entry_count - 1))
+				pr_debug("entry count differs gfifo = %d, orig = %d\n", guard_fifo.num_entries, p->entry_count);
+
+
+			pr_debug("buffer_pointer = %d, tuner_number = %d, num_entries = %d\n", guard_fifo.buffer_pointer, guard_fifo.tuner_number, guard_fifo.num_entries);
+
+			fe = p->fe[guard_fifo.tuner_number];
+			stream_id = p->p_demux[guard_fifo.tuner_number].buffers[guard_fifo.buffer_pointer];
+
+			get_data(p, guard_fifo.tuner_number, guard_fifo.buffer_pointer);
+
+			p->streams[stream_id]->serviced = 1;
+
+		} else {
+			pr_debug("gfifo! zero entries, don't read!\n");
+			zero = 1;
+		}
+		pr_debug("i = %d; entry = %d\n", i, p->entry_count);
+
+		i++;
+
+	} while (i < p->entry_count);
+
+	pr_debug("end irq\n\n");
+
+	if ((cleared != 1) && (zero == 0))
+		pr_debug("interrupt buffer wasn't cleared\n");
+
+}
+
+DECLARE_TASKLET(prospero_tasklet, prospero_irq_tasklet, (unsigned long)&pro);
+
+void dvb_interrupt(struct prospero_pci *p_pci)
+{
+
+	struct prospero_device *p = p_pci->p_dev;
+	struct prospero_fifo int_fifo;
+
+	struct timeval tv;
+
+	do_gettimeofday(&tv);
+
+	pr_debug("interrupt! %ld\n", tv.tv_usec);
+
+	do {
+		prospero_get_fifo(p->dev, &int_fifo, INTERRUPT);
+
+		p->int_buffer = int_fifo.buffer_pointer;
+		pr_debug("interrupt! buffer_pointer = %d, tuner = %d, num_entries = %d; p->int_buffer = %d\n", int_fifo.buffer_pointer, int_fifo.tuner_number, int_fifo.num_entries, p->int_buffer);
+
+	} while (int_fifo.num_entries > 1);
+
+	tasklet_schedule(&prospero_tasklet);
+
+}
+
+static irqreturn_t prospero_pci_isr(int irq, void *dev_id)
+{
+
+	struct prospero_pci *p_pci = dev_id;
+	int status;
+	unsigned long flags;
+	irqreturn_t ret = IRQ_HANDLED;
+
+	spin_lock_irqsave(&p_pci->irq_lock, flags);
+	status = ioread8(p_pci->io_mem + INTERRUPT_CONTROL);
+
+	/* check for DVB Interrupts */
+	if (status & DVB_INT_STATUS_MASK) {
+		dvb_interrupt(p_pci);
+		prospero_clear_interrupt(p_pci, DVB_INT_STATUS_MASK);
+	}
+	/* check for IR Interrupts */
+	if (status & IR_INT_TIMEOUT_MASK) {
+		ir_interrupt(p_pci);
+		prospero_clear_interrupt(p_pci, IR_INT_TIMEOUT_MASK);
+	}
+
+	if (status & IR_INT_FIFO_FILLING_MASK) {
+		ir_interrupt(p_pci);
+		prospero_clear_interrupt(p_pci, IR_INT_FIFO_FILLING_MASK);
+	}
+
+	spin_unlock_irqrestore(&p_pci->irq_lock, flags);
+
+	return ret;
+
+}
+
+static int prospero_pci_init(struct prospero_pci *p_pci)
+{
+
+	u8 card_rev;
+	u16 vendor;
+	u16 device;
+	int ret;
+	u32 interrupts;
+
+	pci_read_config_word(p_pci->pcidev, PCI_VENDOR_ID, &vendor);
+	pr_info("vendor ID = %x", vendor);
+
+	pci_read_config_word(p_pci->pcidev, PCI_DEVICE_ID, &device);
+	pr_info("device ID = %x", device);
+
+	pci_read_config_byte(p_pci->pcidev, PCI_CLASS_REVISION, &card_rev);
+	pr_info("card revision %x", card_rev);
+
+	ret = pci_enable_device(p_pci->pcidev);
+	if (ret != 0) {
+		pr_err("Enabling prospero pci device failed");
+		return ret;
+
+	}
+
+	pr_debug("Prospero pci dvb-T card enabled");
+
+	pci_set_master(p_pci->pcidev);
+
+	ret = pci_request_regions(p_pci->pcidev, DRIVER_NAME);
+	if (ret != 0) {
+		pr_err("Failed to allocate pci memory regions");
+		goto err_pci_disable_device;
+
+	}
+
+	pr_debug("allocated pci memory regions");
+
+	/* map the BAR */
+	p_pci->io_mem = pci_iomap(p_pci->pcidev, 2, 0);
+
+	if (!p_pci->io_mem) {
+		pr_err("cannot map io memory\n");
+		ret = -EIO;
+		goto err_pci_release_regions;
+
+	}
+
+	p_pci->BAR0 = pci_iomap(p_pci->pcidev, 0, 0);
+
+	if (!p_pci->BAR0) {
+		pr_err("cannot map io memory\n");
+		ret = -EIO;
+		goto err_pci_release_regions;
+
+	}
+
+	pci_set_drvdata(p_pci->pcidev, p_pci);
+	spin_lock_init(&p_pci->irq_lock);
+
+	ret = request_irq(p_pci->pcidev->irq, prospero_pci_isr, IRQF_SHARED, DRIVER_NAME, p_pci);
+	if (ret != 0)
+		goto err_pci_iounmap;
+
+	/* enable the interrupts in the pci registers of the prospero card */
+	iowrite32(0x000000FF, p_pci->io_mem + PCI_INTERRUPTS);
+	interrupts = ioread32(p_pci->io_mem + PCI_INTERRUPTS);
+
+	p_pci->init_state |= P_PCI_INIT;
+
+	return ret;
+
+ err_pci_iounmap:
+	pci_iounmap(p_pci->pcidev, p_pci->io_mem);
+	pci_set_drvdata(p_pci->pcidev, NULL);
+ err_pci_release_regions:
+	pci_release_regions(p_pci->pcidev);
+ err_pci_disable_device:
+	pci_disable_device(p_pci->pcidev);
+	return ret;
+
+}
+
+int prospero_frontend_exit(struct prospero_device *p)
+{
+
+	int i;
+
+	for (i = 0; i < p->num_frontends; i++) {
+		if (dvb_unregister_frontend(p->fe[i]))
+			pr_err("failed to unregister frontend %d\n", i);
+
+		dvb_frontend_detach(p->fe[i]);
+	}
+
+	return 0;
+
+}
+
+static void prospero_dvb_exit(struct prospero_device *p)
+{
+	int dev = 0;
+
+	if (p->init_state & P_STATE_DVB_INIT) {
+
+		while (p->num_init > 0) {
+
+			pr_debug("num_init = %d", p->num_init);
+
+			dev = p->num_init - 1;
+
+			pr_debug("dev = %d\n", dev);
+
+			p->demux[dev].dmx.close(&p->demux[dev].dmx);
+
+			if (dev == 0) {
+				pr_debug("dmx.remove hw_frontend\n");
+				p->demux[dev].dmx.remove_frontend(&p->demux[dev].dmx, &p->hw_frontend[dev]);
+			}
+
+			dvb_dmxdev_release(&p->dmxdev[dev]);
+			dvb_dmx_release(&p->demux[dev]);
+			p->num_init--;
+		}
+
+		prospero_frontend_exit(p);
+
+		dvb_unregister_adapter(&p->dvb_adapter);
+
+	}
+	p->init_state &= ~P_STATE_DVB_INIT;
+
+}
+
+static void prospero_pci_exit(struct prospero_device *prospero_dev)
+{
+
+	struct prospero_pci *p_pci = prospero_dev->bus_specific;
+
+	prospero_dvb_exit(prospero_dev);
+
+	if (p_pci->init_state & P_PCI_INIT) {
+
+		free_irq(p_pci->pcidev->irq, p_pci);
+		pci_iounmap(p_pci->pcidev, p_pci->io_mem);
+		pci_set_drvdata(p_pci->pcidev, NULL);
+		pci_release_regions(p_pci->pcidev);
+		pci_disable_device(p_pci->pcidev);
+	}
+	p_pci->init_state &= ~P_PCI_INIT;
+
+}
+
+static int prospero_enable_interrupts(struct prospero_pci *p_pci)
+{
+
+	int offset = INTERRUPT_ENABLE;
+
+	/* we now write 0x3 to enable the infra-red interrupts */
+	iowrite8(0x03, p_pci->io_mem + offset);
+
+	return 0;
+
+}
+
+static int prospero_disable_interrupts(struct prospero_pci *p_pci)
+{
+
+	int offset = INTERRUPT_ENABLE;
+
+	/* this disables the infra-red interrupts */
+	iowrite8(0x00, p_pci->io_mem + offset);
+
+	return 0;
+
+}
+
+static int get_buffer(struct prospero_device *pdev, int fenum, int *buffernum, int stream_id)
+{
+
+	/* this routine should find a free buffer space from the
+	 * buffer definition ram for use in start_feed */
+
+	struct channel_control_bits cbits;
+	int i;
+
+	pr_debug("get_buffer for frontend %d, stream %d", fenum, stream_id);
+
+	for (i = 0; i < STREAMS_PER_DEMUX; i++) {
+
+		cbits.interrupt_enabled = 0;
+		cbits.guard_value_enabled = 0;
+		cbits.channel_enabled = 0;
+
+		prospero_get_control_bits(pdev->dev, &cbits, i, stream_id);
+
+		pr_debug("interrupt_enabled = %d, guard_value_enabled = %d, channel_enabled = %d\n", cbits.interrupt_enabled, cbits.guard_value_enabled, cbits.channel_enabled);
+
+		if (!cbits.channel_enabled) {
+			*buffernum = i;
+			return 0;
+		}
+
+	}
+
+	pr_err("couldn't find a spare buffer for frontend %d, stream %d\n", fenum, stream_id);
+
+	return -EIO;
+
+}
+
+static int prospero_dvb_start_feed(struct dvb_demux_feed *dvbdmxfeed)
+{
+
+	struct prospero_device *p = dvbdmxfeed->demux->priv;
+	struct prospero_pci *p_pci = p->bus_specific;
+
+	struct dmx_ts_feed *ts_feed;
+	struct dmx_section_feed *sec_feed;
+	struct dmxdev_filter *dmxdevfilter;
+	struct dmxdev *demux_dev;
+	struct dvb_device *dvbdev;
+
+	u32 demux_id = 0;
+	int stream_id = 0;
+	unsigned long buff_id = 0;
+	int ret = 0;
+
+	struct channel_control_bits cbits;
+	struct stream_data *stream = 0;
+	float seconds = 0.05;
+	float jiffyCount = 0;
+	int fenum = 0;
+	u32 curr_write = 0;
+	int buffnum = 0;
+
+	jiffyCount = HZ * seconds;
+
+	p->seqstart = 1;
+	p->sequence_track = 0;
+
+	if (dvbdmxfeed->type == DMX_TYPE_TS) {
+		pr_debug("TS feed!\n");
+		ts_feed = &dvbdmxfeed->feed.ts;
+		dmxdevfilter = ts_feed->priv;
+
+	} else if (dvbdmxfeed->type == DMX_TYPE_SEC) {
+		pr_debug("section feed!\n");
+
+		sec_feed = &dvbdmxfeed->feed.sec;
+
+		pr_debug("is_filtering = %d\n", sec_feed->is_filtering);
+
+		dmxdevfilter = sec_feed->priv;
+
+		pr_debug("devfilter setup\n");
+
+	} else {
+		return -ENOTSUPP;
+	}
+
+	demux_dev = dmxdevfilter->dev;
+	dvbdev = demux_dev->dvbdev;
+
+	demux_id = dvbdev->id;
+	buff_id = (long)&dmxdevfilter->buffer;
+	fenum = p->demux_link[demux_id];
+
+	ret = set_stream_id(p, &stream_id, buff_id, demux_id);
+
+	pr_debug("fenum = %d, demux_id = %d, stream_id = %d\n", fenum, demux_id, stream_id);
+
+	if ((p->streams[stream_id] == NULL) || (p->streams[stream_id]->active == 0)) {
+		if (p->streams[stream_id] == NULL) {
+
+			p->streams[stream_id] = kmalloc(sizeof(struct stream_data), GFP_KERNEL);
+			if (p->streams[stream_id] == NULL) {
+				ret = -EIO;
+				goto exit;
+			}
+		}
+
+		stream = p->streams[stream_id];
+		stream->buffnum = 0;
+
+		if (dvbdmxfeed->pid == WILD_PID) {
+			stream->buffer_base_address = 0 + (fenum << 23) + (1 << 22);
+			stream->sub_base_address = 0;
+			stream->buffer_end_address = stream->buffer_base_address + wildcard_buffer_size;
+			stream->feed = dvbdmxfeed;
+
+		} else {
+			ret = get_buffer(p, fenum, &buffnum, stream_id);
+			if (ret >= 0) {
+				stream->buffnum = buffnum;
+				stream->buffer_base_address = 0 + (fenum << 23) + (p->channel_buffer_size * buffnum);
+				stream->sub_base_address = (p->channel_buffer_size * buffnum);
+				stream->buffer_end_address = p->channel_buffer_size * (stream->buffnum + 1);
+				stream->feed = dvbdmxfeed;
+
+			} else {
+				pr_err("couldn't allocate a buffer!\n");
+				goto exit;
+			}
+
+		}
+
+		stream->last_read = stream->sub_base_address;
+		prospero_set_current_write_pointer_A(p->dev, buffnum, stream->last_read, stream_id);
+
+		stream->byte_count = 0;
+		prospero_get_current_write_pointer_A(p->dev, buffnum, &curr_write, stream_id);
+
+		memset(&stream->pids[0], -1, sizeof(stream->pids));
+
+	} else {
+		p->stream_links[stream_id]->count++;
+		stream = p->streams[stream_id];
+		buffnum = stream->buffnum;
+
+		if (dvbdmxfeed->pid != WILD_PID) {
+			stream->buffer_base_address = 0 + (fenum << 23) + (p->channel_buffer_size * buffnum);
+			stream->sub_base_address = (p->channel_buffer_size * buffnum);
+			stream->buffer_end_address = p->channel_buffer_size * (stream->buffnum + 1);
+
+		} else {
+			stream->buffer_base_address = 0 + (fenum << 23) + (1 << 22);
+			stream->sub_base_address = stream->buffer_base_address;
+			stream->buffer_end_address = stream->buffer_base_address + wildcard_buffer_size;
+
+		}
+
+		stream->last_read = stream->sub_base_address;
+		prospero_set_current_write_pointer_A(p->dev, buffnum, stream->last_read, stream_id);
+
+	}
+
+	/* set the guard pointers and enable channel */
+	prospero_get_control_bits(p->dev, &cbits, stream->buffnum, stream_id);
+
+	if (!cbits.guard_value_enabled) {
+		prospero_set_buffer_base_address(p->dev, stream->buffer_base_address, stream_id);
+		prospero_set_buffer_end_address(p->dev, stream->buffer_end_address, stream_id);
+
+		if (dvbdmxfeed->pid == WILD_PID)
+			prospero_set_guard_value_A(p->dev, (stream->sub_base_address + p->wild_buffer_increment), stream_id);
+		else
+			prospero_set_guard_value_A(p->dev, (stream->sub_base_address + p->buffer_increment), stream_id);
+
+
+		prospero_set_guard_value_enabled(p->dev, 1, stream_id);
+
+	}
+
+	prospero_get_control_bits(p->dev, &cbits, stream->buffnum, stream_id);
+
+	if (!cbits.interrupt_enabled) {
+		if (dvbdmxfeed->pid == WILD_PID)
+			prospero_set_int_trigger_address(p->dev, buffnum, (stream->sub_base_address + p->wild_interrupt_increment), stream_id);
+		else
+			prospero_set_int_trigger_address(p->dev, buffnum, (stream->sub_base_address + p->interrupt_increment), stream_id);
+
+		prospero_set_channel_interrupt(p->dev, 1, stream_id);
+
+	}
+
+	prospero_get_control_bits(p->dev, &cbits, stream->buffnum, stream_id);
+
+	if ((cbits.guard_value_enabled) && (cbits.interrupt_enabled)) {
+		p->p_demux[fenum].buffers[buffnum] = stream_id;
+		prospero_set_channel_enabled(p->dev, 1, stream_id);
+
+		stream->active = 1;
+		stream->serviced = 0;
+
+	}
+
+	ret = prospero_set_pid(p->dev, dvbdmxfeed);
+	if (ret != 0)
+		goto exit;
+
+	iowrite8(0xFF, p_pci->io_mem + TS_CAP_ENABLE);
+
+	prospero_get_control_bits(p->dev, &cbits, stream->buffnum, stream_id);
+	stream = p->streams[stream_id];
+
+	pr_debug("start feed, demux index = %d\n", dvbdmxfeed->index);
+
+ exit:
+	return ret;
+
+}
+
+static int prospero_dvb_stop_feed(struct dvb_demux_feed *dvbdmxfeed)
+{
+
+	struct prospero_device *p = dvbdmxfeed->demux->priv;
+	struct dmx_ts_feed *ts_feed;
+	struct dmx_section_feed *sec_feed;
+	struct dmxdev_filter *dmxdevfilter;
+	int ret = 0;
+	int stream_id = 0;
+	unsigned long buff_id;
+
+	if (dvbdmxfeed->type == DMX_TYPE_TS) {
+		ts_feed = (struct dmx_ts_feed *)dvbdmxfeed;
+		dmxdevfilter = ts_feed->priv;
+
+	} else if (dvbdmxfeed->type == DMX_TYPE_SEC) {
+		sec_feed = (struct dmx_section_feed *)dvbdmxfeed;
+		dmxdevfilter = sec_feed->priv;
+
+	} else {
+		return -ENOTSUPP;
+	}
+
+	buff_id = (long)&dmxdevfilter->buffer;
+
+	ret = get_stream_id(p, &stream_id, buff_id);
+
+	/* need to clear the pid table */
+	ret = prospero_disable_pid(p->dev, dvbdmxfeed);
+
+	p->streams[stream_id]->active = 0;
+
+	/* disable the stream */
+	p->stream_links[stream_id]->count--;
+	if (p->stream_links[stream_id]->count < 1)
+		p->stream_links[stream_id]->buffer_pointer = 0;
+
+	pr_debug("stop feed stream %d buffer pointer = %lx", stream_id, p->stream_links[stream_id]->buffer_pointer);
+
+	prospero_set_guard_value_enabled(p->dev, 0, stream_id);
+	prospero_set_channel_interrupt(p->dev, 0, stream_id);
+	prospero_set_channel_enabled(p->dev, 0, stream_id);
+
+	return 0;
+
+}
+
+static int init_demux(int fenum, int devnum, struct prospero_device *p)
+{
+
+	int ret;
+
+	p->demux[devnum].dmx.capabilities = (DMX_TS_FILTERING | DMX_SECTION_FILTERING | DMX_MEMORY_BASED_FILTERING);
+	p->demux[devnum].priv = p;
+	p->demux[devnum].filternum = p->demux[devnum].feednum = 255;
+	p->demux[devnum].start_feed = prospero_dvb_start_feed;
+	p->demux[devnum].stop_feed = prospero_dvb_stop_feed;
+	p->demux[devnum].write_to_decoder = NULL;
+
+	/*
+	 * Initialise the demux
+	 * This doesn't start the feeds etc, just sets the demux
+	 * settings to default values and allocates memory
+	 */
+	ret = dvb_dmx_init(&p->demux[devnum]);
+	if (ret < 0) {
+		pr_err("demux initialisation failed: error %d", ret);
+		goto err_dmx;
+	}
+
+	p->hw_frontend[fenum].source = fenum + 1;
+
+	pr_debug("setting demux %d to frontend %d", devnum, fenum);
+
+	p->dmxdev[devnum].filternum = p->demux[devnum].feednum;
+	p->dmxdev[devnum].demux = &p->demux[devnum].dmx;
+	p->dmxdev[devnum].capabilities = 0;
+
+	ret = dvb_dmxdev_init(&p->dmxdev[devnum], &p->dvb_adapter);
+	if (ret < 0) {
+		pr_err("demux device initialisation failed: error %d", ret);
+		goto err_dmx_dev;
+	}
+
+	ret = p->demux[devnum].dmx.add_frontend(&p->demux[devnum].dmx, &p->hw_frontend[fenum]);
+	if (ret < 0) {
+		pr_err("adding hw_frontend to demux failed: error %d", ret);
+		goto err_dmx_add_hw_frontend;
+	}
+
+	ret = p->demux[devnum].dmx.connect_frontend(&p->demux[devnum].dmx, &p->hw_frontend[fenum]);
+	if (ret < 0) {
+		pr_err("connect frontend failed: error %d", ret);
+		goto err_connect_frontend;
+	}
+
+	p->demux_link[devnum] = fenum;
+	return 0;
+
+ err_connect_frontend:
+	p->demux[devnum].dmx.remove_frontend(&p->demux[devnum].dmx, &p->hw_frontend[fenum]);
+
+ err_dmx_add_hw_frontend:
+	dvb_dmxdev_release(&p->dmxdev[devnum]);
+
+ err_dmx_dev:
+	dvb_dmx_release(&p->demux[devnum]);
+
+ err_dmx:
+	return ret;
+
+}
+
+static int prospero_demux_init(struct prospero_device *p)
+{
+	int x;
+	int num_init = 0;
+	int fenum = 0;
+	int ret = 0;
+	int max_fe = p->num_frontends;
+
+	for (x = 0; x < max_fe; x++) {
+
+		ret = init_demux(fenum, x, p);
+		if (ret == 0) {
+			num_init++;
+			p->num_demuxs++;
+
+			if (fenum < (max_fe - 1))
+				fenum++;
+			else
+				fenum = 0;
+		}
+	}
+
+	if (num_init < 1)
+		goto err_dmx_init;
+
+	p->num_init = num_init;
+	return 0;
+
+ err_dmx_init:
+	pr_err("error during demux initialisation");
+	dvb_unregister_adapter(&p->dvb_adapter);
+	return -EIO;
+}
+
+static int prospero_dvb_init(struct prospero_device *p)
+{
+
+	int ret = dvb_register_adapter(&p->dvb_adapter,
+				       "Prospero Digital TV device", p->owner,
+				       p->dev, adapter_nr);
+	if (ret < 0) {
+		pr_err("error registering DVB adapter");
+		return ret;
+	}
+
+	p->dvb_adapter.priv = p;
+
+	dev_set_drvdata(p->dev, p);
+
+	p->num_demuxs = 0;
+
+	/* initialise the command sequence number */
+	p->command_seqno = 1;
+
+	p->init_state |= P_STATE_DVB_INIT;
+
+	return 0;
+
+}
+
+void prospero_device_exit(struct prospero_device *p)
+{
+	prospero_dvb_exit(p);
+}
+
+static ssize_t show_firmware_version(struct device *dev, struct device_attribute *attr, char *buf)
+{
+
+	struct prospero_device *pdev = dev_get_drvdata(dev);
+	struct prospero_pci *p_pci = pdev->bus_specific;
+
+	u8 version;
+
+	version = ioread8(p_pci->io_mem + FIRMWARE_VERSION);
+
+	return sprintf(buf, "%x", version);
+
+}
+
+static ssize_t store_firmware_version(struct device *dev, struct device_attribute *attr, const char *buf, size_t count)
+{
+
+	unsigned int tmp;
+	uint8_t leds;
+	int ret;
+
+	ret = kstrtouint(buf, 16, &tmp);
+	if (ret != 0)
+		return 0;
+
+	leds = tmp;
+
+	/* placeholder routine for writing to the firmware version */
+
+	return count;
+
+}
+
+static ssize_t show_fwflash(struct device *dev, struct device_attribute *attr, char *buf)
+{
+
+	struct prospero_device *pdev = dev_get_drvdata(dev);
+
+	pr_debug("flash in progress %d\n", pdev->flash_in_progress);
+
+	return sprintf(buf, "%d\n", pdev->flash_in_progress);
+
+}
+
+static ssize_t show_led_status(struct device *dev, struct device_attribute *attr, char *buf)
+{
+
+	/*struct prospero_device *pdev = to_prospero_device(dev);
+	struct prospero_device *pdev = container_of(dev, struct prospero_device, dev );*/
+
+	struct prospero_device *pdev = dev_get_drvdata(dev);
+
+	/* struct prospero_pci *p_pci = container_of(pdev, struct prospero_pci, pdev); */
+
+	struct prospero_pci *p_pci = pdev->bus_specific;
+
+	uint8_t leds;
+
+	leds = ioread8(p_pci->BAR0 + LED_OFFSET);
+
+	pr_debug("leds are set to: %d\n", leds);
+
+	return sprintf(buf, "%d", leds);
+
+}
+
+static ssize_t store_leds(struct device *dev, struct device_attribute *attr, const char *buf, size_t count)
+{
+
+	struct prospero_device *pdev = dev_get_drvdata(dev);
+
+	struct prospero_pci *p_pci = pdev->bus_specific;
+
+	unsigned int tmp;
+	uint8_t leds;
+	int ret;
+
+	ret = kstrtouint(buf, 16, &tmp);
+	if (ret != 0)
+		return 0;
+
+	leds = tmp;
+
+	pr_debug("user wrote %x to leds\n", leds);
+
+	iowrite8(leds, p_pci->BAR0 + LED_OFFSET);
+
+	return count;
+
+}
+
+static void eeprom_erase(struct prospero_pci *p_pci)
+{
+
+	int address = 0x000000;
+	int tmp = 0;
+
+	pr_debug("starting the erase cycle\n");
+
+	iowrite32(address, p_pci->io_mem + FLASH_ADDRESS);
+	iowrite8(0x1, p_pci->io_mem + FLASH_ERASE);
+	do {
+		tmp = ioread8(p_pci->io_mem + FLASH_BUSY);
+	} while (tmp != 0);
+
+	pr_debug("end of the erase cycle\n");
+
+}
+
+static void send_file(struct prospero_pci *p_pci, const struct firmware *fw)
+{
+
+	int address = 0x00;
+	int x = 0;
+	int bytes = 0;
+	/* int loop = fw->size / 256; */
+	uint8_t data;
+	int dcp = 0;
+	uint8_t tmp;
+
+	dev_info(p_pci->p_dev->dev, "sending fw file\n");
+	pr_debug("firmware file size = %d", fw->size);
+
+	while (address < fw->size) {
+		if ((fw->size - address) > 256)
+			bytes = 256;
+		else
+			bytes = fw->size - address;
+
+
+		for (x = 0; x < 256; x++) {
+			do {
+				tmp = ioread8(p_pci->io_mem + FLASH_BUSY);
+				pr_debug("FLASH_busy!\n");
+			} while (tmp != 0);
+
+			if (x < bytes) {
+				memcpy(&data, fw->data + dcp, 1);
+				iowrite8(data, p_pci->io_mem + FLASH_DATA);
+			} else {
+				iowrite8(0xFF, p_pci->io_mem + FLASH_DATA);
+			}
+
+			dcp++;
+		}
+
+		do {
+			tmp = ioread8(p_pci->io_mem + FLASH_BUSY);
+			pr_debug("FLASH_busy!\n");
+		} while (tmp != 0);
+
+		iowrite32(address, p_pci->io_mem + FLASH_ADDRESS);
+		iowrite8(0x1, p_pci->io_mem + FLASH_WRITE);
+
+		do {
+			tmp = ioread8(p_pci->io_mem + FLASH_BUSY);
+		} while (tmp != 0);
+
+		address = address + 256;
+
+	}
+
+	dev_info(p_pci->p_dev->dev, "finished sending fw\n");
+
+}
+
+static ssize_t store_fwflash(struct device *dev, struct device_attribute *attr, const char *buf, size_t count)
+{
+
+	int input = 0;
+	int ret = 0;
+
+	char name[] = "prospero_fw.bin";
+
+	const struct firmware *fw = NULL;
+
+	struct prospero_device *pdev = dev_get_drvdata(dev);
+
+	struct prospero_pci *p_pci = pdev->bus_specific;
+
+	dev_info(dev, "firmware update!");
+
+	if (pdev->flash_in_progress > 0)
+		goto error;
+
+	pdev->flash_in_progress = 1;
+
+	ret = kstrtouint(buf, 16, &input);
+	if (ret != 0)
+		return 0;
+
+	if (input > 0) {
+
+		ret = request_firmware(&fw, name, dev);
+		if (ret != 0) {
+			pr_err("Failed to get the firmware file");
+
+		} else {
+			dev_info(dev, "successfully loaded the firmware file\n");
+
+			/* the firmware image is now in fw and should probably be
+			 * checked then copied to the flash. Once we have finished
+			 * with the image then we need to release it as below
+			 */
+
+			eeprom_erase(p_pci);
+			send_file(p_pci, fw);
+			release_firmware(fw);
+
+		}
+
+	}
+
+	pdev->flash_in_progress = 0;
+
+	return count;
+
+ error:
+	pr_err("Device is already writing to flash\n");
+	return count;
+
+}
+
+DEVICE_ATTR(firmware_version, 0644, show_firmware_version, store_firmware_version);
+DEVICE_ATTR(fwflash, 0644, show_fwflash, store_fwflash);
+DEVICE_ATTR(leds, 0644, show_led_status, store_leds);
+
+int prospero_device_initialize(struct prospero_device *p)
+{
+	int ret = 0;
+
+	ret = prospero_ir_init(p);
+	if (ret != 0) {
+		pr_err("prospero infra-red device failed to initialise\n");
+		return ret;
+	}
+
+	ret = prospero_dvb_init(p);
+	if (ret != 0)
+		return ret;
+
+	ret = prospero_i2c_init(p);
+	if (ret != 0)
+		return ret;
+
+	ret = prospero_frontend_init(p);
+	if (ret != 0)
+		return ret;
+
+	prospero_demux_init(p);
+
+	pr_info("Prospero Frontend Initialised\n");
+
+	ret = device_create_file(p->dev, &dev_attr_firmware_version);
+	if (ret < 0)
+		pr_err("failed to create sysfs firmware version file");
+
+	ret = device_create_file(p->dev, &dev_attr_fwflash);
+	if (ret < 0)
+		pr_err("Failed to create sysfs reflash files");
+
+	ret = device_create_file(p->dev, &dev_attr_leds);
+	if (ret < 0)
+		pr_err("Failed to create sysfs LED files");
+
+	return ret;
+}
+
+static int prospero_allocate_dma(struct pci_dev *pcidev, int fenum, struct device *dev)
+{
+
+	int ret = 0;
+	struct prospero_device *p = dev_get_drvdata(dev);
+
+	pr_debug("buffer_size %d, channel_buffer_size=%d, guard = %d, int = %d", ts_buffer_size, p->channel_buffer_size, p->buffer_increment, p->interrupt_increment);
+
+	p->p_demux[fenum].ts_membuf_ptr = pci_alloc_consistent(pcidev, ts_buffer_size, &p->p_demux[fenum].ts_cdma);
+	if (p->p_demux[fenum].ts_membuf_ptr != NULL) {
+		pr_debug("DMA SUCCESS for ts buffer; virt_add = %p; size = %d\n", p->p_demux[fenum].ts_membuf_ptr, ts_buffer_size);
+
+		memset(p->p_demux[fenum].ts_membuf_ptr, 0xCC, ts_buffer_size);
+
+		ret = 0;
+
+	} else {
+		pr_err("DMA FAILURE for transport stream buffer\n");
+		ret = -EIO;
+	}
+
+	p->p_demux[fenum].wildcard_membuf_ptr = pci_alloc_consistent(pcidev, wildcard_buffer_size, &p->p_demux[fenum].wildcard_cdma);
+	if (p->p_demux[fenum].wildcard_membuf_ptr != NULL) {
+		pr_debug("DMA SUCCESS for wildcard buffer; virt_add = %p; size = %d\n", p->p_demux[fenum].wildcard_membuf_ptr, wildcard_buffer_size);
+
+		memset(p->p_demux[fenum].wildcard_membuf_ptr, 0xCC, wildcard_buffer_size);
+
+		ret = 0;
+
+	} else {
+		pr_err("DMA FAILURE for transport stream buffer\n");
+		ret = -EIO;
+	}
+
+	return ret;
+
+}
+
+static int prospero_pci_dma_init(struct pci_dev *pcidev, struct prospero_device *p)
+{
+
+	struct prospero_pci *p_pci = p->bus_specific;
+	struct device *dev = p->dev;
+	struct dvb_frontend *fe;
+	int *offset1;
+	int *offset2;
+	int dma;
+	int ret;
+	int i;
+	u64 mask;
+
+	mask = dma_get_required_mask(dev);
+	dma = pci_dma_supported(pcidev, mask);
+
+	pr_debug("DMA ALLOWED = %d\n", dma);
+
+	for (i = 0; i < p->num_frontends; i++) {
+		if (p->fe[i] == NULL)
+			continue;
+
+		fe = p->fe[i];
+
+		offset1 = p_pci->io_mem + p->p_demux[i].buffer1_ptr;
+		offset2 = p_pci->io_mem + p->p_demux[i].buffer2_ptr;
+
+		ret = prospero_allocate_dma(pcidev, i, dev);
+
+		if (ret < 0)
+			return ret;
+
+		pr_debug("buffer1 before write dma address is set to %x\n", ioread32(offset1));
+		pr_debug("buffer2 before write dma address is set to %x\n", ioread32(offset2));
+
+		iowrite32(p->p_demux[i].ts_cdma, offset1);
+		iowrite32(p->p_demux[i].wildcard_cdma, offset2);
+
+		pr_debug("buffer1 virtual mem = %p\n", p->p_demux[i].ts_membuf_ptr);
+		pr_debug("buffer2 virtual mem = %p\n", p->p_demux[i].wildcard_membuf_ptr);
+
+		p_pci->init_state |= P_PCI_DMA_INIT;
+
+		pr_debug("DMA state = %04X\n", p_pci->init_state);
+
+		/* initialise the PID LOOKUP RAM */
+		memset(p_pci->io_mem + p->p_demux[i].Pid_Table_Offset, 0x00, 320);
+		memset(p_pci->io_mem + p->p_demux[i].Buffer_Definition_Ram, 0x00, 2048);
+
+	}
+
+	return 0;
+}
+
+static void prospero_pci_dma_exit(struct pci_dev *pcidev)
+{
+	struct prospero_device *prospero_dev = dev_get_drvdata(&pcidev->dev);
+	struct dvb_frontend *fe;
+	struct prospero_pci *p_pci = pci_get_drvdata(pcidev);
+	int temp;
+	int z = 0;
+	int x = 0;
+
+	pr_debug("DMA state = %04X\n", p_pci->init_state);
+
+	temp = p_pci->init_state & P_PCI_DMA_INIT;
+
+	pr_debug("result = %d, compare = %d", temp, P_PCI_DMA_INIT);
+
+	for (x = 0; x < prospero_dev->num_frontends; x++) {
+		fe = prospero_dev->fe[x];
+
+		pr_debug("DMA freeing ts buffer, for frontend %d\n", x);
+		pci_free_consistent(pcidev, ts_buffer_size, prospero_dev->p_demux[x].ts_membuf_ptr, prospero_dev->p_demux[x].ts_cdma);
+
+		pr_debug("DMA freeing wildcard buffer, for frontend %d\n", x);
+		pci_free_consistent(pcidev, wildcard_buffer_size, prospero_dev->p_demux[x].wildcard_membuf_ptr, prospero_dev->p_demux[x].wildcard_cdma);
+
+	}
+
+	for (z = 0; z < MAX_STREAMS; z++) {
+		if (prospero_dev->streams[z] != NULL)
+			kfree(prospero_dev->streams[z]);
+	}
+
+}
+
+static int prospero_pci_probe(struct pci_dev *pcidev, const struct pci_device_id *ent)
+{
+
+	struct prospero_device *p;
+	struct prospero_pci *p_pci;
+	u8 version = 0;
+	int ret = -ENOMEM;
+
+	pr_debug("loading prospero pci\n");
+
+	p = prospero_device_kmalloc(sizeof(struct prospero_pci));
+	if (p == NULL) {
+		pr_err("out of memory\n");
+		return -ENOMEM;
+	}
+
+	/* calculate buffer sizes and pointer increments, ensuring they are a multiple of packet size */
+	p->wild_buffer_increment = ((((wildcard_buffer_size / 100) * 50) / 188) * 188);
+	p->wild_interrupt_increment = ((((wildcard_buffer_size / 100) * 70) / 188) * 188);
+	p->channel_buffer_size = (((ts_buffer_size / STREAMS_PER_DEMUX) / 188) * 188);
+	p->buffer_increment = ((((p->channel_buffer_size / 100) * 50) / 188) * 188);
+	p->interrupt_increment = ((((p->channel_buffer_size / 100) * 70) / 188) * 188);
+
+	pr_debug("wildcard_buffer_size= %d;", wildcard_buffer_size);
+	pr_debug("ts_buffer_size= %d;",  ts_buffer_size);
+	pr_debug("channel_buffer_size= %d\n", p->channel_buffer_size);
+	pr_debug("wild_buffer_increment= %d;", p->wild_buffer_increment);
+	pr_debug("wild_interrupt_increment= %d;", p->wild_interrupt_increment);
+	pr_debug("buffer_increment= %d;", p->buffer_increment);
+	pr_debug("interrupt_increment= %d\n", p->interrupt_increment);
+
+	p_pci = p->bus_specific;
+	p_pci->p_dev = p;
+
+	p->dev = &pcidev->dev;
+	p->owner = THIS_MODULE;
+
+	/* bus specific part */
+	p_pci->pcidev = pcidev;
+	ret = prospero_pci_init(p_pci);
+	if (ret != 0)
+		goto err_kfree;
+
+	ret = prospero_device_initialize(p);
+	if (ret != 0)
+		goto err_pci_exit;
+
+	ret = prospero_pci_dma_init(pcidev, p);
+	if (ret != 0)
+		goto err_pci_exit;
+
+	prospero_enable_interrupts(p_pci);
+
+	pro = p;
+
+	memset(&p->streams, 0, sizeof(p->streams));
+	memset(&p->stream_links, 0, sizeof(p->stream_links));
+
+	version = ioread8(p_pci->io_mem + FIRMWARE_VERSION);
+
+	pr_debug("Prospero Firmware version is %x\n", version);
+
+	pr_debug("wildcard_buffer_size= %d; ts_buffer_size= %d; channel_buffer_size= %d\n", wildcard_buffer_size, ts_buffer_size, p->channel_buffer_size);
+	pr_debug("wild_buffer_increment= %d; wild_interrupt_increment= %d; buffer_increment= %d; interrupt_increment= %d\n", p->wild_buffer_increment, p->wild_interrupt_increment, p->buffer_increment,
+		 p->interrupt_increment);
+
+	return ret;
+
+ err_pci_exit:
+	prospero_pci_exit(p);
+
+ err_kfree:
+	prospero_device_kfree(p);
+	return ret;
+
+}
+
+static void prospero_pci_remove(struct pci_dev *pcidev)
+{
+
+	struct prospero_device *prospero_dev = dev_get_drvdata(&pcidev->dev);
+	struct prospero_pci *p_pci = prospero_dev->bus_specific;
+
+	/* uninitialise the device here */
+
+	pr_debug("remove prospero\n");
+	pr_debug("wildcard_buffer_size= %d;\n", wildcard_buffer_size);
+	pr_debug("ts_buffer_size= %d;\n", ts_buffer_size);
+	pr_debug("channel_buffer_size= %d\n", prospero_dev->channel_buffer_size);
+	pr_debug("wild_buffer_increment= %d;\n",  prospero_dev->wild_buffer_increment);
+	pr_debug("wild_interrupt_increment= %d;\n", prospero_dev->wild_interrupt_increment);
+	pr_debug("buffer_increment= %d;\n", prospero_dev->buffer_increment);
+	pr_debug("interrupt_increment= %d\n", prospero_dev->interrupt_increment);
+
+	iowrite8(0x00, p_pci->io_mem + TS_CAP_ENABLE);
+
+	prospero_disable_interrupts(p_pci);
+	device_remove_file(&pcidev->dev, &dev_attr_firmware_version);
+	device_remove_file(&pcidev->dev, &dev_attr_fwflash);
+	device_remove_file(&pcidev->dev, &dev_attr_leds);
+
+	prospero_pci_dma_exit(pcidev);
+
+	prospero_device_exit(prospero_dev);
+
+	prospero_pci_exit(prospero_dev);
+
+	prospero_device_kfree(prospero_dev);
+
+}
+
+static struct pci_device_id prospero_pci_tbl[] = {
+	{PCI_DEVICE(0x1d3a, 0x1001)},
+	{},
+};
+
+MODULE_DEVICE_TABLE(pci, prospero_pci_tbl);
+
+static struct pci_driver prospero_pci_driver = {
+	.name = "prospero",
+	.id_table = prospero_pci_tbl,
+	.probe = prospero_pci_probe,
+	.remove = prospero_pci_remove,
+};
+
+static int __init prospero_init(void)
+{
+
+	return pci_register_driver(&prospero_pci_driver);
+
+}
+
+static void __exit prospero_exit(void)
+{
+	pci_unregister_driver(&prospero_pci_driver);
+}
+
+module_init(prospero_init);
+module_exit(prospero_exit);
-- 
2.1.4

