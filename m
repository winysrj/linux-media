Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:44091 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S970459AbdIZUXz (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Sep 2017 16:23:55 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 4/5] ir-ctl: implement scancode reading
Date: Tue, 26 Sep 2017 21:23:51 +0100
Message-Id: <20170926202352.10276-4-sean@mess.org>
In-Reply-To: <20170926202352.10276-1-sean@mess.org>
References: <20170926202352.10276-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sean Young <sean@mess.org>
---
 utils/ir-ctl/ir-ctl.c    | 188 +++++++++++++++++++++++++++++++++--------------
 utils/ir-ctl/ir-encode.c |   4 +
 2 files changed, 135 insertions(+), 57 deletions(-)

diff --git a/utils/ir-ctl/ir-ctl.c b/utils/ir-ctl/ir-ctl.c
index f0dcd2a3..f9cf30a3 100644
--- a/utils/ir-ctl/ir-ctl.c
+++ b/utils/ir-ctl/ir-ctl.c
@@ -24,6 +24,7 @@
 #include <fcntl.h>
 #include <argp.h>
 #include <sysexits.h>
+#include <poll.h>
 
 #include <config.h>
 
@@ -840,24 +841,122 @@ static int lirc_send(struct arguments *args, int fd, unsigned features, struct f
 	return 0;
 }
 
