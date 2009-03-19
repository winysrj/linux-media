Return-path: <linux-media-owner@vger.kernel.org>
Received: from email.brin.com ([208.89.164.15]:45703 "EHLO email.brin.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751685AbZCSWkx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Mar 2009 18:40:53 -0400
Date: Thu, 19 Mar 2009 16:38:04 -0600 (MDT)
From: Bob Ingraham <bobi@brin.com>
To: linux-dvb@linuxtv.org, linux-media@vger.kernel.org
Message-ID: <1002969792.105131237502284915.JavaMail.root@email>
In-Reply-To: <1519873602.105111237502250958.JavaMail.root@email>
Subject: Weird TS Stream from DMX_SET_PES_FILTER
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I've been using the Linux DVB API to grab DBV-S MPEG2 video packets using a TechniSat S2 card.

But something seems odd about DMX_SET_PES_FILTER.

It returns a TS packets for my pid just fine, but by MPEG2 frames have no PES headers!  The raw compressed MPEG2 frames just immediately follow the TS/adapation-field headers directly.

When I wrote my TS packet decoder, I was expecting to have to decode PES headers after the TS header. But instead I found the raw compressed frames.

They decode fine (with ffmpeg's libavcodec mpeg2 decoder,) and they look fine when rendered using SDL.

But besides my own program, I can't get vlc or mplayer to decode this stream. Both vlc and mplayer sense a TS stream, but then they never render anything because, I suspect, that they can't find PES headers.

So, two questions:

1. Am I crazy or is DMX_SET_PES_FILTER returning a non-standard TS stream?

2. Is there a way to receive a compliant MPEG-TS (or MPEG2-PS,) stream?

3. Should I use DMX_SET_FILTER instead?

4. If so, what goes in the filter/mask members of the dmx_filter_t struct?


Thanks,
Bob

PS: I use the following to filter on my video stream pid (0x1344):

 struct dmx_pes_filter_params f;

 memset(&f, 0, sizeof(f));
 f.pid = (uint16_t) pid;
 f.input = DMX_IN_FRONTEND;
 f.output = DMX_OUT_TS_TAP;
 f.pes_type = DMX_PES_OTHER;
 f.flags   = DMX_IMMEDIATE_START;

