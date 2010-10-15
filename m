Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:25086 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754405Ab0JOONF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Oct 2010 10:13:05 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o9FED4e5017485
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 15 Oct 2010 10:13:04 -0400
Date: Fri, 15 Oct 2010 10:13:03 -0400
From: Jarod Wilson <jarod@redhat.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
Subject: [PATCH] IR/nuvoton: address all checkpatch.pl issues
Message-ID: <20101015141303.GC9658@redhat.com>
References: <20101008214407.GI5165@redhat.com>
 <AANLkTimezuonksK=wW1PAkW40oo-KPRMrVdoNxymK69f@mail.gmail.com>
 <20101012135028.GF4057@redhat.com>
 <4CB7CD0D.60605@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CB7CD0D.60605@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, Oct 15, 2010 at 12:39:57AM -0300, Mauro Carvalho Chehab wrote:
> Em 12-10-2010 10:50, Jarod Wilson escreveu:
> > Jarod Wilson (8):
> >       IR: add driver for Nuvoton w836x7hg integrated CIR
> 
> There's a number of checkpatch issues on this patch. Please send me later a patch 
> addressing them. The 80-cols warnings seem bogus to me.
> You should notice that a few printk's have the \n missing. Not sure if you forgot, or
> if you should be using KERN_CONT for some printk's.

D'oh. I forgot to checkpatch it entirely. The following should take care
of it all.

>From cb24961b294a6fd13f4297fd2da634e379a8a9a8 Mon Sep 17 00:00:00 2001
From: Jarod Wilson <jarod@redhat.com>
Date: Fri, 15 Oct 2010 10:07:37 -0400
Subject: [PATCH] IR/nuvoton: address all checkpatch.pl issues

The driver was missing KERN_ facilities on a number of printks. The
register dump functions have been updated to use KERN_INFO, so that the
register dump gets logged in syslog (they only run on driver load, and
only when debug is enabled). The buffer dump routine now uses
KERN_DEBUG, as that spew will happen quite frequently (several times
every IR signal), and shouldn't need to be logged.

Also split up the small handful of lines that were just over 80
characaters, and fixed the ioctl.h include.

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/IR/nuvoton-cir.c |  112 +++++++++++++++++++++-------------------
 drivers/media/IR/nuvoton-cir.h |    2 +-
 2 files changed, 60 insertions(+), 54 deletions(-)

diff --git a/drivers/media/IR/nuvoton-cir.c b/drivers/media/IR/nuvoton-cir.c
index fdb280e..2f0f780 100644
--- a/drivers/media/IR/nuvoton-cir.c
+++ b/drivers/media/IR/nuvoton-cir.c
@@ -126,40 +126,43 @@ static u8 nvt_cir_wake_reg_read(struct nvt_dev *nvt, u8 offset)
 	return val;
 }
 
