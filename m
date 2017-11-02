Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:53577 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934442AbdKBXYa (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Nov 2017 19:24:30 -0400
Received: by mail-io0-f196.google.com with SMTP id 189so2565851iow.10
        for <linux-media@vger.kernel.org>; Thu, 02 Nov 2017 16:24:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20171031201143.ziwohlwpdvc4barr@gofer.mess.org>
References: <20171025004005.hyb43h3yvovp4is2@dtor-ws> <20171031172758.ugfo6br344iso4ni@gofer.mess.org>
 <20171031174558.vsdpdudcwjneq2nu@gofer.mess.org> <20171031182236.cxrasbayon7h52mm@dtor-ws>
 <20171031200758.avdowtmcem5fnlb5@gofer.mess.org> <20171031201143.ziwohlwpdvc4barr@gofer.mess.org>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 2 Nov 2017 16:24:27 -0700
Message-ID: <CAGXu5jLZaSDXdCVO3G1zsh3WLYaKvqm32xrJ8saBnCP8a7dZ8w@mail.gmail.com>
Subject: Re: [PATCH v2] media: ttpci: remove autorepeat handling and use timer_setup
To: Sean Young <sean@mess.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Oct 31, 2017 at 1:11 PM, Sean Young <sean@mess.org> wrote:
> Leave the autorepeat handling up to the input layer, and move
> to the new timer API.
>
> Compile tested only.
>
> Signed-off-by: Sean Young <sean@mess.org>

Hi! Just checking up on this... the input timer conversion is blocked
by getting this sorted out, so I'd love to have something either
media, input, or timer tree can carry. :)

Thanks!

-Kees

> ---
> v2:
>  - fixes and improvements from Dmitry Torokhov
>
>  drivers/media/pci/ttpci/av7110.h    |  2 +-
>  drivers/media/pci/ttpci/av7110_ir.c | 56 +++++++++++++------------------------
>  2 files changed, 21 insertions(+), 37 deletions(-)
>
> diff --git a/drivers/media/pci/ttpci/av7110.h b/drivers/media/pci/ttpci/av7110.h
> index 347827925c14..bcb72ecbedc0 100644
> --- a/drivers/media/pci/ttpci/av7110.h
> +++ b/drivers/media/pci/ttpci/av7110.h
> @@ -93,7 +93,7 @@ struct infrared {
>         u8                      inversion;
>         u16                     last_key;
>         u16                     last_toggle;
> -       u8                      delay_timer_finished;
> +       bool                    keypressed;
>  };
>
>
> diff --git a/drivers/media/pci/ttpci/av7110_ir.c b/drivers/media/pci/ttpci/av7110_ir.c
> index ca05198de2c2..ee414803e6b5 100644
> --- a/drivers/media/pci/ttpci/av7110_ir.c
> +++ b/drivers/media/pci/ttpci/av7110_ir.c
> @@ -84,15 +84,16 @@ static u16 default_key_map [256] = {
>
>
>  /* key-up timer */
> -static void av7110_emit_keyup(unsigned long parm)
> +static void av7110_emit_keyup(struct timer_list *t)
>  {
> -       struct infrared *ir = (struct infrared *) parm;
> +       struct infrared *ir = from_timer(ir, t, keyup_timer);
>
> -       if (!ir || !test_bit(ir->last_key, ir->input_dev->key))
> +       if (!ir || !ir->keypressed)
>                 return;
>
>         input_report_key(ir->input_dev, ir->last_key, 0);
>         input_sync(ir->input_dev);
> +       ir->keypressed = false;
>  }
>
>
> @@ -152,29 +153,18 @@ static void av7110_emit_key(unsigned long parm)
>                 return;
>         }
>
> -       if (timer_pending(&ir->keyup_timer)) {
> -               del_timer(&ir->keyup_timer);
> -               if (ir->last_key != keycode || toggle != ir->last_toggle) {
> -                       ir->delay_timer_finished = 0;
> -                       input_event(ir->input_dev, EV_KEY, ir->last_key, 0);
> -                       input_event(ir->input_dev, EV_KEY, keycode, 1);
> -                       input_sync(ir->input_dev);
> -               } else if (ir->delay_timer_finished) {
> -                       input_event(ir->input_dev, EV_KEY, keycode, 2);
> -                       input_sync(ir->input_dev);
> -               }
> -       } else {
> -               ir->delay_timer_finished = 0;
> -               input_event(ir->input_dev, EV_KEY, keycode, 1);
> -               input_sync(ir->input_dev);
> -       }
> +       if (ir->keypressed &&
> +           (ir->last_key != keycode || toggle != ir->last_toggle))
> +               input_event(ir->input_dev, EV_KEY, ir->last_key, 0);
>
> +       input_event(ir->input_dev, EV_KEY, keycode, 1);
> +       input_sync(ir->input_dev);
> +
> +       ir->keypressed = true;
>         ir->last_key = keycode;
>         ir->last_toggle = toggle;
>
> -       ir->keyup_timer.expires = jiffies + UP_TIMEOUT;
> -       add_timer(&ir->keyup_timer);
> -
> +       mod_timer(&ir->keyup_timer, jiffies + UP_TIMEOUT);
>  }
>
>
> @@ -204,16 +194,6 @@ static void input_register_keys(struct infrared *ir)
>         ir->input_dev->keycodemax = ARRAY_SIZE(ir->key_map);
>  }
>
> -
> -/* called by the input driver after rep[REP_DELAY] ms */
> -static void input_repeat_key(unsigned long parm)
> -{
> -       struct infrared *ir = (struct infrared *) parm;
> -
> -       ir->delay_timer_finished = 1;
> -}
> -
> -
>  /* check for configuration changes */
>  int av7110_check_ir_config(struct av7110 *av7110, int force)
>  {
> @@ -333,8 +313,7 @@ int av7110_ir_init(struct av7110 *av7110)
>         av_list[av_cnt++] = av7110;
>         av7110_check_ir_config(av7110, true);
>
> -       setup_timer(&av7110->ir.keyup_timer, av7110_emit_keyup,
> -                   (unsigned long)&av7110->ir);
> +       timer_setup(&av7110->ir.keyup_timer, av7110_emit_keyup, 0);
>
>         input_dev = input_allocate_device();
>         if (!input_dev)
> @@ -365,8 +344,13 @@ int av7110_ir_init(struct av7110 *av7110)
>                 input_free_device(input_dev);
>                 return err;
>         }
> -       input_dev->timer.function = input_repeat_key;
> -       input_dev->timer.data = (unsigned long) &av7110->ir;
> +
> +       /*
> +        * Input core's default autorepeat is 33 cps with 250 msec
> +        * delay, let's adjust to numbers more suitable for remote
> +        * control.
> +        */
> +       input_enable_softrepeat(input_dev, 250, 125);
>
>         if (av_cnt == 1) {
>                 e = proc_create("av7110_ir", S_IWUSR, NULL, &av7110_ir_proc_fops);
> --
> 2.13.6
>



-- 
Kees Cook
Pixel Security
