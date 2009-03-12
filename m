Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110801.mail.gq1.yahoo.com ([67.195.13.224]:34409 "HELO
	web110801.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752215AbZCLMb3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Mar 2009 08:31:29 -0400
Message-ID: <996168.29586.qm@web110801.mail.gq1.yahoo.com>
Date: Thu, 12 Mar 2009 05:31:26 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: [PATCH 1/1] sdio: add low level i/o functions for workarounds
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Michael Krufky <mkrufky@linuxtv.org>, linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


sdio: add low level i/o functions for workarounds

From: Pierre Ossman <drzeus@drzeus.cx>

Some shoddy hardware doesn't properly adhere to the register model
of SDIO, but treats the system like a series of transaction. That means
that the drivers must have full control over what goes the bus (and the
core cannot optimize transactions or work around problems in host
controllers).
This commit adds some low level functions that gives SDIO drivers the
ability to send specific register access commands. They should only be
used when the hardware is truly broken though.

This patch has been created on August 2008, and re-generated against 2.6.29-rc7 .

Signed-off-by: Pierre Ossman <drzeus@drzeus.cx>
Signed-off-by: Uri Shkolnik <uris@siano-ms.com>


diff -uNr linux-2.6.29-rc7.prestine/drivers/mmc/core/sdio_io.c linux-2.6.29-rc7/drivers/mmc/core/sdio_io.c
--- linux-2.6.29-rc7.prestine/drivers/mmc/core/sdio_io.c	2009-03-04 03:05:22.000000000 +0200
+++ linux-2.6.29-rc7/drivers/mmc/core/sdio_io.c	2009-03-12 12:22:42.000000000 +0200
@@ -635,3 +635,252 @@
 		*err_ret = ret;
 }
 EXPORT_SYMBOL_GPL(sdio_f0_writeb);
