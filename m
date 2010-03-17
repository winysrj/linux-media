Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.sscnet.ucla.edu ([128.97.229.231]:47957 "EHLO
	smtp1.sscnet.ucla.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173Ab0CQFar (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Mar 2010 01:30:47 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by smtp1.sscnet.ucla.edu (8.13.8/8.13.8) with ESMTP id o2H53Bj0014687
	for <linux-media@vger.kernel.org>; Tue, 16 Mar 2010 22:03:11 -0700
Received: from smtp1.sscnet.ucla.edu ([127.0.0.1])
	by localhost (smtp1.sscnet.ucla.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id picAm0T-959D for <linux-media@vger.kernel.org>;
	Tue, 16 Mar 2010 22:02:59 -0700 (PDT)
Received: from smtp5.sscnet.ucla.edu (smtp5.sscnet.ucla.edu [128.97.229.235])
	by smtp1.sscnet.ucla.edu (8.13.8/8.13.8) with ESMTP id o2H52uPv014662
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Tue, 16 Mar 2010 22:02:56 -0700
Received: from weber.sscnet.ucla.edu (weber.sscnet.ucla.edu [128.97.42.3])
	by smtp5.sscnet.ucla.edu (8.13.8/8.13.8) with ESMTP id o2H52njo001479
	for <linux-media@vger.kernel.org>; Tue, 16 Mar 2010 22:02:49 -0700
Received: from Titania.local (vpn-8061f520.host.ucla.edu [128.97.245.32])
	by weber.sscnet.ucla.edu (8.14.2/8.14.2) with ESMTP id o2H52lP5003682
	for <linux-media@vger.kernel.org>; Tue, 16 Mar 2010 22:02:47 -0700 (PDT)
Message-ID: <4BA06274.2030107@cogweb.net>
Date: Tue, 16 Mar 2010 22:02:44 -0700
From: David Liontooth <lionteeth@cogweb.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: PCI slots vanish with hvr-1800
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


I just purchased some Hauppauge HVR-1800 cards. They work fine in these 
two PCIe slots:

0000:06:00.0
0000:09:00.0

These are "PCI Express* Gen1" slots (see details below); the others are 
PCI Express* Gen2.
When I place a card in one of these Gen2 slots, the card does not show up.

What's more, the slot disappears from dmesg. Here's an example.

First, the 0000:04:00.0 slot has no card and shows up like this:

pci 0000:04:00.0: reg 10 64bit mmio: [0xb2000000-0xb21fffff]
pci 0000:04:00.0: supports D1 D2
pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:04:00.0: PME# disabled

Second, using a different card, the Hauppauge HVR-1850, we have no problems:

cx23885 0000:04:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
cx23885[0]/0: found at 0000:04:00.0, rev: 4, irq: 19, latency: 0, mmio: 
0xb2000000
cx23885 0000:04:00.0: setting latency timer to 64

Third, using the Haupauge HVR-1800, the card does not show up *and*
the four pci lines above about mmio and PME are also gone without a trace.

The problem arises only if an HVR-1800 is in one or more of the slots 4, 
5, and 6.
These slots are not affected if the HVR-1800 cards are in slots 2 and 3 
only.

I get exactly the same behavior on two different machines (same hardware).
The HVR-1800 cards work fine in slots 2 and 3, but fail consistently in 
slots 4, 5, and 6.
The slots themselves are known to be good, since other cards work fine 
in them.

Is this a known problem? PCI Express Gen2 is supposed to be backwardly
compatible with Gen1, but it looks like these PCIe 1.0 cards are knocking
out the PCIe 2.0 resources.

Cheers,
David


Intel Server Board S3420GPLX has six card slots:

– Slot1: One 5-V PCI 32-bit / 33 MHz connector.
– Slot2: One PCI Express* Gen1 x4 (x1 throughput)
connector).
– Slot3: One PCI Express* Gen1 x8 (x4 throughput)
connector).
– Slot4: One PCI Express* Gen2 x8 (x4 throughput)
connector).
– Slot5: One PCI Express* Gen2x8 (x8 throughput)
connector).
– Slot6: One PCI Express* Gen2 x16 (x8 throughput)
connector).


