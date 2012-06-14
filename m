Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54419 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756139Ab2FNNm7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jun 2012 09:42:59 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: hverkuil@xs4all.nl, Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 4/4] radio-si470x: Lower firmware version requirements
Date: Thu, 14 Jun 2012 15:43:14 +0200
Message-Id: <1339681394-11348-4-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1339681394-11348-1-git-send-email-hdegoede@redhat.com>
References: <1339681394-11348-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

With the changes from the previous patches device firmware version 14 +
usb microcontroller software version 1 works fine too.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/media/radio/si470x/radio-si470x-usb.c |    2 +-
 drivers/media/radio/si470x/radio-si470x.h     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/radio/si470x/radio-si470x-usb.c b/drivers/media/radio/si470x/radio-si470x-usb.c
index 66b1ba8..40b963c 100644
--- a/drivers/media/radio/si470x/radio-si470x-usb.c
+++ b/drivers/media/radio/si470x/radio-si470x-usb.c
@@ -143,7 +143,7 @@ MODULE_PARM_DESC(max_rds_errors, "RDS maximum block errors: *1*");
  * Software/Hardware Versions from Scratch Page
  **************************************************************************/
 #define RADIO_SW_VERSION_NOT_BOOTLOADABLE	6
-#define RADIO_SW_VERSION			7
+#define RADIO_SW_VERSION			1
 #define RADIO_HW_VERSION			1
 
 
diff --git a/drivers/media/radio/si470x/radio-si470x.h b/drivers/media/radio/si470x/radio-si470x.h
index fbf713d..b3b612f 100644
--- a/drivers/media/radio/si470x/radio-si470x.h
+++ b/drivers/media/radio/si470x/radio-si470x.h
@@ -189,7 +189,7 @@ struct si470x_device {
  * Firmware Versions
  **************************************************************************/
 
-#define RADIO_FW_VERSION	15
+#define RADIO_FW_VERSION	14
 
 
 
-- 
1.7.10.2

