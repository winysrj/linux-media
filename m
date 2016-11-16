Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49649 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753610AbcKPQnO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Nov 2016 11:43:14 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 25/35] [media] af9005: remove a printk that would require a KERN_CONT
Date: Wed, 16 Nov 2016 14:42:57 -0200
Message-Id: <df4bbe53fd9ac57f58dac73be01b43239c236492.1479314177.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1479314177.git.mchehab@s-opensource.com>
References: <cover.1479314177.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1479314177.git.mchehab@s-opensource.com>
References: <cover.1479314177.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The dvb-usb system has its own macro to print hexa dumps
(debug_dump). Such macro doesn't support messages with
KERN_CONT after commit 563873318d32 ("Merge branch 'printk-cleanups").
So, let's get rid of a printk() that would be assuming that
this would work.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/dvb-usb/af9005.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb/af9005.c b/drivers/media/usb/dvb-usb/af9005.c
index b257780fb380..e615d040555e 100644
--- a/drivers/media/usb/dvb-usb/af9005.c
+++ b/drivers/media/usb/dvb-usb/af9005.c
@@ -827,7 +827,6 @@ static int af9005_frontend_attach(struct dvb_usb_adapter *adap)
 		printk("EEPROM DUMP\n");
 		for (i = 0; i < 255; i += 8) {
 			af9005_read_eeprom(adap->dev, i, buf, 8);
-			printk("ADDR %x ", i);
 			debug_dump(buf, 8, printk);
 		}
 	}
-- 
2.7.4


