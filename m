Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33731 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbbBRPaM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Feb 2015 10:30:12 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	"Prabhakar Lad" <prabhakar.csengg@gmail.com>
Subject: [PATCH 3/7] [media] tuner-core: fix compilation if the media controller is not defined
Date: Wed, 18 Feb 2015 13:29:57 -0200
Message-Id: <5b078f35e4176dbd2383999289bc9f9651722759.1424273378.git.mchehab@osg.samsung.com>
In-Reply-To: <110dcdca23da9714db1a2d95800abc4c9d33b512.1424273378.git.mchehab@osg.samsung.com>
References: <110dcdca23da9714db1a2d95800abc4c9d33b512.1424273378.git.mchehab@osg.samsung.com>
In-Reply-To: <110dcdca23da9714db1a2d95800abc4c9d33b512.1424273378.git.mchehab@osg.samsung.com>
References: <110dcdca23da9714db1a2d95800abc4c9d33b512.1424273378.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/v4l2-core/tuner-core.c:440:7: error: 'struct v4l2_subdev' has no member named 'entity'
     t->sd.entity.name = t->name;

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/v4l2-core/tuner-core.c b/drivers/media/v4l2-core/tuner-core.c
index 9a83b27a7e8f..abdcffabcb59 100644
--- a/drivers/media/v4l2-core/tuner-core.c
+++ b/drivers/media/v4l2-core/tuner-core.c
@@ -437,7 +437,9 @@ static void set_type(struct i2c_client *c, unsigned int type,
 		t->name = analog_ops->info.name;
 	}
 
+#ifdef CONFIG_MEDIA_CONTROLLER
 	t->sd.entity.name = t->name;
+#endif
 
 	tuner_dbg("type set to %s\n", t->name);
 
-- 
2.1.0

