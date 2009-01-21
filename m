Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ug-out-1314.google.com ([66.249.92.168])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <freebeer.bouwsma@gmail.com>) id 1LPXcu-0005gx-R7
	for linux-dvb@linuxtv.org; Wed, 21 Jan 2009 08:35:55 +0100
Received: by ug-out-1314.google.com with SMTP id x30so307209ugc.16
	for <linux-dvb@linuxtv.org>; Tue, 20 Jan 2009 23:35:49 -0800 (PST)
Date: Wed, 21 Jan 2009 08:35:41 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: Daniel Dalton <d.dalton@iinet.net.au>
In-Reply-To: <20090121003915.GA6120@debian-hp.lan>
Message-ID: <alpine.DEB.2.00.0901210711360.11623@ybpnyubfg.ybpnyqbznva>
References: <20090120091952.GB6792@debian-hp.lan> <4975B5F1.7000306@iki.fi>
	<20090120220701.GB4150@debian-hp.lan> <49765448.8060108@iki.fi>
	<20090121003915.GA6120@debian-hp.lan>
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

Hi Daniel, I see that while I was asleep (sleep GOOOD), you
received more feedback, so I shall try to respond appropriately
to parts of all these mails...

On Wed, 21 Jan 2009, Daniel Dalton wrote:

> Does this mean I have to build the kernel?
> If so, how do I get to this part of the setup what's it under in make
> menuconfig for example?

Not necessarily -- as it turned out, your distribution
seems to include all that you needed pre-built for you.

However, to answer your question -- as part of the long
and tedious process of configuring a new kernel, eventually
you will reach an item concerning video and related
multimedia devices, or something similar.  (It has been
years since I last went through a from-nothing kernel
configuration, so I remember almost nothing about it.)
Your device would be listed as one of the many that are
available.

Sorry that I am not being more precise -- you do not now
need to do this, so I am skipping the details yet offering
an overview which may be helpful to you in the future.


> > One thing you can do, is to plug your device into the USB port
> > (if you haven't done so already), and check the output of
> > `lsusb' for your device vendor and product IDs, to see if
> > these match those in the source code.
> 
> What source code? The stuff you pasted above?

This is no longer important, but you asked, so maybe it
can help you in the future...

The source code I refer to is that for the linux kernel,
and for your device, it would be found in
<path-to-your-source>/drivers/media/dvb/dvb-usb in
files m920x.*
Here you need to replace <path-to-your-source> with
whatever the standard is on your system -- it could be
/usr/src/linux-2.6.26 or something completely different --
I actually have no experience with the different
distributions, because I keep my own copy of Linus'
source tree and make snapshots from that.

Note that at present, you do *not* need to do this, as
your distribution has the binary bits you need.  But
if your curiosity makes you want to learn more about
how you can build a new kernel from source, I am not
going to try to stop you -- on the contrary, I will
encourage you to learn as much as you like!


> > I'm unsure of your level as a beginner, expert, or master of

> I'm not bad in a console, but I'm mostly a home user I just use it for
> work music browsing the web etc, and know a bit more. I can compile and
> patch stuff, and know a tiny bit of c, so thats basically my level.

Thanks, I will try to tune my advice to your level,
yet perhaps also keep in mind someone who googles up
this reply, with a different level of experience...


> > > Finally, I'm vission impared, so are there any programs for controling

> > Similarly for this reason, someone else will have to offer
> > help on convenient end-user applications.  (I can offer
> > good commandline suggestions, but `gtk' and `qt' have on
> > meaning to me)
> 
> Can you recommend any command line programs? I love using the cli, and
> if possible I would avoid using gnome.
> Can mplayer control the tv?

Yes, `mplayer' can do this, but it requires a bit of work
and perhaps some understanding.  Let me explain the latter...

`mplayer' is a wonderful all-purpose swiss-army-knife type
of media player, that achieves flexibility, but may not
seem as polished to the beginner.  The `man' page alone is
often enough to cause a beginner's eyes to glaze over and
for them to start going ``wibble'' before they even get to
the interesting options.

Due to the flexibility of `mplayer', it needs to try to
determine the one out of many many different video formats
which it supports, which takes some time when handling a
broadcast stream.  This results in very slow channel
change times, compared with, say, a good hardware-based
consumer product.

There are ways to speed this up, because I know that in
my experience with broadcast media, I am only going to be
seeing (presently) an MPEG Transport Stream from my DVB
device, and that will be carrying a payload that will be
MPEG 2 video (or maybe H.264), and Layer II or AC3 audio.

