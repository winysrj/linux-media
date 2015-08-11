Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52961 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932128AbbHKSnh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Aug 2015 14:43:37 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Sergey Kozlov <serjk@netup.ru>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 1/3] [media] cxd2841er: don't use variable length arrays
Date: Tue, 11 Aug 2015 15:41:56 -0300
Message-Id: <1439318518-27746-1-git-send-email-mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Linux stack is short; we need to be able to count the number
of bytes used at stack on each function. So, we don't like to
use variable-length arrays, as complained by smatch:

	drivers/media/dvb-frontends/cxd2841er.c:205:19: warning: Variable length array is used.

The max usecase of the driver seems to be 15 bytes + 1 for the
register.

So, let's be safe and allocate 17 bytes for the write buffer.
This should be enough to cover all cases. If not, let's print
an error message.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/dvb-frontends/cxd2841er.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/cxd2841er.c b/drivers/media/dvb-frontends/cxd2841er.c
index 0d1a15109d1e..fdffb2f0ded8 100644
--- a/drivers/media/dvb-frontends/cxd2841er.c
+++ b/drivers/media/dvb-frontends/cxd2841er.c
@@ -33,6 +33,8 @@
 #include "cxd2841er.h"
 #include "cxd2841er_priv.h"
 
+#define MAX_WRITE_REGSIZE	16
+
 enum cxd2841er_state {
 	STATE_SHUTDOWN = 0,
 	STATE_SLEEP_S,
@@ -202,18 +204,24 @@ static int cxd2841er_write_regs(struct cxd2841er_priv *priv,
 				u8 addr, u8 reg, const u8 *data, u32 len)
 {
 	int ret;
-	u8 buf[len+1];
+	u8 buf[MAX_WRITE_REGSIZE + 1];
 	u8 i2c_addr = (addr == I2C_SLVX ?
 		priv->i2c_addr_slvx : priv->i2c_addr_slvt);
 	struct i2c_msg msg[1] = {
 		{
 			.addr = i2c_addr,
 			.flags = 0,
-			.len = sizeof(buf),
+			.len = len + 1,
 			.buf = buf,
 		}
 	};
 
+	if (len + 1 >= sizeof(buf)) {
+		dev_warn(&priv->i2c->dev,"wr reg=%04x: len=%d is too big!\n",
+			 reg, len + 1);
+		return -E2BIG;
+	}
+
 	cxd2841er_i2c_debug(priv, i2c_addr, reg, 1, data, len);
 	buf[0] = reg;
 	memcpy(&buf[1], data, len);
-- 
2.4.3

