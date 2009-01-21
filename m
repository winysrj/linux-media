Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ug-out-1314.google.com ([66.249.92.171])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <freebeer.bouwsma@gmail.com>) id 1LPZPh-0005uQ-23
	for linux-dvb@linuxtv.org; Wed, 21 Jan 2009 10:30:22 +0100
Received: by ug-out-1314.google.com with SMTP id x30so311557ugc.16
	for <linux-dvb@linuxtv.org>; Wed, 21 Jan 2009 01:30:17 -0800 (PST)
Date: Wed, 21 Jan 2009 10:30:05 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: Daniel Dalton <d.dalton@iinet.net.au>
In-Reply-To: <20090121082412.GA3615@debian-hp.lan>
Message-ID: <alpine.DEB.2.00.0901210940220.11623@ybpnyubfg.ybpnyqbznva>
References: <20090120091952.GB6792@debian-hp.lan> <4975B5F1.7000306@iki.fi>
	<20090120220701.GB4150@debian-hp.lan> <49765448.8060108@iki.fi>
	<20090121003915.GA6120@debian-hp.lan>
	<alpine.DEB.2.00.0901210711360.11623@ybpnyubfg.ybpnyqbznva>
	<20090121082412.GA3615@debian-hp.lan>
MIME-Version: 1.0
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

On Wed, 21 Jan 2009, Daniel Dalton wrote:

> > you will reach an item concerning video and related
> > multimedia devices, or something similar.  (It has been
> > years since I last went through a from-nothing kernel
> > configuration, so I remember almost nothing about it.)

> Thanks for that, it's good to know, yep, I've built kernels, using make
> oldconfig many times for a speakup patch i use on my laptop, but that's

Excellent, `oldconfig' is the way I build newer or modified
kernels myself.

I have always stripped my kernels down to the bare minimum
needed, including modules for hardware I don't yet have or
don't know about.  So often I need to enable a disabled
device.  It's easy to do, and I'll give you an example, if
you want to try this and see how it works:

Here is the latest .config file I have on a random machine
which includes your device as a module (in case I find one
that someone has thrown out their window, knowing that is
more likely than that I'll buy a new machine with PCIe or
something)...

CONFIG_DVB_USB_CXUSB=m
CONFIG_DVB_USB_M920X=m
CONFIG_DVB_USB_GL861=m

If I simply delete the middle line, save this .config
file, and `make O=... oldconfig' I will be asked whether
I want to add support for the m920x.

If I read upwards from this point in .config, I see some
comments that this is reached through:
# Supported USB Adapters
# Multimedia drivers
# Multimedia core support
# Multimedia devices


> > Now, back to using `mplayer':
> > 
> > It works from a list of channels, which you will need
> > to create using a different utility.  It then uses
> > simple keyboard input to cycle through the list of
> > channels (I want to think that `k' and something else

> Excellent, I'll look that up when I get to this point. :-)

If I may ask, and I do hope that you do not mind me
asking, but as I recall, you wrote that you did have to
get help when using one program to try to tune...

How is your level of vision?  Are you able to make use
of a video image on your display (the television picture),
or do you only use an audio-description soundtrack, such
as is provided by the larger british and public german
broadcasters, among others?

I ask this in case you might be better served by a radio
application, or even simple commandline scripts that tune
the audio from the six or so available channels, and do
not need to bother with a full media player, and so make
it much simpler -- my listening to the multicast audio
now, is done by three or four building-block utilities
piped together at the sending end, and two simple
commandline utilities at my listening end, with no need
to use a massive, bloated media player (except to
check compatibility).

Naturally, if you have some vision, then a full media
player like `mplayer' will be a better solution...


> > I am going to assume that your distribution already has
> > `mplayer' available, and that it has been built with
> 
> It does. 
> 
> > DVB support.  But this may be wrong, and it may be that
> 
> Not sure about this one.

You will know when you try it...
spiff% mplayer dvb://
will give you an error.  If it cannot find `channels.conf'
then it has DVB support...  But if you have a `channels.conf'
file and still get an error, then probably you will need to
build a new version.  You will see when you reach that
point...


> > It may help if you use `scan' which is part of the `dvb-apps'
> > suite of programs.  This makes use of an initial tuning file,
> > and there should be one already available for your location.
> 
> Um... Ok... Where should this file be located, and am I meant to
> download it from somewhere?

It may already be included in your distribution, perhaps
in /usr/share/somewhere...  But it may be fastest if you
download the latest version.

First of all, do you have a program called `scan' or `dvbscan'?
beer@ralph:~$ which scan
/usr/local/bin/scan
beer@ralph:~$ which dvbscan
/usr/local/bin/dvbscan

If not, then you either need to install a binary package,
or download and build the source.  I will assume you do
have `scan' available, to make it easier  :-)


> So does it use this [initial scan] file to create a suitable
> channels.conf file for mplayer?

That is correct.  The scanfile contains the tuning data
for the available frequencies and transmitters in your
area; from this `scan' tunes these frequencies, and
finds the up-to-date available services.  This list of
services is then written out to stdout, or to a file which
can be used as the channels.conf tuning file for mplayer
or several other utilities (such as `tzap', part of dvb-apps).


> > Make certain that you select the correct initial scan file
> > for your location, available as part of the `dvb-apps'
> > package -- here you probably will do best to obtain the
> > latest source via `hg' because the scanfiles may not be

> Sorry... what's hg?

`hg' refers to Mercurial, the source control system used
by the dvb-apps package, as well as the linux-dvb kernel module.

Details about this can be found at http://linuxtv.org/  somewhere.


> And once I grab the latest source what should I do to run this scan to
> create channels.conf? And where do I find the file for my location?

If you already have `scan' in your $PATH (see above),
then you can probably use the following URL...
http://linuxtv.org/hg/dvb-apps/file/e91138b9bdaa/util/scan/dvb-t/

The result is a long list (722 items in my local copy)
but the au-* files are at the start.  Pick the one(s)
closest to your location.

Either by invoking `scan --help' or `scan' alone, you
should see a usage message.  Basically, you need to tell
it to use the au-Whatever file which you downloaded.


> Thanks very much mate for all your help, and I'm very sorry about all
> the questions.

No need to be sorry.  If I can answer your questions,
than that should mean I have an understanding of what
you need to know, and how things work.  Or that I'm
good enough at BS to find work somewhere.

If I cannot, then my experience is not broad enough
(which I readily admit), and I hope someone will fill
in the missing bits.

If I have done my job, then I should have not only
given or hinted at the answers, but also have given
the information needed to find these answers as well.


Anway, feel free to ask more questions, either about
specific problems you have trying to scan or tune, or
more general questions in case you want to know more
about some things I have tried not to answer in detail.


thanks,
barry bouwsma

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
