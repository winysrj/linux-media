Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:44792 "EHLO
        homiemail-a116.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755795AbeEHVUZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 May 2018 17:20:25 -0400
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mspieth@digivation.com.au
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH 0/5] cx23885: Ryzen/Xeon DMA/interrupt fixes
Date: Tue,  8 May 2018 16:20:15 -0500
Message-Id: <1525814420-25243-1-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Various problems have been reported to Hauppauge related
to usage of QuadHD products on Ryzen platforms and some
Xeon platforms. The most serious issue causes adapters on
the card to stop working. When the four tuners are in use it
is possible to experience RiSc engine OP CODE errors, at which
point the DMA engine for that port stalls and becomes inoperable
until a reboot. Unloading and reloading the driver does not
fix the condition. This DMA stall is handled by checking
TC_REQ and TC_REQ_SET registers in a lot of various spots.
If both of these registers are found to have the same bits
set, then their contents must be written back to 'un-freeze'
the DMA engine and let operation continue. The problem can
be quite hard to reproduce depending on motherboard and cpu.
The attached patch has been reported to fix all various parties
reporting issues with an assortment of Ryzen motherboards and
CPU combinations. It has been reported that some manufacturers
have released BIOS updates to address the PCIe instability.
This patch has been confirmed to have no adverse affets on
the reporting systems.


In the investigation of the issue a couple other problems
were found:
- On Ryzen/Xeon platforms it is possible to skip interrupts
- PCI and TS masks were ignored during irq


Brad Love (5):
  cx23885: Handle additional bufs on interrupt
  cx23885: Use PCI and TS masks in irq functions
  cx23885: Ryzen DMA related RiSC engine stall fixes
  cx23885: Expand registers printed during dma tsport reg dump
  cx23885: Add some missing register documentation

 drivers/media/pci/cx23885/cx23885-core.c | 144 +++++++++++++++++++++++++++----
 drivers/media/pci/cx23885/cx23885-reg.h  |  14 +++
 2 files changed, 139 insertions(+), 19 deletions(-)

-- 
2.7.4
