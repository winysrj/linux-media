Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:53552 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757839Ab0E0PVM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 May 2010 11:21:12 -0400
Received: by gyg13 with SMTP id 13so48566gyg.19
        for <linux-media@vger.kernel.org>; Thu, 27 May 2010 08:21:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1273508571-16472-2-git-send-email-stefan.ringel@arcor.de>
References: <1273508571-16472-1-git-send-email-stefan.ringel@arcor.de>
	<1273508571-16472-2-git-send-email-stefan.ringel@arcor.de>
Date: Thu, 27 May 2010 23:21:09 +0800
Message-ID: <AANLkTilNAbJzaFSlkmOF8iHYMhccaFrdus1piRYl72qy@mail.gmail.com>
Subject: Re: [PATCH 2/2] tm6000: add extension
From: Bee Hock Goh <beehock@gmail.com>
To: stefan.ringel@arcor.de
Cc: linux-media@vger.kernel.org, mchehab@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Stefan,

Did you have a kernel opps while loading the tm6000-alsa?

regards,
 Hock.

On Tue, May 11, 2010 at 12:22 AM,  <stefan.ringel@arcor.de> wrote:
> From: Stefan Ringel <stefan.ringel@arcor.de>
>
> add extension
> add module init over tm6000 extension
>
>
> Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
> ---
>  drivers/staging/tm6000/tm6000-alsa.c  |   25 +++++++++-
>  drivers/staging/tm6000/tm6000-cards.c |    7 +++
>  drivers/staging/tm6000/tm6000-core.c  |   92 +++++++++++++++++++++++++++++++++
>  drivers/staging/tm6000/tm6000.h       |   23 ++++++++-
>  4 files changed, 145 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/staging/tm6000/tm6000-alsa.c b/drivers/staging/tm6000/tm6000-alsa.c
> index bc89f9d..ce081cd 100644
> --- a/drivers/staging/tm6000/tm6000-alsa.c
> +++ b/drivers/staging/tm6000/tm6000-alsa.c
> @@ -410,5 +410,28 @@ error:
>        snd_card_free(card);
>        return rc;
>  }
> -EXPORT_SYMBOL_GPL(tm6000_audio_init);
>
> +static int tm6000_audio_fini(struct tm6000_core *dev)
> +{
> +       return 0;
> +}
> +
> +struct tm6000_ops audio_ops = {
> +       .id     = TM6000_AUDIO,
> +       .name   = "TM6000 Audio Extension",
> +       .init   = tm6000_audio_init,
> +       .fini   = tm6000_audio_fini,
> +};
> +
> +static int __init tm6000_alsa_register(void)
> +{
> +       return tm6000_register_extension(&audio_ops);
> +}
> +
> +static void __exit tm6000_alsa_unregister(void)
> +{
> +       tm6000_unregister_extension(&audio_ops);
> +}
> +
> +module_init(tm6000_alsa_register);
> +module_exit(tm6000_alsa_unregister);
> diff --git a/drivers/staging/tm6000/tm6000-cards.c b/drivers/staging/tm6000/tm6000-cards.c
> index 9f6160b..33b134b 100644
> --- a/drivers/staging/tm6000/tm6000-cards.c
> +++ b/drivers/staging/tm6000/tm6000-cards.c
> @@ -692,6 +692,10 @@ static int tm6000_init_dev(struct tm6000_core *dev)
>        if (rc < 0)
>                goto err;
>
> +       tm6000_add_into_devlist(dev);
> +
> +       tm6000_init_extension(dev);
> +
>        if (dev->caps.has_dvb) {
>                dev->dvb = kzalloc(sizeof(*(dev->dvb)), GFP_KERNEL);
>                if (!dev->dvb) {
> @@ -931,6 +935,9 @@ static void tm6000_usb_disconnect(struct usb_interface *interface)
>
>        usb_put_dev(dev->udev);
>
> +       tm6000_remove_from_devlist(dev);
> +       tm6000_close_extension(dev);
> +
>        mutex_unlock(&dev->lock);
>        kfree(dev);
>  }
> diff --git a/drivers/staging/tm6000/tm6000-core.c b/drivers/staging/tm6000/tm6000-core.c
> index bfbc53b..1259ae5 100644
> --- a/drivers/staging/tm6000/tm6000-core.c
> +++ b/drivers/staging/tm6000/tm6000-core.c
> @@ -600,3 +600,95 @@ printk("Original value=%d\n",val);
>        return val;
>  }
>  EXPORT_SYMBOL_GPL(tm6000_set_audio_bitrate);
> +
> +static LIST_HEAD(tm6000_devlist);
> +static DEFINE_MUTEX(tm6000_devlist_mutex);
> +
> +/*
> + * tm6000_realease_resource()
> + */
> +
> +void tm6000_remove_from_devlist(struct tm6000_core *dev)
> +{
> +       mutex_lock(&tm6000_devlist_mutex);
> +       list_del(&dev->devlist);
> +       mutex_unlock(&tm6000_devlist_mutex);
> +};
> +
> +void tm6000_add_into_devlist(struct tm6000_core *dev)
> +{
> +       mutex_lock(&tm6000_devlist_mutex);
> +       list_add_tail(&dev->devlist, &tm6000_devlist);
> +       mutex_unlock(&tm6000_devlist_mutex);
> +};
> +
> +/*
> + * Extension interface
> + */
> +
> +static LIST_HEAD(tm6000_extension_devlist);
> +static DEFINE_MUTEX(tm6000_extension_devlist_lock);
> +
> +int tm6000_register_extension(struct tm6000_ops *ops)
> +{
> +       struct tm6000_core *dev = NULL;
> +
> +       mutex_lock(&tm6000_devlist_mutex);
> +       mutex_lock(&tm6000_extension_devlist_lock);
> +       list_add_tail(&ops->next, &tm6000_extension_devlist);
> +       list_for_each_entry(dev, &tm6000_devlist, devlist) {
> +               if (dev)
> +                       ops->init(dev);
> +       }
> +       printk(KERN_INFO "tm6000: Initialized (%s) extension\n", ops->name);
> +       mutex_unlock(&tm6000_extension_devlist_lock);
> +       mutex_unlock(&tm6000_devlist_mutex);
> +       return 0;
> +}
> +EXPORT_SYMBOL(tm6000_register_extension);
> +
> +void tm6000_unregister_extension(struct tm6000_ops *ops)
> +{
> +       struct tm6000_core *dev = NULL;
> +
> +       mutex_lock(&tm6000_devlist_mutex);
> +       list_for_each_entry(dev, &tm6000_devlist, devlist) {
> +               if (dev)
> +                       ops->fini(dev);
> +       }
> +
> +       mutex_lock(&tm6000_extension_devlist_lock);
> +       printk(KERN_INFO "tm6000: Remove (%s) extension\n", ops->name);
> +       list_del(&ops->next);
> +       mutex_unlock(&tm6000_extension_devlist_lock);
> +       mutex_unlock(&tm6000_devlist_mutex);
> +}
> +EXPORT_SYMBOL(tm6000_unregister_extension);
> +
> +void tm6000_init_extension(struct tm6000_core *dev)
> +{
> +       struct tm6000_ops *ops = NULL;
> +
> +       mutex_lock(&tm6000_extension_devlist_lock);
> +       if (!list_empty(&tm6000_extension_devlist)) {
> +               list_for_each_entry(ops, &tm6000_extension_devlist, next) {
> +                       if (ops->init)
> +                               ops->init(dev);
> +               }
> +       }
> +       mutex_unlock(&tm6000_extension_devlist_lock);
> +}
> +
> +void tm6000_close_extension(struct tm6000_core *dev)
> +{
> +       struct tm6000_ops *ops = NULL;
> +
> +       mutex_lock(&tm6000_extension_devlist_lock);
> +       if (!list_empty(&tm6000_extension_devlist)) {
> +               list_for_each_entry(ops, &tm6000_extension_devlist, next) {
> +                       if (ops->fini)
> +                               ops->fini(dev);
> +               }
> +       }
> +       mutex_unlock(&tm6000_extension_devlist_lock);
> +}
> diff --git a/drivers/staging/tm6000/tm6000.h b/drivers/staging/tm6000/tm6000.h
> index 6812d68..79ef72a 100644
> --- a/drivers/staging/tm6000/tm6000.h
> +++ b/drivers/staging/tm6000/tm6000.h
> @@ -168,6 +168,10 @@ struct tm6000_core {
>        struct i2c_adapter              i2c_adap;
>        struct i2c_client               i2c_client;
>
> +
> +       /* extension */
> +       struct list_head                devlist;
> +
>        /* video for linux */
>        int                             users;
>
> @@ -203,6 +207,16 @@ struct tm6000_core {
>        spinlock_t                   slock;
>  };
>
> +#define TM6000_AUDIO 0x10
> +
> +struct tm6000_ops {
> +       struct list_head        next;
> +       char                    *name;
> +       int                     id;
> +       int (*init)(struct tm6000_core *);
> +       int (*fini)(struct tm6000_core *);
> +};
> +
>  struct tm6000_fh {
>        struct tm6000_core           *dev;
>
> @@ -246,6 +260,13 @@ int tm6000_v4l2_unregister(struct tm6000_core *dev);
>  int tm6000_v4l2_exit(void);
>  void tm6000_set_fourcc_format(struct tm6000_core *dev);
>
> +void tm6000_remove_from_devlist(struct tm6000_core *dev);
> +void tm6000_add_into_devlist(struct tm6000_core *dev);
> +int tm6000_register_extension(struct tm6000_ops *ops);
> +void tm6000_unregister_extension(struct tm6000_ops *ops);
> +void tm6000_init_extension(struct tm6000_core *dev);
> +void tm6000_close_extension(struct tm6000_core *dev);
> +
>  /* In tm6000-stds.c */
>  void tm6000_get_std_res(struct tm6000_core *dev);
>  int tm6000_set_standard (struct tm6000_core *dev, v4l2_std_id *norm);
> @@ -275,7 +296,7 @@ unsigned int tm6000_v4l2_poll(struct file *file,
>  int tm6000_queue_init(struct tm6000_core *dev);
>
>  /* In tm6000-alsa.c */
> -int tm6000_audio_init(struct tm6000_core *dev, int idx);
> +/*int tm6000_audio_init(struct tm6000_core *dev, int idx);*/
>
>
>  /* Debug stuff */
> --
> 1.7.0.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
