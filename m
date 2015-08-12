Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f177.google.com ([209.85.213.177]:34669 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908AbbHLUpx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Aug 2015 16:45:53 -0400
Received: by igui7 with SMTP id i7so69877538igu.1
        for <linux-media@vger.kernel.org>; Wed, 12 Aug 2015 13:45:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <68d8610deb78010dc1f923b991163f80466c4994.1439410053.git.mchehab@osg.samsung.com>
References: <cover.1439410053.git.mchehab@osg.samsung.com>
	<68d8610deb78010dc1f923b991163f80466c4994.1439410053.git.mchehab@osg.samsung.com>
Date: Wed, 12 Aug 2015 14:45:52 -0600
Message-ID: <CAKocOON1GkPWjvgyCy-GDToSi5JF64RSW8k=D7jNS-pO1M633A@mail.gmail.com>
Subject: Re: [PATCH RFC v3 14/16] media: add a generic function to remove a link
From: Shuah Khan <shuahkhan@gmail.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	shuahkh@osg.samsung.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Aug 12, 2015 at 2:14 PM, Mauro Carvalho Chehab
<mchehab@osg.samsung.com> wrote:
> Removing a link is simple. Yet, better to have a separate
> function for it, as we'll be also sharing it with a
> public API call.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

One thing to think about is whether or not we need some kind of callback
mechanism to alert the entity on the other side of the link and other entities
associated with the media device when a link is removed.

This patch is fine for now and we can enhance it as and when we have the
need for such notifications.

-- Shuah
>
> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index b8991d38c565..f43af2fda306 100644
> --- a/drivers/media/media-entity.c
> +++ b/drivers/media/media-entity.c
> @@ -484,6 +484,12 @@ static struct media_link *__media_create_link(struct media_device *mdev,
>         return link;
>  }
>
> +static void __media_remove_link(struct media_link *link)
> +{
> +       list_del(&link->list);
> +       kfree(link);
> +}
> +
>  static void __media_entity_remove_link(struct media_entity *entity,
>                                        struct media_link *link)
>  {
> @@ -509,11 +515,9 @@ static void __media_entity_remove_link(struct media_entity *entity,
>                         break;
>
>                 /* Remove the remote link */
> -               list_del(&rlink->list);
> -               kfree(rlink);
> +               __media_remove_link(rlink);
>         }
> -       list_del(&link->list);
> -       kfree(link);
> +       __media_remove_link(link);
>  }
>
>  int
> --
> 2.4.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
