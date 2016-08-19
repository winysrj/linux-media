Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:56576 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752067AbcHSJ0H (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Aug 2016 05:26:07 -0400
Subject: [PATCH 2/2] uvc_v4l2: One function call less in uvc_ioctl_ctrl_map()
 after error detection
To: linux-media@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <566ABCD9.1060404@users.sourceforge.net>
 <95aa5fcd-8610-debc-70b0-30b2ed3302d2@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <8f89ec37-1556-4c09-f0b7-df87b4169320@users.sourceforge.net>
Date: Fri, 19 Aug 2016 11:25:44 +0200
MIME-Version: 1.0
In-Reply-To: <95aa5fcd-8610-debc-70b0-30b2ed3302d2@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 19 Aug 2016 11:00:38 +0200

The kfree() function was called in two cases by the uvc_ioctl_ctrl_map()
function during error handling even if the passed data structure element
contained a null pointer.

Adjust jump targets according to the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/usb/uvc/uvc_v4l2.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
index a7e12fd..52a2af8 100644
--- a/drivers/media/usb/uvc/uvc_v4l2.c
+++ b/drivers/media/usb/uvc/uvc_v4l2.c
@@ -66,14 +66,14 @@ static int uvc_ioctl_ctrl_map(struct uvc_video_chain *chain,
 		if (xmap->menu_count == 0 ||
 		    xmap->menu_count > UVC_MAX_CONTROL_MENU_ENTRIES) {
 			ret = -EINVAL;
-			goto done;
+			goto free_map;
 		}
 
 		size = xmap->menu_count * sizeof(*map->menu_info);
 		map->menu_info = memdup_user(xmap->menu_info, size);
 		if (IS_ERR(map->menu_info)) {
 			ret = PTR_ERR(map->menu_info);
-			goto done;
+			goto free_map;
 		}
 
 		map->menu_count = xmap->menu_count;
@@ -83,13 +83,12 @@ static int uvc_ioctl_ctrl_map(struct uvc_video_chain *chain,
 		uvc_trace(UVC_TRACE_CONTROL, "Unsupported V4L2 control type "
 			  "%u.\n", xmap->v4l2_type);
 		ret = -ENOTTY;
-		goto done;
+		goto free_map;
 	}
 
 	ret = uvc_ctrl_add_mapping(chain, map);
-
-done:
 	kfree(map->menu_info);
+free_map:
 	kfree(map);
 
 	return ret;
-- 
2.9.3

