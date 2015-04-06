Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:36511 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752989AbbDFL0i (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 6 Apr 2015 07:26:38 -0400
Subject: [PATCH 1/4] ir-keytable: clarify the meaning of ir protocols
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com
Date: Mon, 06 Apr 2015 13:26:03 +0200
Message-ID: <20150406112603.23289.17083.stgit@zeus.muc.hardeman.nu>
In-Reply-To: <20150406112326.23289.28902.stgit@zeus.muc.hardeman.nu>
References: <20150406112326.23289.28902.stgit@zeus.muc.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Clarify that ir protocols refer to the ones used by sysfs (e.g. "sony", not
"sony12" or "sony15") and replace a bunch of if-else protocol comparison
code with loops instead.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 utils/keytable/keytable.c |  408 +++++++++++++++++----------------------------
 1 file changed, 152 insertions(+), 256 deletions(-)

diff --git a/utils/keytable/keytable.c b/utils/keytable/keytable.c
index dcbfd83..2ca693f 100644
--- a/utils/keytable/keytable.c
+++ b/utils/keytable/keytable.c
@@ -25,6 +25,7 @@
 #include <sys/types.h>
 #include <dirent.h>
 #include <argp.h>
+#include <stdbool.h>
 
 #include "parse.h"
 
@@ -89,21 +90,88 @@ enum sysfs_ver {
 	VERSION_2,	/* has node protocols */
 };
 
-enum ir_protocols {
-	RC_5		= 1 << 0,
-	RC_6		= 1 << 1,
-	NEC		= 1 << 2,
-	JVC		= 1 << 3,
-	SONY		= 1 << 4,
-	LIRC		= 1 << 5,
-	SANYO		= 1 << 6,
-	RC_5_SZ		= 1 << 7,
-	SHARP		= 1 << 8,
-	MCE_KBD		= 1 << 9,
-	XMP		= 1 << 10,
-	OTHER		= 1 << 31,
+enum sysfs_protocols {
+	SYSFS_UNKNOWN		= (1 << 0),
+	SYSFS_OTHER		= (1 << 1),
+	SYSFS_LIRC		= (1 << 2),
+	SYSFS_RC5		= (1 << 3),
+	SYSFS_RC5_SZ		= (1 << 4),
+	SYSFS_JVC		= (1 << 5),
+	SYSFS_SONY		= (1 << 6),
+	SYSFS_NEC		= (1 << 7),
+	SYSFS_SANYO		= (1 << 8),
+	SYSFS_MCE_KBD		= (1 << 9),
+	SYSFS_RC6		= (1 << 10),
+	SYSFS_SHARP		= (1 << 11),
+	SYSFS_XMP		= (1 << 12),
+	SYSFS_INVALID		= 0,
 };
 
+struct protocol_map_entry {
+	const char *name;
+	enum sysfs_protocols sysfs_protocol;
+};
+
+const struct protocol_map_entry protocol_map[] = {
+	{ "unknown",	SYSFS_UNKNOWN	},
+	{ "other",	SYSFS_OTHER	},
+	{ "lirc",	SYSFS_LIRC	},
+	{ "rc-5",	SYSFS_RC5	},
+	{ "rc5",	SYSFS_RC5	},
+	{ "rc-5x",	SYSFS_INVALID	},
+	{ "rc5x",	SYSFS_INVALID	},
+	{ "jvc",	SYSFS_JVC	},
+	{ "sony",	SYSFS_SONY	},
+	{ "sony12",	SYSFS_INVALID	},
+	{ "sony15",	SYSFS_INVALID	},
+	{ "sony20",	SYSFS_INVALID	},
+	{ "nec",	SYSFS_NEC	},
+	{ "sanyo",	SYSFS_SANYO	},
+	{ "mce-kbd",	SYSFS_MCE_KBD	},
+	{ "mce_kbd",	SYSFS_MCE_KBD	},
+	{ "rc-6",	SYSFS_RC6	},
+	{ "rc6",	SYSFS_RC6	},
+	{ "rc-6-0",	SYSFS_INVALID	},
+	{ "rc-6-6a-20",	SYSFS_INVALID	},
+	{ "rc-6-6a-24",	SYSFS_INVALID	},
+	{ "rc-6-6a-32",	SYSFS_INVALID	},
+	{ "rc-6-mce",	SYSFS_INVALID	},
+	{ "sharp",	SYSFS_SHARP	},
+	{ "xmp",	SYSFS_XMP	},
+	{ NULL,		SYSFS_INVALID	},
+};
+
+static enum sysfs_protocols parse_sysfs_protocol(const char *name, bool all_allowed)
+{
+	const struct protocol_map_entry *pme;
+
+	if (!name)
+		return SYSFS_INVALID;
+
+	if (all_allowed && !strcasecmp(name, "all"))
+		return ~0;
+
+	for (pme = protocol_map; pme->name; pme++) {
+		if (!strcasecmp(name, pme->name))
+			return pme->sysfs_protocol;
+	}
+
+	return SYSFS_INVALID;
+}
+
+static void write_sysfs_protocols(enum sysfs_protocols protocols, FILE *fp, const char *fmt)
+{
+	const struct protocol_map_entry *pme;
+
+	for (pme = protocol_map; pme->name; pme++) {
+		if (!(protocols & pme->sysfs_protocol))
+			continue;
+
+		fprintf(fp, fmt, pme->name);
+		protocols &= ~pme->sysfs_protocol;
+	}
+}
+
 static int parse_code(char *string)
 {
 	struct parse_event *p;
@@ -166,7 +234,7 @@ static int debug = 0;
 static int test = 0;
 static int delay = 0;
 static int period = 0;
-static enum ir_protocols ch_proto = 0;
+static enum sysfs_protocols ch_proto = 0;
 
 struct keytable keys = {
 	.codes = {0, 0},
@@ -196,7 +264,7 @@ struct rc_device {
 
 	enum sysfs_ver version; /* sysfs version */
 	enum rc_type type;	/* Software (raw) or hardware decoder */
-	enum ir_protocols supported, current; /* Current and supported IR protocols */
+	enum sysfs_protocols supported, current; /* Current and supported IR protocols */
 };
 
 struct keytable *nextkey = &keys;
@@ -237,37 +305,20 @@ static error_t parse_keyfile(char *fname, char **table)
 					strcpy(*table, p);
 				} else if (!strcmp(p, "type")) {
 					p = strtok(NULL, " ,\n");
-					do {
-						if (!p)
-							goto err_einval;
-						if (!strcasecmp(p,"rc5") || !strcasecmp(p,"rc-5"))
-							ch_proto |= RC_5;
-						else if (!strcasecmp(p,"rc6") || !strcasecmp(p,"rc-6") || !strcasecmp(p,"rc6-mce") || !strcasecmp(p,"rc6_mce"))
-							ch_proto |= RC_6;
-						else if (!strcasecmp(p,"nec"))
-							ch_proto |= NEC;
-						else if (!strcasecmp(p,"jvc"))
-							ch_proto |= JVC;
-						else if (!strcasecmp(p,"sony"))
-							ch_proto |= SONY;
-						else if (!strcasecmp(p,"sanyo"))
-							ch_proto |= SANYO;
-						else if (!strcasecmp(p,"rc-5-sz"))
-							ch_proto |= RC_5_SZ;
-						else if (!strcasecmp(p,"sharp"))
-							ch_proto |= SHARP;
-						else if (!strcasecmp(p,"mce-kbd"))
-							ch_proto |= MCE_KBD;
-						else if (!strcasecmp(p,"xmp"))
-							ch_proto |= XMP;
-						else if (!strcasecmp(p,"other") || !strcasecmp(p,"unknown"))
-							ch_proto |= OTHER;
-						else {
+					if (!p)
+						goto err_einval;
+
+					while (p) {
+						enum sysfs_protocols protocol;
+
+						protocol = parse_sysfs_protocol(p, false);
+						if (protocol == SYSFS_INVALID) {
 							fprintf(stderr, _("Protocol %s invalid\n"), p);
 							goto err_einval;
 						}
+						ch_proto |= protocol;
 						p = strtok(NULL, " ,\n");
-					} while (p);
+					}
 				} else {
 					goto err_einval;
 				}
@@ -477,38 +528,15 @@ static error_t parse_opt(int k, char *arg, struct argp_state *state)
 		} while (p);
 		break;
 	case 'p':
-		p = strtok(arg, ",;");
-		do {
-			if (!p)
-				goto err_inval;
-			if (!strcasecmp(p,"rc5") || !strcasecmp(p,"rc-5"))
-				ch_proto |= RC_5;
-			else if (!strcasecmp(p,"rc6") || !strcasecmp(p,"rc-6"))
-				ch_proto |= RC_6;
-			else if (!strcasecmp(p,"nec"))
-				ch_proto |= NEC;
-			else if (!strcasecmp(p,"jvc"))
-				ch_proto |= JVC;
-			else if (!strcasecmp(p,"sony"))
-				ch_proto |= SONY;
-			else if (!strcasecmp(p,"sanyo"))
-				ch_proto |= SANYO;
-			else if (!strcasecmp(p,"lirc"))
-				ch_proto |= LIRC;
-			else if (!strcasecmp(p,"rc-5-sz"))
-				ch_proto |= RC_5_SZ;
-			else if (!strcasecmp(p,"sharp"))
-				ch_proto |= RC_5_SZ;
-			else if (!strcasecmp(p,"mce-kbd"))
-				ch_proto |= RC_5_SZ;
-			else if (!strcasecmp(p,"xmp"))
-				ch_proto |= XMP;
-			else if (!strcasecmp(p,"all"))
-				ch_proto |= ~0;
-			else
+		for (p = strtok(arg, ",;"); p; p = strtok(NULL, ",;")) {
+			enum sysfs_protocols protocol;
+
+			protocol = parse_sysfs_protocol(p, true);
+			if (protocol == SYSFS_INVALID)
 				goto err_inval;
-			p = strtok(NULL, ",;");
-		} while (p);
+
+			ch_proto |= protocol;
+		}
 		break;
 	case '?':
 		argp_state_help(state, state->out_stream,
@@ -754,11 +782,11 @@ static struct sysfs_names *find_device(char *name)
 	return names;
 }
 
-static enum ir_protocols v1_get_hw_protocols(char *name)
+static enum sysfs_protocols v1_get_hw_protocols(char *name)
 {
 	FILE *fp;
 	char *p, buf[4096];
-	enum ir_protocols proto = 0;
+	enum sysfs_protocols protocols = 0;
 
 	fp = fopen(name, "r");
 	if (!fp) {
@@ -772,39 +800,22 @@ static enum ir_protocols v1_get_hw_protocols(char *name)
 		return 0;
 	}
 
-	p = strtok(buf, " \n");
-	while (p) {
+	for (p = strtok(buf, " \n"); p; p = strtok(NULL, " \n")) {
+		enum sysfs_protocols protocol;
+
 		if (debug)
 			fprintf(stderr, _("%s protocol %s\n"), name, p);
-		if (!strcmp(p, "rc-5"))
-			proto |= RC_5;
-		else if (!strcmp(p, "rc-6"))
-			proto |= RC_6;
-		else if (!strcmp(p, "nec"))
-			proto |= NEC;
-		else if (!strcmp(p, "jvc"))
-			proto |= JVC;
-		else if (!strcmp(p, "sony"))
-			proto |= SONY;
-		else if (!strcmp(p, "sanyo"))
-			proto |= SANYO;
-		else if (!strcmp(p, "rc-5-sz"))
-			proto |= RC_5_SZ;
-		else if (!strcmp(p, "sharp"))
-			proto |= SHARP;
-		else if (!strcmp(p, "mce-kbd"))
-			proto |= MCE_KBD;
-		else if (!strcmp(p, "xmp"))
-			proto |= XMP;
-		else
-			proto |= OTHER;
-
-		p = strtok(NULL, " \n");
+
+		protocol = parse_sysfs_protocol(p, false);
+		if (protocol == SYSFS_INVALID)
+			protocol = SYSFS_OTHER;
+
+		protocols |= protocol;
 	}
 
 	fclose(fp);
 
-	return proto;
+	return protocols;
 }
 
 static int v1_set_hw_protocols(struct rc_device *rc_dev)
@@ -821,38 +832,7 @@ static int v1_set_hw_protocols(struct rc_device *rc_dev)
 		return errno;
 	}
 
-	if (rc_dev->current & RC_5)
-		fprintf(fp, "rc-5 ");
-
-	if (rc_dev->current & RC_6)
-		fprintf(fp, "rc-6 ");
-
-	if (rc_dev->current & NEC)
-		fprintf(fp, "nec ");
-
-	if (rc_dev->current & JVC)
-		fprintf(fp, "jvc ");
-
-	if (rc_dev->current & SONY)
-		fprintf(fp, "sony ");
-
-	if (rc_dev->current & SANYO)
-		fprintf(fp, "sanyo ");
-
-	if (rc_dev->current & RC_5_SZ)
-		fprintf(fp, "rc-5-sz ");
-
-	if (rc_dev->current & SHARP)
-		fprintf(fp, "sharp ");
-
-	if (rc_dev->current & MCE_KBD)
-		fprintf(fp, "mce_kbd ");
-
-	if (rc_dev->current & XMP)
-		fprintf(fp, "xmp ");
-
-	if (rc_dev->current & OTHER)
-		fprintf(fp, "unknown ");
+	write_sysfs_protocols(rc_dev->current, fp, "%s ");
 
 	fprintf(fp, "\n");
 
@@ -934,12 +914,11 @@ static int v1_set_sw_enabled_protocol(struct rc_device *rc_dev,
 	return 0;
 }
 
-static enum ir_protocols v2_get_protocols(struct rc_device *rc_dev, char *name)
+static enum sysfs_protocols v2_get_protocols(struct rc_device *rc_dev, char *name)
 {
 	FILE *fp;
 	char *p, buf[4096];
 	int enabled;
-	enum ir_protocols proto;
 
 	fp = fopen(name, "r");
 	if (!fp) {
@@ -953,8 +932,9 @@ static enum ir_protocols v2_get_protocols(struct rc_device *rc_dev, char *name)
 		return 0;
 	}
 
-	p = strtok(buf, " \n");
-	while (p) {
+	for (p = strtok(buf, " \n"); p; p = strtok(NULL, " \n")) {
+		enum sysfs_protocols protocol;
+
 		if (*p == '[') {
 			enabled = 1;
 			p++;
@@ -966,36 +946,14 @@ static enum ir_protocols v2_get_protocols(struct rc_device *rc_dev, char *name)
 			fprintf(stderr, _("%s protocol %s (%s)\n"), name, p,
 				enabled? _("enabled") : _("disabled"));
 
-		if (!strcmp(p, "rc-5"))
-			proto = RC_5;
-		else if (!strcmp(p, "rc-6"))
-			proto = RC_6;
-		else if (!strcmp(p, "nec"))
-			proto = NEC;
-		else if (!strcmp(p, "jvc"))
-			proto = JVC;
-		else if (!strcmp(p, "sony"))
-			proto = SONY;
-		else if (!strcmp(p, "sanyo"))
-			proto = SANYO;
-		else if (!strcmp(p, "lirc"))	/* Only V2 has LIRC support */
-			proto = LIRC;
-		else if (!strcmp(p, "rc-5-sz"))
-			proto = RC_5_SZ;
-		else if (!strcmp(p, "sharp"))
-			proto = SHARP;
-		else if (!strcmp(p, "mce-kbd"))
-			proto = MCE_KBD;
-		else if (!strcmp(p, "xmp"))
-			proto = XMP;
-		else
-			proto = OTHER;
-
-		rc_dev->supported |= proto;
+		protocol = parse_sysfs_protocol(p, false);
+		if (protocol == SYSFS_INVALID)
+			protocol = SYSFS_OTHER;
+
+		rc_dev->supported |= protocol;
 		if (enabled)
-			rc_dev->current |= proto;
+			rc_dev->current |= protocol;
 
-		p = strtok(NULL, " \n");
 	}
 
 	fclose(fp);
@@ -1020,41 +978,7 @@ static int v2_set_protocols(struct rc_device *rc_dev)
 	/* Disable all protocols */
 	fprintf(fp, "none\n");
 
-	if (rc_dev->current & RC_5)
-		fprintf(fp, "+rc-5\n");
-
-	if (rc_dev->current & RC_6)
-		fprintf(fp, "+rc-6\n");
-
-	if (rc_dev->current & NEC)
-		fprintf(fp, "+nec\n");
-
-	if (rc_dev->current & JVC)
-		fprintf(fp, "+jvc\n");
-
-	if (rc_dev->current & SONY)
-		fprintf(fp, "+sony\n");
-
-	if (rc_dev->current & SANYO)
-		fprintf(fp, "+sanyo\n");
-
-	if (rc_dev->current & LIRC)
-		fprintf(fp, "+lirc\n");
-
-	if (rc_dev->current & RC_5_SZ)
-		fprintf(fp, "+rc-5-sz\n");
-
-	if (rc_dev->current & SHARP)
-		fprintf(fp, "+sharp\n");
-
-	if (rc_dev->current & MCE_KBD)
-		fprintf(fp, "+mce-kbd\n");
-
-	if (rc_dev->current & XMP)
-		fprintf(fp, "+xmp\n");
-
-	if (rc_dev->current & OTHER)
-		fprintf(fp, "+unknown\n");
+	write_sysfs_protocols(rc_dev->current, fp, "+%s\n");
 
 	if (fclose(fp)) {
 		perror(name);
@@ -1064,34 +988,6 @@ static int v2_set_protocols(struct rc_device *rc_dev)
 	return 0;
 }
 
-static void show_proto(	enum ir_protocols proto)
-{
-	if (proto & NEC)
-		fprintf (stderr, "NEC ");
-	if (proto & RC_5)
-		fprintf (stderr, "RC-5 ");
-	if (proto & RC_6)
-		fprintf (stderr, "RC-6 ");
-	if (proto & JVC)
-		fprintf (stderr, "JVC ");
-	if (proto & SONY)
-		fprintf (stderr, "SONY ");
-	if (proto & SANYO)
-		fprintf (stderr, "SANYO ");
-	if (proto & LIRC)
-		fprintf (stderr, "LIRC ");
-	if (proto & RC_5_SZ)
-		fprintf (stderr, "RC-5-SZ ");
-	if (proto & SHARP)
-		fprintf (stderr, "SHARP ");
-	if (proto & MCE_KBD)
-		fprintf (stderr, "MCE_KBD ");
-	if (proto & XMP)
-		fprintf (stderr, "XMP ");
-	if (proto & OTHER)
-		fprintf (stderr, _("other "));
-}
-
 static int get_attribs(struct rc_device *rc_dev, char *sysfs_name)
 {
 	struct uevents  *uevent;
@@ -1189,29 +1085,29 @@ static int get_attribs(struct rc_device *rc_dev, char *sysfs_name)
 			rc_dev->version = VERSION_1;
 			rc_dev->supported = v1_get_hw_protocols(cur->name);
 		} else if (strstr(cur->name, "/nec_decoder")) {
-			rc_dev->supported |= NEC;
+			rc_dev->supported |= SYSFS_NEC;
 			if (v1_get_sw_enabled_protocol(cur->name))
-				rc_dev->current |= NEC;
+				rc_dev->current |= SYSFS_NEC;
 		} else if (strstr(cur->name, "/rc5_decoder")) {
-			rc_dev->supported |= RC_5;
+			rc_dev->supported |= SYSFS_RC5;
 			if (v1_get_sw_enabled_protocol(cur->name))
-				rc_dev->current |= RC_5;
+				rc_dev->current |= SYSFS_RC5;
 		} else if (strstr(cur->name, "/rc6_decoder")) {
-			rc_dev->supported |= RC_6;
+			rc_dev->supported |= SYSFS_RC6;
 			if (v1_get_sw_enabled_protocol(cur->name))
-				rc_dev->current |= RC_6;
+				rc_dev->current |= SYSFS_RC6;
 		} else if (strstr(cur->name, "/jvc_decoder")) {
-			rc_dev->supported |= JVC;
+			rc_dev->supported |= SYSFS_JVC;
 			if (v1_get_sw_enabled_protocol(cur->name))
-				rc_dev->current |= JVC;
+				rc_dev->current |= SYSFS_JVC;
 		} else if (strstr(cur->name, "/sony_decoder")) {
-			rc_dev->supported |= SONY;
+			rc_dev->supported |= SYSFS_SONY;
 			if (v1_get_sw_enabled_protocol(cur->name))
-				rc_dev->current |= SONY;
+				rc_dev->current |= SYSFS_SONY;
 		} else if (strstr(cur->name, "/xmp_decoder")) {
-			rc_dev->supported |= XMP;
+			rc_dev->supported |= SYSFS_XMP;
 			if (v1_get_sw_enabled_protocol(cur->name))
-				rc_dev->current |= XMP;
+				rc_dev->current |= SYSFS_XMP;
 		}
 	}
 
@@ -1234,24 +1130,24 @@ static int set_proto(struct rc_device *rc_dev)
 	}
 
 	if (rc_dev->type == SOFTWARE_DECODER) {
-		if (rc_dev->supported & NEC)
+		if (rc_dev->supported & SYSFS_NEC)
 			rc += v1_set_sw_enabled_protocol(rc_dev, "/nec_decoder",
-						      rc_dev->current & NEC);
-		if (rc_dev->supported & RC_5)
+						      rc_dev->current & SYSFS_NEC);
+		if (rc_dev->supported & SYSFS_RC5)
 			rc += v1_set_sw_enabled_protocol(rc_dev, "/rc5_decoder",
-						      rc_dev->current & RC_5);
-		if (rc_dev->supported & RC_6)
+						      rc_dev->current & SYSFS_RC5);
+		if (rc_dev->supported & SYSFS_RC6)
 			rc += v1_set_sw_enabled_protocol(rc_dev, "/rc6_decoder",
-						      rc_dev->current & RC_6);
-		if (rc_dev->supported & JVC)
+						      rc_dev->current & SYSFS_RC6);
+		if (rc_dev->supported & SYSFS_JVC)
 			rc += v1_set_sw_enabled_protocol(rc_dev, "/jvc_decoder",
-						      rc_dev->current & JVC);
-		if (rc_dev->supported & SONY)
+						      rc_dev->current & SYSFS_JVC);
+		if (rc_dev->supported & SYSFS_SONY)
 			rc += v1_set_sw_enabled_protocol(rc_dev, "/sony_decoder",
-						      rc_dev->current & SONY);
-		if (rc_dev->supported & XMP)
+						      rc_dev->current & SYSFS_SONY);
+		if (rc_dev->supported & SYSFS_XMP)
 			rc += v1_set_sw_enabled_protocol(rc_dev, "/xmp_decoder",
-						      rc_dev->current & XMP);
+						      rc_dev->current & SYSFS_XMP);
 	} else {
 		rc = v1_set_hw_protocols(rc_dev);
 	}
