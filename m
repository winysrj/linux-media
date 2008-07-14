Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <marko.ristola@kolumbus.fi>) id 1KIUIW-0001M4-EA
	for linux-dvb@linuxtv.org; Mon, 14 Jul 2008 22:05:28 +0200
Message-ID: <487BB17D.8080707@kolumbus.fi>
Date: Mon, 14 Jul 2008 23:05:17 +0300
From: Marko Ristola <marko.ristola@kolumbus.fi>
MIME-Version: 1.0
To: Leif Oberste-Berghaus <leif@oberste-berghaus.de>
References: <3b52bc790807101342o12f6f879n9c68704cd6b96e22@mail.gmail.com>
	<4879FA31.2080803@kolumbus.fi>
	<4A2CCDB3-57B0-4121-A94D-59F985FCDE2B@oberste-berghaus.de>
In-Reply-To: <4A2CCDB3-57B0-4121-A94D-59F985FCDE2B@oberste-berghaus.de>
Content-Type: multipart/mixed; boundary="------------080401090901050909030002"
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] TerraTec Cinergy C DVB-C / Twinhan AD-CP400
 (VP-2040) &	mantis driver
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--------------080401090901050909030002
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


Hi Leif,

Here is a patch that implements the mentioned DMA transfer improvements.
I hope that these contain also the needed fix for you.
You can apply it into jusst.de/mantis Mercurial branch.
It modifies linux/drivers/media/dvb/mantis/mantis_dma.c only.
I have compiled the patch against 2.6.25.9-76.fc9.x86_64.

cd mantis
patch -p1 < mantis_dma.c.aligned_dma_trs.patch

Please tell us whether my patch helps you or not: if it helps, some of 
my patch might get into jusst.de as
a fix for your problem.

Best Regards,
Marko

