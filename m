Return-path: <linux-media-owner@vger.kernel.org>
Received: from rotring.dds.nl ([85.17.178.138]:52371 "EHLO rotring.dds.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751469AbZCICRw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 8 Mar 2009 22:17:52 -0400
Subject: Re: Problem with changeset 10837: causes "make all" not to build
 many modules
From: Alain Kalker <miki@dds.nl>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org
In-Reply-To: <alpine.LRH.2.00.0903081354030.17407@pedra.chehab.org>
References: <4e1455be0903051913x37562436y85eef9cba8b10ab0@mail.gmail.com>
	 <20090306074604.10926b03@pedra.chehab.org>
	 <1236439661.7569.132.camel@miki-desktop>
	 <alpine.LRH.2.00.0903081354030.17407@pedra.chehab.org>
Content-Type: text/plain
Date: Mon, 09 Mar 2009 03:17:44 +0100
Message-Id: <1236565064.7149.49.camel@miki-desktop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Op zondag 08-03-2009 om 13:54 uur [tijdzone -0300], schreef Mauro
Carvalho Chehab:
> Hi Alain,
> 
> On Sat, 7 Mar 2009, Alain Kalker wrote:
> 
> > Mauro,
> >
> > Your latest changeset causes many modules (100 in total!) not to be
> > built anymore when doing "make all", i.e. without doing any "make
> > xconfig"/"make gconfig".
> >
> > I think this is related to the config variables for the frontend drivers
> > no longer being defined when DVB_FE_CUSTOMISE=n , so the card drivers
> > cannot depend on them anymore.
> 
> Thanks to warning me about that!
> 
> This seems to be yet another difference between the in-kernel and the 
> out-of-tree building environment.

If the problem doesn't manifest itself during in-kernel build, I believe
it must be with either v4l/Makefile or one of the scripts in scripts/*

As a matter of fact, I found out that commenting out
"disable_config('DVB_FE_CUSTOMISE');" in scripts/make_kconfig.pl line
588 and doing a "make distclean; make all" will cause all the undefined
config variables to be set to 'm' and the missing modules to be built
again.

Why is this disable_config() in there anyway? There is no corresponding
disable_config("MEDIA_TUNER_CUSTOMIZE"), which is used in the same way
in linux/drivers/media/common/tuners/Kconfig to hide a menu.

The only (aesthetic?) difference is that DVB_FE_CUSTOMISE ends up set to
'y' in the generated config (as has always been the case with
MEDIA_TUNER_CUSTOMIZE by the way), but that doesn't matter much at
module build time. A user should not configure _after_ building modules
anyway, so the menu showing up doesn't really matter.

Also note yet another -IZE / -ISE spelling issue :-)

Kind regards,

Alain

