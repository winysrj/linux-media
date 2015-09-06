Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53826 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827AbbIFRbf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Sep 2015 13:31:35 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH 12/18] [media] media-entity: must check media_create_pad_link()
Date: Sun,  6 Sep 2015 14:30:55 -0300
Message-Id: <4dc311149dc667420c59ba7060846ba993cef507.1441559233.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1441559233.git.mchehab@osg.samsung.com>
References: <cover.1441559233.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1441559233.git.mchehab@osg.samsung.com>
References: <cover.1441559233.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Drivers should check if media_create_pad_link() actually
worked.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 62f882d872b1..8bdc10dcc5e7 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -348,8 +348,9 @@ int media_entity_init(struct media_entity *entity, u16 num_pads,
 		      struct media_pad *pads);
 void media_entity_cleanup(struct media_entity *entity);
 
-int media_create_pad_link(struct media_entity *source, u16 source_pad,
-		struct media_entity *sink, u16 sink_pad, u32 flags);
+__must_check int media_create_pad_link(struct media_entity *source,
+			u16 source_pad,	struct media_entity *sink,
+			u16 sink_pad, u32 flags);
 void __media_entity_remove_links(struct media_entity *entity);
 void media_entity_remove_links(struct media_entity *entity);
 
-- 
2.4.3


