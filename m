Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40085 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356AbbHGOUV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Aug 2015 10:20:21 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH RFC v2 11/16] FIXUP: source link removal on failure
Date: Fri,  7 Aug 2015 11:20:09 -0300
Message-Id: <d0f244b77ff1e9741765b2c3c8a764a505509e53.1438954897.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1438954897.git.mchehab@osg.samsung.com>
References: <cover.1438954897.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1438954897.git.mchehab@osg.samsung.com>
References: <cover.1438954897.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index bdeb6e804c7e..43fa8ac59055 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -480,6 +480,9 @@ static struct media_link *media_entity_add_link(struct media_entity *entity)
 	return link;
 }
 
+static void __media_entity_remove_link(struct media_entity *entity,
+				       struct media_link *link);
+
 int
 media_create_pad_link(struct media_entity *source, u16 source_pad,
 			 struct media_entity *sink, u16 sink_pad, u32 flags)
@@ -504,7 +507,7 @@ media_create_pad_link(struct media_entity *source, u16 source_pad,
 	 */
 	backlink = media_entity_add_link(sink);
 	if (backlink == NULL) {
-		source->num_links--;
+		__media_entity_remove_link(source, link);
 		return -ENOMEM;
 	}
 
-- 
2.4.3

