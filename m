Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49830 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753751AbaCCLL3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 06:11:29 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 36/79] [media] drx-j: make checkpatch.pl happy
Date: Mon,  3 Mar 2014 07:06:30 -0300
Message-Id: <1393841233-24840-37-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
References: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix the remaining checkpatch.pl compliants at drxj.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 .../media/dvb-frontends/drx39xyj/drx_dap_fasi.c    |  69 +--
 .../media/dvb-frontends/drx39xyj/drx_dap_fasi.h    |   9 +-
 drivers/media/dvb-frontends/drx39xyj/drx_driver.c  | 123 ++----
 drivers/media/dvb-frontends/drx39xyj/drx_driver.h  | 486 ++++++++++-----------
 .../dvb-frontends/drx39xyj/drx_driver_version.h    |   7 -
 drivers/media/dvb-frontends/drx39xyj/drxj.h        |  52 +--
 drivers/media/dvb-frontends/drx39xyj/drxj_map.h    |   7 -
 7 files changed, 325 insertions(+), 428 deletions(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c b/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c
index e0fc219723f0..2a37098f2152 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c
@@ -26,28 +26,17 @@
   CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
   ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
   POSSIBILITY OF SUCH DAMAGE.
-*/
 
-/*******************************************************************************
-* FILENAME: $Id: drx_dap_fasi.c,v 1.7 2009/12/28 14:36:21 carlo Exp $
-*
-* DESCRIPTION:
-* Part of DRX driver.
-* Data access protocol: Fast Access Sequential Interface (fasi)
-* Fast access, because of short addressing format (16 instead of 32 bits addr)
-* Sequential, because of I2C.
-* These functions know how the chip's memory and registers are to be accessed,
-* but nothing more.
-*
-* These functions should not need adapting to a new platform.
-*
-* USAGE:
-* -
-*
-* NOTES:
-*
-*
-*******************************************************************************/
+  DESCRIPTION:
+  Part of DRX driver.
+  Data access protocol: Fast Access Sequential Interface (fasi)
+  Fast access, because of short addressing format (16 instead of 32 bits addr)
+  Sequential, because of I2C.
+  These functions know how the chip's memory and registers are to be accessed,
+  but nothing more.
+
+  These functions should not need adapting to a new platform.
+*/
 
 #include "drx_dap_fasi.h"
 #include "drx_driver.h"		/* for drxbsp_hst_memcpy() */
@@ -221,9 +210,8 @@ static int drxdap_fasi_read_block(struct i2c_device_addr *dev_addr,
 	u16 overhead_size = 0;
 
 	/* Check parameters ******************************************************* */
-	if (dev_addr == NULL) {
+	if (dev_addr == NULL)
 		return -EINVAL;
-	}
 
 	overhead_size = (IS_I2C_10BIT(dev_addr->i2c_addr) ? 2 : 1) +
 	    (DRXDAP_FASI_LONG_FORMAT(addr) ? 4 : 2);
@@ -252,8 +240,7 @@ static int drxdap_fasi_read_block(struct i2c_device_addr *dev_addr,
 		addr &= ~DRXDAP_FASI_FLAGS;
 		addr |= flags;
 
-#if ((DRXDAPFASI_LONG_ADDR_ALLOWED == 1) && \
-      (DRXDAPFASI_SHORT_ADDR_ALLOWED == 1))
+#if ((DRXDAPFASI_LONG_ADDR_ALLOWED == 1) && (DRXDAPFASI_SHORT_ADDR_ALLOWED == 1))
 		/* short format address preferred but long format otherwise */
 		if (DRXDAP_FASI_LONG_FORMAT(addr)) {
 #endif
@@ -263,8 +250,7 @@ static int drxdap_fasi_read_block(struct i2c_device_addr *dev_addr,
 			buf[bufx++] = (u8) ((addr >> 24) & 0xFF);
 			buf[bufx++] = (u8) ((addr >> 7) & 0xFF);
 #endif
-#if ((DRXDAPFASI_LONG_ADDR_ALLOWED == 1) && \
-      (DRXDAPFASI_SHORT_ADDR_ALLOWED == 1))
+#if ((DRXDAPFASI_LONG_ADDR_ALLOWED == 1) && (DRXDAPFASI_SHORT_ADDR_ALLOWED == 1))
 		} else {
 #endif
 #if (DRXDAPFASI_SHORT_ADDR_ALLOWED == 1)
@@ -273,8 +259,7 @@ static int drxdap_fasi_read_block(struct i2c_device_addr *dev_addr,
 			    (u8) (((addr >> 16) & 0x0F) |
 				    ((addr >> 18) & 0xF0));
 #endif
-#if ((DRXDAPFASI_LONG_ADDR_ALLOWED == 1) && \
-      (DRXDAPFASI_SHORT_ADDR_ALLOWED == 1))
+#if ((DRXDAPFASI_LONG_ADDR_ALLOWED == 1) && (DRXDAPFASI_SHORT_ADDR_ALLOWED == 1))
 		}
 #endif
 
@@ -332,9 +317,8 @@ static int drxdap_fasi_read_modify_write_reg16(struct i2c_device_addr *dev_addr,
 	int rc = -EIO;
 
 #if (DRXDAPFASI_LONG_ADDR_ALLOWED == 1)
-	if (rdata == NULL) {
+	if (rdata == NULL)
 		return -EINVAL;
-	}
 
 	rc = drxdap_fasi_write_reg16(dev_addr, waddr, wdata, DRXDAP_FASI_RMW);
 	if (rc == 0)
@@ -369,9 +353,9 @@ static int drxdap_fasi_read_reg16(struct i2c_device_addr *dev_addr,
 	u8 buf[sizeof(*data)];
 	int rc;
 
-	if (!data) {
+	if (!data)
 		return -EINVAL;
-	}
+
 	rc = drxdap_fasi_read_block(dev_addr, addr, sizeof(*data), buf, flags);
 	*data = buf[0] + (((u16) buf[1]) << 8);
 	return rc;
@@ -402,9 +386,9 @@ static int drxdap_fasi_read_reg32(struct i2c_device_addr *dev_addr,
 	u8 buf[sizeof(*data)];
 	int rc;
 
-	if (!data) {
+	if (!data)
 		return -EINVAL;
-	}
+
 	rc = drxdap_fasi_read_block(dev_addr, addr, sizeof(*data), buf, flags);
 	*data = (((u32) buf[0]) << 0) +
 	    (((u32) buf[1]) << 8) +
@@ -446,9 +430,8 @@ static int drxdap_fasi_write_block(struct i2c_device_addr *dev_addr,
 	u16 block_size = 0;
 
 	/* Check parameters ******************************************************* */
-	if (dev_addr == NULL) {
+	if (dev_addr == NULL)
 		return -EINVAL;
-	}
 
 	overhead_size = (IS_I2C_10BIT(dev_addr->i2c_addr) ? 2 : 1) +
 	    (DRXDAP_FASI_LONG_FORMAT(addr) ? 4 : 2);
@@ -457,9 +440,8 @@ static int drxdap_fasi_write_block(struct i2c_device_addr *dev_addr,
 	    ((!(DRXDAPFASI_LONG_ADDR_ALLOWED)) &&
 	     DRXDAP_FASI_LONG_FORMAT(addr)) ||
 	    (overhead_size > (DRXDAP_MAX_WCHUNKSIZE)) ||
-	    ((datasize != 0) && (data == NULL)) || ((datasize & 1) == 1)) {
+	    ((datasize != 0) && (data == NULL)) || ((datasize & 1) == 1))
 		return -EINVAL;
-	}
 
 	flags &= DRXDAP_FASI_FLAGS;
 	flags &= ~DRXDAP_FASI_MODEFLAGS;
@@ -476,8 +458,7 @@ static int drxdap_fasi_write_block(struct i2c_device_addr *dev_addr,
 		/* Buffer device address */
 		addr &= ~DRXDAP_FASI_FLAGS;
 		addr |= flags;
-#if (((DRXDAPFASI_LONG_ADDR_ALLOWED) == 1) && \
-      ((DRXDAPFASI_SHORT_ADDR_ALLOWED) == 1))
+#if (((DRXDAPFASI_LONG_ADDR_ALLOWED) == 1) && ((DRXDAPFASI_SHORT_ADDR_ALLOWED) == 1))
 		/* short format address preferred but long format otherwise */
 		if (DRXDAP_FASI_LONG_FORMAT(addr)) {
 #endif
@@ -487,8 +468,7 @@ static int drxdap_fasi_write_block(struct i2c_device_addr *dev_addr,
 			buf[bufx++] = (u8) ((addr >> 24) & 0xFF);
 			buf[bufx++] = (u8) ((addr >> 7) & 0xFF);
 #endif
-#if (((DRXDAPFASI_LONG_ADDR_ALLOWED) == 1) && \
-      ((DRXDAPFASI_SHORT_ADDR_ALLOWED) == 1))
+#if (((DRXDAPFASI_LONG_ADDR_ALLOWED) == 1) && ((DRXDAPFASI_SHORT_ADDR_ALLOWED) == 1))
 		} else {
 #endif
 #if ((DRXDAPFASI_SHORT_ADDR_ALLOWED) == 1)
@@ -497,8 +477,7 @@ static int drxdap_fasi_write_block(struct i2c_device_addr *dev_addr,
 			    (u8) (((addr >> 16) & 0x0F) |
 				    ((addr >> 18) & 0xF0));
 #endif
-#if (((DRXDAPFASI_LONG_ADDR_ALLOWED) == 1) && \
-      ((DRXDAPFASI_SHORT_ADDR_ALLOWED) == 1))
+#if (((DRXDAPFASI_LONG_ADDR_ALLOWED) == 1) && ((DRXDAPFASI_SHORT_ADDR_ALLOWED) == 1))
 		}
 #endif
 
diff --git a/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.h b/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.h
index 4151876f0ebe..354ec07eae87 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.h
+++ b/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.h
@@ -234,11 +234,7 @@
 
 /*-------- Public API functions ----------------------------------------------*/
 
-#ifdef __cplusplus
-extern "C" {
-#endif
-
-	extern struct drx_access_func drx_dap_fasi_funct_g;
+extern struct drx_access_func drx_dap_fasi_funct_g;
 
 #define DRXDAP_FASI_RMW           0x10000000
 #define DRXDAP_FASI_BROADCAST     0x20000000
@@ -257,7 +253,4 @@ extern "C" {
 #define DRXDAP_FASI_LONG_FORMAT(addr)      (((addr) & 0xFC30FF80) != 0)
 #define DRXDAP_FASI_OFFSET_TOO_LARGE(addr) (((addr) & 0x00008000) != 0)
 
-#ifdef __cplusplus
-}
-#endif
 #endif				/* __DRX_DAP_FASI_H__ */
diff --git a/drivers/media/dvb-frontends/drx39xyj/drx_driver.c b/drivers/media/dvb-frontends/drx39xyj/drx_driver.c
index 9eb4bbf2627a..bfd02411dc54 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx_driver.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drx_driver.c
@@ -226,31 +226,25 @@ static int scan_wait_for_lock(struct drx_demod_instance *demod, bool *is_locked)
 
 	/* Start polling loop, checking for lock & timeout */
 	while (!done_waiting) {
-
-		if (drx_ctrl(demod, DRX_CTRL_LOCK_STATUS, &lock_state) !=
-		    0) {
+		if (drx_ctrl(demod, DRX_CTRL_LOCK_STATUS, &lock_state))
 			return -EIO;
-		}
+
 		current_time = drxbsp_hst_clock();
 
 		timer_value = current_time - start_time_lock_stage;
 		if (lock_state >= desired_lock_state) {
 			*is_locked = true;
 			done_waiting = true;
-		} /* if ( lock_state >= desired_lock_state ) .. */
-		else if (lock_state == DRX_NEVER_LOCK) {
+		} else if (lock_state == DRX_NEVER_LOCK) {
 			done_waiting = true;
-		} /* if ( lock_state == DRX_NEVER_LOCK ) .. */
-		else if (timer_value > timeout_value) {
+		} else if (timer_value > timeout_value) {
 			/* lock_state == DRX_NOT_LOCKED  and timeout */
 			done_waiting = true;
 		} else {
-			if (drxbsp_hst_sleep(10) != 0) {
+			if (drxbsp_hst_sleep(10) != 0)
 				return -EIO;
-			}
-		}		/* if ( timer_value > timeout_value ) .. */
-
-	}			/* while */
+		}
+	}
 
 	return 0;
 }
@@ -356,36 +350,30 @@ scan_function_default(void *scan_context,
 		      enum drx_scan_command scan_command,
 		    struct drx_channel *scan_channel, bool *get_next_channel)
 {
-	struct drx_demod_instance *demod = NULL;
-	int status = -EIO;
+	struct drx_demod_instance *demod = scan_context;
+	int status;
 	bool is_locked = false;
 
-	demod = (struct drx_demod_instance *) scan_context;
-
-	if (scan_command != DRX_SCAN_COMMAND_NEXT) {
-		/* just return OK if not doing "scan next" */
+	/* just return OK if not doing "scan next" */
+	if (scan_command != DRX_SCAN_COMMAND_NEXT)
 		return 0;
-	}
 
 	*get_next_channel = false;
 
 	status = drx_ctrl(demod, DRX_CTRL_SET_CHANNEL, scan_channel);
-	if (status != 0) {
+	if (status)
 		return status;
-	}
 
 	status = scan_wait_for_lock(demod, &is_locked);
-	if (status != 0) {
+	if (status)
 		return status;
-	}
 
 	/* done with this channel, move to next one */
 	*get_next_channel = true;
 
-	if (!is_locked) {
-		/* no channel found */
-		return -EBUSY;
-	}
+	if (!is_locked)
+		return -EBUSY;		/* no channel found */
+
 	/* channel found */
 	return 0;
 }
@@ -733,23 +721,20 @@ ctrl_program_tuner(struct drx_demod_instance *demod, struct drx_channel *channel
 	bool tuner_slow_mode = false;
 
 	/* can't tune without a tuner */
-	if (demod->my_tuner == NULL) {
+	if (demod->my_tuner == NULL)
 		return -EINVAL;
-	}
 
-	common_attr = (struct drx_common_attr *) demod->my_common_attr;
+	common_attr = demod->my_common_attr;
 
 	/* select analog or digital tuner mode based on current standard */
-	if (drx_ctrl(demod, DRX_CTRL_GET_STANDARD, &standard) != 0) {
+	if (drx_ctrl(demod, DRX_CTRL_GET_STANDARD, &standard))
 		return -EIO;
-	}
 
-	if (DRX_ISATVSTD(standard)) {
+	if (DRX_ISATVSTD(standard))
 		tuner_mode |= TUNER_MODE_ANALOG;
-	} else {		/* note: also for unknown standard */
+	else
 
-		tuner_mode |= TUNER_MODE_DIGITAL;
-	}
+		tuner_mode |= TUNER_MODE_DIGITAL; /* also for unknown standard */
 
 	/* select tuner bandwidth */
 	switch (channel->bandwidth) {
@@ -769,25 +754,23 @@ ctrl_program_tuner(struct drx_demod_instance *demod, struct drx_channel *channel
 	tuner_slow_mode = DRX_ATTR_TUNERSLOWMODE(demod);
 
 	/* select fast (switch) or slow (lock) tuner mode */
-	if (tuner_slow_mode) {
+	if (tuner_slow_mode)
 		tuner_mode |= TUNER_MODE_LOCK;
-	} else {
+	else
 		tuner_mode |= TUNER_MODE_SWITCH;
-	}
 
 	if (common_attr->tuner_port_nr == 1) {
 		bool bridge_closed = true;
 		int status_bridge = -EIO;
 
-		status_bridge =
-		    drx_ctrl(demod, DRX_CTRL_I2C_BRIDGE, &bridge_closed);
-		if (status_bridge != 0) {
+		status_bridge = drx_ctrl(demod, DRX_CTRL_I2C_BRIDGE,
+					 &bridge_closed);
+		if (status_bridge)
 			return status_bridge;
-		}
 	}
 
 	status = drxbsp_tuner_set_frequency(demod->my_tuner,
-					   tuner_mode, channel->frequency);
+					    tuner_mode, channel->frequency);
 
 	/* attempt restoring bridge before checking status of set_frequency */
 	if (common_attr->tuner_port_nr == 1) {
@@ -796,24 +779,21 @@ ctrl_program_tuner(struct drx_demod_instance *demod, struct drx_channel *channel
 
 		status_bridge =
 		    drx_ctrl(demod, DRX_CTRL_I2C_BRIDGE, &bridge_closed);
-		if (status_bridge != 0) {
+		if (status_bridge)
 			return status_bridge;
-		}
 	}
 
 	/* now check status of drxbsp_tuner_set_frequency */
-	if (status != 0) {
+	if (status)
 		return status;
-	}
 
 	/* get actual RF and IF frequencies from tuner */
 	status = drxbsp_tuner_get_frequency(demod->my_tuner,
 					   tuner_mode,
 					   &(channel->frequency),
 					   &(if_frequency));
-	if (status != 0) {
+	if (status)
 		return status;
-	}
 
 	/* update common attributes with information available from this function;
 	   TODO: check if this is required and safe */
@@ -839,29 +819,27 @@ static int ctrl_dump_registers(struct drx_demod_instance *demod,
 {
 	u16 i = 0;
 
-	if (registers == NULL) {
-		/* registers not supplied */
-		return -EINVAL;
-	}
+	if (registers == NULL)
+		return -EINVAL;		/* registers not supplied */
 
 	/* start dumping registers */
-	while (registers[i].address != 0) {
+	while (registers[i].address) {
 		int status = -EIO;
 		u16 value = 0;
 		u32 data = 0;
 
-		status =
-		    demod->my_access_funct->read_reg16func(demod->my_i2c_dev_addr,
+		status = demod->my_access_funct->read_reg16func(demod->my_i2c_dev_addr,
 							registers[i].address,
 							&value, 0);
 
 		data = (u32) value;
 
-		if (status != 0) {
-			/* no breakouts;
-			   depending on device ID, some HW blocks might not be available */
+		/*
+		 * On error: no breakouts;
+		 *   depending on device ID, some HW blocks might not be available
+		 */
+		if (status)
 			data |= ((u32) status) << 16;
-		}
 		registers[i].data = data;
 		i++;
 	}
@@ -989,9 +967,8 @@ ctrl_u_code(struct drx_demod_instance *demod,
 	dev_addr = demod->my_i2c_dev_addr;
 
 	/* Check arguments */
-	if ((mc_info == NULL) || (mc_info->mc_data == NULL)) {
+	if ((mc_info == NULL) || (mc_info->mc_data == NULL))
 		return -EINVAL;
-	}
 
 	mc_data = mc_info->mc_data;
 
@@ -1001,10 +978,8 @@ ctrl_u_code(struct drx_demod_instance *demod,
 	mc_nr_of_blks = u_code_read16(mc_data);
 	mc_data += sizeof(u16);
 
-	if ((mc_magic_word != DRX_UCODE_MAGIC_WORD) || (mc_nr_of_blks == 0)) {
-		/* wrong endianess or wrong data ? */
-		return -EINVAL;
-	}
+	if ((mc_magic_word != DRX_UCODE_MAGIC_WORD) || (mc_nr_of_blks == 0))
+		return -EINVAL;		/* wrong endianess or wrong data ? */
 
 	/* Scan microcode blocks first for version info if uploading */
 	if (action == UCODE_UPLOAD) {
@@ -1049,9 +1024,8 @@ ctrl_u_code(struct drx_demod_instance *demod,
 		   It is also valid if no validation control exists.
 		 */
 		rc = drx_ctrl(demod, DRX_CTRL_VALIDATE_UCODE, NULL);
-		if (rc != 0 && rc != -ENOTSUPP) {
+		if (rc != 0 && rc != -ENOTSUPP)
 			return rc;
-		}
 
 		/* Restore data pointer */
 		mc_data = mc_info->mc_data + 2 * sizeof(u16);
@@ -1149,9 +1123,8 @@ ctrl_u_code(struct drx_demod_instance *demod,
 								      mc_data_buffer,
 								      bytes_to_compare);
 
-						if (result != 0) {
+						if (result != 0)
 							return -EIO;
-						}
 
 						curr_addr +=
 						    ((dr_xaddr_t)
@@ -1205,9 +1178,8 @@ ctrl_version(struct drx_demod_instance *demod, struct drx_version_list **version
 	int return_status = -EIO;
 
 	/* Check arguments */
-	if (version_list == NULL) {
+	if (version_list == NULL)
 		return -EINVAL;
-	}
 
 	/* Get version info list from demod */
 	return_status = (*(demod->my_demod_funct->ctrl_func)) (demod,
@@ -1231,9 +1203,8 @@ ctrl_version(struct drx_demod_instance *demod, struct drx_version_list **version
 		/* Return version info in "bottom-up" order. This way, multiple
 		   devices can be handled without using malloc. */
 		struct drx_version_list *current_list_element = demod_version_list;
-		while (current_list_element->next != NULL) {
+		while (current_list_element->next != NULL)
 			current_list_element = current_list_element->next;
-		}
 		current_list_element->next = &drx_driver_core_version_list;
 
 		*version_list = demod_version_list;
diff --git a/drivers/media/dvb-frontends/drx39xyj/drx_driver.h b/drivers/media/dvb-frontends/drx39xyj/drx_driver.h
index 2a7846699f3c..c36321b9dd72 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx_driver.h
+++ b/drivers/media/dvb-frontends/drx39xyj/drx_driver.h
@@ -2056,275 +2056,275 @@ Conversion from enum values to human readable form.
 /* standard */
 
 #define DRX_STR_STANDARD(x) ( \
-   (x == DRX_STANDARD_DVBT)  ? "DVB-T"            : \
-   (x == DRX_STANDARD_8VSB)  ? "8VSB"             : \
-   (x == DRX_STANDARD_NTSC)  ? "NTSC"             : \
-   (x == DRX_STANDARD_PAL_SECAM_BG)  ? "PAL/SECAM B/G"    : \
-   (x == DRX_STANDARD_PAL_SECAM_DK)  ? "PAL/SECAM D/K"    : \
-   (x == DRX_STANDARD_PAL_SECAM_I)  ? "PAL/SECAM I"      : \
-   (x == DRX_STANDARD_PAL_SECAM_L)  ? "PAL/SECAM L"      : \
-   (x == DRX_STANDARD_PAL_SECAM_LP)  ? "PAL/SECAM LP"     : \
-   (x == DRX_STANDARD_ITU_A)  ? "ITU-A"            : \
-   (x == DRX_STANDARD_ITU_B)  ? "ITU-B"            : \
-   (x == DRX_STANDARD_ITU_C)  ? "ITU-C"            : \
-   (x == DRX_STANDARD_ITU_D)  ? "ITU-D"            : \
-   (x == DRX_STANDARD_FM)  ? "FM"               : \
-   (x == DRX_STANDARD_DTMB)  ? "DTMB"             : \
-   (x == DRX_STANDARD_AUTO)  ? "Auto"             : \
-   (x == DRX_STANDARD_UNKNOWN)  ? "Unknown"          : \
-					     "(Invalid)")
+	(x == DRX_STANDARD_DVBT)  ? "DVB-T"            : \
+	(x == DRX_STANDARD_8VSB)  ? "8VSB"             : \
+	(x == DRX_STANDARD_NTSC)  ? "NTSC"             : \
+	(x == DRX_STANDARD_PAL_SECAM_BG)  ? "PAL/SECAM B/G"    : \
+	(x == DRX_STANDARD_PAL_SECAM_DK)  ? "PAL/SECAM D/K"    : \
+	(x == DRX_STANDARD_PAL_SECAM_I)  ? "PAL/SECAM I"      : \
+	(x == DRX_STANDARD_PAL_SECAM_L)  ? "PAL/SECAM L"      : \
+	(x == DRX_STANDARD_PAL_SECAM_LP)  ? "PAL/SECAM LP"     : \
+	(x == DRX_STANDARD_ITU_A)  ? "ITU-A"            : \
+	(x == DRX_STANDARD_ITU_B)  ? "ITU-B"            : \
+	(x == DRX_STANDARD_ITU_C)  ? "ITU-C"            : \
+	(x == DRX_STANDARD_ITU_D)  ? "ITU-D"            : \
+	(x == DRX_STANDARD_FM)  ? "FM"               : \
+	(x == DRX_STANDARD_DTMB)  ? "DTMB"             : \
+	(x == DRX_STANDARD_AUTO)  ? "Auto"             : \
+	(x == DRX_STANDARD_UNKNOWN)  ? "Unknown"          : \
+	"(Invalid)")
 
 /* channel */
 
 #define DRX_STR_BANDWIDTH(x) ( \
-   (x == DRX_BANDWIDTH_8MHZ)  ?  "8 MHz"            : \
-   (x == DRX_BANDWIDTH_7MHZ)  ?  "7 MHz"            : \
-   (x == DRX_BANDWIDTH_6MHZ)  ?  "6 MHz"            : \
-   (x == DRX_BANDWIDTH_AUTO)  ?  "Auto"             : \
-   (x == DRX_BANDWIDTH_UNKNOWN)  ?  "Unknown"          : \
-					     "(Invalid)")
+	(x == DRX_BANDWIDTH_8MHZ)  ?  "8 MHz"            : \
+	(x == DRX_BANDWIDTH_7MHZ)  ?  "7 MHz"            : \
+	(x == DRX_BANDWIDTH_6MHZ)  ?  "6 MHz"            : \
+	(x == DRX_BANDWIDTH_AUTO)  ?  "Auto"             : \
+	(x == DRX_BANDWIDTH_UNKNOWN)  ?  "Unknown"          : \
+	"(Invalid)")
 #define DRX_STR_FFTMODE(x) ( \
-   (x == DRX_FFTMODE_2K)  ?  "2k"               : \
-   (x == DRX_FFTMODE_4K)  ?  "4k"               : \
-   (x == DRX_FFTMODE_8K)  ?  "8k"               : \
-   (x == DRX_FFTMODE_AUTO)  ?  "Auto"             : \
-   (x == DRX_FFTMODE_UNKNOWN)  ?  "Unknown"          : \
-					     "(Invalid)")
+	(x == DRX_FFTMODE_2K)  ?  "2k"               : \
+	(x == DRX_FFTMODE_4K)  ?  "4k"               : \
+	(x == DRX_FFTMODE_8K)  ?  "8k"               : \
+	(x == DRX_FFTMODE_AUTO)  ?  "Auto"             : \
+	(x == DRX_FFTMODE_UNKNOWN)  ?  "Unknown"          : \
+	"(Invalid)")
 #define DRX_STR_GUARD(x) ( \
-   (x == DRX_GUARD_1DIV32)  ?  "1/32nd"           : \
-   (x == DRX_GUARD_1DIV16)  ?  "1/16th"           : \
-   (x == DRX_GUARD_1DIV8)  ?  "1/8th"            : \
-   (x == DRX_GUARD_1DIV4)  ?  "1/4th"            : \
-   (x == DRX_GUARD_AUTO)  ?  "Auto"             : \
-   (x == DRX_GUARD_UNKNOWN)  ?  "Unknown"          : \
-					     "(Invalid)")
+	(x == DRX_GUARD_1DIV32)  ?  "1/32nd"           : \
+	(x == DRX_GUARD_1DIV16)  ?  "1/16th"           : \
+	(x == DRX_GUARD_1DIV8)  ?  "1/8th"            : \
+	(x == DRX_GUARD_1DIV4)  ?  "1/4th"            : \
+	(x == DRX_GUARD_AUTO)  ?  "Auto"             : \
+	(x == DRX_GUARD_UNKNOWN)  ?  "Unknown"          : \
+	"(Invalid)")
 #define DRX_STR_CONSTELLATION(x) ( \
-   (x == DRX_CONSTELLATION_BPSK)  ?  "BPSK"            : \
-   (x == DRX_CONSTELLATION_QPSK)  ?  "QPSK"            : \
-   (x == DRX_CONSTELLATION_PSK8)  ?  "PSK8"            : \
-   (x == DRX_CONSTELLATION_QAM16)  ?  "QAM16"           : \
-   (x == DRX_CONSTELLATION_QAM32)  ?  "QAM32"           : \
-   (x == DRX_CONSTELLATION_QAM64)  ?  "QAM64"           : \
-   (x == DRX_CONSTELLATION_QAM128)  ?  "QAM128"          : \
-   (x == DRX_CONSTELLATION_QAM256)  ?  "QAM256"          : \
-   (x == DRX_CONSTELLATION_QAM512)  ?  "QAM512"          : \
-   (x == DRX_CONSTELLATION_QAM1024)  ?  "QAM1024"         : \
-   (x == DRX_CONSTELLATION_QPSK_NR)  ?  "QPSK_NR"            : \
-   (x == DRX_CONSTELLATION_AUTO)  ?  "Auto"            : \
-   (x == DRX_CONSTELLATION_UNKNOWN)  ?  "Unknown"         : \
-					     "(Invalid)")
+	(x == DRX_CONSTELLATION_BPSK)  ?  "BPSK"            : \
+	(x == DRX_CONSTELLATION_QPSK)  ?  "QPSK"            : \
+	(x == DRX_CONSTELLATION_PSK8)  ?  "PSK8"            : \
+	(x == DRX_CONSTELLATION_QAM16)  ?  "QAM16"           : \
+	(x == DRX_CONSTELLATION_QAM32)  ?  "QAM32"           : \
+	(x == DRX_CONSTELLATION_QAM64)  ?  "QAM64"           : \
+	(x == DRX_CONSTELLATION_QAM128)  ?  "QAM128"          : \
+	(x == DRX_CONSTELLATION_QAM256)  ?  "QAM256"          : \
+	(x == DRX_CONSTELLATION_QAM512)  ?  "QAM512"          : \
+	(x == DRX_CONSTELLATION_QAM1024)  ?  "QAM1024"         : \
+	(x == DRX_CONSTELLATION_QPSK_NR)  ?  "QPSK_NR"            : \
+	(x == DRX_CONSTELLATION_AUTO)  ?  "Auto"            : \
+	(x == DRX_CONSTELLATION_UNKNOWN)  ?  "Unknown"         : \
+	"(Invalid)")
 #define DRX_STR_CODERATE(x) ( \
-   (x == DRX_CODERATE_1DIV2)  ?  "1/2nd"           : \
-   (x == DRX_CODERATE_2DIV3)  ?  "2/3rd"           : \
-   (x == DRX_CODERATE_3DIV4)  ?  "3/4th"           : \
-   (x == DRX_CODERATE_5DIV6)  ?  "5/6th"           : \
-   (x == DRX_CODERATE_7DIV8)  ?  "7/8th"           : \
-   (x == DRX_CODERATE_AUTO)  ?  "Auto"            : \
-   (x == DRX_CODERATE_UNKNOWN)  ?  "Unknown"         : \
-					     "(Invalid)")
+	(x == DRX_CODERATE_1DIV2)  ?  "1/2nd"           : \
+	(x == DRX_CODERATE_2DIV3)  ?  "2/3rd"           : \
+	(x == DRX_CODERATE_3DIV4)  ?  "3/4th"           : \
+	(x == DRX_CODERATE_5DIV6)  ?  "5/6th"           : \
+	(x == DRX_CODERATE_7DIV8)  ?  "7/8th"           : \
+	(x == DRX_CODERATE_AUTO)  ?  "Auto"            : \
+	(x == DRX_CODERATE_UNKNOWN)  ?  "Unknown"         : \
+	"(Invalid)")
 #define DRX_STR_HIERARCHY(x) ( \
-   (x == DRX_HIERARCHY_NONE)  ?  "None"            : \
-   (x == DRX_HIERARCHY_ALPHA1)  ?  "Alpha=1"         : \
-   (x == DRX_HIERARCHY_ALPHA2)  ?  "Alpha=2"         : \
-   (x == DRX_HIERARCHY_ALPHA4)  ?  "Alpha=4"         : \
-   (x == DRX_HIERARCHY_AUTO)  ?  "Auto"            : \
-   (x == DRX_HIERARCHY_UNKNOWN)  ?  "Unknown"         : \
-					     "(Invalid)")
+	(x == DRX_HIERARCHY_NONE)  ?  "None"            : \
+	(x == DRX_HIERARCHY_ALPHA1)  ?  "Alpha=1"         : \
+	(x == DRX_HIERARCHY_ALPHA2)  ?  "Alpha=2"         : \
+	(x == DRX_HIERARCHY_ALPHA4)  ?  "Alpha=4"         : \
+	(x == DRX_HIERARCHY_AUTO)  ?  "Auto"            : \
+	(x == DRX_HIERARCHY_UNKNOWN)  ?  "Unknown"         : \
+	"(Invalid)")
 #define DRX_STR_PRIORITY(x) ( \
-   (x == DRX_PRIORITY_LOW)  ?  "Low"             : \
-   (x == DRX_PRIORITY_HIGH)  ?  "High"            : \
-   (x == DRX_PRIORITY_UNKNOWN)  ?  "Unknown"         : \
-					     "(Invalid)")
+	(x == DRX_PRIORITY_LOW)  ?  "Low"             : \
+	(x == DRX_PRIORITY_HIGH)  ?  "High"            : \
+	(x == DRX_PRIORITY_UNKNOWN)  ?  "Unknown"         : \
+	"(Invalid)")
 #define DRX_STR_MIRROR(x) ( \
-   (x == DRX_MIRROR_NO)  ?  "Normal"          : \
-   (x == DRX_MIRROR_YES)  ?  "Mirrored"        : \
-   (x == DRX_MIRROR_AUTO)  ?  "Auto"            : \
-   (x == DRX_MIRROR_UNKNOWN)  ?  "Unknown"         : \
-					     "(Invalid)")
+	(x == DRX_MIRROR_NO)  ?  "Normal"          : \
+	(x == DRX_MIRROR_YES)  ?  "Mirrored"        : \
+	(x == DRX_MIRROR_AUTO)  ?  "Auto"            : \
+	(x == DRX_MIRROR_UNKNOWN)  ?  "Unknown"         : \
+	"(Invalid)")
 #define DRX_STR_CLASSIFICATION(x) ( \
