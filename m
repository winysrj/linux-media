Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from quechua.inka.de ([193.197.184.2] helo=mail.inka.de ident=mail)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jw@raven.inka.de>) id 1KYnLt-00059F-8B
	for linux-dvb@linuxtv.org; Thu, 28 Aug 2008 21:40:20 +0200
Date: Thu, 28 Aug 2008 21:34:05 +0200
From: Josef Wolf <jw@raven.inka.de>
To: linux-dvb@linuxtv.org
Message-ID: <20080828193405.GN32022@raven.wolf.lan>
References: <20080826224519.GL32022@raven.wolf.lan>
	<949376.11164.qm@web46110.mail.sp1.yahoo.com>
	<20080827220019.GM32022@raven.wolf.lan>
	<20080828144050.GA9065@linuxtv.org>
Mime-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20080828144050.GA9065@linuxtv.org>
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

Thanks for your Hints, Johannes!

On Thu, Aug 28, 2008 at 04:40:50PM +0200, Johannes Stezenbach wrote:
> The ESCR isn't normally used, I think it means the PES streams don't have
> a common time base. The SCR in the second case doesn't match the
> DTS/PTS values. A software player would probably ignore it anyway
> and sync A/V via PTS only, but a hardware deocder might decide to
> play asynchronously.

SCR don't match in the first case (which is played fine) also.

> Are you sure dvbsnoop output is correct?

I have not checked.  But I don't expect more bugs in snoop than in
the other components, since simply parse+display headers is trivial
compared to demux+parse+reshuffle+generate_additional_headers+mux

> Have you tried iso13818ps from http://www.scara.com/~schirmer/o/mplex13818/ ?
> (linked from http://linuxtv.org/projects.php , BTW)

Thanks for the link.  Description looks promising.  But neither mplayer
nor vlc plays the output created by

  mplex13818-1.1.1/iso13818ps --ts z.ts >z.iso.ps

Mplayer gives no audio and 8x8 (or 16x16?) squares which keep changing
colors.  vlc gives black video and no audio.

The output of my parsing script looks like this:

./parsesnoop z.iso.ps 20
 pkt-nr   id   len        PTS           DTS          ESCR         SCR
00000001 0xba 0x000e                                            0:00:01.9250
00000004 0xe0 0x000e 18:48:10.2516
00000043 0xba 0x000e                                            0:00:01.9250
00000044 0xc1 0x090e 18:48:10.0074
00000045 0xba 0x000e                                            0:00:01.9250
00000046 0xc0 0x150e 18:48:10.0561
00000047 0xba 0x000e                                            0:00:01.9630
00000048 0xe0 0x000e 18:48:10.2916
00000087 0xba 0x000e                                            0:00:02.0390
00000088 0xe0 0x0014 18:48:10.4516 18:48:10.3316
00000127 0xba 0x000e                                            0:00:02.0390
00000128 0xe0 0x000e 18:48:10.3716
00000167 0xba 0x000e                                            0:00:02.0770
00000168 0xe0 0x000e 18:48:10.4116
00000207 0xba 0x000e                                            0:00:02.0790
00000208 0xc1 0x090e 18:48:10.1514
00000209 0xba 0x000e                                            0:00:02.1150
00000210 0xe0 0x0014 18:48:10.5716 18:48:10.4516
00000249 0xba 0x000e                                            0:00:02.1150
00000250 0xc0 0x150e 18:48:10.2241
00000251 0xba 0x000e                                            0:00:02.1530

Here's another interesting point:  Yesterday, I had a TS capture which,
when converted to PS by ffmpeg or ts2ps, played fine on both, mplayer
and vlc.  iso13818ps did not produce a usable output.  I always do
captures for this test from the same broadcast (german ZDF channel on
Astra).  This means that at least for ts2ps, the result depends on the
time of the capture.  Maybe changed bitrate or resolution or something.

> You mentioned you are discarding the adaptation fields. This means
> you don't handle timebase discontinuities.

I have stopped talking about my program some days ago.  I don't see
any point in adopting my program to a broken stream.  Thus, before
I continue on my program, I want to make sure I have a proper reference.

I am talking about tools like ts2ps and iso13818ps, which don't produce
a usable stream. I don't think the output of those programs should be
affected by the question whether I ignore adaptation or not.

> Try to feed the original
> TS to iso13818ps (not your filtered one), it should handle it correctly.

I _am_ feeding the original TS (including adaptation-only packets).  As
you can see in my previous mail, I am capturing the TS into a file and
feed this file as input to any of the test candidates.  Whether I ignore
adaptation should not affect the other candidates in any way.

> ISO-13818-4 (MPEG2 conformance testing) explains a bit how the
> decoder model works. Look for document "ISO/IEC JTC1/SC29/WG11 N0804".

Thanks for the hint.  Looks like that's the only way to get any
clarification in this mess.

> (I'm assuming you already have "ITU-T Recommendation H.222.0" aka
> ISO-13818-1)

Yes, I have read it countless times.  But I must admit that there are
many points unclear to me.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
