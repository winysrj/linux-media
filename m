Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:43394 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727291AbeIPBer (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 15 Sep 2018 21:34:47 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Shuah Khan <shuah@kernel.org>,
        Pravin Shedge <pravin.shedge4linux@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH v2 04/14] media: v4l2-mc: add print messages when media graph fails
Date: Sat, 15 Sep 2018 17:14:19 -0300
Message-Id: <e6aa4ee2950108da974c410cdf909341fcd0d67d.1537042262.git.mchehab+samsung@kernel.org>
In-Reply-To: <cover.1537042262.git.mchehab+samsung@kernel.org>
References: <cover.1537042262.git.mchehab+samsung@kernel.org>
In-Reply-To: <cover.1537042262.git.mchehab+samsung@kernel.org>
References: <cover.1537042262.git.mchehab+samsung@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It is not trivial to debug troubles at media graph build.
So, add print messages to help debug what's happening,
in the case of an error occurs.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/v4l2-core/v4l2-mc.c | 80 +++++++++++++++++++++++--------
 1 file changed, 61 insertions(+), 19 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-mc.c b/drivers/media/v4l2-core/v4l2-mc.c
index 3d868f071dd7..03f41c3fb8ec 100644
--- a/drivers/media/v4l2-core/v4l2-mc.c
+++ b/drivers/media/v4l2-core/v4l2-mc.c
@@ -63,8 +63,10 @@ int v4l2_mc_create_media_graph(struct media_device *mdev)
 	}
 
 	/* It should have at least one I/O entity */
-	if (!io_v4l && !io_vbi && !io_swradio)
+	if (!io_v4l && !io_vbi && !io_swradio) {
+		dev_warn(mdev->dev, "Didn't find any I/O entity\n");
 		return -EINVAL;
+	}
 
 	/*
 	 * Here, webcams are modelled on a very simple way: the sensor is
@@ -74,8 +76,10 @@ int v4l2_mc_create_media_graph(struct media_device *mdev)
 	 * PC-consumer's hardware.
 	 */
 	if (is_webcam) {
-		if (!io_v4l)
+		if (!io_v4l) {
+			dev_warn(mdev->dev, "Didn't find a MEDIA_ENT_F_IO_V4L\n");
 			return -EINVAL;
+		}
 
 		media_device_for_each_entity(entity, mdev) {
 			if (entity->function != MEDIA_ENT_F_CAM_SENSOR)
@@ -83,16 +87,20 @@ int v4l2_mc_create_media_graph(struct media_device *mdev)
 			ret = media_create_pad_link(entity, 0,
 						    io_v4l, 0,
 						    MEDIA_LNK_FL_ENABLED);
-			if (ret)
+			if (ret) {
+				dev_warn(mdev->dev, "Failed to create a sensor link\n");
 				return ret;
+			}
 		}
 		if (!decoder)
 			return 0;
 	}
 
 	/* The device isn't a webcam. So, it should have a decoder */
-	if (!decoder)
+	if (!decoder) {
+		dev_warn(mdev->dev, "Decoder not found\n");
 		return -EINVAL;
+	}
 
 	/* Link the tuner and IF video output pads */
 	if (tuner) {
@@ -101,32 +109,45 @@ int v4l2_mc_create_media_graph(struct media_device *mdev)
 							 PAD_SIGNAL_ANALOG);
 			pad_sink = media_get_pad_index(if_vid, true,
 						       PAD_SIGNAL_ANALOG);
-			if (pad_source < 0 || pad_sink < 0)
+			if (pad_source < 0 || pad_sink < 0) {
+				dev_warn(mdev->dev, "Couldn't get tuner and/or PLL pad(s): (%d, %d)\n",
+					 pad_source, pad_sink);
 				return -EINVAL;
+			}
 			ret = media_create_pad_link(tuner, pad_source,
 						    if_vid, pad_sink,
 						    MEDIA_LNK_FL_ENABLED);
-			if (ret)
+			if (ret) {
+				dev_warn(mdev->dev, "Couldn't create tuner->PLL link)\n");
 				return ret;
+			}
 
 			pad_source = media_get_pad_index(if_vid, false,
 							 PAD_SIGNAL_ANALOG);
 			pad_sink = media_get_pad_index(decoder, true,
 						       PAD_SIGNAL_ANALOG);
-			if (pad_source < 0 || pad_sink < 0)
+			if (pad_source < 0 || pad_sink < 0) {
+				dev_warn(mdev->dev, "get decoder and/or PLL pad(s): (%d, %d)\n",
+					 pad_source, pad_sink);
 				return -EINVAL;
+			}
 			ret = media_create_pad_link(if_vid, pad_source,
 						decoder, pad_sink,
 						MEDIA_LNK_FL_ENABLED);
