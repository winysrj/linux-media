Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:56033 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751316AbcFRPC7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Jun 2016 11:02:59 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Kamil Debski <kamil@wypas.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv18 02/15] rc: Add HDMI CEC protocol handling
Date: Sat, 18 Jun 2016 17:02:35 +0200
Message-Id: <1466262168-12805-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1466262168-12805-1-git-send-email-hverkuil@xs4all.nl>
References: <1466262168-12805-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kamil Debski <kamil@wypas.org>

Add handling of remote control events coming from the HDMI CEC bus
and the new protocol required for that.

Signed-off-by: Kamil Debski <kamil@wypas.org>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/rc/rc-main.c | 1 +
 include/media/rc-map.h     | 5 ++++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 7dfc7c2..c717eaf 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -804,6 +804,7 @@ static const struct {
 	{ RC_BIT_SHARP,		"sharp",	"ir-sharp-decoder"	},
 	{ RC_BIT_MCE_KBD,	"mce_kbd",	"ir-mce_kbd-decoder"	},
 	{ RC_BIT_XMP,		"xmp",		"ir-xmp-decoder"	},
+	{ RC_BIT_CEC,		"cec",		NULL			},
 };
 
 /**
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index 7844e98..6e6557d 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -31,6 +31,7 @@ enum rc_type {
 	RC_TYPE_RC6_MCE		= 16,	/* MCE (Philips RC6-6A-32 subtype) protocol */
 	RC_TYPE_SHARP		= 17,	/* Sharp protocol */
 	RC_TYPE_XMP		= 18,	/* XMP protocol */
+	RC_TYPE_CEC		= 19,	/* CEC protocol */
 };
 
 #define RC_BIT_NONE		0ULL
@@ -53,6 +54,7 @@ enum rc_type {
 #define RC_BIT_RC6_MCE		(1ULL << RC_TYPE_RC6_MCE)
 #define RC_BIT_SHARP		(1ULL << RC_TYPE_SHARP)
 #define RC_BIT_XMP		(1ULL << RC_TYPE_XMP)
+#define RC_BIT_CEC		(1ULL << RC_TYPE_CEC)
 
 #define RC_BIT_ALL	(RC_BIT_UNKNOWN | RC_BIT_OTHER | \
 			 RC_BIT_RC5 | RC_BIT_RC5X | RC_BIT_RC5_SZ | \
@@ -61,7 +63,7 @@ enum rc_type {
 			 RC_BIT_NEC | RC_BIT_SANYO | RC_BIT_MCE_KBD | \
 			 RC_BIT_RC6_0 | RC_BIT_RC6_6A_20 | RC_BIT_RC6_6A_24 | \
 			 RC_BIT_RC6_6A_32 | RC_BIT_RC6_MCE | RC_BIT_SHARP | \
-			 RC_BIT_XMP)
+			 RC_BIT_XMP | RC_BIT_CEC)
 
 
 #define RC_SCANCODE_UNKNOWN(x)			(x)
@@ -123,6 +125,7 @@ void rc_map_init(void);
 #define RC_MAP_BEHOLD_COLUMBUS           "rc-behold-columbus"
 #define RC_MAP_BEHOLD                    "rc-behold"
 #define RC_MAP_BUDGET_CI_OLD             "rc-budget-ci-old"
+#define RC_MAP_CEC                       "rc-cec"
 #define RC_MAP_CINERGY_1400              "rc-cinergy-1400"
 #define RC_MAP_CINERGY                   "rc-cinergy"
 #define RC_MAP_DELOCK_61959              "rc-delock-61959"
-- 
2.8.1

