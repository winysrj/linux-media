Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20420 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751622Ab3D1Qfx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Apr 2013 12:35:53 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r3SGZruw006860
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 28 Apr 2013 12:35:53 -0400
Received: from localhost.localdomain (vpn1-7-217.gru2.redhat.com [10.97.7.217])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id r3SGZlO9017169
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Sun, 28 Apr 2013 12:35:50 -0400
Date: Sun, 28 Apr 2013 13:35:46 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 3/9] [media] drxk_hard: use pr_info/pr_warn/pr_err/...
 macros
Message-ID: <20130428133546.77d82ce8@redhat.com>
In-Reply-To: <1367164071-11468-4-git-send-email-mchehab@redhat.com>
References: <1367164071-11468-1-git-send-email-mchehab@redhat.com>
	<1367164071-11468-4-git-send-email-mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 28 Apr 2013 12:47:45 -0300
Mauro Carvalho Chehab <mchehab@redhat.com> escreveu:

> replace all occurrences of  printk(KERN_* by
> pr_info/pr_warn/pr_err/pr_debug/pr_cont macros.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> ---

Sorry... sent the wrong version. The correct one is attached.

-

[PATCH] [media] drxk_hard: use pr_info/pr_warn/pr_err/... macros

replace all occurrences of  printk(KERN_* by
pr_info/pr_warn/pr_err/pr_debug/pr_cont macros.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/dvb-frontends/drxk_hard.c b/drivers/media/dvb-frontends/drxk_hard.c
index d2b331a..cdfda38 100644
--- a/drivers/media/dvb-frontends/drxk_hard.c
+++ b/drivers/media/dvb-frontends/drxk_hard.c
@@ -21,6 +21,8 @@
  * Or, point your browser to http://www.gnu.org/copyleft/gpl.html
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
@@ -166,7 +168,7 @@ MODULE_PARM_DESC(debug, "enable debug messages");
 
 #define dprintk(level, fmt, arg...) do {			\
 if (debug >= level)						\
-	printk(KERN_DEBUG "drxk: %s" fmt, __func__, ## arg);	\
+	pr_debug(fmt, ##arg);					\
 } while (0)
 
 
@@ -256,15 +258,15 @@ static int i2c_write(struct drxk_state *state, u8 adr, u8 *data, int len)
 	if (debug > 2) {
 		int i;
 		for (i = 0; i < len; i++)
-			printk(KERN_CONT " %02x", data[i]);
-		printk(KERN_CONT "\n");
+			pr_cont(" %02x", data[i]);
+		pr_cont("\n");
 	}
 	status = drxk_i2c_transfer(state, &msg, 1);
 	if (status >= 0 && status != 1)
 		status = -EIO;
 
 	if (status < 0)
-		printk(KERN_ERR "drxk: i2c write error at addr 0x%02x\n", adr);
+		pr_err("i2c write error at addr 0x%02x\n", adr);
 
 	return status;
 }
@@ -283,22 +285,22 @@ static int i2c_read(struct drxk_state *state,
 	status = drxk_i2c_transfer(state, msgs, 2);
 	if (status != 2) {
 		if (debug > 2)
-			printk(KERN_CONT ": ERROR!\n");
+			pr_cont(": ERROR!\n");
 		if (status >= 0)
 			status = -EIO;
 
-		printk(KERN_ERR "drxk: i2c read error at addr 0x%02x\n", adr);
+		pr_err("i2c read error at addr 0x%02x\n", adr);
 		return status;
 	}
 	if (debug > 2) {
 		int i;
 		dprintk(2, ": read from");
 		for (i = 0; i < len; i++)
-			printk(KERN_CONT " %02x", msg[i]);
-		printk(KERN_CONT ", value = ");
+			pr_cont(" %02x", msg[i]);
+		pr_cont(", value = ");
 		for (i = 0; i < alen; i++)
-			printk(KERN_CONT " %02x", answ[i]);
-		printk(KERN_CONT "\n");
+			pr_cont(" %02x", answ[i]);
+		pr_cont("\n");
 	}
 	return 0;
 }
@@ -468,13 +470,13 @@ static int write_block(struct drxk_state *state, u32 address,
 			int i;
 			if (p_block)
 				for (i = 0; i < chunk; i++)
-					printk(KERN_CONT " %02x", p_block[i]);
-			printk(KERN_CONT "\n");
+					pr_cont(" %02x", p_block[i]);
+			pr_cont("\n");
 		}
 		status = i2c_write(state, state->demod_address,
 				   &state->chunk[0], chunk + adr_length);
 		if (status < 0) {
-			printk(KERN_ERR "drxk: %s: i2c write error at addr 0x%02x\n",
+			pr_err("%s: i2c write error at addr 0x%02x\n",
 			       __func__, address);
 			break;
 		}
@@ -531,7 +533,7 @@ static int power_up_device(struct drxk_state *state)
 
 error:
 	if (status < 0)
-		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
+		pr_err("Error %d on %s\n", status, __func__);
 
 	return status;
 }
@@ -800,7 +802,7 @@ static int drxx_open(struct drxk_state *state)
 	status = write16(state, SIO_TOP_COMM_KEY__A, key);
 error:
 	if (status < 0)
-		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
+		pr_err("Error %d on %s\n", status, __func__);
 	return status;
 }
 
@@ -845,7 +847,7 @@ static int get_device_capabilities(struct drxk_state *state)
 		state->m_osc_clock_freq = 20250;
 		break;
 	default:
-		printk(KERN_ERR "drxk: Clock Frequency is unknown\n");
+		pr_err("Clock Frequency is unknown\n");
 		return -EINVAL;
 	}
 	/*
@@ -856,7 +858,7 @@ static int get_device_capabilities(struct drxk_state *state)
 	if (status < 0)
 		goto error;
 
-	printk(KERN_INFO "drxk: status = 0x%08x\n", sio_top_jtagid_lo);
+	pr_info("status = 0x%08x\n", sio_top_jtagid_lo);
 
 	/* driver 0.9.0 */
 	switch ((sio_top_jtagid_lo >> 29) & 0xF) {
@@ -875,8 +877,7 @@ static int get_device_capabilities(struct drxk_state *state)
 	default:
 		state->m_device_spin = DRXK_SPIN_UNKNOWN;
 		status = -EINVAL;
-		printk(KERN_ERR "drxk: Spin %d unknown\n",
-		       (sio_top_jtagid_lo >> 29) & 0xF);
+		pr_err("Spin %d unknown\n", (sio_top_jtagid_lo >> 29) & 0xF);
 		goto error2;
 	}
 	switch ((sio_top_jtagid_lo >> 12) & 0xFF) {
@@ -985,21 +986,20 @@ static int get_device_capabilities(struct drxk_state *state)
 		state->m_has_irqn = false;
 		break;
 	default:
-		printk(KERN_ERR "drxk: DeviceID 0x%02x not supported\n",
+		pr_err("DeviceID 0x%02x not supported\n",
 			((sio_top_jtagid_lo >> 12) & 0xFF));
 		status = -EINVAL;
 		goto error2;
 	}
 
-	printk(KERN_INFO
-	       "drxk: detected a drx-39%02xk, spin %s, xtal %d.%03d MHz\n",
+	pr_info("detected a drx-39%02xk, spin %s, xtal %d.%03d MHz\n",
 	       ((sio_top_jtagid_lo >> 12) & 0xFF), spin,
 	       state->m_osc_clock_freq / 1000,
 	       state->m_osc_clock_freq % 1000);
 
 error:
 	if (status < 0)
-		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
+		pr_err("Error %d on %s\n", status, __func__);
 
 error2:
 	return status;
@@ -1042,7 +1042,7 @@ static int hi_command(struct drxk_state *state, u16 cmd, u16 *p_result)
 	}
 error:
 	if (status < 0)
-		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
+		pr_err("Error %d on %s\n", status, __func__);
 
 	return status;
 }
