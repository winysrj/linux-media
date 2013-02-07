Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:10348 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757845Ab3BGLx2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Feb 2013 06:53:28 -0500
From: Rahul Sharma <rahul.sharma@samsung.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	alsa-devel@alsa-project.org, linux-fbdev@vger.kernel.org
Cc: tomi.valkeinen@ti.com, laurent.pinchart@ideasonboard.com,
	broonie@opensource.wolfsonmicro.com, inki.dae@samsung.com,
	kyungmin.park@samsung.com, r.sh.open@gmail.com, joshi@samsung.com
Subject: [RFC PATCH v2 4/5] alsa/soc: add hdmi audio codec based on cdf
Date: Thu, 07 Feb 2013 07:12:11 -0500
Message-id: <1360239132-15557-2-git-send-email-rahul.sharma@samsung.com>
In-reply-to: <1360239132-15557-1-git-send-email-rahul.sharma@samsung.com>
References: <1360239132-15557-1-git-send-email-rahul.sharma@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

V2:
- DAPM and JACK control to hdmi codec.

This patch registers hdmi-audio codec to the ALSA framework. This is the second
client to the hdmi panel. Once notified by the CDF Core it proceeds towards
audio setting and audio control. It also subscribes for hpd notification to
implement hpd related audio requirements.

Signed-off-by: Rahul Sharma <rahul.sharma@samsung.com>
---
 sound/soc/codecs/Kconfig             |   3 +
 sound/soc/codecs/Makefile            |   2 +
 sound/soc/codecs/exynos_hdmi_audio.c | 424 +++++++++++++++++++++++++++++++++++
 3 files changed, 429 insertions(+)
 create mode 100644 sound/soc/codecs/exynos_hdmi_audio.c

diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
index 3a84782..d3e0874 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -512,3 +512,6 @@ config SND_SOC_ML26124
 
 config SND_SOC_TPA6130A2
 	tristate
+
+config SND_SOC_EXYNOS_HDMI_CODEC
+	tristate
diff --git a/sound/soc/codecs/Makefile b/sound/soc/codecs/Makefile
index f6e8e36..388da28 100644
--- a/sound/soc/codecs/Makefile
+++ b/sound/soc/codecs/Makefile
@@ -115,6 +115,7 @@ snd-soc-wm9705-objs := wm9705.o
 snd-soc-wm9712-objs := wm9712.o
 snd-soc-wm9713-objs := wm9713.o
 snd-soc-wm-hubs-objs := wm_hubs.o
+snd-soc-exynos-hdmi-audio-objs := exynos_hdmi_audio.o
 
 # Amp
 snd-soc-max9877-objs := max9877.o
@@ -236,6 +237,7 @@ obj-$(CONFIG_SND_SOC_WM9712)	+= snd-soc-wm9712.o
 obj-$(CONFIG_SND_SOC_WM9713)	+= snd-soc-wm9713.o
 obj-$(CONFIG_SND_SOC_WM_ADSP)	+= snd-soc-wm-adsp.o
 obj-$(CONFIG_SND_SOC_WM_HUBS)	+= snd-soc-wm-hubs.o
+obj-$(CONFIG_SND_SOC_EXYNOS_HDMI_CODEC)	+= snd-soc-exynos-hdmi-audio.o
 
 # Amp
 obj-$(CONFIG_SND_SOC_MAX9877)	+= snd-soc-max9877.o
