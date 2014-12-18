Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54574 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbaLRQuM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Dec 2014 11:50:12 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <k.debski@samsung.com>
Cc: =?UTF-8?q?Fr=C3=A9d=C3=A9ric=20Sureau?=
	<frederic.sureau@vodalys.com>, linux-media@vger.kernel.org,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 1/2] [media] coda: fix encoder rate control parameter masks
Date: Thu, 18 Dec 2014 17:49:59 +0100
Message-Id: <1418921400-724-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch fixes the ENC_SEQ_RC_PARA initial delay and bitrate masks.
These bit fields are 15 bit wide, not 7 bit.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda_regs.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/coda/coda_regs.h b/drivers/media/platform/coda/coda_regs.h
index 8e015b8..7d02624 100644
--- a/drivers/media/platform/coda/coda_regs.h
+++ b/drivers/media/platform/coda/coda_regs.h
@@ -304,9 +304,9 @@
 #define		CODA_RATECONTROL_AUTOSKIP_OFFSET		31
 #define		CODA_RATECONTROL_AUTOSKIP_MASK			0x01
 #define		CODA_RATECONTROL_INITIALDELAY_OFFSET		16
-#define		CODA_RATECONTROL_INITIALDELAY_MASK		0x7f
+#define		CODA_RATECONTROL_INITIALDELAY_MASK		0x7fff
 #define		CODA_RATECONTROL_BITRATE_OFFSET		1
-#define		CODA_RATECONTROL_BITRATE_MASK			0x7f
+#define		CODA_RATECONTROL_BITRATE_MASK			0x7fff
 #define		CODA_RATECONTROL_ENABLE_OFFSET			0
 #define		CODA_RATECONTROL_ENABLE_MASK			0x01
 #define CODA_CMD_ENC_SEQ_RC_BUF_SIZE				0x1b0
-- 
2.1.3

