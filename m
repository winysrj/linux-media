Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:37170 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621AbaIXODH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Sep 2014 10:03:07 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Mauro Dreissig <mukadr@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 3/4] [media] as102: fix endiannes casts
Date: Wed, 24 Sep 2014 11:02:28 -0300
Message-Id: <d4674455ade0601f0881fc2c63872375189c85f3.1411567328.git.mchehab@osg.samsung.com>
In-Reply-To: <e64ef973881ac3f5d98ee52f275a0fb9c3d07a56.1411567328.git.mchehab@osg.samsung.com>
References: <e64ef973881ac3f5d98ee52f275a0fb9c3d07a56.1411567328.git.mchehab@osg.samsung.com>
In-Reply-To: <e64ef973881ac3f5d98ee52f275a0fb9c3d07a56.1411567328.git.mchehab@osg.samsung.com>
References: <e64ef973881ac3f5d98ee52f275a0fb9c3d07a56.1411567328.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Smatch complains a lot about endiannes issues on as102:

drivers/media/usb/as102/as10x_cmd_stream.c:41:47: warning: incorrect type in assignment (different base types)
drivers/media/usb/as102/as10x_cmd_stream.c:41:47:    expected unsigned short [unsigned] [usertype] proc_id
drivers/media/usb/as102/as10x_cmd_stream.c:41:47:    got restricted __le16 [usertype] <noident>
drivers/media/usb/as102/as10x_cmd_stream.c:43:43: warning: incorrect type in assignment (different base types)
drivers/media/usb/as102/as10x_cmd_stream.c:43:43:    expected unsigned short [unsigned] [usertype] pid
drivers/media/usb/as102/as10x_cmd_stream.c:43:43:    got restricted __le16 [usertype] <noident>
drivers/media/usb/as102/as10x_cmd_stream.c:98:47: warning: incorrect type in assignment (different base types)
drivers/media/usb/as102/as10x_cmd_stream.c:98:47:    expected unsigned short [unsigned] [usertype] proc_id
drivers/media/usb/as102/as10x_cmd_stream.c:98:47:    got restricted __le16 [usertype] <noident>
drivers/media/usb/as102/as10x_cmd_stream.c:100:43: warning: incorrect type in assignment (different base types)
drivers/media/usb/as102/as10x_cmd_stream.c:100:43:    expected unsigned short [unsigned] [usertype] pid
drivers/media/usb/as102/as10x_cmd_stream.c:100:43:    got restricted __le16 [usertype] <noident>
drivers/media/usb/as102/as10x_cmd_stream.c:142:48: warning: incorrect type in assignment (different base types)
drivers/media/usb/as102/as10x_cmd_stream.c:142:48:    expected unsigned short [unsigned] [usertype] proc_id
drivers/media/usb/as102/as10x_cmd_stream.c:142:48:    got restricted __le16 [usertype] <noident>
drivers/media/usb/as102/as10x_cmd_stream.c:185:47: warning: incorrect type in assignment (different base types)
drivers/media/usb/as102/as10x_cmd_stream.c:185:47:    expected unsigned short [unsigned] [usertype] proc_id
drivers/media/usb/as102/as10x_cmd_stream.c:185:47:    got restricted __le16 [usertype] <noident>
drivers/media/usb/as102/as10x_cmd_cfg.c:46:40: warning: incorrect type in assignment (different base types)
drivers/media/usb/as102/as10x_cmd_cfg.c:46:40:    expected unsigned short [unsigned] [usertype] proc_id
drivers/media/usb/as102/as10x_cmd_cfg.c:46:40:    got restricted __le16 [usertype] <noident>
drivers/media/usb/as102/as10x_cmd_cfg.c:47:36: warning: incorrect type in assignment (different base types)
drivers/media/usb/as102/as10x_cmd_cfg.c:47:36:    expected unsigned short [unsigned] [usertype] tag
drivers/media/usb/as102/as10x_cmd_cfg.c:47:36:    got restricted __le16 [usertype] <noident>
drivers/media/usb/as102/as10x_cmd_cfg.c:48:37: warning: incorrect type in assignment (different base types)
drivers/media/usb/as102/as10x_cmd_cfg.c:48:37:    expected unsigned short [unsigned] [usertype] type
drivers/media/usb/as102/as10x_cmd_cfg.c:48:37:    got restricted __le16 [usertype] <noident>
drivers/media/usb/as102/as10x_cmd_cfg.c:72:27: warning: cast to restricted __le32
drivers/media/usb/as102/as10x_cmd_cfg.c:102:40: warning: incorrect type in assignment (different base types)
drivers/media/usb/as102/as10x_cmd_cfg.c:102:40:    expected unsigned short [unsigned] [usertype] proc_id
drivers/media/usb/as102/as10x_cmd_cfg.c:102:40:    got restricted __le16 [usertype] <noident>
drivers/media/usb/as102/as10x_cmd_cfg.c:104:50: warning: incorrect type in assignment (different base types)
drivers/media/usb/as102/as10x_cmd_cfg.c:104:50:    expected unsigned int [unsigned] [usertype] value32
drivers/media/usb/as102/as10x_cmd_cfg.c:104:50:    got restricted __le32 [usertype] <noident>
drivers/media/usb/as102/as10x_cmd_cfg.c:105:36: warning: incorrect type in assignment (different base types)
drivers/media/usb/as102/as10x_cmd_cfg.c:105:36:    expected unsigned short [unsigned] [usertype] tag
drivers/media/usb/as102/as10x_cmd_cfg.c:105:36:    got restricted __le16 [usertype] <noident>
drivers/media/usb/as102/as10x_cmd_cfg.c:106:37: warning: incorrect type in assignment (different base types)
drivers/media/usb/as102/as10x_cmd_cfg.c:106:37:    expected unsigned short [unsigned] [usertype] type
drivers/media/usb/as102/as10x_cmd_cfg.c:106:37:    got restricted __le16 [usertype] <noident>
drivers/media/usb/as102/as10x_cmd_cfg.c:156:48: warning: incorrect type in assignment (different base types)
drivers/media/usb/as102/as10x_cmd_cfg.c:156:48:    expected unsigned short [unsigned] [usertype] proc_id
drivers/media/usb/as102/as10x_cmd_cfg.c:156:48:    got restricted __le16 [usertype] <noident>
drivers/media/usb/as102/as10x_cmd_cfg.c:197:14: warning: cast to restricted __le16
drivers/media/usb/as102/as10x_cmd.c:40:40: warning: incorrect type in assignment (different base types)
drivers/media/usb/as102/as10x_cmd.c:40:40:    expected unsigned short [unsigned] [usertype] proc_id
drivers/media/usb/as102/as10x_cmd.c:40:40:    got restricted __le16 [usertype] <noident>
drivers/media/usb/as102/as10x_cmd.c:81:41: warning: incorrect type in assignment (different base types)
drivers/media/usb/as102/as10x_cmd.c:81:41:    expected unsigned short [unsigned] [usertype] proc_id
drivers/media/usb/as102/as10x_cmd.c:81:41:    got restricted __le16 [usertype] <noident>
drivers/media/usb/as102/as10x_cmd.c:123:41: warning: incorrect type in assignment (different base types)
drivers/media/usb/as102/as10x_cmd.c:123:41:    expected unsigned short [unsigned] [usertype] proc_id
drivers/media/usb/as102/as10x_cmd.c:123:41:    got restricted __le16 [usertype] <noident>
drivers/media/usb/as102/as10x_cmd.c:124:43: warning: incorrect type in assignment (different base types)
drivers/media/usb/as102/as10x_cmd.c:124:43:    expected unsigned int [unsigned] [usertype] freq
drivers/media/usb/as102/as10x_cmd.c:124:43:    got restricted __le32 [usertype] <noident>
drivers/media/usb/as102/as10x_cmd.c:178:48: warning: incorrect type in assignment (different base types)
drivers/media/usb/as102/as10x_cmd.c:178:48:    expected unsigned short [unsigned] [usertype] proc_id
drivers/media/usb/as102/as10x_cmd.c:178:48:    got restricted __le16 [usertype] <noident>
drivers/media/usb/as102/as10x_cmd.c:202:17: warning: cast to restricted __le16
drivers/media/usb/as102/as10x_cmd.c:203:24: warning: cast to restricted __le16
drivers/media/usb/as102/as10x_cmd.c:204:24: warning: cast to restricted __le16
drivers/media/usb/as102/as10x_cmd.c:230:48: warning: incorrect type in assignment (different base types)
drivers/media/usb/as102/as10x_cmd.c:230:48:    expected unsigned short [unsigned] [usertype] proc_id
drivers/media/usb/as102/as10x_cmd.c:230:48:    got restricted __le16 [usertype] <noident>
drivers/media/usb/as102/as10x_cmd.c:262:25: warning: cast to restricted __le16
drivers/media/usb/as102/as10x_cmd.c:289:48: warning: incorrect type in assignment (different base types)
drivers/media/usb/as102/as10x_cmd.c:289:48:    expected unsigned short [unsigned] [usertype] proc_id
drivers/media/usb/as102/as10x_cmd.c:289:48:    got restricted __le16 [usertype] <noident>
drivers/media/usb/as102/as10x_cmd.c:313:17: warning: cast to restricted __le32
drivers/media/usb/as102/as10x_cmd.c:315:17: warning: cast to restricted __le32
drivers/media/usb/as102/as10x_cmd.c:317:17: warning: cast to restricted __le32
drivers/media/usb/as102/as10x_cmd.c:319:17: warning: cast to restricted __le16
drivers/media/usb/as102/as10x_cmd.c:349:48: warning: incorrect type in assignment (different base types)
drivers/media/usb/as102/as10x_cmd.c:349:48:    expected unsigned short [unsigned] [usertype] proc_id
drivers/media/usb/as102/as10x_cmd.c:349:48:    got restricted __le16 [usertype] <noident>
drivers/media/usb/as102/as10x_cmd.c:387:29: warning: incorrect type in assignment (different base types)
drivers/media/usb/as102/as10x_cmd.c:387:29:    expected unsigned short [unsigned] [usertype] req_id
drivers/media/usb/as102/as10x_cmd.c:387:29:    got restricted __le16 [usertype] <noident>
drivers/media/usb/as102/as10x_cmd.c:388:27: warning: incorrect type in assignment (different base types)
drivers/media/usb/as102/as10x_cmd.c:388:27:    expected unsigned short [unsigned] [usertype] prog
drivers/media/usb/as102/as10x_cmd.c:388:27:    got restricted __le16 [usertype] <noident>
drivers/media/usb/as102/as10x_cmd.c:389:30: warning: incorrect type in assignment (different base types)
drivers/media/usb/as102/as10x_cmd.c:389:30:    expected unsigned short [unsigned] [usertype] version
drivers/media/usb/as102/as10x_cmd.c:389:30:    got restricted __le16 [usertype] <noident>
drivers/media/usb/as102/as10x_cmd.c:390:31: warning: incorrect type in assignment (different base types)
drivers/media/usb/as102/as10x_cmd.c:390:31:    expected unsigned short [unsigned] [usertype] data_len
drivers/media/usb/as102/as10x_cmd.c:390:31:    got restricted __le16 [usertype] <noident>
drivers/media/usb/as102/as10x_cmd.c:408:14: warning: cast to restricted __le16

