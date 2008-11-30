Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail4.aster.pl ([212.76.33.58])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <daniel.perzynski@aster.pl>) id 1L6uTq-00011u-WD
	for linux-dvb@linuxtv.org; Sun, 30 Nov 2008 23:09:32 +0100
From: daniel.perzynski <daniel.perzynski@aster.pl>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <19A5416D9B8D564D8AF7C620D6E3E8261228082960C868C7E505CDB8350E@webmail.aster.pl>
Date: Sun, 30 Nov 2008 23:09:25 +0100 (CET)
Subject: Re: [linux-dvb] Avermedia A312 wiki page
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

I've tried to load all v4l modules (one by one) in 2.6.27.4 kernel -
nothing in syslog :(
I've then compiled and tried to load lgdt330x, cx25840,tuner-xc2028 and
wm8739 from http://linuxtv.org/hg/v4l-dvb mercurial repository - nothing
in syslog :(

At the end I've used http://linuxtv.org/hg/v4l-dvb-experimental
repository and when doing:

insmod em28xx_cx25843, I've received :)
Nov 30 21:43:54 h3xu5 cx25843.c: starting probe for adapter SMBus I801
adapter at 1200 (0x40004)
Nov 30 21:43:54 h3xu5 cx25843.c: detecting cx25843 client on address
0x88

It is a small progress and I need even more help here. There is a
question if I'm doing everything right? Do I need to load the modules
with parameters? Why I need to do next to help in creation of working
solution for that A312 card?

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
