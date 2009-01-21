Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from outbound.icp-qv1-irony-out2.iinet.net.au ([203.59.1.107])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <d.dalton@iinet.net.au>) id 1LPYNq-00006g-0Q
	for linux-dvb@linuxtv.org; Wed, 21 Jan 2009 09:24:23 +0100
Date: Wed, 21 Jan 2009 19:24:12 +1100
From: Daniel Dalton <d.dalton@iinet.net.au>
To: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
Message-ID: <20090121082412.GA3615@debian-hp.lan>
References: <20090120091952.GB6792@debian-hp.lan> <4975B5F1.7000306@iki.fi>
	<20090120220701.GB4150@debian-hp.lan> <49765448.8060108@iki.fi>
	<20090121003915.GA6120@debian-hp.lan>
	<alpine.DEB.2.00.0901210711360.11623@ybpnyubfg.ybpnyqbznva>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0901210711360.11623@ybpnyubfg.ybpnyqbznva>
Cc: DVB mailin' list thingy <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] getting started with msi tv card
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi Barry,

> you will reach an item concerning video and related
> multimedia devices, or something similar.  (It has been
> years since I last went through a from-nothing kernel
> configuration, so I remember almost nothing about it.)
> Your device would be listed as one of the many that are
> available.
> 
> Sorry that I am not being more precise -- you do not now
> need to do this, so I am skipping the details yet offering
> an overview which may be helpful to you in the future.

Thanks for that, it's good to know, yep, I've built kernels, using make
oldconfig many times for a speakup patch i use on my laptop, but that's
nice to know.

> can help you in the future...
> 
> The source code I refer to is that for the linux kernel,
> and for your device, it would be found in
> <path-to-your-source>/drivers/media/dvb/dvb-usb in
> files m920x.*

Ah, that makes sense.

> Now, back to using `mplayer':
> 
> It works from a list of channels, which you will need
> to create using a different utility.  It then uses
> simple keyboard input to cycle through the list of
> channels (I want to think that `k' and something else
> are used, but I honestly no longer remember), which
> is not too bad when you have only a few channels
> available.

Excellent, I'll look that up when I get to this point. :-)

> > How would I begin configuring it for mplayer then?
> 
> You need to create a `channels.conf' list of channels
> that you then place under your ~/.mplayer/ directory.
> Then if you want to start with a particular channel,
> you will invoke `mplayer' something like
> `mplayer dvb://"Channel foo" '
> or simply as `mplayer dvb:// ' and then change channels
> to reach the one of interest.

Ah, ok.

> 
> I am going to assume that your distribution already has
> `mplayer' available, and that it has been built with

It does. 

> DVB support.  But this may be wrong, and it may be that

Not sure about this one.

> It may help if you use `scan' which is part of the `dvb-apps'
> suite of programs.  This makes use of an initial tuning file,
> and there should be one already available for your location.

Um... Ok... Where should this file be located, and am I meant to
download it from somewhere?
So does it use this file to create a suitable channels.conf file for
mplayer?

> Make certain that you select the correct initial scan file
> for your location, available as part of the `dvb-apps'
> package -- here you probably will do best to obtain the
> latest source via `hg' because the scanfiles may not be
> up-to-date as included in a distribution, although the
> binary should be mostly unchanged.

Sorry... what's hg?
And once I grab the latest source what should I do to run this scan to
create channels.conf? And where do I find the file for my location?

> signals from the same connection.  But I am hoping that

I should check this your right.

> Happy to help.  If I have done anything in my replies
> that has not worked with your vision, then please do not
> hesitate to give me feedback, so that I can change my
> way of thinking.

Nup, you have done an awesome job.

Thanks very much mate for all your help, and I'm very sorry about all
the questions.

Have a good one

Cheers,

Daniel


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
