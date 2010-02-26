Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f219.google.com ([209.85.220.219]:41566 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935419Ab0BZHpp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Feb 2010 02:45:45 -0500
Received: by fxm19 with SMTP id 19so7137542fxm.21
        for <linux-media@vger.kernel.org>; Thu, 25 Feb 2010 23:45:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B87006A.4030303@oracle.com>
References: <4B87006A.4030303@oracle.com>
Date: Fri, 26 Feb 2010 11:45:43 +0400
Message-ID: <1a297b361002252345k713f8ca4n84fcd1a91f7d9a8@mail.gmail.com>
Subject: Re: [PATCH] media: fix precedence in dvb/frontends/tda665x
From: Manu Abraham <abraham.manu@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Randy,

Thanks for catching the bug !

On Fri, Feb 26, 2010 at 2:57 AM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
>
> Fix precedence so that data is used correctly.
> Fixes sparse warning:
> drivers/media/dvb/frontends/tda665x.c:136:55: warning: right shift by bigger than source value
>
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: Manu Abraham <abraham.manu@gmail.com>

Reviewed-by: Manu Abraham <manu@linuxtv.org>
Acked-by: Manu Abraham <manu@linuxtv.org>


> ---
>  drivers/media/dvb/frontends/tda665x.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- lnx-2633-spr.orig/drivers/media/dvb/frontends/tda665x.c
> +++ lnx-2633-spr/drivers/media/dvb/frontends/tda665x.c
> @@ -133,7 +133,7 @@ static int tda665x_set_state(struct dvb_
>                frequency += config->ref_divider >> 1;
>                frequency /= config->ref_divider;
>
> -               buf[0] = (u8) (frequency & 0x7f00) >> 8;
> +               buf[0] = (u8) ((frequency & 0x7f00) >> 8);
>                buf[1] = (u8) (frequency & 0x00ff) >> 0;
>                buf[2] = 0x80 | 0x40 | 0x02;
>                buf[3] = 0x00;
>
>
