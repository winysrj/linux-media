Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60806 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755587AbbAWQvj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Jan 2015 11:51:39 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <k.debski@samsung.com>
Cc: linux-media@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 07/21] [media] coda: fix try_fmt_vid_out colorspace setting
Date: Fri, 23 Jan 2015 17:51:21 +0100
Message-Id: <1422031895-7740-8-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1422031895-7740-1-git-send-email-p.zabel@pengutronix.de>
References: <1422031895-7740-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v4l2-compliance complains about invalid colorspace settings being accepted
on the output side. This patch only allows REC709 and JPEG.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-common.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index ea54337..af8a4d6 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -592,7 +592,11 @@ static int coda_try_fmt_vid_out(struct file *file, void *priv,
 	if (ret < 0)
 		return ret;
 
-	if (!f->fmt.pix.colorspace) {
+	switch (f->fmt.pix.colorspace) {
+	case V4L2_COLORSPACE_REC709:
+	case V4L2_COLORSPACE_JPEG:
+		break;
+	default:
 		if (f->fmt.pix.pixelformat == V4L2_PIX_FMT_JPEG)
 			f->fmt.pix.colorspace = V4L2_COLORSPACE_JPEG;
 		else
-- 
2.1.4

