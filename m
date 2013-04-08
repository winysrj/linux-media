Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f177.google.com ([209.85.220.177]:46935 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964978Ab3DHPgo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Apr 2013 11:36:44 -0400
Received: by mail-vc0-f177.google.com with SMTP id hr11so1300885vcb.36
        for <linux-media@vger.kernel.org>; Mon, 08 Apr 2013 08:36:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1365418061-23694-3-git-send-email-hverkuil@xs4all.nl>
References: <1365418061-23694-1-git-send-email-hverkuil@xs4all.nl>
	<1365418061-23694-3-git-send-email-hverkuil@xs4all.nl>
Date: Mon, 8 Apr 2013 11:36:44 -0400
Message-ID: <CAC-25o-kM-1De_QQZBrPAqrzvNMRHGygbcZ83Ss=TaKSb3ba2Q@mail.gmail.com>
Subject: Re: [REVIEW PATCH 2/7] radio-si4713: embed struct video_device
 instead of allocating it.
From: "edubezval@gmail.com" <edubezval@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Mon, Apr 8, 2013 at 6:47 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> Also set the v4l2_dev pointer in struct video_device as this was missing.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>


Acked-by: Eduardo Valentin <edubezval@gmail.com>
Tested-by: Eduardo Valentin <edubezval@gmail.com>

Output of v4l2-compliant is the same as in patch 00.

> ---
>  drivers/media/radio/radio-si4713.c |   25 ++++++++-----------------
>  1 file changed, 8 insertions(+), 17 deletions(-)
>
> diff --git a/drivers/media/radio/radio-si4713.c b/drivers/media/radio/radio-si4713.c
> index 320f301..70dc652 100644
> --- a/drivers/media/radio/radio-si4713.c
> +++ b/drivers/media/radio/radio-si4713.c
> @@ -48,7 +48,7 @@ MODULE_ALIAS("platform:radio-si4713");
>  /* Driver state struct */
>  struct radio_si4713_device {
>         struct v4l2_device              v4l2_dev;
> -       struct video_device             *radio_dev;
> +       struct video_device             radio_dev;
>  };
>
>  /* radio_si4713_fops - file operations interface */
> @@ -217,7 +217,7 @@ static struct v4l2_ioctl_ops radio_si4713_ioctl_ops = {
>  static struct video_device radio_si4713_vdev_template = {
>         .fops                   = &radio_si4713_fops,
>         .name                   = "radio-si4713",
> -       .release                = video_device_release,
> +       .release                = video_device_release_empty,
>         .ioctl_ops              = &radio_si4713_ioctl_ops,
>         .vfl_dir                = VFL_DIR_TX,
>  };
> @@ -267,27 +267,18 @@ static int radio_si4713_pdriver_probe(struct platform_device *pdev)
>                 goto put_adapter;
>         }
>
> -       rsdev->radio_dev = video_device_alloc();
> -       if (!rsdev->radio_dev) {
> -               dev_err(&pdev->dev, "Failed to alloc video device.\n");
> -               rval = -ENOMEM;
> -               goto put_adapter;
> -       }
> -
> -       memcpy(rsdev->radio_dev, &radio_si4713_vdev_template,
> -              sizeof(radio_si4713_vdev_template));
> -       video_set_drvdata(rsdev->radio_dev, rsdev);
> -       if (video_register_device(rsdev->radio_dev, VFL_TYPE_RADIO, radio_nr)) {
> +       rsdev->radio_dev = radio_si4713_vdev_template;
> +       rsdev->radio_dev.v4l2_dev = &rsdev->v4l2_dev;
> +       video_set_drvdata(&rsdev->radio_dev, rsdev);
> +       if (video_register_device(&rsdev->radio_dev, VFL_TYPE_RADIO, radio_nr)) {
>                 dev_err(&pdev->dev, "Could not register video device.\n");
>                 rval = -EIO;
> -               goto free_vdev;
> +               goto put_adapter;
>         }
>         dev_info(&pdev->dev, "New device successfully probed\n");
>
>         goto exit;
>
> -free_vdev:
> -       video_device_release(rsdev->radio_dev);
>  put_adapter:
>         i2c_put_adapter(adapter);
>  unregister_v4l2_dev:
> @@ -306,7 +297,7 @@ static int radio_si4713_pdriver_remove(struct platform_device *pdev)
>         struct radio_si4713_device *rsdev;
>
>         rsdev = container_of(v4l2_dev, struct radio_si4713_device, v4l2_dev);
> -       video_unregister_device(rsdev->radio_dev);
> +       video_unregister_device(&rsdev->radio_dev);
>         i2c_put_adapter(client->adapter);
>         v4l2_device_unregister(&rsdev->v4l2_dev);
>
> --
> 1.7.10.4
>



-- 
Eduardo Bezerra Valentin