@@ -1081,7 +1081,7 @@ static int hi_cfg_command(struct drxk_state *state)
 error:
 	mutex_unlock(&state->mutex);
 	if (status < 0)
-		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
+		pr_err("Error %d on %s\n", status, __func__);
 	return status;
 }
 
@@ -1244,7 +1244,7 @@ static int mpegts_configure_pins(struct drxk_state *state, bool mpeg_enable)
 	status = write16(state, SIO_TOP_COMM_KEY__A, 0x0000);
 error:
 	if (status < 0)
-		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
+		pr_err("Error %d on %s\n", status, __func__);
 	return status;
 }
 
@@ -1287,13 +1287,13 @@ static int bl_chain_cmd(struct drxk_state *state,
 			((time_is_after_jiffies(end))));
 
 	if (bl_status == 0x1) {
-		printk(KERN_ERR "drxk: SIO not ready\n");
+		pr_err("SIO not ready\n");
 		status = -EINVAL;
 		goto error2;
 	}
 error:
 	if (status < 0)
-		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
+		pr_err("Error %d on %s\n", status, __func__);
 error2:
 	mutex_unlock(&state->mutex);
 	return status;
@@ -1349,13 +1349,13 @@ static int download_microcode(struct drxk_state *state,
 		offset += sizeof(u16);
 
 		if (offset + block_size > length) {
-			printk(KERN_ERR "drxk: Firmware is corrupted.\n");
+			pr_err("Firmware is corrupted.\n");
 			return -EINVAL;
 		}
 
 		status = write_block(state, address, block_size, p_src);
 		if (status < 0) {
-			printk(KERN_ERR "drxk: Error %d while loading firmware\n", status);
+			pr_err("Error %d while loading firmware\n", status);
 			break;
 		}
 		p_src += block_size;
@@ -1395,7 +1395,7 @@ static int dvbt_enable_ofdm_token_ring(struct drxk_state *state, bool enable)
 		msleep(1);
 	} while (1);
 	if (data != desired_status) {
-		printk(KERN_ERR "drxk: SIO not ready\n");
+		pr_err("SIO not ready\n");
 		return -EINVAL;
 	}
 	return status;
