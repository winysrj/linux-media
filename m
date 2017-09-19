Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00252a01.pphosted.com ([91.207.212.211]:50592 "EHLO
        mx08-00252a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751001AbdISJuz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Sep 2017 05:50:55 -0400
Received: from pps.filterd (m0102629.ppops.net [127.0.0.1])
        by mx08-00252a01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v8J9nsP4004081
        for <linux-media@vger.kernel.org>; Tue, 19 Sep 2017 10:50:54 +0100
Received: from mail-pf0-f198.google.com (mail-pf0-f198.google.com [209.85.192.198])
        by mx08-00252a01.pphosted.com with ESMTP id 2d0reg1ee0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
        for <linux-media@vger.kernel.org>; Tue, 19 Sep 2017 10:50:53 +0100
Received: by mail-pf0-f198.google.com with SMTP id p87so5058819pfj.4
        for <linux-media@vger.kernel.org>; Tue, 19 Sep 2017 02:50:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87k20vswdv.fsf@anholt.net>
References: <cover.1505140980.git.dave.stevenson@raspberrypi.org>
 <0d4dc119a2ba4917e0fecfe5084425830ec53ccb.1505314390.git.dave.stevenson@raspberrypi.org>
 <87k20vswdv.fsf@anholt.net>
From: Dave Stevenson <dave.stevenson@raspberrypi.org>
Date: Tue, 19 Sep 2017 10:50:50 +0100
Message-ID: <CAAoAYcMbSzr7_rtNke2hDKfp+a-vvP0be7_UhrJEgUCfgpfMtQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] [media] bcm2835-unicam: Driver for CCP2/CSI2
 camera interface
To: Eric Anholt <eric@anholt.net>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        linux-media@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
        devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Eric.

Thanks for the review.

On 18 September 2017 at 19:18, Eric Anholt <eric@anholt.net> wrote:
> Dave Stevenson <dave.stevenson@raspberrypi.org> writes:
>> diff --git a/drivers/media/platform/bcm2835/bcm2835-unicam.c b/drivers/media/platform/bcm2835/bcm2835-unicam.c
>> new file mode 100644
>> index 0000000..5b1adc3
>> --- /dev/null
>> +++ b/drivers/media/platform/bcm2835/bcm2835-unicam.c
>> @@ -0,0 +1,2192 @@
>> +/*
>> + * BCM2835 Unicam capture Driver
>> + *
>> + * Copyright (C) 2017 - Raspberry Pi (Trading) Ltd.
>> + *
>> + * Dave Stevenson <dave.stevenson@raspberrypi.org>
>> + *
>> + * Based on TI am437x driver by Benoit Parrot and Lad, Prabhakar and
>> + * TI CAL camera interface driver by Benoit Parrot.
>> + *
>
> Possible future improvement: this description of the driver is really
> nice and could be turned into kernel-doc.

Documentation?! Surely not :-)
For now I'll leave it as a task for another day.

>> + * There are two camera drivers in the kernel for BCM283x - this one
>> + * and bcm2835-camera (currently in staging).
>> + *
>> + * This driver is purely the kernel control the Unicam peripheral - there
>
> Maybe "This driver directly controls..."?

Will do in v3.

>> + * is no involvement with the VideoCore firmware. Unicam receives CSI-2
>> + * or CCP2 data and writes it into SDRAM. The only processing options are
>> + * to repack Bayer data into an alternate format, and applying windowing
>> + * (currently not implemented).
>> + * It should be possible to connect it to any sensor with a
>> + * suitable output interface and V4L2 subdevice driver.
>> + *
>> + * bcm2835-camera uses with the VideoCore firmware to control the sensor,
>
> "uses the"

Will do in v3.

>> + * Unicam, ISP, and all tuner control loops. Fully processed frames are
>> + * delivered to the driver by the firmware. It only has sensor drivers
>> + * for Omnivision OV5647, and Sony IMX219 sensors.
>> + *
>> + * The two drivers are mutually exclusive for the same Unicam instance.
>> + * The VideoCore firmware checks the device tree configuration during boot.
>> + * If it finds device tree nodes called csi0 or csi1 it will block the
>> + * firmware from accessing the peripheral, and bcm2835-camera will
>> + * not be able to stream data.
>
> Thanks for describing this here!
>
>> +/*
>> + * The peripheral can unpack and repack between several of
>> + * the Bayer raw formats, so any Bayer format can be advertised
>> + * as the same Bayer order in each of the supported bit depths.
>> + * Use lower case to avoid clashing with V4L2_PIX_FMT_SGBRG8
>> + * formats.
>> + */
>> +#define PIX_FMT_ALL_BGGR  v4l2_fourcc('b', 'g', 'g', 'r')
>> +#define PIX_FMT_ALL_RGGB  v4l2_fourcc('r', 'g', 'g', 'b')
>> +#define PIX_FMT_ALL_GBRG  v4l2_fourcc('g', 'b', 'r', 'g')
>> +#define PIX_FMT_ALL_GRBG  v4l2_fourcc('g', 'r', 'b', 'g')
>
> Should thes fourccs be defined in a common v4l2 header, to reserve it
> from clashing with others later?

