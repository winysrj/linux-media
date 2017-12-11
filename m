Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:44107 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752041AbdLKQme (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Dec 2017 11:42:34 -0500
Date: Mon, 11 Dec 2017 14:42:29 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Ron Economos <w6rz@comcast.net>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH]media: dvb-frontends: Add delay to Si2168 restart
Message-ID: <20171211144229.3002f15f@vento.lan>
In-Reply-To: <7b146d05-ae00-bf35-c780-cd5ed54d1f86@comcast.net>
References: <7b146d05-ae00-bf35-c780-cd5ed54d1f86@comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 10 Oct 2017 18:13:30 -0700
Ron Economos <w6rz@comcast.net> escreveu:

> On faster CPUs a delay is required after the POWER_UP/RESUME command and 
> the DD_RESTART command. Without the delay, the DD_RESTART command often 
> returns -EREMOTEIO and the Si2168 does not restart.

You forgot to add your signed-off-by after the patch description.

That's required for all patches that will be applied. See:
	https://linuxtv.org/wiki/index.php/Development:_Submitting_Patches#Sign_your_work
	

> 
> diff --git a/drivers/media/dvb-frontends/si2168.c 
> b/drivers/media/dvb-frontends/si2168.c
> index 172fc36..f2a3c8f 100644
> --- a/drivers/media/dvb-frontends/si2168.c
> +++ b/drivers/media/dvb-frontends/si2168.c
> @@ -15,6 +15,7 @@
>    */
> 
>   #include "si2168_priv.h"
> +#include <linux/delay.h>
> 
>   static const struct dvb_frontend_ops si2168_ops;
> 
> @@ -435,6 +436,7 @@ static int si2168_init(struct dvb_frontend *fe)
>                  if (ret)
>                          goto err;
> 
> +               udelay(100);

Your emailer is mangling your patches, replacing tabs by spaces and
breaking long lines. Please either use git send-email or use some
other email software, like claws-mail, pine or exim.

>                  memcpy(cmd.args, "\x85", 1);
>                  cmd.wlen = 1;
>                  cmd.rlen = 1;
> 



Thanks,
Mauro
