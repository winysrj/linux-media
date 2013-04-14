Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2808 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209Ab3DNP15 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Apr 2013 11:27:57 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Sri Deevi <Srinivasa.Deevi@conexant.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 29/30] cx25821: drop cx25821-video-upstream-ch2.c/h.
Date: Sun, 14 Apr 2013 17:27:25 +0200
Message-Id: <1365953246-8972-30-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1365953246-8972-1-git-send-email-hverkuil@xs4all.nl>
References: <1365953246-8972-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

cx25821-video-upstream_ch2.c/h is practically identical to cx25821-video-upstream.c/h
so add support for ch2 into cx25821-video-upstream.c instead.

After this we can replace the custom ioctls with a proper write() interface.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx25821/Makefile                 |    1 -
 drivers/media/pci/cx25821/cx25821-core.c           |    4 +-
 .../media/pci/cx25821/cx25821-video-upstream-ch2.c |  800 --------------------
 .../media/pci/cx25821/cx25821-video-upstream-ch2.h |  138 ----
 drivers/media/pci/cx25821/cx25821-video-upstream.c |  349 ++++-----
 drivers/media/pci/cx25821/cx25821-video.c          |   19 +-
 drivers/media/pci/cx25821/cx25821.h                |  127 ++--
 7 files changed, 243 insertions(+), 1195 deletions(-)
 delete mode 100644 drivers/media/pci/cx25821/cx25821-video-upstream-ch2.c
 delete mode 100644 drivers/media/pci/cx25821/cx25821-video-upstream-ch2.h

diff --git a/drivers/media/pci/cx25821/Makefile b/drivers/media/pci/cx25821/Makefile
index b54a32e..407830c 100644
--- a/drivers/media/pci/cx25821/Makefile
+++ b/drivers/media/pci/cx25821/Makefile
@@ -1,7 +1,6 @@
 cx25821-y   := cx25821-core.o cx25821-cards.o cx25821-i2c.o \
 		       cx25821-gpio.o cx25821-medusa-video.o \
 		       cx25821-video.o cx25821-video-upstream.o \
-		       cx25821-video-upstream-ch2.o \
 		       cx25821-audio-upstream.o
 
 obj-$(CONFIG_VIDEO_CX25821) += cx25821.o
diff --git a/drivers/media/pci/cx25821/cx25821-core.c b/drivers/media/pci/cx25821/cx25821-core.c
index 9068d53..230bd86 100644
--- a/drivers/media/pci/cx25821/cx25821-core.c
+++ b/drivers/media/pci/cx25821/cx25821-core.c
@@ -963,8 +963,6 @@ void cx25821_dev_unregister(struct cx25821_dev *dev)
 	if (!dev->base_io_addr)
 		return;
 
-	cx25821_free_mem_upstream_ch1(dev);
-	cx25821_free_mem_upstream_ch2(dev);
 	cx25821_free_mem_upstream_audio(dev);
 
 	release_mem_region(dev->base_io_addr, pci_resource_len(dev->pci, 0));
@@ -972,6 +970,8 @@ void cx25821_dev_unregister(struct cx25821_dev *dev)
 	for (i = 0; i < MAX_VID_CHANNEL_NUM - 1; i++) {
 		if (i == SRAM_CH08) /* audio channel */
 			continue;
+		if (i == SRAM_CH09 || i == SRAM_CH10)
+			cx25821_free_mem_upstream(&dev->channels[i]);
 		cx25821_video_unregister(dev, i);
 	}
 
