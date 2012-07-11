Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:45202 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752406Ab2GKKAn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jul 2012 06:00:43 -0400
Message-ID: <4FFD4EC2.8090702@iki.fi>
Date: Wed, 11 Jul 2012 13:00:34 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Marx <acc.for.news@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: pctv452e
References: <4FF4697C.8080602@nexusuk.org> <4FF46DC4.4070204@iki.fi> <4FF4911B.9090600@web.de> <4FF4931B.7000708@iki.fi> <gjggc9-dl4.ln1@wuwek.kopernik.gliwice.pl> <4FF5A350.9070509@iki.fi> <r8cic9-ht4.ln1@wuwek.kopernik.gliwice.pl> <4FF6B121.6010105@iki.fi> <9btic9-vd5.ln1@wuwek.kopernik.gliwice.pl> <835kc9-7p4.ln1@wuwek.kopernik.gliwice.pl> <4FF77C1B.50406@iki.fi> <l2smc9-pj4.ln1@wuwek.kopernik.gliwice.pl> <4FF97DF8.4080208@iki.fi> <n1aqc9-sp4.ln1@wuwek.kopernik.gliwice.pl> <4FFA996D.9010206@iki.fi> <scerc9-bm6.ln1@wuwek.kopernik.gliwice.pl> <4FFB172A.2070009@iki.fi> <4FFB1900.6010306@iki.fi> <79vsc9-dte.ln1@wuwek.kopernik.gliwice.pl> <4FFBF6F8.7010907@iki.fi> <d7iuc9-ua5.ln1@wuwek.kopernik.gliwice.pl> <4FFCB71F.5090807@iki.fi> <gsivc9-6u6.ln1@wuwek.kopernik.gliwice.pl>
In-Reply-To: <gsivc9-6u6.ln1@wuwek.kopernik.gliwice.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/11/2012 09:25 AM, Marx wrote:
> On 11.07.2012 01:13, Antti Palosaari wrote:
>> All these tests shows your device is running as it should.
> There are errors in almost every case, they are absent in your example.
> Is it ok?

You mean these:

[mpeg2video @ 0x8d47940] mpeg_decode_postinit() failure
[mp3 @ 0x8d4a5c0] Header missing
[mpegts @ 0x9f1e900] max_analyze_duration reached
[mpegts @ 0x9f1e900] Estimating duration from bitrate, this may be 
inaccurate
[mpegts @ 0x9cc7900] PES packet size mismatch

Those are OK. It is live video stream and thus having no header to tell 
info about stream content. ffmpeg is forced to read raw stream and guess 
used codes where may happen sometimes few problems.

If you see correct picture when opening that stream in video player it 
is correct. It is likely happen if ffmpeg can detect it.

>> Test VDR again to see if it breaks.
> VDR unfortunatelly doesn't work saying "frontend 0/0 timed out while
> tuning to channel 21, tp 211116" and "ERROR: streamdev: protocol
> violation (VTP) from 127.0.0.1:38551". In fact I cannot play any stream
> directly via VDR, but it can be caused by some incompatibility between
> VDR and the newest kernel.
> VDR reads EPG properly so there is something wrong with it.
> But it's probem not for this list.

Add more tuning delay to VDR.

> Today test works like yesterday.
>
> I will wait and test again later.

regards
Antti

-- 
http://palosaari.fi/


