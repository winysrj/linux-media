Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52956 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932119AbbHKSnh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Aug 2015 14:43:37 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Sergey Kozlov <serjk@netup.ru>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 3/3] [media] ascot2e: don't use variable length arrays
Date: Tue, 11 Aug 2015 15:41:58 -0300
Message-Id: <1439318518-27746-3-git-send-email-mchehab@osg.samsung.com>
In-Reply-To: <1439318518-27746-1-git-send-email-mchehab@osg.samsung.com>
References: <1439318518-27746-1-git-send-email-mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Linux stack is short; we need to be able to count the number
of bytes used at stack on each function. So, we don't like to
use variable-length arrays, as complained by smatch:
        drivers/media/dvb-frontends/horus3a.c:57:19: warning: Variable length array is used.

The max usecase of the driver seems to be 10 bytes + 1 for the
register.

So, let's be safe and allocate 11 bytes for the write buffer.
This should be enough to cover all cases. If not, let's print
an error message.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/dvb-frontends/ascot2e.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/ascot2e.c b/drivers/media/dvb-frontends/ascot2e.c
index ae7e463c2f9b..f770f6a2c987 100644
--- a/drivers/media/dvb-frontends/ascot2e.c
+++ b/drivers/media/dvb-frontends/ascot2e.c
@@ -26,6 +26,8 @@
 #include "ascot2e.h"
 #include "dvb_frontend.h"
 
+#define MAX_WRITE_REGSIZE 10
+
 enum ascot2e_state {
 	STATE_UNKNOWN,
 	STATE_SLEEP,
@@ -120,16 +122,22 @@ static int ascot2e_write_regs(struct ascot2e_priv *priv,
 			      u8 reg, const u8 *data, u32 len)
 {
 	int ret;
-	u8 buf[len+1];
+	u8 buf[MAX_WRITE_REGSIZE + 1];
 	struct i2c_msg msg[1] = {
 		{
 			.addr = priv->i2c_address,
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
 	ascot2e_i2c_debug(priv, reg, 1, data, len);
 	buf[0] = reg;
 	memcpy(&buf[1], data, len);
-- 
2.4.3

