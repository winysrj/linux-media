Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ug-out-1314.google.com ([66.249.92.170])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <freebeer.bouwsma@gmail.com>) id 1LPbyC-00045d-VI
	for linux-dvb@linuxtv.org; Wed, 21 Jan 2009 13:14:10 +0100
Received: by ug-out-1314.google.com with SMTP id x30so320126ugc.16
	for <linux-dvb@linuxtv.org>; Wed, 21 Jan 2009 04:14:05 -0800 (PST)
Date: Wed, 21 Jan 2009 13:13:55 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: Daniel Dalton <d.dalton@iinet.net.au>
In-Reply-To: <20090121112436.GA3612@debian-hp.lan>
Message-ID: <alpine.DEB.2.00.0901211226220.11623@ybpnyubfg.ybpnyqbznva>
References: <20090120091952.GB6792@debian-hp.lan> <4975B5F1.7000306@iki.fi>
	<20090120220701.GB4150@debian-hp.lan> <49765448.8060108@iki.fi>
	<20090121003915.GA6120@debian-hp.lan>
	<alpine.DEB.2.00.0901210711360.11623@ybpnyubfg.ybpnyqbznva>
	<20090121082412.GA3615@debian-hp.lan>
	<alpine.DEB.2.00.0901210940220.11623@ybpnyubfg.ybpnyqbznva>
	<20090121112436.GA3612@debian-hp.lan>
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

> > I ask this in case you might be better served by a radio
> > application, or even simple commandline scripts that tune
> > the audio from the six or so available channels, and do
> > not need to bother with a full media player, and so make

> Hmmm, yes, I guess if I just got the audio from the tv network that
> could work, although when having friends or family around and watching
> tv it might be good to have picture.

Yes, I was thinking about having the video for others, if
it would not be so useful for you.

Anyway, I think you will be able to use `mplayer', although
if I were in your situation (sorry, I am mostly sighted, but
with age, I can be easily called ``blind-as-a-bat'' -- I am
nearsighted, which is a blessing when working on micro-sized
electronics, or when looking at details, or when counting the
number of baby spiders (harmless, the nice thing about having
european spiders adopt me as their keeper) currently resident
in my pot-of-winter-weeds, so anything more than 20cm away
requires glasses, but unfortunately, I have lost flexibility
so that while I can see several metres away, I cannot focus
on a notebook monitor or nearby screen until I go out and
get myself another pair of glasses for working and reading,
and so a nice 25x80 console on a 22" widescreen monitor is
wonderful regardless of my orientation, state of wakefulness,
or state of drunkenness.  The 1680x1050 resolution under X11
can be painful at times.)

But I digressed there...

Anyway, for cases where you do not need a display of the
video, and only want to listen while you work on other
things, and do not need to change between channels all the
time, you can easily write a quick script to tune and play
the audio.  If you still wanted to be able to change between
channels easily, I'm sure it would be no problem to write a
wrapper script to do this.  Then you can pull out `mplayer'
when you need it.

Anyway, here is an example (which is for listening to one
radio signal from satellite here, but the principle is
the same -- the TV audio can be thought of as a radio
signal, and tuning via DVB-T is almost the same as tuning
via satellite -- because I don't have the scripts to tune
audio from DVB-T on the machine I'm working on)...

#!/bin/dash

. /home/beer/sbin/dvb-defs OPERA1

if [ x"$OPERA1" = "x -c 7 " ]
then
        echo Cannot make recording, Opera-1 DVB-S receiver not found!  >&2
        exit 8
fi


/home/beer/bin/dvbstream  -c 1  ${OPERA1}  -T  \
    -s 27500   -p v   -f 12525   -I 2   -D 4   -o  \
    -a 187   $*  \
     |  /home/beer/bin/ts_audio_es_demux  \
      /dev/stdin /dev/stdout /dev/null | nice  /usr/bin/mpg123  -v  ${MPGARGS} -



Basically, this is adapted from the templates I use for
recording programming to disk from the commandline, or
from `cron'.  It checks that my tuner is present (left
over from the recording usage), and uses `dvbstream'
which performs the tuning, the following line has the
tuning parameters, with the next line giving the PID
needed to identify the audio (in this example, it's a
newer radio service from Czech Radio).

This is piped into a utility which converts the Transport
Stream into an MPEG audio stream, which basically is
just removing a few extra bits from the stream, and
that is a simple audio stream that plays easily in any
of a number of mpeg audio decoder-players, such as `mpg123'.



> Alright, so, I downloaded the file placed it in /tmp, gave it +rw
> permissions and ran:
> sudo scan /tmp/au-melbourne

Okay, first of all, you should be able to do this as a
normal user -- not `sudo' (sorry, I've been spending too
much time reading Slashdot where people have been discussing
the vulnerability of Linux users to malicious worm- and
virus-like things, and I've learned that there seems to
be a tendency for users to `sudo' when it's not really
necessary...  That is, you can shoot a big hole in your
foot with `sudo', while without, you can still cause
damage, but the hole won't be as big)


> The scan help didn't make a lot of sense to me, but that seemed to do
> some stuff like recognise the file, but it found no channels. Are there

Okay, here is where the troubleshooting starts  :-)

But first, one useful option would be `-v' to verbosely
scan, which can show some details about why you cannot
tune.


> any options I should have used? Is the default output format correct?
> Or should I start checking my cables and tv points?

Yes, this would be where you start to verify that you
can receive the same DVB-T channels when connecting a
different receiver to your connection.

That is, if `scan' gives no useful output with a scanfile
that you know should be correct (and you are welcome to
post the results of scanning, either in private mail or
cut down to the attempts for two or three frequencies to
the mailing list), then there may be a problem outside
of your USB tuner and computer.


> Hey, one other thing, and sorry I know it's really OT, but you said you
> were a console guy. Have you found a command line web browser with
> javascript support? Like how do u get around the javascript thing?

Out of habit, I do all my browsing with `lynx' (my fingers
are too ingrained to spend too much time with `elinks' or
anything else, so it's just habit, not too much a choice).

My attitude to sites with javascript is that I don't bother
with them, as I'm searching for info in text format (ASCII
PR0N FOR THE MASSES!  mplayer supports aalib!  no need for
me to fire up X to watch my pr0n!), and over a slow link,
though when needed, I do download a good JPEG or PDF file.

Unfortunately, that's not a real solution, and I did have
to install Iceape to access the configuration of my router,
as I'm too cheap to buy one with a ssh interface that
allows access to the nvram settings.  And that doesn't
help you much.  While I can be a luddite and refuse to
browse sites that require javascript, particularly for
simple text info that other sites deliver without script,
saying my time would be better spent drinking beer and
browsing small breweries that don't need script, the
Real World will pass me by.

I'd love to kick these web developers into being forced
to using a text-only broswer to review their pages.  And
I'd like a world peace, free broadband pr0n, and a pony.

Sorry I can't help much there...


barry bouwsma

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
