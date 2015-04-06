Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:36513 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752989AbbDFL0m (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 6 Apr 2015 07:26:42 -0400
Subject: [PATCH 2/4] ir-keytable: replace more sysfs if-else code with loops
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com
Date: Mon, 06 Apr 2015 13:26:08 +0200
Message-ID: <20150406112608.23289.58902.stgit@zeus.muc.hardeman.nu>
In-Reply-To: <20150406112326.23289.28902.stgit@zeus.muc.hardeman.nu>
References: <20150406112326.23289.28902.stgit@zeus.muc.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Document the sysfs1 interface in protocol_map[] and replace some
more if-else code with loops.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 utils/keytable/keytable.c |  124 ++++++++++++++++++++-------------------------
 1 file changed, 55 insertions(+), 69 deletions(-)

diff --git a/utils/keytable/keytable.c b/utils/keytable/keytable.c
index 2ca693f..949eed9 100644
--- a/utils/keytable/keytable.c
+++ b/utils/keytable/keytable.c
@@ -109,36 +109,37 @@ enum sysfs_protocols {
 
 struct protocol_map_entry {
 	const char *name;
+	const char *sysfs1_name;
 	enum sysfs_protocols sysfs_protocol;
 };
 
 const struct protocol_map_entry protocol_map[] = {
-	{ "unknown",	SYSFS_UNKNOWN	},
-	{ "other",	SYSFS_OTHER	},
-	{ "lirc",	SYSFS_LIRC	},
-	{ "rc-5",	SYSFS_RC5	},
-	{ "rc5",	SYSFS_RC5	},
-	{ "rc-5x",	SYSFS_INVALID	},
-	{ "rc5x",	SYSFS_INVALID	},
-	{ "jvc",	SYSFS_JVC	},
-	{ "sony",	SYSFS_SONY	},
-	{ "sony12",	SYSFS_INVALID	},
-	{ "sony15",	SYSFS_INVALID	},
-	{ "sony20",	SYSFS_INVALID	},
-	{ "nec",	SYSFS_NEC	},
-	{ "sanyo",	SYSFS_SANYO	},
-	{ "mce-kbd",	SYSFS_MCE_KBD	},
-	{ "mce_kbd",	SYSFS_MCE_KBD	},
-	{ "rc-6",	SYSFS_RC6	},
-	{ "rc6",	SYSFS_RC6	},
-	{ "rc-6-0",	SYSFS_INVALID	},
-	{ "rc-6-6a-20",	SYSFS_INVALID	},
-	{ "rc-6-6a-24",	SYSFS_INVALID	},
-	{ "rc-6-6a-32",	SYSFS_INVALID	},
-	{ "rc-6-mce",	SYSFS_INVALID	},
-	{ "sharp",	SYSFS_SHARP	},
-	{ "xmp",	SYSFS_XMP	},
-	{ NULL,		SYSFS_INVALID	},
+	{ "unknown",	NULL,		SYSFS_UNKNOWN	},
+	{ "other",	NULL,		SYSFS_OTHER	},
+	{ "lirc",	NULL,		SYSFS_LIRC	},
+	{ "rc-5",	"/rc5_decoder",	SYSFS_RC5	},
+	{ "rc5",	NULL,		SYSFS_RC5	},
+	{ "rc-5x",	NULL,		SYSFS_INVALID	},
+	{ "rc5x",	NULL,		SYSFS_INVALID	},
+	{ "jvc",	"/jvc_decoder",	SYSFS_JVC	},
+	{ "sony",	"/sony_decoder",SYSFS_SONY	},
+	{ "sony12",	NULL,		SYSFS_INVALID	},
+	{ "sony15",	NULL,		SYSFS_INVALID	},
+	{ "sony20",	NULL,		SYSFS_INVALID	},
+	{ "nec",	"/nec_decoder",	SYSFS_NEC	},
+	{ "sanyo",	NULL,		SYSFS_SANYO	},
+	{ "mce-kbd",	NULL,		SYSFS_MCE_KBD	},
+	{ "mce_kbd",	NULL,		SYSFS_MCE_KBD	},
+	{ "rc-6",	"/rc6_decoder",	SYSFS_RC6	},
+	{ "rc6",	NULL,		SYSFS_RC6	},
+	{ "rc-6-0",	NULL,		SYSFS_INVALID	},
+	{ "rc-6-6a-20",	NULL,		SYSFS_INVALID	},
+	{ "rc-6-6a-24",	NULL,		SYSFS_INVALID	},
+	{ "rc-6-6a-32",	NULL,		SYSFS_INVALID	},
+	{ "rc-6-mce",	NULL,		SYSFS_INVALID	},
+	{ "sharp",	NULL,		SYSFS_SHARP	},
+	{ "xmp",	"/xmp_decoder",	SYSFS_XMP	},
+	{ NULL,		NULL,		SYSFS_INVALID	},
 };
 
 static enum sysfs_protocols parse_sysfs_protocol(const char *name, bool all_allowed)
@@ -886,7 +887,7 @@ static int v1_get_sw_enabled_protocol(char *dirname)
 }
 
 static int v1_set_sw_enabled_protocol(struct rc_device *rc_dev,
-				   char *dirname, int enabled)
+				      const char *dirname, int enabled)
 {
 	FILE *fp;
 	char name[512];
@@ -1084,30 +1085,20 @@ static int get_attribs(struct rc_device *rc_dev, char *sysfs_name)
 		} else if (strstr(cur->name, "/supported_protocols")) {
 			rc_dev->version = VERSION_1;
 			rc_dev->supported = v1_get_hw_protocols(cur->name);
-		} else if (strstr(cur->name, "/nec_decoder")) {
-			rc_dev->supported |= SYSFS_NEC;
-			if (v1_get_sw_enabled_protocol(cur->name))
-				rc_dev->current |= SYSFS_NEC;
-		} else if (strstr(cur->name, "/rc5_decoder")) {
-			rc_dev->supported |= SYSFS_RC5;
-			if (v1_get_sw_enabled_protocol(cur->name))
-				rc_dev->current |= SYSFS_RC5;
-		} else if (strstr(cur->name, "/rc6_decoder")) {
-			rc_dev->supported |= SYSFS_RC6;
-			if (v1_get_sw_enabled_protocol(cur->name))
-				rc_dev->current |= SYSFS_RC6;
-		} else if (strstr(cur->name, "/jvc_decoder")) {
-			rc_dev->supported |= SYSFS_JVC;
-			if (v1_get_sw_enabled_protocol(cur->name))
-				rc_dev->current |= SYSFS_JVC;
-		} else if (strstr(cur->name, "/sony_decoder")) {
-			rc_dev->supported |= SYSFS_SONY;
-			if (v1_get_sw_enabled_protocol(cur->name))
-				rc_dev->current |= SYSFS_SONY;
-		} else if (strstr(cur->name, "/xmp_decoder")) {
-			rc_dev->supported |= SYSFS_XMP;
-			if (v1_get_sw_enabled_protocol(cur->name))
-				rc_dev->current |= SYSFS_XMP;
+		} else {
+			const struct protocol_map_entry *pme;
+
+			for (pme = protocol_map; pme->name; pme++) {
+				if (!pme->sysfs1_name)
+					continue;
+
+				if (strstr(cur->name, pme->sysfs1_name)) {
+					rc_dev->supported |= pme->sysfs_protocol;
+					if (v1_get_sw_enabled_protocol(cur->name))
+						rc_dev->supported |= pme->sysfs_protocol;
+					break;
+				}
+			}
 		}
 	}
 
