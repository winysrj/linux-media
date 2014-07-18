Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f42.google.com ([209.85.219.42]:33832 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933673AbaGRJcn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Jul 2014 05:32:43 -0400
Received: by mail-oa0-f42.google.com with SMTP id n16so2761823oag.1
        for <linux-media@vger.kernel.org>; Fri, 18 Jul 2014 02:32:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1405662072-26808-1-git-send-email-olli.salonen@iki.fi>
References: <1405662072-26808-1-git-send-email-olli.salonen@iki.fi>
Date: Fri, 18 Jul 2014 10:32:42 +0100
Message-ID: <CAGj5WxBEXrWu0BkrCZ=N4qgRDyZqKR7=cZYaNcMSXKdL9wpmdA@mail.gmail.com>
Subject: Re: [PATCH] si2157: Use name si2157_ops instead of si2157_tuner_ops
 (harmonize with si2168)
From: Luis Alves <ljalvs@gmail.com>
To: Olli Salonen <olli.salonen@iki.fi>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This actually fixes a bug.
The struct prototype is defined at the beginning of the code as
"si2157_ops" but the real struct is called "si2157_tuner_ops".

This is causing the name to be empty on this info msg: si2157 16-0060:
si2157: found a '' in cold state

Luis


On Fri, Jul 18, 2014 at 6:41 AM, Olli Salonen <olli.salonen@iki.fi> wrote:
> Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
> ---
>  drivers/media/tuners/si2157.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
> index 329004f..4730f69 100644
> --- a/drivers/media/tuners/si2157.c
> +++ b/drivers/media/tuners/si2157.c
> @@ -277,7 +277,7 @@ err:
>         return ret;
>  }
>
> -static const struct dvb_tuner_ops si2157_tuner_ops = {
> +static const struct dvb_tuner_ops si2157_ops = {
>         .info = {
>                 .name           = "Silicon Labs Si2157/Si2158",
>                 .frequency_min  = 110000000,
> @@ -317,7 +317,7 @@ static int si2157_probe(struct i2c_client *client,
>                 goto err;
>
>         fe->tuner_priv = s;
> -       memcpy(&fe->ops.tuner_ops, &si2157_tuner_ops,
> +       memcpy(&fe->ops.tuner_ops, &si2157_ops,
>                         sizeof(struct dvb_tuner_ops));
>
>         i2c_set_clientdata(client, s);
> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