-   (x == DRX_CLASSIFICATION_GAUSS)  ?  "Gaussion"        : \
-   (x == DRX_CLASSIFICATION_HVY_GAUSS)  ?  "Heavy Gaussion"  : \
-   (x == DRX_CLASSIFICATION_COCHANNEL)  ?  "Co-channel"      : \
-   (x == DRX_CLASSIFICATION_STATIC)  ?  "Static echo"     : \
-   (x == DRX_CLASSIFICATION_MOVING)  ?  "Moving echo"     : \
-   (x == DRX_CLASSIFICATION_ZERODB)  ?  "Zero dB echo"    : \
-   (x == DRX_CLASSIFICATION_UNKNOWN)  ?  "Unknown"         : \
-   (x == DRX_CLASSIFICATION_AUTO)  ?  "Auto"            : \
-					     "(Invalid)")
+	(x == DRX_CLASSIFICATION_GAUSS)  ?  "Gaussion"        : \
+	(x == DRX_CLASSIFICATION_HVY_GAUSS)  ?  "Heavy Gaussion"  : \
+	(x == DRX_CLASSIFICATION_COCHANNEL)  ?  "Co-channel"      : \
+	(x == DRX_CLASSIFICATION_STATIC)  ?  "Static echo"     : \
+	(x == DRX_CLASSIFICATION_MOVING)  ?  "Moving echo"     : \
+	(x == DRX_CLASSIFICATION_ZERODB)  ?  "Zero dB echo"    : \
+	(x == DRX_CLASSIFICATION_UNKNOWN)  ?  "Unknown"         : \
+	(x == DRX_CLASSIFICATION_AUTO)  ?  "Auto"            : \
+	"(Invalid)")
 
 #define DRX_STR_INTERLEAVEMODE(x) ( \
