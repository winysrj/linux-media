Return-path: <mchehab@pedra>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <jean.bruenn@ip-minds.de>) id 1PsHAG-0002JB-RL
	for linux-dvb@linuxtv.org; Wed, 23 Feb 2011 17:02:10 +0100
Received: from alia.ip-minds.de ([84.201.38.2])
	by mail.tu-berlin.de (exim-4.74/mailfrontend-a) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1PsHAC-0006sO-Aa; Wed, 23 Feb 2011 17:02:08 +0100
Received: from localhost (localhost.localdomain [127.0.0.1])
	by alia.ip-minds.de (Postfix) with ESMTP id 3685B66B0EA
	for <linux-dvb@linuxtv.org>; Wed, 23 Feb 2011 17:02:23 +0100 (CET)
Received: from alia.ip-minds.de ([127.0.0.1])
	by localhost (alia.ip-minds.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NrYOrKgJiC59 for <linux-dvb@linuxtv.org>;
	Wed, 23 Feb 2011 17:02:23 +0100 (CET)
To: <linux-dvb@linuxtv.org>
MIME-Version: 1.0
Date: Wed, 23 Feb 2011 17:02:22 +0100
From: <jean.bruenn@ip-minds.de>
Message-ID: <a8fa184f23be2c90023a3ecf7d6b2017@localhost>
Subject: [linux-dvb] =?utf-8?q?WinTV_1400_broken_with_recent_versions=3F?=
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
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
Sender: <mchehab@pedra>
List-ID: <linux-dvb@linuxtv.org>


Hey,

is this driver going to be fixed anytime soon? It was working fine ago a
half year/year.

lspci:
06:00.0 Multimedia video controller: Conexant Systems, Inc. CX23885 PCI
Video and Audio Decoder (rev 02)

uname -a:
Linux lyra 2.6.37.1 #1 SMP PREEMPT Tue Feb 22 13:22:59 CET 2011 x86_64
x86_64 x86_64 GNU/Linux

dmesg:
xc2028 1-0064: i2c output error: rc = -6 (should be 64)
xc2028 1-0064: -6 returned from send
xc2028 1-0064: Error -22 while loading base firmware
xc2028 1-0064: Loading firmware for type=BASE F8MHZ (3), id
0000000000000000.
xc2028 1-0064: i2c output error: rc = -6 (should be 64)
xc2028 1-0064: -6 returned from send
xc2028 1-0064: Error -22 while loading base firmware
xc2028 1-0064: Loading firmware for type=BASE F8MHZ (3), id
0000000000000000.
xc2028 1-0064: i2c output error: rc = -6 (should be 64)
xc2028 1-0064: -6 returned from send
xc2028 1-0064: Error -22 while loading base firmware

nothing works - if i do scan it finds nothing and those messages appear on
dmesg. if i try to watch with the channels.conf from my other pc i can play
nothing, all i get is those messages above.

Jean

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
