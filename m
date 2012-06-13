Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:33006 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754912Ab2FMWY7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jun 2012 18:24:59 -0400
Received: by wibhj8 with SMTP id hj8so5791712wib.1
        for <linux-media@vger.kernel.org>; Wed, 13 Jun 2012 15:24:58 -0700 (PDT)
Message-ID: <1339626272.2421.74.camel@Route3278>
Subject: [PATCH 1/2] [BUG] dvb_usb_v2:  return the download ret in
 dvb_usb_download_firmware
From: Malcolm Priestley <tvboxspy@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media <linux-media@vger.kernel.org>
Date: Wed, 13 Jun 2012 23:24:32 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi antti

There some issues with dvb_usb_v2 with the lmedm04 driver.

The first being this patch, no return value from dvb_usb_download_firmware
causes system wide dead lock with COLD disconnect as system attempts to continue
to warm state.

The second is to do with d->props.bInterfaceNumber in patch 2.

In get_usb_stream_config there no handing of the struct dvb_frontend.
...
int (*get_usb_stream_config) (struct dvb_frontend *,
			struct usb_data_stream_properties *);

...
I wonder if it would be better to use adapter instead?

I also have a draft patch to use delayed work.

Regards


Malcolm


Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/dvb/dvb-usb/dvb_usb_init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb/dvb-usb/dvb_usb_init.c b/drivers/media/dvb/dvb-usb/dvb_usb_init.c
index 60aa944..c16a28a 100644
--- a/drivers/media/dvb/dvb-usb/dvb_usb_init.c
+++ b/drivers/media/dvb/dvb-usb/dvb_usb_init.c
@@ -61,7 +61,7 @@ static int dvb_usb_download_firmware(struct dvb_usb_device *d)
 	if (ret < 0)
 		goto err;
 
-	return 0;
+	return ret;
 err:
 	pr_debug("%s: failed=%d\n", __func__, ret);
 	return ret;
-- 
1.7.10