-   (x == DRX_INTERLEAVEMODE_I128_J1) ? "I128_J1"         : \
-   (x == DRX_INTERLEAVEMODE_I128_J1_V2) ? "I128_J1_V2"      : \
-   (x == DRX_INTERLEAVEMODE_I128_J2) ? "I128_J2"         : \
-   (x == DRX_INTERLEAVEMODE_I64_J2) ? "I64_J2"          : \
-   (x == DRX_INTERLEAVEMODE_I128_J3) ? "I128_J3"         : \
-   (x == DRX_INTERLEAVEMODE_I32_J4) ? "I32_J4"          : \
-   (x == DRX_INTERLEAVEMODE_I128_J4) ? "I128_J4"         : \
-   (x == DRX_INTERLEAVEMODE_I16_J8) ? "I16_J8"          : \
-   (x == DRX_INTERLEAVEMODE_I128_J5) ? "I128_J5"         : \
-   (x == DRX_INTERLEAVEMODE_I8_J16) ? "I8_J16"          : \
-   (x == DRX_INTERLEAVEMODE_I128_J6) ? "I128_J6"         : \
-   (x == DRX_INTERLEAVEMODE_RESERVED_11) ? "Reserved 11"     : \
-   (x == DRX_INTERLEAVEMODE_I128_J7) ? "I128_J7"         : \
-   (x == DRX_INTERLEAVEMODE_RESERVED_13) ? "Reserved 13"     : \
-   (x == DRX_INTERLEAVEMODE_I128_J8) ? "I128_J8"         : \
-   (x == DRX_INTERLEAVEMODE_RESERVED_15) ? "Reserved 15"     : \
-   (x == DRX_INTERLEAVEMODE_I12_J17) ? "I12_J17"         : \
-   (x == DRX_INTERLEAVEMODE_I5_J4) ? "I5_J4"           : \
-   (x == DRX_INTERLEAVEMODE_B52_M240) ? "B52_M240"        : \
-   (x == DRX_INTERLEAVEMODE_B52_M720) ? "B52_M720"        : \
-   (x == DRX_INTERLEAVEMODE_B52_M48) ? "B52_M48"         : \
-   (x == DRX_INTERLEAVEMODE_B52_M0) ? "B52_M0"          : \
-   (x == DRX_INTERLEAVEMODE_UNKNOWN) ? "Unknown"         : \
-   (x == DRX_INTERLEAVEMODE_AUTO) ? "Auto"            : \
-					     "(Invalid)")
+	(x == DRX_INTERLEAVEMODE_I128_J1) ? "I128_J1"         : \
+	(x == DRX_INTERLEAVEMODE_I128_J1_V2) ? "I128_J1_V2"      : \
+	(x == DRX_INTERLEAVEMODE_I128_J2) ? "I128_J2"         : \
+	(x == DRX_INTERLEAVEMODE_I64_J2) ? "I64_J2"          : \
+	(x == DRX_INTERLEAVEMODE_I128_J3) ? "I128_J3"         : \
+	(x == DRX_INTERLEAVEMODE_I32_J4) ? "I32_J4"          : \
+	(x == DRX_INTERLEAVEMODE_I128_J4) ? "I128_J4"         : \
+	(x == DRX_INTERLEAVEMODE_I16_J8) ? "I16_J8"          : \
+	(x == DRX_INTERLEAVEMODE_I128_J5) ? "I128_J5"         : \
+	(x == DRX_INTERLEAVEMODE_I8_J16) ? "I8_J16"          : \
+	(x == DRX_INTERLEAVEMODE_I128_J6) ? "I128_J6"         : \
+	(x == DRX_INTERLEAVEMODE_RESERVED_11) ? "Reserved 11"     : \
+	(x == DRX_INTERLEAVEMODE_I128_J7) ? "I128_J7"         : \
+	(x == DRX_INTERLEAVEMODE_RESERVED_13) ? "Reserved 13"     : \
+	(x == DRX_INTERLEAVEMODE_I128_J8) ? "I128_J8"         : \
+	(x == DRX_INTERLEAVEMODE_RESERVED_15) ? "Reserved 15"     : \
+	(x == DRX_INTERLEAVEMODE_I12_J17) ? "I12_J17"         : \
+	(x == DRX_INTERLEAVEMODE_I5_J4) ? "I5_J4"           : \
+	(x == DRX_INTERLEAVEMODE_B52_M240) ? "B52_M240"        : \
+	(x == DRX_INTERLEAVEMODE_B52_M720) ? "B52_M720"        : \
+	(x == DRX_INTERLEAVEMODE_B52_M48) ? "B52_M48"         : \
+	(x == DRX_INTERLEAVEMODE_B52_M0) ? "B52_M0"          : \
+	(x == DRX_INTERLEAVEMODE_UNKNOWN) ? "Unknown"         : \
+	(x == DRX_INTERLEAVEMODE_AUTO) ? "Auto"            : \
+	"(Invalid)")
 
 #define DRX_STR_LDPC(x) ( \
