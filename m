Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:52961 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753159AbdGCJby (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Jul 2017 05:31:54 -0400
From: Colin King <colin.king@canonical.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] [media] uvcvideo: fix spelling mistake: "entites" -> "entities"
Date: Mon,  3 Jul 2017 10:31:51 +0100
Message-Id: <20170703093151.11285-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistake in uvc_printk message

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/usb/uvc/uvc_driver.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 70842c5af05b..9901025c4605 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -1995,7 +1995,7 @@ static int uvc_register_chains(struct uvc_device *dev)
 #ifdef CONFIG_MEDIA_CONTROLLER
 		ret = uvc_mc_register_entities(chain);
 		if (ret < 0) {
-			uvc_printk(KERN_INFO, "Failed to register entites "
+			uvc_printk(KERN_INFO, "Failed to register entities "
 				"(%d).\n", ret);
 		}
 #endif
-- 
2.11.0
