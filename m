Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110808.mail.gq1.yahoo.com ([67.195.13.231]:35484 "HELO
	web110808.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752114AbZCLNB3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Mar 2009 09:01:29 -0400
Message-ID: <662082.75656.qm@web110808.mail.gq1.yahoo.com>
Date: Thu, 12 Mar 2009 06:01:26 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: [PATCH 1/1 re-submit 1] sdio: add low level i/o functions for workarounds
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

The patch has been done against 2.6.29-rc7 .

Signed-off-by: Pierre Ossman <drzeus@drzeus.cx>
Signed-off-by: Uri Shkolnik <uris@siano-ms.com>


diff -uNr linux-2.6.29-rc7.prestine/drivers/mmc/core/sdio_io.c linux-2.6.29-rc7_sdio_patch/drivers/mmc/core/sdio_io.c
--- linux-2.6.29-rc7.prestine/drivers/mmc/core/sdio_io.c	2009-03-04 03:05:22.000000000 +0200
+++ linux-2.6.29-rc7_sdio_patch/drivers/mmc/core/sdio_io.c	2009-03-12 12:22:42.000000000 +0200
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
diff -uNr linux-2.6.29-rc7.prestine/include/linux/mmc/sdio_func.h linux-2.6.29-rc7_sdio_patch/include/linux/mmc/sdio_func.h
--- linux-2.6.29-rc7.prestine/include/linux/mmc/sdio_func.h	2009-03-04 03:05:22.000000000 +0200
+++ linux-2.6.29-rc7_sdio_patch/include/linux/mmc/sdio_func.h	2009-03-12 11:51:55.000000000 +0200
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



      