-   (x == DRX_LDPC_0_4) ? "0.4"             : \
-   (x == DRX_LDPC_0_6) ? "0.6"             : \
-   (x == DRX_LDPC_0_8) ? "0.8"             : \
-   (x == DRX_LDPC_AUTO) ? "Auto"            : \
-   (x == DRX_LDPC_UNKNOWN) ? "Unknown"         : \
-					     "(Invalid)")
+	(x == DRX_LDPC_0_4) ? "0.4"             : \
+	(x == DRX_LDPC_0_6) ? "0.6"             : \
+	(x == DRX_LDPC_0_8) ? "0.8"             : \
+	(x == DRX_LDPC_AUTO) ? "Auto"            : \
+	(x == DRX_LDPC_UNKNOWN) ? "Unknown"         : \
+	"(Invalid)")
 
 #define DRX_STR_CARRIER(x) ( \
-   (x == DRX_CARRIER_MULTI) ? "Multi"           : \
-   (x == DRX_CARRIER_SINGLE) ? "Single"          : \
-   (x == DRX_CARRIER_AUTO) ? "Auto"            : \
-   (x == DRX_CARRIER_UNKNOWN) ? "Unknown"         : \
-					     "(Invalid)")
+	(x == DRX_CARRIER_MULTI) ? "Multi"           : \
+	(x == DRX_CARRIER_SINGLE) ? "Single"          : \
+	(x == DRX_CARRIER_AUTO) ? "Auto"            : \
+	(x == DRX_CARRIER_UNKNOWN) ? "Unknown"         : \
+	"(Invalid)")
 
 #define DRX_STR_FRAMEMODE(x) ( \
