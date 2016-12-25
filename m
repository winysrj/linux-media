Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([217.72.192.78]:65058 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753678AbcLYSnW (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Dec 2016 13:43:22 -0500
Subject: [PATCH 11/19] [media] uvc_driver: Delete an unnecessary variable
 initialisation in uvc_parse_streaming()
To: linux-media@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <47aa4314-74ec-b2bf-ee3b-aad4d6e9f0a2@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <268fc54b-9e81-dead-2ee4-3cd8f2caef4b@users.sourceforge.net>
Date: Sun, 25 Dec 2016 19:43:13 +0100
MIME-Version: 1.0
In-Reply-To: <47aa4314-74ec-b2bf-ee3b-aad4d6e9f0a2@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 25 Dec 2016 16:02:46 +0100

The local variable "streaming" will be set to an appropriate pointer
a bit later. Thus omit the explicit initialisation at the beginning.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/usb/uvc/uvc_driver.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 5736f8b26f92..5bb18a5f7d9f 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -631,7 +631,7 @@ static int uvc_parse_format(struct uvc_device *dev,
 static int uvc_parse_streaming(struct uvc_device *dev,
 	struct usb_interface *intf)
 {
-	struct uvc_streaming *streaming = NULL;
+	struct uvc_streaming *streaming;
 	struct uvc_format *format;
 	struct uvc_frame *frame;
 	struct usb_host_interface *alts = &intf->altsetting[0];
-- 
2.11.0