@@ -1338,7 +1234,7 @@ static void display_proto(struct rc_device *rc_dev)
 		fprintf(stderr, _("Current protocols: "));
 	else
 		fprintf(stderr, _("Enabled protocols: "));
-	show_proto(rc_dev->current);
+	write_sysfs_protocols(rc_dev->current, stderr, "%s ");
 	fprintf(stderr, "\n");
 }
 
@@ -1548,7 +1444,7 @@ static int show_sysfs_attribs(struct rc_device *rc_dev)
 				rc_dev->drv_name,
 				rc_dev->keytable_name);
 			fprintf(stderr, _("\tSupported protocols: "));
-			show_proto(rc_dev->supported);
+			write_sysfs_protocols(rc_dev->supported, stderr, "%s ");
 			fprintf(stderr, "\n\t");
 			display_proto(rc_dev);
 			fd = open(rc_dev->input_name, O_RDONLY);
@@ -1706,7 +1602,7 @@ int main(int argc, char *argv[])
 			fprintf(stderr, _("Couldn't change the IR protocols\n"));
 		else {
 			fprintf(stderr, _("Protocols changed to "));
-			show_proto(rc_dev.current);
+			write_sysfs_protocols(rc_dev.current, stderr, "%s ");
 			fprintf(stderr, "\n");
 		}
 	}

