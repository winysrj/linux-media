Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:49534 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab3ACFoO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Jan 2013 00:44:14 -0500
Received: by mail-ob0-f172.google.com with SMTP id za17so13555118obc.31
        for <linux-media@vger.kernel.org>; Wed, 02 Jan 2013 21:44:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1357132642-24588-2-git-send-email-vikas.sajjan@linaro.org>
References: <1357132642-24588-1-git-send-email-vikas.sajjan@linaro.org>
	<1357132642-24588-2-git-send-email-vikas.sajjan@linaro.org>
Date: Thu, 3 Jan 2013 11:14:14 +0530
Message-ID: <CAK9yfHxd3JyzmZcgaj=+RdQzko9sNg7E-AuYdnrbSo7g8KofZg@mail.gmail.com>
Subject: Re: [PATCH 1/2] [RFC] video: exynos mipi dsi: Making Exynos MIPI
 Complaint with CDF
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Vikas C Sajjan <vikas.sajjan@linaro.org>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	inki.dae@samsung.com, laurent.pinchart@ideasonboard.com,
	tomi.valkeinen@ti.com, jesse.barker@linaro.org,
	aditya.ps@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Vikas,

Some nitpicks inline

Subject: s/Complaint/Compliant

On 2 January 2013 18:47, Vikas C Sajjan <vikas.sajjan@linaro.org> wrote:
> From: Vikas Sajjan <vikas.sajjan@linaro.org>
>

Please add some description about this patch here.

