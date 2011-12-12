Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns1.tyldum.com ([91.189.178.231]:48989 "EHLO ns1.tyldum.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752990Ab1LLWpx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Dec 2011 17:45:53 -0500
Received: from tyldum.com (unknown [192.168.168.50])
	by ns1.tyldum.com (Postfix) with ESMTP
	for <linux-media@vger.kernel.org>; Mon, 12 Dec 2011 23:39:52 +0100 (CET)
Received: from [192.168.168.92] (unknown [192.168.168.92])
	by tyldum.com (Postfix) with ESMTP id 6E6A528356
	for <linux-media@vger.kernel.org>; Mon, 12 Dec 2011 23:39:52 +0100 (CET)
Message-ID: <4EE682B3.4090301@tyldum.com>
Date: Mon, 12 Dec 2011 23:39:47 +0100
From: Vidar Tyldum <vidar@tyldum.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Multiple Mantis devices gives me glitches
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I have three  Cinergy C (DVB-C cards) like this:
05:04.0 Multimedia controller: Twinhan Technology Co. Ltd Mantis DTV PCI
Bridge Controller [Ver 1.0] (rev 01)
        Subsystem: TERRATEC Electronic GmbH Device 1178
        Flags: bus master, medium devsel, latency 128, IRQ 20
        Memory at fdcfe000 (32-bit, prefetchable) [size=4K]
        Kernel driver in use: Mantis
        Kernel modules: mantis

Kernel: 2.6.38-13-generic-pae (Ubuntu Natty stock)
Motherboard: P43-ES3G
CPU: Intel(R) Core(TM)2 Quad CPU    Q8400

At some point i started having glitches (I would from time to time get an
'old' frame displayed and sometimes audio noise when this happened). I tried
pretty much every trick I could find:
 * CPU affinity
 * Dedicated IRQ for each card (only shared with USB, which has no units
attached)
 * Various process priorities (also for the kdvb-processes)
 * pci latency (from 0x20 to 0xff)

I have quite decent results when I only have 2 DVB cards present, and the
results became even better when running the irqbalancer-dæmon as well.
The glitches are not completely gone, but much more manageble now.

So the problem seems to be caused by too many interrupts for my system to
handle, however this is where I am in over my head.

I know 2.6.38 isn't the freshest brew, but I could not find any changes to
the driver since then that seemed relevant (which could just be my lack of
source-fu).

So, any ideas on how to improve the performance? I am suffering from some
hardware incompatibility or is the driver this resource hungry?



-- 
Vidar Tyldum
                              vidar@tyldum.com               PGP: 0x3110AA98