diff --git a/drivers/media/pci/cx25821/cx25821-video-upstream-ch2.c b/drivers/media/pci/cx25821/cx25821-video-upstream-ch2.c
deleted file mode 100644
index 2381bdc..0000000
--- a/drivers/media/pci/cx25821/cx25821-video-upstream-ch2.c
+++ /dev/null
@@ -1,800 +0,0 @@
-/*
- *  Driver for the Conexant CX25821 PCIe bridge
- *
- *  Copyright (C) 2009 Conexant Systems Inc.
- *  Authors  <hiep.huynh@conexant.com>, <shu.lin@conexant.com>
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation; either version 2 of the License, or
- *  (at your option) any later version.
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *
- *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- */
-
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
-#include "cx25821-video.h"
-#include "cx25821-video-upstream-ch2.h"
-
-#include <linux/fs.h>
-#include <linux/errno.h>
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/syscalls.h>
-#include <linux/file.h>
-#include <linux/fcntl.h>
-#include <linux/slab.h>
-#include <linux/uaccess.h>
-
-MODULE_DESCRIPTION("v4l2 driver module for cx25821 based TV cards");
-MODULE_AUTHOR("Hiep Huynh <hiep.huynh@conexant.com>");
-MODULE_LICENSE("GPL");
-
-static int _intr_msk = FLD_VID_SRC_RISC1 | FLD_VID_SRC_UF | FLD_VID_SRC_SYNC |
-			FLD_VID_SRC_OPC_ERR;
-
-static __le32 *cx25821_update_riscprogram_ch2(struct cx25821_dev *dev,
-					      __le32 *rp, unsigned int offset,
-					      unsigned int bpl, u32 sync_line,
-					      unsigned int lines,
-					      int fifo_enable, int field_type)
-{
-	unsigned int line, i;
-	int dist_betwn_starts = bpl * 2;
-
-	*(rp++) = cpu_to_le32(RISC_RESYNC | sync_line);
-
-	if (USE_RISC_NOOP_VIDEO) {
-		for (i = 0; i < NUM_NO_OPS; i++)
-			*(rp++) = cpu_to_le32(RISC_NOOP);
-	}
-
-	/* scan lines */
-	for (line = 0; line < lines; line++) {
-		*(rp++) = cpu_to_le32(RISC_READ | RISC_SOL | RISC_EOL | bpl);
-		*(rp++) = cpu_to_le32(dev->_data_buf_phys_addr_ch2 + offset);
-		*(rp++) = cpu_to_le32(0);	/* bits 63-32 */
-
-		if ((lines <= NTSC_FIELD_HEIGHT) ||
-		    (line < (NTSC_FIELD_HEIGHT - 1)) || !(dev->_isNTSC_ch2)) {
-			offset += dist_betwn_starts;
-		}
-	}
-
-	return rp;
-}
-
-static __le32 *cx25821_risc_field_upstream_ch2(struct cx25821_dev *dev,
-					       __le32 *rp,
-					       dma_addr_t databuf_phys_addr,
-					       unsigned int offset,
-					       u32 sync_line, unsigned int bpl,
-					       unsigned int lines,
-					       int fifo_enable, int field_type)
-{
-	unsigned int line, i;
-	const struct sram_channel *sram_ch =
-		dev->channels[dev->_channel2_upstream_select].sram_channels;
-	int dist_betwn_starts = bpl * 2;
-
-	/* sync instruction */
-	if (sync_line != NO_SYNC_LINE)
-		*(rp++) = cpu_to_le32(RISC_RESYNC | sync_line);
-
-	if (USE_RISC_NOOP_VIDEO) {
-		for (i = 0; i < NUM_NO_OPS; i++)
-			*(rp++) = cpu_to_le32(RISC_NOOP);
-	}
-
-	/* scan lines */
-	for (line = 0; line < lines; line++) {
-		*(rp++) = cpu_to_le32(RISC_READ | RISC_SOL | RISC_EOL | bpl);
-		*(rp++) = cpu_to_le32(databuf_phys_addr + offset);
-		*(rp++) = cpu_to_le32(0);	/* bits 63-32 */
-
-		if ((lines <= NTSC_FIELD_HEIGHT) ||
-		    (line < (NTSC_FIELD_HEIGHT - 1)) || !(dev->_isNTSC_ch2)) {
-			offset += dist_betwn_starts;
-		}
-
-	       /*
-		 check if we need to enable the FIFO after the first 4 lines
-		  For the upstream video channel, the risc engine will enable
-		  the FIFO.
-	       */
-		if (fifo_enable && line == 3) {
-			*(rp++) = RISC_WRITECR;
-			*(rp++) = sram_ch->dma_ctl;
-			*(rp++) = FLD_VID_FIFO_EN;
-			*(rp++) = 0x00000001;
-		}
-	}
-
-	return rp;
-}
-
-static int cx25821_risc_buffer_upstream_ch2(struct cx25821_dev *dev,
-					    struct pci_dev *pci,
-					    unsigned int top_offset,
-					    unsigned int bpl,
-					    unsigned int lines)
-{
-	__le32 *rp;
-	int fifo_enable = 0;
-	int singlefield_lines = lines >> 1; /*get line count for single field */
-	int odd_num_lines = singlefield_lines;
-	int frame = 0;
-	int frame_size = 0;
-	int databuf_offset = 0;
-	int risc_program_size = 0;
-	int risc_flag = RISC_CNT_RESET;
-	unsigned int bottom_offset = bpl;
-	dma_addr_t risc_phys_jump_addr;
-
-	if (dev->_isNTSC_ch2) {
-		odd_num_lines = singlefield_lines + 1;
-		risc_program_size = FRAME1_VID_PROG_SIZE;
-		if (bpl == Y411_LINE_SZ)
-			frame_size = FRAME_SIZE_NTSC_Y411;
-		else
-			frame_size = FRAME_SIZE_NTSC_Y422;
-	} else {
-		risc_program_size = PAL_VID_PROG_SIZE;
-		if (bpl == Y411_LINE_SZ)
-			frame_size = FRAME_SIZE_PAL_Y411;
-		else
-			frame_size = FRAME_SIZE_PAL_Y422;
-	}
-
-	/* Virtual address of Risc buffer program */
-	rp = dev->_dma_virt_addr_ch2;
-
-	for (frame = 0; frame < NUM_FRAMES; frame++) {
-		databuf_offset = frame_size * frame;
-
-		if (UNSET != top_offset) {
-			fifo_enable = (frame == 0) ? FIFO_ENABLE : FIFO_DISABLE;
-			rp = cx25821_risc_field_upstream_ch2(dev, rp,
-				dev->_data_buf_phys_addr_ch2 + databuf_offset,
-				top_offset, 0, bpl, odd_num_lines, fifo_enable,
-				ODD_FIELD);
-		}
-
-		fifo_enable = FIFO_DISABLE;
-
-		/* Even field */
-		rp = cx25821_risc_field_upstream_ch2(dev, rp,
-				dev->_data_buf_phys_addr_ch2 + databuf_offset,
-				bottom_offset, 0x200, bpl, singlefield_lines,
-				fifo_enable, EVEN_FIELD);
-
-		if (frame == 0) {
-			risc_flag = RISC_CNT_RESET;
-			risc_phys_jump_addr = dev->_dma_phys_start_addr_ch2 +
-					risc_program_size;
-		} else {
-			risc_flag = RISC_CNT_INC;
-			risc_phys_jump_addr = dev->_dma_phys_start_addr_ch2;
-		}
-
-	       /*
-		* Loop to 2ndFrameRISC or to Start of
-		* Risc program & generate IRQ
-		*/
-		*(rp++) = cpu_to_le32(RISC_JUMP | RISC_IRQ1 | risc_flag);
-		*(rp++) = cpu_to_le32(risc_phys_jump_addr);
-		*(rp++) = cpu_to_le32(0);
-	}
-
-	return 0;
-}
-
-void cx25821_stop_upstream_video_ch2(struct cx25821_dev *dev)
-{
-	const struct sram_channel *sram_ch =
-		dev->channels[VID_UPSTREAM_SRAM_CHANNEL_J].sram_channels;
-	u32 tmp = 0;
-
-	if (!dev->_is_running_ch2) {
-		pr_info("No video file is currently running so return!\n");
-		return;
-	}
-	/* Disable RISC interrupts */
-	tmp = cx_read(sram_ch->int_msk);
-	cx_write(sram_ch->int_msk, tmp & ~_intr_msk);
-
-	/* Turn OFF risc and fifo */
-	tmp = cx_read(sram_ch->dma_ctl);
-	cx_write(sram_ch->dma_ctl, tmp & ~(FLD_VID_FIFO_EN | FLD_VID_RISC_EN));
-
-	/* Clear data buffer memory */
-	if (dev->_data_buf_virt_addr_ch2)
-		memset(dev->_data_buf_virt_addr_ch2, 0,
-		       dev->_data_buf_size_ch2);
-
-	dev->_is_running_ch2 = 0;
-	dev->_is_first_frame_ch2 = 0;
-	dev->_frame_count_ch2 = 0;
-	dev->_file_status_ch2 = END_OF_FILE;
-
-	kfree(dev->_irq_queues_ch2);
-	dev->_irq_queues_ch2 = NULL;
-
-	kfree(dev->_filename_ch2);
-
-	tmp = cx_read(VID_CH_MODE_SEL);
-	cx_write(VID_CH_MODE_SEL, tmp & 0xFFFFFE00);
-}
-
-void cx25821_free_mem_upstream_ch2(struct cx25821_dev *dev)
-{
-	if (dev->_is_running_ch2)
-		cx25821_stop_upstream_video_ch2(dev);
-
-	if (dev->_dma_virt_addr_ch2) {
-		pci_free_consistent(dev->pci, dev->_risc_size_ch2,
-				    dev->_dma_virt_addr_ch2,
-				    dev->_dma_phys_addr_ch2);
-		dev->_dma_virt_addr_ch2 = NULL;
-	}
-
-	if (dev->_data_buf_virt_addr_ch2) {
-		pci_free_consistent(dev->pci, dev->_data_buf_size_ch2,
-				    dev->_data_buf_virt_addr_ch2,
-				    dev->_data_buf_phys_addr_ch2);
-		dev->_data_buf_virt_addr_ch2 = NULL;
-	}
-}
-
-static int cx25821_get_frame_ch2(struct cx25821_dev *dev,
-				 const struct sram_channel *sram_ch)
-{
-	struct file *myfile;
-	int frame_index_temp = dev->_frame_index_ch2;
-	int i = 0;
-	int line_size = (dev->_pixel_format_ch2 == PIXEL_FRMT_411) ?
-		Y411_LINE_SZ : Y422_LINE_SZ;
-	int frame_size = 0;
-	int frame_offset = 0;
-	ssize_t vfs_read_retval = 0;
-	char mybuf[line_size];
-	loff_t file_offset;
-	loff_t pos;
-	mm_segment_t old_fs;
-
-	if (dev->_file_status_ch2 == END_OF_FILE)
-		return 0;
-
-	if (dev->_isNTSC_ch2) {
-		frame_size = (line_size == Y411_LINE_SZ) ?
-			FRAME_SIZE_NTSC_Y411 : FRAME_SIZE_NTSC_Y422;
-	} else {
-		frame_size = (line_size == Y411_LINE_SZ) ?
-			FRAME_SIZE_PAL_Y411 : FRAME_SIZE_PAL_Y422;
-	}
-
-	frame_offset = (frame_index_temp > 0) ? frame_size : 0;
-	file_offset = dev->_frame_count_ch2 * frame_size;
-
-	myfile = filp_open(dev->_filename_ch2, O_RDONLY | O_LARGEFILE, 0);
-	if (IS_ERR(myfile)) {
-		const int open_errno = -PTR_ERR(myfile);
-		pr_err("%s(): ERROR opening file(%s) with errno = %d!\n",
-		       __func__, dev->_filename_ch2, open_errno);
-		return PTR_ERR(myfile);
-	} else {
-		if (!(myfile->f_op)) {
-			pr_err("%s(): File has no file operations registered!\n",
-			       __func__);
-			filp_close(myfile, NULL);
-			return -EIO;
-		}
-
-		if (!myfile->f_op->read) {
-			pr_err("%s(): File has no READ operations registered!\n",
-			       __func__);
-			filp_close(myfile, NULL);
-			return -EIO;
-		}
-
-		pos = myfile->f_pos;
-		old_fs = get_fs();
-		set_fs(KERNEL_DS);
-
-		for (i = 0; i < dev->_lines_count_ch2; i++) {
-			pos = file_offset;
-
-			vfs_read_retval = vfs_read(myfile, mybuf, line_size,
-					&pos);
-
-			if (vfs_read_retval > 0 && vfs_read_retval == line_size
-			    && dev->_data_buf_virt_addr_ch2 != NULL) {
-				memcpy((void *)(dev->_data_buf_virt_addr_ch2 +
-						frame_offset / 4), mybuf,
-						vfs_read_retval);
-			}
-
-			file_offset += vfs_read_retval;
-			frame_offset += vfs_read_retval;
-
-			if (vfs_read_retval < line_size) {
-				pr_info("Done: exit %s() since no more bytes to read from Video file\n",
-					__func__);
-				break;
-			}
-		}
-
-		if (i > 0)
-			dev->_frame_count_ch2++;
-
-		dev->_file_status_ch2 = (vfs_read_retval == line_size) ?
-			IN_PROGRESS : END_OF_FILE;
-
-		set_fs(old_fs);
-		filp_close(myfile, NULL);
-	}
-
-	return 0;
-}
-
-static void cx25821_vidups_handler_ch2(struct work_struct *work)
-{
-	struct cx25821_dev *dev = container_of(work, struct cx25821_dev,
-			_irq_work_entry_ch2);
-
-	if (!dev) {
-		pr_err("ERROR %s(): since container_of(work_struct) FAILED!\n",
-		       __func__);
-		return;
-	}
-
-	cx25821_get_frame_ch2(dev, dev->channels[dev->
-			_channel2_upstream_select].sram_channels);
-}
-
-static int cx25821_openfile_ch2(struct cx25821_dev *dev,
-				const struct sram_channel *sram_ch)
-{
-	struct file *myfile;
-	int i = 0, j = 0;
-	int line_size = (dev->_pixel_format_ch2 == PIXEL_FRMT_411) ?
-		Y411_LINE_SZ : Y422_LINE_SZ;
-	ssize_t vfs_read_retval = 0;
-	char mybuf[line_size];
-	loff_t pos;
-	loff_t offset = (unsigned long)0;
-	mm_segment_t old_fs;
-
-	myfile = filp_open(dev->_filename_ch2, O_RDONLY | O_LARGEFILE, 0);
-
-	if (IS_ERR(myfile)) {
-		const int open_errno = -PTR_ERR(myfile);
-		pr_err("%s(): ERROR opening file(%s) with errno = %d!\n",
-		       __func__, dev->_filename_ch2, open_errno);
-		return PTR_ERR(myfile);
-	} else {
-		if (!(myfile->f_op)) {
-			pr_err("%s(): File has no file operations registered!\n",
-			       __func__);
-			filp_close(myfile, NULL);
-			return -EIO;
-		}
-
-		if (!myfile->f_op->read) {
-			pr_err("%s(): File has no READ operations registered!  Returning\n",
-			       __func__);
-			filp_close(myfile, NULL);
-			return -EIO;
-		}
-
-		pos = myfile->f_pos;
-		old_fs = get_fs();
-		set_fs(KERNEL_DS);
-
-		for (j = 0; j < NUM_FRAMES; j++) {
-			for (i = 0; i < dev->_lines_count_ch2; i++) {
-				pos = offset;
-
-				vfs_read_retval = vfs_read(myfile, mybuf,
-						line_size, &pos);
-
-				if (vfs_read_retval > 0 &&
-				    vfs_read_retval == line_size &&
-				    dev->_data_buf_virt_addr_ch2 != NULL) {
-					memcpy((void *)(dev->
-							_data_buf_virt_addr_ch2
-							+ offset / 4), mybuf,
-							vfs_read_retval);
-				}
-
-				offset += vfs_read_retval;
-
-				if (vfs_read_retval < line_size) {
-					pr_info("Done: exit %s() since no more bytes to read from Video file\n",
-						__func__);
-					break;
-				}
-			}
-
-			if (i > 0)
-				dev->_frame_count_ch2++;
-
-			if (vfs_read_retval < line_size)
-				break;
-		}
-
-		dev->_file_status_ch2 = (vfs_read_retval == line_size) ?
-			IN_PROGRESS : END_OF_FILE;
-
-		set_fs(old_fs);
-		myfile->f_pos = 0;
-		filp_close(myfile, NULL);
-	}
-
-	return 0;
-}
-
-static int cx25821_upstream_buffer_prepare_ch2(struct cx25821_dev *dev,
-					       const struct sram_channel *sram_ch,
-					       int bpl)
-{
-	int ret = 0;
-	dma_addr_t dma_addr;
-	dma_addr_t data_dma_addr;
-
-	if (dev->_dma_virt_addr_ch2 != NULL) {
-		pci_free_consistent(dev->pci, dev->upstream_riscbuf_size_ch2,
-				    dev->_dma_virt_addr_ch2,
-				    dev->_dma_phys_addr_ch2);
-	}
-
-	dev->_dma_virt_addr_ch2 = pci_alloc_consistent(dev->pci,
-			dev->upstream_riscbuf_size_ch2, &dma_addr);
-	dev->_dma_virt_start_addr_ch2 = dev->_dma_virt_addr_ch2;
-	dev->_dma_phys_start_addr_ch2 = dma_addr;
-	dev->_dma_phys_addr_ch2 = dma_addr;
-	dev->_risc_size_ch2 = dev->upstream_riscbuf_size_ch2;
-
-	if (!dev->_dma_virt_addr_ch2) {
-		pr_err("FAILED to allocate memory for Risc buffer! Returning\n");
-		return -ENOMEM;
-	}
-
-	/* Iniitize at this address until n bytes to 0 */
-	memset(dev->_dma_virt_addr_ch2, 0, dev->_risc_size_ch2);
-
-	if (dev->_data_buf_virt_addr_ch2 != NULL) {
-		pci_free_consistent(dev->pci, dev->upstream_databuf_size_ch2,
-				    dev->_data_buf_virt_addr_ch2,
-				    dev->_data_buf_phys_addr_ch2);
-	}
-	/* For Video Data buffer allocation */
-	dev->_data_buf_virt_addr_ch2 = pci_alloc_consistent(dev->pci,
-			dev->upstream_databuf_size_ch2, &data_dma_addr);
-	dev->_data_buf_phys_addr_ch2 = data_dma_addr;
-	dev->_data_buf_size_ch2 = dev->upstream_databuf_size_ch2;
-
-	if (!dev->_data_buf_virt_addr_ch2) {
-		pr_err("FAILED to allocate memory for data buffer! Returning\n");
-		return -ENOMEM;
-	}
-
-	/* Initialize at this address until n bytes to 0 */
-	memset(dev->_data_buf_virt_addr_ch2, 0, dev->_data_buf_size_ch2);
-
-	ret = cx25821_openfile_ch2(dev, sram_ch);
-	if (ret < 0)
-		return ret;
-
-	/* Creating RISC programs */
-	ret = cx25821_risc_buffer_upstream_ch2(dev, dev->pci, 0, bpl,
-						dev->_lines_count_ch2);
-	if (ret < 0) {
-		pr_info("Failed creating Video Upstream Risc programs!\n");
-		goto error;
-	}
-
-	return 0;
-
-error:
-	return ret;
-}
-
-static int cx25821_video_upstream_irq_ch2(struct cx25821_dev *dev,
-					  int chan_num,
-					  u32 status)
-{
-	u32 int_msk_tmp;
-	const struct sram_channel *channel = dev->channels[chan_num].sram_channels;
-	int singlefield_lines = NTSC_FIELD_HEIGHT;
-	int line_size_in_bytes = Y422_LINE_SZ;
-	int odd_risc_prog_size = 0;
-	dma_addr_t risc_phys_jump_addr;
-	__le32 *rp;
-
-	if (status & FLD_VID_SRC_RISC1) {
-		/* We should only process one program per call */
-		u32 prog_cnt = cx_read(channel->gpcnt);
-
-		/*
-		 *  Since we've identified our IRQ, clear our bits from the
-		 *  interrupt mask and interrupt status registers
-		 */
-		int_msk_tmp = cx_read(channel->int_msk);
-		cx_write(channel->int_msk, int_msk_tmp & ~_intr_msk);
-		cx_write(channel->int_stat, _intr_msk);
-
-		spin_lock(&dev->slock);
-
-		dev->_frame_index_ch2 = prog_cnt;
-
-		queue_work(dev->_irq_queues_ch2, &dev->_irq_work_entry_ch2);
-
-		if (dev->_is_first_frame_ch2) {
-			dev->_is_first_frame_ch2 = 0;
-
-			if (dev->_isNTSC_ch2) {
-				singlefield_lines += 1;
-				odd_risc_prog_size = ODD_FLD_NTSC_PROG_SIZE;
-			} else {
-				singlefield_lines = PAL_FIELD_HEIGHT;
-				odd_risc_prog_size = ODD_FLD_PAL_PROG_SIZE;
-			}
-
-			if (dev->_dma_virt_start_addr_ch2 != NULL) {
-				if (dev->_pixel_format_ch2 == PIXEL_FRMT_411)
-					line_size_in_bytes = Y411_LINE_SZ;
-				else
-					line_size_in_bytes = Y422_LINE_SZ;
-				risc_phys_jump_addr =
-					dev->_dma_phys_start_addr_ch2 +
-					odd_risc_prog_size;
-
-				rp = cx25821_update_riscprogram_ch2(dev,
-						dev->_dma_virt_start_addr_ch2,
-						TOP_OFFSET, line_size_in_bytes,
-						0x0, singlefield_lines,
-						FIFO_DISABLE, ODD_FIELD);
-
-			       /* Jump to Even Risc program of 1st Frame */
-				*(rp++) = cpu_to_le32(RISC_JUMP);
-				*(rp++) = cpu_to_le32(risc_phys_jump_addr);
-				*(rp++) = cpu_to_le32(0);
-			}
-		}
-
-		spin_unlock(&dev->slock);
-	}
-
-	if (dev->_file_status_ch2 == END_OF_FILE) {
-		pr_info("EOF Channel 2 Framecount = %d\n",
-			dev->_frame_count_ch2);
-		return -1;
-	}
-	/* ElSE, set the interrupt mask register, re-enable irq. */
-	int_msk_tmp = cx_read(channel->int_msk);
-	cx_write(channel->int_msk, int_msk_tmp |= _intr_msk);
-
-	return 0;
-}
-
-static irqreturn_t cx25821_upstream_irq_ch2(int irq, void *dev_id)
-{
-	struct cx25821_dev *dev = dev_id;
-	u32 vid_status;
-	int handled = 0;
-	int channel_num = 0;
-	const struct sram_channel *sram_ch;
-
-	if (!dev)
-		return -1;
-
-	channel_num = VID_UPSTREAM_SRAM_CHANNEL_J;
-	sram_ch = dev->channels[channel_num].sram_channels;
-
-	vid_status = cx_read(sram_ch->int_stat);
-
-	/* Only deal with our interrupt */
-	if (vid_status)
-		handled = cx25821_video_upstream_irq_ch2(dev, channel_num,
-				vid_status);
-
-	if (handled < 0)
-		cx25821_stop_upstream_video_ch2(dev);
-	else
-		handled += handled;
-
-	return IRQ_RETVAL(handled);
-}
-
-static void cx25821_set_pixelengine_ch2(struct cx25821_dev *dev,
-					const struct sram_channel *ch, int pix_format)
-{
-	int width = WIDTH_D1;
-	int height = dev->_lines_count_ch2;
-	int num_lines, odd_num_lines;
-	u32 value;
-	int vip_mode = PIXEL_ENGINE_VIP1;
-
-	value = ((pix_format & 0x3) << 12) | (vip_mode & 0x7);
-	value &= 0xFFFFFFEF;
-	value |= dev->_isNTSC_ch2 ? 0 : 0x10;
-	cx_write(ch->vid_fmt_ctl, value);
-
-	/*
-	 *  set number of active pixels in each line. Default is 720
-	 * pixels in both NTSC and PAL format
-	 */
-	cx_write(ch->vid_active_ctl1, width);
-
-	num_lines = (height / 2) & 0x3FF;
-	odd_num_lines = num_lines;
-
-	if (dev->_isNTSC_ch2)
-		odd_num_lines += 1;
-
-	value = (num_lines << 16) | odd_num_lines;
-
-	/* set number of active lines in field 0 (top) and field 1 (bottom) */
-	cx_write(ch->vid_active_ctl2, value);
-
-	cx_write(ch->vid_cdt_size, VID_CDT_SIZE >> 3);
-}
-
-static int cx25821_start_video_dma_upstream_ch2(struct cx25821_dev *dev,
-						const struct sram_channel *sram_ch)
-{
-	u32 tmp = 0;
-	int err = 0;
-
-	/*
-	 *  656/VIP SRC Upstream Channel I & J and 7 - Host Bus Interface
-	 * for channel A-C
-	 */
-	tmp = cx_read(VID_CH_MODE_SEL);
-	cx_write(VID_CH_MODE_SEL, tmp | 0x1B0001FF);
-
-	/*
-	 *  Set the physical start address of the RISC program in the initial
-	 *  program counter(IPC) member of the cmds.
-	 */
-	cx_write(sram_ch->cmds_start + 0, dev->_dma_phys_addr_ch2);
-	cx_write(sram_ch->cmds_start + 4, 0); /* Risc IPC High 64 bits 63-32 */
-
-	/* reset counter */
-	cx_write(sram_ch->gpcnt_ctl, 3);
-
-	/* Clear our bits from the interrupt status register. */
-	cx_write(sram_ch->int_stat, _intr_msk);
-
-	/* Set the interrupt mask register, enable irq. */
-	cx_set(PCI_INT_MSK, cx_read(PCI_INT_MSK) | (1 << sram_ch->irq_bit));
-	tmp = cx_read(sram_ch->int_msk);
-	cx_write(sram_ch->int_msk, tmp |= _intr_msk);
-
-	err = request_irq(dev->pci->irq, cx25821_upstream_irq_ch2,
-			IRQF_SHARED, dev->name, dev);
-	if (err < 0) {
-		pr_err("%s: can't get upstream IRQ %d\n",
-		       dev->name, dev->pci->irq);
-		goto fail_irq;
-	}
-	/* Start the DMA  engine */
-	tmp = cx_read(sram_ch->dma_ctl);
-	cx_set(sram_ch->dma_ctl, tmp | FLD_VID_RISC_EN);
-
-	dev->_is_running_ch2 = 1;
-	dev->_is_first_frame_ch2 = 1;
-
-	return 0;
-
-fail_irq:
-	cx25821_dev_unregister(dev);
-	return err;
-}
-
-int cx25821_vidupstream_init_ch2(struct cx25821_dev *dev, int channel_select,
-				 int pixel_format)
-{
-	const struct sram_channel *sram_ch;
-	u32 tmp;
-	int err = 0;
-	int data_frame_size = 0;
-	int risc_buffer_size = 0;
-
-	if (dev->_is_running_ch2) {
-		pr_info("Video Channel is still running so return!\n");
-		return 0;
-	}
-
-	dev->_channel2_upstream_select = channel_select;
-	sram_ch = dev->channels[channel_select].sram_channels;
-
-	INIT_WORK(&dev->_irq_work_entry_ch2, cx25821_vidups_handler_ch2);
-	dev->_irq_queues_ch2 =
-	    create_singlethread_workqueue("cx25821_workqueue2");
-
-	if (!dev->_irq_queues_ch2) {
-		pr_err("create_singlethread_workqueue() for Video FAILED!\n");
-		return -ENOMEM;
-	}
-	/*
-	 * 656/VIP SRC Upstream Channel I & J and 7 -
-	 * Host Bus Interface for channel A-C
-	 */
-	tmp = cx_read(VID_CH_MODE_SEL);
-	cx_write(VID_CH_MODE_SEL, tmp | 0x1B0001FF);
-
-	dev->_is_running_ch2 = 0;
-	dev->_frame_count_ch2 = 0;
-	dev->_file_status_ch2 = RESET_STATUS;
-	dev->_lines_count_ch2 = dev->_isNTSC_ch2 ? 480 : 576;
-	dev->_pixel_format_ch2 = pixel_format;
-	dev->_line_size_ch2 = (dev->_pixel_format_ch2 == PIXEL_FRMT_422) ?
-		(WIDTH_D1 * 2) : (WIDTH_D1 * 3) / 2;
-	data_frame_size = dev->_isNTSC_ch2 ? NTSC_DATA_BUF_SZ : PAL_DATA_BUF_SZ;
-	risc_buffer_size = dev->_isNTSC_ch2 ?
-		NTSC_RISC_BUF_SIZE : PAL_RISC_BUF_SIZE;
-
-	if (dev->input_filename_ch2)
-		dev->_filename_ch2 = kstrdup(dev->input_filename_ch2,
-								GFP_KERNEL);
-	else
-		dev->_filename_ch2 = kstrdup(dev->_defaultname_ch2,
-								GFP_KERNEL);
-
-	if (!dev->_filename_ch2) {
-		err = -ENOENT;
-		goto error;
-	}
-
-	/* Default if filename is empty string */
-	if (strcmp(dev->_filename_ch2, "") == 0) {
-		if (dev->_isNTSC_ch2) {
-			dev->_filename_ch2 = (dev->_pixel_format_ch2 ==
-				PIXEL_FRMT_411) ? "/root/vid411.yuv" :
-				"/root/vidtest.yuv";
-		} else {
-			dev->_filename_ch2 = (dev->_pixel_format_ch2 ==
-				PIXEL_FRMT_411) ? "/root/pal411.yuv" :
-				"/root/pal422.yuv";
-		}
-	}
-
-	err = cx25821_sram_channel_setup_upstream(dev, sram_ch,
-						dev->_line_size_ch2, 0);
-
-	/* setup fifo + format */
-	cx25821_set_pixelengine_ch2(dev, sram_ch, dev->_pixel_format_ch2);
-
-	dev->upstream_riscbuf_size_ch2 = risc_buffer_size * 2;
-	dev->upstream_databuf_size_ch2 = data_frame_size * 2;
-
-	/* Allocating buffers and prepare RISC program */
-	err = cx25821_upstream_buffer_prepare_ch2(dev, sram_ch,
-						dev->_line_size_ch2);
-	if (err < 0) {
-		pr_err("%s: Failed to set up Video upstream buffers!\n",
-		       dev->name);
-		goto error;
-	}
-
-	cx25821_start_video_dma_upstream_ch2(dev, sram_ch);
-
-	return 0;
-
-error:
-	cx25821_dev_unregister(dev);
-
-	return err;
-}
diff --git a/drivers/media/pci/cx25821/cx25821-video-upstream-ch2.h b/drivers/media/pci/cx25821/cx25821-video-upstream-ch2.h
deleted file mode 100644
index d42dab5..0000000
--- a/drivers/media/pci/cx25821/cx25821-video-upstream-ch2.h
+++ /dev/null
@@ -1,138 +0,0 @@
-/*
- *  Driver for the Conexant CX25821 PCIe bridge
- *
- *  Copyright (C) 2009 Conexant Systems Inc.
- *  Authors  <hiep.huynh@conexant.com>, <shu.lin@conexant.com>
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation; either version 2 of the License, or
- *  (at your option) any later version.
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *
- *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- */
-
-#include <linux/mutex.h>
-#include <linux/workqueue.h>
-
-#define OPEN_FILE_1           0
-#define NUM_PROGS             8
-#define NUM_FRAMES            2
-#define ODD_FIELD             0
-#define EVEN_FIELD            1
-#define TOP_OFFSET            0
-#define FIFO_DISABLE          0
-#define FIFO_ENABLE           1
-#define TEST_FRAMES           5
-#define END_OF_FILE           0
-#define IN_PROGRESS           1
-#define RESET_STATUS          -1
-#define NUM_NO_OPS            5
-
-/* PAL and NTSC line sizes and number of lines. */
-#define WIDTH_D1              720
-#define NTSC_LINES_PER_FRAME  480
-#define PAL_LINES_PER_FRAME   576
-#define PAL_LINE_SZ           1440
-#define Y422_LINE_SZ          1440
-#define Y411_LINE_SZ          1080
-#define NTSC_FIELD_HEIGHT     240
-#define NTSC_ODD_FLD_LINES    241
-#define PAL_FIELD_HEIGHT      288
-
-#define FRAME_SIZE_NTSC_Y422    (NTSC_LINES_PER_FRAME * Y422_LINE_SZ)
-#define FRAME_SIZE_NTSC_Y411    (NTSC_LINES_PER_FRAME * Y411_LINE_SZ)
-#define FRAME_SIZE_PAL_Y422     (PAL_LINES_PER_FRAME * Y422_LINE_SZ)
-#define FRAME_SIZE_PAL_Y411     (PAL_LINES_PER_FRAME * Y411_LINE_SZ)
-
-#define NTSC_DATA_BUF_SZ        (Y422_LINE_SZ * NTSC_LINES_PER_FRAME)
-#define PAL_DATA_BUF_SZ         (Y422_LINE_SZ * PAL_LINES_PER_FRAME)
-
-#define RISC_WRITECR_INSTRUCTION_SIZE   16
-#define RISC_SYNC_INSTRUCTION_SIZE      4
-#define JUMP_INSTRUCTION_SIZE           12
-#define MAXSIZE_NO_OPS                  36
-#define DWORD_SIZE                      4
-
-#define USE_RISC_NOOP_VIDEO   1
-
-#ifdef USE_RISC_NOOP_VIDEO
-#define PAL_US_VID_PROG_SIZE						\
-	(PAL_FIELD_HEIGHT * 3 * DWORD_SIZE +				\
-	 RISC_WRITECR_INSTRUCTION_SIZE + RISC_SYNC_INSTRUCTION_SIZE +	\
-	 NUM_NO_OPS * DWORD_SIZE)
-
-#define PAL_RISC_BUF_SIZE         (2 * PAL_US_VID_PROG_SIZE)
-
-#define PAL_VID_PROG_SIZE						\
-	((PAL_FIELD_HEIGHT * 2) * 3 * DWORD_SIZE +			\
-	 2 * RISC_SYNC_INSTRUCTION_SIZE + RISC_WRITECR_INSTRUCTION_SIZE + \
-	 JUMP_INSTRUCTION_SIZE + 2 * NUM_NO_OPS * DWORD_SIZE)
-
-#define ODD_FLD_PAL_PROG_SIZE						\
-	(PAL_FIELD_HEIGHT * 3 * DWORD_SIZE +				\
-	 RISC_SYNC_INSTRUCTION_SIZE + RISC_WRITECR_INSTRUCTION_SIZE +	\
-	 NUM_NO_OPS * DWORD_SIZE)
-
-#define NTSC_US_VID_PROG_SIZE						\
-	((NTSC_ODD_FLD_LINES + 1) * 3 * DWORD_SIZE +			\
-	 RISC_WRITECR_INSTRUCTION_SIZE + JUMP_INSTRUCTION_SIZE +	\
-	 NUM_NO_OPS * DWORD_SIZE)
-
-#define NTSC_RISC_BUF_SIZE						\
-	(2 * (RISC_SYNC_INSTRUCTION_SIZE + NTSC_US_VID_PROG_SIZE))
-
-#define FRAME1_VID_PROG_SIZE						\
-	((NTSC_ODD_FLD_LINES + NTSC_FIELD_HEIGHT) *			\
-	 3 * DWORD_SIZE + 2 * RISC_SYNC_INSTRUCTION_SIZE +		\
-	 RISC_WRITECR_INSTRUCTION_SIZE + JUMP_INSTRUCTION_SIZE +	\
-	 2 * NUM_NO_OPS * DWORD_SIZE)
-
-#define ODD_FLD_NTSC_PROG_SIZE						\
-	(NTSC_ODD_FLD_LINES * 3 * DWORD_SIZE +				\
-	 RISC_SYNC_INSTRUCTION_SIZE + RISC_WRITECR_INSTRUCTION_SIZE +	\
-	 NUM_NO_OPS * DWORD_SIZE)
-#endif
-
-#ifndef USE_RISC_NOOP_VIDEO
-#define PAL_US_VID_PROG_SIZE						\
-	((PAL_FIELD_HEIGHT + 1) * 3 * DWORD_SIZE +			\
-	 RISC_WRITECR_INSTRUCTION_SIZE)
-
-#define PAL_RISC_BUF_SIZE						\
-	(2 * (RISC_SYNC_INSTRUCTION_SIZE + PAL_US_VID_PROG_SIZE))
-
-#define PAL_VID_PROG_SIZE						\
-	((PAL_FIELD_HEIGHT * 2) * 3 * DWORD_SIZE +			\
-	 2 * RISC_SYNC_INSTRUCTION_SIZE + RISC_WRITECR_INSTRUCTION_SIZE + \
-	 JUMP_INSTRUCTION_SIZE)
-
-#define ODD_FLD_PAL_PROG_SIZE						\
-	(PAL_FIELD_HEIGHT * 3 * DWORD_SIZE +				\
-	 RISC_SYNC_INSTRUCTION_SIZE + RISC_WRITECR_INSTRUCTION_SIZE)
-
-#define ODD_FLD_NTSC_PROG_SIZE						\
-	(NTSC_ODD_FLD_LINES * 3 * DWORD_SIZE +				\
-	 RISC_SYNC_INSTRUCTION_SIZE + RISC_WRITECR_INSTRUCTION_SIZE)
-
-#define NTSC_US_VID_PROG_SIZE						\
-	((NTSC_ODD_FLD_LINES + 1) * 3 * DWORD_SIZE +			\
-	 RISC_WRITECR_INSTRUCTION_SIZE + JUMP_INSTRUCTION_SIZE)
-
-#define NTSC_RISC_BUF_SIZE						\
-	(2 * (RISC_SYNC_INSTRUCTION_SIZE + NTSC_US_VID_PROG_SIZE))
-
-#define FRAME1_VID_PROG_SIZE						\
-	((NTSC_ODD_FLD_LINES + NTSC_FIELD_HEIGHT) *			\
-	 3 * DWORD_SIZE + 2 * RISC_SYNC_INSTRUCTION_SIZE +		\
-	 RISC_WRITECR_INSTRUCTION_SIZE + JUMP_INSTRUCTION_SIZE)
-
-#endif
diff --git a/drivers/media/pci/cx25821/cx25821-video-upstream.c b/drivers/media/pci/cx25821/cx25821-video-upstream.c
index 223aae7..37cfc83 100644
--- a/drivers/media/pci/cx25821/cx25821-video-upstream.c
+++ b/drivers/media/pci/cx25821/cx25821-video-upstream.c
@@ -97,12 +97,13 @@ int cx25821_sram_channel_setup_upstream(struct cx25821_dev *dev,
 	return 0;
 }
 