I'm only using them as flags and probably in a manner that nothing
else is likely to copy, so it seems a little excessive to put them in
a common header.
Perhaps it's better to switch to 0xFFFFFFF0 to 0xFFFFFFF3 or other
value that won't come up as a fourcc under any normal circumstance.
Any thoughts from other people?

> This is really the only question I have about this driver before seeing
> it merged.  As far as me wearing my platform maintainer hat, I'm happy
> with the driver, and my other little notes are optional.
>
>> +static int unicam_probe(struct platform_device *pdev)
>> +{
>> +     struct unicam_cfg *unicam_cfg;
>> +     struct unicam_device *unicam;
>> +     struct v4l2_ctrl_handler *hdl;
>> +     struct resource *res;
>> +     int ret;
>> +
>> +     unicam = devm_kzalloc(&pdev->dev, sizeof(*unicam), GFP_KERNEL);
>> +     if (!unicam)
>> +             return -ENOMEM;
>> +
>> +     unicam->pdev = pdev;
>> +     unicam_cfg = &unicam->cfg;
>> +
>> +     res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +     unicam_cfg->base = devm_ioremap_resource(&pdev->dev, res);
>> +     if (IS_ERR(unicam_cfg->base)) {
>> +             unicam_err(unicam, "Failed to get main io block\n");
>> +             return PTR_ERR(unicam_cfg->base);
>> +     }
>> +
>> +     res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
>> +     unicam_cfg->clk_gate_base = devm_ioremap_resource(&pdev->dev, res);
>> +     if (IS_ERR(unicam_cfg->clk_gate_base)) {
>> +             unicam_err(unicam, "Failed to get 2nd io block\n");
>> +             return PTR_ERR(unicam_cfg->clk_gate_base);
>> +     }
>> +
>> +     unicam->clock = devm_clk_get(&pdev->dev, "lp_clock");
>> +     if (IS_ERR(unicam->clock)) {
>> +             unicam_err(unicam, "Failed to get clock\n");
>> +             return PTR_ERR(unicam->clock);
>> +     }
>> +
>> +     ret = platform_get_irq(pdev, 0);
>> +     if (ret <= 0) {
>> +             dev_err(&pdev->dev, "No IRQ resource\n");
>> +             return -ENODEV;
>> +     }
>> +     unicam_cfg->irq = ret;
>> +
>> +     ret = devm_request_irq(&pdev->dev, unicam_cfg->irq, unicam_isr, 0,
>> +                            "unicam_capture0", unicam);
>
> Looks like there's no need to keep "irq" in the device private struct.

Agreed. I'll remove in v3.

>> +     if (ret) {
>> +             dev_err(&pdev->dev, "Unable to request interrupt\n");
>> +             return -EINVAL;
>> +     }
>> +
>> +     ret = v4l2_device_register(&pdev->dev, &unicam->v4l2_dev);
>> +     if (ret) {
>> +             unicam_err(unicam,
>> +                        "Unable to register v4l2 device.\n");
>> +             return ret;
>> +     }
>> +
>> +     /* Reserve space for the controls */
>> +     hdl = &unicam->ctrl_handler;
>> +     ret = v4l2_ctrl_handler_init(hdl, 16);
>> +     if (ret < 0)
>> +             goto probe_out_v4l2_unregister;
>> +     unicam->v4l2_dev.ctrl_handler = hdl;
>> +
>> +     /* set the driver data in platform device */
>> +     platform_set_drvdata(pdev, unicam);
>> +
>> +     ret = of_unicam_connect_subdevs(unicam);
>> +     if (ret) {
>> +             dev_err(&pdev->dev, "Failed to connect subdevs\n");
>> +             goto free_hdl;
>> +     }
>> +
>> +     /* Enabling module functional clock */
>> +     pm_runtime_enable(&pdev->dev);
>
> I think pm_runtime is only controlling the power domain for the PHY, not
> the clock (which you're handling manually).

You're right. Copy and paste from the driver I'd based this on.
Will correct in v3.

  Dave
