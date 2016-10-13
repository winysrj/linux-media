Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.14]:55147 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752030AbcJMQuh (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Oct 2016 12:50:37 -0400
Subject: [PATCH 17/18] [media] RedRat3: Adjust two checks for null pointers in
 redrat3_dev_probe()
To: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sean Young <sean@mess.org>,
        Wolfram Sang <wsa-dev@sang-engineering.com>
References: <566ABCD9.1060404@users.sourceforge.net>
 <81cef537-4ad0-3a74-8bde-94707dcd03f4@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <810dec6f-8c5e-6784-bdc0-a9bed477b8c4@users.sourceforge.net>
Date: Thu, 13 Oct 2016 18:47:05 +0200
MIME-Version: 1.0
In-Reply-To: <81cef537-4ad0-3a74-8bde-94707dcd03f4@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 13 Oct 2016 17:40:34 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The script "checkpatch.pl" pointed information out like the following.

Comparison to NULL could be written !…

Thus fix the affected source code places.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/rc/redrat3.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index 06c9eea..a09d5cb 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -923,8 +923,7 @@ static int redrat3_dev_probe(struct usb_interface *intf,
 		ep = &uhi->endpoint[i].desc;
 		addr = ep->bEndpointAddress;
 		attrs = ep->bmAttributes;
-
-		if ((ep_in == NULL) &&
+		if (!ep_in &&
 		    ((addr & USB_ENDPOINT_DIR_MASK) == USB_DIR_IN) &&
 		    ((attrs & USB_ENDPOINT_XFERTYPE_MASK) ==
 		     USB_ENDPOINT_XFER_BULK)) {
@@ -935,7 +934,7 @@ static int redrat3_dev_probe(struct usb_interface *intf,
 				ep_in = ep;
 		}
 
-		if ((ep_out == NULL) &&
+		if (!ep_out &&
 		    ((addr & USB_ENDPOINT_DIR_MASK) == USB_DIR_OUT) &&
 		    ((attrs & USB_ENDPOINT_XFERTYPE_MASK) ==
 		     USB_ENDPOINT_XFER_BULK)) {
-- 
2.10.1

