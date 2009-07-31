Return-path: <linux-media-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:55154 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855AbZGaUHm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Jul 2009 16:07:42 -0400
Received: from smtp06.web.de (fmsmtp06.dlan.cinetic.de [172.20.5.172])
	by fmmailgate01.web.de (Postfix) with ESMTP id 9B4C510F1C275
	for <linux-media@vger.kernel.org>; Fri, 31 Jul 2009 22:07:42 +0200 (CEST)
Received: from [217.228.167.87] (helo=[172.16.99.2])
	by smtp06.web.de with asmtp (TLSv1:AES256-SHA:256)
	(WEB.DE 4.110 #277)
	id 1MWyOE-0002T2-00
	for linux-media@vger.kernel.org; Fri, 31 Jul 2009 22:07:42 +0200
Message-ID: <4A734F0A.4000600@magic.ms>
Date: Fri, 31 Jul 2009 22:07:38 +0200
From: emagick@magic.ms
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Patch for  stack/DMA problems in Cinergy T2 drivers
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There might be a more elegant solution, but this seems to work for me:

--- drivers/media/dvb/dvb-usb/cinergyT2-fe.c	2009-06-10 05:05:27.000000000 +0200
+++ drivers/media/dvb/dvb-usb/cinergyT2-fe.c	2009-07-31 22:02:48.000000000 +0200
@@ -146,66 +146,103 @@
  					fe_status_t *status)
  {
  	struct cinergyt2_fe_state *state = fe->demodulator_priv;
-	struct dvbt_get_status_msg result;
-	u8 cmd[] = { CINERGYT2_EP1_GET_TUNER_STATUS };
+	struct dvbt_get_status_msg *result;
+	static const u8 cmd0[] = { CINERGYT2_EP1_GET_TUNER_STATUS };
+        u8 *cmd;
  	int ret;

-	ret = dvb_usb_generic_rw(state->d, cmd, sizeof(cmd), (u8 *)&result,
-			sizeof(result), 0);
-	if (ret < 0)
+        cmd = kmalloc(sizeof(cmd0), GFP_KERNEL);
+        if (!cmd) return -ENOMEM;
+        memcpy(cmd, cmd0, sizeof(cmd0));
+        result = kmalloc(sizeof(*result), GFP_KERNEL);
+        if (!result) {
+                kfree(cmd);
+                return -ENOMEM;
+        }
+	ret = dvb_usb_generic_rw(state->d, cmd, sizeof(cmd0), (u8 *)result,
+			sizeof(*result), 0);
+        kfree(cmd);
+	if (ret < 0) {
+                kfree(result);
  		return ret;
+        }

  	*status = 0;

-	if (0xffff - le16_to_cpu(result.gain) > 30)
+	if (0xffff - le16_to_cpu(result->gain) > 30)
  		*status |= FE_HAS_SIGNAL;
-	if (result.lock_bits & (1 << 6))
+	if (result->lock_bits & (1 << 6))
  		*status |= FE_HAS_LOCK;
-	if (result.lock_bits & (1 << 5))
+	if (result->lock_bits & (1 << 5))
  		*status |= FE_HAS_SYNC;
-	if (result.lock_bits & (1 << 4))
+	if (result->lock_bits & (1 << 4))
  		*status |= FE_HAS_CARRIER;
-	if (result.lock_bits & (1 << 1))
+	if (result->lock_bits & (1 << 1))
  		*status |= FE_HAS_VITERBI;

  	if ((*status & (FE_HAS_CARRIER | FE_HAS_VITERBI | FE_HAS_SYNC)) !=
  			(FE_HAS_CARRIER | FE_HAS_VITERBI | FE_HAS_SYNC))
  		*status &= ~FE_HAS_LOCK;

+        kfree(result);
  	return 0;
  }

  static int cinergyt2_fe_read_ber(struct dvb_frontend *fe, u32 *ber)
  {
  	struct cinergyt2_fe_state *state = fe->demodulator_priv;
-	struct dvbt_get_status_msg status;
-	char cmd[] = { CINERGYT2_EP1_GET_TUNER_STATUS };
+	struct dvbt_get_status_msg *status;
+	static const u8 cmd0[] = { CINERGYT2_EP1_GET_TUNER_STATUS };
+        u8 *cmd;
  	int ret;

-	ret = dvb_usb_generic_rw(state->d, cmd, sizeof(cmd), (char *)&status,
-				sizeof(status), 0);
-	if (ret < 0)
+        cmd = kmalloc(sizeof(cmd0), GFP_KERNEL);
+        if (!cmd) return -ENOMEM;
+        memcpy(cmd, cmd0, sizeof(cmd0));
+        status = kmalloc(sizeof(*status), GFP_KERNEL);
+        if (!status) {
+                kfree(cmd);
+                return -ENOMEM;
+        }
+	ret = dvb_usb_generic_rw(state->d, cmd, sizeof(cmd0), (char *)status,
+				sizeof(*status), 0);
+        kfree(cmd);
+	if (ret < 0) {
+                kfree(status);
  		return ret;
-
-	*ber = le32_to_cpu(status.viterbi_error_rate);
+        }
+	*ber = le32_to_cpu(status->viterbi_error_rate);
+        kfree(status);
  	return 0;
  }

  static int cinergyt2_fe_read_unc_blocks(struct dvb_frontend *fe, u32 *unc)
  {
  	struct cinergyt2_fe_state *state = fe->demodulator_priv;
-	struct dvbt_get_status_msg status;
-	u8 cmd[] = { CINERGYT2_EP1_GET_TUNER_STATUS };
+	struct dvbt_get_status_msg *status;
+	static const u8 cmd0[] = { CINERGYT2_EP1_GET_TUNER_STATUS };
+        u8 *cmd;
  	int ret;

-	ret = dvb_usb_generic_rw(state->d, cmd, sizeof(cmd), (u8 *)&status,
-				sizeof(status), 0);
+        cmd = kmalloc(sizeof(cmd0), GFP_KERNEL);
+        if (!cmd) return -ENOMEM;
+        memcpy(cmd, cmd0, sizeof(cmd0));
+        status = kmalloc(sizeof(*status), GFP_KERNEL);
+        if (!status) {
+                kfree(cmd);
+                return -ENOMEM;
+        }
+	ret = dvb_usb_generic_rw(state->d, cmd, sizeof(cmd0), (u8 *)status,
+				sizeof(*status), 0);
+        kfree(cmd);
  	if (ret < 0) {
+                kfree(status);
  		err("cinergyt2_fe_read_unc_blocks() Failed! (Error=%d)\n",
  			ret);
  		return ret;
  	}
-	*unc = le32_to_cpu(status.uncorrected_block_count);
+	*unc = le32_to_cpu(status->uncorrected_block_count);
+        kfree(status);
  	return 0;
  }

