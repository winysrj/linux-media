Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:33799 "EHLO
	mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbcCGK1G (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Mar 2016 05:27:06 -0500
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH] [media] dw2102: fix unreleased firmware
Date: Mon,  7 Mar 2016 15:56:55 +0530
Message-Id: <1457346415-9698-1-git-send-email-sudipm.mukherjee@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On the particular case when the product id is 0x2101 we have requested
for a firmware but after processing it we missed releasing it.

Signed-off-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
---
 drivers/media/usb/dvb-usb/dw2102.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/usb/dvb-usb/dw2102.c b/drivers/media/usb/dvb-usb/dw2102.c
index 6d0dd85..1f35f3d 100644
--- a/drivers/media/usb/dvb-usb/dw2102.c
+++ b/drivers/media/usb/dvb-usb/dw2102.c
@@ -1843,6 +1843,9 @@ static int dw2102_load_firmware(struct usb_device *dev,
 		msleep(100);
 		kfree(p);
 	}
+
+	if (le16_to_cpu(dev->descriptor.idProduct) == 0x2101)
+		release_firmware(fw);
 	return ret;
 }
 
-- 
1.9.1

