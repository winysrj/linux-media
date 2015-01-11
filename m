Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51604 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040AbbAKPo0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Jan 2015 10:44:26 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH v3] Fix ALSA and DVB representation at media controller API
Date: Sun, 11 Jan 2015 13:44:20 -0200
Message-Id: <78ac77441901e13e907817d7e8a2ddd68e7afe0d.1420990746.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The previous provision for DVB media controller support were to
define an ID (likely meaning the adapter number) for the DVB
devnodes.

This is just plain wrong. Just like V4L, DVB devices (and ALSA,
or whatever) are identified via a (major, minor) tuple.

This is enough to uniquely identify a devnode, no matter what
API it implements.

So, before we go too far, let's mark the old v4l, dvb and alsa
"devnode" info as deprecated, and just call it as "dev".

As we don't want to break compilation on already existing apps,
let's just keep the old definitions as-is, adding a note that
those are deprecated at media-entity.h.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

-

Laurent,

If you accept this patch, I'll respin the DVB media controller series
accordingly, and add the missing bits for DVB media controller at
at the documentation.

Regards,
Mauro

diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index e00459185d20..3c3d9d25eb2f 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -83,7 +83,16 @@ struct media_entity {
 	struct media_pipeline *pipe;	/* Pipeline this entity belongs to. */
 
 	union {
-		/* Node specifications */
+		/* For all devnode types */
+		struct {
+			u32 major;
+			u32 minor;
+		} dev;
+
+		/* Sub-device specifications */
+		/* Nothing needed yet */
+
+		/* DEPRECATED: Old node specifications */
 		struct {
 			u32 major;
 			u32 minor;
@@ -98,9 +107,6 @@ struct media_entity {
 			u32 subdevice;
 		} alsa;
 		int dvb;
-
-		/* Sub-device specifications */
-		/* Nothing needed yet */
 	} info;
 };
 
-- 
2.1.0

