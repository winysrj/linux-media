Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49616 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753269AbcKPQnN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Nov 2016 11:43:13 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hansverk@cisco.com>,
        Inki Dae <inki.dae@samsung.com>,
        Junghak Sung <jh1009.sung@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>
Subject: [PATCH 07/35] [media] cx88: use KERN_CONT where needed
Date: Wed, 16 Nov 2016 14:42:39 -0200
Message-Id: <9c001cc21644ca697101224055bd83702698d50a.1479314177.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1479314177.git.mchehab@s-opensource.com>
References: <cover.1479314177.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1479314177.git.mchehab@s-opensource.com>
References: <cover.1479314177.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some continuation messages are not using KERN_CONT.

Since commit 563873318d32 ("Merge branch 'printk-cleanups'"),
this won't work as expected anymore. So, let's add KERN_CONT
to those lines.

While here, add missing log level annotations.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/pci/cx88/cx88-core.c | 38 +++++++++++++++++++-------------------
 drivers/media/pci/cx88/cx88-dsp.c  |  7 +------
 2 files changed, 20 insertions(+), 25 deletions(-)

diff --git a/drivers/media/pci/cx88/cx88-core.c b/drivers/media/pci/cx88/cx88-core.c
index 46fe8c1eb9d4..1ffd341f990d 100644
--- a/drivers/media/pci/cx88/cx88-core.c
+++ b/drivers/media/pci/cx88/cx88-core.c
@@ -399,12 +399,12 @@ static int cx88_risc_decode(u32 risc)
 	};
 	int i;
 
-	printk("0x%08x [ %s", risc,
+	printk(KERN_DEBUG "0x%08x [ %s", risc,
 	       instr[risc >> 28] ? instr[risc >> 28] : "INVALID");
 	for (i = ARRAY_SIZE(bits)-1; i >= 0; i--)
 		if (risc & (1 << (i + 12)))
-			printk(" %s",bits[i]);
-	printk(" count=%d ]\n", risc & 0xfff);
+			printk(KERN_CONT " %s", bits[i]);
+	printk(KERN_CONT " count=%d ]\n", risc & 0xfff);
 	return incr[risc >> 28] ? incr[risc >> 28] : 1;
 }
 
@@ -428,42 +428,42 @@ void cx88_sram_channel_dump(struct cx88_core *core,
 	u32 risc;
 	unsigned int i,j,n;
 
-	printk("%s: %s - dma channel status dump\n",
+	printk(KERN_DEBUG "%s: %s - dma channel status dump\n",
 	       core->name,ch->name);
 	for (i = 0; i < ARRAY_SIZE(name); i++)
-		printk("%s:   cmds: %-12s: 0x%08x\n",
+		printk(KERN_DEBUG "%s:   cmds: %-12s: 0x%08x\n",
 		       core->name,name[i],
 		       cx_read(ch->cmds_start + 4*i));
 	for (n = 1, i = 0; i < 4; i++) {
 		risc = cx_read(ch->cmds_start + 4 * (i+11));
-		printk("%s:   risc%d: ", core->name, i);
+		printk(KERN_CONT "%s:   risc%d: ", core->name, i);
 		if (--n)
-			printk("0x%08x [ arg #%d ]\n", risc, n);
+			printk(KERN_CONT "0x%08x [ arg #%d ]\n", risc, n);
 		else
 			n = cx88_risc_decode(risc);
 	}
 	for (i = 0; i < 16; i += n) {
 		risc = cx_read(ch->ctrl_start + 4 * i);
-		printk("%s:   iq %x: ", core->name, i);
+		printk(KERN_DEBUG "%s:   iq %x: ", core->name, i);
 		n = cx88_risc_decode(risc);
 		for (j = 1; j < n; j++) {
 			risc = cx_read(ch->ctrl_start + 4 * (i+j));
-			printk("%s:   iq %x: 0x%08x [ arg #%d ]\n",
+			printk(KERN_CONT "%s:   iq %x: 0x%08x [ arg #%d ]\n",
 			       core->name, i+j, risc, j);
 		}
 	}
 
-	printk("%s: fifo: 0x%08x -> 0x%x\n",
+	printk(KERN_DEBUG "%s: fifo: 0x%08x -> 0x%x\n",
 	       core->name, ch->fifo_start, ch->fifo_start+ch->fifo_size);
-	printk("%s: ctrl: 0x%08x -> 0x%x\n",
+	printk(KERN_DEBUG "%s: ctrl: 0x%08x -> 0x%x\n",
 	       core->name, ch->ctrl_start, ch->ctrl_start+6*16);
-	printk("%s:   ptr1_reg: 0x%08x\n",
+	printk(KERN_DEBUG "%s:   ptr1_reg: 0x%08x\n",
 	       core->name,cx_read(ch->ptr1_reg));
-	printk("%s:   ptr2_reg: 0x%08x\n",
+	printk(KERN_DEBUG "%s:   ptr2_reg: 0x%08x\n",
 	       core->name,cx_read(ch->ptr2_reg));
-	printk("%s:   cnt1_reg: 0x%08x\n",
+	printk(KERN_DEBUG "%s:   cnt1_reg: 0x%08x\n",
 	       core->name,cx_read(ch->cnt1_reg));
-	printk("%s:   cnt2_reg: 0x%08x\n",
+	printk(KERN_DEBUG "%s:   cnt2_reg: 0x%08x\n",
 	       core->name,cx_read(ch->cnt2_reg));
 }
 
@@ -484,14 +484,14 @@ void cx88_print_irqbits(const char *name, const char *tag, const char *strings[]
 		if (!(bits & (1 << i)))
 			continue;
 		if (strings[i])
-			printk(" %s", strings[i]);
+			printk(KERN_CONT " %s", strings[i]);
 		else
-			printk(" %d", i);
+			printk(KERN_CONT " %d", i);
 		if (!(mask & (1 << i)))
 			continue;
-		printk("*");
+		printk(KERN_CONT "*");
 	}
-	printk("\n");
+	printk(KERN_CONT "\n");
 }
 
 /* ------------------------------------------------------------------ */
diff --git a/drivers/media/pci/cx88/cx88-dsp.c b/drivers/media/pci/cx88/cx88-dsp.c
index 7fafd132ccaf..d00e20b1e53b 100644
--- a/drivers/media/pci/cx88/cx88-dsp.c
+++ b/drivers/media/pci/cx88/cx88-dsp.c
@@ -258,12 +258,7 @@ static s16 *read_rds_samples(struct cx88_core *core, u32 *N)
 		offset += 4;
 	}
 
-	if (dsp_debug >= 2) {
-		dprintk(2, "RDS samples dump: ");
-		for (i = 0; i < sample_count; i++)
-			printk("%hd ", samples[i]);
-		printk(".\n");
-	}
+	dprintk(2, "RDS samples dump: %*ph\n", sample_count, samples);
 
 	return samples;
 }
-- 
2.7.4


