Return-path: <linux-media-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:35640 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932459AbZKRTDm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Nov 2009 14:03:42 -0500
Date: Wed, 18 Nov 2009 20:03:31 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 6/6] firedtv: reduce memset()s
To: linux-media@vger.kernel.org
cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.7dc1f889fd1b69ad@s5r6.in-berlin.de>
Message-ID: <tkrat.534a0b95df131b2e@s5r6.in-berlin.de>
References: <tkrat.7dc1f889fd1b69ad@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Before each FCP transdaction, the entire 512 bytes of the FCP frame were
cleared, then values filled in.

Clear only the bytes between filled-in bytes and end of the
  - request frame, or
  - response frame if data from a larger response will be needed, or
  - whole frame if data from a variable length response will be taken.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/media/dvb/firewire/firedtv-avc.c |  146 ++++++++++-------------
 1 file changed, 65 insertions(+), 81 deletions(-)

Index: linux-2.6.32-rc7/drivers/media/dvb/firewire/firedtv-avc.c
===================================================================
--- linux-2.6.32-rc7.orig/drivers/media/dvb/firewire/firedtv-avc.c
+++ linux-2.6.32-rc7/drivers/media/dvb/firewire/firedtv-avc.c
@@ -87,6 +87,21 @@ struct avc_response_frame {
 	u8 operand[509];
 };
 
+#define LAST_OPERAND (509 - 1)
+
+static inline void clear_operands(struct avc_command_frame *c, int from, int to)
+{
+	memset(&c->operand[from], 0, to - from + 1);
+}
+
+static void pad_operands(struct avc_command_frame *c, int from)
+{
+	int to = ALIGN(from, 4);
+
+	if (from <= to && to <= LAST_OPERAND)
+		clear_operands(c, from, to);
+}
+
 #define AVC_DEBUG_READ_DESCRIPTOR              0x0001
 #define AVC_DEBUG_DSIT                         0x0002
 #define AVC_DEBUG_DSD                          0x0004
