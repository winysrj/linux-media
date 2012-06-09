Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50988 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934452Ab2FIAvM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jun 2012 20:51:12 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-media@vger.kernel.org
Subject: [PATCH v3 5/9] video/uvc: use memweight()
Date: Sat,  9 Jun 2012 09:50:34 +0900
Message-Id: <1339203038-13069-5-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1339203038-13069-1-git-send-email-akinobu.mita@gmail.com>
References: <1339203038-13069-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use memweight() to count the total number of bits set in memory area.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
---
No changes from v1

 drivers/media/video/uvc/uvc_ctrl.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_ctrl.c b/drivers/media/video/uvc/uvc_ctrl.c
index af26bbe..f7061a5 100644
--- a/drivers/media/video/uvc/uvc_ctrl.c
+++ b/drivers/media/video/uvc/uvc_ctrl.c
@@ -2083,7 +2083,7 @@ int uvc_ctrl_init_device(struct uvc_device *dev)
 	/* Walk the entities list and instantiate controls */
 	list_for_each_entry(entity, &dev->entities, list) {
 		struct uvc_control *ctrl;
-		unsigned int bControlSize = 0, ncontrols = 0;
+		unsigned int bControlSize = 0, ncontrols;
 		__u8 *bmControls = NULL;
 
 		if (UVC_ENTITY_TYPE(entity) == UVC_VC_EXTENSION_UNIT) {
@@ -2101,8 +2101,7 @@ int uvc_ctrl_init_device(struct uvc_device *dev)
 		uvc_ctrl_prune_entity(dev, entity);
 
 		/* Count supported controls and allocate the controls array */
-		for (i = 0; i < bControlSize; ++i)
-			ncontrols += hweight8(bmControls[i]);
+		ncontrols = memweight(bmControls, bControlSize);
 		if (ncontrols == 0)
 			continue;
 
-- 
1.7.7.6

