Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49437 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754194AbaCCKID (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 05:08:03 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 32/79] [media] drx-j: Replace printk's by pr_foo()
Date: Mon,  3 Mar 2014 07:06:26 -0300
Message-Id: <1393841233-24840-33-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
References: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using printk's, use the pr_foo() macros.

That fixes some checkpatch warnings and provide a better error,
warning and debug support.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/drx39xyj/drx39xxj.c    | 36 ++++++++++++----------
 .../media/dvb-frontends/drx39xyj/drx39xxj_dummy.c  | 10 +++---
 drivers/media/dvb-frontends/drx39xyj/drxj.c        |  2 +-
 3 files changed, 26 insertions(+), 22 deletions(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drx39xxj.c b/drivers/media/dvb-frontends/drx39xyj/drx39xxj.c
index 6db009e2d705..e5f276f5d215 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx39xxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drx39xxj.c
@@ -19,6 +19,8 @@
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.=
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ":%s: " fmt, __func__
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/string.h>
@@ -44,7 +46,7 @@ static int drx39xxj_set_powerstate(struct dvb_frontend *fe, int enable)
 
 	result = drx_ctrl(demod, DRX_CTRL_POWER_MODE, &power_mode);
 	if (result != 0) {
-		printk(KERN_ERR "Power state change failed\n");
+		pr_err("Power state change failed\n");
 		return 0;
 	}
 
@@ -63,14 +65,14 @@ static int drx39xxj_read_status(struct dvb_frontend *fe, fe_status_t *status)
 
 	result = drx_ctrl(demod, DRX_CTRL_LOCK_STATUS, &lock_status);
 	if (result != 0) {
-		printk(KERN_ERR "drx39xxj: could not get lock status!\n");
+		pr_err("drx39xxj: could not get lock status!\n");
 		*status = 0;
 	}
 
 	switch (lock_status) {
 	case DRX_NEVER_LOCK:
 		*status = 0;
-		printk(KERN_ERR "drx says NEVER_LOCK\n");
+		pr_err("drx says NEVER_LOCK\n");
 		break;
 	case DRX_NOT_LOCKED:
 		*status = 0;
@@ -93,7 +95,7 @@ static int drx39xxj_read_status(struct dvb_frontend *fe, fe_status_t *status)
 		    | FE_HAS_VITERBI | FE_HAS_SYNC | FE_HAS_LOCK;
 		break;
 	default:
-		printk(KERN_ERR "Lock state unknown %d\n", lock_status);
+		pr_err("Lock state unknown %d\n", lock_status);
 	}
 
 	return 0;
@@ -108,7 +110,7 @@ static int drx39xxj_read_ber(struct dvb_frontend *fe, u32 *ber)
 
 	result = drx_ctrl(demod, DRX_CTRL_SIG_QUALITY, &sig_quality);
 	if (result != 0) {
-		printk(KERN_ERR "drx39xxj: could not get ber!\n");
+		pr_err("drx39xxj: could not get ber!\n");
 		*ber = 0;
 		return 0;
 	}
@@ -127,7 +129,7 @@ static int drx39xxj_read_signal_strength(struct dvb_frontend *fe,
 
 	result = drx_ctrl(demod, DRX_CTRL_SIG_QUALITY, &sig_quality);
 	if (result != 0) {
-		printk(KERN_ERR "drx39xxj: could not get signal strength!\n");
+		pr_err("drx39xxj: could not get signal strength!\n");
 		*strength = 0;
 		return 0;
 	}
@@ -146,7 +148,7 @@ static int drx39xxj_read_snr(struct dvb_frontend *fe, u16 *snr)
 
 	result = drx_ctrl(demod, DRX_CTRL_SIG_QUALITY, &sig_quality);
 	if (result != 0) {
-		printk(KERN_ERR "drx39xxj: could not read snr!\n");
+		pr_err("drx39xxj: could not read snr!\n");
 		*snr = 0;
 		return 0;
 	}
@@ -164,7 +166,7 @@ static int drx39xxj_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
 
 	result = drx_ctrl(demod, DRX_CTRL_SIG_QUALITY, &sig_quality);
 	if (result != 0) {
-		printk(KERN_ERR "drx39xxj: could not get uc blocks!\n");
+		pr_err("drx39xxj: could not get uc blocks!\n");
 		*ucblocks = 0;
 		return 0;
 	}
@@ -218,7 +220,7 @@ static int drx39xxj_set_frontend(struct dvb_frontend *fe)
 		/* Set the standard (will be powered up if necessary */
 		result = drx_ctrl(demod, DRX_CTRL_SET_STANDARD, &standard);
 		if (result != 0) {
-			printk(KERN_ERR "Failed to set standard! result=%02x\n",
+			pr_err("Failed to set standard! result=%02x\n",
 			       result);
 			return -EINVAL;
 		}
@@ -235,7 +237,7 @@ static int drx39xxj_set_frontend(struct dvb_frontend *fe)
 	/* program channel */
 	result = drx_ctrl(demod, DRX_CTRL_SET_CHANNEL, &channel);
 	if (result != 0) {
-		printk(KERN_ERR "Failed to set channel!\n");
+		pr_err("Failed to set channel!\n");
 		return -EINVAL;
 	}
 	/* Just for giggles, let's shut off the LNA again.... */
@@ -243,14 +245,14 @@ static int drx39xxj_set_frontend(struct dvb_frontend *fe)
 	uio_data.value = false;
 	result = drx_ctrl(demod, DRX_CTRL_UIO_WRITE, &uio_data);
 	if (result != 0) {
-		printk(KERN_ERR "Failed to disable LNA!\n");
+		pr_err("Failed to disable LNA!\n");
 		return 0;
 	}
 #ifdef DJH_DEBUG
 	for (i = 0; i < 2000; i++) {
 		fe_status_t status;
 		drx39xxj_read_status(fe, &status);
-		printk(KERN_DBG "i=%d status=%d\n", i, status);
+		pr_dbg("i=%d status=%d\n", i, status);
 		msleep(100);
 		i += 100;
 	}
@@ -273,7 +275,7 @@ static int drx39xxj_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
 	int result;
 
 #ifdef DJH_DEBUG
-	printk(KERN_DBG "i2c gate call: enable=%d state=%d\n", enable,
+	pr_dbg("i2c gate call: enable=%d state=%d\n", enable,
 	       state->i2c_gate_open);
 #endif
 
@@ -289,7 +291,7 @@ static int drx39xxj_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
 
 	result = drx_ctrl(demod, DRX_CTRL_I2C_BRIDGE, &i2c_gate_state);
 	if (result != 0) {
-		printk(KERN_ERR "drx39xxj: could not open i2c gate [%d]\n",
+		pr_err("drx39xxj: could not open i2c gate [%d]\n",
 		       result);
 		dump_stack();
 	} else {
@@ -383,7 +385,7 @@ struct dvb_frontend *drx39xxj_attach(struct i2c_adapter *i2c)
 
 	result = drx_open(demod);
 	if (result != 0) {
-		printk(KERN_ERR "DRX open failed!  Aborting\n");
+		pr_err("DRX open failed!  Aborting\n");
 		kfree(state);
 		return NULL;
 	}
@@ -394,7 +396,7 @@ struct dvb_frontend *drx39xxj_attach(struct i2c_adapter *i2c)
 	/* Configure user-I/O #3: enable read/write */
 	result = drx_ctrl(demod, DRX_CTRL_UIO_CFG, &uio_cfg);
 	if (result != 0) {
-		printk(KERN_ERR "Failed to setup LNA GPIO!\n");
+		pr_err("Failed to setup LNA GPIO!\n");
 		return NULL;
 	}
 
@@ -402,7 +404,7 @@ struct dvb_frontend *drx39xxj_attach(struct i2c_adapter *i2c)
 	uio_data.value = false;
 	result = drx_ctrl(demod, DRX_CTRL_UIO_WRITE, &uio_data);
 	if (result != 0) {
-		printk(KERN_ERR "Failed to disable LNA!\n");
+		pr_err("Failed to disable LNA!\n");
 		return NULL;
 	}
 
diff --git a/drivers/media/dvb-frontends/drx39xyj/drx39xxj_dummy.c b/drivers/media/dvb-frontends/drx39xyj/drx39xxj_dummy.c
index 854077419118..c5187a14a03f 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx39xxj_dummy.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drx39xxj_dummy.c
@@ -1,3 +1,5 @@
+#define pr_fmt(fmt) KBUILD_MODNAME ":%s: " fmt, __func__
+
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/module.h>
@@ -99,11 +101,11 @@ int drxbsp_i2c_write_read(struct i2c_device_addr *w_dev_addr,
 	}
 
 	if (state->i2c == NULL) {
-		printk("i2c was zero, aborting\n");
+		pr_err("i2c was zero, aborting\n");
 		return 0;
 	}
 	if (i2c_transfer(state->i2c, msg, num_msgs) != num_msgs) {
-		printk(KERN_WARNING "drx3933: I2C write/read failed\n");
+		pr_warn("drx3933: I2C write/read failed\n");
 		return -EREMOTEIO;
 	}
 
@@ -119,11 +121,11 @@ int drxbsp_i2c_write_read(struct i2c_device_addr *w_dev_addr,
 		 .flags = I2C_M_RD, .buf = r_data, .len = r_count},
 	};
 
-	printk("drx3933 i2c operation addr=%x i2c=%p, wc=%x rc=%x\n",
+	pr_dbg("drx3933 i2c operation addr=%x i2c=%p, wc=%x rc=%x\n",
 	       w_dev_addr->i2c_addr, state->i2c, w_count, r_count);
 
 	if (i2c_transfer(state->i2c, msg, 2) != 2) {
-		printk(KERN_WARNING "drx3933: I2C write/read failed\n");
+		pr_warn("drx3933: I2C write/read failed\n");
 		return -EREMOTEIO;
 	}
 #endif
diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index 811e09c61ba1..aafe6dffdab5 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -35,7 +35,7 @@
 INCLUDE FILES
 ----------------------------------------------------------------------------*/
 
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+#define pr_fmt(fmt) KBUILD_MODNAME ":%s: " fmt, __func__
 
 #include "drxj.h"
 #include "drxj_map.h"
-- 
1.8.5.3

