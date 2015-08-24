Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:34687 "EHLO
	mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060AbbHXWNL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Aug 2015 18:13:11 -0400
Received: by iodb91 with SMTP id b91so165254353iod.1
        for <linux-media@vger.kernel.org>; Mon, 24 Aug 2015 15:13:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <428d72ba195018f3371adbd3a56f474aad6659b7.1440359643.git.mchehab@osg.samsung.com>
References: <cover.1440359643.git.mchehab@osg.samsung.com>
	<428d72ba195018f3371adbd3a56f474aad6659b7.1440359643.git.mchehab@osg.samsung.com>
Date: Mon, 24 Aug 2015 16:13:10 -0600
Message-ID: <CAKocOOPhhs7DTW2aBh64WaCMTigWy2TcuSW4fPH8_Wb4m3hENw@mail.gmail.com>
Subject: Re: [PATCH v7 05/44] [media] media: use media_gobj inside entities
From: Shuah Khan <shuahkhan@gmail.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	shuahkh@osg.samsung.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Aug 23, 2015 at 2:17 PM, Mauro Carvalho Chehab
<mchehab@osg.samsung.com> wrote:
> As entities are graph objects, let's embed media_gobj
> on it. That ensures an unique ID for entities that can be
> global along the entire media controller.
>
> For now, we'll keep the already existing entity ID. Such
> field need to be dropped at some point, but for now, let's
> not do this, to avoid needing to review all drivers and
> the userspace apps.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>
> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> index e429605ca2c3..81d6a130efef 100644
> --- a/drivers/media/media-device.c
> +++ b/drivers/media/media-device.c
> @@ -379,7 +379,6 @@ int __must_check __media_device_register(struct media_device *mdev,
>         if (WARN_ON(mdev->dev == NULL || mdev->model[0] == 0))
>                 return -EINVAL;
>
> -       mdev->entity_id = 1;
>         INIT_LIST_HEAD(&mdev->entities);
>         spin_lock_init(&mdev->lock);
>         mutex_init(&mdev->graph_mutex);
> @@ -433,10 +432,8 @@ int __must_check media_device_register_entity(struct media_device *mdev,
>         entity->parent = mdev;
>
>         spin_lock(&mdev->lock);
> -       if (entity->id == 0)
> -               entity->id = mdev->entity_id++;
> -       else
> -               mdev->entity_id = max(entity->id + 1, mdev->entity_id);
> +       /* Initialize media_gobj embedded at the entity */
> +       media_gobj_init(mdev, MEDIA_GRAPH_ENTITY, &entity->graph_obj);
>         list_add_tail(&entity->list, &mdev->entities);
>         spin_unlock(&mdev->lock);
>
> @@ -459,6 +456,7 @@ void media_device_unregister_entity(struct media_entity *entity)
>                 return;
>
>         spin_lock(&mdev->lock);
> +       media_gobj_remove(&entity->graph_obj);
>         list_del(&entity->list);
>         spin_unlock(&mdev->lock);
>         entity->parent = NULL;
> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index 4834172bf6f8..888cb88e19bf 100644
> --- a/drivers/media/media-entity.c
> +++ b/drivers/media/media-entity.c
> @@ -43,7 +43,12 @@ void media_gobj_init(struct media_device *mdev,
>                            enum media_gobj_type type,
>                            struct media_gobj *gobj)
>  {
> -       /* For now, nothing to do */
> +       /* Create a per-type unique object ID */
> +       switch (type) {
> +       case MEDIA_GRAPH_ENTITY:
> +               gobj->id = media_gobj_gen_id(type, ++mdev->entity_id);
> +               break;
> +       }
>  }

Unless there is a reason to split patches 4 and 5, it would make it lot
easier to review if these two patches are combined. I had to go back to
review media_gobj_gen_id(type, ++mdev->entity_id) for me to get a
feel for what is done here.

If combined, there is no need for skeleton media_gobj_init() and then
followed by a second patch that fills it in. It will be easier to follow the
new interface and its use.

thanks,
-- Shuah
