Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:21670 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757344Ab3BGLy3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Feb 2013 06:54:29 -0500
From: Rahul Sharma <rahul.sharma@samsung.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	alsa-devel@alsa-project.org, linux-fbdev@vger.kernel.org
Cc: tomi.valkeinen@ti.com, laurent.pinchart@ideasonboard.com,
	broonie@opensource.wolfsonmicro.com, inki.dae@samsung.com,
	kyungmin.park@samsung.com, r.sh.open@gmail.com, joshi@samsung.com
Subject: [RFC PATCH v2 5/5] alsa/soc: add hdmi audio card using cdf based hdmi
 codec
Date: Thu, 07 Feb 2013 07:12:12 -0500
Message-id: <1360239132-15557-3-git-send-email-rahul.sharma@samsung.com>
In-reply-to: <1360239132-15557-1-git-send-email-rahul.sharma@samsung.com>
References: <1360239132-15557-1-git-send-email-rahul.sharma@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It registers hdmi-audio card to ALSA framework which associates i2s dai and
cdf based hdmi audio codec.

Signed-off-by: Rahul Sharma <rahul.sharma@samsung.com>
---
 sound/soc/samsung/Kconfig  |   8 ++
 sound/soc/samsung/Makefile |   2 +
 sound/soc/samsung/hdmi.c   | 260 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 270 insertions(+)
 create mode 100644 sound/soc/samsung/hdmi.c

diff --git a/sound/soc/samsung/Kconfig b/sound/soc/samsung/Kconfig
index 90e7e66..d5b92ab 100644
--- a/sound/soc/samsung/Kconfig
+++ b/sound/soc/samsung/Kconfig
@@ -185,6 +185,14 @@ config SND_SOC_SMDK_WM8994_PCM
 	help
 	  Say Y if you want to add support for SoC audio on the SMDK
 
+config SND_SOC_EXYNOS_HDMI_AUDIO
+	tristate "SoC I2S Audio support for HDMI"
+	depends on SND_SOC_SAMSUNG && DRM_EXYNOS_HDMI_CDF
+	select SND_SAMSUNG_I2S
+	select SND_SOC_EXYNOS_HDMI_CODEC
+	help
+		Say Y if you want to add support for hdmi audio on the Exynos.
+
 config SND_SOC_SPEYSIDE
 	tristate "Audio support for Wolfson Speyside"
 	depends on SND_SOC_SAMSUNG && MACH_WLF_CRAGG_6410
diff --git a/sound/soc/samsung/Makefile b/sound/soc/samsung/Makefile
index 709f605..ab1c151 100644
--- a/sound/soc/samsung/Makefile
+++ b/sound/soc/samsung/Makefile
@@ -8,6 +8,7 @@ snd-soc-s3c-i2s-v2-objs := s3c-i2s-v2.o
 snd-soc-samsung-spdif-objs := spdif.o
 snd-soc-pcm-objs := pcm.o
 snd-soc-i2s-objs := i2s.o
+snd-soc-hdmi-objs := hdmi.o
 
 obj-$(CONFIG_SND_SOC_SAMSUNG) += snd-soc-s3c24xx.o
 obj-$(CONFIG_SND_S3C24XX_I2S) += snd-soc-s3c24xx-i2s.o
@@ -18,6 +19,7 @@ obj-$(CONFIG_SND_SAMSUNG_SPDIF) += snd-soc-samsung-spdif.o
 obj-$(CONFIG_SND_SAMSUNG_PCM) += snd-soc-pcm.o
 obj-$(CONFIG_SND_SAMSUNG_I2S) += snd-soc-i2s.o
 obj-$(CONFIG_SND_SAMSUNG_I2S) += snd-soc-idma.o
+obj-$(CONFIG_SND_SOC_EXYNOS_HDMI_AUDIO) += snd-soc-hdmi.o
 
 # S3C24XX Machine Support
 snd-soc-jive-wm8750-objs := jive_wm8750.o
