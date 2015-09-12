Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:34126 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750768AbbILHCJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Sep 2015 03:02:09 -0400
Message-ID: <1442041326.2442.2.camel@xs4all.nl>
Subject: Re: DVBSky T980C CI issues (kernel 4.0.x)
From: Jurgen Kramer <gtmkramer@xs4all.nl>
To: Torbjorn Jansson <torbjorn.jansson@mbox200.swipnet.se>
Cc: linux-media@vger.kernel.org
Date: Sat, 12 Sep 2015 09:02:06 +0200
In-Reply-To: <55F332FE.7040201@mbox200.swipnet.se>
References: <1436697509.2446.14.camel@xs4all.nl>
	 <1440352250.13381.3.camel@xs4all.nl> <55F332FE.7040201@mbox200.swipnet.se>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2015-09-11 at 22:01 +0200, Torbjorn Jansson wrote:
> On 2015-08-23 19:50, Jurgen Kramer wrote:
> >
> > On Sun, 2015-07-12 at 12:38 +0200, Jurgen Kramer wrote:
> >> I have been running a couple of DVBSky T980C's with CIs with success
> >> using an older kernel (3.17.8) with media-build and some added patches
> >> from the mailing list.
> >>
> >> I thought lets try a current 4.0 kernel to see if I no longer need to be
> >> running a custom kernel. Everything works just fine except the CAM
> >> module. I am seeing these:
> >>
> >> [  456.574969] dvb_ca adapter 0: Invalid PC card inserted :(
> >> [  456.626943] dvb_ca adapter 1: Invalid PC card inserted :(
> >> [  456.666932] dvb_ca adapter 2: Invalid PC card inserted :(
> >>
> >> The normal 'CAM detected and initialised' messages to do show up with
> >> 4.0.8
> >>
> >> I am not sure what changed in the recent kernels, what is needed to
> >> debug this?
> >>
> >> Jurgen
> > Retest. I've isolated one T980C on another PC with kernel 4.1.5, still the same 'Invalid PC card inserted :(' message.
> > Even after installed today's media_build from git no improvement.
> >
> > Any hints where to start looking would be appreciated!
> >
> > cimax2.c|h do not seem to have changed. There are changes to
> > dvb_ca_en50221.c
> >
> > Jurgen
> >
> 
> did you get it to work?

No, it needs a thorough debug session. So far no one seems able to
help...

> i got a dvbsky T980C too for dvb-t2 reception and so far the only 
> drivers that have worked at all is the ones from dvbsky directly.
> 
> i was very happy when i noticed that recent kernels have support for it 
> built in but unfortunately only the modules and firmware loads but then 
> nothing actually works.
> i use mythtv and it complains a lot about the signal, running femon also 
> produces lots of errors.
> 
> so i had to switch back to kernel 4.0.4 with mediabuild from dvbsky.
> 
> if there were any other dvb-t2 card with ci support that had better 
> drivers i would change right away.
> 
> one problem i have with the mediabuilt from dvbsky is that at boot the 
> cam never works and i have to first tune a channel, then remove and 
> reinstert the cam to get it to work.
> without that nothing works.
> 
> and finally a problem i ran into when i tried mediabuilt from linuxtv.org.
> fedora uses kernel modules with .ko.xz extension so when you install the 
> mediabuilt modulels you get one modulename.ko and one modulename.ko.xz
> 
> before a make install from mediabuild overwrote the needed modules.
> any advice on how to handle this now?
> 
> 


