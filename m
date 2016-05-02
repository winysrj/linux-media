Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33312 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753826AbcEBLWb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 May 2016 07:22:31 -0400
From: Oliver Neukum <oneukum@suse.com>
To: gregKH@linuxfoundation.org, linux-media@vger.kernel.org,
	hdegoede@redhat.com
Cc: Oliver Neukum <oneukum@suse.com>, Oliver Neukum <ONeukum@suse.com>
Subject: [PATCH 1/2] gspca: correct speed testing
Date: Mon,  2 May 2016 13:22:26 +0200
Message-Id: <1462188146-20132-1-git-send-email-oneukum@suse.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Allow for SS+ devices

Signed-off-by: Oliver Neukum <ONeukum@suse.com>
---
 drivers/media/usb/gspca/gspca.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/gspca/gspca.c b/drivers/media/usb/gspca/gspca.c
index af5cd82..69d56f3 100644
--- a/drivers/media/usb/gspca/gspca.c
+++ b/drivers/media/usb/gspca/gspca.c
@@ -705,7 +705,7 @@ static int build_isoc_ep_tb(struct gspca_dev *gspca_dev,
 			psize = (psize & 0x07ff) * (1 + ((psize >> 11) & 3));
 			bandwidth = psize * 1000;
 			if (gspca_dev->dev->speed == USB_SPEED_HIGH
-			 || gspca_dev->dev->speed == USB_SPEED_SUPER)
+			 || gspca_dev->dev->speed >= USB_SPEED_SUPER)
 				bandwidth *= 8;
 			bandwidth /= 1 << (ep->desc.bInterval - 1);
 			if (bandwidth <= last_bw)
-- 
2.1.4

