Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46102 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759435Ab3EWOnJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 May 2013 10:43:09 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Javier Martin <javier.martin@vista-silicon.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 1/9] [media] coda: fix ENC_SEQ_OPTION for CODA7
Date: Thu, 23 May 2013 16:42:53 +0200
Message-Id: <1369320181-17933-2-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1369320181-17933-1-git-send-email-p.zabel@pengutronix.de>
References: <1369320181-17933-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

GAMMA_OFFSET is different between CodaDx6 and CODA7.
Also, this is a bitfield, so drop the various

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda.c | 10 ++++++++--
 drivers/media/platform/coda.h |  8 ++------
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index 22d1b1b..7ac2299 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -1138,8 +1138,14 @@ static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
 	value = (CODA_DEFAULT_GAMMA & CODA_GAMMA_MASK) << CODA_GAMMA_OFFSET;
 	coda_write(dev, value, CODA_CMD_ENC_SEQ_RC_GAMMA);
 
-	value  = (CODA_DEFAULT_GAMMA > 0) << CODA_OPTION_GAMMA_OFFSET;
-	value |= (0 & CODA_OPTION_SLICEREPORT_MASK) << CODA_OPTION_SLICEREPORT_OFFSET;
+	if (CODA_DEFAULT_GAMMA > 0) {
+		if (dev->devtype->product == CODA_DX6)
+			value  = 1 << CODADX6_OPTION_GAMMA_OFFSET;
+		else
+			value  = 1 << CODA7_OPTION_GAMMA_OFFSET;
+	} else {
+		value = 0;
+	}
 	coda_write(dev, value, CODA_CMD_ENC_SEQ_OPTION);
 
 	if (dst_fourcc == V4L2_PIX_FMT_H264) {
diff --git a/drivers/media/platform/coda.h b/drivers/media/platform/coda.h
index f3f5e43..3c350ac 100644
--- a/drivers/media/platform/coda.h
+++ b/drivers/media/platform/coda.h
@@ -96,16 +96,12 @@
 #define CODA_CMD_ENC_SEQ_BB_START				0x180
 #define CODA_CMD_ENC_SEQ_BB_SIZE				0x184
 #define CODA_CMD_ENC_SEQ_OPTION				0x188
-#define		CODA_OPTION_GAMMA_OFFSET			7
-#define		CODA_OPTION_GAMMA_MASK				0x01
+#define		CODA7_OPTION_GAMMA_OFFSET			8
+#define		CODADX6_OPTION_GAMMA_OFFSET			7
 #define		CODA_OPTION_LIMITQP_OFFSET			6
-#define		CODA_OPTION_LIMITQP_MASK			0x01
 #define		CODA_OPTION_RCINTRAQP_OFFSET			5
-#define		CODA_OPTION_RCINTRAQP_MASK			0x01
 #define		CODA_OPTION_FMO_OFFSET				4
-#define		CODA_OPTION_FMO_MASK				0x01
 #define		CODA_OPTION_SLICEREPORT_OFFSET			1
-#define		CODA_OPTION_SLICEREPORT_MASK			0x01
 #define CODA_CMD_ENC_SEQ_COD_STD				0x18c
 #define		CODA_STD_MPEG4					0
 #define		CODA_STD_H263					1
-- 
1.8.2.rc2

