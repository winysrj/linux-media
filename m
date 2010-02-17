Return-path: <linux-media-owner@vger.kernel.org>
Received: from web37603.mail.mud.yahoo.com ([209.191.87.86]:34620 "HELO
	web37603.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753182Ab0BQXup (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Feb 2010 18:50:45 -0500
Message-ID: <592995.76165.qm@web37603.mail.mud.yahoo.com>
Date: Wed, 17 Feb 2010 15:50:44 -0800 (PST)
From: Emil Meier <emil276me@yahoo.com>
Subject: Re: alevt-dvb 1.7.0: new version, should be free from bugs now
To: Chicken Shack <chicken.shack@gmx.de>
Cc: Linux media <linux-media@vger.kernel.org>
In-Reply-To: <1266059472.1739.44.camel@brian.bconsult.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



--- On Sat, 2/13/10, Chicken Shack <chicken.shack@gmx.de> wrote:

> From: Chicken Shack <chicken.shack@gmx.de>
> Subject: Re: alevt-dvb 1.7.0: new version, should be free from bugs now
> To: "Francesco Lavra" <francescolavra@interfree.it>
> Cc: "Linux media" <linux-media@vger.kernel.org>
> Date: Saturday, February 13, 2010, 6:11 AM
> Am Samstag, den 13.02.2010, 10:56
> +0100 schrieb Francesco Lavra:
> > On Thu, 2010-02-11 at 22:26 +0100, Chicken Shack
> wrote:
> > > Hi,
> > > 
> > > my way to say "Thank you".
> > > Just enjoy this tiny little program with the
> latest kernel.
> > > Debian files for producing a Debian binary
> included.
> > > This version needs libzvbi as dependency to run.
> > > Thanks to Tom Zoerne for the implemention patch
> that I found by
> > > accident.
> > > 
> > > 
> > > Cheers
> > > CS
> > > 
> > > P. S.: There are two issues in the TODO list.
> > > Please drop me a note if you can fix those issues
> mentioned there.
> > > 
> > > ENJOY!
Does this version work with recent kernels without reverting dvb-demux?

> > 
> > What about adding this program to v4l-dvb (under
> v4l2-apps/util/)?
> > AFAIK, alevt currently doesn't have a proper site
> where development
> > could take place.
> > I think it would enjoy a better maintenance if it was
> hosted in vl4-dvb,
> > and it could be an additional testing tool useful for
> drivers
> > development.
> > And it is GPL-licensed.
> > 
> > Francesco
> 
> Hi Francesco,
> 
> I wish your point of view were right. But it isn't at all.
> 
> There are a couple of reasons for that:
> 
> 1. As long as there is not at least one person doing the
> necessary DVB
> maintenance sponsored by some industry there will never be
> a significant
> change at all.
> The roots of the DVB project were a company called
> Convergence media in
> Cologne, Germany. When this company broke down, the
> relevant persons
> vanished one by one leaving behind their heritage.
> For details ask the administrator of linuxtv.org, Johannes
> Stezenbach.
> 
> 2. Right now the personnel of the DVB development appears
> and vanishes
> whenever they want to. It's completely absurd to build up a
> kernel
> branch nearly only on volunteers, but that's the way it
> is.
> Even Linus Torvalds does not see that there should be a
> change:
> Do everything to win skilled ans sponsored people for the
> work to be
> done.
> 
> 3. I do not trust in the capabilities of the man who is
> maintaining the
> actual dvb-apps. His mouth is too big, his thoughts are
> malicious very
> often, his experience level is rather low, and his
> capabilities aren't
> even mediocre.
> And worst of all: exaggerated egoism instead of real
> partnership work,
> real team work, same problem as with Mauro Carvalho
> Chehab.
> 
> Applying for a job these people wouldn't even pass at least
> one
> so-called assessment test (which is checking out the human
> skills).
> But there seem to be places in the world where this kind of
> tests aren't
> mandatory at all.
> 
> 
> Basic rule: Centralization itself does not resolve any
> problem at all.
> You need qualified people and, as a minimum adequate
> demand, at least
> one sponsored person if the job is not only a "fun bringer"
> but at least
> in significant parts a rather "unthankful" one.
> 
> DVB development at linuxtv.org has been a stepchild for
> more than 5
> years now.
> All the former significant people have vanished.
> 
> As long as this continues we're on our own: It's us picking
> up the
> issues, it's us to investigate etc.
> We cannot continue to delegate issues in the traditional
> paternalistic
> spirit - at least not with these people.
> 
> 
> To get back to the program:
> 
> I still do not comprehend why alevt-dvb hangs when the
> transponder is
> changed.
> I've found out that if you start it without any commandline
> parameters
> it does the following:
> 
> a. read and parse the PAT
> b. read and parse the SDT
> c. read and parse the PMT
> 
> It will always start reading the videotext of the program
> with the first
> found (i. e. the lowest) PMT.
> 
> 2 effects out of its standard behaviour:
> 
> 1. When you change the channel within the current
> transponder the
> program takes a short break and then comes back continuing
> to read the
> same PMT. It will not follow the external player doing the
> tuning to the
> new channel.
> 
> 2. When you change the channel AND change the transponder
> the program
> will hang and will only get finished by _killall_.

Or you can tune back to the original transponder or a transponder with the same provider, then alevt works again.
So there is may be a check for the provider name.
> 
> The task is to change that behaviour. alevt-dvb should
> follow the new
> channel. In mtt (by Gerd Hoffmann @ bytesex.org - xawtv-4.0
> pre) a
> module called dvb-monitor does that job.
> 
> Cheers
> 
> CS
Thanks for your this version.

Emil



      
