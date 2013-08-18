Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60215 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755461Ab3HROmt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Aug 2013 10:42:49 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	=?UTF-8?q?Jon=20Arne=20J=C3=B8rgensen?= <jonarne@jonarne.no>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH] [media] saa7115: make multi-line comments compliant with CodingStyle
Date: Sun, 18 Aug 2013 08:42:05 -0300
Message-Id: <1376826125-12229-1-git-send-email-m.chehab@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

changeset 2ccf12a did a crappy job when added multi-line comment lines,
violating CodingStyle.

Change the comments added there to fulfill CodingStyle, and document
the platform_data using Documentation/kernel-doc-nano-HOWTO.txt.

Cc: Jon Arne Jørgensen <jonarne@jonarne.no>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/i2c/saa7115.c | 24 +++++++++++++---------
 include/media/saa7115.h     | 49 +++++++++++++++++++++++++++------------------
 2 files changed, 43 insertions(+), 30 deletions(-)

diff --git a/drivers/media/i2c/saa7115.c b/drivers/media/i2c/saa7115.c
index 5cc48f7..637d026 100644
--- a/drivers/media/i2c/saa7115.c
+++ b/drivers/media/i2c/saa7115.c
@@ -225,12 +225,14 @@ static const unsigned char saa7111_init[] = {
 	0x00, 0x00
 };
 
-/* This table has one illegal value, and some values that are not
-   correct according to the datasheet initialization table.
-
-   If you need a table with legal/default values tell the driver in
-   i2c_board_info.platform_data, and you will get the gm7113c_init
-   table instead. */
+/*
+ * This table has one illegal value, and some values that are not
+ * correct according to the datasheet initialization table.
+ *
+ *  If you need a table with legal/default values tell the driver in
+ *  i2c_board_info.platform_data, and you will get the gm7113c_init
+ *  table instead.
+ */
 
 /* SAA7113 Init codes */
 static const unsigned char saa7113_init[] = {
@@ -265,10 +267,12 @@ static const unsigned char saa7113_init[] = {
 	0x00, 0x00
 };
 
-/* GM7113C is a clone of the SAA7113 chip
-   This init table is copied out of the saa7113 datasheet.
-   In R_08 we enable "Automatic Field Detection" [AUFD],
-   this is disabled when saa711x_set_v4lstd is called. */
+/*
+ * GM7113C is a clone of the SAA7113 chip
+ *  This init table is copied out of the saa7113 datasheet.
+ *  In R_08 we enable "Automatic Field Detection" [AUFD],
+ *  this is disabled when saa711x_set_v4lstd is called.
+ */
 static const unsigned char gm7113c_init[] = {
 	R_01_INC_DELAY, 0x08,
 	R_02_INPUT_CNTL_1, 0xc0,
diff --git a/include/media/saa7115.h b/include/media/saa7115.h
index e8d512a..76911e7 100644
--- a/include/media/saa7115.h
+++ b/include/media/saa7115.h
@@ -47,9 +47,11 @@
 #define SAA7111_FMT_YUV411 	0xc0
 
 /* config flags */
-/* Register 0x85 should set bit 0 to 0 (it's 1 by default). This bit
+/*
+ * Register 0x85 should set bit 0 to 0 (it's 1 by default). This bit
  * controls the IDQ signal polarity which is set to 'inverted' if the bit
- * it 1 and to 'default' if it is 0. */
+ * it 1 and to 'default' if it is 0.
+ */
 #define SAA7115_IDQ_IS_DEFAULT  (1 << 0)
 
 /* s_crystal_freq values and flags */
@@ -84,11 +86,13 @@ enum saa7113_r10_ofts {
 	SAA7113_OFTS_VFLAG_BY_DATA_TYPE
 };
 
-/* Register 0x12 "Output control" [Bit 0..3 Or Bit 4..7]:
+/*
+ * Register 0x12 "Output control" [Bit 0..3 Or Bit 4..7]:
  * This is used to select what data is output on the RTS0 and RTS1 pins.
  * RTS1 [Bit 4..7] Defaults to DOT_IN. (This value can not be set for RTS0)
  * RTS0 [Bit 0..3] Defaults to VIPB in gm7113c_init as specified
- * in the datasheet, but is set to HREF_HS in the saa7113_init table. */
+ * in the datasheet, but is set to HREF_HS in the saa7113_init table.
+ */
 enum saa7113_r12_rts {
 	SAA7113_RTS_DOT_IN = 0,		/* OBS: Only for RTS1 (Default RTS1) */
 	SAA7113_RTS_VIPB,		/* Default RTS0 For gm7113c_init */
@@ -108,24 +112,29 @@ enum saa7113_r12_rts {
 	SAA7113_RTS_FID
 };
 
+/**
+ * struct saa7115_platform_data - Allow overriding default initialization
+ *
+ * @saa7113_force_gm7113c_init:	Force the use of the gm7113c_init table
+ *				instead of saa7113_init table
+ *				(saa7113 only)
+ * @saa7113_r08_htc:		[R_08 - Bit 3..4]
+ * @saa7113_r10_vrln:		[R_10 - Bit 3]
+ *				default: Disabled for gm7113c_init
+ *					 Enabled for saa7113c_init
+ * @saa7113_r10_ofts:		[R_10 - Bit 6..7]
+ * @saa7113_r12_rts0:		[R_12 - Bit 0..3]
+ * @saa7113_r12_rts1:		[R_12 - Bit 4..7]
+ * @saa7113_r13_adlsb:		[R_13 - Bit 7] - default: disabled
+ */
 struct saa7115_platform_data {
-	/* saa7113 only: Force the use of the gm7113c_init table,
-	 * instead of the old saa7113_init table. */
 	bool saa7113_force_gm7113c_init;
-
-	/* SAA7113/GM7113C Specific configurations */
-	enum saa7113_r08_htc *saa7113_r08_htc;	/* [R_08 - Bit 3..4] */
-
-	bool *saa7113_r10_vrln;			/* [R_10 - Bit 3]
-						   Disabled for gm7113c_init
-						   Enabled for saa7113c_init */
-	enum saa7113_r10_ofts *saa7113_r10_ofts;	/* [R_10 - Bit 6..7] */
-
-	enum saa7113_r12_rts *saa7113_r12_rts0;		/* [R_12 - Bit 0..3] */
-	enum saa7113_r12_rts *saa7113_r12_rts1;		/* [R_12 - Bit 4..7] */
-
-	bool *saa7113_r13_adlsb;			/* [R_13 - Bit 7]
-							   Default disabled */
+	enum saa7113_r08_htc *saa7113_r08_htc;
+	bool *saa7113_r10_vrln;
+	enum saa7113_r10_ofts *saa7113_r10_ofts;
+	enum saa7113_r12_rts *saa7113_r12_rts0;
+	enum saa7113_r12_rts *saa7113_r12_rts1;
+	bool *saa7113_r13_adlsb;
 };
 
 #endif
-- 
1.8.3.1

