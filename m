Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:41384 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751445Ab1FAOCj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 1 Jun 2011 10:02:39 -0400
Message-ID: <4DE64679.8040302@redhat.com>
Date: Wed, 01 Jun 2011 11:02:33 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
CC: tuxoholic@hotmail.de, linux-media@vger.kernel.org
Subject: Re: [PATCH] Refactor Mantis DMA transfer to deliver 16Kb TS data
 per interrupt
References: <BLU0-SMTP664E69E794AD6D8EAB4A1BD8980@phx.gbl>
In-Reply-To: <BLU0-SMTP664E69E794AD6D8EAB4A1BD8980@phx.gbl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Manu,

Em 13-08-2010 10:51, Stefan escreveu:
> Hello Marko
> 
> I confirm this patch reduces the amount of interrupts to nearly one third:
> 
> [*] v4l mercurial wo patch: about 600 calls/sec over a 10 seconds interval
> [*] v4l mercurial with patch: about 160 calls/sec over a 10 seconds interval
> 
> Measured using powertop -t 10
> Tuning a Twinhan/Azurewave AD SP400 CI (VP-1041) with szap
> 
> The same ratio using vdr 1.7.15 + xineliboutput + vdr-sfxe:
> 
> [*] wo patch: about 1100 calls/sec over a 10 seconds interval
> [*] with patch: about 320 calls/sec over a 10 seconds interval
> 
> Regards,
> Stefan
> 
>>
>> This patch obsoletes patch with broken spaces
>> https://patchwork.kernel.org/patch/107036/
>>
>> With VDR streaming HDTV into network, generating an interrupt once per 16kb,
>> implemented in this patch, seems to support more robust throughput with 
>> HDTV.
>> Fix leaking almost 64kb data from the previous TS after changing the TS.
>> One effect of the old version was, that the DMA transfer and driver's
>> DMA buffer access might happen at the same time - a race condition.
>>
>> Signed-off-by: Marko M. Ristola <marko.ristola@xxxxxxxxxxxx>
>>
>> Regards,
>> Marko Ristola
>>

This is another patch sitting at your queue for about one year. Please ack it
or comment. Otherwise, I'll assume that the patch is correct and I'll apply it.

Thanks,
Mauro

patches/lmml_118173_refactor_mantis_dma_transfer_to_deliver_16kb_ts_data_per_interrupt.patch
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Refactor Mantis DMA transfer to deliver 16Kb TS data per interrupt
Date: Sat, 07 Aug 2010 12:16:15 -0000
From: Marko Ristola <marko.ristola@kolumbus.fi>
X-Patchwork-Id: 118173
Message-Id: <4C5D4E8F.6080602@kolumbus.fi>
To: Linux Media Mailing List <linux-media@vger.kernel.org>

This patch obsoletes patch with broken spaces
https://patchwork.kernel.org/patch/107036/

With VDR streaming HDTV into network, generating an interrupt once per 16kb,
implemented in this patch, seems to support more robust throughput with HDTV.

Fix leaking almost 64kb data from the previous TS after changing the TS.
One effect of the old version was, that the DMA transfer and driver's
DMA buffer access might happen at the same time - a race condition.

Signed-off-by: Marko M. Ristola <marko.ristola@kolumbus.fi>

Regards,
Marko Ristola

