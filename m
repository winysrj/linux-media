Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:8852 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752740Ab3LML4W (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Dec 2013 06:56:22 -0500
Received: from nauris.fi.intel.com (nauris.localdomain [192.168.240.2])
	by paasikivi.fi.intel.com (Postfix) with ESMTP id 7F725200F4
	for <linux-media@vger.kernel.org>; Fri, 13 Dec 2013 13:56:20 +0200 (EET)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/1] media: Include linux/kernel.h for DIV_ROUND_UP()
Date: Fri, 13 Dec 2013 13:58:37 +0200
Message-Id: <1386935917-32088-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

DIV_ROUND_UP() is defined in kernel.h which was not included by
media-entity.h. Do exactly that.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 include/media/media-entity.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 10df551..e004591 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -24,6 +24,7 @@
 #define _MEDIA_ENTITY_H
 
 #include <linux/bitops.h>
+#include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/media.h>
 
-- 
1.8.3.2

