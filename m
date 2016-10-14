Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59186 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757068AbcJNUWn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 16:22:43 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH 25/57] [media] omap: don't break long lines
Date: Fri, 14 Oct 2016 17:20:13 -0300
Message-Id: <eac003348c8fc7309c6a10701e79489074391227.1476475771.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476475770.git.mchehab@s-opensource.com>
References: <cover.1476475770.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476475770.git.mchehab@s-opensource.com>
References: <cover.1476475770.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Due to the 80-cols checkpatch warnings, several strings
were broken into multiple lines. This is not considered
a good practice anymore, as it makes harder to grep for
strings at the source code. So, join those continuation
lines.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/platform/omap/omap_vout.c      | 12 ++++--------
 drivers/media/platform/omap/omap_vout_vrfb.c |  3 +--
 2 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/media/platform/omap/omap_vout.c b/drivers/media/platform/omap/omap_vout.c
index e668dde6d857..ab0b941c64a4 100644
--- a/drivers/media/platform/omap/omap_vout.c
+++ b/drivers/media/platform/omap/omap_vout.c
@@ -1657,8 +1657,7 @@ static int vidioc_streamoff(struct file *file, void *fh, enum v4l2_buf_type i)
 	/* Turn of the pipeline */
 	ret = omapvid_apply_changes(vout);
 	if (ret)
-		v4l2_err(&vout->vid_dev->v4l2_dev, "failed to change mode in"
-				" streamoff\n");
+		v4l2_err(&vout->vid_dev->v4l2_dev, "failed to change mode in streamoff\n");
 
 	INIT_LIST_HEAD(&vout->dma_queue);
 	ret = videobuf_streamoff(&vout->vbq);
@@ -1858,8 +1857,7 @@ static int __init omap_vout_setup_video_data(struct omap_vout_device *vout)
 	vfd = vout->vfd = video_device_alloc();
 
 	if (!vfd) {
-		printk(KERN_ERR VOUT_NAME ": could not allocate"
-				" video device struct\n");
+		printk(KERN_ERR VOUT_NAME ": could not allocate video device struct\n");
 		v4l2_ctrl_handler_free(hdl);
 		return -ENOMEM;
 	}
@@ -1984,16 +1982,14 @@ static int __init omap_vout_create_video_devices(struct platform_device *pdev)
 		 */
 		vfd = vout->vfd;
 		if (video_register_device(vfd, VFL_TYPE_GRABBER, -1) < 0) {
-			dev_err(&pdev->dev, ": Could not register "
-					"Video for Linux device\n");
+			dev_err(&pdev->dev, ": Could not register Video for Linux device\n");
 			vfd->minor = -1;
 			ret = -ENODEV;
 			goto error2;
 		}
 		video_set_drvdata(vfd, vout);
 
-		dev_info(&pdev->dev, ": registered and initialized"
-				" video device %d\n", vfd->minor);
+		dev_info(&pdev->dev, ": registered and initialized video device %d\n", vfd->minor);
 		if (k == (pdev->num_resources - 1))
 			return 0;
 
diff --git a/drivers/media/platform/omap/omap_vout_vrfb.c b/drivers/media/platform/omap/omap_vout_vrfb.c
index b8638e4e1627..19768f249192 100644
--- a/drivers/media/platform/omap/omap_vout_vrfb.c
+++ b/drivers/media/platform/omap/omap_vout_vrfb.c
@@ -139,8 +139,7 @@ int omap_vout_setup_vrfb_bufs(struct platform_device *pdev, int vid_num,
 			(void *) &vout->vrfb_dma_tx, &vout->vrfb_dma_tx.dma_ch);
 	if (ret < 0) {
 		vout->vrfb_dma_tx.req_status = DMA_CHAN_NOT_ALLOTED;
-		dev_info(&pdev->dev, ": failed to allocate DMA Channel for"
-				" video%d\n", vfd->minor);
+		dev_info(&pdev->dev, ": failed to allocate DMA Channel for video%d\n", vfd->minor);
 	}
 	init_waitqueue_head(&vout->vrfb_dma_tx.wait);
 
-- 
2.7.4