@@ -1427,7 +1427,7 @@ static int mpegts_stop(struct drxk_state *state)
 
 error:
 	if (status < 0)
-		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
+		pr_err("Error %d on %s\n", status, __func__);
 
 	return status;
 }
@@ -1451,7 +1451,7 @@ static int scu_command(struct drxk_state *state,
 
 	if ((cmd == 0) || ((parameter_len > 0) && (parameter == NULL)) ||
 	    ((result_len > 0) && (result == NULL))) {
-		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
+		pr_err("Error %d on %s\n", status, __func__);
 		return status;
 	}
 
@@ -1477,7 +1477,7 @@ static int scu_command(struct drxk_state *state,
 			goto error;
 	} while (!(cur_cmd == DRX_SCU_READY) && (time_is_after_jiffies(end)));
 	if (cur_cmd != DRX_SCU_READY) {
-		printk(KERN_ERR "drxk: SCU not ready\n");
+		pr_err("SCU not ready\n");
 		status = -EIO;
 		goto error2;
 	}
@@ -1515,7 +1515,7 @@ static int scu_command(struct drxk_state *state,
 			sprintf(errname, "ERROR: %d\n", err);
 			p = errname;
 		}
-		printk(KERN_ERR "drxk: %s while sending cmd 0x%04x with params:", p, cmd);
+		pr_err("%s while sending cmd 0x%04x with params:", p, cmd);
 		print_hex_dump_bytes("drxk: ", DUMP_PREFIX_NONE, buffer, cnt);
 		status = -EINVAL;
 		goto error2;
@@ -1523,7 +1523,7 @@ static int scu_command(struct drxk_state *state,
 
 error:
 	if (status < 0)
-		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
+		pr_err("Error %d on %s\n", status, __func__);
 error2:
 	mutex_unlock(&state->mutex);
 	return status;
@@ -1559,7 +1559,7 @@ static int set_iqm_af(struct drxk_state *state, bool active)
 
 error:
 	if (status < 0)
-		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
+		pr_err("Error %d on %s\n", status, __func__);
 	return status;
 }
 
@@ -1664,7 +1664,7 @@ static int ctrl_power_mode(struct drxk_state *state, enum drx_power_mode *mode)
 
 error:
 	if (status < 0)
-		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
+		pr_err("Error %d on %s\n", status, __func__);
 
 	return status;
 }
