Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:60443 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbZCDNDM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Mar 2009 08:03:12 -0500
Date: Wed, 4 Mar 2009 10:02:44 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Igor M. Liplianin" <liplianin@me.by>
Cc: Matthias Schwarzott <zzam@gentoo.org>, linux-media@vger.kernel.org,
	Abylai Ospan <aospan@netup.ru>
Subject: Re: [PATCH] Typo in lnbp21.c / changeset: 10800:ba740eb2348e
Message-ID: <20090304100244.543b8b81@caramujo.chehab.org>
In-Reply-To: <200903041440.33687.liplianin@me.by>
References: <200903041111.15083.zzam@gentoo.org>
	<200903041440.33687.liplianin@me.by>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 4 Mar 2009 14:40:33 +0200
"Igor M. Liplianin" <liplianin@me.by> wrote:

> On 4 марта 2009, linux-media@vger.kernel.org wrote:
> > Hi there!
> >
> > lnbp21 does show strange messages at depmod.
> >
> > WARNING: Loop detected: /lib/modules/2.6.28-tuxonice-r1/v4l/lnbp21.ko which
> > needs lnbp21.ko again!
> > WARNING: Module /lib/modules/2.6.28-tuxonice-r1/v4l/lnbp21.ko ignored, due
> > to loop
> >
> > So I had a look at latest change and noticed there was a typo in the
> > function name, it should be lnbh24_attach, and not lnbp24_attach I guess.
> > The attached patch fixes this.
> >
> > Regards
> > Matthias
> Hi Matthias
> Yes, You are right.
> What an unfortunate misprint and  lack of attention from my side :(
> I confirm your patch.
> 
> Mauro, please apply this patch.

You forgot to attach the patch.
> 
> Best Regards 
> Igor




Cheers,
Mauro
