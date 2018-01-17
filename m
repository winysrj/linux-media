Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:34161 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752467AbeAQIAU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 17 Jan 2018 03:00:20 -0500
MIME-Version: 1.0
In-Reply-To: <1516146473-18234-1-git-send-email-kieran.bingham@ideasonboard.com>
References: <1516146473-18234-1-git-send-email-kieran.bingham@ideasonboard.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 17 Jan 2018 09:00:19 +0100
Message-ID: <CAMuHMdUsCMqSG5kci9FhAfwvgxgXo5xy=JRtiQbYdESsmVYvPw@mail.gmail.com>
Subject: Re: [PATCH v2] v4l: async: Protect against double notifier registrations
To: Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        =?UTF-8?Q?Niklas_S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

On Wed, Jan 17, 2018 at 12:47 AM, Kieran Bingham
<kieran.bingham@ideasonboard.com> wrote:
> From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>
> It can be easy to attempt to register the same notifier twice
> in mis-handled error cases such as working with -EPROBE_DEFER.
>
> This results in odd kernel crashes where the notifier_list becomes
> corrupted due to adding the same entry twice.
>
> Protect against this so that a developer has some sense of the pending
> failure, and use a WARN_ON to identify the fault.
>
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

Thanks for your patch!

However, I have several comments:
  1. Instead of walking notifier_list (O(n)), can't you just check if
     notifier.list is part of a list or not (O(1))?
  2. Isn't notifier usually (always?) allocated dynamically, so if will be a
     different pointer after a previous -EPROBE_DEFER anyway?
  3. If you enable CONFIG_DEBUG_LIST, it should scream, too.

> --- a/drivers/media/v4l2-core/v4l2-async.c
> +++ b/drivers/media/v4l2-core/v4l2-async.c
> @@ -374,17 +374,26 @@ static int __v4l2_async_notifier_register(struct v4l2_async_notifier *notifier)
>         struct device *dev =
>                 notifier->v4l2_dev ? notifier->v4l2_dev->dev : NULL;
>         struct v4l2_async_subdev *asd;
> +       struct v4l2_async_notifier *n;
>         int ret;
>         int i;
>
>         if (notifier->num_subdevs > V4L2_MAX_SUBDEVS)
>                 return -EINVAL;
>
> +       mutex_lock(&list_lock);
> +
> +       /* Avoid re-registering a notifier. */
> +       list_for_each_entry(n, &notifier_list, list) {
> +               if (WARN_ON(n == notifier)) {
> +                       ret = -EEXIST;
> +                       goto err_unlock;
> +               }
> +       }
> +
>         INIT_LIST_HEAD(&notifier->waiting);
>         INIT_LIST_HEAD(&notifier->done);
>
> -       mutex_lock(&list_lock);
> -
>         for (i = 0; i < notifier->num_subdevs; i++) {
>                 asd = notifier->subdevs[i];

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