+
+/**
+ *	sdio_read_bytes - low level byte mode transfer from an SDIO function
+ *	@func: SDIO function to access
+ *	@dst: buffer to store the data
+ *	@addr: address to begin reading from
+ *	@bytes: number of bytes to read
+ *
+ *	Performs a byte mode transfer from the address space of the given
+ *	SDIO function. The address is increased for each byte. Return
+ *	value indicates if the transfer succeeded or not.
+ *
+ *	Note: This is a low level function that should only be used as a
+ *	workaround when the hardware has a crappy register abstraction
+ *	that relies on specific SDIO operations.
+ */
+int sdio_read_bytes(struct sdio_func *func, void *dst,
+	unsigned int addr, int bytes)
+{
+	if (bytes > sdio_max_byte_size(func))
+		return -EINVAL;
+
+	return mmc_io_rw_extended(func->card, 0, func->num, addr, 1,
+			dst, 1, bytes);
+}
+EXPORT_SYMBOL_GPL(sdio_read_bytes);
+
+/**
+ *	sdio_read_bytes_noincr - low level byte mode transfer from an SDIO function
+ *	@func: SDIO function to access
+ *	@dst: buffer to store the data
+ *	@addr: address to begin reading from
+ *	@bytes: number of bytes to read
+ *
+ *	Performs a byte mode transfer from the address space of the given
+ *	SDIO function. The address is NOT increased for each byte. Return
+ *	value indicates if the transfer succeeded or not.
+ *
+ *	Note: This is a low level function that should only be used as a
+ *	workaround when the hardware has a crappy register abstraction
+ *	that relies on specific SDIO operations.
+ */
+int sdio_read_bytes_noincr(struct sdio_func *func, void *dst,
+	unsigned int addr, int bytes)
+{
+	if (bytes > sdio_max_byte_size(func))
+		return -EINVAL;
+
+	return mmc_io_rw_extended(func->card, 0, func->num, addr, 0,
+			dst, 1, bytes);
+}
+EXPORT_SYMBOL_GPL(sdio_read_bytes_noincr);
+
+/**
+ *	sdio_read_blocks - low level block mode transfer from an SDIO function
+ *	@func: SDIO function to access
+ *	@dst: buffer to store the data
+ *	@addr: address to begin reading from
+ *	@block: number of blocks to read
+ *
+ *	Performs a block mode transfer from the address space of the given
+ *	SDIO function. The address is increased for each byte. Return
+ *	value indicates if the transfer succeeded or not.
+ *
+ *	The block size needs to be explicitly changed by calling
+ *	sdio_set_block_size().
+ *
+ *	Note: This is a low level function that should only be used as a
+ *	workaround when the hardware has a crappy register abstraction
+ *	that relies on specific SDIO operations.
+ */
+int sdio_read_blocks(struct sdio_func *func, void *dst,
+	unsigned int addr, int blocks)
+{
+	if (!func->card->cccr.multi_block)
+		return -EINVAL;
+
+	if (blocks > func->card->host->max_blk_count)
+		return -EINVAL;
+	if (blocks > (func->card->host->max_seg_size / func->cur_blksize))
+		return -EINVAL;
+	if (blocks > 511)
+		return -EINVAL;
+
+	return mmc_io_rw_extended(func->card, 0, func->num, addr, 1,
+			dst, blocks, func->cur_blksize);
+}
+EXPORT_SYMBOL_GPL(sdio_read_blocks);
+
+/**
+ *	sdio_read_blocks_noincr - low level block mode transfer from an SDIO function
+ *	@func: SDIO function to access
+ *	@dst: buffer to store the data
+ *	@addr: address to begin reading from
+ *	@block: number of blocks to read
+ *
+ *	Performs a block mode transfer from the address space of the given
+ *	SDIO function. The address is NOT increased for each byte. Return
+ *	value indicates if the transfer succeeded or not.
+ *
+ *	The block size needs to be explicitly changed by calling
+ *	sdio_set_block_size().
+ *
+ *	Note: This is a low level function that should only be used as a
+ *	workaround when the hardware has a crappy register abstraction
+ *	that relies on specific SDIO operations.
+ */
+int sdio_read_blocks_noincr(struct sdio_func *func, void *dst,
+	unsigned int addr, int blocks)
+{
+	if (!func->card->cccr.multi_block)
+		return -EINVAL;
+
+	if (blocks > func->card->host->max_blk_count)
+		return -EINVAL;
+	if (blocks > (func->card->host->max_seg_size / func->cur_blksize))
+		return -EINVAL;
+	if (blocks > 511)
+		return -EINVAL;
+
+	return mmc_io_rw_extended(func->card, 0, func->num, addr, 0,
+			dst, blocks, func->cur_blksize);
+}
+EXPORT_SYMBOL_GPL(sdio_read_blocks_noincr);
+
+/**
+ *	sdio_write_bytes - low level byte mode transfer to an SDIO function
+ *	@func: SDIO function to access
+ *	@addr: address to start writing to
+ *	@src: buffer that contains the data to write
+ *	@bytes: number of bytes to write
+ *
+ *	Performs a byte mode transfer to the address space of the given
+ *	SDIO function. The address is increased for each byte. Return
+ *	value indicates if the transfer succeeded or not.
+ *
+ *	Note: This is a low level function that should only be used as a
+ *	workaround when the hardware has a crappy register abstraction
+ *	that relies on specific SDIO operations.
+ */
+int sdio_write_bytes(struct sdio_func *func, unsigned int addr,
+	 void *src, int bytes)
+{
+	if (bytes > sdio_max_byte_size(func))
+		return -EINVAL;
+
+	return mmc_io_rw_extended(func->card, 1, func->num, addr, 1,
+			src, 1, bytes);
+}
+EXPORT_SYMBOL_GPL(sdio_write_bytes);
+
+/**
+ *	sdio_write_bytes_noincr - low level byte mode transfer to an SDIO function
+ *	@func: SDIO function to access
+ *	@addr: address to start writing to
+ *	@src: buffer that contains the data to write
+ *	@bytes: number of bytes to write
+ *
+ *	Performs a byte mode transfer to the address space of the given
+ *	SDIO function. The address is NOT increased for each byte. Return
+ *	value indicates if the transfer succeeded or not.
+ *
+ *	Note: This is a low level function that should only be used as a
+ *	workaround when the hardware has a crappy register abstraction
+ *	that relies on specific SDIO operations.
+ */
+int sdio_write_bytes_noincr(struct sdio_func *func, unsigned int addr,
+	void *src, int bytes)
+{
+	if (bytes > sdio_max_byte_size(func))
+		return -EINVAL;
+
+	return mmc_io_rw_extended(func->card, 1, func->num, addr, 0,
+			src, 1, bytes);
+}
+EXPORT_SYMBOL_GPL(sdio_write_bytes_noincr);
+
+/**
+ *	sdio_read_blocks - low level block mode transfer to an SDIO function
+ *	@func: SDIO function to access
+ *	@addr: address to start writing to
+ *	@src: buffer that contains the data to write
+ *	@block: number of blocks to write
+ *
+ *	Performs a block mode transfer to the address space of the given
+ *	SDIO function. The address is increased for each byte. Return
+ *	value indicates if the transfer succeeded or not.
+ *
+ *	The block size needs to be explicitly changed by calling
+ *	sdio_set_block_size().
+ *
+ *	Note: This is a low level function that should only be used as a
+ *	workaround when the hardware has a crappy register abstraction
+ *	that relies on specific SDIO operations.
+ */
+int sdio_write_blocks(struct sdio_func *func, unsigned int addr,
+	void *src, int blocks)
+{
+	if (!func->card->cccr.multi_block)
+		return -EINVAL;
+
+	if (blocks > func->card->host->max_blk_count)
+		return -EINVAL;
+	if (blocks > (func->card->host->max_seg_size / func->cur_blksize))
+		return -EINVAL;
+	if (blocks > 511)
+		return -EINVAL;
+
+	return mmc_io_rw_extended(func->card, 1, func->num, addr, 1,
+			src, blocks, func->cur_blksize);
+}
+EXPORT_SYMBOL_GPL(sdio_write_blocks);
+
+/**
+ *	sdio_read_blocks_noincr - low level block mode transfer to an SDIO function
+ *	@func: SDIO function to access
+ *	@addr: address to start writing to
+ *	@src: buffer that contains the data to write
+ *	@block: number of blocks to write
+ *
+ *	Performs a block mode transfer to the address space of the given
+ *	SDIO function. The address is NOT increased for each byte. Return
+ *	value indicates if the transfer succeeded or not.
+ *
+ *	The block size needs to be explicitly changed by calling
+ *	sdio_set_block_size().
+ *
+ *	Note: This is a low level function that should only be used as a
+ *	workaround when the hardware has a crappy register abstraction
+ *	that relies on specific SDIO operations.
+ */
+int sdio_write_blocks_noincr(struct sdio_func *func, unsigned int addr,
+	void *src, int blocks)
+{
+	if (!func->card->cccr.multi_block)
+		return -EINVAL;
+
+	if (blocks > func->card->host->max_blk_count)
+		return -EINVAL;
+	if (blocks > (func->card->host->max_seg_size / func->cur_blksize))
+		return -EINVAL;
+	if (blocks > 511)
+		return -EINVAL;
+
+	return mmc_io_rw_extended(func->card, 1, func->num, addr, 0,
+			src, blocks, func->cur_blksize);
+}
+EXPORT_SYMBOL_GPL(sdio_write_blocks_noincr);
+
diff -uNr linux-2.6.29-rc7.prestine/drivers/mmc/Module.symvers linux-2.6.29-rc7/drivers/mmc/Module.symvers
--- linux-2.6.29-rc7.prestine/drivers/mmc/Module.symvers	1970-01-01 02:00:00.000000000 +0200
+++ linux-2.6.29-rc7/drivers/mmc/Module.symvers	2009-03-12 12:22:53.000000000 +0200
@@ -0,0 +1,55 @@
+0xc0ce4698	sdhci_suspend_host	drivers/mmc/host/sdhci	EXPORT_SYMBOL_GPL
+0x4531d0d5	mmc_cleanup_queue	drivers/mmc/card/mmc_block	EXPORT_SYMBOL
+0x3ea1f141	sdhci_alloc_host	drivers/mmc/host/sdhci	EXPORT_SYMBOL_GPL
+0xcbafc4f4	mmc_wait_for_req	drivers/mmc/core/mmc_core	EXPORT_SYMBOL
+0x9f9ab527	mmc_add_host	drivers/mmc/core/mmc_core	EXPORT_SYMBOL
+0xaa53d49a	sdio_read_bytes	drivers/mmc/core/mmc_core	EXPORT_SYMBOL_GPL
+0x28c8f1ba	sdhci_add_host	drivers/mmc/host/sdhci	EXPORT_SYMBOL_GPL
+0x7c288b18	sdio_unregister_driver	drivers/mmc/core/mmc_core	EXPORT_SYMBOL_GPL
+0x97734726	sdhci_remove_host	drivers/mmc/host/sdhci	EXPORT_SYMBOL_GPL
+0xfe7a751e	sdio_claim_host	drivers/mmc/core/mmc_core	EXPORT_SYMBOL_GPL
+0x184b82fb	mmc_vddrange_to_ocrmask	drivers/mmc/core/mmc_core	EXPORT_SYMBOL
+0x5ba8d484	sdio_f0_writeb	drivers/mmc/core/mmc_core	EXPORT_SYMBOL_GPL
+0x69d099e7	mmc_release_host	drivers/mmc/core/mmc_core	EXPORT_SYMBOL
+0xb83440a4	sdhci_free_host	drivers/mmc/host/sdhci	EXPORT_SYMBOL_GPL
+0x90888d71	sdio_release_irq	drivers/mmc/core/mmc_core	EXPORT_SYMBOL_GPL
+0x18bdeb0f	mmc_wait_for_cmd	drivers/mmc/core/mmc_core	EXPORT_SYMBOL
+0x5c7e0b62	mmc_register_driver	drivers/mmc/core/mmc_core	EXPORT_SYMBOL
+0x526dca1e	sdio_write_bytes_noincr	drivers/mmc/core/mmc_core	EXPORT_SYMBOL_GPL
+0xab6d6203	sdio_read_blocks_noincr	drivers/mmc/core/mmc_core	EXPORT_SYMBOL_GPL
+0x729dbbc4	mmc_request_done	drivers/mmc/core/mmc_core	EXPORT_SYMBOL
+0xa0fe6cc1	sdio_writew	drivers/mmc/core/mmc_core	EXPORT_SYMBOL_GPL
+0x4e3aef85	sdio_register_driver	drivers/mmc/core/mmc_core	EXPORT_SYMBOL_GPL
+0xeb0e9c58	sdhci_resume_host	drivers/mmc/host/sdhci	EXPORT_SYMBOL_GPL
+0xf45a94f7	sdio_write_bytes	drivers/mmc/core/mmc_core	EXPORT_SYMBOL_GPL
+0xc046bd90	sdio_read_blocks	drivers/mmc/core/mmc_core	EXPORT_SYMBOL_GPL
+0x8146b5a4	sdio_writesb	drivers/mmc/core/mmc_core	EXPORT_SYMBOL_GPL
+0x767ceee5	sdio_claim_irq	drivers/mmc/core/mmc_core	EXPORT_SYMBOL_GPL
+0xcf115857	sdio_writeb	drivers/mmc/core/mmc_core	EXPORT_SYMBOL_GPL
+0xc44f1300	sdio_readsb	drivers/mmc/core/mmc_core	EXPORT_SYMBOL_GPL
+0x2e8232bb	mmc_detect_change	drivers/mmc/core/mmc_core	EXPORT_SYMBOL
+0x7fe0ecd3	sdio_readb	drivers/mmc/core/mmc_core	EXPORT_SYMBOL_GPL
+0xa2905df5	sdio_readw	drivers/mmc/core/mmc_core	EXPORT_SYMBOL_GPL
+0x2c5566fc	sdio_readl	drivers/mmc/core/mmc_core	EXPORT_SYMBOL_GPL
+0x678efb7f	mmc_wait_for_app_cmd	drivers/mmc/core/mmc_core	EXPORT_SYMBOL
+0x610e2914	mmc_free_host	drivers/mmc/core/mmc_core	EXPORT_SYMBOL
+0xc2f4fcf4	mmc_remove_host	drivers/mmc/core/mmc_core	EXPORT_SYMBOL
+0x0ddfdcef	mmc_set_data_timeout	drivers/mmc/core/mmc_core	EXPORT_SYMBOL
+0x0b87a075	sdio_writel	drivers/mmc/core/mmc_core	EXPORT_SYMBOL_GPL
+0xd2b0cfe7	sdio_memcpy_toio	drivers/mmc/core/mmc_core	EXPORT_SYMBOL_GPL
+0xbad0cc0f	sdio_set_block_size	drivers/mmc/core/mmc_core	EXPORT_SYMBOL_GPL
+0xcb828fbe	sdio_write_blocks_noincr	drivers/mmc/core/mmc_core	EXPORT_SYMBOL_GPL
+0xdc7d6c4a	sdio_read_bytes_noincr	drivers/mmc/core/mmc_core	EXPORT_SYMBOL_GPL
+0x60c50804	sdio_f0_readb	drivers/mmc/core/mmc_core	EXPORT_SYMBOL_GPL
+0x0d0a7dbd	__mmc_claim_host	drivers/mmc/core/mmc_core	EXPORT_SYMBOL
+0x1193ec99	mmc_unregister_driver	drivers/mmc/core/mmc_core	EXPORT_SYMBOL
+0x5015d587	mmc_resume_host	drivers/mmc/core/mmc_core	EXPORT_SYMBOL
+0x50bc625c	mmc_alloc_host	drivers/mmc/core/mmc_core	EXPORT_SYMBOL
+0xb909aa80	sdio_align_size	drivers/mmc/core/mmc_core	EXPORT_SYMBOL_GPL
+0x0a7c2552	sdio_enable_func	drivers/mmc/core/mmc_core	EXPORT_SYMBOL_GPL
+0x030ef47a	sdio_disable_func	drivers/mmc/core/mmc_core	EXPORT_SYMBOL_GPL
+0xe036df12	sdio_memcpy_fromio	drivers/mmc/core/mmc_core	EXPORT_SYMBOL_GPL
+0xf8c6144f	mmc_suspend_host	drivers/mmc/core/mmc_core	EXPORT_SYMBOL
+0x8d1fd8a9	sdio_release_host	drivers/mmc/core/mmc_core	EXPORT_SYMBOL_GPL
+0x6cfa4491	mmc_align_data_size	drivers/mmc/core/mmc_core	EXPORT_SYMBOL
+0xff7cc1c3	sdio_write_blocks	drivers/mmc/core/mmc_core	EXPORT_SYMBOL_GPL
diff -uNr linux-2.6.29-rc7.prestine/drivers/mmc/.tmp_versions/mmc_block.mod linux-2.6.29-rc7/drivers/mmc/.tmp_versions/mmc_block.mod
--- linux-2.6.29-rc7.prestine/drivers/mmc/.tmp_versions/mmc_block.mod	1970-01-01 02:00:00.000000000 +0200
+++ linux-2.6.29-rc7/drivers/mmc/.tmp_versions/mmc_block.mod	2009-03-12 12:22:45.000000000 +0200
@@ -0,0 +1,2 @@
+drivers/mmc/card/mmc_block.ko
+drivers/mmc/card/block.o drivers/mmc/card/queue.o
diff -uNr linux-2.6.29-rc7.prestine/drivers/mmc/.tmp_versions/mmc_core.mod linux-2.6.29-rc7/drivers/mmc/.tmp_versions/mmc_core.mod
--- linux-2.6.29-rc7.prestine/drivers/mmc/.tmp_versions/mmc_core.mod	1970-01-01 02:00:00.000000000 +0200
+++ linux-2.6.29-rc7/drivers/mmc/.tmp_versions/mmc_core.mod	2009-03-12 12:22:48.000000000 +0200
@@ -0,0 +1,2 @@
+drivers/mmc/core/mmc_core.ko
+drivers/mmc/core/core.o drivers/mmc/core/bus.o drivers/mmc/core/host.o drivers/mmc/core/mmc.o drivers/mmc/core/mmc_ops.o drivers/mmc/core/sd.o drivers/mmc/core/sd_ops.o drivers/mmc/core/sdio.o drivers/mmc/core/sdio_ops.o drivers/mmc/core/sdio_bus.o drivers/mmc/core/sdio_cis.o drivers/mmc/core/sdio_io.o drivers/mmc/core/sdio_irq.o drivers/mmc/core/debugfs.o
diff -uNr linux-2.6.29-rc7.prestine/drivers/mmc/.tmp_versions/sdhci.mod linux-2.6.29-rc7/drivers/mmc/.tmp_versions/sdhci.mod
--- linux-2.6.29-rc7.prestine/drivers/mmc/.tmp_versions/sdhci.mod	1970-01-01 02:00:00.000000000 +0200
+++ linux-2.6.29-rc7/drivers/mmc/.tmp_versions/sdhci.mod	2009-03-12 12:22:50.000000000 +0200
@@ -0,0 +1,2 @@
+drivers/mmc/host/sdhci.ko
+drivers/mmc/host/sdhci.o
diff -uNr linux-2.6.29-rc7.prestine/drivers/mmc/.tmp_versions/sdio_uart.mod linux-2.6.29-rc7/drivers/mmc/.tmp_versions/sdio_uart.mod
--- linux-2.6.29-rc7.prestine/drivers/mmc/.tmp_versions/sdio_uart.mod	1970-01-01 02:00:00.000000000 +0200
+++ linux-2.6.29-rc7/drivers/mmc/.tmp_versions/sdio_uart.mod	2009-03-12 12:22:45.000000000 +0200
@@ -0,0 +1,2 @@
+drivers/mmc/card/sdio_uart.ko
+drivers/mmc/card/sdio_uart.o
diff -uNr linux-2.6.29-rc7.prestine/drivers/mmc/.tmp_versions/tifm_sd.mod linux-2.6.29-rc7/drivers/mmc/.tmp_versions/tifm_sd.mod
--- linux-2.6.29-rc7.prestine/drivers/mmc/.tmp_versions/tifm_sd.mod	1970-01-01 02:00:00.000000000 +0200
+++ linux-2.6.29-rc7/drivers/mmc/.tmp_versions/tifm_sd.mod	2009-03-12 12:22:53.000000000 +0200
@@ -0,0 +1,2 @@
+drivers/mmc/host/tifm_sd.ko
+drivers/mmc/host/tifm_sd.o
diff -uNr linux-2.6.29-rc7.prestine/drivers/mmc/.tmp_versions/wbsd.mod linux-2.6.29-rc7/drivers/mmc/.tmp_versions/wbsd.mod
--- linux-2.6.29-rc7.prestine/drivers/mmc/.tmp_versions/wbsd.mod	1970-01-01 02:00:00.000000000 +0200
+++ linux-2.6.29-rc7/drivers/mmc/.tmp_versions/wbsd.mod	2009-03-12 12:22:52.000000000 +0200
@@ -0,0 +1,2 @@
+drivers/mmc/host/wbsd.ko
+drivers/mmc/host/wbsd.o
diff -uNr linux-2.6.29-rc7.prestine/include/linux/mmc/sdio_func.h linux-2.6.29-rc7/include/linux/mmc/sdio_func.h
--- linux-2.6.29-rc7.prestine/include/linux/mmc/sdio_func.h	2009-03-04 03:05:22.000000000 +0200
+++ linux-2.6.29-rc7/include/linux/mmc/sdio_func.h	2009-03-12 11:51:55.000000000 +0200
@@ -150,5 +150,31 @@
 extern void sdio_f0_writeb(struct sdio_func *func, unsigned char b,
 	unsigned int addr, int *err_ret);
 
