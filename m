Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47898 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755695Ab2KHORq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Nov 2012 09:17:46 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, media-workshop@linuxtv.org,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: drivers without explicit MAINTAINERS entry - was: Re: [media-workshop] Tentative Agenda for the November workshop
Date: Thu, 08 Nov 2012 15:18:38 +0100
Message-ID: <11275936.PtJ8jrzDFv@avalon>
In-Reply-To: <20121102111310.755e38aa@gaivota.chehab>
References: <201210221035.56897.hverkuil@xs4all.nl> <20121101141244.6c72242c@redhat.com> <20121102111310.755e38aa@gaivota.chehab>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Friday 02 November 2012 11:13:10 Mauro Carvalho Chehab wrote:
> Em Thu, 1 Nov 2012 14:12:44 -0200 Mauro Carvalho Chehab escreveu:
> > Em Thu, 1 Nov 2012 16:44:50 +0100 Hans Verkuil escreveu:
> > > On Thu October 25 2012 19:27:01 Mauro Carvalho Chehab wrote:
> > > > Em Mon, 22 Oct 2012 10:35:56 +0200 Hans Verkuil escreveu:
> > > > > Hi all,
> > > > > 
> > > > > This is the tentative agenda for the media workshop on November 8,
> > > > > 2012.
> > > > > If you have additional things that you want to discuss, or something
> > > > > is wrong or incomplete in this list, please let me know so I can
> > > > > update the list.
> > > > 
> > > > Thank you for taking care of it.
> > > > 
> > > > > - Explain current merging process (Mauro)
> > > > > - Open floor for discussions on how to improve it (Mauro)
> > > > > - Write down minimum requirements for new V4L2 (and DVB?) drivers,
> > > > >   both for staging and mainline acceptance: which frameworks to use,
> > > > >   v4l2-compliance, etc. (Hans Verkuil)
> > > > > - V4L2 ambiguities (Hans Verkuil)
> > > > > - TSMux device (a mux rather than a demux): Alain Volmat
> > > > > - dmabuf status, esp. with regards to being able to test
> > > > >   (Mauro/Samsung)
> > > > > - Device tree support (Guennadi, not known yet whether this topic is
> > > > >   needed) - Creating/selecting contexts for hardware that supports
> > > > >   this (Samsung, only if time is available)
> > > > 
> > > > I have an extra theme for discussions there: what should we do with
> > > > the drivers that don't have any MAINTAINERS entry.
> > > 
> > > I've added this topic to the list.
> > 
> > Thanks!
> > 
> > > > It probably makes sense to mark them as "Orphan" (or, at least, have
> > > > some criteria to mark them as such). Perhaps before doing that, we
> > > > could try to see if are there any developer at the community with time
> > > > and patience to handle them.
> > > > 
> > > > This could of course be handled as part of the discussions about how
> > > > to improve the merge process, but I suspect that this could generate
> > > > enough discussions to be handled as a separate theme.
> > > 
> > > Do we have a 'Maintainer-Light' category? I have a lot of hardware that
> > > I can test. So while I wouldn't like to be marked as 'The Maintainer of
> > > driver X' (since I simply don't have the time for that), I wouldn't
> > > mind being marked as someone who can at least test patches if needed.
> > 
> > There are several "maintainance" status there:
> > 	S: Status, one of the following:
> > 	   Supported:	Someone is actually paid to look after this.
> > 	   Maintained:	Someone actually looks after it.
> > 	   Odd Fixes:	It has a maintainer but they don't have time to do
> > 			much other than throw the odd patch in. See below..
> > 	   Orphan:	No current maintainer [but maybe you could take the
> > 			role as you write your new code].
> > 	   Obsolete:	Old code. Something tagged obsolete generally means
> > 			it has been replaced by a better system and you
> > 			should be using that.
> > 
> > (btw, I just realized that I should be changing the EDAC drivers I
> > maintain to Supported; the media drivers I maintain should be kept as
> > Maintained).
> > 
> > I suspect that the "maintainer-light" category for those radio and similar
> > old stuff is likely "Odd Fixes".
> > 
> > > > There are some issues by not having a MAINTAINERS entry:
> > > > 	- patches may not flow into the driver maintainer;
> > > > 	- patches will likely be applied without tests/reviews or may
> > > > 	  stay for a long time queued;
> > > > 	- ./scripts/get_maintainer.pl at --no-git-fallback won't return
> > > > 	  any maintainer[1].
> > > > 
> > > > [1] Letting get_maintainer.pl is very time/CPU consuming. Letting it
> > > > would delay a lot the patch review process, if applied for every
> > > > patch, with unreliable and doubtful results. I don't do it, due to the
> > > > large volume of patches, and because the 'other' results aren't
> > > > typically the driver maintainer.
> > > > 
> > > > An example of this is the results for a patch I just applied
> > > > 
> > > > (changeset 2866aed103b915ca8ba0ff76d5790caea4e62ced):
> > > > 	$ git show --pretty=email|./scripts/get_maintainer.pl
> > > > 	Mauro Carvalho Chehab <mchehab@infradead.org> (maintainer:MEDIA INPUT
> > > > 	INFRA...,commit_signer:7/7=100%) Hans Verkuil
> > > > 	<hans.verkuil@cisco.com> (commit_signer:4/7=57%)
> > > > 	Anatolij Gustschin <agust@denx.de> (commit_signer:1/7=14%)
> > > > 	Wei Yongjun <yongjun_wei@trendmicro.com.cn> (commit_signer:1/7=14%)
> > > > 	Hans de Goede <hdegoede@redhat.com> (commit_signer:1/7=14%)
> > > > 	linux-media@vger.kernel.org (open list:MEDIA INPUT INFRA...)
> > > > 	linux-kernel@vger.kernel.org (open list)
> > > > 
> > > > According with this driver's copyrights:
> > > >  * Copyright 2008-2010 Freescale Semiconductor, Inc. All Rights
> > > >  Reserved.
> > > >  *
> > > >  *  Freescale VIU video driver
> > > >  *
> > > >  *  Authors: Hongjun Chen <hong-jun.chen@freescale.com>
> > > >  *	     Porting to 2.6.35 by DENX Software Engineering,
> > > >  *	     Anatolij Gustschin <agust@denx.de>
> > > > 
> > > > The driver author (Hongjun Chen <hong-jun.chen@freescale.com>) was not
> > > > even shown there, and the co-author got only 15% hit, while I got 100%
> > > > and Hans got 57%.
> > > > 
> > > > This happens not only to this driver. In a matter of fact, on most
> > > > cases where no MAINTAINERS entry exist, the driver's author gets a
> > > > very small hit chance, as, on several of those drivers, the author
> > > > doesn't post anything else but the initial patch series.
> > > 
> > > We probably need to have an entry for all the media drivers, even if it
> > > just points to the linux-media mailinglist as being the 'collective
> > > default maintainer'.
> > 
> > Yes, I think that all media drivers should be there. I prefer to tag the
> > ones that nobody sends us a MAINTAINERS entry with "Orphan", as this tag
> > indicates that help is wanted.
> 
> I wrote a small shell script to see what's missing, using the
> analyze_build.pl script at media-build devel_scripts dir:
> 
> 	DIR=$(dirname $0)
> 
> 	$DIR/analyze_build.pl --path drivers/media/ --show_files_per_module
> >/tmp/all_drivers grep drivers/media/ MAINTAINERS | perl -ne
> 's/F:\s+//;s,drivers/media/,,; print $_ if (!/^\n/)' >maintained grep -v -f
> maintained /tmp/all_drivers |grep -v -e keymaps -e v4l2-core/ -e dvb-core/
> -e media.ko -e rc-core.ko -e ^#| sort >without_maint
> 
> I excluded the core files from the list, as they don't need any specific
> entry. RC keymaps is also a special case, as I don't think any maintainer
> is needed for them.
> 
> Basically, analyze_build.pl says that there are 613 drivers under
> drivers/media. The above script shows 348 drivers without an explicit
> maintainer. So, only 43% of the drivers have a formal maintainer.
> 
> Yet, on the list below, I think several of them can be easily tagged as
> "Odd fixes", like cx88 and saa7134.
> 
> I think I'll send today a few RFC MAINTAINERS patches for some stuff below
> that I can myself be added as "Odd fixes". Yet, I would very much prefer if
> someone with more time than me could be taking over the "Odd fixes" patches
> I'll propose.


These are 'Maintained' by me:

i2c/aptina-pll.ko              = i2c/aptina-pll.c
i2c/mt9p031.ko                 = i2c/mt9p031.c
i2c/mt9t001.ko                 = i2c/mt9t001.c
i2c/mt9v032.ko                 = i2c/mt9v032.c

I can maintain the following driver if needed:

i2c/mt9m032.ko                 = i2c/mt9m032.c

I could also take over maintenance the following driver, but I don't have 
access to a hardware platform that uses it:

i2c/mt9v011.ko                 = i2c/mt9v011.c

These are, as far as I know, co-maintained by Sakari and me :-)

i2c/adp1653.ko                 = i2c/adp1653.c
i2c/as3645a.ko                 = i2c/as3645a.c

-- 
Regards,

Laurent Pinchart

