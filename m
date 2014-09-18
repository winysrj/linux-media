Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:62447 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756604AbaIRWCE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Sep 2014 18:02:04 -0400
Received: by mail-we0-f173.google.com with SMTP id t60so1620769wes.18
        for <linux-media@vger.kernel.org>; Thu, 18 Sep 2014 15:02:02 -0700 (PDT)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH] libdvbv5: MPEG TS parser documentation and cleanups
Date: Fri, 19 Sep 2014 00:01:19 +0200
Message-Id: <1411077679-29737-1-git-send-email-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Documents the table parser for MPEG-PES. Cleanup doxygen of
other parsers.

Signed-off-by: André Roth <neolynx@gmail.com>
---
 doxygen_libdvbv5.cfg            |   3 +-
 lib/include/libdvbv5/mpeg_es.h  |  11 ++-
 lib/include/libdvbv5/mpeg_pes.h | 146 ++++++++++++++++++++++++++++++++++++++--
 lib/include/libdvbv5/mpeg_ts.h  |  18 +++--
 4 files changed, 164 insertions(+), 14 deletions(-)

diff --git a/doxygen_libdvbv5.cfg b/doxygen_libdvbv5.cfg
index bbdaf9a..45bbdbd 100644
--- a/doxygen_libdvbv5.cfg
+++ b/doxygen_libdvbv5.cfg
@@ -764,8 +764,9 @@ INPUT                  = $(SRCDIR)/doc/libdvbv5-index.doc \
 			 $(SRCDIR)/lib/include/libdvbv5/sdt.h \
 			 $(SRCDIR)/lib/include/libdvbv5/vct.h \
 			 $(SRCDIR)/lib/include/libdvbv5/crc32.h \
-			 $(SRCDIR)/lib/include/libdvbv5/mpeg_es.h \
 			 $(SRCDIR)/lib/include/libdvbv5/mpeg_ts.h \
+			 $(SRCDIR)/lib/include/libdvbv5/mpeg_pes.h \
+			 $(SRCDIR)/lib/include/libdvbv5/mpeg_es.h \
 
 # This tag can be used to specify the character encoding of the source files
 # that doxygen parses. Internally doxygen uses the UTF-8 encoding. Doxygen uses
diff --git a/lib/include/libdvbv5/mpeg_es.h b/lib/include/libdvbv5/mpeg_es.h
index cc2156b..ac3ea13 100644
--- a/lib/include/libdvbv5/mpeg_es.h
+++ b/lib/include/libdvbv5/mpeg_es.h
@@ -70,7 +70,8 @@
 
 /**
  * @struct dvb_mpeg_es_seq_start
- * @brief Sequence header
+ * @brief MPEG ES Sequence header
+ * @ingroup dvb_table
  *
  * @param type		DVB_MPEG_ES_SEQ_START
  * @param sync		Sync bytes
@@ -117,7 +118,8 @@ struct dvb_mpeg_es_seq_start {
 
 /**
  * @struct dvb_mpeg_es_pic_start
- * @brief Picture start header
+ * @brief MPEG ES Picture start header
+ * @ingroup dvb_table
  *
  * @param type		DVB_MPEG_ES_PIC_START
  * @param sync		Sync bytes
@@ -172,6 +174,7 @@ enum dvb_mpeg_es_frame_t
 
 /**
  * @brief Vector that translates from enum dvb_mpeg_es_frame_t to string.
+ * @ingroup dvb_table
  */
 extern const char *dvb_mpeg_es_frame_names[5];
 