> Signed-off-by: Vikas Sajjan <vikas.sajjan@linaro.org>
> ---
>  drivers/video/exynos/exynos_mipi_dsi.c        |   46 ++++++++++++++++++-------
>  drivers/video/exynos/exynos_mipi_dsi_common.c |   22 ++++++++----
>  drivers/video/exynos/exynos_mipi_dsi_common.h |   12 +++----
>  include/video/exynos_mipi_dsim.h              |    5 ++-
>  4 files changed, 56 insertions(+), 29 deletions(-)
>
> diff --git a/drivers/video/exynos/exynos_mipi_dsi.c b/drivers/video/exynos/exynos_mipi_dsi.c
> index 07d70a3..88b2aa9 100644
> --- a/drivers/video/exynos/exynos_mipi_dsi.c
> +++ b/drivers/video/exynos/exynos_mipi_dsi.c
> @@ -32,14 +32,13 @@
>  #include <linux/notifier.h>
>  #include <linux/regulator/consumer.h>
>  #include <linux/pm_runtime.h>
> -
> +#include <video/display.h>
>  #include <video/exynos_mipi_dsim.h>
>
>  #include <plat/fb.h>
>
>  #include "exynos_mipi_dsi_common.h"
>  #include "exynos_mipi_dsi_lowlevel.h"
> -
>  struct mipi_dsim_ddi {
>         int                             bus_id;
>         struct list_head                list;
> @@ -111,12 +110,13 @@ static void exynos_mipi_update_cfg(struct mipi_dsim_device *dsim)
>         exynos_mipi_dsi_stand_by(dsim, 1);
>  }
>
> -static int exynos_mipi_dsi_early_blank_mode(struct mipi_dsim_device *dsim,
> +static int exynos_mipi_dsi_early_blank_mode(struct video_source *video_source,
>                 int power)
>  {
> +       struct mipi_dsim_device *dsim = container_of(video_source,
> +                                       struct mipi_dsim_device, video_source);
>         struct mipi_dsim_lcd_driver *client_drv = dsim->dsim_lcd_drv;
>         struct mipi_dsim_lcd_device *client_dev = dsim->dsim_lcd_dev;
> -
>         switch (power) {
>         case FB_BLANK_POWERDOWN:
>                 if (dsim->suspended)
> @@ -139,12 +139,13 @@ static int exynos_mipi_dsi_early_blank_mode(struct mipi_dsim_device *dsim,
>         return 0;
>  }
>
> -static int exynos_mipi_dsi_blank_mode(struct mipi_dsim_device *dsim, int power)
> +static int exynos_mipi_dsi_blank_mode(struct video_source *video_source, int power)
>  {
> +       struct mipi_dsim_device *dsim = container_of(video_source,
> +                                       struct mipi_dsim_device, video_source);
>         struct platform_device *pdev = to_platform_device(dsim->dev);
>         struct mipi_dsim_lcd_driver *client_drv = dsim->dsim_lcd_drv;
>         struct mipi_dsim_lcd_device *client_dev = dsim->dsim_lcd_dev;
> -
>         switch (power) {
>         case FB_BLANK_UNBLANK:
>                 if (!dsim->suspended)
> @@ -319,12 +320,19 @@ static struct mipi_dsim_ddi *exynos_mipi_dsi_bind_lcd_ddi(
>         return NULL;
>  }
>
> -/* define MIPI-DSI Master operations. */
> -static struct mipi_dsim_master_ops master_ops = {
> -       .cmd_read                       = exynos_mipi_dsi_rd_data,
> -       .cmd_write                      = exynos_mipi_dsi_wr_data,
> -       .get_dsim_frame_done            = exynos_mipi_dsi_get_frame_done_status,
> -       .clear_dsim_frame_done          = exynos_mipi_dsi_clear_frame_done,
>

+static void panel_dsi_release(struct video_source *src)

How about exynos_dsi_panel_release in line with other function names?

> +{
> +       printk("dsi entity release\n");

Please use pr_* function here (instead of printk).

> +}
> +
> +static const struct common_video_source_ops dsi_common_ops = {

Some comments for this place holder would be good.

> +};
> +
> +static const struct dsi_video_source_ops exynos_dsi_ops = {
> +       .dcs_read                       = exynos_mipi_dsi_rd_data,
> +       .dcs_write                      = exynos_mipi_dsi_wr_data,
> +       .get_frame_done                 = exynos_mipi_dsi_get_frame_done_status,
> +       .clear_frame_done               = exynos_mipi_dsi_clear_frame_done,
>         .set_early_blank_mode           = exynos_mipi_dsi_early_blank_mode,
>         .set_blank_mode                 = exynos_mipi_dsi_blank_mode,
>  };
> @@ -362,7 +370,6 @@ static int exynos_mipi_dsi_probe(struct platform_device *pdev)
>         }
>
>         dsim->dsim_config = dsim_config;
> -       dsim->master_ops = &master_ops;
>
>         mutex_init(&dsim->lock);
>
> @@ -463,6 +470,19 @@ static int exynos_mipi_dsi_probe(struct platform_device *pdev)
>
>         dsim->suspended = false;
>
> +       dsim->video_source.dev = &pdev->dev;
> +       dsim->video_source.release = panel_dsi_release;
> +       dsim->video_source.common_ops = &dsi_common_ops;
> +       dsim->video_source.ops.dsi = &exynos_dsi_ops;
> +       dsim->video_source.name = "exynos";

Can't we get this from pdev?

> +
> +       ret = video_source_register(&dsim->video_source);
> +       if (ret < 0) {
> +               printk("dsi entity register failed\n");

  Please use pr_* function here (instead of printk).

> +               goto err_bind;
> +       }
> +       printk("dsi entity registered: %p\n", &dsim->video_source);

ditto.


> +       return 0;
>  done:
>         platform_set_drvdata(pdev, dsim);
>
> diff --git a/drivers/video/exynos/exynos_mipi_dsi_common.c b/drivers/video/exynos/exynos_mipi_dsi_common.c
> index 3cd29a4..e59911e 100644
> --- a/drivers/video/exynos/exynos_mipi_dsi_common.c
> +++ b/drivers/video/exynos/exynos_mipi_dsi_common.c
> @@ -153,11 +153,12 @@ static void exynos_mipi_dsi_long_data_wr(struct mipi_dsim_device *dsim,
>                 }
>         }
>  }
> -
> -int exynos_mipi_dsi_wr_data(struct mipi_dsim_device *dsim, unsigned int data_id,
> -       const unsigned char *data0, unsigned int data_size)
> +int exynos_mipi_dsi_wr_data(struct video_source *video_source, int data_id,
> +       u8 *data0, size_t data_size)
>  {
>         unsigned int check_rx_ack = 0;
> +       struct mipi_dsim_device *dsim = container_of(video_source,
> +                               struct mipi_dsim_device, video_source);
>
>         if (dsim->state == DSIM_STATE_ULPS) {
>                 dev_err(dsim->dev, "state is ULPS.\n");
> @@ -340,12 +341,14 @@ static unsigned int exynos_mipi_dsi_response_size(unsigned int req_size)
>         }
>  }
>
> -int exynos_mipi_dsi_rd_data(struct mipi_dsim_device *dsim, unsigned int data_id,
> -       unsigned int data0, unsigned int req_size, u8 *rx_buf)
> +int exynos_mipi_dsi_rd_data(struct video_source *video_source, int data_id,
> +                       u8 data0, u8 *rx_buf,size_t req_size)
>  {
>         unsigned int rx_data, rcv_pkt, i;
>         u8 response = 0;
>         u16 rxsize;
> +       struct mipi_dsim_device *dsim = container_of(video_source,
> +                               struct mipi_dsim_device, video_source);
>
>         if (dsim->state == DSIM_STATE_ULPS) {
>                 dev_err(dsim->dev, "state is ULPS.\n");
> @@ -843,13 +846,18 @@ int exynos_mipi_dsi_set_data_transfer_mode(struct mipi_dsim_device *dsim,
>         return 0;
>  }
>
> -int exynos_mipi_dsi_get_frame_done_status(struct mipi_dsim_device *dsim)
> +int exynos_mipi_dsi_get_frame_done_status(struct video_source *video_source)
>  {
> +        struct mipi_dsim_device *dsim = container_of(video_source,
> +                               struct mipi_dsim_device, video_source);
> +
>         return _exynos_mipi_dsi_get_frame_done_status(dsim);
>  }
>
> -int exynos_mipi_dsi_clear_frame_done(struct mipi_dsim_device *dsim)
> +int exynos_mipi_dsi_clear_frame_done(struct video_source *video_source)
>  {
> +        struct mipi_dsim_device *dsim = container_of(video_source,
> +                               struct mipi_dsim_device, video_source);
>         _exynos_mipi_dsi_clear_frame_done(dsim);
>
>         return 0;
> diff --git a/drivers/video/exynos/exynos_mipi_dsi_common.h b/drivers/video/exynos/exynos_mipi_dsi_common.h
> index 4125522..cd89154 100644
> --- a/drivers/video/exynos/exynos_mipi_dsi_common.h
> +++ b/drivers/video/exynos/exynos_mipi_dsi_common.h
> @@ -18,10 +18,10 @@
>  static DECLARE_COMPLETION(dsim_rd_comp);
>  static DECLARE_COMPLETION(dsim_wr_comp);
>
> -int exynos_mipi_dsi_wr_data(struct mipi_dsim_device *dsim, unsigned int data_id,
> -       const unsigned char *data0, unsigned int data_size);
> -int exynos_mipi_dsi_rd_data(struct mipi_dsim_device *dsim, unsigned int data_id,
> -       unsigned int data0, unsigned int req_size, u8 *rx_buf);
> +int exynos_mipi_dsi_rd_data(struct video_source *video_source, int data_id,
> +                               u8 data0, u8 *rx_buf,size_t req_size);
> +int exynos_mipi_dsi_wr_data(struct video_source *video_source, int data_id,
> +                               u8 *data0, size_t data_size);
>  irqreturn_t exynos_mipi_dsi_interrupt_handler(int irq, void *dev_id);
>  void exynos_mipi_dsi_init_interrupt(struct mipi_dsim_device *dsim);
>  int exynos_mipi_dsi_init_dsim(struct mipi_dsim_device *dsim);
> @@ -35,8 +35,8 @@ int exynos_mipi_dsi_set_data_transfer_mode(struct mipi_dsim_device *dsim,
>                 unsigned int mode);
>  int exynos_mipi_dsi_enable_frame_done_int(struct mipi_dsim_device *dsim,
>         unsigned int enable);
> -int exynos_mipi_dsi_get_frame_done_status(struct mipi_dsim_device *dsim);
> -int exynos_mipi_dsi_clear_frame_done(struct mipi_dsim_device *dsim);
> +int exynos_mipi_dsi_get_frame_done_status(struct video_source *video_source);
> +int exynos_mipi_dsi_clear_frame_done(struct video_source *video_source);
>
>  extern struct fb_info *registered_fb[FB_MAX] __read_mostly;
>
> diff --git a/include/video/exynos_mipi_dsim.h b/include/video/exynos_mipi_dsim.h
> index 83ce5e6..e50438e 100644
> --- a/include/video/exynos_mipi_dsim.h
> +++ b/include/video/exynos_mipi_dsim.h
> @@ -17,7 +17,7 @@
>
>  #include <linux/device.h>
>  #include <linux/fb.h>
> -
> +#include <video/display.h>
>  #define PANEL_NAME_SIZE                (32)
>
>  /*
> @@ -225,9 +225,8 @@ struct mipi_dsim_device {
>         unsigned int                    irq;
>         void __iomem                    *reg_base;
>         struct mutex                    lock;
> -
> +       struct video_source             video_source;
>         struct mipi_dsim_config         *dsim_config;
> -       struct mipi_dsim_master_ops     *master_ops;
>         struct mipi_dsim_lcd_device     *dsim_lcd_dev;
>         struct mipi_dsim_lcd_driver     *dsim_lcd_drv;
>
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
With warm regards,
Sachin
