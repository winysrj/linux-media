Return-path: <linux-media-owner@vger.kernel.org>
Received: from web37603.mail.mud.yahoo.com ([209.191.87.86]:36364 "HELO
	web37603.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756515Ab0BRKrv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Feb 2010 05:47:51 -0500
Message-ID: <879845.58459.qm@web37603.mail.mud.yahoo.com>
Date: Thu, 18 Feb 2010 02:47:50 -0800 (PST)
From: Emil Meier <emil276me@yahoo.com>
Subject: Re: alevt-dvb 1.7.0: new version, should be free from bugs now
To: Chicken Shack <chicken.shack@gmx.de>
Cc: Linux media <linux-media@vger.kernel.org>, greg@kroah.com,
	francescolavra@interfree.it
In-Reply-To: <1266483476.1690.50.camel@brian.bconsult.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



--- On Thu, 2/18/10, Chicken Shack <chicken.shack@gmx.de> wrote:

> From: Chicken Shack <chicken.shack@gmx.de>
> Subject: Re: alevt-dvb 1.7.0: new version, should be free from bugs now
> To: "Emil Meier" <emil276me@yahoo.com>
> Cc: "Linux media" <linux-media@vger.kernel.org>, greg@kroah.com, francescolavra@interfree.it
> Date: Thursday, February 18, 2010, 3:57 AM
> Am Mittwoch, den 17.02.2010, 15:50
> -0800 schrieb Emil Meier:
> > 
> > 
> > Or you can tune back to the original transponder or a
> transponder with the same provider, then alevt works again.
> > So there is may be a check for the provider name.
> 
> Not exactly. As long as there is no necessity to reread the
> PAT (Program
> association table) everything is working fine. At the
> current state the
> mechanism (or system call) to restart or reset the reading
> and parsing
> process of PAT, SDT, PMT is missing. And that exactly poses
> the problems
> as soon as you change the transponder......
> As long as you do not change the transponder, PAT, SDT and
> PMT stay the
> same.
> Transponder is not equal to provider........
> google is your friend or have a look at etsi.org.......
> 
Yes, but I have tested a Transponder change, where the Provider name of the new transponder is the same as before, then alevt changes to a new channel (may be the first one) and continues to work again.
As I have edited my kaffeine channels.dvb on my own, I am very sure, that I have changed the transponder...

Is your version 1.7.0 connected to the version 1.7.0 which Uwe Bulga sent to me?
I will test your new version this evening.

As I am using alevt since I think over 10 years, I hope that I can use this application again with vanilla kernels without reverse-patching!!!
At the moment I am using 2.6.32.7 with a reverse patch Uwe sent to me...
This works fine as before...
Maybe 2.6.32.8 can correct the dvb-demux driver.


> The required monitoring demon MUST work independently from
> the external
> player application doing the tuning.
> 
> My current script switches off and restarts alevt at every
> channel
> change, including waitstates so that the player application
> and alevt do
> not interfere when accessing the demux device (->timing
> issue)....
> But that's just a very dirty workaround.....
> 
I will have a look into alevt, why the update and eventhandling stops after changing transponder/provider...
May be I can find something.

> > > The task is to change that behaviour. alevt-dvb
> should
> > > follow the new
> > > channel. In mtt (by Gerd Hoffmann @ bytesex.org -
> xawtv-4.0
> > > pre) a
> > > module called dvb-monitor does that job.
> > > 
> > > Cheers
> > > 
> > > CS
> > Thanks for your this version.
> 
> You're welcome as every other user is.
> 
> > Emil
> 
> Emil and others: Will you please use the appended version?
> 
> I kicked out a nasty error message that printed out an
> error every time
> when alevt was entering a zero entry in the PAT.
> This error message wasn't even relevant for debug purposes,
> so I
> eliminated it.
> I dropped some lines about external dependencies in the
> README file.
> 
> Some critical words on that one:
> 
> http://linuxtv.org/hg/dvb-apps/rev/7de0663facd9
> 
> 1. alevt-dvb is not a DVB-only application. It's core
> origin is to
> address analogue cards. Only within a rather incomplete
> patchset alevt
> can address DVB cards too. In so far that's a bad idea to
> put it into
> the dvb-apps.....
> 
> 2. With the exception of Christoph Pfister who has done a
> very good job
> with the latest kaffeine the personal scenery @ linuxtv.org
> is like a
> rat race in the production of appropriate drivers.
> Production and maintenance of applications is rather
> cemetary-like @
> linuxtv.org, i. e. de facto not existing.
> 
> It's for instance hihghly questionable why there are still
> 2 formats for
> a channels.conf file (vdr format and the reduced zap
> format).
> The zap format is obsolete IMHO.
> 
> As the situation is as it is, this expectation at least
> sounds utmost
> naive and has got nothing to do with reality as it is:
> 
> "What about adding this program to v4l-dvb (under
> v4l2-apps/util/)?
> AFAIK, alevt currently doesn't have a proper site where
> development
> could take place. I think it would enjoy a better
> maintenance if it was
> hosted in vl4-dvb, and it could be an additional testing
> tool useful for
> drivers development. And it is GPL-licensed. (Francesco
> Lavra)"
> 
> For Greg Kroah-Hartman:
> 
> This one should go into kernel 2.6.32, just to close a gap
> of kernel
> regressions:
> 
> http://linuxtv.org/hg/v4l-dvb/rev/2dfe2234e7ea
> 
> ENJOY!
> 
> CS
> 
> 
Thanks 
Emil


      
