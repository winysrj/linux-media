Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:33602 "EHLO
	mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835AbcGYSzw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jul 2016 14:55:52 -0400
Received: by mail-it0-f68.google.com with SMTP id d65so8164303ith.0
        for <linux-media@vger.kernel.org>; Mon, 25 Jul 2016 11:55:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1469471939-25393-1-git-send-email-aospan@netup.ru>
References: <1469471939-25393-1-git-send-email-aospan@netup.ru>
From: Michael Ira Krufky <mkrufky@linuxtv.org>
Date: Mon, 25 Jul 2016 14:55:51 -0400
Message-ID: <CAOcJUby+9gTrFUF14pvo1iMa2azD5TfGM8WgeZY1+Bh8CTYVzA@mail.gmail.com>
Subject: Re: [PATCH] [media] lgdt3306a: remove 20*50 msec unnecessary timeout
To: Abylay Ospan <aospan@netup.ru>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jul 25, 2016 at 2:38 PM, Abylay Ospan <aospan@netup.ru> wrote:
> inside lgdt3306a_search we reading demod status 20 times with 50 msec sleep after each read.
> This gives us more than 1 sec of delay. Removing this delay should not affect demod functionality.
>
> Signed-off-by: Abylay Ospan <aospan@netup.ru>
> ---
>  drivers/media/dvb-frontends/lgdt3306a.c | 16 ++++------------
>  1 file changed, 4 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/media/dvb-frontends/lgdt3306a.c b/drivers/media/dvb-frontends/lgdt3306a.c
> index 179c26e..dad7ad3 100644
> --- a/drivers/media/dvb-frontends/lgdt3306a.c
> +++ b/drivers/media/dvb-frontends/lgdt3306a.c
> @@ -1737,24 +1737,16 @@ static int lgdt3306a_get_tune_settings(struct dvb_frontend *fe,
>  static int lgdt3306a_search(struct dvb_frontend *fe)
>  {
>         enum fe_status status = 0;
> -       int i, ret;
> +       int ret;
>
>         /* set frontend */
>         ret = lgdt3306a_set_parameters(fe);
>         if (ret)
>                 goto error;
>
> -       /* wait frontend lock */
> -       for (i = 20; i > 0; i--) {
> -               dbg_info(": loop=%d\n", i);
> -               msleep(50);
> -               ret = lgdt3306a_read_status(fe, &status);
> -               if (ret)
> -                       goto error;
> -
> -               if (status & FE_HAS_LOCK)
> -                       break;
> -       }
> +       ret = lgdt3306a_read_status(fe, &status);
> +       if (ret)
> +               goto error;
>
>         /* check if we have a valid signal */
>         if (status & FE_HAS_LOCK)

Your patch removes a loop that was purposefully written here to handle
conditions that are not ideal.  Are you sure this change is best for
all users?

I would disagree with merging this patch.

Best regards,

Michael Ira Krufky
