Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:50949 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbbBLWLu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Feb 2015 17:11:50 -0500
From: Luis de Bethencourt <luis@debethencourt.com>
Date: Thu, 12 Feb 2015 22:11:47 +0000
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, david@hardeman.nu,
	james.harper@ejbdigital.com.au, linux-kernel@vger.kernel.org
Subject: [PATCH] dib0700: remove unused macros
Message-ID: <20150212221147.GA12614@turing>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove unused macros RC_REPEAT_DELAY and RC_REPEAT_DELAY_V1_20

Signed-off-by: Luis de Bethencourt <luis.bg@samsung.com>
---
 drivers/media/usb/dvb-usb/dib0700_core.c    | 3 ---
 drivers/media/usb/dvb-usb/dib0700_devices.c | 3 ---
 2 files changed, 6 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/dib0700_core.c b/drivers/media/usb/dvb-usb/dib0700_core.c
index 50856db..2b40393 100644
--- a/drivers/media/usb/dvb-usb/dib0700_core.c
+++ b/drivers/media/usb/dvb-usb/dib0700_core.c
@@ -651,9 +651,6 @@ out:
 	return ret;
 }
 
-/* Number of keypresses to ignore before start repeating */
-#define RC_REPEAT_DELAY_V1_20 10
-
 /* This is the structure of the RC response packet starting in firmware 1.20 */
 struct dib0700_rc_response {
 	u8 report_id;
diff --git a/drivers/media/usb/dvb-usb/dib0700_devices.c b/drivers/media/usb/dvb-usb/dib0700_devices.c
index e1757b8..d7d55a2 100644
--- a/drivers/media/usb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/usb/dvb-usb/dib0700_devices.c
@@ -510,9 +510,6 @@ static int stk7700ph_tuner_attach(struct dvb_usb_adapter *adap)
 
 static u8 rc_request[] = { REQUEST_POLL_RC, 0 };
 
-/* Number of keypresses to ignore before start repeating */
-#define RC_REPEAT_DELAY 6
-
 /*
  * This function is used only when firmware is < 1.20 version. Newer
  * firmwares use bulk mode, with functions implemented at dib0700_core,
-- 
2.1.0