-			if (ret)
+			if (ret) {
+				dev_warn(mdev->dev, "couldn't link PLL to decoder\n");
 				return ret;
+			}
 		} else {
 			pad_source = media_get_pad_index(tuner, false,
 							 PAD_SIGNAL_ANALOG);
 			pad_sink = media_get_pad_index(decoder, true,
 						       PAD_SIGNAL_ANALOG);
-			if (pad_source < 0 || pad_sink < 0)
+			if (pad_source < 0 || pad_sink < 0) {
+				dev_warn(mdev->dev, "couldn't get tuner and/or decoder pad(s): (%d, %d)\n",
+					 pad_source, pad_sink);
 				return -EINVAL;
+			}
 			ret = media_create_pad_link(tuner, pad_source,
 						decoder, pad_sink,
 						MEDIA_LNK_FL_ENABLED);
@@ -139,13 +160,18 @@ int v4l2_mc_create_media_graph(struct media_device *mdev)
 							 PAD_SIGNAL_AUDIO);
 			pad_sink = media_get_pad_index(if_aud, true,
 						       PAD_SIGNAL_AUDIO);
-			if (pad_source < 0 || pad_sink < 0)
+			if (pad_source < 0 || pad_sink < 0) {
+				dev_warn(mdev->dev, "couldn't get tuner and/or decoder pad(s) for audio: (%d, %d)\n",
+					 pad_source, pad_sink);
 				return -EINVAL;
+			}
 			ret = media_create_pad_link(tuner, pad_source,
 						    if_aud, pad_sink,
 						    MEDIA_LNK_FL_ENABLED);
-			if (ret)
+			if (ret) {
+				dev_warn(mdev->dev, "couldn't link tuner->audio PLL\n");
 				return ret;
+			}
 		} else {
 			if_aud = tuner;
 		}
@@ -155,35 +181,47 @@ int v4l2_mc_create_media_graph(struct media_device *mdev)
 	/* Create demod to V4L, VBI and SDR radio links */
 	if (io_v4l) {
 		pad_source = media_get_pad_index(decoder, false, PAD_SIGNAL_DV);
-		if (pad_source < 0)
+		if (pad_source < 0) {
+			dev_warn(mdev->dev, "couldn't get decoder output pad for V4L I/O\n");
 			return -EINVAL;
+		}
 		ret = media_create_pad_link(decoder, pad_source,
 					io_v4l, 0,
 					MEDIA_LNK_FL_ENABLED);
-		if (ret)
+		if (ret) {
+			dev_warn(mdev->dev, "couldn't link decoder output to V4L I/O\n");
 			return ret;
+		}
 	}
 
 	if (io_swradio) {
 		pad_source = media_get_pad_index(decoder, false, PAD_SIGNAL_DV);
-		if (pad_source < 0)
+		if (pad_source < 0) {
+			dev_warn(mdev->dev, "couldn't get decoder output pad for SDR\n");
 			return -EINVAL;
+		}
 		ret = media_create_pad_link(decoder, pad_source,
 					io_swradio, 0,
 					MEDIA_LNK_FL_ENABLED);
-		if (ret)
+		if (ret) {
+			dev_warn(mdev->dev, "couldn't link decoder output to SDR\n");
 			return ret;
+		}
 	}
 
 	if (io_vbi) {
 		pad_source = media_get_pad_index(decoder, false, PAD_SIGNAL_DV);
-		if (pad_source < 0)
+		if (pad_source < 0) {
+			dev_warn(mdev->dev, "couldn't get decoder output pad for VBI\n");
 			return -EINVAL;
+		}
 		ret = media_create_pad_link(decoder, pad_source,
 					    io_vbi, 0,
 					    MEDIA_LNK_FL_ENABLED);
-		if (ret)
+		if (ret) {
+			dev_warn(mdev->dev, "couldn't link decoder output to VBI\n");
 			return ret;
+		}
 	}
 
 	/* Create links for the media connectors */
@@ -195,8 +233,10 @@ int v4l2_mc_create_media_graph(struct media_device *mdev)
 				continue;
 			pad_sink = media_get_pad_index(tuner, true,
 							 PAD_SIGNAL_ANALOG);
-			if (pad_sink < 0)
+			if (pad_sink < 0) {
+				dev_warn(mdev->dev, "couldn't get tuner analog pad sink\n");
 				return -EINVAL;
+			}
 			ret = media_create_pad_link(entity, 0, tuner,
 						    pad_sink,
 						    flags);
@@ -205,8 +245,10 @@ int v4l2_mc_create_media_graph(struct media_device *mdev)
 		case MEDIA_ENT_F_CONN_COMPOSITE:
 			pad_sink = media_get_pad_index(decoder, true,
 						       PAD_SIGNAL_ANALOG);
-			if (pad_sink < 0)
+			if (pad_sink < 0) {
+				dev_warn(mdev->dev, "couldn't get tuner analog pad sink\n");
 				return -EINVAL;
+			}
 			ret = media_create_pad_link(entity, 0, decoder,
 						    pad_sink,
 						    flags);
-- 
2.17.1
