Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <aeriksson@fastmail.fm>) id 1L1h5Y-0008JH-Ng
	for linux-dvb@linuxtv.org; Sun, 16 Nov 2008 13:50:53 +0100
To: reklam@holisticode.se
In-reply-to: <F891BA13FD394081A5C17FDDA95616D9@xplap>
References: <F891BA13FD394081A5C17FDDA95616D9@xplap>
Mime-Version: 1.0
Date: Sun, 16 Nov 2008 13:50:21 +0100
From: Anders Eriksson <aeriksson@fastmail.fm>
Message-Id: <20081116125021.DAC8B93CC2B@tippex.mynet.homeunix.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] channels.conf for ComHem Stockholm wanted
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



I'm on ComHem/Linkoping and furiously trying to get my new Anysee E30CPlus to
do something useful. If you can help me with that, I can for sure send you some
channels.conf files.

First off, I'm unsure about the diff between dvbscan and w_scan as they 
produce different results. Is that expected?

So far, I've been able to get mplayer to play a few radio channels (P1 P2), 
and the ComHem channel. No "real" tv channels. :-(


I've got a "mediumHD" subscription with a (supposedly) unlocked sister 
card. That should give ca 20 TV channels and >30 Radio channels. Any ideas as 
to where I should start looking? On the failing channels, mplayer seems to end 
up in a loop with (from head):

COLLECT_SECTION: 
SKIP:
PARSE_PAT:
<~10 lines of "PROG">

And this repeats forever.

Let me know how to cook up that channels.conf file and I'll send it your way.

/Anders 



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