This happens because of the command endiannes that are sent/received to
the firmware. So, add the correct endiannes tags to the command fields.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/usb/as102/as10x_cmd.c b/drivers/media/usb/as102/as10x_cmd.c
index ef238022dfe5..870617994410 100644
--- a/drivers/media/usb/as102/as10x_cmd.c
+++ b/drivers/media/usb/as102/as10x_cmd.c
@@ -121,7 +121,7 @@ int as10x_cmd_set_tune(struct as10x_bus_adapter_t *adap,
 
 	/* fill command */
 	preq->body.set_tune.req.proc_id = cpu_to_le16(CONTROL_PROC_SETTUNE);
-	preq->body.set_tune.req.args.freq = cpu_to_le32(ptune->freq);
+	preq->body.set_tune.req.args.freq = (__force __u32)cpu_to_le32(ptune->freq);
 	preq->body.set_tune.req.args.bandwidth = ptune->bandwidth;
 	preq->body.set_tune.req.args.hier_select = ptune->hier_select;
 	preq->body.set_tune.req.args.modulation = ptune->modulation;
@@ -199,9 +199,9 @@ int as10x_cmd_get_tune_status(struct as10x_bus_adapter_t *adap,
 	/* Response OK -> get response data */
 	pstatus->tune_state = prsp->body.get_tune_status.rsp.sts.tune_state;
 	pstatus->signal_strength  =
-		le16_to_cpu(prsp->body.get_tune_status.rsp.sts.signal_strength);
-	pstatus->PER = le16_to_cpu(prsp->body.get_tune_status.rsp.sts.PER);
-	pstatus->BER = le16_to_cpu(prsp->body.get_tune_status.rsp.sts.BER);
+		le16_to_cpu((__force __le16)prsp->body.get_tune_status.rsp.sts.signal_strength);
+	pstatus->PER = le16_to_cpu((__force __le16)prsp->body.get_tune_status.rsp.sts.PER);
+	pstatus->BER = le16_to_cpu((__force __le16)prsp->body.get_tune_status.rsp.sts.BER);
 
 out:
 	return error;
@@ -259,7 +259,7 @@ int as10x_cmd_get_tps(struct as10x_bus_adapter_t *adap, struct as10x_tps *ptps)
 	ptps->transmission_mode  = prsp->body.get_tps.rsp.tps.transmission_mode;
 	ptps->DVBH_mask_HP = prsp->body.get_tps.rsp.tps.DVBH_mask_HP;
 	ptps->DVBH_mask_LP = prsp->body.get_tps.rsp.tps.DVBH_mask_LP;
-	ptps->cell_ID = le16_to_cpu(prsp->body.get_tps.rsp.tps.cell_ID);
+	ptps->cell_ID = le16_to_cpu((__force __le16)prsp->body.get_tps.rsp.tps.cell_ID);
 
 out:
 	return error;
@@ -310,13 +310,13 @@ int as10x_cmd_get_demod_stats(struct as10x_bus_adapter_t *adap,
 
 	/* Response OK -> get response data */
 	pdemod_stats->frame_count =
-		le32_to_cpu(prsp->body.get_demod_stats.rsp.stats.frame_count);
+		le32_to_cpu((__force __le32)prsp->body.get_demod_stats.rsp.stats.frame_count);
 	pdemod_stats->bad_frame_count =
-		le32_to_cpu(prsp->body.get_demod_stats.rsp.stats.bad_frame_count);
+		le32_to_cpu((__force __le32)prsp->body.get_demod_stats.rsp.stats.bad_frame_count);
 	pdemod_stats->bytes_fixed_by_rs =
-		le32_to_cpu(prsp->body.get_demod_stats.rsp.stats.bytes_fixed_by_rs);
+		le32_to_cpu((__force __le32)prsp->body.get_demod_stats.rsp.stats.bytes_fixed_by_rs);
 	pdemod_stats->mer =
-		le16_to_cpu(prsp->body.get_demod_stats.rsp.stats.mer);
+		le16_to_cpu((__force __le16)prsp->body.get_demod_stats.rsp.stats.mer);
 	pdemod_stats->has_started =
 		prsp->body.get_demod_stats.rsp.stats.has_started;
 
diff --git a/drivers/media/usb/as102/as10x_cmd.h b/drivers/media/usb/as102/as10x_cmd.h
index 09134f73ba3d..e06b84e2ff79 100644
--- a/drivers/media/usb/as102/as10x_cmd.h
+++ b/drivers/media/usb/as102/as10x_cmd.h
@@ -92,12 +92,12 @@ union as10x_turn_on {
 	/* request */
 	struct {
 		/* request identifier */
-		uint16_t proc_id;
+		__le16 proc_id;
 	} __packed req;
 	/* response */
 	struct {
 		/* response identifier */
-		uint16_t proc_id;
+		__le16 proc_id;
 		/* error */
 		uint8_t error;
 	} __packed rsp;
@@ -107,12 +107,12 @@ union as10x_turn_off {
 	/* request */
 	struct {
 		/* request identifier */
-		uint16_t proc_id;
+		__le16 proc_id;
 	} __packed req;
 	/* response */
 	struct {
 		/* response identifier */
-		uint16_t proc_id;
+		__le16 proc_id;
 		/* error */
 		uint8_t err;
 	} __packed rsp;
@@ -122,14 +122,14 @@ union as10x_set_tune {
 	/* request */
 	struct {
 		/* request identifier */
-		uint16_t proc_id;
+		__le16 proc_id;
 		/* tune params */
 		struct as10x_tune_args args;
 	} __packed req;
 	/* response */
 	struct {
 		/* response identifier */
-		uint16_t proc_id;
+		__le16 proc_id;
 		/* response error */
 		uint8_t error;
 	} __packed rsp;
@@ -139,12 +139,12 @@ union as10x_get_tune_status {
 	/* request */
 	struct {
 		/* request identifier */
-		uint16_t proc_id;
+		__le16 proc_id;
 	} __packed req;
 	/* response */
 	struct {
 		/* response identifier */
-		uint16_t proc_id;
+		__le16 proc_id;
 		/* response error */
 		uint8_t error;
 		/* tune status */
@@ -156,12 +156,12 @@ union as10x_get_tps {
 	/* request */
 	struct {
 		/* request identifier */
-		uint16_t proc_id;
+		__le16 proc_id;
 	} __packed req;
 	/* response */
 	struct {
 		/* response identifier */
-		uint16_t proc_id;
+		__le16 proc_id;
 		/* response error */
 		uint8_t error;
 		/* tps details */
@@ -173,12 +173,12 @@ union as10x_common {
 	/* request */
 	struct {
 		/* request identifier */
-		uint16_t  proc_id;
+		__le16  proc_id;
 	} __packed req;
 	/* response */
 	struct {
 		/* response identifier */
-		uint16_t proc_id;
+		__le16 proc_id;
 		/* response error */
 		uint8_t error;
 	} __packed rsp;
@@ -188,9 +188,9 @@ union as10x_add_pid_filter {
 	/* request */
 	struct {
 		/* request identifier */
-		uint16_t  proc_id;
+		__le16  proc_id;
 		/* PID to filter */
-		uint16_t  pid;
+		__le16  pid;
 		/* stream type (MPE, PSI/SI or PES )*/
 		uint8_t stream_type;
 		/* PID index in filter table */
@@ -199,7 +199,7 @@ union as10x_add_pid_filter {
 	/* response */
 	struct {
 		/* response identifier */
-		uint16_t proc_id;
+		__le16 proc_id;
 		/* response error */
 		uint8_t error;
 		/* Filter id */
@@ -211,14 +211,14 @@ union as10x_del_pid_filter {
 	/* request */
 	struct {
 		/* request identifier */
-		uint16_t  proc_id;
+		__le16  proc_id;
 		/* PID to remove */
-		uint16_t  pid;
+		__le16  pid;
 	} __packed req;
 	/* response */
 	struct {
 		/* response identifier */
-		uint16_t proc_id;
+		__le16 proc_id;
 		/* response error */
 		uint8_t error;
 	} __packed rsp;
@@ -228,12 +228,12 @@ union as10x_start_streaming {
 	/* request */
 	struct {
 		/* request identifier */
-		uint16_t proc_id;
+		__le16 proc_id;
 	} __packed req;
 	/* response */
 	struct {
 		/* response identifier */
-		uint16_t proc_id;
+		__le16 proc_id;
 		/* error */
 		uint8_t error;
 	} __packed rsp;
@@ -243,12 +243,12 @@ union as10x_stop_streaming {
 	/* request */
 	struct {
 		/* request identifier */
-		uint16_t proc_id;
+		__le16 proc_id;
 	} __packed req;
 	/* response */
 	struct {
 		/* response identifier */
-		uint16_t proc_id;
+		__le16 proc_id;
 		/* error */
 		uint8_t error;
 	} __packed rsp;
@@ -258,12 +258,12 @@ union as10x_get_demod_stats {
 	/* request */
 	struct {
 		/* request identifier */
-		uint16_t proc_id;
+		__le16 proc_id;
 	} __packed req;
 	/* response */
 	struct {
 		/* response identifier */
-		uint16_t proc_id;
+		__le16 proc_id;
 		/* error */
 		uint8_t error;
 		/* demod stats */
@@ -275,12 +275,12 @@ union as10x_get_impulse_resp {
 	/* request */
 	struct {
 		/* request identifier */
-		uint16_t proc_id;
+		__le16 proc_id;
 	} __packed req;
 	/* response */
 	struct {
 		/* response identifier */
-		uint16_t proc_id;
+		__le16 proc_id;
 		/* error */
 		uint8_t error;
 		/* impulse response ready */
@@ -292,22 +292,22 @@ union as10x_fw_context {
 	/* request */
 	struct {
 		/* request identifier */
-		uint16_t proc_id;
+		__le16 proc_id;
 		/* value to write (for set context)*/
 		struct as10x_register_value reg_val;
 		/* context tag */
-		uint16_t tag;
+		__le16 tag;
 		/* context request type */
-		uint16_t type;
+		__le16 type;
 	} __packed req;
 	/* response */
 	struct {
 		/* response identifier */
-		uint16_t proc_id;
+		__le16 proc_id;
 		/* value read (for get context) */
 		struct as10x_register_value reg_val;
 		/* context request type */
-		uint16_t type;
+		__le16 type;
 		/* error */
 		uint8_t error;
 	} __packed rsp;
@@ -317,7 +317,7 @@ union as10x_set_register {
 	/* request */
 	struct {
 		/* response identifier */
-		uint16_t proc_id;
+		__le16 proc_id;
 		/* register description */
 		struct as10x_register_addr reg_addr;
 		/* register content */
@@ -326,7 +326,7 @@ union as10x_set_register {
 	/* response */
 	struct {
 		/* response identifier */
-		uint16_t proc_id;
+		__le16 proc_id;
 		/* error */
 		uint8_t error;
 	} __packed rsp;
@@ -336,14 +336,14 @@ union as10x_get_register {
 	/* request */
 	struct {
 		/* response identifier */
-		uint16_t proc_id;
+		__le16 proc_id;
 		/* register description */
 		struct as10x_register_addr reg_addr;
 	} __packed req;
 	/* response */
 	struct {
 		/* response identifier */
-		uint16_t proc_id;
+		__le16 proc_id;
 		/* error */
 		uint8_t error;
 		/* register content */
@@ -355,24 +355,24 @@ union as10x_cfg_change_mode {
 	/* request */
 	struct {
 		/* request identifier */
-		uint16_t proc_id;
+		__le16 proc_id;
 		/* mode */
 		uint8_t mode;
 	} __packed req;
 	/* response */
 	struct {
 		/* response identifier */
-		uint16_t proc_id;
+		__le16 proc_id;
 		/* error */
 		uint8_t error;
 	} __packed rsp;
 } __packed;
 
 struct as10x_cmd_header_t {
-	uint16_t req_id;
-	uint16_t prog;
-	uint16_t version;
-	uint16_t data_len;
+	__le16 req_id;
+	__le16 prog;
+	__le16 version;
+	__le16 data_len;
 } __packed;
 
 #define DUMP_BLOCK_SIZE 16
@@ -381,18 +381,18 @@ union as10x_dump_memory {
 	/* request */
 	struct {
 		/* request identifier */
-		uint16_t proc_id;
+		__le16 proc_id;
 		/* dump memory type request */
 		uint8_t dump_req;
 		/* register description */
 		struct as10x_register_addr reg_addr;
 		/* nb blocks to read */
-		uint16_t num_blocks;
+		__le16 num_blocks;
 	} __packed req;
 	/* response */
 	struct {
 		/* response identifier */
-		uint16_t proc_id;
+		__le16 proc_id;
 		/* error */
 		uint8_t error;
 		/* dump response */
@@ -400,8 +400,8 @@ union as10x_dump_memory {
 		/* data */
 		union {
 			uint8_t  data8[DUMP_BLOCK_SIZE];
-			uint16_t data16[DUMP_BLOCK_SIZE / sizeof(uint16_t)];
-			uint32_t data32[DUMP_BLOCK_SIZE / sizeof(uint32_t)];
+			__le16 data16[DUMP_BLOCK_SIZE / sizeof(__le16)];
+			__le32 data32[DUMP_BLOCK_SIZE / sizeof(__le32)];
 		} __packed u;
 	} __packed rsp;
 } __packed;
@@ -409,13 +409,13 @@ union as10x_dump_memory {
 union as10x_dumplog_memory {
 	struct {
 		/* request identifier */
-		uint16_t proc_id;
+		__le16 proc_id;
 		/* dump memory type request */
 		uint8_t dump_req;
 	} __packed req;
 	struct {
 		/* request identifier */
-		uint16_t proc_id;
+		__le16 proc_id;
 		/* error */
 		uint8_t error;
 		/* dump response */
@@ -428,13 +428,13 @@ union as10x_dumplog_memory {
 union as10x_raw_data {
 	/* request */
 	struct {
-		uint16_t proc_id;
+		__le16 proc_id;
 		uint8_t data[64 - sizeof(struct as10x_cmd_header_t)
 			     - 2 /* proc_id */];
 	} __packed req;
 	/* response */
 	struct {
-		uint16_t proc_id;
+		__le16 proc_id;
 		uint8_t error;
 		uint8_t data[64 - sizeof(struct as10x_cmd_header_t)
 			     - 2 /* proc_id */ - 1 /* rc */];
diff --git a/drivers/media/usb/as102/as10x_cmd_cfg.c b/drivers/media/usb/as102/as10x_cmd_cfg.c
index 6f9dea1d860b..c87f2ca223a2 100644
--- a/drivers/media/usb/as102/as10x_cmd_cfg.c
+++ b/drivers/media/usb/as102/as10x_cmd_cfg.c
@@ -69,7 +69,7 @@ int as10x_cmd_get_context(struct as10x_bus_adapter_t *adap, uint16_t tag,
 
 	if (error == 0) {
 		/* Response OK -> get response data */
-		*pvalue = le32_to_cpu(prsp->body.context.rsp.reg_val.u.value32);
+		*pvalue = le32_to_cpu((__force __le32)prsp->body.context.rsp.reg_val.u.value32);
 		/* value returned is always a 32-bit value */
 	}
 
@@ -101,7 +101,7 @@ int as10x_cmd_set_context(struct as10x_bus_adapter_t *adap, uint16_t tag,
 	/* fill command */
 	pcmd->body.context.req.proc_id = cpu_to_le16(CONTROL_PROC_CONTEXT);
 	/* pcmd->body.context.req.reg_val.mode initialization is not required */
-	pcmd->body.context.req.reg_val.u.value32 = cpu_to_le32(value);
+	pcmd->body.context.req.reg_val.u.value32 = (__force u32)cpu_to_le32(value);
 	pcmd->body.context.req.tag = cpu_to_le16(tag);
 	pcmd->body.context.req.type = cpu_to_le16(SET_CONTEXT_DATA);
 
-- 
1.9.3

