Return-path: <linux-media-owner@vger.kernel.org>
Received: from imap.netup.ru ([77.72.80.14]:45682 "EHLO imap.netup.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753334AbdGXTdP (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Jul 2017 15:33:15 -0400
Received: from mail-oi0-f51.google.com (mail-oi0-f51.google.com [209.85.218.51])
        by imap.netup.ru (Postfix) with ESMTPSA id 3F8648CE47A
        for <linux-media@vger.kernel.org>; Mon, 24 Jul 2017 22:33:14 +0300 (MSK)
Received: by mail-oi0-f51.google.com with SMTP id g131so34829628oic.3
        for <linux-media@vger.kernel.org>; Mon, 24 Jul 2017 12:33:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170723144509.508-1-d.scheller.oss@gmail.com>
References: <20170723144509.508-1-d.scheller.oss@gmail.com>
From: Abylay Ospan <aospan@netup.ru>
Date: Mon, 24 Jul 2017 15:32:51 -0400
Message-ID: <CAK3bHNVm+qhV6_Gj09RiWYQP4SvSYd5ex5ooaDs_wUoVProOjg@mail.gmail.com>
Subject: Re: [PATCH] [media] dvb-frontends/cxd2841er: update moddesc wrt new
 chip support
To: Daniel Scheller <d.scheller.oss@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>,
        Kozlov Sergey <serjk@netup.ru>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

good idea :)

Acked-by: Abylay Ospan <aospan@netup.ru>

2017-07-23 10:45 GMT-04:00 Daniel Scheller <d.scheller.oss@gmail.com>:
> From: Daniel Scheller <d.scheller@gmx.net>
>
> Since the driver now recognizes and supports more chip variants, reflect
> this fact in the module description accordingly.
>
> Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
> ---
>  drivers/media/dvb-frontends/cxd2841er.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/dvb-frontends/cxd2841er.c b/drivers/media/dvb-frontends/cxd2841er.c
> index 0ab1fc845927..48ee9bc00c06 100644
> --- a/drivers/media/dvb-frontends/cxd2841er.c
> +++ b/drivers/media/dvb-frontends/cxd2841er.c
> @@ -3999,6 +3999,6 @@ static struct dvb_frontend_ops cxd2841er_t_c_ops = {
>         .get_frontend_algo = cxd2841er_get_algo
>  };
>
> -MODULE_DESCRIPTION("Sony CXD2841ER/CXD2854ER DVB-C/C2/T/T2/S/S2 demodulator driver");
> +MODULE_DESCRIPTION("Sony CXD2837/38/41/43/54ER DVB-C/C2/T/T2/S/S2 demodulator driver");
>  MODULE_AUTHOR("Sergey Kozlov <serjk@netup.ru>, Abylay Ospan <aospan@netup.ru>");
>  MODULE_LICENSE("GPL");
> --
> 2.13.0
>



-- 
Abylay Ospan,
NetUP Inc.
http://www.netup.tv
