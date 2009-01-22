Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from outbound.icp-qv1-irony-out1.iinet.net.au ([203.59.1.108])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <d.dalton@iinet.net.au>) id 1LPvoq-0004Ui-Si
	for linux-dvb@linuxtv.org; Thu, 22 Jan 2009 10:25:50 +0100
Date: Thu, 22 Jan 2009 20:25:39 +1100
From: Daniel Dalton <d.dalton@iinet.net.au>
To: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
Message-ID: <20090122092539.GA14123@debian-hp.lan>
References: <20090120091952.GB6792@debian-hp.lan> <4975B5F1.7000306@iki.fi>
	<20090120220701.GB4150@debian-hp.lan> <49765448.8060108@iki.fi>
	<20090121003915.GA6120@debian-hp.lan>
	<alpine.DEB.2.00.0901210711360.11623@ybpnyubfg.ybpnyqbznva>
	<20090121082412.GA3615@debian-hp.lan>
	<alpine.DEB.2.00.0901210940220.11623@ybpnyubfg.ybpnyqbznva>
	<20090121112436.GA3612@debian-hp.lan>
	<alpine.DEB.2.00.0901211226220.11623@ybpnyubfg.ybpnyqbznva>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0901211226220.11623@ybpnyubfg.ybpnyqbznva>
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

> things, and do not need to change between channels all the
> time, you can easily write a quick script to tune and play
> the audio.  If you still wanted to be able to change between
> channels easily, I'm sure it would be no problem to write a
> wrapper script to do this.  Then you can pull out `mplayer'

Hi Barry,

I'm chopping out the script, just to cut the size of this reply
down. But, thanks very much for sending the script, it looks good, and
yep, I think I'll find that very useful once I get tv going on my box.

> > Alright, so, I downloaded the file placed it in /tmp, gave it +rw
> > permissions and ran:
> > sudo scan /tmp/au-melbourne
> 
> Okay, first of all, you should be able to do this as a
> normal user -- not `sudo' (sorry, I've been spending too
> much time reading Slashdot where people have been discussing

Ah, thanks for the tip, yep I'm in a bad habit of that, thanks for the
reminder :-)

> But first, one useful option would be `-v' to verbosely
> scan, which can show some details about why you cannot
> tune.
> 

Please see the mail I sent directly to you off-list.

> That is, if `scan' gives no useful output with a scanfile
> that you know should be correct (and you are welcome to
> post the results of scanning, either in private mail or
> cut down to the attempts for two or three frequencies to
> the mailing list), then there may be a problem outside
> of your USB tuner and computer.

I'm connecting it to a co-axle point in my home; I lost the original
antenna.
I'm reasonably sure that point should work fine.

> > Hey, one other thing, and sorry I know it's really OT, but you said you
> > were a console guy. Have you found a command line web browser with
> > javascript support? Like how do u get around the javascript thing?
> 
> Out of habit, I do all my browsing with `lynx' (my fingers

I do the same, I love lynx. It is a fantastic browser with a braille
terminal, and recently when I have been using speech on my laptop, so I
don't have to carry the display around (speech is terrible by itself),
lynx works very nice as well.

> My attitude to sites with javascript is that I don't bother
> with them, as I'm searching for info in text format (ASCII
> PR0N FOR THE MASSES!  mplayer supports aalib!  no need for

Ah, ok. I kinda do the same :-)

> Unfortunately, that's not a real solution, and I did have
> to install Iceape to access the configuration of my router,
> as I'm too cheap to buy one with a ssh interface that
> allows access to the nvram settings.  And that doesn't

I ended up doing that since those interfaces aren't nice with lynx or
braille (i can use firefox, but they aren't great when it comes to
accessibility), so I really like my ssh router.

The voip ata doesn't have ssh and it's just lucky that the interface is
managable with a braille display.

> Sorry I can't help much there...

No worries, it's just good to know how others handle specific problems.

Thanks very much for all your help with everything.

Cheers,
Daniel.

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
