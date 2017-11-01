Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:47557 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933436AbdKAVGT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 1 Nov 2017 17:06:19 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Colin Ian King <colin.king@canonical.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Max Kellermann <max.kellermann@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v2 23/26] media: drxj: better handle errors
Date: Wed,  1 Nov 2017 17:06:00 -0400
Message-Id: <f240315c530fef8d181d2b4c626ac1ef64bf4069.1509569763.git.mchehab@s-opensource.com>
In-Reply-To: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
References: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
In-Reply-To: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
References: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

as reported by smatch:
	drivers/media/dvb-frontends/drx39xyj/drxj.c:2157 drxj_dap_atomic_read_write_block() error: uninitialized symbol 'word'.

The driver doesn't check if a read error occurred. Add such
check.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-frontends/drx39xyj/drxj.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index 499ccff557bf..28e24d5b7fb3 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -2151,9 +2151,13 @@ int drxj_dap_atomic_read_write_block(struct i2c_device_addr *dev_addr,
 	if (read_flag) {
 		/* read data from buffer */
 		for (i = 0; i < (datasize / 2); i++) {
-			drxj_dap_read_reg16(dev_addr,
-					    (DRXJ_HI_ATOMIC_BUF_START + i),
-					   &word, 0);
+			rc = drxj_dap_read_reg16(dev_addr,
+						 (DRXJ_HI_ATOMIC_BUF_START + i),
+						 &word, 0);
+			if (rc) {
+				pr_err("error %d\n", rc);
+				goto rw_error;
+			}
 			data[2 * i] = (u8) (word & 0xFF);
 			data[(2 * i) + 1] = (u8) (word >> 8);
 		}
-- 
2.13.6
