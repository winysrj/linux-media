Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:56183 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752581AbcHSJXd (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Aug 2016 05:23:33 -0400
Subject: [PATCH 1/2] uvc_v4l2: Use memdup_user() rather than duplicating its
 implementation
To: linux-media@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <566ABCD9.1060404@users.sourceforge.net>
 <95aa5fcd-8610-debc-70b0-30b2ed3302d2@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <4181a4b7-3527-4ddf-4c7f-42fcd47977ca@users.sourceforge.net>
Date: Fri, 19 Aug 2016 11:23:18 +0200
MIME-Version: 1.0
In-Reply-To: <95aa5fcd-8610-debc-70b0-30b2ed3302d2@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 19 Aug 2016 10:50:05 +0200

Reuse existing functionality from memdup_user() instead of keeping
duplicate source code.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/usb/uvc/uvc_v4l2.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
index 05eed4b..a7e12fd 100644
--- a/drivers/media/usb/uvc/uvc_v4l2.c
+++ b/drivers/media/usb/uvc/uvc_v4l2.c
@@ -70,14 +70,9 @@ static int uvc_ioctl_ctrl_map(struct uvc_video_chain *chain,
 		}
 
 		size = xmap->menu_count * sizeof(*map->menu_info);
-		map->menu_info = kmalloc(size, GFP_KERNEL);
-		if (map->menu_info == NULL) {
-			ret = -ENOMEM;
-			goto done;
-		}
-
-		if (copy_from_user(map->menu_info, xmap->menu_info, size)) {
-			ret = -EFAULT;
+		map->menu_info = memdup_user(xmap->menu_info, size);
+		if (IS_ERR(map->menu_info)) {
+			ret = PTR_ERR(map->menu_info);
 			goto done;
 		}
 
-- 
2.9.3

