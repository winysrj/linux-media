Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51394 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754159AbcJRUqQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Oct 2016 16:46:16 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Patrick Boettcher <patrick.boettcher@posteo.de>
Subject: [PATCH v2 05/58] b2c2: don't break long lines
Date: Tue, 18 Oct 2016 18:45:17 -0200
Message-Id: <08b0eafbb06173097d5169c323da49b9738ad253.1476822924.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476822924.git.mchehab@s-opensource.com>
References: <cover.1476822924.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476822924.git.mchehab@s-opensource.com>
References: <cover.1476822924.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Due to the 80-cols restrictions, and latter due to checkpatch
warnings, several strings were broken into multiple lines. This
is not considered a good practice anymore, as it makes harder
to grep for strings at the source code.

As we're right now fixing other drivers due to KERN_CONT, we need
to be able to identify what printk strings don't end with a "\n".
It is a way easier to detect those if we don't break long lines.

So, join those continuation lines.

The patch was generated via the script below, and manually
adjusted if needed.

</script>
use Text::Tabs;
while (<>) {
	if ($next ne "") {
		$c=$_;
		if ($c =~ /^\s+\"(.*)/) {
			$c2=$1;
			$next =~ s/\"\n$//;
			$n = expand($next);
			$funpos = index($n, '(');
			$pos = index($c2, '",');
			if ($funpos && $pos > 0) {
				$s1 = substr $c2, 0, $pos + 2;
				$s2 = ' ' x ($funpos + 1) . substr $c2, $pos + 2;
				$s2 =~ s/^\s+//;

				$s2 = ' ' x ($funpos + 1) . $s2 if ($s2 ne "");

				print unexpand("$next$s1\n");
				print unexpand("$s2\n") if ($s2 ne "");
			} else {
				print "$next$c2\n";
			}
			$next="";
			next;
		} else {
			print $next;
		}
		$next="";
	} else {
		if (m/\"$/) {
			if (!m/\\n\"$/) {
				$next=$_;
				next;
			}
		}
	}
	print $_;
}
</script>

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/pci/b2c2/flexcop-dma.c | 6 ++----
 drivers/media/pci/b2c2/flexcop-pci.c | 7 +++----
 2 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/media/pci/b2c2/flexcop-dma.c b/drivers/media/pci/b2c2/flexcop-dma.c
index 2881e0d956ad..913dc97f8b49 100644
--- a/drivers/media/pci/b2c2/flexcop-dma.c
+++ b/drivers/media/pci/b2c2/flexcop-dma.c
@@ -57,8 +57,7 @@ int flexcop_dma_config(struct flexcop_device *fc,
 		fc->write_ibi_reg(fc,dma2_014,v0x4);
 		fc->write_ibi_reg(fc,dma2_01c,v0xc);
 	} else {
-		err("either DMA1 or DMA2 can be configured within one "
-			"flexcop_dma_config call.");
+		err("either DMA1 or DMA2 can be configured within one flexcop_dma_config call.");
 		return -EINVAL;
 	}
 
@@ -82,8 +81,7 @@ int flexcop_dma_xfer_control(struct flexcop_device *fc,
 		r0x0 = dma2_010;
 		r0xc = dma2_01c;
 	} else {
-		err("either transfer DMA1 or DMA2 can be started within one "
-			"flexcop_dma_xfer_control call.");
+		err("either transfer DMA1 or DMA2 can be started within one flexcop_dma_xfer_control call.");
 		return -EINVAL;
 	}
 
diff --git a/drivers/media/pci/b2c2/flexcop-pci.c b/drivers/media/pci/b2c2/flexcop-pci.c
index 4cac1fc233f2..99ce28442a75 100644
--- a/drivers/media/pci/b2c2/flexcop-pci.c
+++ b/drivers/media/pci/b2c2/flexcop-pci.c
@@ -185,8 +185,7 @@ static irqreturn_t flexcop_pci_isr(int irq, void *dev_id)
 			fc->read_ibi_reg(fc,dma1_008).dma_0x8.dma_cur_addr << 2;
 		u32 cur_pos = cur_addr - fc_pci->dma[0].dma_addr0;
 
-		deb_irq("%u irq: %08x cur_addr: %llx: cur_pos: %08x, "
-			"last_cur_pos: %08x ",
+		deb_irq("%u irq: %08x cur_addr: %llx: cur_pos: %08x, last_cur_pos: %08x ",
 				jiffies_to_usecs(jiffies - fc_pci->last_irq),
 				v.raw, (unsigned long long)cur_addr, cur_pos,
 				fc_pci->last_dma1_cur_pos);
@@ -220,8 +219,8 @@ static irqreturn_t flexcop_pci_isr(int irq, void *dev_id)
 		fc_pci->last_dma1_cur_pos = cur_pos;
 		fc_pci->count++;
 	} else {
-		deb_irq("isr for flexcop called, "
-			"apparently without reason (%08x)\n", v.raw);
+		deb_irq("isr for flexcop called, apparently without reason (%08x)\n",
+			v.raw);
 		ret = IRQ_NONE;
 	}
 
-- 
2.7.4


