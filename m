Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f176.google.com ([209.85.217.176]:43373 "EHLO
        mail-ua0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752244AbeDLIyu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Apr 2018 04:54:50 -0400
Received: by mail-ua0-f176.google.com with SMTP id u4so2977030uaf.10
        for <linux-media@vger.kernel.org>; Thu, 12 Apr 2018 01:54:50 -0700 (PDT)
Received: from mail-vk0-f41.google.com (mail-vk0-f41.google.com. [209.85.213.41])
        by smtp.gmail.com with ESMTPSA id q70sm1636891vkd.47.2018.04.12.01.54.48
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Apr 2018 01:54:49 -0700 (PDT)
Received: by mail-vk0-f41.google.com with SMTP id n64so2787623vkf.12
        for <linux-media@vger.kernel.org>; Thu, 12 Apr 2018 01:54:48 -0700 (PDT)
MIME-Version: 1.0
References: <20180409142026.19369-1-hverkuil@xs4all.nl> <20180409142026.19369-26-hverkuil@xs4all.nl>
In-Reply-To: <20180409142026.19369-26-hverkuil@xs4all.nl>
From: Tomasz Figa <tfiga@chromium.org>
Date: Thu, 12 Apr 2018 08:54:37 +0000
Message-ID: <CAAFQd5C1_rWnQcUUj55UZq83ub=4SMDQW-+WAU6QdarsW9o7OQ@mail.gmail.com>
Subject: Re: [RFCv11 PATCH 25/29] media: vim2m: add media device
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Alexandre Courbot <acourbot@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Apr 9, 2018 at 11:21 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:

> From: Alexandre Courbot <acourbot@chromium.org>

> Request API requires a media node. Add one to the vim2m driver so we can
> use requests with it.

> This probably needs a bit more work to correctly represent m2m
> hardware in the media topology.
[snip]
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

Hmm, what are these pads linked to?

[snip]
> @@ -1050,6 +1076,13 @@ static int vim2m_remove(struct platform_device
*pdev)
>          struct vim2m_dev *dev = platform_get_drvdata(pdev);

>          v4l2_info(&dev->v4l2_dev, "Removing " MEM2MEM_NAME);
> +
> +#ifdef CONFIG_MEDIA_CONTROLLER
> +       if (media_devnode_is_registered(dev->mdev.devnode))

Do we need to check this? Probe seems to fail if media device fails to
register.

Best regards,
Tomasz
