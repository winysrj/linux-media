Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:58953 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758576Ab2CFNsR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Mar 2012 08:48:17 -0500
Received: by mail-ee0-f46.google.com with SMTP id c41so1888705eek.19
        for <linux-media@vger.kernel.org>; Tue, 06 Mar 2012 05:48:16 -0800 (PST)
From: Gianluca Gennari <gennarone@gmail.com>
To: linux-media@vger.kernel.org, mchehab@redhat.com
Cc: dheitmueller@kernellabs.com, snjw23@gmail.com,
	Gianluca Gennari <gennarone@gmail.com>,
	Ryley Angus <rangus@student.unimelb.edu.au>
Subject: [PATCH 1/2] as102: add __packed attribute to structs defined inside packed structs
Date: Tue,  6 Mar 2012 14:47:45 +0100
Message-Id: <1331041666-22361-2-git-send-email-gennarone@gmail.com>
In-Reply-To: <1331041666-22361-1-git-send-email-gennarone@gmail.com>
References: <1331041666-22361-1-git-send-email-gennarone@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch fixes a regression in kernel 3.3 due to this patch:

http://patchwork.linuxtv.org/patch/8332/

That patch changes "#pragma pack(1)" with "__packed" attributes, but it is not
complete. In fact, in the as102 driver there are a lot of structs/unions
defined inside other structs/unions.
When the "__packed" attribute is applied only on the external struct, it will
not affect the internal struct definitions.
So the regression is fixed by specifiying the "__packed" attribute also on the
internal structs.

This patch should go into 3.3, as it fixes a regression introduced in the new
kernel version.

Signed-off-by: Gianluca Gennari <gennarone@gmail.com>
Signed-off-by: Ryley Angus <rangus@student.unimelb.edu.au>
---
 drivers/staging/media/as102/as102_fw.h    |    2 +-
 drivers/staging/media/as102/as10x_cmd.h   |   80 ++++++++++++++--------------
 drivers/staging/media/as102/as10x_types.h |    2 +-
 3 files changed, 42 insertions(+), 42 deletions(-)

diff --git a/drivers/staging/media/as102/as102_fw.h b/drivers/staging/media/as102/as102_fw.h
index bd21f05..4bfc684 100644
--- a/drivers/staging/media/as102/as102_fw.h
+++ b/drivers/staging/media/as102/as102_fw.h
@@ -29,7 +29,7 @@ struct as10x_fw_pkt_t {
 	union {
 		unsigned char request[2];
 		unsigned char length[2];
-	} u;
+	} __packed u;
 	struct as10x_raw_fw_pkt raw;
 } __packed;
 
