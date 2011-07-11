Return-path: <mchehab@localhost>
Received: from mx1.redhat.com ([209.132.183.28]:7032 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755753Ab1GKB72 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jul 2011 21:59:28 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p6B1xRS1018096
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 10 Jul 2011 21:59:27 -0400
Received: from pedra (vpn-225-29.phx2.redhat.com [10.3.225.29])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p6B1xKKS030664
	for <linux-media@vger.kernel.org>; Sun, 10 Jul 2011 21:59:27 -0400
Date: Sun, 10 Jul 2011 22:58:48 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 01/21] [media] drxk: add drxk prefix to the errors
Message-ID: <20110710225848.3135c47f@pedra>
In-Reply-To: <cover.1310347962.git.mchehab@redhat.com>
References: <cover.1310347962.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

It is hard to identify the origin for those errors without a
prefix to indicate which driver produced them:

[ 1390.220984] i2c_write error
[ 1390.224133] I2C Write error
[ 1391.284202] i2c_read error
[ 1392.288685] i2c_read error

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/dvb/frontends/drxk_hard.c b/drivers/media/dvb/frontends/drxk_hard.c
index 24f9897..f550332 100644
--- a/drivers/media/dvb/frontends/drxk_hard.c
+++ b/drivers/media/dvb/frontends/drxk_hard.c
@@ -317,7 +317,7 @@ static int i2c_write(struct i2c_adapter *adap, u8 adr, u8 *data, int len)
 	    .addr = adr, .flags = 0, .buf = data, .len = len };
 
 	if (i2c_transfer(adap, &msg, 1) != 1) {
-		printk(KERN_ERR "i2c_write error\n");
+		printk(KERN_ERR "drxk: i2c write error at addr 0x%02x\n", adr);
 		return -1;
 	}
 	return 0;
@@ -332,7 +332,7 @@ static int i2c_read(struct i2c_adapter *adap,
 	 .buf = answ, .len = alen}
 	};
 	if (i2c_transfer(adap, msgs, 2) != 2) {
-		printk(KERN_ERR "i2c_read error\n");
+		printk(KERN_ERR "drxk: i2c read error at addr 0x%02x\n", adr);
 		return -1;
 	}
 	return 0;
