Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39977 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299AbbLKUSH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Dec 2015 15:18:07 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 1/2] [media] media-device.h: remove extra blank lines
Date: Fri, 11 Dec 2015 18:17:52 -0200
Message-Id: <1cb01ccf2694e93040738f4dd12a86bcf8ce4994.1449865071.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

No functional changes.

Suggested-by:  Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 include/media/media-device.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/media/media-device.h b/include/media/media-device.h
index 3448ad6320c4..b0594be5d631 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -467,8 +467,6 @@ struct media_device *media_device_find_devres(struct device *dev);
 /* Iterate over all links. */
 #define media_device_for_each_link(link, mdev)			\
 	list_for_each_entry(link, &(mdev)->links, graph_obj.list)
-
-
 #else
 static inline int media_device_register(struct media_device *mdev)
 {
-- 
2.5.0

