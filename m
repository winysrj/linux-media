Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:65504 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526AbaJEJAV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Oct 2014 05:00:21 -0400
From: "=?UTF-8?q?=D0=91=D1=83=D0=B4=D0=B8=20=D0=A0=D0=BE=D0=BC=D0=B0=D0=BD=D1=82=D0=BE=2C=20AreMa=20Inc?="
	<info@are.ma>
To: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, crope@iki.fi, m.chehab@samsung.com,
	mchehab@osg.samsung.com, hdegoede@redhat.com,
	laurent.pinchart@ideasonboard.com, mkrufky@linuxtv.org,
	sylvester.nawrocki@gmail.com, g.liakhovetski@gmx.de,
	peter.senna@gmail.com
Subject: [PATCH 06/11] pt3: namespace cleanup
Date: Sun,  5 Oct 2014 17:59:42 +0900
Message-Id: <b05c5163dc74cb38418b4e3471c38d6278570a01.1412497399.git.knightrider@are.ma>
In-Reply-To: <cover.1412497399.git.knightrider@are.ma>
References: <cover.1412497399.git.knightrider@are.ma>
In-Reply-To: <cover.1412497399.git.knightrider@are.ma>
References: <cover.1412497399.git.knightrider@are.ma>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

nothing to export

Signed-off-by: Буди Романто, AreMa Inc <knightrider@are.ma>
---
 drivers/media/pci/pt3/pt3.h | 183 +++-----------------------------------------
 1 file changed, 10 insertions(+), 173 deletions(-)

diff --git a/drivers/media/pci/pt3/pt3.h b/drivers/media/pci/pt3/pt3.h
index 1b3f2ad..13a0c8c 100644
--- a/drivers/media/pci/pt3/pt3.h
+++ b/drivers/media/pci/pt3/pt3.h
@@ -1,12 +1,12 @@
 /*
- * Earthsoft PT3 driver
+ * DVB driver for Earthsoft PT3 ISDB-S/T PCI-E card
  *
- * Copyright (C) 2014 Akihiro Tsukada <tskd08@gmail.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation version 2.
+ * Copyright (C) 2014 Budi Rachmanto, AreMa Inc. <info@are.ma>
  *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
  *
  * This program is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
@@ -14,173 +14,10 @@
  * GNU General Public License for more details.
  */
 
