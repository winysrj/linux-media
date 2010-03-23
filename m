Return-path: <linux-media-owner@vger.kernel.org>
Received: from canardo.mork.no ([148.122.252.1]:50156 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753397Ab0CWNq2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Mar 2010 09:46:28 -0400
From: =?utf-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
To: linux-media@vger.kernel.org
Cc: =?utf-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
Subject: [PATCH] V4L/DVB: saa7146: Making IRQF_DISABLED or IRQF_SHARED optional
Date: Tue, 23 Mar 2010 14:46:21 +0100
Message-Id: <1269351981-12292-1-git-send-email-bjorn@mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
References: <1269202135-340-1-git-send-email-bjorn@mork.no> <1269206641.6135.68.camel@palomino.walls.org> <87ocigwvrf.fsf@nemi.mork.no>
In-Reply-To: <87ocigwvrf.fsf@nemi.mork.no>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As discussed many times, e.g. in http://lkml.org/lkml/2007/7/26/401
mixing IRQF_DISABLED with IRQF_SHARED may cause unpredictable and
unexpected results.

Add a module parameter to allow fine tuning the request_irq
flags based on local system requirements.  Some may need to turn
off IRQF_DISABLED to be able to share interrupt with drivers
needing interrupts enabled, while others may want to turn off
IRQF_SHARED to ensure that IRQF_DISABLED has an effect.

Signed-off-by: Bjørn Mork <bjorn@mork.no>
---

I have reiterated through the previous discussions to find the real reason 
why IRQF_DISABLED is kept in assorted V4L/DVB drivers, and do now understand 
that my first approach was a bit too optimistically simple....

The argument for IRQF_DISABLED seems to be that running with interrupts 
enabled may cause multimedia capture devices to drop frames.  Which sounds 
plausible.

But there are two problems with this:
1) as long as you use IRQF_SHARED there is no guarantee that IRQF_DISABLED 
  has any effect, and you may still drop frames
2) drivers sharing the interrupt may assume that interrupts are enabled

The actual effect is highly system dependant and may change with every 
little change to the PCI system, including adding or removing cards,
moving cards around, or even upgrading the kernel without doing any
hardware or driver change at all.

So I propose adding a module parameter allowing a system administrator to
configure a more predictable behaviour by turning off either IRQF_DISABLED or
IRQF_SHARED.  Those with enough interrupt lines and a wish to enforce 
IRQF_DISABLED to avoid dropping frames may disable IRQF_SHARED, and those
experiencing problems with sharing drivers may try to disable one or the
other.

The default is kept as IRQF_SHARED | IRQF_DISABLED



 drivers/media/common/saa7146_core.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/media/common/saa7146_core.c b/drivers/media/common/saa7146_core.c
index 982f000..21127f6 100644
--- a/drivers/media/common/saa7146_core.c
+++ b/drivers/media/common/saa7146_core.c
@@ -26,9 +26,13 @@ DEFINE_MUTEX(saa7146_devices_lock);
 static int saa7146_num;
 
 unsigned int saa7146_debug;
+static int irqflags = IRQF_SHARED | IRQF_DISABLED;
 
 module_param(saa7146_debug, uint, 0644);
 MODULE_PARM_DESC(saa7146_debug, "debug level (default: 0)");
+module_param(irqflags, int, 0444);
+MODULE_PARM_DESC(irqflags, "request_irq flags - default: 0xA0 = 0x20 (IRQF_DISABLED) | 0x80 (IRQF_SHARED)");
+
 
 #if 0
 static void dump_registers(struct saa7146_dev* dev)
@@ -416,7 +420,7 @@ static int saa7146_init_one(struct pci_dev *pci, const struct pci_device_id *ent
 	saa7146_write(dev, MC2, 0xf8000000);
 
 	/* request an interrupt for the saa7146 */
-	err = request_irq(pci->irq, interrupt_hw, IRQF_SHARED | IRQF_DISABLED,
+	err = request_irq(pci->irq, interrupt_hw, irqflags,
 			  dev->name, dev);
 	if (err < 0) {
 		ERR(("request_irq() failed.\n"));
-- 
1.5.6.5

