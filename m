Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bar.sig21.net ([88.198.146.85])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <js@sig21.net>) id 1KYigB-00080u-DF
	for linux-dvb@linuxtv.org; Thu, 28 Aug 2008 16:40:56 +0200
Date: Thu, 28 Aug 2008 16:40:50 +0200
From: Johannes Stezenbach <js@linuxtv.org>
To: Josef Wolf <jw@raven.inka.de>
Message-ID: <20080828144050.GA9065@linuxtv.org>
References: <20080826224519.GL32022@raven.wolf.lan>
	<949376.11164.qm@web46110.mail.sp1.yahoo.com>
	<20080827220019.GM32022@raven.wolf.lan>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20080827220019.GM32022@raven.wolf.lan>
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

On Thu, Aug 28, 2008 at 12:00:20AM +0200, Josef Wolf wrote:
> 
> Inspired by your detailed description, I decided to hack together an
> quick-n-dirty script to analyze dvbsnoop's timing output.  I attach
> the script at the end of this mail.  First, I'd like to present some
> of the results.  Given a file containing TS (z.ts), I ran those commands:
> 
>   $ rm z.mpg
>   $ ffmpeg -f dvd -acodec copy -vcodec copy -i  z.ts  z.mpg
>   $  ./parsesnoop z.mpg   20
>    pkt-nr   id   len        PTS           DTS          ESCR         SCR
>   00000001 0xba 0x000c                                           14:05:04.5660
>   00000005 0xba 0x000c                                           14:05:04.7942
>   00000007 0xe0 0x0800 22:35:16.0619               13:44:30.5997
>   00000008 0xe0 0x0800 26:05:52.7719 19:59:24.0657
...
> All of those times look pretty much wired to me.  There seem to be no
> consistency at all.  Just some random numbers.  But this stream plays
> very good on all the players I tried.
> 
> Then I tried:
> 
>   $ libdvb-0.5.5.1/dvb-mpegtools/ts2ps 120 110 <z.ts >z.ts2ps
>   $ ./parsesnoop z.ts2ps 20
>    pkt-nr   id   len        PTS           DTS          ESCR         SCR
>   00000001 0xba 0x000e                                            4:42:57.2304
>   00000003 0xe0 0x0800 17:58:19.1292 17:58:19.0092
>   00000033 0xe0 0x0800 17:58:19.0492
>   00000042 0xe0 0x0800 17:58:19.0892
>   00000052 0xe0 0x0800 17:58:19.2492 17:58:19.1292
...
> This looks much more consistent.  The only strange thing is that ESCR
> is missing.  But all the players I tried (except mplayer) fail to play
> this stream in one way or another.

The ESCR isn't normally used, I think it means the PES streams don't have
a common time base. The SCR in the second case doesn't match the
DTS/PTS values. A software player would probably ignore it anyway
and sync A/V via PTS only, but a hardware deocder might decide to
play asynchronously. Are you sure dvbsnoop output is correct?

Have you tried iso13818ps from http://www.scara.com/~schirmer/o/mplex13818/ ?
(linked from http://linuxtv.org/projects.php , BTW)

You mentioned you are discarding the adaptation fields. This means
you don't handle timebase discontinuities. Try to feed the original
TS to iso13818ps (not your filtered one), it should handle it correctly.

ISO-13818-4 (MPEG2 conformance testing) explains a bit how the
decoder model works. Look for document "ISO/IEC JTC1/SC29/WG11 N0804".
(I'm assuming you already have "ITU-T Recommendation H.222.0" aka ISO-13818-1)


HTH,
Johannes

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
