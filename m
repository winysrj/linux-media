Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219])
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <bjornjorgensen@gmail.com>) id 1NFEW8-0008Ev-V2
	for linux-dvb@linuxtv.org; Mon, 30 Nov 2009 23:14:49 +0100
Received: by ewy19 with SMTP id 19so4362643ewy.1
	for <linux-dvb@linuxtv.org>; Mon, 30 Nov 2009 14:14:15 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 30 Nov 2009 23:14:14 +0100
Message-ID: <1c335d470911301414g2a6cb185t42fa15ff3c6cfac@mail.gmail.com>
From: =?ISO-8859-1?Q?Bj=F8rn_J=F8rgensen?= <bjornjorgensen@gmail.com>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] TERRATEC Cinergy C PCI & CI, HD problems with sync
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
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

Hi, I have this TERRATEC Cinergy C PCI & CI, HD, card. I have follow
this guide http://dolot.kipdola.com/wiki/Install_S2API for installing
it, but it don't seems to work. I get a lot of "blop blup" sounds and
some out of sync picture. I have installed hts-tvheadend and are using
xbmc to play show it. its the same problems on sd and hd. i have also
tried kaffeine, but the same problems.
Its ubuntu 9.10 and kernel 2.6.31-15-generic #50-Ubuntu SMP
I can play 1080p files on the same pc and no problems.

in dmesg i get many
[ 5960.873141] mantis stop feed and dma
[ 5960.873281] mantis start feed & dma
[ 5981.315566] mantis stop feed and dma
[ 5981.315710] mantis start feed & dma

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