@@ -479,7 +479,8 @@ static int WriteBlock(struct drxk_state *state, u32 Address,
 		status = i2c_write(state->i2c, state->demod_address,
 				   &state->Chunk[0], Chunk + AdrLength);
 		if (status < 0) {
-			printk(KERN_ERR "I2C Write error\n");
+			printk(KERN_ERR "drxk: %s: i2c write error at addr 0x%02x\n",
+			       __func__, Address);
 			break;
 		}
 		pBlock += Chunk;
@@ -505,7 +506,7 @@ int PowerUpDevice(struct drxk_state *state)
 			data = 0;
 			if (i2c_write(state->i2c,
 				      state->demod_address, &data, 1) < 0)
-				printk(KERN_ERR "powerup failed\n");
+				printk(KERN_ERR "drxk: powerup failed\n");
 			msleep(10);
 			retryCount++;
 		} while (i2c_read1(state->i2c,
@@ -989,7 +990,7 @@ static int GetDeviceCapabilities(struct drxk_state *state)
 			state->m_hasIRQN = false;
 			break;
 		default:
-			printk(KERN_ERR "DeviceID not supported = %02x\n",
+			printk(KERN_ERR "drxk: DeviceID not supported = %02x\n",
 			       ((sioTopJtagidLo >> 12) & 0xFF));
 			status = -1;
 			break;
@@ -1256,7 +1257,7 @@ static int BLChainCmd(struct drxk_state *state,
 		} while ((blStatus == 0x1) &&
 			 ((time_is_after_jiffies(end))));
 		if (blStatus == 0x1) {
-			printk(KERN_ERR "SIO not ready\n");
+			printk(KERN_ERR "drxk: SIO not ready\n");
 			mutex_unlock(&state->mutex);
 			return -1;
 		}
@@ -1344,7 +1345,7 @@ static int DVBTEnableOFDMTokenRing(struct drxk_state *state, bool enable)
 			break;
 	} while ((data != desiredStatus) && ((time_is_after_jiffies(end))));
 	if (data != desiredStatus) {
-		printk(KERN_ERR "SIO not ready\n");
+		printk(KERN_ERR "drxk: SIO not ready\n");
 		return -1;
 	}
 	return status;
@@ -1419,7 +1420,7 @@ static int scu_command(struct drxk_state *state,
 		} while (!(curCmd == DRX_SCU_READY)
 			 && (time_is_after_jiffies(end)));
 		if (curCmd != DRX_SCU_READY) {
-			printk(KERN_ERR "SCU not ready\n");
+			printk(KERN_ERR "drxk: SCU not ready\n");
 			mutex_unlock(&state->mutex);
 			return -1;
 		}
@@ -1439,18 +1440,18 @@ static int scu_command(struct drxk_state *state,
 
 			/* check a few fixed error codes */
 			if (err == SCU_RESULT_UNKSTD) {
-				printk(KERN_ERR "SCU_RESULT_UNKSTD\n");
+				printk(KERN_ERR "drxk: SCU_RESULT_UNKSTD\n");
 				mutex_unlock(&state->mutex);
 				return -1;
 			} else if (err == SCU_RESULT_UNKCMD) {
-				printk(KERN_ERR "SCU_RESULT_UNKCMD\n");
+				printk(KERN_ERR "drxk: SCU_RESULT_UNKCMD\n");
 				mutex_unlock(&state->mutex);
 				return -1;
 			}
 			/* here it is assumed that negative means error,
 			   and positive no error */
 			else if (err < 0) {
-				printk(KERN_ERR "%s ERROR\n", __func__);
+				printk(KERN_ERR "drxk: %s ERROR\n", __func__);
 				mutex_unlock(&state->mutex);
 				return -1;
 			}
@@ -1458,7 +1459,7 @@ static int scu_command(struct drxk_state *state,
 	} while (0);
 	mutex_unlock(&state->mutex);
 	if (status < 0)
-		printk(KERN_ERR "%s: status = %d\n", __func__, status);
+		printk(KERN_ERR "drxk: %s: status = %d\n", __func__, status);
 
 	return status;
 }
@@ -2720,7 +2721,7 @@ static int BLDirectCmd(struct drxk_state *state, u32 targetAddr,
 				break;
 		} while ((blStatus == 0x1) && time_is_after_jiffies(end));
 		if (blStatus == 0x1) {
-			printk(KERN_ERR "SIO not ready\n");
+			printk(KERN_ERR "drxk: SIO not ready\n");
 			mutex_unlock(&state->mutex);
 			return -1;
 		}
@@ -3534,7 +3535,7 @@ static int SetDVBTStandard(struct drxk_state *state,
 	} while (0);
 
 	if (status < 0)
-		printk(KERN_ERR "%s status - %08x\n", __func__, status);
+		printk(KERN_ERR "drxk: %s status - %08x\n", __func__, status);
 
 	return status;
 }
@@ -3589,7 +3590,7 @@ static int SetDVBT(struct drxk_state *state, u16 IntermediateFreqkHz,
 	u16 param1;
 	int status;
 
-	/* printk(KERN_DEBUG "%s IF =%d, TFO = %d\n", __func__, IntermediateFreqkHz, tunerFreqOffset); */
+	/* printk(KERN_DEBUG "drxk: %s IF =%d, TFO = %d\n", __func__, IntermediateFreqkHz, tunerFreqOffset); */
 	do {
 		status = scu_command(state, SCU_RAM_COMMAND_STANDARD_OFDM | SCU_RAM_COMMAND_CMD_DEMOD_STOP, 0, NULL, 1, &cmdResult);
 		if (status < 0)
@@ -4089,7 +4090,7 @@ static int SetQAMMeasurement(struct drxk_state *state,
 	} while (0);
 
 	if (status < 0)
-		printk(KERN_ERR "%s: status - %08x\n", __func__, status);
+		printk(KERN_ERR "drxk: %s: status - %08x\n", __func__, status);
 
 	return status;
 }
@@ -5107,7 +5108,7 @@ static int QAMSetSymbolrate(struct drxk_state *state)
 		/* Select & calculate correct IQM rate */
 		adcFrequency = (state->m_sysClockFreq * 1000) / 3;
 		ratesel = 0;
-		/* printk(KERN_DEBUG "SR %d\n", state->param.u.qam.symbol_rate); */
+		/* printk(KERN_DEBUG "drxk: SR %d\n", state->param.u.qam.symbol_rate); */
 		if (state->param.u.qam.symbol_rate <= 1188750)
 			ratesel = 3;
 		else if (state->param.u.qam.symbol_rate <= 2377500)
@@ -5174,7 +5175,7 @@ static int GetQAMLockStatus(struct drxk_state *state, u32 *pLockStatus)
 			SCU_RAM_COMMAND_CMD_DEMOD_GET_LOCK, 0, NULL, 2,
 			Result);
 	if (status < 0)
-		printk(KERN_ERR "%s status = %08x\n", __func__, status);
+		printk(KERN_ERR "drxk: %s status = %08x\n", __func__, status);
 
 	if (Result[1] < SCU_RAM_QAM_LOCKED_LOCKED_DEMOD_LOCKED) {
 		/* 0x0000 NOT LOCKED */
@@ -5444,7 +5445,7 @@ static int SetQAM(struct drxk_state *state, u16 IntermediateFreqkHz,
 	} while (0);
 
 	if (status < 0)
-		printk(KERN_ERR "%s %d\n", __func__, status);
+		printk(KERN_ERR "drxk: %s %d\n", __func__, status);
 
 	return status;
 }
@@ -5734,9 +5735,9 @@ static int load_microcode(struct drxk_state *state, char *mc_name)
 	err = request_firmware(&fw, mc_name, state->i2c->dev.parent);
 	if (err < 0) {
 		printk(KERN_ERR
-		       "Could not load firmware file %s.\n", mc_name);
+		       "drxk: Could not load firmware file %s.\n", mc_name);
 		printk(KERN_INFO
-		       "Copy %s to your hotplug directory!\n", mc_name);
+		       "drxk: Copy %s to your hotplug directory!\n", mc_name);
 		return err;
 	}
 	err = DownloadMicrocode(state, fw->data, fw->size);
