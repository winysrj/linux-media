Return-path: <linux-media-owner@vger.kernel.org>
Received: from 173-160-178-141-Washington.hfc.comcastbusiness.net ([173.160.178.141]:46265
	"EHLO relay" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932144Ab2JWSoa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Oct 2012 14:44:30 -0400
From: Andrey Smirnov <andrey.smirnov@convergeddevices.net>
To: andrey.smirnov@convergeddevices.net
Cc: hverkuil@xs4all.nl, mchehab@redhat.com, sameo@linux.intel.com,
	broonie@opensource.wolfsonmicro.com, perex@perex.cz, tiwai@suse.de,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: =?UTF-8?q?=5BPATCH=20v3=201/6=5D=20Add=20header=20files=20and=20Kbuild=20plumbing=20for=20SI476x=20MFD=20core?=
Date: Tue, 23 Oct 2012 11:44:27 -0700
Message-Id: <1351017872-32488-2-git-send-email-andrey.smirnov@convergeddevices.net>
In-Reply-To: <1351017872-32488-1-git-send-email-andrey.smirnov@convergeddevices.net>
References: <1351017872-32488-1-git-send-email-andrey.smirnov@convergeddevices.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds all necessary header files and Kbuild plumbing for the
core driver for Silicon Laboratories Si476x series of AM/FM tuner
chips.

The driver as a whole is implemented as an MFD device and this patch
adds a core portion of it that provides all the necessary
functionality to the two other drivers that represent radio and audio
codec subsystems of the chip.

Signed-off-by: Andrey Smirnov <andrey.smirnov@convergeddevices.net>
---
 drivers/mfd/Kconfig             |   14 +
 drivers/mfd/Makefile            |    3 +
 include/linux/mfd/si476x-core.h |  539 +++++++++++++++++++++++++++++++++++++++
 include/media/si476x.h          |  427 +++++++++++++++++++++++++++++++
 4 files changed, 983 insertions(+)
 create mode 100644 include/linux/mfd/si476x-core.h
 create mode 100644 include/media/si476x.h

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index b1a1462..3fab06d 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -895,6 +895,20 @@ config MFD_WL1273_CORE
 	  driver connects the radio-wl1273 V4L2 module and the wl1273
 	  audio codec.
 
+config MFD_SI476X_CORE
+	tristate "Support for Silicon Laboratories 4761/64/68 AM/FM radio."
+	depends on I2C
+	select MFD_CORE
+	default n
+	help
+	  This is the core driver for the SI476x series of AM/FM radio. This MFD
+	  driver connects the radio-si476x V4L2 module and the si476x
+	  audio codec.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called si476x-core.
+
+
 config MFD_OMAP_USB_HOST
 	bool "Support OMAP USBHS core driver"
 	depends on USB_EHCI_HCD_OMAP || USB_OHCI_HCD_OMAP3
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 79dd22d..942257b 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -132,3 +132,6 @@ obj-$(CONFIG_MFD_RC5T583)	+= rc5t583.o rc5t583-irq.o
 obj-$(CONFIG_MFD_SEC_CORE)	+= sec-core.o sec-irq.o
 obj-$(CONFIG_MFD_ANATOP)	+= anatop-mfd.o
 obj-$(CONFIG_MFD_LM3533)	+= lm3533-core.o lm3533-ctrlbank.o
+
+si476x-core-objs := si476x-cmd.o si476x-prop.o si476x-i2c.o
+obj-$(CONFIG_MFD_SI476X_CORE)	+= si476x-core.o
diff --git a/include/linux/mfd/si476x-core.h b/include/linux/mfd/si476x-core.h
new file mode 100644
index 0000000..08bc5dd
--- /dev/null
+++ b/include/linux/mfd/si476x-core.h
@@ -0,0 +1,539 @@
+/*
+ * include/media/si476x-core.h -- Common definitions for si476x core
+ * device
+ *
+ * Copyright (C) 2012 Innovative Converged Devices(ICD)
+ *
+ * Author: Andrey Smirnov <andrey.smirnov@convergeddevices.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ */
+
+#ifndef SI476X_CORE_H
+#define SI476X_CORE_H
+
+#include <linux/kfifo.h>
+#include <linux/atomic.h>
+#include <linux/i2c.h>
+#include <linux/regmap.h>
+#include <linux/mutex.h>
+#include <linux/mfd/core.h>
+#include <linux/videodev2.h>
+#include <linux/regulator/consumer.h>
+
+#include <media/si476x.h>
+
+#ifdef DEBUG
+#define DBG_BUFFER(device, header, buffer, bcount)			\
+	do {								\
+		dev_info((device), header);				\
+		print_hex_dump_bytes("",				\
+				     DUMP_PREFIX_OFFSET,		\
+				     buffer, bcount);			\
+	} while (0)
+#else
+#define DBG_BUFFER(device, header, buffer, bcount)			\
+	do {} while (0)
+#endif
+
+/* -------------------- si476x-i2c.c ----------------------- */
+
+enum si476x_freq_supported_chips {
+	SI476X_CHIP_SI4761 = 1,
+	SI476X_CHIP_SI4764,
+	SI476X_CHIP_SI4768,
+};
+
+enum si476x_mfd_cells {
+	SI476X_RADIO_CELL = 0,
+	SI476X_CODEC_CELL,
+	SI476X_MFD_CELLS,
+};
+
+/**
+ * enum si476x_power_state - possible power state of the si476x
+ * device.
+ *
+ * @SI476X_POWER_DOWN: In this state all regulators are turned off
+ * and the reset line is pulled low. The device is completely
+ * inactive.
+ * @SI476X_POWER_UP_FULL: In this state all the power regualtors are
+ * turned on, reset line pulled high, IRQ line is enabled(polling is
+ * active for polling use scenario) and device is turned on with
+ * POWER_UP command. The device is ready to be used.
+ * @SI476X_POWER_INCONSISTENT: This state indicates that previous
+ * power down was inconsistent, meaning some of the regulators were
+ * not turned down and thus use of the device, without power-cycling
+ * is impossible.
+ */
+enum si476x_power_state {
+	SI476X_POWER_DOWN		= 0,
+	SI476X_POWER_UP_FULL		= 1,
+	SI476X_POWER_INCONSISTENT	= 2,
+};
+
+/**
+ * struct si476x_core - internal data structure representing the
+ * underlying "core" device which all the MFD cell-devices use.
+ *
+ * @client: Actual I2C client used to transfer commands to the chip.
+ * @chip_id: Last digit of the chip model(E.g. "1" for SI4761)
+ * @cells: MFD cell devices created by this driver.
+ * @cmd_lock: Mutex used to serialize all the requests to the core
+ * device. This filed should not be used directly. Instead
+ * si476x_core_lock()/si476x_core_unlock() should be used to get
+ * exclusive access to the "core" device.
+ * @users: Active users counter(Used by the radio cell)
+ * @rds_read_queue: Wait queue used to wait for RDS data.
+ * @rds_fifo: FIFO in which all the RDS data received from the chip is
+ * placed.
+ * @rds_fifo_drainer: Worker that drains on-chip RDS FIFO.
+ * @rds_drainer_is_working: Flag used for launching only one instance
+ * of the @rds_fifo_drainer.
+ * @rds_drainer_status_lock: Lock used to guard access to the
+ * @rds_drainer_is_working variable.
+ * @command: Wait queue for wainting on the command comapletion.
+ * @cts: Clear To Send flag set upon receiving first status with CTS
+ * set.
+ * @tuning: Wait queue used for wainting for tune/seek comand
+ * completion.
+ * @stc: Similar to @cts, but for the STC bit of the status value.
+ * @power_up_parameters: Parameters used as argument for POWER_UP
+ * command when the device is started.
+ * @state: Current power state of the device.
+ * @supplues: Structure containing handles to all power supplies used
+ * by the device (NULL ones are ignored).
+ * @gpio_reset: GPIO pin connectet to the RSTB pin of the chip.
+ * @pinmux: Chip's configurable pins configuration.
+ * @diversity_mode: Chips role when functioning in diversity mode.
+ * @status_monitor: Polling worker used in polling use case scenarion
+ * (when IRQ is not avalible).
+ * @revision: Chip's running firmware revision number(Used for correct
+ * command set support).
+ */
+
+struct si476x_core {
+	struct i2c_client *client;
+	struct regmap *regmap;
+	int chip_id;
+	struct mfd_cell cells[SI476X_MFD_CELLS];
+
+	struct mutex cmd_lock; /* for serializing fm radio operations */
+	atomic_t users;
+
+	wait_queue_head_t  rds_read_queue;
+	struct kfifo       rds_fifo;
+	struct work_struct rds_fifo_drainer;
+	bool               rds_drainer_is_working;
+	struct mutex       rds_drainer_status_lock;
+
+	wait_queue_head_t command;
+	atomic_t          cts;
+
+	wait_queue_head_t tuning;
+	atomic_t          stc;
+
+	struct si476x_power_up_args power_up_parameters;
+
+	enum si476x_power_state power_state;
+
+	struct regulator_bulk_data supplies[4];
+
+	int gpio_reset;
+
+	struct si476x_pinmux pinmux;
+	enum si476x_phase_diversity_mode diversity_mode;
+
+	atomic_t is_alive;
+
+	struct delayed_work status_monitor;
+#define SI476X_WORK_TO_CORE(w) container_of(to_delayed_work(w),	\
+					    struct si476x_core,	\
+					    status_monitor)
+
+	int revision;
+
+	int rds_fifo_depth;
+
+	struct {
+		atomic_t tune;
+		atomic_t power_up;
+		atomic_t command;
+	} timeouts;
+
+	atomic_t polling_interval;
+};
+
+static inline struct si476x_core *i2c_mfd_cell_to_core(struct device *dev)
+{
+	struct i2c_client *client = to_i2c_client(dev->parent);
+	return i2c_get_clientdata(client);
+}
+
+
+/**
+ * si476x_core_lock() - lock the core device to get an exclusive access
+ * to it.
+ */
+static inline void si476x_core_lock(struct si476x_core *core)
+{
+	mutex_lock(&core->cmd_lock);
+}
+
+/**
+ * si476x_core_unlock() - unlock the core device to relinquish an
+ * exclusive access to it.
+ */
+static inline void si476x_core_unlock(struct si476x_core *core)
+{
+	mutex_unlock(&core->cmd_lock);
+}
+
+/* *_TUNE_FREQ family of commands accept frequency in multiples of
+    10kHz */
+static inline u16 hz_to_si476x(struct si476x_core *core, int freq)
+{
+	u16 result;
+
+	switch (core->power_up_parameters.func) {
+	default:
+	case SI476X_FUNC_FM_RECEIVER:
+		result = freq / 10000;
+		break;
+	case SI476X_FUNC_AM_RECEIVER:
+		result = freq / 1000;
+		break;
+	}
+
+	return result;
+}
+
+static inline int si476x_to_hz(struct si476x_core *core, u16 freq)
+{
+	int result;
+
+	switch (core->power_up_parameters.func) {
+	default:
+	case SI476X_FUNC_FM_RECEIVER:
+		result = freq * 10000;
+		break;
+	case SI476X_FUNC_AM_RECEIVER:
+		result = freq * 1000;
+		break;
+	}
+
+	return result;
+}
+
+/* Since the V4L2_TUNER_CAP_LOW flag is supplied, V4L2 subsystem
+ * mesures frequency in 62.5 Hz units */
+
+static inline int hz_to_v4l2(int freq)
+{
+	return (freq * 10) / 625;
+}
+
+static inline int v4l2_to_hz(int freq)
+{
+	return (freq * 625) / 10;
+}
+
+static inline u16 v4l2_to_si476x(struct si476x_core *core, int freq)
+{
+	return hz_to_si476x(core, v4l2_to_hz(freq));
+}
+
+static inline int si476x_to_v4l2(struct si476x_core *core, u16 freq)
+{
+	return hz_to_v4l2(si476x_to_hz(core, freq));
+}
+
+
+
+/**
+ * struct si476x_func_info - structure containing result of the
+ * FUNC_INFO command.
+ *
+ * @firmware.major: Firmware major number.
+ * @firmware.minor[...]: Firmware minor numbers.
+ * @patch_id:
+ * @func: Mode tuner is working in.
+ */
+struct si476x_func_info {
+	struct {
+		u8 major, minor[2];
+	} firmware;
+	u16 patch_id;
+	enum si476x_func func;
+};
+
+/**
+ * struct si476x_power_down_args - structure used to pass parameters
+ * to POWER_DOWN command
+ *
+ * @xosc: true - Power down, but leav oscillator running.
+ *        false - Full power down.
+ */
+struct si476x_power_down_args {
+	bool xosc;
+};
+
+/**
+ * enum si476x_tunemode - enum representing possible tune modes for
+ * the chip.
+ * @SI476X_TM_VALIDATED_NORMAL_TUNE: Unconditionally stay on the new
+ * channel after tune, tune status is valid.
+ * @SI476X_TM_INVALIDATED_FAST_TUNE: Unconditionally stay in the new
+ * channel after tune, tune status invalid.
+ * @SI476X_TM_VALIDATED_AF_TUNE: Jump back to previous channel if
+ * metric thresholds are not met.
+ * @SI476X_TM_VALIDATED_AF_CHECK: Unconditionally jump back to the
+ * previous channel.
+ */
+enum si476x_tunemode {
+	SI476X_TM_VALIDATED_NORMAL_TUNE = 0,
+	SI476X_TM_INVALIDATED_FAST_TUNE = 1,
+	SI476X_TM_VALIDATED_AF_TUNE     = 2,
+	SI476X_TM_VALIDATED_AF_CHECK    = 3,
+};
+
+/**
+ * enum si476x_smoothmetrics - enum containing the possible setting fo
+ * audio transitioning of the chip
+ * @SI476X_SM_INITIALIZE_AUDIO: Initialize audio state to match this
+ * new channel
+ * @SI476X_SM_TRANSITION_AUDIO: Transition audio state from previous
+ * channel values to the new values
+ */
+enum si476x_smoothmetrics {
+	SI476X_SM_INITIALIZE_AUDIO = 0,
+	SI476X_SM_TRANSITION_AUDIO = 1,
+};
+
+/**
+ * struct si476x_rds_status_report - the structure representing the
+ * response to 'FM_RD_STATUS' command
+ * @rdstpptyint: Traffic program flag(TP) and/or program type(PTY)
+ * code has changed.
+ * @rdspiint: Program indentifiaction(PI) code has changed.
+ * @rdssyncint: RDS synchronization has changed.
+ * @rdsfifoint: RDS was received and the RDS FIFO has at least
+ * 'FM_RDS_INTERRUPT_FIFO_COUNT' elements in it.
+ * @tpptyvalid: TP flag and PTY code are valid falg.
+ * @pivalid: PI code is valid flag.
+ * @rdssync: RDS is currently synchronized.
+ * @rdsfifolost: On or more RDS groups have been lost/discarded flag.
+ * @tp: Current channel's TP flag.
+ * @pty: Current channel's PTY code.
+ * @pi: Current channel's PI code.
+ * @rdsfifoused: Number of blocks remaining in the RDS FIFO (0 if
+ * empty).
+ */
+struct si476x_rds_status_report {
+	bool rdstpptyint, rdspiint, rdssyncint, rdsfifoint;
+	bool tpptyvalid, pivalid, rdssync, rdsfifolost;
+	bool tp;
+
+	u8 pty;
+	u16 pi;
+
+	u8 rdsfifoused;
+	u8 ble[4];
+
+	struct v4l2_rds_data rds[4];
+};
+
+struct si476x_rsq_status_args {
+	bool primary;
+	bool rsqack;
+	bool attune;
+	bool cancel;
+	bool stcack;
+};
+
+enum si476x_injside {
+	SI476X_INJSIDE_AUTO	= 0,
+	SI476X_INJSIDE_LOW	= 1,
+	SI476X_INJSIDE_HIGH	= 2,
+};
+
+struct si476x_tune_freq_args {
+	bool zifsr;
+	bool hd;
+	enum si476x_injside injside;
+	int freq;
+	enum si476x_tunemode tunemode;
+	enum si476x_smoothmetrics smoothmetrics;
+	int antcap;
+};
+
+int  si476x_core_stop(struct si476x_core *, bool);
+int  si476x_core_start(struct si476x_core *, bool);
+int  si476x_core_set_power_state(struct si476x_core *, enum si476x_power_state);
+bool si476x_core_has_am(struct si476x_core *);
+bool si476x_core_has_diversity(struct si476x_core *);
+bool si476x_core_is_a_secondary_tuner(struct si476x_core *);
+bool si476x_core_is_a_primary_tuner(struct si476x_core *);
+bool si476x_core_is_in_am_receiver_mode(struct si476x_core *core);
+
+enum si476x_i2c_type {
+	SI476X_I2C_SEND,
+	SI476X_I2C_RECV
+};
+
+int si476x_core_i2c_xfer(struct si476x_core *,
+			 enum si476x_i2c_type,
+			 char *, int);
+
+
+/* -------------------- si476x-cmd.c ----------------------- */
+
+int si476x_core_cmd_func_info(struct si476x_core *, struct si476x_func_info *);
+int si476x_core_cmd_set_property(struct si476x_core *, u16, u16);
+int si476x_core_cmd_get_property(struct si476x_core *, u16);
+int si476x_core_cmd_dig_audio_pin_cfg(struct si476x_core *,
+				      enum si476x_dclk_config,
+				      enum si476x_dfs_config,
+				      enum si476x_dout_config,
+				      enum si476x_xout_config);
+int si476x_core_cmd_zif_pin_cfg(struct si476x_core *,
+				enum si476x_iqclk_config,
+				enum si476x_iqfs_config,
+				enum si476x_iout_config,
+				enum si476x_qout_config);
+int si476x_core_cmd_ic_link_gpo_ctl_pin_cfg(struct si476x_core *,
+					    enum si476x_icin_config,
+					    enum si476x_icip_config,
+					    enum si476x_icon_config,
+					    enum si476x_icop_config);
+int si476x_core_cmd_ana_audio_pin_cfg(struct si476x_core *,
+				      enum si476x_lrout_config);
+int si476x_core_cmd_intb_pin_cfg(struct si476x_core *, enum si476x_intb_config,
+				 enum si476x_a1_config);
+int si476x_core_cmd_fm_seek_start(struct si476x_core *, bool, bool);
+int si476x_core_cmd_am_seek_start(struct si476x_core *, bool, bool);
+int si476x_core_cmd_fm_rds_status(struct si476x_core *, bool, bool, bool,
+				  struct si476x_rds_status_report *);
+int si476x_core_cmd_fm_rds_blockcount(struct si476x_core *, bool,
+				      struct si476x_rds_blockcount_report *);
+int si476x_core_cmd_fm_tune_freq(struct si476x_core *,
+				 struct si476x_tune_freq_args *);
+int si476x_core_cmd_am_tune_freq(struct si476x_core *,
+				 struct si476x_tune_freq_args *);
+int si476x_core_cmd_am_rsq_status(struct si476x_core *,
+				  struct si476x_rsq_status_args *,
+				  struct si476x_rsq_status_report *);
+int si476x_core_cmd_fm_rsq_status(struct si476x_core *,
+				  struct si476x_rsq_status_args *,
+				  struct si476x_rsq_status_report *);
+int si476x_core_cmd_power_up(struct si476x_core *,
+			     struct si476x_power_up_args *);
+int si476x_core_cmd_power_down(struct si476x_core *,
+			       struct si476x_power_down_args *);
+int si476x_core_cmd_fm_phase_div_status(struct si476x_core *);
+int si476x_core_cmd_fm_phase_diversity(struct si476x_core *,
+				       enum si476x_phase_diversity_mode);
+
+int si476x_core_cmd_fm_acf_status(struct si476x_core *,
+				  struct si476x_acf_status_report *);
+int si476x_core_cmd_am_acf_status(struct si476x_core *,
+				  struct si476x_acf_status_report *);
+int si476x_core_cmd_agc_status(struct si476x_core *,
+			       struct si476x_agc_status_report *);
+
+enum si476x_power_grid_type {
+	SI476X_POWER_GRID_50HZ = 0,
+	SI476X_POWER_GRID_60HZ,
+};
+
+/* Properties  */
+
+enum si476x_interrupt_flags {
+	SI476X_STCIEN = (1 << 0),
+	SI476X_ACFIEN = (1 << 1),
+	SI476X_RDSIEN = (1 << 2),
+	SI476X_RSQIEN = (1 << 3),
+
+	SI476X_ERRIEN = (1 << 6),
+	SI476X_CTSIEN = (1 << 7),
+
+	SI476X_STCREP = (1 << 8),
+	SI476X_ACFREP = (1 << 9),
+	SI476X_RDSREP = (1 << 10),
+	SI476X_RSQREP = (1 << 11),
+};
+
+enum si476x_rdsint_sources {
+	SI476X_RDSTPPTY = (1 << 4),
+	SI476X_RDSPI    = (1 << 3),
+	SI476X_RDSSYNC	= (1 << 1),
+	SI476X_RDSRECV	= (1 << 0),
+};
+
+enum si476x_status_response_bits {
+	SI476X_CTS	  = (1 << 7),
+	SI476X_ERR	  = (1 << 6),
+	/* Status response for WB receiver */
+	SI476X_WB_ASQ_INT = (1 << 4),
+	SI476X_RSQ_INT    = (1 << 3),
+	/* Status response for FM receiver */
+	SI476X_FM_RDS_INT = (1 << 2),
+	SI476X_ACF_INT    = (1 << 1),
+	SI476X_STC_INT    = (1 << 0),
+};
+
+/* -------------------- si476x-prop.c ----------------------- */
+
+enum si476x_common_receiver_properties {
+	SI476X_PROP_INT_CTL_ENABLE			= 0x0000,
+	SI476X_PROP_DIGITAL_IO_INPUT_SAMPLE_RATE	= 0x0200,
+	SI476X_PROP_DIGITAL_IO_INPUT_FORMAT		= 0x0201,
+	SI476X_PROP_DIGITAL_IO_OUTPUT_SAMPLE_RATE	= 0x0202,
+	SI476X_PROP_DIGITAL_IO_OUTPUT_FORMAT		= 0x0203,
+
+	SI476X_PROP_SEEK_BAND_BOTTOM			= 0x1100,
+	SI476X_PROP_SEEK_BAND_TOP			= 0x1101,
+	SI476X_PROP_SEEK_FREQUENCY_SPACING		= 0x1102,
+
+	SI476X_PROP_VALID_MAX_TUNE_ERROR		= 0x2000,
+	SI476X_PROP_VALID_SNR_THRESHOLD			= 0x2003,
+	SI476X_PROP_VALID_RSSI_THRESHOLD		= 0x2004,
+};
+
+enum si476x_am_receiver_properties {
+	SI476X_PROP_AUDIO_PWR_LINE_FILTER		= 0x0303,
+};
+
+enum si476x_fm_receiver_properties {
+	SI476X_PROP_AUDIO_DEEMPHASIS			= 0x0302,
+
+	SI476X_PROP_FM_RDS_INTERRUPT_SOURCE		= 0x4000,
+	SI476X_PROP_FM_RDS_INTERRUPT_FIFO_COUNT		= 0x4001,
+	SI476X_PROP_FM_RDS_CONFIG			= 0x4002,
+};
+
+enum si476x_prop_audio_pwr_line_filter_bits {
+	SI476X_PROP_PWR_HARMONICS_MASK	= 0b0000000000011111,
+	SI476X_PROP_PWR_GRID_MASK	= 0b0000000100000000,
+	SI476X_PROP_PWR_ENABLE_MASK	= 0b0000001000000000,
+	SI476X_PROP_PWR_GRID_50HZ	= 0b0000000000000000,
+	SI476X_PROP_PWR_GRID_60HZ	= 0b0000000100000000,
+};
+
+enum si476x_prop_fm_rds_config_bits {
+	SI476X_PROP_RDSEN_MASK	= 0x1,
+	SI476X_PROP_RDSEN	= 0x1,
+};
+
+
+struct regmap *devm_regmap_init_si476x(struct si476x_core *);
+
+#endif	/* SI476X_CORE_H */
diff --git a/include/media/si476x.h b/include/media/si476x.h
new file mode 100644
index 0000000..6d95cba
--- /dev/null
+++ b/include/media/si476x.h
@@ -0,0 +1,427 @@
+/*
+ * include/media/si476x.h -- Common definitions for si476x driver
+ *
+ * Copyright (C) 2012 Innovative Converged Devices(ICD)
+ *
+ * Author: Andrey Smirnov <andrey.smirnov@convergeddevices.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ */
+
+#ifndef SI476X_H
+#define SI476X_H
+
+#include <linux/types.h>
+#include <linux/videodev2.h>
+
+struct si476x_device;
+
+/* It is possible to select one of the four adresses using pins A0
+ * and A1 on SI476x */
+#define SI476X_I2C_ADDR_1	0x60
+#define SI476X_I2C_ADDR_2	0x61
+#define SI476X_I2C_ADDR_3	0x62
+#define SI476X_I2C_ADDR_4	0x63
+
+enum si476x_iqclk_config {
+	SI476X_IQCLK_NOOP = 0,
+	SI476X_IQCLK_TRISTATE = 1,
+	SI476X_IQCLK_IQ = 21,
+};
+enum si476x_iqfs_config {
+	SI476X_IQFS_NOOP = 0,
+	SI476X_IQFS_TRISTATE = 1,
+	SI476X_IQFS_IQ = 21,
+};
+enum si476x_iout_config {
+	SI476X_IOUT_NOOP = 0,
+	SI476X_IOUT_TRISTATE = 1,
+	SI476X_IOUT_OUTPUT = 22,
+};
+enum si476x_qout_config {
+	SI476X_QOUT_NOOP = 0,
+	SI476X_QOUT_TRISTATE = 1,
+	SI476X_QOUT_OUTPUT = 22,
+};
+
+enum si476x_dclk_config {
+	SI476X_DCLK_NOOP      = 0,
+	SI476X_DCLK_TRISTATE  = 1,
+	SI476X_DCLK_DAUDIO    = 10,
+};
+
+enum si476x_dfs_config {
+	SI476X_DFS_NOOP      = 0,
+	SI476X_DFS_TRISTATE  = 1,
+	SI476X_DFS_DAUDIO    = 10,
+};
+
+enum si476x_dout_config {
+	SI476X_DOUT_NOOP       = 0,
+	SI476X_DOUT_TRISTATE   = 1,
+	SI476X_DOUT_I2S_OUTPUT = 12,
+	SI476X_DOUT_I2S_INPUT  = 13,
+};
+
+enum si476x_xout_config {
+	SI476X_XOUT_NOOP        = 0,
+	SI476X_XOUT_TRISTATE    = 1,
+	SI476X_XOUT_I2S_INPUT   = 13,
+	SI476X_XOUT_MODE_SELECT = 23,
+};
+
+
+enum si476x_icin_config {
+	SI476X_ICIN_NOOP	= 0,
+	SI476X_ICIN_TRISTATE	= 1,
+	SI476X_ICIN_GPO1_HIGH	= 2,
+	SI476X_ICIN_GPO1_LOW	= 3,
+	SI476X_ICIN_IC_LINK	= 30,
+};
+
+enum si476x_icip_config {
+	SI476X_ICIP_NOOP	= 0,
+	SI476X_ICIP_TRISTATE	= 1,
+	SI476X_ICIP_GPO2_HIGH	= 2,
+	SI476X_ICIP_GPO2_LOW	= 3,
+	SI476X_ICIP_IC_LINK	= 30,
+};
+
+enum si476x_icon_config {
+	SI476X_ICON_NOOP	= 0,
+	SI476X_ICON_TRISTATE	= 1,
+	SI476X_ICON_I2S		= 10,
+	SI476X_ICON_IC_LINK	= 30,
+};
+
+enum si476x_icop_config {
+	SI476X_ICOP_NOOP	= 0,
+	SI476X_ICOP_TRISTATE	= 1,
+	SI476X_ICOP_I2S		= 10,
+	SI476X_ICOP_IC_LINK	= 30,
+};
+
+
+enum si476x_lrout_config {
+	SI476X_LROUT_NOOP	= 0,
+	SI476X_LROUT_TRISTATE	= 1,
+	SI476X_LROUT_AUDIO	= 2,
+	SI476X_LROUT_MPX	= 3,
+};
+
+
+enum si476x_intb_config {
+	SI476X_INTB_NOOP     = 0,
+	SI476X_INTB_TRISTATE = 1,
+	SI476X_INTB_DAUDIO   = 10,
+	SI476X_INTB_IRQ      = 40,
+};
+
+enum si476x_a1_config {
+	SI476X_A1_NOOP     = 0,
+	SI476X_A1_TRISTATE = 1,
+	SI476X_A1_IRQ      = 40,
+};
+
+enum si476x_part_revisions {
+	SI476X_REVISION_A10 = 0,
+	SI476X_REVISION_A20 = 1,
+	SI476X_REVISION_A30 = 2,
+};
+
+struct si476x_pinmux {
+	enum si476x_dclk_config  dclk;
+	enum si476x_dfs_config   dfs;
+	enum si476x_dout_config  dout;
+	enum si476x_xout_config  xout;
+
+	enum si476x_iqclk_config iqclk;
+	enum si476x_iqfs_config  iqfs;
+	enum si476x_iout_config  iout;
+	enum si476x_qout_config  qout;
+
+	enum si476x_icin_config  icin;
+	enum si476x_icip_config  icip;
+	enum si476x_icon_config  icon;
+	enum si476x_icop_config  icop;
+
+	enum si476x_lrout_config lrout;
+
+	enum si476x_intb_config  intb;
+	enum si476x_a1_config    a1;
+};
+
+/**
+ * enum si476x_phase_diversity_mode - possbile phase diversity modes
+ * for SI4764/5/6/7 chips.
+ *
+ * @SI476X_PHDIV_DISABLED:		Phase diversity feature is
+ *					disabled.
+ * @SI476X_PHDIV_PRIMARY_COMBINING:	Tuner works as a primary tuner
+ *					in combination with a
+ *					secondary one.
+ * @SI476X_PHDIV_PRIMARY_ANTENNA:	Tuner works as a primary tuner
+ *					using only its own antenna.
+ * @SI476X_PHDIV_SECONDARY_ANTENNA:	Tuner works as a primary tuner
+ *					usning seconary tuner's antenna.
+ * @SI476X_PHDIV_SECONDARY_COMBINING:	Tuner works as a secondary
+ *					tuner in combination with the
+ *					primary one.
+ */
+enum si476x_phase_diversity_mode {
+	SI476X_PHDIV_DISABLED			= 0,
+	SI476X_PHDIV_PRIMARY_COMBINING		= 1,
+	SI476X_PHDIV_PRIMARY_ANTENNA		= 2,
+	SI476X_PHDIV_SECONDARY_ANTENNA		= 3,
+	SI476X_PHDIV_SECONDARY_COMBINING	= 5,
+};
+
+enum si476x_ibias6x {
+	SI476X_IBIAS6X_OTHER			= 0,
+	SI476X_IBIAS6X_RCVR1_NON_4MHZ_CLK	= 1,
+};
+
+enum si476x_xstart {
+	SI476X_XSTART_MULTIPLE_TUNER	= 0x11,
+	SI476X_XSTART_NORMAL		= 0x77,
+};
+
+enum si476x_freq {
+	SI476X_FREQ_4_MHZ		= 0,
+	SI476X_FREQ_37P209375_MHZ	= 1,
+	SI476X_FREQ_36P4_MHZ		= 2,
+	SI476X_FREQ_37P8_MHZ		=  3,
+};
+
+enum si476x_xmode {
+	SI476X_XMODE_CRYSTAL_RCVR1	= 1,
+	SI476X_XMODE_EXT_CLOCK		= 2,
+	SI476X_XMODE_CRYSTAL_RCVR2_3	= 3,
+};
+
+enum si476x_xbiashc {
+	SI476X_XBIASHC_SINGLE_RECEIVER = 0,
+	SI476X_XBIASHC_MULTIPLE_RECEIVER = 1,
+};
+
+enum si476x_xbias {
+	SI476X_XBIAS_RCVR2_3	= 0,
+	SI476X_XBIAS_4MHZ_RCVR1 = 3,
+	SI476X_XBIAS_RCVR1	= 7,
+};
+
+enum si476x_func {
+	SI476X_FUNC_BOOTLOADER	= 0,
+	SI476X_FUNC_FM_RECEIVER = 1,
+	SI476X_FUNC_AM_RECEIVER = 2,
+	SI476X_FUNC_WB_RECEIVER = 3,
+};
+
+
+/**
+ * @xcload: Selects the amount of additional on-chip capacitance to
+ *          be connected between XTAL1 and gnd and between XTAL2 and
+ *          GND. One half of the capacitance value shown here is the
+ *          additional load capacitance presented to the xtal. The
+ *          minimum step size is 0.277 pF. Recommended value is 0x28
+ *          but it will be layout dependent. Range is 0–0x3F i.e.
+ *          (0–16.33 pF)
+ * @ctsien: enable CTSINT(interrupt request when CTS condition
+ *          arises) when set
+ * @intsel: when set A1 pin becomes the interrupt pin; otherwise,
+ *          INTB is the interrupt pin
+ * @func:   selects the boot function of the device. I.e.
+ *          SI476X_BOOTLOADER  - Boot loader
+ *          SI476X_FM_RECEIVER - FM receiver
+ *          SI476X_AM_RECEIVER - AM receiver
+ *          SI476X_WB_RECEIVER - Weatherband receiver
+ * @freq:   oscillator's crystal frequency:
+ *          SI476X_XTAL_37P209375_MHZ - 37.209375 Mhz
+ *          SI476X_XTAL_36P4_MHZ      - 36.4 Mhz
+ *          SI476X_XTAL_37P8_MHZ      - 37.8 Mhz
+ */
+struct si476x_power_up_args {
+	enum si476x_ibias6x ibias6x;
+	enum si476x_xstart  xstart;
+	u8   xcload;
+	bool fastboot;
+	enum si476x_xbiashc xbiashc;
+	enum si476x_xbias   xbias;
+	enum si476x_func    func;
+	enum si476x_freq    freq;
+	enum si476x_xmode   xmode;
+};
+
+
+enum si476x_ctrl_id {
+	SI476X_CID_RSSI_THRESHOLD	= (V4L2_CID_USER_BASE | 0x1001),
+	SI476X_CID_SNR_THRESHOLD	= (V4L2_CID_USER_BASE | 0x1002),
+	SI476X_CID_MAX_TUNE_ERROR	= (V4L2_CID_USER_BASE | 0x1003),
+	SI476X_CID_RDS_RECEPTION	= (V4L2_CID_USER_BASE | 0x1004),
+	SI476X_CID_DEEMPHASIS		= (V4L2_CID_USER_BASE | 0x1005),
+	SI476X_CID_HARMONICS_COUNT	= (V4L2_CID_USER_BASE | 0x1006),
+	SI476X_CID_DIVERSITY_MODE	= (V4L2_CID_USER_BASE | 0x1007),
+	SI476X_CID_INTERCHIP_LINK	= (V4L2_CID_USER_BASE | 0x1008),
+};
+
+/*
+ * Platform dependent definition
+ */
+struct si476x_platform_data {
+	int gpio_reset; /* < 0 if not used */
+
+	struct si476x_power_up_args power_up_parameters;
+	enum si476x_phase_diversity_mode diversity_mode;
+
+	struct si476x_pinmux pinmux;
+};
+
+/**
+ * struct si476x_rsq_status - structure containing received signal
+ * quality
+ * @multhint:   Multipath Detect High.
+ *              true  - Indicatedes that the value is below
+ *                      FM_RSQ_MULTIPATH_HIGH_THRESHOLD
+ *              false - Indicatedes that the value is above
+ *                      FM_RSQ_MULTIPATH_HIGH_THRESHOLD
+ * @multlint:   Multipath Detect Low.
+ *              true  - Indicatedes that the value is below
+ *                      FM_RSQ_MULTIPATH_LOW_THRESHOLD
+ *              false - Indicatedes that the value is above
+ *                      FM_RSQ_MULTIPATH_LOW_THRESHOLD
+ * @snrhint:    SNR Detect High.
+ *              true  - Indicatedes that the value is below
+ *                      FM_RSQ_SNR_HIGH_THRESHOLD
+ *              false - Indicatedes that the value is above
+ *                      FM_RSQ_SNR_HIGH_THRESHOLD
+ * @snrlint:    SNR Detect Low.
+ *              true  - Indicatedes that the value is below
+ *                      FM_RSQ_SNR_LOW_THRESHOLD
+ *              false - Indicatedes that the value is above
+ *                      FM_RSQ_SNR_LOW_THRESHOLD
+ * @rssihint:   RSSI Detect High.
+ *              true  - Indicatedes that the value is below
+ *                      FM_RSQ_RSSI_HIGH_THRESHOLD
+ *              false - Indicatedes that the value is above
+ *                      FM_RSQ_RSSI_HIGH_THRESHOLD
+ * @rssilint:   RSSI Detect Low.
+ *              true  - Indicatedes that the value is below
+ *                      FM_RSQ_RSSI_LOW_THRESHOLD
+ *              false - Indicatedes that the value is above
+ *                      FM_RSQ_RSSI_LOW_THRESHOLD
+ * @bltf:       Band Limit.
+ *              Set if seek command hits the band limit or wrapped to
+ *              the original frequency.
+ * @snr_ready:  SNR measurement in progress.
+ * @rssiready:  RSSI measurement in progress.
+ * @afcrl:      Set if FREQOFF >= MAX_TUNE_ERROR
+ * @valid:      Set if the channel is valid
+ *               rssi < FM_VALID_RSSI_THRESHOLD
+ *               snr  < FM_VALID_SNR_THRESHOLD
+ *               tune_error < FM_VALID_MAX_TUNE_ERROR
+ * @readfreq:   Current tuned frequency.
+ * @freqoff:    Signed frequency offset.
+ * @rssi:       Received Signal Strength Indicator(dBuV).
+ * @snr:        RF SNR Indicator(dB).
+ * @lassi:
+ * @hassi:      Low/High side Adjacent(100 kHz) Channel Strength Indicator
+ * @mult:       Multipath indicator
+ * @dev:        Who knows? But values may vary.
+ * @readantcap: Antenna tuning capacity value.
+ * @assi:       Adjacent Channel(+/- 200kHz) Strength Indicator
+ * @usn:        Ultrasonic Noise Inticator in -DBFS
+ */
+struct si476x_rsq_status_report {
+	__u8 multhint, multlint;
+	__u8 snrhint,  snrlint;
+	__u8 rssihint, rssilint;
+	__u8 bltf;
+	__u8 snr_ready;
+	__u8 rssiready;
+	__u8 injside;
+	__u8 afcrl;
+	__u8 valid;
+
+	__u16 readfreq;
+	__s8  freqoff;
+	__s8  rssi;
+	__s8  snr;
+	__s8  issi;
+	__s8  lassi, hassi;
+	__s8  mult;
+	__u8  dev;
+	__u16 readantcap;
+	__s8  assi;
+	__s8  usn;
+
+	__u8 pilotdev;
+	__u8 rdsdev;
+	__u8 assidev;
+	__u8 strongdev;
+	__u16 rdspi;
+};
+
+/**
+ * si476x_acf_status_report - ACF report results
+ *
+ * @blend_int: If set, indicates that stereo separation has crossed
+ * below the blend threshold as set by FM_ACF_BLEND_THRESHOLD
+ * @hblend_int: If set, indicates that HiBlend cutoff frequency is
+ * lower than threshold as set by FM_ACF_HBLEND_THRESHOLD
+ * @hicut_int:  If set, indicates that HiCut cutoff frequency is lower
+ * than the threshold set by ACF_
+
+ */
+struct si476x_acf_status_report {
+	__u8 blend_int;
+	__u8 hblend_int;
+	__u8 hicut_int;
+	__u8 chbw_int;
+	__u8 softmute_int;
+	__u8 smute;
+	__u8 smattn;
+	__u8 chbw;
+	__u8 hicut;
+	__u8 hiblend;
+	__u8 pilot;
+	__u8 stblend;
+};
+
+enum si476x_fmagc {
+	SI476X_FMAGC_10K_OHM	= 0,
+	SI476X_FMAGC_800_OHM	= 1,
+	SI476X_FMAGC_400_OHM	= 2,
+	SI476X_FMAGC_200_OHM	= 4,
+	SI476X_FMAGC_100_OHM	= 8,
+	SI476X_FMAGC_50_OHM	= 16,
+	SI476X_FMAGC_25_OHM	= 32,
+	SI476X_FMAGC_12P5_OHM	= 64,
+	SI476X_FMAGC_6P25_OHM	= 128,
+};
+
+struct si476x_agc_status_report {
+	__u8 mxhi;
+	__u8 mxlo;
+	__u8 lnahi;
+	__u8 lnalo;
+	__u8 fmagc1;
+	__u8 fmagc2;
+	__u8 pgagain;
+	__u8 fmwblang;
+};
+
+struct si476x_rds_blockcount_report {
+	__u16 expected;
+	__u16 received;
+	__u16 uncorrectable;
+};
+
+#endif /* SI476X_H*/
-- 
1.7.10.4