diff --git a/drivers/media/dvb/mantis/hopper_cards.c b/drivers/media/dvb/mantis/hopper_cards.c
index 09e9fc7..3b7e376 100644
--- a/drivers/media/dvb/mantis/hopper_cards.c
+++ b/drivers/media/dvb/mantis/hopper_cards.c
@@ -126,7 +126,7 @@ static irqreturn_t hopper_irq_handler(int irq, void *dev_id)
 	}
 	if (stat & MANTIS_INT_RISCI) {
 		dprintk(MANTIS_DEBUG, 0, "<%s>", label[8]);
-		mantis->finished_block = (stat & MANTIS_INT_RISCSTAT) >> 28;
+		mantis->busy_block = (stat & MANTIS_INT_RISCSTAT) >> 28;
 		tasklet_schedule(&mantis->tasklet);
 	}
 	if (stat & MANTIS_INT_I2CDONE) {
diff --git a/drivers/media/dvb/mantis/mantis_cards.c b/drivers/media/dvb/mantis/mantis_cards.c
index cf4b39f..8f048d5 100644
--- a/drivers/media/dvb/mantis/mantis_cards.c
+++ b/drivers/media/dvb/mantis/mantis_cards.c
@@ -134,7 +134,7 @@ static irqreturn_t mantis_irq_handler(int irq, void *dev_id)
 	}
 	if (stat & MANTIS_INT_RISCI) {
 		dprintk(MANTIS_DEBUG, 0, "<%s>", label[8]);
-		mantis->finished_block = (stat & MANTIS_INT_RISCSTAT) >> 28;
+		mantis->busy_block = (stat & MANTIS_INT_RISCSTAT) >> 28;
 		tasklet_schedule(&mantis->tasklet);
 	}
 	if (stat & MANTIS_INT_I2CDONE) {
diff --git a/drivers/media/dvb/mantis/mantis_common.h b/drivers/media/dvb/mantis/mantis_common.h
index d0b645a..23b23b7 100644
--- a/drivers/media/dvb/mantis/mantis_common.h
+++ b/drivers/media/dvb/mantis/mantis_common.h
@@ -122,11 +122,8 @@ struct mantis_pci {
 	unsigned int		num;
 
 	/*	RISC Core		*/
-	u32			finished_block;
+	u32			busy_block;
 	u32			last_block;
-	u32			line_bytes;
-	u32			line_count;
-	u32			risc_pos;
 	u8			*buf_cpu;
 	dma_addr_t		buf_dma;
 	u32			*risc_cpu;
diff --git a/drivers/media/dvb/mantis/mantis_dma.c b/drivers/media/dvb/mantis/mantis_dma.c
index 46202a4..c61ca7d 100644
--- a/drivers/media/dvb/mantis/mantis_dma.c
+++ b/drivers/media/dvb/mantis/mantis_dma.c
@@ -43,13 +43,17 @@
 #define RISC_IRQ		(0x01 << 24)
 
 #define RISC_STATUS(status)	((((~status) & 0x0f) << 20) | ((status & 0x0f) << 16))
-#define RISC_FLUSH()		(mantis->risc_pos = 0)
-#define RISC_INSTR(opcode)	(mantis->risc_cpu[mantis->risc_pos++] = cpu_to_le32(opcode))
+#define RISC_FLUSH(risc_pos)		(risc_pos = 0)
+#define RISC_INSTR(risc_pos, opcode)	(mantis->risc_cpu[risc_pos++] = cpu_to_le32(opcode))
 
 #define MANTIS_BUF_SIZE		(64 * 1024)
-#define MANTIS_BLOCK_BYTES	(MANTIS_BUF_SIZE >> 4)
-#define MANTIS_BLOCK_COUNT	(1 << 4)
-#define MANTIS_RISC_SIZE	PAGE_SIZE
+#define MANTIS_BLOCK_BYTES      (MANTIS_BUF_SIZE / 4)
+#define MANTIS_DMA_TR_BYTES     (2 * 1024) /* upper limit: 4095 bytes. */
+#define MANTIS_BLOCK_COUNT	(MANTIS_BUF_SIZE / MANTIS_BLOCK_BYTES)
+
+#define MANTIS_DMA_TR_UNITS     (MANTIS_BLOCK_BYTES / MANTIS_DMA_TR_BYTES)
+/* MANTIS_BUF_SIZE / MANTIS_DMA_TR_UNITS must not exceed MANTIS_RISC_SIZE (4k RISC cmd buffer) */
+#define MANTIS_RISC_SIZE	PAGE_SIZE /* RISC program must fit here. */
 
 int mantis_dma_exit(struct mantis_pci *mantis)
 {
@@ -124,27 +128,6 @@ err:
 	return -ENOMEM;
 }
 
-static inline int mantis_calc_lines(struct mantis_pci *mantis)
-{
-	mantis->line_bytes = MANTIS_BLOCK_BYTES;
-	mantis->line_count = MANTIS_BLOCK_COUNT;
-
-	while (mantis->line_bytes > 4095) {
-		mantis->line_bytes >>= 1;
-		mantis->line_count <<= 1;
-	}
-
-	dprintk(MANTIS_DEBUG, 1, "Mantis RISC block bytes=[%d], line bytes=[%d], line count=[%d]",
-		MANTIS_BLOCK_BYTES, mantis->line_bytes, mantis->line_count);
-
-	if (mantis->line_count > 255) {
-		dprintk(MANTIS_ERROR, 1, "Buffer size error");
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
 int mantis_dma_init(struct mantis_pci *mantis)
 {
 	int err = 0;
@@ -158,12 +141,6 @@ int mantis_dma_init(struct mantis_pci *mantis)
 
 		goto err;
 	}
-	err = mantis_calc_lines(mantis);
-	if (err < 0) {
-		dprintk(MANTIS_ERROR, 1, "Mantis calc lines failed");
-
-		goto err;
-	}
 
 	return 0;
 err:
@@ -174,31 +151,32 @@ EXPORT_SYMBOL_GPL(mantis_dma_init);
 static inline void mantis_risc_program(struct mantis_pci *mantis)
 {
 	u32 buf_pos = 0;
-	u32 line;
+	u32 line, step;
+	u32 risc_pos;
 
 	dprintk(MANTIS_DEBUG, 1, "Mantis create RISC program");
-	RISC_FLUSH();
-
-	dprintk(MANTIS_DEBUG, 1, "risc len lines %u, bytes per line %u",
-		mantis->line_count, mantis->line_bytes);
-
-	for (line = 0; line < mantis->line_count; line++) {
-		dprintk(MANTIS_DEBUG, 1, "RISC PROG line=[%d]", line);
-		if (!(buf_pos % MANTIS_BLOCK_BYTES)) {
-			RISC_INSTR(RISC_WRITE	|
-				   RISC_IRQ	|
-				   RISC_STATUS(((buf_pos / MANTIS_BLOCK_BYTES) +
-				   (MANTIS_BLOCK_COUNT - 1)) %
-				    MANTIS_BLOCK_COUNT) |
-				    mantis->line_bytes);
-		} else {
-			RISC_INSTR(RISC_WRITE	| mantis->line_bytes);
-		}
-		RISC_INSTR(mantis->buf_dma + buf_pos);
-		buf_pos += mantis->line_bytes;
+	RISC_FLUSH(risc_pos);
+
+	dprintk(MANTIS_DEBUG, 1, "risc len lines %u, bytes per line %u, bytes per DMA tr %u",
+		MANTIS_BLOCK_COUNT, MANTIS_BLOCK_BYTES, MANTIS_DMA_TR_BYTES);
+
+	for (line = 0; line < MANTIS_BLOCK_COUNT; line++) {
+		for (step = 0; step < MANTIS_DMA_TR_UNITS; step++) {
+			dprintk(MANTIS_DEBUG, 1, "RISC PROG line=[%d], step=[%d]", line, step);
+			if (step == 0) {
+				RISC_INSTR(risc_pos, RISC_WRITE	|
+					   RISC_IRQ	|
+					   RISC_STATUS(line) |
+					   MANTIS_DMA_TR_BYTES);
+			} else {
+				RISC_INSTR(risc_pos, RISC_WRITE | MANTIS_DMA_TR_BYTES);
+			}
+			RISC_INSTR(risc_pos, mantis->buf_dma + buf_pos);
+			buf_pos += MANTIS_DMA_TR_BYTES;
+		  }
 	}
-	RISC_INSTR(RISC_JUMP);
-	RISC_INSTR(mantis->risc_dma);
+	RISC_INSTR(risc_pos, RISC_JUMP);
+	RISC_INSTR(risc_pos, mantis->risc_dma);
 }
 
 void mantis_dma_start(struct mantis_pci *mantis)
@@ -210,7 +188,7 @@ void mantis_dma_start(struct mantis_pci *mantis)
 	mmwrite(mmread(MANTIS_GPIF_ADDR) | MANTIS_GPIF_HIFRDWRN, MANTIS_GPIF_ADDR);
 
 	mmwrite(0, MANTIS_DMA_CTL);
-	mantis->last_block = mantis->finished_block = 0;
+	mantis->last_block = mantis->busy_block = 0;
 
 	mmwrite(mmread(MANTIS_INT_MASK) | MANTIS_INT_RISCI, MANTIS_INT_MASK);
 
@@ -245,9 +223,9 @@ void mantis_dma_xfer(unsigned long data)
 	struct mantis_pci *mantis = (struct mantis_pci *) data;
 	struct mantis_hwconfig *config = mantis->hwconfig;
 
-	while (mantis->last_block != mantis->finished_block) {
+	while (mantis->last_block != mantis->busy_block) {
 		dprintk(MANTIS_DEBUG, 1, "last block=[%d] finished block=[%d]",
-			mantis->last_block, mantis->finished_block);
+			mantis->last_block, mantis->busy_block);
 
 		(config->ts_size ? dvb_dmx_swfilter_204 : dvb_dmx_swfilter)
 		(&mantis->demux, &mantis->buf_cpu[mantis->last_block * MANTIS_BLOCK_BYTES], MANTIS_BLOCK_BYTES);

