Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:52659 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S967680AbdIZUXy (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Sep 2017 16:23:54 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/5] ir-ctl: a pulse space file cannot contain scancode and raw IR
Date: Tue, 26 Sep 2017 21:23:48 +0100
Message-Id: <20170926202352.10276-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This simplifies dealing with kernel encoders and raw IR, and does
not make much sense anyway.

Signed-off-by: Sean Young <sean@mess.org>
---
 utils/ir-ctl/ir-ctl.1.in |  7 ++-----
 utils/ir-ctl/ir-ctl.c    | 12 +++++++++---
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/utils/ir-ctl/ir-ctl.1.in b/utils/ir-ctl/ir-ctl.1.in
index 05550fb1..401521da 100644
--- a/utils/ir-ctl/ir-ctl.1.in
+++ b/utils/ir-ctl/ir-ctl.1.in
@@ -168,11 +168,8 @@ carrier. The above can be written as:
 .PP
 	scancode rc5:0x1e01
 .PP
-Do not specify scancodes with different protocols in one file, as the
-carrier might differ and the transmitter cannot send this. Multiple
-scancodes can be specified in one file but ensure that the rules for the
-protocol are met by inserting an appropriate space between them. Also,
-there are limits to what lirc devices can send in one go.
+If you specify a scancode in a pulse space file, no other pulse, space or
+even carrier may be specified.
 .PP
 .SS Supported Protocols
 A scancode with protocol can be specified on the command line or in the
diff --git a/utils/ir-ctl/ir-ctl.c b/utils/ir-ctl/ir-ctl.c
index d3cce6a6..7dcdd983 100644
--- a/utils/ir-ctl/ir-ctl.c
+++ b/utils/ir-ctl/ir-ctl.c
@@ -187,7 +187,7 @@ static unsigned parse_emitters(char *p)
 
 static struct file *read_file(const char *fname)
 {
-	bool expect_pulse = true;
+	bool expect_pulse = true, seen_scancode = false;
 	int lineno = 0, lastspace = 0;
 	char line[1024];
 	int len = 0;
@@ -229,8 +229,8 @@ static struct file *read_file(const char *fname)
 			unsigned scancode, carrier;
 			char *scancodestr;
 
-			if (!expect_pulse) {
-				fprintf(stderr, _("error: %s:%d: space must precede scancode\n"), fname, lineno);
+			if (len) {
+				fprintf(stderr, _("error: %s:%d: scancode must be appear in file by itself\n"), fname, lineno);
 				return NULL;
 			}
 
@@ -269,6 +269,7 @@ static struct file *read_file(const char *fname)
 				f->carrier = carrier;
 
 			len += protocol_encode(proto, scancode, f->buf);
+			seen_scancode = true;
 			continue;
 		}
 
@@ -284,6 +285,11 @@ static struct file *read_file(const char *fname)
 			continue;
 		}
 
+		if (seen_scancode) {
+			fprintf(stderr, _("error: %s:%d: scancode must be appear in file by itself\n"), fname, lineno);
+			return NULL;
+		}
+
 		if (strcmp(keyword, "space") == 0) {
 			if (expect_pulse) {
 				if (len == 0) {
-- 
2.13.5
