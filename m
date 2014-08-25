Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:3176 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755505AbaHYLbB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Aug 2014 07:31:01 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 10/12] vivid: add support for radio receivers and transmitters
Date: Mon, 25 Aug 2014 13:30:21 +0200
Message-Id: <1408966223-5221-11-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1408966223-5221-1-git-send-email-hverkuil@xs4all.nl>
References: <1408966223-5221-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This adds radio receiver and transmitter support. Part of that is common
to both and so is placed in the radio-common source.

These drivers also support RDS. In order to generate valid RDS data a
simple RDS generator is implemented in rds-gen.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-radio-common.c | 189 ++++++++++++++
 drivers/media/platform/vivid/vivid-radio-common.h |  40 +++
 drivers/media/platform/vivid/vivid-radio-rx.c     | 287 ++++++++++++++++++++++
 drivers/media/platform/vivid/vivid-radio-rx.h     |  31 +++
 drivers/media/platform/vivid/vivid-radio-tx.c     | 141 +++++++++++
 drivers/media/platform/vivid/vivid-radio-tx.h     |  29 +++
 drivers/media/platform/vivid/vivid-rds-gen.c      | 165 +++++++++++++
 drivers/media/platform/vivid/vivid-rds-gen.h      |  53 ++++
 8 files changed, 935 insertions(+)
 create mode 100644 drivers/media/platform/vivid/vivid-radio-common.c
 create mode 100644 drivers/media/platform/vivid/vivid-radio-common.h
 create mode 100644 drivers/media/platform/vivid/vivid-radio-rx.c
 create mode 100644 drivers/media/platform/vivid/vivid-radio-rx.h
 create mode 100644 drivers/media/platform/vivid/vivid-radio-tx.c
 create mode 100644 drivers/media/platform/vivid/vivid-radio-tx.h
 create mode 100644 drivers/media/platform/vivid/vivid-rds-gen.c
 create mode 100644 drivers/media/platform/vivid/vivid-rds-gen.h

