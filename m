Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:52015 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752198AbdJTHZo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Oct 2017 03:25:44 -0400
Received: by mail-pf0-f195.google.com with SMTP id n14so9820307pfh.8
        for <linux-media@vger.kernel.org>; Fri, 20 Oct 2017 00:25:44 -0700 (PDT)
From: Jaejoong Kim <climbbb.kim@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, Jaejoong Kim <climbbb.kim@gmail.com>
Subject: [PATCH 2/2] media: usb: usbtv: remove duplicate & operation
Date: Fri, 20 Oct 2017 16:25:28 +0900
Message-Id: <1508484328-11018-3-git-send-email-climbbb.kim@gmail.com>
In-Reply-To: <1508484328-11018-1-git-send-email-climbbb.kim@gmail.com>
References: <1508484328-11018-1-git-send-email-climbbb.kim@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

usb_endpoint_maxp() has an inline keyword and searches for bits[10:0]
by & operation with 0x7ff. So, we can remove the duplicate & operation
with 0x7ff.

Signed-off-by: Jaejoong Kim <climbbb.kim@gmail.com>
---
 drivers/media/usb/usbtv/usbtv-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/usbtv/usbtv-core.c b/drivers/media/usb/usbtv/usbtv-core.c
index ceb953b..a95a468 100644
--- a/drivers/media/usb/usbtv/usbtv-core.c
+++ b/drivers/media/usb/usbtv/usbtv-core.c
@@ -84,7 +84,7 @@ static int usbtv_probe(struct usb_interface *intf,
 	/* Packet size is split into 11 bits of base size and count of
 	 * extra multiplies of it.*/
 	size = usb_endpoint_maxp(&ep->desc);
-	size = (size & 0x07ff) * usb_endpoint_maxp_mult(&ep->desc);
+	size = size * usb_endpoint_maxp_mult(&ep->desc);
 
 	/* Device structure */
 	usbtv = kzalloc(sizeof(struct usbtv), GFP_KERNEL);
-- 
2.7.4
