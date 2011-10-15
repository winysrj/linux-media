Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpo05.poczta.onet.pl ([213.180.142.136]:60220 "EHLO
	smtpo05.poczta.onet.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218Ab1JOUyf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Oct 2011 16:54:35 -0400
Message-ID: <4E99F308.20406@poczta.onet.pl>
Date: Sat, 15 Oct 2011 22:54:32 +0200
From: Piotr Chmura <chmooreck@poczta.onet.pl>
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Greg KH <gregkh@suse.de>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Mauro Carvalho Chehab <maurochehab@gmail.com>,
	Patrick Dickey <pdickeybeta@gmail.com>,
	LMML <linux-media@vger.kernel.org>, devel@driverdev.osuosl.org
Subject: [PATCH 3/7] staging/as102: cleanup - get rid of typedefs
References: <4E7F1FB5.5030803@gmail.com> <CAGoCfixneQG=S5wy2qZZ50+PB-QNTFx=GLM7RYPuxfXtUy6Ecg@mail.gmail.com> <4E7FF0A0.7060004@gmail.com> <CAGoCfizyLgpEd_ei-SYEf6WWs5cygQJNjKPNPOYOQUqF773D4Q@mail.gmail.com> <20110927094409.7a5fcd5a@stein> <20110927174307.GD24197@suse.de> <20110927213300.6893677a@stein> <4E9992F9.7000101@poczta.onet.pl>
In-Reply-To: <4E9992F9.7000101@poczta.onet.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

staging as102: cleanup - get rid off typedefs

Cleanup code: get rid of typedef in structures and union definitions.

Signed-off-by: Piotr Chmura<chmooreck@poczta.onet.pl>
Cc: Devin Heitmueller<dheitmueller@kernellabs.com>
Cc: Greg HK<gregkh@suse.de>

diff -Nur linux.as102.02-nbox/drivers/staging/as102/as10x_cmd.h linux.as102.03-typedefs/drivers/staging/as102/as10x_cmd.h
--- linux.as102.02-nbox/drivers/staging/as102/as10x_cmd.h	2011-10-14 17:55:02.000000000 +0200
+++ linux.as102.03-typedefs/drivers/staging/as102/as10x_cmd.h	2011-10-14 18:48:39.000000000 +0200
@@ -52,7 +52,7 @@
  /*********************************/
  /*     TYPE DEFINITION           */
  /*********************************/
-typedef enum {
+enum control_proc {
     CONTROL_PROC_TURNON               = 0x0001,
     CONTROL_PROC_TURNON_RSP           = 0x0100,
     CONTROL_PROC_SET_REGISTER         = 0x0002,
@@ -92,11 +92,11 @@
     CONTROL_PROC_DUMPLOG_MEMORY_RSP   = 0xFE00,
     CONTROL_PROC_TURNOFF              = 0x00FF,
     CONTROL_PROC_TURNOFF_RSP          = 0xFF00
-} control_proc;
+};


  #pragma pack(1)
-typedef union {
+union TURN_ON {
     /* request */
     struct {
        /* request identifier */
@@ -109,9 +109,9 @@
        /* error */
        uint8_t error;
     } rsp;
-} TURN_ON;
+};

-typedef union {
+union TURN_OFF {
     /* request */
     struct {
        /* request identifier */
@@ -124,9 +124,9 @@
        /* error */
        uint8_t err;
     } rsp;
-} TURN_OFF;
+};

-typedef union {
+union SET_TUNE {
     /* request */
     struct {
        /* request identifier */
@@ -141,9 +141,9 @@
        /* response error */
        uint8_t error;
     } rsp;
-} SET_TUNE;
+};

-typedef union {
+union GET_TUNE_STATUS {
     /* request */
     struct {
        /* request identifier */
@@ -158,9 +158,9 @@
        /* tune status */
        struct as10x_tune_status sts;
     } rsp;
-} GET_TUNE_STATUS;
+};

-typedef union {
+union GET_TPS {
     /* request */
     struct {
        /* request identifier */
@@ -175,9 +175,9 @@
        /* tps details */
        struct as10x_tps tps;
     } rsp;
-} GET_TPS;
+};

-typedef union {
+union COMMON {
     /* request */
     struct {
        /* request identifier */
@@ -190,9 +190,9 @@
        /* response error */
        uint8_t error;
     } rsp;
-} COMMON;
+};

-typedef union {
+union ADD_PID_FILTER {
     /* request */
     struct {
        /* request identifier */
@@ -213,9 +213,9 @@
        /* Filter id */
        uint8_t filter_id;
     } rsp;
-} ADD_PID_FILTER;
+};

-typedef union {
+union DEL_PID_FILTER {
     /* request */
     struct {
        /* request identifier */
@@ -230,9 +230,9 @@
        /* response error */
        uint8_t error;
     } rsp;
-} DEL_PID_FILTER;
+};

-typedef union {
+union START_STREAMING {
     /* request */
     struct {
        /* request identifier */
@@ -245,9 +245,9 @@
        /* error */
        uint8_t error;
     } rsp;
-} START_STREAMING;
+};

-typedef union {
+union STOP_STREAMING {
     /* request */
     struct {
        /* request identifier */
@@ -260,9 +260,9 @@
        /* error */
        uint8_t error;
     } rsp;
-} STOP_STREAMING;
+};

-typedef union {
+union GET_DEMOD_STATS {
     /* request */
     struct {
        /* request identifier */
@@ -277,9 +277,9 @@
        /* demod stats */
        struct as10x_demod_stats stats;
     } rsp;
-} GET_DEMOD_STATS;
+};

-typedef union {
+union GET_IMPULSE_RESP {
     /* request */
     struct {
        /* request identifier */
@@ -294,9 +294,9 @@
        /* impulse response ready */
        uint8_t is_ready;
     } rsp;
-} GET_IMPULSE_RESP;
+};

-typedef union {
+union FW_CONTEXT {
     /* request */
     struct {
        /* request identifier */
@@ -319,9 +319,9 @@
        /* error */
        uint8_t error;
     } rsp;
-} FW_CONTEXT;
+};

-typedef union {
+union SET_REGISTER {
     /* request */
     struct {
        /* response identifier */
@@ -338,9 +338,9 @@
        /* error */
        uint8_t error;
     } rsp;
-} SET_REGISTER;
+};

-typedef union {
+union GET_REGISTER {
     /* request */
     struct {
        /* response identifier */
@@ -357,9 +357,9 @@
        /* register content */
        struct as10x_register_value reg_val;
     } rsp;
-} GET_REGISTER;
+};

-typedef union {
+union CFG_CHANGE_MODE {
     /* request */
     struct {
        /* request identifier */
@@ -374,7 +374,7 @@
        /* error */
        uint8_t error;
     } rsp;
-} CFG_CHANGE_MODE;
+};

  struct as10x_cmd_header_t {
     uint16_t req_id;
@@ -384,7 +384,7 @@
  };

  #define DUMP_BLOCK_SIZE 16
-typedef union {
+union DUMP_MEMORY {
     /* request */
     struct {
        /* request identifier */
@@ -411,9 +411,9 @@
  	 uint32_t data32[DUMP_BLOCK_SIZE / sizeof(uint32_t)];
        } u;
     } rsp;
-} DUMP_MEMORY;
+};

