Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:35029 "EHLO
	metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759015AbbLBRAU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Dec 2015 12:00:20 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <k.debski@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 4/5] [media] coda: don't start streaming without queued buffers
Date: Wed,  2 Dec 2015 17:58:53 +0100
Message-Id: <1449075534-8072-4-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1449075534-8072-1-git-send-email-p.zabel@pengutronix.de>
References: <1449075534-8072-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We could support start streaming with an empty output queue for the
BIT decoders due to the bitstream buffer which could still contain
data at this point, but there is really no reason for userspace to
expect this to work. Simplify the code by disallowing it.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-common.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 007f458..2452f46 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -1252,6 +1252,9 @@ static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
 	struct vb2_v4l2_buffer *buf;
 	int ret = 0;
 
+	if (count < 1)
+		return -EINVAL;
+
 	q_data_src = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
 	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
 		if (ctx->inst_type == CODA_INST_DECODER && ctx->use_bit) {
@@ -1264,20 +1267,10 @@ static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
 				ret = -EINVAL;
 				goto err;
 			}
-		} else {
-			if (count < 1) {
-				ret = -EINVAL;
-				goto err;
-			}
 		}
 
 		ctx->streamon_out = 1;
 	} else {
-		if (count < 1) {
-			ret = -EINVAL;
-			goto err;
-		}
-
 		ctx->streamon_cap = 1;
 	}
 
-- 
2.6.2