-#ifndef PT3_H
-#define PT3_H
-
-#include <linux/atomic.h>
-#include <linux/types.h>
-
-#include "dvb_demux.h"
-#include "dvb_frontend.h"
-#include "dmxdev.h"
-
-#include "tc90522.h"
-#include "mxl301rf.h"
-#include "qm1d1c0042.h"
-
-#define DRV_NAME KBUILD_MODNAME
-
-#define PT3_NUM_FE 4
-
-/*
- * register index of the FPGA chip
- */
-#define REG_VERSION	0x00
-#define REG_BUS		0x04
-#define REG_SYSTEM_W	0x08
-#define REG_SYSTEM_R	0x0c
-#define REG_I2C_W	0x10
-#define REG_I2C_R	0x14
-#define REG_RAM_W	0x18
-#define REG_RAM_R	0x1c
-#define REG_DMA_BASE	0x40	/* regs for FE[i] = REG_DMA_BASE + 0x18 * i */
-#define OFST_DMA_DESC_L	0x00
-#define OFST_DMA_DESC_H	0x04
-#define OFST_DMA_CTL	0x08
-#define OFST_TS_CTL	0x0c
-#define OFST_STATUS	0x10
-#define OFST_TS_ERR	0x14
-
-/*
- * internal buffer for I2C
- */
-#define PT3_I2C_MAX 4091
-struct pt3_i2cbuf {
-	u8  data[PT3_I2C_MAX];
-	u8  tmp;
-	u32 num_cmds;
-};
-
-/*
- * DMA things
- */
-#define TS_PACKET_SZ  188
-/* DMA transfers must not cross 4GiB, so use one page / transfer */
-#define DATA_XFER_SZ   4096
-#define DATA_BUF_XFERS 47
-/* (num_bufs * DATA_BUF_SZ) % TS_PACKET_SZ must be 0 */
-#define DATA_BUF_SZ    (DATA_BUF_XFERS * DATA_XFER_SZ)
-#define MAX_DATA_BUFS  16
-#define MIN_DATA_BUFS   2
-
-#define DESCS_IN_PAGE (PAGE_SIZE / sizeof(struct xfer_desc))
-#define MAX_NUM_XFERS (MAX_DATA_BUFS * DATA_BUF_XFERS)
-#define MAX_DESC_BUFS DIV_ROUND_UP(MAX_NUM_XFERS, DESCS_IN_PAGE)
-
-/* DMA transfer description.
- * device is passed a pointer to this struct, dma-reads it,
- * and gets the DMA buffer ring for storing TS data.
- */
-struct xfer_desc {
-	u32 addr_l; /* bus address of target data buffer */
-	u32 addr_h;
-	u32 size;
-	u32 next_l; /* bus adddress of the next xfer_desc */
-	u32 next_h;
-};
-
-/* A DMA mapping of a page containing xfer_desc's */
-struct xfer_desc_buffer {
-	dma_addr_t b_addr;
-	struct xfer_desc *descs; /* PAGE_SIZE (xfer_desc[DESCS_IN_PAGE]) */
-};
-
-/* A DMA mapping of a data buffer */
-struct dma_data_buffer {
-	dma_addr_t b_addr;
-	u8 *data; /* size: u8[PAGE_SIZE] */
-};
-
-/*
- * device things
- */
-struct pt3_adap_config {
-	struct i2c_board_info demod_info;
-	struct tc90522_config demod_cfg;
-
-	struct i2c_board_info tuner_info;
-	union tuner_config {
-		struct qm1d1c0042_config qm1d1c0042;
-		struct mxl301rf_config   mxl301rf;
-	} tuner_cfg;
-	u32 init_freq;
-};
-
-struct pt3_adapter {
-	struct dvb_adapter  dvb_adap;  /* dvb_adap.priv => struct pt3_board */
-	int adap_idx;
-
-	struct dvb_demux    demux;
-	struct dmxdev       dmxdev;
-	struct dvb_frontend *fe;
-	struct i2c_client   *i2c_demod;
-	struct i2c_client   *i2c_tuner;
-
-	/* data fetch thread */
-	struct task_struct *thread;
-	int num_feeds;
-
-	bool cur_lna;
-	bool cur_lnb; /* current LNB power status (on/off) */
-
-	/* items below are for DMA */
-	struct dma_data_buffer buffer[MAX_DATA_BUFS];
-	int buf_idx;
-	int buf_ofs;
-	int num_bufs;  /* == pt3_board->num_bufs */
-	int num_discard; /* how many access units to discard initially */
-
-	struct xfer_desc_buffer desc_buf[MAX_DESC_BUFS];
-	int num_desc_bufs;  /* == num_bufs * DATA_BUF_XFERS / DESCS_IN_PAGE */
-};
+#ifndef	__PT3_H__
+#define	__PT3_H__
 
+#define PT3_DRVNAME KBUILD_MODNAME
 
-struct pt3_board {
-	struct pci_dev *pdev;
-	void __iomem *regs[2];
-	/* regs[0]: registers, regs[1]: internal memory, used for I2C */
-
-	struct mutex lock;
-
-	/* LNB power shared among sat-FEs */
-	int lnb_on_cnt; /* LNB power on count */
-
-	/* LNA shared among terr-FEs */
-	int lna_on_cnt; /* booster enabled count */
-
-	int num_bufs;  /* number of DMA buffers allocated/mapped per FE */
-
-	struct i2c_adapter i2c_adap;
-	struct pt3_i2cbuf *i2c_buf;
-
-	struct pt3_adapter *adaps[PT3_NUM_FE];
-};
-
-
-/*
- * prototypes
- */
-extern int  pt3_alloc_dmabuf(struct pt3_adapter *adap);
-extern void pt3_init_dmabuf(struct pt3_adapter *adap);
-extern void pt3_free_dmabuf(struct pt3_adapter *adap);
-extern int  pt3_start_dma(struct pt3_adapter *adap);
-extern int  pt3_stop_dma(struct pt3_adapter *adap);
-extern int  pt3_proc_dma(struct pt3_adapter *adap);
+#endif
 
-extern int  pt3_i2c_master_xfer(struct i2c_adapter *adap,
-				struct i2c_msg *msgs, int num);
-extern u32  pt3_i2c_functionality(struct i2c_adapter *adap);
-extern void pt3_i2c_reset(struct pt3_board *pt3);
-extern int  pt3_init_all_demods(struct pt3_board *pt3);
-extern int  pt3_init_all_mxl301rf(struct pt3_board *pt3);
-#endif /* PT3_H */
-- 
1.8.4.5

