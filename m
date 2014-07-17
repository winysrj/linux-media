Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:51472 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164AbaGQTQR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jul 2014 15:16:17 -0400
Received: by mail-oi0-f53.google.com with SMTP id e131so1510836oig.12
        for <linux-media@vger.kernel.org>; Thu, 17 Jul 2014 12:16:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1405622607-27248-1-git-send-email-olli.salonen@iki.fi>
References: <1405622607-27248-1-git-send-email-olli.salonen@iki.fi>
Date: Thu, 17 Jul 2014 20:09:31 +0100
Message-ID: <CAGj5WxCBwM3UZ1XW9aUez+nYaB46hxy6+NOWQqwdzFdd9aNq8A@mail.gmail.com>
Subject: Re: [PATCH] si2168: improve scanning performance by setting property
 0301 with a value from Windows driver.
From: Luis Alves <ljalvs@gmail.com>
To: Olli Salonen <olli.salonen@iki.fi>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This would be best done during init and not every time on set_frontend.

Regards,
Luis

On Thu, Jul 17, 2014 at 7:43 PM, Olli Salonen <olli.salonen@iki.fi> wrote:
> Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
> ---
>  drivers/media/dvb-frontends/si2168.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
> index 0422925..56811e1 100644
> --- a/drivers/media/dvb-frontends/si2168.c
> +++ b/drivers/media/dvb-frontends/si2168.c
> @@ -313,6 +313,13 @@ static int si2168_set_frontend(struct dvb_frontend *fe)
>         if (ret)
>                 goto err;
>
> +       memcpy(cmd.args, "\x14\x00\x01\x03\x0c\x00", 6);
> +       cmd.wlen = 6;
> +       cmd.rlen = 4;
> +       ret = si2168_cmd_execute(s, &cmd);
> +       if (ret)
> +               goto err;
> +
>         memcpy(cmd.args, "\x85", 1);
>         cmd.wlen = 1;
>         cmd.rlen = 1;
> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
