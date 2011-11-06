Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44704 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544Ab1KFUcW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Nov 2011 15:32:22 -0500
Received: by mail-fx0-f46.google.com with SMTP id o14so4498582faa.19
        for <linux-media@vger.kernel.org>; Sun, 06 Nov 2011 12:32:21 -0800 (PST)
From: Sylwester Nawrocki <snjw23@gmail.com>
To: linux-media@vger.kernel.org
Cc: Piotr Chmura <chmooreck@poczta.onet.pl>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Sylwester Nawrocki <snjw23@gmail.com>
Subject: [PATCH 05/13] staging: as102: Replace pragma(pack) with attribute __packed
Date: Sun,  6 Nov 2011 21:31:42 +0100
Message-Id: <1320611510-3326-6-git-send-email-snjw23@gmail.com>
In-Reply-To: <1320611510-3326-1-git-send-email-snjw23@gmail.com>
References: <1320611510-3326-1-git-send-email-snjw23@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Signed-off-by: Sylwester Nawrocki <snjw23@gmail.com>
Signed-off-by: Piotr Chmura <chmooreck@poczta.onet.pl>
---
 drivers/staging/media/as102/as102_fw.h    |    6 +--
 drivers/staging/media/as102/as10x_cmd.h   |   47 +++++++++++++---------------
 drivers/staging/media/as102/as10x_types.h |   15 ++++-----
 3 files changed, 30 insertions(+), 38 deletions(-)

diff --git a/drivers/staging/media/as102/as102_fw.h b/drivers/staging/media/as102/as102_fw.h
index 951a1fa..a1fdb92 100644
--- a/drivers/staging/media/as102/as102_fw.h
+++ b/drivers/staging/media/as102/as102_fw.h
@@ -20,11 +20,10 @@
 
 extern int dual_tuner;
 
-#pragma pack(1)
 struct as10x_raw_fw_pkt {
 	unsigned char address[4];
 	unsigned char data[MAX_FW_PKT_SIZE - 6];
-};
+} __packed;
 
 struct as10x_fw_pkt_t {
 	union {
@@ -32,8 +31,7 @@ struct as10x_fw_pkt_t {
 		unsigned char length[2];
 	} u;
 	struct as10x_raw_fw_pkt raw;
-};
-#pragma pack()
+} __packed;
 
 #ifdef __KERNEL__
 int as102_fw_upload(struct as102_bus_adapter_t *bus_adap);
diff --git a/drivers/staging/media/as102/as10x_cmd.h b/drivers/staging/media/as102/as10x_cmd.h
index 8f13bea..05f7150 100644
--- a/drivers/staging/media/as102/as10x_cmd.h
+++ b/drivers/staging/media/as102/as10x_cmd.h
@@ -94,8 +94,6 @@ enum control_proc {
    CONTROL_PROC_TURNOFF_RSP          = 0xFF00
 };
 
-
-#pragma pack(1)
 union as10x_turn_on {
    /* request */
    struct {
@@ -109,7 +107,7 @@ union as10x_turn_on {
       /* error */
       uint8_t error;
    } rsp;
-};
+} __packed;
 
 union as10x_turn_off {
    /* request */
@@ -124,7 +122,7 @@ union as10x_turn_off {
       /* error */
       uint8_t err;
    } rsp;
-};
+} __packed;
 
 union as10x_set_tune {
    /* request */
@@ -141,7 +139,7 @@ union as10x_set_tune {
       /* response error */
       uint8_t error;
    } rsp;
-};
+} __packed;
 
 union as10x_get_tune_status {
    /* request */
@@ -158,7 +156,7 @@ union as10x_get_tune_status {
       /* tune status */
       struct as10x_tune_status sts;
    } rsp;
-};
+} __packed;
 
 union as10x_get_tps {
    /* request */
@@ -175,7 +173,7 @@ union as10x_get_tps {
       /* tps details */
       struct as10x_tps tps;
    } rsp;
-};
+} __packed;
 
 union as10x_common {
    /* request */
@@ -190,7 +188,7 @@ union as10x_common {
       /* response error */
       uint8_t error;
    } rsp;
-};
+} __packed;
 
 union as10x_add_pid_filter {
    /* request */
@@ -213,7 +211,7 @@ union as10x_add_pid_filter {
       /* Filter id */
       uint8_t filter_id;
    } rsp;
-};
+} __packed;
 
 union as10x_del_pid_filter {
    /* request */
@@ -230,7 +228,7 @@ union as10x_del_pid_filter {
       /* response error */
       uint8_t error;
    } rsp;
-};
+} __packed;
 
 union as10x_start_streaming {
    /* request */
@@ -245,7 +243,7 @@ union as10x_start_streaming {
       /* error */
       uint8_t error;
    } rsp;
-};
+} __packed;
 
 union as10x_stop_streaming {
    /* request */
@@ -260,7 +258,7 @@ union as10x_stop_streaming {
       /* error */
       uint8_t error;
    } rsp;
-};
+} __packed;
 
 union as10x_get_demod_stats {
    /* request */
@@ -277,7 +275,7 @@ union as10x_get_demod_stats {
       /* demod stats */
       struct as10x_demod_stats stats;
    } rsp;
-};
+} __packed;
 
 union as10x_get_impulse_resp {
    /* request */
@@ -294,7 +292,7 @@ union as10x_get_impulse_resp {
       /* impulse response ready */
       uint8_t is_ready;
    } rsp;
-};
+} __packed;
 
 union as10x_fw_context {
    /* request */
@@ -319,7 +317,7 @@ union as10x_fw_context {
       /* error */
       uint8_t error;
    } rsp;
-};
+} __packed;
 
 union as10x_set_register {
    /* request */
@@ -338,7 +336,7 @@ union as10x_set_register {
       /* error */
       uint8_t error;
    } rsp;
-};
+} __packed;
 
 union as10x_get_register {
    /* request */
@@ -357,7 +355,7 @@ union as10x_get_register {
       /* register content */
       struct as10x_register_value reg_val;
    } rsp;
-};
+} __packed;
 
 union as10x_cfg_change_mode {
    /* request */
@@ -374,14 +372,14 @@ union as10x_cfg_change_mode {
       /* error */
       uint8_t error;
    } rsp;
-};
+} __packed;
 
 struct as10x_cmd_header_t {
    uint16_t req_id;
    uint16_t prog;
    uint16_t version;
    uint16_t data_len;
-};
+} __packed;
 
 #define DUMP_BLOCK_SIZE 16
 
