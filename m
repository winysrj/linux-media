Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:65077 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757181AbaIQUCt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Sep 2014 16:02:49 -0400
Received: by mail-we0-f173.google.com with SMTP id t60so136560wes.32
        for <linux-media@vger.kernel.org>; Wed, 17 Sep 2014 13:02:47 -0700 (PDT)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH] libdvbv5: MPEG ES parser documentation
Date: Wed, 17 Sep 2014 22:02:24 +0200
Message-Id: <1410984144-4908-1-git-send-email-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: André Roth <neolynx@gmail.com>
---
 lib/include/libdvbv5/mpeg_es.h | 140 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 135 insertions(+), 5 deletions(-)

diff --git a/lib/include/libdvbv5/mpeg_es.h b/lib/include/libdvbv5/mpeg_es.h
index 4f1786e..377f235 100644
--- a/lib/include/libdvbv5/mpeg_es.h
+++ b/lib/include/libdvbv5/mpeg_es.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2013 - Andre Roth <neolynx@gmail.com>
+ * Copyright (c) 2013-2014 - Andre Roth <neolynx@gmail.com>
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
@@ -21,9 +21,46 @@
 #ifndef _MPEG_ES_H
 #define _MPEG_ES_H
 
+/**
+ * @file mpeg_es.h
+ * @ingroup dvb_table
+ * @brief Provides the table parser for the MPEG-TS Elementary Stream
+ * @copyright GNU General Public License version 2 (GPLv2)
+ * @author Andre Roth
+ *
+ * @par Relevant specs
+ * The table described herein is defined in ISO 13818-2
+ *
+ * @see
+ * http://dvd.sourceforge.net/dvdinfo/mpeghdrs.html
+ *
+ * @par Bug Report
+ * Please submit bug reports and patches to linux-media@vger.kernel.org
+ */
+
 #include <stdint.h>
 #include <unistd.h> /* ssize_t */
 
+/**
+ * @def DVB_MPEG_ES_PIC_START
+ *	@brief Picture Start
+ *	@ingroup dvb_table
+ * @def DVB_MPEG_ES_USER_DATA
+ *	@brief User Data
+ *	@ingroup dvb_table
+ * @def DVB_MPEG_ES_SEQ_START
+ *	@brief Sequence Start
+ *	@ingroup dvb_table
+ * @def DVB_MPEG_ES_SEQ_EXT
+ *	@brief Extension
+ *	@ingroup dvb_table
+ * @def DVB_MPEG_ES_GOP
+ *	@brief Group Of Pictures
+ *	@ingroup dvb_table
+ * @def DVB_MPEG_ES_SLICES
+ *	@brief Slices
+ *	@ingroup dvb_table
+ */
 #define DVB_MPEG_ES_PIC_START  0x00
 #define DVB_MPEG_ES_USER_DATA  0xb2
 #define DVB_MPEG_ES_SEQ_START  0xb3
@@ -31,6 +68,23 @@
 #define DVB_MPEG_ES_GOP        0xb8
 #define DVB_MPEG_ES_SLICES     0x01 ... 0xaf
 