@@ -213,35 +250,59 @@
  						u16 *strength)
  {
  	struct cinergyt2_fe_state *state = fe->demodulator_priv;
-	struct dvbt_get_status_msg status;
-	char cmd[] = { CINERGYT2_EP1_GET_TUNER_STATUS };
+	struct dvbt_get_status_msg *status;
+	static const u8 cmd0[] = { CINERGYT2_EP1_GET_TUNER_STATUS };
+        u8 *cmd;
  	int ret;

-	ret = dvb_usb_generic_rw(state->d, cmd, sizeof(cmd), (char *)&status,
-				sizeof(status), 0);
+        cmd = kmalloc(sizeof(cmd0), GFP_KERNEL);
+        if (!cmd) return -ENOMEM;
+        memcpy(cmd, cmd0, sizeof(cmd0));
+        status = kmalloc(sizeof(*status), GFP_KERNEL);
+        if (!status) {
+                kfree(cmd);
+                return -ENOMEM;
+        }
+	ret = dvb_usb_generic_rw(state->d, cmd, sizeof(cmd0), (char *)status,
+				sizeof(*status), 0);
+        kfree(cmd);
  	if (ret < 0) {
+                kfree(status);
  		err("cinergyt2_fe_read_signal_strength() Failed!"
  			" (Error=%d)\n", ret);
  		return ret;
  	}
-	*strength = (0xffff - le16_to_cpu(status.gain));
+	*strength = (0xffff - le16_to_cpu(status->gain));
+        kfree(status);
  	return 0;
  }

  static int cinergyt2_fe_read_snr(struct dvb_frontend *fe, u16 *snr)
  {
  	struct cinergyt2_fe_state *state = fe->demodulator_priv;
-	struct dvbt_get_status_msg status;
-	char cmd[] = { CINERGYT2_EP1_GET_TUNER_STATUS };
+	struct dvbt_get_status_msg *status;
+	static const u8 cmd0[] = { CINERGYT2_EP1_GET_TUNER_STATUS };
+        u8 *cmd;
  	int ret;

-	ret = dvb_usb_generic_rw(state->d, cmd, sizeof(cmd), (char *)&status,
-				sizeof(status), 0);
+        cmd = kmalloc(sizeof(cmd0), GFP_KERNEL);
+        if (!cmd) return -ENOMEM;
+        memcpy(cmd, cmd0, sizeof(cmd0));
+        status = kmalloc(sizeof(*status), GFP_KERNEL);
+        if (!status) {
+                kfree(cmd);
+                return -ENOMEM;
+        }
+	ret = dvb_usb_generic_rw(state->d, cmd, sizeof(cmd0), (char *)status,
+				sizeof(*status), 0);
+        kfree(cmd);
  	if (ret < 0) {
+                kfree(status);
  		err("cinergyt2_fe_read_snr() Failed! (Error=%d)\n", ret);
  		return ret;
  	}
-	*snr = (status.snr << 8) | status.snr;
+	*snr = (status->snr << 8) | status->snr;
+        kfree(status);
  	return 0;
  }

