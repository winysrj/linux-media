Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <jan.burgmeier@gmx.de>) id 1Kvr2k-0006GU-Ui
	for linux-dvb@linuxtv.org; Fri, 31 Oct 2008 11:15:51 +0100
Received: from [193.196.7.49] (helo=[172.16.125.240])
	by router.archaon.ath.cx with esmtpsa (SSLv3:CAMELLIA256-SHA:256)
	(Exim 4.69) (envelope-from <jan@archaon.ath.cx>) id 1Kvr2B-0000xn-Sx
	for linux-dvb@linuxtv.org; Fri, 31 Oct 2008 11:15:16 +0100
From: Jan Burgmeier <jan@archaon.ath.cx>
To: linux-dvb@linuxtv.org
Date: Fri, 31 Oct 2008 11:15:08 +0100
Message-Id: <1225448108.5202.12.camel@archaon-laptop>
Mime-Version: 1.0
Subject: [linux-dvb] TechnoTrend C-1501 timed out waiting for end of xfer
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

Hello,

I own a TechnoTrend C-1501 budget card. I'am using the driver in the
kernel. My kernel version is gentoo-sources-2.6.27-r2 which is based on
the 2.6.27.4 release.

I think the TechnoTren C-1501 should be supported upstream since the
2.6.27 release is this correct?

I use these models:

tda826x
tda10023
budget_ci
budget_core
dvb_core
saa7146
ttpci_eeprom

the modules get loaded automaticly at boot time.

After boot my logs get flooded with these message:
saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of
xfer

I'm using mythTV to watch TV but i don't get any picture or audio. I get
error message about "chanel lock" or something like that.

When you need some more information feel free to ask.

Greetings
Jan Burgmeier



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
