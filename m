Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59267 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754025Ab1L2VJ1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Dec 2011 16:09:27 -0500
Message-ID: <4EFCD701.3020005@redhat.com>
Date: Thu, 29 Dec 2011 19:09:21 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH for 3.2 URGENT] gspca: Fix bulk mode cameras no longer working
 (regression fix)
References: <1325191002-25074-2-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1325191002-25074-2-git-send-email-hdegoede@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans de Goede <hdegoede@redhat.com>

The new iso bandwidth calculation code accidentally has broken support
for bulk mode cameras. This has broken the following drivers:
finepix, jeilinj, ovfx2, ov534, ov534_9, se401, sq905, sq905c, sq930x,
stv0680, vicam.

Thix patch fixes this. Fix tested with: se401, sq905, sq905c, stv0680 & vicam
cams.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/video/gspca/gspca.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/gspca/gspca.c b/drivers/media/video/gspca/gspca.c
index 271be98..5ce3557 100644
--- a/drivers/media/video/gspca/gspca.c
+++ b/drivers/media/video/gspca/gspca.c
@@ -838,13 +838,13 @@ static int gspca_init_transfer(struct gspca_dev *gspca_dev)
 	gspca_dev->usb_err = 0;
 
 	/* do the specific subdriver stuff before endpoint selection */
-	gspca_dev->alt = 0;
+	intf = usb_ifnum_to_if(gspca_dev->dev, gspca_dev->iface);
+	gspca_dev->alt = gspca_dev->cam.bulk ? intf->num_altsetting : 0;
 	if (gspca_dev->sd_desc->isoc_init) {
 		ret = gspca_dev->sd_desc->isoc_init(gspca_dev);
 		if (ret < 0)
 			goto unlock;
 	}
-	intf = usb_ifnum_to_if(gspca_dev->dev, gspca_dev->iface);
 	xfer = gspca_dev->cam.bulk ? USB_ENDPOINT_XFER_BULK
 				   : USB_ENDPOINT_XFER_ISOC;
 
-- 
1.7.7.4
