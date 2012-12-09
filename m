Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp207.alice.it ([82.57.200.103]:36129 "EHLO smtp207.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753332Ab2LIXS5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Dec 2012 18:18:57 -0500
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Jacob Schloss <jacob.schloss@unlimitedautomata.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Antonio Ospite <ospite@studenti.unina.it>
Subject: [PATCH] [media] gspca_kinect: add Kinect for Windows USB id
Date: Mon, 10 Dec 2012 00:18:25 +0100
Message-Id: <1355095105-23310-1-git-send-email-ospite@studenti.unina.it>
In-Reply-To: <1354948731.10575.8.camel@andromeda>
References: <1354948731.10575.8.camel@andromeda>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jacob Schloss <jacob.schloss@unlimitedautomata.com>

Add the USB ID for the Kinect for Windows RGB camera so it can be used
with the gspca_kinect driver.

Signed-off-by: Jacob Schloss <jacob.schloss@unlimitedautomata.com>
Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
---

Thanks Jacob, I took the liberty to rebase the patch on top of
linux-3.7.0-rc7 as the gspca location has changed from
drivers/media/video/gspca to drivers/media/usb/gspca

It will be a little easier for HdG to apply it.

Regards,
   Antonio

 drivers/media/usb/gspca/kinect.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/usb/gspca/kinect.c b/drivers/media/usb/gspca/kinect.c
index 40ad668..3773a8a 100644
--- a/drivers/media/usb/gspca/kinect.c
+++ b/drivers/media/usb/gspca/kinect.c
@@ -381,6 +381,7 @@ static const struct sd_desc sd_desc = {
 /* -- module initialisation -- */
 static const struct usb_device_id device_table[] = {
 	{USB_DEVICE(0x045e, 0x02ae)},
+	{USB_DEVICE(0x045e, 0x02bf)},
 	{}
 };
 
-- 
1.7.10.4

