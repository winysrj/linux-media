Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:57785 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758249Ab2EJPXP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 May 2012 11:23:15 -0400
Received: by bkcji2 with SMTP id ji2so1408269bkc.19
        for <linux-media@vger.kernel.org>; Thu, 10 May 2012 08:23:13 -0700 (PDT)
From: "Igor M. Liplianin" <liplianin@me.by>
To: =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Manu Abraham <abraham.manu@gmail.com>
Subject: Re: Re: [PATCH] Terratec Cinergy C PCI HD (CI)
Date: Thu, 10 May 2012 18:23:23 +0300
Message-ID: <1859889.AVKT8ZT1ng@useri>
In-Reply-To: <87fwb95gia.fsf@nemi.mork.no>
References: <1543153.gDfgtO0cjd@useri> <87fwb95gia.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 9 мая 2012 20:57:49 Bjørn Mork wrote:
> "Igor M. Liplianin" <liplianin@me.by> writes:
> > This patch seems for rectifying a typo. But actually the difference
> > between
> > mantis_vp2040.c and mantis_vp2033.c code is a card name only.
> 
> Yes, there are major code duplication issues in this driver.
> 
> > Signed-off-by: Igor M. Liplianin <liplianin@me.by>
> > diff -r 990a92e2410f linux/drivers/media/dvb/mantis/mantis_cards.c
> > --- a/linux/drivers/media/dvb/mantis/mantis_cards.c	Wed May 09 01:37:05
> > 2012 +0300 +++ b/linux/drivers/media/dvb/mantis/mantis_cards.c	Wed May 09
> > 14:04:31 2012 +0300 @@ -276,7 +276,7 @@
> > 
> >  	MAKE_ENTRY(TWINHAN_TECHNOLOGIES, MANTIS_VP_2033_DVB_C, &vp2033_config),
> >  	MAKE_ENTRY(TWINHAN_TECHNOLOGIES, MANTIS_VP_2040_DVB_C, &vp2040_config),
> >  	MAKE_ENTRY(TECHNISAT, CABLESTAR_HD2, &vp2040_config),
> > 
> > -	MAKE_ENTRY(TERRATEC, CINERGY_C, &vp2033_config),
> > +	MAKE_ENTRY(TERRATEC, CINERGY_C, &vp2040_config),
> > 
> >  	MAKE_ENTRY(TWINHAN_TECHNOLOGIES, MANTIS_VP_3030_DVB_T, &vp3030_config),
> >  	{ }
> >  
> >  };
> 
> What's the point? It's a constructed difference.  Makes more sense to
> refactor and merge all the duplicated code instead of maintaining this
> meaningless code split.
> 
> > diff -r 990a92e2410f linux/drivers/media/dvb/mantis/mantis_core.c
> > --- a/linux/drivers/media/dvb/mantis/mantis_core.c	Wed May 09 01:37:05
> > 2012 +0300 +++ b/linux/drivers/media/dvb/mantis/mantis_core.c	Wed May 09
> > 14:04:31 2012 +0300 @@ -121,7 +121,7 @@
> > 
> >  		mantis->hwconfig = &vp2033_mantis_config;
> >  		break;
> >  	
> >  	case MANTIS_VP_2040_DVB_C:	/* VP-2040 */
> > 
> > -	case TERRATEC_CINERGY_C_PCI:	/* VP-2040 clone */
> > +	case CINERGY_C:	/* VP-2040 clone */
> > 
> >  	case TECHNISAT_CABLESTAR_HD2:
> >  		mantis->hwconfig = &vp2040_mantis_config;
> >  		break;
> 
> And this file should never have been merged into the mainline kernel at
> all.  If you wonder how a bug like that could survive without being
> noticed, then the explanation is simple:  This code has never been built
> as part of the driver in the mainline kernel.
> 
> I tried submitting a cleanup patch to have it removed a long time ago:
> http://patchwork.linuxtv.org/patch/3680/
Oh, I wasn't aware of that.

> but it doesn't seem to have gone anywhere, like most of the patches for
> this driver -  silently ignored until everyone forgets it and moves on.
> 
> The code could certainly benefit from a major cleanup, but I don't see
> how that would ever happen.  It sort of works.  Better leave it there
> and spend valuable time elsewhere.
This patch is just a remainder. Seriously, I don't anticipate something.

Igor.
> 
> 
> 
> Bjørn
-- 
Igor M. Liplianin
Microsoft Windows Free Zone - Linux used for all Computing Tasks