@@ -303,8 +318,8 @@ static int add_pid_filter(struct firedtv
  * tuning command for setting the relative LNB frequency
  * (not supported by the AVC standard)
  */
-static void avc_tuner_tuneqpsk(struct firedtv *fdtv,
-			       struct dvb_frontend_parameters *params)
+static int avc_tuner_tuneqpsk(struct firedtv *fdtv,
+			      struct dvb_frontend_parameters *params)
 {
 	struct avc_command_frame *c = (void *)fdtv->avc_data;
 
@@ -356,14 +371,15 @@ static void avc_tuner_tuneqpsk(struct fi
 		c->operand[13] = 0x1;
 		c->operand[14] = 0xff;
 		c->operand[15] = 0xff;
-		fdtv->avc_data_length = 20;
+
+		return 16;
 	} else {
-		fdtv->avc_data_length = 16;
+		return 13;
 	}
 }
 
-static void avc_tuner_dsd_dvb_c(struct firedtv *fdtv,
-				struct dvb_frontend_parameters *params)
+static int avc_tuner_dsd_dvb_c(struct firedtv *fdtv,
+			       struct dvb_frontend_parameters *params)
 {
 	struct avc_command_frame *c = (void *)fdtv->avc_data;
 
@@ -427,13 +443,11 @@ static void avc_tuner_dsd_dvb_c(struct f
 	c->operand[20] = 0x00;
 	c->operand[21] = 0x00;
 
-	/* Add PIDs to filter */
-	fdtv->avc_data_length =
-		ALIGN(22 + add_pid_filter(fdtv, &c->operand[22]) + 3, 4);
+	return 22 + add_pid_filter(fdtv, &c->operand[22]);
 }
 
-static void avc_tuner_dsd_dvb_t(struct firedtv *fdtv,
-				struct dvb_frontend_parameters *params)
+static int avc_tuner_dsd_dvb_t(struct firedtv *fdtv,
+			       struct dvb_frontend_parameters *params)
 {
 	struct dvb_ofdm_parameters *ofdm = &params->u.ofdm;
 	struct avc_command_frame *c = (void *)fdtv->avc_data;
@@ -531,32 +545,31 @@ static void avc_tuner_dsd_dvb_t(struct f
 	c->operand[15] = 0x00; /* network_ID[0] */
 	c->operand[16] = 0x00; /* network_ID[1] */
 
-	/* Add PIDs to filter */
-	fdtv->avc_data_length =
-		ALIGN(17 + add_pid_filter(fdtv, &c->operand[17]) + 3, 4);
+	return 17 + add_pid_filter(fdtv, &c->operand[17]);
 }
 
 int avc_tuner_dsd(struct firedtv *fdtv,
 		  struct dvb_frontend_parameters *params)
 {
 	struct avc_command_frame *c = (void *)fdtv->avc_data;
-	int ret;
+	int pos, ret;
 
 	mutex_lock(&fdtv->avc_mutex);
 
-	memset(c, 0, sizeof(*c));
-
 	c->ctype   = AVC_CTYPE_CONTROL;
 	c->subunit = AVC_SUBUNIT_TYPE_TUNER | fdtv->subunit;
 
 	switch (fdtv->type) {
 	case FIREDTV_DVB_S:
-	case FIREDTV_DVB_S2: avc_tuner_tuneqpsk(fdtv, params); break;
-	case FIREDTV_DVB_C: avc_tuner_dsd_dvb_c(fdtv, params); break;
-	case FIREDTV_DVB_T: avc_tuner_dsd_dvb_t(fdtv, params); break;
+	case FIREDTV_DVB_S2: pos = avc_tuner_tuneqpsk(fdtv, params); break;
+	case FIREDTV_DVB_C: pos = avc_tuner_dsd_dvb_c(fdtv, params); break;
+	case FIREDTV_DVB_T: pos = avc_tuner_dsd_dvb_t(fdtv, params); break;
 	default:
 		BUG();
 	}
+	pad_operands(c, pos);
+
+	fdtv->avc_data_length = ALIGN(3 + pos, 4);
 	ret = avc_write(fdtv);
 #if 0
 	/*
@@ -585,8 +598,6 @@ int avc_tuner_set_pids(struct firedtv *f
 
 	mutex_lock(&fdtv->avc_mutex);
 
-	memset(c, 0, sizeof(*c));
-
 	c->ctype   = AVC_CTYPE_CONTROL;
 	c->subunit = AVC_SUBUNIT_TYPE_TUNER | fdtv->subunit;
 	c->opcode  = AVC_OPCODE_DSD;
@@ -608,6 +619,7 @@ int avc_tuner_set_pids(struct firedtv *f
 			c->operand[pos++] = 0x00; /* tableID */
 			c->operand[pos++] = 0x00; /* filter_length */
 		}
+	pad_operands(c, pos);
 
 	fdtv->avc_data_length = ALIGN(3 + pos, 4);
 	ret = avc_write(fdtv);
@@ -629,8 +641,6 @@ int avc_tuner_get_ts(struct firedtv *fdt
 
 	mutex_lock(&fdtv->avc_mutex);
 
-	memset(c, 0, sizeof(*c));
-
 	c->ctype   = AVC_CTYPE_CONTROL;
 	c->subunit = AVC_SUBUNIT_TYPE_TUNER | fdtv->subunit;
 	c->opcode  = AVC_OPCODE_DSIT;
@@ -644,9 +654,12 @@ int avc_tuner_get_ts(struct firedtv *fdt
 	c->operand[4] = 0x00;	/* antenna number */
 	c->operand[5] = 0x0; 	/* system_specific_search_flags */
 	c->operand[6] = sl;	/* system_specific_multiplex selection_length */
-	c->operand[7] = 0x00;	/* valid_flags [0] */
-	c->operand[8] = 0x00;	/* valid_flags [1] */
-	c->operand[7 + sl] = 0x00; /* nr_of_dsit_sel_specs (always 0) */
+	/*
+	 * operand[7]: valid_flags[0]
+	 * operand[8]: valid_flags[1]
+	 * operand[7 + sl]: nr_of_dsit_sel_specs (always 0)
+	 */
+	clear_operands(c, 7, 24);
 
 	fdtv->avc_data_length = fdtv->type == FIREDTV_DVB_T ? 24 : 28;
 	ret = avc_write(fdtv);
@@ -669,8 +682,6 @@ int avc_identify_subunit(struct firedtv 
 
 	mutex_lock(&fdtv->avc_mutex);
 
-	memset(c, 0, sizeof(*c));
-
 	c->ctype   = AVC_CTYPE_CONTROL;
 	c->subunit = AVC_SUBUNIT_TYPE_TUNER | fdtv->subunit;
 	c->opcode  = AVC_OPCODE_READ_DESCRIPTOR;
@@ -682,6 +693,7 @@ int avc_identify_subunit(struct firedtv 
 	c->operand[4] = 0x08; /* length lowbyte  */
 	c->operand[5] = 0x00; /* offset highbyte */
 	c->operand[6] = 0x0d; /* offset lowbyte  */
+	clear_operands(c, 7, 8); /* padding */
 
 	fdtv->avc_data_length = 12;
 	ret = avc_write(fdtv);
@@ -710,19 +722,18 @@ int avc_tuner_status(struct firedtv *fdt
 
 	mutex_lock(&fdtv->avc_mutex);
 
-	memset(c, 0, sizeof(*c));
-
 	c->ctype   = AVC_CTYPE_CONTROL;
 	c->subunit = AVC_SUBUNIT_TYPE_TUNER | fdtv->subunit;
 	c->opcode  = AVC_OPCODE_READ_DESCRIPTOR;
 
 	c->operand[0] = DESCRIPTOR_TUNER_STATUS;
 	c->operand[1] = 0xff;	/* read_result_status */
-	c->operand[2] = 0x00;	/* reserved */
-	c->operand[3] = 0;	/* SIZEOF_ANTENNA_INPUT_INFO >> 8; */
-	c->operand[4] = 0;	/* SIZEOF_ANTENNA_INPUT_INFO & 0xff; */
-	c->operand[5] = 0x00;
-	c->operand[6] = 0x00;
+	/*
+	 * operand[2]: reserved
+	 * operand[3]: SIZEOF_ANTENNA_INPUT_INFO >> 8
+	 * operand[4]: SIZEOF_ANTENNA_INPUT_INFO & 0xff
+	 */
+	clear_operands(c, 2, 31);
 
 	fdtv->avc_data_length = 12;
 	ret = avc_write(fdtv);
@@ -788,12 +799,10 @@ int avc_lnb_control(struct firedtv *fdtv
 {
 	struct avc_command_frame *c = (void *)fdtv->avc_data;
 	struct avc_response_frame *r = (void *)fdtv->avc_data;
-	int i, j, k, ret;
+	int pos, j, k, ret;
 
 	mutex_lock(&fdtv->avc_mutex);
 
-	memset(c, 0, sizeof(*c));
-
 	c->ctype   = AVC_CTYPE_CONTROL;
 	c->subunit = AVC_SUBUNIT_TYPE_TUNER | fdtv->subunit;
 	c->opcode  = AVC_OPCODE_VENDOR;
@@ -802,23 +811,21 @@ int avc_lnb_control(struct firedtv *fdtv
 	c->operand[1] = SFE_VENDOR_DE_COMPANYID_1;
 	c->operand[2] = SFE_VENDOR_DE_COMPANYID_2;
 	c->operand[3] = SFE_VENDOR_OPCODE_LNB_CONTROL;
-
 	c->operand[4] = voltage;
 	c->operand[5] = nrdiseq;
 
-	i = 6;
-
+	pos = 6;
 	for (j = 0; j < nrdiseq; j++) {
-		c->operand[i++] = diseqcmd[j].msg_len;
+		c->operand[pos++] = diseqcmd[j].msg_len;
 
 		for (k = 0; k < diseqcmd[j].msg_len; k++)
-			c->operand[i++] = diseqcmd[j].msg[k];
+			c->operand[pos++] = diseqcmd[j].msg[k];
 	}
+	c->operand[pos++] = burst;
+	c->operand[pos++] = conttone;
+	pad_operands(c, pos);
 
-	c->operand[i++] = burst;
-	c->operand[i++] = conttone;
-
-	fdtv->avc_data_length = ALIGN(3 + i, 4);
+	fdtv->avc_data_length = ALIGN(3 + pos, 4);
 	ret = avc_write(fdtv);
 	if (ret < 0)
 		goto out;
@@ -840,8 +847,6 @@ int avc_register_remote_control(struct f
 
 	mutex_lock(&fdtv->avc_mutex);
 
-	memset(c, 0, sizeof(*c));
-
 	c->ctype   = AVC_CTYPE_NOTIFY;
 	c->subunit = AVC_SUBUNIT_TYPE_UNIT | 7;
 	c->opcode  = AVC_OPCODE_VENDOR;
@@ -850,6 +855,7 @@ int avc_register_remote_control(struct f
 	c->operand[1] = SFE_VENDOR_DE_COMPANYID_1;
 	c->operand[2] = SFE_VENDOR_DE_COMPANYID_2;
 	c->operand[3] = SFE_VENDOR_OPCODE_REGISTER_REMOTE_CONTROL;
+	c->operand[4] = 0; /* padding */
 
 	fdtv->avc_data_length = 8;
 	ret = avc_write(fdtv);
@@ -878,8 +884,6 @@ int avc_tuner_host2ca(struct firedtv *fd
 
 	mutex_lock(&fdtv->avc_mutex);
 
-	memset(c, 0, sizeof(*c));
-
 	c->ctype   = AVC_CTYPE_CONTROL;
 	c->subunit = AVC_SUBUNIT_TYPE_TUNER | fdtv->subunit;
 	c->opcode  = AVC_OPCODE_VENDOR;
@@ -890,8 +894,7 @@ int avc_tuner_host2ca(struct firedtv *fd
 	c->operand[3] = SFE_VENDOR_OPCODE_HOST2CA;
 	c->operand[4] = 0; /* slot */
 	c->operand[5] = SFE_VENDOR_TAG_CA_APPLICATION_INFO; /* ca tag */
-	c->operand[6] = 0; /* more/last */
-	c->operand[7] = 0; /* length */
+	clear_operands(c, 6, 8);
 
 	fdtv->avc_data_length = 12;
 	ret = avc_write(fdtv);
@@ -937,8 +940,6 @@ int avc_ca_app_info(struct firedtv *fdtv
 
 	mutex_lock(&fdtv->avc_mutex);
 
-	memset(c, 0, sizeof(*c));
-
 	c->ctype   = AVC_CTYPE_STATUS;
 	c->subunit = AVC_SUBUNIT_TYPE_TUNER | fdtv->subunit;
 	c->opcode  = AVC_OPCODE_VENDOR;
@@ -949,6 +950,7 @@ int avc_ca_app_info(struct firedtv *fdtv
 	c->operand[3] = SFE_VENDOR_OPCODE_CA2HOST;
 	c->operand[4] = 0; /* slot */
 	c->operand[5] = SFE_VENDOR_TAG_CA_APPLICATION_INFO; /* ca tag */
+	clear_operands(c, 6, LAST_OPERAND);
 
 	fdtv->avc_data_length = 12;
 	ret = avc_write(fdtv);
@@ -979,8 +981,6 @@ int avc_ca_info(struct firedtv *fdtv, ch
 
 	mutex_lock(&fdtv->avc_mutex);
 
-	memset(c, 0, sizeof(*c));
-
 	c->ctype   = AVC_CTYPE_STATUS;
 	c->subunit = AVC_SUBUNIT_TYPE_TUNER | fdtv->subunit;
 	c->opcode  = AVC_OPCODE_VENDOR;
@@ -991,6 +991,7 @@ int avc_ca_info(struct firedtv *fdtv, ch
 	c->operand[3] = SFE_VENDOR_OPCODE_CA2HOST;
 	c->operand[4] = 0; /* slot */
 	c->operand[5] = SFE_VENDOR_TAG_CA_APPLICATION_INFO; /* ca tag */
+	clear_operands(c, 6, LAST_OPERAND);
 
 	fdtv->avc_data_length = 12;
 	ret = avc_write(fdtv);
@@ -1020,8 +1021,6 @@ int avc_ca_reset(struct firedtv *fdtv)
 
 	mutex_lock(&fdtv->avc_mutex);
 
-	memset(c, 0, sizeof(*c));
-
 	c->ctype   = AVC_CTYPE_CONTROL;
 	c->subunit = AVC_SUBUNIT_TYPE_TUNER | fdtv->subunit;
 	c->opcode  = AVC_OPCODE_VENDOR;
@@ -1064,8 +1063,6 @@ int avc_ca_pmt(struct firedtv *fdtv, cha
 
 	mutex_lock(&fdtv->avc_mutex);
 
-	memset(c, 0, sizeof(*c));
-
 	c->ctype   = AVC_CTYPE_CONTROL;
 	c->subunit = AVC_SUBUNIT_TYPE_TUNER | fdtv->subunit;
 	c->opcode  = AVC_OPCODE_VENDOR;
@@ -1096,7 +1093,7 @@ int avc_ca_pmt(struct firedtv *fdtv, cha
 
 	c->operand[12] = 0x02; /* Table id=2 */
 	c->operand[13] = 0x80; /* Section syntax + length */
-	/* c->operand[14] = XXXprogram_info_length + 12; */
+
 	c->operand[15] = msg[1]; /* Program number */
 	c->operand[16] = msg[2];
 	c->operand[17] = 0x01; /* Version number=0 + current/next=1 */
@@ -1144,12 +1141,7 @@ int avc_ca_pmt(struct firedtv *fdtv, cha
 			write_pos += es_info_length;
 		}
 	}
-
-	/* CRC */
-	c->operand[write_pos++] = 0x00;
-	c->operand[write_pos++] = 0x00;
-	c->operand[write_pos++] = 0x00;
-	c->operand[write_pos++] = 0x00;
+	write_pos += 4; /* CRC */
 
 	c->operand[7] = 0x82;
 	c->operand[8] = (write_pos - 10) >> 8;
@@ -1161,6 +1153,7 @@ int avc_ca_pmt(struct firedtv *fdtv, cha
 	c->operand[write_pos - 3] = (crc32_csum >> 16) & 0xff;
 	c->operand[write_pos - 2] = (crc32_csum >>  8) & 0xff;
 	c->operand[write_pos - 1] = (crc32_csum >>  0) & 0xff;
+	pad_operands(c, write_pos);
 
 	fdtv->avc_data_length = ALIGN(3 + write_pos, 4);
 	ret = avc_write(fdtv);
@@ -1186,8 +1179,6 @@ int avc_ca_get_time_date(struct firedtv 
 
 	mutex_lock(&fdtv->avc_mutex);
 
-	memset(c, 0, sizeof(*c));
-
 	c->ctype   = AVC_CTYPE_STATUS;
 	c->subunit = AVC_SUBUNIT_TYPE_TUNER | fdtv->subunit;
 	c->opcode  = AVC_OPCODE_VENDOR;
@@ -1198,8 +1189,7 @@ int avc_ca_get_time_date(struct firedtv 
 	c->operand[3] = SFE_VENDOR_OPCODE_CA2HOST;
 	c->operand[4] = 0; /* slot */
 	c->operand[5] = SFE_VENDOR_TAG_CA_DATE_TIME; /* ca tag */
-	c->operand[6] = 0; /* more/last */
-	c->operand[7] = 0; /* length */
+	clear_operands(c, 6, LAST_OPERAND);
 
 	fdtv->avc_data_length = 12;
 	ret = avc_write(fdtv);
@@ -1222,8 +1212,6 @@ int avc_ca_enter_menu(struct firedtv *fd
 
 	mutex_lock(&fdtv->avc_mutex);
 
-	memset(c, 0, sizeof(*c));
-
 	c->ctype   = AVC_CTYPE_STATUS;
 	c->subunit = AVC_SUBUNIT_TYPE_TUNER | fdtv->subunit;
 	c->opcode  = AVC_OPCODE_VENDOR;
@@ -1234,8 +1222,7 @@ int avc_ca_enter_menu(struct firedtv *fd
 	c->operand[3] = SFE_VENDOR_OPCODE_HOST2CA;
 	c->operand[4] = 0; /* slot */
 	c->operand[5] = SFE_VENDOR_TAG_CA_ENTER_MENU;
-	c->operand[6] = 0; /* more/last */
-	c->operand[7] = 0; /* length */
+	clear_operands(c, 6, 8);
 
 	fdtv->avc_data_length = 12;
 	ret = avc_write(fdtv);
@@ -1255,8 +1242,6 @@ int avc_ca_get_mmi(struct firedtv *fdtv,
 
 	mutex_lock(&fdtv->avc_mutex);
 
-	memset(c, 0, sizeof(*c));
-
 	c->ctype   = AVC_CTYPE_STATUS;
 	c->subunit = AVC_SUBUNIT_TYPE_TUNER | fdtv->subunit;
 	c->opcode  = AVC_OPCODE_VENDOR;
@@ -1267,8 +1252,7 @@ int avc_ca_get_mmi(struct firedtv *fdtv,
 	c->operand[3] = SFE_VENDOR_OPCODE_CA2HOST;
 	c->operand[4] = 0; /* slot */
 	c->operand[5] = SFE_VENDOR_TAG_CA_MMI;
-	c->operand[6] = 0; /* more/last */
-	c->operand[7] = 0; /* length */
+	clear_operands(c, 6, LAST_OPERAND);
 
 	fdtv->avc_data_length = 12;
 	ret = avc_write(fdtv);

-- 
Stefan Richter
-=====-==--= =-== =--=-
http://arcgraph.de/sr/

