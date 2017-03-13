Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:36565 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750772AbdCMMyd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Mar 2017 08:54:33 -0400
From: Johan Hovold <johan@kernel.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: [PATCH 1/6] [media] dib0700: fix NULL-deref at probe
Date: Mon, 13 Mar 2017 13:53:54 +0100
Message-Id: <20170313125359.29394-2-johan@kernel.org>
In-Reply-To: <20170313125359.29394-1-johan@kernel.org>
References: <20170313125359.29394-1-johan@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make sure to check the number of endpoints to avoid dereferencing a
NULL-pointer should a malicious device lack endpoints.

Fixes: c4018fa2e4c0 ("[media] dib0700: fix RC support on Hauppauge
Nova-TD")
Cc: stable <stable@vger.kernel.org>     # 3.16
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/media/usb/dvb-usb/dib0700_core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/usb/dvb-usb/dib0700_core.c b/drivers/media/usb/dvb-usb/dib0700_core.c
index dd5edd3a17ee..08acdd32e412 100644
--- a/drivers/media/usb/dvb-usb/dib0700_core.c
+++ b/drivers/media/usb/dvb-usb/dib0700_core.c
@@ -809,6 +809,9 @@ int dib0700_rc_setup(struct dvb_usb_device *d, struct usb_interface *intf)
 
 	/* Starting in firmware 1.20, the RC info is provided on a bulk pipe */
 
+	if (intf->altsetting[0].desc.bNumEndpoints < rc_ep + 1)
+		return -ENODEV;
+
 	purb = usb_alloc_urb(0, GFP_KERNEL);
 	if (purb == NULL)
 		return -ENOMEM;
-- 
2.12.0