-int lirc_record(struct arguments *args, int fd, unsigned features)
+static bool keep_reading = true;
+static bool leading_space = true;
+
+int lirc_record_mode2(FILE *out, int fd, struct arguments *args)
 {
-	char *dev = args->device;
-	FILE *out = stdout;
-	int rc = EX_IOERR;
 	int mode = LIRC_MODE_MODE2;
+	unsigned buf[LIRCBUF_SIZE];
+	char *dev = args->device;
+	ssize_t ret;
 
-	if (!(features & LIRC_CAN_REC_MODE2)) {
-		fprintf(stderr, _("%s: device cannot record raw ir\n"), dev);
-		return EX_UNAVAILABLE;
+	// some kernel versions return errors, ignore them
+	ioctl(fd, LIRC_SET_REC_MODE, &mode);
+
+	ret = TEMP_FAILURE_RETRY(read(fd, buf, sizeof(buf)));
+	if (ret < 0) {
+		fprintf(stderr, _("%s: failed read: %m\n"), dev);
+		return EX_IOERR;
 	}
 
-	// kernel v4.8 and v4.9 return ENOTTY
-	if (ioctl(fd, LIRC_SET_REC_MODE, &mode) && errno != ENOTTY) {
-		fprintf(stderr, _("%s: failed to set record mode: %m\n"), dev);
+	if (ret == 0 || ret % sizeof(unsigned)) {
+		fprintf(stderr, _("%s: read returned %zd bytes\n"), dev, ret);
+		return EX_IOERR;
+	}
+
+	for (int i=0; i<ret / sizeof(unsigned); i++) {
+		unsigned val = buf[i] & LIRC_VALUE_MASK;
+		unsigned msg = buf[i] & LIRC_MODE2_MASK;
+
+		// FIXME: the kernel often send us a space after
+		// the IR receiver comes out of idle mode. This
+		// is meaningless, maybe fix the kernel?
+		if (leading_space && msg == LIRC_MODE2_SPACE)
+			continue;
+		else
+			leading_space = false;
+
+		if (args->oneshot &&
+			(msg == LIRC_MODE2_TIMEOUT ||
+			(msg == LIRC_MODE2_SPACE && val > 19000))) {
+			keep_reading = false;
+			break;
+		}
+
+		switch (msg) {
+		case LIRC_MODE2_TIMEOUT:
+			fprintf(out, "timeout %u\n", val);
+			leading_space = true;
+			break;
+		case LIRC_MODE2_PULSE:
+			fprintf(out, "pulse %u\n", val);
+			break;
+		case LIRC_MODE2_SPACE:
+			fprintf(out, "space %u\n", val);
+			break;
+		case LIRC_MODE2_FREQUENCY:
+			fprintf(out, "carrier %u\n", val);
+			break;
+		}
+
+		fflush(out);
+	}
+
+	return 0;
+}
+
+int lirc_record_scancode(FILE *out, int fd, const char *dev)
+{
+	struct lirc_scancode sc[32];
+	int mode = LIRC_MODE_SCANCODE;
+	ssize_t ret;
+
+	ret = ioctl(fd, LIRC_SET_REC_MODE, &mode);
+	if (ret < 0) {
+		fprintf(stderr, _("%s: failed set recording mode: %m\n"), dev);
+		return EX_IOERR;
+	}
+
+	ret = TEMP_FAILURE_RETRY(read(fd, sc, sizeof sc));
+	if (ret < 0) {
+		fprintf(stderr, _("%s: failed read: %m\n"), dev);
 		return EX_IOERR;
 	}
 
+	if (ret == 0 || ret % sizeof sc[0]) {
+		fprintf(stderr, _("%s: read returned %zd bytes\n"), dev, ret);
+		return EX_IOERR;
+	}
+
+	for (int i=0; i<ret / sizeof sc[0]; i++) {
+		const char *proto = protocol_name(sc[i].rc_proto);
+
+		if (proto)
+			fprintf(out, "scancode %s:0x%llx\n",
+				protocol_name(sc[i].rc_proto), sc[i].scancode);
+		else
+			fprintf(out, "scancode protocol-%u:0x%llx\n", i,
+				sc[i].scancode);
+	}
+
+	fflush(out);
+
+	return 0;
+}
+
+int lirc_record(struct arguments *args, int fd, unsigned features)
+{
+	char *dev = args->device;
+	FILE *out = stdout;
+	int rc = 0;
+	ssize_t ret;
+
+	if (!(features & (LIRC_CAN_REC_MODE2 | LIRC_CAN_REC_SCANCODE))) {
+		fprintf(stderr, _("%s: device cannot receive\n"), dev);
+		return EX_UNAVAILABLE;
+	}
+
 	if (args->savetofile) {
 		out = fopen(args->savetofile, "w");
 		if (!out) {
@@ -865,65 +964,40 @@ int lirc_record(struct arguments *args, int fd, unsigned features)
 			return EX_CANTCREAT;
 		}
 	}
-	unsigned buf[LIRCBUF_SIZE];
-
-	bool keep_reading = true;
-	bool leading_space = true;
 
 	while (keep_reading) {
-		ssize_t ret = TEMP_FAILURE_RETRY(read(fd, buf, sizeof(buf)));
-		if (ret < 0) {
-			fprintf(stderr, _("%s: failed read: %m\n"), dev);
-			goto err;
-		}
-
-		if (ret == 0 || ret % sizeof(unsigned)) {
-			fprintf(stderr, _("%s: read returned %zd bytes\n"),
-								dev, ret);
-			goto err;
+		if (features & LIRC_CAN_REC_SCANCODE) {
+			unsigned mode = LIRC_MODE_MODE2 | LIRC_MODE_SCANCODE;
+			if (ioctl(fd, LIRC_SET_POLL_MODE, &mode)) {
+				fprintf(stderr, _("%s: set poll mode failed: %m\n"), dev);
+				rc = EX_IOERR;
+				break;
+			}
 		}
 
-		for (int i=0; i<ret / sizeof(unsigned); i++) {
-			unsigned val = buf[i] & LIRC_VALUE_MASK;
-			unsigned msg = buf[i] & LIRC_MODE2_MASK;
-
-			// FIXME: the kernel often send us a space after
-			// the IR receiver comes out of idle mode. This
-			// is meaningless, maybe fix the kernel?
-			if (leading_space && msg == LIRC_MODE2_SPACE)
+		struct pollfd p = { .fd = fd, .events = POLLIN };
+		ret = poll(&p, 1, -1);
+		if (ret == -1) {
+			if (errno == -EINTR)
 				continue;
-			else
-				leading_space = false;
+			fprintf(stderr, _("%s: poll failed: %m\n"), dev);
+			rc = EX_IOERR;
+			break;
+		}
 
-			if (args->oneshot &&
-				(msg == LIRC_MODE2_TIMEOUT ||
-				(msg == LIRC_MODE2_SPACE && val > 19000))) {
-				keep_reading = false;
+		if (features & LIRC_CAN_REC_SCANCODE) {
+			rc = lirc_record_scancode(out, fd, dev);
+			if (rc)
 				break;
-			}
+		}
 
-			switch (msg) {
-			case LIRC_MODE2_TIMEOUT:
-				fprintf(out, "timeout %u\n", val);
-				leading_space = true;
-				break;
-			case LIRC_MODE2_PULSE:
-				fprintf(out, "pulse %u\n", val);
-				break;
-			case LIRC_MODE2_SPACE:
-				fprintf(out, "space %u\n", val);
-				break;
-			case LIRC_MODE2_FREQUENCY:
-				fprintf(out, "carrier %u\n", val);
+		if (features & LIRC_CAN_REC_MODE2) {
+			rc = lirc_record_mode2(out, fd, args);
+			if (rc)
 				break;
-			}
-
-			fflush(out);
 		}
 	}
 
-	rc = 0;
-err:
 	if (args->savetofile)
 		fclose(out);
 
diff --git a/utils/ir-ctl/ir-encode.c b/utils/ir-ctl/ir-encode.c
index 8a125628..702c1bb0 100644
--- a/utils/ir-ctl/ir-encode.c
+++ b/utils/ir-ctl/ir-encode.c
@@ -18,6 +18,7 @@
  */
 
 #include <stdbool.h>
+#include <stdlib.h>
 #include <stdint.h>
 #include <ctype.h>
 
@@ -445,5 +446,8 @@ unsigned protocol_encode(enum rc_proto proto, unsigned scancode, unsigned *buf)
 
 const char* protocol_name(enum rc_proto proto)
 {
+	if (proto >= ARRAY_SIZE(encoders))
+		return NULL;
+
 	return encoders[proto].name;
 }
-- 
2.13.5
