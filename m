Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47445 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757652Ab2IJPaR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Sep 2012 11:30:17 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Javier Martin <javier.martin@vista-silicon.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Richard Zhao <richard.zhao@freescale.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v4 16/16] media: coda: support >1024 px height on CODA7, set max frame size to 1080p
Date: Mon, 10 Sep 2012 17:30:00 +0200
Message-Id: <1347291000-340-17-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1347291000-340-1-git-send-email-p.zabel@pengutronix.de>
References: <1347291000-340-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Increases the maximum encoded frame buffer size to 1 MiB.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda.c |   11 +++++------
 drivers/media/platform/coda.h |    3 ++-
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index 4c3e100..defab64 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -47,16 +47,14 @@
 
 #define CODA_MAX_FRAMEBUFFERS	2
 
-#define MAX_W		720
-#define MAX_H		576
-#define CODA_MAX_FRAME_SIZE	0x90000
+#define MAX_W		1920
+#define MAX_H		1080
+#define CODA_MAX_FRAME_SIZE	0x100000
 #define FMO_SLICE_SAVE_BUF_SIZE         (32)
 #define CODA_DEFAULT_GAMMA		4096
 
 #define MIN_W 176
 #define MIN_H 144
-#define MAX_W 720
-#define MAX_H 576
 
 #define S_ALIGN		1 /* multiple of 2 */
 #define W_ALIGN		1 /* multiple of 2 */
@@ -1016,11 +1014,12 @@ static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
 	switch (dev->devtype->product) {
 	case CODA_DX6:
 		value = (q_data_src->width & CODADX6_PICWIDTH_MASK) << CODADX6_PICWIDTH_OFFSET;
+		value |= (q_data_src->height & CODADX6_PICHEIGHT_MASK) << CODA_PICHEIGHT_OFFSET;
 		break;
 	default:
 		value = (q_data_src->width & CODA7_PICWIDTH_MASK) << CODA7_PICWIDTH_OFFSET;
+		value |= (q_data_src->height & CODA7_PICHEIGHT_MASK) << CODA_PICHEIGHT_OFFSET;
 	}
-	value |= (q_data_src->height & CODA_PICHEIGHT_MASK) << CODA_PICHEIGHT_OFFSET;
 	coda_write(dev, value, CODA_CMD_ENC_SEQ_SRC_SIZE);
 	coda_write(dev, ctx->params.framerate,
 		   CODA_CMD_ENC_SEQ_SRC_F_RATE);
diff --git a/drivers/media/platform/coda.h b/drivers/media/platform/coda.h
index f3f5e43..60338c3 100644
--- a/drivers/media/platform/coda.h
+++ b/drivers/media/platform/coda.h
@@ -117,7 +117,8 @@
 #define		CODADX6_PICWIDTH_OFFSET				10
 #define		CODADX6_PICWIDTH_MASK				0x3ff
 #define		CODA_PICHEIGHT_OFFSET				0
-#define		CODA_PICHEIGHT_MASK				0x3ff
+#define		CODADX6_PICHEIGHT_MASK				0x3ff
+#define		CODA7_PICHEIGHT_MASK				0xffff
 #define CODA_CMD_ENC_SEQ_SRC_F_RATE				0x194
 #define CODA_CMD_ENC_SEQ_MP4_PARA				0x198
 #define		CODA_MP4PARAM_VERID_OFFSET			6
-- 
1.7.10.4

