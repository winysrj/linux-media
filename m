Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48274 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482Ab1LKVJ7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Dec 2011 16:09:59 -0500
Received: by wgbdr13 with SMTP id dr13so9857931wgb.1
        for <linux-media@vger.kernel.org>; Sun, 11 Dec 2011 13:09:57 -0800 (PST)
Message-ID: <1323637786.2325.8.camel@tvbox>
Subject: [PATCH] it913x stop dual frontend attach in warm state with single
 devices.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Date: Sun, 11 Dec 2011 21:09:46 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Stop dual frontend attach in warm state with single devices.

Since this is a no reconnect device this occurs only after a warm system reboot.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/dvb/dvb-usb/it913x.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/it913x.c b/drivers/media/dvb/dvb-usb/it913x.c
index 26b31c0..3ddf82a 100644
--- a/drivers/media/dvb/dvb-usb/it913x.c
+++ b/drivers/media/dvb/dvb-usb/it913x.c
@@ -473,9 +473,12 @@ static int it913x_identify_state(struct usb_device *udev,
 	else
 		props->adapter[0].fe[0].stream.u.bulk.buffersize =
 			TS_BUFFER_SIZE_PID;
-	if (it913x_config.dual_mode)
+	if (it913x_config.dual_mode) {
 		props->adapter[1].fe[0].stream.u.bulk.buffersize =
 			props->adapter[0].fe[0].stream.u.bulk.buffersize;
+		props->num_adapters = 2;
+	} else
+		props->num_adapters = 1;
 
 	ret = ite_firmware_select(udev, props);
 
@@ -499,10 +502,8 @@ static int it913x_identify_state(struct usb_device *udev,
 			if (ret != 0)
 				ret = it913x_wr_reg(udev, DEV_0,
 					GPIOH1_O, 0x0);
-			props->num_adapters = 2;
 		}
-	} else
-		props->num_adapters = 1;
+	}
 
 	reg = it913x_read_reg(udev, IO_MUX_POWER_CLK);
 
-- 
1.7.7.3


