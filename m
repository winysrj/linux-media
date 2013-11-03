Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:45822 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753350Ab3KCRSk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 3 Nov 2013 12:18:40 -0500
Message-ID: <5276856E.3000209@iki.fi>
Date: Sun, 03 Nov 2013 19:18:38 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: CrazyCat <crazycat69@narod.ru>, linux-media@vger.kernel.org
Subject: Re: [PATCH] cxd2820r_c: Fix if_ctl calculation
References: <527568E6.2000600@narod.ru>
In-Reply-To: <527568E6.2000600@narod.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

CrazyCat,

Could you fix your mailer? Or tell me the command I can import that 
patch to my local git tree for testing?

git send-email is at least know to break patches.


I will manually applying that patch and testing, but..



$ wget --no-check-certificate -O - 
https://patchwork.linuxtv.org/patch/20560/mbox/ | git am -s
--2013-11-03 19:15:11--  https://patchwork.linuxtv.org/patch/20560/mbox/
Resolving patchwork.linuxtv.org (patchwork.linuxtv.org)... 130.149.80.248
Connecting to patchwork.linuxtv.org 
(patchwork.linuxtv.org)|130.149.80.248|:443... connected.
WARNING: cannot verify patchwork.linuxtv.org's certificate, issued by 
‘/C=XX/ST=There is no such thing outside 
US/L=Everywhere/O=OCOSA/OU=Office for Complication of Otherwise Simple 
Affairs/CN=www.linuxtv.org/emailAddress=root@www.linuxtv.org’:
   Self-signed certificate encountered.
     WARNING: certificate common name ‘www.linuxtv.org’ doesn't match 
requested host name ‘patchwork.linuxtv.org’.
HTTP request sent, awaiting response... 200 OK
Length: unspecified [text/plain]
Saving to: ‘STDOUT’

     [ <=> 
 
        ] 1 199       --.-K/s   in 0s

2013-11-03 19:15:11 (9,34 MB/s) - written to stdout [1199]

Applying: cxd2820r_c: Fix if_ctl calculation
error: patch failed: drivers/media/dvb-frontends/cxd2820r_c.c:78
error: drivers/media/dvb-frontends/cxd2820r_c.c: patch does not apply
Patch failed at 0001 cxd2820r_c: Fix if_ctl calculation
The copy of the patch that failed is found in:
    /home/crope/linuxtv/code/linux/.git/rebase-apply/patch
When you have resolved this problem, run "git am --continue".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".


regards
Antti


On 02.11.2013 23:04, CrazyCat wrote:
> Fix tune for DVB-C.
>
> Signed-off-by: Evgeny Plehov <EvgenyPlehov@ukr.net>
> diff --git a/drivers/media/dvb-frontends/cxd2820r_c.c
> b/drivers/media/dvb-frontends/cxd2820r_c.c
> index 125a440..5c6ab49 100644
> --- a/drivers/media/dvb-frontends/cxd2820r_c.c
> +++ b/drivers/media/dvb-frontends/cxd2820r_c.c
> @@ -78,7 +78,7 @@ int cxd2820r_set_frontend_c(struct dvb_frontend *fe)
>
>       num = if_freq / 1000; /* Hz => kHz */
>       num *= 0x4000;
> -    if_ctl = cxd2820r_div_u64_round_closest(num, 41000);
> +    if_ctl = 0x4000 - cxd2820r_div_u64_round_closest(num, 41000);
>       buf[0] = (if_ctl >> 8) & 0x3f;
>       buf[1] = (if_ctl >> 0) & 0xff;
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
http://palosaari.fi/
