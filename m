Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:48628 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754936Ab2FMW0o (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jun 2012 18:26:44 -0400
Received: by weyu7 with SMTP id u7so816356wey.19
        for <linux-media@vger.kernel.org>; Wed, 13 Jun 2012 15:26:43 -0700 (PDT)
Message-ID: <1339626396.2421.75.camel@Route3278>
Subject: [PATCH 2/2] dvb_usb_v2 Allow d->props.bInterfaceNumber to set the
 correct  interface.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media <linux-media@vger.kernel.org>
Date: Wed, 13 Jun 2012 23:26:36 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Although the interface could be set in identify state, ideally it should be done in
the probe.

Allow d->props.bInterfaceNumber try to set the correct interface rather than return error.


Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/dvb/dvb-usb/dvb_usb_init.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/dvb_usb_init.c b/drivers/media/dvb/dvb-usb/dvb_usb_init.c
index c16a28a..b2eb8ac 100644
--- a/drivers/media/dvb/dvb-usb/dvb_usb_init.c
+++ b/drivers/media/dvb/dvb-usb/dvb_usb_init.c
@@ -391,8 +391,15 @@ int dvb_usbv2_probe(struct usb_interface *intf,
 
 	if (d->intf->cur_altsetting->desc.bInterfaceNumber !=
 			d->props.bInterfaceNumber) {
-		ret = -ENODEV;
-		goto err_kfree;
+		usb_reset_configuration(d->udev);
+
+		ret = usb_set_interface(d->udev,
+			d->intf->cur_altsetting->desc.bInterfaceNumber,
+				d->props.bInterfaceNumber);
+		if (ret < 0) {
+			ret = -ENODEV;
+			goto err_kfree;
+		}
 	}
 
 	mutex_init(&d->usb_mutex);
-- 
1.7.10








