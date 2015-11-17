Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:32832 "EHLO
	mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487AbbKQGde (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Nov 2015 01:33:34 -0500
Received: by wmec201 with SMTP id c201so211159951wme.0
        for <linux-media@vger.kernel.org>; Mon, 16 Nov 2015 22:33:33 -0800 (PST)
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH] media: cx23885: fix type of allowed_protos
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org,
	=?UTF-8?Q?David_H=c3=a4rdeman?= <david@hardeman.nu>
Message-ID: <564ACA35.9010401@gmail.com>
Date: Tue, 17 Nov 2015 07:33:25 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Protocol lists are represented as 64-bit bitmaps,
therefore use u64 instead of unsigned long.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/media/pci/cx23885/cx23885-input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/cx23885/cx23885-input.c b/drivers/media/pci/cx23885/cx23885-input.c
index 088799c..64328d0 100644
--- a/drivers/media/pci/cx23885/cx23885-input.c
+++ b/drivers/media/pci/cx23885/cx23885-input.c
@@ -268,7 +268,7 @@ int cx23885_input_init(struct cx23885_dev *dev)
 	struct rc_dev *rc;
 	char *rc_map;
 	enum rc_driver_type driver_type;
-	unsigned long allowed_protos;
+	u64 allowed_protos;
 
 	int ret;
 
-- 
2.6.2