@@ -1716,7 +1716,7 @@ static int power_down_dvbt(struct drxk_state *state, bool set_power_mode)
 	}
 error:
 	if (status < 0)
-		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
+		pr_err("Error %d on %s\n", status, __func__);
 	return status;
 }
 
@@ -1796,7 +1796,7 @@ static int setoperation_mode(struct drxk_state *state,
 	}
 error:
 	if (status < 0)
-		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
+		pr_err("Error %d on %s\n", status, __func__);
 	return status;
 }
 
@@ -1847,7 +1847,7 @@ static int start(struct drxk_state *state, s32 offset_freq,
 	}
 error:
 	if (status < 0)
-		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
+		pr_err("Error %d on %s\n", status, __func__);
 	return status;
 }
 
@@ -1885,7 +1885,7 @@ static int get_lock_status(struct drxk_state *state, u32 *p_lock_status)
 	}
 error:
 	if (status < 0)
-		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
+		pr_err("Error %d on %s\n", status, __func__);
 	return status;
 }
 
@@ -1906,7 +1906,7 @@ static int mpegts_start(struct drxk_state *state)
 	status = write16(state, FEC_OC_SNC_UNLOCK__A, 1);
 error:
 	if (status < 0)
-		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
+		pr_err("Error %d on %s\n", status, __func__);
 	return status;
 }
 
@@ -1952,7 +1952,7 @@ static int mpegts_dto_init(struct drxk_state *state)
 	status = write16(state, FEC_OC_SNC_HWM__A, 12);
 error:
 	if (status < 0)
-		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
+		pr_err("Error %d on %s\n", status, __func__);
 
 	return status;
 }
@@ -2089,7 +2089,7 @@ static int mpegts_dto_setup(struct drxk_state *state,
 	status = write16(state, FEC_OC_TMD_MODE__A, fec_oc_tmd_mode);
 error:
 	if (status < 0)
-		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
+		pr_err("Error %d on %s\n", status, __func__);
 	return status;
 }
 
@@ -2269,7 +2269,7 @@ static int set_agc_rf(struct drxk_state *state,
 	}
 error:
 	if (status < 0)
-		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
+		pr_err("Error %d on %s\n", status, __func__);
 	return status;
 }
 
@@ -2397,7 +2397,7 @@ static int set_agc_if(struct drxk_state *state,
 	status = write16(state, SCU_RAM_AGC_INGAIN_TGT_MIN__A, p_agc_cfg->top);
 error:
 	if (status < 0)
-		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
+		pr_err("Error %d on %s\n", status, __func__);
 	return status;
 }
 
@@ -2418,7 +2418,7 @@ static int get_qam_signal_to_noise(struct drxk_state *state,
 	/* get the register value needed for MER */
 	status = read16(state, QAM_SL_ERR_POWER__A, &qam_sl_err_power);
 	if (status < 0) {
-		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
+		pr_err("Error %d on %s\n", status, __func__);
 		return -EINVAL;
 	}
 
@@ -2545,7 +2545,7 @@ static int get_dvbt_signal_to_noise(struct drxk_state *state,
 
 error:
 	if (status < 0)
-		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
+		pr_err("Error %d on %s\n", status, __func__);
 	return status;
 }
 
@@ -2740,7 +2740,7 @@ static int ConfigureI2CBridge(struct drxk_state *state, bool b_enable_bridge)
 
 error:
 	if (status < 0)
-		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
+		pr_err("Error %d on %s\n", status, __func__);
 	return status;
 }
 
