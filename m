Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:53646 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112AbcCDKNv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Mar 2016 05:13:51 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] v4l2-mc.h: fix PM/pipeline stub definitions
Date: Fri,  4 Mar 2016 11:13:36 +0100
Message-Id: <1457086419-261550-1-git-send-email-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The newly added functions have an extra semicolon, which
prevents compilation, and they need to be marked inline:

In file included from ../include/media/tuner.h:23:0,
                 from ../drivers/media/tuners/tuner-simple.c:10:
../include/media/v4l2-mc.h:233:1: error: expected identifier or '(' before '{' token

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: a77bf7048add ("v4l2-mc.h: Add stubs for the V4L2 PM/pipeline routines")
---
 include/media/v4l2-mc.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/media/v4l2-mc.h b/include/media/v4l2-mc.h
index 96cfca9cd338..6096e635fc9f 100644
--- a/include/media/v4l2-mc.h
+++ b/include/media/v4l2-mc.h
@@ -229,13 +229,13 @@ static inline int v4l_vb2q_enable_media_source(struct vb2_queue *q)
 	return 0;
 }
 
-int v4l2_pipeline_pm_use(struct media_entity *entity, int use);
+static inline int v4l2_pipeline_pm_use(struct media_entity *entity, int use)
 {
 	return 0;
 }
 
-int v4l2_pipeline_link_notify(struct media_link *link, u32 flags,
-			      unsigned int notification);
+static inline int v4l2_pipeline_link_notify(struct media_link *link, u32 flags,
+			      unsigned int notification)
 {
 	return 0;
 }
-- 
2.7.0