@@ -412,7 +410,7 @@ union as10x_dump_memory {
 	 uint32_t data32[DUMP_BLOCK_SIZE / sizeof(uint32_t)];
       } u;
    } rsp;
-};
+} __packed;
 
 union as10x_dumplog_memory {
    struct {
@@ -431,7 +429,7 @@ union as10x_dumplog_memory {
       /* dump data */
       uint8_t data[DUMP_BLOCK_SIZE];
    } rsp;
-};
+} __packed;
 
 union as10x_raw_data {
    /* request */
@@ -446,7 +444,7 @@ union as10x_raw_data {
       uint8_t data[64 - sizeof(struct as10x_cmd_header_t) /* header */
 		      - 2 /* proc_id */ - 1 /* rc */];
    } rsp;
-};
+} __packed;
 
 struct as10x_cmd_t {
 	struct as10x_cmd_header_t header;
@@ -471,15 +469,14 @@ struct as10x_cmd_t {
 		union as10x_dumplog_memory	dumplog_memory;
 		union as10x_raw_data		raw_data;
 	} body;
-};
+} __packed;
 
 struct as10x_token_cmd_t {
    /* token cmd */
    struct as10x_cmd_t c;
    /* token response */
    struct as10x_cmd_t r;
-};
-#pragma pack()
+} __packed;
 
 
 /**************************/
diff --git a/drivers/staging/media/as102/as10x_types.h b/drivers/staging/media/as102/as10x_types.h
index 3dedb3c..0b27f3a 100644
--- a/drivers/staging/media/as102/as10x_types.h
+++ b/drivers/staging/media/as102/as10x_types.h
@@ -111,7 +111,6 @@
 #define CFG_MODE_OFF    1
 #define CFG_MODE_AUTO   2
 
-#pragma pack(1)
 struct as10x_tps {
    uint8_t constellation;
    uint8_t hierarchy;
@@ -123,7 +122,7 @@ struct as10x_tps {
    uint8_t DVBH_mask_HP;
    uint8_t DVBH_mask_LP;
    uint16_t cell_ID;
-};
+} __packed;
 
 struct as10x_tune_args {
    /* frequency */
@@ -144,7 +143,7 @@ struct as10x_tune_args {
    uint8_t guard_interval;
    /* transmission mode */
    uint8_t transmission_mode;
-};
+} __packed;
 
 struct as10x_tune_status {
    /* tune status */
@@ -155,7 +154,7 @@ struct as10x_tune_status {
    uint16_t PER;
    /* bit error rate 10^-4 */
    uint16_t BER;
-};
+} __packed;
 
 struct as10x_demod_stats {
    /* frame counter */
@@ -168,13 +167,13 @@ struct as10x_demod_stats {
    uint16_t mer;
    /* statistics calculation state indicator (started or not) */
    uint8_t has_started;
-};
+} __packed;
 
 struct as10x_ts_filter {
    uint16_t pid;  /** valid PID value 0x00 : 0x2000 */
    uint8_t  type; /** Red TS_PID_TYPE_<N> values */
    uint8_t  idx;  /** index in filtering table */
-};
+} __packed;
 
 struct as10x_register_value {
    uint8_t       mode;
@@ -183,9 +182,7 @@ struct as10x_register_value {
       uint16_t   value16;   /* 16 bit value */
       uint32_t   value32;   /* 32 bit value */
    }u;
-};
-
-#pragma pack()
+} __packed;
 
 struct as10x_register_addr {
    /* register addr */
-- 
1.7.5.4

