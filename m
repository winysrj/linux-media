Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f67.google.com ([209.85.215.67]:63375 "EHLO
	mail-la0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523Ab3AKUuI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Jan 2013 15:50:08 -0500
Received: by mail-la0-f67.google.com with SMTP id fn20so628540lab.6
        for <linux-media@vger.kernel.org>; Fri, 11 Jan 2013 12:50:05 -0800 (PST)
Received: by mail-la0-f41.google.com with SMTP id em20so2162247lab.28
        for <linux-media@vger.kernel.org>; Fri, 11 Jan 2013 12:00:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1357900540-19490-1-git-send-email-l.krishna@samsung.com>
References: <1357900540-19490-1-git-send-email-l.krishna@samsung.com>
From: Sean Paul <seanpaul@chromium.org>
Date: Fri, 11 Jan 2013 15:00:18 -0500
Message-ID: <CAOw6vbLRYsmzg0YDeO9kLfxL1chr8dX6u+xdqy=YUbXyJ5kXBg@mail.gmail.com>
Subject: Re: [PATCH] [RFC] video: exynos dp: Making Exynos DP Compliant with CDF
To: Leela Krishna Amudala <l.krishna@samsung.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	tomi.valkeinen@ti.com, laurent.pinchart@ideasonboard.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jan 11, 2013 at 5:35 AM, Leela Krishna Amudala
<l.krishna@samsung.com> wrote:
> The Exynos DP transmitter is treated as an end entity in the display pipeline
> and made this RFC patch compliant with CDF.
>
> Any suggestions are welcome.
>

A few comments below. It's hard to get too much of an appreciation for
what you're trying to do since a bunch of the interesting parts are
stubbed out.

> Signed-off-by: Leela Krishna Amudala <l.krishna@samsung.com>
> ---
>  drivers/video/display/display-core.c  |  2 +-
>  drivers/video/exynos/exynos_dp_core.c | 88 +++++++++++++++++++++++++++++++++++
>  drivers/video/exynos/exynos_dp_core.h |  6 +++
>  3 files changed, 95 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/video/display/display-core.c b/drivers/video/display/display-core.c
> index 5f8be30..dbad7e9 100644
> --- a/drivers/video/display/display-core.c
> +++ b/drivers/video/display/display-core.c
> @@ -15,7 +15,7 @@
>  #include <linux/list.h>
>  #include <linux/module.h>
>  #include <linux/mutex.h>
> -#include <linux/videomode.h>
> +#include <video/videomode.h>
>
>  #include <video/display.h>
>
> diff --git a/drivers/video/exynos/exynos_dp_core.c b/drivers/video/exynos/exynos_dp_core.c
> index 4ef18e2..0f8de27b 100644
> --- a/drivers/video/exynos/exynos_dp_core.c
> +++ b/drivers/video/exynos/exynos_dp_core.c
> @@ -23,6 +23,9 @@
>  #include <video/exynos_dp.h>
>
>  #include "exynos_dp_core.h"
> +#include <video/videomode.h>
> +#include <video/display.h>
> +#define to_panel(p) container_of(p, struct exynos_dp_device, entity)
>
>  static int exynos_dp_init_dp(struct exynos_dp_device *dp)
>  {
> @@ -1033,6 +1036,81 @@ static void exynos_dp_phy_exit(struct exynos_dp_device *dp)
>  }
>  #endif /* CONFIG_OF */
>
> +static int exynos_dp_power_on(struct exynos_dp_device *dp)
> +{
> +       struct platform_device *pdev = to_platform_device(dp->dev);
> +       struct exynos_dp_platdata *pdata = pdev->dev.platform_data;
> +
> +       if (dp->dev->of_node) {
> +               if (dp->phy_addr)
> +                       exynos_dp_phy_init(dp);
> +       } else {
> +               if (pdata->phy_init)
> +                       pdata->phy_init();
> +       }
> +
> +       clk_prepare_enable(dp->clock);
> +       exynos_dp_init_dp(dp);
> +       enable_irq(dp->irq);
> +
> +       return 0;
> +}
> +
> +static int dp_set_state(struct display_entity *entity,
> +                       enum display_entity_state state)
> +{
> +       struct exynos_dp_device *dp = to_panel(entity);
> +       struct platform_device *pdev = to_platform_device(dp->dev);
> +       int ret = 0;
> +
> +       switch (state) {
> +       case DISPLAY_ENTITY_STATE_OFF:
> +       case DISPLAY_ENTITY_STATE_STANDBY:
> +               ret = exynos_dp_remove(pdev);

This is incorrect, that is the module remove function. It seems like
it works right now since there's nothing permanent happening (like
platform data being freed), but there's no guarantee that this will
remain like that in the future.

IMO, you should factor out the common bits from remove and suspend
into a new function which is called from all three.

> +               break;
> +       case DISPLAY_ENTITY_STATE_ON:
> +               ret = exynos_dp_power_on(dp);
> +               break;
> +       }
> +       return ret;
> +}
> +
> +static int dp_get_modes(struct display_entity *entity,
> +                       const struct videomode **modes)
> +{
> +       /* Rework has to be done here*/
> +       return 1;

Returning 1 here is pretty risky since you didn't actually allocate or
populate a mode. I'm surprised this isn't causing some weird
side-effects for you.

> +}
> +
> +static int dp_get_size(struct display_entity *entity,
> +                       unsigned int *width, unsigned int *height)
> +{
> +       struct exynos_dp_device *dp = to_panel(entity);
> +       struct platform_device *pdev = to_platform_device(dp->dev);
> +       /*getting pdata in older way, rework has to be done  here to
> +         parse it from dt node */
> +       struct exynos_dp_platdata *pdata = pdev->dev.platform_data;
> +
> +       /*Rework has to be done here */
> +       *width = 1280;
> +       *height = 800;
> +       return 0;
> +}
> +
> +static int dp_update(struct display_entity *entity,
> +               void (*callback)(int, void *), void *data)
> +{
> +       /*Rework has to be done here*/
> +       return 0;
> +}
> +
> +static const struct display_entity_control_ops dp_control_ops = {
> +       .set_state = dp_set_state,
> +       .get_modes = dp_get_modes,
> +       .get_size = dp_get_size,
> +       .update = dp_update,
> +};
> +
>  static int exynos_dp_probe(struct platform_device *pdev)
>  {
>         struct resource *res;
> @@ -1111,6 +1189,16 @@ static int exynos_dp_probe(struct platform_device *pdev)
>
>         platform_set_drvdata(pdev, dp);
>
> +       /* setup panel entity */
> +       dp->entity.dev = &pdev->dev;
> +       dp->entity.release = exynos_dp_remove;
> +       dp->entity.ops = &dp_control_ops;
> +
> +       ret = display_entity_register(&dp->entity);
> +       if (ret < 0) {
> +               pr_err("failed to register display entity\n");
> +               return ret;
> +       }
>         return 0;
>  }
>
> diff --git a/drivers/video/exynos/exynos_dp_core.h b/drivers/video/exynos/exynos_dp_core.h
> index 6c567bb..eb18c10 100644
> --- a/drivers/video/exynos/exynos_dp_core.h
> +++ b/drivers/video/exynos/exynos_dp_core.h
> @@ -13,6 +13,8 @@
>  #ifndef _EXYNOS_DP_CORE_H
>  #define _EXYNOS_DP_CORE_H
>
> +#include <video/display.h>
> +
>  enum dp_irq_type {
>         DP_IRQ_TYPE_HP_CABLE_IN,
>         DP_IRQ_TYPE_HP_CABLE_OUT,
> @@ -42,6 +44,7 @@ struct exynos_dp_device {
>         struct video_info       *video_info;
>         struct link_train       link_train;
>         struct work_struct      hotplug_work;
> +       struct display_entity   entity;
>  };
>
>  /* exynos_dp_reg.c */
> @@ -133,6 +136,9 @@ void exynos_dp_config_video_slave_mode(struct exynos_dp_device *dp);
>  void exynos_dp_enable_scrambling(struct exynos_dp_device *dp);
>  void exynos_dp_disable_scrambling(struct exynos_dp_device *dp);
>
> +static int exynos_dp_power_on(struct exynos_dp_device *dp);
> +static int exynos_dp_remove(struct platform_device *pdev);
> +

You can just move the functions around the file as needed and avoid
the forward declaration.

>  /* I2C EDID Chip ID, Slave Address */
>  #define I2C_EDID_DEVICE_ADDR                   0x50
>  #define I2C_E_EDID_DEVICE_ADDR                 0x30
> --
> 1.8.0
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
