Return-path: <linux-media-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:48729 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755939Ab0FTJM6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Jun 2010 05:12:58 -0400
Received: from saunalahti-vams (vs3-12.mail.saunalahti.fi [62.142.5.96])
	by emh07-2.mail.saunalahti.fi (Postfix) with SMTP id 241F218D18E
	for <linux-media@vger.kernel.org>; Sun, 20 Jun 2010 12:12:56 +0300 (EEST)
Received: from tammi.koti (a88-114-153-83.elisa-laajakaista.fi [88.114.153.83])
	by emh04.mail.saunalahti.fi (Postfix) with ESMTP id 01B2541BE7
	for <linux-media@vger.kernel.org>; Sun, 20 Jun 2010 12:12:53 +0300 (EEST)
Message-ID: <4C1DDB95.5050401@kolumbus.fi>
Date: Sun, 20 Jun 2010 12:12:53 +0300
From: Marko Ristola <marko.ristola@kolumbus.fi>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH] Mantis DMA transfer cleanup, fixes data corruption and a
 race, improves performance.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi

Here is another version of the DMA transfer fix.
Please try it. Comments?

The current DMA code with drivers/media/dvb/mantis/mantis_dma.c has user 
visible problems:
- about 1500 interrupts per second. One CPU can't copy h.264 data over 
the network for me (vdr, streamdev).
- 64K garbage at start of the data stream, part of which goes into User 
land application.
The garbage data is partly from the same stream (given twice), and 
partly from previous tuned frequency (buffer
uninitialized at DMA start).
- Race condition: Memory copying from DMA buffer is done at the same 
time as there is DMA transfer going on to the same bytes.
Can this race cause harware problems?

Current DMA code is not clear:
Current DMA RISC coding creates one DMA transfer per 2048 bytes.
Risc command generating code has mantis->line_count=32.
mantis->last_block and mantis->finished_block iterates over [0 to 16].

