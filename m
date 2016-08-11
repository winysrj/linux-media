Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-by2nam03on0054.outbound.protection.outlook.com ([104.47.42.54]:41371
	"EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752203AbcHKGot (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Aug 2016 02:44:49 -0400
From: Liu Ying <gnuiyl@gmail.com>
To: <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 3/3] [media] media-entity.h: remove redundant macro definition for gobj_to_pad()
Date: Thu, 11 Aug 2016 13:10:11 +0800
Message-ID: <1470892211-31387-3-git-send-email-gnuiyl@gmail.com>
In-Reply-To: <1470892211-31387-1-git-send-email-gnuiyl@gmail.com>
References: <1470892211-31387-1-git-send-email-gnuiyl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The macro gobj_to_pad() is defined twice in media-entity.h.
Let's remove one.

Signed-off-by: Liu Ying <gnuiyl@gmail.com>
---
 include/media/media-entity.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index fa874ad..7bf6885 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -520,9 +520,6 @@ static inline bool media_entity_enum_intersects(
 #define gobj_to_link(gobj) \
 		container_of(gobj, struct media_link, graph_obj)
 
-#define gobj_to_pad(gobj) \
-		container_of(gobj, struct media_pad, graph_obj)
-
 #define gobj_to_intf(gobj) \
 		container_of(gobj, struct media_interface, graph_obj)
 
-- 
2.7.4

