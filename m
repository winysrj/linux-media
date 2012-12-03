Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:46639 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755214Ab2LCRYN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Dec 2012 12:24:13 -0500
Received: by mail-lb0-f174.google.com with SMTP id gi11so2576638lbb.19
        for <linux-media@vger.kernel.org>; Mon, 03 Dec 2012 09:24:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1354555082-11308-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1354555082-11308-1-git-send-email-fschaefer.oss@googlemail.com>
Date: Mon, 3 Dec 2012 12:24:12 -0500
Message-ID: <CAOcJUbxYoz=S1PWV+Jdf5r8cbu3oy677iQkvBmYOOCGqEEWEkg@mail.gmail.com>
Subject: Re: [PATCH] tda18271: add missing entries for qam_7 to
 tda18271_update_std_map() and tda18271_dump_std_map()
From: Michael Krufky <mkrufky@linuxtv.org>
To: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Frank,

Thank you for your patch -- I'll merge it to my tree later on today.

Best regards,

Mike Krufky

2012/12/3 Frank Schäfer <fschaefer.oss@googlemail.com>:
> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
> ---
>  drivers/media/tuners/tda18271-fe.c |    2 ++
>  1 Datei geändert, 2 Zeilen hinzugefügt(+)
>
> diff --git a/drivers/media/tuners/tda18271-fe.c b/drivers/media/tuners/tda18271-fe.c
> index 72c26fd..e778686 100644
> --- a/drivers/media/tuners/tda18271-fe.c
> +++ b/drivers/media/tuners/tda18271-fe.c
> @@ -1122,6 +1122,7 @@ static int tda18271_dump_std_map(struct dvb_frontend *fe)
>         tda18271_dump_std_item(dvbt_7, "dvbt 7");
>         tda18271_dump_std_item(dvbt_8, "dvbt 8");
>         tda18271_dump_std_item(qam_6,  "qam 6 ");
> +       tda18271_dump_std_item(qam_7,  "qam 7 ");
>         tda18271_dump_std_item(qam_8,  "qam 8 ");
>
>         return 0;
> @@ -1149,6 +1150,7 @@ static int tda18271_update_std_map(struct dvb_frontend *fe,
>         tda18271_update_std(dvbt_7, "dvbt 7");
>         tda18271_update_std(dvbt_8, "dvbt 8");
>         tda18271_update_std(qam_6,  "qam 6");
> +       tda18271_update_std(qam_7,  "qam 7");
>         tda18271_update_std(qam_8,  "qam 8");
>
>         return 0;
> --
> 1.7.10.4
>