diff --git a/sound/soc/samsung/hdmi.c b/sound/soc/samsung/hdmi.c
new file mode 100644
index 0000000..a600a84
--- /dev/null
+++ b/sound/soc/samsung/hdmi.c
@@ -0,0 +1,260 @@
+/*
+ * ALSA SoC Card driver for HDMI audio on Samsung Exynos processors.
+ * Copyright (C) 2013 Samsung corp.
+ * Author: Rahul Sharma <rahul.sharma@samsung.com>
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
+ */
+
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/clk.h>
+
+#include <sound/pcm_params.h>
+#include <sound/soc.h>
+
+#include "i2s.h"
+
+/* platform device pointer for eynos hdmi audio device. */
+static struct platform_device *exynos_hdmi_audio_pdev;
+
+static int set_epll_rate(unsigned long rate)
+{
+	int ret;
+	struct clk *fout_epll;
+
+	fout_epll = clk_get(NULL, "fout_epll");
+
+	if (IS_ERR(fout_epll))
+		return PTR_ERR(fout_epll);
+
+	if (rate == clk_get_rate(fout_epll))
+		goto out;
+
+	ret = clk_set_rate(fout_epll, rate);
+	if (ret < 0)
+		goto out;
+
+out:
+	clk_put(fout_epll);
+
+	return 0;
+}
+
+static int hdmi_hw_params(struct snd_pcm_substream *substream,
+	struct snd_pcm_hw_params *params)
+{
+	struct snd_soc_pcm_runtime *rtd = substream->private_data;
+	struct snd_soc_dai *cpu_dai = rtd->cpu_dai;
+	int bfs, psr, rfs, ret;
+	unsigned long rclk;
+	unsigned long xtal;
+	struct clk *xtal_clk;
+
+	dev_dbg(rtd->dev, "[%d][%s]\n", __LINE__, __func__);
+
+	switch (params_format(params)) {
+	case SNDRV_PCM_FORMAT_U24:
+	case SNDRV_PCM_FORMAT_S24:
+		bfs = 48;
+		break;
+	case SNDRV_PCM_FORMAT_U16_LE:
+	case SNDRV_PCM_FORMAT_S16_LE:
+		bfs = 32;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	switch (params_rate(params)) {
+	case 16000:
+	case 22050:
+	case 24000:
+	case 32000:
+	case 44100:
+	case 48000:
+	case 88200:
+	case 96000:
+		if (bfs == 48)
+			rfs = 384;
+		else
+			rfs = 256;
+		break;
+	case 64000:
+		rfs = 384;
+		break;
+	case 8000:
+	case 11025:
+	case 12000:
+		if (bfs == 48)
+			rfs = 768;
+		else
+			rfs = 512;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	rclk = params_rate(params) * rfs;
+
+	switch (rclk) {
+	case 4096000:
+	case 5644800:
+	case 6144000:
+	case 8467200:
+	case 9216000:
+		psr = 8;
+		break;
+	case 8192000:
+	case 11289600:
+	case 12288000:
+	case 16934400:
+	case 18432000:
+		psr = 4;
+		break;
+	case 22579200:
+	case 24576000:
+	case 33868800:
+	case 36864000:
+		psr = 2;
+		break;
+	case 67737600:
+	case 73728000:
+		psr = 1;
+		break;
+	default:
+		dev_err(rtd->dev, "rclk = %lu is not yet supported!\n", rclk);
+		return -EINVAL;
+	}
+
+	ret = set_epll_rate(rclk * psr);
+	if (ret < 0)
+		return ret;
+
+	ret = snd_soc_dai_set_fmt(cpu_dai, SND_SOC_DAIFMT_I2S |
+					   SND_SOC_DAIFMT_NB_NF |
+					   SND_SOC_DAIFMT_CBS_CFS);
+	if (ret < 0)
+		return ret;
+
+	xtal_clk = clk_get(NULL, "xtal"); /*xtal clk is input to codec MCLK1*/
+	if (IS_ERR(xtal_clk)) {
+		dev_err(rtd->dev, "%s: failed to get xtal clock\n", __func__);
+		return PTR_ERR(xtal_clk);
+	}
+
+	xtal = clk_get_rate(xtal_clk);
+	clk_put(xtal_clk);
+
+	ret = snd_soc_dai_set_sysclk(cpu_dai, SAMSUNG_I2S_CDCLK,
+					0, SND_SOC_CLOCK_OUT);
+	if (ret < 0)
+		return ret;
+
+	ret = snd_soc_dai_set_clkdiv(cpu_dai, SAMSUNG_I2S_DIV_BCLK, bfs);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+/*
+ * HDMI DAI operations.
+ */
+static struct snd_soc_ops hdmi_ops = {
+	.hw_params = hdmi_hw_params,
+};
+
+static struct snd_soc_dai_link hdmi_dai[] = {
+	{ /* HDMI Playback i/f */
+		.name = "HDMI Playback",
+		.stream_name = "i2s_Dai",
+		.cpu_dai_name = "samsung-i2s.0",
+		.codec_dai_name = "exynos-hdmi-audio-dai",
+		.platform_name = "samsung-i2s.0",
+		.codec_name = "exynos-hdmi-audio-codec",
+		.ops = &hdmi_ops,
+	},
+};
+
+static struct snd_soc_card hdmi = {
+	.name = "HDMI-AUDIO",
+	.owner = THIS_MODULE,
+	.dai_link = hdmi_dai,
+	.num_links = ARRAY_SIZE(hdmi_dai),
+};
+
+static int hdmi_audio_probe(struct platform_device *pdev)
+{
+	int ret;
+	struct snd_soc_card *card = &hdmi;
+
+	card->dev = &pdev->dev;
+	dev_dbg(&pdev->dev, "[%d][%s]\n", __LINE__, __func__);
+
+	ret = snd_soc_register_card(card);
+	if (ret)
+		dev_err(&pdev->dev, "snd_soc_register_card() failed:%d\n", ret);
+
+	return ret;
+}
+
+static int hdmi_audio_remove(struct platform_device *pdev)
+{
+	struct snd_soc_card *card = platform_get_drvdata(pdev);
+
+	snd_soc_unregister_card(card);
+
+	return 0;
+}
+
+static struct platform_driver hdmi_audio_driver = {
+	.driver		= {
+		.name	= "exynos-hdmi-audio",
+		.owner	= THIS_MODULE,
+		.pm	= &snd_soc_pm_ops,
+	},
+	.probe		= hdmi_audio_probe,
+	.remove		= hdmi_audio_remove,
+};
+
+static int __init hdmi_audio_init(void)
+{
+	int ret;
+
+	ret = platform_driver_register(&hdmi_audio_driver);
+	if (ret < 0)
+		return -EINVAL;
+
+	exynos_hdmi_audio_pdev = platform_device_register_simple
+		("exynos-hdmi-audio", -1, NULL, 0);
+	if (IS_ERR_OR_NULL(exynos_hdmi_audio_pdev)) {
+		ret = PTR_ERR(exynos_hdmi_audio_pdev);
+		platform_driver_unregister(&hdmi_audio_driver);
+		return ret;
+	}
+
+	return 0;
+}
+
+static void __exit hdmi_audio_exit(void)
+{
+	platform_driver_unregister(&hdmi_audio_driver);
+	platform_device_unregister(exynos_hdmi_audio_pdev);
+}
+
+module_init(hdmi_audio_init);
+module_exit(hdmi_audio_exit);
+
+MODULE_AUTHOR("Rahul Sharma <rahul.sharma@samsung.com>");
+MODULE_DESCRIPTION("ALSA SoC HDMI AUDIO Card");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:hdmi-audio");
-- 
1.8.0

