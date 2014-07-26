Return-path: <linux-media-owner@vger.kernel.org>
Received: from doortje.mesa.nl ([83.161.67.157]:45865 "EHLO mesa.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752283AbaGZUr0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Jul 2014 16:47:26 -0400
Received: from joshua.mesa.nl (localhost.localdomain [127.0.0.1])
	by mesa.nl (8.12.11/8.12.8) with ESMTP id s6QKlPXF021592
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sat, 26 Jul 2014 22:47:25 +0200
Received: (from marcel@localhost)
	by joshua.mesa.nl (8.12.11/8.12.8/Submit) id s6QKlPAk021590
	for linux-media@vger.kernel.org; Sat, 26 Jul 2014 22:47:25 +0200
Date: Sat, 26 Jul 2014 22:47:25 +0200
From: "Marcel J.E. Mol" <marcel@mesa.nl>
To: linux-media@vger.kernel.org
Subject: [PATCH] [v4l-utils] keytable: add support for XMP IR protocol
Message-ID: <20140726204725.GA21580@joshua.mesa.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Marcel Mol <marcel@mesa.nl>
---
 utils/keytable/keytable.c | 27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/utils/keytable/keytable.c b/utils/keytable/keytable.c
index 1a91fba..57e88a0 100644
--- a/utils/keytable/keytable.c
+++ b/utils/keytable/keytable.c
@@ -88,6 +88,7 @@ enum ir_protocols {
 	RC_5_SZ		= 1 << 7,
 	SHARP		= 1 << 8,
 	MCE_KBD		= 1 << 9,
+	XMP		= 1 << 10,
 	OTHER		= 1 << 31,
 };
 
@@ -112,7 +113,8 @@ static const char doc[] = "\nAllows get/set IR keycode/scancode tables\n"
 	"  SYSDEV   - the ir class as found at /sys/class/rc\n"
 	"  TABLE    - a file with a set of scancode=keycode value pairs\n"
 	"  SCANKEY  - a set of scancode1=keycode1,scancode2=keycode2.. value pairs\n"
-	"  PROTOCOL - protocol name (nec, rc-5, rc-6, jvc, sony, sanyo, rc-5-sz, lirc, sharp, mce_kbd, other, all) to be enabled\n"
+	"  PROTOCOL - protocol name (nec, rc-5, rc-6, jvc, sony, sanyo, rc-5-sz, lirc,\n"
+        "                            sharp, mce_kbd, xmp, other, all) to be enabled\n"
 	"  DELAY    - Delay before repeating a keystroke\n"
 	"  PERIOD   - Period to repeat a keystroke\n"
 	"  CFGFILE  - configuration file that associates a driver/table name with a keymap file\n"
@@ -240,6 +242,8 @@ static error_t parse_keyfile(char *fname, char **table)
 							ch_proto |= SHARP;
 						else if (!strcasecmp(p,"mce-kbd"))
 							ch_proto |= MCE_KBD;
+						else if (!strcasecmp(p,"xmp"))
+							ch_proto |= XMP;
 						else if (!strcasecmp(p,"other") || !strcasecmp(p,"unknown"))
 							ch_proto |= OTHER;
 						else {
@@ -481,6 +485,8 @@ static error_t parse_opt(int k, char *arg, struct argp_state *state)
 				ch_proto |= RC_5_SZ;
 			else if (!strcasecmp(p,"mce-kbd"))
 				ch_proto |= RC_5_SZ;
+			else if (!strcasecmp(p,"xmp"))
+				ch_proto |= XMP;
 			else if (!strcasecmp(p,"all"))
 				ch_proto |= ~0;
 			else
@@ -760,6 +766,8 @@ static enum ir_protocols v1_get_hw_protocols(char *name)
 			proto |= SHARP;
 		else if (!strcmp(p, "mce-kbd"))
 			proto |= MCE_KBD;
+		else if (!strcmp(p, "xmp"))
+			proto |= XMP;
 		else
 			proto |= OTHER;
 
@@ -812,6 +820,9 @@ static int v1_set_hw_protocols(struct rc_device *rc_dev)
 	if (rc_dev->current & MCE_KBD)
 		fprintf(fp, "mce_kbd ");
 
+	if (rc_dev->current & XMP)
+		fprintf(fp, "xmp ");
+
 	if (rc_dev->current & OTHER)
 		fprintf(fp, "unknown ");
 
@@ -947,6 +958,8 @@ static enum ir_protocols v2_get_protocols(struct rc_device *rc_dev, char *name)
 			proto = SHARP;
 		else if (!strcmp(p, "mce-kbd"))
 			proto = MCE_KBD;
+		else if (!strcmp(p, "xmp"))
+			proto = XMP;
 		else
 			proto = OTHER;
 
@@ -1009,6 +1022,9 @@ static int v2_set_protocols(struct rc_device *rc_dev)
 	if (rc_dev->current & MCE_KBD)
 		fprintf(fp, "+mce-kbd\n");
 
+	if (rc_dev->current & XMP)
+		fprintf(fp, "+xmp\n");
+
 	if (rc_dev->current & OTHER)
 		fprintf(fp, "+unknown\n");
 
@@ -1042,6 +1058,8 @@ static void show_proto(	enum ir_protocols proto)
 		fprintf (stderr, "SHARP ");
 	if (proto & MCE_KBD)
 		fprintf (stderr, "MCE_KBD ");
+	if (proto & XMP)
+		fprintf (stderr, "XMP ");
 	if (proto & OTHER)
 		fprintf (stderr, "other ");
 }
@@ -1164,6 +1182,10 @@ static int get_attribs(struct rc_device *rc_dev, char *sysfs_name)
 			rc_dev->supported |= SONY;
 			if (v1_get_sw_enabled_protocol(cur->name))
 				rc_dev->current |= SONY;
+		} else if (strstr(cur->name, "/xmp_decoder")) {
+			rc_dev->supported |= XMP;
+			if (v1_get_sw_enabled_protocol(cur->name))
+				rc_dev->current |= XMP;
 		}
 	}
 
@@ -1201,6 +1223,9 @@ static int set_proto(struct rc_device *rc_dev)
 		if (rc_dev->supported & SONY)
 			rc += v1_set_sw_enabled_protocol(rc_dev, "/sony_decoder",
 						      rc_dev->current & SONY);
+		if (rc_dev->supported & XMP)
+			rc += v1_set_sw_enabled_protocol(rc_dev, "/xmp_decoder",
+						      rc_dev->current & XMP);
 	} else {
 		rc = v1_set_hw_protocols(rc_dev);
 	}
-- 
1.9.3