Leif Oberste-Berghaus wrote:
> Hi Marko,
>
> thanks for you information.
>
> Could you be so kind to point out how to configure the "aligmnent for 
> DMA tranfers" and how to generate "less IRQs from DMA transfer"?
>
> Regards,
> Leif
>
> Am 13.07.2008 um 14:50 schrieb Marko Ristola:
>
>>
>> Hi,
>>
>> I have Twinhan DVB-C 2033.
>> I have had freezes /reboots.
>>
>> I did following things with the driver to stabilize things (my own 
>> driver version):
>> - Implement both 64byte and 188 byte alignment for DMA transfers.
>> - Generate less IRQs from DMA transfers.
>>
>> That has helped: My AMD dualcore don't do hard reset so often and the
>> saved TV programs are now usable (without my changes the dvb stream
>> lost voice and VDR couldn't show them more than a few minutes).
>> My version seems to use less power (Too weak power supply
>> might be part of my problem though).
>>
>> I don't know yet though whether Manu or others are interested in my 
>> patches.
>> I use too new kernel version to deliver patches for Manu easilly.
>>
>> Regards,
>> Marko Ristola
>


--------------080401090901050909030002
Content-Type: text/plain;
 name="mantis_dma.c.aligned_dma_trs.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="mantis_dma.c.aligned_dma_trs.patch"

diff -r 0b04be0c088a linux/drivers/media/dvb/mantis/mantis_dma.c
--- a/linux/drivers/media/dvb/mantis/mantis_dma.c	Wed May 28 13:25:23 2008 +0400
+++ b/linux/drivers/media/dvb/mantis/mantis_dma.c	Mon Jul 14 22:42:03 2008 +0300
@@ -28,26 +28,31 @@
 
 #define RISC_STATUS(status)	((((~status) & 0x0f) << 20) | ((status & 0x0f) << 16))
 #define RISC_FLUSH()		mantis->risc_pos = 0
 #define RISC_INSTR(opcode)	mantis->risc_cpu[mantis->risc_pos++] = cpu_to_le32(opcode)
 
-#define MANTIS_BUF_SIZE		64 * 1024
-#define MANTIS_BLOCK_BYTES	(MANTIS_BUF_SIZE >> 4)
-#define MANTIS_BLOCK_COUNT	(1 << 4)
+/* (16 * 188) = 3008. (16 * 204) = 3264. x % 64 == 0, x <= 4095 */
+#define RISC_DMA_TR_UNIT(m)     (((m->hwconfig->ts_size == MANTIS_TS_204)? 204:188) * 16)
+#define DMA_TRANSFERS_PER_BLOCK (9)
+#define MANTIS_BLOCK_BYTES(m)   (RISC_DMA_TR_UNIT(m) * DMA_TRANSFERS_PER_BLOCK)
+#define MANTIS_BLOCK_COUNT	(4)
 #define MANTIS_RISC_SIZE	PAGE_SIZE
+
+#define MANTIS_DMA_BUFSZ(m)     (m->line_bytes * m->line_count)
 
 int mantis_dma_exit(struct mantis_pci *mantis)
 {
 	if (mantis->buf_cpu) {
 		dprintk(verbose, MANTIS_ERROR, 1,
 			"DMA=0x%lx cpu=0x%p size=%d",
 			(unsigned long) mantis->buf_dma,
 			 mantis->buf_cpu,
-			 MANTIS_BUF_SIZE);
+			 MANTIS_DMA_BUFSZ(mantis));
 
-		pci_free_consistent(mantis->pdev, MANTIS_BUF_SIZE,
-				    mantis->buf_cpu, mantis->buf_dma);
+		pci_free_consistent(mantis->pdev, 
+				MANTIS_DMA_BUFSZ(mantis),
+			mantis->buf_cpu, mantis->buf_dma);
 
 		mantis->buf_cpu = NULL;
 	}
 	if (mantis->risc_cpu) {
 		dprintk(verbose, MANTIS_ERROR, 1,
@@ -67,22 +72,23 @@ int mantis_dma_exit(struct mantis_pci *m
 
 static inline int mantis_alloc_buffers(struct mantis_pci *mantis)
 {
 	if (!mantis->buf_cpu) {
 		mantis->buf_cpu = pci_alloc_consistent(mantis->pdev,
-						       MANTIS_BUF_SIZE,
-						       &mantis->buf_dma);
+				MANTIS_DMA_BUFSZ(mantis),
+			&mantis->buf_dma);
 		if (!mantis->buf_cpu) {
 			dprintk(verbose, MANTIS_ERROR, 1,
 				"DMA buffer allocation failed");
 
 			goto err;
 		}
 		dprintk(verbose, MANTIS_ERROR, 1,
 			"DMA=0x%lx cpu=0x%p size=%d",
 			(unsigned long) mantis->buf_dma,
-			mantis->buf_cpu, MANTIS_BUF_SIZE);
+			mantis->buf_cpu, 
+			MANTIS_DMA_BUFSZ(mantis));
 	}
 	if (!mantis->risc_cpu) {
 		mantis->risc_cpu = pci_alloc_consistent(mantis->pdev,
 							MANTIS_RISC_SIZE,
 							&mantis->risc_dma);
@@ -107,46 +113,38 @@ err:
 	return -ENOMEM;
 }
 
 static inline int mantis_calc_lines(struct mantis_pci *mantis)
 {
-	mantis->line_bytes = MANTIS_BLOCK_BYTES;
+	mantis->line_bytes = MANTIS_BLOCK_BYTES(mantis);
 	mantis->line_count = MANTIS_BLOCK_COUNT;
 
-	while (mantis->line_bytes > 4095) {
-		mantis->line_bytes >>= 1;
-		mantis->line_count <<= 1;
-	}
-
 	dprintk(verbose, MANTIS_DEBUG, 1,
-		"Mantis RISC block bytes=[%d], line bytes=[%d], line count=[%d]",
-		MANTIS_BLOCK_BYTES, mantis->line_bytes, mantis->line_count);
-
-	if (mantis->line_count > 255) {
-		dprintk(verbose, MANTIS_ERROR, 1, "Buffer size error");
-		return -EINVAL;
-	}
+		"Mantis RISC line bytes=[%d], line count=[%d]",
+		mantis->line_bytes, mantis->line_count);
 
 	return 0;
 }
 
 int mantis_dma_init(struct mantis_pci *mantis)
 {
 	int err = 0;
 
 	dprintk(verbose, MANTIS_DEBUG, 1, "Mantis DMA init");
+
+	if ((err = mantis_calc_lines(mantis)) < 0) {
+		dprintk(verbose, MANTIS_ERROR, 1, "Mantis calc lines failed");
+
+		goto err;
+	}
+
 	if (mantis_alloc_buffers(mantis) < 0) {
 		dprintk(verbose, MANTIS_ERROR, 1, "Error allocating DMA buffer");
 
 		// Stop RISC Engine
 //		mmwrite(mmread(MANTIS_DMA_CTL) & ~MANTIS_RISC_EN, MANTIS_DMA_CTL);
 		mmwrite(0, MANTIS_DMA_CTL);
-
-		goto err;
-	}
-	if ((err = mantis_calc_lines(mantis)) < 0) {
-		dprintk(verbose, MANTIS_ERROR, 1, "Mantis calc lines failed");
 
 		goto err;
 	}
 
 	return 0;
@@ -156,46 +154,48 @@ err:
 
 static inline void mantis_risc_program(struct mantis_pci *mantis)
 {
 	u32 buf_pos = 0;
 	u32 line;
+	u32 step_bytes;
 
+	step_bytes = RISC_DMA_TR_UNIT(mantis);
 	dprintk(verbose, MANTIS_DEBUG, 1, "Mantis create RISC program");
 	RISC_FLUSH();
 
 	dprintk(verbose, MANTIS_DEBUG, 1, "risc len lines %u, bytes per line %u",
 		mantis->line_count, mantis->line_bytes);
 
 	for (line = 0; line < mantis->line_count; line++) {
-		dprintk(verbose, MANTIS_DEBUG, 1, "RISC PROG line=[%d]", line);
-		if (!(buf_pos % MANTIS_BLOCK_BYTES)) {
-			RISC_INSTR(RISC_WRITE	|
-				   RISC_IRQ	|
-				   RISC_STATUS(((buf_pos / MANTIS_BLOCK_BYTES) +
-				   (MANTIS_BLOCK_COUNT - 1)) %
-				    MANTIS_BLOCK_COUNT) |
-				    mantis->line_bytes);
-		} else {
-			RISC_INSTR(RISC_WRITE	| mantis->line_bytes);
+		int risc_step;
+
+		for (risc_step = 0; risc_step < DMA_TRANSFERS_PER_BLOCK; risc_step++) {
+			dprintk(verbose, MANTIS_DEBUG, 1, "RISC PROG line=[%x] risc_step=[%x], step_bytes=[%x], buf_pos=[%x]", line, risc_step, step_bytes, buf_pos);
+			/* First step: informs that the previous line has been completed (round robin). */
+			RISC_INSTR(RISC_WRITE |
+				   ((risc_step == 1)? (RISC_IRQ | RISC_STATUS(line)) : 0) |
+				   step_bytes);
+			RISC_INSTR(mantis->buf_dma + buf_pos);
+			buf_pos += step_bytes;
 		}
-		RISC_INSTR(mantis->buf_dma + buf_pos);
-		buf_pos += mantis->line_bytes;
 	}
 	RISC_INSTR(RISC_JUMP);
 	RISC_INSTR(mantis->risc_dma);
+	dprintk(verbose, MANTIS_DEBUG, 1, "Final RISC PROG size=[%x/%x]", (u32)mantis->risc_pos, (u32)MANTIS_RISC_SIZE);
 }
 
 void mantis_dma_start(struct mantis_pci *mantis)
 {
 	dprintk(verbose, MANTIS_DEBUG, 1, "Mantis Start DMA engine");
 
+	memset(mantis->buf_cpu, 0, MANTIS_DMA_BUFSZ(mantis));
+	mantis->last_block = mantis->finished_block = 0;
 	mantis_risc_program(mantis);
 	mmwrite(mantis->risc_dma, MANTIS_RISC_START);
 	mmwrite(mmread(MANTIS_GPIF_ADDR) | MANTIS_GPIF_HIFRDWRN, MANTIS_GPIF_ADDR);
 
 	mmwrite(0, MANTIS_DMA_CTL);
-	mantis->last_block = mantis->finished_block = 0;
 
 	mmwrite(mmread(MANTIS_INT_MASK) | MANTIS_INT_RISCI, MANTIS_INT_MASK);
 
 	mmwrite(MANTIS_FIFO_EN | MANTIS_DCAP_EN
 			       | MANTIS_RISC_EN, MANTIS_DMA_CTL);
@@ -218,22 +218,24 @@ void mantis_dma_stop(struct mantis_pci *
 
 	mmwrite(mmread(MANTIS_INT_STAT), MANTIS_INT_STAT);
 
 	mmwrite(mmread(MANTIS_INT_MASK) & ~(MANTIS_INT_RISCI |
 					    MANTIS_INT_RISCEN), MANTIS_INT_MASK);
+
+	tasklet_kill(&mantis->tasklet);	
 }
 
 
 void mantis_dma_xfer(unsigned long data)
 {
 	struct mantis_pci *mantis = (struct mantis_pci *) data;
-	struct mantis_hwconfig *config = mantis->hwconfig;
+	
+	while (mantis->last_block != mantis->finished_block) {
 
-	while (mantis->last_block != mantis->finished_block) {
 		dprintk(verbose, MANTIS_DEBUG, 1, "last block=[%d] finished block=[%d]",
 			mantis->last_block, mantis->finished_block);
 
-		(config->ts_size ? dvb_dmx_swfilter_204: dvb_dmx_swfilter)
-		(&mantis->demux, &mantis->buf_cpu[mantis->last_block * MANTIS_BLOCK_BYTES], MANTIS_BLOCK_BYTES);
-		mantis->last_block = (mantis->last_block + 1) % MANTIS_BLOCK_COUNT;
+		(mantis->hwconfig->ts_size == MANTIS_TS_204 ? dvb_dmx_swfilter_204: dvb_dmx_swfilter)
+		(&mantis->demux, &mantis->buf_cpu[mantis->last_block * mantis->line_bytes], mantis->line_bytes);
+		mantis->last_block = (mantis->last_block + 1) % mantis->line_count;
 	}
 }

--------------080401090901050909030002
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------080401090901050909030002--
