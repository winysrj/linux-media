Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nerdig.org ([88.198.12.5] ident=postfix)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jan@codejunky.org>) id 1KErG7-00062m-RN
	for linux-dvb@linuxtv.org; Fri, 04 Jul 2008 21:47:56 +0200
Received: from nerdig.org (localhost [127.0.0.1])
	by mx-int.nerdig.org (Postfix) with ESMTP id AAB12D17B55B
	for <linux-dvb@linuxtv.org>; Fri,  4 Jul 2008 21:49:04 +0200 (CEST)
Received: from b14tch (port-3459.pppoe.wtnet.de [84.46.13.144])
	(Authenticated sender: jan@codejunky.org)
	by mx.nerdig.org (Postfix) with ESMTP id 9116DD123397
	for <linux-dvb@linuxtv.org>; Fri,  4 Jul 2008 21:49:04 +0200 (CEST)
From: Jan Meier <jan@codejunky.org>
To: linux-dvb@linuxtv.org
Date: Fri, 4 Jul 2008 21:46:26 +0200
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200807042146.26204.jan@codejunky.org>
Subject: [linux-dvb] Cinergy 1200 DVB-C unsupported device
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

I have a cinergy 1200 DVB-C card which is not supprted by the current driver 
from the mercurial repository. lspci -vnn shows the following:

Subsystem: TERRATEC Electronic GmbH Unknown device [153b:a156]

The device with the device string 153b:1156 is supported, so I hacked around 
in budget.c/budget-av.c and added a156 instead of 1156, and now the device is 
found: 

saa7146: register extension 'budget_av'.
ACPI: PCI Interrupt 0000:05:07.0[A] -> Link [APC2] -> GSI 17 (level, low) -> 
IRQ 17
saa7146: found saa7146 @ mem f887e000 (revision 1, irq 17) (0x153b,0xa156).
saa7146 (0): dma buffer size 192512
DVB: registering new adapter (Terratec Cinergy 1200 DVB-C)

The problem is that there is no frontend working. I do not know how to get 
this working any further. Maybe you can fix this? 

Kind regards,
Jan

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
