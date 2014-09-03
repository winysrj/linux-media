Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44386 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756136AbaICUda (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Sep 2014 16:33:30 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH 18/46] [media] omap3isp: use true/false for boolean vars
Date: Wed,  3 Sep 2014 17:32:50 -0300
Message-Id: <f9d3de5adb4521bd377c51468b9e941615f861ba.1409775488.git.m.chehab@samsung.com>
In-Reply-To: <cover.1409775488.git.m.chehab@samsung.com>
References: <cover.1409775488.git.m.chehab@samsung.com>
In-Reply-To: <cover.1409775488.git.m.chehab@samsung.com>
References: <cover.1409775488.git.m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using 0 or 1 for boolean, use the true/false
defines.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

diff --git a/drivers/media/platform/omap3isp/ispccdc.c b/drivers/media/platform/omap3isp/ispccdc.c
index cabf46b4b645..81a9dc053d58 100644
--- a/drivers/media/platform/omap3isp/ispccdc.c
+++ b/drivers/media/platform/omap3isp/ispccdc.c
@@ -1806,7 +1806,7 @@ static int ccdc_video_queue(struct isp_video *video, struct isp_buffer *buffer)
 	spin_lock_irqsave(&ccdc->lock, flags);
 	if (ccdc->state == ISP_PIPELINE_STREAM_CONTINUOUS && !ccdc->running &&
 	    ccdc->bt656)
-		restart = 1;
+		restart = true;
 	else
 		ccdc->underrun = 1;
 	spin_unlock_irqrestore(&ccdc->lock, flags);
-- 
1.9.3

