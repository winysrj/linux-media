Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47995 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754660Ab1EPWH0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 May 2011 18:07:26 -0400
Received: by wya21 with SMTP id 21so3789964wya.19
        for <linux-media@vger.kernel.org>; Mon, 16 May 2011 15:07:24 -0700 (PDT)
Subject: [PATCH ] dvb-usb provide exit for any structure inside priv.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 May 2011 23:07:17 +0100
Message-ID: <1305583637.2481.3.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Currently priv is freed from memory by dvb-usb on any error or exit.
 If any buffer has been allocated in the priv structure,
 freeing it is tricky.  While freeing it on device disconnect
 is fairly easy, on error it is almost impossible because it
 has been removed from memory by dvb-usb.

This patch provides an exit from the priv.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/dvb/dvb-usb/dvb-usb-init.c |    2 ++
 drivers/media/dvb/dvb-usb/dvb-usb.h      |    1 +
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-init.c b/drivers/media/dvb/dvb-usb/dvb-usb-init.c
index 2e3ea0f..217b948 100644
--- a/drivers/media/dvb/dvb-usb/dvb-usb-init.c
+++ b/drivers/media/dvb/dvb-usb/dvb-usb-init.c
@@ -118,6 +118,8 @@ static int dvb_usb_exit(struct dvb_usb_device *d)
 	dvb_usb_i2c_exit(d);
 	deb_info("state should be zero now: %x\n", d->state);
 	d->state = DVB_USB_STATE_INIT;
+	if (d->props.priv_exit)
+		d->props.priv_exit(d);
 	kfree(d->priv);
 	kfree(d);
 	return 0;
diff --git a/drivers/media/dvb/dvb-usb/dvb-usb.h b/drivers/media/dvb/dvb-usb/dvb-usb.h
index 76a8096..044c906 100644
--- a/drivers/media/dvb/dvb-usb/dvb-usb.h
+++ b/drivers/media/dvb/dvb-usb/dvb-usb.h
@@ -263,6 +263,7 @@ struct dvb_usb_device_properties {
 	int        no_reconnect;
 
 	int size_of_priv;
+	int (*priv_exit) (struct dvb_usb_device *);
 
 	int num_adapters;
 	struct dvb_usb_adapter_properties adapter[MAX_NO_OF_ADAPTER_PER_DEVICE];
-- 
1.7.4.1