+/*
+ * Low-level I/O functions for hardware that doesn't properly abstract
+ * the register space. Don't use these unless you absolutely have to.
+ */
+
+extern int sdio_read_bytes(struct sdio_func *func, void *dst,
+	unsigned int addr, int bytes);
+extern int sdio_read_bytes_noincr(struct sdio_func *func, void *dst,
+	unsigned int addr, int bytes);
+
+extern int sdio_read_blocks(struct sdio_func *func, void *dst,
+	unsigned int addr, int blocks);
+extern int sdio_read_blocks_noincr(struct sdio_func *func, void *dst,
+	unsigned int addr, int blocks);
+
+extern int sdio_write_bytes(struct sdio_func *func, unsigned int addr,
+	 void *src, int bytes);
+extern int sdio_write_bytes_noincr(struct sdio_func *func, unsigned int addr,
+	void *src, int bytes);
+
+extern int sdio_write_blocks(struct sdio_func *func, unsigned int addr,
+	void *src, int blocks);
+extern int sdio_write_blocks_noincr(struct sdio_func *func, unsigned int addr,
+	void *src, int blocks);
+
+
 #endif
 
diff -uNr linux-2.6.29-rc7.prestine/include/linux/mmc/sdio_ids.h linux-2.6.29-rc7/include/linux/mmc/sdio_ids.h
--- linux-2.6.29-rc7.prestine/include/linux/mmc/sdio_ids.h	2009-03-04 03:05:22.000000000 +0200
+++ linux-2.6.29-rc7/include/linux/mmc/sdio_ids.h	2009-03-12 12:24:14.000000000 +0200
@@ -24,6 +24,14 @@
  */
 
 #define SDIO_VENDOR_ID_MARVELL			0x02df
+#define SDIO_VENDOR_ID_SIANO			0x039a
+
 #define SDIO_DEVICE_ID_MARVELL_LIBERTAS		0x9103
+#define SDIO_DEVICE_ID_SIANO_STELLAR 		0x5347
+#define SDIO_DEVICE_ID_SIANO_NOVA_A0		0x1100
+#define SDIO_DEVICE_ID_SIANO_NOVA_B0		0x0201
+#define SDIO_DEVICE_ID_SIANO_NICE		0x0202
+#define SDIO_DEVICE_ID_SIANO_VEGA_A0		0x0300
+#define SDIO_DEVICE_ID_SIANO_VENICE		0x0301
 
 #endif



      
