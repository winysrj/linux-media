Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from outbound.icp-qv1-irony-out4.iinet.net.au ([203.59.1.150])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <d.dalton@iinet.net.au>) id 1LPbCT-0007r3-6k
	for linux-dvb@linuxtv.org; Wed, 21 Jan 2009 12:24:51 +0100
Date: Wed, 21 Jan 2009 22:24:36 +1100
From: Daniel Dalton <d.dalton@iinet.net.au>
To: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
Message-ID: <20090121112436.GA3612@debian-hp.lan>
References: <20090120091952.GB6792@debian-hp.lan> <4975B5F1.7000306@iki.fi>
	<20090120220701.GB4150@debian-hp.lan> <49765448.8060108@iki.fi>
	<20090121003915.GA6120@debian-hp.lan>
	<alpine.DEB.2.00.0901210711360.11623@ybpnyubfg.ybpnyqbznva>
	<20090121082412.GA3615@debian-hp.lan>
	<alpine.DEB.2.00.0901210940220.11623@ybpnyubfg.ybpnyqbznva>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0901210940220.11623@ybpnyubfg.ybpnyqbznva>
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

On Wed, Jan 21, 2009 at 10:30:05AM +0100, BOUWSMA Barry wrote:
> On Wed, 21 Jan 2009, Daniel Dalton wrote:
> 
> Here is the latest .config file I have on a random machine
> which includes your device as a module (in case I find one
> that someone has thrown out their window, knowing that is
> more likely than that I'll buy a new machine with PCIe or
> something)...
> 
> CONFIG_DVB_USB_CXUSB=m
> CONFIG_DVB_USB_M920X=m
> CONFIG_DVB_USB_GL861=m
> 
> If I simply delete the middle line, save this .config
> file, and `make O=... oldconfig' I will be asked whether
> I want to add support for the m920x.
> 

Hey! That's very cool, thanks for the tip.

> > > Now, back to using `mplayer':
> > > 
> > > It works from a list of channels, which you will need
> > > to create using a different utility.  It then uses
> > > simple keyboard input to cycle through the list of
> > > channels (I want to think that `k' and something else
> 
> > Excellent, I'll look that up when I get to this point. :-)
> 
> If I may ask, and I do hope that you do not mind me

No, it's not at all a problem.

> asking, but as I recall, you wrote that you did have to
> get help when using one program to try to tune...
> 
> How is your level of vision?  Are you able to make use
> of a video image on your display (the television picture),
> or do you only use an audio-description soundtrack, such

I'm almost totally blind, although I do have a little bit of useful
vision, not enough for making out picture easily on a computer
monitor. But yeah pretty much totally. I use a braille terminal to
access my linux box, so yeah, not even enough vision to read, but got to
admit, it does come in handy when walking and for orientation.
But, it just helps, can't rely on it of course. :-)

> I ask this in case you might be better served by a radio
> application, or even simple commandline scripts that tune
> the audio from the six or so available channels, and do
> not need to bother with a full media player, and so make
> it much simpler -- my listening to the multicast audio

Hmmm, yes, I guess if I just got the audio from the tv network that
could work, although when having friends or family around and watching
tv it might be good to have picture.

> You will know when you try it...
> spiff% mplayer dvb://
> will give you an error.  If it cannot find `channels.conf'
> then it has DVB support...  But if you have a `channels.conf'

Yep, then my version  has dvb support.

> > Um... Ok... Where should this file be located, and am I meant to
> > download it from somewhere?
> 
> It may already be included in your distribution, perhaps
> in /usr/share/somewhere...  But it may be fastest if you
> download the latest version.
> 
> First of all, do you have a program called `scan' or `dvbscan'?
> beer@ralph:~$ which scan

I have both, sorry I should have said.

> If you already have `scan' in your $PATH (see above),
> then you can probably use the following URL...
> http://linuxtv.org/hg/dvb-apps/file/e91138b9bdaa/util/scan/dvb-t/
> 
> The result is a long list (722 items in my local copy)
> but the au-* files are at the start.  Pick the one(s)
> closest to your location.
> 
> Either by invoking `scan --help' or `scan' alone, you
> should see a usage message.  Basically, you need to tell
> it to use the au-Whatever file which you downloaded.
> 

Alright, so, I downloaded the file placed it in /tmp, gave it +rw
permissions and ran:
sudo scan /tmp/au-melbourne
The scan help didn't make a lot of sense to me, but that seemed to do
some stuff like recognise the file, but it found no channels. Are there
any options I should have used? Is the default output format correct?
Or should I start checking my cables and tv points?

Hey, one other thing, and sorry I know it's really OT, but you said you
were a console guy. Have you found a command line web browser with
javascript support? Like how do u get around the javascript thing?
Unfortunately I have been using firefox for this reason...

Thanks very much for all your help, it's greatly appreciated.

Cheers,

Daniel


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
