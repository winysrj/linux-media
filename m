Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38277 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760615Ab2ERAeE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 May 2012 20:34:04 -0400
Received: by pbbrp8 with SMTP id rp8so3207841pbb.19
        for <linux-media@vger.kernel.org>; Thu, 17 May 2012 17:34:04 -0700 (PDT)
From: Ismael Luceno <ismael.luceno@gmail.com>
To: linux-media@vger.kernel.org
Cc: Ismael Luceno <ismael.luceno@gmail.com>
Subject: [PATCH] au0828: Move the Kconfig knob under V4L_USB_DRIVERS
Date: Thu, 17 May 2012 21:33:21 -0300
Message-Id: <1337301201-5925-1-git-send-email-ismael.luceno@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver is for USB devices, but was incorrectly listed under
V4L_PCI_DRIVERS.

Signed-off-by: Ismael Luceno <ismael.luceno@gmail.com>
---
 drivers/media/video/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index ce1e7ba..5d9e584 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -644,6 +644,8 @@ menuconfig V4L_USB_DRIVERS
 
 if V4L_USB_DRIVERS
 
+source "drivers/media/video/au0828/Kconfig"
+
 source "drivers/media/video/uvc/Kconfig"
 
 source "drivers/media/video/gspca/Kconfig"
@@ -721,8 +723,6 @@ menuconfig V4L_PCI_DRIVERS
 
 if V4L_PCI_DRIVERS
 
-source "drivers/media/video/au0828/Kconfig"
-
 source "drivers/media/video/bt8xx/Kconfig"
 
 source "drivers/media/video/cx18/Kconfig"
-- 
1.7.10.1