@@ -1130,24 +1121,19 @@ static int set_proto(struct rc_device *rc_dev)
 	}
 
 	if (rc_dev->type == SOFTWARE_DECODER) {
-		if (rc_dev->supported & SYSFS_NEC)
-			rc += v1_set_sw_enabled_protocol(rc_dev, "/nec_decoder",
-						      rc_dev->current & SYSFS_NEC);
-		if (rc_dev->supported & SYSFS_RC5)
-			rc += v1_set_sw_enabled_protocol(rc_dev, "/rc5_decoder",
-						      rc_dev->current & SYSFS_RC5);
-		if (rc_dev->supported & SYSFS_RC6)
-			rc += v1_set_sw_enabled_protocol(rc_dev, "/rc6_decoder",
-						      rc_dev->current & SYSFS_RC6);
-		if (rc_dev->supported & SYSFS_JVC)
-			rc += v1_set_sw_enabled_protocol(rc_dev, "/jvc_decoder",
-						      rc_dev->current & SYSFS_JVC);
-		if (rc_dev->supported & SYSFS_SONY)
-			rc += v1_set_sw_enabled_protocol(rc_dev, "/sony_decoder",
-						      rc_dev->current & SYSFS_SONY);
-		if (rc_dev->supported & SYSFS_XMP)
-			rc += v1_set_sw_enabled_protocol(rc_dev, "/xmp_decoder",
-						      rc_dev->current & SYSFS_XMP);
+		const struct protocol_map_entry *pme;
+
+		for (pme = protocol_map; pme->name; pme++) {
+			if (!pme->sysfs1_name)
+				continue;
+
+			if (!(rc_dev->supported & pme->sysfs_protocol))
+				continue;
+
+			rc += v1_set_sw_enabled_protocol(rc_dev, pme->sysfs1_name,
+							 rc_dev->current & pme->sysfs_protocol);
+		}
+
 	} else {
 		rc = v1_set_hw_protocols(rc_dev);
 	}

