Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f67.google.com ([209.85.213.67]:41921 "EHLO
        mail-vk0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754183AbeD3Wlu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Apr 2018 18:41:50 -0400
Received: by mail-vk0-f67.google.com with SMTP id 131-v6so6096249vkf.8
        for <linux-media@vger.kernel.org>; Mon, 30 Apr 2018 15:41:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180427195430.237342-1-samitolvanen@google.com>
References: <20180427195430.237342-1-samitolvanen@google.com>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 30 Apr 2018 15:41:48 -0700
Message-ID: <CAGXu5jKmzibsYKZnnD6da3Fri4o36wbUQe4-iG1YHt5FLwcH4g@mail.gmail.com>
Subject: Re: [PATCH] media: media-device: fix ioctl function types
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 27, 2018 at 12:54 PM, Sami Tolvanen <samitolvanen@google.com> wrote:
> This change fixes function types for media device ioctls to avoid
> indirect call mismatches with Control-Flow Integrity checking.
>
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>

Thanks for sending these!

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  drivers/media/media-device.c | 21 +++++++++++----------
>  1 file changed, 11 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> index 35e81f7c0d2f..bc5c024906e6 100644
> --- a/drivers/media/media-device.c
> +++ b/drivers/media/media-device.c
> @@ -54,9 +54,10 @@ static int media_device_close(struct file *filp)
>         return 0;
>  }
>
> -static int media_device_get_info(struct media_device *dev,
> -                                struct media_device_info *info)
> +static long media_device_get_info(struct media_device *dev, void *arg)
>  {
> +       struct media_device_info *info = (struct media_device_info *)arg;
> +
>         memset(info, 0, sizeof(*info));
>
>         if (dev->driver_name[0])
> @@ -93,9 +94,9 @@ static struct media_entity *find_entity(struct media_device *mdev, u32 id)
>         return NULL;
>  }
>
> -static long media_device_enum_entities(struct media_device *mdev,
> -                                      struct media_entity_desc *entd)
> +static long media_device_enum_entities(struct media_device *mdev, void *arg)
>  {
> +       struct media_entity_desc *entd = (struct media_entity_desc *)arg;
>         struct media_entity *ent;
>
>         ent = find_entity(mdev, entd->id);
> @@ -146,9 +147,9 @@ static void media_device_kpad_to_upad(const struct media_pad *kpad,
>         upad->flags = kpad->flags;
>  }
>
> -static long media_device_enum_links(struct media_device *mdev,
> -                                   struct media_links_enum *links)
> +static long media_device_enum_links(struct media_device *mdev, void *arg)
>  {
> +       struct media_links_enum *links = (struct media_links_enum *)arg;
>         struct media_entity *entity;
>
>         entity = find_entity(mdev, links->entity);
> @@ -195,9 +196,9 @@ static long media_device_enum_links(struct media_device *mdev,
>         return 0;
>  }
>
> -static long media_device_setup_link(struct media_device *mdev,
> -                                   struct media_link_desc *linkd)
> +static long media_device_setup_link(struct media_device *mdev, void *arg)
>  {
> +       struct media_link_desc *linkd = (struct media_link_desc *)arg;
>         struct media_link *link = NULL;
>         struct media_entity *source;
>         struct media_entity *sink;
> @@ -225,9 +226,9 @@ static long media_device_setup_link(struct media_device *mdev,
>         return __media_entity_setup_link(link, linkd->flags);
>  }
>
> -static long media_device_get_topology(struct media_device *mdev,
> -                                     struct media_v2_topology *topo)
> +static long media_device_get_topology(struct media_device *mdev, void *arg)
>  {
> +       struct media_v2_topology *topo = (struct media_v2_topology *)arg;
>         struct media_entity *entity;
>         struct media_interface *intf;
>         struct media_pad *pad;
> --
> 2.17.0.441.gb46fe60e1d-goog
>



-- 
Kees Cook
Pixel Security
