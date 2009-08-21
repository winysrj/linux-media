Return-path: <linux-media-owner@vger.kernel.org>
Received: from tricon.hu ([195.70.57.4]:46058 "EHLO tricon.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754898AbZHUOC6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Aug 2009 10:02:58 -0400
Date: Fri, 21 Aug 2009 16:03:19 +0200
From: =?ISO-8859-2?Q?P=E1sztor_Szil=E1rd?= <don@tricon.hu>
To: linux-media@vger.kernel.org
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Anysee E30 C Plus + MPEG-4?
Message-Id: <20090821160319.42c9b199.don@tricon.hu>
In-Reply-To: <alpine.DEB.2.01.0908182107300.27276@ybpnyubfg.ybpnyqbznva>
References: <20090818170820.3d999fb9.don@tricon.hu>
	<alpine.DEB.2.01.0908181959241.27276@ybpnyubfg.ybpnyqbznva>
	<20090818210107.2a6a5146.don@tricon.hu>
	<alpine.DEB.2.01.0908182107300.27276@ybpnyubfg.ybpnyqbznva>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks for the advice, it worked! mplayer -identify dvb://<channel name>
produced the following result:

PROGRAM_ID=0 (0x00), PMT_PID: 16(0x10)
PROGRAM_ID=109 (0x6D), PMT_PID: 7029(0x1B75)
PROGRAM_ID=1001 (0x3E9), PMT_PID: 59(0x3B)
PROGRAM_ID=1930 (0x78A), PMT_PID: 1930(0x78A)
PROGRAM_ID=15551 (0x3CBF), PMT_PID: 8021(0x1F55)

I was searching for the HD channel with program id 15551, so I added +8021 to
the video identifier in channels.conf and it works.

regards
s.

BOUWSMA Barry:
> I said it before and I'll say it again, what `mplayer' needs is
>  -- I mean, I don't know if it would be possible for `mplayer' to
> identify the video as H.264, but for me, it needs this additional
> PID stream to do that.  That is something for the `mplayer' 
> developers or for someone more familiar with H.264 in DVB to
> answer.
> 
> I'm guessing your `channels.conf' file is simple with one field
> for video and one for audio, but no extra fields.  If this is the
> case, then what you will need to do as a test would be to write
> more of the stream to a file; the example I gave in my earlier
> reply for BBC-HD is what I pass to `dvbstream'.  Then `mplayer'
> should be able to play this file with no problems.

        ---------------------------------------------------------------
        |  Make it idiot proof and someone will make a better idiot.  |
        ---------------------------------------------------------------
