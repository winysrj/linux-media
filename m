Return-path: <linux-media-owner@vger.kernel.org>
Received: from multi.imgtec.com ([194.200.65.239]:53939 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753410Ab3LMPPA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Dec 2013 10:15:00 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	<linux-media@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 09/11] media: rc: add Sharp infrared protocol
Date: Fri, 13 Dec 2013 15:12:57 +0000
Message-ID: <1386947579-26703-10-git-send-email-james.hogan@imgtec.com>
In-Reply-To: <1386947579-26703-1-git-send-email-james.hogan@imgtec.com>
References: <1386947579-26703-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add Sharp infrared protocol constants RC_TYPE_SHARP and RC_BIT_SHARP.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org
---
 drivers/media/rc/rc-main.c | 1 +
 include/media/rc-map.h     | 4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 46da365c9c84..a1b90ef45910 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -786,6 +786,7 @@ static struct {
 	  RC_BIT_SONY20,	"sony"		},
 	{ RC_BIT_RC5_SZ,	"rc-5-sz"	},
 	{ RC_BIT_SANYO,		"sanyo"		},
+	{ RC_BIT_SHARP,		"sharp"		},
 	{ RC_BIT_MCE_KBD,	"mce_kbd"	},
 	{ RC_BIT_LIRC,		"lirc"		},
 };
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index a20ed97d7d8a..b3224edf1b46 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -30,6 +30,7 @@ enum rc_type {
 	RC_TYPE_RC6_6A_24	= 15,	/* Philips RC6-6A-24 protocol */
 	RC_TYPE_RC6_6A_32	= 16,	/* Philips RC6-6A-32 protocol */
 	RC_TYPE_RC6_MCE		= 17,	/* MCE (Philips RC6-6A-32 subtype) protocol */
+	RC_TYPE_SHARP		= 18,	/* Sharp protocol */
 };
 
 #define RC_BIT_NONE		0
@@ -51,6 +52,7 @@ enum rc_type {
 #define RC_BIT_RC6_6A_24	(1 << RC_TYPE_RC6_6A_24)
 #define RC_BIT_RC6_6A_32	(1 << RC_TYPE_RC6_6A_32)
 #define RC_BIT_RC6_MCE		(1 << RC_TYPE_RC6_MCE)
+#define RC_BIT_SHARP		(1 << RC_TYPE_SHARP)
 
 #define RC_BIT_ALL	(RC_BIT_UNKNOWN | RC_BIT_OTHER | RC_BIT_LIRC | \
 			 RC_BIT_RC5 | RC_BIT_RC5X | RC_BIT_RC5_SZ | \
@@ -58,7 +60,7 @@ enum rc_type {
 			 RC_BIT_SONY12 | RC_BIT_SONY15 | RC_BIT_SONY20 | \
 			 RC_BIT_NEC | RC_BIT_SANYO | RC_BIT_MCE_KBD | \
 			 RC_BIT_RC6_0 | RC_BIT_RC6_6A_20 | RC_BIT_RC6_6A_24 | \
-			 RC_BIT_RC6_6A_32 | RC_BIT_RC6_MCE)
+			 RC_BIT_RC6_6A_32 | RC_BIT_RC6_MCE | RC_BIT_SHARP)
 
 struct rc_map_table {
 	u32	scancode;
-- 
1.8.1.2


