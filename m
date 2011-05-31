Return-path: <mchehab@pedra>
Received: from antispam02.maxim-ic.com ([205.153.101.183]:34438 "EHLO
	antispam02.maxim-ic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932779Ab1EaWep (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 May 2011 18:34:45 -0400
Subject: [PATCH] [media] uvcvideo: Fix control mapping for devices with
 multiple chains
From: Stephan Lachowsky <stephan.lachowsky@maxim-ic.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-uvc-devel@lists.berlios.de" <linux-uvc-devel@lists.berlios.de>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Tue, 31 May 2011 15:24:21 -0700
Message-ID: <1306880661.2916.39.camel@svmlwks101>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The search for matching extension units fails to take account of the
current chain.  In the case where you have two distinct video chains,
both containing an XU with the same GUID but different unit ids, you
will be unable to perform a mapping on the second chain because entity
on the first chain will always be found first

Fix this by only searching the current chain when performing a control
mapping.  This is analogous to the search used by uvc_find_control(),
and is the correct behaviour.

Signed-off-by: Stephan Lachowsky <stephan.lachowsky@maxim-ic.com>
---
 drivers/media/video/uvc/uvc_ctrl.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_ctrl.c b/drivers/media/video/uvc/uvc_ctrl.c
index 59f8a9a..a77648f 100644
--- a/drivers/media/video/uvc/uvc_ctrl.c
+++ b/drivers/media/video/uvc/uvc_ctrl.c
@@ -1565,8 +1565,8 @@ int uvc_ctrl_add_mapping(struct uvc_video_chain *chain,
 		return -EINVAL;
 	}
 
-	/* Search for the matching (GUID/CS) control in the given device */
-	list_for_each_entry(entity, &dev->entities, list) {
+	/* Search for the matching (GUID/CS) control on the current chain */
+	list_for_each_entry(entity, &chain->entities, chain) {
 		unsigned int i;
 
 		if (UVC_ENTITY_TYPE(entity) != UVC_VC_EXTENSION_UNIT ||
-- 
1.7.4.4


