Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:50643 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752162AbeDRUFP (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 18 Apr 2018 16:05:15 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] media: si470x: fix a typo at the Makefile causing build issues
Date: Wed, 18 Apr 2018 16:05:10 -0400
Message-Id: <42a182282ea2426d56b2d63be634ee419194c45c.1524081907.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of +=, the rule had :=, with actually disables build
of everything else.

Fixes: 58757984ca3c ("media: si470x: allow build both USB and I2C at the same time")
Reported-by: Daniel Scheller <d.scheller.oss@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/radio/si470x/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/radio/si470x/Makefile b/drivers/media/radio/si470x/Makefile
index 563500823e04..682b3146397e 100644
--- a/drivers/media/radio/si470x/Makefile
+++ b/drivers/media/radio/si470x/Makefile
@@ -2,6 +2,6 @@
 # Makefile for radios with Silicon Labs Si470x FM Radio Receivers
 #
 
-obj-$(CONFIG_RADIO_SI470X) := radio-si470x-common.o
+obj-$(CONFIG_RADIO_SI470X) += radio-si470x-common.o
 obj-$(CONFIG_USB_SI470X) += radio-si470x-usb.o
 obj-$(CONFIG_I2C_SI470X) += radio-si470x-i2c.o
-- 
2.14.3
