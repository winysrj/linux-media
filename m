Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42421 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755918AbcA2MMM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jan 2016 07:12:12 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Eduard Gavin <egavinc@gmail.com>
Subject: [PATCH 09/13] [media] tvp5150: create the expected number of pads
Date: Fri, 29 Jan 2016 10:10:59 -0200
Message-Id: <32df4e6a3064a77fddf57a3c9816e3f0e2d0b8b4.1454067262.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1454067262.git.mchehab@osg.samsung.com>
References: <cover.1454067262.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1454067262.git.mchehab@osg.samsung.com>
References: <cover.1454067262.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The tvp5150 doesn't have just one pad. It has 3 ones:
	- IF input
	- Video output
	- VBI output

Fix it and use the macros for the pad indexes.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/i2c/tvp5150.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index 0ad122fcd632..20428f052506 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -16,6 +16,7 @@
 #include <media/i2c/tvp5150.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-of.h>
+#include <media/v4l2-mc.h>
 
 #include "tvp5150_reg.h"
 
@@ -37,7 +38,9 @@ MODULE_PARM_DESC(debug, "Debug level (0-2)");
 
 struct tvp5150 {
 	struct v4l2_subdev sd;
-	struct media_pad pad;
+#ifdef CONFIG_MEDIA_CONTROLLER
+	struct media_pad pads[DEMOD_NUM_PADS];
+#endif
 	struct v4l2_ctrl_handler hdl;
 	struct v4l2_rect rect;
 
@@ -1313,8 +1316,10 @@ static int tvp5150_probe(struct i2c_client *c,
 	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
 
 #if defined(CONFIG_MEDIA_CONTROLLER)
-	core->pad.flags = MEDIA_PAD_FL_SOURCE;
-	res = media_entity_pads_init(&sd->entity, 1, &core->pad);
+	core->pads[DEMOD_PAD_IF_INPUT].flags = MEDIA_PAD_FL_SINK;
+	core->pads[DEMOD_PAD_VID_OUT].flags = MEDIA_PAD_FL_SOURCE;
+	core->pads[DEMOD_PAD_VBI_OUT].flags = MEDIA_PAD_FL_SOURCE;
+	res = media_entity_pads_init(&sd->entity, DEMOD_NUM_PADS, core->pads);
 	if (res < 0)
 		return res;
 #endif
-- 
2.5.0


