Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40138 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002Ab1KFUcR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Nov 2011 15:32:17 -0500
Received: by mail-fx0-f46.google.com with SMTP id o14so4498572faa.19
        for <linux-media@vger.kernel.org>; Sun, 06 Nov 2011 12:32:16 -0800 (PST)
From: Sylwester Nawrocki <snjw23@gmail.com>
To: linux-media@vger.kernel.org
Cc: Piotr Chmura <chmooreck@poczta.onet.pl>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Sylwester Nawrocki <snjw23@gmail.com>
Subject: [PATCH 02/13] staging: as102: Remove unnecessary typedefs
Date: Sun,  6 Nov 2011 21:31:39 +0100
Message-Id: <1320611510-3326-3-git-send-email-snjw23@gmail.com>
In-Reply-To: <1320611510-3326-1-git-send-email-snjw23@gmail.com>
References: <1320611510-3326-1-git-send-email-snjw23@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

According to the kernel coding rules typedefs should be avoided,
so replace theit occurances with explicit enum/union types.

Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Signed-off-by: Sylwester Nawrocki <snjw23@gmail.com>
---
 drivers/staging/media/as102/as10x_cmd.h |  127 +++++++++++++++----------------
 1 files changed, 63 insertions(+), 64 deletions(-)

diff --git a/drivers/staging/media/as102/as10x_cmd.h b/drivers/staging/media/as102/as10x_cmd.h
index 6f837b1..8f13bea 100644
--- a/drivers/staging/media/as102/as10x_cmd.h
+++ b/drivers/staging/media/as102/as10x_cmd.h
@@ -52,7 +52,7 @@
 /*********************************/
 /*     TYPE DEFINITION           */
 /*********************************/