@@ -183,6 +186,7 @@ extern "C" {
 
 /**
  * @brief Initialize a struct dvb_mpeg_es_seq_start from buffer
+ * @ingroup dvb_table
  *
  * @param buf		Buffer
  * @param buflen	Length of buffer
@@ -199,6 +203,7 @@ int  dvb_mpeg_es_seq_start_init (const uint8_t *buf, ssize_t buflen,
 
 /**
  * @brief Print details of struct dvb_mpeg_es_seq_start
+ * @ingroup dvb_table
  *
  * @param parms		struct dvb_v5_fe_parms for log functions
  * @param seq_start	Pointer to struct dvb_mpeg_es_seq_start to print
@@ -210,6 +215,7 @@ void dvb_mpeg_es_seq_start_print(struct dvb_v5_fe_parms *parms,
 
 /**
  * @brief Initialize a struct dvb_mpeg_es_pic_start from buffer
+ * @ingroup dvb_table
  *
  * @param buf		Buffer
  * @param buflen	Length of buffer
@@ -226,6 +232,7 @@ int  dvb_mpeg_es_pic_start_init (const uint8_t *buf, ssize_t buflen,
 
 /**
  * @brief Print details of struct dvb_mpeg_es_pic_start
+ * @ingroup dvb_table
  *
  * @param parms		struct dvb_v5_fe_parms for log functions
  * @param pic_start	Pointer to struct dvb_mpeg_es_pic_start to print
diff --git a/lib/include/libdvbv5/mpeg_pes.h b/lib/include/libdvbv5/mpeg_pes.h
index 5889df7..1f24f99 100644
--- a/lib/include/libdvbv5/mpeg_pes.h
+++ b/lib/include/libdvbv5/mpeg_pes.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2013 - Andre Roth <neolynx@gmail.com>
+ * Copyright (c) 2013-2014 - Andre Roth <neolynx@gmail.com>
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
@@ -21,10 +21,66 @@
 #ifndef _MPEG_PES_H
 #define _MPEG_PES_H
 
+/**
+ * @file mpeg_pes.h
+ * @ingroup dvb_table
+ * @brief Provides the table parser for the MPEG-PES Elementary Stream
+ * @copyright GNU General Public License version 2 (GPLv2)
+ * @author Andre Roth
+ *
+ * @par Relevant specs
+ * The table described herein is defined in ISO 13818-1
+ *
+ * @see
+ * http://dvd.sourceforge.net/dvdinfo/pes-hdr.html
+ *
+ * @par Bug Report
+ * Please submit bug reports and patches to linux-media@vger.kernel.org
+ */
+
 #include <stdint.h>
 #include <unistd.h> /* ssize_t */
 
+
+/**
+ * @def DVB_MPEG_PES
+ *	@brief MPEG Packetized Elementary Stream magic
+ *	@ingroup dvb_table
+ * @def DVB_MPEG_PES_AUDIO
+ *	@brief PES Audio
+ *	@ingroup dvb_table
+ * @def DVB_MPEG_PES_VIDEO
+ *	@brief PES Video
+ *	@ingroup dvb_table
+ * @def DVB_MPEG_STREAM_MAP
+ *	@brief PES Stream map
+ *	@ingroup dvb_table
+ * @def DVB_MPEG_STREAM_PADDING
+ *	@brief PES padding
+ *	@ingroup dvb_table
+ * @def DVB_MPEG_STREAM_PRIVATE_2
+ *	@brief PES private
+ *	@ingroup dvb_table
+ * @def DVB_MPEG_STREAM_ECM
+ *	@brief PES ECM Stream
+ *	@ingroup dvb_table
+ * @def DVB_MPEG_STREAM_EMM
+ *	@brief PES EMM Stream
+ *	@ingroup dvb_table
+ * @def DVB_MPEG_STREAM_DIRECTORY
+ *	@brief PES Stream directory
+ *	@ingroup dvb_table
+ * @def DVB_MPEG_STREAM_DSMCC
+ *	@brief PES DSMCC
+ *	@ingroup dvb_table
+ * @def DVB_MPEG_STREAM_H222E
+ *	@brief PES H.222.1 type E
+ *	@ingroup dvb_table
+ */
+
 #define DVB_MPEG_PES  0x00001
+
+#define DVB_MPEG_PES_AUDIO  0xc0 ... 0xcf
 #define DVB_MPEG_PES_VIDEO  0xe0 ... 0xef
 
 #define DVB_MPEG_STREAM_MAP       0xBC
@@ -36,6 +92,20 @@
 #define DVB_MPEG_STREAM_DSMCC     0x7A
 #define DVB_MPEG_STREAM_H222E     0xF8
 
+/**
+ * @struct ts_t
+ * @brief MPEG PES timestamp structure, used for dts and pts
+ * @ingroup dvb_table
+ *
+ * @param tag		4 bits  Should be 0010 for PTS and 0011 for DTS
+ * @param bits30	3 bits	Timestamp bits 30-32
+ * @param one		1 bit	Sould be 1
+ * @param bits15	15 bits	Timestamp bits 15-29
+ * @param one1		1 bit	Should be 1
+ * @param bits00	15 Bits	Timestamp bits 0-14
+ * @param one2		1 bit	Should be 1
+ */
+
 struct ts_t {
 	uint8_t  one:1;
 	uint8_t  bits30:3;
@@ -58,6 +128,28 @@ struct ts_t {
 	} __attribute__((packed));
 } __attribute__((packed));
 
+/**
+ * @struct dvb_mpeg_pes_optional
+ * @brief MPEG PES optional header
+ * @ingroup dvb_table
+ *
+ * @param two				2 bits	Should be 10
+ * @param PES_scrambling_control	2 bits	PES Scrambling Control (Not Scrambled=00, otherwise scrambled)
+ * @param PES_priority			1 bit	PES Priority
+ * @param data_alignment_indicator	1 bit	PES data alignment
+ * @param copyright			1 bit	PES content protected by copyright
+ * @param original_or_copy		1 bit	PES content is original (=1) or copied (=0)
+ * @param PTS_DTS			2 bit	PES header contains PTS (=10, =11) and/or DTS (=01, =11)
+ * @param ESCR				1 bit	PES header contains ESCR fields
+ * @param ES_rate			1 bit	PES header contains ES_rate field
+ * @param DSM_trick_mode		1 bit	PES header contains DSM_trick_mode field
+ * @param additional_copy_info		1 bit	PES header contains additional_copy_info field
+ * @param PES_CRC			1 bit	PES header contains CRC field
+ * @param PES_extension			1 bit	PES header contains extension field
+ * @param length			8 bit	PES header data length
+ * @param pts				64 bit	PES PTS timestamp
+ * @param dts				64 bit	PES DTS timestamp
+ */
 struct dvb_mpeg_pes_optional {
 	union {
 		uint16_t bitfield;
@@ -82,6 +174,16 @@ struct dvb_mpeg_pes_optional {
 	uint64_t dts;
 } __attribute__((packed));
 
+/**
+ * @struct dvb_mpeg_pes
+ * @brief MPEG PES data structure
+ * @ingroup dvb_table
+ *
+ * @param sync		24 bits	DVB_MPEG_PES
+ * @param stream_id	8 bits	PES Stream ID
+ * @param length	16 bits	PES packet length
+ * @param optional	Pointer to optional PES header
+ */
 struct dvb_mpeg_pes {
 	union {
 		uint32_t bitfield;
@@ -100,9 +202,45 @@ struct dvb_v5_fe_parms;
 extern "C" {
 #endif
 
-ssize_t dvb_mpeg_pes_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, uint8_t *table);
-void dvb_mpeg_pes_free(struct dvb_mpeg_pes *ts);
-void dvb_mpeg_pes_print(struct dvb_v5_fe_parms *parms, struct dvb_mpeg_pes *ts);
+/**
+ * @brief Initialize a struct dvb_mpeg_pes from buffer
+ * @ingroup dvb_table
+ *
+ * @param parms		struct dvb_v5_fe_parms for log functions
+ * @param buf		Buffer
+ * @param buflen	Length of buffer
+ * @param table		Pointer to allocated struct dvb_mpeg_pes
+ *
+ * @return		Length of data in table
+ *
+ * This function copies the length of struct dvb_mpeg_pes
+ * to table and fixes endianness. The pointer table has to be
+ * allocated on stack or dynamically.
+ */
+ssize_t dvb_mpeg_pes_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen,
+		uint8_t *table);
+
+/**
+ * @brief Deallocate memory associated with a struct dvb_mpeg_pes
+ * @ingroup dvb_table
+ *
+ * @param pes	struct dvb_mpeg_pes to be deallocated
+ *
+ * If the pointer pes was allocated dynamically, this function
+ * can be used to free the memory.
+ */
+void dvb_mpeg_pes_free (struct dvb_mpeg_pes *pes);
+
+/**
+ * @brief Print details of struct dvb_mpeg_pes
+ * @ingroup dvb_table
+ *
+ * @param parms		struct dvb_v5_fe_parms for log functions
+ * @param pes    	Pointer to struct dvb_mpeg_pes to print
+ *
+ * This function prints the fields of struct dvb_mpeg_pes
+ */
+void dvb_mpeg_pes_print (struct dvb_v5_fe_parms *parms, struct dvb_mpeg_pes *pes);
 
 #ifdef __cplusplus
 }
diff --git a/lib/include/libdvbv5/mpeg_ts.h b/lib/include/libdvbv5/mpeg_ts.h
index cfb8831..f85be59 100644
--- a/lib/include/libdvbv5/mpeg_ts.h
+++ b/lib/include/libdvbv5/mpeg_ts.h
@@ -54,6 +54,7 @@
 /**
  * @struct dvb_mpeg_ts_adaption
  * @brief MPEG TS header adaption field
+ * @ingroup dvb_table
  *
  * @param type			DVB_MPEG_ES_SEQ_START
  * @param length		1 bit	Adaptation Field Length
@@ -85,6 +86,7 @@ struct dvb_mpeg_ts_adaption {
 /**
  * @struct dvb_mpeg_ts
  * @brief MPEG TS header
+ * @ingroup dvb_table
  *
  * @param sync_byte		DVB_MPEG_TS
  * @param tei			1 bit	Transport Error Indicator
@@ -125,6 +127,7 @@ extern "C" {
 
 /**
  * @brief Initialize a struct dvb_mpeg_ts from buffer
+ * @ingroup dvb_table
  *
  * @param parms		struct dvb_v5_fe_parms for log functions
  * @param buf		Buffer
@@ -135,32 +138,33 @@ extern "C" {
  * @return		Length of data in table
  *
  * This function copies the length of struct dvb_mpeg_ts
- * to table and fixes endianness. table has to be allocated
- * with malloc.
+ * to table and fixes endianness. The pointer table has to be allocated
+ * on stack or dynamically.
  */
 ssize_t dvb_mpeg_ts_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen,
 		uint8_t *table, ssize_t *table_length);
 
 /**
  * @brief Deallocate memory associated with a struct dvb_mpeg_ts
- * @ingroup file
+ * @ingroup dvb_table
  *
  * @param ts	struct dvb_mpeg_ts to be deallocated
  *
- * This function assumes frees dynamically allocated memory by the
- * dvb_mpeg_ts_init function.
+ * If ts was allocated dynamically, this function
+ * can be used to free the memory.
  */
-void dvb_mpeg_ts_free(struct dvb_mpeg_ts *ts);
+void dvb_mpeg_ts_free (struct dvb_mpeg_ts *ts);
 
 /**
  * @brief Print details of struct dvb_mpeg_ts
+ * @ingroup dvb_table
  *
  * @param parms		struct dvb_v5_fe_parms for log functions
  * @param ts    	Pointer to struct dvb_mpeg_ts to print
  *
  * This function prints the fields of struct dvb_mpeg_ts
  */
-void dvb_mpeg_ts_print(struct dvb_v5_fe_parms *parms, struct dvb_mpeg_ts *ts);
+void dvb_mpeg_ts_print (struct dvb_v5_fe_parms *parms, struct dvb_mpeg_ts *ts);
 
 #ifdef __cplusplus
 }
-- 
1.9.1

