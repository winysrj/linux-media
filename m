Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:53744 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750861AbdIQNdH (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 17 Sep 2017 09:33:07 -0400
Subject: [PATCH 2/4] [media] cpia2: Adjust two function calls together with a
 variable assignment
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Shyam Saini <mayhs11saini@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <c2ff478e-94d7-6c92-f467-69f5b66b8a1e@users.sourceforge.net>
Message-ID: <b7bd5189-926c-b48c-37af-5d764c0674ec@users.sourceforge.net>
Date: Sun, 17 Sep 2017 15:32:56 +0200
MIME-Version: 1.0
In-Reply-To: <c2ff478e-94d7-6c92-f467-69f5b66b8a1e@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 17 Sep 2017 12:56:50 +0200

The script "checkpatch.pl" pointed information out like the following.

ERROR: do not use assignment in if condition

Thus fix the affected source code places.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/usb/cpia2/cpia2_usb.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/cpia2/cpia2_usb.c b/drivers/media/usb/cpia2/cpia2_usb.c
index c6be2786a66f..161c9b827f8e 100644
--- a/drivers/media/usb/cpia2/cpia2_usb.c
+++ b/drivers/media/usb/cpia2/cpia2_usb.c
@@ -367,7 +367,8 @@ static void cpia2_usb_complete(struct urb *urb)
 	if(cam->streaming) {
 		/* resubmit */
 		urb->dev = cam->dev;
-		if ((i = usb_submit_urb(urb, GFP_ATOMIC)) != 0)
+		i = usb_submit_urb(urb, GFP_ATOMIC);
+		if (i != 0)
 			ERR("%s: usb_submit_urb ret %d!\n", __func__, i);
 	}
 }
@@ -852,5 +853,5 @@ static int cpia2_usb_probe(struct usb_interface *intf,
 	}
 
-
-	if((ret = cpia2_init_camera(cam)) < 0) {
+	ret = cpia2_init_camera(cam);
+	if (ret < 0) {
 		ERR("%s: failed to initialize cpia2 camera (ret = %d)\n", __func__, ret);
-- 
2.14.1
