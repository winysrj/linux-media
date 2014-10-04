Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:32866 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbaJDSnU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 4 Oct 2014 14:43:20 -0400
Date: Sun, 5 Oct 2014 00:13:16 +0530
From: Stevean Raja Kumar <rk.stevean@gmail.com>
To: m.chehab@samsung.com, gregkh@linuxfoundation.org,
	rk.stevean@gmail.com, aybuke.147@gmail.com,
	tapaswenipathak@gmail.com, paul.gortmaker@windriver.com,
	monamagarwal123@gmail.com, linux-media@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: media: Added semicolon.
Message-ID: <20141004184316.GA6561@srkjfone>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Added semicolon for the line usleep_range(10000, 11000);

Signed-off-by: Stevean Raja Kumar <rk.stevean@gmail.com>
---
 drivers/staging/media/cxd2099/cxd2099.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/cxd2099/cxd2099.c b/drivers/staging/media/cxd2099/cxd2099.c
index cda1595..657ea48 100644
--- a/drivers/staging/media/cxd2099/cxd2099.c
+++ b/drivers/staging/media/cxd2099/cxd2099.c
@@ -527,7 +527,7 @@ static int slot_reset(struct dvb_ca_en50221 *ca, int slot)
 		u8 val;
 #endif
 		for (i = 0; i < 100; i++) {
-			usleep_range(10000, 11000)
+			usleep_range(10000, 11000);
 #if 0
 			read_reg(ci, 0x06, &val);
 			dev_info(&ci->i2c->dev, "%d:%02x\n", i, val);
-- 
1.9.1

