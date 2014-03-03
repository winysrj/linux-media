Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49414 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754181AbaCCKIA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 05:08:00 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Shuah Khan <shuah.kh@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH 76/79] [media] drx-j: fix boot failure due to null pointer dereference
Date: Mon,  3 Mar 2014 07:07:10 -0300
Message-Id: <1393841233-24840-77-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
References: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Shuah Khan <shuah.kh@samsung.com>

DJH_DEBUG only code path in drxbsp_i2c_write_read() dereferences
w_dev_addr and subsequently w_dev_addr->user_data->i2c which results
in failure during boot. This patch fixes the null pointer derefence
bug as well as the following compile errors:

  LD      arch/x86/built-in.o
  CC      drivers/media/dvb-frontends/drx39xyj/drxj.o
drivers/media/dvb-frontends/drx39xyj/drxj.c: In function ‘drxbsp_i2c_write_read’:
drivers/media/dvb-frontends/drx39xyj/drxj.c:1558:25: error: redeclaration of ‘state’ with no linkage
  struct drx39xxj_state *state = w_dev_addr->user_data;
                         ^
drivers/media/dvb-frontends/drx39xyj/drxj.c:1512:25: note: previous declaration of ‘state’ was here
  struct drx39xxj_state *state;
                         ^
drivers/media/dvb-frontends/drx39xyj/drxj.c:1558:2: warning: ISO C90 forbids mixed declarations and code [-Wdeclaration-after-statement]
  struct drx39xxj_state *state = w_dev_addr->user_data;
  ^
drivers/media/dvb-frontends/drx39xyj/drxj.c:1560:17: error: redeclaration of ‘msg’ with no linkage
  struct i2c_msg msg[2] = {
                 ^
drivers/media/dvb-frontends/drx39xyj/drxj.c:1513:17: note: previous declaration of ‘msg’ was here
  struct i2c_msg msg[2];
                 ^

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/drx39xyj/drxj.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index 72c541a3c6c0..585d891392c3 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -1551,14 +1551,23 @@ int drxbsp_i2c_write_read(struct i2c_device_addr *w_dev_addr,
 	}
 
 #ifdef DJH_DEBUG
-	struct drx39xxj_state *state = w_dev_addr->user_data;
+	if (w_dev_addr == NULL || r_dev_addr == NULL)
+		return 0;
 
-	struct i2c_msg msg[2] = {
-		{.addr = w_dev_addr->i2c_addr,
-		 .flags = 0, .buf = wData, .len = w_count},
-		{.addr = r_dev_addr->i2c_addr,
-		 .flags = I2C_M_RD, .buf = r_data, .len = r_count},
-	};
+	state = w_dev_addr->user_data;
+
+	if (state->i2c == NULL)
+		return 0;
+
+	msg[0].addr = w_dev_addr->i2c_addr;
+	msg[0].flags = 0;
+	msg[0].buf = wData;
+	msg[0].len = w_count;
+	msg[1].addr = r_dev_addr->i2c_addr;
+	msg[1].flags = I2C_M_RD;
+	msg[1].buf = r_data;
+	msg[1].len = r_count;
+	num_msgs = 2;
 
 	pr_debug("drx3933 i2c operation addr=%x i2c=%p, wc=%x rc=%x\n",
 	       w_dev_addr->i2c_addr, state->i2c, w_count, r_count);
-- 
1.8.5.3