@@ -2758,7 +2758,7 @@ static int set_pre_saw(struct drxk_state *state,
 	status = write16(state, IQM_AF_PDREF__A, p_pre_saw_cfg->reference);
 error:
 	if (status < 0)
-		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
+		pr_err("Error %d on %s\n", status, __func__);
 	return status;
 }
 
@@ -2800,13 +2800,13 @@ static int bl_direct_cmd(struct drxk_state *state, u32 target_addr,
 			goto error;
 	} while ((bl_status == 0x1) && time_is_after_jiffies(end));
 	if (bl_status == 0x1) {
-		printk(KERN_ERR "drxk: SIO not ready\n");
+		pr_err("SIO not ready\n");
 		status = -EINVAL;
 		goto error2;
 	}
 error:
 	if (status < 0)
-		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
+		pr_err("Error %d on %s\n", status, __func__);
 error2:
 	mutex_unlock(&state->mutex);
 	return status;
@@ -2847,7 +2847,7 @@ static int adc_sync_measurement(struct drxk_state *state, u16 *count)
 
 error:
 	if (status < 0)
-		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
+		pr_err("Error %d on %s\n", status, __func__);
 	return status;
 }
 
@@ -2891,7 +2891,7 @@ static int adc_synchronization(struct drxk_state *state)
 		status = -EINVAL;
 error:
 	if (status < 0)
-		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
+		pr_err("Error %d on %s\n", status, __func__);
 	return status;
 }
 
@@ -2957,7 +2957,7 @@ static int set_frequency_shifter(struct drxk_state *state,
 	status = write32(state, IQM_FS_RATE_OFS_LO__A,
 			 state->m_iqm_fs_rate_ofs);
 	if (status < 0)
-		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
+		pr_err("Error %d on %s\n", status, __func__);
 	return status;
 }
 
@@ -2992,7 +2992,8 @@ static int init_agc(struct drxk_state *state, bool is_dtv)
 
 	/* AGCInit() not available for DVBT; init done in microcode */
 	if (!is_qam(state)) {
-		printk(KERN_ERR "drxk: %s: mode %d is not DVB-C\n", __func__, state->m_operation_mode);
+		pr_err("%s: mode %d is not DVB-C\n",
+		       __func__, state->m_operation_mode);
 		return -EINVAL;
 	}
 
@@ -3145,7 +3146,7 @@ static int init_agc(struct drxk_state *state, bool is_dtv)
 	status = write16(state, SCU_RAM_AGC_KI__A, data);
 error:
 	if (status < 0)
-		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
+		pr_err("Error %d on %s\n", status, __func__);
 	return status;
 }
 
@@ -3159,7 +3160,7 @@ static int dvbtqam_get_acc_pkt_err(struct drxk_state *state, u16 *packet_err)
 	else
 		status = read16(state, SCU_RAM_FEC_ACCUM_PKT_FAILURES__A, packet_err);
 	if (status < 0)
-		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
+		pr_err("Error %d on %s\n", status, __func__);
 	return status;
 }
 
@@ -3279,7 +3280,7 @@ static int dvbt_sc_command(struct drxk_state *state,
 	}			/* switch (cmd->cmd) */
 error:
 	if (status < 0)
-		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
+		pr_err("Error %d on %s\n", status, __func__);
 	return status;
 }
 
@@ -3291,7 +3292,7 @@ static int power_up_dvbt(struct drxk_state *state)
 	dprintk(1, "\n");
 	status = ctrl_power_mode(state, &power_mode);
 	if (status < 0)
