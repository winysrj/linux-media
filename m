Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44557 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753444AbaFMQJO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Jun 2014 12:09:14 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 29/30] [media] coda: increase frame stride to 16 for h.264
Date: Fri, 13 Jun 2014 18:08:55 +0200
Message-Id: <1402675736-15379-30-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1402675736-15379-1-git-send-email-p.zabel@pengutronix.de>
References: <1402675736-15379-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When encoding into h.264, the input frame stride needs to be a multiple of 16.
During allocation of the input buffers, it may not be known yet whether the
encoder should create h.264 or not. Assume the worst and always use a frame
stride that is a multiple of 16.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index c65047f..aabd639d 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -687,8 +687,8 @@ static int coda_try_fmt(struct coda_ctx *ctx, struct coda_codec *codec,
 	switch (f->fmt.pix.pixelformat) {
 	case V4L2_PIX_FMT_YUV420:
 	case V4L2_PIX_FMT_YVU420:
-		/* Frame stride must be multiple of 8 */
-		f->fmt.pix.bytesperline = round_up(f->fmt.pix.width, 8);
+		/* Frame stride must be multiple of 8, but 16 for h.264 */
+		f->fmt.pix.bytesperline = round_up(f->fmt.pix.width, 16);
 		f->fmt.pix.sizeimage = f->fmt.pix.bytesperline *
 					f->fmt.pix.height * 3 / 2;
 		break;
-- 
2.0.0.rc2