-typedef enum {
+enum control_proc {
    CONTROL_PROC_TURNON               = 0x0001,
    CONTROL_PROC_TURNON_RSP           = 0x0100,
    CONTROL_PROC_SET_REGISTER         = 0x0002,
@@ -92,11 +92,11 @@ typedef enum {
    CONTROL_PROC_DUMPLOG_MEMORY_RSP   = 0xFE00,
    CONTROL_PROC_TURNOFF              = 0x00FF,
    CONTROL_PROC_TURNOFF_RSP          = 0xFF00
-} control_proc;
+};
 
 
 #pragma pack(1)
-typedef union {
+union as10x_turn_on {
    /* request */
    struct {
       /* request identifier */
@@ -109,9 +109,9 @@ typedef union {
       /* error */
       uint8_t error;
    } rsp;
-} TURN_ON;
+};
 
-typedef union {
+union as10x_turn_off {
    /* request */
    struct {
       /* request identifier */
@@ -124,9 +124,9 @@ typedef union {
       /* error */
       uint8_t err;
    } rsp;
-} TURN_OFF;
+};
 
-typedef union {
+union as10x_set_tune {
    /* request */
    struct {
       /* request identifier */
@@ -141,9 +141,9 @@ typedef union {
       /* response error */
       uint8_t error;
    } rsp;
-} SET_TUNE;
+};
 
-typedef union {
+union as10x_get_tune_status {
    /* request */
    struct {
       /* request identifier */
@@ -158,9 +158,9 @@ typedef union {
       /* tune status */
       struct as10x_tune_status sts;
    } rsp;
-} GET_TUNE_STATUS;
+};
 
-typedef union {
+union as10x_get_tps {
    /* request */
    struct {
       /* request identifier */
@@ -175,9 +175,9 @@ typedef union {
       /* tps details */
       struct as10x_tps tps;
    } rsp;
-} GET_TPS;
+};
 
-typedef union {
+union as10x_common {
    /* request */
    struct {
       /* request identifier */
@@ -190,9 +190,9 @@ typedef union {
       /* response error */
       uint8_t error;
    } rsp;
-} COMMON;
+};
 
-typedef union {
+union as10x_add_pid_filter {
    /* request */
    struct {
       /* request identifier */
@@ -213,9 +213,9 @@ typedef union {
       /* Filter id */
       uint8_t filter_id;
    } rsp;
-} ADD_PID_FILTER;
+};
 
-typedef union {
+union as10x_del_pid_filter {
    /* request */
    struct {
       /* request identifier */
@@ -230,9 +230,9 @@ typedef union {
       /* response error */
       uint8_t error;
    } rsp;
-} DEL_PID_FILTER;
+};
 
-typedef union {
+union as10x_start_streaming {
    /* request */
    struct {
       /* request identifier */
@@ -245,9 +245,9 @@ typedef union {
       /* error */
       uint8_t error;
    } rsp;
-} START_STREAMING;
+};
 
-typedef union {
+union as10x_stop_streaming {
    /* request */
    struct {
       /* request identifier */
@@ -260,9 +260,9 @@ typedef union {
       /* error */
       uint8_t error;
    } rsp;
-} STOP_STREAMING;
+};
 
-typedef union {
+union as10x_get_demod_stats {
    /* request */
    struct {
       /* request identifier */
@@ -277,9 +277,9 @@ typedef union {
       /* demod stats */
       struct as10x_demod_stats stats;
    } rsp;
-} GET_DEMOD_STATS;
+};
 
-typedef union {
+union as10x_get_impulse_resp {
    /* request */
    struct {
       /* request identifier */
@@ -294,9 +294,9 @@ typedef union {
       /* impulse response ready */
       uint8_t is_ready;
    } rsp;
-} GET_IMPULSE_RESP;
+};
 
-typedef union {
+union as10x_fw_context {
    /* request */
    struct {
       /* request identifier */
@@ -319,9 +319,9 @@ typedef union {
       /* error */
       uint8_t error;
    } rsp;
-} FW_CONTEXT;
+};
 
-typedef union {
+union as10x_set_register {
    /* request */
    struct {
       /* response identifier */
@@ -338,9 +338,9 @@ typedef union {
       /* error */
       uint8_t error;
    } rsp;
-} SET_REGISTER;
+};
 
-typedef union {
+union as10x_get_register {
    /* request */
    struct {
       /* response identifier */
@@ -357,9 +357,9 @@ typedef union {
       /* register content */
       struct as10x_register_value reg_val;
    } rsp;
-} GET_REGISTER;
+};
 
-typedef union {
+union as10x_cfg_change_mode {
    /* request */
    struct {
       /* request identifier */
@@ -374,7 +374,7 @@ typedef union {
       /* error */
       uint8_t error;
    } rsp;
-} CFG_CHANGE_MODE;
+};
 
 struct as10x_cmd_header_t {
    uint16_t req_id;
@@ -384,7 +384,8 @@ struct as10x_cmd_header_t {
 };
 
 #define DUMP_BLOCK_SIZE 16
-typedef union {
+
+union as10x_dump_memory {
    /* request */
    struct {
       /* request identifier */
@@ -411,9 +412,9 @@ typedef union {
 	 uint32_t data32[DUMP_BLOCK_SIZE / sizeof(uint32_t)];
       } u;
    } rsp;
-} DUMP_MEMORY;
+};
 
-typedef union {
+union as10x_dumplog_memory {
    struct {
       /* request identifier */
       uint16_t proc_id;
@@ -430,9 +431,9 @@ typedef union {
       /* dump data */
       uint8_t data[DUMP_BLOCK_SIZE];
    } rsp;
-} DUMPLOG_MEMORY;
+};
 
-typedef union {
+union as10x_raw_data {
    /* request */
    struct {
       uint16_t proc_id;
@@ -445,33 +446,31 @@ typedef union {
       uint8_t data[64 - sizeof(struct as10x_cmd_header_t) /* header */
 		      - 2 /* proc_id */ - 1 /* rc */];
    } rsp;
-} RAW_DATA;
+};
 
 struct as10x_cmd_t {
-   /* header */
-   struct as10x_cmd_header_t header;
-   /* body */
-   union {
-      TURN_ON           turn_on;
-      TURN_OFF          turn_off;
-      SET_TUNE          set_tune;
-      GET_TUNE_STATUS   get_tune_status;
-      GET_TPS           get_tps;
-      COMMON            common;
-      ADD_PID_FILTER    add_pid_filter;
-      DEL_PID_FILTER    del_pid_filter;
-      START_STREAMING   start_streaming;
-      STOP_STREAMING    stop_streaming;
-      GET_DEMOD_STATS   get_demod_stats;
-      GET_IMPULSE_RESP  get_impulse_rsp;
-      FW_CONTEXT        context;
-      SET_REGISTER      set_register;
-      GET_REGISTER      get_register;
-      CFG_CHANGE_MODE   cfg_change_mode;
-      DUMP_MEMORY       dump_memory;
-      DUMPLOG_MEMORY    dumplog_memory;
-      RAW_DATA          raw_data;
-   } body;
+	struct as10x_cmd_header_t header;
+	union {
+		union as10x_turn_on		turn_on;
+		union as10x_turn_off		turn_off;
+		union as10x_set_tune		set_tune;
+		union as10x_get_tune_status	get_tune_status;
+		union as10x_get_tps		get_tps;
+		union as10x_common		common;
+		union as10x_add_pid_filter	add_pid_filter;
+		union as10x_del_pid_filter	del_pid_filter;
+		union as10x_start_streaming	start_streaming;
+		union as10x_stop_streaming	stop_streaming;
+		union as10x_get_demod_stats	get_demod_stats;
+		union as10x_get_impulse_resp	get_impulse_rsp;
+		union as10x_fw_context		context;
+		union as10x_set_register	set_register;
+		union as10x_get_register	get_register;
+		union as10x_cfg_change_mode	cfg_change_mode;
+		union as10x_dump_memory		dump_memory;
+		union as10x_dumplog_memory	dumplog_memory;
+		union as10x_raw_data		raw_data;
+	} body;
 };
 
 struct as10x_token_cmd_t {
-- 
1.7.5.4

