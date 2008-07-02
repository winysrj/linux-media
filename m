Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ptb-relay01.plus.net ([212.159.14.212])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <linux-dvb@adslpipe.co.uk>) id 1KE3hm-00017j-0X
	for linux-dvb@linuxtv.org; Wed, 02 Jul 2008 16:53:10 +0200
Received: from [84.92.25.126] (helo=[192.168.1.100])
	by ptb-relay01.plus.net with esmtp (Exim) id 1KE3hD-0003H6-QV
	for linux-dvb@linuxtv.org; Wed, 02 Jul 2008 15:52:36 +0100
Message-ID: <486B9630.1080100@adslpipe.co.uk>
Date: Wed, 02 Jul 2008 15:52:32 +0100
From: Andy Burns <linux-dvb@adslpipe.co.uk>
MIME-Version: 1.0
To: Linux DVB List <linux-dvb@linuxtv.org>
References: <486A6F0F.7090507@adslpipe.co.uk>
In-Reply-To: <486A6F0F.7090507@adslpipe.co.uk>
Subject: [linux-dvb] [PATCH] Shrink saa7134 mmio mapped size
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

The saa7134 driver attempts to map 4K starting from the base address of 
its mmio area, although lspci shows the size of the area is only 1K. The 
excessive mapping goes un-noticed on bare-metal, but is detected and 
denied when the card is used with pci passthrough to a xen domU. If 
shared IRQ is used the "pollirq" kernel option may be required in dom0.

Signed-off-by: Andy Burns <andy@burns.net>
--- drivers/media/video/saa7134/saa7134-core.c.orig     2008-07-01 
16:46:49.000000000 +0100
+++ drivers/media/video/saa7134/saa7134-core.c  2008-07-01 
16:47:10.000000000 +0100
@@ -908,7 +908,7 @@
                        dev->name,(unsigned long 
long)pci_resource_start(pci_dev,0));
                 goto fail1;
         }
-       dev->lmmio = ioremap(pci_resource_start(pci_dev,0), 0x1000);
+       dev->lmmio = ioremap(pci_resource_start(pci_dev,0), 0x400);
         dev->bmmio = (__u8 __iomem *)dev->lmmio;
         if (NULL == dev->lmmio) {
                 err = -EIO;



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
