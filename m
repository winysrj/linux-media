Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49432 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754193AbaCCKIC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 05:08:02 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Shuah Khan <shuah.kh@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH 74/79] [media] drx-j: fix pr_dbg undefined compile errors when DJH_DEBUG is defined
Date: Mon,  3 Mar 2014 07:07:08 -0300
Message-Id: <1393841233-24840-75-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
References: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Shuah Khan <shuah.kh@samsung.com>

drxj.c fails to compile with the following errors when DJH_DEBUG
is defined.

drivers/media/dvb-frontends/drx39xyj/drxj.c:1567:2: error: implicit declaration of function ‘pr_dbg’ [-Werror=implicit-function-declaration]
  pr_dbg("drx3933 i2c operation addr=%x i2c=%p, wc=%x rc=%x\n",
  ^

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/drx39xyj/drxj.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index ed68c52f4e96..a78af4ea93bb 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -1562,7 +1562,7 @@ int drxbsp_i2c_write_read(struct i2c_device_addr *w_dev_addr,
 		 .flags = I2C_M_RD, .buf = r_data, .len = r_count},
 	};
 
-	pr_dbg("drx3933 i2c operation addr=%x i2c=%p, wc=%x rc=%x\n",
+	pr_debug("drx3933 i2c operation addr=%x i2c=%p, wc=%x rc=%x\n",
 	       w_dev_addr->i2c_addr, state->i2c, w_count, r_count);
 
 	if (i2c_transfer(state->i2c, msg, 2) != 2) {
@@ -20640,7 +20640,7 @@ static int drx39xxj_set_frontend(struct dvb_frontend *fe)
 	for (i = 0; i < 2000; i++) {
 		fe_status_t status;
 		drx39xxj_read_status(fe, &status);
-		pr_dbg("i=%d status=%d\n", i, status);
+		pr_debug("i=%d status=%d\n", i, status);
 		msleep(100);
 		i += 100;
 	}
@@ -20663,7 +20663,7 @@ static int drx39xxj_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
 	int result;
 
 #ifdef DJH_DEBUG
-	pr_dbg("i2c gate call: enable=%d state=%d\n", enable,
+	pr_debug("i2c gate call: enable=%d state=%d\n", enable,
 	       state->i2c_gate_open);
 #endif
 
-- 
1.8.5.3

