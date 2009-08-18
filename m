Return-path: <linux-media-owner@vger.kernel.org>
Received: from tricon.hu ([195.70.57.4]:51060 "EHLO tricon.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751364AbZHRT2U (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Aug 2009 15:28:20 -0400
Date: Tue, 18 Aug 2009 21:01:07 +0200
From: =?ISO-8859-2?Q?P=E1sztor_Szil=E1rd?= <don@tricon.hu>
To: linux-media@vger.kernel.org, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Anysee E30 C Plus + MPEG-4?
Message-Id: <20090818210107.2a6a5146.don@tricon.hu>
In-Reply-To: <alpine.DEB.2.01.0908181959241.27276@ybpnyubfg.ybpnyqbznva>
References: <20090818170820.3d999fb9.don@tricon.hu>
	<alpine.DEB.2.01.0908181959241.27276@ybpnyubfg.ybpnyqbznva>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks for the comprehensive answer.
Mr. Thommeret's hint about the missing video PID pushed me into the right
direction so I'm a step further now. With scan -vv I could find the video PIDs
for the HD channels and indeed they were missing in my channels.conf (values
were 0) as scan detected them as "OTHER", but with a "type 0x1b" addition with
which I don't know what to do for the time being...

After adding the correct PID values, mplayer still can't demux the incoming
stream but the video is there, and with -dumpvideo a h264 elementary stream
gets produced in the file that can be played back if I specify -demuxer
h264es on the command line. What are beyond me now are:
1) how can mplayer not demux the stream if it can dump the video out
(shouldn't a video dump involve a demux operation before all?)
2) is it a missing feature of mplayer that no metastream is processed that
would carry the necessary information about the muxed streams? It would be
adequate for me if I could specify a demuxer to use but it seems impossible in
just one step - which I currently don't understand because an elementary
stream is dumped as video.

s.

BOUWSMA Barry:
> `mplayer' assumes a MPEG-2 video stream by default unless it is
> told otherwise by the additional metadata carried outside the
> video PID stream.  That means you need to feed mplayer with not
> only the video and audio streams, but also the PMT stream which
> identifies the video as H.264.

             -----------------------------------------------------
             |  Friends may come and go but enemies accumulate.  |
             -----------------------------------------------------
