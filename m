Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <aeriksson@fastmail.fm>) id 1LGrP6-0003ND-M1
	for linux-dvb@linuxtv.org; Sun, 28 Dec 2008 09:53:46 +0100
to: Hartmut Hackmann <hartmut.hackmann@t-online.de>
Mime-Version: 1.0
Date: Sun, 28 Dec 2008 09:53:27 +0100
From: Anders Eriksson <aeriksson@fastmail.fm>
Message-Id: <20081228085327.6604F93CD2C@tippex.mynet.homeunix.org>
Cc: linux-dvb@linuxtv.org
Subject: [linux-dvb] state of Pinnacle 310i remote support
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


Hi,

I reently got myself a 310i and am having troubles getting it to work.

1) The video has an added layer of white noise on kernels >2.6.25
2) The remote doesn't work.

I tried to bisect 1, but ended up in a big v4l merge which didn't compile after
all commits. I plan to look into this a bit later.

Asking google on 2, I've found many in the same situation, but also a few 
indications that the remote does (or at last did) work! E.g.
http://www.video4linux.org/changeset/4781%3A3be8a25192a2
http://www.mythtv.org/wiki/index.php/Pinnacle_PCTV_MediaCenter_310i

Can you please tell me is that changeset mentioned on the v4l site actually
fixed the remote and if so, point me to the exact tree that worked? I'd be more
than happy to try it out to see if it works with my hardware. I've tried all
kernels >2.6.13 with no success (just the much spoken of key=.. . raw=...
sequence)

Thanks in advance!
/Anders


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
