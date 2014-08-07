Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35401 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932380AbaHGQKe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Aug 2014 12:10:34 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 2/3] au0828: add an option to disable IR via modprobe parameter
Date: Thu,  7 Aug 2014 13:10:25 -0300
Message-Id: <1407427826-12886-2-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1407427826-12886-1-git-send-email-m.chehab@samsung.com>
References: <1407427826-12886-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The IR code increases the power consumption of the device.
Allow to disable it via modprobe parameter.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/au0828/au0828-input.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/au0828/au0828-input.c b/drivers/media/usb/au0828/au0828-input.c
index 53d2c59355f2..94d29c2a6fcf 100644
--- a/drivers/media/usb/au0828/au0828-input.c
+++ b/drivers/media/usb/au0828/au0828-input.c
@@ -25,6 +25,10 @@
 #include <linux/slab.h>
 #include <media/rc-core.h>
 
+static int disable_ir;
+module_param(disable_ir,        int, 0444);
+MODULE_PARM_DESC(disable_ir, "disable infrared remote support");
+
 #include "au0828.h"
 
 struct au0828_rc {
@@ -274,7 +278,7 @@ int au0828_rc_register(struct au0828_dev *dev)
 	int err = -ENOMEM;
 	u16 i2c_rc_dev_addr = 0;
 
-	if (!dev->board.has_ir_i2c)
+	if (!dev->board.has_ir_i2c || disable_ir)
 		return 0;
 
 	i2c_rc_dev_addr = au0828_probe_i2c_ir(dev);
-- 
1.9.3