-typedef union {
+union DUMPLOG_MEMORY {
     struct {
        /* request identifier */
        uint16_t proc_id;
@@ -430,9 +430,9 @@
        /* dump data */
        uint8_t data[DUMP_BLOCK_SIZE];
     } rsp;
-} DUMPLOG_MEMORY;
+};

-typedef union {
+union RAW_DATA {
     /* request */
     struct {
        uint16_t proc_id;
@@ -445,32 +445,32 @@
        uint8_t data[64 - sizeof(struct as10x_cmd_header_t) /* header */
  		      - 2 /* proc_id */ - 1 /* rc */];
     } rsp;
-} RAW_DATA;
+};

  struct as10x_cmd_t {
     /* header */
     struct as10x_cmd_header_t header;
     /* body */
     union {
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
+      union TURN_ON           turn_on;
+      union TURN_OFF          turn_off;
+      union SET_TUNE          set_tune;
+      union GET_TUNE_STATUS   get_tune_status;
+      union GET_TPS           get_tps;
+      union COMMON            common;
+      union ADD_PID_FILTER    add_pid_filter;
+      union DEL_PID_FILTER    del_pid_filter;
+      union START_STREAMING   start_streaming;
+      union STOP_STREAMING    stop_streaming;
+      union GET_DEMOD_STATS   get_demod_stats;
+      union GET_IMPULSE_RESP  get_impulse_rsp;
+      union FW_CONTEXT        context;
+      union SET_REGISTER      set_register;
+      union GET_REGISTER      get_register;
+      union CFG_CHANGE_MODE   cfg_change_mode;
+      union DUMP_MEMORY       dump_memory;
+      union DUMPLOG_MEMORY    dumplog_memory;
+      union RAW_DATA          raw_data;
     } body;
  };





