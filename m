Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f181.google.com ([209.85.213.181]:38335 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbbHYRvg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Aug 2015 13:51:36 -0400
Received: by igfj19 with SMTP id j19so17336379igf.1
        for <linux-media@vger.kernel.org>; Tue, 25 Aug 2015 10:51:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1f0cabf7f3606b7ade2548820a2e03904d32f727.1440359643.git.mchehab@osg.samsung.com>
References: <cover.1440359643.git.mchehab@osg.samsung.com>
	<1f0cabf7f3606b7ade2548820a2e03904d32f727.1440359643.git.mchehab@osg.samsung.com>
Date: Tue, 25 Aug 2015 11:51:35 -0600
Message-ID: <CAKocOOOpv-5XbpZyxwmd+vwpcOgCR6A_g8gAOzBdRhti2iLzOA@mail.gmail.com>
Subject: Re: [PATCH v7 09/44] [media] media: add a debug message to warn about
 gobj creation/removal
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
> It helps to check if the media controller is doing the
> right thing with the object creation and removal.
>
> No extra code/data will be produced if DEBUG or
> CONFIG_DYNAMIC_DEBUG is not enabled.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>
> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index 36d725ec5f3d..6d515e149d7f 100644
> --- a/drivers/media/media-entity.c
> +++ b/drivers/media/media-entity.c
> @@ -27,6 +27,69 @@
>  #include <media/media-device.h>
>
>  /**
> + *  dev_dbg_obj - Prints in debug mode a change on some object
> + *
> + * @event_name:        Name of the event to report. Could be __func__
> + * @gobj:      Pointer to the object
> + *
> + * Enabled only if DEBUG or CONFIG_DYNAMIC_DEBUG. Otherwise, it
> + * won't produce any code.
> + */
> +static inline const char *gobj_type(enum media_gobj_type type)
> +{
> +       switch (type) {
> +       case MEDIA_GRAPH_ENTITY:
> +               return "entity";
> +       case MEDIA_GRAPH_PAD:
> +               return "pad";
> +       case MEDIA_GRAPH_LINK:
> +               return "link";
> +       default:
> +               return "unknown";
> +       }
> +}
> +

Shouldn't the above gobj_type be defined in if defined(DEBUG) || defined
(CONFIG_DYNAMIC_DEBUG) scope? Unless gobj_type() is used from
other places, you will see defined, but not used warning when DEBUG
and CONFIG_DYNAMIC_DEBUG are undefined.

Kind of related, maybe we should be looking into adding trace event
support for media as opposed to dynamic and debug.

thanks,
-- Shuah

> +static void dev_dbg_obj(const char *event_name,  struct media_gobj *gobj)
> +{
> +#if defined(DEBUG) || defined (CONFIG_DYNAMIC_DEBUG)
> +       switch (media_type(gobj)) {
> +       case MEDIA_GRAPH_ENTITY:
> +               dev_dbg(gobj->mdev->dev,
> +                       "%s: id 0x%08x entity#%d: '%s'\n",
> +                       event_name, gobj->id, media_localid(gobj),
> +                       gobj_to_entity(gobj)->name);
> +               break;
> +       case MEDIA_GRAPH_LINK:
> +       {
> +               struct media_link *link = gobj_to_link(gobj);
> +
> +               dev_dbg(gobj->mdev->dev,
> +                       "%s: id 0x%08x link#%d: '%s' %s#%d ==> '%s' %s#%d\n",
> +                       event_name, gobj->id, media_localid(gobj),
> +
> +                       link->source->entity->name,
> +                       gobj_type(media_type(&link->source->graph_obj)),
> +                       media_localid(&link->source->graph_obj),
> +
> +                       link->sink->entity->name,
> +                       gobj_type(media_type(&link->sink->graph_obj)),
> +                       media_localid(&link->sink->graph_obj));
> +               break;
> +       }
> +       case MEDIA_GRAPH_PAD:
> +       {
> +               struct media_pad *pad = gobj_to_pad(gobj);
> +
> +               dev_dbg(gobj->mdev->dev,
> +                       "%s: id 0x%08x pad#%d: '%s':%d\n",
> +                       event_name, gobj->id, media_localid(gobj),
> +                       pad->entity->name, pad->index);
> +       }
> +       }
> +#endif
> +}
> +
> +/**
>   *  media_gobj_init - Initialize a graph object
>   *
>   * @mdev:      Pointer to the media_device that contains the object
> @@ -43,6 +106,8 @@ void media_gobj_init(struct media_device *mdev,
>                            enum media_gobj_type type,
>                            struct media_gobj *gobj)
>  {
> +       gobj->mdev = mdev;
> +
>         /* Create a per-type unique object ID */
>         switch (type) {
>         case MEDIA_GRAPH_ENTITY:
> @@ -55,6 +120,7 @@ void media_gobj_init(struct media_device *mdev,
>                 gobj->id = media_gobj_gen_id(type, ++mdev->link_id);
>                 break;
>         }
> +       dev_dbg_obj(__func__, gobj);
>  }
>
>  /**
> @@ -66,7 +132,7 @@ void media_gobj_init(struct media_device *mdev,
>   */
>  void media_gobj_remove(struct media_gobj *gobj)
>  {
> -       /* For now, nothing to do */
> +       dev_dbg_obj(__func__, gobj);
>  }
>
>  /**
> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> index cd08a96bfbaa..af6646ddf6db 100644
> --- a/include/media/media-entity.h
> +++ b/include/media/media-entity.h
> @@ -61,6 +61,7 @@ enum media_gobj_type {
>   * All objects on the media graph should have this struct embedded
>   */
>  struct media_gobj {
> +       struct media_device     *mdev;
>         u32                     id;
>  };
>
> @@ -192,6 +193,12 @@ struct media_entity_graph {
>  #define gobj_to_entity(gobj) \
>                 container_of(gobj, struct media_entity, graph_obj)
>
> +#define gobj_to_pad(gobj) \
> +               container_of(gobj, struct media_pad, graph_obj)
> +
> +#define gobj_to_link(gobj) \
> +               container_of(gobj, struct media_link, graph_obj)
> +
>  void media_gobj_init(struct media_device *mdev,
>                     enum media_gobj_type type,
>                     struct media_gobj *gobj);
> --
> 2.4.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
