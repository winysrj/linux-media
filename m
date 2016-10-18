Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51557 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935002AbcJRUqW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Oct 2016 16:46:22 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: [PATCH v2 23/58] omap: don't break long lines
Date: Tue, 18 Oct 2016 18:45:35 -0200
Message-Id: <a17578581d094e95c95baf83f20b712fd913c0f5.1476822924.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476822924.git.mchehab@s-opensource.com>
References: <cover.1476822924.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476822924.git.mchehab@s-opensource.com>
References: <cover.1476822924.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Due to the 80-cols restrictions, and latter due to checkpatch
warnings, several strings were broken into multiple lines. This
is not considered a good practice anymore, as it makes harder
to grep for strings at the source code.

As we're right now fixing other drivers due to KERN_CONT, we need
to be able to identify what printk strings don't end with a "\n".
It is a way easier to detect those if we don't break long lines.

So, join those continuation lines.

The patch was generated via the script below, and manually
adjusted if needed.

</script>
use Text::Tabs;
while (<>) {
	if ($next ne "") {
		$c=$_;
		if ($c =~ /^\s+\"(.*)/) {
			$c2=$1;
			$next =~ s/\"\n$//;
			$n = expand($next);
			$funpos = index($n, '(');
			$pos = index($c2, '",');
			if ($funpos && $pos > 0) {
				$s1 = substr $c2, 0, $pos + 2;
				$s2 = ' ' x ($funpos + 1) . substr $c2, $pos + 2;
				$s2 =~ s/^\s+//;

				$s2 = ' ' x ($funpos + 1) . $s2 if ($s2 ne "");

				print unexpand("$next$s1\n");
				print unexpand("$s2\n") if ($s2 ne "");
			} else {
				print "$next$c2\n";
			}
			$next="";
			next;
		} else {
			print $next;
		}
		$next="";
	} else {
		if (m/\"$/) {
			if (!m/\\n\"$/) {
				$next=$_;
				next;
			}
		}
	}
	print $_;
}
</script>

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/platform/omap/omap_vout.c      | 24 +++++++++++++-----------
 drivers/media/platform/omap/omap_vout_vrfb.c |  5 +++--
 2 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/media/platform/omap/omap_vout.c b/drivers/media/platform/omap/omap_vout.c
index e668dde6d857..c39b5463e0b3 100644
--- a/drivers/media/platform/omap/omap_vout.c
+++ b/drivers/media/platform/omap/omap_vout.c
@@ -408,8 +408,8 @@ static int omapvid_setup_overlay(struct omap_vout_device *vout,
 	v4l2_dbg(1, debug, &vout->vid_dev->v4l2_dev,
 		"%s enable=%d addr=%pad width=%d\n height=%d color_mode=%d\n"
 		"rotation=%d mirror=%d posx=%d posy=%d out_width = %d \n"
-		"out_height=%d rotation_type=%d screen_width=%d\n",
-		__func__, ovl->is_enabled(ovl), &info.paddr, info.width, info.height,
+		"out_height=%d rotation_type=%d screen_width=%d\n", __func__,
+		ovl->is_enabled(ovl), &info.paddr, info.width, info.height,
 		info.color_mode, info.rotation, info.mirror, info.pos_x,
 		info.pos_y, info.out_width, info.out_height, info.rotation_type,
 		info.screen_width);
@@ -791,7 +791,8 @@ static int omap_vout_buffer_prepare(struct videobuf_queue *q,
 		dma_addr = dma_map_single(vout->vid_dev->v4l2_dev.dev, (void *) addr,
 				size, DMA_TO_DEVICE);
 		if (dma_mapping_error(vout->vid_dev->v4l2_dev.dev, dma_addr))
-			v4l2_err(&vout->vid_dev->v4l2_dev, "dma_map_single failed\n");
+			v4l2_err(&vout->vid_dev->v4l2_dev,
+				 "dma_map_single failed\n");
 
 		vout->queued_buf_addr[vb->i] = (u8 *)vout->buf_phy_addr[vb->i];
 	}
@@ -1657,8 +1658,8 @@ static int vidioc_streamoff(struct file *file, void *fh, enum v4l2_buf_type i)
 	/* Turn of the pipeline */
 	ret = omapvid_apply_changes(vout);
 	if (ret)
-		v4l2_err(&vout->vid_dev->v4l2_dev, "failed to change mode in"
-				" streamoff\n");
+		v4l2_err(&vout->vid_dev->v4l2_dev,
+			 "failed to change mode in streamoff\n");
 
 	INIT_LIST_HEAD(&vout->dma_queue);
 	ret = videobuf_streamoff(&vout->vbq);
@@ -1858,8 +1859,8 @@ static int __init omap_vout_setup_video_data(struct omap_vout_device *vout)
 	vfd = vout->vfd = video_device_alloc();
 
 	if (!vfd) {
-		printk(KERN_ERR VOUT_NAME ": could not allocate"
-				" video device struct\n");
+		printk(KERN_ERR VOUT_NAME
+		       ": could not allocate video device struct\n");
 		v4l2_ctrl_handler_free(hdl);
 		return -ENOMEM;
 	}
@@ -1984,16 +1985,17 @@ static int __init omap_vout_create_video_devices(struct platform_device *pdev)
 		 */
 		vfd = vout->vfd;
 		if (video_register_device(vfd, VFL_TYPE_GRABBER, -1) < 0) {
-			dev_err(&pdev->dev, ": Could not register "
-					"Video for Linux device\n");
+			dev_err(&pdev->dev,
+				": Could not register Video for Linux device\n");
 			vfd->minor = -1;
 			ret = -ENODEV;
 			goto error2;
 		}
 		video_set_drvdata(vfd, vout);
 
-		dev_info(&pdev->dev, ": registered and initialized"
-				" video device %d\n", vfd->minor);
+		dev_info(&pdev->dev,
+			 ": registered and initialized video device %d\n",
+			 vfd->minor);
 		if (k == (pdev->num_resources - 1))
 			return 0;
 
diff --git a/drivers/media/platform/omap/omap_vout_vrfb.c b/drivers/media/platform/omap/omap_vout_vrfb.c
index b8638e4e1627..92c4e1826356 100644
--- a/drivers/media/platform/omap/omap_vout_vrfb.c
+++ b/drivers/media/platform/omap/omap_vout_vrfb.c
@@ -139,8 +139,9 @@ int omap_vout_setup_vrfb_bufs(struct platform_device *pdev, int vid_num,
 			(void *) &vout->vrfb_dma_tx, &vout->vrfb_dma_tx.dma_ch);
 	if (ret < 0) {
 		vout->vrfb_dma_tx.req_status = DMA_CHAN_NOT_ALLOTED;
-		dev_info(&pdev->dev, ": failed to allocate DMA Channel for"
-				" video%d\n", vfd->minor);
+		dev_info(&pdev->dev,
+			 ": failed to allocate DMA Channel for video%d\n",
+			 vfd->minor);
 	}
 	init_waitqueue_head(&vout->vrfb_dma_tx.wait);
 
-- 
2.7.4