+/**
+ * @struct dvb_mpeg_es_seq_start
+ * @brief Sequence header
+ *
+ * @param type		DVB_MPEG_ES_SEQ_START
+ * @param sync		Sync bytes
+ * @param framerate	Framerate
+ * @param aspect	Aspect ratio
+ * @param height	Height
+ * @param width		Width
+ * @param qm_nonintra	Load non-intra quantizer matrix
+ * @param qm_intra	Load intra quantizer matrix
+ * @param constrained	Constrained parameters flag
+ * @param vbv		VBV buffer size
+ * @param one		Should be 1
+ * @param bitrate	Bitrate
+ */
 struct dvb_mpeg_es_seq_start {
 	union {
 		uint32_t bitfield;
@@ -61,6 +115,17 @@ struct dvb_mpeg_es_seq_start {
 	} __attribute__((packed));
 } __attribute__((packed));
 
+/**
+ * @struct dvb_mpeg_es_pic_start
+ * @brief Picture start header
+ *
+ * @param type		DVB_MPEG_ES_PIC_START
+ * @param sync		Sync bytes
+ * @param dummy		Unused
+ * @param vbv_delay	VBV delay
+ * @param coding_type	Frame type (enum dvb_mpeg_es_frame_t)
+ * @param temporal_ref	Temporal sequence number
+ */
 struct dvb_mpeg_es_pic_start {
 	union {
 		uint32_t bitfield;
@@ -80,6 +145,22 @@ struct dvb_mpeg_es_pic_start {
 	} __attribute__((packed));
 } __attribute__((packed));
 
+/**
+ * @enum dvb_mpeg_es_frame_t
+ * @brief MPEG frame types
+ * @ingroup dvb_table
+ *
+ * @var DVB_MPEG_ES_FRAME_UNKNOWN
+ *	@brief	Unknown frame
+ * @var DVB_MPEG_ES_FRAME_I
+ *	@brief	I frame
+ * @var DVB_MPEG_ES_FRAME_P
+ *	@brief	P frame
+ * @var DVB_MPEG_ES_FRAME_B
+ *	@brief	B frame
+ * @var DVB_MPEG_ES_FRAME_D
+ *	@brief	D frame
+ */
 enum dvb_mpeg_es_frame_t
 {
 	DVB_MPEG_ES_FRAME_UNKNOWN,
@@ -88,6 +169,7 @@ enum dvb_mpeg_es_frame_t
 	DVB_MPEG_ES_FRAME_B,
 	DVB_MPEG_ES_FRAME_D
 };
+
 extern const char *dvb_mpeg_es_frame_names[5];
 
 struct dvb_v5_fe_parms;
@@ -96,11 +178,59 @@ struct dvb_v5_fe_parms;
 extern "C" {
 #endif
 
-int  dvb_mpeg_es_seq_start_init (const uint8_t *buf, ssize_t buflen, struct dvb_mpeg_es_seq_start *seq_start);
-void dvb_mpeg_es_seq_start_print(struct dvb_v5_fe_parms *parms, struct dvb_mpeg_es_seq_start *seq_start);
+/**
+ * @brief Initialize a struct dvb_mpeg_es_seq_start from buffer
+ *
+ * @param buf		Buffer
+ * @param buflen	Lenght of buffer
+ * @param seq_start	Pointer to allocated struct dvb_mpeg_es_seq_start
+ *
+ * @return		If buflen too small, return -1, 0 otherwise.
+ *
+ * This function copies the length of struct dvb_mpeg_es_seq_start
+ * to seq_start and fixes endianness. seq_start has to be allocated
+ * with malloc.
+ */
+int  dvb_mpeg_es_seq_start_init (const uint8_t *buf, ssize_t buflen,
+		struct dvb_mpeg_es_seq_start *seq_start);
+
+/**
+ * @brief Print details of struct dvb_mpeg_es_seq_start
+ *
+ * @param parms		struct dvb_v5_fe_parms for log functions
+ * @param seq_start	Pointer to struct dvb_mpeg_es_seq_start to print
+ *
+ * This function prints the fields of struct dvb_mpeg_es_seq_start
+ */
+void dvb_mpeg_es_seq_start_print(struct dvb_v5_fe_parms *parms,
+		struct dvb_mpeg_es_seq_start *seq_start);
+
+/**
+ * @brief Initialize a struct dvb_mpeg_es_pic_start from buffer
+ *
+ * @param buf		Buffer
+ * @param buflen	Lenght of buffer
+ * @param pic_start	Pointer to allocated structdvb_mpeg_es_pic_start
+ *
+ * @return		If buflen too small, return -1, 0 otherwise.
+ *
+ * This function copies the length of struct dvb_mpeg_es_pic_start
+ * to pic_start	and fixes endianness. seq_start has to be allocated
+ * with malloc.
+ */
+int  dvb_mpeg_es_pic_start_init (const uint8_t *buf, ssize_t buflen,
+		struct dvb_mpeg_es_pic_start *pic_start);
 
-int  dvb_mpeg_es_pic_start_init (const uint8_t *buf, ssize_t buflen, struct dvb_mpeg_es_pic_start *pic_start);
-void dvb_mpeg_es_pic_start_print(struct dvb_v5_fe_parms *parms, struct dvb_mpeg_es_pic_start *pic_start);
+/**
+ * @brief Print details of struct dvb_mpeg_es_pic_start
+ *
+ * @param parms		struct dvb_v5_fe_parms for log functions
+ * @param pic_start	Pointer to struct dvb_mpeg_es_pic_start to print
+ *
+ * This function prints the fields of struct dvb_mpeg_es_pic_start
+ */
+void dvb_mpeg_es_pic_start_print(struct dvb_v5_fe_parms *parms,
+		struct dvb_mpeg_es_pic_start *pic_start);
 
 #ifdef __cplusplus
 }
-- 
1.9.1

