Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from quechua.inka.de ([193.197.184.2] helo=mail.inka.de ident=mail)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jw@raven.inka.de>) id 1KYT41-0007Uh-8x
	for linux-dvb@linuxtv.org; Thu, 28 Aug 2008 00:00:30 +0200
Date: Thu, 28 Aug 2008 00:00:20 +0200
From: Josef Wolf <jw@raven.inka.de>
To: linux-dvb@linuxtv.org
Message-ID: <20080827220019.GM32022@raven.wolf.lan>
References: <20080826224519.GL32022@raven.wolf.lan>
	<949376.11164.qm@web46110.mail.sp1.yahoo.com>
Mime-Version: 1.0
Content-Disposition: inline
In-Reply-To: <949376.11164.qm@web46110.mail.sp1.yahoo.com>
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

On Wed, Aug 27, 2008 at 12:26:00AM -0700, barry bouwsma wrote:
[ ... ]

Thanks for your patience and your efforts, Barry!

Inspired by your detailed description, I decided to hack together an
quick-n-dirty script to analyze dvbsnoop's timing output.  I attach
the script at the end of this mail.  First, I'd like to present some
of the results.  Given a file containing TS (z.ts), I ran those commands:

  $ rm z.mpg
  $ ffmpeg -f dvd -acodec copy -vcodec copy -i  z.ts  z.mpg
  $  ./parsesnoop z.mpg   20
   pkt-nr   id   len        PTS           DTS          ESCR         SCR
  00000001 0xba 0x000c                                           14:05:04.5660
  00000005 0xba 0x000c                                           14:05:04.7942
  00000007 0xe0 0x0800 22:35:16.0619               13:44:30.5997
  00000008 0xe0 0x0800 26:05:52.7719 19:59:24.0657
  00000009 0xe0 0x0800 25:29:04.5040               11:43:55.6654
  00000010 0xe0 0x0800                             25:09:57.5575  4:39:52.5434
  00000011 0xe0 0x0800                                            1:42:31.9742
  00000012 0xe0 0x0800 11:05:40.9000  6:14:46.3895 14:34:14.3564
  00000014 0xe0 0x0800 26:22:35.1851  5:58:32.8467  9:35:17.3297
  00000015 0xe0 0x0800  0:27:29.7839 23:55:23.4698
  00000016 0xe0 0x0800  0:31:07.6702
  00000017 0xe0 0x0800                             25:25:02.1821
  00000018 0xe0 0x0800                                           22:08:07.7717
  00000019 0xe0 0x0800                             25:42:03.2501
  00000020 0xe0 0x0800  4:08:35.6544 11:21:31.4357 23:12:35.3037
  00000022 0xe0 0x0800                             25:34:24.0965
  00000023 0xe0 0x0800                             12:24:51.4790
  00000024 0xe0 0x0800                             16:35:12.6386  9:34:01.5197
  00000025 0xe0 0x0800  1:17:22.1240 20:05:57.9732
  00000026 0xe0 0x0800                             23:02:50.3471 13:38:26.3393
  00000027 0xe0 0x0800 24:19:14.5942  7:04:21.1562

All of those times look pretty much wired to me.  There seem to be no
consistency at all.  Just some random numbers.  But this stream plays
very good on all the players I tried.

Then I tried:

  $ libdvb-0.5.5.1/dvb-mpegtools/ts2ps 120 110 <z.ts >z.ts2ps
  $ ./parsesnoop z.ts2ps 20
   pkt-nr   id   len        PTS           DTS          ESCR         SCR
  00000001 0xba 0x000e                                            4:42:57.2304
  00000003 0xe0 0x0800 17:58:19.1292 17:58:19.0092
  00000033 0xe0 0x0800 17:58:19.0492
  00000042 0xe0 0x0800 17:58:19.0892
  00000052 0xe0 0x0800 17:58:19.2492 17:58:19.1292
  00000055 0xba 0x000e                                            4:42:56.9789
  00000056 0xc0 0x0800 17:58:18.8777
  00000079 0xe0 0x0800 17:58:19.1692
  00000091 0xe0 0x0800 17:58:19.2092
  00000100 0xe0 0x0800 17:58:19.3692 17:58:19.2492
  00000121 0xe0 0x0800 17:58:19.2892
  00000122 0xba 0x000e                                            4:42:57.1469
  00000123 0xc0 0x0800 17:58:19.0457
  00000132 0xe0 0x0800 17:58:19.3292
  00000141 0xe0 0x0800 17:58:19.4892 17:58:19.3692
  00000161 0xe0 0x0800 17:58:19.4092
  00000174 0xe0 0x0800 17:58:19.4492
  00000183 0xe0 0x0800 17:58:19.6092 17:58:19.4892
  00000188 0xba 0x000e                                            4:42:57.3149
  00000189 0xc0 0x0800 17:58:19.2137
  00000204 0xe0 0x0800 17:58:19.5292
  $

This looks much more consistent.  The only strange thing is that ESCR
is missing.  But all the players I tried (except mplayer) fail to play
this stream in one way or another.

Please note that both streams were created from identical input.  I can
see ts2ps timestamps in the original stream.  But I can fine none of
the ffpeg timestamps in the original stream.  Strange enough, the
ts2ps stream (the one that preserves original timestamps) does not play
on any player (except mplayer) and the stream with fantasy-timestamps
plays virtually anywhere.

> And now, I'm wondering just how `replex' is arriving at these
> timestamps from the TS file.

Same question for ffmpeg...

> Anyway, it's not all that relevant, no?  I'm just muttering to
> myself out loud, yes?  I'm not slowly going insane, right?
> I'll be off in my corner, rocking back and forth

Oh, you start feeling like me ;-)

Please, can somebody recommend a _good_ book explaining all this mess?

Here's the script that I used to generate the output listed above:

#! /usr/bin/perl

use strict;
use warnings;

my ($infile, $packets) = (shift, shift);

my $dvbsnoop = "dvbsnoop-1.4.50/src/dvbsnoop -s ps -ph 0 -nohexdumpbuffer";
open (my $snoop, "$dvbsnoop -if '$infile'|") or die;

print " pkt-nr   id   len        PTS           DTS          ESCR         SCR\n";
my ($nr, $len, $sid, %ts);
while (my $line = <$snoop>) {
    $line =~ s/system_clock_reference_base/SCR_base/;

    $nr=$1, $len=$2 if $line =~ /^PS-Packet: (\d+).*Length: \d+ \(([0-9a-fx]+)\)/;
    $sid=$1 if $line =~ /^Stream_id: \d+ \(([0-9a-fx]+)\)/;
    $ts{$1}=$2 if $line =~ /(PTS|DTS|E?SCR).*Timestamp: ([\d\:\.]+)/;
    
    next unless $line =~ /=========/;
    next unless keys %ts;

    print join (" ", $nr, $sid, $len,
                map {
                    sprintf ("%13s", exists $ts{$_} ? $ts{$_} : "");
                } qw(PTS DTS ESCR SCR)), "\n";

    $sid=undef;
    %ts=();

    last if --$packets<0;
}

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
