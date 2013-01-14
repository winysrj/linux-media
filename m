Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:62587 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299Ab3ANGEy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jan 2013 01:04:54 -0500
Received: by mail-wg0-f44.google.com with SMTP id dr12so1778073wgb.23
        for <linux-media@vger.kernel.org>; Sun, 13 Jan 2013 22:04:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAK9yfHx=AxQVSzNNuV0hcQjiT0DS_iXY+shuG4GgJEiQGbDr4g@mail.gmail.com>
References: <1358081534-21372-1-git-send-email-rahul.sharma@samsung.com>
	<1358081534-21372-5-git-send-email-rahul.sharma@samsung.com>
	<CAK9yfHx=AxQVSzNNuV0hcQjiT0DS_iXY+shuG4GgJEiQGbDr4g@mail.gmail.com>
Date: Mon, 14 Jan 2013 11:34:52 +0530
Message-ID: <CAPdUM4MjS8zdQbp03A8x91aMJMCSx0-jmBHTPZQW8C6TXMv3FQ@mail.gmail.com>
Subject: Re: [RFC PATCH 4/4] alsa/soc: add hdmi audio codec based on cdf
From: Rahul Sharma <r.sh.open@gmail.com>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Rahul Sharma <rahul.sharma@samsung.com>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	tomi.valkeinen@ti.com, laurent.pinchart@ideasonboard.com,
	inki.dae@samsung.com, joshi@samsung.com,
	alsa-devel@alsa-project.org,
	Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks Sachin,

On Mon, Jan 14, 2013 at 11:13 AM, Sachin Kamat <sachin.kamat@linaro.org> wrote:
> +CC: ALSA mailing list, Mark Brown
>
> On 13 January 2013 18:22, Rahul Sharma <rahul.sharma@samsung.com> wrote:
>> This patch registers hdmi-audio codec to the ALSA framework. This is the second
>> client to the hdmi panel. Once notified by the CDF Core it proceeds towards
>> audio setting and audio control. It also subscribes for hpd notification to
>> implement hpd related audio requirements.
>>
>> Signed-off-by: Rahul Sharma <rahul.sharma@samsung.com>
>> ---
>>  sound/soc/codecs/Kconfig             |   4 +
>>  sound/soc/codecs/Makefile            |   2 +
>>  sound/soc/codecs/exynos_hdmi_audio.c | 307 +++++++++++++++++++++++++++++++++++
>>  3 files changed, 313 insertions(+)
>>  create mode 100644 sound/soc/codecs/exynos_hdmi_audio.c
>>
>> diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
>> index b92759a..93f3f6b 100644
>> --- a/sound/soc/codecs/Kconfig
>> +++ b/sound/soc/codecs/Kconfig
>> @@ -496,3 +496,7 @@ config SND_SOC_ML26124
>>
>>  config SND_SOC_TPA6130A2
>>         tristate
>> +
>> +config SND_SOC_EXYNOS_HDMI_AUDIO
>> +       tristate
>> +       default y
>
> Do you want to enable this by default? Shouldn't this be depending on
> HDMI support?
>

Yes, it should depend on Exynos HDMI support. I will add it in v2.