@@ -5970,7 +5971,7 @@ static int drxk_gate_ctrl(struct dvb_frontend *fe, int enable)
 {
 	struct drxk_state *state = fe->demodulator_priv;
 
-	/* printk(KERN_DEBUG "drxk_gate %d\n", enable); */
+	/* printk(KERN_DEBUG "drxk: drxk_gate %d\n", enable); */
 	return ConfigureI2CBridge(state, enable ? true : false);
 }
 
@@ -5990,7 +5991,7 @@ static int drxk_set_parameters(struct dvb_frontend *fe,
 	fe->ops.tuner_ops.get_frequency(fe, &IF);
 	Start(state, 0, IF);
 
-	/* printk(KERN_DEBUG "%s IF=%d done\n", __func__, IF); */
+	/* printk(KERN_DEBUG "drxk: %s IF=%d done\n", __func__, IF); */
 
 	return 0;
 }
@@ -6068,7 +6069,7 @@ static void drxk_t_release(struct dvb_frontend *fe)
 #if 0
 	struct drxk_state *state = fe->demodulator_priv;
 
-	printk(KERN_DEBUG "%s\n", __func__);
+	printk(KERN_DEBUG "drxk: %s\n", __func__);
 	kfree(state);
 #endif
 }
-- 
1.7.1


