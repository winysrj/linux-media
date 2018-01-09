Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:16988 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756978AbeAIWbt (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 9 Jan 2018 17:31:49 -0500
Date: Wed, 10 Jan 2018 00:31:41 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Wenyou Yang <wenyou.yang@microchip.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 1/1] media: entity: Add a nop variant of
 media_entity_cleanupr
Message-ID: <20180109223141.55p7bv4klcsyqet4@kekkonen.localdomain>
References: <20180109135858.1964-1-sakari.ailus@linux.intel.com>
 <CAK8P3a0otMJjeJi3RGyyCq73FdSfEUZvGybytGYJWOJfRd8qnQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a0otMJjeJi3RGyyCq73FdSfEUZvGybytGYJWOJfRd8qnQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arnd,

On Tue, Jan 09, 2018 at 03:26:38PM +0100, Arnd Bergmann wrote:
> On Tue, Jan 9, 2018 at 2:58 PM, Sakari Ailus
> <sakari.ailus@linux.intel.com> wrote:
> > Add nop variant of media_entity_cleanup. This allows calling
> > media_entity_cleanup whether or not Media controller is enabled,
> > simplifying driver code.
> >
> > Also drop #ifdefs on a few drivers around media_entity_cleanup() and drop
> > the extra semicolon from media_entity_cleanup prototype.
> >
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > ---
> > Hi Arnd,
> >
> > I thought about doing something similar with media_entity_pads_init which is
> > equally commonly used in drivers that support MC/non-MC cases. The trouble
> > with that is that the drivers set up the struct first before calling
> > media_entity_pads_init, requiring the #ifdefs in any case. So the benefit
> > would be questionable at least. So just media_entity_cleanup this time.
> 
> Looks good overall, just two thoughts:
> 
> > diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> > index d7a669058b5e..a732af1dbba0 100644
> > --- a/include/media/media-entity.h
> > +++ b/include/media/media-entity.h
> > @@ -634,7 +634,11 @@ int media_entity_pads_init(struct media_entity *entity, u16 num_pads,
> >   * This function must be called during the cleanup phase after unregistering
> >   * the entity (currently, it does nothing).
> >   */
> > -static inline void media_entity_cleanup(struct media_entity *entity) {};
> > +#if IS_ENABLED(CONFIG_MEDIA_CONTROLLER)
> > +static inline void media_entity_cleanup(struct media_entity *entity) {}
> > +#else
> > +#define media_entity_cleanup(entity) do { } while (false)
> > +#endif
> 
> This might cause a harmless warning about an unused variable in case
> we have a driver that does:
> 
>  void f(struct i2c_client *client)
> {
>         struct v4l2_subdev *sd = to_subdev(client);
>         media_entity_cleanup(sd);

That'd be:

	media_entity_cleanup(&sd->entity);

> }
> 
> None of the drivers you changed would have an unused variable after
> your change (otherwise they would already have it before your change),
> so it's probably fine.

I thought of that, too. There are drivers that define the entity (as in
struct v4l2_subdev) only if CONFIG_MEDIA_CONTROLLER is enabled. As the
entity field isn't there, this won't compile; that's actually why I turned
it into a macro. This should be actually mentioned in the commit message.

I guess that could be changed, too, but the purpose, I believe, is to avoid
wasting memory on things that aren't there. I didn't see compiler warnings
from those drivers by disabling MC either, so presume that should be a
change for better...

> 
> and second, I'm trying the patch below on top of yours now, will
> see how far that gets us ;-)
> 
> diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
> index 03cf3a1a1e06..6421da7cb58a 100644
> --- a/drivers/media/i2c/Kconfig
> +++ b/drivers/media/i2c/Kconfig
> @@ -310,14 +310,14 @@ config VIDEO_ML86V7667
> 
>  config VIDEO_AD5820
>         tristate "AD5820 lens voice coil support"
> -       depends on I2C && VIDEO_V4L2 && MEDIA_CONTROLLER
> +       depends on I2C && VIDEO_V4L2
>         ---help---
>           This is a driver for the AD5820 camera lens voice coil.
>           It is used for example in Nokia N900 (RX-51).
> 
>  config VIDEO_DW9714
>         tristate "DW9714 lens voice coil support"
> -       depends on I2C && VIDEO_V4L2 && MEDIA_CONTROLLER
> +       depends on I2C && VIDEO_V4L2

Both drivers call media_entity_pads_init() unconditionally.

>         depends on VIDEO_V4L2_SUBDEV_API
>         ---help---
>           This is a driver for the DW9714 camera lens voice coil.
> @@ -636,7 +636,6 @@ config VIDEO_OV5670
>         tristate "OmniVision OV5670 sensor support"
>         depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
>         depends on MEDIA_CAMERA_SUPPORT
> -       depends on MEDIA_CONTROLLER

ov5670 does depend on MC at least right now. I guess it might not take much
to make it optional. But it's more than this patch. :-)

>         select V4L2_FWNODE
>         ---help---
>           This is a Video4Linux2 sensor-level driver for the OmniVision
> @@ -667,7 +666,7 @@ config VIDEO_OV7670
> 
>  config VIDEO_OV7740
>         tristate "OmniVision OV7740 sensor support"
> -       depends on I2C && VIDEO_V4L2 && MEDIA_CONTROLLER
> +       depends on I2C && VIDEO_V4L2

Hmm. In here the ov7740 driver doesn't seem to depend on MC.

>         depends on MEDIA_CAMERA_SUPPORT
>         ---help---
>           This is a Video4Linux2 sensor-level driver for the OmniVision
> @@ -815,7 +814,7 @@ comment "Flash devices"
> 
>  config VIDEO_ADP1653
>         tristate "ADP1653 flash support"
> -       depends on I2C && VIDEO_V4L2 && MEDIA_CONTROLLER
> +       depends on I2C && VIDEO_V4L2
>         depends on MEDIA_CAMERA_SUPPORT
>         ---help---
>           This is a driver for the ADP1653 flash controller. It is used for
> @@ -823,7 +822,7 @@ config VIDEO_ADP1653
> 
>  config VIDEO_LM3560
>         tristate "LM3560 dual flash driver support"
> -       depends on I2C && VIDEO_V4L2 && MEDIA_CONTROLLER
> +       depends on I2C && VIDEO_V4L2
>         depends on MEDIA_CAMERA_SUPPORT
>         select REGMAP_I2C
>         ---help---
> @@ -832,7 +831,7 @@ config VIDEO_LM3560
> 
>  config VIDEO_LM3646
>         tristate "LM3646 dual flash driver support"
> -       depends on I2C && VIDEO_V4L2 && MEDIA_CONTROLLER
> +       depends on I2C && VIDEO_V4L2
>         depends on MEDIA_CAMERA_SUPPORT
>         select REGMAP_I2C
>         ---help---

These also call media_entity_pads_init() unconditionally.

How was this tested? :-)

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