-		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
+		pr_err("Error %d on %s\n", status, __func__);
 	return status;
 }
 
@@ -3305,7 +3306,7 @@ static int dvbt_ctrl_set_inc_enable(struct drxk_state *state, bool *enabled)
 	else
 		status = write16(state, IQM_CF_BYPASSDET__A, 1);
 	if (status < 0)
-		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
+		pr_err("Error %d on %s\n", status, __func__);
 	return status;
 }
 
@@ -3325,7 +3326,7 @@ static int dvbt_ctrl_set_fr_enable(struct drxk_state *state, bool *enabled)
 		status = write16(state, OFDM_SC_RA_RAM_FR_THRES_8K__A, 0);
 	}
 	if (status < 0)
-		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
+		pr_err("Error %d on %s\n", status, __func__);
 
 	return status;
 }
@@ -3361,7 +3362,7 @@ static int dvbt_ctrl_set_echo_threshold(struct drxk_state *state,
 	status = write16(state, OFDM_SC_RA_RAM_ECHO_THRES__A, data);
 error:
 	if (status < 0)
-		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
+		pr_err("Error %d on %s\n", status, __func__);
 	return status;
 }
 
@@ -3384,7 +3385,7 @@ static int dvbt_ctrl_set_sqi_speed(struct drxk_state *state,
 			   (u16) *speed);
 error:
 	if (status < 0)
-		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
+		pr_err("Error %d on %s\n", status, __func__);
 	return status;
 }
 
@@ -3423,7 +3424,7 @@ static int dvbt_activate_presets(struct drxk_state *state)
 	status = write16(state, SCU_RAM_AGC_INGAIN_TGT_MAX__A, state->m_dvbt_if_agc_cfg.ingain_tgt_max);
 error:
 	if (status < 0)
-		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
+		pr_err("Error %d on %s\n", status, __func__);
 	return status;
 }
 
@@ -3629,7 +3630,7 @@ static int set_dvbt_standard(struct drxk_state *state,
 
 error:
 	if (status < 0)
-		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
+		pr_err("Error %d on %s\n", status, __func__);
 	return status;
 }
 
@@ -3661,7 +3662,7 @@ static int dvbt_start(struct drxk_state *state)
 		goto error;
 error:
 	if (status < 0)
-		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
+		pr_err("Error %d on %s\n", status, __func__);
 	return status;
 }
 
@@ -3980,7 +3981,7 @@ static int set_dvbt(struct drxk_state *state, u16 intermediate_freqk_hz,
 		status = dvbt_ctrl_set_sqi_speed(state, &state->m_sqi_speed);
 error:
 	if (status < 0)
-		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
+		pr_err("Error %d on %s\n", status, __func__);
 
 	return status;
 }
@@ -4031,7 +4032,7 @@ static int get_dvbt_lock_status(struct drxk_state *state, u32 *p_lock_status)
 		*p_lock_status = NEVER_LOCK;
 end:
 	if (status < 0)
-		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
+		pr_err("Error %d on %s\n", status, __func__);
 
 	return status;
 }
@@ -4044,7 +4045,7 @@ static int power_up_qam(struct drxk_state *state)
 	dprintk(1, "\n");
 	status = ctrl_power_mode(state, &power_mode);
 	if (status < 0)
-		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
+		pr_err("Error %d on %s\n", status, __func__);
 
 	return status;
 }
@@ -4079,7 +4080,7 @@ static int power_down_qam(struct drxk_state *state)
 
 error:
 	if (status < 0)
-		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
+		pr_err("Error %d on %s\n", status, __func__);
 
 	return status;
 }
@@ -4167,7 +4168,7 @@ static int set_qam_measurement(struct drxk_state *state,
 	status = write16(state, FEC_OC_SNC_FAIL_PERIOD__A, fec_rs_period);
 error:
 	if (status < 0)
-		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
+		pr_err("Error %d on %s\n", status, __func__);
 	return status;
 }
 
