Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:50129 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753264AbZKKE3x (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Nov 2009 23:29:53 -0500
Subject: cx18: Reprise of YUV frame alignment improvements
From: Andy Walls <awalls@radix.net>
To: ivtv-devel@ivtvdriver.org, linux-media@vger.kernel.org
Content-Type: text/plain
Date: Tue, 10 Nov 2009 23:31:45 -0500
Message-Id: <1257913905.28958.32.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

OK, here's my second attempt at getting rid of cx18 YUV frame alignment
and tearing issues.

	http://linuxtv.org/hg/~awalls/cx18-yuv2

This change primarily implements full scatter-gather buffer handling
between the cx18 driver and the CX23418 firmware.  That in turn allows
me to set the MDL size to have exactly one YUV frame per MDL transfer
from the encoder to eliminate frame alignment issues, while using very
small buffers that should not have anyone's machine go into a panic.  (I
also tweaked the VBI transfer size while I was at it.)

I'm pretty happy with the results.  I can run this set of streams
simultaneously from one HVR-1600 and have witnessed no new cx18 driver
issues on my machine:

YUV:  mplayer /dev/video32 -demuxer rawvideo -rawvideo w=720:h=480:format=hm12:ntsc
PCM:  aplay -f dat < /dev/video24
VBI:  ~/build/zvbi-0.2.30/test/osc -2
MPEG: mplayer /dev/video0 -cache 8192
ATSC: mplayer dvb://WTTG\ DT -cache 8192

(ALSA or my soundcard couldn't mix together 3 streams of audio out to my
speakers though.  Only 2 streams, PCM and MPEG audio, were audible).

The cx18 default YUV buffer size is now 3 * 33.75 kB = 3 full HM12
macroblock sets that cover 32 screen lines for each macroblock set.  A
full NTSC frame requires 15 * 33.75 kB and a full PAL frame requires 18
* 33.75 kB which is why I picked 3 * 33.75 kB.  I don't anticipate
anyone having problems with this new default YUV buffer size of about
~102 kB, since the current default YUV buffer size is 128 kB.

(BTW the cx18 driver restricts YUV captures to sizes which are a
multiple of 32 lines in height.  I believe the reasoning is that the
software HM12 decoders may not gracefully handle a partial macroblock
set when not a multiple of 32 lines.  This changeset is robust enough to
handle lifting that restriction, if someone has a smart HM12 decoder
that can handle partial macroblocks sensibly.)



Could folks give this cx18 code a test to make sure their primary use
cases didn't break?


Regards,
Andy

