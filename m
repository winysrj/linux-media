Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55232 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756798AbbAFVJS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Jan 2015 16:09:18 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Ramakrishnan Muthukrishnan <ramakrmu@cisco.com>,
	Boris BREZILLON <boris.brezillon@free-electrons.com>,
	Matthias Schwarzott <zzam@gentoo.org>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCHv3 19/20] cx231xx: create a streaming pipeline at VB start
Date: Tue,  6 Jan 2015 19:08:50 -0200
Message-Id: <9224ddf11a676ba35003c543c05d6e067463eeaa.1420578087.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1420578087.git.mchehab@osg.samsung.com>
References: <cover.1420578087.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1420578087.git.mchehab@osg.samsung.com>
References: <cover.1420578087.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When videobuf starts, create a streaming pipeline,
destroying it when the stream stops.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
index 634763535d60..c5ded52ba7ed 100644
--- a/drivers/media/usb/cx231xx/cx231xx-video.c
+++ b/drivers/media/usb/cx231xx/cx231xx-video.c
@@ -705,11 +705,12 @@ static void free_buffer(struct videobuf_queue *vq, struct cx231xx_buffer *buf)
 
 static int cx231xx_enable_analog_tuner(struct cx231xx *dev)
 {
+	int ret = 0;
 #ifdef CONFIG_MEDIA_CONTROLLER
 	struct media_device *mdev = dev->media_dev;
 	struct media_entity  *entity, *decoder = NULL, *source;
 	struct media_link *link, *found_link = NULL;
-	int i, ret, active_links = 0;
+	int i;
 
 	if (!mdev)
 		return 0;
@@ -733,13 +734,11 @@ static int cx231xx_enable_analog_tuner(struct cx231xx *dev)
 		link = &decoder->links[i];
 		if (link->sink->entity == decoder) {
 			found_link = link;
-			if (link->flags & MEDIA_LNK_FL_ENABLED)
-				active_links++;
 			break;
 		}
 	}
 
-	if (active_links == 1 || !found_link)
+	if (!found_link)
 		return 0;
 
 	source = found_link->source->entity;
@@ -767,8 +766,12 @@ static int cx231xx_enable_analog_tuner(struct cx231xx *dev)
 				source->name, sink->name,
 				flags ? "ENABLED" : "disabled");
 	}
+
+	dev->pipe_start_entity = source;
+	ret = media_entity_pipeline_start(dev->pipe_start_entity, &dev->pipe);
+
 #endif
-	return 0;
+	return ret;
 }
 
 static int
@@ -804,6 +807,10 @@ buffer_prepare(struct videobuf_queue *vq, struct videobuf_buffer *vb,
 		if (!dev->video_mode.bulk_ctl.num_bufs)
 			urb_init = 1;
 	}
+	rc = cx231xx_enable_analog_tuner(dev);
+	if (rc < 0)
+		goto fail;
+
 	dev_dbg(dev->dev,
 		"urb_init=%d dev->video_mode.max_pkt_size=%d\n",
 		urb_init, dev->video_mode.max_pkt_size);
@@ -825,11 +832,15 @@ buffer_prepare(struct videobuf_queue *vq, struct videobuf_buffer *vb,
 
 	buf->vb.state = VIDEOBUF_PREPARED;
 
-	cx231xx_enable_analog_tuner(dev);
-
 	return 0;
 
 fail:
+#ifdef CONFIG_MEDIA_CONTROLLER
+	if (dev->pipe_start_entity) {
+		media_entity_pipeline_stop(dev->pipe_start_entity);
+		dev->pipe_start_entity = NULL;
+	}
+#endif
 	free_buffer(vq, buf);
 	return rc;
 }
@@ -857,6 +868,12 @@ static void buffer_release(struct videobuf_queue *vq,
 
 	cx231xx_isocdbg("cx231xx: called buffer_release\n");
 
+#ifdef CONFIG_MEDIA_CONTROLLER
+	if (dev->pipe_start_entity) {
+		media_entity_pipeline_stop(dev->pipe_start_entity);
+		dev->pipe_start_entity = NULL;
+	}
+#endif
 	free_buffer(vq, buf);
 }
 
diff --git a/drivers/media/usb/cx231xx/cx231xx.h b/drivers/media/usb/cx231xx/cx231xx.h
index e0d3106f6b44..fa5742801169 100644
--- a/drivers/media/usb/cx231xx/cx231xx.h
+++ b/drivers/media/usb/cx231xx/cx231xx.h
@@ -661,6 +661,8 @@ struct cx231xx {
 #if defined(CONFIG_MEDIA_CONTROLLER)
 	struct media_device *media_dev;
 	struct media_pad video_pad, vbi_pad;
+	struct media_pipeline pipe;
+	struct media_entity *pipe_start_entity;
 #endif
 
 	unsigned char eedata[256];
-- 
2.1.0

