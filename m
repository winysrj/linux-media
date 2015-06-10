Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48649 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690AbbFJU7j (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Jun 2015 16:59:39 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 1/2] [media] cx88: don't declare restart_video_queue if not used
Date: Wed, 10 Jun 2015 17:59:14 -0300
Message-Id: <bc5e66bd2591424f0e08d5478a36a8074fe739f5.1433969944.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While compiled on alpha, got this error:
	drivers/media/pci/cx88/cx88-video.c:415:12: warning: 'restart_video_queue' defined but not used [-Wunused-function]

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/pci/cx88/cx88-video.c b/drivers/media/pci/cx88/cx88-video.c
index cebb07d87617..400e5caefd58 100644
--- a/drivers/media/pci/cx88/cx88-video.c
+++ b/drivers/media/pci/cx88/cx88-video.c
@@ -410,7 +410,6 @@ static int stop_video_dma(struct cx8800_dev    *dev)
 	cx_clear(MO_VID_INTMSK, 0x0f0011);
 	return 0;
 }
-#endif
 
 static int restart_video_queue(struct cx8800_dev    *dev,
 			       struct cx88_dmaqueue *q)
@@ -426,6 +425,7 @@ static int restart_video_queue(struct cx8800_dev    *dev,
 	}
 	return 0;
 }
+#endif
 
 /* ------------------------------------------------------------------ */
 
-- 
2.4.2

