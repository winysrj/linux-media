Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110802.mail.gq1.yahoo.com ([67.195.13.225]:22822 "HELO
	web110802.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753055AbZCNNes convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Mar 2009 09:34:48 -0400
Message-ID: <584379.19635.qm@web110802.mail.gq1.yahoo.com>
Date: Sat, 14 Mar 2009 06:34:44 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: Re: Fw: [PATCH 1/1 re-submit 1] sdio: add low level i/o functions for workarounds
To: Pierre Ossman <drzeus@drzeus.cx>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Uri Shkolnik <uris@siano-ms.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi Mauro and Pierre,


The second patch, which add devices IDs to the SDIO' header file (include/linux/mmc/sdio_ids.h), is also external to the "Media" kernel sub-tree and falls under the domain of MMC.


Pierre - I hope that at last, after so long time, those patches will be committed, and again, thank you very much for your help :-)


Regards,

Uri

------------------------------------------------------------------------

sdio: add cards id for sms (Siano Mobile Silicon) MDTV receivers

From: Uri Shkolnik <uris@siano-ms.com>

Add SDIO vendor ID, and multiple device IDs for
various SMS-based MDTV SDIO adapters.

The patch has been done against 2.6.29-rc7 .

Signed-off-by: Uri Shkolnik <uris@siano-ms.com>


diff -uNr linux-2.6.29-rc7.prestine/include/linux/mmc/sdio_ids.h linux-2.6.29-rc7_sdio_patch/include/linux/mmc/sdio_ids.h
--- linux-2.6.29-rc7.prestine/include/linux/mmc/sdio_ids.h    2009-03-04 03:05:22.000000000 +0200
+++ linux-2.6.29-rc7_sdio_patch/include/linux/mmc/sdio_ids.h    2009-03-12 12:24:14.000000000 +0200
@@ -24,6 +24,14 @@
  */

#define SDIO_VENDOR_ID_MARVELL            0x02df
+#define SDIO_VENDOR_ID_SIANO            0x039a
+
#define SDIO_DEVICE_ID_MARVELL_LIBERTAS        0x9103
+#define SDIO_DEVICE_ID_SIANO_STELLAR         0x5347
+#define SDIO_DEVICE_ID_SIANO_NOVA_A0        0x1100
+#define SDIO_DEVICE_ID_SIANO_NOVA_B0        0x0201
+#define SDIO_DEVICE_ID_SIANO_NICE        0x0202
+#define SDIO_DEVICE_ID_SIANO_VEGA_A0        0x0300
+#define SDIO_DEVICE_ID_SIANO_VENICE        0x0301

#endif




--- On Sat, 3/14/09, Mauro Carvalho Chehab <mchehab@infradead.org> wrote:

