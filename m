Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:33929 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933587AbbICQBK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Sep 2015 12:01:10 -0400
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Subject: [PATCH 5/5] [media] smiapp: create pad links after subdev registration
Date: Thu,  3 Sep 2015 18:00:36 +0200
Message-Id: <1441296036-20727-6-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1441296036-20727-1-git-send-email-javier@osg.samsung.com>
References: <1441296036-20727-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The smiapp driver creates the pads links before the media entity is
registered with the media device. This doesn't work now that object
IDs are used to create links so the media_device has to be set.

Move entity registration logic before pads links creation.

Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

---

 drivers/media/i2c/smiapp/smiapp-core.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 5aa49eb393a9..938201789ebc 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2495,23 +2495,23 @@ static int smiapp_register_subdevs(struct smiapp_sensor *sensor)
 			return rval;
 		}
 
-		rval = media_create_pad_link(&this->sd.entity,
-						this->source_pad,
-						&last->sd.entity,
-						last->sink_pad,
-						MEDIA_LNK_FL_ENABLED |
-						MEDIA_LNK_FL_IMMUTABLE);
+		rval = v4l2_device_register_subdev(sensor->src->sd.v4l2_dev,
+						   &this->sd);
 		if (rval) {
 			dev_err(&client->dev,
-				"media_create_pad_link failed\n");
+				"v4l2_device_register_subdev failed\n");
 			return rval;
 		}
 
-		rval = v4l2_device_register_subdev(sensor->src->sd.v4l2_dev,
-						   &this->sd);
+		rval = media_create_pad_link(&this->sd.entity,
+					     this->source_pad,
+					     &last->sd.entity,
+					     last->sink_pad,
+					     MEDIA_LNK_FL_ENABLED |
+					     MEDIA_LNK_FL_IMMUTABLE);
 		if (rval) {
 			dev_err(&client->dev,
-				"v4l2_device_register_subdev failed\n");
+				"media_create_pad_link failed\n");
 			return rval;
 		}
 	}
-- 
2.4.3

