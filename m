Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f193.google.com ([74.125.82.193]:33767 "EHLO
        mail-ot0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754278AbeAJRAg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 10 Jan 2018 12:00:36 -0500
Received: by mail-ot0-f193.google.com with SMTP id x15so14841184ote.0
        for <linux-media@vger.kernel.org>; Wed, 10 Jan 2018 09:00:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180109223141.55p7bv4klcsyqet4@kekkonen.localdomain>
References: <20180109135858.1964-1-sakari.ailus@linux.intel.com>
 <CAK8P3a0otMJjeJi3RGyyCq73FdSfEUZvGybytGYJWOJfRd8qnQ@mail.gmail.com> <20180109223141.55p7bv4klcsyqet4@kekkonen.localdomain>
From: Arnd Bergmann <arnd@arndb.de>
Date: Wed, 10 Jan 2018 18:00:35 +0100
Message-ID: <CAK8P3a2R0Bhb2MvXsVBN5e0um6yiGY0Ow_9T0ki_N4DNtMCzaA@mail.gmail.com>
Subject: Re: [PATCH 1/1] media: entity: Add a nop variant of media_entity_cleanupr
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Wenyou Yang <wenyou.yang@microchip.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Pavel Machek <pavel@ucw.cz>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jan 9, 2018 at 11:31 PM, Sakari Ailus
<sakari.ailus@linux.intel.com> wrote:

>>         depends on VIDEO_V4L2_SUBDEV_API
>>         ---help---
>>           This is a driver for the DW9714 camera lens voice coil.
>> @@ -636,7 +636,6 @@ config VIDEO_OV5670
>>         tristate "OmniVision OV5670 sensor support"
>>         depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
>>         depends on MEDIA_CAMERA_SUPPORT
>> -       depends on MEDIA_CONTROLLER
>
> ov5670 does depend on MC at least right now. I guess it might not take much
> to make it optional. But it's more than this patch. :-)
>
>>         select V4L2_FWNODE
>>         ---help---
>>           This is a Video4Linux2 sensor-level driver for the OmniVision
>> @@ -667,7 +666,7 @@ config VIDEO_OV7670
>>
>>  config VIDEO_OV7740
>>         tristate "OmniVision OV7740 sensor support"
>> -       depends on I2C && VIDEO_V4L2 && MEDIA_CONTROLLER
>> +       depends on I2C && VIDEO_V4L2
>
> Hmm. In here the ov7740 driver doesn't seem to depend on MC.

Right, this was on top of the earlier patch I sent that you rejected ;-)

>>         depends on MEDIA_CAMERA_SUPPORT
>>         ---help---
>>           This is a Video4Linux2 sensor-level driver for the OmniVision
>> @@ -815,7 +814,7 @@ comment "Flash devices"
>>
>>  config VIDEO_ADP1653
>>         tristate "ADP1653 flash support"
>> -       depends on I2C && VIDEO_V4L2 && MEDIA_CONTROLLER
>> +       depends on I2C && VIDEO_V4L2
>>         depends on MEDIA_CAMERA_SUPPORT
>>         ---help---
>>           This is a driver for the ADP1653 flash controller. It is used for
>> @@ -823,7 +822,7 @@ config VIDEO_ADP1653
>>
>>  config VIDEO_LM3560
>>         tristate "LM3560 dual flash driver support"
>> -       depends on I2C && VIDEO_V4L2 && MEDIA_CONTROLLER
>> +       depends on I2C && VIDEO_V4L2
>>         depends on MEDIA_CAMERA_SUPPORT
>>         select REGMAP_I2C
>>         ---help---

Those two also failed to build

>> @@ -832,7 +831,7 @@ config VIDEO_LM3560
>>
>>  config VIDEO_LM3646
>>         tristate "LM3646 dual flash driver support"
>> -       depends on I2C && VIDEO_V4L2 && MEDIA_CONTROLLER
>> +       depends on I2C && VIDEO_V4L2
>>         depends on MEDIA_CAMERA_SUPPORT
>>         select REGMAP_I2C
>>         ---help---
>
> These also call media_entity_pads_init() unconditionally.
>
> How was this tested? :-)

Not before I sent it, what I meant is that I'd give it a try, blindly applying
the patch to my randconfig build tree to see what breaks.

The result after a day worth of randconfig builds is this one, which
basically matches what you concluded already:

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 03cf3a1a1e06..5d465221fbfa 100644
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
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index d7a669058b5e..3f34a1126bd1 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -636,6 +636,11 @@ int media_entity_pads_init(struct media_entity
*entity, u16 num_pads,
  */
 static inline void media_entity_cleanup(struct media_entity *entity) {};

+#ifndef CONFIG_MEDIA_CONTROLLER
+#define media_entity_pads_init(e, n, p) 0
+#define media_entity_cleanup(e) do { } while (0)
+#endif
+
 /**
  * media_create_pad_link() - creates a link between two entities.
  *

I'll just drop that patch then from my build tree.

         Arnd
