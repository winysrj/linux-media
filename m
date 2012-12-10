Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55641 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751498Ab2LJOPO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Dec 2012 09:15:14 -0500
Date: Mon, 10 Dec 2012 15:15:08 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Arne Fitzenreiter <Arne.Fitzenreiter@ipfire.org>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] [media] fix tua6034 pll bandwich configuration [3rd and
 last attempt]
In-Reply-To: <c391b828d500549858eca574a253d69b@mail01.ipfire.org>
Message-ID: <alpine.LNX.2.00.1212101514320.31825@pobox.suse.cz>
References: <c391b828d500549858eca574a253d69b@mail01.ipfire.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 10 Dec 2012, Arne Fitzenreiter wrote:

> i have already send this patch twice and the mailing list but get no response.
> (Three weeks delay between the mails).
> Why mail mails are ignored?

I have no idea, but I'd like to have this taken through media tree rather 
than trivial.

Adding Mauro to CC.

> 
> The tua6034 pll is corrupted by commit "[media] dvb-pll: use DVBv5 parameters
> on set_params()"
> http://git.linuxtv.org/media_tree.git/commit/80d8d4985f280dca3c395286d13b49f910a029e7
> 
> [SNIP]
> /* Infineon TUA6034
> * used in LG TDTP E102P
> */
> -static void tua6034_bw(struct dvb_frontend *fe, u8 *buf,
> -                      const struct dvb_frontend_parameters *params)
> +static void tua6034_bw(struct dvb_frontend *fe, u8 *buf)
> {
> -       if (BANDWIDTH_7_MHZ != params->u.ofdm.bandwidth)
> +       u32 bw = fe->dtv_property_cache.bandwidth_hz;
> +       if (bw == 7000000)
>               buf[3] |= 0x08;
> }
> [/SNIP]
> 
> so here is a patch to fix this typo to get the Skymaster DTMU100 (HANFTEK
> UMT010 OEM BOX)
> working again.
> 
> Arne
> 
> Resolves-bug: https://bugzilla.kernel.org/show_bug.cgi?id=51011
> 
> diff -Naur linux-3.7-rc7-org/drivers/media/dvb-frontends/dvb-pll.c
> linux-3.7-rc7/drivers/media/dvb-frontends/dvb-pll.c
> --- linux-3.7-rc7-org/drivers/media/dvb-frontends/dvb-pll.c	2012-11-26
> 02:59:19.000000000 +0100
> +++ linux-3.7-rc7/drivers/media/dvb-frontends/dvb-pll.c	2012-11-27
> 09:45:16.736775252 +0100
> @@ -247,7 +247,7 @@
> static void tua6034_bw(struct dvb_frontend *fe, u8 *buf)
> {
> 	u32 bw = fe->dtv_property_cache.bandwidth_hz;
> -	if (bw == 7000000)
> +	if (bw != 7000000)
> 		buf[3] |= 0x08;
> }
> 

-- 
Jiri Kosina
SUSE Labs
