Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:38899 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751608AbdIBLmw (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 2 Sep 2017 07:42:52 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 5/7] media: rc: dvb: use dvb device name for rc device
Date: Sat,  2 Sep 2017 12:42:46 +0100
Message-Id: <b25ffa9abe9aa623c76ef8c753990ac34814ebb9.1504352252.git.sean@mess.org>
In-Reply-To: <cover.1504352252.git.sean@mess.org>
References: <cover.1504352252.git.sean@mess.org>
In-Reply-To: <cover.1504352252.git.sean@mess.org>
References: <cover.1504352252.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

"IR-receiver inside an USB DVB receiver" is not descriptive and we have
a proper name available.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/usb/dvb-usb/dvb-usb-remote.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb/dvb-usb-remote.c b/drivers/media/usb/dvb-usb/dvb-usb-remote.c
index 0b03f9bd9c26..b027d378102a 100644
--- a/drivers/media/usb/dvb-usb/dvb-usb-remote.c
+++ b/drivers/media/usb/dvb-usb/dvb-usb-remote.c
@@ -279,7 +279,7 @@ static int rc_core_dvb_usb_remote_init(struct dvb_usb_device *d)
 	dev->change_protocol = d->props.rc.core.change_protocol;
 	dev->allowed_protocols = d->props.rc.core.allowed_protos;
 	usb_to_input_id(d->udev, &dev->input_id);
-	dev->device_name = "IR-receiver inside an USB DVB receiver";
+	dev->device_name = d->desc->name;
 	dev->input_phys = d->rc_phys;
 	dev->dev.parent = &d->udev->dev;
 	dev->priv = d;
-- 
2.13.5
