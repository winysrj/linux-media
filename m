Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44181 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755810AbaHZVzW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Aug 2014 17:55:22 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2 12/35] [media] vpif: don't cast pointers to int
Date: Tue, 26 Aug 2014 18:54:48 -0300
Message-Id: <1409090111-8290-13-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1409090111-8290-1-git-send-email-m.chehab@samsung.com>
References: <1409090111-8290-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Shut up several warnings about invalid casting when printing
the values of two pointers.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/platform/davinci/vpfe_capture.c | 2 +-
 drivers/media/platform/davinci/vpif_display.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/davinci/vpfe_capture.c b/drivers/media/platform/davinci/vpfe_capture.c
index ea7661a27479..ed9dd27e3c63 100644
--- a/drivers/media/platform/davinci/vpfe_capture.c
+++ b/drivers/media/platform/davinci/vpfe_capture.c
@@ -1914,7 +1914,7 @@ static int vpfe_probe(struct platform_device *pdev)
 	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev,
 		"trying to register vpfe device.\n");
 	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev,
-		"video_dev=%x\n", (int)&vpfe_dev->video_dev);
+		"video_dev=%p\n", &vpfe_dev->video_dev);
 	vpfe_dev->fmt.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	ret = video_register_device(vpfe_dev->video_dev,
 				    VFL_TYPE_GRABBER, -1);
diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index aaa9ec06630f..2ce3ddfcca80 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -1204,8 +1204,8 @@ static int vpif_probe_complete(void)
 		INIT_LIST_HEAD(&common->dma_queue);
 
 		/* register video device */
-		vpif_dbg(1, debug, "channel=%x,channel->video_dev=%x\n",
-			 (int)ch, (int)&ch->video_dev);
+		vpif_dbg(1, debug, "channel=%p,channel->video_dev=%p\n",
+			 ch, &ch->video_dev);
 
 		/* Initialize the video_device structure */
 		vdev = ch->video_dev;
-- 
1.9.3

