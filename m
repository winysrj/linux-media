Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49498 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754239AbaCCKIO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 05:08:14 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 57/79] [media] drx-j: remove some ugly bindings from drx39xxj_dummy.c
Date: Mon,  3 Mar 2014 07:06:51 -0300
Message-Id: <1393841233-24840-58-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
References: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This file does an ugly binding between drxj and DVB frontend.

Remove most of the functions there. We still need to get rid of
get_frequency and set_frequency, but such patch is a little more
complex, as it should also remove some previous tuner bindings.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 .../media/dvb-frontends/drx39xyj/drx39xxj_dummy.c  | 114 +--------------------
 .../media/dvb-frontends/drx39xyj/drx_dap_fasi.c    |  81 ++++++++++++++-
 drivers/media/dvb-frontends/drx39xyj/drx_driver.h  |  21 ----
 drivers/media/dvb-frontends/drx39xyj/drxj.c        |  86 ++++++----------
 4 files changed, 113 insertions(+), 189 deletions(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drx39xxj_dummy.c b/drivers/media/dvb-frontends/drx39xyj/drx39xxj_dummy.c
index c5187a14a03f..33413cda5290 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx39xxj_dummy.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drx39xxj_dummy.c
@@ -1,27 +1,8 @@
-#define pr_fmt(fmt) KBUILD_MODNAME ":%s: " fmt, __func__
+/* Dummy function to satisfy drxj.c */
 
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/string.h>
-#include <linux/slab.h>
-#include <linux/delay.h>
-#include <linux/jiffies.h>
 #include <linux/types.h>
-
 #include "drx_driver.h"
-#include "drx39xxj.h"
 
-/* Dummy function to satisfy drxj.c */
-int drxbsp_tuner_open(struct tuner_instance *tuner)
-{
-	return 0;
-}
-
-int drxbsp_tuner_close(struct tuner_instance *tuner)
-{
-	return 0;
-}
 
 int drxbsp_tuner_set_frequency(struct tuner_instance *tuner,
 				      u32 mode,
@@ -38,96 +19,3 @@ drxbsp_tuner_get_frequency(struct tuner_instance *tuner,
 {
 	return 0;
 }
-
-int drxbsp_hst_sleep(u32 n)
-{
-	msleep(n);
-	return 0;
-}
-
-u32 drxbsp_hst_clock(void)
-{
-	return jiffies_to_msecs(jiffies);
-}
-
-int drxbsp_hst_memcmp(void *s1, void *s2, u32 n)
-{
-	return memcmp(s1, s2, (size_t)n);
-}
-
-void *drxbsp_hst_memcpy(void *to, void *from, u32 n)
-{
-	return memcpy(to, from, (size_t)n);
-}
-
-int drxbsp_i2c_write_read(struct i2c_device_addr *w_dev_addr,
-				 u16 w_count,
-				 u8 *wData,
-				 struct i2c_device_addr *r_dev_addr,
-				 u16 r_count, u8 *r_data)
-{
-	struct drx39xxj_state *state;
-	struct i2c_msg msg[2];
-	unsigned int num_msgs;
-
-	if (w_dev_addr == NULL) {
-		/* Read only */
-		state = r_dev_addr->user_data;
-		msg[0].addr = r_dev_addr->i2c_addr >> 1;
-		msg[0].flags = I2C_M_RD;
-		msg[0].buf = r_data;
-		msg[0].len = r_count;
-		num_msgs = 1;
-	} else if (r_dev_addr == NULL) {
-		/* Write only */
-		state = w_dev_addr->user_data;
-		msg[0].addr = w_dev_addr->i2c_addr >> 1;
-		msg[0].flags = 0;
-		msg[0].buf = wData;
-		msg[0].len = w_count;
-		num_msgs = 1;
-	} else {
-		/* Both write and read */
-		state = w_dev_addr->user_data;
-		msg[0].addr = w_dev_addr->i2c_addr >> 1;
-		msg[0].flags = 0;
-		msg[0].buf = wData;
-		msg[0].len = w_count;
-		msg[1].addr = r_dev_addr->i2c_addr >> 1;
-		msg[1].flags = I2C_M_RD;
-		msg[1].buf = r_data;
-		msg[1].len = r_count;
-		num_msgs = 2;
-	}
-
-	if (state->i2c == NULL) {
-		pr_err("i2c was zero, aborting\n");
-		return 0;
-	}
-	if (i2c_transfer(state->i2c, msg, num_msgs) != num_msgs) {
-		pr_warn("drx3933: I2C write/read failed\n");
-		return -EREMOTEIO;
-	}
-
-	return 0;
-
-#ifdef DJH_DEBUG
-	struct drx39xxj_state *state = w_dev_addr->user_data;
-
-	struct i2c_msg msg[2] = {
-		{.addr = w_dev_addr->i2c_addr,
-		 .flags = 0, .buf = wData, .len = w_count},
-		{.addr = r_dev_addr->i2c_addr,
-		 .flags = I2C_M_RD, .buf = r_data, .len = r_count},
-	};
-
-	pr_dbg("drx3933 i2c operation addr=%x i2c=%p, wc=%x rc=%x\n",
-	       w_dev_addr->i2c_addr, state->i2c, w_count, r_count);
-
-	if (i2c_transfer(state->i2c, msg, 2) != 2) {
-		pr_warn("drx3933: I2C write/read failed\n");
-		return -EREMOTEIO;
-	}
-#endif
-	return 0;
-}
diff --git a/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c b/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c
index 2a37098f2152..b78d45b68668 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c
@@ -39,7 +39,11 @@
 */
 
 #include "drx_dap_fasi.h"
-#include "drx_driver.h"		/* for drxbsp_hst_memcpy() */
+#include "drx39xxj.h"
+
+#include <linux/delay.h>
+#include <linux/jiffies.h>
+
 
 /*============================================================================*/
 
@@ -172,6 +176,79 @@ static int drxdap_fasi_read_modify_write_reg32(struct i2c_device_addr *dev_addr,
 	return -EIO;
 }
 
+
+int drxbsp_i2c_write_read(struct i2c_device_addr *w_dev_addr,
+				 u16 w_count,
+				 u8 *wData,
+				 struct i2c_device_addr *r_dev_addr,
+				 u16 r_count, u8 *r_data)
+{
+	struct drx39xxj_state *state;
+	struct i2c_msg msg[2];
+	unsigned int num_msgs;
+
+	if (w_dev_addr == NULL) {
+		/* Read only */
+		state = r_dev_addr->user_data;
+		msg[0].addr = r_dev_addr->i2c_addr >> 1;
+		msg[0].flags = I2C_M_RD;
+		msg[0].buf = r_data;
+		msg[0].len = r_count;
+		num_msgs = 1;
+	} else if (r_dev_addr == NULL) {
+		/* Write only */
+		state = w_dev_addr->user_data;
+		msg[0].addr = w_dev_addr->i2c_addr >> 1;
+		msg[0].flags = 0;
+		msg[0].buf = wData;
+		msg[0].len = w_count;
+		num_msgs = 1;
+	} else {
+		/* Both write and read */
+		state = w_dev_addr->user_data;
+		msg[0].addr = w_dev_addr->i2c_addr >> 1;
+		msg[0].flags = 0;
+		msg[0].buf = wData;
+		msg[0].len = w_count;
+		msg[1].addr = r_dev_addr->i2c_addr >> 1;
+		msg[1].flags = I2C_M_RD;
+		msg[1].buf = r_data;
+		msg[1].len = r_count;
+		num_msgs = 2;
+	}
+
+	if (state->i2c == NULL) {
+		pr_err("i2c was zero, aborting\n");
+		return 0;
+	}
+	if (i2c_transfer(state->i2c, msg, num_msgs) != num_msgs) {
+		pr_warn("drx3933: I2C write/read failed\n");
+		return -EREMOTEIO;
+	}
+
+	return 0;
+
+#ifdef DJH_DEBUG
+	struct drx39xxj_state *state = w_dev_addr->user_data;
+
+	struct i2c_msg msg[2] = {
+		{.addr = w_dev_addr->i2c_addr,
+		 .flags = 0, .buf = wData, .len = w_count},
+		{.addr = r_dev_addr->i2c_addr,
+		 .flags = I2C_M_RD, .buf = r_data, .len = r_count},
+	};
+
+	pr_dbg("drx3933 i2c operation addr=%x i2c=%p, wc=%x rc=%x\n",
+	       w_dev_addr->i2c_addr, state->i2c, w_count, r_count);
+
+	if (i2c_transfer(state->i2c, msg, 2) != 2) {
+		pr_warn("drx3933: I2C write/read failed\n");
+		return -EREMOTEIO;
+	}
+#endif
+	return 0;
+}
+
 /*============================================================================*/
 
 /******************************
@@ -515,7 +592,7 @@ static int drxdap_fasi_write_block(struct i2c_device_addr *dev_addr,
 			    (data_block_size <
 			     datasize ? data_block_size : datasize);
 		}
-		drxbsp_hst_memcpy(&buf[bufx], data, todo);
+		memcpy(&buf[bufx], data, todo);
 		/* write (address if can do and) data */
 		st = drxbsp_i2c_write_read(dev_addr,
 					  (u16) (bufx + todo),
diff --git a/drivers/media/dvb-frontends/drx39xyj/drx_driver.h b/drivers/media/dvb-frontends/drx39xyj/drx_driver.h
index daa9027983e8..1aff810b57da 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx_driver.h
+++ b/drivers/media/dvb-frontends/drx39xyj/drx_driver.h
@@ -225,10 +225,6 @@ struct tuner_instance {
 	struct tuner_ops *my_funct;
 };
 
-int drxbsp_tuner_open(struct tuner_instance *tuner);
-
-int drxbsp_tuner_close(struct tuner_instance *tuner);
-
 int drxbsp_tuner_set_frequency(struct tuner_instance *tuner,
 					u32 mode,
 					s32 frequency);
@@ -238,9 +234,6 @@ int drxbsp_tuner_get_frequency(struct tuner_instance *tuner,
 					s32 *r_ffrequency,
 					s32 *i_ffrequency);
 
-int drxbsp_tuner_lock_status(struct tuner_instance *tuner,
-					enum tuner_lock_status *lock_stat);
-
 int drxbsp_tuner_default_i2c_write_read(struct tuner_instance *tuner,
 						struct i2c_device_addr *w_dev_addr,
 						u16 w_count,
@@ -248,20 +241,6 @@ int drxbsp_tuner_default_i2c_write_read(struct tuner_instance *tuner,
 						struct i2c_device_addr *r_dev_addr,
 						u16 r_count, u8 *r_data);
 
-int drxbsp_hst_init(void);
-
-int drxbsp_hst_term(void);
-
-void *drxbsp_hst_memcpy(void *to, void *from, u32 n);
-
-int drxbsp_hst_memcmp(void *s1, void *s2, u32 n);
-
-u32 drxbsp_hst_clock(void);
-
-int drxbsp_hst_sleep(u32 n);
-
-
-
 /**************
 *
 * This section configures the DRX Data Access Protocols (DAPs).
diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index 0dfb338731a4..08e32d70269a 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -1710,7 +1710,7 @@ static int drxj_dap_read_aud_reg16(struct i2c_device_addr *dev_addr,
 		addr &= (~write_bit);
 
 		/* Set up read */
-		start_timer = drxbsp_hst_clock();
+		start_timer = jiffies_to_msecs(jiffies);
 		do {
 			/* RMW to aud TR IF until request is granted or timeout */
 			stat = drxj_dap_read_modify_write_reg16(dev_addr,
@@ -1721,7 +1721,7 @@ static int drxj_dap_read_aud_reg16(struct i2c_device_addr *dev_addr,
 			if (stat != 0)
 				break;
 
-			current_timer = drxbsp_hst_clock();
+			current_timer = jiffies_to_msecs(jiffies);
 			delta_timer = current_timer - start_timer;
 			if (delta_timer > DRXJ_DAP_AUDTRIF_TIMEOUT) {
 				stat = -EIO;
@@ -1736,7 +1736,7 @@ static int drxj_dap_read_aud_reg16(struct i2c_device_addr *dev_addr,
 
 	/* Wait for read ready status or timeout */
 	if (stat == 0) {
-		start_timer = drxbsp_hst_clock();
+		start_timer = jiffies_to_msecs(jiffies);
 
 		while ((tr_status & AUD_TOP_TR_CTR_FIFO_RD_RDY__M) !=
 		       AUD_TOP_TR_CTR_FIFO_RD_RDY_READY) {
@@ -1746,7 +1746,7 @@ static int drxj_dap_read_aud_reg16(struct i2c_device_addr *dev_addr,
 			if (stat != 0)
 				break;
 
-			current_timer = drxbsp_hst_clock();
+			current_timer = jiffies_to_msecs(jiffies);
 			delta_timer = current_timer - start_timer;
 			if (delta_timer > DRXJ_DAP_AUDTRIF_TIMEOUT) {
 				stat = -EIO;
@@ -1846,7 +1846,7 @@ static int drxj_dap_write_aud_reg16(struct i2c_device_addr *dev_addr,
 
 		/* Force write bit */
 		addr |= write_bit;
-		start_timer = drxbsp_hst_clock();
+		start_timer = jiffies_to_msecs(jiffies);
 		do {
 			/* RMW to aud TR IF until request is granted or timeout */
 			stat = drxj_dap_read_modify_write_reg16(dev_addr,
@@ -1856,7 +1856,7 @@ static int drxj_dap_write_aud_reg16(struct i2c_device_addr *dev_addr,
 			if (stat != 0)
 				break;
 
-			current_timer = drxbsp_hst_clock();
+			current_timer = jiffies_to_msecs(jiffies);
 			delta_timer = current_timer - start_timer;
 			if (delta_timer > DRXJ_DAP_AUDTRIF_TIMEOUT) {
 				stat = -EIO;
@@ -2160,7 +2160,7 @@ hi_command(struct i2c_device_addr *dev_addr, const struct drxj_hi_cmd *cmd, u16
 	}
 
 	if ((cmd->cmd) == SIO_HI_RA_RAM_CMD_RESET)
-		drxbsp_hst_sleep(1);
+		msleep(1);
 
 	/* Detect power down to ommit reading result */
 	powerdown_cmd = (bool) ((cmd->cmd == SIO_HI_RA_RAM_CMD_CONFIG) &&
@@ -2519,7 +2519,7 @@ static int power_up_device(struct drx_demod_instance *demod)
 		drxbsp_i2c_write_read(&wake_up_addr, 1, &data,
 				      (struct i2c_device_addr *)(NULL), 0,
 				     (u8 *)(NULL));
-		drxbsp_hst_sleep(10);
+		msleep(10);
 		retry_count++;
 	} while ((drxbsp_i2c_write_read
 		  ((struct i2c_device_addr *) (NULL), 0, (u8 *)(NULL), dev_addr, 1,
@@ -2527,7 +2527,7 @@ static int power_up_device(struct drx_demod_instance *demod)
 		  != 0) && (retry_count < DRXJ_MAX_RETRIES_POWERUP));
 
 	/* Need some recovery time .... */
-	drxbsp_hst_sleep(10);
+	msleep(10);
 
 	if (retry_count == DRXJ_MAX_RETRIES_POWERUP)
 		return -EIO;
@@ -4351,14 +4351,14 @@ ctrl_set_cfg_smart_ant(struct drx_demod_instance *demod, struct drxj_cfg_smart_a
 		   RR16( dev_addr, SIO_SA_TX_COMMAND__A, &data );
 		   WR16( dev_addr, SIO_SA_TX_COMMAND__A, data | SIO_SA_TX_COMMAND_TX_ENABLE__M );
 		 */
-		start_time = drxbsp_hst_clock();
+		start_time = jiffies_to_msecs(jiffies);
 		do {
 			rc = DRXJ_DAP.read_reg16func(dev_addr, SIO_SA_TX_STATUS__A, &data, 0);
 			if (rc != 0) {
 				pr_err("error %d\n", rc);
 				goto rw_error;
 			}
-		} while ((data & SIO_SA_TX_STATUS_BUSY__M) && ((drxbsp_hst_clock() - start_time) < DRXJ_MAX_WAITTIME));
+		} while ((data & SIO_SA_TX_STATUS_BUSY__M) && ((jiffies_to_msecs(jiffies) - start_time) < DRXJ_MAX_WAITTIME));
 
 		if (data & SIO_SA_TX_STATUS_BUSY__M)
 			return -EIO;
@@ -4479,7 +4479,7 @@ static int scu_command(struct i2c_device_addr *dev_addr, struct drxjscu_cmd *cmd
 	}
 
 	/* Wait until SCU has processed command */
-	start_time = drxbsp_hst_clock();
+	start_time = jiffies_to_msecs(jiffies);
 	do {
 		rc = DRXJ_DAP.read_reg16func(dev_addr, SCU_RAM_COMMAND__A, &cur_cmd, 0);
 		if (rc != 0) {
@@ -4487,7 +4487,7 @@ static int scu_command(struct i2c_device_addr *dev_addr, struct drxjscu_cmd *cmd
 			goto rw_error;
 		}
 	} while (!(cur_cmd == DRX_SCU_READY)
-		 && ((drxbsp_hst_clock() - start_time) < DRXJ_MAX_WAITTIME));
+		 && ((jiffies_to_msecs(jiffies) - start_time) < DRXJ_MAX_WAITTIME));
 
 	if (cur_cmd != DRX_SCU_READY)
 		return -EIO;
@@ -4704,11 +4704,7 @@ static int adc_sync_measurement(struct drx_demod_instance *demod, u16 *count)
 	}
 
 	/* Wait at least 3*128*(1/sysclk) <<< 1 millisec */
-	rc = drxbsp_hst_sleep(1);
-	if (rc != 0) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
-	}
+	msleep(1);
 
 	*count = 0;
 	rc = DRXJ_DAP.read_reg16func(dev_addr, IQM_AF_PHASE0__A, &data, 0);
@@ -10191,7 +10187,7 @@ qam64auto(struct drx_demod_instance *demod,
 	/* external attributes for storing aquired channel constellation */
 	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 	*lock_status = DRX_NOT_LOCKED;
-	start_time = drxbsp_hst_clock();
+	start_time = jiffies_to_msecs(jiffies);
 	state = NO_LOCK;
 	do {
 		rc = ctrl_lock_status(demod, lock_status);
@@ -10212,13 +10208,13 @@ qam64auto(struct drx_demod_instance *demod,
 					state = DEMOD_LOCKED;
 					/* some delay to see if fec_lock possible TODO find the right value */
 					timeout_ofs += DRXJ_QAM_DEMOD_LOCK_EXT_WAITTIME;	/* see something, waiting longer */
-					d_locked_time = drxbsp_hst_clock();
+					d_locked_time = jiffies_to_msecs(jiffies);
 				}
 			}
 			break;
 		case DEMOD_LOCKED:
 			if ((*lock_status == DRXJ_DEMOD_LOCK) &&	/* still demod_lock in 150ms */
-			    ((drxbsp_hst_clock() - d_locked_time) >
+			    ((jiffies_to_msecs(jiffies) - d_locked_time) >
 			     DRXJ_QAM_FEC_LOCK_WAITTIME)) {
 				rc = DRXJ_DAP.read_reg16func(demod->my_i2c_dev_addr, QAM_SY_TIMEOUT__A, &data, 0);
 				if (rc != 0) {
@@ -10231,7 +10227,7 @@ qam64auto(struct drx_demod_instance *demod,
 					goto rw_error;
 				}
 				state = SYNC_FLIPPED;
-				drxbsp_hst_sleep(10);
+				msleep(10);
 			}
 			break;
 		case SYNC_FLIPPED:
@@ -10258,19 +10254,19 @@ qam64auto(struct drx_demod_instance *demod,
 					state = SPEC_MIRRORED;
 					/* reset timer TODO: still need 500ms? */
 					start_time = d_locked_time =
-					    drxbsp_hst_clock();
+					    jiffies_to_msecs(jiffies);
 					timeout_ofs = 0;
 				} else {	/* no need to wait lock */
 
 					start_time =
-					    drxbsp_hst_clock() -
+					    jiffies_to_msecs(jiffies) -
 					    DRXJ_QAM_MAX_WAITTIME - timeout_ofs;
 				}
 			}
 			break;
 		case SPEC_MIRRORED:
 			if ((*lock_status == DRXJ_DEMOD_LOCK) &&	/* still demod_lock in 150ms */
-			    ((drxbsp_hst_clock() - d_locked_time) >
+			    ((jiffies_to_msecs(jiffies) - d_locked_time) >
 			     DRXJ_QAM_FEC_LOCK_WAITTIME)) {
 				rc = ctrl_get_qam_sig_quality(demod, &sig_quality);
 				if (rc != 0) {
@@ -10290,7 +10286,7 @@ qam64auto(struct drx_demod_instance *demod,
 					}
 					/* no need to wait lock */
 					start_time =
-					    drxbsp_hst_clock() -
+					    jiffies_to_msecs(jiffies) -
 					    DRXJ_QAM_MAX_WAITTIME - timeout_ofs;
 				}
 			}
@@ -10298,11 +10294,11 @@ qam64auto(struct drx_demod_instance *demod,
 		default:
 			break;
 		}
-		drxbsp_hst_sleep(10);
+		msleep(10);
 	} while
 	    ((*lock_status != DRX_LOCKED) &&
 	     (*lock_status != DRX_NEVER_LOCK) &&
-	     ((drxbsp_hst_clock() - start_time) <
+	     ((jiffies_to_msecs(jiffies) - start_time) <
 	      (DRXJ_QAM_MAX_WAITTIME + timeout_ofs))
 	    );
 	/* Returning control to apllication ... */
@@ -10337,7 +10333,7 @@ qam256auto(struct drx_demod_instance *demod,
 	/* external attributes for storing aquired channel constellation */
 	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 	*lock_status = DRX_NOT_LOCKED;
-	start_time = drxbsp_hst_clock();
+	start_time = jiffies_to_msecs(jiffies);
 	state = NO_LOCK;
 	do {
 		rc = ctrl_lock_status(demod, lock_status);
@@ -10356,14 +10352,14 @@ qam256auto(struct drx_demod_instance *demod,
 				if (sig_quality.MER > 268) {
 					state = DEMOD_LOCKED;
 					timeout_ofs += DRXJ_QAM_DEMOD_LOCK_EXT_WAITTIME;	/* see something, wait longer */
-					d_locked_time = drxbsp_hst_clock();
+					d_locked_time = jiffies_to_msecs(jiffies);
 				}
 			}
 			break;
 		case DEMOD_LOCKED:
 			if (*lock_status == DRXJ_DEMOD_LOCK) {
 				if ((channel->mirror == DRX_MIRROR_AUTO) &&
-				    ((drxbsp_hst_clock() - d_locked_time) >
+				    ((jiffies_to_msecs(jiffies) - d_locked_time) >
 				     DRXJ_QAM_FEC_LOCK_WAITTIME)) {
 					ext_attr->mirror = DRX_MIRROR_YES;
 					rc = qam_flip_spec(demod, channel);
@@ -10373,7 +10369,7 @@ qam256auto(struct drx_demod_instance *demod,
 					}
 					state = SPEC_MIRRORED;
 					/* reset timer TODO: still need 300ms? */
-					start_time = drxbsp_hst_clock();
+					start_time = jiffies_to_msecs(jiffies);
 					timeout_ofs = -DRXJ_QAM_MAX_WAITTIME / 2;
 				}
 			}
@@ -10383,11 +10379,11 @@ qam256auto(struct drx_demod_instance *demod,
 		default:
 			break;
 		}
-		drxbsp_hst_sleep(10);
+		msleep(10);
 	} while
 	    ((*lock_status < DRX_LOCKED) &&
 	     (*lock_status != DRX_NEVER_LOCK) &&
-	     ((drxbsp_hst_clock() - start_time) <
+	     ((jiffies_to_msecs(jiffies) - start_time) <
 	      (DRXJ_QAM_MAX_WAITTIME + timeout_ofs)));
 
 	return 0;
@@ -19662,11 +19658,7 @@ int drxj_open(struct drx_demod_instance *demod)
 		pr_err("error %d\n", rc);
 		goto rw_error;
 	}
-	rc = drxbsp_hst_sleep(1);
-	if (rc != 0) {
-		pr_err("error %d\n", rc);
-		goto rw_error;
-	}
+	msleep(1);
 
 	/* TODO first make sure that everything keeps working before enabling this */
 	/* PowerDownAnalogBlocks() */
@@ -19761,12 +19753,6 @@ int drxj_open(struct drx_demod_instance *demod)
 			}
 		}
 
-		rc = drxbsp_tuner_open(demod->my_tuner);
-		if (rc != 0) {
-			pr_err("error %d\n", rc);
-			goto rw_error;
-		}
-
 		if (common_attr->tuner_port_nr == 1) {
 			bool bridge_closed = false;
 			rc = ctrl_i2c_bridge(demod, &bridge_closed);
@@ -19873,11 +19859,6 @@ int drxj_close(struct drx_demod_instance *demod)
 				goto rw_error;
 			}
 		}
-		rc = drxbsp_tuner_close(demod->my_tuner);
-		if (rc != 0) {
-			pr_err("error %d\n", rc);
-			goto rw_error;
-		}
 		if (common_attr->tuner_port_nr == 1) {
 			bool bridge_closed = false;
 			rc = ctrl_i2c_bridge(demod, &bridge_closed);
@@ -20185,9 +20166,8 @@ static int drx_ctrl_u_code(struct drx_demod_instance *demod,
 					return -EIO;
 				}
 
-				result =drxbsp_hst_memcmp(curr_ptr,
-							  mc_data_buffer,
-							  bytes_to_comp);
+				result = memcmp(curr_ptr, mc_data_buffer,
+						bytes_to_comp);
 
 				if (result) {
 					pr_err("error verifying firmware at pos %u\n",
-- 
1.8.5.3

