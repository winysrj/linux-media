Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:61418 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989Ab1HDHO2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Aug 2011 03:14:28 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 14/21] [staging] tm6000: Initialize isochronous transfers only once.
Date: Thu,  4 Aug 2011 09:14:12 +0200
Message-Id: <1312442059-23935-15-git-send-email-thierry.reding@avionic-design.de>
In-Reply-To: <1312442059-23935-1-git-send-email-thierry.reding@avionic-design.de>
References: <1312442059-23935-1-git-send-email-thierry.reding@avionic-design.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This fixes a memory leak where isochronous buffers would be set up for
each video buffer, while it is sufficient to set them up only once per
device.
---
 drivers/staging/tm6000/tm6000-video.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-video.c b/drivers/staging/tm6000/tm6000-video.c
index 4b50f6c..492ec73 100644
--- a/drivers/staging/tm6000/tm6000-video.c
+++ b/drivers/staging/tm6000/tm6000-video.c
@@ -758,7 +758,7 @@ buffer_prepare(struct videobuf_queue *vq, struct videobuf_buffer *vb,
 	struct tm6000_fh     *fh  = vq->priv_data;
 	struct tm6000_buffer *buf = container_of(vb, struct tm6000_buffer, vb);
 	struct tm6000_core   *dev = fh->dev;
-	int rc = 0, urb_init = 0;
+	int rc = 0;
 
 	BUG_ON(NULL == fh->fmt);
 
@@ -784,13 +784,9 @@ buffer_prepare(struct videobuf_queue *vq, struct videobuf_buffer *vb,
 		rc = videobuf_iolock(vq, &buf->vb, NULL);
 		if (rc != 0)
 			goto fail;
-		urb_init = 1;
 	}
 
-	if (!dev->isoc_ctl.num_bufs)
-		urb_init = 1;
-
-	if (urb_init) {
+	if (!dev->isoc_ctl.num_bufs) {
 		rc = tm6000_prepare_isoc(dev);
 		if (rc < 0)
 			goto fail;
-- 
1.7.6

