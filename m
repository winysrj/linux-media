Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46127 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759441Ab3EWOnQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 May 2013 10:43:16 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Javier Martin <javier.martin@vista-silicon.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 2/9] [media] coda: frame stride must be a multiple of 8
Date: Thu, 23 May 2013 16:42:54 +0200
Message-Id: <1369320181-17933-3-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1369320181-17933-1-git-send-email-p.zabel@pengutronix.de>
References: <1369320181-17933-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index 7ac2299..79a81eb 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -422,8 +422,9 @@ static int vidioc_try_fmt(struct coda_dev *dev, struct v4l2_format *f)
 		v4l_bound_align_image(&f->fmt.pix.width, MIN_W, MAX_W,
 				      W_ALIGN, &f->fmt.pix.height,
 				      MIN_H, MAX_H, H_ALIGN, S_ALIGN);
-		f->fmt.pix.bytesperline = round_up(f->fmt.pix.width, 2);
-		f->fmt.pix.sizeimage = f->fmt.pix.width *
+		/* Frame stride must be multiple of 8 */
+		f->fmt.pix.bytesperline = round_up(f->fmt.pix.width, 8);
+		f->fmt.pix.sizeimage = f->fmt.pix.bytesperline *
 					f->fmt.pix.height * 3 / 2;
 	} else { /*encoded formats h.264/mpeg4 */
 		f->fmt.pix.bytesperline = 0;
-- 
1.8.2.rc2

