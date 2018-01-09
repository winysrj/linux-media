Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:43986 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752097AbeAIO0k (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 9 Jan 2018 09:26:40 -0500
Received: by mail-qt0-f194.google.com with SMTP id s3so2013403qtb.10
        for <linux-media@vger.kernel.org>; Tue, 09 Jan 2018 06:26:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180109135858.1964-1-sakari.ailus@linux.intel.com>
References: <20180109135858.1964-1-sakari.ailus@linux.intel.com>
From: Arnd Bergmann <arnd@arndb.de>
Date: Tue, 9 Jan 2018 15:26:38 +0100
Message-ID: <CAK8P3a0otMJjeJi3RGyyCq73FdSfEUZvGybytGYJWOJfRd8qnQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] media: entity: Add a nop variant of media_entity_cleanupr
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Wenyou Yang <wenyou.yang@microchip.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Pavel Machek <pavel@ucw.cz>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jan 9, 2018 at 2:58 PM, Sakari Ailus
<sakari.ailus@linux.intel.com> wrote:
> Add nop variant of media_entity_cleanup. This allows calling
> media_entity_cleanup whether or not Media controller is enabled,
> simplifying driver code.
>
> Also drop #ifdefs on a few drivers around media_entity_cleanup() and drop
> the extra semicolon from media_entity_cleanup prototype.
>
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
> Hi Arnd,
>
> I thought about doing something similar with media_entity_pads_init which is
> equally commonly used in drivers that support MC/non-MC cases. The trouble
> with that is that the drivers set up the struct first before calling
> media_entity_pads_init, requiring the #ifdefs in any case. So the benefit
> would be questionable at least. So just media_entity_cleanup this time.

Looks good overall, just two thoughts:

> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> index d7a669058b5e..a732af1dbba0 100644
> --- a/include/media/media-entity.h
> +++ b/include/media/media-entity.h
> @@ -634,7 +634,11 @@ int media_entity_pads_init(struct media_entity *entity, u16 num_pads,
>   * This function must be called during the cleanup phase after unregistering
>   * the entity (currently, it does nothing).
>   */
> -static inline void media_entity_cleanup(struct media_entity *entity) {};
> +#if IS_ENABLED(CONFIG_MEDIA_CONTROLLER)
> +static inline void media_entity_cleanup(struct media_entity *entity) {}
> +#else
> +#define media_entity_cleanup(entity) do { } while (false)
> +#endif

This might cause a harmless warning about an unused variable in case
we have a driver that does:

 void f(struct i2c_client *client)
{
        struct v4l2_subdev *sd = to_subdev(client);
        media_entity_cleanup(sd);
}

None of the drivers you changed would have an unused variable after
your change (otherwise they would already have it before your change),
so it's probably fine.

and second, I'm trying the patch below on top of yours now, will
see how far that gets us ;-)

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 03cf3a1a1e06..6421da7cb58a 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -310,14 +310,14 @@ config VIDEO_ML86V7667

 config VIDEO_AD5820
        tristate "AD5820 lens voice coil support"
-       depends on I2C && VIDEO_V4L2 && MEDIA_CONTROLLER
+       depends on I2C && VIDEO_V4L2
        ---help---
          This is a driver for the AD5820 camera lens voice coil.
          It is used for example in Nokia N900 (RX-51).

 config VIDEO_DW9714
        tristate "DW9714 lens voice coil support"
-       depends on I2C && VIDEO_V4L2 && MEDIA_CONTROLLER
+       depends on I2C && VIDEO_V4L2
        depends on VIDEO_V4L2_SUBDEV_API
        ---help---
          This is a driver for the DW9714 camera lens voice coil.
@@ -636,7 +636,6 @@ config VIDEO_OV5670
        tristate "OmniVision OV5670 sensor support"
        depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
        depends on MEDIA_CAMERA_SUPPORT
-       depends on MEDIA_CONTROLLER
        select V4L2_FWNODE
        ---help---
          This is a Video4Linux2 sensor-level driver for the OmniVision
@@ -667,7 +666,7 @@ config VIDEO_OV7670

 config VIDEO_OV7740
        tristate "OmniVision OV7740 sensor support"
-       depends on I2C && VIDEO_V4L2 && MEDIA_CONTROLLER
+       depends on I2C && VIDEO_V4L2
        depends on MEDIA_CAMERA_SUPPORT
        ---help---
          This is a Video4Linux2 sensor-level driver for the OmniVision
@@ -815,7 +814,7 @@ comment "Flash devices"

 config VIDEO_ADP1653
        tristate "ADP1653 flash support"
-       depends on I2C && VIDEO_V4L2 && MEDIA_CONTROLLER
+       depends on I2C && VIDEO_V4L2
        depends on MEDIA_CAMERA_SUPPORT
        ---help---
          This is a driver for the ADP1653 flash controller. It is used for
@@ -823,7 +822,7 @@ config VIDEO_ADP1653

 config VIDEO_LM3560
        tristate "LM3560 dual flash driver support"
-       depends on I2C && VIDEO_V4L2 && MEDIA_CONTROLLER
+       depends on I2C && VIDEO_V4L2
        depends on MEDIA_CAMERA_SUPPORT
        select REGMAP_I2C
        ---help---
@@ -832,7 +831,7 @@ config VIDEO_LM3560

 config VIDEO_LM3646
        tristate "LM3646 dual flash driver support"
-       depends on I2C && VIDEO_V4L2 && MEDIA_CONTROLLER
+       depends on I2C && VIDEO_V4L2
        depends on MEDIA_CAMERA_SUPPORT
        select REGMAP_I2C
        ---help---


       Arnd
