Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46103 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759436Ab3EWOnK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 May 2013 10:43:10 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Javier Martin <javier.martin@vista-silicon.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 3/9] [media] coda: stop setting bytesused in buf_prepare
Date: Thu, 23 May 2013 16:42:55 +0200
Message-Id: <1369320181-17933-4-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1369320181-17933-1-git-send-email-p.zabel@pengutronix.de>
References: <1369320181-17933-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The application must have filled the bytesused field,
don't overwrite it here.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index 79a81eb..3be56b0 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -878,8 +878,6 @@ static int coda_buf_prepare(struct vb2_buffer *vb)
 		return -EINVAL;
 	}
 
-	vb2_set_plane_payload(vb, 0, q_data->sizeimage);
-
 	return 0;
 }
 
-- 
1.8.2.rc2

