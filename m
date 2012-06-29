Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12962 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752201Ab2F2VwB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jun 2012 17:52:01 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q5TLq12i024276
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 29 Jun 2012 17:52:01 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 3/4] [media] drxk: Lock I2C bus during firmware load
Date: Fri, 29 Jun 2012 18:51:56 -0300
Message-Id: <1341006717-32373-4-git-send-email-mchehab@redhat.com>
In-Reply-To: <1341006717-32373-1-git-send-email-mchehab@redhat.com>
References: <20120629124719.2cf23f6b@endymion.delvare>
 <1341006717-32373-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Don't allow other devices at the same I2C bus to use it during
firmware load, in order to prevent using the device while it is
not on a sane state.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/frontends/drxk_hard.c |   29 +++++++++++++++++++++++++++--
 drivers/media/dvb/frontends/drxk_hard.h |    3 +++
 2 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/frontends/drxk_hard.c b/drivers/media/dvb/frontends/drxk_hard.c
index 5b3a17c..87cb3f0 100644
--- a/drivers/media/dvb/frontends/drxk_hard.c
+++ b/drivers/media/dvb/frontends/drxk_hard.c
@@ -28,6 +28,7 @@
 #include <linux/delay.h>
 #include <linux/firmware.h>
 #include <linux/i2c.h>
+#include <linux/hardirq.h>
 #include <asm/div64.h>
 
 #include "dvb_frontend.h"
@@ -308,10 +309,30 @@ static u32 Log10Times100(u32 x)
 /* I2C **********************************************************************/
 /****************************************************************************/
 
+static int drxk_i2c_lock(struct drxk_state *state)
+{
+	i2c_lock_adapter(state->i2c);
+	state->drxk_i2c_exclusive_lock = true;
+
+	return 0;
+}
+
+static void drxk_i2c_unlock(struct drxk_state *state)
+{
+	if (!state->drxk_i2c_exclusive_lock)
+		return;
+
+	i2c_unlock_adapter(state->i2c);
+	state->drxk_i2c_exclusive_lock = false;
+}
+
 static int drxk_i2c_transfer(struct drxk_state *state, struct i2c_msg *msgs,
 			     unsigned len)
 {
-	return i2c_transfer(state->i2c, msgs, len);
+	if (state->drxk_i2c_exclusive_lock)
+		return __i2c_transfer(state->i2c, msgs, len);
+	else
+		return i2c_transfer(state->i2c, msgs, len);
 }
 
 static int i2c_read1(struct drxk_state *state, u8 adr, u8 *val)
@@ -5982,6 +6003,7 @@ static int init_drxk(struct drxk_state *state)
 
 	dprintk(1, "\n");
 	if ((state->m_DrxkState == DRXK_UNINITIALIZED)) {
+		drxk_i2c_lock(state);
 		status = PowerUpDevice(state);
 		if (status < 0)
 			goto error;
@@ -6171,10 +6193,13 @@ static int init_drxk(struct drxk_state *state)
 			strlcat(state->frontend.ops.info.name, " DVB-T",
 				sizeof(state->frontend.ops.info.name));
 		}
+		drxk_i2c_unlock(state);
 	}
 error:
-	if (status < 0)
+	if (status < 0) {
+		drxk_i2c_unlock(state);
 		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
+	}
 
 	return status;
 }
diff --git a/drivers/media/dvb/frontends/drxk_hard.h b/drivers/media/dvb/frontends/drxk_hard.h
index 36677cd..c35ab2b 100644
--- a/drivers/media/dvb/frontends/drxk_hard.h
+++ b/drivers/media/dvb/frontends/drxk_hard.h
@@ -325,6 +325,9 @@ struct drxk_state {
 
 	enum DRXPowerMode m_currentPowerMode;
 
+	/* when true, avoids other devices to use the I2C bus */
+	bool		  drxk_i2c_exclusive_lock;
+
 	/*
 	 * Configurable parameters at the driver. They stores the values found
 	 * at struct drxk_config.
-- 
1.7.10.2

