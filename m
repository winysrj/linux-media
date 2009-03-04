Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f176.google.com ([209.85.220.176]:54585 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491AbZCDNoW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Mar 2009 08:44:22 -0500
Received: by fxm24 with SMTP id 24so2901963fxm.37
        for <linux-media@vger.kernel.org>; Wed, 04 Mar 2009 05:44:20 -0800 (PST)
From: "Igor M. Liplianin" <liplianin@me.by>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] Typo in lnbp21.c / changeset: 10800:ba740eb2348e
Date: Wed, 4 Mar 2009 15:44:34 +0200
Cc: "Igor M. Liplianin" <liplianin@me.by>,
	Matthias Schwarzott <zzam@gentoo.org>,
	linux-media@vger.kernel.org, Abylai Ospan <aospan@netup.ru>
References: <200903041111.15083.zzam@gentoo.org> <200903041440.33687.liplianin@me.by> <20090304100244.543b8b81@caramujo.chehab.org>
In-Reply-To: <20090304100244.543b8b81@caramujo.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903041544.34438.liplianin@me.by>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

В сообщении от 4 March 2009 15:02:44 Mauro Carvalho Chehab написал(а):
> On Wed, 4 Mar 2009 14:40:33 +0200
>
> "Igor M. Liplianin" <liplianin@me.by> wrote:
> > On 4 п╪п╟я─я┌п╟ 2009, linux-media@vger.kernel.org wrote:
> > > Hi there!
> > >
> > > lnbp21 does show strange messages at depmod.
> > >
> > > WARNING: Loop detected: /lib/modules/2.6.28-tuxonice-r1/v4l/lnbp21.ko
> > > which needs lnbp21.ko again!
> > > WARNING: Module /lib/modules/2.6.28-tuxonice-r1/v4l/lnbp21.ko ignored,
> > > due to loop
> > >
> > > So I had a look at latest change and noticed there was a typo in the
> > > function name, it should be lnbh24_attach, and not lnbp24_attach I
> > > guess. The attached patch fixes this.
> > >
> > > Regards
> > > Matthias
> >
> > Hi Matthias
> > Yes, You are right.
> > What an unfortunate misprint and  lack of attention from my side :(
> > I confirm your patch.
> >
> > Mauro, please apply this patch.
>
> You forgot to attach the patch.
>
> > Best Regards
> > Igor
>
> Cheers,
> Mauro
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Mauro,

That was correct pull request to fix typo.

Please pull from http://udev.netup.ru/hg/v4l-dvb-netup

for the following changeset:

01/01: Fix typo in lnbp21.c
http://udev.netup.ru/hg/v4l-dvb-netup?cmd=changeset;node=19f5b50ab3d6


 lnbp21.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Thanks,
Igor
