Return-path: <linux-media-owner@vger.kernel.org>
Received: from www17.your-server.de ([213.133.104.17]:40520 "EHLO
        www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756962AbdIHTq1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Sep 2017 15:46:27 -0400
From: Thomas Meyer <thomas@m3y3r.de>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        mchehab@kernel.org
Cc: Thomas Meyer <thomas@m3y3r.de>
Subject: [PATCH] media: rc: Use bsearch library function
Date: Fri,  8 Sep 2017 18:33:36 +0200
Message-Id: <20170908163336.2438-1-thomas@m3y3r.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace self coded binary search, by existing library version.

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---
 drivers/media/rc/rc-main.c | 34 ++++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 981cccd6b988..d3d6537867fb 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -15,6 +15,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <media/rc-core.h>
+#include <linux/bsearch.h>
 #include <linux/spinlock.h>
 #include <linux/delay.h>
 #include <linux/input.h>
@@ -460,6 +461,18 @@ static int ir_setkeytable(struct rc_dev *dev,
 	return rc;
 }
 
+static int rc_map_cmp(const void *key, const void *elt)
+{
+	unsigned int scancode = *(unsigned int *) key;
+	struct rc_map_table *e = (struct rc_map_table *) elt;
+
+	if (e->scancode > scancode)
+		return -1;
+	else if (e->scancode < scancode)
+		return 1;
+	return 0;
+}
+
 /**
  * ir_lookup_by_scancode() - locate mapping by scancode
  * @rc_map:	the struct rc_map to search
@@ -472,21 +485,14 @@ static int ir_setkeytable(struct rc_dev *dev,
 static unsigned int ir_lookup_by_scancode(const struct rc_map *rc_map,
 					  unsigned int scancode)
 {
-	int start = 0;
-	int end = rc_map->len - 1;
-	int mid;
-
-	while (start <= end) {
-		mid = (start + end) / 2;
-		if (rc_map->scan[mid].scancode < scancode)
-			start = mid + 1;
-		else if (rc_map->scan[mid].scancode > scancode)
-			end = mid - 1;
-		else
-			return mid;
-	}
+	struct rc_map_table *res;
 
-	return -1U;
+	res = bsearch(&scancode, rc_map->scan, rc_map->len,
+		      sizeof(struct rc_map_table), rc_map_cmp);
+	if (res == NULL)
+		return -1U;
+	else
+		return res - rc_map->scan;
 }
 
 /**
-- 
2.11.0
