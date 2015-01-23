Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60794 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755557AbbAWQvj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Jan 2015 11:51:39 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <k.debski@samsung.com>
Cc: linux-media@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 01/21] [media] coda: fix encoder rate control parameter masks
Date: Fri, 23 Jan 2015 17:51:15 +0100
Message-Id: <1422031895-7740-2-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1422031895-7740-1-git-send-email-p.zabel@pengutronix.de>
References: <1422031895-7740-1-git-send-email-p.zabel@pengutronix.de>
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
2.1.4

