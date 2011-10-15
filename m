Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpo05.poczta.onet.pl ([213.180.142.136]:52837 "EHLO
	smtpo05.poczta.onet.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218Ab1JOUy7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Oct 2011 16:54:59 -0400
Message-ID: <4E99F320.6050808@poczta.onet.pl>
Date: Sat, 15 Oct 2011 22:54:56 +0200
From: Piotr Chmura <chmooreck@poczta.onet.pl>
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Greg KH <gregkh@suse.de>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Mauro Carvalho Chehab <maurochehab@gmail.com>,
	Patrick Dickey <pdickeybeta@gmail.com>,
	LMML <linux-media@vger.kernel.org>, devel@driverdev.osuosl.org
Subject: [PATCH 5/7] staging as102: cleanup - get rid of pragma(pack)
References: <4E7F1FB5.5030803@gmail.com> <CAGoCfixneQG=S5wy2qZZ50+PB-QNTFx=GLM7RYPuxfXtUy6Ecg@mail.gmail.com> <4E7FF0A0.7060004@gmail.com> <CAGoCfizyLgpEd_ei-SYEf6WWs5cygQJNjKPNPOYOQUqF773D4Q@mail.gmail.com> <20110927094409.7a5fcd5a@stein> <20110927174307.GD24197@suse.de> <20110927213300.6893677a@stein> <4E9992F9.7000101@poczta.onet.pl>
In-Reply-To: <4E9992F9.7000101@poczta.onet.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

staging as102: cleanup - get rid of pragma(pack)

Cleanup code: change #pragma(pack) directive to __attribute__(packed)

Signed-off-by: Piotr Chmura<chmooreck@poczta.onet.pl>
Cc: Devin Heitmueller<dheitmueller@kernellabs.com>
Cc: Greg HK<gregkh@suse.de>

diff -Nur linux.as102.04-tabs/drivers/staging/as102/as102_fw.h linux.as102.05-pragmapack//drivers/staging/as102/as102_fw.h
--- linux.as102.04-tabs/drivers/staging/as102/as102_fw.h	2011-10-14 23:36:54.000000000 +0200
+++ linux.as102.05-pragmapack//drivers/staging/as102/as102_fw.h	2011-10-14 23:38:24.000000000 +0200
@@ -20,11 +20,10 @@

  extern int dual_tuner;

-#pragma pack(1)
  struct as10x_raw_fw_pkt {
  	unsigned char address[4];
  	unsigned char data[MAX_FW_PKT_SIZE - 6];
-};
+} __attribute__((packed));

  struct as10x_fw_pkt_t {
  	union {
@@ -32,8 +31,7 @@
  		unsigned char length[2];
  	} u;
  	struct as10x_raw_fw_pkt raw;
-};
-#pragma pack()
+} __attribute__((packed));

  #ifdef __KERNEL__
  int as102_fw_upload(struct as102_bus_adapter_t *bus_adap);
diff -Nur linux.as102.04-tabs/drivers/staging/as102/as10x_cmd.h linux.as102.05-pragmapack//drivers/staging/as102/as10x_cmd.h
--- linux.as102.04-tabs/drivers/staging/as102/as10x_cmd.h	2011-10-14 23:34:17.000000000 +0200
+++ linux.as102.05-pragmapack//drivers/staging/as102/as10x_cmd.h	2011-10-14 23:39:06.000000000 +0200
@@ -95,7 +95,6 @@
  };


-#pragma pack(1)
  union TURN_ON {
  	/* request */
  	struct {
@@ -109,7 +108,7 @@
  		/* error */
  		uint8_t error;
  	} rsp;
-};
+} __attribute__((packed));

  union TURN_OFF {
  	/* request */
@@ -124,7 +123,7 @@
  		/* error */
  		uint8_t err;
  	} rsp;
-};
+} __attribute__((packed));

  union SET_TUNE {
  	/* request */
@@ -141,7 +140,7 @@
  		/* response error */
  		uint8_t error;
  	} rsp;
-};
+} __attribute__((packed));

  union GET_TUNE_STATUS {
  	/* request */
@@ -158,7 +157,7 @@
  		/* tune status */
  		struct as10x_tune_status sts;
  	} rsp;
-};
+} __attribute__((packed));

  union GET_TPS {
  	/* request */
@@ -175,7 +174,7 @@
  		/* tps details */
  		struct as10x_tps tps;
  	} rsp;
-};
+} __attribute__((packed));

  union COMMON {
  	/* request */
@@ -190,7 +189,7 @@
  		/* response error */
  		uint8_t error;
  	} rsp;
-};
+} __attribute__((packed));

  union ADD_PID_FILTER {
  	/* request */
@@ -213,7 +212,7 @@
  		/* Filter id */
  		uint8_t filter_id;
  	} rsp;
-};
+} __attribute__((packed));

  union DEL_PID_FILTER {
  	/* request */
@@ -230,7 +229,7 @@
  		/* response error */
  		uint8_t error;
  	} rsp;
-};
+} __attribute__((packed));

  union START_STREAMING {
  	/* request */
@@ -245,7 +244,7 @@
  		/* error */
  		uint8_t error;
  	} rsp;
