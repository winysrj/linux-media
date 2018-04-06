Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:55396 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756742AbeDFOXf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 6 Apr 2018 10:23:35 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 16/21] media: vpbe_display: get rid of warnings
Date: Fri,  6 Apr 2018 10:23:17 -0400
Message-Id: <d4188068598404b275a16b071b2d50a3bfb3b483.1523024380.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1523024380.git.mchehab@s-opensource.com>
References: <cover.1523024380.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1523024380.git.mchehab@s-opensource.com>
References: <cover.1523024380.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Solve those warnings:

    drivers/media/platform/davinci/vpbe_display.c:288 vpbe_start_streaming() warn: inconsistent indenting
    drivers/media/platform/davinci/vpbe_display.c:1356 register_device() warn: argument 3 to %x specifier is cast from pointer
    drivers/media/platform/davinci/vpbe_display.c:1356 register_device() warn: argument 4 to %x specifier is cast from pointer

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/platform/davinci/vpbe_display.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
index a0b5e670d736..b0eb3d899eb4 100644
--- a/drivers/media/platform/davinci/vpbe_display.c
+++ b/drivers/media/platform/davinci/vpbe_display.c
@@ -285,7 +285,7 @@ static int vpbe_start_streaming(struct vb2_queue *vq, unsigned int count)
 	struct osd_state *osd_device = layer->disp_dev->osd_device;
 	int ret;
 
-	 osd_device->ops.disable_layer(osd_device, layer->layer_info.id);
+	osd_device->ops.disable_layer(osd_device, layer->layer_info.id);
 
 	/* Get the next frame from the buffer queue */
 	layer->next_frm = layer->cur_frm = list_entry(layer->dma_queue.next,
@@ -1354,9 +1354,9 @@ static int register_device(struct vpbe_layer *vpbe_display_layer,
 	v4l2_info(&disp_dev->vpbe_dev->v4l2_dev,
 		  "Trying to register VPBE display device.\n");
 	v4l2_info(&disp_dev->vpbe_dev->v4l2_dev,
-		  "layer=%x,layer->video_dev=%x\n",
-		  (int)vpbe_display_layer,
-		  (int)&vpbe_display_layer->video_dev);
+		  "layer=%p,layer->video_dev=%p\n",
+		  vpbe_display_layer,
+		  &vpbe_display_layer->video_dev);
 
 	vpbe_display_layer->video_dev.queue = &vpbe_display_layer->buffer_queue;
 	err = video_register_device(&vpbe_display_layer->video_dev,
-- 
2.14.3