These counters are confusing. It takes lots of time to look and debug to 
understand
what is happening there even for me :(

Basic example how the 64K garbage generation happens:
At mantis_dma_start, mantis->last_block = mantis->finished_block = 0
1st DMA transfer (2048 bytes) generates interrupt, sets 
mantis->finished_block=15.
Tasklet will call mantis_dma_xfer(), which iterates from 
mantis->last_block = 0 to mantis->finished_block = 14. Set last_block=15.
2nd DMA transfer of 2048 bytes goes quietly (no interrupt generated), 
race with the tasklet above here.
3rd DMA transfer sets mantis->finished_block = 0, mantis_dma_xfer() 
copies mantis->finished_block = 15. Set last_block=0.
After this copying continues from block 0, so the content is valid, 
although block 0 was already partly copied.

Because the current looping implementation is too hard to understand,
I decided to rewrite it and not give you any small patch that fixes the 
issue but nobody else understands it.
This doesn't have the alignment stuff at all that I mentioned in earlier 
emails last week.

Basic idea:
Keep DMA buffer of size 64k, but generate interrupts four times, thus 
one interrupt per 16k.
Rename mantis->finished_block to be mantis->busy_block, because that 
keeps mantis_dma_xfer() simple:
while(mantis->last_block != mantis->busy_block) { do copy, last_block = 
(last_block + 1) mod 4.
last_block is thus incremented until last_block == busy_block, which 
can't be copied yet.

DMA RISC code generation: outer loop iterates over blocks from 0 to 4.
Inner loop iterates over DMA transfer units from 0 to 
MANTIS_DMA_TR_UNITS, each DMA transfer is 2048 bytes.
The interrupt is generated at block[0], DMA unit 0: the block 0 is now 
busy :)

mantis->line_bytes, mantis->line_count and mantis->risc_pos
were used only for DMA risc code generation.
Removed them from the structure.

Benefits of this code:
- Removes the 64k garbage issue.
- Remove race condition with concurrent DMA transfer and memory copy.
- Lessen interrupts to about 350 per second (seen by powertop) by
   moving 16k bytes per interrupt, instead of 4k per interrupt.
   The number of interrupts gets much smaller, and it becomes possible 
with single core AMD cpu to
   deliver h.264 data over the network from vdr via streamdev.
- Mantis DMA code is more understandable for reviewers and others.

My patch is GPLv2.
The patch is made against GIT linuxtv/master, applies cleanly to 
Mercurial v4l-dvb too.

Best regards,
Marko Ristola

diff --git a/drivers/media/dvb/mantis/hopper_cards.c 
b/drivers/media/dvb/mantis/hopper_cards.c
index 09e9fc7..3b7e376 100644
--- a/drivers/media/dvb/mantis/hopper_cards.c
+++ b/drivers/media/dvb/mantis/hopper_cards.c
@@ -126,7 +126,7 @@ static irqreturn_t hopper_irq_handler(int irq, void 
*dev_id)
      }
      if (stat & MANTIS_INT_RISCI) {
          dprintk(MANTIS_DEBUG, 0, "<%s>", label[8]);
-        mantis->finished_block = (stat & MANTIS_INT_RISCSTAT) >> 28;
+        mantis->busy_block = (stat & MANTIS_INT_RISCSTAT) >> 28;
          tasklet_schedule(&mantis->tasklet);
      }
      if (stat & MANTIS_INT_I2CDONE) {
diff --git a/drivers/media/dvb/mantis/mantis_cards.c 
b/drivers/media/dvb/mantis/mantis_cards.c
index cf4b39f..8f048d5 100644
--- a/drivers/media/dvb/mantis/mantis_cards.c
+++ b/drivers/media/dvb/mantis/mantis_cards.c
@@ -134,7 +134,7 @@ static irqreturn_t mantis_irq_handler(int irq, void 
*dev_id)
      }
      if (stat & MANTIS_INT_RISCI) {
          dprintk(MANTIS_DEBUG, 0, "<%s>", label[8]);
-        mantis->finished_block = (stat & MANTIS_INT_RISCSTAT) >> 28;
+        mantis->busy_block = (stat & MANTIS_INT_RISCSTAT) >> 28;
          tasklet_schedule(&mantis->tasklet);
      }
      if (stat & MANTIS_INT_I2CDONE) {
diff --git a/drivers/media/dvb/mantis/mantis_common.h 
b/drivers/media/dvb/mantis/mantis_common.h
index d0b645a..23b23b7 100644
--- a/drivers/media/dvb/mantis/mantis_common.h
+++ b/drivers/media/dvb/mantis/mantis_common.h
@@ -122,11 +122,8 @@ struct mantis_pci {
      unsigned int        num;

      /*    RISC Core        */
-    u32            finished_block;
+    u32            busy_block;
      u32            last_block;
-    u32            line_bytes;
-    u32            line_count;
-    u32            risc_pos;
      u8            *buf_cpu;
      dma_addr_t        buf_dma;
      u32            *risc_cpu;
diff --git a/drivers/media/dvb/mantis/mantis_dma.c 
b/drivers/media/dvb/mantis/mantis_dma.c
index 46202a4..c61ca7d 100644
--- a/drivers/media/dvb/mantis/mantis_dma.c
+++ b/drivers/media/dvb/mantis/mantis_dma.c
@@ -43,13 +43,17 @@
  #define RISC_IRQ        (0x01 << 24)

  #define RISC_STATUS(status)    ((((~status) & 0x0f) << 20) | ((status 
& 0x0f) << 16))
-#define RISC_FLUSH()        (mantis->risc_pos = 0)
-#define RISC_INSTR(opcode)    (mantis->risc_cpu[mantis->risc_pos++] = 
cpu_to_le32(opcode))
+#define RISC_FLUSH(risc_pos)        (risc_pos = 0)
+#define RISC_INSTR(risc_pos, opcode)    (mantis->risc_cpu[risc_pos++] = 
cpu_to_le32(opcode))

  #define MANTIS_BUF_SIZE        (64 * 1024)
-#define MANTIS_BLOCK_BYTES    (MANTIS_BUF_SIZE >> 4)
-#define MANTIS_BLOCK_COUNT    (1 << 4)
-#define MANTIS_RISC_SIZE    PAGE_SIZE
+#define MANTIS_BLOCK_BYTES      (MANTIS_BUF_SIZE / 4)
+#define MANTIS_DMA_TR_BYTES     (2 * 1024) /* upper limit: 4095 bytes. */
+#define MANTIS_BLOCK_COUNT    (MANTIS_BUF_SIZE / MANTIS_BLOCK_BYTES)
+
+#define MANTIS_DMA_TR_UNITS     (MANTIS_BLOCK_BYTES / MANTIS_DMA_TR_BYTES)
+/* MANTIS_BUF_SIZE / MANTIS_DMA_TR_UNITS must not exceed 
MANTIS_RISC_SIZE (4k RISC cmd buffer) */
+#define MANTIS_RISC_SIZE    PAGE_SIZE /* RISC program must fit here. */

  int mantis_dma_exit(struct mantis_pci *mantis)
  {
@@ -124,27 +128,6 @@ err:
      return -ENOMEM;
  }

-static inline int mantis_calc_lines(struct mantis_pci *mantis)
-{
-    mantis->line_bytes = MANTIS_BLOCK_BYTES;
-    mantis->line_count = MANTIS_BLOCK_COUNT;
-
-    while (mantis->line_bytes > 4095) {
-        mantis->line_bytes >>= 1;
-        mantis->line_count <<= 1;
-    }
-
-    dprintk(MANTIS_DEBUG, 1, "Mantis RISC block bytes=[%d], line 
bytes=[%d], line count=[%d]",
-        MANTIS_BLOCK_BYTES, mantis->line_bytes, mantis->line_count);
-
-    if (mantis->line_count > 255) {
-        dprintk(MANTIS_ERROR, 1, "Buffer size error");
-        return -EINVAL;
-    }
-
-    return 0;
-}
-
  int mantis_dma_init(struct mantis_pci *mantis)
  {
      int err = 0;
@@ -158,12 +141,6 @@ int mantis_dma_init(struct mantis_pci *mantis)

          goto err;
      }
