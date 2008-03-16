Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp-out2.libero.it ([212.52.84.42])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abc336633@libero.it>) id 1Jah6o-0000Be-Vf
	for linux-dvb@linuxtv.org; Sun, 16 Mar 2008 01:52:21 +0100
Received: from mailrelay07.libero.it (192.168.32.94) by smtp-out2.libero.it
	(7.3.120) id 4688F31B19799888 for linux-dvb@linuxtv.org;
	Sun, 16 Mar 2008 01:51:45 +0100
Received: from libero.it (192.168.17.4) by smtp-out2.libero.it (7.3.120)
	id 4611FD4B03C43842 for linux-dvb@linuxtv.org;
	Sun, 16 Mar 2008 01:51:45 +0100
Date: Sun, 16 Mar 2008 01:51:44 +0100
Message-Id: <JXST28$838B51422BBDA91CE4FD6588B0A61AB2@libero.it>
MIME-Version: 1.0
From: "abc336633\@libero\.it" <abc336633@libero.it>
To: "linux-dvb" <linux-dvb@linuxtv.org>
Subject: [linux-dvb] big problem with dexatek sphere dk-5701 bt878 sat card
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

Hallo,
I'm having a big trouble with dexatek sphere dk-5701 card. 
When I have this pci card plugged in motherboard, when trying to install or boot (after having installed without the card)ubuntu (any version) the system freezes when it has to recognize the card giving this message: bttv0: subsytsem 0000:2001 unknown card detected=0
bt878 (rev 17) irq 17 latency 32 mmio 0xfdaff000
I can't find a driver that make it works neither a way to disable the card just to boot ubuntu. The only way to use ubuntu for me at the moment is to unplug the card!


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
