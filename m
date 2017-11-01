Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:44750 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933428AbdKAVGQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 1 Nov 2017 17:06:16 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Max Kellermann <max.kellermann@gmail.com>
Subject: [PATCH v2 10/26] media: xc4000: don't ignore error if hwmodel fails
Date: Wed,  1 Nov 2017 17:05:47 -0400
Message-Id: <06e27fc9b3ca44ced5f854b7e3b09984d5c26769.1509569763.git.mchehab@s-opensource.com>
In-Reply-To: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
References: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
In-Reply-To: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
References: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If, for some reason, reading the hwmodel register on
xc4000 fails, it will cause the following logig to
use a random value, as reported by smatch:

	drivers/media/tuners/xc4000.c:1047 check_firmware() error: uninitialized symbol 'hwmodel'.
	drivers/media/tuners/xc4000.c:1060 check_firmware() error: uninitialized symbol 'hwmodel'.
	drivers/media/tuners/xc4000.c:1064 check_firmware() error: uninitialized symbol 'hwmodel'.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/tuners/xc4000.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/tuners/xc4000.c b/drivers/media/tuners/xc4000.c
index e30948e4ff87..2113ce594f75 100644
--- a/drivers/media/tuners/xc4000.c
+++ b/drivers/media/tuners/xc4000.c
@@ -1036,7 +1036,10 @@ static int check_firmware(struct dvb_frontend *fe, unsigned int type,
 		dprintk(1, "load scode failed %d\n", rc);
 
 check_device:
-	rc = xc4000_readreg(priv, XREG_PRODUCT_ID, &hwmodel);
+	if (xc4000_readreg(priv, XREG_PRODUCT_ID, &hwmodel) < 0) {
+		printk(KERN_ERR "Unable to read tuner registers.\n");
+		goto fail;
+	}
 
 	if (xc_get_version(priv, &hw_major, &hw_minor, &fw_major,
 			   &fw_minor) != 0) {
-- 
2.13.6
