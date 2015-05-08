Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:49897 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752283AbbEHJIH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 8 May 2015 05:08:07 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: ovebryne@cisco.com, marbugge@cisco.com, matrandg@cisco.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 5/5] cobalt: add new driver
Date: Fri,  8 May 2015 11:07:28 +0200
Message-Id: <1431076048-1963-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1431076048-1963-1-git-send-email-hverkuil@xs4all.nl>
References: <1431076048-1963-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The cobalt device is a PCIe card with 4 HDMI inputs (adv7604) and a
connector that can be used to hook up an adv7511 transmitter or an
adv7842 receiver daughterboard.

This device is used within Cisco but is sadly not available outside
of Cisco. Nevertheless it is a very interesting driver that can serve
as an example of how to support HDMI hardware and how to use the popular
adv devices.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 MAINTAINERS                                        |    8 +
 drivers/media/pci/Kconfig                          |    1 +
 drivers/media/pci/Makefile                         |    1 +
 drivers/media/pci/cobalt/Kconfig                   |   18 +
 drivers/media/pci/cobalt/Makefile                  |    5 +
 drivers/media/pci/cobalt/cobalt-alsa-main.c        |  162 +++
 drivers/media/pci/cobalt/cobalt-alsa-pcm.c         |  618 ++++++++++
 drivers/media/pci/cobalt/cobalt-alsa-pcm.h         |   22 +
 drivers/media/pci/cobalt/cobalt-alsa.h             |   42 +
 drivers/media/pci/cobalt/cobalt-cpld.c             |  341 ++++++
 drivers/media/pci/cobalt/cobalt-cpld.h             |   29 +
 drivers/media/pci/cobalt/cobalt-driver.c           |  821 +++++++++++++
 drivers/media/pci/cobalt/cobalt-driver.h           |  377 ++++++
 drivers/media/pci/cobalt/cobalt-flash.c            |  132 +++
 drivers/media/pci/cobalt/cobalt-flash.h            |   29 +
 drivers/media/pci/cobalt/cobalt-i2c.c              |  396 +++++++
 drivers/media/pci/cobalt/cobalt-i2c.h              |   25 +
 drivers/media/pci/cobalt/cobalt-irq.c              |  254 ++++
 drivers/media/pci/cobalt/cobalt-irq.h              |   25 +
 drivers/media/pci/cobalt/cobalt-omnitek.c          |  340 ++++++
 drivers/media/pci/cobalt/cobalt-omnitek.h          |   62 +
 drivers/media/pci/cobalt/cobalt-v4l2.c             | 1248 ++++++++++++++++++++
 drivers/media/pci/cobalt/cobalt-v4l2.h             |   22 +
 .../cobalt/m00233_video_measure_memmap_package.h   |  115 ++
 .../pci/cobalt/m00235_fdma_packer_memmap_package.h |   44 +
 .../media/pci/cobalt/m00389_cvi_memmap_package.h   |   59 +
 .../media/pci/cobalt/m00460_evcnt_memmap_package.h |   44 +
 .../pci/cobalt/m00473_freewheel_memmap_package.h   |   57 +
 .../m00479_clk_loss_detector_memmap_package.h      |   53 +
 .../m00514_syncgen_flow_evcnt_memmap_package.h     |   88 ++
 30 files changed, 5438 insertions(+)
 create mode 100644 drivers/media/pci/cobalt/Kconfig
 create mode 100644 drivers/media/pci/cobalt/Makefile
 create mode 100644 drivers/media/pci/cobalt/cobalt-alsa-main.c
 create mode 100644 drivers/media/pci/cobalt/cobalt-alsa-pcm.c
 create mode 100644 drivers/media/pci/cobalt/cobalt-alsa-pcm.h
 create mode 100644 drivers/media/pci/cobalt/cobalt-alsa.h
 create mode 100644 drivers/media/pci/cobalt/cobalt-cpld.c
 create mode 100644 drivers/media/pci/cobalt/cobalt-cpld.h
 create mode 100644 drivers/media/pci/cobalt/cobalt-driver.c
 create mode 100644 drivers/media/pci/cobalt/cobalt-driver.h
 create mode 100644 drivers/media/pci/cobalt/cobalt-flash.c
 create mode 100644 drivers/media/pci/cobalt/cobalt-flash.h
 create mode 100644 drivers/media/pci/cobalt/cobalt-i2c.c
 create mode 100644 drivers/media/pci/cobalt/cobalt-i2c.h
 create mode 100644 drivers/media/pci/cobalt/cobalt-irq.c
 create mode 100644 drivers/media/pci/cobalt/cobalt-irq.h
 create mode 100644 drivers/media/pci/cobalt/cobalt-omnitek.c
 create mode 100644 drivers/media/pci/cobalt/cobalt-omnitek.h
 create mode 100644 drivers/media/pci/cobalt/cobalt-v4l2.c
 create mode 100644 drivers/media/pci/cobalt/cobalt-v4l2.h
 create mode 100644 drivers/media/pci/cobalt/m00233_video_measure_memmap_package.h
 create mode 100644 drivers/media/pci/cobalt/m00235_fdma_packer_memmap_package.h
 create mode 100644 drivers/media/pci/cobalt/m00389_cvi_memmap_package.h
 create mode 100644 drivers/media/pci/cobalt/m00460_evcnt_memmap_package.h
 create mode 100644 drivers/media/pci/cobalt/m00473_freewheel_memmap_package.h
 create mode 100644 drivers/media/pci/cobalt/m00479_clk_loss_detector_memmap_package.h
 create mode 100644 drivers/media/pci/cobalt/m00514_syncgen_flow_evcnt_memmap_package.h

diff --git a/MAINTAINERS b/MAINTAINERS
index ef403f5..a09eb9f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2596,6 +2596,14 @@ L:	platform-driver-x86@vger.kernel.org
 S:	Supported
 F:	drivers/platform/x86/classmate-laptop.c
 
+COBALT MEDIA DRIVER
+M:	Hans Verkuil <hans.verkuil@cisco.com>
+L:	linux-media@vger.kernel.org
+T:	git git://linuxtv.org/media_tree.git
+W:	http://linuxtv.org
+S:	Supported
+F:	drivers/media/pci/cobalt/
+
 COCCINELLE/Semantic Patches (SmPL)
 M:	Julia Lawall <Julia.Lawall@lip6.fr>
 M:	Gilles Muller <Gilles.Muller@lip6.fr>
diff --git a/drivers/media/pci/Kconfig b/drivers/media/pci/Kconfig
index fd359fb..f318ae9 100644
--- a/drivers/media/pci/Kconfig
+++ b/drivers/media/pci/Kconfig
@@ -33,6 +33,7 @@ source "drivers/media/pci/cx88/Kconfig"
 source "drivers/media/pci/bt8xx/Kconfig"
 source "drivers/media/pci/saa7134/Kconfig"
 source "drivers/media/pci/saa7164/Kconfig"
+source "drivers/media/pci/cobalt/Kconfig"
 
 endif
 
diff --git a/drivers/media/pci/Makefile b/drivers/media/pci/Makefile
index 3471ab6..23ce53b 100644
--- a/drivers/media/pci/Makefile
+++ b/drivers/media/pci/Makefile
@@ -28,3 +28,4 @@ obj-$(CONFIG_VIDEO_DT3155) += dt3155/
 obj-$(CONFIG_VIDEO_MEYE) += meye/
 obj-$(CONFIG_STA2X11_VIP) += sta2x11/
 obj-$(CONFIG_VIDEO_SOLO6X10) += solo6x10/
