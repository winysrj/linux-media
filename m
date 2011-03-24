Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:34296 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934098Ab1CXUEg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Mar 2011 16:04:36 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p2OK4agZ005430
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 24 Mar 2011 16:04:36 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>
Subject: [PATCH 2/2] mceusb: tivo transceiver should default to tivo keymap
Date: Thu, 24 Mar 2011 16:04:25 -0400
Message-Id: <1300997065-4085-2-git-send-email-jarod@redhat.com>
In-Reply-To: <1300997065-4085-1-git-send-email-jarod@redhat.com>
References: <1300997065-4085-1-git-send-email-jarod@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/rc/mceusb.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index 044fb7a..0d6ca2b 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -149,6 +149,7 @@ enum mceusb_model_type {
 	POLARIS_EVK,
 	CX_HYBRID_TV,
 	MULTIFUNCTION,
+	TIVO_KIT,
 };
 
 struct mceusb_model {
@@ -197,6 +198,10 @@ static const struct mceusb_model mceusb_model[] = {
 		.mce_gen2 = 1,
 		.ir_intfnum = 2,
 	},
+	[TIVO_KIT] = {
+		.mce_gen2 = 1,
+		.rc_map = RC_MAP_TIVO,
+	},
 };
 
 static struct usb_device_id mceusb_dev_table[] = {
@@ -306,7 +311,8 @@ static struct usb_device_id mceusb_dev_table[] = {
 	/* Northstar Systems, Inc. eHome Infrared Transceiver */
 	{ USB_DEVICE(VENDOR_NORTHSTAR, 0xe004) },
 	/* TiVo PC IR Receiver */
-	{ USB_DEVICE(VENDOR_TIVO, 0x2000) },
+	{ USB_DEVICE(VENDOR_TIVO, 0x2000),
+	  .driver_info = TIVO_KIT },
 	/* Conexant Hybrid TV "Shelby" Polaris SDK */
 	{ USB_DEVICE(VENDOR_CONEXANT, 0x58a1),
 	  .driver_info = POLARIS_EVK },
-- 
1.7.1

