Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-17.arcor-online.net ([151.189.21.57]:34621 "EHLO
	mail-in-17.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752440Ab0ETNws (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 May 2010 09:52:48 -0400
Subject: Re: [linux-dvb] Leadtek DVT1000S W/ Phillips saa7134
From: hermann pitton <hermann-pitton@arcor.de>
To: Nathan Metcalf <nmetcalf@starnewsgroup.com.au>
Cc: linux-media@vger.kernel.org, linux-dvb@linuxtv.org
In-Reply-To: <4BF594FF.30505@starnewsgroup.com.au>
References: <4BF583EB.7080505@starnewsgroup.com.au>
	 <1274311695.5829.6.camel@pc07.localdom.local>
	 <4BF594FF.30505@starnewsgroup.com.au>
Content-Type: text/plain
Date: Thu, 20 May 2010 15:52:55 +0200
Message-Id: <1274363575.3169.38.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Freitag, den 21.05.2010, 06:01 +1000 schrieb Nathan Metcalf:
> Thanks Hermann,
> Does this mean I need to apply that patch you linked to me? Then 
> recompile the module and re-insert?
> 
> Regards,
> Nathan

depends on your source. The 2.6.32 has no support for that card and it
depends also on further patches for tuner and demodulator

However, all 4 patches in question are in this pull request

                               Von: 
Mauro Carvalho Chehab
<mchehab@redhat.com>
                                An: 
Linus Torvalds
<torvalds@linux-foundation.org>
                             Kopie: 
Andrew Morton
<akpm@linux-foundation.org>,
linux-kernel@vger.kernel.org,
linux-media@vger.kernel.org
                           Betreff: 
[GIT PULL for 2.6.33] V4L/DVB
updates
                             Datum: 
        Wed, 9 Dec 2009 02:16:39
-0200 (05:16 CET)

and via Michael Krufky and Michael Obst for the remote.
(add the card, fix the entry, add the remote support, fix some coding
style)

You need a kernel >= 2.6.33 or have to build and install mercurial
v4l-dvb from linuxtv.org on older kernels.

The current v4l-dvb is in process to gain deeper compatibility for older
kernels again, see the daily mails.


[cron job] v4l-dvb daily build 
Progress was made from 2.6.33 only a few days ago down to 2.6.25 now. My
latest test was on a 2.6.29. 

Else you can also use a snapshot from May 04 2010, after that backward
compat was limited to 2.6.33 only for a while, see the "v4l-dvb daily
build" messages. For 2.6.32 the recent is good again.

Cheers,
Hermann


> On 20/05/10 09:28, hermann pitton wrote:
> > Hi Nathan,
> >
> > Am Freitag, den 21.05.2010, 04:48 +1000 schrieb Nathan Metcalf:
> >    
> >> Hey Guys,
> >> I hope this is the correct place, I am trying to get a LEADTEK DVT1000S HD Tuner card working in Ubuntu (Latest)
> >> When I load the saa7134_dvb kernel module, there are no errors, but /dev/dvb is not created.
> >>
> >> I have tried enabling the debug=1 option when loading the module, but don't get any more useful information.
> >>
> >> Can someone please assist me? Or direct me to the correct place?
> >>
> >> Regards,
> >> Nathan Metcalf
> >>
> >>      
> > there was some buglet previously, but the card is else supported since
> > Nov. 01 2009 on mercurial v4l-dvb and later kernels.
> >
> > http://linuxtv.org/hg/v4l-dvb/rev/855ee0444e61b8dfe98f495026c4e75c461ce9dd
> >
> > Support for the remote was also added.
> >
> > Cheers,
> > Hermann
> >


