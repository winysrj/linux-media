Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:37501 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754180AbdK2Kql (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Nov 2017 05:46:41 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sean Young <sean@mess.org>, James Hogan <jhogan@kernel.org>,
        =?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>,
        Andi Shyti <andi.shyti@samsung.com>,
        =?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jasmin Jessich <jasmin@anw.at>
Subject: [PATCH 08/12] media: rc-ir-raw: cleanup kernel-doc markups
Date: Wed, 29 Nov 2017 05:46:29 -0500
Message-Id: <c4365922d5cd9720cb114f75089bc290571993a3.1511952372.git.mchehab@s-opensource.com>
In-Reply-To: <46e42a303178ca1341d1ab3e0b5c1227b89b60ee.1511952372.git.mchehab@s-opensource.com>
References: <46e42a303178ca1341d1ab3e0b5c1227b89b60ee.1511952372.git.mchehab@s-opensource.com>
In-Reply-To: <46e42a303178ca1341d1ab3e0b5c1227b89b60ee.1511952372.git.mchehab@s-opensource.com>
References: <46e42a303178ca1341d1ab3e0b5c1227b89b60ee.1511952372.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Cleanup those warnings:
	drivers/media/rc/rc-ir-raw.c:141: warning: No description found for parameter 'ev'
	drivers/media/rc/rc-ir-raw.c:141: warning: Excess function parameter 'type' description in 'ir_raw_event_store_with_filter'

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/rc/rc-ir-raw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
index f6e5ba4fbb49..d78483a504c9 100644
--- a/drivers/media/rc/rc-ir-raw.c
+++ b/drivers/media/rc/rc-ir-raw.c
@@ -128,7 +128,7 @@ EXPORT_SYMBOL_GPL(ir_raw_event_store_edge);
 /**
  * ir_raw_event_store_with_filter() - pass next pulse/space to decoders with some processing
  * @dev:	the struct rc_dev device descriptor
- * @type:	the type of the event that has occurred
+ * @ev:		the event that has occurred
  *
  * This routine (which may be called from an interrupt context) works
  * in similar manner to ir_raw_event_store_edge.
-- 
2.14.3
