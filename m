Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:40380 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753523AbZHZX2a (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Aug 2009 19:28:30 -0400
Subject: Re: [linux-dvb] Can ir polling be turned off in cx88 module for
 Leadtek 1000DTV card?
From: Andy Walls <awalls@radix.net>
To: linux-media@vger.kernel.org
Cc: linux-dvb@linuxtv.org
In-Reply-To: <357341.28380.qm@web112510.mail.gq1.yahoo.com>
References: <357341.28380.qm@web112510.mail.gq1.yahoo.com>
Content-Type: text/plain
Date: Wed, 26 Aug 2009 19:30:02 -0400
Message-Id: <1251329402.5232.6.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2009-08-26 at 07:33 -0700, Dalton Harvie wrote:
> Hi,
> 
> I'm no expert with this stuff but have been using mythtv under ubuntu
> for a while.  Lately the machine became quite sluggish.
> 
> I have two Leadtek 1000DTV cards and a usb remote in a ubuntu 8.04
> (2.6.24-24-generic) machine with the standard packaged kernel.
> 
> >From /var/log/dmesg
> [   56.656386] cx88[0]: subsystem: 107d:665f, board: WinFast DTV1000-T
> [card=35,autodetected]
> 
> 
> I installed powertop and found that there were 500 wakeups/s occuring
> from `run_workqueue (ir_timer)' which I assume is to do with polling
> the built in remote receiver on these tuner cards.  I no longer use
> these Leadtek remotes, instead using a mceusb type one - so would like
> to stop this polling.
> 
> I tried a hack with my limited c knowledge - I edited cx88-input.c to
> remove all references to the DTV1000 card (two places) and recompiled
> the modules.  Now the rapid polling has gone.  The reponse of the new
> mceusb remote seems to be much better now too.  The problem is that I
> don't want to have to recompile these modules each time there is an
> update package to the kernel available.
> 
> My question is - is there any way to stop this polling without having
> to recompile the modules?  Some option to pass to them maybe?


No. No.

>   If there isn't, would it be a good idea?

Maybe.

> Thanks for any help.


Try this.  It adds a module option "noir" that accepts an array of
int's.  For a 0, that card's IR is set up as normal; for a 1, that
card's IR is not initialized.

	# modprobe cx88 noir=1,1

Regards,
Andy


cx88: Add module option for disabling IR

If an IR receiver isn't in use, there's no need to incurr the penalties
for polling.

Reported-by: Dalton Harvie <dalton_harvie@yahoo.com.au>
Signed-off-by: Andy Walls <awalls@radix.net>

diff -r 28f8b0ebd224 linux/drivers/media/video/cx88/cx88-cards.c
--- a/linux/drivers/media/video/cx88/cx88-cards.c	Sun Aug 23 13:55:25 2009 -0300
+++ b/linux/drivers/media/video/cx88/cx88-cards.c	Wed Aug 26 19:23:17 2009 -0400
@@ -32,14 +32,17 @@
 static unsigned int tuner[] = {[0 ... (CX88_MAXBOARDS - 1)] = UNSET };
 static unsigned int radio[] = {[0 ... (CX88_MAXBOARDS - 1)] = UNSET };
 static unsigned int card[]  = {[0 ... (CX88_MAXBOARDS - 1)] = UNSET };
+static unsigned int noir[]  = {[0 ... (CX88_MAXBOARDS - 1)] = UNSET };
 
 module_param_array(tuner, int, NULL, 0444);
 module_param_array(radio, int, NULL, 0444);
 module_param_array(card,  int, NULL, 0444);
+module_param_array(noir,  int, NULL, 0444);
 
 MODULE_PARM_DESC(tuner,"tuner type");
 MODULE_PARM_DESC(radio,"radio tuner type");
 MODULE_PARM_DESC(card,"card type");
+MODULE_PARM_DESC(noir, "disable IR (default: 0, IR enabled)");
 
 static unsigned int latency = UNSET;
 module_param(latency,int,0444);
@@ -3490,7 +3493,8 @@
 	}
 
 	cx88_card_setup(core);
-	cx88_ir_init(core, pci);
+	if (!noir[core->nr])
+		cx88_ir_init(core, pci);
 
 	return core;
 }


