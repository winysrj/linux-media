Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:50809 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970Ab0DTPUY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Apr 2010 11:20:24 -0400
Received: from esebh105.NOE.Nokia.com (esebh105.ntc.nokia.com [172.21.138.211])
	by mgw-mx09.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o3KFK9GC008479
	for <linux-media@vger.kernel.org>; Tue, 20 Apr 2010 10:20:23 -0500
From: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
To: linux-media@vger.kernel.org, eduardo.valentin@nokia.com
Cc: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Subject: [PATCH 2/3] ASoC: WL1273 FM Radio: Digital audio codec.
Date: Tue, 20 Apr 2010 18:20:06 +0300
Message-Id: <1271776807-2710-3-git-send-email-matti.j.aaltonen@nokia.com>
In-Reply-To: <1271776807-2710-2-git-send-email-matti.j.aaltonen@nokia.com>
References: <1271776807-2710-1-git-send-email-matti.j.aaltonen@nokia.com>
 <1271776807-2710-2-git-send-email-matti.j.aaltonen@nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The codec handles digital audio input to and output from the
WL1273 FM radio.

Signed-off-by: Matti J. Aaltonen <matti.j.aaltonen@nokia.com>
---
 sound/soc/codecs/Kconfig  |    6 +
 sound/soc/codecs/Makefile |    2 +
 sound/soc/codecs/wl1273.c |  708 +++++++++++++++++++++++++++++++++++++++++++++
 sound/soc/codecs/wl1273.h |   49 +++
 4 files changed, 765 insertions(+), 0 deletions(-)
 create mode 100644 sound/soc/codecs/wl1273.c
 create mode 100644 sound/soc/codecs/wl1273.h

diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
index 52b005f..c4769f2 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -35,6 +35,7 @@ config SND_SOC_ALL_CODECS
 	select SND_SOC_TWL4030 if TWL4030_CORE
 	select SND_SOC_UDA134X
 	select SND_SOC_UDA1380 if I2C
+	select SND_SOC_WL1273 if I2C
 	select SND_SOC_WM8350 if MFD_WM8350
 	select SND_SOC_WM8400 if MFD_WM8400
 	select SND_SOC_WM8510 if SND_SOC_I2C_AND_SPI
@@ -161,6 +162,11 @@ config SND_SOC_UDA134X
 config SND_SOC_UDA1380
         tristate
 
+config SND_SOC_WL1273
+	tristate
+	select WL1273_CORE
+	default n
+
 config SND_SOC_WM8350
 	tristate
 
diff --git a/sound/soc/codecs/Makefile b/sound/soc/codecs/Makefile
index dbaecb1..2a7c564 100644
--- a/sound/soc/codecs/Makefile
+++ b/sound/soc/codecs/Makefile
@@ -22,6 +22,7 @@ snd-soc-tlv320dac33-objs := tlv320dac33.o
 snd-soc-twl4030-objs := twl4030.o
 snd-soc-uda134x-objs := uda134x.o
 snd-soc-uda1380-objs := uda1380.o
+snd-soc-wl1273-objs := wl1273.o
 snd-soc-wm8350-objs := wm8350.o
 snd-soc-wm8400-objs := wm8400.o
 snd-soc-wm8510-objs := wm8510.o
@@ -78,6 +79,7 @@ obj-$(CONFIG_SND_SOC_TLV320DAC33)	+= snd-soc-tlv320dac33.o
 obj-$(CONFIG_SND_SOC_TWL4030)	+= snd-soc-twl4030.o
 obj-$(CONFIG_SND_SOC_UDA134X)	+= snd-soc-uda134x.o
 obj-$(CONFIG_SND_SOC_UDA1380)	+= snd-soc-uda1380.o