-   (x == DRX_FRAMEMODE_420)  ? "420"                : \
-   (x == DRX_FRAMEMODE_595)  ? "595"                : \
-   (x == DRX_FRAMEMODE_945)  ? "945"                : \
-   (x == DRX_FRAMEMODE_420_FIXED_PN)  ? "420 with fixed PN"  : \
-   (x == DRX_FRAMEMODE_945_FIXED_PN)  ? "945 with fixed PN"  : \
-   (x == DRX_FRAMEMODE_AUTO)  ? "Auto"               : \
-   (x == DRX_FRAMEMODE_UNKNOWN)  ? "Unknown"            : \
-					  "(Invalid)")
+	(x == DRX_FRAMEMODE_420)  ? "420"                : \
+	(x == DRX_FRAMEMODE_595)  ? "595"                : \
+	(x == DRX_FRAMEMODE_945)  ? "945"                : \
+	(x == DRX_FRAMEMODE_420_FIXED_PN)  ? "420 with fixed PN"  : \
+	(x == DRX_FRAMEMODE_945_FIXED_PN)  ? "945 with fixed PN"  : \
+	(x == DRX_FRAMEMODE_AUTO)  ? "Auto"               : \
+	(x == DRX_FRAMEMODE_UNKNOWN)  ? "Unknown"            : \
+	"(Invalid)")
 
 #define DRX_STR_PILOT(x) ( \
