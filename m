Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50442 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204AbaCJL7w (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Mar 2014 07:59:52 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 01/15] drx-j: Don't use 0 as NULL
Date: Mon, 10 Mar 2014 08:58:53 -0300
Message-Id: <1394452747-5426-2-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1394452747-5426-1-git-send-email-m.chehab@samsung.com>
References: <1394452747-5426-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixes the following warnings:
	drivers/media/dvb-frontends/drx39xyj/drxj.c:1679:65: warning: Using plain integer as NULL pointer
	drivers/media/dvb-frontends/drx39xyj/drxj.c:1679:71: warning: Using plain integer as NULL pointer
	drivers/media/dvb-frontends/drx39xyj/drxj.c:1681:52: warning: Using plain integer as NULL pointer
	drivers/media/dvb-frontends/drx39xyj/drxj.c:1681:58: warning: Using plain integer as NULL pointer

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/drx39xyj/drxj.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index 0232b1409ec0..af3b69ce8c16 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -1676,9 +1676,10 @@ static int drxdap_fasi_read_block(struct i2c_device_addr *dev_addr,
 		 * In single master mode, split the read and write actions.
 		 * No special action is needed for write chunks here.
 		 */
-		rc = drxbsp_i2c_write_read(dev_addr, bufx, buf, 0, 0, 0);
+		rc = drxbsp_i2c_write_read(dev_addr, bufx, buf,
+					   NULL, 0, NULL);
 		if (rc == 0)
-			rc = drxbsp_i2c_write_read(0, 0, 0, dev_addr, todo, data);
+			rc = drxbsp_i2c_write_read(NULL, 0, NULL, dev_addr, todo, data);
 #else
 		/* In multi master mode, do everything in one RW action */
 		rc = drxbsp_i2c_write_read(dev_addr, bufx, buf, dev_addr, todo,
-- 
1.8.5.3

