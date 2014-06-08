Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-hk1lp0124.outbound.protection.outlook.com ([207.46.51.124]:36416
	"EHLO APAC01-HK1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753138AbaFHB3v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Jun 2014 21:29:51 -0400
From: James Harper <james@ejbdigital.com.au>
To: =?iso-8859-1?Q?Ren=E9?= <poisson.rene@neuf.fr>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: RE: fusion hdtv dual express 2 (working, kind of)
Date: Sun, 8 Jun 2014 01:29:43 +0000
Message-ID: <c48e37ce86984e7a9e0822c9745aaa9e@SIXPR04MB304.apcprd04.prod.outlook.com>
References: <c01bd13c8e7241339365ecd0785fc3c4@SIXPR04MB304.apcprd04.prod.outlook.com>
 <2406CE434D5342D8B36CACED1EB791F6@ci5fish>
In-Reply-To: <2406CE434D5342D8B36CACED1EB791F6@ci5fish>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Hi,
> I don't use mythtv myself so I can't help you troubleshooting using this
> program. But the symptoms you describe (high pitch sound, degraded video)
> make me think of missing packets in the received stream. May be you might
> use vlc in maximum verbosity mode to get information about the stream as it
> is really received by the device.
> I suggest  you store the output of stderr  in a file to examine it
> afterwards because your system my have difficulties to cope with the output
> rate.
> Given your tuning parameters the command line shall look like:
> vlc -vvv -I dummy
> dvb://frequency=550500000 --dvb-adapter=2 --dvb-bandwidth=7 --dvb-
> transmission=8
>  --dvb-guard=1/16 --dvb-code-rate-hp=3/4 --no-video --no-audio 2> dttv.log
> 
> Wait about one minute, ^C and watch the log. You may, before issue "grep
> discontinuity ddtv.log" to see if there are a lot of missing packets.
> However, continuity counters are modulo 16 so is the number of missing
> packets ...

[0x7f239c003c68] ts demux warning: discontinuity received 0x2 instead of 0x1 (pid=2841)
[0x7f239c003c68] ts demux warning: discontinuity received 0x3 instead of 0x2 (pid=2840)
[0x7f239c003c68] ts demux warning: discontinuity received 0xc instead of 0xb (pid=2845)
[0x7f239c003c68] ts demux error: libdvbpsi (PSI decoder): TS discontinuity (received 4, expected 3) for PID 18
[0x7f239c003c68] ts demux warning: discontinuity received 0x4 instead of 0x3 (pid=2841)
[0x7f239c003c68] ts demux warning: discontinuity received 0xe instead of 0x5 (pid=2840)
[0x7f239c003c68] ts demux warning: discontinuity received 0x6 instead of 0x2 (pid=2840)
[0x7f239c003c68] ts demux error: libdvbpsi (PSI decoder): TS discontinuity (received 8, expected 6) for PID 18
[0x7f239c003c68] ts demux warning: discontinuity received 0x8 instead of 0x7 (pid=2841)
[0x7f239c003c68] ts demux warning: discontinuity received 0x5 instead of 0x8 (pid=2840)
[0x7f239c003c68] ts demux warning: discontinuity received 0xa instead of 0x9 (pid=2841)

Looks like a problem!

So if I'm getting signal around 50000, Verror=0, and BlockError=0 then would I be right in thinking the tuner and everything like that is hooked up correctly, and that my problem is not related to signal quality but to something a bit further along?

Next I guess I'll crank up the debug in the kernel modules. I'll probably figure out something on my own but if you had any tips on which would be best to enable it would be much appreciated!

> 
> PS: I am not a developer but I can help you with dvb if you have specific
> questions in that domain, just reply to me, I'll do my best to help.

Your help so far is greatly appreciated!

Thanks

James