@@ -267,19 +328,27 @@
  				  struct dvb_frontend_parameters *fep)
  {
  	struct cinergyt2_fe_state *state = fe->demodulator_priv;
-	struct dvbt_set_parameters_msg param;
-	char result[2];
+        struct dvbt_set_parameters_msg *param;
+        char *result;
  	int err;

-	param.cmd = CINERGYT2_EP1_SET_TUNER_PARAMETERS;
-	param.tps = cpu_to_le16(compute_tps(fep));
-	param.freq = cpu_to_le32(fep->frequency / 1000);
-	param.bandwidth = 8 - fep->u.ofdm.bandwidth - BANDWIDTH_8_MHZ;
-
+        param = kmalloc(sizeof(*param), GFP_KERNEL);
+        if (!param) return -ENOMEM;
+	param->cmd = CINERGYT2_EP1_SET_TUNER_PARAMETERS;
+	param->tps = cpu_to_le16(compute_tps(fep));
+	param->freq = cpu_to_le32(fep->frequency / 1000);
+	param->bandwidth = 8 - fep->u.ofdm.bandwidth - BANDWIDTH_8_MHZ;
+        result = kmalloc(2, GFP_KERNEL);
+        if (!result) {
+                kfree(param);
+                return -ENOMEM;
+        }
  	err = dvb_usb_generic_rw(state->d,
-			(char *)&param, sizeof(param),
-			result, sizeof(result), 0);
-	if (err < 0)
+			(char *)param, sizeof(*param),
+                        result, 2, 0);
+        kfree(param);
+        kfree(result);
+        if (err < 0)
  		err("cinergyt2_fe_set_frontend() Failed! err=%d\n", err);

  	return (err < 0) ? err : 0;