+#define pr_reg(text, ...) \
+	printk(KERN_INFO KBUILD_MODNAME ": " text, ## __VA_ARGS__)
+
 /* dump current cir register contents */
 static void cir_dump_regs(struct nvt_dev *nvt)
 {
 	nvt_efm_enable(nvt);
 	nvt_select_logical_dev(nvt, LOGICAL_DEV_CIR);
 
-	printk("%s: Dump CIR logical device registers:\n", NVT_DRIVER_NAME);
-	printk(" * CR CIR ACTIVE :   0x%x\n",
+	pr_reg("%s: Dump CIR logical device registers:\n", NVT_DRIVER_NAME);
+	pr_reg(" * CR CIR ACTIVE :   0x%x\n",
 	       nvt_cr_read(nvt, CR_LOGICAL_DEV_EN));
-	printk(" * CR CIR BASE ADDR: 0x%x\n",
+	pr_reg(" * CR CIR BASE ADDR: 0x%x\n",
 	       (nvt_cr_read(nvt, CR_CIR_BASE_ADDR_HI) << 8) |
 		nvt_cr_read(nvt, CR_CIR_BASE_ADDR_LO));
-	printk(" * CR CIR IRQ NUM:   0x%x\n",
+	pr_reg(" * CR CIR IRQ NUM:   0x%x\n",
 	       nvt_cr_read(nvt, CR_CIR_IRQ_RSRC));
 
 	nvt_efm_disable(nvt);
 
-	printk("%s: Dump CIR registers:\n", NVT_DRIVER_NAME);
-	printk(" * IRCON:     0x%x\n", nvt_cir_reg_read(nvt, CIR_IRCON));
-	printk(" * IRSTS:     0x%x\n", nvt_cir_reg_read(nvt, CIR_IRSTS));
-	printk(" * IREN:      0x%x\n", nvt_cir_reg_read(nvt, CIR_IREN));
-	printk(" * RXFCONT:   0x%x\n", nvt_cir_reg_read(nvt, CIR_RXFCONT));
-	printk(" * CP:        0x%x\n", nvt_cir_reg_read(nvt, CIR_CP));
-	printk(" * CC:        0x%x\n", nvt_cir_reg_read(nvt, CIR_CC));
-	printk(" * SLCH:      0x%x\n", nvt_cir_reg_read(nvt, CIR_SLCH));
-	printk(" * SLCL:      0x%x\n", nvt_cir_reg_read(nvt, CIR_SLCL));
-	printk(" * FIFOCON:   0x%x\n", nvt_cir_reg_read(nvt, CIR_FIFOCON));
-	printk(" * IRFIFOSTS: 0x%x\n", nvt_cir_reg_read(nvt, CIR_IRFIFOSTS));
-	printk(" * SRXFIFO:   0x%x\n", nvt_cir_reg_read(nvt, CIR_SRXFIFO));
-	printk(" * TXFCONT:   0x%x\n", nvt_cir_reg_read(nvt, CIR_TXFCONT));
-	printk(" * STXFIFO:   0x%x\n", nvt_cir_reg_read(nvt, CIR_STXFIFO));
-	printk(" * FCCH:      0x%x\n", nvt_cir_reg_read(nvt, CIR_FCCH));
-	printk(" * FCCL:      0x%x\n", nvt_cir_reg_read(nvt, CIR_FCCL));
-	printk(" * IRFSM:     0x%x\n", nvt_cir_reg_read(nvt, CIR_IRFSM));
+	pr_reg("%s: Dump CIR registers:\n", NVT_DRIVER_NAME);
+	pr_reg(" * IRCON:     0x%x\n", nvt_cir_reg_read(nvt, CIR_IRCON));
+	pr_reg(" * IRSTS:     0x%x\n", nvt_cir_reg_read(nvt, CIR_IRSTS));
+	pr_reg(" * IREN:      0x%x\n", nvt_cir_reg_read(nvt, CIR_IREN));
+	pr_reg(" * RXFCONT:   0x%x\n", nvt_cir_reg_read(nvt, CIR_RXFCONT));
+	pr_reg(" * CP:        0x%x\n", nvt_cir_reg_read(nvt, CIR_CP));
+	pr_reg(" * CC:        0x%x\n", nvt_cir_reg_read(nvt, CIR_CC));
+	pr_reg(" * SLCH:      0x%x\n", nvt_cir_reg_read(nvt, CIR_SLCH));
+	pr_reg(" * SLCL:      0x%x\n", nvt_cir_reg_read(nvt, CIR_SLCL));
+	pr_reg(" * FIFOCON:   0x%x\n", nvt_cir_reg_read(nvt, CIR_FIFOCON));
+	pr_reg(" * IRFIFOSTS: 0x%x\n", nvt_cir_reg_read(nvt, CIR_IRFIFOSTS));
+	pr_reg(" * SRXFIFO:   0x%x\n", nvt_cir_reg_read(nvt, CIR_SRXFIFO));
+	pr_reg(" * TXFCONT:   0x%x\n", nvt_cir_reg_read(nvt, CIR_TXFCONT));
+	pr_reg(" * STXFIFO:   0x%x\n", nvt_cir_reg_read(nvt, CIR_STXFIFO));
+	pr_reg(" * FCCH:      0x%x\n", nvt_cir_reg_read(nvt, CIR_FCCH));
+	pr_reg(" * FCCL:      0x%x\n", nvt_cir_reg_read(nvt, CIR_FCCL));
+	pr_reg(" * IRFSM:     0x%x\n", nvt_cir_reg_read(nvt, CIR_IRFSM));
 }
 
 /* dump current cir wake register contents */
@@ -170,59 +173,59 @@ static void cir_wake_dump_regs(struct nvt_dev *nvt)
 	nvt_efm_enable(nvt);
 	nvt_select_logical_dev(nvt, LOGICAL_DEV_CIR_WAKE);
 
-	printk("%s: Dump CIR WAKE logical device registers:\n",
+	pr_reg("%s: Dump CIR WAKE logical device registers:\n",
 	       NVT_DRIVER_NAME);
-	printk(" * CR CIR WAKE ACTIVE :   0x%x\n",
+	pr_reg(" * CR CIR WAKE ACTIVE :   0x%x\n",
 	       nvt_cr_read(nvt, CR_LOGICAL_DEV_EN));
-	printk(" * CR CIR WAKE BASE ADDR: 0x%x\n",
+	pr_reg(" * CR CIR WAKE BASE ADDR: 0x%x\n",
 	       (nvt_cr_read(nvt, CR_CIR_BASE_ADDR_HI) << 8) |
-	        nvt_cr_read(nvt, CR_CIR_BASE_ADDR_LO));
-	printk(" * CR CIR WAKE IRQ NUM:   0x%x\n",
+		nvt_cr_read(nvt, CR_CIR_BASE_ADDR_LO));
+	pr_reg(" * CR CIR WAKE IRQ NUM:   0x%x\n",
 	       nvt_cr_read(nvt, CR_CIR_IRQ_RSRC));
 
 	nvt_efm_disable(nvt);
 
-	printk("%s: Dump CIR WAKE registers\n", NVT_DRIVER_NAME);
-	printk(" * IRCON:          0x%x\n",
+	pr_reg("%s: Dump CIR WAKE registers\n", NVT_DRIVER_NAME);
+	pr_reg(" * IRCON:          0x%x\n",
 	       nvt_cir_wake_reg_read(nvt, CIR_WAKE_IRCON));
-	printk(" * IRSTS:          0x%x\n",
+	pr_reg(" * IRSTS:          0x%x\n",
 	       nvt_cir_wake_reg_read(nvt, CIR_WAKE_IRSTS));
-	printk(" * IREN:           0x%x\n",
+	pr_reg(" * IREN:           0x%x\n",
 	       nvt_cir_wake_reg_read(nvt, CIR_WAKE_IREN));
-	printk(" * FIFO CMP DEEP:  0x%x\n",
+	pr_reg(" * FIFO CMP DEEP:  0x%x\n",
 	       nvt_cir_wake_reg_read(nvt, CIR_WAKE_FIFO_CMP_DEEP));
-	printk(" * FIFO CMP TOL:   0x%x\n",
+	pr_reg(" * FIFO CMP TOL:   0x%x\n",
 	       nvt_cir_wake_reg_read(nvt, CIR_WAKE_FIFO_CMP_TOL));
-	printk(" * FIFO COUNT:     0x%x\n",
+	pr_reg(" * FIFO COUNT:     0x%x\n",
 	       nvt_cir_wake_reg_read(nvt, CIR_WAKE_FIFO_COUNT));
-	printk(" * SLCH:           0x%x\n",
+	pr_reg(" * SLCH:           0x%x\n",
 	       nvt_cir_wake_reg_read(nvt, CIR_WAKE_SLCH));
-	printk(" * SLCL:           0x%x\n",
+	pr_reg(" * SLCL:           0x%x\n",
 	       nvt_cir_wake_reg_read(nvt, CIR_WAKE_SLCL));
-	printk(" * FIFOCON:        0x%x\n",
+	pr_reg(" * FIFOCON:        0x%x\n",
 	       nvt_cir_wake_reg_read(nvt, CIR_WAKE_FIFOCON));
-	printk(" * SRXFSTS:        0x%x\n",
+	pr_reg(" * SRXFSTS:        0x%x\n",
 	       nvt_cir_wake_reg_read(nvt, CIR_WAKE_SRXFSTS));
-	printk(" * SAMPLE RX FIFO: 0x%x\n",
+	pr_reg(" * SAMPLE RX FIFO: 0x%x\n",
 	       nvt_cir_wake_reg_read(nvt, CIR_WAKE_SAMPLE_RX_FIFO));
-	printk(" * WR FIFO DATA:   0x%x\n",
+	pr_reg(" * WR FIFO DATA:   0x%x\n",
 	       nvt_cir_wake_reg_read(nvt, CIR_WAKE_WR_FIFO_DATA));
-	printk(" * RD FIFO ONLY:   0x%x\n",
+	pr_reg(" * RD FIFO ONLY:   0x%x\n",
 	       nvt_cir_wake_reg_read(nvt, CIR_WAKE_RD_FIFO_ONLY));
-	printk(" * RD FIFO ONLY IDX: 0x%x\n",
+	pr_reg(" * RD FIFO ONLY IDX: 0x%x\n",
 	       nvt_cir_wake_reg_read(nvt, CIR_WAKE_RD_FIFO_ONLY_IDX));
-	printk(" * FIFO IGNORE:    0x%x\n",
+	pr_reg(" * FIFO IGNORE:    0x%x\n",
 	       nvt_cir_wake_reg_read(nvt, CIR_WAKE_FIFO_IGNORE));
-	printk(" * IRFSM:          0x%x\n",
+	pr_reg(" * IRFSM:          0x%x\n",
 	       nvt_cir_wake_reg_read(nvt, CIR_WAKE_IRFSM));
 
 	fifo_len = nvt_cir_wake_reg_read(nvt, CIR_WAKE_FIFO_COUNT);
-	printk("%s: Dump CIR WAKE FIFO (len %d)\n", NVT_DRIVER_NAME, fifo_len);
-	printk("* Contents = ");
+	pr_reg("%s: Dump CIR WAKE FIFO (len %d)\n", NVT_DRIVER_NAME, fifo_len);
+	pr_reg("* Contents = ");
 	for (i = 0; i < fifo_len; i++)
-		printk("%02x ",
+		printk(KERN_CONT "%02x ",
 		       nvt_cir_wake_reg_read(nvt, CIR_WAKE_RD_FIFO_ONLY));
-	printk("\n");
+	printk(KERN_CONT "\n");
 }
 
 /* detect hardware features */
@@ -362,8 +365,10 @@ static void nvt_cir_regs_init(struct nvt_dev *nvt)
 	 * Enable TX and RX, specify carrier on = low, off = high, and set
 	 * sample period (currently 50us)
 	 */
-	nvt_cir_reg_write(nvt, CIR_IRCON_TXEN | CIR_IRCON_RXEN | CIR_IRCON_RXINV |
-			  CIR_IRCON_SAMPLE_PERIOD_SEL, CIR_IRCON);
+	nvt_cir_reg_write(nvt,
+			  CIR_IRCON_TXEN | CIR_IRCON_RXEN |
+			  CIR_IRCON_RXINV | CIR_IRCON_SAMPLE_PERIOD_SEL,
+			  CIR_IRCON);
 
 	/* clear hardware rx and tx fifos */
 	nvt_clear_cir_fifo(nvt);
@@ -425,7 +430,8 @@ static void nvt_enable_wake(struct nvt_dev *nvt)
 
 	nvt_cir_wake_reg_write(nvt, CIR_WAKE_IRCON_MODE0 | CIR_WAKE_IRCON_RXEN |
 			       CIR_WAKE_IRCON_R | CIR_WAKE_IRCON_RXINV |
-			       CIR_WAKE_IRCON_SAMPLE_PERIOD_SEL, CIR_WAKE_IRCON);
+			       CIR_WAKE_IRCON_SAMPLE_PERIOD_SEL,
+			       CIR_WAKE_IRCON);
 	nvt_cir_wake_reg_write(nvt, 0xff, CIR_WAKE_IRSTS);
 	nvt_cir_wake_reg_write(nvt, 0, CIR_WAKE_IREN);
 }
@@ -560,10 +566,10 @@ static void nvt_dump_rx_buf(struct nvt_dev *nvt)
 {
 	int i;
 
-	printk("%s (len %d): ", __func__, nvt->pkts);
+	printk(KERN_DEBUG "%s (len %d): ", __func__, nvt->pkts);
 	for (i = 0; (i < nvt->pkts) && (i < RX_BUF_LEN); i++)
-		printk("0x%02x ", nvt->buf[i]);
-	printk("\n");
+		printk(KERN_CONT "0x%02x ", nvt->buf[i]);
+	printk(KERN_CONT "\n");
 }
 
 /*
diff --git a/drivers/media/IR/nuvoton-cir.h b/drivers/media/IR/nuvoton-cir.h
index 12bfe89..62dc530 100644
--- a/drivers/media/IR/nuvoton-cir.h
+++ b/drivers/media/IR/nuvoton-cir.h
@@ -26,7 +26,7 @@
  */
 
 #include <linux/spinlock.h>
-#include <asm/ioctl.h>
+#include <linux/ioctl.h>
 
 /* platform driver name to register */
 #define NVT_DRIVER_NAME "nuvoton-cir"
-- 
1.7.1


-- 
Jarod Wilson
jarod@redhat.com

