Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33221 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751785Ab3KAULj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 1 Nov 2013 16:11:39 -0400
Message-ID: <52740AFA.2090704@iki.fi>
Date: Fri, 01 Nov 2013 22:11:38 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: CrazyCat <crazycat69@narod.ru>, linux-media@vger.kernel.org
Subject: Re: [PATCH] cxd2820r_c: Fix if_ctl calculation
References: <527409DE.4010606@narod.ru>
In-Reply-To: <527409DE.4010606@narod.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

$ wget --no-check-certificate -O - 
https://patchwork.linuxtv.org/patch/20516/mbox/ | git am -s
--2013-11-01 22:10:30--  https://patchwork.linuxtv.org/patch/20516/mbox/
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
 
        ] 1 218       --.-K/s   in 0s

2013-11-01 22:10:30 (8,89 MB/s) - written to stdout [1218]

Applying: cxd2820r_c: Fix if_ctl calculation
error: patch failed: drivers/media/dvb-frontends/cxd2820r_c.c:78
error: drivers/media/dvb-frontends/cxd2820r_c.c: patch does not apply
Patch failed at 0001 cxd2820r_c: Fix if_ctl calculation
The copy of the patch that failed is found in:
    /home/crope/linuxtv/code/linux/.git/rebase-apply/patch
When you have resolved this problem, run "git am --continue".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".


On 01.11.2013 22:06, CrazyCat wrote:
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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
http://palosaari.fi/
