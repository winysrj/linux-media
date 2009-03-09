Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:44228 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbZCIEae (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Mar 2009 00:30:34 -0400
Date: Mon, 9 Mar 2009 01:30:05 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Alain Kalker <miki@dds.nl>
Cc: linux-media@vger.kernel.org
Subject: Re: Problem with changeset 10837: causes "make all" not to build
 many modules
Message-ID: <20090309013005.66a71767@caramujo.chehab.org>
In-Reply-To: <1236565064.7149.49.camel@miki-desktop>
References: <4e1455be0903051913x37562436y85eef9cba8b10ab0@mail.gmail.com>
	<20090306074604.10926b03@pedra.chehab.org>
	<1236439661.7569.132.camel@miki-desktop>
	<alpine.LRH.2.00.0903081354030.17407@pedra.chehab.org>
	<1236565064.7149.49.camel@miki-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 09 Mar 2009 03:17:44 +0100
Alain Kalker <miki@dds.nl> wrote:

> Op zondag 08-03-2009 om 13:54 uur [tijdzone -0300], schreef Mauro
> Carvalho Chehab:
> > Hi Alain,
> > 
> > On Sat, 7 Mar 2009, Alain Kalker wrote:
> > 
> > > Mauro,
> > >
> > > Your latest changeset causes many modules (100 in total!) not to be
> > > built anymore when doing "make all", i.e. without doing any "make
> > > xconfig"/"make gconfig".
> > >
> > > I think this is related to the config variables for the frontend drivers
> > > no longer being defined when DVB_FE_CUSTOMISE=n , so the card drivers
> > > cannot depend on them anymore.
> > 
> > Thanks to warning me about that!
> > 
> > This seems to be yet another difference between the in-kernel and the 
> > out-of-tree building environment.
> 
> If the problem doesn't manifest itself during in-kernel build, I believe
> it must be with either v4l/Makefile or one of the scripts in scripts/*
> 
> As a matter of fact, I found out that commenting out
> "disable_config('DVB_FE_CUSTOMISE');" in scripts/make_kconfig.pl line
> 588 and doing a "make distclean; make all" will cause all the undefined
> config variables to be set to 'm' and the missing modules to be built
> again.

Yes, I noticed the same, and already committed a patch removing this option
from the script.

> Why is this disable_config() in there anyway? There is no corresponding
> disable_config("MEDIA_TUNER_CUSTOMIZE"), which is used in the same way
> in linux/drivers/media/common/tuners/Kconfig to hide a menu.

The implementation of both options were different in the past. What changeset 10837 did
were to implement both with about same logic.

> The only (aesthetic?) difference is that DVB_FE_CUSTOMISE ends up set to
> 'y' in the generated config (as has always been the case with
> MEDIA_TUNER_CUSTOMIZE by the way), but that doesn't matter much at
> module build time. A user should not configure _after_ building modules
> anyway, so the menu showing up doesn't really matter.
> 
> Also note yet another -IZE / -ISE spelling issue :-)

The dvb option were added by Europeans (so, it ends with -ISE), while the media
were implemented by Americans (-IZE) ;)

I suspect that this is the reason why we had several DVB_FE_CUSTOMIZE with -IZE
in the past. IMO, we should decide if we will use the American or the Britain
way.

I'm not sure if Kernel has a default language convention for this. Probably, it
has, but I can't find anything on Documentation/*. Otherwise, I would vote for
using -ISE on both options.

Hmm... maybe we can just grep for both and see what happens most on Kernel:

$ git grep -i customise|wc
    256    1451   19677

$ git grep -i customize|wc
    115     733    9986

It seems that the Britain way is more popular.

Cheers,
Mauro
