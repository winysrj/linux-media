Return-path: <linux-media-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:24067 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754753AbZCESDD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Mar 2009 13:03:03 -0500
Received: by yx-out-2324.google.com with SMTP id 8so38830yxm.1
        for <linux-media@vger.kernel.org>; Thu, 05 Mar 2009 10:03:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20090305103930.25b18638@hyperion.delvare>
References: <20090305103930.25b18638@hyperion.delvare>
Date: Thu, 5 Mar 2009 13:03:00 -0500
Message-ID: <412bdbff0903051003o15d4d269s3b05b01a6b06b47a@mail.gmail.com>
Subject: Re: [PATCH] Fix race in infrared polling on rmmod
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: LMML <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Mar 5, 2009 at 4:39 AM, Jean Delvare <khali@linux-fr.org> wrote:
> From: Jean Delvare <khali@linux-fr.org>
> Subject: Fix race in infrared polling on rmmod
>
> The race on rmmod I just fixed in cx88-input affects 3 other drivers.
> Fix these the same way.
>
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> ---
> Note that I do not have any of these devices, so this patch is
> untested. Testers welcome!
>
>  linux/drivers/media/video/em28xx/em28xx-input.c |   25 ++++++++++++++++++-----
>  linux/drivers/media/video/ir-kbd-i2c.c          |   21 ++++++++++++++-----
>  linux/drivers/media/video/saa6588.c             |   25 ++++++++++++++++++-----
>  linux/include/media/ir-kbd-i2c.h                |    4 +++
>  4 files changed, 60 insertions(+), 15 deletions(-)
>
> --- v4l-dvb.orig/linux/drivers/media/video/ir-kbd-i2c.c 2009-03-04 22:16:24.000000000 +0100
> +++ v4l-dvb/linux/drivers/media/video/ir-kbd-i2c.c      2009-03-05 09:28:15.000000000 +0100
> @@ -280,13 +280,13 @@ static void ir_key_poll(struct IR_i2c *i
>        }
>  }
>
> +#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
>  static void ir_timer(unsigned long data)
>  {
>        struct IR_i2c *ir = (struct IR_i2c*)data;
>        schedule_work(&ir->work);
>  }
>
> -#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
>  static void ir_work(void *data)
>  #else
>  static void ir_work(struct work_struct *work)
> @@ -295,7 +295,9 @@ static void ir_work(struct work_struct *
>  #if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
>        struct IR_i2c *ir = data;
>  #else
> -       struct IR_i2c *ir = container_of(work, struct IR_i2c, work);
> +       struct delayed_work *dwork = container_of(work, struct delayed_work,
> +                                                 work);
> +       struct IR_i2c *ir = container_of(dwork, struct IR_i2c, work);
>  #endif
>        int polling_interval = 100;
>
> @@ -305,7 +307,11 @@ static void ir_work(struct work_struct *
>                polling_interval = 50;
>
>        ir_key_poll(ir);
> +#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
>        mod_timer(&ir->timer, jiffies + msecs_to_jiffies(polling_interval));
> +#else
> +       schedule_delayed_work(dwork, msecs_to_jiffies(polling_interval));
> +#endif
>  }
>
>  /* ----------------------------------------------------------------------- */
> @@ -463,13 +469,14 @@ static int ir_attach(struct i2c_adapter
>        /* start polling via eventd */
>  #if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
>        INIT_WORK(&ir->work, ir_work, ir);
> -#else
> -       INIT_WORK(&ir->work, ir_work);
> -#endif
>        init_timer(&ir->timer);
>        ir->timer.function = ir_timer;
>        ir->timer.data     = (unsigned long)ir;
>        schedule_work(&ir->work);
> +#else
> +       INIT_DELAYED_WORK(&ir->work, ir_work);
> +       schedule_delayed_work(&ir->work, msecs_to_jiffies(100));
> +#endif
>
>        return 0;
>
> @@ -486,8 +493,12 @@ static int ir_detach(struct i2c_client *
>        struct IR_i2c *ir = i2c_get_clientdata(client);
>
>        /* kill outstanding polls */
> +#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
>        del_timer_sync(&ir->timer);
>        flush_scheduled_work();
> +#else
> +       cancel_delayed_work_sync(&ir->work);
> +#endif
>
>        /* unregister devices */
>        input_unregister_device(ir->input);
> --- v4l-dvb.orig/linux/include/media/ir-kbd-i2c.h       2009-03-04 22:16:24.000000000 +0100
> +++ v4l-dvb/linux/include/media/ir-kbd-i2c.h    2009-03-05 09:28:30.000000000 +0100
> @@ -14,8 +14,12 @@ struct IR_i2c {
>        /* Used to avoid fast repeating */
>        unsigned char          old;
>
> +#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
>        struct work_struct     work;
>        struct timer_list      timer;
> +#else
> +       struct delayed_work     work;
> +#endif
>        char                   phys[32];
>        int                    (*get_key)(struct IR_i2c*, u32*, u32*);
>  };
> --- v4l-dvb.orig/linux/drivers/media/video/em28xx/em28xx-input.c        2009-03-05 09:14:01.000000000 +0100
> +++ v4l-dvb/linux/drivers/media/video/em28xx/em28xx-input.c     2009-03-05 09:21:57.000000000 +0100
> @@ -69,8 +69,12 @@ struct em28xx_IR {
>
>        /* poll external decoder */
>        int polling;
> +#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 20)
>        struct work_struct work;
>        struct timer_list timer;
> +#else
> +       struct delayed_work work;
> +#endif
>        unsigned int last_toggle:1;
>        unsigned int last_readcount;
>        unsigned int repeat_interval;
> @@ -298,6 +302,7 @@ static void em28xx_ir_handle_key(struct
>        return;
>  }
>
> +#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 20)
>  static void ir_timer(unsigned long data)
>  {
>        struct em28xx_IR *ir = (struct em28xx_IR *)data;
> @@ -305,7 +310,6 @@ static void ir_timer(unsigned long data)
>        schedule_work(&ir->work);
>  }
>
> -#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 20)
>  static void em28xx_ir_work(void *data)
>  #else
>  static void em28xx_ir_work(struct work_struct *work)
> @@ -314,28 +318,39 @@ static void em28xx_ir_work(struct work_s
>  #if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 20)
>        struct em28xx_IR *ir = data;
>  #else
> -       struct em28xx_IR *ir = container_of(work, struct em28xx_IR, work);
> +       struct delayed_work *dwork = container_of(work, struct delayed_work,
> +                                                 work);
> +       struct em28xx_IR *ir = container_of(dwork, struct em28xx_IR, work);
>  #endif
>
>        em28xx_ir_handle_key(ir);
> +#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 20)
>        mod_timer(&ir->timer, jiffies + msecs_to_jiffies(ir->polling));
> +#else
> +       schedule_delayed_work(dwork, msecs_to_jiffies(ir->polling));
> +#endif
>  }
>
>  static void em28xx_ir_start(struct em28xx_IR *ir)
>  {
> -       setup_timer(&ir->timer, ir_timer, (unsigned long)ir);
>  #if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 20)
> +       setup_timer(&ir->timer, ir_timer, (unsigned long)ir);
>        INIT_WORK(&ir->work, em28xx_ir_work, ir);
> +       schedule_work(&ir->work);
>  #else
> -       INIT_WORK(&ir->work, em28xx_ir_work);
> +       INIT_DELAYED_WORK(&ir->work, em28xx_ir_work);
> +       schedule_delayed_work(&ir->work, msecs_to_jiffies(ir->polling));
>  #endif
> -       schedule_work(&ir->work);
>  }
>
>  static void em28xx_ir_stop(struct em28xx_IR *ir)
>  {
> +#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 20)
>        del_timer_sync(&ir->timer);
>        flush_scheduled_work();
> +#else
> +       cancel_delayed_work_sync(&ir->work);
> +#endif
>  }
>
>  int em28xx_ir_init(struct em28xx *dev)
> --- v4l-dvb.orig/linux/drivers/media/video/saa6588.c    2009-03-05 09:14:01.000000000 +0100
> +++ v4l-dvb/linux/drivers/media/video/saa6588.c 2009-03-05 09:29:23.000000000 +0100
> @@ -77,8 +77,12 @@ MODULE_LICENSE("GPL");
>
>  struct saa6588 {
>        struct v4l2_subdev sd;
> +#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 20)
>        struct work_struct work;
>        struct timer_list timer;
> +#else
> +       struct delayed_work work;
> +#endif
>        spinlock_t lock;
>        unsigned char *buffer;
>        unsigned int buf_size;
> @@ -323,6 +327,7 @@ static void saa6588_i2c_poll(struct saa6
>        wake_up_interruptible(&s->read_queue);
>  }
>
> +#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 20)
>  static void saa6588_timer(unsigned long data)
>  {
>        struct saa6588 *s = (struct saa6588 *)data;
> @@ -330,7 +335,6 @@ static void saa6588_timer(unsigned long
>        schedule_work(&s->work);
>  }
>
> -#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
>  static void saa6588_work(void *data)
>  #else
>  static void saa6588_work(struct work_struct *work)
> @@ -339,11 +343,17 @@ static void saa6588_work(struct work_str
>  #if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
>        struct saa6588 *s = (struct saa6588 *)data;
>  #else
> -       struct saa6588 *s = container_of(work, struct saa6588, work);
> +       struct delayed_work *dwork = container_of(work, struct delayed_work,
> +                                                 work);
> +       struct saa6588 *s = container_of(dwork, struct saa6588, work);
>  #endif
>
>        saa6588_i2c_poll(s);
> +#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 20)
>        mod_timer(&s->timer, jiffies + msecs_to_jiffies(20));
> +#else
> +       schedule_delayed_work(dwork, msecs_to_jiffies(20));
> +#endif
>  }
>
>  static int saa6588_configure(struct saa6588 *s)
> @@ -501,13 +511,14 @@ static int saa6588_probe(struct i2c_clie
>        /* start polling via eventd */
>  #if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 20)
>        INIT_WORK(&s->work, saa6588_work, s);
> -#else
> -       INIT_WORK(&s->work, saa6588_work);
> -#endif
>        init_timer(&s->timer);
>        s->timer.function = saa6588_timer;
>        s->timer.data = (unsigned long)s;
>        schedule_work(&s->work);
> +#else
> +       INIT_DELAYED_WORK(&s->work, saa6588_work);
> +       schedule_delayed_work(&s->work, msecs_to_jiffies(20));
> +#endif
>        return 0;
>  }
>
> @@ -518,8 +529,12 @@ static int saa6588_remove(struct i2c_cli
>
>        v4l2_device_unregister_subdev(sd);
>
> +#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 20)
>        del_timer_sync(&s->timer);
>        flush_scheduled_work();
> +#else
> +       cancel_delayed_work_sync(&s->work);
> +#endif
>
>        kfree(s->buffer);
>        kfree(s);
>
>
> --
> Jean Delvare
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Hello Jean,

I would suggest that this patch be broken into three separate patches,
and then they can go in as the individual maintainers have the
opportunity to test them out. This will ensure that no totally
untested code goes into the codebase.

I'll volunteer to do the em28xx patch.

Regards,

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