-};
+} __attribute__((packed));

  union STOP_STREAMING {
  	/* request */
@@ -260,7 +259,7 @@
  		/* error */
  		uint8_t error;
  	} rsp;
-};
+} __attribute__((packed));

  union GET_DEMOD_STATS {
  	/* request */
@@ -277,7 +276,7 @@
  		/* demod stats */
  		struct as10x_demod_stats stats;
  	} rsp;
-};
+} __attribute__((packed));

  union GET_IMPULSE_RESP {
  	/* request */
@@ -294,7 +293,7 @@
  		/* impulse response ready */
  		uint8_t is_ready;
  	} rsp;
-};
+} __attribute__((packed));

  union FW_CONTEXT {
  	/* request */
@@ -319,7 +318,7 @@
  		/* error */
  		uint8_t error;
  	} rsp;
-};
+} __attribute__((packed));

  union SET_REGISTER {
  	/* request */
@@ -338,7 +337,7 @@
  		/* error */
  		uint8_t error;
  	} rsp;
-};
+} __attribute__((packed));

  union GET_REGISTER {
  	/* request */
@@ -357,7 +356,7 @@
  		/* register content */
  		struct as10x_register_value reg_val;
  	} rsp;
-};
+} __attribute__((packed));

  union CFG_CHANGE_MODE {
  	/* request */
@@ -374,14 +373,14 @@
  		/* error */
  		uint8_t error;
  	} rsp;
-};
+} __attribute__((packed));

  struct as10x_cmd_header_t {
  	uint16_t req_id;
  	uint16_t prog;
  	uint16_t version;
  	uint16_t data_len;
-};
+} __attribute__((packed));

  #define DUMP_BLOCK_SIZE 16
  union DUMP_MEMORY {
@@ -411,7 +410,7 @@
  			uint32_t data32[DUMP_BLOCK_SIZE / sizeof(uint32_t)];
  		} u;
  	} rsp;
-};
+} __attribute__((packed));

  union DUMPLOG_MEMORY {
  	struct {
@@ -430,7 +429,7 @@
  		/* dump data */
  		uint8_t data[DUMP_BLOCK_SIZE];
  	} rsp;
-};
+} __attribute__((packed));

  union RAW_DATA {
  	/* request */
@@ -444,7 +443,7 @@
  		uint8_t error;
  		uint8_t data[64 - sizeof(struct as10x_cmd_header_t) - 2 - 1]; /* 64 - header - proc_id - rc */
  	} rsp;
-};
+} __attribute__((packed));

  struct as10x_cmd_t {
  	/* header */
@@ -471,15 +470,14 @@
  		union DUMPLOG_MEMORY	dumplog_memory;
  		union RAW_DATA			raw_data;
  	} body;
-};
+} __attribute__((packed));

  struct as10x_token_cmd_t {
  	/* token cmd */
  	struct as10x_cmd_t c;
  	/* token response */
  	struct as10x_cmd_t r;
-};
-#pragma pack()
+} __attribute__((packed));


  /************************/
diff -Nur linux.as102.04-tabs/drivers/staging/as102/as10x_types.h linux.as102.05-pragmapack//drivers/staging/as102/as10x_types.h
--- linux.as102.04-tabs/drivers/staging/as102/as10x_types.h	2011-10-14 23:33:20.000000000 +0200
+++ linux.as102.05-pragmapack//drivers/staging/as102/as10x_types.h	2011-10-14 23:40:11.000000000 +0200
@@ -111,7 +111,6 @@
  #define CFG_MODE_OFF	1
  #define CFG_MODE_AUTO	2

-#pragma pack(1)
  struct as10x_tps {
  	uint8_t constellation;
  	uint8_t hierarchy;
@@ -123,7 +122,7 @@
  	uint8_t DVBH_mask_HP;
  	uint8_t DVBH_mask_LP;
  	uint16_t cell_ID;
-};
+} __attribute__((packed));

  struct as10x_tune_args {
  	/* frequency */
@@ -144,7 +143,7 @@
  	uint8_t guard_interval;
  	/* transmission mode */
  	uint8_t transmission_mode;
-};
+} __attribute__((packed));

  struct as10x_tune_status {
  	/* tune status */
@@ -155,7 +154,7 @@
  	uint16_t PER;
  	/* bit error rate 10^-4 */
  	uint16_t BER;
-};
+} __attribute__((packed));

  struct as10x_demod_stats {
  	/* frame counter */
@@ -168,13 +167,13 @@
  	uint16_t mer;
  	/* statistics calculation state indicator (started or not) */
  	uint8_t has_started;
-};
+} __attribute__((packed));

  struct as10x_ts_filter {
  	uint16_t	pid;	/** valid PID value 0x00 : 0x2000 */
  	uint8_t		type;	/** Red TS_PID_TYPE_<N>  values */
  	uint8_t		idx;	/** index in filtering table */
-};
+} __attribute__((packed));

  struct as10x_register_value {
  	uint8_t mode;
@@ -183,9 +182,7 @@
  		uint16_t	value16;	/* 16 bit value */
  		uint32_t	value32;	/* 32 bit value */
  	}u;
-};
-
-#pragma pack()
+} __attribute__((packed));

  struct as10x_register_addr {
  	/* register addr */




