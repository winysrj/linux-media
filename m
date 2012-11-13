Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:41707 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754300Ab2KMJwZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Nov 2012 04:52:25 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: martin@neutronstar.dyndns.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, media-workshop@linuxtv.org,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: drivers without explicit MAINTAINERS entry - was: Re: [media-workshop] Tentative Agenda for the November workshop
Date: Tue, 13 Nov 2012 10:53:17 +0100
Message-ID: <1424972.CmdJA1f2pQ@avalon>
In-Reply-To: <11275936.PtJ8jrzDFv@avalon>
References: <201210221035.56897.hverkuil@xs4all.nl> <20121102111310.755e38aa@gaivota.chehab> <11275936.PtJ8jrzDFv@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Martin,

On Thursday 08 November 2012 15:18:38 Laurent Pinchart wrote:
> On Friday 02 November 2012 11:13:10 Mauro Carvalho Chehab wrote:
> > Em Thu, 1 Nov 2012 14:12:44 -0200 Mauro Carvalho Chehab escreveu:
> > > Em Thu, 1 Nov 2012 16:44:50 +0100 Hans Verkuil escreveu:
> > > > On Thu October 25 2012 19:27:01 Mauro Carvalho Chehab wrote:
> > > > > Em Mon, 22 Oct 2012 10:35:56 +0200 Hans Verkuil escreveu:
> > > > > > Hi all,
> > > > > > 
> > > > > > This is the tentative agenda for the media workshop on November 8,
> > > > > > 2012. If you have additional things that you want to discuss, or
> > > > > > something is wrong or incomplete in this list, please let me know
> > > > > > so I can update the list.

[snip]

> > > > > I have an extra theme for discussions there: what should we do with
> > > > > the drivers that don't have any MAINTAINERS entry.
> > > > 
> > > > I've added this topic to the list.
> > > 
> > > Thanks!
> > > 
> > > > > It probably makes sense to mark them as "Orphan" (or, at least, have
> > > > > some criteria to mark them as such). Perhaps before doing that, we
> > > > > could try to see if are there any developer at the community with
> > > > > time and patience to handle them.
> > > > > 
> > > > > This could of course be handled as part of the discussions about how
> > > > > to improve the merge process, but I suspect that this could generate
> > > > > enough discussions to be handled as a separate theme.
> > > > 
> > > > Do we have a 'Maintainer-Light' category? I have a lot of hardware
> > > > that I can test. So while I wouldn't like to be marked as 'The
> > > > Maintainer of driver X' (since I simply don't have the time for that),
> > > > I wouldn't mind being marked as someone who can at least test patches
> > > > if needed.
> > > 
> > > There are several "maintainance" status there:
> > > 	S: Status, one of the following:
> > > 	   Supported:	Someone is actually paid to look after this.
> > > 	   Maintained:	Someone actually looks after it.
> > > 	   Odd Fixes:	It has a maintainer but they don't have time to do
> > > 			much other than throw the odd patch in. See below..
> > > 	   Orphan:	No current maintainer [but maybe you could take the
> > > 			role as you write your new code].
> > > 	   Obsolete:	Old code. Something tagged obsolete generally means
> > > 			it has been replaced by a better system and you
> > > 			should be using that.

[snip]

> > > > We probably need to have an entry for all the media drivers, even if
> > > > it just points to the linux-media mailinglist as being the 'collective
> > > > default maintainer'.
> > > 
> > > Yes, I think that all media drivers should be there. I prefer to tag the
> > > ones that nobody sends us a MAINTAINERS entry with "Orphan", as this tag
> > > indicates that help is wanted.
> > 
> > I wrote a small shell script to see what's missing, using the
> > 
> > analyze_build.pl script at media-build devel_scripts dir:
> > 	DIR=$(dirname $0)
> > 	
> > 	$DIR/analyze_build.pl --path drivers/media/ --show_files_per_module
> > 	
> > >/tmp/all_drivers grep drivers/media/ MAINTAINERS | perl -ne
> > 
> > 's/F:\s+//;s,drivers/media/,,; print $_ if (!/^\n/)' >maintained grep -v
> > -f maintained /tmp/all_drivers |grep -v -e keymaps -e v4l2-core/
> > -e dvb-core/ -e media.ko -e rc-core.ko -e ^#| sort >without_maint
> > 
> > I excluded the core files from the list, as they don't need any specific
> > entry. RC keymaps is also a special case, as I don't think any maintainer
> > is needed for them.
> > 
> > Basically, analyze_build.pl says that there are 613 drivers under
> > drivers/media. The above script shows 348 drivers without an explicit
> > maintainer. So, only 43% of the drivers have a formal maintainer.
> > 
> > Yet, on the list below, I think several of them can be easily tagged as
> > "Odd fixes", like cx88 and saa7134.
> > 
> > I think I'll send today a few RFC MAINTAINERS patches for some stuff below
> > that I can myself be added as "Odd fixes". Yet, I would very much prefer
> > if someone with more time than me could be taking over the "Odd fixes"
> > patches I'll propose.
> 
> These are 'Maintained' by me:
> 
> i2c/aptina-pll.ko              = i2c/aptina-pll.c
> i2c/mt9p031.ko                 = i2c/mt9p031.c
> i2c/mt9t001.ko                 = i2c/mt9t001.c
> i2c/mt9v032.ko                 = i2c/mt9v032.c
> 
> I can maintain the following driver if needed:
> 
> i2c/mt9m032.ko                 = i2c/mt9m032.c

Do you plan to send a MAINTAINERS patch for this driver (and thus maintain the 
driver :-)), or should I maintain it ?

> I could also take over maintenance the following driver, but I don't have
> access to a hardware platform that uses it:
> 
> i2c/mt9v011.ko                 = i2c/mt9v011.c
> 
> These are, as far as I know, co-maintained by Sakari and me :-)
> 
> i2c/adp1653.ko                 = i2c/adp1653.c
> i2c/as3645a.ko                 = i2c/as3645a.c

-- 
Regards,

Laurent Pinchart

