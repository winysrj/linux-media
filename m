Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from berter.planb.net.au ([202.138.65.24])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <linux-dvb@ephedrine.net>) id 1KWL8C-0005xo-Uu
	for linux-dvb@linuxtv.org; Fri, 22 Aug 2008 03:08:02 +0200
Message-ID: <52113.203.82.187.131.1219367267.squirrel@webmail.planb.net.au>
In-Reply-To: <20080821174512.GC32022@raven.wolf.lan>
References: <20080820214814.GB32022@raven.wolf.lan><369347.83967.qm@web46113.mail.sp1.yahoo.com>
	<20080821174512.GC32022@raven.wolf.lan>
Date: Fri, 22 Aug 2008 11:07:47 +1000 (EST)
From: "Kevin Sheehan" <linux-dvb@ephedrine.net>
To: "Josef Wolf" <jw@raven.inka.de>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] How to convert MPEG-TS to MPEG-PS on the fly?
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

Josef,

Barry was right on the money with the ts2ps suggestion below.  It's part
of the libdvb package.  You don't have to use the dvb-mpegtools app, you
can just use the lib in yours - no pipes, etc.

rgs

> Thank you for the extensive answer, Barry!
>
> On Thu, Aug 21, 2008 at 05:10:10AM -0700, barry bouwsma wrote:
>> --- On Wed, 8/20/08, Josef Wolf <jw@raven.inka.de> wrote:
>>
>> > > >I'd like to convert live mpeg-ts streams from DVB-S on the fly into
>> > > >a mpeg-ps stream.  I know that (for example)
>> >
>> > In principle, yes.  But there is a big drawback to such a solution:
>> > the pipes (and demuxing/muxing in a different process) will introduce
>> > lots of context switches.  Since I want to convert four full
>> > transponders at the same time (about 25 channels), this will certainly
>> > kill my 450MHz PII machine.  Let alone the 25 additional mencoder
>> > processes all running in parallel.
>>
>> Can I ask for more details?  As I'm using a 200MHz and similar
>> machines for full- and partial-TS work from 4 DVB cards, I have
>> some concerns, that may or may not be a problem.
>>
>> What sort of cards are you using -- internal PCI or external USB?
>
> Technotrends internal PCI budget cards.
>
>> When I'm handling a high bandwidth (BBC-HD) program on my internal
>> PCI card, not even a full transport stream, I start to feel the
>> CPU pinch, which will be far worse for USB streams.
>
> I am not interested in HD (yet).  But surely this will change at
> some point in time.
>
>> Given about
>> 36Mbit/sec per transponder, you'll be schlepping quite a bit of
>> data, which may give you concern.  Keep an eye on idle time.
>
> Grabbing 18 TV TS streams from 3 transponders gives 60% idle at the
> moment. (my fourth card has died and I have not bought a replacement
> yet.  AFAIK they have stopped manufacturing the cards :-(( )
>
>> Of course, my machine is only an MMX Pentium, and only 32MB RAM,
>> so will by far reach its capacity well before yours; mine seems to
>> max out with a 15Mbit/sec HD stream (internal PCI), a full 16Mbit/
>> sec transport stream via USB of DVB-T, and two filtered USB1 partial
>> radio streams, doing nothing but writing files to internal disks.
>
> Watch out for a catch when writing to internal (ext3) disks: When
> the commit-interval is reached and the journal is flushed, write(2)
> blocks for a significant time.  You risk buffer overruns on the
> incoming TS if you are reading in the same thread.  I had this problem
> a long time ago when I did my first experiments with DVB drivers.
>
>> Are you intending to use the PSen in real-time like it seems you
>> describe, or will you/can you be recording for later use?
>
> Both.  But the recording would probably be by grabbing the already
> converted real-time stream via
>
>   wget http://dvb.local:1234/zdf.ps
>
> or something.  Decoupling recording from demuxing saves me from the
> above mentioned catch.  In addition, recording can be done on every
> host in my network.  I could even roll a script based on LWP to get
> the start/end time of the recording correct.
>
>> It sounds like you may, given your example of ZDF, be streaming
>> the oeffis from 10744 (arte & Co), 11836 (ARD & Co), ZDF, and some
>> Dritte programs at 12110.
>
> 11836 + 11954 + 12188 + 12545.  Unfortunately, they have moved arte
> from 12188 and a fifth card is not supported by the drivers :-(
>
>> If I'm not mistaken, your program stream should include the video PID
>> data, plus an audio PID (only one, I'll assume the primary mp2 audio,
>> though you may choose the AC3 where present) from each channel, so no
>> worry about second/alternative audio, teletext, or additional program
>> tables sent in the full stream.
>
> No, I want to get all the streams so I can select language on the client
> (vlc or something).
>
>> The program `ts2ps', part of the dvb-mpegtools suite, or something
>> similar from those programs, can be used to repack the data into
>> PS, and should be a lot more lightweight than mencoder.
>
> This would still need the pipes.  Introducing pipes would introduce
> significant context switching since pipes are (AFAIR) only 8kbytes.
> So, assuming 500kbytes/sec, I would get 240 context switches per
> second for every program.  This gives a total of 6000 context switches
> every second.  You need _really_ big iron to cope with this.
>
>> Timing data is partially within each PID, so you should be able to
>> get a usable PS from just the two PIDs.
>
> Yes, timing is within the PID.  But there are lots of times there:
>  - PCR, OPCR, DTS_next_AU from the adaptation field
>  - PTS, DTS, ESCR_base, ECSR_extension, ES_rate from the PES header
>  - there's the possibility that the PCR is carried in a different
>    PID (indicated by the PCR_PID field in the PMT)
>
> Which one do I have to use to create the PS header?  I guess I have to
> use the PTS from the PES, but I fail to deduce this from the iso-13818-1.
>
>> Given the amount of data you'll be handling on your 450MHz machine,
>> you may see lost packets and thus corruption at full load, so test
>> by working your way from a single functioning transponder up to the
>> full workload.
>
> I don't have lost packets, but still artefacts in the video.  Looks like
> the additional stream_id's on the video-PID disturbs vlc's decoder.
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
