Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:36515 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752989AbbDFL0s (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 6 Apr 2015 07:26:48 -0400
Subject: [PATCH 3/4] ir-keytable: cleanup keytable code
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com
Date: Mon, 06 Apr 2015 13:26:13 +0200
Message-ID: <20150406112613.23289.89393.stgit@zeus.muc.hardeman.nu>
In-Reply-To: <20150406112326.23289.28902.stgit@zeus.muc.hardeman.nu>
References: <20150406112326.23289.28902.stgit@zeus.muc.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Cleanup the keytable code by giving the struct members more explicit
names (scancode instead of codes[0], keycode instead of codes[1]).

Also, replace a linked list implementation using a quirky empty list
member as the head of the list rather than the classical pointer.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 utils/keytable/keytable.c |  100 ++++++++++++++++++++++++++-------------------
 1 file changed, 57 insertions(+), 43 deletions(-)

diff --git a/utils/keytable/keytable.c b/utils/keytable/keytable.c
index 949eed9..63eea2e 100644
--- a/utils/keytable/keytable.c
+++ b/utils/keytable/keytable.c
@@ -55,12 +55,14 @@ struct input_keymap_entry_v2 {
 #define EVIOCSKEYCODE_V2	_IOW('E', 0x04, struct input_keymap_entry_v2)
 #endif
 
-struct keytable {
-	u_int32_t codes[2];
-	struct input_keymap_entry_v2 keymap;
-	struct keytable *next;
+struct keytable_entry {
+	u_int32_t scancode;
+	u_int32_t keycode;
+	struct keytable_entry *next;
 };
 
+struct keytable_entry *keytable = NULL;
+
 struct uevents {
 	char		*key;
 	char		*value;
@@ -237,12 +239,6 @@ static int delay = 0;
 static int period = 0;
 static enum sysfs_protocols ch_proto = 0;
 
-struct keytable keys = {
-	.codes = {0, 0},
-	.next = NULL
-};
-
-
 struct cfgfile cfg = {
 	NULL, NULL, NULL, NULL
 };
@@ -268,13 +264,12 @@ struct rc_device {
 	enum sysfs_protocols supported, current; /* Current and supported IR protocols */
 };
 
-struct keytable *nextkey = &keys;
-
 static error_t parse_keyfile(char *fname, char **table)
 {
 	FILE *fin;
 	int value, line = 0;
 	char *scancode, *keycode, s[2048];
+	struct keytable_entry *ke;
 
 	*table = NULL;
 
@@ -356,14 +351,16 @@ static error_t parse_keyfile(char *fname, char **table)
 				perror(_("value"));
 		}
 
-		nextkey->codes[0] = (unsigned) strtoul(scancode, NULL, 0);
-		nextkey->codes[1] = (unsigned) value;
-		nextkey->next = calloc(1, sizeof(*nextkey));
-		if (!nextkey->next) {
+		ke = calloc(1, sizeof(*ke));
+		if (!ke) {
 			perror("parse_keyfile");
 			return ENOMEM;
 		}
-		nextkey = nextkey->next;
+
+		ke->scancode	= strtoul(scancode, NULL, 0);
+		ke->keycode	= value;
+		ke->next	= keytable;
+		keytable	= ke;
 	}
 	fclose(fin);
 
@@ -497,33 +494,46 @@ static error_t parse_opt(int k, char *arg, struct argp_state *state)
 	case 'k':
 		p = strtok(arg, ":=");
 		do {
+			struct keytable_entry *ke;
+
 			if (!p)
 				goto err_inval;
-			nextkey->codes[0] = strtoul(p, NULL, 0);
-			if (errno)
+
+			ke = calloc(1, sizeof(*ke));
+			if (!ke) {
+				perror(_("No memory!\n"));
+				return ENOMEM;
+			}
+
+			ke->scancode = strtoul(p, NULL, 0);
+			if (errno) {
+				free(ke);
 				goto err_inval;
+			}
 
 			p = strtok(NULL, ",;");
-			if (!p)
+			if (!p) {
+				free(ke);
 				goto err_inval;
+			}
+
 			key = parse_code(p);
 			if (key == -1) {
 				key = strtol(p, NULL, 0);
-				if (errno)
+				if (errno) {
+					free(ke);
 					goto err_inval;
+				}
 			}
-			nextkey->codes[1] = key;
+
+			ke->keycode = key;
 
 			if (debug)
 				fprintf(stderr, _("scancode 0x%04x=%u\n"),
-					nextkey->codes[0], nextkey->codes[1]);
+					ke->scancode, ke->keycode);
 
-			nextkey->next = calloc(1, sizeof(keys));
-			if (!nextkey->next) {
-				perror(_("No memory!\n"));
-				return ENOMEM;
-			}
-			nextkey = nextkey->next;
+			ke->next = keytable;
+			keytable = ke;
 
 			p = strtok(NULL, ":=");
 		} while (p);
@@ -1189,26 +1199,30 @@ static void clear_table(int fd)
 static int add_keys(int fd)
 {
 	int write_cnt = 0;
+	struct keytable_entry *ke;
+	unsigned codes[2];
 
-	nextkey = &keys;
-	while (nextkey->next) {
-		struct keytable *old;
-
+	for (ke = keytable; ke; ke = ke->next) {
 		write_cnt++;
 		if (debug)
 			fprintf(stderr, "\t%04x=%04x\n",
-			       nextkey->codes[0], nextkey->codes[1]);
+				ke->scancode, ke->keycode);
 
-		if (ioctl(fd, EVIOCSKEYCODE, nextkey->codes)) {
+		codes[0] = ke->scancode;
+		codes[1] = ke->keycode;
+
+		if (ioctl(fd, EVIOCSKEYCODE, codes)) {
 			fprintf(stderr,
 				_("Setting scancode 0x%04x with 0x%04x via "),
-				nextkey->codes[0], nextkey->codes[1]);
+				ke->scancode, ke->keycode);
 			perror("EVIOCSKEYCODE");
 		}
-		old = nextkey;
-		nextkey = nextkey->next;
-		if (old != &keys)
-			free(old);
+	}
+
+	while (keytable) {
+		ke = keytable;
+		keytable = ke->next;
+		free(ke);
 	}
 
 	return write_cnt;
@@ -1460,7 +1474,7 @@ int main(int argc, char *argv[])
 	argp_parse(&argp, argc, argv, ARGP_NO_HELP | ARGP_NO_EXIT, 0, 0);
 
 	/* Just list all devices */
-	if (!clear && !readtable && !keys.next && !ch_proto && !cfg.next && !test && !delay && !period) {
+	if (!clear && !readtable && !keytable && !ch_proto && !cfg.next && !test && !delay && !period) {
 		if (devicename) {
 			fd = open(devicename, O_RDONLY);
 			if (fd < 0) {
@@ -1477,7 +1491,7 @@ int main(int argc, char *argv[])
 		return 0;
 	}
 
-	if (cfg.next && (clear || keys.next || ch_proto || devicename)) {
+	if (cfg.next && (clear || keytable || ch_proto || devicename)) {
 		fprintf (stderr, _("Auto-mode can be used only with --read, --debug and --sysdev options\n"));
 		return -1;
 	}
@@ -1545,7 +1559,7 @@ int main(int argc, char *argv[])
 				return -1;
 			}
 		}
-		if (!keys.next) {
+		if (!keytable) {
 			fprintf(stderr, _("Empty table %s\n"), fname);
 			return -1;
 		}

