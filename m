Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:39121 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S968189AbdIZUXy (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Sep 2017 16:23:54 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 3/5] ir-ctl: use lirc scancode sending
Date: Tue, 26 Sep 2017 21:23:50 +0100
Message-Id: <20170926202352.10276-3-sean@mess.org>
In-Reply-To: <20170926202352.10276-1-sean@mess.org>
References: <20170926202352.10276-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sean Young <sean@mess.org>
---
 utils/ir-ctl/ir-ctl.c | 79 +++++++++++++++++++++++++++++++++------------------
 1 file changed, 52 insertions(+), 27 deletions(-)

diff --git a/utils/ir-ctl/ir-ctl.c b/utils/ir-ctl/ir-ctl.c
index 32d7162f..f0dcd2a3 100644
--- a/utils/ir-ctl/ir-ctl.c
+++ b/utils/ir-ctl/ir-ctl.c
@@ -66,9 +66,18 @@ const char *argp_program_bug_address = "Sean Young <sean@mess.org>";
 struct file {
 	struct file *next;
 	const char *fname;
-	unsigned carrier;
-	unsigned len;
-	unsigned buf[LIRCBUF_SIZE];
+	bool is_scancode;
+	union {
+		struct {
+			unsigned carrier;
+			unsigned len;
+			unsigned buf[LIRCBUF_SIZE];
+		};
+		struct {
+			unsigned scancode;
+			unsigned protocol;
+		};
+	};
 };
 
 struct arguments {
@@ -187,7 +196,7 @@ static unsigned parse_emitters(char *p)
 
 static struct file *read_file(const char *fname)
 {
-	bool expect_pulse = true, seen_scancode = false;
+	bool expect_pulse = true;
 	int lineno = 0, lastspace = 0;
 	char line[1024];
 	int len = 0;
@@ -206,6 +215,7 @@ static struct file *read_file(const char *fname)
 		fprintf(stderr, _("Failed to allocate memory\n"));
 		return NULL;
 	}
+	f->is_scancode = false;
 	f->carrier = 0;
 	f->fname = fname;
 
@@ -226,7 +236,7 @@ static struct file *read_file(const char *fname)
 
 		if (strcmp(keyword, "scancode") == 0) {
 			enum rc_proto proto;
-			unsigned scancode, carrier;
+			unsigned scancode;
 			char *scancodestr;
 
 			if (len) {
@@ -257,19 +267,9 @@ static struct file *read_file(const char *fname)
 				return NULL;
 			}
 
-			if (len + protocol_max_size(proto) >= LIRCBUF_SIZE) {
-				fprintf(stderr, _("error: %s:%d: too much IR for one transmit\n"), fname, lineno);
-				return NULL;
-			}
-
-			carrier = protocol_carrier(proto);
-			if (f->carrier && f->carrier != carrier)
-				fprintf(stderr, _("error: %s:%d: carrier already specified\n"), fname, lineno);
-			else
-				f->carrier = carrier;
-
-			len += protocol_encode(proto, scancode, f->buf);
-			seen_scancode = true;
+			f->is_scancode = true;
+			f->scancode = scancode;
+			f->protocol = proto;
 			continue;
 		}
 
@@ -285,7 +285,7 @@ static struct file *read_file(const char *fname)
 			continue;
 		}
 
-		if (seen_scancode) {
+		if (f->is_scancode) {
 			fprintf(stderr, _("error: %s:%d: scancode must be appear in file by itself\n"), fname, lineno);
 			return NULL;
 		}
@@ -383,9 +383,9 @@ static struct file *read_scancode(const char *name)
 		return NULL;
 	}
 
-	f->carrier = protocol_carrier(proto);
-	f->fname = name;
-	f->len = protocol_encode(proto, scancode, f->buf);
+	f->is_scancode = true;
+	f->scancode = scancode;
+	f->protocol = proto;
 
 	return f;
 }
@@ -772,16 +772,41 @@ static void lirc_features(struct arguments *args, int fd, unsigned features)
 static int lirc_send(struct arguments *args, int fd, unsigned features, struct file *f)
 {
 	const char *dev = args->device;
-	int mode = LIRC_MODE_PULSE;
+	int rc, mode;
+	ssize_t ret;
+
+	if (f->is_scancode && (features & LIRC_CAN_SEND_SCANCODE)) {
+		mode = LIRC_MODE_SCANCODE;
+		rc = ioctl(fd, LIRC_SET_SEND_MODE, &mode);
+		if (rc == 0) {
+			struct lirc_scancode sc = {
+				.scancode = f->scancode,
+				.rc_proto = f->protocol,
+				.flags = 0
+			};
+			ret = TEMP_FAILURE_RETRY(write(fd, &sc, sizeof sc));
+			if (ret > 0)
+				return 0;
+		}
+	}
 
 	if (!(features & LIRC_CAN_SEND_PULSE)) {
 		fprintf(stderr, _("%s: device cannot send raw ir\n"), dev);
 		return EX_UNAVAILABLE;
 	}
 
-	if (ioctl(fd, LIRC_SET_SEND_MODE, &mode)) {
-		fprintf(stderr, _("%s: failed to set send mode: %m\n"), dev);
-		return EX_IOERR;
+	mode = LIRC_MODE_PULSE;
+	rc = ioctl(fd, LIRC_SET_SEND_MODE, &mode);
+	if (rc) {
+		fprintf(stderr, _("%s: cannot set send mode\n"), dev);
+		return EX_UNAVAILABLE;
+	}
+
+	if (f->is_scancode) {
+		// encode scancode
+		enum rc_proto proto = f->protocol;
+		f->len = protocol_encode(f->protocol, f->scancode, f->buf);
+		f->carrier = protocol_carrier(proto);
 	}
 
 	if (args->carrier && f->carrier)
@@ -796,7 +821,7 @@ static int lirc_send(struct arguments *args, int fd, unsigned features, struct f
 		for (i=0; i<f->len; i++)
 			printf("%s %u\n", i & 1 ? "space" : "pulse", f->buf[i]);
 	}
-	ssize_t ret = TEMP_FAILURE_RETRY(write(fd, f->buf, size));
+	ret = TEMP_FAILURE_RETRY(write(fd, f->buf, size));
 	if (ret < 0) {
 		fprintf(stderr, _("%s: failed to send: %m\n"), dev);
 		return EX_IOERR;
-- 
2.13.5
