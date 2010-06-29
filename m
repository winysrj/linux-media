Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:57016 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753330Ab0F2Mop (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Jun 2010 08:44:45 -0400
From: Sergio Aguirre <saaguirre@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, Sergio Aguirre <saaguirre@ti.com>
Subject: [media-ctl RFC][PATCH 4/5] media: Add missing linux/types.h include
Date: Tue, 29 Jun 2010 07:43:09 -0500
Message-Id: <1277815390-24681-5-git-send-email-saaguirre@ti.com>
In-Reply-To: <1277815390-24681-1-git-send-email-saaguirre@ti.com>
References: <1277815390-24681-1-git-send-email-saaguirre@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This fixes headers_check warning:

*/usr/include/linux/media.h:25: found __[us]{8,16,32,64} type without #include <linux/types.h>

Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
---
 include/linux/media.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/media.h b/include/linux/media.h
index a44875d..4f39639 100644
--- a/include/linux/media.h
+++ b/include/linux/media.h
@@ -1,6 +1,8 @@
 #ifndef __LINUX_MEDIA_H
 #define __LINUX_MEDIA_H
 
+#include <linux/types.h>
+
 #define MEDIA_ENTITY_TYPE_NODE		1
 #define MEDIA_ENTITY_TYPE_SUBDEV	2
 
-- 
1.6.3.3

