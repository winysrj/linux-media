Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62518 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760Ab1KLPyy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Nov 2011 10:54:54 -0500
Received: by wyh15 with SMTP id 15so4692973wyh.19
        for <linux-media@vger.kernel.org>; Sat, 12 Nov 2011 07:54:52 -0800 (PST)
Message-ID: <4ebe96cb.85c7e30a.27d9.ffff9098@mx.google.com>
Subject: [PATCH 1/7] af9015 Slow down download firmware
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Date: Sat, 12 Nov 2011 15:54:47 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It is noticed that sometimes the device fails to download parts of the firmware.

Since there is no ack from firmware write a 250u second delay has been added.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/dvb/dvb-usb/af9015.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/af9015.c b/drivers/media/dvb/dvb-usb/af9015.c
index c6c275b..dc6e4ec 100644
--- a/drivers/media/dvb/dvb-usb/af9015.c
+++ b/drivers/media/dvb/dvb-usb/af9015.c
@@ -698,6 +698,7 @@ static int af9015_download_firmware(struct usb_device *udev,
 			err("firmware download failed:%d", ret);
 			goto error;
 		}
+		udelay(250);
 	}
 
 	/* firmware loaded, request boot */
-- 
1.7.5.4




