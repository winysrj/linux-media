Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from [213.161.191.158] (helo=patton.snap.tv)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <sigmund@snap.tv>) id 1K4BUF-0002nl-Of
	for linux-dvb@linuxtv.org; Thu, 05 Jun 2008 11:10:30 +0200
Received: from [10.0.0.4] (89.80-203-124.nextgentel.com [80.203.124.89])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(No client certificate requested)
	by patton.snap.tv (Postfix) with ESMTP id 8D657F14006
	for <linux-dvb@linuxtv.org>; Thu,  5 Jun 2008 11:10:00 +0200 (CEST)
From: Sigmund Augdal <sigmund@snap.tv>
To: linux-dvb <linux-dvb@linuxtv.org>
In-Reply-To: <1212590233.15236.11.camel@rommel.snap.tv>
References: <1212585271.32385.41.camel@pascal>  <48469F71.1070904@iki.fi>
	<1212590233.15236.11.camel@rommel.snap.tv>
Content-Type: multipart/mixed; boundary="=-E+MOgy5T2evBI0DxGCvJ"
Date: Thu, 05 Jun 2008 11:10:11 +0200
Message-Id: <1212657011.32385.53.camel@pascal>
Mime-Version: 1.0
Subject: Re: [linux-dvb] [PATCH] experimental support for C-1501
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


--=-E+MOgy5T2evBI0DxGCvJ
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Wed, 2008-06-04 at 16:37 +0200, Sigmund Augdal wrote:
> ons, 04.06.2008 kl. 16.58 +0300, skrev Antti Palosaari:
> > Sigmund Augdal wrote:
> > > The following experimental patch adds support for the technotrend budget
> > > C-1501 dvb-c card. The parameters used to configure the tda10023 demod
> > > chip are largely determined experimentally, but works quite for me in my
> > > initial tests.
> > 
> > You finally found correct values :) I see that it uses same clock 
> > settings than Anysee. Also deltaf could be correct because I remember 
> > from my tests that it cannot set wrong otherwise it will not work at 
> > all. How did you find defltaf?
> I guessed the clock settings based on how the same tuner is used by a
> different demod. The deltaf value was found by trial and error (helped
> by some scripting). deltaf values slightly off will also work, but
> tuning will be very slow. I also think the deltaf value will depend on
> the bandwidth of the transponder tuned. All transponders I've tested
> with are 8MHz, but I think other values are possible, and these will
> most likely not work. I submitted the patch anyway in the hope that some
> broader testing might help uncover any remaining problems.
> > 
> > Your patch has at least coding style issues, please run make checkpatch 
> > fix errors and resend patch.
> I was trying to follow the guidelines, but I guess I wasn't doing that
> good enough. Will try to clean that up and resend soon.
Here is a new version. This one passes checkpatch without warnings. I
removed the read_pwm function, as it always uses the fallback path for
my card (and frankly I have no idea wether it is actually relevant at
all for this kind of card). Furthermore the tda10023 driver doesn't seem
to use this value for anything.

Best regards

Sigmund Augdal
> 
> regards
> Sigmund
> > 
> > regards
> > Antti
> > 
> > > 
> > > Signed-Off-By: Sigmund Augdal <sigmund@snap.tv>
> > > 
> > > 
> > > ------------------------------------------------------------------------
> > > 
> > > _______________________________________________
> > > linux-dvb mailing list
> > > linux-dvb@linuxtv.org
> > > http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> > 
> > 
> 
> 
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> 

--=-E+MOgy5T2evBI0DxGCvJ
Content-Disposition: attachment; filename=c-1501_try2.patch
Content-Type: text/x-patch; name=c-1501_try2.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

Signed-off-by: Sigmund Augdal <sigmund@snap.tv>
diff -r 6541620a09b7 linux/drivers/media/dvb/ttpci/budget-ci.c
--- a/linux/drivers/media/dvb/ttpci/budget-ci.c	Tue Jun 03 10:32:16 2008 -0300
+++ b/linux/drivers/media/dvb/ttpci/budget-ci.c	Thu Jun 05 11:02:28 2008 +0200
@@ -46,6 +46,8 @@
 #include "lnbp21.h"
 #include "bsbe1.h"
 #include "bsru6.h"
+#include "tda1002x.h"
+#include "tda827x.h"
 
 /*
  * Regarding DEBIADDR_IR:
@@ -1069,6 +1071,16 @@
 
 
 
+static struct tda10023_config tda10023_config = {
+	.demod_address = 0xc,
+	.invert = 0,
+	.xtal = 16000000,
+	.pll_m = 11,
+	.pll_p = 3,
+	.pll_n = 1,
+	.deltaf = 0xA511,
+};
+
 static void frontend_init(struct budget_ci *budget_ci)
 {
 	switch (budget_ci->budget.dev->pci->subsystem_device) {
@@ -1137,6 +1149,20 @@
 			}
 		}
 
+		break;
+	case 0x101a: /* TT Budget-C-1501 (philips tda10023/philips tda8274A) */
+		budget_ci->budget.dvb_frontend =
+			dvb_attach(tda10023_attach, &tda10023_config,
+				   &budget_ci->budget.i2c_adap, 0x48);
+		if (budget_ci->budget.dvb_frontend) {
+			if (dvb_attach(tda827x_attach,
+				       budget_ci->budget.dvb_frontend, 0x61,
+				       &budget_ci->budget.i2c_adap, NULL)
+			    == NULL)
+				printk(KERN_ERR "%s: No tda827x found!\n",
+				       __func__);
+			break;
+		}
 		break;
 	}
 
@@ -1226,6 +1252,7 @@
 MAKE_BUDGET_INFO(ttbt2, "TT-Budget/WinTV-NOVA-T	 PCI", BUDGET_TT);
 MAKE_BUDGET_INFO(ttbtci, "TT-Budget-T-CI PCI", BUDGET_TT);
 MAKE_BUDGET_INFO(ttbcci, "TT-Budget-C-CI PCI", BUDGET_TT);
+MAKE_BUDGET_INFO(ttc1501, "TT-Budget C-1501 PCI", BUDGET_TT);
 
 static struct pci_device_id pci_tbl[] = {
 	MAKE_EXTENSION_PCI(ttbci, 0x13c2, 0x100c),
@@ -1234,6 +1261,7 @@
 	MAKE_EXTENSION_PCI(ttbt2, 0x13c2, 0x1011),
 	MAKE_EXTENSION_PCI(ttbtci, 0x13c2, 0x1012),
 	MAKE_EXTENSION_PCI(ttbs2, 0x13c2, 0x1017),
+	MAKE_EXTENSION_PCI(ttc1501, 0x13c2, 0x101A),
 	{
 	 .vendor = 0,
 	 }

--=-E+MOgy5T2evBI0DxGCvJ
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--=-E+MOgy5T2evBI0DxGCvJ--
