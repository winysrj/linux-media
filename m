Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49299 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988AbaCCKHt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 05:07:49 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH 07/79] [media] drx-j: remove the "const" annotate on HICommand()
Date: Mon,  3 Mar 2014 07:06:01 -0300
Message-Id: <1393841233-24840-8-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
References: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mauro Carvalho Chehab <mchehab@redhat.com>

After removing the typedef, it is now clear that HICommand() were
abusing of a var that was expecting to be constant:

drivers/media/dvb-frontends/drx39xyj/drxj.c: In function ‘HICommand’:
drivers/media/dvb-frontends/drx39xyj/drxj.c:2272:3: warning: passing argument 1 of ‘drxDapDRXJFunct_g.writeReg16Func’ discards ‘const’ qualifier from pointer target type [enabled by default]
drivers/media/dvb-frontends/drx39xyj/drxj.c:2272:3: note: expected ‘struct i2c_device_addr *’ but argument is of type ‘const struct i2c_device_addr *’
drivers/media/dvb-frontends/drx39xyj/drxj.c:2273:3: warning: passing argument 1 of ‘drxDapDRXJFunct_g.writeReg16Func’ discards ‘const’ qualifier from pointer target type [enabled by default]
drivers/media/dvb-frontends/drx39xyj/drxj.c:2273:3: note: expected ‘struct i2c_device_addr *’ but argument is of type ‘const struct i2c_device_addr *’
drivers/media/dvb-frontends/drx39xyj/drxj.c:2274:3: warning: passing argument 1 of ‘drxDapDRXJFunct_g.writeReg16Func’ discards ‘const’ qualifier from pointer target type [enabled by default]
drivers/media/dvb-frontends/drx39xyj/drxj.c:2274:3: note: expected ‘struct i2c_device_addr *’ but argument is of type ‘const struct i2c_device_addr *’
drivers/media/dvb-frontends/drx39xyj/drxj.c:2275:3: warning: passing argument 1 of ‘drxDapDRXJFunct_g.writeReg16Func’ discards ‘const’ qualifier from pointer target type [enabled by default]
drivers/media/dvb-frontends/drx39xyj/drxj.c:2275:3: note: expected ‘struct i2c_device_addr *’ but argument is of type ‘const struct i2c_device_addr *’
drivers/media/dvb-frontends/drx39xyj/drxj.c:2278:3: warning: passing argument 1 of ‘drxDapDRXJFunct_g.writeReg16Func’ discards ‘const’ qualifier from pointer target type [enabled by default]
drivers/media/dvb-frontends/drx39xyj/drxj.c:2278:3: note: expected ‘struct i2c_device_addr *’ but argument is of type ‘const struct i2c_device_addr *’
drivers/media/dvb-frontends/drx39xyj/drxj.c:2279:3: warning: passing argument 1 of ‘drxDapDRXJFunct_g.writeReg16Func’ discards ‘const’ qualifier from pointer target type [enabled by default]
drivers/media/dvb-frontends/drx39xyj/drxj.c:2279:3: note: expected ‘struct i2c_device_addr *’ but argument is of type ‘const struct i2c_device_addr *’
drivers/media/dvb-frontends/drx39xyj/drxj.c:2291:2: warning: passing argument 1 of ‘drxDapDRXJFunct_g.writeReg16Func’ discards ‘const’ qualifier from pointer target type [enabled by default]
drivers/media/dvb-frontends/drx39xyj/drxj.c:2291:2: note: expected ‘struct i2c_device_addr *’ but argument is of type ‘const struct i2c_device_addr *’
drivers/media/dvb-frontends/drx39xyj/drxj.c:2311:4: warning: passing argument 1 of ‘drxDapDRXJFunct_g.readReg16Func’ discards ‘const’ qualifier from pointer target type [enabled by default]
drivers/media/dvb-frontends/drx39xyj/drxj.c:2311:4: note: expected ‘struct i2c_device_addr *’ but argument is of type ‘const struct i2c_device_addr *’
drivers/media/dvb-frontends/drx39xyj/drxj.c:2315:3: warning: passing argument 1 of ‘drxDapDRXJFunct_g.readReg16Func’ discards ‘const’ qualifier from pointer target type [enabled by default]
drivers/media/dvb-frontends/drx39xyj/drxj.c:2315:3: note: expected ‘struct i2c_device_addr *’ but argument is of type ‘const struct i2c_device_addr *’

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/drx39xyj/drxj.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index 84f4e1823925..a41b2a9fe9b4 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -1146,7 +1146,7 @@ FUNCTIONS
 ----------------------------------------------------------------------------*/
 /* Some prototypes */
 static DRXStatus_t
-HICommand(const struct i2c_device_addr *devAddr,
+HICommand(struct i2c_device_addr *devAddr,
 	  const pDRXJHiCmd_t cmd, pu16_t result);
 
 static DRXStatus_t
@@ -2258,7 +2258,7 @@ rw_error:
 *
 */
 static DRXStatus_t
-HICommand(const struct i2c_device_addr *devAddr, const pDRXJHiCmd_t cmd, pu16_t result)
+HICommand(struct i2c_device_addr *devAddr, const pDRXJHiCmd_t cmd, pu16_t result)
 {
 	u16_t waitCmd = 0;
 	u16_t nrRetries = 0;
-- 
1.8.5.3

