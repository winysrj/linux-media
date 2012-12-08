Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-da0-f46.google.com ([209.85.210.46]:56383 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757662Ab2LHGiy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Dec 2012 01:38:54 -0500
Received: by mail-da0-f46.google.com with SMTP id p5so494448dak.19
        for <linux-media@vger.kernel.org>; Fri, 07 Dec 2012 22:38:54 -0800 (PST)
Message-ID: <1354948731.10575.8.camel@andromeda>
Subject: [PATCH] [media] gspca_kinect: add kinect for windows usb id
From: Jacob Schloss <jacob.schloss@unlimitedautomata.com>
To: linux-media@vger.kernel.org
Cc: Antonio Ospite <ospite@studenti.unina.it>
Date: Fri, 07 Dec 2012 22:38:51 -0800
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


This patch adds the USB ID for the Kinect for Windows RGB camera so
it can be used with the gspca_kinect driver.

Signed-off-by: Jacob Schloss <jacob.schloss@unlimitedautomata.com>
---
 drivers/media/video/gspca/kinect.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/video/gspca/kinect.c b/drivers/media/video/gspca/kinect.c
index 40ad668..3773a8a7 100644
--- a/drivers/media/video/gspca/kinect.c
+++ b/drivers/media/video/gspca/kinect.c
@@ -381,6 +381,7 @@ static const struct sd_desc sd_desc = {
 /* -- module initialisation -- */
 static const struct usb_device_id device_table[] = {
 	{USB_DEVICE(0x045e, 0x02ae)},
+	{USB_DEVICE(0x045e, 0x02bf)},
 	{}
 };
 
-- 
1.7.10.4



