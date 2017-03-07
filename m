Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:32806 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932683AbdCGST6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Mar 2017 13:19:58 -0500
From: Johan Hovold <johan@kernel.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Jarod Wilson <jarod@redhat.com>, linux-media@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH] [media] mceusb: fix NULL-deref at probe
Date: Tue,  7 Mar 2017 19:14:13 +0100
Message-Id: <20170307181413.7264-1-johan@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make sure to check for the required out endpoint to avoid dereferencing
a NULL-pointer in mce_request_packet should a malicious device lack such
an endpoint. Note that this path it hit during probe.

Fixes: 66e89522aff7 ("V4L/DVB: IR: add mceusb IR receiver driver")
Cc: stable <stable@vger.kernel.org>	# 2.6.36
Signed-off-by: Johan Hovold <johan@kernel.org>
---

Found through inspection, compile tested only.

Johan


 drivers/media/rc/mceusb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index 238d8eaf7d94..93b16fe3ab38 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -1288,8 +1288,8 @@ static int mceusb_dev_probe(struct usb_interface *intf,
 			}
 		}
 	}
-	if (ep_in == NULL) {
-		dev_dbg(&intf->dev, "inbound and/or endpoint not found");
+	if (!ep_in || !ep_out) {
+		dev_dbg(&intf->dev, "required endpoints not found\n");
 		return -ENODEV;
 	}
 
-- 
2.12.0
