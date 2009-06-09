Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:34347 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755205AbZFILhk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Jun 2009 07:37:40 -0400
Received: by fxm9 with SMTP id 9so2893660fxm.37
        for <linux-media@vger.kernel.org>; Tue, 09 Jun 2009 04:37:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1244545180.28249.8.camel@tux.localhost>
References: <1244545180.28249.8.camel@tux.localhost>
Date: Tue, 9 Jun 2009 13:37:41 +0200
Message-ID: <62e5edd40906090437p3bcb9dbav6bd6875f3c281245@mail.gmail.com>
Subject: Re: [patch review] gspca - stv06xx: remove needless if check and goto
From: =?ISO-8859-1?Q?Erik_Andr=E9n?= <erik.andren@gmail.com>
To: Alexey Klimov <klimov.linux@gmail.com>
Cc: Jean-Francois Moine <moinejf@free.fr>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2009/6/9 Alexey Klimov <klimov.linux@gmail.com>:
> Hello, Jean-Francois and Erik André
>
> What do you think about such small change?
> Looks like the code doesn't need if-check and goto here in stv06xx_stopN
> function. The code after label "out" does this.
>
> --
> Patch removes needless if check and goto.
>
>
> Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>

Looks sane.
Thank you for reporting.

Best regards,
Erik

Reviewed-by: Erik Andrén <erik.andren@gmail.com>


> --
> diff -r ed3781a79c73 linux/drivers/media/video/gspca/stv06xx/stv06xx.c
> --- a/linux/drivers/media/video/gspca/stv06xx/stv06xx.c Sat Jun 06 16:31:34 2009 +0400
> +++ b/linux/drivers/media/video/gspca/stv06xx/stv06xx.c Tue Jun 09 14:49:04 2009 +0400
> @@ -293,8 +293,6 @@
>                goto out;
>
>        err = sd->sensor->stop(sd);
> -       if (err < 0)
> -               goto out;
>
>  out:
>        if (err < 0)
>
>
> --
> Best regards, Klimov Alexey
>
>