>> diff --git a/sound/soc/codecs/Makefile b/sound/soc/codecs/Makefile
>> index 9bd4d95..bfe93e6 100644
>> --- a/sound/soc/codecs/Makefile
>> +++ b/sound/soc/codecs/Makefile
>> @@ -112,6 +112,7 @@ snd-soc-wm9705-objs := wm9705.o
>>  snd-soc-wm9712-objs := wm9712.o
>>  snd-soc-wm9713-objs := wm9713.o
>>  snd-soc-wm-hubs-objs := wm_hubs.o
>> +snd-soc-exynos-hdmi-audio-objs := exynos_hdmi_audio.o
>>
>>  # Amp
>>  snd-soc-max9877-objs := max9877.o
>> @@ -230,6 +231,7 @@ obj-$(CONFIG_SND_SOC_WM9705)        += snd-soc-wm9705.o
>>  obj-$(CONFIG_SND_SOC_WM9712)   += snd-soc-wm9712.o
>>  obj-$(CONFIG_SND_SOC_WM9713)   += snd-soc-wm9713.o
>>  obj-$(CONFIG_SND_SOC_WM_HUBS)  += snd-soc-wm-hubs.o
>> +obj-$(CONFIG_SND_SOC_EXYNOS_HDMI_AUDIO)        += snd-soc-exynos-hdmi-audio.o
>>
>>  # Amp
>>  obj-$(CONFIG_SND_SOC_MAX9877)  += snd-soc-max9877.o
>> diff --git a/sound/soc/codecs/exynos_hdmi_audio.c b/sound/soc/codecs/exynos_hdmi_audio.c
>> new file mode 100644
>> index 0000000..50e8564
>> --- /dev/null
>> +++ b/sound/soc/codecs/exynos_hdmi_audio.c
>> @@ -0,0 +1,307 @@
>> +/*
>> + * ALSA SoC codec driver for HDMI audio on Samsung Exynos processors.
>> + * Copyright (C) 2012 Samsung corp.
>
> Copyright (c) 2012 (-13?) Samsung Electronics Co., Ltd.
>

I will correct this.

>
>> + * Author: Rahul Sharma <rahul.sharma@samsung.com>
>> + *
>> + * This program is free software; you can redistribute it and/or
>> + * modify it under the terms of the GNU General Public License
>> + * version 2 as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful, but
>> + * WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
>> + * General Public License for more details.
>> + *
>> + */
>> +#include <linux/module.h>
>> +#include <linux/delay.h>
>> +#include <sound/soc.h>
>> +#include <video/display.h>
>> +#include <video/exynos_hdmi.h>
>> +#include <sound/pcm.h>
>> +#include <sound/pcm_params.h>
>> +#include <linux/of_platform.h>
>> +#include <linux/platform_device.h>
>> +
>> +#undef dev_info
>> +
>> +#define dev_info(dev, format, arg...)          \
>> +       dev_printk(KERN_CRIT, dev, format, ##arg)
>
> You may directly use dev_crit instead of dev_printk.
>

I will clean this in v2.

>> +
>> +static struct snd_soc_codec_driver hdmi_codec;
>> +
>> +/* platform device pointer for eynos hdmi audio device. */
>> +static struct platform_device *exynos_hdmi_audio_pdev;
>> +
>> +struct hdmi_audio_context {
>> +       struct platform_device          *pdev;
>> +       atomic_t                                plugged;
>> +       struct display_entity_audio_params      audio_params;
>> +       struct display_entity           *entity;
>> +       struct display_entity_notifier  notf;
>> +       struct display_event_subscriber subscriber;
>> +};
>> +
>> +static int exynos_hdmi_audio_hw_params(struct snd_pcm_substream *substream,
>> +               struct snd_pcm_hw_params *params,
>> +               struct snd_soc_dai *dai)
>> +{
>> +       struct snd_soc_codec *codec = dai->codec;
>> +       struct hdmi_audio_context *ctx = snd_soc_codec_get_drvdata(codec);
>> +       int ret;
>> +
>> +       dev_info(codec->dev, "[%d] %s\n", __LINE__, __func__);
>
> How about making this a debug message as it does not convey anything useful?
ok.
>
>> +
>> +       ctx->audio_params.type = DISPLAY_ENTITY_AUDIO_I2S;
>> +
>> +       switch (params_channels(params)) {
>> +       case 6:
>> +       case 4:
>> +       case 2:
>> +       case 1:
>> +               ctx->audio_params.channels = params_channels(params);
>> +               break;
>> +       default:
>> +               dev_err(codec->dev, "%d channels not supported\n",
>> +                               params_channels(params));
>> +               return -EINVAL;
>> +       }
>> +
>> +       switch (params_format(params)) {
>> +       case SNDRV_PCM_FORMAT_S8:
>> +               ctx->audio_params.bits_per_sample = 8;
>> +               break;
>> +       case SNDRV_PCM_FORMAT_S16_LE:
>> +               ctx->audio_params.bits_per_sample = 12;
>> +               break;
>> +       case SNDRV_PCM_FORMAT_S24_LE:
>> +               ctx->audio_params.bits_per_sample = 16;
>> +               break;
>> +       default:
>> +               dev_err(codec->dev, "Format(%d) not supported\n",
>> +                               params_format(params));
>> +               return -EINVAL;
>> +       }
>> +
>> +       switch (params_rate(params)) {
>> +       case 32000:
>> +       case 44100:
>> +       case 88200:
>> +       case 176400:
>> +       case 48000:
>> +       case 96000:
>> +       case 192000:
>> +               ctx->audio_params.sf = params_rate(params);
>> +               break;
>> +       default:
>> +               dev_err(codec->dev, "%d Rate supported\n",
>> +                               params_rate(params));
>> +               return -EINVAL;
>> +       }
>> +
>> +       /* checking here to cache audioparms for hpd plug handling */
>> +       if (!atomic_read(&ctx->plugged))
>> +               return -EINVAL;
>> +
>> +       ret =
>> +       display_entity_hdmi_init_audio(ctx->entity, &ctx->audio_params);
>> +       return ret;
>> +}
>> +
>> +static int exynos_hdmi_audio_trigger(struct snd_pcm_substream *substream,
>> +                       int cmd, struct snd_soc_dai *dai)
>> +{
>> +       struct snd_soc_codec *codec = dai->codec;
>> +       struct hdmi_audio_context *ctx = snd_soc_codec_get_drvdata(codec);
>> +       int ret;
>> +
>> +       dev_info(codec->dev, "[%d] %s\n", __LINE__, __func__);
>
> ditto
>
>> +
>> +       /* checking here to cache audioparms for hpd plug handling */
>> +       if (!atomic_read(&ctx->plugged))
>> +               return -EINVAL;
>> +
>> +       switch (cmd) {
>> +       case SNDRV_PCM_TRIGGER_START:
>> +               ret = display_entity_hdmi_set_audiostate(ctx->entity,
>> +                       DISPLAY_ENTITY_AUDIOSTATE_ON);
>> +               if (ret) {
>> +                       dev_err(codec->dev, "audio enable failed.\n");
>> +                       return -EINVAL;
>> +               }
>> +               break;
>> +       case SNDRV_PCM_TRIGGER_STOP:
>> +               ret = display_entity_hdmi_set_audiostate(ctx->entity,
>> +                       DISPLAY_ENTITY_AUDIOSTATE_OFF);
>> +               break;
>> +       default:
>> +               ret = -EINVAL;
>> +               break;
>> +       }
>> +
>> +       return ret;
>> +}
>> +
>> +static const struct snd_soc_dai_ops exynos_hdmi_audio_dai_ops = {
>> +       .hw_params = exynos_hdmi_audio_hw_params,
>> +       .trigger = exynos_hdmi_audio_trigger,
>> +};
>> +
>> +static struct snd_soc_dai_driver hdmi_codec_dai = {
>> +       .name = "exynos-hdmi-audio",
>> +       .playback = {
>> +               .channels_min = 2,
>> +               .channels_max = 8,
>> +               .rates = SNDRV_PCM_RATE_32000 |
>> +                       SNDRV_PCM_RATE_44100 | SNDRV_PCM_RATE_48000 |
>> +                       SNDRV_PCM_RATE_88200 | SNDRV_PCM_RATE_96000 |
>> +                       SNDRV_PCM_RATE_176400 | SNDRV_PCM_RATE_192000,
>> +               .formats = SNDRV_PCM_FMTBIT_S16_LE |
>> +                       SNDRV_PCM_FMTBIT_S24_LE,
>> +       },
>> +       .ops = &exynos_hdmi_audio_dai_ops,
>> +};
>> +
>> +void hdmi_audio_event_notify(struct display_entity *entity,
>> +               enum display_entity_event_type type,
>> +               unsigned int value, void *context)
>> +{
>> +       struct hdmi_audio_context *ctx = (struct hdmi_audio_context *)context;
>> +
>> +       if (type == DISPLAY_ENTITY_HDMI_HOTPLUG) {
>> +               dev_info(&ctx->pdev->dev, "[%d][%s] hpd(%d)\n", __LINE__,
>> +                       __func__, value);
>> +               atomic_set(&ctx->plugged, !!value);
>> +       }
>> +}
>> +
>> +int exynos_hdmi_audio_notification(struct display_entity_notifier *notf,
>> +               struct display_entity *entity, int status)
>> +{
>> +       struct hdmi_audio_context *ctx = container_of(notf,
>> +               struct hdmi_audio_context, notf);
>> +       struct exynos_hdmi_control_ops *exynos_ops =
>> +               (struct exynos_hdmi_control_ops *)entity->private;
>> +       int hpd;
>> +
>> +       if (status != DISPLAY_ENTITY_NOTIFIER_CONNECT && entity)
>> +               return -EINVAL;
>> +
>> +       dev_info(&ctx->pdev->dev, "[%d][%s]\n", __LINE__, __func__);
>> +
>> +       ctx->entity = entity;
>> +
>> +       ctx->subscriber.context = ctx;
>> +       ctx->subscriber.notify = hdmi_audio_event_notify;
>> +
>> +       display_entity_subscribe_event(entity, &ctx->subscriber);
>> +
>> +       exynos_ops->get_hpdstate(entity, &hpd);
>> +       atomic_set(&ctx->plugged, !!hpd);
>> +
>> +       return 0;
>> +}
>> +
>> +static __devinit int hdmi_codec_probe(struct platform_device *pdev)
>
> __devinit is not necessary.

ok. I will correct these.

regards,
Rahul Sharma.


>
> +{
>> +       int ret;
>> +       struct hdmi_audio_context *ctx;
>> +       struct device_node *dev_node;
>> +       struct platform_device *disp_pdev;
>> +
>> +       dev_info(&pdev->dev, "[%d][%s]\n", __LINE__, __func__);
>> +
>> +       ret = snd_soc_register_codec(&pdev->dev, &hdmi_codec,
>> +                       &hdmi_codec_dai, 1);
>> +
>> +       if (ret) {
>> +               dev_err(&pdev->dev, "register_codec failed (%d)\n", ret);
>> +               return ret;
>> +       }
>> +
>> +       ctx = devm_kzalloc(&pdev->dev, sizeof(struct hdmi_audio_context),
>> +                               GFP_KERNEL);
>> +       if (ctx == NULL)
>> +               return -ENOMEM;
>> +
>> +       ctx->pdev = pdev;
>> +       atomic_set(&ctx->plugged, 0);
>> +       platform_set_drvdata(pdev, ctx);
>> +
>> +       dev_node = of_find_compatible_node(NULL, NULL,
>> +                       "samsung,exynos5-hdmi");
>> +       if (!dev_node) {
>> +               dev_err(&pdev->dev, "[%d][%s] dt node not found.\n",
>> +                       __LINE__, __func__);
>> +               return -EINVAL;
>> +       }
>> +
>> +       disp_pdev = of_find_device_by_node(dev_node);
>> +       if (!disp_pdev) {
>> +               dev_err(&pdev->dev, "[ERROR][%d][%s] No pdev\n",
>> +                       __LINE__, __func__);
>> +               return -EINVAL;
>> +       }
>> +
>> +       ctx->notf.dev = &disp_pdev->dev;
>> +       ctx->notf.notify = exynos_hdmi_audio_notification;
>> +
>> +       ret = display_entity_register_notifier(&ctx->notf);
>> +       if (ret) {
>> +               dev_err(&pdev->dev, "[%d][%s] entity registe failed.\n",
>> +                       __LINE__, __func__);
>> +               return -EINVAL;
>> +       }
>> +       return ret;
>> +}
>> +
>> +static __devexit int hdmi_codec_remove(struct platform_device *pdev)
>
> __devexit is not necessary.
>
>
>> +{
>> +       dev_info(&pdev->dev, " %s:%s:%d", __FILE__, __func__, __LINE__);
>> +       mdelay(1000);
>> +
>> +       snd_soc_unregister_codec(&pdev->dev);
>> +       return 0;
>> +}
>> +
>> +static struct platform_driver hdmi_codec_driver = {
>> +       .driver         = {
>> +               .name   = "exynos-hdmi-audio-codec",
>> +               .owner  = THIS_MODULE,
>> +       },
>> +
>> +       .probe          = hdmi_codec_probe,
>> +       .remove         = __devexit_p(hdmi_codec_remove),
>> +};
>> +
>> +static int __init hdmi_codec_init(void)
>> +{
>> +       int ret;
>> +
>> +       ret = platform_driver_register(&hdmi_codec_driver);
>> +       if (ret < 0)
>> +               return -EINVAL;
>> +
>> +       exynos_hdmi_audio_pdev = platform_device_register_simple
>> +               ("exynos-hdmi-audio-codec", -1, NULL, 0);
>> +       if (IS_ERR_OR_NULL(exynos_hdmi_audio_pdev)) {
>> +               ret = PTR_ERR(exynos_hdmi_audio_pdev);
>> +               platform_driver_unregister(&hdmi_codec_driver);
>> +               return ret;
>> +       }
>> +
>> +       return 0;
>> +}
>> +static void __exit hdmi_codec_exit(void)
>> +{
>> +       platform_driver_unregister(&hdmi_codec_driver);
>> +       platform_device_unregister(exynos_hdmi_audio_pdev);
>> +}
>> +
>> +module_init(hdmi_codec_init);
>> +module_exit(hdmi_codec_exit);
>> +
>> +MODULE_AUTHOR("Rahul Sharma <rahul.sharma@samsung.com>");
>> +MODULE_DESCRIPTION("ASoC EXYNOS HDMI codec driver");
>> +MODULE_LICENSE("GPL");
>> +MODULE_ALIAS("platform:" DRV_NAME);
>> --
>> 1.8.0
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
> --
> With warm regards,
> Sachin
