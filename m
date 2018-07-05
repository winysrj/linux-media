Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:46356 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754086AbeGENNX (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 5 Jul 2018 09:13:23 -0400
Date: Thu, 5 Jul 2018 10:13:15 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Michael Ira Krufky <mkrufky@linuxtv.org>
Cc: linux-media <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        suzuki.katsuhiro@socionext.com, Antti Palosaari <crope@iki.fi>,
        Sergey Kozlov <serjk@netup.ru>, Abylay Ospan <aospan@netup.ru>,
        Malcolm Priestley <tvboxspy@gmail.com>,
        d.scheller.oss@gmail.com, Michael Buesch <m@bues.ch>,
        Olli Salonen <olli.salonen@iki.fi>
Subject: Re: [PATCH 1/2] media: dvb: convert tuner_info frequencies to Hz
Message-ID: <20180705101315.70ea4ef3@coco.lan>
In-Reply-To: <CAOcJUbzxccYDYoB4ZBPNzVKcidUde56M-=G_PO4vC+Q2N-KqUQ@mail.gmail.com>
References: <cover.1530740760.git.mchehab+samsung@kernel.org>
        <2a369e8faf3b277baff4026371f298e95c84fbb2.1530740760.git.mchehab+samsung@kernel.org>
        <CAOcJUbzxccYDYoB4ZBPNzVKcidUde56M-=G_PO4vC+Q2N-KqUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 5 Jul 2018 08:35:24 -0400
Michael Ira Krufky <mkrufky@linuxtv.org> escreveu:

> On Wed, Jul 4, 2018 at 10:47 PM Mauro Carvalho Chehab
> <mchehab+samsung@kernel.org> wrote:
> >
> > Right now, satellite tuner drivers specify frequencies in kHz,
> > while terrestrial/cable ones specify in Hz. That's confusing
> > for developers.
> >
> > However, the main problem is that universal tuners capable
> > of handling both satellite and non-satelite delivery systems
> > are appearing. We end by needing to hack the drivers in
> > order to support such hybrid tuners.
> >
> > So, convert everything to specify tuner frequencies in Hz.
> >
> > Plese notice that a similar patch is also needed for frontends.
> >
> > Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>  
> 
> I'm okay with the idea behind this, but I'm not sure I'm behind the
> way it's being done.  What if, rather than changing every tuner range
> to HZ, instead, to add a new field to indicate the magnitude. This can
> be Hz, KHz, MHz, etc
> 
> This way, the ranges would remain unaltered, and userspace can remain
> unchanged.  Although the patch as-is may solve a problem, it might be
> better to solve it with less impact.

With just those patches, userspace remains unchanged. Internally,
the DVB core handles kHz conversion when needed, but it will keep 
exposing data from FE_GET_INFO on kHz for Satellite systems or in
Hz for cable/terrestrial in a transparent way.

In the future, it could be interesting to change internally the 
frequencies to u64 and have some new ioctls (or dtv properties)
that would always handle frequencies in Hz.

With those patches, doing such change should be really simple, as
now the internal representation becomes independent from the
external one (see patch 2/2).

Thanks,
Mauro
