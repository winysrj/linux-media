Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <hfvogt@gmx.net>) id 1LJ9M7-00079y-No
	for linux-dvb@linuxtv.org; Sat, 03 Jan 2009 17:28:09 +0100
From: "Hans-Frieder Vogt" <hfvogt@gmx.net>
To: linux-dvb@linuxtv.org
Date: Sat, 3 Jan 2009 17:27:26 +0100
References: <loom.20090103T043514-870@post.gmane.org>
In-Reply-To: <loom.20090103T043514-870@post.gmane.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200901031727.26569.hfvogt@gmx.net>
Subject: Re: [linux-dvb] HVR-1200,
	cx23885 driver and Message Signaled Interrupts
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

Am Samstag, 3. Januar 2009 05:38:47 schrieb Peter Hoeg:
> Hi,
>
> I'm successfully using a HVR1200, however the board reports MSI
> capabilities and the driver doesn't seem to enable it. Is there any work
> happening on supporting MSI? Anyway I can help testing things out?
>
> $ lspci -v -s 4:0.0
> 04:00.0 Multimedia video controller: Conexant Systems, Inc. CX23885 PCI
> Video and Audio Decoder (rev 02)
> 	Subsystem: Hauppauge computer works Inc. Device 71d3
> 	Flags: bus master, fast devsel, latency 0, IRQ 16
> 	Memory at ef800000 (64-bit, non-prefetchable) [size=2M]
> 	Capabilities: [40] Express Endpoint, MSI 00
> 	Capabilities: [80] Power Management version 2
> 	Capabilities: [90] Vital Product Data <?>
> 	Capabilities: [a0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0
> Enable- Capabilities: [100] Advanced Error Reporting <?>
> 	Capabilities: [200] Virtual Channel <?>
> 	Kernel driver in use: cx23885
> 	Kernel modules: cx23885
>
> Regards,
> Peter
>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

Hi Peter, hi List,

attached is a patch that enables MSI on the cx23885. I tested this patch for a 
while now on a Dvico FusionHDTV Dual Express and have not found any side 
effects. It works on versions 2.6.27.x and 2.6.28. 2.6.28-gitx not tried yet.

Regards,
Hans-Frieder

Signed-off-by: Hans-Frieder Vogt <hfvogt@gmx.net>

--- linux-2.6.28.orig/drivers/media/video/cx23885/cx23885-core.c	2008-10-25 
18:10:32.000000000 +0200
+++ linux-2.6.28/drivers/media/video/cx23885/cx23885-core.c	2009-01-03 
17:08:55.665685231 +0100
@@ -44,6 +44,10 @@ static unsigned int card[]  = {[0 ... (C
 module_param_array(card,  int, NULL, 0444);
 MODULE_PARM_DESC(card, "card type");
 
+static int enable_msi;
+module_param(enable_msi, int, 0444);
+MODULE_PARM_DESC(enable_msi, "Enable Message Signaled Interrupt (MSI)");
+
 #define dprintk(level, fmt, arg...)\
 	do { if (debug >= level)\
 		printk(KERN_DEBUG "%s/0: " fmt, dev->name, ## arg);\
@@ -1750,7 +1754,11 @@ static int __devinit cx23885_initdev(str
 		goto fail_irq;
 	}
 
-	err = request_irq(pci_dev->irq, cx23885_irq,
+	if (enable_msi && (pci_enable_msi(pci_dev) >= 0))
+		err = request_irq(pci_dev->irq, cx23885_irq,
+			IRQF_DISABLED, dev->name, dev);
+	else
+		err = request_irq(pci_dev->irq, cx23885_irq,
 			  IRQF_SHARED | IRQF_DISABLED, dev->name, dev);
 	if (err < 0) {
 		printk(KERN_ERR "%s: can't get IRQ %d\n",
@@ -1778,6 +1786,8 @@ static void __devexit cx23885_finidev(st
 
 	/* unregister stuff */
 	free_irq(pci_dev->irq, dev);
+	if (pci_dev->msi_enabled)
+		pci_disable_msi(pci_dev);
 	pci_set_drvdata(pci_dev, NULL);
 
 	mutex_lock(&devlist);


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
