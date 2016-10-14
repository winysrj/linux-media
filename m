Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48628 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754857AbcJNRrG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 13:47:06 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 18/25] [media] uvc_driver: use KERN_CONT where needed
Date: Fri, 14 Oct 2016 14:45:56 -0300
Message-Id: <cb3853709bfff02c2a967112531e87d49c74f4fd.1476466574.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476466574.git.mchehab@s-opensource.com>
References: <cover.1476466574.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476466574.git.mchehab@s-opensource.com>
References: <cover.1476466574.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some continuation messages are not using KERN_CONT.

Since commit 563873318d32 ("Merge branch 'printk-cleanups"),
this won't work as expected anymore. So, let's add KERN_CONT
to those lines.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/uvc/uvc_driver.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 302e284a95eb..9c4b56b4a9c6 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -1309,7 +1309,7 @@ static int uvc_scan_chain_entity(struct uvc_video_chain *chain,
 	switch (UVC_ENTITY_TYPE(entity)) {
 	case UVC_VC_EXTENSION_UNIT:
 		if (uvc_trace_param & UVC_TRACE_PROBE)
-			printk(" <- XU %d", entity->id);
+			printk(KERN_CONT " <- XU %d", entity->id);
 
 		if (entity->bNrInPins != 1) {
 			uvc_trace(UVC_TRACE_DESCR, "Extension unit %d has more "
@@ -1321,7 +1321,7 @@ static int uvc_scan_chain_entity(struct uvc_video_chain *chain,
 
 	case UVC_VC_PROCESSING_UNIT:
 		if (uvc_trace_param & UVC_TRACE_PROBE)
-			printk(" <- PU %d", entity->id);
+			printk(KERN_CONT " <- PU %d", entity->id);
 
 		if (chain->processing != NULL) {
 			uvc_trace(UVC_TRACE_DESCR, "Found multiple "
@@ -1334,7 +1334,7 @@ static int uvc_scan_chain_entity(struct uvc_video_chain *chain,
 
 	case UVC_VC_SELECTOR_UNIT:
 		if (uvc_trace_param & UVC_TRACE_PROBE)
-			printk(" <- SU %d", entity->id);
+			printk(KERN_CONT " <- SU %d", entity->id);
 
 		/* Single-input selector units are ignored. */
 		if (entity->bNrInPins == 1)
@@ -1353,7 +1353,7 @@ static int uvc_scan_chain_entity(struct uvc_video_chain *chain,
 	case UVC_ITT_CAMERA:
 	case UVC_ITT_MEDIA_TRANSPORT_INPUT:
 		if (uvc_trace_param & UVC_TRACE_PROBE)
-			printk(" <- IT %d\n", entity->id);
+			printk(KERN_CONT " <- IT %d\n", entity->id);
 
 		break;
 
@@ -1361,17 +1361,17 @@ static int uvc_scan_chain_entity(struct uvc_video_chain *chain,
 	case UVC_OTT_DISPLAY:
 	case UVC_OTT_MEDIA_TRANSPORT_OUTPUT:
 		if (uvc_trace_param & UVC_TRACE_PROBE)
-			printk(" OT %d", entity->id);
+			printk(KERN_CONT " OT %d", entity->id);
 
 		break;
 
 	case UVC_TT_STREAMING:
 		if (UVC_ENTITY_IS_ITERM(entity)) {
 			if (uvc_trace_param & UVC_TRACE_PROBE)
-				printk(" <- IT %d\n", entity->id);
+				printk(KERN_CONT " <- IT %d\n", entity->id);
 		} else {
 			if (uvc_trace_param & UVC_TRACE_PROBE)
-				printk(" OT %d", entity->id);
+				printk(KERN_CONT " OT %d", entity->id);
 		}
 
 		break;
@@ -1416,9 +1416,9 @@ static int uvc_scan_chain_forward(struct uvc_video_chain *chain,
 			list_add_tail(&forward->chain, &chain->entities);
 			if (uvc_trace_param & UVC_TRACE_PROBE) {
 				if (!found)
-					printk(" (->");
+					printk(KERN_CONT " (->");
 
-				printk(" XU %d", forward->id);
+				printk(KERN_CONT " XU %d", forward->id);
 				found = 1;
 			}
 			break;
@@ -1436,16 +1436,16 @@ static int uvc_scan_chain_forward(struct uvc_video_chain *chain,
 			list_add_tail(&forward->chain, &chain->entities);
 			if (uvc_trace_param & UVC_TRACE_PROBE) {
 				if (!found)
-					printk(" (->");
+					printk(KERN_CONT " (->");
 
-				printk(" OT %d", forward->id);
+				printk(KERN_CONT " OT %d", forward->id);
 				found = 1;
 			}
 			break;
 		}
 	}
 	if (found)
-		printk(")");
+		printk(KERN_CONT ")");
 
 	return 0;
 }
@@ -1471,7 +1471,7 @@ static int uvc_scan_chain_backward(struct uvc_video_chain *chain,
 		}
 
 		if (uvc_trace_param & UVC_TRACE_PROBE)
-			printk(" <- IT");
+			printk(KERN_CONT " <- IT");
 
 		chain->selector = entity;
 		for (i = 0; i < entity->bNrInPins; ++i) {
@@ -1485,14 +1485,14 @@ static int uvc_scan_chain_backward(struct uvc_video_chain *chain,
 			}
 
 			if (uvc_trace_param & UVC_TRACE_PROBE)
-				printk(" %d", term->id);
+				printk(KERN_CONT " %d", term->id);
 
 			list_add_tail(&term->chain, &chain->entities);
 			uvc_scan_chain_forward(chain, term, entity);
 		}
 
 		if (uvc_trace_param & UVC_TRACE_PROBE)
-			printk("\n");
+			printk(KERN_CONT "\n");
 
 		id = 0;
 		break;
-- 
2.7.4


