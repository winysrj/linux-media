Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:38049 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729871AbeKFApk (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Nov 2018 19:45:40 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de
Subject: [PATCH 12/15] media: coda: print SEQ_INIT error code as hex value
Date: Mon,  5 Nov 2018 16:25:10 +0100
Message-Id: <20181105152513.26345-12-p.zabel@pengutronix.de>
In-Reply-To: <20181105152513.26345-1-p.zabel@pengutronix.de>
References: <20181105152513.26345-1-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Michael Tretter <m.tretter@pengutronix.de>

The error code looks much more like a bit field than an error value.
Print it as hex rather than decimal.

Signed-off-by: Michael Tretter <m.tretter@pengutronix.de>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-bit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index 348b17140715..53f1a83e72a9 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -1748,7 +1748,7 @@ static int __coda_start_decoding(struct coda_ctx *ctx)
 
 	if (coda_read(dev, CODA_RET_DEC_SEQ_SUCCESS) == 0) {
 		v4l2_err(&dev->v4l2_dev,
-			"CODA_COMMAND_SEQ_INIT failed, error code = %d\n",
+			"CODA_COMMAND_SEQ_INIT failed, error code = 0x%x\n",
 			coda_read(dev, CODA_RET_DEC_SEQ_ERR_REASON));
 		return -EAGAIN;
 	}
-- 
2.19.1
