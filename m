Return-path: <linux-media-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:35629 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932561AbZKRTCN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Nov 2009 14:02:13 -0500
Date: Wed, 18 Nov 2009 20:02:01 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 4/6] firedtv: do not DMA-map stack addresses
To: linux-media@vger.kernel.org
cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.7dc1f889fd1b69ad@s5r6.in-berlin.de>
Message-ID: <tkrat.ffff709b3e481400@s5r6.in-berlin.de>
References: <tkrat.7dc1f889fd1b69ad@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a portability fix and reduces stack usage.

The DMA mapping API cannot map on-stack addresses, as explained in
Documentation/DMA-mapping.txt.  Convert the two cases of on-stack packet
payload buffers in firedtv (payload of write requests in avc_write and
of lock requests in cmp_lock) to slab-allocated memory.

We use the 512 bytes sized FCP frame buffer in struct firedtv for this
purpose.  Previously it held only incoming FCP responses, now it holds
pending FCP requests and is then overwriten by an FCP response from the
tuner subunit.  Ditto for CMP lock requests and responses.  Accesses to
the payload buffer are serialized by fdtv->avc_mutex.

As a welcome side effect, stack usage of the AV/C transaction functions
is reduced by 512 bytes.

Alas, avc_register_remote_control() is a special case:  It previously
did not wait for a response.  To fit better in with the other FCP
transactions, let it wait for an interim response.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/media/dvb/firewire/firedtv-1394.c |    9 +
 drivers/media/dvb/firewire/firedtv-avc.c  |  437 +++++++++++++---------
 drivers/media/dvb/firewire/firedtv-dvb.c  |    1 -
 drivers/media/dvb/firewire/firedtv-fw.c   |    2 
 drivers/media/dvb/firewire/firedtv.h      |    6 
 5 files changed, 264 insertions(+), 191 deletions(-)

Index: linux-2.6.32-rc7/drivers/media/dvb/firewire/firedtv-1394.c
===================================================================
--- linux-2.6.32-rc7.orig/drivers/media/dvb/firewire/firedtv-1394.c
+++ linux-2.6.32-rc7/drivers/media/dvb/firewire/firedtv-1394.c
@@ -90,13 +90,14 @@ static inline struct node_entry *node_of
 	return container_of(fdtv->device, struct unit_directory, device)->ne;
 }
 
-static int node_lock(struct firedtv *fdtv, u64 addr, __be32 data[])
+static int node_lock(struct firedtv *fdtv, u64 addr, void *data)
 {
+	quadlet_t *d = data;
 	int ret;
 
-	ret = hpsb_node_lock(node_of(fdtv), addr, EXTCODE_COMPARE_SWAP,
-		(__force quadlet_t *)&data[1], (__force quadlet_t)data[0]);
-	data[0] = data[1];
+	ret = hpsb_node_lock(node_of(fdtv), addr,
+			     EXTCODE_COMPARE_SWAP, &d[1], d[0]);
+	d[0] = d[1];
 
 	return ret;
 }
Index: linux-2.6.32-rc7/drivers/media/dvb/firewire/firedtv-avc.c
===================================================================
--- linux-2.6.32-rc7.orig/drivers/media/dvb/firewire/firedtv-avc.c
+++ linux-2.6.32-rc7/drivers/media/dvb/firewire/firedtv-avc.c
@@ -74,7 +74,6 @@
 #define EN50221_TAG_CA_INFO		0x9f8031
 
 struct avc_command_frame {
-	int length;
 	u8 ctype;
 	u8 subunit;
 	u8 opcode;
@@ -82,7 +81,6 @@ struct avc_command_frame {
 };
 
 struct avc_response_frame {
-	int length;
 	u8 response;
 	u8 subunit;
 	u8 opcode;
@@ -202,78 +200,65 @@ static void debug_pmt(char *msg, int len
 		       16, 1, msg, length, false);
 }
 
-static int __avc_write(struct firedtv *fdtv,
-		const struct avc_command_frame *c, struct avc_response_frame *r)
+static int avc_write(struct firedtv *fdtv)
 {
 	int err, retry;
 
-	if (r)
-		fdtv->avc_reply_received = false;
+	fdtv->avc_reply_received = false;
 
 	for (retry = 0; retry < 6; retry++) {
 		if (unlikely(avc_debug))
-			debug_fcp(&c->ctype, c->length);
+			debug_fcp(fdtv->avc_data, fdtv->avc_data_length);
 
 		err = fdtv->backend->write(fdtv, FCP_COMMAND_REGISTER,
-					   (void *)&c->ctype, c->length);
+				fdtv->avc_data, fdtv->avc_data_length);
 		if (err) {
-			fdtv->avc_reply_received = true;
 			dev_err(fdtv->device, "FCP command write failed\n");
+
 			return err;
 		}
 
-		if (!r)
-			return 0;
-
 		/*
 		 * AV/C specs say that answers should be sent within 150 ms.
 		 * Time out after 200 ms.
 		 */
 		if (wait_event_timeout(fdtv->avc_wait,
 				       fdtv->avc_reply_received,
-				       msecs_to_jiffies(200)) != 0) {
-			r->length = fdtv->response_length;
-			memcpy(&r->response, fdtv->response, r->length);
-
+				       msecs_to_jiffies(200)) != 0)
 			return 0;
-		}
 	}
 	dev_err(fdtv->device, "FCP response timed out\n");
