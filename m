Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:34887 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751466AbdHPNwy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Aug 2017 09:52:54 -0400
Received: by mail-it0-f67.google.com with SMTP id 76so2423539ith.2
        for <linux-media@vger.kernel.org>; Wed, 16 Aug 2017 06:52:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170816125514.27634-2-sakari.ailus@linux.intel.com>
References: <20170816125440.27534-1-sakari.ailus@linux.intel.com>
 <20170816125514.27634-1-sakari.ailus@linux.intel.com> <20170816125514.27634-2-sakari.ailus@linux.intel.com>
From: Javier Martinez Canillas <javier@dowhile0.org>
Date: Wed, 16 Aug 2017 15:52:52 +0200
Message-ID: <CABxcv=m5TQrctg=vturEte1BBm6yM+V1YjL8ZXL1JcZOsR7SxA@mail.gmail.com>
Subject: Re: [PATCH 2/3] leds: as3645a: Add LED flash class driver
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        linux-leds@vger.kernel.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@iki.fi>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Sakari,

I haven't looked at the driver, but just have a comment about the I2C subsystem.

On Wed, Aug 16, 2017 at 2:55 PM, Sakari Ailus
<sakari.ailus@linux.intel.com> wrote:

[snip]

> +
> +static const struct of_device_id as3645a_of_table[] = {
> +       { .compatible = "ams,as3645a" },
> +       { },
> +};
> +MODULE_DEVICE_TABLE(of, as3645a_of_table);
> +
> +SIMPLE_DEV_PM_OPS(as3645a_pm_ops, as3645a_resume, as3645a_suspend);
> +
> +static struct i2c_driver as3645a_i2c_driver = {
> +       .driver = {
> +               .of_match_table = as3645a_of_table,
> +               .name = AS_NAME,
> +               .pm   = &as3645a_pm_ops,
> +       },
> +       .probe_new      = as3645a_probe,
> +       .remove = as3645a_remove,
> +};
> +
> +module_i2c_driver(as3645a_i2c_driver);
> +

The I2C core is still broken w.r.t reporting a proper MODALIAS for OF
registered devices, it will report a MODALIAS=i2c:as3645a in this
case. So if you build this as a module, autoload won't work.

In theory this will be fixed soon, but for now you should add a
i2c_device_id table and export it with MODULE_DEVICE_TABLE(i2c,...) if
you care about module autoloading.

Best regards,
Javier
