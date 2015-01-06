Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54981 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756754AbbAFVJI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Jan 2015 16:09:08 -0500
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
	Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCHv3 18/20] cx231xx: enable tuner->decoder link at videobuf start
Date: Tue,  6 Jan 2015 19:08:49 -0200
Message-Id: <a1fa09af2da026204f2b0d7eebcad14149a0f880.1420578087.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1420578087.git.mchehab@osg.samsung.com>
References: <cover.1420578087.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1420578087.git.mchehab@osg.samsung.com>
References: <cover.1420578087.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The tuner->decoder needs to be enabled when we're about to
start streaming.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
index f3d1a488dfa7..634763535d60 100644
--- a/drivers/media/usb/cx231xx/cx231xx-video.c
+++ b/drivers/media/usb/cx231xx/cx231xx-video.c
@@ -703,6 +703,74 @@ static void free_buffer(struct videobuf_queue *vq, struct cx231xx_buffer *buf)
 	buf->vb.state = VIDEOBUF_NEEDS_INIT;
 }
 
+static int cx231xx_enable_analog_tuner(struct cx231xx *dev)
+{
+#ifdef CONFIG_MEDIA_CONTROLLER
+	struct media_device *mdev = dev->media_dev;
+	struct media_entity  *entity, *decoder = NULL, *source;
+	struct media_link *link, *found_link = NULL;
+	int i, ret, active_links = 0;
+
+	if (!mdev)
+		return 0;
+
+/*
+ * This will find the tuner that it is connected into the decoder.
+ * Technically, this is not 100% correct, as the device may be using an
+ * analog input instead of the tuner. However, we can't use the DVB for dvb
+ * while the DMA engine is being used for V4L2.
+ */
+	media_device_for_each_entity(entity, mdev) {
+		if (entity->type == MEDIA_ENT_T_V4L2_SUBDEV_DECODER) {
+			decoder = entity;
+			break;
+		}
+	}
+	if (!decoder)
+		return 0;
+
+	for (i = 0; i < decoder->num_links; i++) {
+		link = &decoder->links[i];
+		if (link->sink->entity == decoder) {
+			found_link = link;
+			if (link->flags & MEDIA_LNK_FL_ENABLED)
+				active_links++;
+			break;
+		}
+	}
+
+	if (active_links == 1 || !found_link)
+		return 0;
+
+	source = found_link->source->entity;
+	for (i = 0; i < source->num_links; i++) {
+		struct media_entity *sink;
+		int flags = 0;
+
+		link = &source->links[i];
+		sink = link->sink->entity;
+
+		if (sink == entity)
+			flags = MEDIA_LNK_FL_ENABLED;
+
+		ret = media_entity_setup_link(link, flags);
+		if (ret) {
+			dev_err(dev->dev,
+				"Couldn't change link %s->%s to %s. Error %d\n",
+				source->name, sink->name,
+				flags ? "enabled" : "disabled",
+				ret);
+			return ret;
+		} else
+			dev_dbg(dev->dev,
+				"link %s->%s was %s\n",
+				source->name, sink->name,
+				flags ? "ENABLED" : "disabled");
+	}
+#endif
+	return 0;
+}
+
 static int
 buffer_prepare(struct videobuf_queue *vq, struct videobuf_buffer *vb,
 	       enum v4l2_field field)
@@ -756,6 +824,9 @@ buffer_prepare(struct videobuf_queue *vq, struct videobuf_buffer *vb,
 	}
 
 	buf->vb.state = VIDEOBUF_PREPARED;
+
+	cx231xx_enable_analog_tuner(dev);
+
 	return 0;
 
 fail:
-- 
2.1.0

