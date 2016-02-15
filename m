Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:46529 "EHLO
	metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751158AbcBOLIX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Feb 2016 06:08:23 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] [media] media-entity: include linux/bug.h for WARN_ON
Date: Mon, 15 Feb 2016 12:08:06 +0100
Message-Id: <1455534486-11012-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

WARN_ON is used by this header file, but none of its direct includes
include asm/bug.h by way of linux/bug.h yet.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 include/media/media-entity.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index fe485d3..ca4e1a6 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -24,6 +24,7 @@
 #define _MEDIA_ENTITY_H
 
 #include <linux/bitmap.h>
+#include <linux/bug.h>
 #include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/media.h>
-- 
2.7.0.rc3