-   (x == DRX_PILOT_ON) ?   "On"              : \
-   (x == DRX_PILOT_OFF) ?   "Off"             : \
-   (x == DRX_PILOT_AUTO) ?   "Auto"            : \
-   (x == DRX_PILOT_UNKNOWN) ?   "Unknown"         : \
-					     "(Invalid)")
+	(x == DRX_PILOT_ON) ?   "On"              : \
+	(x == DRX_PILOT_OFF) ?   "Off"             : \
+	(x == DRX_PILOT_AUTO) ?   "Auto"            : \
+	(x == DRX_PILOT_UNKNOWN) ?   "Unknown"         : \
+	"(Invalid)")
 /* TPS */
 
 #define DRX_STR_TPS_FRAME(x)  ( \
-   (x == DRX_TPS_FRAME1)  ?  "Frame1"          : \
-   (x == DRX_TPS_FRAME2)  ?  "Frame2"          : \
-   (x == DRX_TPS_FRAME3)  ?  "Frame3"          : \
-   (x == DRX_TPS_FRAME4)  ?  "Frame4"          : \
-   (x == DRX_TPS_FRAME_UNKNOWN)  ?  "Unknown"         : \
-					     "(Invalid)")
+	(x == DRX_TPS_FRAME1)  ?  "Frame1"          : \
+	(x == DRX_TPS_FRAME2)  ?  "Frame2"          : \
+	(x == DRX_TPS_FRAME3)  ?  "Frame3"          : \
+	(x == DRX_TPS_FRAME4)  ?  "Frame4"          : \
+	(x == DRX_TPS_FRAME_UNKNOWN)  ?  "Unknown"         : \
+	"(Invalid)")
 
 /* lock status */
 
 #define DRX_STR_LOCKSTATUS(x) ( \
-   (x == DRX_NEVER_LOCK)  ?  "Never"           : \
-   (x == DRX_NOT_LOCKED)  ?  "No"              : \
-   (x == DRX_LOCKED)  ?  "Locked"          : \
-   (x == DRX_LOCK_STATE_1)  ?  "Lock state 1"    : \
-   (x == DRX_LOCK_STATE_2)  ?  "Lock state 2"    : \
-   (x == DRX_LOCK_STATE_3)  ?  "Lock state 3"    : \
-   (x == DRX_LOCK_STATE_4)  ?  "Lock state 4"    : \
-   (x == DRX_LOCK_STATE_5)  ?  "Lock state 5"    : \
-   (x == DRX_LOCK_STATE_6)  ?  "Lock state 6"    : \
-   (x == DRX_LOCK_STATE_7)  ?  "Lock state 7"    : \
-   (x == DRX_LOCK_STATE_8)  ?  "Lock state 8"    : \
-   (x == DRX_LOCK_STATE_9)  ?  "Lock state 9"    : \
-					     "(Invalid)")
+	(x == DRX_NEVER_LOCK)  ?  "Never"           : \
+	(x == DRX_NOT_LOCKED)  ?  "No"              : \
+	(x == DRX_LOCKED)  ?  "Locked"          : \
+	(x == DRX_LOCK_STATE_1)  ?  "Lock state 1"    : \
+	(x == DRX_LOCK_STATE_2)  ?  "Lock state 2"    : \
+	(x == DRX_LOCK_STATE_3)  ?  "Lock state 3"    : \
+	(x == DRX_LOCK_STATE_4)  ?  "Lock state 4"    : \
+	(x == DRX_LOCK_STATE_5)  ?  "Lock state 5"    : \
+	(x == DRX_LOCK_STATE_6)  ?  "Lock state 6"    : \
+	(x == DRX_LOCK_STATE_7)  ?  "Lock state 7"    : \
+	(x == DRX_LOCK_STATE_8)  ?  "Lock state 8"    : \
+	(x == DRX_LOCK_STATE_9)  ?  "Lock state 9"    : \
+	"(Invalid)")
 
 /* version information , modules */
 #define DRX_STR_MODULE(x) ( \
-   (x == DRX_MODULE_DEVICE)  ?  "Device"                : \
-   (x == DRX_MODULE_MICROCODE)  ?  "Microcode"             : \
-   (x == DRX_MODULE_DRIVERCORE)  ?  "CoreDriver"            : \
-   (x == DRX_MODULE_DEVICEDRIVER)  ?  "DeviceDriver"          : \
-   (x == DRX_MODULE_BSP_I2C)  ?  "BSP I2C"               : \
-   (x == DRX_MODULE_BSP_TUNER)  ?  "BSP Tuner"             : \
-   (x == DRX_MODULE_BSP_HOST)  ?  "BSP Host"              : \
-   (x == DRX_MODULE_DAP)  ?  "Data Access Protocol"  : \
-   (x == DRX_MODULE_UNKNOWN)  ?  "Unknown"               : \
-					     "(Invalid)")
+	(x == DRX_MODULE_DEVICE)  ?  "Device"                : \
+	(x == DRX_MODULE_MICROCODE)  ?  "Microcode"             : \
+	(x == DRX_MODULE_DRIVERCORE)  ?  "CoreDriver"            : \
+	(x == DRX_MODULE_DEVICEDRIVER)  ?  "DeviceDriver"          : \
+	(x == DRX_MODULE_BSP_I2C)  ?  "BSP I2C"               : \
+	(x == DRX_MODULE_BSP_TUNER)  ?  "BSP Tuner"             : \
+	(x == DRX_MODULE_BSP_HOST)  ?  "BSP Host"              : \
+	(x == DRX_MODULE_DAP)  ?  "Data Access Protocol"  : \
+	(x == DRX_MODULE_UNKNOWN)  ?  "Unknown"               : \
+	"(Invalid)")
 
 #define DRX_STR_POWER_MODE(x) ( \