+
 	return -ETIMEDOUT;
 }
 
-static int avc_write(struct firedtv *fdtv,
-		const struct avc_command_frame *c, struct avc_response_frame *r)
+static bool is_register_rc(struct avc_response_frame *r)
 {
-	int ret;
-
-	if (mutex_lock_interruptible(&fdtv->avc_mutex))
-		return -EINTR;
-
-	ret = __avc_write(fdtv, c, r);
-
-	mutex_unlock(&fdtv->avc_mutex);
-	return ret;
+	return r->opcode     == AVC_OPCODE_VENDOR &&
+	       r->operand[0] == SFE_VENDOR_DE_COMPANYID_0 &&
+	       r->operand[1] == SFE_VENDOR_DE_COMPANYID_1 &&
+	       r->operand[2] == SFE_VENDOR_DE_COMPANYID_2 &&
+	       r->operand[3] == SFE_VENDOR_OPCODE_REGISTER_REMOTE_CONTROL;
 }
 
 int avc_recv(struct firedtv *fdtv, void *data, size_t length)
 {
-	struct avc_response_frame *r =
-			data - offsetof(struct avc_response_frame, response);
+	struct avc_response_frame *r = data;
 
 	if (unlikely(avc_debug))
 		debug_fcp(data, length);
 
-	if (length >= 8 &&
-	    r->operand[0] == SFE_VENDOR_DE_COMPANYID_0 &&
-	    r->operand[1] == SFE_VENDOR_DE_COMPANYID_1 &&
-	    r->operand[2] == SFE_VENDOR_DE_COMPANYID_2 &&
-	    r->operand[3] == SFE_VENDOR_OPCODE_REGISTER_REMOTE_CONTROL) {
-		if (r->response == AVC_RESPONSE_CHANGED) {
-			fdtv_handle_rc(fdtv,
-			    r->operand[4] << 8 | r->operand[5]);
+	if (length >= 8 && is_register_rc(r)) {
+		switch (r->response) {
+		case AVC_RESPONSE_CHANGED:
+			fdtv_handle_rc(fdtv, r->operand[4] << 8 | r->operand[5]);
 			schedule_work(&fdtv->remote_ctrl_work);
-		} else if (r->response != AVC_RESPONSE_INTERIM) {
+			break;
+		case AVC_RESPONSE_INTERIM:
+			if (is_register_rc((void *)fdtv->avc_data))
+				goto wake;
+			break;
+		default:
 			dev_info(fdtv->device,
 				 "remote control result = %d\n", r->response);
 		}
@@ -285,9 +270,9 @@ int avc_recv(struct firedtv *fdtv, void 
 		return -EIO;
 	}
 
-	memcpy(fdtv->response, data, length);
-	fdtv->response_length = length;
-
+	memcpy(fdtv->avc_data, data, length);
+	fdtv->avc_data_length = length;
+wake:
 	fdtv->avc_reply_received = true;
 	wake_up(&fdtv->avc_wait);
 
@@ -319,9 +304,10 @@ static int add_pid_filter(struct firedtv
  * (not supported by the AVC standard)
  */
 static void avc_tuner_tuneqpsk(struct firedtv *fdtv,
-			       struct dvb_frontend_parameters *params,
-			       struct avc_command_frame *c)
+			       struct dvb_frontend_parameters *params)
 {
+	struct avc_command_frame *c = (void *)fdtv->avc_data;
+
 	c->opcode = AVC_OPCODE_VENDOR;
 
 	c->operand[0] = SFE_VENDOR_DE_COMPANYID_0;
@@ -370,16 +356,17 @@ static void avc_tuner_tuneqpsk(struct fi
 		c->operand[13] = 0x1;
 		c->operand[14] = 0xff;
 		c->operand[15] = 0xff;
-		c->length = 20;
+		fdtv->avc_data_length = 20;
 	} else {
-		c->length = 16;
+		fdtv->avc_data_length = 16;
 	}
 }
 
 static void avc_tuner_dsd_dvb_c(struct firedtv *fdtv,
-				struct dvb_frontend_parameters *params,
-				struct avc_command_frame *c)
+				struct dvb_frontend_parameters *params)
 {
+	struct avc_command_frame *c = (void *)fdtv->avc_data;
+
 	c->opcode = AVC_OPCODE_DSD;
 
 	c->operand[0] = 0;    /* source plug */
@@ -441,14 +428,15 @@ static void avc_tuner_dsd_dvb_c(struct f
 	c->operand[21] = 0x00;
 
 	/* Add PIDs to filter */
-	c->length = ALIGN(22 + add_pid_filter(fdtv, &c->operand[22]) + 3, 4);
+	fdtv->avc_data_length =
+		ALIGN(22 + add_pid_filter(fdtv, &c->operand[22]) + 3, 4);
 }
 
 static void avc_tuner_dsd_dvb_t(struct firedtv *fdtv,
-				struct dvb_frontend_parameters *params,
-				struct avc_command_frame *c)
+				struct dvb_frontend_parameters *params)
 {
 	struct dvb_ofdm_parameters *ofdm = &params->u.ofdm;
+	struct avc_command_frame *c = (void *)fdtv->avc_data;
 
 	c->opcode = AVC_OPCODE_DSD;
 
@@ -544,15 +532,18 @@ static void avc_tuner_dsd_dvb_t(struct f
 	c->operand[16] = 0x00; /* network_ID[1] */
 
 	/* Add PIDs to filter */
-	c->length = ALIGN(17 + add_pid_filter(fdtv, &c->operand[17]) + 3, 4);
+	fdtv->avc_data_length =
+		ALIGN(17 + add_pid_filter(fdtv, &c->operand[17]) + 3, 4);
 }
 
 int avc_tuner_dsd(struct firedtv *fdtv,
 		  struct dvb_frontend_parameters *params)
 {
-	char buffer[sizeof(struct avc_command_frame)];
-	struct avc_command_frame *c = (void *)buffer;
-	struct avc_response_frame *r = (void *)buffer; /* FIXME: unused */
+	struct avc_command_frame *c = (void *)fdtv->avc_data;
+	int ret;
+
+	if (mutex_lock_interruptible(&fdtv->avc_mutex))
+		return -EINTR;
 
 	memset(c, 0, sizeof(*c));
 
@@ -561,36 +552,41 @@ int avc_tuner_dsd(struct firedtv *fdtv,
 
 	switch (fdtv->type) {
 	case FIREDTV_DVB_S:
-	case FIREDTV_DVB_S2: avc_tuner_tuneqpsk(fdtv, params, c); break;
-	case FIREDTV_DVB_C: avc_tuner_dsd_dvb_c(fdtv, params, c); break;
-	case FIREDTV_DVB_T: avc_tuner_dsd_dvb_t(fdtv, params, c); break;
+	case FIREDTV_DVB_S2: avc_tuner_tuneqpsk(fdtv, params); break;
+	case FIREDTV_DVB_C: avc_tuner_dsd_dvb_c(fdtv, params); break;
+	case FIREDTV_DVB_T: avc_tuner_dsd_dvb_t(fdtv, params); break;
 	default:
 		BUG();
 	}
-
-	if (avc_write(fdtv, c, r) < 0)
-		return -EIO;
-
-	msleep(500);
+	ret = avc_write(fdtv);
 #if 0
-	/* FIXME: */
-	/* u8 *status was an out-parameter of avc_tuner_dsd, unused by caller */
+	/*
+	 * FIXME:
+	 * u8 *status was an out-parameter of avc_tuner_dsd, unused by caller.
+	 * Check for AVC_RESPONSE_ACCEPTED here instead?
+	 */
 	if (status)
 		*status = r->operand[2];
 #endif
-	return 0;
+	mutex_unlock(&fdtv->avc_mutex);
+
+	if (ret == 0)
+		msleep(500);
+
+	return ret;
 }
 
 int avc_tuner_set_pids(struct firedtv *fdtv, unsigned char pidc, u16 pid[])
 {
-	char buffer[sizeof(struct avc_command_frame)];
-	struct avc_command_frame *c = (void *)buffer;
-	struct avc_response_frame *r = (void *)buffer; /* FIXME: unused */
-	int pos, k;
+	struct avc_command_frame *c = (void *)fdtv->avc_data;
+	int ret, pos, k;
 
 	if (pidc > 16 && pidc != 0xff)
 		return -EINVAL;
 
+	if (mutex_lock_interruptible(&fdtv->avc_mutex))
+		return -EINTR;
+
 	memset(c, 0, sizeof(*c));
 
 	c->ctype   = AVC_CTYPE_CONTROL;
@@ -615,21 +611,26 @@ int avc_tuner_set_pids(struct firedtv *f
 			c->operand[pos++] = 0x00; /* filter_length */
 		}
 
-	c->length = ALIGN(3 + pos, 4);
+	fdtv->avc_data_length = ALIGN(3 + pos, 4);
+	ret = avc_write(fdtv);
 
-	if (avc_write(fdtv, c, r) < 0)
-		return -EIO;
+	/* FIXME: check response code? */
 
-	msleep(50);
-	return 0;
+	mutex_unlock(&fdtv->avc_mutex);
+
+	if (ret == 0)
+		msleep(50);
+
+	return ret;
 }
 
 int avc_tuner_get_ts(struct firedtv *fdtv)
 {
-	char buffer[sizeof(struct avc_command_frame)];
-	struct avc_command_frame *c = (void *)buffer;
-	struct avc_response_frame *r = (void *)buffer; /* FIXME: unused */
-	int sl;
+	struct avc_command_frame *c = (void *)fdtv->avc_data;
+	int ret, sl;
+
+	if (mutex_lock_interruptible(&fdtv->avc_mutex))
+		return -EINTR;
 
 	memset(c, 0, sizeof(*c));
 
@@ -650,20 +651,27 @@ int avc_tuner_get_ts(struct firedtv *fdt
 	c->operand[8] = 0x00;	/* valid_flags [1] */
 	c->operand[7 + sl] = 0x00; /* nr_of_dsit_sel_specs (always 0) */
 
-	c->length = fdtv->type == FIREDTV_DVB_T ? 24 : 28;
+	fdtv->avc_data_length = fdtv->type == FIREDTV_DVB_T ? 24 : 28;
+	ret = avc_write(fdtv);
 
-	if (avc_write(fdtv, c, r) < 0)
-		return -EIO;
+	/* FIXME: check response code? */
 
-	msleep(250);
-	return 0;
+	mutex_unlock(&fdtv->avc_mutex);
+
+	if (ret == 0)
+		msleep(250);
+
+	return ret;
 }
 
 int avc_identify_subunit(struct firedtv *fdtv)
 {
-	char buffer[sizeof(struct avc_command_frame)];
-	struct avc_command_frame *c = (void *)buffer;
-	struct avc_response_frame *r = (void *)buffer;
+	struct avc_command_frame *c = (void *)fdtv->avc_data;
+	struct avc_response_frame *r = (void *)fdtv->avc_data;
+	int ret;
+
+	if (mutex_lock_interruptible(&fdtv->avc_mutex))
+		return -EINTR;
 
 	memset(c, 0, sizeof(*c));
 
@@ -679,28 +687,33 @@ int avc_identify_subunit(struct firedtv 
 	c->operand[5] = 0x00; /* offset highbyte */
 	c->operand[6] = 0x0d; /* offset lowbyte  */
 
-	c->length = 12;
-
-	if (avc_write(fdtv, c, r) < 0)
-		return -EIO;
+	fdtv->avc_data_length = 12;
+	ret = avc_write(fdtv);
+	if (ret < 0)
+		goto out;
 
 	if ((r->response != AVC_RESPONSE_STABLE &&
 	     r->response != AVC_RESPONSE_ACCEPTED) ||
 	    (r->operand[3] << 8) + r->operand[4] != 8) {
 		dev_err(fdtv->device, "cannot read subunit identifier\n");
-		return -EINVAL;
+		ret = -EINVAL;
 	}
-	return 0;
+out:
+	mutex_unlock(&fdtv->avc_mutex);
+
+	return ret;
 }
 
 #define SIZEOF_ANTENNA_INPUT_INFO 22
 
 int avc_tuner_status(struct firedtv *fdtv, struct firedtv_tuner_status *stat)
 {
-	char buffer[sizeof(struct avc_command_frame)];
-	struct avc_command_frame *c = (void *)buffer;
-	struct avc_response_frame *r = (void *)buffer;
-	int length;
+	struct avc_command_frame *c = (void *)fdtv->avc_data;
+	struct avc_response_frame *r = (void *)fdtv->avc_data;
+	int length, ret;
+
+	if (mutex_lock_interruptible(&fdtv->avc_mutex))
+		return -EINTR;
 
 	memset(c, 0, sizeof(*c));
 
@@ -716,21 +729,23 @@ int avc_tuner_status(struct firedtv *fdt
 	c->operand[5] = 0x00;
 	c->operand[6] = 0x00;
 
-	c->length = 12;
-
-	if (avc_write(fdtv, c, r) < 0)
-		return -EIO;
+	fdtv->avc_data_length = 12;
+	ret = avc_write(fdtv);
+	if (ret < 0)
+		goto out;
 
 	if (r->response != AVC_RESPONSE_STABLE &&
 	    r->response != AVC_RESPONSE_ACCEPTED) {
 		dev_err(fdtv->device, "cannot read tuner status\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out;
 	}
 
 	length = r->operand[9];
 	if (r->operand[1] != 0x10 || length != SIZEOF_ANTENNA_INPUT_INFO) {
 		dev_err(fdtv->device, "got invalid tuner status\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out;
 	}
 
 	stat->active_system		= r->operand[10];
@@ -766,18 +781,22 @@ int avc_tuner_status(struct firedtv *fdt
 	stat->ca_dvb_flag		= r->operand[31] >> 3 & 1;
 	stat->ca_error_flag		= r->operand[31] >> 2 & 1;
 	stat->ca_initialization_status	= r->operand[31] >> 1 & 1;
+out:
+	mutex_unlock(&fdtv->avc_mutex);
 
-	return 0;
+	return ret;
 }
 
 int avc_lnb_control(struct firedtv *fdtv, char voltage, char burst,
 		    char conttone, char nrdiseq,
 		    struct dvb_diseqc_master_cmd *diseqcmd)
 {
-	char buffer[sizeof(struct avc_command_frame)];
-	struct avc_command_frame *c = (void *)buffer;
-	struct avc_response_frame *r = (void *)buffer;
-	int i, j, k;
+	struct avc_command_frame *c = (void *)fdtv->avc_data;
+	struct avc_response_frame *r = (void *)fdtv->avc_data;
+	int i, j, k, ret;
+
+	if (mutex_lock_interruptible(&fdtv->avc_mutex))
+		return -EINTR;
 
 	memset(c, 0, sizeof(*c));
 
@@ -805,23 +824,28 @@ int avc_lnb_control(struct firedtv *fdtv
 	c->operand[i++] = burst;
 	c->operand[i++] = conttone;
 
-	c->length = ALIGN(3 + i, 4);
-
-	if (avc_write(fdtv, c, r) < 0)
-		return -EIO;
+	fdtv->avc_data_length = ALIGN(3 + i, 4);
+	ret = avc_write(fdtv);
+	if (ret < 0)
+		goto out;
 
 	if (r->response != AVC_RESPONSE_ACCEPTED) {
 		dev_err(fdtv->device, "LNB control failed\n");
-		return -EINVAL;
+		ret = -EINVAL;
 	}
+out:
+	mutex_unlock(&fdtv->avc_mutex);
 
-	return 0;
+	return ret;
 }
 
 int avc_register_remote_control(struct firedtv *fdtv)
 {
-	char buffer[sizeof(struct avc_command_frame)];
-	struct avc_command_frame *c = (void *)buffer;
+	struct avc_command_frame *c = (void *)fdtv->avc_data;
+	int ret;
+
+	if (mutex_lock_interruptible(&fdtv->avc_mutex))
+		return -EINTR;
 
 	memset(c, 0, sizeof(*c));
 
@@ -834,9 +858,14 @@ int avc_register_remote_control(struct f
 	c->operand[2] = SFE_VENDOR_DE_COMPANYID_2;
 	c->operand[3] = SFE_VENDOR_OPCODE_REGISTER_REMOTE_CONTROL;
 
-	c->length = 8;
+	fdtv->avc_data_length = 8;
+	ret = avc_write(fdtv);
 
-	return avc_write(fdtv, c, NULL);
+	/* FIXME: check response code? */
+
+	mutex_unlock(&fdtv->avc_mutex);
+
+	return ret;
 }
 
 void avc_remote_ctrl_work(struct work_struct *work)
@@ -851,9 +880,11 @@ void avc_remote_ctrl_work(struct work_st
 #if 0 /* FIXME: unused */
 int avc_tuner_host2ca(struct firedtv *fdtv)
 {
-	char buffer[sizeof(struct avc_command_frame)];
-	struct avc_command_frame *c = (void *)buffer;
-	struct avc_response_frame *r = (void *)buffer; /* FIXME: unused */
+	struct avc_command_frame *c = (void *)fdtv->avc_data;
+	int ret;
+
+	if (mutex_lock_interruptible(&fdtv->avc_mutex))
+		return -EINTR;
 
 	memset(c, 0, sizeof(*c));
 
@@ -870,12 +901,14 @@ int avc_tuner_host2ca(struct firedtv *fd
 	c->operand[6] = 0; /* more/last */
 	c->operand[7] = 0; /* length */
 
-	c->length = 12;
+	fdtv->avc_data_length = 12;
+	ret = avc_write(fdtv);
 
-	if (avc_write(fdtv, c, r) < 0)
-		return -EIO;
+	/* FIXME: check response code? */
 
-	return 0;
+	mutex_unlock(&fdtv->avc_mutex);
+
+	return ret;
 }
 #endif
 
@@ -906,10 +939,12 @@ static int get_ca_object_length(struct a
 
 int avc_ca_app_info(struct firedtv *fdtv, char *app_info, unsigned int *len)
 {
-	char buffer[sizeof(struct avc_command_frame)];
-	struct avc_command_frame *c = (void *)buffer;
-	struct avc_response_frame *r = (void *)buffer;
-	int pos;
+	struct avc_command_frame *c = (void *)fdtv->avc_data;
+	struct avc_response_frame *r = (void *)fdtv->avc_data;
+	int pos, ret;
+
+	if (mutex_lock_interruptible(&fdtv->avc_mutex))
+		return -EINTR;
 
 	memset(c, 0, sizeof(*c));
 
@@ -924,10 +959,10 @@ int avc_ca_app_info(struct firedtv *fdtv
 	c->operand[4] = 0; /* slot */
 	c->operand[5] = SFE_VENDOR_TAG_CA_APPLICATION_INFO; /* ca tag */
 
-	c->length = 12;
-
-	if (avc_write(fdtv, c, r) < 0)
-		return -EIO;
+	fdtv->avc_data_length = 12;
+	ret = avc_write(fdtv);
+	if (ret < 0)
+		goto out;
 
 	/* FIXME: check response code and validate response data */
 
@@ -939,16 +974,20 @@ int avc_ca_app_info(struct firedtv *fdtv
 	app_info[4] = 0x01;
 	memcpy(&app_info[5], &r->operand[pos], 5 + r->operand[pos + 4]);
 	*len = app_info[3] + 4;
+out:
+	mutex_unlock(&fdtv->avc_mutex);
 
-	return 0;
+	return ret;
 }
 
 int avc_ca_info(struct firedtv *fdtv, char *app_info, unsigned int *len)
 {
-	char buffer[sizeof(struct avc_command_frame)];
-	struct avc_command_frame *c = (void *)buffer;
-	struct avc_response_frame *r = (void *)buffer;
-	int pos;
+	struct avc_command_frame *c = (void *)fdtv->avc_data;
+	struct avc_response_frame *r = (void *)fdtv->avc_data;
+	int pos, ret;
+
+	if (mutex_lock_interruptible(&fdtv->avc_mutex))
+		return -EINTR;
 
 	memset(c, 0, sizeof(*c));
 
@@ -963,10 +1002,12 @@ int avc_ca_info(struct firedtv *fdtv, ch
 	c->operand[4] = 0; /* slot */
 	c->operand[5] = SFE_VENDOR_TAG_CA_APPLICATION_INFO; /* ca tag */
 
-	c->length = 12;
+	fdtv->avc_data_length = 12;
+	ret = avc_write(fdtv);
+	if (ret < 0)
+		goto out;
 
-	if (avc_write(fdtv, c, r) < 0)
-		return -EIO;
+	/* FIXME: check response code and validate response data */
 
 	pos = get_ca_object_pos(r);
 	app_info[0] = (EN50221_TAG_CA_INFO >> 16) & 0xff;
@@ -976,15 +1017,19 @@ int avc_ca_info(struct firedtv *fdtv, ch
 	app_info[4] = r->operand[pos + 0];
 	app_info[5] = r->operand[pos + 1];
 	*len = app_info[3] + 4;
+out:
+	mutex_unlock(&fdtv->avc_mutex);
 
-	return 0;
+	return ret;
 }
 
 int avc_ca_reset(struct firedtv *fdtv)
 {
-	char buffer[sizeof(struct avc_command_frame)];
-	struct avc_command_frame *c = (void *)buffer;
-	struct avc_response_frame *r = (void *)buffer; /* FIXME: unused */
+	struct avc_command_frame *c = (void *)fdtv->avc_data;
+	int ret;
+
+	if (mutex_lock_interruptible(&fdtv->avc_mutex))
+		return -EINTR;
 
 	memset(c, 0, sizeof(*c));
 
@@ -1002,19 +1047,20 @@ int avc_ca_reset(struct firedtv *fdtv)
 	c->operand[7] = 1; /* length */
 	c->operand[8] = 0; /* force hardware reset */
 
-	c->length = 12;
+	fdtv->avc_data_length = 12;
+	ret = avc_write(fdtv);
 
-	if (avc_write(fdtv, c, r) < 0)
-		return -EIO;
+	/* FIXME: check response code? */
 
-	return 0;
+	mutex_unlock(&fdtv->avc_mutex);
+
+	return ret;
 }
 
 int avc_ca_pmt(struct firedtv *fdtv, char *msg, int length)
 {
-	char buffer[sizeof(struct avc_command_frame)];
-	struct avc_command_frame *c = (void *)buffer;
-	struct avc_response_frame *r = (void *)buffer;
+	struct avc_command_frame *c = (void *)fdtv->avc_data;
+	struct avc_response_frame *r = (void *)fdtv->avc_data;
 	int list_management;
 	int program_info_length;
 	int pmt_cmd_id;
@@ -1022,10 +1068,14 @@ int avc_ca_pmt(struct firedtv *fdtv, cha
 	int write_pos;
 	int es_info_length;
 	int crc32_csum;
+	int ret;
 
 	if (unlikely(avc_debug & AVC_DEBUG_APPLICATION_PMT))
 		debug_pmt(msg, length);
 
+	if (mutex_lock_interruptible(&fdtv->avc_mutex))
+		return -EINTR;
+
 	memset(c, 0, sizeof(*c));
 
 	c->ctype   = AVC_CTYPE_CONTROL;
@@ -1124,25 +1174,30 @@ int avc_ca_pmt(struct firedtv *fdtv, cha
 	c->operand[write_pos - 2] = (crc32_csum >>  8) & 0xff;
 	c->operand[write_pos - 1] = (crc32_csum >>  0) & 0xff;
 
-	c->length = ALIGN(3 + write_pos, 4);
-
-	if (avc_write(fdtv, c, r) < 0)
-		return -EIO;
+	fdtv->avc_data_length = ALIGN(3 + write_pos, 4);
+	ret = avc_write(fdtv);
+	if (ret < 0)
+		goto out;
 
 	if (r->response != AVC_RESPONSE_ACCEPTED) {
 		dev_err(fdtv->device,
 			"CA PMT failed with response 0x%x\n", r->response);
-		return -EFAULT;
+		ret = -EFAULT;
 	}
+out:
+	mutex_unlock(&fdtv->avc_mutex);
 
-	return 0;
+	return ret;
 }
 
 int avc_ca_get_time_date(struct firedtv *fdtv, int *interval)
 {
-	char buffer[sizeof(struct avc_command_frame)];
-	struct avc_command_frame *c = (void *)buffer;
-	struct avc_response_frame *r = (void *)buffer;
+	struct avc_command_frame *c = (void *)fdtv->avc_data;
+	struct avc_response_frame *r = (void *)fdtv->avc_data;
+	int ret;
+
+	if (mutex_lock_interruptible(&fdtv->avc_mutex))
+		return -EINTR;
 
 	memset(c, 0, sizeof(*c));
 
@@ -1159,23 +1214,27 @@ int avc_ca_get_time_date(struct firedtv 
 	c->operand[6] = 0; /* more/last */
 	c->operand[7] = 0; /* length */
 
-	c->length = 12;
-
-	if (avc_write(fdtv, c, r) < 0)
-		return -EIO;
+	fdtv->avc_data_length = 12;
+	ret = avc_write(fdtv);
+	if (ret < 0)
+		goto out;
 
 	/* FIXME: check response code and validate response data */
 
 	*interval = r->operand[get_ca_object_pos(r)];
+out:
+	mutex_unlock(&fdtv->avc_mutex);
 
-	return 0;
+	return ret;
 }
 
 int avc_ca_enter_menu(struct firedtv *fdtv)
 {
-	char buffer[sizeof(struct avc_command_frame)];
-	struct avc_command_frame *c = (void *)buffer;
-	struct avc_response_frame *r = (void *)buffer; /* FIXME: unused */
+	struct avc_command_frame *c = (void *)fdtv->avc_data;
+	int ret;
+
+	if (mutex_lock_interruptible(&fdtv->avc_mutex))
+		return -EINTR;
 
 	memset(c, 0, sizeof(*c));
 
@@ -1192,19 +1251,24 @@ int avc_ca_enter_menu(struct firedtv *fd
 	c->operand[6] = 0; /* more/last */
 	c->operand[7] = 0; /* length */
 
-	c->length = 12;
+	fdtv->avc_data_length = 12;
+	ret = avc_write(fdtv);
 
-	if (avc_write(fdtv, c, r) < 0)
-		return -EIO;
+	/* FIXME: check response code? */
 
-	return 0;
+	mutex_unlock(&fdtv->avc_mutex);
+
+	return ret;
 }
 
 int avc_ca_get_mmi(struct firedtv *fdtv, char *mmi_object, unsigned int *len)
 {
-	char buffer[sizeof(struct avc_command_frame)];
-	struct avc_command_frame *c = (void *)buffer;
-	struct avc_response_frame *r = (void *)buffer;
+	struct avc_command_frame *c = (void *)fdtv->avc_data;
+	struct avc_response_frame *r = (void *)fdtv->avc_data;
+	int ret;
+
+	if (mutex_lock_interruptible(&fdtv->avc_mutex))
+		return -EINTR;
 
 	memset(c, 0, sizeof(*c));
 
@@ -1221,17 +1285,19 @@ int avc_ca_get_mmi(struct firedtv *fdtv,
 	c->operand[6] = 0; /* more/last */
 	c->operand[7] = 0; /* length */
 
-	c->length = 12;
-
-	if (avc_write(fdtv, c, r) < 0)
-		return -EIO;
+	fdtv->avc_data_length = 12;
+	ret = avc_write(fdtv);
+	if (ret < 0)
+		goto out;
 
 	/* FIXME: check response code and validate response data */
 
 	*len = get_ca_object_length(r);
 	memcpy(mmi_object, &r->operand[get_ca_object_pos(r)], *len);
+out:
+	mutex_unlock(&fdtv->avc_mutex);
 
-	return 0;
+	return ret;
 }
 
 #define CMP_OUTPUT_PLUG_CONTROL_REG_0	0xfffff0000904ULL
@@ -1248,6 +1314,7 @@ static int cmp_read(struct firedtv *fdtv
 		dev_err(fdtv->device, "CMP: read I/O error\n");
 
 	mutex_unlock(&fdtv->avc_mutex);
+
 	return ret;
 }
 
@@ -1258,11 +1325,17 @@ static int cmp_lock(struct firedtv *fdtv
 	if (mutex_lock_interruptible(&fdtv->avc_mutex))
 		return -EINTR;
 
-	ret = fdtv->backend->lock(fdtv, addr, data);
+	/* data[] is stack-allocated and should not be DMA-mapped. */
+	memcpy(fdtv->avc_data, data, 8);
+
+	ret = fdtv->backend->lock(fdtv, addr, fdtv->avc_data);
 	if (ret < 0)
 		dev_err(fdtv->device, "CMP: lock I/O error\n");
+	else
+		memcpy(data, fdtv->avc_data, 8);
 
 	mutex_unlock(&fdtv->avc_mutex);
+
 	return ret;
 }
 
Index: linux-2.6.32-rc7/drivers/media/dvb/firewire/firedtv-dvb.c
===================================================================
--- linux-2.6.32-rc7.orig/drivers/media/dvb/firewire/firedtv-dvb.c
+++ linux-2.6.32-rc7/drivers/media/dvb/firewire/firedtv-dvb.c
@@ -277,7 +277,6 @@ struct firedtv *fdtv_alloc(struct device
 
 	mutex_init(&fdtv->avc_mutex);
 	init_waitqueue_head(&fdtv->avc_wait);
-	fdtv->avc_reply_received = true;
 	mutex_init(&fdtv->demux_mutex);
 	INIT_WORK(&fdtv->remote_ctrl_work, avc_remote_ctrl_work);
 
Index: linux-2.6.32-rc7/drivers/media/dvb/firewire/firedtv-fw.c
===================================================================
--- linux-2.6.32-rc7.orig/drivers/media/dvb/firewire/firedtv-fw.c
+++ linux-2.6.32-rc7/drivers/media/dvb/firewire/firedtv-fw.c
@@ -41,7 +41,7 @@ static int node_req(struct firedtv *fdtv
 	return rcode != RCODE_COMPLETE ? -EIO : 0;
 }
 
-static int node_lock(struct firedtv *fdtv, u64 addr, __be32 data[])
+static int node_lock(struct firedtv *fdtv, u64 addr, void *data)
 {
 	return node_req(fdtv, addr, data, 8, TCODE_LOCK_COMPARE_SWAP);
 }
Index: linux-2.6.32-rc7/drivers/media/dvb/firewire/firedtv.h
===================================================================
--- linux-2.6.32-rc7.orig/drivers/media/dvb/firewire/firedtv.h
+++ linux-2.6.32-rc7/drivers/media/dvb/firewire/firedtv.h
@@ -73,7 +73,7 @@ struct input_dev;
 struct firedtv;
 
 struct firedtv_backend {
-	int (*lock)(struct firedtv *fdtv, u64 addr, __be32 data[]);
+	int (*lock)(struct firedtv *fdtv, u64 addr, void *data);
 	int (*read)(struct firedtv *fdtv, u64 addr, void *data);
 	int (*write)(struct firedtv *fdtv, u64 addr, void *data, size_t len);
 	int (*start_iso)(struct firedtv *fdtv);
@@ -114,8 +114,8 @@ struct firedtv {
 	unsigned long		channel_active;
 	u16			channel_pid[16];
 
-	size_t			response_length;
-	u8			response[512];
+	int			avc_data_length;
+	u8			avc_data[512];
 };
 
 /* firedtv-1394.c */

-- 
Stefan Richter
-=====-==--= =-== =--=-
http://arcgraph.de/sr/

