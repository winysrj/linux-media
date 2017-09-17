Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:64077 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750861AbdIQNbr (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 17 Sep 2017 09:31:47 -0400
Subject: [PATCH 1/4] [media] cpia2: Use common error handling code in
 cpia2_usb_probe()
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
Message-ID: <a5c38437-f79b-e92e-b571-dd240090ca2b@users.sourceforge.net>
Date: Sun, 17 Sep 2017 15:31:31 +0200
MIME-Version: 1.0
In-Reply-To: <c2ff478e-94d7-6c92-f467-69f5b66b8a1e@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 17 Sep 2017 12:40:14 +0200
Add a jump target so that a bit of exception handling can be better reused
at the end of this function.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/usb/cpia2/cpia2_usb.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/media/usb/cpia2/cpia2_usb.c b/drivers/media/usb/cpia2/cpia2_usb.c
index 6089036049d9..c6be2786a66f 100644
--- a/drivers/media/usb/cpia2/cpia2_usb.c
+++ b/drivers/media/usb/cpia2/cpia2_usb.c
@@ -849,13 +849,11 @@ static int cpia2_usb_probe(struct usb_interface *intf,
 	if (ret < 0) {
 		ERR("%s: usb_set_interface error (ret = %d)\n", __func__, ret);
-		kfree(cam);
-		return ret;
+		goto free_data;
 	}
 
 
 	if((ret = cpia2_init_camera(cam)) < 0) {
 		ERR("%s: failed to initialize cpia2 camera (ret = %d)\n", __func__, ret);
-		kfree(cam);
-		return ret;
+		goto free_data;
 	}
 	LOG("  CPiA Version: %d.%02d (%d.%d)\n",
@@ -877,9 +875,12 @@ static int cpia2_usb_probe(struct usb_interface *intf,
 	if (ret < 0) {
 		ERR("%s: Failed to register cpia2 camera (ret = %d)\n", __func__, ret);
-		kfree(cam);
-		return ret;
+		goto free_data;
 	}
 
 	return 0;
+
+free_data:
+	kfree(cam);
+	return ret;
 }
 
-- 
2.14.1