+obj-$(CONFIG_VIDEO_COBALT) += cobalt/
diff --git a/drivers/media/pci/cobalt/Kconfig b/drivers/media/pci/cobalt/Kconfig
new file mode 100644
index 0000000..e3c03e9
--- /dev/null
+++ b/drivers/media/pci/cobalt/Kconfig
@@ -0,0 +1,18 @@
+config VIDEO_COBALT
+	tristate "Cisco Cobalt support"
+	depends on VIDEO_V4L2 && I2C && MEDIA_CONTROLLER
+	depends on PCI_MSI && MTD_COMPLEX_MAPPINGS
+	select I2C_ALGOBIT
+	select VIDEO_ADV7604
+	select VIDEO_ADV7511
+	select VIDEO_ADV7842
+	select VIDEOBUF2_DMA_SG
+	---help---
+	  This is a video4linux driver for the Cisco PCIe Cobalt card.
+
+	  This board is sadly not available outside of Cisco, but it is
+	  very useful as an example of a real driver that uses all the
+	  latest frameworks and APIs.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called cobalt.
diff --git a/drivers/media/pci/cobalt/Makefile b/drivers/media/pci/cobalt/Makefile
new file mode 100644
index 0000000..b328955
--- /dev/null
+++ b/drivers/media/pci/cobalt/Makefile
@@ -0,0 +1,5 @@
+cobalt-objs    := cobalt-driver.o cobalt-irq.o cobalt-v4l2.o \
+		  cobalt-i2c.o cobalt-omnitek.o cobalt-flash.o cobalt-cpld.o \
+		  cobalt-alsa-main.o cobalt-alsa-pcm.o
+
+obj-$(CONFIG_VIDEO_COBALT) += cobalt.o
diff --git a/drivers/media/pci/cobalt/cobalt-alsa-main.c b/drivers/media/pci/cobalt/cobalt-alsa-main.c
new file mode 100644
index 0000000..720e3ad
--- /dev/null
+++ b/drivers/media/pci/cobalt/cobalt-alsa-main.c
@@ -0,0 +1,162 @@
+/*
+ *  ALSA interface to cobalt PCM capture streams
+ *
+ *  Copyright 2014-2015 Cisco Systems, Inc. and/or its affiliates.
+ *  All rights reserved.
+ *
+ *  This program is free software; you may redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; version 2 of the License.
+ *
+ *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ *  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ *  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ *  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ *  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ *  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ *  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ *  SOFTWARE.
+ */
+
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/device.h>
+#include <linux/spinlock.h>
+
+#include <media/v4l2-device.h>
+
+#include <sound/core.h>
+#include <sound/initval.h>
+
+#include "cobalt-driver.h"
+#include "cobalt-alsa.h"
+#include "cobalt-alsa-pcm.h"
+
+static void snd_cobalt_card_free(struct snd_cobalt_card *cobsc)
+{
+	if (cobsc == NULL)
+		return;
+
+	cobsc->s->alsa = NULL;
+
+	kfree(cobsc);
+}
+
+static void snd_cobalt_card_private_free(struct snd_card *sc)
+{
+	if (sc == NULL)
+		return;
+	snd_cobalt_card_free(sc->private_data);
+	sc->private_data = NULL;
+	sc->private_free = NULL;
+}
+
+static int snd_cobalt_card_create(struct cobalt_stream *s,
+				       struct snd_card *sc,
+				       struct snd_cobalt_card **cobsc)
+{
+	*cobsc = kzalloc(sizeof(struct snd_cobalt_card), GFP_KERNEL);
+	if (*cobsc == NULL)
+		return -ENOMEM;
+
+	(*cobsc)->s = s;
+	(*cobsc)->sc = sc;
+
+	sc->private_data = *cobsc;
+	sc->private_free = snd_cobalt_card_private_free;
+
+	return 0;
+}
+
+static int snd_cobalt_card_set_names(struct snd_cobalt_card *cobsc)
+{
+	struct cobalt_stream *s = cobsc->s;
+	struct cobalt *cobalt = s->cobalt;
+	struct snd_card *sc = cobsc->sc;
+
+	/* sc->driver is used by alsa-lib's configurator: simple, unique */
+	strlcpy(sc->driver, "cobalt", sizeof(sc->driver));
+
+	/* sc->shortname is a symlink in /proc/asound: COBALT-M -> cardN */
+	snprintf(sc->shortname,  sizeof(sc->shortname), "cobalt-%d-%d",
+		 cobalt->instance, s->video_channel);
+
+	/* sc->longname is read from /proc/asound/cards */
+	snprintf(sc->longname, sizeof(sc->longname),
+		 "Cobalt %d HDMI %d",
+		 cobalt->instance, s->video_channel);
+
+	return 0;
+}
+
+int cobalt_alsa_init(struct cobalt_stream *s)
+{
+	struct cobalt *cobalt = s->cobalt;
+	struct snd_card *sc = NULL;
+	struct snd_cobalt_card *cobsc;
+	int ret;
+
+	/* Numbrs steps from "Writing an ALSA Driver" by Takashi Iwai */
+
+	/* (1) Check and increment the device index */
+	/* This is a no-op for us.  We'll use the cobalt->instance */
+
+	/* (2) Create a card instance */
+	ret = snd_card_new(&cobalt->pci_dev->dev, SNDRV_DEFAULT_IDX1,
+			   SNDRV_DEFAULT_STR1, THIS_MODULE, 0, &sc);
+	if (ret) {
+		cobalt_err("snd_card_new() failed with err %d\n", ret);
+		goto err_exit;
+	}
+
+	/* (3) Create a main component */
+	ret = snd_cobalt_card_create(s, sc, &cobsc);
+	if (ret) {
+		cobalt_err("snd_cobalt_card_create() failed with err %d\n",
+			   ret);
+		goto err_exit_free;
+	}
+
+	/* (4) Set the driver ID and name strings */
+	snd_cobalt_card_set_names(cobsc);
+
+	ret = snd_cobalt_pcm_create(cobsc);
+	if (ret) {
+		cobalt_err("snd_cobalt_pcm_create() failed with err %d\n",
+			   ret);
+		goto err_exit_free;
+	}
+	/* FIXME - proc files */
+
+	/* (7) Set the driver data and return 0 */
+	/* We do this out of normal order for PCI drivers to avoid races */
+	s->alsa = cobsc;
+
+	/* (6) Register the card instance */
+	ret = snd_card_register(sc);
+	if (ret) {
+		s->alsa = NULL;
+		cobalt_err("snd_card_register() failed with err %d\n", ret);
+		goto err_exit_free;
+	}
+
+	return 0;
+
+err_exit_free:
+	if (sc != NULL)
+		snd_card_free(sc);
+	kfree(cobsc);
+err_exit:
+	return ret;
+}
+
+void cobalt_alsa_exit(struct cobalt_stream *s)
+{
+	struct snd_cobalt_card *cobsc = s->alsa;
+
+	if (cobsc)
+		snd_card_free(cobsc->sc);
+	s->alsa = NULL;
+}
diff --git a/drivers/media/pci/cobalt/cobalt-alsa-pcm.c b/drivers/media/pci/cobalt/cobalt-alsa-pcm.c
new file mode 100644
index 0000000..e039914
--- /dev/null
+++ b/drivers/media/pci/cobalt/cobalt-alsa-pcm.c
@@ -0,0 +1,618 @@
+/*
+ *  ALSA PCM device for the
+ *  ALSA interface to cobalt PCM capture streams
+ *
+ *  Copyright 2014-2015 Cisco Systems, Inc. and/or its affiliates.
+ *  All rights reserved.
+ *
+ *  This program is free software; you may redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; version 2 of the License.
+ *
+ *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ *  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ *  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ *  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ *  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ *  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ *  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ *  SOFTWARE.
+ */
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/vmalloc.h>
+#include <linux/delay.h>
+
+#include <media/v4l2-device.h>
+
+#include <sound/core.h>
+#include <sound/pcm.h>
+
+#include "cobalt-driver.h"
+#include "cobalt-alsa.h"
+#include "cobalt-alsa-pcm.h"
+
+static unsigned int pcm_debug;
+module_param(pcm_debug, int, 0644);
+MODULE_PARM_DESC(pcm_debug, "enable debug messages for pcm");
+
+#define dprintk(fmt, arg...) \
+	do { \
+		if (pcm_debug) \
+			pr_info("cobalt-alsa-pcm %s: " fmt, __func__, ##arg); \
+	} while (0)
+
+static struct snd_pcm_hardware snd_cobalt_hdmi_capture = {
+	.info = SNDRV_PCM_INFO_BLOCK_TRANSFER |
+		SNDRV_PCM_INFO_MMAP           |
+		SNDRV_PCM_INFO_INTERLEAVED    |
+		SNDRV_PCM_INFO_MMAP_VALID,
+
+	.formats = SNDRV_PCM_FMTBIT_S16_LE | SNDRV_PCM_FMTBIT_S32_LE,
+
+	.rates = SNDRV_PCM_RATE_48000,
+
+	.rate_min = 48000,
+	.rate_max = 48000,
+	.channels_min = 1,
+	.channels_max = 8,
+	.buffer_bytes_max = 4 * 240 * 8 * 4,	/* 5 ms of data */
+	.period_bytes_min = 1920,		/* 1 sample = 8 * 4 bytes */
+	.period_bytes_max = 240 * 8 * 4,	/* 5 ms of 8 channel data */
+	.periods_min = 1,
+	.periods_max = 4,
+};
+
+static struct snd_pcm_hardware snd_cobalt_playback = {
+	.info = SNDRV_PCM_INFO_BLOCK_TRANSFER |
+		SNDRV_PCM_INFO_MMAP           |
+		SNDRV_PCM_INFO_INTERLEAVED    |
+		SNDRV_PCM_INFO_MMAP_VALID,
+
+	.formats = SNDRV_PCM_FMTBIT_S16_LE | SNDRV_PCM_FMTBIT_S32_LE,
+
+	.rates = SNDRV_PCM_RATE_48000,
+
+	.rate_min = 48000,
+	.rate_max = 48000,
+	.channels_min = 1,
+	.channels_max = 8,
+	.buffer_bytes_max = 4 * 240 * 8 * 4,	/* 5 ms of data */
+	.period_bytes_min = 1920,		/* 1 sample = 8 * 4 bytes */
+	.period_bytes_max = 240 * 8 * 4,	/* 5 ms of 8 channel data */
+	.periods_min = 1,
+	.periods_max = 4,
+};
+
+static void sample_cpy(u8 *dst, const u8 *src, u32 len, bool is_s32)
+{
+	static const unsigned map[8] = { 0, 1, 5, 4, 2, 3, 6, 7 };
+	unsigned idx = 0;
+
+	while (len >= (is_s32 ? 4 : 2)) {
+		unsigned offset = map[idx] * 4;
+		u32 val = src[offset + 1] + (src[offset + 2] << 8) +
+			 (src[offset + 3] << 16);
+
+		if (is_s32) {
+			*dst++ = 0;
+			*dst++ = val & 0xff;
+		}
+		*dst++ = (val >> 8) & 0xff;
+		*dst++ = (val >> 16) & 0xff;
+		len -= is_s32 ? 4 : 2;
+		idx++;
+	}
+}
+
+static void cobalt_alsa_announce_pcm_data(struct snd_cobalt_card *cobsc,
+					u8 *pcm_data,
+					size_t skip,
+					size_t samples)
+{
+	struct snd_pcm_substream *substream;
+	struct snd_pcm_runtime *runtime;
+	unsigned long flags;
+	unsigned int oldptr;
+	unsigned int stride;
+	int length = samples;
+	int period_elapsed = 0;
+	bool is_s32;
+
+	dprintk("cobalt alsa announce ptr=%p data=%p num_bytes=%zd\n", cobsc,
+		pcm_data, samples);
+
+	substream = cobsc->capture_pcm_substream;
+	if (substream == NULL) {
+		dprintk("substream was NULL\n");
+		return;
+	}
+
+	runtime = substream->runtime;
+	if (runtime == NULL) {
+		dprintk("runtime was NULL\n");
+		return;
+	}
+	is_s32 = runtime->format == SNDRV_PCM_FORMAT_S32_LE;
+
+	stride = runtime->frame_bits >> 3;
+	if (stride == 0) {
+		dprintk("stride is zero\n");
+		return;
+	}
+
+	if (length == 0) {
+		dprintk("%s: length was zero\n", __func__);
+		return;
+	}
+
+	if (runtime->dma_area == NULL) {
+		dprintk("dma area was NULL - ignoring\n");
+		return;
+	}
+
+	oldptr = cobsc->hwptr_done_capture;
+	if (oldptr + length >= runtime->buffer_size) {
+		unsigned int cnt = runtime->buffer_size - oldptr;
+		unsigned i;
+
+		for (i = 0; i < cnt; i++)
+			sample_cpy(runtime->dma_area + (oldptr + i) * stride,
+					pcm_data + i * skip,
+					stride, is_s32);
+		for (i = cnt; i < length; i++)
+			sample_cpy(runtime->dma_area + (i - cnt) * stride,
+					pcm_data + i * skip, stride, is_s32);
+	} else {
+		unsigned i;
+
+		for (i = 0; i < length; i++)
+			sample_cpy(runtime->dma_area + (oldptr + i) * stride,
+					pcm_data + i * skip,
+					stride, is_s32);
+	}
+	snd_pcm_stream_lock_irqsave(substream, flags);
+
+	cobsc->hwptr_done_capture += length;
+	if (cobsc->hwptr_done_capture >=
+	    runtime->buffer_size)
+		cobsc->hwptr_done_capture -=
+			runtime->buffer_size;
+
+	cobsc->capture_transfer_done += length;
+	if (cobsc->capture_transfer_done >=
+	    runtime->period_size) {
+		cobsc->capture_transfer_done -=
+			runtime->period_size;
+		period_elapsed = 1;
+	}
+
+	snd_pcm_stream_unlock_irqrestore(substream, flags);
+
+	if (period_elapsed)
+		snd_pcm_period_elapsed(substream);
+}
+
+static int alsa_fnc(struct vb2_buffer *vb, void *priv)
+{
+	struct cobalt_stream *s = priv;
+	unsigned char *p = vb2_plane_vaddr(vb, 0);
+	int i;
+
+	if (pcm_debug) {
+		pr_info("alsa: ");
+		for (i = 0; i < 8 * 4; i++) {
+			if (!(i & 3))
+				pr_cont(" ");
+			pr_cont("%02x", p[i]);
+		}
+		pr_cont("\n");
+	}
+	cobalt_alsa_announce_pcm_data(s->alsa,
+			vb2_plane_vaddr(vb, 0),
+			8 * 4,
+			vb2_get_plane_payload(vb, 0) / (8 * 4));
+	return 0;
+}
+
+static int snd_cobalt_pcm_capture_open(struct snd_pcm_substream *substream)
+{
+	struct snd_pcm_runtime *runtime = substream->runtime;
+	struct snd_cobalt_card *cobsc = snd_pcm_substream_chip(substream);
+	struct cobalt_stream *s = cobsc->s;
+
+	runtime->hw = snd_cobalt_hdmi_capture;
+	snd_pcm_hw_constraint_integer(runtime, SNDRV_PCM_HW_PARAM_PERIODS);
+	cobsc->capture_pcm_substream = substream;
+	runtime->private_data = s;
+	cobsc->alsa_record_cnt++;
+	if (cobsc->alsa_record_cnt == 1) {
+		int rc;
+
+		rc = vb2_thread_start(&s->q, alsa_fnc, s, s->vdev.name);
+		if (rc) {
+			cobsc->alsa_record_cnt--;
+			return rc;
+		}
+	}
+	return 0;
+}
+
+static int snd_cobalt_pcm_capture_close(struct snd_pcm_substream *substream)
+{
+	struct snd_cobalt_card *cobsc = snd_pcm_substream_chip(substream);
+	struct cobalt_stream *s = cobsc->s;
+
+	cobsc->alsa_record_cnt--;
+	if (cobsc->alsa_record_cnt == 0)
+		vb2_thread_stop(&s->q);
+	return 0;
+}
+
+static int snd_cobalt_pcm_ioctl(struct snd_pcm_substream *substream,
+		     unsigned int cmd, void *arg)
+{
+	return snd_pcm_lib_ioctl(substream, cmd, arg);
+}
+
+
+static int snd_pcm_alloc_vmalloc_buffer(struct snd_pcm_substream *subs,
+					size_t size)
+{
+	struct snd_pcm_runtime *runtime = subs->runtime;
+
+	dprintk("Allocating vbuffer\n");
+	if (runtime->dma_area) {
+		if (runtime->dma_bytes > size)
+			return 0;
+
+		vfree(runtime->dma_area);
+	}
+	runtime->dma_area = vmalloc(size);
+	if (!runtime->dma_area)
+		return -ENOMEM;
+
+	runtime->dma_bytes = size;
+
+	return 0;
+}
+
+static int snd_cobalt_pcm_hw_params(struct snd_pcm_substream *substream,
+			 struct snd_pcm_hw_params *params)
+{
+	dprintk("%s called\n", __func__);
+
+	return snd_pcm_alloc_vmalloc_buffer(substream,
+					   params_buffer_bytes(params));
+}
+
+static int snd_cobalt_pcm_hw_free(struct snd_pcm_substream *substream)
+{
+	struct snd_cobalt_card *cobsc = snd_pcm_substream_chip(substream);
+	unsigned long flags;
+
+	spin_lock_irqsave(&cobsc->slock, flags);
+	if (substream->runtime->dma_area) {
+		dprintk("freeing pcm capture region\n");
+		vfree(substream->runtime->dma_area);
+		substream->runtime->dma_area = NULL;
+	}
+	spin_unlock_irqrestore(&cobsc->slock, flags);
+
+	return 0;
+}
+
+static int snd_cobalt_pcm_prepare(struct snd_pcm_substream *substream)
+{
+	struct snd_cobalt_card *cobsc = snd_pcm_substream_chip(substream);
+
+	cobsc->hwptr_done_capture = 0;
+	cobsc->capture_transfer_done = 0;
+
+	return 0;
+}
+
+static int snd_cobalt_pcm_trigger(struct snd_pcm_substream *substream, int cmd)
+{
+	switch (cmd) {
+	case SNDRV_PCM_TRIGGER_START:
+	case SNDRV_PCM_TRIGGER_STOP:
+		return 0;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static
+snd_pcm_uframes_t snd_cobalt_pcm_pointer(struct snd_pcm_substream *substream)
+{
+	unsigned long flags;
+	snd_pcm_uframes_t hwptr_done;
+	struct snd_cobalt_card *cobsc = snd_pcm_substream_chip(substream);
+
+	spin_lock_irqsave(&cobsc->slock, flags);
+	hwptr_done = cobsc->hwptr_done_capture;
+	spin_unlock_irqrestore(&cobsc->slock, flags);
+
+	return hwptr_done;
+}
+
+static void pb_sample_cpy(u8 *dst, const u8 *src, u32 len, bool is_s32)
+{
+	static const unsigned map[8] = { 0, 1, 5, 4, 2, 3, 6, 7 };
+	unsigned idx = 0;
+
+	while (len >= (is_s32 ? 4 : 2)) {
+		unsigned offset = map[idx] * 4;
+		u8 *out = dst + offset;
+
+		*out++ = 0;
+		if (is_s32) {
+			src++;
+			*out++ = *src++;
+		} else {
+			*out++ = 0;
+		}
+		*out++ = *src++;
+		*out = *src++;
+		len -= is_s32 ? 4 : 2;
+		idx++;
+	}
+}
+
+static void cobalt_alsa_pb_pcm_data(struct snd_cobalt_card *cobsc,
+					u8 *pcm_data,
+					size_t skip,
+					size_t samples)
+{
+	struct snd_pcm_substream *substream;
+	struct snd_pcm_runtime *runtime;
+	unsigned long flags;
+	unsigned int pos;
+	unsigned int stride;
+	bool is_s32;
+	unsigned i;
+
+	dprintk("cobalt alsa pb ptr=%p data=%p samples=%zd\n", cobsc,
+		pcm_data, samples);
+
+	substream = cobsc->playback_pcm_substream;
+	if (substream == NULL) {
+		dprintk("substream was NULL\n");
+		return;
+	}
+
+	runtime = substream->runtime;
+	if (runtime == NULL) {
+		dprintk("runtime was NULL\n");
+		return;
+	}
+
+	is_s32 = runtime->format == SNDRV_PCM_FORMAT_S32_LE;
+	stride = runtime->frame_bits >> 3;
+	if (stride == 0) {
+		dprintk("stride is zero\n");
+		return;
+	}
+
+	if (samples == 0) {
+		dprintk("%s: samples was zero\n", __func__);
+		return;
+	}
+
+	if (runtime->dma_area == NULL) {
+		dprintk("dma area was NULL - ignoring\n");
+		return;
+	}
+
+	pos = cobsc->pb_pos % cobsc->pb_size;
+	for (i = 0; i < cobsc->pb_count / (8 * 4); i++)
+		pb_sample_cpy(pcm_data + i * skip,
+				runtime->dma_area + pos + i * stride,
+				stride, is_s32);
+	snd_pcm_stream_lock_irqsave(substream, flags);
+
+	cobsc->pb_pos += i * stride;
+
+	snd_pcm_stream_unlock_irqrestore(substream, flags);
+	if (cobsc->pb_pos % cobsc->pb_count == 0)
+		snd_pcm_period_elapsed(substream);
+}
+
+static int alsa_pb_fnc(struct vb2_buffer *vb, void *priv)
+{
+	struct cobalt_stream *s = priv;
+
+	if (s->alsa->alsa_pb_channel)
+		cobalt_alsa_pb_pcm_data(s->alsa,
+				vb2_plane_vaddr(vb, 0),
+				8 * 4,
+				vb2_get_plane_payload(vb, 0) / (8 * 4));
+	return 0;
+}
+
+static int snd_cobalt_pcm_playback_open(struct snd_pcm_substream *substream)
+{
+	struct snd_cobalt_card *cobsc = snd_pcm_substream_chip(substream);
+	struct snd_pcm_runtime *runtime = substream->runtime;
+	struct cobalt_stream *s = cobsc->s;
+
+	runtime->hw = snd_cobalt_playback;
+	snd_pcm_hw_constraint_integer(runtime, SNDRV_PCM_HW_PARAM_PERIODS);
+	cobsc->playback_pcm_substream = substream;
+	runtime->private_data = s;
+	cobsc->alsa_playback_cnt++;
+	if (cobsc->alsa_playback_cnt == 1) {
+		int rc;
+
+		rc = vb2_thread_start(&s->q, alsa_pb_fnc, s, s->vdev.name);
+		if (rc) {
+			cobsc->alsa_playback_cnt--;
+			return rc;
+		}
+	}
+
+	return 0;
+}
+
+static int snd_cobalt_pcm_playback_close(struct snd_pcm_substream *substream)
+{
+	struct snd_cobalt_card *cobsc = snd_pcm_substream_chip(substream);
+	struct cobalt_stream *s = cobsc->s;
+
+	cobsc->alsa_playback_cnt--;
+	if (cobsc->alsa_playback_cnt == 0)
+		vb2_thread_stop(&s->q);
+	return 0;
+}
+
+static int snd_cobalt_pcm_pb_prepare(struct snd_pcm_substream *substream)
+{
+	struct snd_cobalt_card *cobsc = snd_pcm_substream_chip(substream);
+
+	cobsc->pb_size = snd_pcm_lib_buffer_bytes(substream);
+	cobsc->pb_count = snd_pcm_lib_period_bytes(substream);
+	cobsc->pb_pos = 0;
+
+	return 0;
+}
+
+static int snd_cobalt_pcm_pb_trigger(struct snd_pcm_substream *substream,
+				     int cmd)
+{
+	struct snd_cobalt_card *cobsc = snd_pcm_substream_chip(substream);
+
+	switch (cmd) {
+	case SNDRV_PCM_TRIGGER_START:
+		if (cobsc->alsa_pb_channel)
+			return -EBUSY;
+		cobsc->alsa_pb_channel = true;
+		return 0;
+	case SNDRV_PCM_TRIGGER_STOP:
+		cobsc->alsa_pb_channel = false;
+		return 0;
+	default:
+		return -EINVAL;
+	}
+}
+
+static
+snd_pcm_uframes_t snd_cobalt_pcm_pb_pointer(struct snd_pcm_substream *substream)
+{
+	unsigned long flags;
+	struct snd_cobalt_card *cobsc = snd_pcm_substream_chip(substream);
+	size_t ptr;
+
+	spin_lock_irqsave(&cobsc->slock, flags);
+	ptr = cobsc->pb_pos;
+	spin_unlock_irqrestore(&cobsc->slock, flags);
+
+	return bytes_to_frames(substream->runtime, ptr) %
+	       substream->runtime->buffer_size;
+}
+
+static struct page *snd_pcm_get_vmalloc_page(struct snd_pcm_substream *subs,
+					     unsigned long offset)
+{
+	void *pageptr = subs->runtime->dma_area + offset;
+
+	return vmalloc_to_page(pageptr);
+}
+
+static struct snd_pcm_ops snd_cobalt_pcm_capture_ops = {
+	.open		= snd_cobalt_pcm_capture_open,
+	.close		= snd_cobalt_pcm_capture_close,
+	.ioctl		= snd_cobalt_pcm_ioctl,
+	.hw_params	= snd_cobalt_pcm_hw_params,
+	.hw_free	= snd_cobalt_pcm_hw_free,
+	.prepare	= snd_cobalt_pcm_prepare,
+	.trigger	= snd_cobalt_pcm_trigger,
+	.pointer	= snd_cobalt_pcm_pointer,
+	.page		= snd_pcm_get_vmalloc_page,
+};
+
+static struct snd_pcm_ops snd_cobalt_pcm_playback_ops = {
+	.open		= snd_cobalt_pcm_playback_open,
+	.close		= snd_cobalt_pcm_playback_close,
+	.ioctl		= snd_cobalt_pcm_ioctl,
+	.hw_params	= snd_cobalt_pcm_hw_params,
+	.hw_free	= snd_cobalt_pcm_hw_free,
+	.prepare	= snd_cobalt_pcm_pb_prepare,
+	.trigger	= snd_cobalt_pcm_pb_trigger,
+	.pointer	= snd_cobalt_pcm_pb_pointer,
+	.page		= snd_pcm_get_vmalloc_page,
+};
+
+int snd_cobalt_pcm_create(struct snd_cobalt_card *cobsc)
+{
+	struct snd_pcm *sp;
+	struct snd_card *sc = cobsc->sc;
+	struct cobalt_stream *s = cobsc->s;
+	struct cobalt *cobalt = s->cobalt;
+	int ret;
+
+	s->q.gfp_flags |= __GFP_ZERO;
+
+	if (!s->is_output) {
+		cobalt_s_bit_sysctrl(cobalt,
+			COBALT_SYS_CTRL_AUDIO_IPP_RESETN_BIT(s->video_channel),
+			0);
+		mdelay(2);
+		cobalt_s_bit_sysctrl(cobalt,
+			COBALT_SYS_CTRL_AUDIO_IPP_RESETN_BIT(s->video_channel),
+			1);
+		mdelay(1);
+
+		ret = snd_pcm_new(sc, "Cobalt PCM-In HDMI",
+			0, /* PCM device 0, the only one for this card */
+			0, /* 0 playback substreams */
+			1, /* 1 capture substream */
+			&sp);
+		if (ret) {
+			cobalt_err("snd_cobalt_pcm_create() failed for input with err %d\n",
+				   ret);
+			goto err_exit;
+		}
+
+		spin_lock_init(&cobsc->slock);
+
+		snd_pcm_set_ops(sp, SNDRV_PCM_STREAM_CAPTURE,
+				&snd_cobalt_pcm_capture_ops);
+		sp->info_flags = 0;
+		sp->private_data = cobsc;
+		strlcpy(sp->name, "cobalt", sizeof(sp->name));
+	} else {
+		cobalt_s_bit_sysctrl(cobalt,
+			COBALT_SYS_CTRL_AUDIO_OPP_RESETN_BIT, 0);
+		mdelay(2);
+		cobalt_s_bit_sysctrl(cobalt,
+			COBALT_SYS_CTRL_AUDIO_OPP_RESETN_BIT, 1);
+		mdelay(1);
+
+		ret = snd_pcm_new(sc, "Cobalt PCM-Out HDMI",
+			0, /* PCM device 0, the only one for this card */
+			1, /* 0 playback substreams */
+			0, /* 1 capture substream */
+			&sp);
+		if (ret) {
+			cobalt_err("snd_cobalt_pcm_create() failed for output with err %d\n",
+				   ret);
+			goto err_exit;
+		}
+
+		spin_lock_init(&cobsc->slock);
+
+		snd_pcm_set_ops(sp, SNDRV_PCM_STREAM_PLAYBACK,
+				&snd_cobalt_pcm_playback_ops);
+		sp->info_flags = 0;
+		sp->private_data = cobsc;
+		strlcpy(sp->name, "cobalt", sizeof(sp->name));
+	}
+
+	return 0;
+
+err_exit:
+	return ret;
+}
diff --git a/drivers/media/pci/cobalt/cobalt-alsa-pcm.h b/drivers/media/pci/cobalt/cobalt-alsa-pcm.h
new file mode 100644
index 0000000..513fb1f
--- /dev/null
+++ b/drivers/media/pci/cobalt/cobalt-alsa-pcm.h
@@ -0,0 +1,22 @@
+/*
+ *  ALSA PCM device for the
+ *  ALSA interface to cobalt PCM capture streams
+ *
+ *  Copyright 2014-2015 Cisco Systems, Inc. and/or its affiliates.
+ *  All rights reserved.
+ *
+ *  This program is free software; you may redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; version 2 of the License.
+ *
+ *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ *  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ *  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ *  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ *  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ *  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ *  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ *  SOFTWARE.
+ */
+
+int snd_cobalt_pcm_create(struct snd_cobalt_card *cobsc);
diff --git a/drivers/media/pci/cobalt/cobalt-alsa.h b/drivers/media/pci/cobalt/cobalt-alsa.h
new file mode 100644
index 0000000..1af53af
--- /dev/null
+++ b/drivers/media/pci/cobalt/cobalt-alsa.h
@@ -0,0 +1,42 @@
+/*
+ *  ALSA interface to cobalt PCM capture streams
+ *
+ *  Copyright 2014-2015 Cisco Systems, Inc. and/or its affiliates.
+ *  All rights reserved.
+ *
+ *  This program is free software; you may redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; version 2 of the License.
+ *
+ *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ *  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ *  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ *  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ *  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ *  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ *  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ *  SOFTWARE.
+ */
+
+struct snd_card;
+
+struct snd_cobalt_card {
+	struct cobalt_stream *s;
+	struct snd_card *sc;
+	unsigned int capture_transfer_done;
+	unsigned int hwptr_done_capture;
+	unsigned alsa_record_cnt;
+	struct snd_pcm_substream *capture_pcm_substream;
+
+	unsigned int pb_size;
+	unsigned int pb_count;
+	unsigned int pb_pos;
+	unsigned pb_filled;
+	bool alsa_pb_channel;
+	unsigned alsa_playback_cnt;
+	struct snd_pcm_substream *playback_pcm_substream;
+	spinlock_t slock;
+};
+
+int cobalt_alsa_init(struct cobalt_stream *s);
+void cobalt_alsa_exit(struct cobalt_stream *s);
diff --git a/drivers/media/pci/cobalt/cobalt-cpld.c b/drivers/media/pci/cobalt/cobalt-cpld.c
new file mode 100644
index 0000000..77ed9e5
--- /dev/null
+++ b/drivers/media/pci/cobalt/cobalt-cpld.c
@@ -0,0 +1,341 @@
+/*
+ *  Cobalt CPLD functions
+ *
+ *  Copyright 2012-2015 Cisco Systems, Inc. and/or its affiliates.
+ *  All rights reserved.
+ *
+ *  This program is free software; you may redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; version 2 of the License.
+ *
+ *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ *  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ *  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ *  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ *  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ *  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ *  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ *  SOFTWARE.
+ */
+
+#include <linux/delay.h>
+
+#include "cobalt-driver.h"
+
+#define ADRS(offset) (COBALT_BUS_CPLD_BASE + offset)
+
+static u16 cpld_read(struct cobalt *cobalt, u32 offset)
+{
+	return cobalt_bus_read32(cobalt, ADRS(offset));
+}
+
+static void cpld_write(struct cobalt *cobalt, u32 offset, u16 val)
+{
+	return cobalt_bus_write32(cobalt, ADRS(offset), val);
+}
+
+static void cpld_info_ver3(struct cobalt *cobalt)
+{
+	u32 rd;
+	u32 tmp;
+
+	cobalt_info("CPLD System control register (read/write)\n");
+	cobalt_info("\t\tSystem control:  0x%04x (0x0f00)\n",
+		    cpld_read(cobalt, 0));
+	cobalt_info("CPLD Clock control register (read/write)\n");
+	cobalt_info("\t\tClock control:   0x%04x (0x0000)\n",
+		    cpld_read(cobalt, 0x04));
+	cobalt_info("CPLD HSMA Clk Osc register (read/write) - Must set wr trigger to load default values\n");
+	cobalt_info("\t\tRegister #7:\t0x%04x (0x0022)\n",
+		    cpld_read(cobalt, 0x08));
+	cobalt_info("\t\tRegister #8:\t0x%04x (0x0047)\n",
+		    cpld_read(cobalt, 0x0c));
+	cobalt_info("\t\tRegister #9:\t0x%04x (0x00fa)\n",
+		    cpld_read(cobalt, 0x10));
+	cobalt_info("\t\tRegister #10:\t0x%04x (0x0061)\n",
+		    cpld_read(cobalt, 0x14));
+	cobalt_info("\t\tRegister #11:\t0x%04x (0x001e)\n",
+		    cpld_read(cobalt, 0x18));
+	cobalt_info("\t\tRegister #12:\t0x%04x (0x0045)\n",
+		    cpld_read(cobalt, 0x1c));
+	cobalt_info("\t\tRegister #135:\t0x%04x\n",
+		    cpld_read(cobalt, 0x20));
+	cobalt_info("\t\tRegister #137:\t0x%04x\n",
+		    cpld_read(cobalt, 0x24));
+	cobalt_info("CPLD System status register (read only)\n");
+	cobalt_info("\t\tSystem status:  0x%04x\n",
+		    cpld_read(cobalt, 0x28));
+	cobalt_info("CPLD MAXII info register (read only)\n");
+	cobalt_info("\t\tBoard serial number:     0x%04x\n",
+		    cpld_read(cobalt, 0x2c));
+	cobalt_info("\t\tMAXII program revision:  0x%04x\n",
+		    cpld_read(cobalt, 0x30));
+	cobalt_info("CPLD temp and voltage ADT7411 registers (read only)\n");
+	cobalt_info("\t\tBoard temperature:  %u Celcius\n",
+		    cpld_read(cobalt, 0x34) / 4);
+	cobalt_info("\t\tFPGA temperature:   %u Celcius\n",
+		    cpld_read(cobalt, 0x38) / 4);
+	rd = cpld_read(cobalt, 0x3c);
+	tmp = (rd * 33 * 1000) / (483 * 10);
+	cobalt_info("\t\tVDD 3V3:      %u,%03uV\n", tmp / 1000, tmp % 1000);
+	rd = cpld_read(cobalt, 0x40);
+	tmp = (rd * 74 * 2197) / (27 * 1000);
+	cobalt_info("\t\tADC ch3 5V:   %u,%03uV\n", tmp / 1000, tmp % 1000);
+	rd = cpld_read(cobalt, 0x44);
+	tmp = (rd * 74 * 2197) / (47 * 1000);
+	cobalt_info("\t\tADC ch4 3V:   %u,%03uV\n", tmp / 1000, tmp % 1000);
+	rd = cpld_read(cobalt, 0x48);
+	tmp = (rd * 57 * 2197) / (47 * 1000);
+	cobalt_info("\t\tADC ch5 2V5:  %u,%03uV\n", tmp / 1000, tmp % 1000);
+	rd = cpld_read(cobalt, 0x4c);
+	tmp = (rd * 2197) / 1000;
+	cobalt_info("\t\tADC ch6 1V8:  %u,%03uV\n", tmp / 1000, tmp % 1000);
+	rd = cpld_read(cobalt, 0x50);
+	tmp = (rd * 2197) / 1000;
+	cobalt_info("\t\tADC ch7 1V5:  %u,%03uV\n", tmp / 1000, tmp % 1000);
+	rd = cpld_read(cobalt, 0x54);
+	tmp = (rd * 2197) / 1000;
+	cobalt_info("\t\tADC ch8 0V9:  %u,%03uV\n", tmp / 1000, tmp % 1000);
+}
+
+void cobalt_cpld_status(struct cobalt *cobalt)
+{
+	u32 rev = cpld_read(cobalt, 0x30);
+
+	switch (rev) {
+	case 3:
+	case 4:
+	case 5:
+		cpld_info_ver3(cobalt);
+		break;
+	default:
+		cobalt_info("CPLD revision %u is not supported!\n", rev);
+		break;
+	}
+}
+
+#define DCO_MIN 4850000000ULL
+#define DCO_MAX 5670000000ULL
+
+#define SI570_CLOCK_CTRL   0x04
+#define S01755_REG_CLOCK_CTRL_BITMAP_CLKHSMA_WR_TRIGGER 0x200
+#define S01755_REG_CLOCK_CTRL_BITMAP_CLKHSMA_RST_TRIGGER 0x100
+#define S01755_REG_CLOCK_CTRL_BITMAP_CLKHSMA_FPGA_CTRL 0x80
+#define S01755_REG_CLOCK_CTRL_BITMAP_CLKHSMA_EN 0x40
+
+#define SI570_REG7   0x08
+#define SI570_REG8   0x0c
+#define SI570_REG9   0x10
+#define SI570_REG10  0x14
+#define SI570_REG11  0x18
+#define SI570_REG12  0x1c
+#define SI570_REG135 0x20
+#define SI570_REG137 0x24
+
+struct multiplier {
+	unsigned mult, hsdiv, n1;
+};
+
+/* List all possible multipliers (= hsdiv * n1). There are lots of duplicates,
+   which are all removed in this list to keep the list as short as possible.
+   The values for hsdiv and n1 are the actual values, not the register values.
+ */
+static const struct multiplier multipliers[] = {
+	{    4,  4,   1 }, {    5,  5,   1 }, {    6,  6,   1 },
+	{    7,  7,   1 }, {    8,  4,   2 }, {    9,  9,   1 },
+	{   10,  5,   2 }, {   11, 11,   1 }, {   12,  6,   2 },
+	{   14,  7,   2 }, {   16,  4,   4 }, {   18,  9,   2 },
+	{   20,  5,   4 }, {   22, 11,   2 }, {   24,  4,   6 },
+	{   28,  7,   4 }, {   30,  5,   6 }, {   32,  4,   8 },
+	{   36,  6,   6 }, {   40,  4,  10 }, {   42,  7,   6 },
+	{   44, 11,   4 }, {   48,  4,  12 }, {   50,  5,  10 },
+	{   54,  9,   6 }, {   56,  4,  14 }, {   60,  5,  12 },
+	{   64,  4,  16 }, {   66, 11,   6 }, {   70,  5,  14 },
+	{   72,  4,  18 }, {   80,  4,  20 }, {   84,  6,  14 },
+	{   88, 11,   8 }, {   90,  5,  18 }, {   96,  4,  24 },
+	{   98,  7,  14 }, {  100,  5,  20 }, {  104,  4,  26 },
+	{  108,  6,  18 }, {  110, 11,  10 }, {  112,  4,  28 },
+	{  120,  4,  30 }, {  126,  7,  18 }, {  128,  4,  32 },
+	{  130,  5,  26 }, {  132, 11,  12 }, {  136,  4,  34 },
+	{  140,  5,  28 }, {  144,  4,  36 }, {  150,  5,  30 },
+	{  152,  4,  38 }, {  154, 11,  14 }, {  156,  6,  26 },
+	{  160,  4,  40 }, {  162,  9,  18 }, {  168,  4,  42 },
+	{  170,  5,  34 }, {  176, 11,  16 }, {  180,  5,  36 },
+	{  182,  7,  26 }, {  184,  4,  46 }, {  190,  5,  38 },
+	{  192,  4,  48 }, {  196,  7,  28 }, {  198, 11,  18 },
+	{  198,  9,  22 }, {  200,  4,  50 }, {  204,  6,  34 },
+	{  208,  4,  52 }, {  210,  5,  42 }, {  216,  4,  54 },
+	{  220, 11,  20 }, {  224,  4,  56 }, {  228,  6,  38 },
+	{  230,  5,  46 }, {  232,  4,  58 }, {  234,  9,  26 },
+	{  238,  7,  34 }, {  240,  4,  60 }, {  242, 11,  22 },
+	{  248,  4,  62 }, {  250,  5,  50 }, {  252,  6,  42 },
+	{  256,  4,  64 }, {  260,  5,  52 }, {  264, 11,  24 },
+	{  266,  7,  38 }, {  270,  5,  54 }, {  272,  4,  68 },
+	{  276,  6,  46 }, {  280,  4,  70 }, {  286, 11,  26 },
+	{  288,  4,  72 }, {  290,  5,  58 }, {  294,  7,  42 },
+	{  296,  4,  74 }, {  300,  5,  60 }, {  304,  4,  76 },
+	{  306,  9,  34 }, {  308, 11,  28 }, {  310,  5,  62 },
+	{  312,  4,  78 }, {  320,  4,  80 }, {  322,  7,  46 },
+	{  324,  6,  54 }, {  328,  4,  82 }, {  330, 11,  30 },
+	{  336,  4,  84 }, {  340,  5,  68 }, {  342,  9,  38 },
+	{  344,  4,  86 }, {  348,  6,  58 }, {  350,  5,  70 },
+	{  352, 11,  32 }, {  360,  4,  90 }, {  364,  7,  52 },
+	{  368,  4,  92 }, {  370,  5,  74 }, {  372,  6,  62 },
+	{  374, 11,  34 }, {  376,  4,  94 }, {  378,  7,  54 },
+	{  380,  5,  76 }, {  384,  4,  96 }, {  390,  5,  78 },
+	{  392,  4,  98 }, {  396, 11,  36 }, {  400,  4, 100 },
+	{  406,  7,  58 }, {  408,  4, 102 }, {  410,  5,  82 },
+	{  414,  9,  46 }, {  416,  4, 104 }, {  418, 11,  38 },
+	{  420,  5,  84 }, {  424,  4, 106 }, {  430,  5,  86 },
+	{  432,  4, 108 }, {  434,  7,  62 }, {  440, 11,  40 },
+	{  444,  6,  74 }, {  448,  4, 112 }, {  450,  5,  90 },
+	{  456,  4, 114 }, {  460,  5,  92 }, {  462, 11,  42 },
+	{  464,  4, 116 }, {  468,  6,  78 }, {  470,  5,  94 },
+	{  472,  4, 118 }, {  476,  7,  68 }, {  480,  4, 120 },
+	{  484, 11,  44 }, {  486,  9,  54 }, {  488,  4, 122 },
+	{  490,  5,  98 }, {  492,  6,  82 }, {  496,  4, 124 },
+	{  500,  5, 100 }, {  504,  4, 126 }, {  506, 11,  46 },
+	{  510,  5, 102 }, {  512,  4, 128 }, {  516,  6,  86 },
+	{  518,  7,  74 }, {  520,  5, 104 }, {  522,  9,  58 },
+	{  528, 11,  48 }, {  530,  5, 106 }, {  532,  7,  76 },
+	{  540,  5, 108 }, {  546,  7,  78 }, {  550, 11,  50 },
+	{  552,  6,  92 }, {  558,  9,  62 }, {  560,  5, 112 },
+	{  564,  6,  94 }, {  570,  5, 114 }, {  572, 11,  52 },
+	{  574,  7,  82 }, {  576,  6,  96 }, {  580,  5, 116 },
+	{  588,  6,  98 }, {  590,  5, 118 }, {  594, 11,  54 },
+	{  600,  5, 120 }, {  602,  7,  86 }, {  610,  5, 122 },
+	{  612,  6, 102 }, {  616, 11,  56 }, {  620,  5, 124 },
+	{  624,  6, 104 }, {  630,  5, 126 }, {  636,  6, 106 },
+	{  638, 11,  58 }, {  640,  5, 128 }, {  644,  7,  92 },
+	{  648,  6, 108 }, {  658,  7,  94 }, {  660, 11,  60 },
+	{  666,  9,  74 }, {  672,  6, 112 }, {  682, 11,  62 },
+	{  684,  6, 114 }, {  686,  7,  98 }, {  696,  6, 116 },
+	{  700,  7, 100 }, {  702,  9,  78 }, {  704, 11,  64 },
+	{  708,  6, 118 }, {  714,  7, 102 }, {  720,  6, 120 },
+	{  726, 11,  66 }, {  728,  7, 104 }, {  732,  6, 122 },
+	{  738,  9,  82 }, {  742,  7, 106 }, {  744,  6, 124 },
+	{  748, 11,  68 }, {  756,  6, 126 }, {  768,  6, 128 },
+	{  770, 11,  70 }, {  774,  9,  86 }, {  784,  7, 112 },
+	{  792, 11,  72 }, {  798,  7, 114 }, {  810,  9,  90 },
+	{  812,  7, 116 }, {  814, 11,  74 }, {  826,  7, 118 },
+	{  828,  9,  92 }, {  836, 11,  76 }, {  840,  7, 120 },
+	{  846,  9,  94 }, {  854,  7, 122 }, {  858, 11,  78 },
+	{  864,  9,  96 }, {  868,  7, 124 }, {  880, 11,  80 },
+	{  882,  7, 126 }, {  896,  7, 128 }, {  900,  9, 100 },
+	{  902, 11,  82 }, {  918,  9, 102 }, {  924, 11,  84 },
+	{  936,  9, 104 }, {  946, 11,  86 }, {  954,  9, 106 },
+	{  968, 11,  88 }, {  972,  9, 108 }, {  990, 11,  90 },
+	{ 1008,  9, 112 }, { 1012, 11,  92 }, { 1026,  9, 114 },
+	{ 1034, 11,  94 }, { 1044,  9, 116 }, { 1056, 11,  96 },
+	{ 1062,  9, 118 }, { 1078, 11,  98 }, { 1080,  9, 120 },
+	{ 1098,  9, 122 }, { 1100, 11, 100 }, { 1116,  9, 124 },
+	{ 1122, 11, 102 }, { 1134,  9, 126 }, { 1144, 11, 104 },
+	{ 1152,  9, 128 }, { 1166, 11, 106 }, { 1188, 11, 108 },
+	{ 1210, 11, 110 }, { 1232, 11, 112 }, { 1254, 11, 114 },
+	{ 1276, 11, 116 }, { 1298, 11, 118 }, { 1320, 11, 120 },
+	{ 1342, 11, 122 }, { 1364, 11, 124 }, { 1386, 11, 126 },
+	{ 1408, 11, 128 },
+};
+
+bool cobalt_cpld_set_freq(struct cobalt *cobalt, unsigned f_out)
+{
+	const unsigned f_xtal = 39170000;	/* xtal for si598 */
+	unsigned long long dco;
+	unsigned long long rfreq;
+	unsigned delta = 0xffffffff;
+	unsigned i_best = 0;
+	unsigned i;
+	u8 n1, hsdiv;
+	u8 regs[6];
+	int found = 0;
+	u16 clock_ctrl;
+	int retries = 3;
+
+	for (i = 0; i < ARRAY_SIZE(multipliers); i++) {
+		unsigned mult = multipliers[i].mult;
+		unsigned d;
+
+		dco = (unsigned long long)f_out * mult;
+		if (dco < DCO_MIN || dco > DCO_MAX)
+			continue;
+		d = ((dco << 28) + f_xtal / 2) % f_xtal;
+		if (d < delta) {
+			found = 1;
+			i_best = i;
+			delta = d;
+		}
+	}
+	if (!found)
+		return false;
+	dco = (unsigned long long)f_out * multipliers[i_best].mult;
+	n1 = multipliers[i_best].n1 - 1;
+	hsdiv = multipliers[i_best].hsdiv - 4;
+	rfreq = (dco << 28) / f_xtal;
+
+	clock_ctrl = cpld_read(cobalt, SI570_CLOCK_CTRL);
+	clock_ctrl |= S01755_REG_CLOCK_CTRL_BITMAP_CLKHSMA_FPGA_CTRL;
+	clock_ctrl |= S01755_REG_CLOCK_CTRL_BITMAP_CLKHSMA_EN;
+
+	regs[0] = (hsdiv << 5) | (n1 >> 2);
+	regs[1] = ((n1 & 0x3) << 6) | (rfreq >> 32);
+	regs[2] = (rfreq >> 24) & 0xff;
+	regs[3] = (rfreq >> 16) & 0xff;
+	regs[4] = (rfreq >> 8) & 0xff;
+	regs[5] = rfreq & 0xff;
+
+	/* The sequence of clock_ctrl flags to set is very weird. It looks
+	   like I have to reset it, then set the new frequency and reset it
+	   again. It shouldn't be necessary to do a reset, but if I don't,
+	   then a strange frequency is set (156.412034 MHz, or register values
+	   0x01, 0xc7, 0xfc, 0x7f, 0x53, 0x62).
+	 */
+
+	cobalt_dbg(1, "%u: %02x %02x %02x %02x %02x %02x\n", f_out,
+			regs[0], regs[1], regs[2], regs[3], regs[4], regs[5]);
+	while (retries--) {
+		u8 read_regs[6];
+
+		cpld_write(cobalt, SI570_CLOCK_CTRL,
+			S01755_REG_CLOCK_CTRL_BITMAP_CLKHSMA_EN |
+			S01755_REG_CLOCK_CTRL_BITMAP_CLKHSMA_FPGA_CTRL);
+		usleep_range(10000, 15000);
+		cpld_write(cobalt, SI570_REG7, regs[0]);
+		cpld_write(cobalt, SI570_REG8, regs[1]);
+		cpld_write(cobalt, SI570_REG9, regs[2]);
+		cpld_write(cobalt, SI570_REG10, regs[3]);
+		cpld_write(cobalt, SI570_REG11, regs[4]);
+		cpld_write(cobalt, SI570_REG12, regs[5]);
+		cpld_write(cobalt, SI570_CLOCK_CTRL,
+			S01755_REG_CLOCK_CTRL_BITMAP_CLKHSMA_EN |
+			S01755_REG_CLOCK_CTRL_BITMAP_CLKHSMA_WR_TRIGGER);
+		usleep_range(10000, 15000);
+		cpld_write(cobalt, SI570_CLOCK_CTRL,
+			S01755_REG_CLOCK_CTRL_BITMAP_CLKHSMA_EN |
+			S01755_REG_CLOCK_CTRL_BITMAP_CLKHSMA_FPGA_CTRL);
+		usleep_range(10000, 15000);
+		read_regs[0] = cpld_read(cobalt, SI570_REG7);
+		read_regs[1] = cpld_read(cobalt, SI570_REG8);
+		read_regs[2] = cpld_read(cobalt, SI570_REG9);
+		read_regs[3] = cpld_read(cobalt, SI570_REG10);
+		read_regs[4] = cpld_read(cobalt, SI570_REG11);
+		read_regs[5] = cpld_read(cobalt, SI570_REG12);
+		cpld_write(cobalt, SI570_CLOCK_CTRL,
+			S01755_REG_CLOCK_CTRL_BITMAP_CLKHSMA_EN |
+			S01755_REG_CLOCK_CTRL_BITMAP_CLKHSMA_FPGA_CTRL |
+			S01755_REG_CLOCK_CTRL_BITMAP_CLKHSMA_RST_TRIGGER);
+		usleep_range(10000, 15000);
+		cpld_write(cobalt, SI570_CLOCK_CTRL,
+			S01755_REG_CLOCK_CTRL_BITMAP_CLKHSMA_EN);
+		usleep_range(10000, 15000);
+
+		if (!memcmp(read_regs, regs, sizeof(read_regs)))
+			break;
+		cobalt_dbg(1, "retry: %02x %02x %02x %02x %02x %02x\n",
+			read_regs[0], read_regs[1], read_regs[2],
+			read_regs[3], read_regs[4], read_regs[5]);
+	}
+	if (2 - retries)
+		cobalt_info("Needed %d retries\n", 2 - retries);
+
+	return true;
+}
diff --git a/drivers/media/pci/cobalt/cobalt-cpld.h b/drivers/media/pci/cobalt/cobalt-cpld.h
new file mode 100644
index 0000000..0fc88fd
--- /dev/null
+++ b/drivers/media/pci/cobalt/cobalt-cpld.h
@@ -0,0 +1,29 @@
+/*
+ *  Cobalt CPLD functions
+ *
+ *  Copyright 2012-2015 Cisco Systems, Inc. and/or its affiliates.
+ *  All rights reserved.
+ *
+ *  This program is free software; you may redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; version 2 of the License.
+ *
+ *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ *  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ *  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ *  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ *  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ *  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ *  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ *  SOFTWARE.
+ */
+
+#ifndef COBALT_CPLD_H
+#define COBALT_CPLD_H
+
+#include "cobalt-driver.h"
+
+void cobalt_cpld_status(struct cobalt *cobalt);
+bool cobalt_cpld_set_freq(struct cobalt *cobalt, unsigned freq);
+
+#endif
diff --git a/drivers/media/pci/cobalt/cobalt-driver.c b/drivers/media/pci/cobalt/cobalt-driver.c
new file mode 100644
index 0000000..0f2549a
--- /dev/null
+++ b/drivers/media/pci/cobalt/cobalt-driver.c
@@ -0,0 +1,821 @@
+/*
+ *  cobalt driver initialization and card probing
+ *
+ *  Derived from cx18-driver.c
+ *
+ *  Copyright 2012-2015 Cisco Systems, Inc. and/or its affiliates.
+ *  All rights reserved.
+ *
+ *  This program is free software; you may redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; version 2 of the License.
+ *
+ *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ *  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ *  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ *  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ *  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ *  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ *  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ *  SOFTWARE.
+ */
+
+#include <linux/delay.h>
+#include <media/adv7604.h>
+#include <media/adv7842.h>
+#include <media/adv7511.h>
+#include <media/v4l2-event.h>
+#include <media/v4l2-ctrls.h>
+
+#include "cobalt-driver.h"
+#include "cobalt-irq.h"
+#include "cobalt-i2c.h"
+#include "cobalt-v4l2.h"
+#include "cobalt-flash.h"
+#include "cobalt-alsa.h"
+#include "cobalt-omnitek.h"
+
+/* add your revision and whatnot here */
+static struct pci_device_id cobalt_pci_tbl[] = {
+	{PCI_VENDOR_ID_CISCO, PCI_DEVICE_ID_COBALT,
+	 PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{0,}
+};
+
+MODULE_DEVICE_TABLE(pci, cobalt_pci_tbl);
+
+static atomic_t cobalt_instance = ATOMIC_INIT(0);
+
+int cobalt_debug;
+module_param_named(debug, cobalt_debug, int, 0644);
+MODULE_PARM_DESC(debug, "Debug level. Default: 0\n");
+
+int cobalt_ignore_err;
+module_param_named(ignore_err, cobalt_ignore_err, int, 0644);
+MODULE_PARM_DESC(ignore_err,
+	"If set then ignore missing i2c adapters/receivers. Default: 0\n");
+
+MODULE_AUTHOR("Hans Verkuil <hans.verkuil@cisco.com> & Morten Hestnes");
+MODULE_DESCRIPTION("cobalt driver");
+MODULE_LICENSE("GPL");
+
+static u8 edid[256] = {
+	0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x00,
+	0x50, 0x21, 0x9C, 0x27, 0x00, 0x00, 0x00, 0x00,
+	0x19, 0x12, 0x01, 0x03, 0x80, 0x00, 0x00, 0x78,
+	0x0E, 0x00, 0xB2, 0xA0, 0x57, 0x49, 0x9B, 0x26,
+	0x10, 0x48, 0x4F, 0x2F, 0xCF, 0x00, 0x31, 0x59,
+	0x45, 0x59, 0x61, 0x59, 0x81, 0x99, 0x01, 0x01,
+	0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x02, 0x3A,
+	0x80, 0x18, 0x71, 0x38, 0x2D, 0x40, 0x58, 0x2C,
+	0x46, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x1E,
+	0x00, 0x00, 0x00, 0xFD, 0x00, 0x31, 0x55, 0x18,
+	0x5E, 0x11, 0x00, 0x0A, 0x20, 0x20, 0x20, 0x20,
+	0x20, 0x20, 0x00, 0x00, 0x00, 0xFC, 0x00, 0x43,
+	0x20, 0x39, 0x30, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A,
+	0x0A, 0x0A, 0x0A, 0x0A, 0x00, 0x00, 0x00, 0x10,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x68,
+	0x02, 0x03, 0x1a, 0xc0, 0x48, 0xa2, 0x10, 0x04,
+	0x02, 0x01, 0x21, 0x14, 0x13, 0x23, 0x09, 0x07,
+	0x07, 0x65, 0x03, 0x0c, 0x00, 0x10, 0x00, 0xe2,
+	0x00, 0x2a, 0x01, 0x1d, 0x00, 0x80, 0x51, 0xd0,
+	0x1c, 0x20, 0x40, 0x80, 0x35, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x1e, 0x8c, 0x0a, 0xd0, 0x8a,
+	0x20, 0xe0, 0x2d, 0x10, 0x10, 0x3e, 0x96, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x18, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xd7
+};
+
+static void cobalt_set_interrupt(struct cobalt *cobalt, bool enable)
+{
+	if (enable) {
+		unsigned irqs = COBALT_SYSSTAT_VI0_INT1_MSK |
+				COBALT_SYSSTAT_VI1_INT1_MSK |
+				COBALT_SYSSTAT_VI2_INT1_MSK |
+				COBALT_SYSSTAT_VI3_INT1_MSK |
+				COBALT_SYSSTAT_VI0_INT2_MSK |
+				COBALT_SYSSTAT_VI1_INT2_MSK |
+				COBALT_SYSSTAT_VI2_INT2_MSK |
+				COBALT_SYSSTAT_VI3_INT2_MSK |
+				COBALT_SYSSTAT_VI0_LOST_DATA_MSK |
+				COBALT_SYSSTAT_VI1_LOST_DATA_MSK |
+				COBALT_SYSSTAT_VI2_LOST_DATA_MSK |
+				COBALT_SYSSTAT_VI3_LOST_DATA_MSK |
+				COBALT_SYSSTAT_AUD_IN_LOST_DATA_MSK;
+
+		if (cobalt->have_hsma_rx)
+			irqs |= COBALT_SYSSTAT_VIHSMA_INT1_MSK |
+				COBALT_SYSSTAT_VIHSMA_INT2_MSK |
+				COBALT_SYSSTAT_VIHSMA_LOST_DATA_MSK;
+
+		if (cobalt->have_hsma_tx)
+			irqs |= COBALT_SYSSTAT_VOHSMA_INT1_MSK |
+				COBALT_SYSSTAT_VOHSMA_LOST_DATA_MSK |
+				COBALT_SYSSTAT_AUD_OUT_LOST_DATA_MSK;
+		/* Clear any existing interrupts */
+		cobalt_write_bar1(cobalt, COBALT_SYS_STAT_EDGE, 0xffffffff);
+		/* PIO Core interrupt mask register.
+		   Enable ADV7604 INT1 interrupts */
+		cobalt_write_bar1(cobalt, COBALT_SYS_STAT_MASK, irqs);
+	} else {
+		/* Disable all ADV7604 interrupts */
+		cobalt_write_bar1(cobalt, COBALT_SYS_STAT_MASK, 0);
+	}
+}
+
+static unsigned cobalt_get_sd_nr(struct v4l2_subdev *sd)
+{
+	struct cobalt *cobalt = to_cobalt(sd->v4l2_dev);
+	unsigned i;
+
+	for (i = 0; i < COBALT_NUM_NODES; i++)
+		if (sd == cobalt->streams[i].sd)
+			return i;
+	cobalt_err("Invalid adv7604 subdev pointer!\n");
+	return 0;
+}
+
+static void cobalt_notify(struct v4l2_subdev *sd,
+			  unsigned int notification, void *arg)
+{
+	struct cobalt *cobalt = to_cobalt(sd->v4l2_dev);
+	unsigned sd_nr = cobalt_get_sd_nr(sd);
+	struct cobalt_stream *s = &cobalt->streams[sd_nr];
+	bool hotplug = arg ? *((int *)arg) : false;
+
+	if (s->is_output)
+		return;
+
+	switch (notification) {
+	case ADV76XX_HOTPLUG:
+		cobalt_s_bit_sysctrl(cobalt,
+			COBALT_SYS_CTRL_HPD_TO_CONNECTOR_BIT(sd_nr), hotplug);
+		cobalt_dbg(1, "Set hotplug for adv %d to %d\n", sd_nr, hotplug);
+		break;
+	case V4L2_DEVICE_NOTIFY_EVENT:
+		cobalt_dbg(1, "Format changed for adv %d\n", sd_nr);
+		v4l2_event_queue(&s->vdev, arg);
+		break;
+	default:
+		break;
+	}
+}
+
+static int get_payload_size(u16 code)
+{
+	switch (code) {
+	case 0: return 128;
+	case 1: return 256;
+	case 2: return 512;
+	case 3: return 1024;
+	case 4: return 2048;
+	case 5: return 4096;
+	default: return 0;
+	}
+	return 0;
+}
+
+static const char *get_link_speed(u16 stat)
+{
+	switch (stat & PCI_EXP_LNKSTA_CLS) {
+	case 1:	return "2.5 Gbit/s";
+	case 2:	return "5 Gbit/s";
+	case 3:	return "10 Gbit/s";
+	}
+	return "Unknown speed";
+}
+
+void cobalt_pcie_status_show(struct cobalt *cobalt)
+{
+	struct pci_dev *pci_dev = cobalt->pci_dev;
+	struct pci_dev *pci_bus_dev = cobalt->pci_dev->bus->self;
+	int offset;
+	int bus_offset;
+	u32 capa;
+	u16 stat, ctrl;
+
+	offset = pci_find_capability(pci_dev, PCI_CAP_ID_EXP);
+	bus_offset = pci_find_capability(pci_bus_dev, PCI_CAP_ID_EXP);
+
+	/* Device */
+	pci_read_config_dword(pci_dev, offset + PCI_EXP_DEVCAP, &capa);
+	pci_read_config_word(pci_dev, offset + PCI_EXP_DEVCTL, &ctrl);
+	pci_read_config_word(pci_dev, offset + PCI_EXP_DEVSTA, &stat);
+	cobalt_info("PCIe device capability 0x%08x: Max payload %d\n",
+		    capa, get_payload_size(capa & PCI_EXP_DEVCAP_PAYLOAD));
+	cobalt_info("PCIe device control 0x%04x: Max payload %d. Max read request %d\n",
+		    ctrl,
+		    get_payload_size((ctrl & PCI_EXP_DEVCTL_PAYLOAD) >> 5),
+		    get_payload_size((ctrl & PCI_EXP_DEVCTL_READRQ) >> 12));
+	cobalt_info("PCIe device status 0x%04x\n", stat);
+
+	/* Link */
+	pci_read_config_dword(pci_dev, offset + PCI_EXP_LNKCAP, &capa);
+	pci_read_config_word(pci_dev, offset + PCI_EXP_LNKCTL, &ctrl);
+	pci_read_config_word(pci_dev, offset + PCI_EXP_LNKSTA, &stat);
+	cobalt_info("PCIe link capability 0x%08x: %s per lane and %u lanes\n",
+			capa, get_link_speed(capa),
+			(capa & PCI_EXP_LNKCAP_MLW) >> 4);
+	cobalt_info("PCIe link control 0x%04x\n", ctrl);
+	cobalt_info("PCIe link status 0x%04x: %s per lane and %u lanes\n",
+		    stat, get_link_speed(stat),
+		    (stat & PCI_EXP_LNKSTA_NLW) >> 4);
+
+	/* Bus */
+	pci_read_config_dword(pci_bus_dev, bus_offset + PCI_EXP_LNKCAP, &capa);
+	cobalt_info("PCIe bus link capability 0x%08x: %s per lane and %u lanes\n",
+			capa, get_link_speed(capa),
+			(capa & PCI_EXP_LNKCAP_MLW) >> 4);
+
+	/* Slot */
+	pci_read_config_dword(pci_dev, offset + PCI_EXP_SLTCAP, &capa);
+	pci_read_config_word(pci_dev, offset + PCI_EXP_SLTCTL, &ctrl);
+	pci_read_config_word(pci_dev, offset + PCI_EXP_SLTSTA, &stat);
+	cobalt_info("PCIe slot capability 0x%08x\n", capa);
+	cobalt_info("PCIe slot control 0x%04x\n", ctrl);
+	cobalt_info("PCIe slot status 0x%04x\n", stat);
+}
+
+static unsigned pcie_link_get_lanes(struct cobalt *cobalt)
+{
+	struct pci_dev *pci_dev = cobalt->pci_dev;
+	unsigned offset;
+	u16 link;
+
+	offset = pci_find_capability(pci_dev, PCI_CAP_ID_EXP);
+	if (!offset)
+		return 0;
+	pci_read_config_word(pci_dev, offset + PCI_EXP_LNKSTA, &link);
+	return (link & PCI_EXP_LNKSTA_NLW) >> 4;
+}
+
+static unsigned pcie_bus_link_get_lanes(struct cobalt *cobalt)
+{
+	struct pci_dev *pci_dev = cobalt->pci_dev->bus->self;
+	unsigned offset;
+	u32 link;
+
+	offset = pci_find_capability(pci_dev, PCI_CAP_ID_EXP);
+	if (!offset)
+		return 0;
+	pci_read_config_dword(pci_dev, offset + PCI_EXP_LNKCAP, &link);
+	return (link & PCI_EXP_LNKCAP_MLW) >> 4;
+}
+
+static void msi_config_show(struct cobalt *cobalt, struct pci_dev *pci_dev)
+{
+	u16 ctrl, data;
+	u32 adrs_l, adrs_h;
+
+	pci_read_config_word(pci_dev, 0x52, &ctrl);
+	cobalt_info("MSI %s\n", ctrl & 1 ? "enable" : "disable");
+	cobalt_info("MSI multiple message: Capable %u. Enable %u\n",
+		    (1 << ((ctrl >> 1) & 7)), (1 << ((ctrl >> 4) & 7)));
+	if (ctrl & 0x80)
+		cobalt_info("MSI: 64-bit address capable\n");
+	pci_read_config_dword(pci_dev, 0x54, &adrs_l);
+	pci_read_config_dword(pci_dev, 0x58, &adrs_h);
+	pci_read_config_word(pci_dev, 0x5c, &data);
+	if (ctrl & 0x80)
+		cobalt_info("MSI: Address 0x%08x%08x. Data 0x%04x\n",
+				adrs_h, adrs_l, data);
+	else
+		cobalt_info("MSI: Address 0x%08x. Data 0x%04x\n",
+				adrs_l, data);
+}
+
+static void cobalt_pci_iounmap(struct cobalt *cobalt, struct pci_dev *pci_dev)
+{
+	if (cobalt->bar0) {
+		pci_iounmap(pci_dev, cobalt->bar0);
+		cobalt->bar0 = 0;
+	}
+	if (cobalt->bar1) {
+		pci_iounmap(pci_dev, cobalt->bar1);
+		cobalt->bar1 = 0;
+	}
+}
+
+static void cobalt_free_msi(struct cobalt *cobalt, struct pci_dev *pci_dev)
+{
+	free_irq(pci_dev->irq, (void *)cobalt);
+
+	if (cobalt->msi_enabled)
+		pci_disable_msi(pci_dev);
+}
+
+static int cobalt_setup_pci(struct cobalt *cobalt, struct pci_dev *pci_dev,
+			    const struct pci_device_id *pci_id)
+{
+	u32 ctrl;
+	int ret;
+
+	cobalt_dbg(1, "enabling pci device\n");
+
+	ret = pci_enable_device(pci_dev);
+	if (ret) {
+		cobalt_err("can't enable device\n");
+		return ret;
+	}
+	pci_set_master(pci_dev);
+	pci_read_config_byte(pci_dev, PCI_CLASS_REVISION, &cobalt->card_rev);
+	pci_read_config_word(pci_dev, PCI_DEVICE_ID, &cobalt->device_id);
+
+	switch (cobalt->device_id) {
+	case PCI_DEVICE_ID_COBALT:
+		cobalt_info("PCI Express interface from Omnitek\n");
+		break;
+	default:
+		cobalt_info("PCI Express interface provider is unknown!\n");
+		break;
+	}
+
+	if (pcie_link_get_lanes(cobalt) != 8) {
+		cobalt_err("PCI Express link width is not 8 lanes (%d)\n",
+				pcie_link_get_lanes(cobalt));
+		if (pcie_bus_link_get_lanes(cobalt) < 8)
+			cobalt_err("The current slot only supports %d lanes, at least 8 are needed\n",
+					pcie_bus_link_get_lanes(cobalt));
+		else
+			cobalt_err("The card is most likely not seated correctly in the PCIe slot\n");
+		ret = -EIO;
+		goto err_disable;
+	}
+
+	if (pci_set_dma_mask(pci_dev, DMA_BIT_MASK(64))) {
+		ret = pci_set_dma_mask(pci_dev, DMA_BIT_MASK(32));
+		if (ret) {
+			cobalt_err("no suitable DMA available\n");
+			goto err_disable;
+		}
+	}
+
+	ret = pci_request_regions(pci_dev, "cobalt");
+	if (ret) {
+		cobalt_err("error requesting regions\n");
+		goto err_disable;
+	}
+
+	cobalt_pcie_status_show(cobalt);
+
+	cobalt->bar0 = pci_iomap(pci_dev, 0, 0);
+	cobalt->bar1 = pci_iomap(pci_dev, 1, 0);
+	if (cobalt->bar1 == NULL) {
+		cobalt->bar1 = pci_iomap(pci_dev, 2, 0);
+		cobalt_info("64-bit BAR\n");
+	}
+	if (!cobalt->bar0 || !cobalt->bar1) {
+		ret = -EIO;
+		goto err_release;
+	}
+
+	/* Reset the video inputs before enabling any interrupts */
+	ctrl = cobalt_read_bar1(cobalt, COBALT_SYS_CTRL_BASE);
+	cobalt_write_bar1(cobalt, COBALT_SYS_CTRL_BASE, ctrl & ~0xf00);
+
+	/* Disable interrupts to prevent any spurious interrupts
+	   from being generated. */
+	cobalt_set_interrupt(cobalt, false);
+
+	if (pci_enable_msi_range(pci_dev, 1, 1) < 1) {
+		cobalt_err("Could not enable MSI\n");
+		cobalt->msi_enabled = false;
+		ret = -EIO;
+		goto err_release;
+	}
+	msi_config_show(cobalt, pci_dev);
+	cobalt->msi_enabled = true;
+
+	/* Register IRQ */
+	if (request_irq(pci_dev->irq, cobalt_irq_handler, IRQF_SHARED,
+			cobalt->v4l2_dev.name, (void *)cobalt)) {
+		cobalt_err("Failed to register irq %d\n", pci_dev->irq);
+		ret = -EIO;
+		goto err_msi;
+	}
+
+	omni_sg_dma_init(cobalt);
+	return 0;
+
+err_msi:
+	pci_disable_msi(pci_dev);
+
+err_release:
+	cobalt_pci_iounmap(cobalt, pci_dev);
+	pci_release_regions(pci_dev);
+
+err_disable:
+	pci_disable_device(cobalt->pci_dev);
+	return ret;
+}
+
+static int cobalt_hdl_info_get(struct cobalt *cobalt)
+{
+	int i;
+
+	for (i = 0; i < COBALT_HDL_INFO_SIZE; i++)
+		cobalt->hdl_info[i] =
+			ioread8(cobalt->bar1 + COBALT_HDL_INFO_BASE + i);
+	cobalt->hdl_info[COBALT_HDL_INFO_SIZE - 1] = '\0';
+	if (strstr(cobalt->hdl_info, COBALT_HDL_SEARCH_STR))
+		return 0;
+
+	return 1;
+}
+
+static void cobalt_stream_struct_init(struct cobalt *cobalt)
+{
+	int i;
+
+	for (i = 0; i < COBALT_NUM_STREAMS; i++) {
+		struct cobalt_stream *s = &cobalt->streams[i];
+
+		s->cobalt = cobalt;
+		s->flags = 0;
+		s->is_audio = false;
+		s->is_output = false;
+		s->is_dummy = true;
+
+		/* The Memory DMA channels will always get a lower channel
+		 * number than the FIFO DMA. Video input should map to the
+		 * stream 0-3. The other can use stream struct from 4 and
+		 * higher */
+		if (i <= COBALT_HSMA_IN_NODE) {
+			s->dma_channel = i + cobalt->first_fifo_channel;
+			s->video_channel = i;
+		} else if (i >= COBALT_AUDIO_IN_STREAM &&
+			   i <= COBALT_AUDIO_IN_STREAM + 4) {
+			s->dma_channel = 6 + i - COBALT_AUDIO_IN_STREAM;
+			s->is_audio = true;
+			s->video_channel = i - COBALT_AUDIO_IN_STREAM;
+		} else if (i == COBALT_HSMA_OUT_NODE) {
+			s->dma_channel = 11;
+			s->is_output = true;
+			s->video_channel = 5;
+		} else if (i == COBALT_AUDIO_OUT_STREAM) {
+			s->dma_channel = 12;
+			s->is_audio = true;
+			s->is_output = true;
+			s->video_channel = 5;
+		} else {
+			/* FIXME: Memory DMA for debug purpose */
+			s->dma_channel = i - COBALT_NUM_NODES;
+		}
+		cobalt_info("stream #%d -> dma channel #%d <- video channel %d\n",
+			    i, s->dma_channel, s->video_channel);
+	}
+}
+
+static int cobalt_subdevs_init(struct cobalt *cobalt)
+{
+	static struct adv76xx_platform_data adv7604_pdata = {
+		.disable_pwrdnb = 1,
+		.ain_sel = ADV7604_AIN7_8_9_NC_SYNC_3_1,
+		.bus_order = ADV7604_BUS_ORDER_BRG,
+		.blank_data = 1,
+		.op_656_range = 1,
+		.op_format_mode_sel = ADV7604_OP_FORMAT_MODE0,
+		.int1_config = ADV76XX_INT1_CONFIG_ACTIVE_HIGH,
+		.dr_str_data = ADV76XX_DR_STR_HIGH,
+		.dr_str_clk = ADV76XX_DR_STR_HIGH,
+		.dr_str_sync = ADV76XX_DR_STR_HIGH,
+		.hdmi_free_run_mode = 1,
+		.inv_vs_pol = 1,
+		.inv_hs_pol = 1,
+	};
+	static struct i2c_board_info adv7604_info = {
+		.type = "adv7604",
+		.addr = 0x20,
+		.platform_data = &adv7604_pdata,
+	};
+
+	struct cobalt_stream *s = cobalt->streams;
+	int i;
+
+	for (i = 0; i < COBALT_NUM_INPUTS; i++) {
+		struct v4l2_subdev_format sd_fmt = {
+			.pad = ADV7604_PAD_SOURCE,
+			.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+			.format.code = MEDIA_BUS_FMT_YUYV8_1X16,
+		};
+		struct v4l2_subdev_edid cobalt_edid = {
+			.pad = ADV76XX_PAD_HDMI_PORT_A,
+			.start_block = 0,
+			.blocks = 2,
+			.edid = edid,
+		};
+		int err;
+
+		s[i].pad_source = ADV7604_PAD_SOURCE;
+		s[i].i2c_adap = &cobalt->i2c_adap[i];
+		if (s[i].i2c_adap->dev.parent == NULL)
+			continue;
+		cobalt_s_bit_sysctrl(cobalt,
+				COBALT_SYS_CTRL_NRESET_TO_HDMI_BIT(i), 1);
+		s[i].sd = v4l2_i2c_new_subdev_board(&cobalt->v4l2_dev,
+			s[i].i2c_adap, &adv7604_info, NULL);
+		if (!s[i].sd) {
+			if (cobalt_ignore_err)
+				continue;
+			return -ENODEV;
+		}
+		err = v4l2_subdev_call(s[i].sd, video, s_routing,
+				ADV76XX_PAD_HDMI_PORT_A, 0, 0);
+		if (err)
+			return err;
+		err = v4l2_subdev_call(s[i].sd, pad, set_edid,
+				&cobalt_edid);
+		if (err)
+			return err;
+		err = v4l2_subdev_call(s[i].sd, pad, set_fmt, NULL,
+				&sd_fmt);
+		if (err)
+			return err;
+		/* Reset channel video module */
+		cobalt_s_bit_sysctrl(cobalt,
+				COBALT_SYS_CTRL_VIDEO_RX_RESETN_BIT(i), 0);
+		mdelay(2);
+		cobalt_s_bit_sysctrl(cobalt,
+				COBALT_SYS_CTRL_VIDEO_RX_RESETN_BIT(i), 1);
+		mdelay(1);
+		s[i].is_dummy = false;
+		cobalt->streams[i + COBALT_AUDIO_IN_STREAM].is_dummy = false;
+	}
+	return 0;
+}
+
+static int cobalt_subdevs_hsma_init(struct cobalt *cobalt)
+{
+	static struct adv7842_platform_data adv7842_pdata = {
+		.disable_pwrdnb = 1,
+		.ain_sel = ADV7842_AIN1_2_3_NC_SYNC_1_2,
+		.bus_order = ADV7842_BUS_ORDER_RBG,
+		.op_format_mode_sel = ADV7842_OP_FORMAT_MODE0,
+		.blank_data = 1,
+		.op_656_range = 1,
+		.dr_str_data = 3,
+		.dr_str_clk = 3,
+		.dr_str_sync = 3,
+		.mode = ADV7842_MODE_HDMI,
+		.hdmi_free_run_enable = 1,
+		.vid_std_select = ADV7842_HDMI_COMP_VID_STD_HD_1250P,
+		.i2c_sdp_io = 0x4a,
+		.i2c_sdp = 0x48,
+		.i2c_cp = 0x22,
+		.i2c_vdp = 0x24,
+		.i2c_afe = 0x26,
+		.i2c_hdmi = 0x34,
+		.i2c_repeater = 0x32,
+		.i2c_edid = 0x36,
+		.i2c_infoframe = 0x3e,
+		.i2c_cec = 0x40,
+		.i2c_avlink = 0x42,
+	};
+	static struct i2c_board_info adv7842_info = {
+		.type = "adv7842",
+		.addr = 0x20,
+		.platform_data = &adv7842_pdata,
+	};
+	static struct v4l2_subdev_format sd_fmt = {
+		.pad = ADV7842_PAD_SOURCE,
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+		.format.code = MEDIA_BUS_FMT_YUYV8_1X16,
+	};
+	static struct adv7511_platform_data adv7511_pdata = {
+		.i2c_edid = 0x7e >> 1,
+		.i2c_cec = 0x7c >> 1,
+		.cec_clk = 12000000,
+	};
+	static struct i2c_board_info adv7511_info = {
+		.type = "adv7511",
+		.addr = 0x39, /* 0x39 or 0x3d */
+		.platform_data = &adv7511_pdata,
+	};
+	struct v4l2_subdev_edid cobalt_edid = {
+		.pad = ADV7842_EDID_PORT_A,
+		.start_block = 0,
+		.blocks = 2,
+		.edid = edid,
+	};
+	struct cobalt_stream *s = &cobalt->streams[COBALT_HSMA_IN_NODE];
+
+	s->i2c_adap = &cobalt->i2c_adap[COBALT_NUM_ADAPTERS - 1];
+	if (s->i2c_adap->dev.parent == NULL)
+		return 0;
+	cobalt_s_bit_sysctrl(cobalt, COBALT_SYS_CTRL_NRESET_TO_HDMI_BIT(4), 1);
+
+	s->sd = v4l2_i2c_new_subdev_board(&cobalt->v4l2_dev,
+			s->i2c_adap, &adv7842_info, NULL);
+	if (s->sd) {
+		int err = v4l2_subdev_call(s->sd, pad, set_edid, &cobalt_edid);
+
+		if (err)
+			return err;
+		err = v4l2_subdev_call(s->sd, pad, set_fmt, NULL,
+				&sd_fmt);
+		if (err)
+			return err;
+		cobalt->have_hsma_rx = true;
+		s->pad_source = ADV7842_PAD_SOURCE;
+		s->is_dummy = false;
+		cobalt->streams[4 + COBALT_AUDIO_IN_STREAM].is_dummy = false;
+		/* Reset channel video module */
+		cobalt_s_bit_sysctrl(cobalt,
+				COBALT_SYS_CTRL_VIDEO_RX_RESETN_BIT(4), 0);
+		mdelay(2);
+		cobalt_s_bit_sysctrl(cobalt,
+				COBALT_SYS_CTRL_VIDEO_RX_RESETN_BIT(4), 1);
+		mdelay(1);
+		return err;
+	}
+	cobalt_s_bit_sysctrl(cobalt, COBALT_SYS_CTRL_NRESET_TO_HDMI_BIT(4), 0);
+	cobalt_s_bit_sysctrl(cobalt, COBALT_SYS_CTRL_PWRDN0_TO_HSMA_TX_BIT, 0);
+	s++;
+	s->i2c_adap = &cobalt->i2c_adap[COBALT_NUM_ADAPTERS - 1];
+	s->sd = v4l2_i2c_new_subdev_board(&cobalt->v4l2_dev,
+			s->i2c_adap, &adv7511_info, NULL);
+	if (s->sd) {
+		/* A transmitter is hooked up, so we can set this bit */
+		cobalt_s_bit_sysctrl(cobalt,
+				COBALT_SYS_CTRL_HSMA_TX_ENABLE_BIT, 1);
+		cobalt_s_bit_sysctrl(cobalt,
+				COBALT_SYS_CTRL_VIDEO_RX_RESETN_BIT(4), 0);
+		cobalt_s_bit_sysctrl(cobalt,
+				COBALT_SYS_CTRL_VIDEO_TX_RESETN_BIT, 1);
+		cobalt->have_hsma_tx = true;
+		v4l2_subdev_call(s->sd, core, s_power, 1);
+		v4l2_subdev_call(s->sd, video, s_stream, 1);
+		v4l2_subdev_call(s->sd, audio, s_stream, 1);
+		v4l2_ctrl_s_ctrl(v4l2_ctrl_find(s->sd->ctrl_handler,
+				 V4L2_CID_DV_TX_MODE), V4L2_DV_TX_MODE_HDMI);
+		s->is_dummy = false;
+		cobalt->streams[COBALT_AUDIO_OUT_STREAM].is_dummy = false;
+		return 0;
+	}
+	return -ENODEV;
+}
+
+static int cobalt_probe(struct pci_dev *pci_dev,
+				  const struct pci_device_id *pci_id)
+{
+	struct cobalt *cobalt;
+	int retval = 0;
+	int i;
+
+	/* FIXME - module parameter arrays constrain max instances */
+	i = atomic_inc_return(&cobalt_instance) - 1;
+
+	cobalt = kzalloc(sizeof(struct cobalt), GFP_ATOMIC);
+	if (cobalt == NULL)
+		return -ENOMEM;
+	cobalt->pci_dev = pci_dev;
+	cobalt->instance = i;
+
+	cobalt->alloc_ctx = vb2_dma_sg_init_ctx(&pci_dev->dev);
+	if (IS_ERR(cobalt->alloc_ctx)) {
+		kfree(cobalt);
+		return -ENOMEM;
+	}
+
+	retval = v4l2_device_register(&pci_dev->dev, &cobalt->v4l2_dev);
+	if (retval) {
+		pr_err("cobalt: v4l2_device_register of card %d failed\n",
+				cobalt->instance);
+		vb2_dma_sg_cleanup_ctx(cobalt->alloc_ctx);
+		kfree(cobalt);
+		return retval;
+	}
+	snprintf(cobalt->v4l2_dev.name, sizeof(cobalt->v4l2_dev.name),
+		 "cobalt-%d", cobalt->instance);
+	cobalt->v4l2_dev.notify = cobalt_notify;
+	cobalt_info("Initializing card %d\n", cobalt->instance);
+
+	cobalt->irq_work_queues =
+		create_singlethread_workqueue(cobalt->v4l2_dev.name);
+	if (cobalt->irq_work_queues == NULL) {
+		cobalt_err("Could not create workqueue\n");
+		retval = -ENOMEM;
+		goto err;
+	}
+
+	INIT_WORK(&cobalt->irq_work_queue, cobalt_irq_work_handler);
+
+	/* PCI Device Setup */
+	retval = cobalt_setup_pci(cobalt, pci_dev, pci_id);
+	if (retval != 0)
+		goto err_wq;
+
+	/* Show HDL version info */
+	if (cobalt_hdl_info_get(cobalt))
+		cobalt_info("Not able to read the HDL info\n");
+	else
+		cobalt_info("%s", cobalt->hdl_info);
+
+	retval = cobalt_i2c_init(cobalt);
+	if (retval)
+		goto err_pci;
+
+	cobalt_stream_struct_init(cobalt);
+
+	retval = cobalt_subdevs_init(cobalt);
+	if (retval)
+		goto err_i2c;
+
+	if (!(cobalt_read_bar1(cobalt, COBALT_SYS_STAT_BASE) &
+			COBALT_SYSSTAT_HSMA_PRSNTN_MSK)) {
+		retval = cobalt_subdevs_hsma_init(cobalt);
+		if (retval)
+			goto err_i2c;
+	}
+
+	retval = v4l2_device_register_subdev_nodes(&cobalt->v4l2_dev);
+	if (retval)
+		goto err_i2c;
+	retval = cobalt_nodes_register(cobalt);
+	if (retval) {
+		cobalt_err("Error %d registering device nodes\n", retval);
+		goto err_i2c;
+	}
+	cobalt_set_interrupt(cobalt, true);
+	v4l2_device_call_all(&cobalt->v4l2_dev, 0, core,
+					interrupt_service_routine, 0, NULL);
+
+	cobalt_info("Initialized cobalt card\n");
+
+	cobalt_flash_probe(cobalt);
+
+	return 0;
+
+err_i2c:
+	cobalt_i2c_exit(cobalt);
+	cobalt_s_bit_sysctrl(cobalt, COBALT_SYS_CTRL_HSMA_TX_ENABLE_BIT, 0);
+err_pci:
+	cobalt_free_msi(cobalt, pci_dev);
+	cobalt_pci_iounmap(cobalt, pci_dev);
+	pci_release_regions(cobalt->pci_dev);
+	pci_disable_device(cobalt->pci_dev);
+err_wq:
+	destroy_workqueue(cobalt->irq_work_queues);
+err:
+	if (retval == 0)
+		retval = -ENODEV;
+	cobalt_err("error %d on initialization\n", retval);
+
+	v4l2_device_unregister(&cobalt->v4l2_dev);
+	vb2_dma_sg_cleanup_ctx(cobalt->alloc_ctx);
+	kfree(cobalt);
+	return retval;
+}
+
+static void cobalt_remove(struct pci_dev *pci_dev)
+{
+	struct v4l2_device *v4l2_dev = pci_get_drvdata(pci_dev);
+	struct cobalt *cobalt = to_cobalt(v4l2_dev);
+	int i;
+
+	cobalt_flash_remove(cobalt);
+	cobalt_set_interrupt(cobalt, false);
+	flush_workqueue(cobalt->irq_work_queues);
+	cobalt_nodes_unregister(cobalt);
+	for (i = 0; i < COBALT_NUM_ADAPTERS; i++) {
+		struct v4l2_subdev *sd = cobalt->streams[i].sd;
+		struct i2c_client *client;
+
+		if (sd == NULL)
+			continue;
+		client = v4l2_get_subdevdata(sd);
+		v4l2_device_unregister_subdev(sd);
+		i2c_unregister_device(client);
+	}
+	cobalt_i2c_exit(cobalt);
+	cobalt_free_msi(cobalt, pci_dev);
+	cobalt_s_bit_sysctrl(cobalt, COBALT_SYS_CTRL_HSMA_TX_ENABLE_BIT, 0);
+	cobalt_pci_iounmap(cobalt, pci_dev);
+	pci_release_regions(cobalt->pci_dev);
+	pci_disable_device(cobalt->pci_dev);
+	destroy_workqueue(cobalt->irq_work_queues);
+
+	cobalt_info("removed cobalt card\n");
+
+	v4l2_device_unregister(v4l2_dev);
+	vb2_dma_sg_cleanup_ctx(cobalt->alloc_ctx);
+	kfree(cobalt);
+}
+
+/* define a pci_driver for card detection */
+static struct pci_driver cobalt_pci_driver = {
+	.name =     "cobalt",
+	.id_table = cobalt_pci_tbl,
+	.probe =    cobalt_probe,
+	.remove =   cobalt_remove,
+};
+
+module_pci_driver(cobalt_pci_driver);
diff --git a/drivers/media/pci/cobalt/cobalt-driver.h b/drivers/media/pci/cobalt/cobalt-driver.h
new file mode 100644
index 0000000..082bf82
--- /dev/null
+++ b/drivers/media/pci/cobalt/cobalt-driver.h
@@ -0,0 +1,377 @@
+/*
+ *  cobalt driver internal defines and structures
+ *
+ *  Derived from cx18-driver.h
+ *
+ *  Copyright 2012-2015 Cisco Systems, Inc. and/or its affiliates.
+ *  All rights reserved.
+ *
+ *  This program is free software; you may redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; version 2 of the License.
+ *
+ *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ *  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ *  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ *  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ *  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ *  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ *  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ *  SOFTWARE.
+ */
+
+#ifndef COBALT_DRIVER_H
+#define COBALT_DRIVER_H
+
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/spinlock.h>
+#include <linux/i2c.h>
+#include <linux/list.h>
+#include <linux/workqueue.h>
+#include <linux/mutex.h>
+
+#include <media/v4l2-common.h>
+#include <media/v4l2-ioctl.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-fh.h>
+#include <media/videobuf2-dma-sg.h>
+
+#include "m00233_video_measure_memmap_package.h"
+#include "m00235_fdma_packer_memmap_package.h"
+#include "m00389_cvi_memmap_package.h"
+#include "m00460_evcnt_memmap_package.h"
+#include "m00473_freewheel_memmap_package.h"
+#include "m00479_clk_loss_detector_memmap_package.h"
+#include "m00514_syncgen_flow_evcnt_memmap_package.h"
+
+/* System device ID */
+#define PCI_DEVICE_ID_COBALT	0x2732
+
+/* Number of cobalt device nodes. */
+#define COBALT_NUM_INPUTS	4
+#define COBALT_NUM_NODES	6
+
+/* Number of cobalt device streams. */
+#define COBALT_NUM_STREAMS	12
+
+#define COBALT_HSMA_IN_NODE	4
+#define COBALT_HSMA_OUT_NODE	5
+
+/* Cobalt audio streams */
+#define COBALT_AUDIO_IN_STREAM	6
+#define COBALT_AUDIO_OUT_STREAM 11
+
+/* DMA stuff */
+#define DMA_CHANNELS_MAX	16
+
+/* i2c stuff */
+#define I2C_CLIENTS_MAX		16
+#define COBALT_NUM_ADAPTERS	5
+
+#define COBALT_CLK		50000000
+
+/* System status register */
+#define COBALT_SYSSTAT_DIP0_MSK			(1 << 0)
+#define COBALT_SYSSTAT_DIP1_MSK			(1 << 1)
+#define COBALT_SYSSTAT_HSMA_PRSNTN_MSK		(1 << 2)
+#define COBALT_SYSSTAT_FLASH_RDYBSYN_MSK	(1 << 3)
+#define COBALT_SYSSTAT_VI0_5V_MSK		(1 << 4)
+#define COBALT_SYSSTAT_VI0_INT1_MSK		(1 << 5)
+#define COBALT_SYSSTAT_VI0_INT2_MSK		(1 << 6)
+#define COBALT_SYSSTAT_VI0_LOST_DATA_MSK	(1 << 7)
+#define COBALT_SYSSTAT_VI1_5V_MSK		(1 << 8)
+#define COBALT_SYSSTAT_VI1_INT1_MSK		(1 << 9)
+#define COBALT_SYSSTAT_VI1_INT2_MSK		(1 << 10)
+#define COBALT_SYSSTAT_VI1_LOST_DATA_MSK	(1 << 11)
+#define COBALT_SYSSTAT_VI2_5V_MSK		(1 << 12)
+#define COBALT_SYSSTAT_VI2_INT1_MSK		(1 << 13)
+#define COBALT_SYSSTAT_VI2_INT2_MSK		(1 << 14)
+#define COBALT_SYSSTAT_VI2_LOST_DATA_MSK	(1 << 15)
+#define COBALT_SYSSTAT_VI3_5V_MSK		(1 << 16)
+#define COBALT_SYSSTAT_VI3_INT1_MSK		(1 << 17)
+#define COBALT_SYSSTAT_VI3_INT2_MSK		(1 << 18)
+#define COBALT_SYSSTAT_VI3_LOST_DATA_MSK	(1 << 19)
+#define COBALT_SYSSTAT_VIHSMA_5V_MSK		(1 << 20)
+#define COBALT_SYSSTAT_VIHSMA_INT1_MSK		(1 << 21)
+#define COBALT_SYSSTAT_VIHSMA_INT2_MSK		(1 << 22)
+#define COBALT_SYSSTAT_VIHSMA_LOST_DATA_MSK	(1 << 23)
+#define COBALT_SYSSTAT_VOHSMA_INT1_MSK		(1 << 25)
+#define COBALT_SYSSTAT_VOHSMA_PLL_LOCKED_MSK	(1 << 26)
+#define COBALT_SYSSTAT_VOHSMA_LOST_DATA_MSK	(1 << 27)
+#define COBALT_SYSSTAT_AUD_PLL_LOCKED_MSK	(1 << 28)
+#define COBALT_SYSSTAT_AUD_IN_LOST_DATA_MSK	(1 << 29)
+#define COBALT_SYSSTAT_AUD_OUT_LOST_DATA_MSK	(1 << 30)
+#define COBALT_SYSSTAT_PCIE_SMBCLK_MSK		(1 << 31)
+
+/* Cobalt memory map */
+#define COBALT_I2C_0_BASE			0x0
+#define COBALT_I2C_1_BASE			0x080
+#define COBALT_I2C_2_BASE			0x100
+#define COBALT_I2C_3_BASE			0x180
+#define COBALT_I2C_HSMA_BASE			0x200
+
+#define COBALT_SYS_CTRL_BASE			0x400
+#define COBALT_SYS_CTRL_HSMA_TX_ENABLE_BIT	1
+#define COBALT_SYS_CTRL_VIDEO_RX_RESETN_BIT(n)	(4 + 4 * (n))
+#define COBALT_SYS_CTRL_NRESET_TO_HDMI_BIT(n)	(5 + 4 * (n))
+#define COBALT_SYS_CTRL_HPD_TO_CONNECTOR_BIT(n)	(6 + 4 * (n))
+#define COBALT_SYS_CTRL_AUDIO_IPP_RESETN_BIT(n)	(7 + 4 * (n))
+#define COBALT_SYS_CTRL_PWRDN0_TO_HSMA_TX_BIT	24
+#define COBALT_SYS_CTRL_VIDEO_TX_RESETN_BIT	25
+#define COBALT_SYS_CTRL_AUDIO_OPP_RESETN_BIT	27
+
+#define COBALT_SYS_STAT_BASE			0x500
+#define COBALT_SYS_STAT_MASK			(COBALT_SYS_STAT_BASE + 0x08)
+#define COBALT_SYS_STAT_EDGE			(COBALT_SYS_STAT_BASE + 0x0c)
+
+#define COBALT_HDL_INFO_BASE			0x4800
+#define COBALT_HDL_INFO_SIZE			0x200
+
+#define COBALT_VID_BASE				0x10000
+#define COBALT_VID_SIZE				0x1000
+
+#define COBALT_CVI(cobalt, c) \
+	(cobalt->bar1 + COBALT_VID_BASE + (c) * COBALT_VID_SIZE)
+#define COBALT_CVI_VMR(cobalt, c) \
+	(cobalt->bar1 + COBALT_VID_BASE + (c) * COBALT_VID_SIZE + 0x100)
+#define COBALT_CVI_EVCNT(cobalt, c) \
+	(cobalt->bar1 + COBALT_VID_BASE + (c) * COBALT_VID_SIZE + 0x200)
+#define COBALT_CVI_FREEWHEEL(cobalt, c) \
+	(cobalt->bar1 + COBALT_VID_BASE + (c) * COBALT_VID_SIZE + 0x300)
+#define COBALT_CVI_CLK_LOSS(cobalt, c) \
+	(cobalt->bar1 + COBALT_VID_BASE + (c) * COBALT_VID_SIZE + 0x400)
+#define COBALT_CVI_PACKER(cobalt, c) \
+	(cobalt->bar1 + COBALT_VID_BASE + (c) * COBALT_VID_SIZE + 0x500)
+
+#define COBALT_TX_BASE(cobalt) (cobalt->bar1 + COBALT_VID_BASE + 0x5000)
+
+#define DMA_INTERRUPT_STATUS_REG		0x08
+
+#define COBALT_HDL_SEARCH_STR			"** HDL version info **"
+
+/* Cobalt CPU bus interface */
+#define COBALT_BUS_BAR1_BASE			0x600
+#define COBALT_BUS_SRAM_BASE			0x0
+#define COBALT_BUS_CPLD_BASE			0x00600000
+#define COBALT_BUS_FLASH_BASE			0x08000000
+
+/* FDMA to PCIe packing */
+#define COBALT_BYTES_PER_PIXEL_YUYV		2
+#define COBALT_BYTES_PER_PIXEL_RGB24		3
+#define COBALT_BYTES_PER_PIXEL_RGB32		4
+
+/* debugging */
+extern int cobalt_debug;
+extern int cobalt_ignore_err;
+
+#define cobalt_err(fmt, arg...)  v4l2_err(&cobalt->v4l2_dev, fmt, ## arg)
+#define cobalt_warn(fmt, arg...) v4l2_warn(&cobalt->v4l2_dev, fmt, ## arg)
+#define cobalt_info(fmt, arg...) v4l2_info(&cobalt->v4l2_dev, fmt, ## arg)
+#define cobalt_dbg(level, fmt, arg...) \
+	v4l2_dbg(level, cobalt_debug, &cobalt->v4l2_dev, fmt, ## arg)
+
+struct cobalt;
+struct cobalt_i2c_regs;
+
+/* Per I2C bus private algo callback data */
+struct cobalt_i2c_data {
+	struct cobalt *cobalt;
+	volatile struct cobalt_i2c_regs __iomem *regs;
+};
+
+struct pci_consistent_buffer {
+	void *virt;
+	dma_addr_t bus;
+	size_t bytes;
+};
+
+struct sg_dma_desc_info {
+	void *virt;
+	dma_addr_t bus;
+	unsigned size;
+	void *last_desc_virt;
+	struct device *dev;
+};
+
+#define COBALT_MAX_WIDTH			1920
+#define COBALT_MAX_HEIGHT			1200
+#define COBALT_MAX_BPP				3
+#define COBALT_MAX_FRAMESZ \
+	(COBALT_MAX_WIDTH * COBALT_MAX_HEIGHT * COBALT_MAX_BPP)
+
+#define NR_BUFS					VIDEO_MAX_FRAME
+
+#define COBALT_STREAM_FL_DMA_IRQ		0
+#define COBALT_STREAM_FL_ADV_IRQ		1
+
+struct cobalt_buffer {
+	struct vb2_buffer vb;
+	struct list_head list;
+};
+
+static inline struct cobalt_buffer *to_cobalt_buffer(struct vb2_buffer *vb2)
+{
+	return container_of(vb2, struct cobalt_buffer, vb);
+}
+
+struct cobalt_stream {
+	struct video_device vdev;
+	struct vb2_queue q;
+	struct list_head bufs;
+	struct i2c_adapter *i2c_adap;
+	struct v4l2_subdev *sd;
+	struct mutex lock;
+	spinlock_t irqlock;
+	struct v4l2_dv_timings timings;
+	u32 input;
+	u32 pad_source;
+	u32 width, height, bpp;
+	u32 stride;
+	u32 pixfmt;
+	u32 sequence;
+	u32 colorspace;
+	u32 ycbcr_enc;
+	u32 quantization;
+
+	u8 dma_channel;
+	int video_channel;
+	struct sg_dma_desc_info dma_desc_info[NR_BUFS];
+	unsigned long flags;
+	bool unstable_frame;
+	bool enable_cvi;
+	bool enable_freewheel;
+	unsigned skip_first_frames;
+	bool is_output;
+	bool is_audio;
+	bool is_dummy;
+
+	struct cobalt *cobalt;
+	struct snd_cobalt_card *alsa;
+};
+
+struct snd_cobalt_card;
+
+/* Struct to hold info about cobalt cards */
+struct cobalt {
+	int instance;
+	struct pci_dev *pci_dev;
+	struct v4l2_device v4l2_dev;
+	void *alloc_ctx;
+
+	void __iomem *bar0, *bar1;
+
+	u8 card_rev;
+	u16 device_id;
+
+	/* device nodes */
+	struct cobalt_stream streams[DMA_CHANNELS_MAX];
+	struct i2c_adapter i2c_adap[COBALT_NUM_ADAPTERS];
+	struct cobalt_i2c_data i2c_data[COBALT_NUM_ADAPTERS];
+	bool have_hsma_rx;
+	bool have_hsma_tx;
+
+	/* irq */
+	struct workqueue_struct *irq_work_queues;
+	struct work_struct irq_work_queue;              /* work entry */
+	/* irq counters */
+	u32 irq_adv1;
+	u32 irq_adv2;
+	u32 irq_advout;
+	u32 irq_dma_tot;
+	u32 irq_dma[COBALT_NUM_STREAMS];
+	u32 irq_none;
+	u32 irq_full_fifo;
+
+	bool msi_enabled;
+
+	/* omnitek dma */
+	int dma_channels;
+	int first_fifo_channel;
+	bool pci_32_bit;
+
+	char hdl_info[COBALT_HDL_INFO_SIZE];
+
+	/* NOR flash */
+	struct mtd_info *mtd;
+};
+
+static inline struct cobalt *to_cobalt(struct v4l2_device *v4l2_dev)
+{
+	return container_of(v4l2_dev, struct cobalt, v4l2_dev);
+}
+
+static inline void cobalt_write_bar0(struct cobalt *cobalt, u32 reg, u32 val)
+{
+	iowrite32(val, cobalt->bar0 + reg);
+}
+
+static inline u32 cobalt_read_bar0(struct cobalt *cobalt, u32 reg)
+{
+	return ioread32(cobalt->bar0 + reg);
+}
+
+static inline void cobalt_write_bar1(struct cobalt *cobalt, u32 reg, u32 val)
+{
+	iowrite32(val, cobalt->bar1 + reg);
+}
+
+static inline u32 cobalt_read_bar1(struct cobalt *cobalt, u32 reg)
+{
+	return ioread32(cobalt->bar1 + reg);
+}
+
+static inline u32 cobalt_g_sysctrl(struct cobalt *cobalt)
+{
+	return cobalt_read_bar1(cobalt, COBALT_SYS_CTRL_BASE);
+}
+
+static inline void cobalt_s_bit_sysctrl(struct cobalt *cobalt,
+					int bit, int val)
+{
+	u32 ctrl = cobalt_read_bar1(cobalt, COBALT_SYS_CTRL_BASE);
+
+	cobalt_write_bar1(cobalt, COBALT_SYS_CTRL_BASE,
+			(ctrl & ~(1UL << bit)) | (val << bit));
+}
+
+static inline u32 cobalt_g_sysstat(struct cobalt *cobalt)
+{
+	return cobalt_read_bar1(cobalt, COBALT_SYS_STAT_BASE);
+}
+
+#define ADRS_REG (cobalt->bar1 + COBALT_BUS_BAR1_BASE + 0)
+#define LOWER_DATA (cobalt->bar1 + COBALT_BUS_BAR1_BASE + 4)
+#define UPPER_DATA (cobalt->bar1 + COBALT_BUS_BAR1_BASE + 6)
+
+static inline u32 cobalt_bus_read32(struct cobalt *cobalt, u32 bus_adrs)
+{
+	iowrite32(bus_adrs, ADRS_REG);
+	return ioread32(LOWER_DATA);
+}
+
+static inline void cobalt_bus_write16(struct cobalt *cobalt,
+				      u32 bus_adrs, u16 data)
+{
+	iowrite32(bus_adrs, ADRS_REG);
+	if (bus_adrs & 2)
+		iowrite16(data, UPPER_DATA);
+	else
+		iowrite16(data, LOWER_DATA);
+}
+
+static inline void cobalt_bus_write32(struct cobalt *cobalt,
+				      u32 bus_adrs, u16 data)
+{
+	iowrite32(bus_adrs, ADRS_REG);
+	if (bus_adrs & 2)
+		iowrite32(data, UPPER_DATA);
+	else
+		iowrite32(data, LOWER_DATA);
+}
+
+/*==============Prototypes==================*/
+
+void cobalt_pcie_status_show(struct cobalt *cobalt);
+
+#endif
diff --git a/drivers/media/pci/cobalt/cobalt-flash.c b/drivers/media/pci/cobalt/cobalt-flash.c
new file mode 100644
index 0000000..129f48f
--- /dev/null
+++ b/drivers/media/pci/cobalt/cobalt-flash.c
@@ -0,0 +1,132 @@
+/*
+ *  Cobalt NOR flash functions
+ *
+ *  Copyright 2012-2015 Cisco Systems, Inc. and/or its affiliates.
+ *  All rights reserved.
+ *
+ *  This program is free software; you may redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; version 2 of the License.
+ *
+ *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ *  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ *  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ *  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ *  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ *  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ *  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ *  SOFTWARE.
+ */
+
+#include <linux/mtd/mtd.h>
+#include <linux/mtd/map.h>
+#include <linux/mtd/cfi.h>
+#include <linux/time.h>
+
+#include "cobalt-driver.h"
+
+#define ADRS(offset) (COBALT_BUS_FLASH_BASE + offset)
+
+static struct map_info cobalt_flash_map = {
+	.name =		"cobalt-flash",
+	.bankwidth =	2,         /* 16 bits */
+	.size =		0x4000000, /* 64MB */
+	.phys =		0,         /* offset  */
+};
+
+static map_word flash_read16(struct map_info *map, unsigned long offset)
+{
+	struct cobalt *cobalt = map->virt;
+	map_word r;
+
+	r.x[0] = cobalt_bus_read32(cobalt, ADRS(offset));
+	if (offset & 0x2)
+		r.x[0] >>= 16;
+	else
+		r.x[0] &= 0x0000ffff;
+
+	return r;
+}
+
+static void flash_write16(struct map_info *map, const map_word datum,
+			  unsigned long offset)
+{
+	struct cobalt *cobalt = map->virt;
+	u16 data = (u16)datum.x[0];
+
+	cobalt_bus_write16(cobalt, ADRS(offset), data);
+}
+
+static void flash_copy_from(struct map_info *map, void *to,
+			    unsigned long from, ssize_t len)
+{
+	struct cobalt *cobalt = map->virt;
+	u32 src = from;
+	u8 *dest = to;
+	u32 data;
+
+	while (len) {
+		data = cobalt_bus_read32(cobalt, ADRS(src));
+		do {
+			*dest = data >> (8 * (src & 3));
+			src++;
+			dest++;
+			len--;
+		} while (len && (src % 4));
+	}
+}
+
+static void flash_copy_to(struct map_info *map, unsigned long to,
+			  const void *from, ssize_t len)
+{
+	struct cobalt *cobalt = map->virt;
+	const u8 *src = from;
+	u32 dest = to;
+
+	cobalt_info("%s: offset 0x%x: length %zu\n", __func__, dest, len);
+	while (len) {
+		u16 data = 0xffff;
+
+		do {
+			data = *src << (8 * (dest & 1));
+			src++;
+			dest++;
+			len--;
+		} while (len && (dest % 2));
+
+		cobalt_bus_write16(cobalt, ADRS(dest - 2), data);
+	}
+}
+
+int cobalt_flash_probe(struct cobalt *cobalt)
+{
+	struct map_info *map = &cobalt_flash_map;
+	struct mtd_info *mtd;
+
+	BUG_ON(!map_bankwidth_supported(map->bankwidth));
+	map->virt = cobalt;
+	map->read = flash_read16;
+	map->write = flash_write16;
+	map->copy_from = flash_copy_from;
+	map->copy_to = flash_copy_to;
+
+	mtd = do_map_probe("cfi_probe", map);
+	cobalt->mtd = mtd;
+	if (!mtd) {
+		cobalt_err("Probe CFI flash failed!\n");
+		return -1;
+	}
+
+	mtd->owner = THIS_MODULE;
+	mtd->dev.parent = &cobalt->pci_dev->dev;
+	mtd_device_register(mtd, NULL, 0);
+	return 0;
+}
+
+void cobalt_flash_remove(struct cobalt *cobalt)
+{
+	if (cobalt->mtd) {
+		mtd_device_unregister(cobalt->mtd);
+		map_destroy(cobalt->mtd);
+	}
+}
diff --git a/drivers/media/pci/cobalt/cobalt-flash.h b/drivers/media/pci/cobalt/cobalt-flash.h
new file mode 100644
index 0000000..8077dae
--- /dev/null
+++ b/drivers/media/pci/cobalt/cobalt-flash.h
@@ -0,0 +1,29 @@
+/*
+ *  Cobalt NOR flash functions
+ *
+ *  Copyright 2012-2015 Cisco Systems, Inc. and/or its affiliates.
+ *  All rights reserved.
+ *
+ *  This program is free software; you may redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; version 2 of the License.
+ *
+ *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ *  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ *  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ *  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ *  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ *  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ *  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ *  SOFTWARE.
+ */
+
+#ifndef COBALT_FLASH_H
+#define COBALT_FLASH_H
+
+#include "cobalt-driver.h"
+
+int cobalt_flash_probe(struct cobalt *cobalt);
+void cobalt_flash_remove(struct cobalt *cobalt);
+
+#endif
diff --git a/drivers/media/pci/cobalt/cobalt-i2c.c b/drivers/media/pci/cobalt/cobalt-i2c.c
new file mode 100644
index 0000000..57b330f
--- /dev/null
+++ b/drivers/media/pci/cobalt/cobalt-i2c.c
@@ -0,0 +1,396 @@
+/*
+ *  cobalt I2C functions
+ *
+ *  Derived from cx18-i2c.c
+ *
+ *  Copyright 2012-2015 Cisco Systems, Inc. and/or its affiliates.
+ *  All rights reserved.
+ *
+ *  This program is free software; you may redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; version 2 of the License.
+ *
+ *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ *  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ *  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ *  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ *  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ *  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ *  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ *  SOFTWARE.
+ */
+
+#include "cobalt-driver.h"
+#include "cobalt-i2c.h"
+
+struct cobalt_i2c_regs {
+	/* Clock prescaler register lo-byte */
+	u8 prerlo;
+	u8 dummy0[3];
+	/* Clock prescaler register high-byte */
+	u8 prerhi;
+	u8 dummy1[3];
+	/* Control register */
+	u8 ctr;
+	u8 dummy2[3];
+	/* Transmit/Receive register */
+	u8 txr_rxr;
+	u8 dummy3[3];
+	/* Command and Status register */
+	u8 cr_sr;
+	u8 dummy4[3];
+};
+
+/* CTR[7:0] - Control register */
+
+/* I2C Core enable bit */
+#define M00018_CTR_BITMAP_EN_MSK	(1 << 7)
+
+/* I2C Core interrupt enable bit */
+#define M00018_CTR_BITMAP_IEN_MSK	(1 << 6)
+
+/* CR[7:0] - Command register */
+
+/* I2C start condition */
+#define M00018_CR_BITMAP_STA_MSK	(1 << 7)
+
+/* I2C stop condition */
+#define M00018_CR_BITMAP_STO_MSK	(1 << 6)
+
+/* I2C read from slave */
+#define M00018_CR_BITMAP_RD_MSK		(1 << 5)
+
+/* I2C write to slave */
+#define M00018_CR_BITMAP_WR_MSK		(1 << 4)
+
+/* I2C ack */
+#define M00018_CR_BITMAP_ACK_MSK	(1 << 3)
+
+/* I2C Interrupt ack */
+#define M00018_CR_BITMAP_IACK_MSK	(1 << 0)
+
+/* SR[7:0] - Status register */
+
+/* Receive acknowledge from slave */
+#define M00018_SR_BITMAP_RXACK_MSK	(1 << 7)
+
+/* Busy, I2C bus busy (as defined by start / stop bits) */
+#define M00018_SR_BITMAP_BUSY_MSK	(1 << 6)
+
+/* Arbitration lost - core lost arbitration */
+#define M00018_SR_BITMAP_AL_MSK		(1 << 5)
+
+/* Transfer in progress */
+#define M00018_SR_BITMAP_TIP_MSK	(1 << 1)
+
+/* Interrupt flag */
+#define M00018_SR_BITMAP_IF_MSK		(1 << 0)
+
+/* Frequency, in Hz */
+#define I2C_FREQUENCY			400000
+#define ALT_CPU_FREQ			83333333
+
+static volatile struct cobalt_i2c_regs __iomem *
+cobalt_i2c_regs(struct cobalt *cobalt, unsigned idx)
+{
+	switch (idx) {
+	case 0:
+	default:
+		return (volatile struct cobalt_i2c_regs __iomem *)
+			(cobalt->bar1 + COBALT_I2C_0_BASE);
+	case 1:
+		return (volatile struct cobalt_i2c_regs __iomem *)
+			(cobalt->bar1 + COBALT_I2C_1_BASE);
+	case 2:
+		return (volatile struct cobalt_i2c_regs __iomem *)
+			(cobalt->bar1 + COBALT_I2C_2_BASE);
+	case 3:
+		return (volatile struct cobalt_i2c_regs __iomem *)
+			(cobalt->bar1 + COBALT_I2C_3_BASE);
+	case 4:
+		return (volatile struct cobalt_i2c_regs __iomem *)
+			(cobalt->bar1 + COBALT_I2C_HSMA_BASE);
+	}
+}
+
+/* Do low-level i2c byte transfer.
+ * Returns -1 in case of an error or 0 otherwise.
+ */
+static int cobalt_tx_bytes(volatile struct cobalt_i2c_regs __iomem *regs,
+		struct i2c_adapter *adap, bool start, bool stop,
+		u8 *data, u16 len)
+{
+	unsigned long start_time;
+	int status;
+	int cmd;
+	int i;
+
+	for (i = 0; i < len; i++) {
+		/* Setup data */
+		regs->txr_rxr = data[i];
+
+		/* Setup command */
+		if (i == 0 && start != 0) {
+			/* Write + Start */
+			cmd = M00018_CR_BITMAP_WR_MSK |
+			      M00018_CR_BITMAP_STA_MSK;
+		} else if (i == len - 1 && stop != 0) {
+			/* Write + Stop */
+			cmd = M00018_CR_BITMAP_WR_MSK |
+			      M00018_CR_BITMAP_STO_MSK;
+		} else {
+			/* Write only */
+			cmd = M00018_CR_BITMAP_WR_MSK;
+		}
+
+		/* Execute command */
+		regs->cr_sr = cmd;
+
+		/* Wait for transfer to complete (TIP = 0) */
+		start_time = jiffies;
+		status = regs->cr_sr;
+		while (status & M00018_SR_BITMAP_TIP_MSK) {
+			if (time_after(jiffies, start_time + adap->timeout))
+				return -ETIMEDOUT;
+			cond_resched();
+			status = regs->cr_sr;
+		}
+
+		/* Verify ACK */
+		if (status & M00018_SR_BITMAP_RXACK_MSK) {
+			/* NO ACK! */
+			return -EIO;
+		}
+
+		/* Verify arbitration */
+		if (status & M00018_SR_BITMAP_AL_MSK) {
+			/* Arbitration lost! */
+			return -EIO;
+		}
+	}
+	return 0;
+}
+
+/* Do low-level i2c byte read.
+ * Returns -1 in case of an error or 0 otherwise.
+ */
+static int cobalt_rx_bytes(volatile struct cobalt_i2c_regs __iomem *regs,
+		struct i2c_adapter *adap, bool start, bool stop,
+		u8 *data, u16 len)
+{
+	unsigned long start_time;
+	int status;
+	int cmd;
+	int i;
+
+	for (i = 0; i < len; i++) {
+		/* Setup command */
+		if (i == 0 && start != 0) {
+			/* Read + Start */
+			cmd = M00018_CR_BITMAP_RD_MSK |
+			      M00018_CR_BITMAP_STA_MSK;
+		} else if (i == len - 1 && stop != 0) {
+			/* Read + Stop */
+			cmd = M00018_CR_BITMAP_RD_MSK |
+			      M00018_CR_BITMAP_STO_MSK;
+		} else {
+			/* Read only */
+			cmd = M00018_CR_BITMAP_RD_MSK;
+		}
+
+		/* Last byte to read, no ACK */
+		if (i == len - 1)
+			cmd |= M00018_CR_BITMAP_ACK_MSK;
+
+		/* Execute command */
+		regs->cr_sr = cmd;
+
+		/* Wait for transfer to complete (TIP = 0) */
+		start_time = jiffies;
+		status = regs->cr_sr;
+		while (status & M00018_SR_BITMAP_TIP_MSK) {
+			if (time_after(jiffies, start_time + adap->timeout))
+				return -ETIMEDOUT;
+			cond_resched();
+			status = regs->cr_sr;
+		}
+
+		/* Verify arbitration */
+		if (status & M00018_SR_BITMAP_AL_MSK) {
+			/* Arbitration lost! */
+			return -EIO;
+		}
+
+		/* Store data */
+		data[i] = regs->txr_rxr;
+	}
+	return 0;
+}
+
+/* Generate stop condition on i2c bus.
+ * The m00018 stop isn't doing the right thing (wrong timing).
+ * So instead send a start condition, 8 zeroes and a stop condition.
+ */
+static int cobalt_stop(volatile struct cobalt_i2c_regs __iomem *regs,
+		struct i2c_adapter *adap)
+{
+	u8 data = 0;
+
+	return cobalt_tx_bytes(regs, adap, true, true, &data, 1);
+}
+
+static int cobalt_xfer(struct i2c_adapter *adap,
+			struct i2c_msg msgs[], int num)
+{
+	struct cobalt_i2c_data *data = adap->algo_data;
+	volatile struct cobalt_i2c_regs __iomem *regs = data->regs;
+	struct i2c_msg *pmsg;
+	unsigned short flags;
+	int ret = 0;
+	int i, j;
+
+	for (i = 0; i < num; i++) {
+		int stop = (i == num - 1);
+
+		pmsg = &msgs[i];
+		flags = pmsg->flags;
+
+		if (!(pmsg->flags & I2C_M_NOSTART)) {
+			u8 addr = pmsg->addr << 1;
+
+			if (flags & I2C_M_RD)
+				addr |= 1;
+			if (flags & I2C_M_REV_DIR_ADDR)
+				addr ^= 1;
+			for (j = 0; j < adap->retries; j++) {
+				ret = cobalt_tx_bytes(regs, adap, true, false,
+						      &addr, 1);
+				if (!ret)
+					break;
+				cobalt_stop(regs, adap);
+			}
+			if (ret < 0)
+				return ret;
+			ret = 0;
+		}
+		if (pmsg->flags & I2C_M_RD) {
+			/* read bytes into buffer */
+			ret = cobalt_rx_bytes(regs, adap, false, stop,
+					pmsg->buf, pmsg->len);
+			if (ret < 0)
+				goto bailout;
+		} else {
+			/* write bytes from buffer */
+			ret = cobalt_tx_bytes(regs, adap, false, stop,
+					pmsg->buf, pmsg->len);
+			if (ret < 0)
+				goto bailout;
+		}
+	}
+	ret = i;
+
+bailout:
+	if (ret < 0)
+		cobalt_stop(regs, adap);
+	return ret;
+}
+
+static u32 cobalt_func(struct i2c_adapter *adap)
+{
+	return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL;
+}
+
+/* template for i2c-bit-algo */
+static struct i2c_adapter cobalt_i2c_adap_template = {
+	.name = "cobalt i2c driver",
+	.algo = NULL,                   /* set by i2c-algo-bit */
+	.algo_data = NULL,              /* filled from template */
+	.owner = THIS_MODULE,
+};
+
+static const struct i2c_algorithm cobalt_algo = {
+	.master_xfer	= cobalt_xfer,
+	.functionality	= cobalt_func,
+};
+
+/* init + register i2c algo-bit adapter */
+int cobalt_i2c_init(struct cobalt *cobalt)
+{
+	int i, err;
+	int status;
+	int prescale;
+	unsigned long start_time;
+
+	cobalt_dbg(1, "i2c init\n");
+
+	/* Define I2C clock prescaler */
+	prescale = ((ALT_CPU_FREQ) / (5 * I2C_FREQUENCY)) - 1;
+
+	for (i = 0; i < COBALT_NUM_ADAPTERS; i++) {
+		volatile struct cobalt_i2c_regs __iomem *regs =
+			cobalt_i2c_regs(cobalt, i);
+		struct i2c_adapter *adap = &cobalt->i2c_adap[i];
+
+		/* Disable I2C */
+		regs->cr_sr = M00018_CTR_BITMAP_EN_MSK;
+		regs->ctr = 0;
+		regs->cr_sr = 0;
+
+		start_time = jiffies;
+		do {
+			if (time_after(jiffies, start_time + HZ)) {
+				if (cobalt_ignore_err) {
+					adap->dev.parent = NULL;
+					return 0;
+				}
+				return -ETIMEDOUT;
+			}
+			status = regs->cr_sr;
+		} while (status & M00018_SR_BITMAP_TIP_MSK);
+
+		/* Disable I2C */
+		regs->ctr = 0;
+		regs->cr_sr = 0;
+
+		/* Calculate i2c prescaler */
+		regs->prerlo = prescale & 0xff;
+		regs->prerhi = (prescale >> 8) & 0xff;
+		/* Enable I2C, interrupts disabled */
+		regs->ctr = M00018_CTR_BITMAP_EN_MSK;
+		/* Setup algorithm for adapter */
+		cobalt->i2c_data[i].cobalt = cobalt;
+		cobalt->i2c_data[i].regs = regs;
+		*adap = cobalt_i2c_adap_template;
+		adap->algo = &cobalt_algo;
+		adap->algo_data = &cobalt->i2c_data[i];
+		adap->retries = 3;
+		sprintf(adap->name + strlen(adap->name),
+				" #%d-%d", cobalt->instance, i);
+		i2c_set_adapdata(adap, &cobalt->v4l2_dev);
+		adap->dev.parent = &cobalt->pci_dev->dev;
+		err = i2c_add_adapter(adap);
+		if (err) {
+			if (cobalt_ignore_err) {
+				adap->dev.parent = NULL;
+				return 0;
+			}
+			while (i--)
+				i2c_del_adapter(&cobalt->i2c_adap[i]);
+			return err;
+		}
+		cobalt_info("registered bus %s\n", adap->name);
+	}
+	return 0;
+}
+
+void cobalt_i2c_exit(struct cobalt *cobalt)
+{
+	int i;
+
+	cobalt_dbg(1, "i2c exit\n");
+
+	for (i = 0; i < COBALT_NUM_ADAPTERS; i++) {
+		cobalt_err("unregistered bus %s\n", cobalt->i2c_adap[i].name);
+		i2c_del_adapter(&cobalt->i2c_adap[i]);
+	}
+}
diff --git a/drivers/media/pci/cobalt/cobalt-i2c.h b/drivers/media/pci/cobalt/cobalt-i2c.h
new file mode 100644
index 0000000..a4c1cfa
--- /dev/null
+++ b/drivers/media/pci/cobalt/cobalt-i2c.h
@@ -0,0 +1,25 @@
+/*
+ *  cobalt I2C functions
+ *
+ *  Derived from cx18-i2c.h
+ *
+ *  Copyright 2012-2015 Cisco Systems, Inc. and/or its affiliates.
+ *  All rights reserved.
+ *
+ *  This program is free software; you may redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; version 2 of the License.
+ *
+ *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ *  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ *  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ *  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ *  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ *  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ *  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ *  SOFTWARE.
+ */
+
+/* init + register i2c algo-bit adapter */
+int cobalt_i2c_init(struct cobalt *cobalt);
+void cobalt_i2c_exit(struct cobalt *cobalt);
diff --git a/drivers/media/pci/cobalt/cobalt-irq.c b/drivers/media/pci/cobalt/cobalt-irq.c
new file mode 100644
index 0000000..e18f49e
--- /dev/null
+++ b/drivers/media/pci/cobalt/cobalt-irq.c
@@ -0,0 +1,254 @@
+/*
+ *  cobalt interrupt handling
+ *
+ *  Copyright 2012-2015 Cisco Systems, Inc. and/or its affiliates.
+ *  All rights reserved.
+ *
+ *  This program is free software; you may redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; version 2 of the License.
+ *
+ *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ *  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ *  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ *  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ *  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ *  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ *  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ *  SOFTWARE.
+ */
+
+#include <media/adv7604.h>
+
+#include "cobalt-driver.h"
+#include "cobalt-irq.h"
+#include "cobalt-omnitek.h"
+
+static void cobalt_dma_stream_queue_handler(struct cobalt_stream *s)
+{
+	struct cobalt *cobalt = s->cobalt;
+	int rx = s->video_channel;
+	volatile struct m00473_freewheel_regmap __iomem *fw =
+		COBALT_CVI_FREEWHEEL(s->cobalt, rx);
+	volatile struct m00233_video_measure_regmap __iomem *vmr =
+		COBALT_CVI_VMR(s->cobalt, rx);
+	volatile struct m00389_cvi_regmap __iomem *cvi =
+		COBALT_CVI(s->cobalt, rx);
+	volatile struct m00479_clk_loss_detector_regmap __iomem *clkloss =
+		COBALT_CVI_CLK_LOSS(s->cobalt, rx);
+	struct cobalt_buffer *cb;
+	bool skip = false;
+
+	spin_lock(&s->irqlock);
+
+	if (list_empty(&s->bufs)) {
+		pr_err("no buffers!\n");
+		spin_unlock(&s->irqlock);
+		return;
+	}
+
+	/* Give the fresh filled up buffer to the user.
+	 * Note that the interrupt is only sent if the DMA can continue
+	 * with a new buffer, so it is always safe to return this buffer
+	 * to userspace. */
+	cb = list_first_entry(&s->bufs, struct cobalt_buffer, list);
+	list_del(&cb->list);
+	spin_unlock(&s->irqlock);
+
+	if (s->is_audio || s->is_output)
+		goto done;
+
+	if (s->unstable_frame) {
+		uint32_t stat = vmr->irq_status;
+
+		vmr->irq_status = stat;
+		if (!(vmr->status & M00233_STATUS_BITMAP_INIT_DONE_MSK)) {
+			cobalt_dbg(1, "!init_done\n");
+			if (s->enable_freewheel)
+				goto restart_fw;
+			goto done;
+		}
+
+		if (clkloss->status & M00479_STATUS_BITMAP_CLOCK_MISSING_MSK) {
+			clkloss->ctrl = 0;
+			clkloss->ctrl = M00479_CTRL_BITMAP_ENABLE_MSK;
+			cobalt_dbg(1, "no clock\n");
+			if (s->enable_freewheel)
+				goto restart_fw;
+			goto done;
+		}
+		if ((stat & (M00233_IRQ_STATUS_BITMAP_VACTIVE_AREA_MSK |
+			     M00233_IRQ_STATUS_BITMAP_HACTIVE_AREA_MSK)) ||
+				vmr->vactive_area != s->timings.bt.height ||
+				vmr->hactive_area != s->timings.bt.width) {
+			cobalt_dbg(1, "unstable\n");
+			if (s->enable_freewheel)
+				goto restart_fw;
+			goto done;
+		}
+		if (!s->enable_cvi) {
+			s->enable_cvi = true;
+			cvi->control = M00389_CONTROL_BITMAP_ENABLE_MSK;
+			goto done;
+		}
+		if (!(cvi->status & M00389_STATUS_BITMAP_LOCK_MSK)) {
+			cobalt_dbg(1, "cvi no lock\n");
+			if (s->enable_freewheel)
+				goto restart_fw;
+			goto done;
+		}
+		if (!s->enable_freewheel) {
+			cobalt_dbg(1, "stable\n");
+			s->enable_freewheel = true;
+			fw->ctrl = 0;
+			goto done;
+		}
+		cobalt_dbg(1, "enabled fw\n");
+		vmr->control = M00233_CONTROL_BITMAP_ENABLE_MEASURE_MSK |
+			       M00233_CONTROL_BITMAP_ENABLE_INTERRUPT_MSK;
+		fw->ctrl = M00473_CTRL_BITMAP_ENABLE_MSK;
+		s->enable_freewheel = false;
+		s->unstable_frame = false;
+		s->skip_first_frames = 2;
+		skip = true;
+		goto done;
+	}
+	if (fw->status & M00473_STATUS_BITMAP_FREEWHEEL_MODE_MSK) {
+restart_fw:
+		cobalt_dbg(1, "lost lock\n");
+		vmr->control = M00233_CONTROL_BITMAP_ENABLE_MEASURE_MSK;
+		fw->ctrl = M00473_CTRL_BITMAP_ENABLE_MSK |
+			   M00473_CTRL_BITMAP_FORCE_FREEWHEEL_MODE_MSK;
+		cvi->control = 0;
+		s->unstable_frame = true;
+		s->enable_freewheel = false;
+		s->enable_cvi = false;
+	}
+done:
+	if (s->skip_first_frames) {
+		skip = true;
+		s->skip_first_frames--;
+	}
+	v4l2_get_timestamp(&cb->vb.v4l2_buf.timestamp);
+	/* TODO: the sequence number should be read from the FPGA so we
+	   also know about dropped frames. */
+	cb->vb.v4l2_buf.sequence = s->sequence++;
+	vb2_buffer_done(&cb->vb, (skip || s->unstable_frame) ?
+			VB2_BUF_STATE_QUEUED : VB2_BUF_STATE_DONE);
+}
+
+irqreturn_t cobalt_irq_handler(int irq, void *dev_id)
+{
+	struct cobalt *cobalt = (struct cobalt *)dev_id;
+	u32 dma_interrupt =
+		cobalt_read_bar0(cobalt, DMA_INTERRUPT_STATUS_REG) & 0xffff;
+	u32 mask = cobalt_read_bar1(cobalt, COBALT_SYS_STAT_MASK);
+	u32 edge = cobalt_read_bar1(cobalt, COBALT_SYS_STAT_EDGE);
+	int i;
+
+	/* Clear DMA interrupt */
+	cobalt_write_bar0(cobalt, DMA_INTERRUPT_STATUS_REG, dma_interrupt);
+	cobalt_write_bar1(cobalt, COBALT_SYS_STAT_MASK, mask & ~edge);
+	cobalt_write_bar1(cobalt, COBALT_SYS_STAT_EDGE, edge);
+
+	for (i = 0; i < COBALT_NUM_STREAMS; i++) {
+		struct cobalt_stream *s = &cobalt->streams[i];
+		unsigned dma_fifo_mask =
+		    COBALT_SYSSTAT_VI0_LOST_DATA_MSK << (4 * s->video_channel);
+
+		if (dma_interrupt & (1 << s->dma_channel)) {
+			cobalt->irq_dma[i]++;
+			/* Give fresh buffer to user and chain newly
+			 * queued buffers */
+			cobalt_dma_stream_queue_handler(s);
+			if (!s->is_audio) {
+				edge &= ~dma_fifo_mask;
+				cobalt_write_bar1(cobalt, COBALT_SYS_STAT_MASK,
+						  mask & ~edge);
+			}
+		}
+		if (s->is_audio)
+			continue;
+		if (edge & (0x20 << (4 * s->video_channel)))
+			set_bit(COBALT_STREAM_FL_ADV_IRQ, &s->flags);
+		if ((edge & mask & dma_fifo_mask) && vb2_is_streaming(&s->q)) {
+			cobalt_info("full rx FIFO %d\n", i);
+			cobalt->irq_full_fifo++;
+		}
+	}
+
+	queue_work(cobalt->irq_work_queues, &cobalt->irq_work_queue);
+
+	if (edge & mask & (COBALT_SYSSTAT_VI0_INT1_MSK |
+			   COBALT_SYSSTAT_VI1_INT1_MSK |
+			   COBALT_SYSSTAT_VI2_INT1_MSK |
+			   COBALT_SYSSTAT_VI3_INT1_MSK |
+			   COBALT_SYSSTAT_VIHSMA_INT1_MSK |
+			   COBALT_SYSSTAT_VOHSMA_INT1_MSK))
+		cobalt->irq_adv1++;
+	if (edge & mask & (COBALT_SYSSTAT_VI0_INT2_MSK |
+			   COBALT_SYSSTAT_VI1_INT2_MSK |
+			   COBALT_SYSSTAT_VI2_INT2_MSK |
+			   COBALT_SYSSTAT_VI3_INT2_MSK |
+			   COBALT_SYSSTAT_VIHSMA_INT2_MSK))
+		cobalt->irq_adv2++;
+	if (edge & mask & COBALT_SYSSTAT_VOHSMA_INT1_MSK)
+		cobalt->irq_advout++;
+	if (dma_interrupt)
+		cobalt->irq_dma_tot++;
+	if (!(edge & mask) && !dma_interrupt)
+		cobalt->irq_none++;
+	dma_interrupt = cobalt_read_bar0(cobalt, DMA_INTERRUPT_STATUS_REG);
+
+	return IRQ_HANDLED;
+}
+
+void cobalt_irq_work_handler(struct work_struct *work)
+{
+	struct cobalt *cobalt =
+		container_of(work, struct cobalt, irq_work_queue);
+	int i;
+
+	for (i = 0; i < COBALT_NUM_NODES; i++) {
+		struct cobalt_stream *s = &cobalt->streams[i];
+
+		if (test_and_clear_bit(COBALT_STREAM_FL_ADV_IRQ, &s->flags)) {
+			u32 mask;
+
+			v4l2_subdev_call(cobalt->streams[i].sd, core,
+					interrupt_service_routine, 0, NULL);
+			mask = cobalt_read_bar1(cobalt, COBALT_SYS_STAT_MASK);
+			cobalt_write_bar1(cobalt, COBALT_SYS_STAT_MASK,
+				mask | (0x20 << (4 * s->video_channel)));
+		}
+	}
+}
+
+void cobalt_irq_log_status(struct cobalt *cobalt)
+{
+	u32 mask;
+	int i;
+
+	cobalt_info("irq: adv1=%u adv2=%u advout=%u none=%u full=%u\n",
+		    cobalt->irq_adv1, cobalt->irq_adv2, cobalt->irq_advout,
+		    cobalt->irq_none, cobalt->irq_full_fifo);
+	cobalt_info("irq: dma_tot=%u (", cobalt->irq_dma_tot);
+	for (i = 0; i < COBALT_NUM_STREAMS; i++)
+		pr_cont("%s%u", i ? "/" : "", cobalt->irq_dma[i]);
+	pr_cont(")\n");
+	cobalt->irq_dma_tot = cobalt->irq_adv1 = cobalt->irq_adv2 = 0;
+	cobalt->irq_advout = cobalt->irq_none = cobalt->irq_full_fifo = 0;
+	memset(cobalt->irq_dma, 0, sizeof(cobalt->irq_dma));
+
+	mask = cobalt_read_bar1(cobalt, COBALT_SYS_STAT_MASK);
+	cobalt_write_bar1(cobalt, COBALT_SYS_STAT_MASK,
+			mask |
+			COBALT_SYSSTAT_VI0_LOST_DATA_MSK |
+			COBALT_SYSSTAT_VI1_LOST_DATA_MSK |
+			COBALT_SYSSTAT_VI2_LOST_DATA_MSK |
+			COBALT_SYSSTAT_VI3_LOST_DATA_MSK |
+			COBALT_SYSSTAT_VIHSMA_LOST_DATA_MSK |
+			COBALT_SYSSTAT_VOHSMA_LOST_DATA_MSK |
+			COBALT_SYSSTAT_AUD_IN_LOST_DATA_MSK |
+			COBALT_SYSSTAT_AUD_OUT_LOST_DATA_MSK);
+}
diff --git a/drivers/media/pci/cobalt/cobalt-irq.h b/drivers/media/pci/cobalt/cobalt-irq.h
new file mode 100644
index 0000000..5119484
--- /dev/null
+++ b/drivers/media/pci/cobalt/cobalt-irq.h
@@ -0,0 +1,25 @@
+/*
+ *  cobalt interrupt handling
+ *
+ *  Copyright 2012-2015 Cisco Systems, Inc. and/or its affiliates.
+ *  All rights reserved.
+ *
+ *  This program is free software; you may redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; version 2 of the License.
+ *
+ *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ *  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ *  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ *  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ *  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ *  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ *  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ *  SOFTWARE.
+ */
+
+#include <linux/interrupt.h>
+
+irqreturn_t cobalt_irq_handler(int irq, void *dev_id);
+void cobalt_irq_work_handler(struct work_struct *work);
+void cobalt_irq_log_status(struct cobalt *cobalt);
diff --git a/drivers/media/pci/cobalt/cobalt-omnitek.c b/drivers/media/pci/cobalt/cobalt-omnitek.c
new file mode 100644
index 0000000..a0d94e6
--- /dev/null
+++ b/drivers/media/pci/cobalt/cobalt-omnitek.c
@@ -0,0 +1,340 @@
+/*
+ *  Omnitek Scatter-Gather DMA Controller
+ *
+ *  Copyright 2012-2015 Cisco Systems, Inc. and/or its affiliates.
+ *  All rights reserved.
+ *
+ *  This program is free software; you may redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; version 2 of the License.
+ *
+ *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ *  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ *  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ *  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ *  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ *  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ *  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ *  SOFTWARE.
+ */
+
+#include <linux/string.h>
+#include <linux/io.h>
+#include <linux/pci_regs.h>
+#include <linux/spinlock.h>
+
+#include "cobalt-driver.h"
+#include "cobalt-omnitek.h"
+
+/* descriptor */
+#define END_OF_CHAIN		(1 << 1)
+#define INTERRUPT_ENABLE	(1 << 2)
+#define WRITE_TO_PCI		(1 << 3)
+#define READ_FROM_PCI		(0 << 3)
+#define DESCRIPTOR_FLAG_MSK	(END_OF_CHAIN | INTERRUPT_ENABLE | WRITE_TO_PCI)
+#define NEXT_ADRS_MSK		0xffffffe0
+
+/* control/status register */
+#define ENABLE                  (1 << 0)
+#define START                   (1 << 1)
+#define ABORT                   (1 << 2)
+#define DONE                    (1 << 4)
+#define SG_INTERRUPT            (1 << 5)
+#define EVENT_INTERRUPT         (1 << 6)
+#define SCATTER_GATHER_MODE     (1 << 8)
+#define DISABLE_VIDEO_RESYNC    (1 << 9)
+#define EVENT_INTERRUPT_ENABLE  (1 << 10)
+#define DIRECTIONAL_MSK         (3 << 16)
+#define INPUT_ONLY              (0 << 16)
+#define OUTPUT_ONLY             (1 << 16)
+#define BIDIRECTIONAL           (2 << 16)
+#define DMA_TYPE_MEMORY         (0 << 18)
+#define DMA_TYPE_FIFO		(1 << 18)
+
+#define BASE			(cobalt->bar0)
+#define CAPABILITY_HEADER	(BASE)
+#define CAPABILITY_REGISTER	(BASE + 0x04)
+#define PCI_64BIT		(1 << 8)
+#define LOCAL_64BIT		(1 << 9)
+#define INTERRUPT_STATUS	(BASE + 0x08)
+#define PCI(c)			(BASE + 0x40 + ((c) * 0x40))
+#define SIZE(c)			(BASE + 0x58 + ((c) * 0x40))
+#define DESCRIPTOR(c)		(BASE + 0x50 + ((c) * 0x40))
+#define CS_REG(c)		(BASE + 0x60 + ((c) * 0x40))
+#define BYTES_TRANSFERRED(c)	(BASE + 0x64 + ((c) * 0x40))
+
+
+static char *get_dma_direction(u32 status)
+{
+	switch (status & DIRECTIONAL_MSK) {
+	case INPUT_ONLY: return "Input";
+	case OUTPUT_ONLY: return "Output";
+	case BIDIRECTIONAL: return "Bidirectional";
+	}
+	return "";
+}
+
+static void show_dma_capability(struct cobalt *cobalt)
+{
+	u32 header = ioread32(CAPABILITY_HEADER);
+	u32 capa = ioread32(CAPABILITY_REGISTER);
+	u32 i;
+
+	cobalt_info("Omnitek DMA capability: ID 0x%02x Version 0x%02x Next 0x%x Size 0x%x\n",
+		    header & 0xff, (header >> 8) & 0xff,
+		    (header >> 16) & 0xffff, (capa >> 24) & 0xff);
+
+	switch ((capa >> 8) & 0x3) {
+	case 0:
+		cobalt_info("Omnitek DMA: 32 bits PCIe and Local\n");
+		break;
+	case 1:
+		cobalt_info("Omnitek DMA: 64 bits PCIe, 32 bits Local\n");
+		break;
+	case 3:
+		cobalt_info("Omnitek DMA: 64 bits PCIe and Local\n");
+		break;
+	}
+
+	for (i = 0;  i < (capa & 0xf);  i++) {
+		u32 status = ioread32(CS_REG(i));
+
+		cobalt_info("Omnitek DMA channel #%d: %s %s\n", i,
+			    status & DMA_TYPE_FIFO ? "FIFO" : "MEMORY",
+			    get_dma_direction(status));
+	}
+}
+
+void omni_sg_dma_start(struct cobalt_stream *s, struct sg_dma_desc_info *desc)
+{
+	struct cobalt *cobalt = s->cobalt;
+
+	iowrite32((u32)(desc->bus >> 32), DESCRIPTOR(s->dma_channel) + 4);
+	iowrite32((u32)desc->bus & NEXT_ADRS_MSK, DESCRIPTOR(s->dma_channel));
+	iowrite32(ENABLE | SCATTER_GATHER_MODE | START, CS_REG(s->dma_channel));
+}
+
+bool is_dma_done(struct cobalt_stream *s)
+{
+	struct cobalt *cobalt = s->cobalt;
+
+	if (ioread32(CS_REG(s->dma_channel)) & DONE)
+		return true;
+
+	return false;
+}
+
+void omni_sg_dma_abort_channel(struct cobalt_stream *s)
+{
+	struct cobalt *cobalt = s->cobalt;
+
+	if (is_dma_done(s) == false)
+		iowrite32(ABORT, CS_REG(s->dma_channel));
+}
+
+int omni_sg_dma_init(struct cobalt *cobalt)
+{
+	u32 capa = ioread32(CAPABILITY_REGISTER);
+	int i;
+
+	cobalt->first_fifo_channel = 0;
+	cobalt->dma_channels = capa & 0xf;
+	if (capa & PCI_64BIT)
+		cobalt->pci_32_bit = false;
+	else
+		cobalt->pci_32_bit = true;
+
+	for (i = 0; i < cobalt->dma_channels; i++) {
+		u32 status = ioread32(CS_REG(i));
+		u32 ctrl = ioread32(CS_REG(i));
+
+		if (!(ctrl & DONE))
+			iowrite32(ABORT, CS_REG(i));
+
+		if (!(status & DMA_TYPE_FIFO))
+			cobalt->first_fifo_channel++;
+	}
+	show_dma_capability(cobalt);
+	return 0;
+}
+
+int descriptor_list_create(struct cobalt *cobalt,
+		struct scatterlist *scatter_list, bool to_pci, unsigned sglen,
+		unsigned size, unsigned width, unsigned stride,
+		struct sg_dma_desc_info *desc)
+{
+	struct sg_dma_descriptor *d = (struct sg_dma_descriptor *)desc->virt;
+	dma_addr_t next = desc->bus;
+	unsigned offset = 0;
+	unsigned copy_bytes = width;
+	unsigned copied = 0;
+	bool first = true;
+
+	/* Must be 4-byte aligned */
+	WARN_ON(sg_dma_address(scatter_list) & 3);
+	WARN_ON(size & 3);
+	WARN_ON(next & 3);
+	WARN_ON(stride & 3);
+	WARN_ON(stride < width);
+	if (width >= stride)
+		copy_bytes = stride = size;
+
+	while (size) {
+		dma_addr_t addr = sg_dma_address(scatter_list) + offset;
+		unsigned bytes;
+
+		if (addr == 0)
+			return -EFAULT;
+		if (cobalt->pci_32_bit) {
+			WARN_ON((u64)addr >> 32);
+			if ((u64)addr >> 32)
+				return -EFAULT;
+		}
+
+		/* PCIe address */
+		d->pci_l = addr & 0xffffffff;
+		/* If dma_addr_t is 32 bits, then addr >> 32 is actually the
+		   equivalent of addr >> 0 in gcc. So must cast to u64. */
+		d->pci_h = (u64)addr >> 32;
+
+		/* Sync to start of streaming frame */
+		d->local = 0;
+		d->reserved0 = 0;
+
+		/* Transfer bytes */
+		bytes = min(sg_dma_len(scatter_list) - offset,
+				copy_bytes - copied);
+
+		if (first) {
+			if (to_pci)
+				d->local = 0x11111111;
+			first = false;
+			if (sglen == 1) {
+				/* Make sure there are always at least two
+				 * descriptors */
+				d->bytes = (bytes / 2) & ~3;
+				d->reserved1 = 0;
+				size -= d->bytes;
+				copied += d->bytes;
+				offset += d->bytes;
+				addr += d->bytes;
+				next += sizeof(struct sg_dma_descriptor);
+				d->next_h = (u32)(next >> 32);
+				d->next_l = (u32)next |
+					(to_pci ? WRITE_TO_PCI : 0);
+				bytes -= d->bytes;
+				d++;
+				/* PCIe address */
+				d->pci_l = addr & 0xffffffff;
+				/* If dma_addr_t is 32 bits, then addr >> 32
+				 * is actually the equivalent of addr >> 0 in
+				 * gcc. So must cast to u64. */
+				d->pci_h = (u64)addr >> 32;
+
+				/* Sync to start of streaming frame */
+				d->local = 0;
+				d->reserved0 = 0;
+			}
+		}
+
+		d->bytes = bytes;
+		d->reserved1 = 0;
+		size -= bytes;
+		copied += bytes;
+		offset += bytes;
+
+		if (copied == copy_bytes) {
+			while (copied < stride) {
+				bytes = min(sg_dma_len(scatter_list) - offset,
+						stride - copied);
+				copied += bytes;
+				offset += bytes;
+				size -= bytes;
+				if (sg_dma_len(scatter_list) == offset) {
+					offset = 0;
+					scatter_list = sg_next(scatter_list);
+				}
+			}
+			copied = 0;
+		} else {
+			offset = 0;
+			scatter_list = sg_next(scatter_list);
+		}
+
+		/* Next descriptor + control bits */
+		next += sizeof(struct sg_dma_descriptor);
+		if (size == 0) {
+			/* Loopback to the first descriptor */
+			d->next_h = (u32)(desc->bus >> 32);
+			d->next_l = (u32)desc->bus |
+				(to_pci ? WRITE_TO_PCI : 0) | INTERRUPT_ENABLE;
+			if (!to_pci)
+				d->local = 0x22222222;
+			desc->last_desc_virt = d;
+		} else {
+			d->next_h = (u32)(next >> 32);
+			d->next_l = (u32)next | (to_pci ? WRITE_TO_PCI : 0);
+		}
+		d++;
+	}
+	return 0;
+}
+
+void descriptor_list_chain(struct sg_dma_desc_info *this,
+			   struct sg_dma_desc_info *next)
+{
+	struct sg_dma_descriptor *d = this->last_desc_virt;
+	u32 direction = d->next_l & WRITE_TO_PCI;
+
+	if (next == NULL) {
+		d->next_h = 0;
+		d->next_l = direction | INTERRUPT_ENABLE | END_OF_CHAIN;
+	} else {
+		d->next_h = (u32)(next->bus >> 32);
+		d->next_l = (u32)next->bus | direction | INTERRUPT_ENABLE;
+	}
+}
+
+void *descriptor_list_allocate(struct sg_dma_desc_info *desc, size_t bytes)
+{
+	desc->size = bytes;
+	desc->virt = dma_alloc_coherent(desc->dev, bytes,
+					&desc->bus, GFP_KERNEL);
+	return desc->virt;
+}
+
+void descriptor_list_free(struct sg_dma_desc_info *desc)
+{
+	if (desc->virt)
+		dma_free_coherent(desc->dev, desc->size,
+				  desc->virt, desc->bus);
+}
+
+void descriptor_list_interrupt_enable(struct sg_dma_desc_info *desc)
+{
+	struct sg_dma_descriptor *d = desc->last_desc_virt;
+
+	d->next_l |= INTERRUPT_ENABLE;
+}
+
+void descriptor_list_interrupt_disable(struct sg_dma_desc_info *desc)
+{
+	struct sg_dma_descriptor *d = desc->last_desc_virt;
+
+	d->next_l &= ~INTERRUPT_ENABLE;
+}
+
+void descriptor_list_loopback(struct sg_dma_desc_info *desc)
+{
+	struct sg_dma_descriptor *d = desc->last_desc_virt;
+
+	d->next_h = (u32)(desc->bus >> 32);
+	d->next_l = (u32)desc->bus | (d->next_l & DESCRIPTOR_FLAG_MSK);
+}
+
+void descriptor_list_end_of_chain(struct sg_dma_desc_info *desc)
+{
+	struct sg_dma_descriptor *d = desc->last_desc_virt;
+
+	d->next_l |= END_OF_CHAIN;
+}
diff --git a/drivers/media/pci/cobalt/cobalt-omnitek.h b/drivers/media/pci/cobalt/cobalt-omnitek.h
new file mode 100644
index 0000000..e5c6d03
--- /dev/null
+++ b/drivers/media/pci/cobalt/cobalt-omnitek.h
@@ -0,0 +1,62 @@
+/*
+ *  Omnitek Scatter-Gather DMA Controller
+ *
+ *  Copyright 2012-2015 Cisco Systems, Inc. and/or its affiliates.
+ *  All rights reserved.
+ *
+ *  This program is free software; you may redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; version 2 of the License.
+ *
+ *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ *  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ *  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ *  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ *  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ *  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ *  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ *  SOFTWARE.
+ */
+
+#ifndef COBALT_OMNITEK_H
+#define COBALT_OMNITEK_H
+
+#include <linux/scatterlist.h>
+#include "cobalt-driver.h"
+
+struct sg_dma_descriptor {
+	u32 pci_l;
+	u32 pci_h;
+
+	u32 local;
+	u32 reserved0;
+
+	u32 next_l;
+	u32 next_h;
+
+	u32 bytes;
+	u32 reserved1;
+};
+
+int omni_sg_dma_init(struct cobalt *cobalt);
+void omni_sg_dma_abort_channel(struct cobalt_stream *s);
+void omni_sg_dma_start(struct cobalt_stream *s, struct sg_dma_desc_info *desc);
+bool is_dma_done(struct cobalt_stream *s);
+
+int descriptor_list_create(struct cobalt *cobalt,
+	struct scatterlist *scatter_list, bool to_pci, unsigned sglen,
+	unsigned size, unsigned width, unsigned stride,
+	struct sg_dma_desc_info *desc);
+
+void descriptor_list_chain(struct sg_dma_desc_info *this,
+			   struct sg_dma_desc_info *next);
+void descriptor_list_loopback(struct sg_dma_desc_info *desc);
+void descriptor_list_end_of_chain(struct sg_dma_desc_info *desc);
+
+void *descriptor_list_allocate(struct sg_dma_desc_info *desc, size_t bytes);
+void descriptor_list_free(struct sg_dma_desc_info *desc);
+
+void descriptor_list_interrupt_enable(struct sg_dma_desc_info *desc);
+void descriptor_list_interrupt_disable(struct sg_dma_desc_info *desc);
+
+#endif
diff --git a/drivers/media/pci/cobalt/cobalt-v4l2.c b/drivers/media/pci/cobalt/cobalt-v4l2.c
new file mode 100644
index 0000000..ad4dd3d
--- /dev/null
+++ b/drivers/media/pci/cobalt/cobalt-v4l2.c
@@ -0,0 +1,1248 @@
+/*
+ *  cobalt V4L2 API
+ *
+ *  Derived from ivtv-ioctl.c and cx18-fileops.c
+ *
+ *  Copyright 2012-2015 Cisco Systems, Inc. and/or its affiliates.
+ *  All rights reserved.
+ *
+ *  This program is free software; you may redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; version 2 of the License.
+ *
+ *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ *  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ *  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ *  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ *  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ *  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ *  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ *  SOFTWARE.
+ */
+
+#include <linux/dma-mapping.h>
+#include <linux/delay.h>
+#include <linux/pci.h>
+#include <linux/v4l2-dv-timings.h>
+
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-event.h>
+#include <media/adv7604.h>
+#include <media/adv7842.h>
+
+#include "cobalt-alsa.h"
+#include "cobalt-cpld.h"
+#include "cobalt-driver.h"
+#include "cobalt-v4l2.h"
+#include "cobalt-irq.h"
+#include "cobalt-omnitek.h"
+
+static const struct v4l2_dv_timings cea1080p60 = V4L2_DV_BT_CEA_1920X1080P60;
+
+/* vb2 DMA streaming ops */
+
+static int cobalt_queue_setup(struct vb2_queue *q,
+			const struct v4l2_format *fmt,
+			unsigned int *num_buffers, unsigned int *num_planes,
+			unsigned int sizes[], void *alloc_ctxs[])
+{
+	struct cobalt_stream *s = q->drv_priv;
+	unsigned size = s->stride * s->height;
+
+	if (*num_buffers < 3)
+		*num_buffers = 3;
+	if (*num_buffers > NR_BUFS)
+		*num_buffers = NR_BUFS;
+	*num_planes = 1;
+	if (fmt) {
+		if (fmt->fmt.pix.sizeimage < size)
+			return -EINVAL;
+		size = fmt->fmt.pix.sizeimage;
+	}
+	sizes[0] = size;
+	alloc_ctxs[0] = s->cobalt->alloc_ctx;
+	return 0;
+}
+
+static int cobalt_buf_prepare(struct vb2_buffer *vb)
+{
+	struct cobalt_stream *s = vb->vb2_queue->drv_priv;
+	struct cobalt *cobalt = s->cobalt;
+	struct sg_dma_desc_info *d = &s->dma_desc_info[vb->v4l2_buf.index];
+	struct sg_table *sg_desc = vb2_dma_sg_plane_desc(vb, 0);
+	unsigned size;
+
+	size = s->stride * s->height;
+	if (vb2_plane_size(vb, 0) < size) {
+		cobalt_info("data will not fit into plane (%lu < %u)\n",
+					vb2_plane_size(vb, 0), size);
+		return -EINVAL;
+	}
+
+	vb2_set_plane_payload(vb, 0, size);
+	vb->v4l2_buf.field = V4L2_FIELD_NONE;
+	return descriptor_list_create(cobalt, sg_desc->sgl,
+			!s->is_output, sg_desc->nents, size,
+			s->width * s->bpp, s->stride, d);
+}
+
+static void chain_all_buffers(struct cobalt_stream *s)
+{
+	struct sg_dma_desc_info *desc[NR_BUFS];
+	struct cobalt_buffer *cb;
+	struct list_head *p;
+	int i = 0;
+
+	list_for_each(p, &s->bufs) {
+		cb = list_entry(p, struct cobalt_buffer, list);
+		desc[i] = &s->dma_desc_info[cb->vb.v4l2_buf.index];
+		if (i > 0)
+			descriptor_list_chain(desc[i-1], desc[i]);
+		i++;
+	}
+}
+
+static void cobalt_buf_queue(struct vb2_buffer *vb)
+{
+	struct vb2_queue *q = vb->vb2_queue;
+	struct cobalt_stream *s = q->drv_priv;
+	struct cobalt_buffer *cb = to_cobalt_buffer(vb);
+	struct sg_dma_desc_info *desc = &s->dma_desc_info[vb->v4l2_buf.index];
+	unsigned long flags;
+
+	/* Prepare new buffer */
+	descriptor_list_loopback(desc);
+	descriptor_list_interrupt_disable(desc);
+
+	spin_lock_irqsave(&s->irqlock, flags);
+	list_add_tail(&cb->list, &s->bufs);
+	chain_all_buffers(s);
+	spin_unlock_irqrestore(&s->irqlock, flags);
+}
+
+static void cobalt_enable_output(struct cobalt_stream *s)
+{
+	struct cobalt *cobalt = s->cobalt;
+	struct v4l2_bt_timings *bt = &s->timings.bt;
+	volatile struct m00514_syncgen_flow_evcnt_regmap __iomem *vo =
+		COBALT_TX_BASE(cobalt);
+	unsigned fmt = s->pixfmt != V4L2_PIX_FMT_BGR32 ?
+			M00514_CONTROL_BITMAP_FORMAT_16_BPP_MSK : 0;
+	struct v4l2_subdev_format sd_fmt = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+	};
+
+	if (!cobalt_cpld_set_freq(cobalt, bt->pixelclock)) {
+		cobalt_err("pixelclock out of range\n");
+		return;
+	}
+
+	sd_fmt.format.colorspace = s->colorspace;
+	sd_fmt.format.ycbcr_enc = s->ycbcr_enc;
+	sd_fmt.format.quantization = s->quantization;
+	sd_fmt.format.width = bt->width;
+	sd_fmt.format.height = bt->height;
+
+	/* Set up FDMA packer */
+	switch (s->pixfmt) {
+	case V4L2_PIX_FMT_YUYV:
+		sd_fmt.format.code = MEDIA_BUS_FMT_UYVY8_1X16;
+		break;
+	case V4L2_PIX_FMT_BGR32:
+		sd_fmt.format.code = MEDIA_BUS_FMT_RGB888_1X24;
+		break;
+	}
+	v4l2_subdev_call(s->sd, pad, set_fmt, NULL, &sd_fmt);
+
+	vo->control = 0;
+	/* 1080p60 */
+	vo->sync_generator_h_sync_length = bt->hsync;
+	vo->sync_generator_h_backporch_length = bt->hbackporch;
+	vo->sync_generator_h_active_length = bt->width;
+	vo->sync_generator_h_frontporch_length = bt->hfrontporch;
+	vo->sync_generator_v_sync_length = bt->vsync;
+	vo->sync_generator_v_backporch_length = bt->vbackporch;
+	vo->sync_generator_v_active_length = bt->height;
+	vo->sync_generator_v_frontporch_length = bt->vfrontporch;
+	vo->error_color = 0x9900c1;
+
+	vo->control = M00514_CONTROL_BITMAP_SYNC_GENERATOR_LOAD_PARAM_MSK | fmt;
+	vo->control = M00514_CONTROL_BITMAP_EVCNT_CLEAR_MSK | fmt;
+	vo->control = M00514_CONTROL_BITMAP_SYNC_GENERATOR_ENABLE_MSK |
+		      M00514_CONTROL_BITMAP_FLOW_CTRL_OUTPUT_ENABLE_MSK |
+		      fmt;
+}
+
+static void cobalt_enable_input(struct cobalt_stream *s)
+{
+	struct cobalt *cobalt = s->cobalt;
+	int ch = (int)s->video_channel;
+	volatile struct m00235_fdma_packer_regmap __iomem *packer;
+	struct v4l2_subdev_format sd_fmt_yuyv = {
+		.pad = s->pad_source,
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+		.format.code = MEDIA_BUS_FMT_YUYV8_1X16,
+	};
+	struct v4l2_subdev_format sd_fmt_rgb = {
+		.pad = s->pad_source,
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+		.format.code = MEDIA_BUS_FMT_RGB888_1X24,
+	};
+
+	cobalt_dbg(1, "video_channel %d (%s, %s)\n",
+		   s->video_channel,
+		   s->input == 0 ? "hdmi" : "generator",
+		   "YUYV");
+
+	packer = COBALT_CVI_PACKER(cobalt, ch);
+
+	/* Set up FDMA packer */
+	switch (s->pixfmt) {
+	case V4L2_PIX_FMT_YUYV:
+		packer->control = M00235_CONTROL_BITMAP_ENABLE_MSK |
+			(1 << M00235_CONTROL_BITMAP_PACK_FORMAT_OFST);
+		v4l2_subdev_call(s->sd, pad, set_fmt, NULL,
+				 &sd_fmt_yuyv);
+		break;
+	case V4L2_PIX_FMT_RGB24:
+		packer->control = M00235_CONTROL_BITMAP_ENABLE_MSK |
+			(2 << M00235_CONTROL_BITMAP_PACK_FORMAT_OFST);
+		v4l2_subdev_call(s->sd, pad, set_fmt, NULL,
+				 &sd_fmt_rgb);
+		break;
+	case V4L2_PIX_FMT_BGR32:
+		packer->control = M00235_CONTROL_BITMAP_ENABLE_MSK |
+			M00235_CONTROL_BITMAP_ENDIAN_FORMAT_MSK |
+			(3 << M00235_CONTROL_BITMAP_PACK_FORMAT_OFST);
+		v4l2_subdev_call(s->sd, pad, set_fmt, NULL,
+				 &sd_fmt_rgb);
+		break;
+	}
+}
+
+static void cobalt_dma_start_streaming(struct cobalt_stream *s)
+{
+	struct cobalt *cobalt = s->cobalt;
+	int rx = s->video_channel;
+	volatile struct m00460_evcnt_regmap __iomem *evcnt =
+		COBALT_CVI_EVCNT(cobalt, rx);
+	struct cobalt_buffer *cb;
+	unsigned long flags;
+
+	spin_lock_irqsave(&s->irqlock, flags);
+	if (!s->is_output) {
+		evcnt->control = M00460_CONTROL_BITMAP_CLEAR_MSK;
+		evcnt->control = M00460_CONTROL_BITMAP_ENABLE_MSK;
+	} else {
+		volatile struct m00514_syncgen_flow_evcnt_regmap __iomem *vo =
+			COBALT_TX_BASE(cobalt);
+		u32 ctrl = vo->control;
+
+		ctrl &= ~(M00514_CONTROL_BITMAP_EVCNT_ENABLE_MSK |
+			  M00514_CONTROL_BITMAP_EVCNT_CLEAR_MSK);
+		vo->control = ctrl | M00514_CONTROL_BITMAP_EVCNT_CLEAR_MSK;
+		vo->control = ctrl | M00514_CONTROL_BITMAP_EVCNT_ENABLE_MSK;
+	}
+	cb = list_first_entry(&s->bufs, struct cobalt_buffer, list);
+	omni_sg_dma_start(s, &s->dma_desc_info[cb->vb.v4l2_buf.index]);
+	spin_unlock_irqrestore(&s->irqlock, flags);
+}
+
+static int cobalt_start_streaming(struct vb2_queue *q, unsigned int count)
+{
+	struct cobalt_stream *s = q->drv_priv;
+	struct cobalt *cobalt = s->cobalt;
+	volatile struct m00233_video_measure_regmap __iomem *vmr;
+	volatile struct m00473_freewheel_regmap __iomem *fw;
+	volatile struct m00479_clk_loss_detector_regmap __iomem *clkloss;
+	int rx = s->video_channel;
+	volatile struct m00389_cvi_regmap __iomem *cvi =
+		COBALT_CVI(cobalt, rx);
+	volatile struct m00460_evcnt_regmap __iomem *evcnt =
+		COBALT_CVI_EVCNT(cobalt, rx);
+	struct v4l2_bt_timings *bt = &s->timings.bt;
+	u64 tot_size;
+
+	if (s->is_audio)
+		goto done;
+	if (s->is_output) {
+		s->unstable_frame = false;
+		cobalt_enable_output(s);
+		goto done;
+	}
+
+	cobalt_enable_input(s);
+
+	fw = COBALT_CVI_FREEWHEEL(cobalt, rx);
+	vmr = COBALT_CVI_VMR(cobalt, rx);
+	clkloss = COBALT_CVI_CLK_LOSS(cobalt, rx);
+
+	evcnt->control = M00460_CONTROL_BITMAP_CLEAR_MSK;
+	evcnt->control = M00460_CONTROL_BITMAP_ENABLE_MSK;
+	cvi->frame_width = bt->width;
+	cvi->frame_height = bt->height;
+	tot_size = V4L2_DV_BT_FRAME_WIDTH(bt) * V4L2_DV_BT_FRAME_HEIGHT(bt);
+	vmr->hsync_timeout_val =
+		((u64)V4L2_DV_BT_FRAME_WIDTH(bt) * COBALT_CLK * 4) /
+		bt->pixelclock;
+	vmr->control = M00233_CONTROL_BITMAP_ENABLE_MEASURE_MSK;
+	clkloss->ref_clk_cnt_val = fw->clk_freq / 1000000;
+	/* The lower bound for the clock frequency is 0.5% lower as is
+	 * allowed by the spec */
+	clkloss->test_clk_cnt_val =
+		(((u64)bt->pixelclock * 995) / 1000) / 1000000;
+	/* will be enabled after the first frame has been received */
+	fw->active_length = bt->width * bt->height;
+	fw->total_length = ((u64)fw->clk_freq * tot_size) / bt->pixelclock;
+	vmr->irq_triggers = M00233_IRQ_TRIGGERS_BITMAP_VACTIVE_AREA_MSK |
+		M00233_IRQ_TRIGGERS_BITMAP_HACTIVE_AREA_MSK;
+	cvi->control = 0;
+	vmr->control = M00233_CONTROL_BITMAP_ENABLE_MEASURE_MSK;
+
+	fw->output_color = 0xff;
+	clkloss->ctrl = M00479_CTRL_BITMAP_ENABLE_MSK;
+	fw->ctrl = M00473_CTRL_BITMAP_ENABLE_MSK |
+		   M00473_CTRL_BITMAP_FORCE_FREEWHEEL_MODE_MSK;
+	s->unstable_frame = true;
+	s->enable_freewheel = false;
+	s->enable_cvi = false;
+	s->skip_first_frames = 0;
+
+done:
+	s->sequence = 0;
+	cobalt_dma_start_streaming(s);
+	return 0;
+}
+
+static void cobalt_dma_stop_streaming(struct cobalt_stream *s)
+{
+	struct cobalt *cobalt = s->cobalt;
+	struct sg_dma_desc_info *desc;
+	struct cobalt_buffer *cb;
+	struct list_head *p;
+	unsigned long flags;
+	int timeout_msec = 100;
+	int rx = s->video_channel;
+	volatile struct m00460_evcnt_regmap __iomem *evcnt =
+		COBALT_CVI_EVCNT(cobalt, rx);
+
+	if (!s->is_output) {
+		evcnt->control = 0;
+	} else if (!s->is_audio) {
+		volatile struct m00514_syncgen_flow_evcnt_regmap __iomem *vo =
+			COBALT_TX_BASE(cobalt);
+
+		vo->control = M00514_CONTROL_BITMAP_EVCNT_CLEAR_MSK;
+		vo->control = 0;
+	}
+
+	/* Try to stop the DMA engine gracefully */
+	spin_lock_irqsave(&s->irqlock, flags);
+	list_for_each(p, &s->bufs) {
+		cb = list_entry(p, struct cobalt_buffer, list);
+		desc = &s->dma_desc_info[cb->vb.v4l2_buf.index];
+		/* Stop DMA after this descriptor chain */
+		descriptor_list_end_of_chain(desc);
+	}
+	spin_unlock_irqrestore(&s->irqlock, flags);
+
+	/* Wait 100 milisecond for DMA to finish, abort on timeout. */
+	if (!wait_event_timeout(s->q.done_wq, is_dma_done(s),
+				msecs_to_jiffies(timeout_msec))) {
+		omni_sg_dma_abort_channel(s);
+		pr_warn("aborted\n");
+	}
+	cobalt_write_bar0(cobalt, DMA_INTERRUPT_STATUS_REG,
+			1 << s->dma_channel);
+}
+
+static void cobalt_stop_streaming(struct vb2_queue *q)
+{
+	struct cobalt_stream *s = q->drv_priv;
+	struct cobalt *cobalt = s->cobalt;
+	int rx = s->video_channel;
+	volatile struct m00233_video_measure_regmap __iomem *vmr;
+	volatile struct m00473_freewheel_regmap __iomem *fw;
+	volatile struct m00479_clk_loss_detector_regmap __iomem *clkloss;
+	struct cobalt_buffer *cb;
+	struct list_head *p, *safe;
+	unsigned long flags;
+
+	cobalt_dma_stop_streaming(s);
+
+	/* Return all buffers to user space */
+	spin_lock_irqsave(&s->irqlock, flags);
+	list_for_each_safe(p, safe, &s->bufs) {
+		cb = list_entry(p, struct cobalt_buffer, list);
+		list_del(&cb->list);
+		vb2_buffer_done(&cb->vb, VB2_BUF_STATE_ERROR);
+	}
+	spin_unlock_irqrestore(&s->irqlock, flags);
+
+	if (s->is_audio || s->is_output)
+		return;
+
+	fw = COBALT_CVI_FREEWHEEL(cobalt, rx);
+	vmr = COBALT_CVI_VMR(cobalt, rx);
+	clkloss = COBALT_CVI_CLK_LOSS(cobalt, rx);
+	vmr->control = 0;
+	vmr->control = M00233_CONTROL_BITMAP_ENABLE_MEASURE_MSK;
+	fw->ctrl = 0;
+	clkloss->ctrl = 0;
+}
+
+static const struct vb2_ops cobalt_qops = {
+	.queue_setup = cobalt_queue_setup,
+	.wait_prepare = vb2_ops_wait_prepare,
+	.wait_finish = vb2_ops_wait_finish,
+	.buf_prepare = cobalt_buf_prepare,
+	.buf_queue = cobalt_buf_queue,
+	.start_streaming = cobalt_start_streaming,
+	.stop_streaming = cobalt_stop_streaming,
+};
+
+/* V4L2 ioctls */
+
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+static int cobalt_cobaltc(struct cobalt *cobalt, unsigned int cmd, void *arg)
+{
+	struct v4l2_dbg_register *regs = arg;
+	void __iomem *adrs = cobalt->bar1 + regs->reg;
+
+	cobalt_info("cobalt_cobaltc: adrs = %p\n", adrs);
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	regs->size = 4;
+	if (cmd == VIDIOC_DBG_S_REGISTER)
+		iowrite32(regs->val, adrs);
+	else
+		regs->val = ioread32(adrs);
+	return 0;
+}
+
+static int cobalt_g_register(struct file *file, void *priv_fh,
+		struct v4l2_dbg_register *reg)
+{
+	struct cobalt_stream *s = video_drvdata(file);
+	struct cobalt *cobalt = s->cobalt;
+
+	return cobalt_cobaltc(cobalt, VIDIOC_DBG_G_REGISTER, reg);
+}
+
+static int cobalt_s_register(struct file *file, void *priv_fh,
+		const struct v4l2_dbg_register *reg)
+{
+	struct cobalt_stream *s = video_drvdata(file);
+	struct cobalt *cobalt = s->cobalt;
+
+	return cobalt_cobaltc(cobalt, VIDIOC_DBG_S_REGISTER,
+			(struct v4l2_dbg_register *)reg);
+}
+#endif
+
+static int cobalt_querycap(struct file *file, void *priv_fh,
+				struct v4l2_capability *vcap)
+{
+	struct cobalt_stream *s = video_drvdata(file);
+	struct cobalt *cobalt = s->cobalt;
+
+	strlcpy(vcap->driver, "cobalt", sizeof(vcap->driver));
+	strlcpy(vcap->card, "cobalt", sizeof(vcap->card));
+	snprintf(vcap->bus_info, sizeof(vcap->bus_info),
+		 "PCIe:%s", pci_name(cobalt->pci_dev));
+	vcap->device_caps = V4L2_CAP_STREAMING | V4L2_CAP_READWRITE;
+	if (s->is_output)
+		vcap->device_caps |= V4L2_CAP_VIDEO_OUTPUT;
+	else
+		vcap->device_caps |= V4L2_CAP_VIDEO_CAPTURE;
+	vcap->capabilities = vcap->device_caps | V4L2_CAP_DEVICE_CAPS |
+		V4L2_CAP_VIDEO_CAPTURE;
+	if (cobalt->have_hsma_tx)
+		vcap->capabilities |= V4L2_CAP_VIDEO_OUTPUT;
+	return 0;
+}
+
+static void cobalt_video_input_status_show(struct cobalt_stream *s)
+{
+	volatile struct m00389_cvi_regmap __iomem *cvi;
+	volatile struct m00233_video_measure_regmap __iomem *vmr;
+	volatile struct m00473_freewheel_regmap __iomem *fw;
+	volatile struct m00479_clk_loss_detector_regmap __iomem *clkloss;
+	volatile struct m00235_fdma_packer_regmap __iomem *packer;
+	int rx = s->video_channel;
+	struct cobalt *cobalt = s->cobalt;
+
+	cvi = COBALT_CVI(cobalt, rx);
+	vmr = COBALT_CVI_VMR(cobalt, rx);
+	fw = COBALT_CVI_FREEWHEEL(cobalt, rx);
+	clkloss = COBALT_CVI_CLK_LOSS(cobalt, rx);
+	packer = COBALT_CVI_PACKER(cobalt, rx);
+	cobalt_info("rx%d: cvi resolution: %dx%d\n", rx,
+			cvi->frame_width, cvi->frame_height);
+	cobalt_info("rx%d: cvi control: %s%s%s\n", rx,
+		(cvi->control & M00389_CONTROL_BITMAP_ENABLE_MSK) ?
+			"enable " : "disable ",
+		(cvi->control & M00389_CONTROL_BITMAP_HSYNC_POLARITY_LOW_MSK) ?
+			"HSync- " : "HSync+ ",
+		(cvi->control & M00389_CONTROL_BITMAP_VSYNC_POLARITY_LOW_MSK) ?
+			"VSync- " : "VSync+ ");
+	cobalt_info("rx%d: cvi status: %s%s\n", rx,
+		(cvi->status & M00389_STATUS_BITMAP_LOCK_MSK) ?
+			"lock " : "no-lock ",
+		(cvi->status & M00389_STATUS_BITMAP_ERROR_MSK) ?
+			"error " : "no-error ");
+
+	cobalt_info("rx%d: Measurements: %s%s%s%s%s%s%s\n", rx,
+		(vmr->control & M00233_CONTROL_BITMAP_HSYNC_POLARITY_LOW_MSK) ?
+			"HSync- " : "HSync+ ",
+		(vmr->control & M00233_CONTROL_BITMAP_VSYNC_POLARITY_LOW_MSK) ?
+			"VSync- " : "VSync+ ",
+		(vmr->control & M00233_CONTROL_BITMAP_ENABLE_MEASURE_MSK) ?
+			"enabled " : "disabled ",
+		(vmr->control & M00233_CONTROL_BITMAP_ENABLE_INTERRUPT_MSK) ?
+			"irq-enabled " : "irq-disabled ",
+		(vmr->control & M00233_CONTROL_BITMAP_UPDATE_ON_HSYNC_MSK) ?
+			"update-on-hsync " : "",
+		(vmr->status & M00233_STATUS_BITMAP_HSYNC_TIMEOUT_MSK) ?
+			"hsync-timeout " : "",
+		(vmr->status & M00233_STATUS_BITMAP_INIT_DONE_MSK) ?
+			"init-done" : "");
+	cobalt_info("rx%d: irq_status: 0x%02x irq_triggers: 0x%02x\n", rx,
+			vmr->irq_status & 0xff, vmr->irq_triggers & 0xff);
+	cobalt_info("rx%d: vsync: %d\n", rx, vmr->vsync_time);
+	cobalt_info("rx%d: vbp: %d\n", rx, vmr->vback_porch);
+	cobalt_info("rx%d: vact: %d\n", rx, vmr->vactive_area);
+	cobalt_info("rx%d: vfb: %d\n", rx, vmr->vfront_porch);
+	cobalt_info("rx%d: hsync: %d\n", rx, vmr->hsync_time);
+	cobalt_info("rx%d: hbp: %d\n", rx, vmr->hback_porch);
+	cobalt_info("rx%d: hact: %d\n", rx, vmr->hactive_area);
+	cobalt_info("rx%d: hfb: %d\n", rx, vmr->hfront_porch);
+	cobalt_info("rx%d: Freewheeling: %s%s%s\n", rx,
+		(fw->ctrl & M00473_CTRL_BITMAP_ENABLE_MSK) ?
+			"enabled " : "disabled ",
+		(fw->ctrl & M00473_CTRL_BITMAP_FORCE_FREEWHEEL_MODE_MSK) ?
+			"forced " : "",
+		(fw->status & M00473_STATUS_BITMAP_FREEWHEEL_MODE_MSK) ?
+			"freewheeling " : "video-passthrough ");
+	vmr->irq_status = 0xff;
+	cobalt_info("rx%d: Clock Loss Detection: %s%s\n", rx,
+		(clkloss->ctrl & M00479_CTRL_BITMAP_ENABLE_MSK) ?
+			"enabled " : "disabled ",
+		(clkloss->status & M00479_STATUS_BITMAP_CLOCK_MISSING_MSK) ?
+			"clock-missing " : "found-clock ");
+	cobalt_info("rx%d: Packer: %x\n", rx, packer->control);
+}
+
+static int cobalt_log_status(struct file *file, void *priv_fh)
+{
+	struct cobalt_stream *s = video_drvdata(file);
+	struct cobalt *cobalt = s->cobalt;
+	volatile struct m00514_syncgen_flow_evcnt_regmap __iomem *vo =
+		COBALT_TX_BASE(cobalt);
+	u8 stat;
+
+	cobalt_info("%s", cobalt->hdl_info);
+	cobalt_info("sysctrl: %08x, sysstat: %08x\n",
+			cobalt_g_sysctrl(cobalt),
+			cobalt_g_sysstat(cobalt));
+	cobalt_info("dma channel: %d, video channel: %d\n",
+			s->dma_channel, s->video_channel);
+	cobalt_pcie_status_show(cobalt);
+	cobalt_cpld_status(cobalt);
+	cobalt_irq_log_status(cobalt);
+	v4l2_subdev_call(s->sd, core, log_status);
+	if (!s->is_output) {
+		cobalt_video_input_status_show(s);
+		return 0;
+	}
+
+	stat = vo->rd_status;
+
+	cobalt_info("tx: status: %s%s\n",
+		(stat & M00514_RD_STATUS_BITMAP_FLOW_CTRL_NO_DATA_ERROR_MSK) ?
+			"no_data " : "",
+		(stat & M00514_RD_STATUS_BITMAP_READY_BUFFER_FULL_MSK) ?
+			"ready_buffer_full " : "");
+	cobalt_info("tx: evcnt: %d\n", vo->rd_evcnt_count);
+	return 0;
+}
+
+static int cobalt_enum_dv_timings(struct file *file, void *priv_fh,
+				    struct v4l2_enum_dv_timings *timings)
+{
+	struct cobalt_stream *s = video_drvdata(file);
+
+	if (s->input == 1) {
+		if (timings->index)
+			return -EINVAL;
+		memset(timings->reserved, 0, sizeof(timings->reserved));
+		timings->timings = cea1080p60;
+		return 0;
+	}
+	timings->pad = 0;
+	return v4l2_subdev_call(s->sd,
+			pad, enum_dv_timings, timings);
+}
+
+static int cobalt_s_dv_timings(struct file *file, void *priv_fh,
+				    struct v4l2_dv_timings *timings)
+{
+	struct cobalt_stream *s = video_drvdata(file);
+	int err;
+
+	if (vb2_is_busy(&s->q))
+		return -EBUSY;
+
+	if (s->input == 1) {
+		*timings = cea1080p60;
+		return 0;
+	}
+	err = v4l2_subdev_call(s->sd,
+			video, s_dv_timings, timings);
+	if (!err) {
+		s->timings = *timings;
+		s->width = timings->bt.width;
+		s->height = timings->bt.height;
+		s->stride = timings->bt.width * s->bpp;
+	}
+	return err;
+}
+
+static int cobalt_g_dv_timings(struct file *file, void *priv_fh,
+				    struct v4l2_dv_timings *timings)
+{
+	struct cobalt_stream *s = video_drvdata(file);
+
+	if (s->input == 1) {
+		*timings = cea1080p60;
+		return 0;
+	}
+	return v4l2_subdev_call(s->sd,
+			video, g_dv_timings, timings);
+}
+
+static int cobalt_query_dv_timings(struct file *file, void *priv_fh,
+				    struct v4l2_dv_timings *timings)
+{
+	struct cobalt_stream *s = video_drvdata(file);
+
+	if (s->input == 1) {
+		*timings = cea1080p60;
+		return 0;
+	}
+	return v4l2_subdev_call(s->sd,
+			video, query_dv_timings, timings);
+}
+
+static int cobalt_dv_timings_cap(struct file *file, void *priv_fh,
+				    struct v4l2_dv_timings_cap *cap)
+{
+	struct cobalt_stream *s = video_drvdata(file);
+
+	cap->pad = 0;
+	return v4l2_subdev_call(s->sd,
+			pad, dv_timings_cap, cap);
+}
+
+static int cobalt_enum_fmt_vid_cap(struct file *file, void *priv_fh,
+		struct v4l2_fmtdesc *f)
+{
+	switch (f->index) {
+	case 0:
+		strlcpy(f->description, "YUV 4:2:2", sizeof(f->description));
+		f->pixelformat = V4L2_PIX_FMT_YUYV;
+		break;
+	case 1:
+		strlcpy(f->description, "RGB24", sizeof(f->description));
+		f->pixelformat = V4L2_PIX_FMT_RGB24;
+		break;
+	case 2:
+		strlcpy(f->description, "RGB32", sizeof(f->description));
+		f->pixelformat = V4L2_PIX_FMT_BGR32;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int cobalt_g_fmt_vid_cap(struct file *file, void *priv_fh,
+		struct v4l2_format *f)
+{
+	struct cobalt_stream *s = video_drvdata(file);
+	struct v4l2_pix_format *pix = &f->fmt.pix;
+	struct v4l2_subdev_format sd_fmt;
+
+	pix->width = s->width;
+	pix->height = s->height;
+	pix->bytesperline = s->stride;
+	pix->field = V4L2_FIELD_NONE;
+
+	if (s->input == 1) {
+		pix->colorspace = V4L2_COLORSPACE_SRGB;
+	} else {
+		sd_fmt.pad = s->pad_source;
+		sd_fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
+		v4l2_subdev_call(s->sd, pad, get_fmt, NULL, &sd_fmt);
+		v4l2_fill_pix_format(pix, &sd_fmt.format);
+		pix->colorspace = sd_fmt.format.colorspace;
+		pix->ycbcr_enc = sd_fmt.format.ycbcr_enc;
+		pix->quantization = sd_fmt.format.quantization;
+	}
+
+	pix->pixelformat = s->pixfmt;
+	pix->sizeimage = pix->bytesperline * pix->height;
+
+	return 0;
+}
+
+static int cobalt_try_fmt_vid_cap(struct file *file, void *priv_fh,
+		struct v4l2_format *f)
+{
+	struct cobalt_stream *s = video_drvdata(file);
+	struct v4l2_pix_format *pix = &f->fmt.pix;
+	struct v4l2_subdev_format sd_fmt;
+
+	/* Check for min (QCIF) and max (Full HD) size */
+	if ((pix->width < 176) || (pix->height < 144)) {
+		pix->width = 176;
+		pix->height = 144;
+	}
+
+	if ((pix->width > 1920) || (pix->height > 1080)) {
+		pix->width = 1920;
+		pix->height = 1080;
+	}
+
+	/* Make width multiple of 4 */
+	pix->width &= ~0x3;
+
+	/* Make height multiple of 2 */
+	pix->height &= ~0x1;
+
+	if (s->input == 1) {
+		/* Generator => fixed format only */
+		pix->width = 1920;
+		pix->height = 1080;
+		pix->colorspace = V4L2_COLORSPACE_SRGB;
+	} else {
+		sd_fmt.pad = s->pad_source;
+		sd_fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
+		v4l2_subdev_call(s->sd, pad, get_fmt, NULL, &sd_fmt);
+		v4l2_fill_pix_format(pix, &sd_fmt.format);
+		pix->colorspace = sd_fmt.format.colorspace;
+		pix->ycbcr_enc = sd_fmt.format.ycbcr_enc;
+		pix->quantization = sd_fmt.format.quantization;
+	}
+
+	switch (pix->pixelformat) {
+	case V4L2_PIX_FMT_YUYV:
+	default:
+		pix->bytesperline = max(pix->bytesperline & ~0x3,
+				pix->width * COBALT_BYTES_PER_PIXEL_YUYV);
+		pix->pixelformat = V4L2_PIX_FMT_YUYV;
+		break;
+	case V4L2_PIX_FMT_RGB24:
+		pix->bytesperline = max(pix->bytesperline & ~0x3,
+				pix->width * COBALT_BYTES_PER_PIXEL_RGB24);
+		break;
+	case V4L2_PIX_FMT_BGR32:
+		pix->bytesperline = max(pix->bytesperline & ~0x3,
+				pix->width * COBALT_BYTES_PER_PIXEL_RGB32);
+		break;
+	}
+
+	pix->sizeimage = pix->bytesperline * pix->height;
+	pix->field = V4L2_FIELD_NONE;
+	pix->priv = 0;
+
+	return 0;
+}
+
+static int cobalt_s_fmt_vid_cap(struct file *file, void *priv_fh,
+		struct v4l2_format *f)
+{
+	struct cobalt_stream *s = video_drvdata(file);
+	struct v4l2_pix_format *pix = &f->fmt.pix;
+
+	if (vb2_is_busy(&s->q))
+		return -EBUSY;
+
+	if (cobalt_try_fmt_vid_cap(file, priv_fh, f))
+		return -EINVAL;
+
+	s->width = pix->width;
+	s->height = pix->height;
+	s->stride = pix->bytesperline;
+	switch (pix->pixelformat) {
+	case V4L2_PIX_FMT_YUYV:
+		s->bpp = COBALT_BYTES_PER_PIXEL_YUYV;
+		break;
+	case V4L2_PIX_FMT_RGB24:
+		s->bpp = COBALT_BYTES_PER_PIXEL_RGB24;
+		break;
+	case V4L2_PIX_FMT_BGR32:
+		s->bpp = COBALT_BYTES_PER_PIXEL_RGB32;
+		break;
+	default:
+		return -EINVAL;
+	}
+	s->pixfmt = pix->pixelformat;
+	cobalt_enable_input(s);
+
+	return 0;
+}
+
+static int cobalt_try_fmt_vid_out(struct file *file, void *priv_fh,
+		struct v4l2_format *f)
+{
+	struct v4l2_pix_format *pix = &f->fmt.pix;
+
+	/* Check for min (QCIF) and max (Full HD) size */
+	if ((pix->width < 176) || (pix->height < 144)) {
+		pix->width = 176;
+		pix->height = 144;
+	}
+
+	if ((pix->width > 1920) || (pix->height > 1080)) {
+		pix->width = 1920;
+		pix->height = 1080;
+	}
+
+	/* Make width multiple of 4 */
+	pix->width &= ~0x3;
+
+	/* Make height multiple of 2 */
+	pix->height &= ~0x1;
+
+	switch (pix->pixelformat) {
+	case V4L2_PIX_FMT_YUYV:
+	default:
+		pix->bytesperline = max(pix->bytesperline & ~0x3,
+				pix->width * COBALT_BYTES_PER_PIXEL_YUYV);
+		pix->pixelformat = V4L2_PIX_FMT_YUYV;
+		break;
+	case V4L2_PIX_FMT_BGR32:
+		pix->bytesperline = max(pix->bytesperline & ~0x3,
+				pix->width * COBALT_BYTES_PER_PIXEL_RGB32);
+		break;
+	}
+
+	pix->sizeimage = pix->bytesperline * pix->height;
+	pix->field = V4L2_FIELD_NONE;
+
+	return 0;
+}
+
+static int cobalt_g_fmt_vid_out(struct file *file, void *priv_fh,
+		struct v4l2_format *f)
+{
+	struct cobalt_stream *s = video_drvdata(file);
+	struct v4l2_pix_format *pix = &f->fmt.pix;
+
+	pix->width = s->width;
+	pix->height = s->height;
+	pix->bytesperline = s->stride;
+	pix->field = V4L2_FIELD_NONE;
+	pix->pixelformat = s->pixfmt;
+	pix->colorspace = s->colorspace;
+	pix->ycbcr_enc = s->ycbcr_enc;
+	pix->quantization = s->quantization;
+	pix->sizeimage = pix->bytesperline * pix->height;
+
+	return 0;
+}
+
+static int cobalt_enum_fmt_vid_out(struct file *file, void *priv_fh,
+		struct v4l2_fmtdesc *f)
+{
+	switch (f->index) {
+	case 0:
+		strlcpy(f->description, "YUV 4:2:2", sizeof(f->description));
+		f->pixelformat = V4L2_PIX_FMT_YUYV;
+		break;
+	case 1:
+		strlcpy(f->description, "RGB32", sizeof(f->description));
+		f->pixelformat = V4L2_PIX_FMT_BGR32;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int cobalt_s_fmt_vid_out(struct file *file, void *priv_fh,
+		struct v4l2_format *f)
+{
+	struct cobalt_stream *s = video_drvdata(file);
+	struct v4l2_pix_format *pix = &f->fmt.pix;
+	struct v4l2_subdev_format sd_fmt = { 0 };
+
+	if (cobalt_try_fmt_vid_out(file, priv_fh, f))
+		return -EINVAL;
+
+	if (vb2_is_busy(&s->q) && (pix->pixelformat != s->pixfmt ||
+	    pix->width != s->width || pix->height != s->height ||
+	    pix->bytesperline != s->stride))
+		return -EBUSY;
+
+	switch (pix->pixelformat) {
+	case V4L2_PIX_FMT_YUYV:
+		s->bpp = COBALT_BYTES_PER_PIXEL_YUYV;
+		break;
+	case V4L2_PIX_FMT_BGR32:
+		s->bpp = COBALT_BYTES_PER_PIXEL_RGB32;
+		break;
+	default:
+		return -EINVAL;
+	}
+	s->width = pix->width;
+	s->height = pix->height;
+	s->stride = pix->bytesperline;
+	s->pixfmt = pix->pixelformat;
+	s->colorspace = pix->colorspace;
+	s->ycbcr_enc = pix->ycbcr_enc;
+	s->quantization = pix->quantization;
+	sd_fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
+	v4l2_subdev_call(s->sd, pad, get_fmt, NULL, &sd_fmt);
+	sd_fmt.format.colorspace = pix->colorspace;
+	sd_fmt.format.ycbcr_enc = pix->ycbcr_enc;
+	sd_fmt.format.quantization = pix->quantization;
+	v4l2_subdev_call(s->sd, pad, set_fmt, NULL, &sd_fmt);
+	return 0;
+}
+
+static int cobalt_enum_input(struct file *file, void *priv_fh,
+				 struct v4l2_input *inp)
+{
+	struct cobalt_stream *s = video_drvdata(file);
+
+	if (inp->index > 1)
+		return -EINVAL;
+	if (inp->index == 0)
+		snprintf(inp->name, sizeof(inp->name),
+				"HDMI-%d", s->video_channel);
+	else
+		snprintf(inp->name, sizeof(inp->name),
+				"Generator-%d", s->video_channel);
+	inp->type = V4L2_INPUT_TYPE_CAMERA;
+	inp->capabilities = V4L2_IN_CAP_DV_TIMINGS;
+	if (inp->index == 1)
+		return 0;
+	return v4l2_subdev_call(s->sd,
+			video, g_input_status, &inp->status);
+}
+
+static int cobalt_g_input(struct file *file, void *priv_fh, unsigned int *i)
+{
+	struct cobalt_stream *s = video_drvdata(file);
+
+	*i = s->input;
+	return 0;
+}
+
+static int cobalt_s_input(struct file *file, void *priv_fh, unsigned int i)
+{
+	struct cobalt_stream *s = video_drvdata(file);
+
+	if (i >= 2)
+		return -EINVAL;
+	if (vb2_is_busy(&s->q))
+		return -EBUSY;
+	s->input = i;
+
+	cobalt_enable_input(s);
+
+	if (s->input == 1) /* Test Pattern Generator */
+		return 0;
+
+	return v4l2_subdev_call(s->sd, video, s_routing,
+			ADV76XX_PAD_HDMI_PORT_A, 0, 0);
+}
+
+static int cobalt_enum_output(struct file *file, void *priv_fh,
+				 struct v4l2_output *out)
+{
+	if (out->index)
+		return -EINVAL;
+	snprintf(out->name, sizeof(out->name), "HDMI-%d", out->index);
+	out->type = V4L2_OUTPUT_TYPE_ANALOG;
+	out->capabilities = V4L2_OUT_CAP_DV_TIMINGS;
+	return 0;
+}
+
+static int cobalt_g_output(struct file *file, void *priv_fh, unsigned int *i)
+{
+	*i = 0;
+	return 0;
+}
+
+static int cobalt_s_output(struct file *file, void *priv_fh, unsigned int i)
+{
+	return i ? -EINVAL : 0;
+}
+
+static int cobalt_g_edid(struct file *file, void *fh, struct v4l2_edid *edid)
+{
+	struct cobalt_stream *s = video_drvdata(file);
+	u32 pad = edid->pad;
+	int ret;
+
+	if (edid->pad >= (s->is_output ? 1 : 2))
+		return -EINVAL;
+	edid->pad = 0;
+	ret = v4l2_subdev_call(s->sd, pad, get_edid, edid);
+	edid->pad = pad;
+	return ret;
+}
+
+static int cobalt_s_edid(struct file *file, void *fh, struct v4l2_edid *edid)
+{
+	struct cobalt_stream *s = video_drvdata(file);
+	u32 pad = edid->pad;
+	int ret;
+
+	if (edid->pad >= 2)
+		return -EINVAL;
+	edid->pad = 0;
+	ret = v4l2_subdev_call(s->sd, pad, set_edid, edid);
+	edid->pad = pad;
+	return ret;
+}
+
+static int cobalt_subscribe_event(struct v4l2_fh *fh,
+				  const struct v4l2_event_subscription *sub)
+{
+	switch (sub->type) {
+	case V4L2_EVENT_SOURCE_CHANGE:
+		return v4l2_event_subscribe(fh, sub, 4, NULL);
+	}
+	return v4l2_ctrl_subscribe_event(fh, sub);
+}
+
+static int cobalt_g_parm(struct file *file, void *fh, struct v4l2_streamparm *a)
+{
+	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+	a->parm.capture.timeperframe.numerator = 1;
+	a->parm.capture.timeperframe.denominator = 60;
+	a->parm.capture.readbuffers = 3;
+	return 0;
+}
+
+static const struct v4l2_ioctl_ops cobalt_ioctl_ops = {
+	.vidioc_querycap		= cobalt_querycap,
+	.vidioc_g_parm			= cobalt_g_parm,
+	.vidioc_log_status		= cobalt_log_status,
+	.vidioc_streamon		= vb2_ioctl_streamon,
+	.vidioc_streamoff		= vb2_ioctl_streamoff,
+	.vidioc_enum_input		= cobalt_enum_input,
+	.vidioc_g_input			= cobalt_g_input,
+	.vidioc_s_input			= cobalt_s_input,
+	.vidioc_enum_fmt_vid_cap	= cobalt_enum_fmt_vid_cap,
+	.vidioc_g_fmt_vid_cap		= cobalt_g_fmt_vid_cap,
+	.vidioc_s_fmt_vid_cap		= cobalt_s_fmt_vid_cap,
+	.vidioc_try_fmt_vid_cap		= cobalt_try_fmt_vid_cap,
+	.vidioc_enum_output		= cobalt_enum_output,
+	.vidioc_g_output		= cobalt_g_output,
+	.vidioc_s_output		= cobalt_s_output,
+	.vidioc_enum_fmt_vid_out	= cobalt_enum_fmt_vid_out,
+	.vidioc_g_fmt_vid_out		= cobalt_g_fmt_vid_out,
+	.vidioc_s_fmt_vid_out		= cobalt_s_fmt_vid_out,
+	.vidioc_try_fmt_vid_out		= cobalt_try_fmt_vid_out,
+	.vidioc_s_dv_timings		= cobalt_s_dv_timings,
+	.vidioc_g_dv_timings		= cobalt_g_dv_timings,
+	.vidioc_query_dv_timings	= cobalt_query_dv_timings,
+	.vidioc_enum_dv_timings		= cobalt_enum_dv_timings,
+	.vidioc_dv_timings_cap		= cobalt_dv_timings_cap,
+	.vidioc_g_edid			= cobalt_g_edid,
+	.vidioc_s_edid			= cobalt_s_edid,
+	.vidioc_subscribe_event		= cobalt_subscribe_event,
+	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
+	.vidioc_reqbufs			= vb2_ioctl_reqbufs,
+	.vidioc_create_bufs		= vb2_ioctl_create_bufs,
+	.vidioc_querybuf		= vb2_ioctl_querybuf,
+	.vidioc_qbuf			= vb2_ioctl_qbuf,
+	.vidioc_dqbuf			= vb2_ioctl_dqbuf,
+	.vidioc_expbuf			= vb2_ioctl_expbuf,
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+	.vidioc_g_register              = cobalt_g_register,
+	.vidioc_s_register              = cobalt_s_register,
+#endif
+};
+
+static const struct v4l2_ioctl_ops cobalt_ioctl_empty_ops = {
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+	.vidioc_g_register              = cobalt_g_register,
+	.vidioc_s_register              = cobalt_s_register,
+#endif
+};
+
+/* Register device nodes */
+
+static const struct v4l2_file_operations cobalt_fops = {
+	.owner = THIS_MODULE,
+	.open = v4l2_fh_open,
+	.unlocked_ioctl = video_ioctl2,
+	.release = vb2_fop_release,
+	.poll = vb2_fop_poll,
+	.mmap = vb2_fop_mmap,
+	.read = vb2_fop_read,
+};
+
+static const struct v4l2_file_operations cobalt_out_fops = {
+	.owner = THIS_MODULE,
+	.open = v4l2_fh_open,
+	.unlocked_ioctl = video_ioctl2,
+	.release = vb2_fop_release,
+	.poll = vb2_fop_poll,
+	.mmap = vb2_fop_mmap,
+	.write = vb2_fop_write,
+};
+
+static const struct v4l2_file_operations cobalt_empty_fops = {
+	.owner = THIS_MODULE,
+	.open = v4l2_fh_open,
+	.unlocked_ioctl = video_ioctl2,
+	.release = v4l2_fh_release,
+};
+
+static int cobalt_node_register(struct cobalt *cobalt, int node)
+{
+	static const struct v4l2_dv_timings dv1080p60 =
+		V4L2_DV_BT_CEA_1920X1080P60;
+	struct cobalt_stream *s = cobalt->streams + node;
+	struct video_device *vdev = &s->vdev;
+	struct vb2_queue *q = &s->q;
+	int ret, i;
+
+	mutex_init(&s->lock);
+	spin_lock_init(&s->irqlock);
+
+	/* initialize dma descriptors */
+	for (i = 0; i < NR_BUFS; i++) {
+		const size_t max_pages_per_line =
+			(COBALT_MAX_WIDTH * COBALT_MAX_BPP) / PAGE_SIZE + 2;
+		const size_t bytes =
+			COBALT_MAX_HEIGHT * max_pages_per_line * 0x20;
+		const size_t audio_bytes = ((1920 * 4) / PAGE_SIZE + 1) * 0x20;
+		struct sg_dma_desc_info *desc = &s->dma_desc_info[i];
+
+		desc->dev = &cobalt->pci_dev->dev;
+		descriptor_list_allocate(desc,
+				s->is_audio ? audio_bytes : bytes);
+	}
+
+	snprintf(vdev->name, sizeof(vdev->name),
+			"%s-%d", cobalt->v4l2_dev.name, node);
+	s->width = 1920;
+	/* Audio frames are just 4 lines of 1920 bytes */
+	s->height = s->is_audio ? 4 : 1080;
+
+	if (s->is_audio) {
+		s->bpp = 1;
+		s->pixfmt = V4L2_PIX_FMT_GREY;
+	} else if (s->is_output) {
+		s->bpp = COBALT_BYTES_PER_PIXEL_RGB32;
+		s->pixfmt = V4L2_PIX_FMT_BGR32;
+	} else {
+		s->bpp = COBALT_BYTES_PER_PIXEL_YUYV;
+		s->pixfmt = V4L2_PIX_FMT_YUYV;
+	}
+	s->colorspace = V4L2_COLORSPACE_SRGB;
+	s->stride = s->width * s->bpp;
+
+	if (!s->is_audio) {
+		if (s->is_dummy)
+			cobalt_warn("Setting up dummy video node %d\n", node);
+		vdev->v4l2_dev = &cobalt->v4l2_dev;
+		if (s->is_dummy)
+			vdev->fops = &cobalt_empty_fops;
+		else
+			vdev->fops = s->is_output ? &cobalt_out_fops :
+						    &cobalt_fops;
+		vdev->release = video_device_release_empty;
+		vdev->vfl_dir = s->is_output ? VFL_DIR_TX : VFL_DIR_RX;
+		vdev->lock = &s->lock;
+		if (s->sd)
+			vdev->ctrl_handler = s->sd->ctrl_handler;
+		s->timings = dv1080p60;
+		v4l2_subdev_call(s->sd, video, s_dv_timings, &s->timings);
+		if (!s->is_output && s->sd)
+			cobalt_enable_input(s);
+		vdev->ioctl_ops = s->is_dummy ? &cobalt_ioctl_empty_ops :
+				  &cobalt_ioctl_ops;
+	}
+
+	INIT_LIST_HEAD(&s->bufs);
+	q->type = s->is_output ? V4L2_BUF_TYPE_VIDEO_OUTPUT :
+				 V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
+	q->io_modes |= s->is_output ? VB2_WRITE : VB2_READ;
+	q->drv_priv = s;
+	q->buf_struct_size = sizeof(struct cobalt_buffer);
+	q->ops = &cobalt_qops;
+	q->mem_ops = &vb2_dma_sg_memops;
+	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+	q->min_buffers_needed = 2;
+	q->lock = &s->lock;
+	vdev->queue = q;
+
+	video_set_drvdata(vdev, s);
+	ret = vb2_queue_init(q);
+	if (!s->is_audio && ret == 0)
+		ret = video_register_device(vdev, VFL_TYPE_GRABBER, -1);
+	else if (!s->is_dummy)
+		ret = cobalt_alsa_init(s);
+
+	if (ret < 0) {
+		if (!s->is_audio)
+			cobalt_err("couldn't register v4l2 device node %d\n",
+					node);
+		return ret;
+	}
+	cobalt_info("registered node %d\n", node);
+	return 0;
+}
+
+/* Initialize v4l2 variables and register v4l2 devices */
+int cobalt_nodes_register(struct cobalt *cobalt)
+{
+	int node, ret;
+
+	/* Setup V4L2 Devices */
+	for (node = 0; node < COBALT_NUM_STREAMS; node++) {
+		ret = cobalt_node_register(cobalt, node);
+		if (ret)
+			return ret;
+	}
+	return 0;
+}
+
+/* Unregister v4l2 devices */
+void cobalt_nodes_unregister(struct cobalt *cobalt)
+{
+	int node;
+
+	/* Teardown all streams */
+	for (node = 0; node < COBALT_NUM_STREAMS; node++) {
+		struct cobalt_stream *s = cobalt->streams + node;
+		struct video_device *vdev = &s->vdev;
+		int i;
+
+		if (!s->is_audio)
+			video_unregister_device(vdev);
+		else if (!s->is_dummy)
+			cobalt_alsa_exit(s);
+
+		for (i = 0; i < NR_BUFS; i++) {
+			struct sg_dma_desc_info *desc = &s->dma_desc_info[i];
+
+			descriptor_list_free(desc);
+		}
+	}
+}
diff --git a/drivers/media/pci/cobalt/cobalt-v4l2.h b/drivers/media/pci/cobalt/cobalt-v4l2.h
new file mode 100644
index 0000000..62be553
--- /dev/null
+++ b/drivers/media/pci/cobalt/cobalt-v4l2.h
@@ -0,0 +1,22 @@
+/*
+ *  cobalt V4L2 API
+ *
+ *  Copyright 2012-2015 Cisco Systems, Inc. and/or its affiliates.
+ *  All rights reserved.
+ *
+ *  This program is free software; you may redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; version 2 of the License.
+ *
+ *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ *  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ *  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ *  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ *  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ *  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ *  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ *  SOFTWARE.
+ */
+
+int cobalt_nodes_register(struct cobalt *cobalt);
+void cobalt_nodes_unregister(struct cobalt *cobalt);
diff --git a/drivers/media/pci/cobalt/m00233_video_measure_memmap_package.h b/drivers/media/pci/cobalt/m00233_video_measure_memmap_package.h
new file mode 100644
index 0000000..9bc9ef1
--- /dev/null
+++ b/drivers/media/pci/cobalt/m00233_video_measure_memmap_package.h
@@ -0,0 +1,115 @@
+/*
+ *  Copyright 2014-2015 Cisco Systems, Inc. and/or its affiliates.
+ *  All rights reserved.
+ *
+ *  This program is free software; you may redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; version 2 of the License.
+ *
+ *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ *  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ *  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ *  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ *  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ *  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ *  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ *  SOFTWARE.
+ */
+
+#ifndef M00233_VIDEO_MEASURE_MEMMAP_PACKAGE_H
+#define M00233_VIDEO_MEASURE_MEMMAP_PACKAGE_H
+
+/*******************************************************************
+ * Register Block
+ * M00233_VIDEO_MEASURE_MEMMAP_PACKAGE_VHD_REGMAP
+ *******************************************************************/
+struct m00233_video_measure_regmap {
+	uint32_t irq_status;        /* Reg 0x0000 */
+	/* The vertical counter starts on rising edge of vsync */
+	uint32_t vsync_time;        /* Reg 0x0004 */
+	uint32_t vback_porch;       /* Reg 0x0008 */
+	uint32_t vactive_area;      /* Reg 0x000c */
+	uint32_t vfront_porch;      /* Reg 0x0010 */
+	/* The horizontal counter starts on rising edge of hsync. */
+	uint32_t hsync_time;        /* Reg 0x0014 */
+	uint32_t hback_porch;       /* Reg 0x0018 */
+	uint32_t hactive_area;      /* Reg 0x001c */
+	uint32_t hfront_porch;      /* Reg 0x0020 */
+	uint32_t control;           /* Reg 0x0024, Default=0x0 */
+	uint32_t irq_triggers;      /* Reg 0x0028, Default=0xff */
+	/* Value is given in number of register bus clock periods between */
+	/* falling and rising edge of hsync. Must be non-zero. */
+	uint32_t hsync_timeout_val; /* Reg 0x002c, Default=0x1fff */
+	uint32_t status;            /* Reg 0x0030 */
+};
+
+#define M00233_VIDEO_MEASURE_REG_IRQ_STATUS_OFST 0
+#define M00233_VIDEO_MEASURE_REG_VSYNC_TIME_OFST 4
+#define M00233_VIDEO_MEASURE_REG_VBACK_PORCH_OFST 8
+#define M00233_VIDEO_MEASURE_REG_VACTIVE_AREA_OFST 12
+#define M00233_VIDEO_MEASURE_REG_VFRONT_PORCH_OFST 16
+#define M00233_VIDEO_MEASURE_REG_HSYNC_TIME_OFST 20
+#define M00233_VIDEO_MEASURE_REG_HBACK_PORCH_OFST 24
+#define M00233_VIDEO_MEASURE_REG_HACTIVE_AREA_OFST 28
+#define M00233_VIDEO_MEASURE_REG_HFRONT_PORCH_OFST 32
+#define M00233_VIDEO_MEASURE_REG_CONTROL_OFST 36
+#define M00233_VIDEO_MEASURE_REG_IRQ_TRIGGERS_OFST 40
+#define M00233_VIDEO_MEASURE_REG_HSYNC_TIMEOUT_VAL_OFST 44
+#define M00233_VIDEO_MEASURE_REG_STATUS_OFST 48
+
+/*******************************************************************
+ * Bit Mask for register
+ * M00233_VIDEO_MEASURE_MEMMAP_PACKAGE_VHD_BITMAP
+ *******************************************************************/
+/* irq_status [7:0] */
+#define M00233_IRQ_STATUS_BITMAP_VSYNC_TIME_OFST      (0)
+#define M00233_IRQ_STATUS_BITMAP_VSYNC_TIME_MSK       (0x1 << M00233_IRQ_STATUS_BITMAP_VSYNC_TIME_OFST)
+#define M00233_IRQ_STATUS_BITMAP_VBACK_PORCH_OFST     (1)
+#define M00233_IRQ_STATUS_BITMAP_VBACK_PORCH_MSK      (0x1 << M00233_IRQ_STATUS_BITMAP_VBACK_PORCH_OFST)
+#define M00233_IRQ_STATUS_BITMAP_VACTIVE_AREA_OFST    (2)
+#define M00233_IRQ_STATUS_BITMAP_VACTIVE_AREA_MSK     (0x1 << M00233_IRQ_STATUS_BITMAP_VACTIVE_AREA_OFST)
+#define M00233_IRQ_STATUS_BITMAP_VFRONT_PORCH_OFST    (3)
+#define M00233_IRQ_STATUS_BITMAP_VFRONT_PORCH_MSK     (0x1 << M00233_IRQ_STATUS_BITMAP_VFRONT_PORCH_OFST)
+#define M00233_IRQ_STATUS_BITMAP_HSYNC_TIME_OFST      (4)
+#define M00233_IRQ_STATUS_BITMAP_HSYNC_TIME_MSK       (0x1 << M00233_IRQ_STATUS_BITMAP_HSYNC_TIME_OFST)
+#define M00233_IRQ_STATUS_BITMAP_HBACK_PORCH_OFST     (5)
+#define M00233_IRQ_STATUS_BITMAP_HBACK_PORCH_MSK      (0x1 << M00233_IRQ_STATUS_BITMAP_HBACK_PORCH_OFST)
+#define M00233_IRQ_STATUS_BITMAP_HACTIVE_AREA_OFST    (6)
+#define M00233_IRQ_STATUS_BITMAP_HACTIVE_AREA_MSK     (0x1 << M00233_IRQ_STATUS_BITMAP_HACTIVE_AREA_OFST)
+#define M00233_IRQ_STATUS_BITMAP_HFRONT_PORCH_OFST    (7)
+#define M00233_IRQ_STATUS_BITMAP_HFRONT_PORCH_MSK     (0x1 << M00233_IRQ_STATUS_BITMAP_HFRONT_PORCH_OFST)
+/* control [4:0] */
+#define M00233_CONTROL_BITMAP_HSYNC_POLARITY_LOW_OFST (0)
+#define M00233_CONTROL_BITMAP_HSYNC_POLARITY_LOW_MSK  (0x1 << M00233_CONTROL_BITMAP_HSYNC_POLARITY_LOW_OFST)
+#define M00233_CONTROL_BITMAP_VSYNC_POLARITY_LOW_OFST (1)
+#define M00233_CONTROL_BITMAP_VSYNC_POLARITY_LOW_MSK  (0x1 << M00233_CONTROL_BITMAP_VSYNC_POLARITY_LOW_OFST)
+#define M00233_CONTROL_BITMAP_ENABLE_MEASURE_OFST     (2)
+#define M00233_CONTROL_BITMAP_ENABLE_MEASURE_MSK      (0x1 << M00233_CONTROL_BITMAP_ENABLE_MEASURE_OFST)
+#define M00233_CONTROL_BITMAP_ENABLE_INTERRUPT_OFST   (3)
+#define M00233_CONTROL_BITMAP_ENABLE_INTERRUPT_MSK    (0x1 << M00233_CONTROL_BITMAP_ENABLE_INTERRUPT_OFST)
+#define M00233_CONTROL_BITMAP_UPDATE_ON_HSYNC_OFST    (4)
+#define M00233_CONTROL_BITMAP_UPDATE_ON_HSYNC_MSK     (0x1 << M00233_CONTROL_BITMAP_UPDATE_ON_HSYNC_OFST)
+/* irq_triggers [7:0] */
+#define M00233_IRQ_TRIGGERS_BITMAP_VSYNC_TIME_OFST    (0)
+#define M00233_IRQ_TRIGGERS_BITMAP_VSYNC_TIME_MSK     (0x1 << M00233_IRQ_TRIGGERS_BITMAP_VSYNC_TIME_OFST)
+#define M00233_IRQ_TRIGGERS_BITMAP_VBACK_PORCH_OFST   (1)
+#define M00233_IRQ_TRIGGERS_BITMAP_VBACK_PORCH_MSK    (0x1 << M00233_IRQ_TRIGGERS_BITMAP_VBACK_PORCH_OFST)
+#define M00233_IRQ_TRIGGERS_BITMAP_VACTIVE_AREA_OFST  (2)
+#define M00233_IRQ_TRIGGERS_BITMAP_VACTIVE_AREA_MSK   (0x1 << M00233_IRQ_TRIGGERS_BITMAP_VACTIVE_AREA_OFST)
+#define M00233_IRQ_TRIGGERS_BITMAP_VFRONT_PORCH_OFST  (3)
+#define M00233_IRQ_TRIGGERS_BITMAP_VFRONT_PORCH_MSK   (0x1 << M00233_IRQ_TRIGGERS_BITMAP_VFRONT_PORCH_OFST)
+#define M00233_IRQ_TRIGGERS_BITMAP_HSYNC_TIME_OFST    (4)
+#define M00233_IRQ_TRIGGERS_BITMAP_HSYNC_TIME_MSK     (0x1 << M00233_IRQ_TRIGGERS_BITMAP_HSYNC_TIME_OFST)
+#define M00233_IRQ_TRIGGERS_BITMAP_HBACK_PORCH_OFST   (5)
+#define M00233_IRQ_TRIGGERS_BITMAP_HBACK_PORCH_MSK    (0x1 << M00233_IRQ_TRIGGERS_BITMAP_HBACK_PORCH_OFST)
+#define M00233_IRQ_TRIGGERS_BITMAP_HACTIVE_AREA_OFST  (6)
+#define M00233_IRQ_TRIGGERS_BITMAP_HACTIVE_AREA_MSK   (0x1 << M00233_IRQ_TRIGGERS_BITMAP_HACTIVE_AREA_OFST)
+#define M00233_IRQ_TRIGGERS_BITMAP_HFRONT_PORCH_OFST  (7)
+#define M00233_IRQ_TRIGGERS_BITMAP_HFRONT_PORCH_MSK   (0x1 << M00233_IRQ_TRIGGERS_BITMAP_HFRONT_PORCH_OFST)
+/* status [1:0] */
+#define M00233_STATUS_BITMAP_HSYNC_TIMEOUT_OFST       (0)
+#define M00233_STATUS_BITMAP_HSYNC_TIMEOUT_MSK        (0x1 << M00233_STATUS_BITMAP_HSYNC_TIMEOUT_OFST)
+#define M00233_STATUS_BITMAP_INIT_DONE_OFST           (1)
+#define M00233_STATUS_BITMAP_INIT_DONE_MSK            (0x1 << M00233_STATUS_BITMAP_INIT_DONE_OFST)
+
+#endif /*M00233_VIDEO_MEASURE_MEMMAP_PACKAGE_H*/
diff --git a/drivers/media/pci/cobalt/m00235_fdma_packer_memmap_package.h b/drivers/media/pci/cobalt/m00235_fdma_packer_memmap_package.h
new file mode 100644
index 0000000..a480529
--- /dev/null
+++ b/drivers/media/pci/cobalt/m00235_fdma_packer_memmap_package.h
@@ -0,0 +1,44 @@
+/*
+ *  Copyright 2014-2015 Cisco Systems, Inc. and/or its affiliates.
+ *  All rights reserved.
+ *
+ *  This program is free software; you may redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; version 2 of the License.
+ *
+ *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ *  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ *  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ *  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ *  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ *  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ *  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ *  SOFTWARE.
+ */
+
+#ifndef M00235_FDMA_PACKER_MEMMAP_PACKAGE_H
+#define M00235_FDMA_PACKER_MEMMAP_PACKAGE_H
+
+/*******************************************************************
+ * Register Block
+ * M00235_FDMA_PACKER_MEMMAP_PACKAGE_VHD_REGMAP
+ *******************************************************************/
+struct m00235_fdma_packer_regmap {
+	uint32_t control; /* Reg 0x0000, Default=0x0 */
+};
+
+#define M00235_FDMA_PACKER_REG_CONTROL_OFST 0
+
+/*******************************************************************
+ * Bit Mask for register
+ * M00235_FDMA_PACKER_MEMMAP_PACKAGE_VHD_BITMAP
+ *******************************************************************/
+/* control [3:0] */
+#define M00235_CONTROL_BITMAP_ENABLE_OFST        (0)
+#define M00235_CONTROL_BITMAP_ENABLE_MSK         (0x1 << M00235_CONTROL_BITMAP_ENABLE_OFST)
+#define M00235_CONTROL_BITMAP_PACK_FORMAT_OFST   (1)
+#define M00235_CONTROL_BITMAP_PACK_FORMAT_MSK    (0x3 << M00235_CONTROL_BITMAP_PACK_FORMAT_OFST)
+#define M00235_CONTROL_BITMAP_ENDIAN_FORMAT_OFST (3)
+#define M00235_CONTROL_BITMAP_ENDIAN_FORMAT_MSK  (0x1 << M00235_CONTROL_BITMAP_ENDIAN_FORMAT_OFST)
+
+#endif /*M00235_FDMA_PACKER_MEMMAP_PACKAGE_H*/
diff --git a/drivers/media/pci/cobalt/m00389_cvi_memmap_package.h b/drivers/media/pci/cobalt/m00389_cvi_memmap_package.h
new file mode 100644
index 0000000..602419e5
--- /dev/null
+++ b/drivers/media/pci/cobalt/m00389_cvi_memmap_package.h
@@ -0,0 +1,59 @@
+/*
+ *  Copyright 2014-2015 Cisco Systems, Inc. and/or its affiliates.
+ *  All rights reserved.
+ *
+ *  This program is free software; you may redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; version 2 of the License.
+ *
+ *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ *  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ *  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ *  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ *  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ *  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ *  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ *  SOFTWARE.
+ */
+
+#ifndef M00389_CVI_MEMMAP_PACKAGE_H
+#define M00389_CVI_MEMMAP_PACKAGE_H
+
+/*******************************************************************
+ * Register Block
+ * M00389_CVI_MEMMAP_PACKAGE_VHD_REGMAP
+ *******************************************************************/
+struct m00389_cvi_regmap {
+	uint32_t control;          /* Reg 0x0000, Default=0x0 */
+	uint32_t frame_width;      /* Reg 0x0004, Default=0x10 */
+	uint32_t frame_height;     /* Reg 0x0008, Default=0xc */
+	uint32_t freewheel_period; /* Reg 0x000c, Default=0x0 */
+	uint32_t error_color;      /* Reg 0x0010, Default=0x0 */
+	uint32_t status;           /* Reg 0x0014 */
+};
+
+#define M00389_CVI_REG_CONTROL_OFST 0
+#define M00389_CVI_REG_FRAME_WIDTH_OFST 4
+#define M00389_CVI_REG_FRAME_HEIGHT_OFST 8
+#define M00389_CVI_REG_FREEWHEEL_PERIOD_OFST 12
+#define M00389_CVI_REG_ERROR_COLOR_OFST 16
+#define M00389_CVI_REG_STATUS_OFST 20
+
+/*******************************************************************
+ * Bit Mask for register
+ * M00389_CVI_MEMMAP_PACKAGE_VHD_BITMAP
+ *******************************************************************/
+/* control [2:0] */
+#define M00389_CONTROL_BITMAP_ENABLE_OFST             (0)
+#define M00389_CONTROL_BITMAP_ENABLE_MSK              (0x1 << M00389_CONTROL_BITMAP_ENABLE_OFST)
+#define M00389_CONTROL_BITMAP_HSYNC_POLARITY_LOW_OFST (1)
+#define M00389_CONTROL_BITMAP_HSYNC_POLARITY_LOW_MSK  (0x1 << M00389_CONTROL_BITMAP_HSYNC_POLARITY_LOW_OFST)
+#define M00389_CONTROL_BITMAP_VSYNC_POLARITY_LOW_OFST (2)
+#define M00389_CONTROL_BITMAP_VSYNC_POLARITY_LOW_MSK  (0x1 << M00389_CONTROL_BITMAP_VSYNC_POLARITY_LOW_OFST)
+/* status [1:0] */
+#define M00389_STATUS_BITMAP_LOCK_OFST                (0)
+#define M00389_STATUS_BITMAP_LOCK_MSK                 (0x1 << M00389_STATUS_BITMAP_LOCK_OFST)
+#define M00389_STATUS_BITMAP_ERROR_OFST               (1)
+#define M00389_STATUS_BITMAP_ERROR_MSK                (0x1 << M00389_STATUS_BITMAP_ERROR_OFST)
+
+#endif /*M00389_CVI_MEMMAP_PACKAGE_H*/
diff --git a/drivers/media/pci/cobalt/m00460_evcnt_memmap_package.h b/drivers/media/pci/cobalt/m00460_evcnt_memmap_package.h
new file mode 100644
index 0000000..95471c9
--- /dev/null
+++ b/drivers/media/pci/cobalt/m00460_evcnt_memmap_package.h
@@ -0,0 +1,44 @@
+/*
+ *  Copyright 2014-2015 Cisco Systems, Inc. and/or its affiliates.
+ *  All rights reserved.
+ *
+ *  This program is free software; you may redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; version 2 of the License.
+ *
+ *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ *  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ *  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ *  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ *  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ *  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ *  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ *  SOFTWARE.
+ */
+
+#ifndef M00460_EVCNT_MEMMAP_PACKAGE_H
+#define M00460_EVCNT_MEMMAP_PACKAGE_H
+
+/*******************************************************************
+ * Register Block
+ * M00460_EVCNT_MEMMAP_PACKAGE_VHD_REGMAP
+ *******************************************************************/
+struct m00460_evcnt_regmap {
+	uint32_t control; /* Reg 0x0000, Default=0x0 */
+	uint32_t count;   /* Reg 0x0004 */
+};
+
+#define M00460_EVCNT_REG_CONTROL_OFST 0
+#define M00460_EVCNT_REG_COUNT_OFST 4
+
+/*******************************************************************
+ * Bit Mask for register
+ * M00460_EVCNT_MEMMAP_PACKAGE_VHD_BITMAP
+ *******************************************************************/
+/* control [1:0] */
+#define M00460_CONTROL_BITMAP_ENABLE_OFST (0)
+#define M00460_CONTROL_BITMAP_ENABLE_MSK  (0x1 << M00460_CONTROL_BITMAP_ENABLE_OFST)
+#define M00460_CONTROL_BITMAP_CLEAR_OFST  (1)
+#define M00460_CONTROL_BITMAP_CLEAR_MSK   (0x1 << M00460_CONTROL_BITMAP_CLEAR_OFST)
+
+#endif /*M00460_EVCNT_MEMMAP_PACKAGE_H*/
diff --git a/drivers/media/pci/cobalt/m00473_freewheel_memmap_package.h b/drivers/media/pci/cobalt/m00473_freewheel_memmap_package.h
new file mode 100644
index 0000000..384a3e1
--- /dev/null
+++ b/drivers/media/pci/cobalt/m00473_freewheel_memmap_package.h
@@ -0,0 +1,57 @@
+/*
+ *  Copyright 2014-2015 Cisco Systems, Inc. and/or its affiliates.
+ *  All rights reserved.
+ *
+ *  This program is free software; you may redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; version 2 of the License.
+ *
+ *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ *  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ *  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ *  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ *  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ *  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ *  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ *  SOFTWARE.
+ */
+
+#ifndef M00473_FREEWHEEL_MEMMAP_PACKAGE_H
+#define M00473_FREEWHEEL_MEMMAP_PACKAGE_H
+
+/*******************************************************************
+ * Register Block
+ * M00473_FREEWHEEL_MEMMAP_PACKAGE_VHD_REGMAP
+ *******************************************************************/
+struct m00473_freewheel_regmap {
+	uint32_t ctrl;          /* Reg 0x0000, Default=0x0 */
+	uint32_t status;        /* Reg 0x0004 */
+	uint32_t active_length; /* Reg 0x0008, Default=0x1fa400 */
+	uint32_t total_length;  /* Reg 0x000c, Default=0x31151b */
+	uint32_t data_width;    /* Reg 0x0010 */
+	uint32_t output_color;  /* Reg 0x0014, Default=0xffff */
+	uint32_t clk_freq;      /* Reg 0x0018 */
+};
+
+#define M00473_FREEWHEEL_REG_CTRL_OFST 0
+#define M00473_FREEWHEEL_REG_STATUS_OFST 4
+#define M00473_FREEWHEEL_REG_ACTIVE_LENGTH_OFST 8
+#define M00473_FREEWHEEL_REG_TOTAL_LENGTH_OFST 12
+#define M00473_FREEWHEEL_REG_DATA_WIDTH_OFST 16
+#define M00473_FREEWHEEL_REG_OUTPUT_COLOR_OFST 20
+#define M00473_FREEWHEEL_REG_CLK_FREQ_OFST 24
+
+/*******************************************************************
+ * Bit Mask for register
+ * M00473_FREEWHEEL_MEMMAP_PACKAGE_VHD_BITMAP
+ *******************************************************************/
+/* ctrl [1:0] */
+#define M00473_CTRL_BITMAP_ENABLE_OFST               (0)
+#define M00473_CTRL_BITMAP_ENABLE_MSK                (0x1 << M00473_CTRL_BITMAP_ENABLE_OFST)
+#define M00473_CTRL_BITMAP_FORCE_FREEWHEEL_MODE_OFST (1)
+#define M00473_CTRL_BITMAP_FORCE_FREEWHEEL_MODE_MSK  (0x1 << M00473_CTRL_BITMAP_FORCE_FREEWHEEL_MODE_OFST)
+/* status [0:0] */
+#define M00473_STATUS_BITMAP_FREEWHEEL_MODE_OFST     (0)
+#define M00473_STATUS_BITMAP_FREEWHEEL_MODE_MSK      (0x1 << M00473_STATUS_BITMAP_FREEWHEEL_MODE_OFST)
+
+#endif /*M00473_FREEWHEEL_MEMMAP_PACKAGE_H*/
diff --git a/drivers/media/pci/cobalt/m00479_clk_loss_detector_memmap_package.h b/drivers/media/pci/cobalt/m00479_clk_loss_detector_memmap_package.h
new file mode 100644
index 0000000..2a02902
--- /dev/null
+++ b/drivers/media/pci/cobalt/m00479_clk_loss_detector_memmap_package.h
@@ -0,0 +1,53 @@
+/*
+ *  Copyright 2014-2015 Cisco Systems, Inc. and/or its affiliates.
+ *  All rights reserved.
+ *
+ *  This program is free software; you may redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; version 2 of the License.
+ *
+ *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ *  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ *  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ *  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ *  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ *  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ *  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ *  SOFTWARE.
+ */
+
+#ifndef M00479_CLK_LOSS_DETECTOR_MEMMAP_PACKAGE_H
+#define M00479_CLK_LOSS_DETECTOR_MEMMAP_PACKAGE_H
+
+/*******************************************************************
+ * Register Block
+ * M00479_CLK_LOSS_DETECTOR_MEMMAP_PACKAGE_VHD_REGMAP
+ *******************************************************************/
+struct m00479_clk_loss_detector_regmap {
+	/* Control module */
+	uint32_t ctrl;             /* Reg 0x0000, Default=0x0 */
+	uint32_t status;           /* Reg 0x0004 */
+	/* Number of ref clk cycles before checking the clock under test */
+	uint32_t ref_clk_cnt_val;  /* Reg 0x0008, Default=0xc4 */
+	/* Number of test clk cycles required in the ref_clk_cnt_val period
+	 * to ensure that the test clock is performing as expected */
+	uint32_t test_clk_cnt_val; /* Reg 0x000c, Default=0xa */
+};
+
+#define M00479_CLK_LOSS_DETECTOR_REG_CTRL_OFST 0
+#define M00479_CLK_LOSS_DETECTOR_REG_STATUS_OFST 4
+#define M00479_CLK_LOSS_DETECTOR_REG_REF_CLK_CNT_VAL_OFST 8
+#define M00479_CLK_LOSS_DETECTOR_REG_TEST_CLK_CNT_VAL_OFST 12
+
+/*******************************************************************
+ * Bit Mask for register
+ * M00479_CLK_LOSS_DETECTOR_MEMMAP_PACKAGE_VHD_BITMAP
+ *******************************************************************/
+/* ctrl [0:0] */
+#define M00479_CTRL_BITMAP_ENABLE_OFST          (0)
+#define M00479_CTRL_BITMAP_ENABLE_MSK           (0x1 << M00479_CTRL_BITMAP_ENABLE_OFST)
+/* status [0:0] */
+#define M00479_STATUS_BITMAP_CLOCK_MISSING_OFST (0)
+#define M00479_STATUS_BITMAP_CLOCK_MISSING_MSK  (0x1 << M00479_STATUS_BITMAP_CLOCK_MISSING_OFST)
+
+#endif /*M00479_CLK_LOSS_DETECTOR_MEMMAP_PACKAGE_H*/
diff --git a/drivers/media/pci/cobalt/m00514_syncgen_flow_evcnt_memmap_package.h b/drivers/media/pci/cobalt/m00514_syncgen_flow_evcnt_memmap_package.h
new file mode 100644
index 0000000..bdef2df
--- /dev/null
+++ b/drivers/media/pci/cobalt/m00514_syncgen_flow_evcnt_memmap_package.h
@@ -0,0 +1,88 @@
+/*
+ *  Copyright 2014-2015 Cisco Systems, Inc. and/or its affiliates.
+ *  All rights reserved.
+ *
+ *  This program is free software; you may redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; version 2 of the License.
+ *
+ *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ *  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ *  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ *  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ *  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ *  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ *  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ *  SOFTWARE.
+ */
+
+#ifndef M00514_SYNCGEN_FLOW_EVCNT_MEMMAP_PACKAGE_H
+#define M00514_SYNCGEN_FLOW_EVCNT_MEMMAP_PACKAGE_H
+
+/*******************************************************************
+ * Register Block
+ * M00514_SYNCGEN_FLOW_EVCNT_MEMMAP_PACKAGE_VHD_REGMAP
+ *******************************************************************/
+struct m00514_syncgen_flow_evcnt_regmap {
+	uint32_t control;                            /* Reg 0x0000, Default=0x0 */
+	uint32_t sync_generator_h_sync_length;       /* Reg 0x0004, Default=0x0 */
+	uint32_t sync_generator_h_backporch_length;  /* Reg 0x0008, Default=0x0 */
+	uint32_t sync_generator_h_active_length;     /* Reg 0x000c, Default=0x0 */
+	uint32_t sync_generator_h_frontporch_length; /* Reg 0x0010, Default=0x0 */
+	uint32_t sync_generator_v_sync_length;       /* Reg 0x0014, Default=0x0 */
+	uint32_t sync_generator_v_backporch_length;  /* Reg 0x0018, Default=0x0 */
+	uint32_t sync_generator_v_active_length;     /* Reg 0x001c, Default=0x0 */
+	uint32_t sync_generator_v_frontporch_length; /* Reg 0x0020, Default=0x0 */
+	uint32_t error_color;                        /* Reg 0x0024, Default=0x0 */
+	uint32_t rd_status;                          /* Reg 0x0028 */
+	uint32_t rd_evcnt_count;                     /* Reg 0x002c */
+};
+
+#define M00514_SYNCGEN_FLOW_EVCNT_REG_CONTROL_OFST 0
+#define M00514_SYNCGEN_FLOW_EVCNT_REG_SYNC_GENERATOR_H_SYNC_LENGTH_OFST 4
+#define M00514_SYNCGEN_FLOW_EVCNT_REG_SYNC_GENERATOR_H_BACKPORCH_LENGTH_OFST 8
+#define M00514_SYNCGEN_FLOW_EVCNT_REG_SYNC_GENERATOR_H_ACTIVE_LENGTH_OFST 12
+#define M00514_SYNCGEN_FLOW_EVCNT_REG_SYNC_GENERATOR_H_FRONTPORCH_LENGTH_OFST 16
+#define M00514_SYNCGEN_FLOW_EVCNT_REG_SYNC_GENERATOR_V_SYNC_LENGTH_OFST 20
+#define M00514_SYNCGEN_FLOW_EVCNT_REG_SYNC_GENERATOR_V_BACKPORCH_LENGTH_OFST 24
+#define M00514_SYNCGEN_FLOW_EVCNT_REG_SYNC_GENERATOR_V_ACTIVE_LENGTH_OFST 28
+#define M00514_SYNCGEN_FLOW_EVCNT_REG_SYNC_GENERATOR_V_FRONTPORCH_LENGTH_OFST 32
+#define M00514_SYNCGEN_FLOW_EVCNT_REG_ERROR_COLOR_OFST 36
+#define M00514_SYNCGEN_FLOW_EVCNT_REG_RD_STATUS_OFST 40
+#define M00514_SYNCGEN_FLOW_EVCNT_REG_RD_EVCNT_COUNT_OFST 44
+
+/*******************************************************************
+ * Bit Mask for register
+ * M00514_SYNCGEN_FLOW_EVCNT_MEMMAP_PACKAGE_VHD_BITMAP
+ *******************************************************************/
+/* control [7:0] */
+#define M00514_CONTROL_BITMAP_SYNC_GENERATOR_LOAD_PARAM_OFST (0)
+#define M00514_CONTROL_BITMAP_SYNC_GENERATOR_LOAD_PARAM_MSK  (0x1 << M00514_CONTROL_BITMAP_SYNC_GENERATOR_LOAD_PARAM_OFST)
+#define M00514_CONTROL_BITMAP_SYNC_GENERATOR_ENABLE_OFST     (1)
+#define M00514_CONTROL_BITMAP_SYNC_GENERATOR_ENABLE_MSK      (0x1 << M00514_CONTROL_BITMAP_SYNC_GENERATOR_ENABLE_OFST)
+#define M00514_CONTROL_BITMAP_FLOW_CTRL_OUTPUT_ENABLE_OFST   (2)
+#define M00514_CONTROL_BITMAP_FLOW_CTRL_OUTPUT_ENABLE_MSK    (0x1 << M00514_CONTROL_BITMAP_FLOW_CTRL_OUTPUT_ENABLE_OFST)
+#define M00514_CONTROL_BITMAP_HSYNC_POLARITY_LOW_OFST        (3)
+#define M00514_CONTROL_BITMAP_HSYNC_POLARITY_LOW_MSK         (0x1 << M00514_CONTROL_BITMAP_HSYNC_POLARITY_LOW_OFST)
+#define M00514_CONTROL_BITMAP_VSYNC_POLARITY_LOW_OFST        (4)
+#define M00514_CONTROL_BITMAP_VSYNC_POLARITY_LOW_MSK         (0x1 << M00514_CONTROL_BITMAP_VSYNC_POLARITY_LOW_OFST)
+#define M00514_CONTROL_BITMAP_EVCNT_ENABLE_OFST              (5)
+#define M00514_CONTROL_BITMAP_EVCNT_ENABLE_MSK               (0x1 << M00514_CONTROL_BITMAP_EVCNT_ENABLE_OFST)
+#define M00514_CONTROL_BITMAP_EVCNT_CLEAR_OFST               (6)
+#define M00514_CONTROL_BITMAP_EVCNT_CLEAR_MSK                (0x1 << M00514_CONTROL_BITMAP_EVCNT_CLEAR_OFST)
+#define M00514_CONTROL_BITMAP_FORMAT_16_BPP_OFST             (7)
+#define M00514_CONTROL_BITMAP_FORMAT_16_BPP_MSK              (0x1 << M00514_CONTROL_BITMAP_FORMAT_16_BPP_OFST)
+/* error_color [23:0] */
+#define M00514_ERROR_COLOR_BITMAP_BLUE_OFST                  (0)
+#define M00514_ERROR_COLOR_BITMAP_BLUE_MSK                   (0xff << M00514_ERROR_COLOR_BITMAP_BLUE_OFST)
+#define M00514_ERROR_COLOR_BITMAP_GREEN_OFST                 (8)
+#define M00514_ERROR_COLOR_BITMAP_GREEN_MSK                  (0xff << M00514_ERROR_COLOR_BITMAP_GREEN_OFST)
+#define M00514_ERROR_COLOR_BITMAP_RED_OFST                   (16)
+#define M00514_ERROR_COLOR_BITMAP_RED_MSK                    (0xff << M00514_ERROR_COLOR_BITMAP_RED_OFST)
+/* rd_status [1:0] */
+#define M00514_RD_STATUS_BITMAP_FLOW_CTRL_NO_DATA_ERROR_OFST (0)
+#define M00514_RD_STATUS_BITMAP_FLOW_CTRL_NO_DATA_ERROR_MSK  (0x1 << M00514_RD_STATUS_BITMAP_FLOW_CTRL_NO_DATA_ERROR_OFST)
+#define M00514_RD_STATUS_BITMAP_READY_BUFFER_FULL_OFST       (1)
+#define M00514_RD_STATUS_BITMAP_READY_BUFFER_FULL_MSK        (0x1 << M00514_RD_STATUS_BITMAP_READY_BUFFER_FULL_OFST)
+
+#endif /*M00514_SYNCGEN_FLOW_EVCNT_MEMMAP_PACKAGE_H*/
-- 
2.1.4

