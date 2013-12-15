Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33574 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487Ab3LOODT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Dec 2013 09:03:19 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Olivier GRENIE <olivier.grenie@parrot.com>,
	Patrick Boettcher <pboettcher@kernellabs.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	stable@vger.kernel.org
Subject: [PATCH 2/3] [media] dib8000: make 32 bits read atomic
Date: Sun, 15 Dec 2013 09:00:09 -0200
Message-Id: <1387105210-6893-3-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1387105210-6893-1-git-send-email-m.chehab@samsung.com>
References: <1387105210-6893-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As the dvb-frontend kthread can be called anytime, it can race
with some get status ioctl. So, it seems better to avoid one to
race with the other while reading a 32 bits register.
I can't see any other reason for having a mutex there at I2C, except
to provide such kind of protection, as the I2C core already has a
mutex to protect I2C transfers.

Note: instead of this approach, it could eventually remove the dib8000
specific mutex for it, and either group the 4 ops into one xfer or
to manually control the I2C mutex. The main advantage of the current
approach is that the changes are smaller and more puntual.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: stable@vger.kernel.org
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/dib8000.c | 33 +++++++++++++++++++++++++--------
 1 file changed, 25 insertions(+), 8 deletions(-)

diff --git a/drivers/media/dvb-frontends/dib8000.c b/drivers/media/dvb-frontends/dib8000.c
index 1e03961135ac..36c839cabe82 100644
--- a/drivers/media/dvb-frontends/dib8000.c
+++ b/drivers/media/dvb-frontends/dib8000.c
@@ -157,15 +157,10 @@ static u16 dib8000_i2c_read16(struct i2c_device *i2c, u16 reg)
 	return ret;
 }
 
-static u16 dib8000_read_word(struct dib8000_state *state, u16 reg)
+static u16 __dib8000_read_word(struct dib8000_state *state, u16 reg)
 {
 	u16 ret;
 
-	if (mutex_lock_interruptible(&state->i2c_buffer_lock) < 0) {
-		dprintk("could not acquire lock");
-		return 0;
-	}
-
 	state->i2c_write_buffer[0] = reg >> 8;
 	state->i2c_write_buffer[1] = reg & 0xff;
 
@@ -183,6 +178,21 @@ static u16 dib8000_read_word(struct dib8000_state *state, u16 reg)
 		dprintk("i2c read error on %d", reg);
 
 	ret = (state->i2c_read_buffer[0] << 8) | state->i2c_read_buffer[1];
+
+	return ret;
+}
+
+static u16 dib8000_read_word(struct dib8000_state *state, u16 reg)
+{
+	u16 ret;
+
+	if (mutex_lock_interruptible(&state->i2c_buffer_lock) < 0) {
+		dprintk("could not acquire lock");
+		return 0;
+	}
+
+	ret = __dib8000_read_word(state, reg);
+
 	mutex_unlock(&state->i2c_buffer_lock);
 
 	return ret;
@@ -192,8 +202,15 @@ static u32 dib8000_read32(struct dib8000_state *state, u16 reg)
 {
 	u16 rw[2];
 
-	rw[0] = dib8000_read_word(state, reg + 0);
-	rw[1] = dib8000_read_word(state, reg + 1);
+	if (mutex_lock_interruptible(&state->i2c_buffer_lock) < 0) {
+		dprintk("could not acquire lock");
+		return 0;
+	}
+
+	rw[0] = __dib8000_read_word(state, reg + 0);
+	rw[1] = __dib8000_read_word(state, reg + 1);
+
+	mutex_unlock(&state->i2c_buffer_lock);
 
 	return ((rw[0] << 16) | (rw[1]));
 }
-- 
1.8.3.1

