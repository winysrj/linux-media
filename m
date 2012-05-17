Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51814 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754892Ab2EQXrR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 May 2012 19:47:17 -0400
Received: by pbbrp8 with SMTP id rp8so3168683pbb.19
        for <linux-media@vger.kernel.org>; Thu, 17 May 2012 16:47:17 -0700 (PDT)
From: Ismael Luceno <ismael.luceno@gmail.com>
To: linux-media@vger.kernel.org
Cc: Ismael Luceno <ismael.luceno@gmail.com>
Subject: [PATCH] au0828: Add USB ID used by many dongles
Date: Thu, 17 May 2012 20:46:46 -0300
Message-Id: <1337298406-28395-1-git-send-email-ismael.luceno@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Tested with Yfeng 680 ATV dongle.

Signed-off-by: Ismael Luceno <ismael.luceno@gmail.com>
---
 drivers/media/video/au0828/au0828-cards.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/video/au0828/au0828-cards.c b/drivers/media/video/au0828/au0828-cards.c
index 1c6015a..e3fe9a6 100644
--- a/drivers/media/video/au0828/au0828-cards.c
+++ b/drivers/media/video/au0828/au0828-cards.c
@@ -325,6 +325,8 @@ struct usb_device_id au0828_usb_id_table[] = {
 		.driver_info = AU0828_BOARD_HAUPPAUGE_HVR950Q_MXL },
 	{ USB_DEVICE(0x2040, 0x7281),
 		.driver_info = AU0828_BOARD_HAUPPAUGE_HVR950Q_MXL },
+	{ USB_DEVICE(0x05e1, 0x0480),
+		.driver_info = AU0828_BOARD_HAUPPAUGE_WOODBURY },
 	{ USB_DEVICE(0x2040, 0x8200),
 		.driver_info = AU0828_BOARD_HAUPPAUGE_WOODBURY },
 	{ USB_DEVICE(0x2040, 0x7260),
-- 
1.7.10.1

