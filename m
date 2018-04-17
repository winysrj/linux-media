Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:38734 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752427AbeDQEhP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Apr 2018 00:37:15 -0400
Received: by mail-io0-f196.google.com with SMTP id h9so7188939iob.5
        for <linux-media@vger.kernel.org>; Mon, 16 Apr 2018 21:37:15 -0700 (PDT)
Received: from mail-it0-f44.google.com (mail-it0-f44.google.com. [209.85.214.44])
        by smtp.gmail.com with ESMTPSA id 126sm2154271iou.47.2018.04.16.21.37.14
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 16 Apr 2018 21:37:14 -0700 (PDT)
Received: by mail-it0-f44.google.com with SMTP id m134-v6so14271861itb.3
        for <linux-media@vger.kernel.org>; Mon, 16 Apr 2018 21:37:14 -0700 (PDT)
MIME-Version: 1.0
References: <20180409142026.19369-1-hverkuil@xs4all.nl> <20180409142026.19369-26-hverkuil@xs4all.nl>
In-Reply-To: <20180409142026.19369-26-hverkuil@xs4all.nl>
From: Alexandre Courbot <acourbot@chromium.org>
Date: Tue, 17 Apr 2018 04:37:03 +0000
Message-ID: <CAPBb6MUmN3zkwGtWcUdeMAipV+cO6UgiJsYc2HdHGZ6hN-OBLg@mail.gmail.com>
Subject: Re: [RFCv11 PATCH 25/29] media: vim2m: add media device
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Apr 9, 2018 at 11:20 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:

> From: Alexandre Courbot <acourbot@chromium.org>

> Request API requires a media node. Add one to the vim2m driver so we can
> use requests with it.

> This probably needs a bit more work to correctly represent m2m
> hardware in the media topology.

> Signed-off-by: Alexandre Courbot <acourbot@chromium.org>

I don't remember writing this - actually IIRC you came with this patch
initially.

> ---
>   drivers/media/platform/vim2m.c | 43
+++++++++++++++++++++++++++++++++++++-----
>   1 file changed, 38 insertions(+), 5 deletions(-)

> diff --git a/drivers/media/platform/vim2m.c
b/drivers/media/platform/vim2m.c
> index 065483e62db4..ef970434af13 100644
> --- a/drivers/media/platform/vim2m.c
> +++ b/drivers/media/platform/vim2m.c
> @@ -140,6 +140,10 @@ static struct vim2m_fmt *find_format(struct
v4l2_format *f)
>   struct vim2m_dev {
>          struct v4l2_device      v4l2_dev;
>          struct video_device     vfd;
> +#ifdef CONFIG_MEDIA_CONTROLLER
> +       struct media_device     mdev;
> +       struct media_pad        pad[2];
> +#endif

>          atomic_t                num_inst;
>          struct mutex            dev_mutex;
> @@ -1000,11 +1004,6 @@ static int vim2m_probe(struct platform_device
*pdev)
>                  return -ENOMEM;

>          spin_lock_init(&dev->irqlock);
> -
> -       ret = v4l2_device_register(&pdev->dev, &dev->v4l2_dev);
> -       if (ret)
> -               return ret;
> -
>          atomic_set(&dev->num_inst, 0);
>          mutex_init(&dev->dev_mutex);

> @@ -1013,6 +1012,22 @@ static int vim2m_probe(struct platform_device
*pdev)
>          vfd->lock = &dev->dev_mutex;
>          vfd->v4l2_dev = &dev->v4l2_dev;

> +#ifdef CONFIG_MEDIA_CONTROLLER
> +       dev->mdev.dev = &pdev->dev;
> +       strlcpy(dev->mdev.model, "vim2m", sizeof(dev->mdev.model));
> +       media_device_init(&dev->mdev);
> +       dev->v4l2_dev.mdev = &dev->mdev;
> +       dev->pad[0].flags = MEDIA_PAD_FL_SINK;
> +       dev->pad[1].flags = MEDIA_PAD_FL_SOURCE;
> +       ret = media_entity_pads_init(&vfd->entity, 2, dev->pad);
> +       if (ret)
> +               return ret;
> +#endif
> +
> +       ret = v4l2_device_register(&pdev->dev, &dev->v4l2_dev);
> +       if (ret)
> +               goto unreg_media;
> +
>          ret = video_register_device(vfd, VFL_TYPE_GRABBER, 0);
>          if (ret) {
>                  v4l2_err(&dev->v4l2_dev, "Failed to register video
device\n");
> @@ -1034,6 +1049,13 @@ static int vim2m_probe(struct platform_device
*pdev)
>                  goto err_m2m;
>          }

> +#ifdef CONFIG_MEDIA_CONTROLLER
> +       /* Register the media device node */
> +       ret = media_device_register(&dev->mdev);
> +       if (ret)
> +               goto err_m2m;
> +#endif
> +
>          return 0;

>   err_m2m:
> @@ -1041,6 +1063,10 @@ static int vim2m_probe(struct platform_device
*pdev)
>          video_unregister_device(&dev->vfd);
>   unreg_dev:
>          v4l2_device_unregister(&dev->v4l2_dev);
> +unreg_media:
> +#ifdef CONFIG_MEDIA_CONTROLLER
> +       media_device_unregister(&dev->mdev);
> +#endif

>          return ret;
>   }
> @@ -1050,6 +1076,13 @@ static int vim2m_remove(struct platform_device
*pdev)
>          struct vim2m_dev *dev = platform_get_drvdata(pdev);

>          v4l2_info(&dev->v4l2_dev, "Removing " MEM2MEM_NAME);
> +
> +#ifdef CONFIG_MEDIA_CONTROLLER
> +       if (media_devnode_is_registered(dev->mdev.devnode))
> +               media_device_unregister(&dev->mdev);
> +       media_device_cleanup(&dev->mdev);
> +#endif
> +
>          v4l2_m2m_release(dev->m2m_dev);
>          del_timer_sync(&dev->timer);
>          video_unregister_device(&dev->vfd);
> --
> 2.16.3
