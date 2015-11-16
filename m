Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:36057 "EHLO
	mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126AbbKPTyM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Nov 2015 14:54:12 -0500
Received: by wmww144 with SMTP id w144so125652892wmw.1
        for <linux-media@vger.kernel.org>; Mon, 16 Nov 2015 11:54:11 -0800 (PST)
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 7/8] media: rc: improve RC_BIT_ constant definition
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org,
	=?UTF-8?Q?David_H=c3=a4rdeman?= <david@hardeman.nu>
Message-ID: <564A3440.7020400@gmail.com>
Date: Mon, 16 Nov 2015 20:53:36 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The RC_BIT_ constants are used in 64-bit bitmaps.
In case of > 32 RC_BIT_ constants the current code will fail
on 32-bit systems.
Therefore define the RC_BIT_ constants as unsigned long long.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 include/media/rc-map.h | 40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index 7c4bbc4..7844e98 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -33,26 +33,26 @@ enum rc_type {
 	RC_TYPE_XMP		= 18,	/* XMP protocol */
 };
 
-#define RC_BIT_NONE		0
-#define RC_BIT_UNKNOWN		(1 << RC_TYPE_UNKNOWN)
-#define RC_BIT_OTHER		(1 << RC_TYPE_OTHER)
-#define RC_BIT_RC5		(1 << RC_TYPE_RC5)
-#define RC_BIT_RC5X		(1 << RC_TYPE_RC5X)
-#define RC_BIT_RC5_SZ		(1 << RC_TYPE_RC5_SZ)
-#define RC_BIT_JVC		(1 << RC_TYPE_JVC)
-#define RC_BIT_SONY12		(1 << RC_TYPE_SONY12)
-#define RC_BIT_SONY15		(1 << RC_TYPE_SONY15)
-#define RC_BIT_SONY20		(1 << RC_TYPE_SONY20)
-#define RC_BIT_NEC		(1 << RC_TYPE_NEC)
-#define RC_BIT_SANYO		(1 << RC_TYPE_SANYO)
-#define RC_BIT_MCE_KBD		(1 << RC_TYPE_MCE_KBD)
-#define RC_BIT_RC6_0		(1 << RC_TYPE_RC6_0)
-#define RC_BIT_RC6_6A_20	(1 << RC_TYPE_RC6_6A_20)
-#define RC_BIT_RC6_6A_24	(1 << RC_TYPE_RC6_6A_24)
-#define RC_BIT_RC6_6A_32	(1 << RC_TYPE_RC6_6A_32)
-#define RC_BIT_RC6_MCE		(1 << RC_TYPE_RC6_MCE)
-#define RC_BIT_SHARP		(1 << RC_TYPE_SHARP)
-#define RC_BIT_XMP		(1 << RC_TYPE_XMP)
+#define RC_BIT_NONE		0ULL
+#define RC_BIT_UNKNOWN		(1ULL << RC_TYPE_UNKNOWN)
+#define RC_BIT_OTHER		(1ULL << RC_TYPE_OTHER)
+#define RC_BIT_RC5		(1ULL << RC_TYPE_RC5)
+#define RC_BIT_RC5X		(1ULL << RC_TYPE_RC5X)
+#define RC_BIT_RC5_SZ		(1ULL << RC_TYPE_RC5_SZ)
+#define RC_BIT_JVC		(1ULL << RC_TYPE_JVC)
+#define RC_BIT_SONY12		(1ULL << RC_TYPE_SONY12)
+#define RC_BIT_SONY15		(1ULL << RC_TYPE_SONY15)
+#define RC_BIT_SONY20		(1ULL << RC_TYPE_SONY20)
+#define RC_BIT_NEC		(1ULL << RC_TYPE_NEC)
+#define RC_BIT_SANYO		(1ULL << RC_TYPE_SANYO)
+#define RC_BIT_MCE_KBD		(1ULL << RC_TYPE_MCE_KBD)
+#define RC_BIT_RC6_0		(1ULL << RC_TYPE_RC6_0)
+#define RC_BIT_RC6_6A_20	(1ULL << RC_TYPE_RC6_6A_20)
+#define RC_BIT_RC6_6A_24	(1ULL << RC_TYPE_RC6_6A_24)
+#define RC_BIT_RC6_6A_32	(1ULL << RC_TYPE_RC6_6A_32)
+#define RC_BIT_RC6_MCE		(1ULL << RC_TYPE_RC6_MCE)
+#define RC_BIT_SHARP		(1ULL << RC_TYPE_SHARP)
+#define RC_BIT_XMP		(1ULL << RC_TYPE_XMP)
 
 #define RC_BIT_ALL	(RC_BIT_UNKNOWN | RC_BIT_OTHER | \
 			 RC_BIT_RC5 | RC_BIT_RC5X | RC_BIT_RC5_SZ | \
-- 
2.6.2

