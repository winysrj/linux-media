Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from static.106.220.46.78.clients.your-server.de
	([78.46.220.106] helo=mail.vanguard.fi ident=postfix)
	by mail.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <beepo@vanguard.fi>) id 1MTxMB-0005e2-Pe
	for linux-dvb@linuxtv.org; Thu, 23 Jul 2009 14:25:08 +0200
Received: from localhost (localhost [127.0.0.1])
	by mail.vanguard.fi (Postfix) with ESMTP id 3F657C089E
	for <linux-dvb@linuxtv.org>; Thu, 23 Jul 2009 15:25:04 +0300 (EEST)
Received: from mail.vanguard.fi ([127.0.0.1])
	by localhost (mail.vanguard.fi [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id n5CdQOgwALMo for <linux-dvb@linuxtv.org>;
	Thu, 23 Jul 2009 15:24:56 +0300 (EEST)
Received: from mail.vanguard.fi (mail.vanguard.fi [78.46.220.106])
	by mail.vanguard.fi (Postfix) with ESMTP id D2988C0870
	for <linux-dvb@linuxtv.org>; Thu, 23 Jul 2009 15:24:56 +0300 (EEST)
Date: Thu, 23 Jul 2009 15:24:56 +0300 (EEST)
From: Beepo / Vanguard <beepo@vanguard.fi>
To: linux-dvb@linuxtv.org
Message-ID: <25292630.1991248351896700.JavaMail.root@mail.vanguard.fi>
In-Reply-To: <15086228.1971248351503115.JavaMail.root@mail.vanguard.fi>
MIME-Version: 1.0
Subject: [linux-dvb] Problem scanning channels with s2-liplianin drivers on
 Terratec Cynergy C PCI HD
Reply-To: linux-media@vger.kernel.org
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

I've been struggling for a while to get the channel scanning to work with my Terratec Cynergy C PCI HD DVB card. I'm using drivers from http://mercurial.intuxication.org/hg/s2-liplianin on Gentoo x86_64 system. Any help is greatly appreciated.

The problem might have something to do with dmesg entry: mantis_ack_wait (0): Slave RACK Fail !

By googling I found some patch for other card with same error message but the patch was quite old and didn't apply to the recent driver source.

I've tried with Gentoo genkernel (2.6.29-gentoo-r5) and with my own configuration (optimized for athlon64)
I've tried dvbscan that comes with gentoo pakage linuxtv-dvb-apps and with http://mercurial.intuxication.org/hg/scan-s2

The s2-liplianin driver for this card has worked with my previous Ubuntu installation few months ago.

I tried to gather as much information about the problem as I could:

http://www.vanguard.fi/terratec/dvbscan_output.txt
http://www.vanguard.fi/terratec/dmesg.txt
http://www.vanguard.fi/terratec/lspci.txt
http://www.vanguard.fi/terratec/emergeinfo.txt
http://www.vanguard.fi/terratec/kernel-config

Thank you in advance!

- Beepo


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
