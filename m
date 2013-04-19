Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:33145 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754374Ab3DSVIl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Apr 2013 17:08:41 -0400
Received: by mail-we0-f171.google.com with SMTP id i48so3913933wef.2
        for <linux-media@vger.kernel.org>; Fri, 19 Apr 2013 14:08:39 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH] em28xx: add a missing le16_to_cpu conversion
Date: Fri, 19 Apr 2013 23:09:46 +0200
Message-Id: <1366405786-2252-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

commit 61ff5d69 "em28xx: improve em2710/em2820 distinction" missed the
le16_to_cpu conversion of the USB vendor ID.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c |    3 ++-
 1 Datei geändert, 2 Zeilen hinzugefügt(+), 1 Zeile entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index cc63f19..d2ed678 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -2910,7 +2910,8 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 			break;
 		case CHIP_ID_EM2820:
 			chip_name = "em2710/2820";
-			if (dev->udev->descriptor.idVendor == 0xeb1a) {
+			if (le16_to_cpu(dev->udev->descriptor.idVendor)
+								    == 0xeb1a) {
 				__le16 idProd = dev->udev->descriptor.idProduct;
 				if (le16_to_cpu(idProd) == 0x2710)
 					chip_name = "em2710";
-- 
1.7.10.4