I have built a small-footprint version of `mplayer' by
manually editing the configuration to only include the
code for the video, audio, and container formats that
I expect to use that version for (in my case, verifying
the integrity of recorded broadcast streams, but not
actually sending the output to any video display).

The other thing which can be done, is to call `mplayer'
with the commandline options which tell it what demux
to use (mpeg ts) and which video and audio codecs to
use, which skips most of the autodetection process.
This probably will speed up changing channels, to the
speed of dedicated utilities that handle a single
format, and essentially instantly start to deliver the
output when, in my example, I tune into a multicast
audio stream.



Now, back to using `mplayer':

It works from a list of channels, which you will need
to create using a different utility.  It then uses
simple keyboard input to cycle through the list of
channels (I want to think that `k' and something else
are used, but I honestly no longer remember), which
is not too bad when you have only a few channels
available.

(Unfortunately, in my experience, older versions of
`mplayer' have had some problems with keyboard input
in some cases, such as after suspending the program,
and perhaps when tuning after coming across more than
one radio-only service, if I remember.  But I have not
built and tried a new `mplayer' for some months...)

Read on, as you have already tried without success to
get a list of channels...


> > Totem, Me-TV, Kaffeine, mplayer, Xine.
> 
> Mplayer works with this card? Great!

Also, I have not had experience with the first three
applications which Antti listed, but I have used
`xine' as well as `vlc', but I cannot remember how
well they worked for me.

Except for `vlc' trying to listen to the multicast
audio stream, where some blasted graphical display
was invoked and took more than 100% of my CPU and
caused audio dropouts, and I saw no way to disable that
eye-candy and drop CPU to a near-zero level even on
my ten-year-old machines.


> How would I begin configuring it for mplayer then?

You need to create a `channels.conf' list of channels
that you then place under your ~/.mplayer/ directory.
Then if you want to start with a particular channel,
you will invoke `mplayer' something like
`mplayer dvb://"Channel foo" '
or simply as `mplayer dvb:// ' and then change channels
to reach the one of interest.

I am going to assume that your distribution already has
`mplayer' available, and that it has been built with
DVB support.  But this may be wrong, and it may be that
you need to download the `mplayer' source, configure it
to enable DVB support, and then let it build.


> On Wed, Jan 21, 2009 at 12:46:32AM +0200, Antti Palosaari wrote:
> > Yes, should work out of the box. No need to install any driver, driver 
> > is included in your Kernel.
> 
> /dev/dvb/adapter0/ is created. so does this mean the right modules have
> been loaded?

Yes, everything is fine, and you should not need to do
anything building a new kernel or new modules.


> > configure. Otherwise you will need initial tuning file and then scan to 
> > get channels.conf. Try google for more info.
> 
> I've been googling, and have played with w_scan and me-tv.
> Kaffeine unfortunately is qt and won't work with braille/speech, but
> me-tv does. So I got sighted help to scan for channels in kaffeine, the
> scan didn't find any channels.
> Next, I ran the w_scan program, and that as well failed to find any
> channels. Finally, I ran me-tv and that as well failed. (I selected my
> location for me-tv).

It may help if you use `scan' which is part of the `dvb-apps'
suite of programs.  This makes use of an initial tuning file,
and there should be one already available for your location.

I vaguely remember reading that in Australia, use is made of
either an offset to the frequency, or of a bandwidth that is
different from the rest of the world, which has led to
problems with certain firmware.  And in fact, looking at the
initial scanfiles available for .au, both appear to be so:

# Australia / Melbourne (Mt Dandenong transmitters)
# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
# ABC
T 226500000 7MHz 3/4 NONE QAM64 8k 1/16 NONE
# Seven
T 177500000 7MHz 3/4 NONE QAM64 8k 1/16 NONE
# Nine
T 191625000 7MHz 3/4 NONE QAM64 8k 1/16 NONE
# Ten
T 219500000 7MHz 3/4 NONE QAM64 8k 1/16 NONE
# SBS
T 536625000 7MHz 2/3 NONE QAM64 8k 1/8 NONE


Make certain that you select the correct initial scan file
for your location, available as part of the `dvb-apps'
package -- here you probably will do best to obtain the
latest source via `hg' because the scanfiles may not be
up-to-date as included in a distribution, although the
binary should be mostly unchanged.


> So, how do I get w_scan or me-tv to find some channels? It's probably

While I have the `w_scan' source mirrored, I actually
have not taken any time to look at it :-)  Perhaps it
is not able to find frequencies such as the above...


> not worth talking about kaffeine as I won't be able to use this. I'm
> plugging my usb receiver into a tv connection in my home which a
> standard tv would plug into.

If you continue to have problems, then later I will ask
for information to help troubleshoot -- such as your
location, and whether a normal digital TV can receive
signals from the same connection.  But I am hoping that
use of `scan' alone will give you results.


> Thanks very much for your help,

Happy to help.  If I have done anything in my replies
that has not worked with your vision, then please do not
hesitate to give me feedback, so that I can change my
way of thinking.


barry bouwsma

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
