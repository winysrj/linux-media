Return-path: <linux-media-owner@vger.kernel.org>
Received: from s87.loopia.se ([194.9.94.112]:59917 "EHLO s87.loopia.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751127AbaHFEwJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Aug 2014 00:52:09 -0400
From: Hans Wennborg <hans@hanshq.net>
To: m.chehab@samsung.com, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Hans Wennborg <hans@hanshq.net>
Subject: [PATCH 04/15] [media] dvb: fix decimal printf format specifiers prefixed with 0x
Date: Tue,  5 Aug 2014 21:42:17 -0700
Message-Id: <1407300137-32480-1-git-send-email-hans@hanshq.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The prefix suggests the number should be printed in hex, so use
the %x specifier to do that.

Found by using regex suggested by Joe Perches.

Signed-off-by: Hans Wennborg <hans@hanshq.net>
---
 drivers/media/dvb-frontends/mb86a16.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/mb86a16.c b/drivers/media/dvb-frontends/mb86a16.c
index 9ae40ab..5939133 100644
--- a/drivers/media/dvb-frontends/mb86a16.c
+++ b/drivers/media/dvb-frontends/mb86a16.c
@@ -115,7 +115,7 @@ static int mb86a16_read(struct mb86a16_state *state, u8 reg, u8 *val)
 	};
 	ret = i2c_transfer(state->i2c_adap, msg, 2);
 	if (ret != 2) {
-		dprintk(verbose, MB86A16_ERROR, 1, "read error(reg=0x%02x, ret=0x%i)",
+		dprintk(verbose, MB86A16_ERROR, 1, "read error(reg=0x%02x, ret=0x%x)",
 			reg, ret);
 
 		return -EREMOTEIO;
-- 
2.0.0.526.g5318336