+obj-$(CONFIG_SND_SOC_WL1273)	+= snd-soc-wl1273.o
 obj-$(CONFIG_SND_SOC_WM8350)	+= snd-soc-wm8350.o
 obj-$(CONFIG_SND_SOC_WM8400)	+= snd-soc-wm8400.o
 obj-$(CONFIG_SND_SOC_WM8510)	+= snd-soc-wm8510.o
diff --git a/sound/soc/codecs/wl1273.c b/sound/soc/codecs/wl1273.c
new file mode 100644
index 0000000..2efe865
--- /dev/null
+++ b/sound/soc/codecs/wl1273.c
@@ -0,0 +1,708 @@
+/*
+ * ALSA SoC WL1273 codec driver
+ *
+ * Author:      Matti Aaltonen, <matti.j.aaltonen@nokia.com>
+ *
+ * Copyright:   (C) 2010 Nokia Corporation
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
+ *
+ */
+
+#undef DEBUG
+
+#include <linux/mfd/wl1273-core.h>
+#include <linux/module.h>
+#include <sound/pcm.h>
+#include <sound/pcm_params.h>
+#include <sound/soc.h>
+#include <sound/soc-dapm.h>
+#include <sound/initval.h>
+
+#include "wl1273.h"
+
+static int wl1273_get_audio_route(struct snd_kcontrol *kcontrol,
+				  struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_codec *codec = snd_kcontrol_chip(kcontrol);
+	struct wl1273_priv *wl1273 = codec->private_data;
+
+	ucontrol->value.integer.value[0] = wl1273->mode;
+
+	return 0;
+}
+
+static int wl1273_set_audio_route(struct snd_kcontrol *kcontrol,
+				 struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_codec *codec = snd_kcontrol_chip(kcontrol);
+	struct wl1273_priv *wl1273 = codec->private_data;
+
+	/* Do not allow changes while stream is running */
+	if (codec->active)
+		return -EPERM;
+
+	wl1273->mode = ucontrol->value.integer.value[0];
+
+	return 1;
+}
+
+static const char *wl1273_audio_route[] = { "Bt", "FmRx", "FmTx" };
+
+static const struct soc_enum wl1273_enum[] = {
+	SOC_ENUM_SINGLE_EXT(ARRAY_SIZE(wl1273_audio_route), wl1273_audio_route),
+};
+
+static int snd_wl1273_fm_ctune_get(struct snd_kcontrol *kcontrol,
+				   struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_codec *codec = snd_kcontrol_chip(kcontrol);
+	struct wl1273_priv *wl1273 = codec->private_data;
+
+	dev_dbg(codec->dev, "%s: enter.\n", __func__);
+
+	wl1273->ctune = wl1273_fm_get_tx_ctune(wl1273->core);
+	ucontrol->value.integer.value[0] = wl1273->ctune;
+
+	return 0;
+}
+
+static int snd_wl1273_fm_power_get(struct snd_kcontrol *kcontrol,
+				   struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_codec *codec = snd_kcontrol_chip(kcontrol);
+	struct wl1273_priv *wl1273 = codec->private_data;
+
+	dev_dbg(codec->dev, "%s: enter.\n", __func__);
+
+	wl1273->tx_power = 31 - wl1273_fm_get_tx_power(wl1273->core);
+	ucontrol->value.integer.value[0] = wl1273->tx_power;
+
+	return 0;
+}
+
+static int snd_wl1273_fm_power_put(struct snd_kcontrol *kcontrol,
+				   struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_codec *codec = snd_kcontrol_chip(kcontrol);
+	struct wl1273_priv *wl1273 = codec->private_data;
+	int val, r = 0;
+
+	dev_dbg(codec->dev, "%s: enter.\n", __func__);
+
+	val = ucontrol->value.integer.value[0];
+	if (val < 0 || val > 31)
+		return -EDOM;
+
+	if (wl1273->tx_power == val)
+		return 0;
+
+	wl1273->tx_power = val;
+	r = wl1273_fm_set_tx_power(wl1273->core, 31 - val);
+	if (r)
+		return r;
+
+	return 1;
+}
+
+static int snd_wl1273_fm_rds_get(struct snd_kcontrol *kcontrol,
+				 struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_codec *codec = snd_kcontrol_chip(kcontrol);
+	struct wl1273_priv *wl1273 = codec->private_data;
+
+	dev_dbg(codec->dev, "%s: enter.\n", __func__);
+
+	wl1273->rds_mode = wl1273_fm_get_tx_rds(wl1273->core);
+	ucontrol->value.integer.value[0] = wl1273->rds_mode;
+	return 0;
+}
+
+static int snd_wl1273_fm_rds_put(struct snd_kcontrol *kcontrol,
+				 struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_codec *codec = snd_kcontrol_chip(kcontrol);
+	struct wl1273_priv *wl1273 = codec->private_data;
+	unsigned int val;
+	int r = 0;
+
+	dev_dbg(codec->dev, "%s: enter.\n", __func__);
+
+	val = ucontrol->value.integer.value[0];
+	if (wl1273->rds_mode == val)
+		return 0;
+
+	wl1273->rds_mode = val;
+	r = wl1273_fm_set_tx_rds(wl1273->core, val);
+	if (r)
+		return r;
+
+	return 1;
+}
+
+static const char *wl1273_rds_strings[] = { "Off", "On", "Reset" };
+
+static const struct soc_enum wl1273_rds_enum[] = {
+	SOC_ENUM_SINGLE_EXT(ARRAY_SIZE(wl1273_rds_strings), wl1273_rds_strings),
+};
+
+static int snd_wl1273_fm_mode_get(struct snd_kcontrol *kcontrol,
+				  struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_codec *codec = snd_kcontrol_chip(kcontrol);
+	struct wl1273_priv *wl1273 = codec->private_data;
+
+	dev_dbg(codec->dev, "%s: enter.\n", __func__);
+
+	wl1273->pwr_mode = wl1273_fm_get_mode(wl1273->core);
+	ucontrol->value.integer.value[0] = wl1273->pwr_mode;
+
+	return 0;
+}
+
+static int snd_wl1273_fm_mode_put(struct snd_kcontrol *kcontrol,
+				  struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_codec *codec = snd_kcontrol_chip(kcontrol);
+	struct wl1273_priv *wl1273 = codec->private_data;
+	int val, r = 0;
+
+	dev_dbg(codec->dev, "%s: enter.\n", __func__);
+
+	val = ucontrol->value.integer.value[0];
+	if (wl1273->pwr_mode == val)
+		return 0;
+
+	wl1273->pwr_mode = val;
+	r = wl1273_fm_set_mode(wl1273->core, val);
+	if (r < 0)
+		return r;
+
+	return 1;
+}
+
+static const char *wl1273_mode_strings[] = { "Rx", "Tx", "Off", "Suspend" };
+
+static const struct soc_enum wl1273_mode_enum[] = {
+	SOC_ENUM_SINGLE_EXT(ARRAY_SIZE(wl1273_mode_strings),
+			    wl1273_mode_strings),
+};
+
+static int snd_wl1273_fm_audio_get(struct snd_kcontrol *kcontrol,
+				   struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_codec *codec = snd_kcontrol_chip(kcontrol);
+	struct wl1273_priv *wl1273 = codec->private_data;
+
+	dev_dbg(codec->dev, "%s: enter.\n", __func__);
+
+	wl1273->audio_mode = wl1273_fm_get_audio(wl1273->core);
+	ucontrol->value.integer.value[0] = wl1273->audio_mode;
+
+	return 0;
+}
+
+static int snd_wl1273_fm_audio_put(struct snd_kcontrol *kcontrol,
+				   struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_codec *codec = snd_kcontrol_chip(kcontrol);
+	struct wl1273_priv *wl1273 = codec->private_data;
+	int val, r = 0;
+
+	dev_dbg(codec->dev, "%s: enter.\n", __func__);
+
+	val = ucontrol->value.integer.value[0];
+	if (wl1273->audio_mode == val)
+		return 0;
+
+	wl1273->audio_mode = val;
+	r = wl1273_fm_set_audio(wl1273->core, val);
+	if (r < 0)
+		return r;
+
+	return 1;
+}
+
+static const char *wl1273_audio_strings[] = { "Digital", "Analog" };
+
+static const struct soc_enum wl1273_audio_enum[] = {
+	SOC_ENUM_SINGLE_EXT(ARRAY_SIZE(wl1273_audio_strings),
+			    wl1273_audio_strings),
+};
+
+static int snd_wl1273_fm_region_get(struct snd_kcontrol *kcontrol,
+				    struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_codec *codec = snd_kcontrol_chip(kcontrol);
+	struct wl1273_priv *wl1273 = codec->private_data;
+
+	dev_dbg(codec->dev, "%s: enter.\n", __func__);
+
+	wl1273->region = wl1273_fm_get_region(wl1273->core);
+	ucontrol->value.integer.value[0] = wl1273->region;
+
+	return 0;
+}
+
+static int snd_wl1273_fm_region_put(struct snd_kcontrol *kcontrol,
+				    struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_codec *codec = snd_kcontrol_chip(kcontrol);
+	struct wl1273_priv *wl1273 = codec->private_data;
+	int val, r;
+
+	dev_dbg(codec->dev, "%s: enter.\n", __func__);
+
+	val = ucontrol->value.integer.value[0];
+	if (wl1273->region == val)
+		return 0;
+
+	wl1273->region = val;
+	r = wl1273_fm_set_region(wl1273->core, val);
+	if (r < 0)
+		return r;
+
+	return 1;
+}
+
+static const char *wl1273_region_strings[] = { "Japan", "USA-Europe" };
+
+static const struct soc_enum wl1273_region_enum[] = {
+	SOC_ENUM_SINGLE_EXT(ARRAY_SIZE(wl1273_region_strings),
+			    wl1273_region_strings),
+};
+
+static int snd_wl1273_fm_preemphasis_get(struct snd_kcontrol *kcontrol,
+					 struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_codec *codec = snd_kcontrol_chip(kcontrol);
+	struct wl1273_priv *wl1273 = codec->private_data;
+
+	dev_dbg(codec->dev, "%s: enter.\n", __func__);
+
+	wl1273->preemphasis = wl1273_fm_get_preemphasis(wl1273->core);
+	ucontrol->value.integer.value[0] = wl1273->preemphasis;
+
+	return 0;
+}
+
+static int snd_wl1273_fm_preemphasis_put(struct snd_kcontrol *kcontrol,
+					 struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_codec *codec = snd_kcontrol_chip(kcontrol);
+	struct wl1273_priv *wl1273 = codec->private_data;
+	int val, r = 0;
+
+	dev_dbg(codec->dev, "%s: enter.\n", __func__);
+
+	val = ucontrol->value.integer.value[0];
+	if (wl1273->preemphasis == val)
+		return 0;
+
+	wl1273->preemphasis = val;
+	r = wl1273_fm_set_preemphasis(wl1273->core,
+				      ucontrol->value.integer.value[0]);
+	if (r < 0)
+		return 0;
+
+	return 1;
+}
+
+static const char *wl1273_preemphasis_strings[] = { "Off", "50us", "75us" };
+
+static const struct soc_enum wl1273_preemphasis_enum[] = {
+	SOC_ENUM_SINGLE_EXT(ARRAY_SIZE(wl1273_preemphasis_strings),
+			    wl1273_preemphasis_strings),
+};
+
+static int snd_wl1273_fm_spacing_get(struct snd_kcontrol *kcontrol,
+				     struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_codec *codec = snd_kcontrol_chip(kcontrol);
+	struct wl1273_priv *wl1273 = codec->private_data;
+
+	dev_dbg(codec->dev, "%s: enter.\n", __func__);
+
+	wl1273->spacing = wl1273_fm_tx_get_spacing(wl1273->core);
+	ucontrol->value.integer.value[0] = wl1273->spacing;
+
+	return 0;
+}
+
+static int snd_wl1273_fm_spacing_put(struct snd_kcontrol *kcontrol,
+				     struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_codec *codec = snd_kcontrol_chip(kcontrol);
+	struct wl1273_priv *wl1273 = codec->private_data;
+	int val, r;
+
+	dev_dbg(codec->dev, "%s: enter.\n", __func__);
+
+	val = ucontrol->value.integer.value[0];
+	if (wl1273->spacing == val)
+		return 0;
+
+	wl1273->spacing = val;
+	r = wl1273_fm_tx_set_spacing(wl1273->core,
+				     ucontrol->value.integer.value[0]);
+	if (r < 0)
+		return r;
+
+	return 1;
+}
+
+static const char *wl1273_spacing_strings[] = { "50kHz", "100kHz", "200kHz" };
+
+static const struct soc_enum wl1273_spacing_enum[] = {
+	SOC_ENUM_SINGLE_EXT(ARRAY_SIZE(wl1273_spacing_strings),
+			    wl1273_spacing_strings),
+};
+
+static const struct snd_kcontrol_new wl1273_controls[] = {
+	SOC_ENUM_EXT("Codec Mode", wl1273_enum[0],
+		     wl1273_get_audio_route, wl1273_set_audio_route),
+	SOC_SINGLE_EXT("Tx Ctune", 0, 0, 255, 0, snd_wl1273_fm_ctune_get, NULL),
+	SOC_SINGLE_EXT("Tx Power", 0, 0, 31, 0, snd_wl1273_fm_power_get,
+		       snd_wl1273_fm_power_put),
+	SOC_ENUM_EXT("Rds Switch", wl1273_rds_enum[0],
+		     snd_wl1273_fm_rds_get,  snd_wl1273_fm_rds_put),
+	SOC_ENUM_EXT("Mode Switch", wl1273_mode_enum[0],
+		     snd_wl1273_fm_mode_get,  snd_wl1273_fm_mode_put),
+	SOC_ENUM_EXT("Audio Switch", wl1273_audio_enum[0],
+		     snd_wl1273_fm_audio_get,  snd_wl1273_fm_audio_put),
+	SOC_ENUM_EXT("Region Switch", wl1273_region_enum[0],
+		     snd_wl1273_fm_region_get,  snd_wl1273_fm_region_put),
+	SOC_ENUM_EXT("Pre-emphasis", wl1273_preemphasis_enum[0],
+		     snd_wl1273_fm_preemphasis_get,
+		     snd_wl1273_fm_preemphasis_put),
+	SOC_ENUM_EXT("Channel Spacing", wl1273_spacing_enum[0],
+		     snd_wl1273_fm_spacing_get,  snd_wl1273_fm_spacing_put),
+};
+
+static int wl1273_add_controls(struct snd_soc_codec *codec)
+{
+	return snd_soc_add_controls(codec, wl1273_controls,
+				    ARRAY_SIZE(wl1273_controls));
+}
+
+static int wl1273_startup(struct snd_pcm_substream *substream,
+			  struct snd_soc_dai *dai)
+{
+	struct snd_soc_pcm_runtime *rtd = substream->private_data;
+	struct snd_soc_device *socdev = rtd->socdev;
+	struct snd_pcm *pcm = socdev->card->dai_link->pcm;
+	struct snd_soc_codec *codec = socdev->card->codec;
+	struct wl1273_priv *wl1273 = codec->private_data;
+
+	switch (wl1273->mode) {
+	case WL1273_MODE_BT:
+		pcm->info_flags &= ~SNDRV_PCM_INFO_HALF_DUPLEX;
+		break;
+	case WL1273_MODE_FM_RX:
+		if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
+			pr_err("Cannot play in RX mode.\n");
+			return -EINVAL;
+		}
+		pcm->info_flags |= SNDRV_PCM_INFO_HALF_DUPLEX;
+		break;
+	case WL1273_MODE_FM_TX:
+		if (substream->stream == SNDRV_PCM_STREAM_CAPTURE) {
+			pr_err("Cannot capture in TX mode.\n");
+			return -EINVAL;
+		}
+		pcm->info_flags |= SNDRV_PCM_INFO_HALF_DUPLEX;
+		break;
+	default:
+		return -EINVAL;
+		break;
+	}
+
+	return 0;
+}
+
+static int wl1273_hw_params(struct snd_pcm_substream *substream,
+			    struct snd_pcm_hw_params *params,
+			    struct snd_soc_dai *dai)
+{
+	struct snd_soc_pcm_runtime *rtd = substream->private_data;
+	struct snd_soc_device *socdev = rtd->socdev;
+	struct snd_soc_codec *codec = socdev->card->codec;
+	struct wl1273_priv *wl1273 = codec->private_data;
+	struct wl1273_core *core = wl1273->core;
+	unsigned int rate, width, r;
+
+	if (params_format(params) != SNDRV_PCM_FORMAT_S16_LE) {
+		pr_err("Only SNDRV_PCM_FORMAT_S16_LE supported.\n");
+		return -EINVAL;
+	}
+
+	rate = params_rate(params);
+	width =  hw_param_interval(params, SNDRV_PCM_HW_PARAM_SAMPLE_BITS)->min;
+
+	if (wl1273->mode == WL1273_MODE_BT) {
+		if (rate != 8000) {
+			pr_err("Rate %d not supported.\n", params_rate(params));
+			return -EINVAL;
+		}
+
+		if (params_channels(params) != 1) {
+			pr_err("Only mono supported.\n");
+			return -EINVAL;
+		}
+
+		return 0;
+	}
+
+	if (wl1273->mode == WL1273_MODE_FM_TX &&
+	    substream->stream == SNDRV_PCM_STREAM_CAPTURE) {
+		pr_err("Only playback supported with TX.\n");
+		return -EINVAL;
+	}
+
+	if (wl1273->mode == WL1273_MODE_FM_RX  &&
+	    substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
+		pr_err("Only capture supported with RX.\n");
+		return -EINVAL;
+	}
+
+	if (wl1273->mode != WL1273_MODE_FM_RX  &&
+	    wl1273->mode != WL1273_MODE_FM_TX) {
+		pr_err("Unexpected mode: %d.\n", wl1273->mode);
+		return -EINVAL;
+	}
+
+	r = wl1273_fm_set_i2s_mode(core, rate, width);
+	if (r)
+		return r;
+
+	r = wl1273_fm_set_channel_number(core, (params_channels(params)));
+	if (r)
+		return r;
+
+	return 0;
+}
+
+static int wl1273_set_dai_fmt(struct snd_soc_dai *codec_dai,
+			      unsigned int fmt)
+{
+	return 0;
+}
+
+static struct snd_soc_dai_ops wl1273_dai_ops = {
+	.startup	= wl1273_startup,
+	.hw_params	= wl1273_hw_params,
+	.set_fmt	= wl1273_set_dai_fmt,
+};
+
+struct snd_soc_dai wl1273_dai = {
+	.name = "WL1273 BT/FM codec",
+	.playback = {
+		.stream_name = "Playback",
+		.channels_min = 1,
+		.channels_max = 2,
+		.rates = SNDRV_PCM_RATE_8000 | SNDRV_PCM_RATE_48000,
+		.formats = SNDRV_PCM_FMTBIT_S16_LE},
+	.capture = {
+		.stream_name = "Capture",
+		.channels_min = 1,
+		.channels_max = 2,
+		.rates = SNDRV_PCM_RATE_8000 | SNDRV_PCM_RATE_48000,
+		.formats = SNDRV_PCM_FMTBIT_S16_LE},
+	.ops = &wl1273_dai_ops,
+};
+EXPORT_SYMBOL_GPL(wl1273_dai);
+
+static int wl1273_soc_suspend(struct platform_device *pdev, pm_message_t state)
+{
+	return 0;
+}
+
+static int wl1273_soc_resume(struct platform_device *pdev)
+{
+	return 0;
+}
+
+static struct snd_soc_codec *wl1273_codec;
+
+/*
+ * initialize the driver
+ * register the mixer and dsp interfaces with the kernel
+ */
+static int wl1273_soc_probe(struct platform_device *pdev)
+{
+	struct snd_soc_device *socdev = platform_get_drvdata(pdev);
+	struct snd_soc_codec *codec;
+	struct wl1273_priv *wl1273;
+	int r = 0;
+
+	dev_dbg(&pdev->dev, "%s.\n", __func__);
+
+	codec = wl1273_codec;
+	wl1273 = codec->private_data;
+	socdev->card->codec = codec;
+
+	codec->name = "wl1273";
+	codec->owner = THIS_MODULE;
+	codec->dai = &wl1273_dai;
+	codec->num_dai = 1;
+
+	/* register pcms */
+	r = snd_soc_new_pcms(socdev, SNDRV_DEFAULT_IDX1, SNDRV_DEFAULT_STR1);
+	if (r < 0) {
+		dev_err(&pdev->dev, "Wl1273: failed to create pcms.\n");
+		goto err2;
+	}
+
+	r = wl1273_add_controls(codec);
+	if (r < 0) {
+		dev_err(&pdev->dev, "Wl1273: failed to add contols.\n");
+		goto err1;
+	}
+
+	return 0;
+err1:
+	snd_soc_free_pcms(socdev);
+err2:
+	return r;
+}
+
+static int wl1273_soc_remove(struct platform_device *pdev)
+{
+	struct snd_soc_device *socdev = platform_get_drvdata(pdev);
+
+	snd_soc_free_pcms(socdev);
+
+	return 0;
+}
+
+static int __devinit wl1273_codec_probe(struct platform_device *pdev)
+{
+	struct wl1273_core **pdata = pdev->dev.platform_data;
+	struct snd_soc_codec *codec;
+	struct wl1273_priv *wl1273;
+	int r;
+
+	dev_dbg(&pdev->dev, "%s.\n", __func__);
+
+	if (!pdata) {
+		dev_err(&pdev->dev, "Platform data is missing.\n");
+		return -EINVAL;
+	}
+
+	wl1273 = kzalloc(sizeof(struct wl1273_priv), GFP_KERNEL);
+	if (wl1273 == NULL) {
+		dev_err(&pdev->dev, "Cannot allocate memory.\n");
+		return -ENOMEM;
+	}
+
+	wl1273->mode = WL1273_MODE_BT;
+	wl1273->ctune = -1;
+	wl1273->tx_power = -1;
+	wl1273->rds_mode = -1;
+	wl1273->pwr_mode = -1;
+	wl1273->audio_mode = -1;
+	wl1273->region = -1;
+	wl1273->preemphasis = -1;
+	wl1273->spacing = -1;
+	wl1273->core = *pdata;
+
+	codec = &wl1273->codec;
+	codec->private_data = wl1273;
+	codec->dev = &pdev->dev;
+	wl1273_dai.dev = &pdev->dev;
+
+	mutex_init(&codec->mutex);
+	INIT_LIST_HEAD(&codec->dapm_widgets);
+	INIT_LIST_HEAD(&codec->dapm_paths);
+
+	codec->name = "wl1273";
+	codec->owner = THIS_MODULE;
+	codec->dai = &wl1273_dai;
+	codec->num_dai = 1;
+
+	platform_set_drvdata(pdev, wl1273);
+	wl1273_codec = codec;
+
+	codec->bias_level = SND_SOC_BIAS_OFF;
+
+	r = snd_soc_register_codec(codec);
+	if (r != 0) {
+		dev_err(codec->dev, "Failed to register codec: %d\n", r);
+		goto err2;
+	}
+
+	r = snd_soc_register_dai(&wl1273_dai);
+	if (r != 0) {
+		dev_err(codec->dev, "Failed to register DAIs: %d\n", r);
+		goto err1;
+	}
+
+	return 0;
+
+err1:
+	snd_soc_unregister_codec(codec);
+err2:
+	kfree(wl1273);
+	return r;
+}
+
+static int __devexit wl1273_codec_remove(struct platform_device *pdev)
+{
+	struct wl1273_priv *wl1273 = platform_get_drvdata(pdev);
+
+	dev_dbg(&pdev->dev, "%s\n", __func__);
+
+	snd_soc_unregister_dai(&wl1273_dai);
+	snd_soc_unregister_codec(&wl1273->codec);
+
+	kfree(wl1273);
+	wl1273_codec = NULL;
+
+	return 0;
+}
+
+MODULE_ALIAS("platform:wl1273_codec_audio");
+
+static struct platform_driver wl1273_codec_driver = {
+	.probe		= wl1273_codec_probe,
+	.remove		= __devexit_p(wl1273_codec_remove),
+	.driver		= {
+		.name	= "wl1273_codec_audio",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init wl1273_modinit(void)
+{
+	return platform_driver_register(&wl1273_codec_driver);
+}
+module_init(wl1273_modinit);
+
+static void __exit wl1273_exit(void)
+{
+	platform_driver_unregister(&wl1273_codec_driver);
+}
+module_exit(wl1273_exit);
+
+struct snd_soc_codec_device soc_codec_dev_wl1273 = {
+	.probe = wl1273_soc_probe,
+	.remove = wl1273_soc_remove,
+	.suspend = wl1273_soc_suspend,
+	.resume = wl1273_soc_resume};
+EXPORT_SYMBOL_GPL(soc_codec_dev_wl1273);
+
+MODULE_AUTHOR("Matti Aaltonen <matti.j.aaltonen@nokia.com>");
+MODULE_DESCRIPTION("ASoC WL1273 codec driver");
+MODULE_LICENSE("GPL");
diff --git a/sound/soc/codecs/wl1273.h b/sound/soc/codecs/wl1273.h
new file mode 100644
index 0000000..d1775d8
--- /dev/null
+++ b/sound/soc/codecs/wl1273.h
@@ -0,0 +1,49 @@
+/*
+ * sound/soc/codec/wl1273.h
+ *
+ * ALSA SoC WL1273 codec driver
+ *
+ * Copyright (C) Nokia Corporation
+ * Author: Matti Aaltonen <matti.j.aaltonen@nokia.com>
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
+ *
+ */
+
+#ifndef __WL1273_CODEC_H__
+#define __WL1273_CODEC_H__
+
+enum wl1273_mode { WL1273_MODE_BT, WL1273_MODE_FM_RX, WL1273_MODE_FM_TX };
+
+/* codec private data */
+struct wl1273_priv {
+	struct snd_soc_codec codec;
+	enum wl1273_mode mode;
+	int ctune;
+	int tx_power;
+	int rds_mode;
+	int pwr_mode;
+	int audio_mode;
+	int region;
+	int preemphasis;
+	int spacing;
+
+	struct wl1273_core *core;
+};
+
+extern struct snd_soc_dai wl1273_dai;
+extern struct snd_soc_codec_device soc_codec_dev_wl1273;
+
+#endif	/* End of __WL1273_CODEC_H__ */
-- 
1.6.1.3

