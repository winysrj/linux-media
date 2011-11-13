Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:47982 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750870Ab1KMX3Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Nov 2011 18:29:16 -0500
Message-ID: <4EC052CE.1080002@gmx.de>
Date: Mon, 14 Nov 2011 00:29:18 +0100
From: Ninja <Ninja15@gmx.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Mantis CAM not SMP safe / Activating CAM on Technisat Skystar HD2
 (DVB-S2)
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I'm using a Technisat Skystar HD2 (DVB-S2) with a CI Module under Ubuntu 
11.04.
As some people already noticed, the mantis_ca_init() is never called to 
initialize the CAM.
Since s2-liplianin used almost the same code, I basically just put the 
mantis_ca_init back in,
which is working quite good. But I hope somebody can help me to remove a 
bug rendering the driver not SMP safe,
since I believe my work around for this makes the driver less reliable.

First of all the description of the bug:
I'm using a dual core cpu and noticed that I don't get all the interrupt 
i should get when writing to/ reading from the card using a function 
which uses "mantis_hif_sbuf_opdone_wait" in "mantis_hif.c".
This leads to the 500 ms timeout. Interesting enough, when reading the 
data despite the timeout, the data is valid and available. Using 
max_cpus=1 parameter when starting ubuntu 11.04 solves the problem; all 
interrupts are received and no timeout occurs.
In addition to this, i think the return value of "msecs_to_jiffies" 
changed with some kernel update an thus "mantis_hif_sbuf_opdone_wait" 
never returns an error.
How hope someone can help figuraing out, why the card send less 
interrupt on SMP enabled machines. I know the core which handles the IRQ 
can change, but even all the IRQs from all core are less than when 
disabling SMP.

Now the description how I added the CI support again:

File mantis_hif.c (workaround for the SMP bug):
- Change the call from msecs_to_jiffies(500) to msecs_to_jiffies(2) in 
function "mantis_hif_sbuf_opdone_wait" (we just get the data after 2 ms, 
regardless if we got the data ready IRQ or not).

File mantis_pci.c:
- Move the function set_direction from mantis_core.c to mantis_pci.c (I 
tried to just add the forward declaration to mantis_core.h, but I 
couldn't get it to work...)
- Add its function declaration to mantis_pci.h (extern void 
mantis_set_direction(struct mantis_pci *mantis, int direction);).
- Add "mantis_set_direction(mantis, 0);" after "mantis->revision = 
pdev->revision;" in function "mantis_pci_init".
- Add "mmwrite(0x00, MANTIS_INT_MASK);" before "err = 
request_irq(pdev->irq,"... in function "mantis_pci_init".

File mantis_ca.c:
- Add the include #include "mantis_pci.h"
- Comment in "mantis_set_direction(mantis, 1);" in function 
"mantis_ts_control" in file mantis_ca.c

File manits_dvb.c:
- Add the function call "mantis_ca_init(mantis);" right before the 
return 0 in function "mantis_dvb_init".
- Add th function call "mantis_ca_exit(mantis);" right before 
"tasklet_kill(&mantis->tasklet);" in function "mantis_dvb_exit".

Regards,
Manuel