diff --git a/drivers/media/platform/vivid/vivid-radio-common.c b/drivers/media/platform/vivid/vivid-radio-common.c
new file mode 100644
index 0000000..78c1e92
--- /dev/null
+++ b/drivers/media/platform/vivid/vivid-radio-common.c
@@ -0,0 +1,189 @@
+/*
+ * vivid-radio-common.c - common radio rx/tx support functions.
+ *
+ * Copyright 2014 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
+ *
+ * This program is free software; you may redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/delay.h>
+#include <linux/videodev2.h>
+
+#include "vivid-core.h"
+#include "vivid-ctrls.h"
+#include "vivid-radio-common.h"
+#include "vivid-rds-gen.h"
+
+/*
+ * These functions are shared between the vivid receiver and transmitter
+ * since both use the same frequency bands.
+ */
+
+const struct v4l2_frequency_band vivid_radio_bands[TOT_BANDS] = {
+	/* Band FM */
+	{
+		.type = V4L2_TUNER_RADIO,
+		.index = 0,
+		.capability = V4L2_TUNER_CAP_LOW | V4L2_TUNER_CAP_STEREO |
+			      V4L2_TUNER_CAP_FREQ_BANDS,
+		.rangelow   = FM_FREQ_RANGE_LOW,
+		.rangehigh  = FM_FREQ_RANGE_HIGH,
+		.modulation = V4L2_BAND_MODULATION_FM,
+	},
+	/* Band AM */
+	{
+		.type = V4L2_TUNER_RADIO,
+		.index = 1,
+		.capability = V4L2_TUNER_CAP_LOW | V4L2_TUNER_CAP_FREQ_BANDS,
+		.rangelow   = AM_FREQ_RANGE_LOW,
+		.rangehigh  = AM_FREQ_RANGE_HIGH,
+		.modulation = V4L2_BAND_MODULATION_AM,
+	},
+	/* Band SW */
+	{
+		.type = V4L2_TUNER_RADIO,
+		.index = 2,
+		.capability = V4L2_TUNER_CAP_LOW | V4L2_TUNER_CAP_FREQ_BANDS,
+		.rangelow   = SW_FREQ_RANGE_LOW,
+		.rangehigh  = SW_FREQ_RANGE_HIGH,
+		.modulation = V4L2_BAND_MODULATION_AM,
+	},
+};
+
+/*
+ * Initialize the RDS generator. If we can loop, then the RDS generator
+ * is set up with the values from the RDS TX controls, otherwise it
+ * will fill in standard values using one of two alternates.
+ */
+void vivid_radio_rds_init(struct vivid_dev *dev)
+{
+	struct vivid_rds_gen *rds = &dev->rds_gen;
+	bool alt = dev->radio_rx_rds_use_alternates;
+
+	/* Do nothing, blocks will be filled by the transmitter */
+	if (dev->radio_rds_loop && !dev->radio_tx_rds_controls)
+		return;
+
+	if (dev->radio_rds_loop) {
+		v4l2_ctrl_lock(dev->radio_tx_rds_pi);
+		rds->picode = dev->radio_tx_rds_pi->cur.val;
+		rds->pty = dev->radio_tx_rds_pty->cur.val;
+		rds->mono_stereo = dev->radio_tx_rds_mono_stereo->cur.val;
+		rds->art_head = dev->radio_tx_rds_art_head->cur.val;
+		rds->compressed = dev->radio_tx_rds_compressed->cur.val;
+		rds->dyn_pty = dev->radio_tx_rds_dyn_pty->cur.val;
+		rds->ta = dev->radio_tx_rds_ta->cur.val;
+		rds->tp = dev->radio_tx_rds_tp->cur.val;
+		rds->ms = dev->radio_tx_rds_ms->cur.val;
+		strlcpy(rds->psname,
+			dev->radio_tx_rds_psname->p_cur.p_char,
+			sizeof(rds->psname));
+		strlcpy(rds->radiotext,
+			dev->radio_tx_rds_radiotext->p_cur.p_char + alt * 64,
+			sizeof(rds->radiotext));
+		v4l2_ctrl_unlock(dev->radio_tx_rds_pi);
+	} else {
+		vivid_rds_gen_fill(rds, dev->radio_rx_freq, alt);
+	}
+	if (dev->radio_rx_rds_controls) {
+		v4l2_ctrl_s_ctrl(dev->radio_rx_rds_pty, rds->pty);
+		v4l2_ctrl_s_ctrl(dev->radio_rx_rds_ta, rds->ta);
+		v4l2_ctrl_s_ctrl(dev->radio_rx_rds_tp, rds->tp);
+		v4l2_ctrl_s_ctrl(dev->radio_rx_rds_ms, rds->ms);
+		v4l2_ctrl_s_ctrl_string(dev->radio_rx_rds_psname, rds->psname);
+		v4l2_ctrl_s_ctrl_string(dev->radio_rx_rds_radiotext, rds->radiotext);
+		if (!dev->radio_rds_loop)
+			dev->radio_rx_rds_use_alternates = !dev->radio_rx_rds_use_alternates;
+	}
+	vivid_rds_generate(rds);
+}
+
+/*
+ * Calculate the emulated signal quality taking into account the frequency
+ * the transmitter is using.
+ */
+static void vivid_radio_calc_sig_qual(struct vivid_dev *dev)
+{
+	int mod = 16000;
+	int delta = 800;
+	int sig_qual, sig_qual_tx = mod;
+
+	/*
+	 * For SW and FM there is a channel every 1000 kHz, for AM there is one
+	 * every 100 kHz.
+	 */
+	if (dev->radio_rx_freq <= AM_FREQ_RANGE_HIGH) {
+		mod /= 10;
+		delta /= 10;
+	}
+	sig_qual = (dev->radio_rx_freq + delta) % mod - delta;
+	if (dev->has_radio_tx)
+		sig_qual_tx = dev->radio_rx_freq - dev->radio_tx_freq;
+	if (abs(sig_qual_tx) <= abs(sig_qual)) {
+		sig_qual = sig_qual_tx;
+		/*
+		 * Zero the internal rds buffer if we are going to loop
+		 * rds blocks.
+		 */
+		if (!dev->radio_rds_loop && !dev->radio_tx_rds_controls)
+			memset(dev->rds_gen.data, 0,
+			       sizeof(dev->rds_gen.data));
+		dev->radio_rds_loop = dev->radio_rx_freq >= FM_FREQ_RANGE_LOW;
+	} else {
+		dev->radio_rds_loop = false;
+	}
+	if (dev->radio_rx_freq <= AM_FREQ_RANGE_HIGH)
+		sig_qual *= 10;
+	dev->radio_rx_sig_qual = sig_qual;
+}
+
+int vivid_radio_g_frequency(struct file *file, const unsigned *pfreq, struct v4l2_frequency *vf)
+{
+	if (vf->tuner != 0)
+		return -EINVAL;
+	vf->frequency = *pfreq;
+	return 0;
+}
+
+int vivid_radio_s_frequency(struct file *file, unsigned *pfreq, const struct v4l2_frequency *vf)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+	unsigned freq;
+	unsigned band;
+
+	if (vf->tuner != 0)
+		return -EINVAL;
+
+	if (vf->frequency >= (FM_FREQ_RANGE_LOW + SW_FREQ_RANGE_HIGH) / 2)
+		band = BAND_FM;
+	else if (vf->frequency <= (AM_FREQ_RANGE_HIGH + SW_FREQ_RANGE_LOW) / 2)
+		band = BAND_AM;
+	else
+		band = BAND_SW;
+
+	freq = clamp_t(u32, vf->frequency, vivid_radio_bands[band].rangelow,
+					   vivid_radio_bands[band].rangehigh);
+	*pfreq = freq;
+
+	/*
+	 * For both receiver and transmitter recalculate the signal quality
+	 * (since that depends on both frequencies) and re-init the rds
+	 * generator.
+	 */
+	vivid_radio_calc_sig_qual(dev);
+	vivid_radio_rds_init(dev);
+	return 0;
+}
diff --git a/drivers/media/platform/vivid/vivid-radio-common.h b/drivers/media/platform/vivid/vivid-radio-common.h
new file mode 100644
index 0000000..92fe589
--- /dev/null
+++ b/drivers/media/platform/vivid/vivid-radio-common.h
@@ -0,0 +1,40 @@
+/*
+ * vivid-radio-common.h - common radio rx/tx support functions.
+ *
+ * Copyright 2014 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
+ *
+ * This program is free software; you may redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#ifndef _VIVID_RADIO_COMMON_H_
+#define _VIVID_RADIO_COMMON_H_
+
+/* The supported radio frequency ranges in kHz */
+#define FM_FREQ_RANGE_LOW       (64000U * 16U)
+#define FM_FREQ_RANGE_HIGH      (108000U * 16U)
+#define AM_FREQ_RANGE_LOW       (520U * 16U)
+#define AM_FREQ_RANGE_HIGH      (1710U * 16U)
+#define SW_FREQ_RANGE_LOW       (2300U * 16U)
+#define SW_FREQ_RANGE_HIGH      (26100U * 16U)
+
+enum { BAND_FM, BAND_AM, BAND_SW, TOT_BANDS };
+
+extern const struct v4l2_frequency_band vivid_radio_bands[TOT_BANDS];
+
+int vivid_radio_g_frequency(struct file *file, const unsigned *freq, struct v4l2_frequency *vf);
+int vivid_radio_s_frequency(struct file *file, unsigned *freq, const struct v4l2_frequency *vf);
+
+void vivid_radio_rds_init(struct vivid_dev *dev);
+
+#endif
diff --git a/drivers/media/platform/vivid/vivid-radio-rx.c b/drivers/media/platform/vivid/vivid-radio-rx.c
new file mode 100644
index 0000000..c7651a5
--- /dev/null
+++ b/drivers/media/platform/vivid/vivid-radio-rx.c
@@ -0,0 +1,287 @@
+/*
+ * vivid-radio-rx.c - radio receiver support functions.
+ *
+ * Copyright 2014 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
+ *
+ * This program is free software; you may redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/delay.h>
+#include <linux/videodev2.h>
+#include <linux/v4l2-dv-timings.h>
+#include <media/v4l2-common.h>
+#include <media/v4l2-event.h>
+#include <media/v4l2-dv-timings.h>
+
+#include "vivid-core.h"
+#include "vivid-ctrls.h"
+#include "vivid-radio-common.h"
+#include "vivid-rds-gen.h"
+#include "vivid-radio-rx.h"
+
+ssize_t vivid_radio_rx_read(struct file *file, char __user *buf,
+			 size_t size, loff_t *offset)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+	struct timespec ts;
+	struct v4l2_rds_data *data = dev->rds_gen.data;
+	bool use_alternates;
+	unsigned blk;
+	int perc;
+	int i;
+
+	if (dev->radio_rx_rds_controls)
+		return -EINVAL;
+	if (size < sizeof(*data))
+		return 0;
+	size = sizeof(*data) * (size / sizeof(*data));
+
+	if (mutex_lock_interruptible(&dev->mutex))
+		return -ERESTARTSYS;
+	if (dev->radio_rx_rds_owner &&
+	    file->private_data != dev->radio_rx_rds_owner) {
+		mutex_unlock(&dev->mutex);
+		return -EBUSY;
+	}
+	if (dev->radio_rx_rds_owner == NULL) {
+		vivid_radio_rds_init(dev);
+		dev->radio_rx_rds_owner = file->private_data;
+	}
+
+retry:
+	ktime_get_ts(&ts);
+	use_alternates = ts.tv_sec % 10 >= 5;
+	if (dev->radio_rx_rds_last_block == 0 ||
+	    dev->radio_rx_rds_use_alternates != use_alternates) {
+		dev->radio_rx_rds_use_alternates = use_alternates;
+		/* Re-init the RDS generator */
+		vivid_radio_rds_init(dev);
+	}
+	ts = timespec_sub(ts, dev->radio_rds_init_ts);
+	blk = ts.tv_sec * 100 + ts.tv_nsec / 10000000;
+	blk = (blk * VIVID_RDS_GEN_BLOCKS) / 500;
+	if (blk >= dev->radio_rx_rds_last_block + VIVID_RDS_GEN_BLOCKS)
+		dev->radio_rx_rds_last_block = blk - VIVID_RDS_GEN_BLOCKS + 1;
+
+	/*
+	 * No data is available if there hasn't been time to get new data,
+	 * or if the RDS receiver has been disabled, or if we use the data
+	 * from the RDS transmitter and that RDS transmitter has been disabled,
+	 * or if the signal quality is too weak.
+	 */
+	if (blk == dev->radio_rx_rds_last_block || !dev->radio_rx_rds_enabled ||
+	    (dev->radio_rds_loop && !(dev->radio_tx_subchans & V4L2_TUNER_SUB_RDS)) ||
+	    abs(dev->radio_rx_sig_qual) > 200) {
+		mutex_unlock(&dev->mutex);
+		if (file->f_flags & O_NONBLOCK)
+			return -EWOULDBLOCK;
+		if (msleep_interruptible(20) && signal_pending(current))
+			return -EINTR;
+		if (mutex_lock_interruptible(&dev->mutex))
+			return -ERESTARTSYS;
+		goto retry;
+	}
+
+	/* abs(dev->radio_rx_sig_qual) <= 200, map that to a 0-50% range */
+	perc = abs(dev->radio_rx_sig_qual) / 4;
+
+	for (i = 0; i < size && blk > dev->radio_rx_rds_last_block;
+			dev->radio_rx_rds_last_block++) {
+		unsigned data_blk = dev->radio_rx_rds_last_block % VIVID_RDS_GEN_BLOCKS;
+		struct v4l2_rds_data rds = data[data_blk];
+
+		if (data_blk == 0 && dev->radio_rds_loop)
+			vivid_radio_rds_init(dev);
+		if (perc && prandom_u32_max(100) < perc) {
+			switch (prandom_u32_max(4)) {
+			case 0:
+				rds.block |= V4L2_RDS_BLOCK_CORRECTED;
+				break;
+			case 1:
+				rds.block |= V4L2_RDS_BLOCK_INVALID;
+				break;
+			case 2:
+				rds.block |= V4L2_RDS_BLOCK_ERROR;
+				rds.lsb = prandom_u32_max(256);
+				rds.msb = prandom_u32_max(256);
+				break;
+			case 3: /* Skip block altogether */
+				if (i)
+					continue;
+				/*
+				 * Must make sure at least one block is
+				 * returned, otherwise the application
+				 * might think that end-of-file occurred.
+				 */
+				break;
+			}
+		}
+		if (copy_to_user(buf + i, &rds, sizeof(rds))) {
+			i = -EFAULT;
+			break;
+		}
+		i += sizeof(rds);
+	}
+	mutex_unlock(&dev->mutex);
+	return i;
+}
+
+unsigned int vivid_radio_rx_poll(struct file *file, struct poll_table_struct *wait)
+{
+	return POLLIN | POLLRDNORM | v4l2_ctrl_poll(file, wait);
+}
+
+int vivid_radio_rx_enum_freq_bands(struct file *file, void *fh, struct v4l2_frequency_band *band)
+{
+	if (band->tuner != 0)
+		return -EINVAL;
+
+	if (band->index >= TOT_BANDS)
+		return -EINVAL;
+
+	*band = vivid_radio_bands[band->index];
+	return 0;
+}
+
+int vivid_radio_rx_s_hw_freq_seek(struct file *file, void *fh, const struct v4l2_hw_freq_seek *a)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+	unsigned low, high;
+	unsigned freq;
+	unsigned spacing;
+	unsigned band;
+
+	if (a->tuner)
+		return -EINVAL;
+	if (a->wrap_around && dev->radio_rx_hw_seek_mode == VIVID_HW_SEEK_BOUNDED)
+		return -EINVAL;
+
+	if (!a->wrap_around && dev->radio_rx_hw_seek_mode == VIVID_HW_SEEK_WRAP)
+		return -EINVAL;
+	if (!a->rangelow ^ !a->rangehigh)
+		return -EINVAL;
+
+	if (file->f_flags & O_NONBLOCK)
+		return -EWOULDBLOCK;
+
+	if (a->rangelow) {
+		for (band = 0; band < TOT_BANDS; band++)
+			if (a->rangelow >= vivid_radio_bands[band].rangelow &&
+			    a->rangehigh <= vivid_radio_bands[band].rangehigh)
+				break;
+		if (band == TOT_BANDS)
+			return -EINVAL;
+		if (!dev->radio_rx_hw_seek_prog_lim &&
+		    (a->rangelow != vivid_radio_bands[band].rangelow ||
+		     a->rangehigh != vivid_radio_bands[band].rangehigh))
+			return -EINVAL;
+		low = a->rangelow;
+		high = a->rangehigh;
+	} else {
+		for (band = 0; band < TOT_BANDS; band++)
+			if (dev->radio_rx_freq >= vivid_radio_bands[band].rangelow &&
+			    dev->radio_rx_freq <= vivid_radio_bands[band].rangehigh)
+				break;
+		low = vivid_radio_bands[band].rangelow;
+		high = vivid_radio_bands[band].rangehigh;
+	}
+	spacing = band == BAND_AM ? 1600 : 16000;
+	freq = clamp(dev->radio_rx_freq, low, high);
+
+	if (a->seek_upward) {
+		freq = spacing * (freq / spacing) + spacing;
+		if (freq > high) {
+			if (!a->wrap_around)
+				return -ENODATA;
+			freq = spacing * (low / spacing) + spacing;
+			if (freq >= dev->radio_rx_freq)
+				return -ENODATA;
+		}
+	} else {
+		freq = spacing * ((freq + spacing - 1) / spacing) - spacing;
+		if (freq < low) {
+			if (!a->wrap_around)
+				return -ENODATA;
+			freq = spacing * ((high + spacing - 1) / spacing) - spacing;
+			if (freq <= dev->radio_rx_freq)
+				return -ENODATA;
+		}
+	}
+	return 0;
+}
+
+int vivid_radio_rx_g_tuner(struct file *file, void *fh, struct v4l2_tuner *vt)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+	int delta = 800;
+	int sig_qual;
+
+	if (vt->index > 0)
+		return -EINVAL;
+
+	strlcpy(vt->name, "AM/FM/SW Receiver", sizeof(vt->name));
+	vt->capability = V4L2_TUNER_CAP_LOW | V4L2_TUNER_CAP_STEREO |
+			 V4L2_TUNER_CAP_FREQ_BANDS | V4L2_TUNER_CAP_RDS |
+			 (dev->radio_rx_rds_controls ?
+				V4L2_TUNER_CAP_RDS_CONTROLS :
+				V4L2_TUNER_CAP_RDS_BLOCK_IO) |
+			 (dev->radio_rx_hw_seek_prog_lim ?
+				V4L2_TUNER_CAP_HWSEEK_PROG_LIM : 0);
+	switch (dev->radio_rx_hw_seek_mode) {
+	case VIVID_HW_SEEK_BOUNDED:
+		vt->capability |= V4L2_TUNER_CAP_HWSEEK_BOUNDED;
+		break;
+	case VIVID_HW_SEEK_WRAP:
+		vt->capability |= V4L2_TUNER_CAP_HWSEEK_WRAP;
+		break;
+	case VIVID_HW_SEEK_BOTH:
+		vt->capability |= V4L2_TUNER_CAP_HWSEEK_WRAP |
+				  V4L2_TUNER_CAP_HWSEEK_BOUNDED;
+		break;
+	}
+	vt->rangelow = AM_FREQ_RANGE_LOW;
+	vt->rangehigh = FM_FREQ_RANGE_HIGH;
+	sig_qual = dev->radio_rx_sig_qual;
+	vt->signal = abs(sig_qual) > delta ? 0 :
+		     0xffff - (abs(sig_qual) * 0xffff) / delta;
+	vt->afc = sig_qual > delta ? 0 : sig_qual;
+	if (abs(sig_qual) > delta)
+		vt->rxsubchans = 0;
+	else if (dev->radio_rx_freq < FM_FREQ_RANGE_LOW || vt->signal < 0x8000)
+		vt->rxsubchans = V4L2_TUNER_SUB_MONO;
+	else if (dev->radio_rds_loop && !(dev->radio_tx_subchans & V4L2_TUNER_SUB_STEREO))
+		vt->rxsubchans = V4L2_TUNER_SUB_MONO;
+	else
+		vt->rxsubchans = V4L2_TUNER_SUB_STEREO;
+	if (dev->radio_rx_rds_enabled &&
+	    (!dev->radio_rds_loop || (dev->radio_tx_subchans & V4L2_TUNER_SUB_RDS)) &&
+	    dev->radio_rx_freq >= FM_FREQ_RANGE_LOW && vt->signal >= 0xc000)
+		vt->rxsubchans |= V4L2_TUNER_SUB_RDS;
+	if (dev->radio_rx_rds_controls)
+		vivid_radio_rds_init(dev);
+	vt->audmode = dev->radio_rx_audmode;
+	return 0;
+}
+
+int vivid_radio_rx_s_tuner(struct file *file, void *fh, const struct v4l2_tuner *vt)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+
+	if (vt->index)
+		return -EINVAL;
+	dev->radio_rx_audmode = vt->audmode >= V4L2_TUNER_MODE_STEREO;
+	return 0;
+}
diff --git a/drivers/media/platform/vivid/vivid-radio-rx.h b/drivers/media/platform/vivid/vivid-radio-rx.h
new file mode 100644
index 0000000..1077d8f
--- /dev/null
+++ b/drivers/media/platform/vivid/vivid-radio-rx.h
@@ -0,0 +1,31 @@
+/*
+ * vivid-radio-rx.h - radio receiver support functions.
+ *
+ * Copyright 2014 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
+ *
+ * This program is free software; you may redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#ifndef _VIVID_RADIO_RX_H_
+#define _VIVID_RADIO_RX_H_
+
+ssize_t vivid_radio_rx_read(struct file *, char __user *, size_t, loff_t *);
+unsigned int vivid_radio_rx_poll(struct file *file, struct poll_table_struct *wait);
+
+int vivid_radio_rx_enum_freq_bands(struct file *file, void *fh, struct v4l2_frequency_band *band);
+int vivid_radio_rx_s_hw_freq_seek(struct file *file, void *fh, const struct v4l2_hw_freq_seek *a);
+int vivid_radio_rx_g_tuner(struct file *file, void *fh, struct v4l2_tuner *vt);
+int vivid_radio_rx_s_tuner(struct file *file, void *fh, const struct v4l2_tuner *vt);
+
+#endif
diff --git a/drivers/media/platform/vivid/vivid-radio-tx.c b/drivers/media/platform/vivid/vivid-radio-tx.c
new file mode 100644
index 0000000..8c59d4f
--- /dev/null
+++ b/drivers/media/platform/vivid/vivid-radio-tx.c
@@ -0,0 +1,141 @@
+/*
+ * vivid-radio-tx.c - radio transmitter support functions.
+ *
+ * Copyright 2014 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
+ *
+ * This program is free software; you may redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/delay.h>
+#include <linux/videodev2.h>
+#include <linux/v4l2-dv-timings.h>
+#include <media/v4l2-common.h>
+#include <media/v4l2-event.h>
+#include <media/v4l2-dv-timings.h>
+
+#include "vivid-core.h"
+#include "vivid-ctrls.h"
+#include "vivid-radio-common.h"
+#include "vivid-radio-tx.h"
+
+ssize_t vivid_radio_tx_write(struct file *file, const char __user *buf,
+			  size_t size, loff_t *offset)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+	struct v4l2_rds_data *data = dev->rds_gen.data;
+	struct timespec ts;
+	unsigned blk;
+	int i;
+
+	if (dev->radio_tx_rds_controls)
+		return -EINVAL;
+
+	if (size < sizeof(*data))
+		return -EINVAL;
+	size = sizeof(*data) * (size / sizeof(*data));
+
+	if (mutex_lock_interruptible(&dev->mutex))
+		return -ERESTARTSYS;
+	if (dev->radio_tx_rds_owner &&
+	    file->private_data != dev->radio_tx_rds_owner) {
+		mutex_unlock(&dev->mutex);
+		return -EBUSY;
+	}
+	dev->radio_tx_rds_owner = file->private_data;
+
+retry:
+	ktime_get_ts(&ts);
+	ts = timespec_sub(ts, dev->radio_rds_init_ts);
+	blk = ts.tv_sec * 100 + ts.tv_nsec / 10000000;
+	blk = (blk * VIVID_RDS_GEN_BLOCKS) / 500;
+	if (blk - VIVID_RDS_GEN_BLOCKS >= dev->radio_tx_rds_last_block)
+		dev->radio_tx_rds_last_block = blk - VIVID_RDS_GEN_BLOCKS + 1;
+
+	/*
+	 * No data is available if there hasn't been time to get new data,
+	 * or if the RDS receiver has been disabled, or if we use the data
+	 * from the RDS transmitter and that RDS transmitter has been disabled,
+	 * or if the signal quality is too weak.
+	 */
+	if (blk == dev->radio_tx_rds_last_block ||
+	    !(dev->radio_tx_subchans & V4L2_TUNER_SUB_RDS)) {
+		mutex_unlock(&dev->mutex);
+		if (file->f_flags & O_NONBLOCK)
+			return -EWOULDBLOCK;
+		if (msleep_interruptible(20) && signal_pending(current))
+			return -EINTR;
+		if (mutex_lock_interruptible(&dev->mutex))
+			return -ERESTARTSYS;
+		goto retry;
+	}
+
+	for (i = 0; i < size && blk > dev->radio_tx_rds_last_block;
+			dev->radio_tx_rds_last_block++) {
+		unsigned data_blk = dev->radio_tx_rds_last_block % VIVID_RDS_GEN_BLOCKS;
+		struct v4l2_rds_data rds;
+
+		if (copy_from_user(&rds, buf + i, sizeof(rds))) {
+			i = -EFAULT;
+			break;
+		}
+		i += sizeof(rds);
+		if (!dev->radio_rds_loop)
+			continue;
+		if ((rds.block & V4L2_RDS_BLOCK_MSK) == V4L2_RDS_BLOCK_INVALID ||
+		    (rds.block & V4L2_RDS_BLOCK_ERROR))
+			continue;
+		rds.block &= V4L2_RDS_BLOCK_MSK;
+		data[data_blk] = rds;
+	}
+	mutex_unlock(&dev->mutex);
+	return i;
+}
+
+unsigned int vivid_radio_tx_poll(struct file *file, struct poll_table_struct *wait)
+{
+	return POLLOUT | POLLWRNORM | v4l2_ctrl_poll(file, wait);
+}
+
+int vidioc_g_modulator(struct file *file, void *fh, struct v4l2_modulator *a)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+
+	if (a->index > 0)
+		return -EINVAL;
+
+	strlcpy(a->name, "AM/FM/SW Transmitter", sizeof(a->name));
+	a->capability = V4L2_TUNER_CAP_LOW | V4L2_TUNER_CAP_STEREO |
+			V4L2_TUNER_CAP_FREQ_BANDS | V4L2_TUNER_CAP_RDS |
+			(dev->radio_tx_rds_controls ?
+				V4L2_TUNER_CAP_RDS_CONTROLS :
+				V4L2_TUNER_CAP_RDS_BLOCK_IO);
+	a->rangelow = AM_FREQ_RANGE_LOW;
+	a->rangehigh = FM_FREQ_RANGE_HIGH;
+	a->txsubchans = dev->radio_tx_subchans;
+	return 0;
+}
+
+int vidioc_s_modulator(struct file *file, void *fh, const struct v4l2_modulator *a)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+
+	if (a->index)
+		return -EINVAL;
+	if (a->txsubchans & ~0x13)
+		return -EINVAL;
+	dev->radio_tx_subchans = a->txsubchans;
+	return 0;
+}
diff --git a/drivers/media/platform/vivid/vivid-radio-tx.h b/drivers/media/platform/vivid/vivid-radio-tx.h
new file mode 100644
index 0000000..7f8ff75
--- /dev/null
+++ b/drivers/media/platform/vivid/vivid-radio-tx.h
@@ -0,0 +1,29 @@
+/*
+ * vivid-radio-tx.h - radio transmitter support functions.
+ *
+ * Copyright 2014 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
+ *
+ * This program is free software; you may redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#ifndef _VIVID_RADIO_TX_H_
+#define _VIVID_RADIO_TX_H_
+
+ssize_t vivid_radio_tx_write(struct file *, const char __user *, size_t, loff_t *);
+unsigned int vivid_radio_tx_poll(struct file *file, struct poll_table_struct *wait);
+
+int vidioc_g_modulator(struct file *file, void *fh, struct v4l2_modulator *a);
+int vidioc_s_modulator(struct file *file, void *fh, const struct v4l2_modulator *a);
+
+#endif
diff --git a/drivers/media/platform/vivid/vivid-rds-gen.c b/drivers/media/platform/vivid/vivid-rds-gen.c
new file mode 100644
index 0000000..dab5463
--- /dev/null
+++ b/drivers/media/platform/vivid/vivid-rds-gen.c
@@ -0,0 +1,165 @@
+/*
+ * vivid-rds-gen.c - rds (radio data system) generator support functions.
+ *
+ * Copyright 2014 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
+ *
+ * This program is free software; you may redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#include <linux/kernel.h>
+#include <linux/ktime.h>
+#include <linux/videodev2.h>
+
+#include "vivid-rds-gen.h"
+
+static u8 vivid_get_di(const struct vivid_rds_gen *rds, unsigned grp)
+{
+	switch (grp) {
+	case 0:
+		return (rds->dyn_pty << 2) | (grp & 3);
+	case 1:
+		return (rds->compressed << 2) | (grp & 3);
+	case 2:
+		return (rds->art_head << 2) | (grp & 3);
+	case 3:
+		return (rds->mono_stereo << 2) | (grp & 3);
+	}
+	return 0;
+}
+
+/*
+ * This RDS generator creates 57 RDS groups (one group == four RDS blocks).
+ * Groups 0-3, 22-25 and 44-47 (spaced 22 groups apart) are filled with a
+ * standard 0B group containing the PI code and PS name.
+ *
+ * Groups 4-19 and 26-41 use group 2A for the radio text.
+ *
+ * Group 56 contains the time (group 4A).
+ *
+ * All remaining groups use a filler group 15B block that just repeats
+ * the PI and PTY codes.
+ */
+void vivid_rds_generate(struct vivid_rds_gen *rds)
+{
+	struct v4l2_rds_data *data = rds->data;
+	unsigned grp;
+	struct tm tm;
+	unsigned date;
+	unsigned time;
+	int l;
+
+	for (grp = 0; grp < VIVID_RDS_GEN_GROUPS; grp++, data += VIVID_RDS_GEN_BLKS_PER_GRP) {
+		data[0].lsb = rds->picode & 0xff;
+		data[0].msb = rds->picode >> 8;
+		data[0].block = V4L2_RDS_BLOCK_A | (V4L2_RDS_BLOCK_A << 3);
+		data[1].lsb = rds->pty << 5;
+		data[1].msb = (rds->pty >> 3) | (rds->tp << 2);
+		data[1].block = V4L2_RDS_BLOCK_B | (V4L2_RDS_BLOCK_B << 3);
+		data[3].block = V4L2_RDS_BLOCK_D | (V4L2_RDS_BLOCK_D << 3);
+
+		switch (grp) {
+		case 0 ... 3:
+		case 22 ... 25:
+		case 44 ... 47: /* Group 0B */
+			data[1].lsb |= (rds->ta << 4) | (rds->ms << 3);
+			data[1].lsb |= vivid_get_di(rds, grp % 22);
+			data[1].msb |= 1 << 3;
+			data[2].lsb = rds->picode & 0xff;
+			data[2].msb = rds->picode >> 8;
+			data[2].block = V4L2_RDS_BLOCK_C_ALT | (V4L2_RDS_BLOCK_C_ALT << 3);
+			data[3].lsb = rds->psname[2 * (grp % 22) + 1];
+			data[3].msb = rds->psname[2 * (grp % 22)];
+			break;
+		case 4 ... 19:
+		case 26 ... 41: /* Group 2A */
+			data[1].lsb |= (grp - 4) % 22;
+			data[1].msb |= 4 << 3;
+			data[2].msb = rds->radiotext[4 * ((grp - 4) % 22)];
+			data[2].lsb = rds->radiotext[4 * ((grp - 4) % 22) + 1];
+			data[2].block = V4L2_RDS_BLOCK_C | (V4L2_RDS_BLOCK_C << 3);
+			data[3].msb = rds->radiotext[4 * ((grp - 4) % 22) + 2];
+			data[3].lsb = rds->radiotext[4 * ((grp - 4) % 22) + 3];
+			break;
+		case 56:
+			/*
+			 * Group 4A
+			 *
+			 * Uses the algorithm from Annex G of the RDS standard
+			 * EN 50067:1998 to convert a UTC date to an RDS Modified
+			 * Julian Day.
+			 */
+			time_to_tm(get_seconds(), 0, &tm);
+			l = tm.tm_mon <= 1;
+			date = 14956 + tm.tm_mday + ((tm.tm_year - l) * 1461) / 4 +
+				((tm.tm_mon + 2 + l * 12) * 306001) / 10000;
+			time = (tm.tm_hour << 12) |
+			       (tm.tm_min << 6) |
+			       (sys_tz.tz_minuteswest >= 0 ? 0x20 : 0) |
+			       (abs(sys_tz.tz_minuteswest) / 30);
+			data[1].lsb &= ~3;
+			data[1].lsb |= date >> 15;
+			data[1].msb |= 8 << 3;
+			data[2].lsb = (date << 1) & 0xfe;
+			data[2].lsb |= (time >> 16) & 1;
+			data[2].msb = (date >> 7) & 0xff;
+			data[2].block = V4L2_RDS_BLOCK_C | (V4L2_RDS_BLOCK_C << 3);
+			data[3].lsb = time & 0xff;
+			data[3].msb = (time >> 8) & 0xff;
+			break;
+		default: /* Group 15B */
+			data[1].lsb |= (rds->ta << 4) | (rds->ms << 3);
+			data[1].lsb |= vivid_get_di(rds, grp % 22);
+			data[1].msb |= 0x1f << 3;
+			data[2].lsb = rds->picode & 0xff;
+			data[2].msb = rds->picode >> 8;
+			data[2].block = V4L2_RDS_BLOCK_C_ALT | (V4L2_RDS_BLOCK_C_ALT << 3);
+			data[3].lsb = rds->pty << 5;
+			data[3].lsb |= (rds->ta << 4) | (rds->ms << 3);
+			data[3].lsb |= vivid_get_di(rds, grp % 22);
+			data[3].msb |= rds->pty >> 3;
+			data[3].msb |= 0x1f << 3;
+			break;
+		}
+	}
+}
+
+void vivid_rds_gen_fill(struct vivid_rds_gen *rds, unsigned freq,
+			  bool alt)
+{
+	/* Alternate PTY between Info and Weather */
+	if (rds->use_rbds) {
+		rds->picode = 0x2e75; /* 'KLNX' call sign */
+		rds->pty = alt ? 29 : 2;
+	} else {
+		rds->picode = 0x8088;
+		rds->pty = alt ? 16 : 3;
+	}
+	rds->mono_stereo = true;
+	rds->art_head = false;
+	rds->compressed = false;
+	rds->dyn_pty = false;
+	rds->tp = true;
+	rds->ta = alt;
+	rds->ms = true;
+	snprintf(rds->psname, sizeof(rds->psname), "%6d.%1d",
+		 freq / 16, ((freq & 0xf) * 10) / 16);
+	if (alt)
+		strlcpy(rds->radiotext,
+			" The Radio Data System can switch between different Radio Texts ",
+			sizeof(rds->radiotext));
+	else
+		strlcpy(rds->radiotext,
+			"An example of Radio Text as transmitted by the Radio Data System",
+			sizeof(rds->radiotext));
+}
diff --git a/drivers/media/platform/vivid/vivid-rds-gen.h b/drivers/media/platform/vivid/vivid-rds-gen.h
new file mode 100644
index 0000000..eff4bf5
--- /dev/null
+++ b/drivers/media/platform/vivid/vivid-rds-gen.h
@@ -0,0 +1,53 @@
+/*
+ * vivid-rds-gen.h - rds (radio data system) generator support functions.
+ *
+ * Copyright 2014 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
+ *
+ * This program is free software; you may redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#ifndef _VIVID_RDS_GEN_H_
+#define _VIVID_RDS_GEN_H_
+
+/*
+ * It takes almost exactly 5 seconds to transmit 57 RDS groups.
+ * Each group has 4 blocks and each block has a payload of 16 bits + a
+ * block identification. The driver will generate the contents of these
+ * 57 groups only when necessary and it will just be played continuously.
+ */
+#define VIVID_RDS_GEN_GROUPS 57
+#define VIVID_RDS_GEN_BLKS_PER_GRP 4
+#define VIVID_RDS_GEN_BLOCKS (VIVID_RDS_GEN_BLKS_PER_GRP * VIVID_RDS_GEN_GROUPS)
+
+struct vivid_rds_gen {
+	struct v4l2_rds_data	data[VIVID_RDS_GEN_BLOCKS];
+	bool			use_rbds;
+	u16			picode;
+	u8			pty;
+	bool			mono_stereo;
+	bool			art_head;
+	bool			compressed;
+	bool			dyn_pty;
+	bool			ta;
+	bool			tp;
+	bool			ms;
+	char			psname[8 + 1];
+	char			radiotext[64 + 1];
+};
+
+void vivid_rds_gen_fill(struct vivid_rds_gen *rds, unsigned freq,
+		    bool use_alternate);
+void vivid_rds_generate(struct vivid_rds_gen *rds);
+
+#endif
-- 
2.0.1