diff --git a/drivers/staging/media/as102/as10x_cmd.h b/drivers/staging/media/as102/as10x_cmd.h
index 4ea249e..e21ec6c 100644
--- a/drivers/staging/media/as102/as10x_cmd.h
+++ b/drivers/staging/media/as102/as10x_cmd.h
@@ -99,14 +99,14 @@ union as10x_turn_on {
 	struct {
 		/* request identifier */
 		uint16_t proc_id;
-	} req;
+	} __packed req;
 	/* response */
 	struct {
 		/* response identifier */
 		uint16_t proc_id;
 		/* error */
 		uint8_t error;
-	} rsp;
+	} __packed rsp;
 } __packed;
 
 union as10x_turn_off {
@@ -114,14 +114,14 @@ union as10x_turn_off {
 	struct {
 		/* request identifier */
 		uint16_t proc_id;
-	} req;
+	} __packed req;
 	/* response */
 	struct {
 		/* response identifier */
 		uint16_t proc_id;
 		/* error */
 		uint8_t err;
-	} rsp;
+	} __packed rsp;
 } __packed;
 
 union as10x_set_tune {
@@ -131,14 +131,14 @@ union as10x_set_tune {
 		uint16_t proc_id;
 		/* tune params */
 		struct as10x_tune_args args;
-	} req;
+	} __packed req;
 	/* response */
 	struct {
 		/* response identifier */
 		uint16_t proc_id;
 		/* response error */
 		uint8_t error;
-	} rsp;
+	} __packed rsp;
 } __packed;
 
 union as10x_get_tune_status {
@@ -146,7 +146,7 @@ union as10x_get_tune_status {
 	struct {
 		/* request identifier */
 		uint16_t proc_id;
-	} req;
+	} __packed req;
 	/* response */
 	struct {
 		/* response identifier */
@@ -155,7 +155,7 @@ union as10x_get_tune_status {
 		uint8_t error;
 		/* tune status */
 		struct as10x_tune_status sts;
-	} rsp;
+	} __packed rsp;
 } __packed;
 
 union as10x_get_tps {
@@ -163,7 +163,7 @@ union as10x_get_tps {
 	struct {
 		/* request identifier */
 		uint16_t proc_id;
-	} req;
+	} __packed req;
 	/* response */
 	struct {
 		/* response identifier */
@@ -172,7 +172,7 @@ union as10x_get_tps {
 		uint8_t error;
 		/* tps details */
 		struct as10x_tps tps;
-	} rsp;
+	} __packed rsp;
 } __packed;
 
 union as10x_common {
@@ -180,14 +180,14 @@ union as10x_common {
 	struct {
 		/* request identifier */
 		uint16_t  proc_id;
-	} req;
+	} __packed req;
 	/* response */
 	struct {
 		/* response identifier */
 		uint16_t proc_id;
 		/* response error */
 		uint8_t error;
-	} rsp;
+	} __packed rsp;
 } __packed;
 
 union as10x_add_pid_filter {
@@ -201,7 +201,7 @@ union as10x_add_pid_filter {
 		uint8_t stream_type;
 		/* PID index in filter table */
 		uint8_t idx;
-	} req;
+	} __packed req;
 	/* response */
 	struct {
 		/* response identifier */
@@ -210,7 +210,7 @@ union as10x_add_pid_filter {
 		uint8_t error;
 		/* Filter id */
 		uint8_t filter_id;
-	} rsp;
+	} __packed rsp;
 } __packed;
 
 union as10x_del_pid_filter {
@@ -220,14 +220,14 @@ union as10x_del_pid_filter {
 		uint16_t  proc_id;
 		/* PID to remove */
 		uint16_t  pid;
-	} req;
+	} __packed req;
 	/* response */
 	struct {
 		/* response identifier */
 		uint16_t proc_id;
 		/* response error */
 		uint8_t error;
-	} rsp;
+	} __packed rsp;
 } __packed;
 
 union as10x_start_streaming {
@@ -235,14 +235,14 @@ union as10x_start_streaming {
 	struct {
 		/* request identifier */
 		uint16_t proc_id;
-	} req;
+	} __packed req;
 	/* response */
 	struct {
 		/* response identifier */
 		uint16_t proc_id;
 		/* error */
 		uint8_t error;
-	} rsp;
+	} __packed rsp;
 } __packed;
 
 union as10x_stop_streaming {
@@ -250,14 +250,14 @@ union as10x_stop_streaming {
 	struct {
 		/* request identifier */
 		uint16_t proc_id;
-	} req;
+	} __packed req;
 	/* response */
 	struct {
 		/* response identifier */
 		uint16_t proc_id;
 		/* error */
 		uint8_t error;
-	} rsp;
+	} __packed rsp;
 } __packed;
 
 union as10x_get_demod_stats {
@@ -265,7 +265,7 @@ union as10x_get_demod_stats {
 	struct {
 		/* request identifier */
 		uint16_t proc_id;
-	} req;
+	} __packed req;
 	/* response */
 	struct {
 		/* response identifier */
@@ -274,7 +274,7 @@ union as10x_get_demod_stats {
 		uint8_t error;
 		/* demod stats */
 		struct as10x_demod_stats stats;
-	} rsp;
+	} __packed rsp;
 } __packed;
 
 union as10x_get_impulse_resp {
@@ -282,7 +282,7 @@ union as10x_get_impulse_resp {
 	struct {
 		/* request identifier */
 		uint16_t proc_id;
-	} req;
+	} __packed req;
 	/* response */
 	struct {
 		/* response identifier */
@@ -291,7 +291,7 @@ union as10x_get_impulse_resp {
 		uint8_t error;
 		/* impulse response ready */
 		uint8_t is_ready;
-	} rsp;
+	} __packed rsp;
 } __packed;
 
 union as10x_fw_context {
@@ -305,7 +305,7 @@ union as10x_fw_context {
 		uint16_t tag;
 		/* context request type */
 		uint16_t type;
-	} req;
+	} __packed req;
 	/* response */
 	struct {
 		/* response identifier */
@@ -316,7 +316,7 @@ union as10x_fw_context {
 		uint16_t type;
 		/* error */
 		uint8_t error;
-	} rsp;
+	} __packed rsp;
 } __packed;
 
 union as10x_set_register {
@@ -328,14 +328,14 @@ union as10x_set_register {
 		struct as10x_register_addr reg_addr;
 		/* register content */
 		struct as10x_register_value reg_val;
-	} req;
+	} __packed req;
 	/* response */
 	struct {
 		/* response identifier */
 		uint16_t proc_id;
 		/* error */
 		uint8_t error;
-	} rsp;
+	} __packed rsp;
 } __packed;
 
 union as10x_get_register {
@@ -345,7 +345,7 @@ union as10x_get_register {
 		uint16_t proc_id;
 		/* register description */
 		struct as10x_register_addr reg_addr;
-	} req;
+	} __packed req;
 	/* response */
 	struct {
 		/* response identifier */
@@ -354,7 +354,7 @@ union as10x_get_register {
 		uint8_t error;
 		/* register content */
 		struct as10x_register_value reg_val;
-	} rsp;
+	} __packed rsp;
 } __packed;
 
 union as10x_cfg_change_mode {
@@ -364,14 +364,14 @@ union as10x_cfg_change_mode {
 		uint16_t proc_id;
 		/* mode */
 		uint8_t mode;
-	} req;
+	} __packed req;
 	/* response */
 	struct {
 		/* response identifier */
 		uint16_t proc_id;
 		/* error */
 		uint8_t error;
-	} rsp;
+	} __packed rsp;
 } __packed;
 
 struct as10x_cmd_header_t {
@@ -394,7 +394,7 @@ union as10x_dump_memory {
 		struct as10x_register_addr reg_addr;
 		/* nb blocks to read */
 		uint16_t num_blocks;
-	} req;
+	} __packed req;
 	/* response */
 	struct {
 		/* response identifier */
@@ -408,8 +408,8 @@ union as10x_dump_memory {
 			uint8_t  data8[DUMP_BLOCK_SIZE];
 			uint16_t data16[DUMP_BLOCK_SIZE / sizeof(uint16_t)];
 			uint32_t data32[DUMP_BLOCK_SIZE / sizeof(uint32_t)];
-		} u;
-	} rsp;
+		} __packed u;
+	} __packed rsp;
 } __packed;
 
 union as10x_dumplog_memory {
@@ -418,7 +418,7 @@ union as10x_dumplog_memory {
 		uint16_t proc_id;
 		/* dump memory type request */
 		uint8_t dump_req;
-	} req;
+	} __packed req;
 	struct {
 		/* request identifier */
 		uint16_t proc_id;
@@ -428,7 +428,7 @@ union as10x_dumplog_memory {
 		uint8_t dump_rsp;
 		/* dump data */
 		uint8_t data[DUMP_BLOCK_SIZE];
-	} rsp;
+	} __packed rsp;
 } __packed;
 
 union as10x_raw_data {
@@ -437,14 +437,14 @@ union as10x_raw_data {
 		uint16_t proc_id;
 		uint8_t data[64 - sizeof(struct as10x_cmd_header_t)
 			     - 2 /* proc_id */];
-	} req;
+	} __packed req;
 	/* response */
 	struct {
 		uint16_t proc_id;
 		uint8_t error;
 		uint8_t data[64 - sizeof(struct as10x_cmd_header_t)
 			     - 2 /* proc_id */ - 1 /* rc */];
-	} rsp;
+	} __packed rsp;
 } __packed;
 
 struct as10x_cmd_t {
@@ -469,7 +469,7 @@ struct as10x_cmd_t {
 		union as10x_dump_memory		dump_memory;
 		union as10x_dumplog_memory	dumplog_memory;
 		union as10x_raw_data		raw_data;
-	} body;
+	} __packed body;
 } __packed;
 
 struct as10x_token_cmd_t {
diff --git a/drivers/staging/media/as102/as10x_types.h b/drivers/staging/media/as102/as10x_types.h
index fde8140..af26e05 100644
--- a/drivers/staging/media/as102/as10x_types.h
+++ b/drivers/staging/media/as102/as10x_types.h
@@ -181,7 +181,7 @@ struct as10x_register_value {
 		uint8_t  value8;   /* 8 bit value */
 		uint16_t value16;  /* 16 bit value */
 		uint32_t value32;  /* 32 bit value */
-	} u;
+	} __packed u;
 } __packed;
 
 struct as10x_register_addr {
-- 
1.7.0.4

