Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nf-out-0910.google.com ([64.233.182.186])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mariofutire@googlemail.com>) id 1JYSph-0004uI-97
	for linux-dvb@linuxtv.org; Sun, 09 Mar 2008 22:13:26 +0100
Received: by nf-out-0910.google.com with SMTP id d21so579400nfb.11
	for <linux-dvb@linuxtv.org>; Sun, 09 Mar 2008 14:13:18 -0700 (PDT)
Message-ID: <47D452E6.2000408@googlemail.com>
Date: Sun, 09 Mar 2008 21:13:10 +0000
From: Andrea <mariofutire@googlemail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] [PATCH] DMX_OUT_TSDEMUX_TAP: record two streams from
	same mux, resend
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

 > Hi there,

 > This is what you want for capturing multiple audio streams from the same
 > multiplex simultaneously: open demux0 several times and send
 > depacketised output there. And capturing a single video stream is fine
 > too: open dvr0. But for capturing multiple video streams, it's surely
 > not what you want: you want multi-open (so demux0, not dvr0), but you
 > want the TS nature preserved (because that's what you want on output, as
 > you're going to re-multiplex it with the audio).

Can I ask your opinion on the best solution for:

I would like to have 2 separate TS (audio + video + subtitles...) for 2 channels (same frequency).
Is it possible to set a DMX_SET_PES_FILTER with many pids?

Ideally I would like to multi-open the demux, set a PES filter for a few pids (currently I can do 
only for 1), read from demux and save the TS.

So that I can have more the one applications running.

What I can do now is: multi-open the demux, set filter -1 (i.e. get everything), read, and only save 
the pids I want.

I was just wondering what is the best solution.
I don't like to get many times the whole TS. It's a bit of a waste.

 > At least one existing solution -- GStreamer -- sends all its streams
 > simultaneously via dvr0 and demuxes again in userland, but it seems a
 > bit of a shame to pick out all the PIDs in kernel, stick them back
 > together in kernel, and send them to userland only to get unpicked
 > again, when the alternative is such a small API addition.

Andrea

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