-   (x == DRX_POWER_UP)  ?  "DRX_POWER_UP    "  : \
-   (x == DRX_POWER_MODE_1)  ?  "DRX_POWER_MODE_1"  : \
-   (x == DRX_POWER_MODE_2)  ?  "DRX_POWER_MODE_2"  : \
-   (x == DRX_POWER_MODE_3)  ?  "DRX_POWER_MODE_3"  : \
-   (x == DRX_POWER_MODE_4)  ?  "DRX_POWER_MODE_4"  : \
-   (x == DRX_POWER_MODE_5)  ?  "DRX_POWER_MODE_5"  : \
-   (x == DRX_POWER_MODE_6)  ?  "DRX_POWER_MODE_6"  : \
-   (x == DRX_POWER_MODE_7)  ?  "DRX_POWER_MODE_7"  : \
-   (x == DRX_POWER_MODE_8)  ?  "DRX_POWER_MODE_8"  : \
-   (x == DRX_POWER_MODE_9)  ?  "DRX_POWER_MODE_9"  : \
-   (x == DRX_POWER_MODE_10)  ?  "DRX_POWER_MODE_10" : \
-   (x == DRX_POWER_MODE_11)  ?  "DRX_POWER_MODE_11" : \
-   (x == DRX_POWER_MODE_12)  ?  "DRX_POWER_MODE_12" : \
-   (x == DRX_POWER_MODE_13)  ?  "DRX_POWER_MODE_13" : \
-   (x == DRX_POWER_MODE_14)  ?  "DRX_POWER_MODE_14" : \
-   (x == DRX_POWER_MODE_15)  ?  "DRX_POWER_MODE_15" : \
-   (x == DRX_POWER_MODE_16)  ?  "DRX_POWER_MODE_16" : \
-   (x == DRX_POWER_DOWN)  ?  "DRX_POWER_DOWN  " : \
-					     "(Invalid)")
+	(x == DRX_POWER_UP)  ?  "DRX_POWER_UP    "  : \
+	(x == DRX_POWER_MODE_1)  ?  "DRX_POWER_MODE_1"  : \
+	(x == DRX_POWER_MODE_2)  ?  "DRX_POWER_MODE_2"  : \
+	(x == DRX_POWER_MODE_3)  ?  "DRX_POWER_MODE_3"  : \
+	(x == DRX_POWER_MODE_4)  ?  "DRX_POWER_MODE_4"  : \
+	(x == DRX_POWER_MODE_5)  ?  "DRX_POWER_MODE_5"  : \
+	(x == DRX_POWER_MODE_6)  ?  "DRX_POWER_MODE_6"  : \
+	(x == DRX_POWER_MODE_7)  ?  "DRX_POWER_MODE_7"  : \
+	(x == DRX_POWER_MODE_8)  ?  "DRX_POWER_MODE_8"  : \
+	(x == DRX_POWER_MODE_9)  ?  "DRX_POWER_MODE_9"  : \
+	(x == DRX_POWER_MODE_10)  ?  "DRX_POWER_MODE_10" : \
+	(x == DRX_POWER_MODE_11)  ?  "DRX_POWER_MODE_11" : \
+	(x == DRX_POWER_MODE_12)  ?  "DRX_POWER_MODE_12" : \
+	(x == DRX_POWER_MODE_13)  ?  "DRX_POWER_MODE_13" : \
+	(x == DRX_POWER_MODE_14)  ?  "DRX_POWER_MODE_14" : \
+	(x == DRX_POWER_MODE_15)  ?  "DRX_POWER_MODE_15" : \
+	(x == DRX_POWER_MODE_16)  ?  "DRX_POWER_MODE_16" : \
+	(x == DRX_POWER_DOWN)  ?  "DRX_POWER_DOWN  " : \
+	"(Invalid)")
 
 #define DRX_STR_OOB_STANDARD(x) ( \
-   (x == DRX_OOB_MODE_A)  ?  "ANSI 55-1  " : \
-   (x == DRX_OOB_MODE_B_GRADE_A)  ?  "ANSI 55-2 A" : \
-   (x == DRX_OOB_MODE_B_GRADE_B)  ?  "ANSI 55-2 B" : \
-					     "(Invalid)")
+	(x == DRX_OOB_MODE_A)  ?  "ANSI 55-1  " : \
+	(x == DRX_OOB_MODE_B_GRADE_A)  ?  "ANSI 55-2 A" : \
+	(x == DRX_OOB_MODE_B_GRADE_B)  ?  "ANSI 55-2 B" : \
+	"(Invalid)")
 
 #define DRX_STR_AUD_STANDARD(x) ( \
-   (x == DRX_AUD_STANDARD_BTSC)  ? "BTSC"                     : \
-   (x == DRX_AUD_STANDARD_A2)  ? "A2"                       : \
-   (x == DRX_AUD_STANDARD_EIAJ)  ? "EIAJ"                     : \
-   (x == DRX_AUD_STANDARD_FM_STEREO)  ? "FM Stereo"                : \
-   (x == DRX_AUD_STANDARD_AUTO)  ? "Auto"                     : \
-   (x == DRX_AUD_STANDARD_M_MONO)  ? "M-Standard Mono"          : \
-   (x == DRX_AUD_STANDARD_D_K_MONO)  ? "D/K Mono FM"              : \
-   (x == DRX_AUD_STANDARD_BG_FM)  ? "B/G-Dual Carrier FM (A2)" : \
-   (x == DRX_AUD_STANDARD_D_K1)  ? "D/K1-Dual Carrier FM"     : \
-   (x == DRX_AUD_STANDARD_D_K2)  ? "D/K2-Dual Carrier FM"     : \
-   (x == DRX_AUD_STANDARD_D_K3)  ? "D/K3-Dual Carrier FM"     : \
-   (x == DRX_AUD_STANDARD_BG_NICAM_FM)  ? "B/G-NICAM-FM"             : \
-   (x == DRX_AUD_STANDARD_L_NICAM_AM)  ? "L-NICAM-AM"               : \
-   (x == DRX_AUD_STANDARD_I_NICAM_FM)  ? "I-NICAM-FM"               : \
-   (x == DRX_AUD_STANDARD_D_K_NICAM_FM)  ? "D/K-NICAM-FM"             : \
-   (x == DRX_AUD_STANDARD_UNKNOWN)  ? "Unknown"                  : \
-					     "(Invalid)")
+	(x == DRX_AUD_STANDARD_BTSC)  ? "BTSC"                     : \
+	(x == DRX_AUD_STANDARD_A2)  ? "A2"                       : \
+	(x == DRX_AUD_STANDARD_EIAJ)  ? "EIAJ"                     : \
+	(x == DRX_AUD_STANDARD_FM_STEREO)  ? "FM Stereo"                : \
+	(x == DRX_AUD_STANDARD_AUTO)  ? "Auto"                     : \
+	(x == DRX_AUD_STANDARD_M_MONO)  ? "M-Standard Mono"          : \
+	(x == DRX_AUD_STANDARD_D_K_MONO)  ? "D/K Mono FM"              : \
+	(x == DRX_AUD_STANDARD_BG_FM)  ? "B/G-Dual Carrier FM (A2)" : \
+	(x == DRX_AUD_STANDARD_D_K1)  ? "D/K1-Dual Carrier FM"     : \
+	(x == DRX_AUD_STANDARD_D_K2)  ? "D/K2-Dual Carrier FM"     : \
+	(x == DRX_AUD_STANDARD_D_K3)  ? "D/K3-Dual Carrier FM"     : \
+	(x == DRX_AUD_STANDARD_BG_NICAM_FM)  ? "B/G-NICAM-FM"             : \
+	(x == DRX_AUD_STANDARD_L_NICAM_AM)  ? "L-NICAM-AM"               : \
+	(x == DRX_AUD_STANDARD_I_NICAM_FM)  ? "I-NICAM-FM"               : \
+	(x == DRX_AUD_STANDARD_D_K_NICAM_FM)  ? "D/K-NICAM-FM"             : \
+	(x == DRX_AUD_STANDARD_UNKNOWN)  ? "Unknown"                  : \
+	"(Invalid)")
 #define DRX_STR_AUD_STEREO(x) ( \
-   (x == true)  ? "Stereo"           : \
-   (x == false)  ? "Mono"             : \
-					     "(Invalid)")
+	(x == true)  ? "Stereo"           : \
+	(x == false)  ? "Mono"             : \
+	"(Invalid)")
 
 #define DRX_STR_AUD_SAP(x) ( \
-   (x == true)  ? "Present"          : \
-   (x == false)  ? "Not present"      : \
-					     "(Invalid)")
+	(x == true)  ? "Present"          : \
+	(x == false)  ? "Not present"      : \
+	"(Invalid)")
 
 #define DRX_STR_AUD_CARRIER(x) ( \
-   (x == true)  ? "Present"          : \
-   (x == false)  ? "Not present"      : \
-					     "(Invalid)")
+	(x == true)  ? "Present"          : \
+	(x == false)  ? "Not present"      : \
+	"(Invalid)")
 
 #define DRX_STR_AUD_RDS(x) ( \
-   (x == true)  ? "Available"        : \
-   (x == false)  ? "Not Available"    : \
-					     "(Invalid)")
+	(x == true)  ? "Available"        : \
+	(x == false)  ? "Not Available"    : \
+	"(Invalid)")
 
 #define DRX_STR_AUD_NICAM_STATUS(x) ( \
-   (x == DRX_AUD_NICAM_DETECTED)  ? "Detected"         : \
-   (x == DRX_AUD_NICAM_NOT_DETECTED)  ? "Not detected"     : \
-   (x == DRX_AUD_NICAM_BAD)  ? "Bad"              : \
-					     "(Invalid)")
+	(x == DRX_AUD_NICAM_DETECTED)  ? "Detected"         : \
+	(x == DRX_AUD_NICAM_NOT_DETECTED)  ? "Not detected"     : \
+	(x == DRX_AUD_NICAM_BAD)  ? "Bad"              : \
+	"(Invalid)")
 
 #define DRX_STR_RDS_VALID(x) ( \
-   (x == true)  ? "Valid"            : \
-   (x == false)  ? "Not Valid"        : \
-					     "(Invalid)")
+	(x == true)  ? "Valid"            : \
+	(x == false)  ? "Not Valid"        : \
+	"(Invalid)")
 
 /*-------------------------------------------------------------------------
 Access macros
@@ -2371,29 +2371,29 @@ Access macros
 /* Macros with device-specific handling are converted to CFG functions */
 
 #define DRX_ACCESSMACRO_SET(demod, value, cfg_name, data_type)             \
