Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34095 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393AbaJBRI5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Oct 2014 13:08:57 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <k.debski@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	linux-media@vger.kernel.org, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Lucas Stach <l.stach@pengutronix.de>
Subject: [PATCH v2 05/10] [media] coda: add JPEG register definitions for CODA7541
Date: Thu,  2 Oct 2014 19:08:30 +0200
Message-Id: <1412269715-28388-6-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1412269715-28388-1-git-send-email-p.zabel@pengutronix.de>
References: <1412269715-28388-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add JPEG specific sequence initialization registers and bit definitions.

Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda_regs.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/media/platform/coda/coda_regs.h b/drivers/media/platform/coda/coda_regs.h
index c791275..8e015b8 100644
--- a/drivers/media/platform/coda/coda_regs.h
+++ b/drivers/media/platform/coda/coda_regs.h
@@ -147,6 +147,7 @@
 #define CODA_CMD_DEC_SEQ_BB_START		0x180
 #define CODA_CMD_DEC_SEQ_BB_SIZE		0x184
 #define CODA_CMD_DEC_SEQ_OPTION			0x188
+#define		CODA_NO_INT_ENABLE			(1 << 10)
 #define		CODA_REORDER_ENABLE			(1 << 1)
 #define		CODADX6_QP_REPORT			(1 << 0)
 #define		CODA7_MP4_DEBLK_ENABLE			(1 << 0)
@@ -332,6 +333,12 @@
 #define CODA9_CMD_ENC_SEQ_ME_OPTION				0x1d8
 #define CODA_RET_ENC_SEQ_SUCCESS				0x1c0
 
+#define CODA_CMD_ENC_SEQ_JPG_PARA				0x198
+#define CODA_CMD_ENC_SEQ_JPG_RST_INTERVAL			0x19C
+#define CODA_CMD_ENC_SEQ_JPG_THUMB_EN				0x1a0
+#define CODA_CMD_ENC_SEQ_JPG_THUMB_SIZE				0x1a4
+#define CODA_CMD_ENC_SEQ_JPG_THUMB_OFFSET			0x1a8
+
 /* Encoder Picture Run */
 #define CODA9_CMD_ENC_PIC_SRC_INDEX		0x180
 #define CODA9_CMD_ENC_PIC_SRC_STRIDE		0x184
-- 
2.1.0

