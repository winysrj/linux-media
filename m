Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from pih-relay04.plus.net ([212.159.14.131])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <linux-dvb@adslpipe.co.uk>) id 1KE4bT-0004mC-CS
	for linux-dvb@linuxtv.org; Wed, 02 Jul 2008 17:50:44 +0200
Received: from [84.92.25.126] (helo=[192.168.1.100])
	by pih-relay04.plus.net with esmtp (Exim) id 1KE4av-0001Ak-HK
	for linux-dvb@linuxtv.org; Wed, 02 Jul 2008 16:50:09 +0100
Message-ID: <486BA3AE.1020808@adslpipe.co.uk>
Date: Wed, 02 Jul 2008 16:50:06 +0100
From: Andy Burns <linux-dvb@adslpipe.co.uk>
MIME-Version: 1.0
To: Linux DVB List <linux-dvb@linuxtv.org>
References: <486A6F0F.7090507@adslpipe.co.uk>
	<486B9630.1080100@adslpipe.co.uk>	<200807021712.53659.zzam@gentoo.org>
	<486BA03D.4040904@adslpipe.co.uk>
In-Reply-To: <486BA03D.4040904@adslpipe.co.uk>
Subject: Re: [linux-dvb] [PATCH] Shrink saa7134 mmio mapped size
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

The saa7134 driver attempts to map a fixed 4K starting from the base 
address of its mmio area, regardless of the actual size of the area.
Any excessive mapping may extend past the end of a page, which goes 
un-noticed on bare-metal, but is detected and denied when the card is 
used with pci passthrough to a xen domU. If shared IRQ is used the 
"pollirq" kernel option may be required in dom0.

Signed-off-by: Andy Burns <andy@burns.net>
---- drivers/media/video/saa7134/saa7134-core.c.orig     2008-07-01 
16:46:49.000000000 +0100
+++ drivers/media/video/saa7134/saa7134-core.c  2008-07-02 
16:41:37.000000000 +0100
@@ -908,7 +908,8 @@
                        dev->name,(unsigned long 
long)pci_resource_start(pci_dev,0));
                 goto fail1;
         }
-       dev->lmmio = ioremap(pci_resource_start(pci_dev,0), 0x1000);
+       dev->lmmio = ioremap(pci_resource_start(pci_dev,0),
+                             pci_resource_len(pci_dev,0));
         dev->bmmio = (__u8 __iomem *)dev->lmmio;
         if (NULL == dev->lmmio) {
                 err = -EIO;


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
