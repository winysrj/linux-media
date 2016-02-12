Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52108 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbcBLKO5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Feb 2016 05:14:57 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] v4l2-mc: remove the unused sensor var
Date: Fri, 12 Feb 2016 08:13:33 -0200
Message-Id: <ff1ecda875c7278da1b585f0423224f2e645ce96.1455272007.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This fixes this warning:

	v4l2-mc.c: In function 'v4l2_mc_create_media_graph':
	v4l2-mc.c:60:69: warning: variable 'sensor' set but not used [-Wunused-but-set-variable]

We could solve it the other way: don't do the second loop for
webcams. However, that would fail if a chip would have two sensors
plugged. This is not the current case, but it doesn't hurt to be
future-safe here, specially since this code runs only once during
device probe. So, performance is not an issue here.

Reported-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/v4l2-core/v4l2-mc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-mc.c b/drivers/media/v4l2-core/v4l2-mc.c
index ab5e42a86cc5..b61f8d969958 100644
--- a/drivers/media/v4l2-core/v4l2-mc.c
+++ b/drivers/media/v4l2-core/v4l2-mc.c
@@ -96,7 +96,7 @@ int v4l2_mc_create_media_graph(struct media_device *mdev)
 
 {
 	struct media_entity *entity;
-	struct media_entity *if_vid = NULL, *if_aud = NULL, *sensor = NULL;
+	struct media_entity *if_vid = NULL, *if_aud = NULL;
 	struct media_entity *tuner = NULL, *decoder = NULL;
 	struct media_entity *io_v4l = NULL, *io_vbi = NULL, *io_swradio = NULL;
 	bool is_webcam = false;
@@ -130,7 +130,6 @@ int v4l2_mc_create_media_graph(struct media_device *mdev)
 			io_swradio = entity;
 			break;
 		case MEDIA_ENT_F_CAM_SENSOR:
-			sensor = entity;
 			is_webcam = true;
 			break;
 		}
-- 
2.5.0