diff --git a/sound/soc/codecs/exynos_hdmi_audio.c b/sound/soc/codecs/exynos_hdmi_audio.c
new file mode 100644
index 0000000..e2cf94c
--- /dev/null
+++ b/sound/soc/codecs/exynos_hdmi_audio.c
@@ -0,0 +1,424 @@
+/*
+ * ALSA SoC codec driver for HDMI audio on Samsung Exynos processors.
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
+#include <linux/module.h>
+#include <linux/delay.h>
+#include <linux/of_platform.h>
+#include <linux/platform_device.h>
+
+#include <sound/soc.h>
+#include <sound/jack.h>
+#include <sound/pcm.h>
+#include <sound/pcm_params.h>
+
+#include <video/display.h>
+#include <video/exynos_hdmi.h>
+
+#define get_ctx(dev) ((struct hdmi_audio_context *)platform_get_drvdata\
+			(to_platform_device((struct device *)dev)))
+
+/* platform device pointer for eynos hdmi audio codec device. */
+static struct platform_device *exynos_hdmi_codec_pdev;
+
+struct hdmi_audio_context {
+	struct platform_device		*pdev;
+	atomic_t			plugged;
+	atomic_t			enabled;
+	struct workqueue_struct		*event_wq;
+	struct delayed_work			hotplug_work;
+	struct display_entity_audio_params	audio_params;
+	struct display_entity		*entity;
+	struct display_entity_notifier	notf;
+	struct display_event_subscriber	subscriber;
+	struct snd_soc_jack			hdmi_jack;
+};
+
+static int exynos_hdmi_audio_hw_params(struct snd_pcm_substream *substream,
+		struct snd_pcm_hw_params *params,
+		struct snd_soc_dai *dai)
+{
+	struct snd_soc_codec *codec = dai->codec;
+	struct hdmi_audio_context *ctx = snd_soc_codec_get_drvdata(codec);
+	int ret;
+
+	dev_dbg(codec->dev, "[%d] %s\n", __LINE__, __func__);
+
+	/* report failure if hdmi sink is unplugged. */
+	if (!atomic_read(&ctx->plugged))
+		return -ENODEV;
+
+	ctx->audio_params.type = DISPLAY_ENTITY_AUDIO_I2S;
+
+	switch (params_channels(params)) {
+	case 6:
+	case 4:
+	case 2:
+	case 1:
+		ctx->audio_params.channels = params_channels(params);
+		break;
+	default:
+		dev_err(codec->dev, "%d channels not supported\n",
+				params_channels(params));
+		return -EINVAL;
+	}
+
+	switch (params_format(params)) {
+	case SNDRV_PCM_FORMAT_S8:
+		ctx->audio_params.bits_per_sample = 8;
+		break;
+	case SNDRV_PCM_FORMAT_S16_LE:
+		ctx->audio_params.bits_per_sample = 12;
+		break;
+	case SNDRV_PCM_FORMAT_S24_LE:
+		ctx->audio_params.bits_per_sample = 16;
+		break;
+	default:
+		dev_err(codec->dev, "Format(%d) not supported\n",
+				params_format(params));
+		return -EINVAL;
+	}
+
+	switch (params_rate(params)) {
+	case 32000:
+	case 44100:
+	case 88200:
+	case 176400:
+	case 48000:
+	case 96000:
+	case 192000:
+		ctx->audio_params.sf = params_rate(params);
+		break;
+	default:
+		dev_err(codec->dev, "%d Rate supported\n",
+				params_rate(params));
+		return -EINVAL;
+	}
+
+	ret =
+	display_entity_hdmi_init_audio(ctx->entity, &ctx->audio_params);
+	if (ret)
+		dev_err(codec->dev, "initaudio failed ret %d\n", ret);
+	return ret;
+}
+
+static int exynos_hdmi_audio_trigger(struct snd_pcm_substream *substream,
+			int cmd, struct snd_soc_dai *dai)
+{
+	struct snd_soc_codec *codec = dai->codec;
+	struct hdmi_audio_context *ctx = snd_soc_codec_get_drvdata(codec);
+	int ret;
+
+	dev_dbg(codec->dev, "[%d] %s\n", __LINE__, __func__);
+
+	/* report failure if hdmi sink is unplugged. */
+	if (!atomic_read(&ctx->plugged))
+		return -EINVAL;
+
+	switch (cmd) {
+	case SNDRV_PCM_TRIGGER_START:
+		/* Don't start if hdmi audio is disabled. return Success. */
+		if (!atomic_read(&ctx->enabled))
+			return 0;
+
+		ret = display_entity_hdmi_set_audiostate(ctx->entity,
+			DISPLAY_ENTITY_AUDIOSTATE_ON);
+		if (ret) {
+			dev_err(codec->dev, "audio enable failed.\n");
+			return -EINVAL;
+		}
+		break;
+	case SNDRV_PCM_TRIGGER_STOP:
+		ret = display_entity_hdmi_set_audiostate(ctx->entity,
+			DISPLAY_ENTITY_AUDIOSTATE_OFF);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	return ret;
+}
+
+static const struct snd_soc_dai_ops exynos_hdmi_audio_dai_ops = {
+	.hw_params = exynos_hdmi_audio_hw_params,
+	.trigger = exynos_hdmi_audio_trigger,
+};
+
+static struct snd_soc_dai_driver hdmi_codec_dai = {
+	.name = "exynos-hdmi-audio-dai",
+	.playback = {
+		.channels_min = 2,
+		.channels_max = 8,
+		.rates = SNDRV_PCM_RATE_32000 |
+			SNDRV_PCM_RATE_44100 | SNDRV_PCM_RATE_48000 |
+			SNDRV_PCM_RATE_88200 | SNDRV_PCM_RATE_96000 |
+			SNDRV_PCM_RATE_176400 | SNDRV_PCM_RATE_192000,
+		.formats = SNDRV_PCM_FMTBIT_S16_LE |
+			SNDRV_PCM_FMTBIT_S24_LE,
+	},
+	.ops = &exynos_hdmi_audio_dai_ops,
+};
+
+void hdmi_audio_event_notify(struct display_entity *entity,
+		enum display_entity_event_type type,
+		unsigned int value, void *context)
+{
+	struct hdmi_audio_context *ctx = (struct hdmi_audio_context *)context;
+
+	if (type == DISPLAY_ENTITY_HDMI_HOTPLUG) {
+		dev_dbg(&ctx->pdev->dev, "[%d][%s] hpd(%d)\n", __LINE__,
+			__func__, value);
+		atomic_set(&ctx->plugged, !!value);
+
+		/* should set audio regs after ip, phy got stable. 5ms suff */
+		queue_delayed_work(ctx->event_wq, &ctx->hotplug_work,
+				msecs_to_jiffies(5));
+	}
+}
+
+static void hotplug_event_handler(struct work_struct *work)
+{
+	struct hdmi_audio_context *ctx = container_of(work,
+		struct hdmi_audio_context, hotplug_work.work);
+
+	if (atomic_read(&ctx->plugged)) {
+		display_entity_hdmi_init_audio(ctx->entity,
+			&ctx->audio_params);
+
+		if (atomic_read(&ctx->enabled))
+			display_entity_hdmi_set_audiostate(ctx->entity,
+				DISPLAY_ENTITY_AUDIOSTATE_ON);
+		else
+			display_entity_hdmi_set_audiostate(ctx->entity,
+				DISPLAY_ENTITY_AUDIOSTATE_OFF);
+	}
+
+	snd_soc_jack_report(&ctx->hdmi_jack,
+			    atomic_read(&ctx->plugged) ? SND_JACK_AVOUT
+			    : 0, SND_JACK_AVOUT);
+}
+
+int exynos_hdmi_audio_notification(struct display_entity_notifier *notf,
+		struct display_entity *entity, int status)
+{
+	struct hdmi_audio_context *ctx = container_of(notf,
+		struct hdmi_audio_context, notf);
+	struct exynos_hdmi_control_ops *exynos_ops =
+		(struct exynos_hdmi_control_ops *)entity->private;
+	int hpd;
+
+	if (status != DISPLAY_ENTITY_NOTIFIER_CONNECT && entity)
+		return -EINVAL;
+
+	dev_dbg(&ctx->pdev->dev, "[%d][%s]\n", __LINE__, __func__);
+
+	ctx->entity = entity;
+
+	ctx->subscriber.context = ctx;
+	ctx->subscriber.notify = hdmi_audio_event_notify;
+
+	display_entity_subscribe_event(entity, &ctx->subscriber);
+
+	exynos_ops->get_hpdstate(entity, &hpd);
+	atomic_set(&ctx->plugged, !!hpd);
+
+	return 0;
+}
+
+static int get_hdmi(struct snd_kcontrol *kcontrol,
+				 struct snd_ctl_elem_value *ucontrol)
+{
+	struct hdmi_audio_context *ctx = get_ctx(kcontrol->private_value);
+
+	if (!ctx) {
+		dev_err(&ctx->pdev->dev, "invalid context.\n");
+		return 0;
+	}
+
+	ucontrol->value.integer.value[0] = atomic_read(&ctx->enabled);
+	return 1;
+}
+
+static int put_hdmi(struct snd_kcontrol *kcontrol,
+				  struct snd_ctl_elem_value *ucontrol)
+{
+	struct hdmi_audio_context *ctx = get_ctx(kcontrol->private_value);
+	int enable = (int)ucontrol->value.integer.value[0];
+
+	if (!ctx) {
+		dev_err(&ctx->pdev->dev, "invalid context.\n");
+		return 0;
+	}
+
+	atomic_set(&ctx->enabled, !!enable);
+
+	if (!atomic_read(&ctx->plugged))
+		return 1;
+	else if (enable)
+		display_entity_hdmi_set_audiostate(ctx->entity,
+			DISPLAY_ENTITY_AUDIOSTATE_ON);
+	else
+		display_entity_hdmi_set_audiostate(ctx->entity,
+			DISPLAY_ENTITY_AUDIOSTATE_OFF);
+
+	return 1;
+}
+
+static struct snd_kcontrol_new hdmi_dapm_controls[] = {
+	SOC_SINGLE_BOOL_EXT("HDMI Playback Switch", 0, get_hdmi, put_hdmi),
+};
+
+static int hdmi_codec_init(struct snd_soc_codec *codec)
+{
+	struct hdmi_audio_context *ctx = get_ctx(codec->dev);
+	int ret;
+
+	ret = snd_soc_jack_new(codec, "HDMI Jack",
+			 SND_JACK_AVOUT, &ctx->hdmi_jack);
+	if (ret) {
+		dev_err(codec->dev, "audio enable failed.\n");
+		return ret;
+	}
+
+	hdmi_dapm_controls[0].private_value = (unsigned long)codec->dev;
+	return 0;
+}
+
+static struct snd_soc_codec_driver hdmi_codec = {
+	.probe	= hdmi_codec_init,
+	.controls = hdmi_dapm_controls,
+	.num_controls = ARRAY_SIZE(hdmi_dapm_controls),
+};
+
+static int hdmi_codec_probe(struct platform_device *pdev)
+{
+	struct hdmi_audio_context *ctx;
+	struct device_node *dev_node;
+	struct platform_device *disp_pdev;
+	int ret;
+
+	dev_dbg(&pdev->dev, "[%d][%s]\n", __LINE__, __func__);
+
+	ret = snd_soc_register_codec(&pdev->dev, &hdmi_codec,
+			&hdmi_codec_dai, 1);
+	if (ret) {
+		dev_err(&pdev->dev, "register_codec failed (%d)\n", ret);
+		return ret;
+	}
+
+	ctx = devm_kzalloc(&pdev->dev, sizeof(struct hdmi_audio_context),
+				GFP_KERNEL);
+	if (ctx == NULL)
+		return -ENOMEM;
+
+	ctx->pdev = pdev;
+	atomic_set(&ctx->enabled, 1);
+	platform_set_drvdata(pdev, ctx);
+
+	/* create workqueue and hotplug work */
+	ctx->event_wq = alloc_workqueue("hdmi-audio-event",
+			WQ_UNBOUND | WQ_NON_REENTRANT, 1);
+	if (ctx->event_wq == NULL) {
+		dev_err(&pdev->dev, "failed to create workqueue\n");
+		ret = -ENOMEM;
+	}
+	INIT_DELAYED_WORK(&ctx->hotplug_work, hotplug_event_handler);
+
+	dev_node = of_find_compatible_node(NULL, NULL,
+			"samsung,exynos5-hdmi");
+	if (!dev_node) {
+		dev_err(&pdev->dev, "[%d][%s] dt node not found.\n",
+				__LINE__, __func__);
+		return -EINVAL;
+	}
+
+	disp_pdev = of_find_device_by_node(dev_node);
+	if (!disp_pdev) {
+		dev_err(&pdev->dev, "[ERROR][%d][%s] No pdev\n",
+				__LINE__, __func__);
+		return -EINVAL;
+	}
+
+	ctx->notf.dev = &disp_pdev->dev;
+	ctx->notf.notify = exynos_hdmi_audio_notification;
+
+	ret = display_entity_register_notifier(&ctx->notf);
+	if (ret) {
+		dev_err(&pdev->dev, "[%d][%s] entity registe failed.\n",
+			__LINE__, __func__);
+		ret = -EINVAL;
+		goto err_workq;
+	}
+
+	return 0;
+
+err_workq:
+	destroy_workqueue(ctx->event_wq);
+	return ret;
+}
+
+static int hdmi_codec_remove(struct platform_device *pdev)
+{
+	struct hdmi_audio_context *ctx = get_ctx(&pdev->dev);
+	dev_dbg(&pdev->dev, "[%d][%s]\n", __LINE__, __func__);
+	mdelay(1000);
+
+	display_entity_register_notifier(&ctx->notf);
+	snd_soc_unregister_codec(&pdev->dev);
+	destroy_workqueue(ctx->event_wq);
+	return 0;
+}
+
+static struct platform_driver hdmi_codec_driver = {
+	.driver		= {
+		.name	= "exynos-hdmi-audio-codec",
+		.owner	= THIS_MODULE,
+	},
+
+	.probe		= hdmi_codec_probe,
+	.remove		= hdmi_codec_remove,
+};
+
+static int __init hdmi_audio_codec_init(void)
+{
+	int ret;
+
+	ret = platform_driver_register(&hdmi_codec_driver);
+	if (ret < 0)
+		return -EINVAL;
+
+	exynos_hdmi_codec_pdev = platform_device_register_simple
+		("exynos-hdmi-audio-codec", -1, NULL, 0);
+	if (IS_ERR_OR_NULL(exynos_hdmi_codec_pdev)) {
+		ret = PTR_ERR(exynos_hdmi_codec_pdev);
+		platform_driver_unregister(&hdmi_codec_driver);
+		return ret;
+	}
+
+	return 0;
+}
+static void __exit hdmi_audio_codec_exit(void)
+{
+	platform_driver_unregister(&hdmi_codec_driver);
+	platform_device_unregister(exynos_hdmi_codec_pdev);
+}
+
+module_init(hdmi_audio_codec_init);
+module_exit(hdmi_audio_codec_exit);
+
+MODULE_AUTHOR("Rahul Sharma <rahul.sharma@samsung.com>");
+MODULE_DESCRIPTION("ASoC EXYNOS HDMI codec driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:exynos-hdmi-codec");
-- 
1.8.0

