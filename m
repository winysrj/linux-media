Return-path: <linux-media-owner@vger.kernel.org>
Received: from imap.netup.ru ([77.72.80.14]:45857 "EHLO imap.netup.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905AbcHNIYW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Aug 2016 04:24:22 -0400
MIME-Version: 1.0
In-Reply-To: <1471112214-19547-1-git-send-email-colin.king@canonical.com>
References: <1471112214-19547-1-git-send-email-colin.king@canonical.com>
From: Abylay Ospan <aospan@netup.ru>
Date: Sat, 13 Aug 2016 23:37:13 -0400
Message-ID: <CAK3bHNV=TsAQ0x6S1f4+h_4Ar0rkPhpx2-gSLtQvFWuScXHwKw@mail.gmail.com>
Subject: Re: [PATCH] helene: fix memory leak when heleno_x_pon fails
To: Colin King <colin.king@canonical.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
	linux-media <linux-media@vger.kernel.org>,
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Colin,

It's really possible memory leak here. thanks for fix.

Acked-by: Abylay Ospan <aospan@netup.ru>

2016-08-13 14:16 GMT-04:00 Colin King <colin.king@canonical.com>:
> From: Colin Ian King <colin.king@canonical.com>
>
> The error return path of failed calls to heleno_x_pon leak
> memory because priv is not kfree'd.  Fix this by kfree'ing
> priv before returning.
>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/media/dvb-frontends/helene.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/dvb-frontends/helene.c b/drivers/media/dvb-frontends/helene.c
> index 97a8982..3d1cd5f 100644
> --- a/drivers/media/dvb-frontends/helene.c
> +++ b/drivers/media/dvb-frontends/helene.c
> @@ -987,8 +987,10 @@ struct dvb_frontend *helene_attach_s(struct dvb_frontend *fe,
>         if (fe->ops.i2c_gate_ctrl)
>                 fe->ops.i2c_gate_ctrl(fe, 1);
>
> -       if (helene_x_pon(priv) != 0)
> +       if (helene_x_pon(priv) != 0) {
> +               kfree(priv);
>                 return NULL;
> +       }
>
>         if (fe->ops.i2c_gate_ctrl)
>                 fe->ops.i2c_gate_ctrl(fe, 0);
> @@ -1021,8 +1023,10 @@ struct dvb_frontend *helene_attach(struct dvb_frontend *fe,
>         if (fe->ops.i2c_gate_ctrl)
>                 fe->ops.i2c_gate_ctrl(fe, 1);
>
> -       if (helene_x_pon(priv) != 0)
> +       if (helene_x_pon(priv) != 0) {
> +               kfree(priv);
>                 return NULL;
> +       }
>
>         if (fe->ops.i2c_gate_ctrl)
>                 fe->ops.i2c_gate_ctrl(fe, 0);
> --
> 2.8.1
>



-- 
Abylay Ospan,
NetUP Inc.
http://www.netup.tv
