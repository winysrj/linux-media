Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n8a.bullet.mail.mud.yahoo.com ([209.191.87.104])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <free_beer_for_all@yahoo.com>) id 1KW906-0002pR-EP
	for linux-dvb@linuxtv.org; Thu, 21 Aug 2008 14:10:51 +0200
Date: Thu, 21 Aug 2008 05:10:10 -0700 (PDT)
From: barry bouwsma <free_beer_for_all@yahoo.com>
To: linux-dvb@linuxtv.org, Josef Wolf <jw@raven.inka.de>
In-Reply-To: <20080820214814.GB32022@raven.wolf.lan>
MIME-Version: 1.0
Message-ID: <369347.83967.qm@web46113.mail.sp1.yahoo.com>
Subject: Re: [linux-dvb] How to convert MPEG-TS to MPEG-PS on the fly?
Reply-To: free_beer_for_all@yahoo.com
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


--- On Wed, 8/20/08, Josef Wolf <jw@raven.inka.de> wrote:

> > >I'd like to convert live mpeg-ts streams from DVB-S on the fly into
> > >a mpeg-ps stream.  I know that (for example)
> 
> In principle, yes.  But there is a big drawback to such a solution:
> the pipes (and demuxing/muxing in a different process) will introduce
> lots of context switches.  Since I want to convert four full
> transponders at the same time (about 25 channels), this will certainly
> kill my 450MHz PII machine.  Let alone the 25 additional mencoder
> processes all running in parallel.

Can I ask for more details?  As I'm using a 200MHz and similar
machines for full- and partial-TS work from 4 DVB cards, I have
some concerns, that may or may not be a problem.

What sort of cards are you using -- internal PCI or external USB?
When I'm handling a high bandwidth (BBC-HD) program on my internal
PCI card, not even a full transport stream, I start to feel the
CPU pinch, which will be far worse for USB streams.  Given about
36Mbit/sec per transponder, you'll be schlepping quite a bit of
data, which may give you concern.  Keep an eye on idle time.

Of course, my machine is only an MMX Pentium, and only 32MB RAM,
so will by far reach its capacity well before yours; mine seems to
max out with a 15Mbit/sec HD stream (internal PCI), a full 16Mbit/
sec transport stream via USB of DVB-T, and two filtered USB1 partial
radio streams, doing nothing but writing files to internal disks.
With less than this I've got adequate headroom.

Are you intending to use the PSen in real-time like it seems you
describe, or will you/can you be recording for later use?

It sounds like you may, given your example of ZDF, be streaming
the oeffis from 10744 (arte & Co), 11836 (ARD & Co), ZDF, and some
Dritte programs at 12110.  These are all now higher quality streams
than the commercial private channels which you may also be using
to reach your 25 channels, with video bandwidths usually around 5
to 8Mbit/sec per stream.

If I'm not mistaken, your program stream should include the video PID
data, plus an audio PID (only one, I'll assume the primary mp2 audio,
though you may choose the AC3 where present) from each channel, so no
worry about second/alternative audio, teletext, or additional program
tables sent in the full stream.

So, for example, assuming you want all the channels from the ARD
transponder, you need PIDs 101+102 (ARD), 201+202 (BR), 301+302 (hr),
601+602 (WDR), (701+702 BR-alpha if not taken from elsewhere), and
801+802 (SWR-BW), with x01 the video channel, and x02 the simple
mp2 audio.  Likewise for the other transponders of interest.

You should be able to use `dvbstream' specifying only those needed
PIDs and either write a file directly for later processing, or pipe
for immediate streaming, saving a bit of bandwidth from data you'd
not be using (teletext and such) -- provided you don't need to use
software demuxing of a full TS with your cards.

Take a look at hacking a program called `superdemux' if I recall,
which you should be able to use to split the stream into its
PID pairs -- I use it hacked to write multiple radio streams into
separate files.  Alternatively, a hack based on a teletext program
may help you separate the streams.

The program `ts2ps', part of the dvb-mpegtools suite, or something
similar from those programs, can be used to repack the data into
PS, and should be a lot more lightweight than mencoder.

Timing data is partially within each PID, so you should be able to
get a usable PS from just the two PIDs.  At least, that's how I
used to record programs, until learning that the additional PIDs
could be helpful.

Given the amount of data you'll be handling on your 450MHz machine,
you may see lost packets and thus corruption at full load, so test
by working your way from a single functioning transponder up to the
full workload.

I don't have a turnkey solution, but those are the building blocks
I'd be looking at to try to do what I think you want to do; however,
with plenty of source hacking.  Of course, if you're not doing exactly
or approximately what I've guessed, then my advice may need tweaking.


Hope this is somewhat useful
barry bouwsma


      


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
