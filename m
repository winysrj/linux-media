Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.156])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <dennis.schwan@gmail.com>) id 1JtfBJ-0007LE-Hu
	for linux-dvb@linuxtv.org; Wed, 07 May 2008 10:39:22 +0200
Received: by fg-out-1718.google.com with SMTP id e21so151144fga.25
	for <linux-dvb@linuxtv.org>; Wed, 07 May 2008 01:39:17 -0700 (PDT)
Message-ID: <48216AB2.10200@leuchtturm-it.de>
Date: Wed, 07 May 2008 10:39:14 +0200
From: Dennis Schwan <dennis.schwan@leuchtturm-it.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Problems loading drivers in Ubuntu 8.04
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

i just installed the newest drivers via make, make install.

But now loading the drivers fails with both of my cards (cx88 and budget):

 modprobe budget
WARNING: Error inserting budget_core 
(/lib/modules/2.6.24-16-generic/kernel/drivers/media/dvb/ttpci/budget-core.ko): 
Unknown symbol in module, or unknown parameter (see dmesg)
FATAL: Error inserting budget 
(/lib/modules/2.6.24-16-generic/kernel/drivers/media/dvb/ttpci/budget.ko): 
Unknown symbol in module, or unknown parameter (see dmesg)


[551845.935907] budget_core: disagrees about version of symbol 
dvb_dmxdev_init
[551845.935914] budget_core: Unknown symbol dvb_dmxdev_init
[551845.936031] budget_core: disagrees about version of symbol 
dvb_register_adapter
[551845.936034] budget_core: Unknown symbol dvb_register_adapter
[551845.936211] budget_core: disagrees about version of symbol dvb_net_init
[551845.936213] budget_core: Unknown symbol dvb_net_init
[551845.936253] budget_core: disagrees about version of symbol 
dvb_dmxdev_release
[551845.936255] budget_core: Unknown symbol dvb_dmxdev_release
[551845.936362] budget_core: disagrees about version of symbol 
dvb_net_release
[551845.936364] budget_core: Unknown symbol dvb_net_release
[551845.993898] budget: Unknown symbol budget_debug
[551845.993952] budget: Unknown symbol ttpci_budget_irq10_handler
[551845.994004] budget: Unknown symbol ttpci_budget_deinit
[551845.994104] budget: disagrees about version of symbol 
dvb_frontend_detach
[551845.994106] budget: Unknown symbol dvb_frontend_detach
[551845.994158] budget: disagrees about version of symbol 
dvb_unregister_frontend
[551845.994161] budget: Unknown symbol dvb_unregister_frontend
[551845.994209] budget: Unknown symbol ttpci_budget_init_hooks
[551845.994300] budget: Unknown symbol ttpci_budget_init
[551845.994339] budget: disagrees about version of symbol 
dvb_register_frontend
[551845.994341] budget: Unknown symbol dvb_register_frontend


Any Idea?

Regards Dennis

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
