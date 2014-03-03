Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49464 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754211AbaCCKIH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 05:08:07 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 62/79] [media] drx-j: use the proper timeout code on scu_command
Date: Mon,  3 Mar 2014 07:06:56 -0300
Message-Id: <1393841233-24840-63-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
References: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Checking if a time is after another one can have issues, as
times are generally u32 wide.

Use the proper macros for that at scu_command().

It should be noticed that other places also use jiffies
calculus on an improper way. This should be fixed too,
but the logic there is more complex. So, let's do it in
separate patches.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/drx39xyj/drxj.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index b1a7dfeec489..c843d8f4a96a 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -4417,8 +4417,8 @@ rw_error:
 static int scu_command(struct i2c_device_addr *dev_addr, struct drxjscu_cmd *cmd)
 {
 	int rc;
-	u32 start_time = 0;
 	u16 cur_cmd = 0;
+	unsigned long timeout;
 
 	/* Check param */
 	if (cmd == NULL)
@@ -4478,15 +4478,17 @@ static int scu_command(struct i2c_device_addr *dev_addr, struct drxjscu_cmd *cmd
 	}
 
 	/* Wait until SCU has processed command */
-	start_time = jiffies_to_msecs(jiffies);
-	do {
+	timeout = jiffies + msecs_to_jiffies(DRXJ_MAX_WAITTIME);
+	while (time_is_after_jiffies(timeout)) {
 		rc = DRXJ_DAP.read_reg16func(dev_addr, SCU_RAM_COMMAND__A, &cur_cmd, 0);
 		if (rc != 0) {
 			pr_err("error %d\n", rc);
 			goto rw_error;
 		}
-	} while (!(cur_cmd == DRX_SCU_READY)
-		 && ((jiffies_to_msecs(jiffies) - start_time) < DRXJ_MAX_WAITTIME));
+		if (cur_cmd == DRX_SCU_READY)
+			break;
+		usleep_range(1000, 2000);
+	}
 
 	if (cur_cmd != DRX_SCU_READY)
 		return -EIO;
-- 
1.8.5.3