@@ -4353,7 +4354,7 @@ static int set_qam16(struct drxk_state *state)
 
 error:
 	if (status < 0)
-		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
+		pr_err("Error %d on %s\n", status, __func__);
 	return status;
 }
 
@@ -4548,7 +4549,7 @@ static int set_qam32(struct drxk_state *state)
 	status = write16(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET5__A, (u16) -86);
 error:
 	if (status < 0)
-		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
+		pr_err("Error %d on %s\n", status, __func__);
 	return status;
 }
 
@@ -4741,7 +4742,7 @@ static int set_qam64(struct drxk_state *state)
 	status = write16(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET5__A, (u16) -80);
 error:
 	if (status < 0)
-		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
+		pr_err("Error %d on %s\n", status, __func__);
 
 	return status;
 }
@@ -4937,7 +4938,7 @@ static int set_qam128(struct drxk_state *state)
 	status = write16(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET5__A, (u16) -23);
 error:
 	if (status < 0)
-		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
+		pr_err("Error %d on %s\n", status, __func__);
 
 	return status;
 }
@@ -5132,7 +5133,7 @@ static int set_qam256(struct drxk_state *state)
 	status = write16(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET5__A, (u16) -8);
 error:
 	if (status < 0)
-		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
+		pr_err("Error %d on %s\n", status, __func__);
 	return status;
 }
 
@@ -5158,7 +5159,7 @@ static int qam_reset_qam(struct drxk_state *state)
 	status = scu_command(state, SCU_RAM_COMMAND_STANDARD_QAM | SCU_RAM_COMMAND_CMD_DEMOD_RESET, 0, NULL, 1, &cmd_result);
 error:
 	if (status < 0)
-		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
+		pr_err("Error %d on %s\n", status, __func__);
 	return status;
 }
 
@@ -5228,7 +5229,7 @@ static int qam_set_symbolrate(struct drxk_state *state)
 
 error:
 	if (status < 0)
-		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
+		pr_err("Error %d on %s\n", status, __func__);
 	return status;
 }
 
@@ -5253,7 +5254,7 @@ static int get_qam_lock_status(struct drxk_state *state, u32 *p_lock_status)
 			SCU_RAM_COMMAND_CMD_DEMOD_GET_LOCK, 0, NULL, 2,
 			result);
 	if (status < 0)
-		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
+		pr_err("Error %d on %s\n", status, __func__);
 
 	if (result[1] < SCU_RAM_QAM_LOCKED_LOCKED_DEMOD_LOCKED) {
 		/* 0x0000 NOT LOCKED */
@@ -5324,15 +5325,14 @@ static int qam_demodulator_command(struct drxk_state *state,
 				     number_of_parameters, set_param_parameters,
 				     1, &cmd_result);
 	} else {
-		printk(KERN_WARNING "drxk: Unknown QAM demodulator parameter "
-			"count %d\n", number_of_parameters);
+		pr_warn("Unknown QAM demodulator parameter count %d\n",
+			number_of_parameters);
 		status = -EINVAL;
 	}
 
 error:
 	if (status < 0)
-		printk(KERN_WARNING "drxk: Warning %d on %s\n",
-		       status, __func__);
+		pr_warn("Warning %d on %s\n", status, __func__);
 	return status;
 }
 
@@ -5587,7 +5587,7 @@ static int set_qam(struct drxk_state *state, u16 intermediate_freqk_hz,
 
 error:
 	if (status < 0)
-		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
+		pr_err("Error %d on %s\n", status, __func__);
 	return status;
 }
 
@@ -5749,7 +5749,7 @@ static int set_qam_standard(struct drxk_state *state,
 	status = write16(state, SCU_COMM_EXEC__A, SCU_COMM_EXEC_ACTIVE);
 error:
 	if (status < 0)
-		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
+		pr_err("Error %d on %s\n", status, __func__);
 	return status;
 }
 