-   do {                                                                    \
-      struct drx_cfg config;                                                     \
-      data_type cfg_data;                                                    \
-      config.cfg_type = cfg_name;                                            \
-      config.cfg_data = &cfg_data;                                           \
-      cfg_data = value;                                                     \
-      drx_ctrl(demod, DRX_CTRL_SET_CFG, &config);                        \
-   } while (0)
+	do {                                                               \
+		struct drx_cfg config;                                     \
+		data_type cfg_data;                                        \
+		config.cfg_type = cfg_name;                                \
+		config.cfg_data = &cfg_data;                               \
+		cfg_data = value;                                          \
+		drx_ctrl(demod, DRX_CTRL_SET_CFG, &config);                \
+	} while (0)
 
 #define DRX_ACCESSMACRO_GET(demod, value, cfg_name, data_type, error_value) \
-   do {                                                                    \
-      int cfg_status;                                               \
-      struct drx_cfg config;                                                  \
-      data_type    cfg_data;                                                 \
-      config.cfg_type = cfg_name;                                            \
-      config.cfg_data = &cfg_data;                                           \
-      cfg_status = drx_ctrl(demod, DRX_CTRL_GET_CFG, &config);            \
-      if (cfg_status == 0) {                                     \
-	 value = cfg_data;                                                  \
-      } else {                                                             \
-	 value = (data_type)error_value;                                     \
-      }                                                                    \
-   } while (0)
+	do {                                                                \
+		int cfg_status;                                             \
+		struct drx_cfg config;                                      \
+		data_type    cfg_data;                                      \
+		config.cfg_type = cfg_name;                                 \
+		config.cfg_data = &cfg_data;                                \
+		cfg_status = drx_ctrl(demod, DRX_CTRL_GET_CFG, &config);    \
+		if (cfg_status == 0) {                                      \
+			value = cfg_data;                                   \
+		} else {                                                    \
+			value = (data_type)error_value;                     \
+		}                                                           \
+	} while (0)
 
 /* Configuration functions for usage by Access (XS) Macros */
 
@@ -2408,9 +2408,9 @@ Access macros
 /* Access Macros with device-specific handling */
 
 #define DRX_SET_PRESET(d, x) \
-   DRX_ACCESSMACRO_SET((d), (x), DRX_XS_CFG_PRESET, char*)
+	DRX_ACCESSMACRO_SET((d), (x), DRX_XS_CFG_PRESET, char*)
 #define DRX_GET_PRESET(d, x) \
-   DRX_ACCESSMACRO_GET((d), (x), DRX_XS_CFG_PRESET, char*, "ERROR")
+	DRX_ACCESSMACRO_GET((d), (x), DRX_XS_CFG_PRESET, char*, "ERROR")
 
 #define DRX_SET_AUD_BTSC_DETECT(d, x) DRX_ACCESSMACRO_SET((d), (x), \
 	 DRX_XS_CFG_AUD_BTSC_DETECT, enum drx_aud_btsc_detect)
diff --git a/drivers/media/dvb-frontends/drx39xyj/drx_driver_version.h b/drivers/media/dvb-frontends/drx39xyj/drx_driver_version.h
index 07986bdbc489..ff05a4ffb190 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx_driver_version.h
+++ b/drivers/media/dvb-frontends/drx39xyj/drx_driver_version.h
@@ -47,10 +47,6 @@
 #ifndef __DRX_DRIVER_VERSION__H__
 #define __DRX_DRIVER_VERSION__H__ INCLUDED
 
-#ifdef __cplusplus
-extern "C" {
-#endif
-
 #ifdef _REGISTERTABLE_
 #include <registertable.h>
 	extern register_table_t drx_driver_version[];
@@ -69,9 +65,6 @@ extern "C" {
 #define   VERSION_MINOR 0
 #define   VERSION_PATCH 56
 
-#ifdef __cplusplus
-}
-#endif
 #endif				/* __DRX_DRIVER_VERSION__H__ */
 /*
  * End of file (drx_driver_version.h)
diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.h b/drivers/media/dvb-frontends/drx39xyj/drxj.h
index c38245ee15ed..6d46513b7169 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.h
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.h
@@ -27,14 +27,10 @@
   CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
   ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
   POSSIBILITY OF SUCH DAMAGE.
-*/
 
-/**
-* \file $Id: drxj.h,v 1.132 2009/12/22 12:13:48 danielg Exp $
-*
-* \brief DRXJ specific header file
-*
-* \author Dragan Savic, Milos Nikolic, Mihajlo Katona, Tao Ding, Paul Janssen
+ DRXJ specific header file
+
+ Authors: Dragan Savic, Milos Nikolic, Mihajlo Katona, Tao Ding, Paul Janssen
 */
 
 #ifndef __DRXJ_H__
@@ -46,10 +42,6 @@ INCLUDES
 #include "drx_driver.h"
 #include "drx_dap_fasi.h"
 
-#ifdef __cplusplus
-extern "C" {
-#endif
-
 /* Check DRX-J specific dap condition */
 /* Multi master mode and short addr format only will not work.
    RMW, CRC reset, broadcast and switching back to single master mode
@@ -322,7 +314,7 @@ struct drxj_cfg_oob_misc {
 	bool dig_gain_lock;
 	bool ana_gain_lock;
 	u8 state;
- };
+};
 
 /*
  *  Index of in array of coef
@@ -558,27 +550,6 @@ Access MACROS
 #define DRXJ_ATTR_BTSC_DETECT(d)                       \
 			(((struct drxj_data *)(d)->my_ext_attr)->aud_data.btsc_detect)
 
-/**
-* \brief Actual access macros
-* \param d pointer to demod instance
-* \param x value to set or to get
-*
-* SET macros must be used to set the value of an attribute.
-* GET macros must be used to retrieve the value of an attribute.
-* Depending on the value of DRX_USE_ACCESS_FUNCTIONS the macro's will be
-* substituted by "direct-access-inline-code" or a function call.
-*
-*/
-#define DRXJ_GET_BTSC_DETECT(d, x)                     \
-   do {                                                  \
-      (x) = DRXJ_ATTR_BTSC_DETECT((d);                 \
-   } while (0)
-
-#define DRXJ_SET_BTSC_DETECT(d, x)                     \
-   do {                                                  \
-      DRXJ_ATTR_BTSC_DETECT(d) = (x);                  \
-   } while (0)
-
 /*-------------------------------------------------------------------------
 DEFINES
 -------------------------------------------------------------------------*/
@@ -669,12 +640,12 @@ DEFINES
 
 /* Convert OOB lock status to string */
 #define DRXJ_STR_OOB_LOCKSTATUS(x) ( \
-   (x == DRX_NEVER_LOCK)  ?  "Never"           : \
-   (x == DRX_NOT_LOCKED)  ?  "No"              : \
-   (x == DRX_LOCKED)  ?  "Locked"          : \
-   (x == DRX_LOCK_STATE_1)  ?  "AGC lock"        : \
-   (x == DRX_LOCK_STATE_2)  ?  "sync lock"       : \
-					     "(Invalid)")
+	(x == DRX_NEVER_LOCK) ? "Never" : \
+	(x == DRX_NOT_LOCKED) ? "No" : \
+	(x == DRX_LOCKED) ? "Locked" : \
+	(x == DRX_LOCK_STATE_1) ? "AGC lock" : \
+	(x == DRX_LOCK_STATE_2) ? "sync lock" : \
+	"(Invalid)")
 
 /*-------------------------------------------------------------------------
 ENUM
@@ -706,7 +677,4 @@ Exported GLOBAL VARIABLES
 /*-------------------------------------------------------------------------
 THE END
 -------------------------------------------------------------------------*/
-#ifdef __cplusplus
-}
-#endif
 #endif				/* __DRXJ_H__ */
diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj_map.h b/drivers/media/dvb-frontends/drx39xyj/drxj_map.h
index af427548eab8..0bbd4ae1f524 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj_map.h
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj_map.h
@@ -47,10 +47,6 @@
 #ifndef __DRXJ_MAP__H__
 #define __DRXJ_MAP__H__ INCLUDED
 
-#ifdef __cplusplus
-extern "C" {
-#endif
-
 #ifdef _REGISTERTABLE_
 #include <registertable.h>
 	extern register_table_t drxj_map[];
@@ -15056,7 +15052,4 @@ extern "C" {
 #define   VSB_EQTAP_RAM_EQTAP_RAM__M                                        0xFFF
 #define   VSB_EQTAP_RAM_EQTAP_RAM__PRE                                      0x0
 
-#ifdef __cplusplus
-}
-#endif
 #endif
-- 
1.8.5.3

