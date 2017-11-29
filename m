Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:53277 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753341AbdK2J04 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Nov 2017 04:26:56 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/2] keytable: fail more gracefully when commandline cannot be parsed
Date: Wed, 29 Nov 2017 09:26:54 +0000
Message-Id: <20171129092655.17201-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If there is a problem during argp_parse, you get:

$ ir-keytable -p foo
Invalid parameter(s)
ir-keytable: -p: (PROGRAM ERROR) Option should have been recognized!?
Try `ir-keytable --help' or `ir-keytable --usage' for more information.
Try `ir-keytable --help' or `ir-keytable --usage' for more information.
Found /sys/class/rc/rc0/ (/dev/input/event6) with:
	Driver winbond-cir, table rc-rc6-mce
	Supported protocols: lirc rc-5 rc-5-sz jvc sony nec sanyo mce_kbd rc-6 sharp xmp
	Enabled protocols: lirc rc-6
	Extra capabilities: <access denied>

So, ARGP_ERR_UNKNOWN is not correct and it should exit on parse failures.

Signed-off-by: Sean Young <sean@mess.org>
---
 utils/keytable/keytable.c | 33 ++++++++++++++++++---------------
 1 file changed, 18 insertions(+), 15 deletions(-)

diff --git a/utils/keytable/keytable.c b/utils/keytable/keytable.c
index 64db7703..4c1e8641 100644
--- a/utils/keytable/keytable.c
+++ b/utils/keytable/keytable.c
@@ -496,7 +496,7 @@ static error_t parse_opt(int k, char *arg, struct argp_state *state)
 
 		rc = parse_keyfile(arg, &name);
 		if (rc)
-			goto err_inval;
+			argp_error(state, _("Failed to read table file %s"), arg);
 		if (name)
 			fprintf(stderr, _("Read %s table\n"), name);
 		break;
@@ -504,7 +504,7 @@ static error_t parse_opt(int k, char *arg, struct argp_state *state)
 	case 'a': {
 		rc = parse_cfgfile(arg);
 		if (rc)
-			goto err_inval;
+			argp_error(state, _("Failed to read config file %s"), arg);
 		break;
 	}
 	case 'k':
@@ -512,8 +512,10 @@ static error_t parse_opt(int k, char *arg, struct argp_state *state)
 		do {
 			struct keytable_entry *ke;
 
-			if (!p)
-				goto err_inval;
+			if (!p) {
+				argp_error(state, _("Missing scancode: %s"), arg);
+				break;
+			}
 
 			ke = calloc(1, sizeof(*ke));
 			if (!ke) {
@@ -524,13 +526,15 @@ static error_t parse_opt(int k, char *arg, struct argp_state *state)
 			ke->scancode = strtoul(p, NULL, 0);
 			if (errno) {
 				free(ke);
-				goto err_inval;
+				argp_error(state, _("Invalid scancode: %s"), p);
+				break;
 			}
 
 			p = strtok(NULL, ",;");
 			if (!p) {
 				free(ke);
-				goto err_inval;
+				argp_error(state, _("Missing keycode"));
+				break;
 			}
 
 			key = parse_code(p);
@@ -538,7 +542,8 @@ static error_t parse_opt(int k, char *arg, struct argp_state *state)
 				key = strtol(p, NULL, 0);
 				if (errno) {
 					free(ke);
-					goto err_inval;
+					argp_error(state, _("Unknown keycode: %s"), p);
+					break;
 				}
 			}
 
@@ -559,8 +564,10 @@ static error_t parse_opt(int k, char *arg, struct argp_state *state)
 			enum sysfs_protocols protocol;
 
 			protocol = parse_sysfs_protocol(p, true);
-			if (protocol == SYSFS_INVALID)
-				goto err_inval;
+			if (protocol == SYSFS_INVALID) {
+				argp_error(state, _("Unknown protocol: %s"), p);
+				break;
+			}
 
 			ch_proto |= protocol;
 		}
@@ -580,12 +587,8 @@ static error_t parse_opt(int k, char *arg, struct argp_state *state)
 	default:
 		return ARGP_ERR_UNKNOWN;
 	}
-	return 0;
-
-err_inval:
-	fprintf(stderr, _("Invalid parameter(s)\n"));
-	return ARGP_ERR_UNKNOWN;
 
+	return 0;
 }
 
 static struct argp argp = {
@@ -1507,7 +1510,7 @@ int main(int argc, char *argv[])
 	textdomain (PACKAGE);
 #endif
 
-	argp_parse(&argp, argc, argv, ARGP_NO_HELP | ARGP_NO_EXIT, 0, 0);
+	argp_parse(&argp, argc, argv, ARGP_NO_HELP, 0, 0);
 
 	/* Just list all devices */
 	if (!clear && !readtable && !keytable && !ch_proto && !cfg.next && !test && !delay && !period) {
-- 
2.14.3
