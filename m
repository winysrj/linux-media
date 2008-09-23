Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from [85.17.51.120] (helo=master.jcz.nl)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jaap@jcz.nl>) id 1Ki4Xm-0007h3-6L
	for linux-dvb@linuxtv.org; Tue, 23 Sep 2008 11:50:56 +0200
Message-ID: <48D8BBED.3010109@jcz.nl>
Date: Tue, 23 Sep 2008 11:50:37 +0200
From: Jaap Crezee <jaap@jcz.nl>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <48D8A4FF.9010502@jcz.nl> <48D8B08B.6090602@konto.pl>
In-Reply-To: <48D8B08B.6090602@konto.pl>
Content-Type: multipart/mixed; boundary="------------060708060304060100090607"
Subject: Re: [linux-dvb] TT Budget S2-3200 CI: failure with CAM module
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

This is a multi-part message in MIME format.
--------------060708060304060100090607
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit

> Jaap Crezee wrote:
>> Again, when I remove the CAM module, everything works fine (as for FTA 
>> channels...). Tools like dvbdate, dvbtraffic and mplayer 
>> /dev/dvb/adapter0/dvr0 work fine.

I just created a patch to add a budget-ci module param to the driver to disable the CI interface at module load time. 
This way I can still use the card when the CAM module is inserted.
Maybe it is good enough to integrated it with the current hg tree?

> I've got SkystarHD+CI Slot+Aston 2.18 and it works OK (for decoding some 
> channels like HBO/MINIMINI I must wait very long time, but it works)

I have waited long enough (more than 6 hours) and still no results.
Anyone got it working with a TT S2-3200 and AstonCrypt CAM module?

regards,


Jaap Crezee


--------------060708060304060100090607
Content-Type: text/plain;
 name="buget-ci-disable-ci-interface-mod-param.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="buget-ci-disable-ci-interface-mod-param.patch"

--- /kernel/multiproto/linux/drivers/media/dvb/ttpci/budget-ci.c	2008-09-23 11:30:25.000000000 +0200
+++ linux/drivers/media/dvb/ttpci/budget-ci.c	2008-09-23 11:38:24.000000000 +0200
@@ -101,6 +101,10 @@
 module_param(ir_debug, int, 0644);
 MODULE_PARM_DESC(ir_debug, "enable debugging information for IR decoding");
 
+static int ci_disable = 0;
+module_param(ci_disable, int, 0644);
+MODULE_PARM_DESC(ci_disable, "disable CI interface (default: 0, enable...)");
+
 struct budget_ci_ir {
 	struct input_dev *dev;
 	struct tasklet_struct msp430_irq_tasklet;
@@ -1509,7 +1513,11 @@
 	if (err)
 		goto out3;
 
-	ciintf_init(budget_ci);
+	if (ci_disable == 0) {
+		ciintf_init(budget_ci);
+	} else {
+	        printk("buget-ci: disabled CI interface!\n");
+	}
 
 	budget_ci->budget.dvb_adapter.priv = budget_ci;
 	frontend_init(budget_ci);

--------------060708060304060100090607
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------060708060304060100090607--
