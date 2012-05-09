Return-path: <linux-media-owner@vger.kernel.org>
Received: from canardo.mork.no ([148.122.252.1]:44324 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755699Ab2EIS6A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 May 2012 14:58:00 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: "Igor M. Liplianin" <liplianin@me.by>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Manu Abraham <abraham.manu@gmail.com>
Subject: Re: [PATCH] Terratec Cinergy C PCI HD (CI)
References: <1543153.gDfgtO0cjd@useri>
Date: Wed, 09 May 2012 20:57:49 +0200
In-Reply-To: <1543153.gDfgtO0cjd@useri> (Igor M. Liplianin's message of "Wed,
	09 May 2012 14:23:14 +0300")
Message-ID: <87fwb95gia.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

"Igor M. Liplianin" <liplianin@me.by> writes:

> This patch seems for rectifying a typo. But actually the difference between
> mantis_vp2040.c and mantis_vp2033.c code is a card name only.

Yes, there are major code duplication issues in this driver.

> Signed-off-by: Igor M. Liplianin <liplianin@me.by>
> diff -r 990a92e2410f linux/drivers/media/dvb/mantis/mantis_cards.c
> --- a/linux/drivers/media/dvb/mantis/mantis_cards.c	Wed May 09 01:37:05 2012 +0300
> +++ b/linux/drivers/media/dvb/mantis/mantis_cards.c	Wed May 09 14:04:31 2012 +0300
> @@ -276,7 +276,7 @@
>  	MAKE_ENTRY(TWINHAN_TECHNOLOGIES, MANTIS_VP_2033_DVB_C, &vp2033_config),
>  	MAKE_ENTRY(TWINHAN_TECHNOLOGIES, MANTIS_VP_2040_DVB_C, &vp2040_config),
>  	MAKE_ENTRY(TECHNISAT, CABLESTAR_HD2, &vp2040_config),
> -	MAKE_ENTRY(TERRATEC, CINERGY_C, &vp2033_config),
> +	MAKE_ENTRY(TERRATEC, CINERGY_C, &vp2040_config),
>  	MAKE_ENTRY(TWINHAN_TECHNOLOGIES, MANTIS_VP_3030_DVB_T, &vp3030_config),
>  	{ }
>  };

What's the point? It's a constructed difference.  Makes more sense to
refactor and merge all the duplicated code instead of maintaining this
meaningless code split.

> diff -r 990a92e2410f linux/drivers/media/dvb/mantis/mantis_core.c
> --- a/linux/drivers/media/dvb/mantis/mantis_core.c	Wed May 09 01:37:05 2012 +0300
> +++ b/linux/drivers/media/dvb/mantis/mantis_core.c	Wed May 09 14:04:31 2012 +0300
> @@ -121,7 +121,7 @@
>  		mantis->hwconfig = &vp2033_mantis_config;
>  		break;
>  	case MANTIS_VP_2040_DVB_C:	/* VP-2040 */
> -	case TERRATEC_CINERGY_C_PCI:	/* VP-2040 clone */
> +	case CINERGY_C:	/* VP-2040 clone */
>  	case TECHNISAT_CABLESTAR_HD2:
>  		mantis->hwconfig = &vp2040_mantis_config;
>  		break;


And this file should never have been merged into the mainline kernel at
all.  If you wonder how a bug like that could survive without being
noticed, then the explanation is simple:  This code has never been built
as part of the driver in the mainline kernel.

I tried submitting a cleanup patch to have it removed a long time ago:
http://patchwork.linuxtv.org/patch/3680/
but it doesn't seem to have gone anywhere, like most of the patches for
this driver -  silently ignored until everyone forgets it and moves on.

The code could certainly benefit from a major cleanup, but I don't see
how that would ever happen.  It sort of works.  Better leave it there
and spend valuable time elsewhere.



Bjørn
