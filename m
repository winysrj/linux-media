Return-path: <linux-media-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:55161 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511Ab2KCJZj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 3 Nov 2012 05:25:39 -0400
Date: Sat, 3 Nov 2012 10:25:20 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	linux1394-devel@lists.sourceforge.net
Subject: [PATCH] firedtv: add MAINTAINERS entry
Message-ID: <20121103102520.2babeb29@stein>
In-Reply-To: <20121102111310.755e38aa@gaivota.chehab>
References: <201210221035.56897.hverkuil@xs4all.nl>
	<20121025152701.0f4145c8@redhat.com>
	<201211011644.50882.hverkuil@xs4all.nl>
	<20121101141244.6c72242c@redhat.com>
	<20121102111310.755e38aa@gaivota.chehab>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is currently discussion to add MAINTAINERS records for media
drivers that don't have one yet, possibly with 'orphan' or 'odd fixes'
status.  Here is a proper entry for the firedtv driver (for 1394
attached DVB STBs and 1394 attached DVB cards from Digital Everywhere).

The L: linux-media and T: linux-media.git lines in this entry are
redundant to what scripts/get_maintainer.pl would show automatically but
I added them for folks who read MAINTAINERS directly.  The "(firedtv)"
string is for those folks as well if they look for driver name rather
than file path.

The F: drivers/media/firewire/ pattern and the "FireWire media drivers"
title are currently synonymous with firedtv.  If more drivers get added
there, this can be revisited.

I don't have documentation or DVB-S2 devices to test, but I have DVB-C
and DVB-T devices for testing.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 MAINTAINERS |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3041,6 +3041,14 @@ T:	git git://git.alsa-project.org/alsa-k
 S:	Maintained
 F:	sound/firewire/
 
+FIREWIRE MEDIA DRIVERS (firedtv)
+M:	Stefan Richter <stefanr@s5r6.in-berlin.de>
+L:	linux-media@vger.kernel.org
+L:	linux1394-devel@lists.sourceforge.net
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media.git
+S:	Maintained
+F:	drivers/media/firewire/
+
 FIREWIRE SBP-2 TARGET
 M:	Chris Boot <bootc@bootc.net>
 L:	linux-scsi@vger.kernel.org



On Nov 02 Mauro Carvalho Chehab wrote:
> Em Thu, 1 Nov 2012 14:12:44 -0200
> Mauro Carvalho Chehab <mchehab@redhat.com> escreveu:
> 
> > Em Thu, 1 Nov 2012 16:44:50 +0100
> > Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> > 

(thread [media-workshop] Tentative Agenda for the November workshop)
> > > On Thu October 25 2012 19:27:01 Mauro Carvalho Chehab wrote:
> > > > I have an extra theme for discussions there: what should we do with the drivers
> > > > that don't have any MAINTAINERS entry.
[...]
> > > > It probably makes sense to mark them as "Orphan" (or, at least, have some
> > > > criteria to mark them as such). Perhaps before doing that, we could try
> > > > to see if are there any developer at the community with time and patience
> > > > to handle them.
> > > > 
> > > > This could of course be handled as part of the discussions about how to improve
> > > > the merge process, but I suspect that this could generate enough discussions
> > > > to be handled as a separate theme.
> > > 
> > > Do we have a 'Maintainer-Light' category? I have a lot of hardware that I can
> > > test. So while I wouldn't like to be marked as 'The Maintainer of driver X'
> > > (since I simply don't have the time for that), I wouldn't mind being marked as
> > > someone who can at least test patches if needed.
> > 
> > There are several "maintainance" status there: 
> > 
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
> > (btw, I just realized that I should be changing the EDAC drivers I maintain
> >  to Supported; the media drivers I maintain should be kept as Maintained).
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
> > > > [1] Letting get_maintainer.pl is very time/CPU consuming. Letting it would 
> > > > delay a lot the patch review process, if applied for every patch, with
> > > > unreliable and doubtful results. I don't do it, due to the large volume
> > > > of patches, and because the 'other' results aren't typically the driver
> > > > maintainer.
> > > > 
> > > > An example of this is the results for a patch I just applied
> > > > (changeset 2866aed103b915ca8ba0ff76d5790caea4e62ced):
> > > > 
> > > > 	$ git show --pretty=email|./scripts/get_maintainer.pl
[...]
> > > > The driver author (Hongjun Chen <hong-jun.chen@freescale.com>) was not even
> > > > shown there, and the co-author got only 15% hit, while I got 100% and Hans
> > > > got 57%.
> > > > 
> > > > This happens not only to this driver. In a matter of fact, on most cases where
> > > > no MAINTAINERS entry exist, the driver's author gets a very small hit chance,
> > > > as, on several of those drivers, the author doesn't post anything else but
> > > > the initial patch series.
> > > 
> > > We probably need to have an entry for all the media drivers, even if it just
> > > points to the linux-media mailinglist as being the 'collective default maintainer'.
> > 
> > Yes, I think that all media drivers should be there. I prefer to tag the ones
> > that nobody sends us a MAINTAINERS entry with "Orphan", as this tag indicates
> > that help is wanted. 
> 
> I wrote a small shell script to see what's missing, using the analyze_build.pl script
> at media-build devel_scripts dir:
> 
> 	DIR=$(dirname $0)
> 
> 	$DIR/analyze_build.pl --path drivers/media/ --show_files_per_module >/tmp/all_drivers
> 	grep drivers/media/ MAINTAINERS | perl -ne 's/F:\s+//;s,drivers/media/,,; print $_ if (!/^\n/)' >maintained
> 	grep -v -f maintained /tmp/all_drivers |grep -v -e keymaps -e v4l2-core/ -e dvb-core/ -e media.ko -e rc-core.ko -e ^#| sort >without_maint
> 
> I excluded the core files from the list, as they don't need any specific entry. RC
> keymaps is also a special case, as I don't think any maintainer is needed for them.
> 
> Basically, analyze_build.pl says that there are 613 drivers under drivers/media.
> The above script shows 348 drivers without an explicit maintainer. So, only 43%
> of the drivers have a formal maintainer.
[...]

-- 
Stefan Richter
-=====-===-- =-== ---==
http://arcgraph.de/sr/
