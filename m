Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44068 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965628AbcIHMEX (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2016 08:04:23 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Markus Heiser <markus.heiser@darmarit.de>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 13/47] [media] rc-map.h: document structs/enums on it
Date: Thu,  8 Sep 2016 09:03:35 -0300
Message-Id: <539f14e2e0b3af385c7dad53e8282651560fb78c.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are some structs/enums that aren't documented via
kernel-doc markup. Add documentation for them.

Fix those warnings:
./include/media/rc-map.h:103: WARNING: c:type reference target not found: rc_map_list
./include/media/rc-map.h:110: WARNING: c:type reference target not found: rc_map_list
./include/media/rc-map.h:117: WARNING: c:type reference target not found: rc_map

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 include/media/rc-map.h | 94 ++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 71 insertions(+), 23 deletions(-)

diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index daa75fcc1ff1..173ad58fb61b 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -11,27 +11,51 @@
 
 #include <linux/input.h>
 
+/**
+ * enum rc_type - type of the Remote Controller protocol
+ *
+ * @RC_TYPE_UNKNOWN: Protocol not known
+ * @RC_TYPE_OTHER: Protocol known but proprietary
+ * @RC_TYPE_RC5: Philips RC5 protocol
+ * @RC_TYPE_RC5X: Philips RC5x protocol
+ * @RC_TYPE_RC5_SZ: StreamZap variant of RC5
+ * @RC_TYPE_JVC: JVC protocol
+ * @RC_TYPE_SONY12: Sony 12 bit protocol
+ * @RC_TYPE_SONY15: Sony 15 bit protocol
+ * @RC_TYPE_SONY20: Sony 20 bit protocol
+ * @RC_TYPE_NEC: NEC protocol
+ * @RC_TYPE_SANYO: Sanyo protocol
+ * @RC_TYPE_MCE_KBD: RC6-ish MCE keyboard/mouse
+ * @RC_TYPE_RC6_0: Philips RC6-0-16 protocol
+ * @RC_TYPE_RC6_6A_20: Philips RC6-6A-20 protocol
+ * @RC_TYPE_RC6_6A_24: Philips RC6-6A-24 protocol
+ * @RC_TYPE_RC6_6A_32: Philips RC6-6A-32 protocol
+ * @RC_TYPE_RC6_MCE: MCE (Philips RC6-6A-32 subtype) protocol
+ * @RC_TYPE_SHARP: Sharp protocol
+ * @RC_TYPE_XMP: XMP protocol
+ * @RC_TYPE_CEC: CEC protocol
+ */
 enum rc_type {
-	RC_TYPE_UNKNOWN		= 0,	/* Protocol not known */
-	RC_TYPE_OTHER		= 1,	/* Protocol known but proprietary */
-	RC_TYPE_RC5		= 2,	/* Philips RC5 protocol */
-	RC_TYPE_RC5X		= 3,	/* Philips RC5x protocol */
-	RC_TYPE_RC5_SZ		= 4,	/* StreamZap variant of RC5 */
-	RC_TYPE_JVC		= 5,	/* JVC protocol */
-	RC_TYPE_SONY12		= 6,	/* Sony 12 bit protocol */
-	RC_TYPE_SONY15		= 7,	/* Sony 15 bit protocol */
-	RC_TYPE_SONY20		= 8,	/* Sony 20 bit protocol */
-	RC_TYPE_NEC		= 9,	/* NEC protocol */
-	RC_TYPE_SANYO		= 10,	/* Sanyo protocol */
-	RC_TYPE_MCE_KBD		= 11,	/* RC6-ish MCE keyboard/mouse */
-	RC_TYPE_RC6_0		= 12,	/* Philips RC6-0-16 protocol */
-	RC_TYPE_RC6_6A_20	= 13,	/* Philips RC6-6A-20 protocol */
-	RC_TYPE_RC6_6A_24	= 14,	/* Philips RC6-6A-24 protocol */
-	RC_TYPE_RC6_6A_32	= 15,	/* Philips RC6-6A-32 protocol */
-	RC_TYPE_RC6_MCE		= 16,	/* MCE (Philips RC6-6A-32 subtype) protocol */
-	RC_TYPE_SHARP		= 17,	/* Sharp protocol */
-	RC_TYPE_XMP		= 18,	/* XMP protocol */
-	RC_TYPE_CEC		= 19,	/* CEC protocol */
+	RC_TYPE_UNKNOWN		= 0,
+	RC_TYPE_OTHER		= 1,
+	RC_TYPE_RC5		= 2,
+	RC_TYPE_RC5X		= 3,
+	RC_TYPE_RC5_SZ		= 4,
+	RC_TYPE_JVC		= 5,
+	RC_TYPE_SONY12		= 6,
+	RC_TYPE_SONY15		= 7,
+	RC_TYPE_SONY20		= 8,
+	RC_TYPE_NEC		= 9,
+	RC_TYPE_SANYO		= 10,
+	RC_TYPE_MCE_KBD		= 11,
+	RC_TYPE_RC6_0		= 12,
+	RC_TYPE_RC6_6A_20	= 13,
+	RC_TYPE_RC6_6A_24	= 14,
+	RC_TYPE_RC6_6A_32	= 15,
+	RC_TYPE_RC6_MCE		= 16,
+	RC_TYPE_SHARP		= 17,
+	RC_TYPE_XMP		= 18,
+	RC_TYPE_CEC		= 19,
 };
 
 #define RC_BIT_NONE		0ULL
@@ -76,21 +100,45 @@ enum rc_type {
 #define RC_SCANCODE_RC6_0(sys, cmd)		(((sys) << 8) | (cmd))
 #define RC_SCANCODE_RC6_6A(vendor, sys, cmd)	(((vendor) << 16) | ((sys) << 8) | (cmd))
 
+/**
+ * struct rc_map_table - represents a scancode/keycode pair
+ *
+ * @scancode: scan code (u32)
+ * @keycode: Linux input keycode
+ */
 struct rc_map_table {
 	u32	scancode;
 	u32	keycode;
 };
 
+/**
+ * struct rc_map - represents a keycode map table
+ *
+ * @scan: pointer to struct &rc_map_table
+ * @size: Max number of entries
+ * @len: Number of entries that are in use
+ * @alloc: size of *scan, in bytes
+ * @rc_type: type of the remote controller protocol, as defined at
+ *	     enum &rc_type
+ * @name: name of the key map table
+ * @lock: lock to protect access to this structure
+ */
 struct rc_map {
 	struct rc_map_table	*scan;
-	unsigned int		size;	/* Max number of entries */
-	unsigned int		len;	/* Used number of entries */
-	unsigned int		alloc;	/* Size of *scan in bytes */
+	unsigned int		size;
+	unsigned int		len;
+	unsigned int		alloc;
 	enum rc_type		rc_type;
 	const char		*name;
 	spinlock_t		lock;
 };
 
+/**
+ * struct rc_map_list - list of the registered &rc_map maps
+ *
+ * @list: pointer to struct &list_head
+ * @map: pointer to struct &rc_map
+ */
 struct rc_map_list {
 	struct list_head	 list;
 	struct rc_map map;
-- 
2.7.4


