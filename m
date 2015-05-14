Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:36748 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422786AbbENVkr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 May 2015 17:40:47 -0400
Date: Thu, 14 May 2015 18:40:40 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Patrick Boettcher <patrick.boettcher@posteo.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Jemma Denson <jdenson@gmail.com>
Subject: Re: [PULL] For 4.2 (or even 4.1?) add support for cx24120/Technisat
 SkyStar S2
Message-ID: <20150514184040.094c8a95@recife.lan>
In-Reply-To: <20150429085526.655677d8@recife.lan>
References: <20150420092720.3cb092ba@dibcom294.coe.adi.dibcom.com>
	<20150427171628.5ba22752@recife.lan>
	<20150427232523.08c1c8f1@lappi3.parrot.biz>
	<20150427214022.1ff9f61f@recife.lan>
	<20150429133501.38eacfa0@dibcom294.coe.adi.dibcom.com>
	<20150429085526.655677d8@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 29 Apr 2015 08:55:26 -0300
Mauro Carvalho Chehab <mchehab@osg.samsung.com> escreveu:

> Em Wed, 29 Apr 2015 13:35:01 +0200
> Patrick Boettcher <patrick.boettcher@posteo.de> escreveu:
> 
> > Hi Mauro,
> > 
> > On Mon, 27 Apr 2015 21:40:22 -0300 Mauro Carvalho Chehab
> > <mchehab@osg.samsung.com> wrote:
> > > > Could we send an additional patch for coding-style or would you prefer
> > > > a new patch which has everything inside? This would maintain the
> > > > author-attribution of the initial commit.
> > > 
> > > An additional patch is fine.
> > 
> > I fixed the files cx24120.[ch] in a --strict manner. 
> 
> Thanks
> 
> > Do you want me to
> > send each of these patches to the list? They are not really
> > interesting. But if it might help to review for any obvious mistakes...
> 
> Yes, please send to ML.

Ping.

I'll be marking the original patch at patchwork:
	http://patchwork.linuxtv.org/patch/29162/

As changes requested.

Please submit the new version of the pull request when ready.

Thanks!
Mauro


> 
> > I rebased my tree on the media-tree of this morning.
> 
> Ok.
> 
> > I checked the fe_stat-stuff and I saw that you need to keep the old
> > unc, ber and snr functions anyway.
> 
> For now, yes.
> 
> > I doubt that the cx24120 in its current state reports anything useful
> > for statistical uses. Do you think there is an added value adding
> > it to a driver which is very simple in this regards?
> 
> The thing is that we'll need/want to remove the DVBv3 stats support
> from the drivers, and add some code inside the core to keep backward
> support.
> 
> So, it is more like avoiding the need of rework on it latter.
> Now that the driver is fresh, people have the hardware in hands to
> check if something doesn't break with the conversion. If this got
> postponed, the one doing the conversion may not have the hardware
> anymore, with could cause regressions.
> 
> > Regarding the wait for channel-lock I think it could be written
> > differently using a state and checking in the get_status-function
> > whether it is locked for the first time. This will need testing. I
> > haven't done it yet.
> 
> Well, as this was not merged on 4.2 and we're at -rc1, we have some
> time to address the needs. Just try to send me a new pull request
> up to -rc5 (or, at most, at beginning of the -rc6 week), or otherwise
> it could be postponed to 4.3.
> 
> Regards,
> Mauro
