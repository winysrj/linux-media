Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:35996 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756784Ab2DYN53 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Apr 2012 09:57:29 -0400
Received: by obbwc18 with SMTP id wc18so143535obb.37
        for <linux-media@vger.kernel.org>; Wed, 25 Apr 2012 06:57:27 -0700 (PDT)
From: Sergio Aguirre <saaguirre@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, Sergio Aguirre <saaguirre@ti.com>
Subject: [media-ctl PATCH] Compare entity name length aswell
Date: Wed, 25 Apr 2012 08:57:13 -0500
Message-Id: <1335362233-31022-1-git-send-email-saaguirre@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Otherwise, some false positives might arise when
having 2 subdevices with similar names, like:

"OMAP4 ISS ISP IPIPEIF"
"OMAP4 ISS ISP IPIPE"

Before this patch, trying to find "OMAP4 ISS ISP IPIPE", resulted
in a false entity match, retrieving "OMAP4 ISS ISP IPIPEIF"
information instead.

Checking length should ensure such cases are handled well.

Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
---
 src/mediactl.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/src/mediactl.c b/src/mediactl.c
index 5b8c587..451a386 100644
--- a/src/mediactl.c
+++ b/src/mediactl.c
@@ -66,7 +66,8 @@ struct media_entity *media_get_entity_by_name(struct media_device *media,
 	for (i = 0; i < media->entities_count; ++i) {
 		struct media_entity *entity = &media->entities[i];
 
-		if (strncmp(entity->info.name, name, length) == 0)
+		if ((strncmp(entity->info.name, name, length) == 0) &&
+		    (strlen(entity->info.name) == length))
 			return entity;
 	}
 
-- 
1.7.5.4

