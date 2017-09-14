Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:52412 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751516AbdINKff (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Sep 2017 06:35:35 -0400
Subject: [PATCH 5/8] [media] ttusb_dec: Move an assignment in
 ttusb_dec_probe()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <66b087d3-6dd3-1e1c-d33d-e34c9e2ffe25@users.sourceforge.net>
Message-ID: <e5f2a546-0a8e-73b4-60bf-f8e2b9e6be71@users.sourceforge.net>
Date: Thu, 14 Sep 2017 12:35:25 +0200
MIME-Version: 1.0
In-Reply-To: <66b087d3-6dd3-1e1c-d33d-e34c9e2ffe25@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 13 Sep 2017 20:32:25 +0200

Assign a pointer to a data structure member without using an intermediate
local variable.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/usb/ttusb-dec/ttusb_dec.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/media/usb/ttusb-dec/ttusb_dec.c b/drivers/media/usb/ttusb-dec/ttusb_dec.c
index 26d637684b30..7759de653ee9 100644
--- a/drivers/media/usb/ttusb-dec/ttusb_dec.c
+++ b/drivers/media/usb/ttusb-dec/ttusb_dec.c
@@ -1650,14 +1650,10 @@ static const struct ttusbdecfe_config fe_config = {
 static int ttusb_dec_probe(struct usb_interface *intf,
 			   const struct usb_device_id *id)
 {
-	struct usb_device *udev;
 	struct ttusb_dec *dec;
 	int result;
 
 	dprintk("%s\n", __func__);
-
-	udev = interface_to_usbdev(intf);
-
 	dec = kzalloc(sizeof(*dec), GFP_KERNEL);
 	if (!dec)
 		return -ENOMEM;
@@ -1678,7 +1674,7 @@ static int ttusb_dec_probe(struct usb_interface *intf,
 		break;
 	}
 
-	dec->udev = udev;
+	dec->udev = interface_to_usbdev(intf);
 
 	result = ttusb_dec_init_usb(dec);
 	if (result)
-- 
2.14.1
