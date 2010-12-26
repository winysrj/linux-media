Return-path: <mchehab@gaivota>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:43131 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729Ab0LZKdO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Dec 2010 05:33:14 -0500
Received: by iwn9 with SMTP id 9so7955912iwn.19
        for <linux-media@vger.kernel.org>; Sun, 26 Dec 2010 02:33:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1293105242-16979-1-git-send-email-manjunath.hadli@ti.com>
References: <1293105242-16979-1-git-send-email-manjunath.hadli@ti.com>
Date: Sun, 26 Dec 2010 18:33:12 +0800
Message-ID: <AANLkTimXUpy9hB9dFLixsusQetan6HuHzoX=4yqFRE-b@mail.gmail.com>
Subject: Re: [PATCH v10 2/8] davinci vpbe: VPBE display driver
From: Kaspter Ju <nigh0st3018@gmail.com>
To: Manjunath Hadli <manjunath.hadli@ti.com>
Cc: LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hello,Hadli,

On Thu, Dec 23, 2010 at 7:54 PM, Manjunath Hadli <manjunath.hadli@ti.com> wrote:
> This patch implements the coe functionality of the dislay driver,
> mainly controlling the VENC and other encoders, and acting as
> the one point interface for the man V4L2 driver.This implements
> the cre of each of the V4L2 IOCTLs.
>
> Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> Acked-by: Muralidharan Karicheri <m-karicheri2@ti.com>
> Acked-by: Hans Verkuil <hverkuil@xs4all.nl>
> ---
>  drivers/media/video/davinci/vpbe.c |  836 ++++++++++++++++++++++++++++++++++++
>  include/media/davinci/vpbe.h       |  186 ++++++++
>  2 files changed, 1022 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/video/davinci/vpbe.c
>  create mode 100644 include/media/davinci/vpbe.h
>
> diff --git a/drivers/media/video/davinci/vpbe.c b/drivers/media/video/davinci/vpbe.c
> new file mode 100644
> index 0000000..aa0aac9
> --- /dev/null
> +++ b/drivers/media/video/davinci/vpbe.c

...

> +static __init int vpbe_probe(struct platform_device *pdev)
> +{
> +       struct vpbe_display_config *vpbe_config;
> +       struct vpbe_device *vpbe_dev;
> +
> +       int ret = -EINVAL;
> +
> +       if (NULL == pdev->dev.platform_data) {
> +               v4l2_err(pdev->dev.driver, "Unable to get vpbe config\n");
> +               return -ENODEV;
> +       }
> +
> +       if (pdev->dev.platform_data == NULL) {
> +               v4l2_err(pdev->dev.driver, "No platform data\n");
> +               return -ENODEV;
> +       }

code duplicate?

> +       vpbe_config = pdev->dev.platform_data;
> +
> +       if (!vpbe_config->module_name[0] ||
> +           !vpbe_config->osd.module_name[0] ||
> +           !vpbe_config->venc.module_name[0]) {
> +               v4l2_err(pdev->dev.driver, "vpbe display module names not"
> +                        " defined\n");
> +               return ret;
> +       }
> +
> +       vpbe_dev = kzalloc(sizeof(*vpbe_dev), GFP_KERNEL);
> +       if (vpbe_dev == NULL) {
> +               v4l2_err(pdev->dev.driver, "Unable to allocate memory"
> +                        " for vpbe_device\n");
> +               return -ENOMEM;
> +       }
> +       vpbe_dev->cfg = vpbe_config;
> +       vpbe_dev->ops = vpbe_dev_ops;
> +       vpbe_dev->pdev = &pdev->dev;
> +
> +       if (vpbe_config->outputs->num_modes > 0)
> +               vpbe_dev->current_timings = vpbe_dev->cfg->outputs[0].modes[0];
> +       else
> +               return -ENODEV;
> +
> +       /* set the driver data in platform device */
> +       platform_set_drvdata(pdev, vpbe_dev);
> +       mutex_init(&vpbe_dev->lock);
> +       return 0;
> +}
> +


> _______________________________________________
> Davinci-linux-open-source mailing list
> Davinci-linux-open-source@linux.davincidsp.com
> http://linux.davincidsp.com/mailman/listinfo/davinci-linux-open-source
>

-- 
Kaspter
