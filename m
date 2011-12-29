Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61901 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753358Ab1L2Ufn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Dec 2011 15:35:43 -0500
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Jean-Francois Moine <moinejf@free.fr>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH for 3.2 URGENT] gspca: Fix bulk mode cameras no longer working (regression fix)
Date: Thu, 29 Dec 2011 21:36:42 +0100
Message-Id: <1325191002-25074-2-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1325191002-25074-1-git-send-email-hdegoede@redhat.com>
References: <1325191002-25074-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The new iso bandwidth calculation code accidentally has broken support
for bulk mode cameras. This has broken the following drivers:
finepix, jeilinj, ovfx2, ov534, ov534_9, se401, sq905, sq905c, sq930x,
stv0680, vicam.

Thix patch fixes this. Fix tested with: se401, sq905, sq905c, stv0680 & vicam
cams.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
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

