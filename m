Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:47468 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759852Ab0FQNXP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jun 2010 09:23:15 -0400
Received: by gxk21 with SMTP id 21so1647298gxk.19
        for <linux-media@vger.kernel.org>; Thu, 17 Jun 2010 06:23:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100617120653.GI5483@bicker>
References: <20100617120653.GI5483@bicker>
Date: Thu, 17 Jun 2010 20:58:20 +0800
Message-ID: <AANLkTil5dcevMnihwru7GS9znlhQDzB2uwFrNI-zYWEz@mail.gmail.com>
Subject: Re: [patch] Staging: tm6000: fix problem in alsa init
From: Bee Hock Goh <beehock@gmail.com>
To: Dan Carpenter <error27@gmail.com>
Cc: linux-media@vger.kernel.org,
	Stefan Ringel <stefan.ringel@arcor.de>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dan,

The lastest codes under the tm6000 branch created by Maruo have no
reference to idx in  tm6000_audio_init.

Also if you use the latest tree, the audio extension is initiated.
Only issue now is that the there is no continuous audio data.

regards,
 Hock.

On Thu, Jun 17, 2010 at 8:06 PM, Dan Carpenter <error27@gmail.com> wrote:
> The problem is that we never passed the "idx" parameter to
> tm6000_audio_init() so it's uninitialized.  In fact, the struct
> tm6000_ops ->init() definition didn't have idx as a parameter.
>
> When I added the parameter to tm6000_ops, I also added a parameter to
> the ->fini() callback.  fini() is just a stub right now and it doesn't
> need idx, but it's better to be symetric.
>
> As I was updating the calls to init() I noticed that there were some
> needless NULL checks.  "dev" doesn't need to be checked because it is
> the list cursor and can never be null.  op->init() doesn't need to be
> checked because we assumed it was non-null in the other function and
> in fact it always is non-null with the current code.  I removed these
> uneeded checks because it made writing this patch slightly simpler.
>
> Signed-off-by: Dan Carpenter <error27@gmail.com>
>
> diff --git a/drivers/staging/tm6000/tm6000-alsa.c b/drivers/staging/tm6000/tm6000-alsa.c
> index ce081cd..94c9f15 100644
> --- a/drivers/staging/tm6000/tm6000-alsa.c
> +++ b/drivers/staging/tm6000/tm6000-alsa.c
> @@ -337,7 +337,7 @@ static int __devinit snd_tm6000_pcm(struct snd_tm6000_card *chip,
>  * Alsa Constructor - Component probe
>  */
>
> -int tm6000_audio_init(struct tm6000_core *dev, int idx)
> +static int tm6000_audio_init(struct tm6000_core *dev, int idx)
>  {
>        struct snd_card         *card;
>        struct snd_tm6000_card  *chip;
> @@ -411,12 +411,12 @@ error:
>        return rc;
>  }
>
> -static int tm6000_audio_fini(struct tm6000_core *dev)
> +static int tm6000_audio_fini(struct tm6000_core *dev, int idx)
>  {
>        return 0;
>  }
>
> -struct tm6000_ops audio_ops = {
> +static struct tm6000_ops audio_ops = {
>        .id     = TM6000_AUDIO,
>        .name   = "TM6000 Audio Extension",
>        .init   = tm6000_audio_init,
> diff --git a/drivers/staging/tm6000/tm6000-core.c b/drivers/staging/tm6000/tm6000-core.c
> index 27f3f55..c71452c 100644
> --- a/drivers/staging/tm6000/tm6000-core.c
> +++ b/drivers/staging/tm6000/tm6000-core.c
> @@ -661,13 +661,14 @@ static DEFINE_MUTEX(tm6000_extension_devlist_lock);
>  int tm6000_register_extension(struct tm6000_ops *ops)
>  {
>        struct tm6000_core *dev = NULL;
> +       int idx = 0;
>
>        mutex_lock(&tm6000_devlist_mutex);
>        mutex_lock(&tm6000_extension_devlist_lock);
>        list_add_tail(&ops->next, &tm6000_extension_devlist);
>        list_for_each_entry(dev, &tm6000_devlist, devlist) {
> -               if (dev)
> -                       ops->init(dev);
> +               ops->init(dev, idx);
> +               idx++;
>        }
>        printk(KERN_INFO "tm6000: Initialized (%s) extension\n", ops->name);
>        mutex_unlock(&tm6000_extension_devlist_lock);
> @@ -679,11 +680,12 @@ EXPORT_SYMBOL(tm6000_register_extension);
>  void tm6000_unregister_extension(struct tm6000_ops *ops)
>  {
>        struct tm6000_core *dev = NULL;
> +       int idx = 0;
>
>        mutex_lock(&tm6000_devlist_mutex);
>        list_for_each_entry(dev, &tm6000_devlist, devlist) {
> -               if (dev)
> -                       ops->fini(dev);
> +               ops->fini(dev, idx);
> +               idx++;
>        }
>
>        mutex_lock(&tm6000_extension_devlist_lock);
> @@ -697,12 +699,13 @@ EXPORT_SYMBOL(tm6000_unregister_extension);
>  void tm6000_init_extension(struct tm6000_core *dev)
>  {
>        struct tm6000_ops *ops = NULL;
> +       int idx = 0;
>
>        mutex_lock(&tm6000_extension_devlist_lock);
>        if (!list_empty(&tm6000_extension_devlist)) {
>                list_for_each_entry(ops, &tm6000_extension_devlist, next) {
> -                       if (ops->init)
> -                               ops->init(dev);
> +                       ops->init(dev, idx);
> +                       idx++;
>                }
>        }
>        mutex_unlock(&tm6000_extension_devlist_lock);
> @@ -711,12 +714,13 @@ void tm6000_init_extension(struct tm6000_core *dev)
>  void tm6000_close_extension(struct tm6000_core *dev)
>  {
>        struct tm6000_ops *ops = NULL;
> +       int idx = 0;
>
>        mutex_lock(&tm6000_extension_devlist_lock);
>        if (!list_empty(&tm6000_extension_devlist)) {
>                list_for_each_entry(ops, &tm6000_extension_devlist, next) {
> -                       if (ops->fini)
> -                               ops->fini(dev);
> +                       ops->fini(dev, idx);
> +                       idx++;
>                }
>        }
>        mutex_unlock(&tm6000_extension_devlist_lock);
> diff --git a/drivers/staging/tm6000/tm6000.h b/drivers/staging/tm6000/tm6000.h
> index 7bbaf26..971a39a 100644
> --- a/drivers/staging/tm6000/tm6000.h
> +++ b/drivers/staging/tm6000/tm6000.h
> @@ -213,8 +213,8 @@ struct tm6000_ops {
>        struct list_head        next;
>        char                    *name;
>        int                     id;
> -       int (*init)(struct tm6000_core *);
> -       int (*fini)(struct tm6000_core *);
> +       int (*init)(struct tm6000_core *, int idx);
> +       int (*fini)(struct tm6000_core *, int idx);
>  };
>
>  struct tm6000_fh {
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