@@ -5832,7 +5832,7 @@ static int write_gpio(struct drxk_state *state)
 	status = write16(state, SIO_TOP_COMM_KEY__A, 0x0000);
 error:
 	if (status < 0)
-		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
+		pr_err("Error %d on %s\n", status, __func__);
 	return status;
 }
 
@@ -5857,7 +5857,7 @@ static int switch_antenna_to_qam(struct drxk_state *state)
 		status = write_gpio(state);
 	}
 	if (status < 0)
-		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
+		pr_err("Error %d on %s\n", status, __func__);
 	return status;
 }
 
@@ -5882,7 +5882,7 @@ static int switch_antenna_to_dvbt(struct drxk_state *state)
 		status = write_gpio(state);
 	}
 	if (status < 0)
-		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
+		pr_err("Error %d on %s\n", status, __func__);
 	return status;
 }
 
@@ -5919,7 +5919,7 @@ static int power_down_device(struct drxk_state *state)
 	status = hi_cfg_command(state);
 error:
 	if (status < 0)
-		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
+		pr_err("Error %d on %s\n", status, __func__);
 
 	return status;
 }
@@ -6060,7 +6060,7 @@ static int init_drxk(struct drxk_state *state)
 		if (status < 0)
 			goto error;
 
-		printk(KERN_INFO "DRXK driver version %d.%d.%d\n",
+		pr_info("DRXK driver version %d.%d.%d\n",
 			DRXK_VERSION_MAJOR, DRXK_VERSION_MINOR,
 			DRXK_VERSION_PATCH);
 
@@ -6128,7 +6128,7 @@ error:
 	if (status < 0) {
 		state->m_drxk_state = DRXK_NO_DEV;
 		drxk_i2c_unlock(state);
-		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
+		pr_err("Error %d on %s\n", status, __func__);
 	}
 
 	return status;
@@ -6141,11 +6141,9 @@ static void load_firmware_cb(const struct firmware *fw,
 
 	dprintk(1, ": %s\n", fw ? "firmware loaded" : "firmware not loaded");
 	if (!fw) {
-		printk(KERN_ERR
-		       "drxk: Could not load firmware file %s.\n",
+		pr_err("Could not load firmware file %s.\n",
 			state->microcode_name);
-		printk(KERN_INFO
-		       "drxk: Copy %s to your hotplug directory!\n",
+		pr_info("Copy %s to your hotplug directory!\n",
 			state->microcode_name);
 		state->microcode_name = NULL;
 
@@ -6219,8 +6217,7 @@ static int drxk_set_parameters(struct dvb_frontend *fe)
 		return -EAGAIN;
 
 	if (!fe->ops.tuner_ops.get_if_frequency) {
-		printk(KERN_ERR
-		       "drxk: Error: get_if_frequency() not defined at tuner. Can't work without it!\n");
+		pr_err("Error: get_if_frequency() not defined at tuner. Can't work without it!\n");
 		return -EINVAL;
 	}
 
@@ -6704,8 +6701,7 @@ struct dvb_frontend *drxk_attach(const struct drxk_config *config,
 					      GFP_KERNEL,
 					      state, load_firmware_cb);
 			if (status < 0) {
-				printk(KERN_ERR
-				       "drxk: failed to request a firmware\n");
+				pr_err("failed to request a firmware\n");
 				return NULL;
 			}
 		}
@@ -6733,11 +6729,11 @@ struct dvb_frontend *drxk_attach(const struct drxk_config *config,
 	p->post_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 	p->post_bit_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 
-	printk(KERN_INFO "drxk: frontend initialized.\n");
+	pr_info("frontend initialized.\n");
 	return &state->frontend;
 
 error:
-	printk(KERN_ERR "drxk: not found\n");
+	pr_err("not found\n");
 	kfree(state);
 	return NULL;
 }