-static __le32 *cx25821_update_riscprogram(struct cx25821_dev *dev,
+static __le32 *cx25821_update_riscprogram(struct cx25821_channel *chan,
 					  __le32 *rp, unsigned int offset,
 					  unsigned int bpl, u32 sync_line,
 					  unsigned int lines, int fifo_enable,
 					  int field_type)
 {
+	struct cx25821_video_out_data *out = chan->out;
 	unsigned int line, i;
 	int dist_betwn_starts = bpl * 2;
 
@@ -116,11 +117,11 @@ static __le32 *cx25821_update_riscprogram(struct cx25821_dev *dev,
 	/* scan lines */
 	for (line = 0; line < lines; line++) {
 		*(rp++) = cpu_to_le32(RISC_READ | RISC_SOL | RISC_EOL | bpl);
-		*(rp++) = cpu_to_le32(dev->_data_buf_phys_addr + offset);
+		*(rp++) = cpu_to_le32(out->_data_buf_phys_addr + offset);
 		*(rp++) = cpu_to_le32(0);	/* bits 63-32 */
 
 		if ((lines <= NTSC_FIELD_HEIGHT)
-		    || (line < (NTSC_FIELD_HEIGHT - 1)) || !(dev->_isNTSC)) {
+		    || (line < (NTSC_FIELD_HEIGHT - 1)) || !(out->is_60hz)) {
 			offset += dist_betwn_starts;
 		}
 	}
@@ -128,15 +129,15 @@ static __le32 *cx25821_update_riscprogram(struct cx25821_dev *dev,
 	return rp;
 }
 
-static __le32 *cx25821_risc_field_upstream(struct cx25821_dev *dev, __le32 * rp,
+static __le32 *cx25821_risc_field_upstream(struct cx25821_channel *chan, __le32 *rp,
 					   dma_addr_t databuf_phys_addr,
 					   unsigned int offset, u32 sync_line,
 					   unsigned int bpl, unsigned int lines,
 					   int fifo_enable, int field_type)
 {
+	struct cx25821_video_out_data *out = chan->out;
 	unsigned int line, i;
-	const struct sram_channel *sram_ch =
-		dev->channels[dev->_channel_upstream_select].sram_channels;
+	const struct sram_channel *sram_ch = chan->sram_channels;
 	int dist_betwn_starts = bpl * 2;
 
 	/* sync instruction */
@@ -155,7 +156,7 @@ static __le32 *cx25821_risc_field_upstream(struct cx25821_dev *dev, __le32 * rp,
 		*(rp++) = cpu_to_le32(0);	/* bits 63-32 */
 
 		if ((lines <= NTSC_FIELD_HEIGHT)
-		    || (line < (NTSC_FIELD_HEIGHT - 1)) || !(dev->_isNTSC))
+		    || (line < (NTSC_FIELD_HEIGHT - 1)) || !(out->is_60hz))
 			/* to skip the other field line */
 			offset += dist_betwn_starts;
 
@@ -173,11 +174,12 @@ static __le32 *cx25821_risc_field_upstream(struct cx25821_dev *dev, __le32 * rp,
 	return rp;
 }
 
-static int cx25821_risc_buffer_upstream(struct cx25821_dev *dev,
+static int cx25821_risc_buffer_upstream(struct cx25821_channel *chan,
 					struct pci_dev *pci,
 					unsigned int top_offset,
 					unsigned int bpl, unsigned int lines)
 {
+	struct cx25821_video_out_data *out = chan->out;
 	__le32 *rp;
 	int fifo_enable = 0;
 	/* get line count for single field */
@@ -191,7 +193,7 @@ static int cx25821_risc_buffer_upstream(struct cx25821_dev *dev,
 	unsigned int bottom_offset = bpl;
 	dma_addr_t risc_phys_jump_addr;
 
-	if (dev->_isNTSC) {
+	if (out->is_60hz) {
 		odd_num_lines = singlefield_lines + 1;
 		risc_program_size = FRAME1_VID_PROG_SIZE;
 		frame_size = (bpl == Y411_LINE_SZ) ?
@@ -203,15 +205,15 @@ static int cx25821_risc_buffer_upstream(struct cx25821_dev *dev,
 	}
 
 	/* Virtual address of Risc buffer program */
-	rp = dev->_dma_virt_addr;
+	rp = out->_dma_virt_addr;
 
 	for (frame = 0; frame < NUM_FRAMES; frame++) {
 		databuf_offset = frame_size * frame;
 
 		if (UNSET != top_offset) {
 			fifo_enable = (frame == 0) ? FIFO_ENABLE : FIFO_DISABLE;
-			rp = cx25821_risc_field_upstream(dev, rp,
-					dev->_data_buf_phys_addr +
+			rp = cx25821_risc_field_upstream(chan, rp,
+					out->_data_buf_phys_addr +
 					databuf_offset, top_offset, 0, bpl,
 					odd_num_lines, fifo_enable, ODD_FIELD);
 		}
@@ -219,18 +221,18 @@ static int cx25821_risc_buffer_upstream(struct cx25821_dev *dev,
 		fifo_enable = FIFO_DISABLE;
 
 		/* Even Field */
-		rp = cx25821_risc_field_upstream(dev, rp,
-						 dev->_data_buf_phys_addr +
+		rp = cx25821_risc_field_upstream(chan, rp,
+						 out->_data_buf_phys_addr +
 						 databuf_offset, bottom_offset,
 						 0x200, bpl, singlefield_lines,
 						 fifo_enable, EVEN_FIELD);
 
 		if (frame == 0) {
 			risc_flag = RISC_CNT_RESET;
-			risc_phys_jump_addr = dev->_dma_phys_start_addr +
+			risc_phys_jump_addr = out->_dma_phys_start_addr +
 				risc_program_size;
 		} else {
-			risc_phys_jump_addr = dev->_dma_phys_start_addr;
+			risc_phys_jump_addr = out->_dma_phys_start_addr;
 			risc_flag = RISC_CNT_INC;
 		}
 
@@ -245,13 +247,14 @@ static int cx25821_risc_buffer_upstream(struct cx25821_dev *dev,
 	return 0;
 }
 
-void cx25821_stop_upstream_video_ch1(struct cx25821_dev *dev)
+void cx25821_stop_upstream_video(struct cx25821_channel *chan)
 {
-	const struct sram_channel *sram_ch =
-		dev->channels[VID_UPSTREAM_SRAM_CHANNEL_I].sram_channels;
+	struct cx25821_video_out_data *out = chan->out;
+	struct cx25821_dev *dev = chan->dev;
+	const struct sram_channel *sram_ch = chan->sram_channels;
 	u32 tmp = 0;
 
-	if (!dev->_is_running) {
+	if (!out->_is_running) {
 		pr_info("No video file is currently running so return!\n");
 		return;
 	}
@@ -264,49 +267,53 @@ void cx25821_stop_upstream_video_ch1(struct cx25821_dev *dev)
 	cx_write(sram_ch->dma_ctl, tmp & ~(FLD_VID_FIFO_EN | FLD_VID_RISC_EN));
 
 	/* Clear data buffer memory */
-	if (dev->_data_buf_virt_addr)
-		memset(dev->_data_buf_virt_addr, 0, dev->_data_buf_size);
+	if (out->_data_buf_virt_addr)
+		memset(out->_data_buf_virt_addr, 0, out->_data_buf_size);
 
-	dev->_is_running = 0;
-	dev->_is_first_frame = 0;
-	dev->_frame_count = 0;
-	dev->_file_status = END_OF_FILE;
+	out->_is_running = 0;
+	out->_is_first_frame = 0;
+	out->_frame_count = 0;
+	out->_file_status = END_OF_FILE;
 
-	kfree(dev->_irq_queues);
-	dev->_irq_queues = NULL;
+	destroy_workqueue(out->_irq_queues);
+	out->_irq_queues = NULL;
 
-	kfree(dev->_filename);
+	kfree(out->_filename);
 
 	tmp = cx_read(VID_CH_MODE_SEL);
 	cx_write(VID_CH_MODE_SEL, tmp & 0xFFFFFE00);
 }
 
-void cx25821_free_mem_upstream_ch1(struct cx25821_dev *dev)
+void cx25821_free_mem_upstream(struct cx25821_channel *chan)
 {
-	if (dev->_is_running)
-		cx25821_stop_upstream_video_ch1(dev);
+	struct cx25821_video_out_data *out = chan->out;
+	struct cx25821_dev *dev = chan->dev;
 
-	if (dev->_dma_virt_addr) {
-		pci_free_consistent(dev->pci, dev->_risc_size,
-				    dev->_dma_virt_addr, dev->_dma_phys_addr);
-		dev->_dma_virt_addr = NULL;
+	if (out->_is_running)
+		cx25821_stop_upstream_video(chan);
+
+	if (out->_dma_virt_addr) {
+		pci_free_consistent(dev->pci, out->_risc_size,
+				    out->_dma_virt_addr, out->_dma_phys_addr);
+		out->_dma_virt_addr = NULL;
 	}
 
-	if (dev->_data_buf_virt_addr) {
-		pci_free_consistent(dev->pci, dev->_data_buf_size,
-				    dev->_data_buf_virt_addr,
-				    dev->_data_buf_phys_addr);
-		dev->_data_buf_virt_addr = NULL;
+	if (out->_data_buf_virt_addr) {
+		pci_free_consistent(dev->pci, out->_data_buf_size,
+				    out->_data_buf_virt_addr,
+				    out->_data_buf_phys_addr);
+		out->_data_buf_virt_addr = NULL;
 	}
 }
 
-static int cx25821_get_frame(struct cx25821_dev *dev,
+static int cx25821_get_frame(struct cx25821_channel *chan,
 			     const struct sram_channel *sram_ch)
 {
+	struct cx25821_video_out_data *out = chan->out;
 	struct file *myfile;
-	int frame_index_temp = dev->_frame_index;
+	int frame_index_temp = out->_frame_index;
 	int i = 0;
-	int line_size = (dev->_pixel_format == PIXEL_FRMT_411) ?
+	int line_size = (out->_pixel_format == PIXEL_FRMT_411) ?
 		Y411_LINE_SZ : Y422_LINE_SZ;
 	int frame_size = 0;
 	int frame_offset = 0;
@@ -316,10 +323,10 @@ static int cx25821_get_frame(struct cx25821_dev *dev,
 	loff_t pos;
 	mm_segment_t old_fs;
 
-	if (dev->_file_status == END_OF_FILE)
+	if (out->_file_status == END_OF_FILE)
 		return 0;
 
-	if (dev->_isNTSC)
+	if (out->is_60hz)
 		frame_size = (line_size == Y411_LINE_SZ) ?
 			FRAME_SIZE_NTSC_Y411 : FRAME_SIZE_NTSC_Y422;
 	else
@@ -327,14 +334,14 @@ static int cx25821_get_frame(struct cx25821_dev *dev,
 			FRAME_SIZE_PAL_Y411 : FRAME_SIZE_PAL_Y422;
 
 	frame_offset = (frame_index_temp > 0) ? frame_size : 0;
-	file_offset = dev->_frame_count * frame_size;
+	file_offset = out->_frame_count * frame_size;
 
-	myfile = filp_open(dev->_filename, O_RDONLY | O_LARGEFILE, 0);
+	myfile = filp_open(out->_filename, O_RDONLY | O_LARGEFILE, 0);
 
 	if (IS_ERR(myfile)) {
 		const int open_errno = -PTR_ERR(myfile);
 		pr_err("%s(): ERROR opening file(%s) with errno = %d!\n",
-		       __func__, dev->_filename, open_errno);
+		       __func__, out->_filename, open_errno);
 		return PTR_ERR(myfile);
 	} else {
 		if (!(myfile->f_op)) {
@@ -355,15 +362,15 @@ static int cx25821_get_frame(struct cx25821_dev *dev,
 		old_fs = get_fs();
 		set_fs(KERNEL_DS);
 
-		for (i = 0; i < dev->_lines_count; i++) {
+		for (i = 0; i < out->_lines_count; i++) {
 			pos = file_offset;
 
 			vfs_read_retval = vfs_read(myfile, mybuf, line_size,
 					&pos);
 
 			if (vfs_read_retval > 0 && vfs_read_retval == line_size
-			    && dev->_data_buf_virt_addr != NULL) {
-				memcpy((void *)(dev->_data_buf_virt_addr +
+			    && out->_data_buf_virt_addr != NULL) {
+				memcpy((void *)(out->_data_buf_virt_addr +
 						frame_offset / 4), mybuf,
 				       vfs_read_retval);
 			}
@@ -379,9 +386,9 @@ static int cx25821_get_frame(struct cx25821_dev *dev,
 		}
 
 		if (i > 0)
-			dev->_frame_count++;
+			out->_frame_count++;
 
-		dev->_file_status = (vfs_read_retval == line_size) ?
+		out->_file_status = (vfs_read_retval == line_size) ?
 			IN_PROGRESS : END_OF_FILE;
 
 		set_fs(old_fs);
@@ -393,25 +400,19 @@ static int cx25821_get_frame(struct cx25821_dev *dev,
 
 static void cx25821_vidups_handler(struct work_struct *work)
 {
-	struct cx25821_dev *dev = container_of(work, struct cx25821_dev,
-			_irq_work_entry);
-
-	if (!dev) {
-		pr_err("ERROR %s(): since container_of(work_struct) FAILED!\n",
-		       __func__);
-		return;
-	}
+	struct cx25821_video_out_data *out =
+		container_of(work, struct cx25821_video_out_data, _irq_work_entry);
 
-	cx25821_get_frame(dev, dev->channels[dev->_channel_upstream_select].
-			sram_channels);
+	cx25821_get_frame(out->chan, out->chan->sram_channels);
 }
 
-static int cx25821_openfile(struct cx25821_dev *dev,
+static int cx25821_openfile(struct cx25821_channel *chan,
 			    const struct sram_channel *sram_ch)
 {
+	struct cx25821_video_out_data *out = chan->out;
 	struct file *myfile;
 	int i = 0, j = 0;
-	int line_size = (dev->_pixel_format == PIXEL_FRMT_411) ?
+	int line_size = (out->_pixel_format == PIXEL_FRMT_411) ?
 		Y411_LINE_SZ : Y422_LINE_SZ;
 	ssize_t vfs_read_retval = 0;
 	char mybuf[line_size];
@@ -419,12 +420,12 @@ static int cx25821_openfile(struct cx25821_dev *dev,
 	loff_t offset = (unsigned long)0;
 	mm_segment_t old_fs;
 
-	myfile = filp_open(dev->_filename, O_RDONLY | O_LARGEFILE, 0);
+	myfile = filp_open(out->_filename, O_RDONLY | O_LARGEFILE, 0);
 
 	if (IS_ERR(myfile)) {
 		const int open_errno = -PTR_ERR(myfile);
 		pr_err("%s(): ERROR opening file(%s) with errno = %d!\n",
-		       __func__, dev->_filename, open_errno);
+		       __func__, out->_filename, open_errno);
 		return PTR_ERR(myfile);
 	} else {
 		if (!(myfile->f_op)) {
@@ -446,7 +447,7 @@ static int cx25821_openfile(struct cx25821_dev *dev,
 		set_fs(KERNEL_DS);
 
 		for (j = 0; j < NUM_FRAMES; j++) {
-			for (i = 0; i < dev->_lines_count; i++) {
+			for (i = 0; i < out->_lines_count; i++) {
 				pos = offset;
 
 				vfs_read_retval = vfs_read(myfile, mybuf,
@@ -454,8 +455,8 @@ static int cx25821_openfile(struct cx25821_dev *dev,
 
 				if (vfs_read_retval > 0
 				    && vfs_read_retval == line_size
-				    && dev->_data_buf_virt_addr != NULL) {
-					memcpy((void *)(dev->
+				    && out->_data_buf_virt_addr != NULL) {
+					memcpy((void *)(out->
 							_data_buf_virt_addr +
 							offset / 4), mybuf,
 					       vfs_read_retval);
@@ -471,13 +472,13 @@ static int cx25821_openfile(struct cx25821_dev *dev,
 			}
 
 			if (i > 0)
-				dev->_frame_count++;
+				out->_frame_count++;
 
 			if (vfs_read_retval < line_size)
 				break;
 		}
 
-		dev->_file_status = (vfs_read_retval == line_size) ?
+		out->_file_status = (vfs_read_retval == line_size) ?
 			IN_PROGRESS : END_OF_FILE;
 
 		set_fs(old_fs);
@@ -488,58 +489,60 @@ static int cx25821_openfile(struct cx25821_dev *dev,
 	return 0;
 }
 
-static int cx25821_upstream_buffer_prepare(struct cx25821_dev *dev,
+static int cx25821_upstream_buffer_prepare(struct cx25821_channel *chan,
 					   const struct sram_channel *sram_ch,
 					   int bpl)
 {
+	struct cx25821_video_out_data *out = chan->out;
+	struct cx25821_dev *dev = chan->dev;
 	int ret = 0;
 	dma_addr_t dma_addr;
 	dma_addr_t data_dma_addr;
 
-	if (dev->_dma_virt_addr != NULL)
-		pci_free_consistent(dev->pci, dev->upstream_riscbuf_size,
-				dev->_dma_virt_addr, dev->_dma_phys_addr);
+	if (out->_dma_virt_addr != NULL)
+		pci_free_consistent(dev->pci, out->upstream_riscbuf_size,
+				out->_dma_virt_addr, out->_dma_phys_addr);
 
-	dev->_dma_virt_addr = pci_alloc_consistent(dev->pci,
-			dev->upstream_riscbuf_size, &dma_addr);
-	dev->_dma_virt_start_addr = dev->_dma_virt_addr;
-	dev->_dma_phys_start_addr = dma_addr;
-	dev->_dma_phys_addr = dma_addr;
-	dev->_risc_size = dev->upstream_riscbuf_size;
+	out->_dma_virt_addr = pci_alloc_consistent(dev->pci,
+			out->upstream_riscbuf_size, &dma_addr);
+	out->_dma_virt_start_addr = out->_dma_virt_addr;
+	out->_dma_phys_start_addr = dma_addr;
+	out->_dma_phys_addr = dma_addr;
+	out->_risc_size = out->upstream_riscbuf_size;
 
-	if (!dev->_dma_virt_addr) {
+	if (!out->_dma_virt_addr) {
 		pr_err("FAILED to allocate memory for Risc buffer! Returning\n");
 		return -ENOMEM;
 	}
 
 	/* Clear memory at address */
-	memset(dev->_dma_virt_addr, 0, dev->_risc_size);
+	memset(out->_dma_virt_addr, 0, out->_risc_size);
 
-	if (dev->_data_buf_virt_addr != NULL)
-		pci_free_consistent(dev->pci, dev->upstream_databuf_size,
-				dev->_data_buf_virt_addr,
-				dev->_data_buf_phys_addr);
+	if (out->_data_buf_virt_addr != NULL)
+		pci_free_consistent(dev->pci, out->upstream_databuf_size,
+				out->_data_buf_virt_addr,
+				out->_data_buf_phys_addr);
 	/* For Video Data buffer allocation */
-	dev->_data_buf_virt_addr = pci_alloc_consistent(dev->pci,
-			dev->upstream_databuf_size, &data_dma_addr);
-	dev->_data_buf_phys_addr = data_dma_addr;
-	dev->_data_buf_size = dev->upstream_databuf_size;
+	out->_data_buf_virt_addr = pci_alloc_consistent(dev->pci,
+			out->upstream_databuf_size, &data_dma_addr);
+	out->_data_buf_phys_addr = data_dma_addr;
+	out->_data_buf_size = out->upstream_databuf_size;
 
-	if (!dev->_data_buf_virt_addr) {
+	if (!out->_data_buf_virt_addr) {
 		pr_err("FAILED to allocate memory for data buffer! Returning\n");
 		return -ENOMEM;
 	}
 
 	/* Clear memory at address */
-	memset(dev->_data_buf_virt_addr, 0, dev->_data_buf_size);
+	memset(out->_data_buf_virt_addr, 0, out->_data_buf_size);
 
-	ret = cx25821_openfile(dev, sram_ch);
+	ret = cx25821_openfile(chan, sram_ch);
 	if (ret < 0)
 		return ret;
 
 	/* Create RISC programs */
-	ret = cx25821_risc_buffer_upstream(dev, dev->pci, 0, bpl,
-			dev->_lines_count);
+	ret = cx25821_risc_buffer_upstream(chan, dev->pci, 0, bpl,
+			out->_lines_count);
 	if (ret < 0) {
 		pr_info("Failed creating Video Upstream Risc programs!\n");
 		goto error;
@@ -551,11 +554,12 @@ error:
 	return ret;
 }
 
-static int cx25821_video_upstream_irq(struct cx25821_dev *dev, int chan_num,
-				      u32 status)
+static int cx25821_video_upstream_irq(struct cx25821_channel *chan, u32 status)
 {
+	struct cx25821_video_out_data *out = chan->out;
+	struct cx25821_dev *dev = chan->dev;
 	u32 int_msk_tmp;
-	const struct sram_channel *channel = dev->channels[chan_num].sram_channels;
+	const struct sram_channel *channel = chan->sram_channels;
 	int singlefield_lines = NTSC_FIELD_HEIGHT;
 	int line_size_in_bytes = Y422_LINE_SZ;
 	int odd_risc_prog_size = 0;
@@ -574,14 +578,14 @@ static int cx25821_video_upstream_irq(struct cx25821_dev *dev, int chan_num,
 
 		spin_lock(&dev->slock);
 
-		dev->_frame_index = prog_cnt;
+		out->_frame_index = prog_cnt;
 
-		queue_work(dev->_irq_queues, &dev->_irq_work_entry);
+		queue_work(out->_irq_queues, &out->_irq_work_entry);
 
-		if (dev->_is_first_frame) {
-			dev->_is_first_frame = 0;
+		if (out->_is_first_frame) {
+			out->_is_first_frame = 0;
 
-			if (dev->_isNTSC) {
+			if (out->is_60hz) {
 				singlefield_lines += 1;
 				odd_risc_prog_size = ODD_FLD_NTSC_PROG_SIZE;
 			} else {
@@ -589,17 +593,17 @@ static int cx25821_video_upstream_irq(struct cx25821_dev *dev, int chan_num,
 				odd_risc_prog_size = ODD_FLD_PAL_PROG_SIZE;
 			}
 
-			if (dev->_dma_virt_start_addr != NULL) {
+			if (out->_dma_virt_start_addr != NULL) {
 				line_size_in_bytes =
-				    (dev->_pixel_format ==
+				    (out->_pixel_format ==
 				     PIXEL_FRMT_411) ? Y411_LINE_SZ :
 				    Y422_LINE_SZ;
 				risc_phys_jump_addr =
-				    dev->_dma_phys_start_addr +
+				    out->_dma_phys_start_addr +
 				    odd_risc_prog_size;
 
-				rp = cx25821_update_riscprogram(dev,
-					dev->_dma_virt_start_addr, TOP_OFFSET,
+				rp = cx25821_update_riscprogram(chan,
+					out->_dma_virt_start_addr, TOP_OFFSET,
 					line_size_in_bytes, 0x0,
 					singlefield_lines, FIFO_DISABLE,
 					ODD_FIELD);
@@ -626,8 +630,8 @@ static int cx25821_video_upstream_irq(struct cx25821_dev *dev, int chan_num,
 			       __func__);
 	}
 
-	if (dev->_file_status == END_OF_FILE) {
-		pr_err("EOF Channel 1 Framecount = %d\n", dev->_frame_count);
+	if (out->_file_status == END_OF_FILE) {
+		pr_err("EOF Channel 1 Framecount = %d\n", out->_frame_count);
 		return -1;
 	}
 	/* ElSE, set the interrupt mask register, re-enable irq. */
@@ -639,47 +643,41 @@ static int cx25821_video_upstream_irq(struct cx25821_dev *dev, int chan_num,
 
 static irqreturn_t cx25821_upstream_irq(int irq, void *dev_id)
 {
-	struct cx25821_dev *dev = dev_id;
+	struct cx25821_channel *chan = dev_id;
+	struct cx25821_dev *dev = chan->dev;
 	u32 vid_status;
 	int handled = 0;
-	int channel_num = 0;
 	const struct sram_channel *sram_ch;
 
 	if (!dev)
 		return -1;
 
-	channel_num = VID_UPSTREAM_SRAM_CHANNEL_I;
-
-	sram_ch = dev->channels[channel_num].sram_channels;
+	sram_ch = chan->sram_channels;
 
 	vid_status = cx_read(sram_ch->int_stat);
 
 	/* Only deal with our interrupt */
 	if (vid_status)
-		handled = cx25821_video_upstream_irq(dev, channel_num,
-				vid_status);
-
-	if (handled < 0)
-		cx25821_stop_upstream_video_ch1(dev);
-	else
-		handled += handled;
+		handled = cx25821_video_upstream_irq(chan, vid_status);
 
 	return IRQ_RETVAL(handled);
 }
 
-static void cx25821_set_pixelengine(struct cx25821_dev *dev,
+static void cx25821_set_pixelengine(struct cx25821_channel *chan,
 				    const struct sram_channel *ch,
 				    int pix_format)
 {
+	struct cx25821_video_out_data *out = chan->out;
+	struct cx25821_dev *dev = chan->dev;
 	int width = WIDTH_D1;
-	int height = dev->_lines_count;
+	int height = out->_lines_count;
 	int num_lines, odd_num_lines;
 	u32 value;
 	int vip_mode = OUTPUT_FRMT_656;
 
 	value = ((pix_format & 0x3) << 12) | (vip_mode & 0x7);
 	value &= 0xFFFFFFEF;
-	value |= dev->_isNTSC ? 0 : 0x10;
+	value |= out->is_60hz ? 0 : 0x10;
 	cx_write(ch->vid_fmt_ctl, value);
 
 	/* set number of active pixels in each line.
@@ -689,7 +687,7 @@ static void cx25821_set_pixelengine(struct cx25821_dev *dev,
 	num_lines = (height / 2) & 0x3FF;
 	odd_num_lines = num_lines;
 
-	if (dev->_isNTSC)
+	if (out->is_60hz)
 		odd_num_lines += 1;
 
 	value = (num_lines << 16) | odd_num_lines;
@@ -700,9 +698,11 @@ static void cx25821_set_pixelengine(struct cx25821_dev *dev,
 	cx_write(ch->vid_cdt_size, VID_CDT_SIZE >> 3);
 }
 
-static int cx25821_start_video_dma_upstream(struct cx25821_dev *dev,
+static int cx25821_start_video_dma_upstream(struct cx25821_channel *chan,
 					    const struct sram_channel *sram_ch)
 {
+	struct cx25821_video_out_data *out = chan->out;
+	struct cx25821_dev *dev = chan->dev;
 	u32 tmp = 0;
 	int err = 0;
 
@@ -715,7 +715,7 @@ static int cx25821_start_video_dma_upstream(struct cx25821_dev *dev,
 	/* Set the physical start address of the RISC program in the initial
 	 * program counter(IPC) member of the cmds.
 	 */
-	cx_write(sram_ch->cmds_start + 0, dev->_dma_phys_addr);
+	cx_write(sram_ch->cmds_start + 0, out->_dma_phys_addr);
 	/* Risc IPC High 64 bits 63-32 */
 	cx_write(sram_ch->cmds_start + 4, 0);
 
@@ -731,7 +731,7 @@ static int cx25821_start_video_dma_upstream(struct cx25821_dev *dev,
 	cx_write(sram_ch->int_msk, tmp |= _intr_msk);
 
 	err = request_irq(dev->pci->irq, cx25821_upstream_irq,
-			IRQF_SHARED, dev->name, dev);
+			IRQF_SHARED, dev->name, chan);
 	if (err < 0) {
 		pr_err("%s: can't get upstream IRQ %d\n",
 		       dev->name, dev->pci->irq);
@@ -742,8 +742,8 @@ static int cx25821_start_video_dma_upstream(struct cx25821_dev *dev,
 	tmp = cx_read(sram_ch->dma_ctl);
 	cx_set(sram_ch->dma_ctl, tmp | FLD_VID_RISC_EN);
 
-	dev->_is_running = 1;
-	dev->_is_first_frame = 1;
+	out->_is_running = 1;
+	out->_is_first_frame = 1;
 
 	return 0;
 
@@ -752,9 +752,11 @@ fail_irq:
 	return err;
 }
 
-int cx25821_vidupstream_init_ch1(struct cx25821_dev *dev, int channel_select,
+int cx25821_vidupstream_init(struct cx25821_channel *chan,
 				 int pixel_format)
 {
+	struct cx25821_video_out_data *out = chan->out;
+	struct cx25821_dev *dev = chan->dev;
 	const struct sram_channel *sram_ch;
 	u32 tmp;
 	int err = 0;
@@ -762,18 +764,17 @@ int cx25821_vidupstream_init_ch1(struct cx25821_dev *dev, int channel_select,
 	int risc_buffer_size = 0;
 	int str_length = 0;
 
-	if (dev->_is_running) {
+	if (out->_is_running) {
 		pr_info("Video Channel is still running so return!\n");
 		return 0;
 	}
 
-	dev->_channel_upstream_select = channel_select;
-	sram_ch = dev->channels[channel_select].sram_channels;
+	sram_ch = chan->sram_channels;
 
-	INIT_WORK(&dev->_irq_work_entry, cx25821_vidups_handler);
-	dev->_irq_queues = create_singlethread_workqueue("cx25821_workqueue");
+	INIT_WORK(&out->_irq_work_entry, cx25821_vidups_handler);
+	out->_irq_queues = create_singlethread_workqueue("cx25821_workqueue");
 
-	if (!dev->_irq_queues) {
+	if (!out->_irq_queues) {
 		pr_err("create_singlethread_workqueue() for Video FAILED!\n");
 		return -ENOMEM;
 	}
@@ -783,76 +784,76 @@ int cx25821_vidupstream_init_ch1(struct cx25821_dev *dev, int channel_select,
 	tmp = cx_read(VID_CH_MODE_SEL);
 	cx_write(VID_CH_MODE_SEL, tmp | 0x1B0001FF);
 
-	dev->_is_running = 0;
-	dev->_frame_count = 0;
-	dev->_file_status = RESET_STATUS;
-	dev->_lines_count = dev->_isNTSC ? 480 : 576;
-	dev->_pixel_format = pixel_format;
-	dev->_line_size = (dev->_pixel_format == PIXEL_FRMT_422) ?
+	out->_is_running = 0;
+	out->_frame_count = 0;
+	out->_file_status = RESET_STATUS;
+	out->_lines_count = out->is_60hz ? 480 : 576;
+	out->_pixel_format = pixel_format;
+	out->_line_size = (out->_pixel_format == PIXEL_FRMT_422) ?
 		(WIDTH_D1 * 2) : (WIDTH_D1 * 3) / 2;
-	data_frame_size = dev->_isNTSC ? NTSC_DATA_BUF_SZ : PAL_DATA_BUF_SZ;
-	risc_buffer_size = dev->_isNTSC ?
+	data_frame_size = out->is_60hz ? NTSC_DATA_BUF_SZ : PAL_DATA_BUF_SZ;
+	risc_buffer_size = out->is_60hz ?
 		NTSC_RISC_BUF_SIZE : PAL_RISC_BUF_SIZE;
 
-	if (dev->input_filename) {
-		str_length = strlen(dev->input_filename);
-		dev->_filename = kmemdup(dev->input_filename, str_length + 1,
+	if (out->input_filename) {
+		str_length = strlen(out->input_filename);
+		out->_filename = kmemdup(out->input_filename, str_length + 1,
 					 GFP_KERNEL);
 
-		if (!dev->_filename) {
+		if (!out->_filename) {
 			err = -ENOENT;
 			goto error;
 		}
 	} else {
-		str_length = strlen(dev->_defaultname);
-		dev->_filename = kmemdup(dev->_defaultname, str_length + 1,
+		str_length = strlen(out->_defaultname);
+		out->_filename = kmemdup(out->_defaultname, str_length + 1,
 					 GFP_KERNEL);
 
-		if (!dev->_filename) {
+		if (!out->_filename) {
 			err = -ENOENT;
 			goto error;
 		}
 	}
 
 	/* Default if filename is empty string */
-	if (strcmp(dev->_filename, "") == 0) {
-		if (dev->_isNTSC) {
-			dev->_filename =
-				(dev->_pixel_format == PIXEL_FRMT_411) ?
+	if (strcmp(out->_filename, "") == 0) {
+		if (out->is_60hz) {
+			out->_filename =
+				(out->_pixel_format == PIXEL_FRMT_411) ?
 				"/root/vid411.yuv" : "/root/vidtest.yuv";
 		} else {
-			dev->_filename =
-				(dev->_pixel_format == PIXEL_FRMT_411) ?
+			out->_filename =
+				(out->_pixel_format == PIXEL_FRMT_411) ?
 				"/root/pal411.yuv" : "/root/pal422.yuv";
 		}
 	}
 
-	dev->_is_running = 0;
-	dev->_frame_count = 0;
-	dev->_file_status = RESET_STATUS;
-	dev->_lines_count = dev->_isNTSC ? 480 : 576;
-	dev->_pixel_format = pixel_format;
-	dev->_line_size = (dev->_pixel_format == PIXEL_FRMT_422) ?
+	out->_is_running = 0;
+	out->_frame_count = 0;
+	out->_file_status = RESET_STATUS;
+	out->_lines_count = out->is_60hz ? 480 : 576;
+	out->_pixel_format = pixel_format;
+	out->_line_size = (out->_pixel_format == PIXEL_FRMT_422) ?
 		(WIDTH_D1 * 2) : (WIDTH_D1 * 3) / 2;
 
 	err = cx25821_sram_channel_setup_upstream(dev, sram_ch,
-			dev->_line_size, 0);
+			out->_line_size, 0);
 
 	/* setup fifo + format */
-	cx25821_set_pixelengine(dev, sram_ch, dev->_pixel_format);
+	cx25821_set_pixelengine(chan, sram_ch, out->_pixel_format);
 
-	dev->upstream_riscbuf_size = risc_buffer_size * 2;
-	dev->upstream_databuf_size = data_frame_size * 2;
+	out->upstream_riscbuf_size = risc_buffer_size * 2;
+	out->upstream_databuf_size = data_frame_size * 2;
 
 	/* Allocating buffers and prepare RISC program */
-	err = cx25821_upstream_buffer_prepare(dev, sram_ch, dev->_line_size);
+	err = cx25821_upstream_buffer_prepare(chan, sram_ch, out->_line_size);
 	if (err < 0) {
 		pr_err("%s: Failed to set up Video upstream buffers!\n",
 		       dev->name);
 		goto error;
 	}
 
-	cx25821_start_video_dma_upstream(dev, sram_ch);
+	cx25821_start_video_dma_upstream(chan, sram_ch);
 
 	return 0;
 
diff --git a/drivers/media/pci/cx25821/cx25821-video.c b/drivers/media/pci/cx25821/cx25821-video.c
index 70e33b1..dde0ba3 100644
--- a/drivers/media/pci/cx25821/cx25821-video.c
+++ b/drivers/media/pci/cx25821/cx25821-video.c
@@ -893,6 +893,20 @@ static int vidioc_s_fmt_vid_out(struct file *file, void *priv,
 	return 0;
 }
 
+static int video_out_release(struct file *file)
+{
+	struct cx25821_channel *chan = video_drvdata(file);
+	struct cx25821_video_out_data *out = chan->out;
+	struct cx25821_dev *dev = chan->dev;
+
+	mutex_lock(&dev->lock);
+	if ((chan->id == SRAM_CH09 || chan->id == SRAM_CH10) && out->_is_running)
+		cx25821_stop_upstream_video(chan);
+	mutex_unlock(&dev->lock);
+
+	return v4l2_fh_release(file);
+}
+
 static const struct v4l2_ctrl_ops cx25821_ctrl_ops = {
 	.s_ctrl = cx25821_s_ctrl,
 };
@@ -941,7 +955,7 @@ static const struct video_device cx25821_video_device = {
 static const struct v4l2_file_operations video_out_fops = {
 	.owner = THIS_MODULE,
 	.open = v4l2_fh_open,
-	.release = v4l2_fh_release,
+	.release = video_out_release,
 	.unlocked_ioctl = video_ioctl2,
 };
 
@@ -1017,6 +1031,9 @@ int cx25821_video_register(struct cx25821_dev *dev)
 			err = v4l2_ctrl_handler_setup(hdl);
 			if (err)
 				goto fail_unreg;
+		} else {
+			chan->out = &dev->vid_out_data[i - SRAM_CH09];
+			chan->out->chan = chan;
 		}
 
 		cx25821_risc_stopper(dev->pci, &chan->dma_vidq.stopper,
diff --git a/drivers/media/pci/cx25821/cx25821.h b/drivers/media/pci/cx25821/cx25821.h
index 156ad6f..b0bc2e6 100644
--- a/drivers/media/pci/cx25821/cx25821.h
+++ b/drivers/media/pci/cx25821/cx25821.h
@@ -172,6 +172,42 @@ struct cx25821_data {
 
 struct cx25821_dev;
 
+struct cx25821_channel;
+
+struct cx25821_video_out_data {
+	struct cx25821_channel *chan;
+	int _line_size;
+	int _prog_cnt;
+	int _pixel_format;
+	int _is_first_frame;
+	int _is_running;
+	int _file_status;
+	int _lines_count;
+	int _frame_count;
+	unsigned int _risc_size;
+
+	__le32 *_dma_virt_start_addr;
+	__le32 *_dma_virt_addr;
+	dma_addr_t _dma_phys_addr;
+	dma_addr_t _dma_phys_start_addr;
+
+	unsigned int _data_buf_size;
+	__le32 *_data_buf_virt_addr;
+	dma_addr_t _data_buf_phys_addr;
+
+	u32 upstream_riscbuf_size;
+	u32 upstream_databuf_size;
+	struct workqueue_struct *_irq_queues;
+	struct work_struct _irq_work_entry;
+	int is_60hz;
+	int _frame_index;
+	char *input_filename;
+	char *vid_stdname;
+	int pixel_format;
+	char *_filename;
+	char *_defaultname;
+};
+
 struct cx25821_channel {
 	unsigned id;
 	struct cx25821_dev *dev;
@@ -191,6 +227,9 @@ struct cx25821_channel {
 	int pixel_formats;
 	int use_cif_resolution;
 	int cif_width;
+
+	/* video output data for the video output channel */
+	struct cx25821_video_out_data *out;
 };
 
 struct snd_card;
@@ -250,83 +289,18 @@ struct cx25821_dev {
 	__le32 *_audiodata_buf_virt_addr;
 	dma_addr_t _audiodata_buf_phys_addr;
 	char *_audiofilename;
-
-	/* V4l */
-	spinlock_t slock;
-
-	/* Video Upstream */
-	int _line_size;
-	int _prog_cnt;
-	int _pixel_format;
-	int _is_first_frame;
-	int _is_running;
-	int _file_status;
-	int _lines_count;
-	int _frame_count;
-	int _channel_upstream_select;
-	unsigned int _risc_size;
-
-	__le32 *_dma_virt_start_addr;
-	__le32 *_dma_virt_addr;
-	dma_addr_t _dma_phys_addr;
-	dma_addr_t _dma_phys_start_addr;
-
-	unsigned int _data_buf_size;
-	__le32 *_data_buf_virt_addr;
-	dma_addr_t _data_buf_phys_addr;
-	char *_filename;
-	char *_defaultname;
-
-	int _line_size_ch2;
-	int _prog_cnt_ch2;
-	int _pixel_format_ch2;
-	int _is_first_frame_ch2;
-	int _is_running_ch2;
-	int _file_status_ch2;
-	int _lines_count_ch2;
-	int _frame_count_ch2;
-	int _channel2_upstream_select;
-	unsigned int _risc_size_ch2;
-
-	__le32 *_dma_virt_start_addr_ch2;
-	__le32 *_dma_virt_addr_ch2;
-	dma_addr_t _dma_phys_addr_ch2;
-	dma_addr_t _dma_phys_start_addr_ch2;
-
-	unsigned int _data_buf_size_ch2;
-	__le32 *_data_buf_virt_addr_ch2;
-	dma_addr_t _data_buf_phys_addr_ch2;
-	char *_filename_ch2;
-	char *_defaultname_ch2;
-
-	u32 upstream_riscbuf_size;
-	u32 upstream_databuf_size;
-	u32 upstream_riscbuf_size_ch2;
-	u32 upstream_databuf_size_ch2;
 	u32 audio_upstream_riscbuf_size;
 	u32 audio_upstream_databuf_size;
-	int _isNTSC;
-	int _frame_index;
 	int _audioframe_index;
-	struct workqueue_struct *_irq_queues;
-	struct work_struct _irq_work_entry;
-	struct workqueue_struct *_irq_queues_ch2;
-	struct work_struct _irq_work_entry_ch2;
 	struct workqueue_struct *_irq_audio_queues;
 	struct work_struct _audio_work_entry;
-	char *input_filename;
-	char *input_filename_ch2;
-	int _frame_index_ch2;
-	int _isNTSC_ch2;
-	char *vid_stdname_ch2;
-	int pixel_format_ch2;
-	int channel_select_ch2;
-	int command_ch2;
 	char *input_audiofilename;
-	char *vid_stdname;
-	int pixel_format;
-	int channel_select;
-	int command;
+
+	/* V4l */
+	spinlock_t slock;
+
+	/* Video Upstream */
+	struct cx25821_video_out_data vid_out_data[2];
 };
 
 static inline struct cx25821_dev *get_cx25821(struct v4l2_device *v4l2_dev)
@@ -463,17 +437,12 @@ extern int cx25821_sram_channel_setup_audio(struct cx25821_dev *dev,
 					    const struct sram_channel *ch,
 					    unsigned int bpl, u32 risc);
 
-extern int cx25821_vidupstream_init_ch1(struct cx25821_dev *dev,
-					int channel_select, int pixel_format);
-extern int cx25821_vidupstream_init_ch2(struct cx25821_dev *dev,
-					int channel_select, int pixel_format);
+extern int cx25821_vidupstream_init(struct cx25821_channel *chan, int pixel_format);
 extern int cx25821_audio_upstream_init(struct cx25821_dev *dev,
 				       int channel_select);
-extern void cx25821_free_mem_upstream_ch1(struct cx25821_dev *dev);
-extern void cx25821_free_mem_upstream_ch2(struct cx25821_dev *dev);
+extern void cx25821_free_mem_upstream(struct cx25821_channel *chan);
 extern void cx25821_free_mem_upstream_audio(struct cx25821_dev *dev);
-extern void cx25821_stop_upstream_video_ch1(struct cx25821_dev *dev);
-extern void cx25821_stop_upstream_video_ch2(struct cx25821_dev *dev);
+extern void cx25821_stop_upstream_video(struct cx25821_channel *chan);
 extern void cx25821_stop_upstream_audio(struct cx25821_dev *dev);
 extern int cx25821_sram_channel_setup_upstream(struct cx25821_dev *dev,
 					       const struct sram_channel *ch,
-- 
1.7.10.4