-    err = mantis_calc_lines(mantis);
-    if (err < 0) {
-        dprintk(MANTIS_ERROR, 1, "Mantis calc lines failed");
-
-        goto err;
-    }

      return 0;
  err:
@@ -174,31 +151,32 @@ EXPORT_SYMBOL_GPL(mantis_dma_init);
  static inline void mantis_risc_program(struct mantis_pci *mantis)
  {
      u32 buf_pos = 0;
-    u32 line;
+    u32 line, step;
+    u32 risc_pos;

      dprintk(MANTIS_DEBUG, 1, "Mantis create RISC program");
-    RISC_FLUSH();
-
-    dprintk(MANTIS_DEBUG, 1, "risc len lines %u, bytes per line %u",
-        mantis->line_count, mantis->line_bytes);
-
-    for (line = 0; line < mantis->line_count; line++) {
-        dprintk(MANTIS_DEBUG, 1, "RISC PROG line=[%d]", line);
-        if (!(buf_pos % MANTIS_BLOCK_BYTES)) {
-            RISC_INSTR(RISC_WRITE    |
-                   RISC_IRQ    |
-                   RISC_STATUS(((buf_pos / MANTIS_BLOCK_BYTES) +
-                   (MANTIS_BLOCK_COUNT - 1)) %
-                    MANTIS_BLOCK_COUNT) |
-                    mantis->line_bytes);
-        } else {
-            RISC_INSTR(RISC_WRITE    | mantis->line_bytes);
-        }
-        RISC_INSTR(mantis->buf_dma + buf_pos);
-        buf_pos += mantis->line_bytes;
+    RISC_FLUSH(risc_pos);
+
+    dprintk(MANTIS_DEBUG, 1, "risc len lines %u, bytes per line %u, 
bytes per DMA tr %u",
+        MANTIS_BLOCK_COUNT, MANTIS_BLOCK_BYTES, MANTIS_DMA_TR_BYTES);
+
+    for (line = 0; line < MANTIS_BLOCK_COUNT; line++) {
+        for (step = 0; step < MANTIS_DMA_TR_UNITS; step++) {
+            dprintk(MANTIS_DEBUG, 1, "RISC PROG line=[%d], step=[%d]", 
line, step);
+            if (step == 0) {
+                RISC_INSTR(risc_pos, RISC_WRITE    |
+                       RISC_IRQ    |
+                       RISC_STATUS(line) |
+                       MANTIS_DMA_TR_BYTES);
+            } else {
+                RISC_INSTR(risc_pos, RISC_WRITE | MANTIS_DMA_TR_BYTES);
+            }
+            RISC_INSTR(risc_pos, mantis->buf_dma + buf_pos);
+            buf_pos += MANTIS_DMA_TR_BYTES;
+          }
      }
-    RISC_INSTR(RISC_JUMP);
-    RISC_INSTR(mantis->risc_dma);
+    RISC_INSTR(risc_pos, RISC_JUMP);
+    RISC_INSTR(risc_pos, mantis->risc_dma);
  }

  void mantis_dma_start(struct mantis_pci *mantis)
@@ -210,7 +188,7 @@ void mantis_dma_start(struct mantis_pci *mantis)
      mmwrite(mmread(MANTIS_GPIF_ADDR) | MANTIS_GPIF_HIFRDWRN, 
MANTIS_GPIF_ADDR);

      mmwrite(0, MANTIS_DMA_CTL);
-    mantis->last_block = mantis->finished_block = 0;
+    mantis->last_block = mantis->busy_block = 0;

      mmwrite(mmread(MANTIS_INT_MASK) | MANTIS_INT_RISCI, MANTIS_INT_MASK);

@@ -245,9 +223,9 @@ void mantis_dma_xfer(unsigned long data)
      struct mantis_pci *mantis = (struct mantis_pci *) data;
      struct mantis_hwconfig *config = mantis->hwconfig;

-    while (mantis->last_block != mantis->finished_block) {
+    while (mantis->last_block != mantis->busy_block) {
          dprintk(MANTIS_DEBUG, 1, "last block=[%d] finished block=[%d]",
-            mantis->last_block, mantis->finished_block);
+            mantis->last_block, mantis->busy_block);

          (config->ts_size ? dvb_dmx_swfilter_204 : dvb_dmx_swfilter)
          (&mantis->demux, &mantis->buf_cpu[mantis->last_block * 
MANTIS_BLOCK_BYTES], MANTIS_BLOCK_BYTES);
