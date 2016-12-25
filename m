Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:53259 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753678AbcLYSlu (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Dec 2016 13:41:50 -0500
Subject: [PATCH 10/19] [media] uvc_driver: Return -ENOMEM after a failed
 kzalloc() call in uvc_parse_streaming()
To: linux-media@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <47aa4314-74ec-b2bf-ee3b-aad4d6e9f0a2@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <cca09ee1-dc30-b3e6-41fb-63c1443bf91b@users.sourceforge.net>
Date: Sun, 25 Dec 2016 19:41:41 +0100
MIME-Version: 1.0
In-Reply-To: <47aa4314-74ec-b2bf-ee3b-aad4d6e9f0a2@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 25 Dec 2016 16:00:17 +0100

Use the return code "-ENOMEM" (instead of "-EINVAL") after a call of
the function "kzalloc" failed here.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/usb/uvc/uvc_driver.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index b0833902fde2..5736f8b26f92 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -663,7 +663,7 @@ static int uvc_parse_streaming(struct uvc_device *dev,
 	streaming = kzalloc(sizeof(*streaming), GFP_KERNEL);
 	if (!streaming) {
 		usb_driver_release_interface(&uvc_driver.driver, intf);
-		return -EINVAL;
+		return -ENOMEM;
 	}
 
 	mutex_init(&streaming->mutex);
-- 
2.11.0