> From: Mauro Carvalho Chehab <mchehab@infradead.org>
> Subject: Fw: [PATCH 1/1 re-submit 1] sdio: add low level i/o functions for workarounds
> To: "Pierre Ossman" <drzeus@drzeus.cx>
> Cc: "Uri Shkolnik" <uris@siano-ms.com>, "Linux Media Mailing List" <linux-media@vger.kernel.org>
> Date: Saturday, March 14, 2009, 12:42 PM
> Hi Pierre,
> 
> Uri sent me this patchset, as part of the changes for
> supporting some devices
> from Siano.
> 
> The changeset looks fine, although I have no experiences
> with MMC. Are you
> applying it on your tree, or do you prefer if I apply
> here?
> 
> If you're applying on yours, this is my ack:
> Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> Cheers,
> Mauro.
> 
> 
> Forwarded message:
> 
> Date: Thu, 12 Mar 2009 06:01:26 -0700 (PDT)
> From: Uri Shkolnik <urishk@yahoo.com>
> To: Mauro Carvalho Chehab <mchehab@infradead.org>
> Cc: Michael Krufky <mkrufky@linuxtv.org>,
> linux-media@vger.kernel.org
> Subject: [PATCH 1/1 re-submit 1] sdio: add low level i/o
> functions for workarounds
> 
> 
> 
> sdio: add low level i/o functions for workarounds
> 
> From: Pierre Ossman <drzeus@drzeus.cx>
> 
> Some shoddy hardware doesn't properly adhere to the
> register model
> of SDIO, but treats the system like a series of
> transaction. That means
> that the drivers must have full control over what goes the
> bus (and the
> core cannot optimize transactions or work around problems
> in host
> controllers).
> This commit adds some low level functions that gives SDIO
> drivers the
> ability to send specific register access commands. They
> should only be
> used when the hardware is truly broken though.
> 
> The patch has been done against 2.6.29-rc7 .
> 
> Signed-off-by: Pierre Ossman <drzeus@drzeus.cx>
> Signed-off-by: Uri Shkolnik <uris@siano-ms.com>
> 
> 
> diff -uNr
> linux-2.6.29-rc7.prestine/drivers/mmc/core/sdio_io.c
> linux-2.6.29-rc7_sdio_patch/drivers/mmc/core/sdio_io.c
> ---
> linux-2.6.29-rc7.prestine/drivers/mmc/core/sdio_io.c���
> 2009-03-04 03:05:22.000000000 +0200
> +++
> linux-2.6.29-rc7_sdio_patch/drivers/mmc/core/sdio_io.c���
> 2009-03-12 12:22:42.000000000 +0200
> @@ -635,3 +635,252 @@
>  ��� ��� *err_ret = ret;
>  }
>  EXPORT_SYMBOL_GPL(sdio_f0_writeb);
> +
> +/**
> + *��� sdio_read_bytes - low level byte mode
> transfer from an SDIO function
> + *��� @func: SDIO function to access
> + *��� @dst: buffer to store the data
> + *��� @addr: address to begin reading from
> + *��� @bytes: number of bytes to read
> + *
> + *��� Performs a byte mode transfer from
> the address space of the given
> + *��� SDIO function. The address is
> increased for each byte. Return
> + *��� value indicates if the transfer
> succeeded or not.
> + *
> + *��� Note: This is a low level function
> that should only be used as a
> + *��� workaround when the hardware has a
> crappy register abstraction
> + *��� that relies on specific SDIO
> operations.
> + */
> +int sdio_read_bytes(struct sdio_func *func, void *dst,
> +��� unsigned int addr, int bytes)
> +{
> +��� if (bytes >
> sdio_max_byte_size(func))
> +��� ��� return -EINVAL;
> +
> +��� return
> mmc_io_rw_extended(func->card, 0, func->num, addr, 1,
> +��� ��� ���
> dst, 1, bytes);
> +}
> +EXPORT_SYMBOL_GPL(sdio_read_bytes);
> +
> +/**
> + *��� sdio_read_bytes_noincr - low level
> byte mode transfer from an SDIO function
> + *��� @func: SDIO function to access
> + *��� @dst: buffer to store the data
> + *��� @addr: address to begin reading from
> + *��� @bytes: number of bytes to read
> + *
> + *��� Performs a byte mode transfer from
> the address space of the given
> + *��� SDIO function. The address is NOT
> increased for each byte. Return
> + *��� value indicates if the transfer
> succeeded or not.
> + *
> + *��� Note: This is a low level function
> that should only be used as a
> + *��� workaround when the hardware has a
> crappy register abstraction
> + *��� that relies on specific SDIO
> operations.
> + */
> +int sdio_read_bytes_noincr(struct sdio_func *func, void
> *dst,
> +��� unsigned int addr, int bytes)
> +{
> +��� if (bytes >
> sdio_max_byte_size(func))
> +��� ��� return -EINVAL;
> +
> +��� return
> mmc_io_rw_extended(func->card, 0, func->num, addr, 0,
> +��� ��� ���
> dst, 1, bytes);
> +}
> +EXPORT_SYMBOL_GPL(sdio_read_bytes_noincr);
> +
> +/**
> + *��� sdio_read_blocks - low level block
> mode transfer from an SDIO function
> + *��� @func: SDIO function to access
> + *��� @dst: buffer to store the data
> + *��� @addr: address to begin reading from
> + *��� @block: number of blocks to read
> + *
> + *��� Performs a block mode transfer from
> the address space of the given
> + *��� SDIO function. The address is
> increased for each byte. Return
> + *��� value indicates if the transfer
> succeeded or not.
> + *
> + *��� The block size needs to be explicitly
> changed by calling
> + *��� sdio_set_block_size().
> + *
> + *��� Note: This is a low level function
> that should only be used as a
> + *��� workaround when the hardware has a
> crappy register abstraction
> + *��� that relies on specific SDIO
> operations.
> + */
> +int sdio_read_blocks(struct sdio_func *func, void *dst,
> +��� unsigned int addr, int blocks)
> +{
> +��� if
> (!func->card->cccr.multi_block)
> +��� ��� return -EINVAL;
> +
> +��� if (blocks >
> func->card->host->max_blk_count)
> +��� ��� return -EINVAL;
> +��� if (blocks >
> (func->card->host->max_seg_size /
> func->cur_blksize))
> +��� ��� return -EINVAL;
> +��� if (blocks > 511)
> +��� ��� return -EINVAL;
> +
> +��� return
> mmc_io_rw_extended(func->card, 0, func->num, addr, 1,
> +��� ��� ���
> dst, blocks, func->cur_blksize);
> +}
> +EXPORT_SYMBOL_GPL(sdio_read_blocks);
> +
> +/**
> + *��� sdio_read_blocks_noincr - low level
> block mode transfer from an SDIO function
> + *��� @func: SDIO function to access
> + *��� @dst: buffer to store the data
> + *��� @addr: address to begin reading from
> + *��� @block: number of blocks to read
> + *
> + *��� Performs a block mode transfer from
> the address space of the given
> + *��� SDIO function. The address is NOT
> increased for each byte. Return
> + *��� value indicates if the transfer
> succeeded or not.
> + *
> + *��� The block size needs to be explicitly
> changed by calling
> + *��� sdio_set_block_size().
> + *
> + *��� Note: This is a low level function
> that should only be used as a
> + *��� workaround when the hardware has a
> crappy register abstraction
> + *��� that relies on specific SDIO
> operations.
> + */
> +int sdio_read_blocks_noincr(struct sdio_func *func, void
> *dst,
> +��� unsigned int addr, int blocks)
> +{
> +��� if
> (!func->card->cccr.multi_block)
> +��� ��� return -EINVAL;
> +
> +��� if (blocks >
> func->card->host->max_blk_count)
> +��� ��� return -EINVAL;
> +��� if (blocks >
> (func->card->host->max_seg_size /
> func->cur_blksize))
> +��� ��� return -EINVAL;
> +��� if (blocks > 511)
> +��� ��� return -EINVAL;
> +
> +��� return
> mmc_io_rw_extended(func->card, 0, func->num, addr, 0,
> +��� ��� ���
> dst, blocks, func->cur_blksize);
> +}
> +EXPORT_SYMBOL_GPL(sdio_read_blocks_noincr);
> +
> +/**
> + *��� sdio_write_bytes - low level byte
> mode transfer to an SDIO function
> + *��� @func: SDIO function to access
> + *��� @addr: address to start writing to
> + *��� @src: buffer that contains the data
> to write
> + *��� @bytes: number of bytes to write
> + *
> + *��� Performs a byte mode transfer to the
> address space of the given
> + *��� SDIO function. The address is
> increased for each byte. Return
> + *��� value indicates if the transfer
> succeeded or not.
> + *
> + *��� Note: This is a low level function
> that should only be used as a
> + *��� workaround when the hardware has a
> crappy register abstraction
> + *��� that relies on specific SDIO
> operations.
> + */
> +int sdio_write_bytes(struct sdio_func *func, unsigned int
> addr,
> +�����void *src, int bytes)
> +{
> +��� if (bytes >
> sdio_max_byte_size(func))
> +��� ��� return -EINVAL;
> +
> +��� return
> mmc_io_rw_extended(func->card, 1, func->num, addr, 1,
> +��� ��� ���
> src, 1, bytes);
> +}
> +EXPORT_SYMBOL_GPL(sdio_write_bytes);
> +
> +/**
> + *��� sdio_write_bytes_noincr - low level
> byte mode transfer to an SDIO function
> + *��� @func: SDIO function to access
> + *��� @addr: address to start writing to
> + *��� @src: buffer that contains the data
> to write
> + *��� @bytes: number of bytes to write
> + *
> + *��� Performs a byte mode transfer to the
> address space of the given
> + *��� SDIO function. The address is NOT
> increased for each byte. Return
> + *��� value indicates if the transfer
> succeeded or not.
> + *
> + *��� Note: This is a low level function
> that should only be used as a
> + *��� workaround when the hardware has a
> crappy register abstraction
> + *��� that relies on specific SDIO
> operations.
> + */
> +int sdio_write_bytes_noincr(struct sdio_func *func,
> unsigned int addr,
> +��� void *src, int bytes)
> +{
> +��� if (bytes >
> sdio_max_byte_size(func))
> +��� ��� return -EINVAL;
> +
> +��� return
> mmc_io_rw_extended(func->card, 1, func->num, addr, 0,
> +��� ��� ���
> src, 1, bytes);
> +}
> +EXPORT_SYMBOL_GPL(sdio_write_bytes_noincr);
> +
> +/**
> + *��� sdio_read_blocks - low level block
> mode transfer to an SDIO function
> + *��� @func: SDIO function to access
> + *��� @addr: address to start writing to
> + *��� @src: buffer that contains the data
> to write
> + *��� @block: number of blocks to write
> + *
> + *��� Performs a block mode transfer to the
> address space of the given
> + *��� SDIO function. The address is
> increased for each byte. Return
> + *��� value indicates if the transfer
> succeeded or not.
> + *
> + *��� The block size needs to be explicitly
> changed by calling
> + *��� sdio_set_block_size().
> + *
> + *��� Note: This is a low level function
> that should only be used as a
> + *��� workaround when the hardware has a
> crappy register abstraction
> + *��� that relies on specific SDIO
> operations.
> + */
> +int sdio_write_blocks(struct sdio_func *func, unsigned int
> addr,
> +��� void *src, int blocks)
> +{
> +��� if
> (!func->card->cccr.multi_block)
> +��� ��� return -EINVAL;
> +
> +��� if (blocks >
> func->card->host->max_blk_count)
> +��� ��� return -EINVAL;
> +��� if (blocks >
> (func->card->host->max_seg_size /
> func->cur_blksize))
> +��� ��� return -EINVAL;
> +��� if (blocks > 511)
> +��� ��� return -EINVAL;
> +
> +��� return
> mmc_io_rw_extended(func->card, 1, func->num, addr, 1,
> +��� ��� ���
> src, blocks, func->cur_blksize);
> +}
> +EXPORT_SYMBOL_GPL(sdio_write_blocks);
> +
> +/**
> + *��� sdio_read_blocks_noincr - low level
> block mode transfer to an SDIO function
> + *��� @func: SDIO function to access
> + *��� @addr: address to start writing to
> + *��� @src: buffer that contains the data
> to write
> + *��� @block: number of blocks to write
> + *
> + *��� Performs a block mode transfer to the
> address space of the given
> + *��� SDIO function. The address is NOT
> increased for each byte. Return
> + *��� value indicates if the transfer
> succeeded or not.
> + *
> + *��� The block size needs to be explicitly
> changed by calling
> + *��� sdio_set_block_size().
> + *
> + *��� Note: This is a low level function
> that should only be used as a
> + *��� workaround when the hardware has a
> crappy register abstraction
> + *��� that relies on specific SDIO
> operations.
> + */
> +int sdio_write_blocks_noincr(struct sdio_func *func,
> unsigned int addr,
> +��� void *src, int blocks)
> +{
> +��� if
> (!func->card->cccr.multi_block)
> +��� ��� return -EINVAL;
> +
> +��� if (blocks >
> func->card->host->max_blk_count)
> +��� ��� return -EINVAL;
> +��� if (blocks >
> (func->card->host->max_seg_size /
> func->cur_blksize))
> +��� ��� return -EINVAL;
> +��� if (blocks > 511)
> +��� ��� return -EINVAL;
> +
> +��� return
> mmc_io_rw_extended(func->card, 1, func->num, addr, 0,
> +��� ��� ���
> src, blocks, func->cur_blksize);
> +}
> +EXPORT_SYMBOL_GPL(sdio_write_blocks_noincr);
> +
> diff -uNr
> linux-2.6.29-rc7.prestine/include/linux/mmc/sdio_func.h
> linux-2.6.29-rc7_sdio_patch/include/linux/mmc/sdio_func.h
> ---
> linux-2.6.29-rc7.prestine/include/linux/mmc/sdio_func.h���
> 2009-03-04 03:05:22.000000000 +0200
> +++
> linux-2.6.29-rc7_sdio_patch/include/linux/mmc/sdio_func.h���
> 2009-03-12 11:51:55.000000000 +0200
> @@ -150,5 +150,31 @@
>  extern void sdio_f0_writeb(struct sdio_func *func,
> unsigned char b,
>  ��� unsigned int addr, int *err_ret);
>  
> +/*
> + * Low-level I/O functions for hardware that doesn't
> properly abstract
> + * the register space. Don't use these unless you
> absolutely have to.
> + */
> +
> +extern int sdio_read_bytes(struct sdio_func *func, void
> *dst,
> +��� unsigned int addr, int bytes);
> +extern int sdio_read_bytes_noincr(struct sdio_func *func,
> void *dst,
> +��� unsigned int addr, int bytes);
> +
> +extern int sdio_read_blocks(struct sdio_func *func, void
> *dst,
> +��� unsigned int addr, int blocks);
> +extern int sdio_read_blocks_noincr(struct sdio_func *func,
> void *dst,
> +��� unsigned int addr, int blocks);
> +
> +extern int sdio_write_bytes(struct sdio_func *func,
> unsigned int addr,
> +�����void *src, int bytes);
> +extern int sdio_write_bytes_noincr(struct sdio_func *func,
> unsigned int addr,
> +��� void *src, int bytes);
> +
> +extern int sdio_write_blocks(struct sdio_func *func,
> unsigned int addr,
> +��� void *src, int blocks);
> +extern int sdio_write_blocks_noincr(struct sdio_func
> *func, unsigned int addr,
> +��� void *src, int blocks);
> +
> +
>  #endif
> 
> 
> 
> � � � 
> 
> 
> 
> 
> Cheers,
> Mauro
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at� http://vger.kernel.org/majordomo-info.html
> 


      
