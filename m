Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-17.arcor-online.net ([151.189.21.57]:38693 "EHLO
	mail-in-17.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752784AbZIPWRP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Sep 2009 18:17:15 -0400
Subject: Re: Problems with Pinnacle 310i (saa7134) and recent kernels
From: hermann pitton <hermann-pitton@arcor.de>
To: Avl Jawrowski <avljawrowski@gmail.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <loom.20090915T215753-102@post.gmane.org>
References: <loom.20090718T135733-267@post.gmane.org>
	 <1248033581.3667.40.camel@pc07.localdom.local>
	 <loom.20090720T224156-477@post.gmane.org>
	 <1248146456.3239.6.camel@pc07.localdom.local>
	 <loom.20090722T123703-889@post.gmane.org>
	 <1248338430.3206.34.camel@pc07.localdom.local>
	 <loom.20090910T234610-403@post.gmane.org>
	 <1252630820.3321.14.camel@pc07.localdom.local>
	 <loom.20090912T211959-273@post.gmane.org>
	 <1252815178.3259.39.camel@pc07.localdom.local>
	 <loom.20090913T115105-855@post.gmane.org>
	 <1252881736.4318.48.camel@pc07.localdom.local>
	 <loom.20090914T150511-456@post.gmane.org>
	 <1252968793.3250.23.camel@pc07.localdom.local>
	 <loom.20090915T215753-102@post.gmane.org>
Content-Type: text/plain
Date: Thu, 17 Sep 2009 00:07:26 +0200
Message-Id: <1253138846.3901.19.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Dienstag, den 15.09.2009, 20:27 +0000 schrieb Avl Jawrowski:
> Hi,
> 
> hermann pitton <hermann-pitton <at> arcor.de> writes:
> 
> > mplayer works on all my cards including the 310i for DVB-T and DVB-S
> > since years. Guess you miss something or have a broken checkout.
> 
> I've just compiled another checkout, but it's the same.
> With some channels I can see even something like this:
> 
> TS file format detected.
> dvb_streaming_read, attempt N. 6 failed with errno 0 when reading 816 bytes
> dvb_streaming_read, attempt N. 6 failed with errno 0 when reading 1736 bytes
> dvb_streaming_read, attempt N. 6 failed with errno 0 when reading 1148 bytes
> 
> or like this:
> 
> dvb_streaming_read, attempt N. 6 failed with errno 0 when reading 2048 bytes
> dvb_streaming_read, attempt N. 5 failed with errno 0 when reading 2048 bytes
> dvb_streaming_read, attempt N. 4 failed with errno 0 when reading 2048 bytes
> dvb_streaming_read, attempt N. 3 failed with errno 0 when reading 2048 bytes
> dvb_streaming_read, attempt N. 2 failed with errno 0 when reading 2048 bytes
> dvb_streaming_read, attempt N. 1 failed with errno 0 when reading 2048 bytes
> dvb_streaming_read, return 0 bytes

yes, that you do usually see on critical frequencies.

dvb_streaming_read, attempt N. 4 failed with errno 0 when reading 1088 bytes
dvb_streaming_read, attempt N. 6 failed with errno 0 when reading 1068 bytes
dvb_streaming_read, attempt N. 6 failed with errno 0 when reading 1236 bytes
dvb_streaming_read, attempt N. 5 failed with errno 0 when reading 484 bytes
dvb_streaming_read, attempt N. 4 failed with errno 0 when reading 108 bytes
dvb_streaming_read, attempt N. 3 failed with errno 0 when reading 108 bytes
TRIED UP TO POSITION 0, FOUND 47, packet_size= 188, SEEMS A TS? 1
GOOD CC: 5, BAD CC: 20

Mplayer decides, the relation from good to bad packets is too worse to
try on it in that case.

> But I can't see any video.
> With Kaffeine I can see the same channels as well.

My guess is, kaffeine has a bit more trust in error correction,
but you over all reception quality seems to be on a critical limit.

> > Best is to add them to the wiki, else upload somewhere else or post off
> > list.
> 
> Then I'm going to sign me up to the wiki.
> Do you think it's better to create a "Pinnacle PCTV Hybrid Pro PCI" page or to
> add the photos to the 310i page?

Good question, but since yours still has the same PCI subsystem and your
eeprom is not original anymore, we can only try identification by
different chips, layout or board revisions.

So it is still some sort of 310i, but you should mention the new name
and that the remote chip on 0x47/0x8e is not detected.

> > > saa7133[0]: i2c xfer: < 8e ERROR: NO_DEVICE
> > 
> > Here is the problem. The supported cards do have the i2c chip at 0x47 or
> > 0x8e in 8bit notation. Needs closer investigation.
> 
> If can be useful, I can attach the entire log.

You might try with i2c_scan=1, if another and new address is reported
instead. Guess no.

Cheers,
Hermann






