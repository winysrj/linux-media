Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:45040 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932117AbaIRSMK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Sep 2014 14:12:10 -0400
Received: by mail-wi0-f172.google.com with SMTP id hi2so730366wib.17
        for <linux-media@vger.kernel.org>; Thu, 18 Sep 2014 11:12:09 -0700 (PDT)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH v2] libdvbv5: MPEG TS parser documentation
Date: Thu, 18 Sep 2014 20:11:56 +0200
Message-Id: <1411063916-4762-1-git-send-email-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: André Roth <neolynx@gmail.com>
---
 doxygen_libdvbv5.cfg           |  1 +
 lib/include/libdvbv5/mpeg_ts.h | 96 ++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 94 insertions(+), 3 deletions(-)

diff --git a/doxygen_libdvbv5.cfg b/doxygen_libdvbv5.cfg
index f1f9ab4..bbdaf9a 100644
--- a/doxygen_libdvbv5.cfg
+++ b/doxygen_libdvbv5.cfg
@@ -765,6 +765,7 @@ INPUT                  = $(SRCDIR)/doc/libdvbv5-index.doc \
 			 $(SRCDIR)/lib/include/libdvbv5/vct.h \
 			 $(SRCDIR)/lib/include/libdvbv5/crc32.h \
 			 $(SRCDIR)/lib/include/libdvbv5/mpeg_es.h \
+			 $(SRCDIR)/lib/include/libdvbv5/mpeg_ts.h \

 # This tag can be used to specify the character encoding of the source files
 # that doxygen parses. Internally doxygen uses the UTF-8 encoding. Doxygen uses
diff --git a/lib/include/libdvbv5/mpeg_ts.h b/lib/include/libdvbv5/mpeg_ts.h
index 3eab029..2662543 100644
--- a/lib/include/libdvbv5/mpeg_ts.h
+++ b/lib/include/libdvbv5/mpeg_ts.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2013 - Andre Roth <neolynx@gmail.com>
+ * Copyright (c) 2013-2014 - Andre Roth <neolynx@gmail.com>
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
@@ -21,12 +21,52 @@
 #ifndef _MPEG_TS_H
 #define _MPEG_TS_H

+/**
+ * @file mpeg_ts.h
+ * @ingroup dvb_table
+ * @brief Provides the table parser for the MPEG-PES Elementary Stream
+ * @copyright GNU General Public License version 2 (GPLv2)
+ * @author Andre Roth
+ *
+ * @par Relevant specs
+ * The table described herein is defined in ISO 13818-1
+ *
+ * @see
+ * http://en.wikipedia.org/wiki/MPEG_transport_stream
+ *
+ * @par Bug Report
+ * Please submit bug reports and patches to linux-media@vger.kernel.org
+ */
 #include <stdint.h>
 #include <unistd.h> /* ssize_t */

+/**
+ * @def DVB_MPEG_TS
+ *	@brief MPEG Transport Stream magic
+ *	@ingroup dvb_table
+ * @def DVB_MPEG_TS_PACKET_SIZE
+ *	@brief Size of an MPEG packet
+ *	@ingroup dvb_table
+ */
 #define DVB_MPEG_TS  0x47
 #define DVB_MPEG_TS_PACKET_SIZE  188

+/**
+ * @struct dvb_mpeg_ts_adaption
+ * @brief MPEG TS header adaption field
+ *
+ * @param type			DVB_MPEG_ES_SEQ_START
+ * @param length		1 bit	Adaptation Field Length
+ * @param discontinued		1 bit	Discontinuity indicator
+ * @param random_access		1 bit	Random Access indicator
+ * @param priority		1 bit	Elementary stream priority indicator
+ * @param PCR			1 bit	PCR flag
+ * @param OPCR			1 bit	OPCR flag
+ * @param splicing_point	1 bit	Splicing point flag
+ * @param private_data		1 bit	Transport private data flag
+ * @param extension		1 bit	Adaptation field extension flag
+ * @param data			Pointer to data
+ */
 struct dvb_mpeg_ts_adaption {
 	uint8_t length;
 	struct {
@@ -42,8 +82,23 @@ struct dvb_mpeg_ts_adaption {
 	uint8_t data[];
 } __attribute__((packed));

+/**
+ * @structdvb_mpeg_ts
+ * @brief MPEG TS header
+ *
+ * @param sync_byte		DVB_MPEG_TS
+ * @param tei			1 bit	Transport Error Indicator
+ * @param payload_start		1 bit	Payload Unit Start Indicator
+ * @param priority		1 bit	Transport Priority
+ * @param pid			13 bits	Packet Identifier
+ * @param scrambling		2 bits	Scrambling control
+ * @param adaptation_field	1 bit	Adaptation field exist
+ * @param payload		1 bit	Contains payload
+ * @param continuity_counter	4 bits	Continuity counter
+ * @param adaption		Pointer to optional adaption fiels (struct dvb_mpeg_ts_adaption)
+ */
 struct dvb_mpeg_ts {
-	uint8_t sync_byte; // DVB_MPEG_TS
+	uint8_t sync_byte;
 	union {
 		uint16_t bitfield;
 		struct {
@@ -68,8 +123,43 @@ struct dvb_v5_fe_parms;
 extern "C" {
 #endif

-ssize_t dvb_mpeg_ts_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, uint8_t *table, ssize_t *table_length);
+/**
+ * @brief Initialize a struct dvb_mpeg_ts from buffer
+ *
+ * @param parms		struct dvb_v5_fe_parms for log functions
+ * @param buf		Buffer
+ * @param buflen	Length of buffer
+ * @param table		Pointer to allocated struct dvb_mpeg_ts
+ * @param table_length	Pointer to size_t where length will be written to
+ *
+ * @return		Length of data in table
+ *
+ * This function copies the length of struct dvb_mpeg_ts
+ * to table and fixes endianness. table has to be allocated
+ * with malloc.
+ */
+ssize_t dvb_mpeg_ts_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen,
+		uint8_t *table, ssize_t *table_length);
+
+/**
+ * @brief Deallocate memory associated with a struct dvb_mpeg_ts
+ * @ingroup file
+ *
+ * @param ts	struct dvb_mpeg_ts to be deallocated
+ *
+ * This function assumes frees dynamically allocated memory by the
+ * dvb_mpeg_ts_init function.
+ */
 void dvb_mpeg_ts_free(struct dvb_mpeg_ts *ts);
+
+/**
+ * @brief Print details of struct dvb_mpeg_ts
+ *
+ * @param parms		struct dvb_v5_fe_parms for log functions
+ * @param seq_start	Pointer to struct dvb_mpeg_ts to print
+ *
+ * This function prints the fields of struct dvb_mpeg_ts
+ */
 void dvb_mpeg_ts_print(struct dvb_v5_fe_parms *parms, struct dvb_mpeg_ts *ts);

 #ifdef __cplusplus
--
1.9.1

