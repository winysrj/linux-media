Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:39041 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730565AbeGQWHm (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Jul 2018 18:07:42 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/2] media: rc: self test for IR encoders and decoders
Date: Tue, 17 Jul 2018 22:33:06 +0100
Message-Id: <20180717213306.22799-3-sean@mess.org>
In-Reply-To: <20180717213306.22799-1-sean@mess.org>
References: <20180717213306.22799-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ir-loopback can transmit IR on one rc device and check the correct
scancode and protocol is decoded on a different rc device. This can be
used to check IR transmission between two rc devices. Using rc-loopback,
we use it to check the IR encoders and decoders themselves.

Signed-off-by: Sean Young <sean@mess.org>
---
 tools/testing/selftests/Makefile          |   1 +
 tools/testing/selftests/ir/.gitignore     |   1 +
 tools/testing/selftests/ir/Makefile       |  19 ++
 tools/testing/selftests/ir/config         |  12 ++
 tools/testing/selftests/ir/ir-loopback.c  | 209 ++++++++++++++++++++++
 tools/testing/selftests/ir/ir-loopback.sh |  28 +++
 6 files changed, 270 insertions(+)
 create mode 100644 tools/testing/selftests/ir/.gitignore
 create mode 100644 tools/testing/selftests/ir/Makefile
 create mode 100644 tools/testing/selftests/ir/config
 create mode 100644 tools/testing/selftests/ir/ir-loopback.c
 create mode 100755 tools/testing/selftests/ir/ir-loopback.sh

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index f1fe492c8e17..995034ea5546 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -15,6 +15,7 @@ TARGETS += futex
 TARGETS += gpio
 TARGETS += intel_pstate
 TARGETS += ipc
+TARGETS += ir
 TARGETS += kcmp
 TARGETS += kvm
 TARGETS += lib
diff --git a/tools/testing/selftests/ir/.gitignore b/tools/testing/selftests/ir/.gitignore
new file mode 100644
index 000000000000..87bf2989b678
--- /dev/null
+++ b/tools/testing/selftests/ir/.gitignore
@@ -0,0 +1 @@
+ir-loopback
diff --git a/tools/testing/selftests/ir/Makefile b/tools/testing/selftests/ir/Makefile
new file mode 100644
index 000000000000..501b464e56b5
--- /dev/null
+++ b/tools/testing/selftests/ir/Makefile
@@ -0,0 +1,19 @@
+# SPDX-License-Identifier: GPL-2.0
+uname_M := $(shell uname -m 2>/dev/null || echo not)
+ARCH ?= $(shell echo $(uname_M) | sed -e s/i.86/i386/)
+ifeq ($(ARCH),i386)
+        ARCH := x86
+	CFLAGS := -DCONFIG_X86_32 -D__i386__
+endif
+ifeq ($(ARCH),x86_64)
+	ARCH := x86
+	CFLAGS := -DCONFIG_X86_64 -D__x86_64__
+endif
+
+CFLAGS += -I../../../../usr/include/
+
+TEST_PROGS := ir-loopback.sh
+
+TEST_GEN_PROGS := ir-loopback
+
+include ../lib.mk
diff --git a/tools/testing/selftests/ir/config b/tools/testing/selftests/ir/config
new file mode 100644
index 000000000000..78e041e9319e
--- /dev/null
+++ b/tools/testing/selftests/ir/config
@@ -0,0 +1,12 @@
+CONFIG_RC_CORE=y
+CONFIG_RC_LOOPBACK=y
+CONFIG_IR_NEC_DECODER=m
+CONFIG_IR_RC5_DECODER=m
+CONFIG_IR_RC6_DECODER=m
+CONFIG_IR_JVC_DECODER=m
+CONFIG_IR_SONY_DECODER=m
+CONFIG_IR_SANYO_DECODER=m
+CONFIG_IR_SHARP_DECODER=m
+CONFIG_IR_MCE_KBD_DECODER=m
+CONFIG_IR_XMP_DECODER=m
+CONFIG_IR_IMON_DECODER=m
diff --git a/tools/testing/selftests/ir/ir-loopback.c b/tools/testing/selftests/ir/ir-loopback.c
new file mode 100644
index 000000000000..95b6f0f2f1f5
--- /dev/null
+++ b/tools/testing/selftests/ir/ir-loopback.c
@@ -0,0 +1,209 @@
+// SPDX-License-Identifier: GPL-2.0
+// test ir decoder
+//
+// Copyright (C) 2018 Sean Young <sean@mess.org>
+
+// When sending LIRC_MODE_SCANCODE, the IR will be encoded. rc-loopback
+// will send this IR to the receiver side, where we try to read the decoded
+// IR. Decoding happens in a separate kernel thread, so we will need to
+// wait until that is scheduled, hence we use poll to check for read
+// readiness.
+
+#include <linux/lirc.h>
+#include <errno.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <stdbool.h>
+#include <string.h>
+#include <unistd.h>
+#include <poll.h>
+#include <time.h>
+#include <sys/types.h>
+#include <sys/ioctl.h>
+#include <dirent.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+
+#define TEST_SCANCODES 	10
+#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))
+
+static const struct {
+	enum rc_proto proto;
+	const char *name;
+	unsigned int mask;
+	const char *decoder;
+} protocols[] = {
+	{ RC_PROTO_RC5, "rc-5", 0x1f7f, "rc-5" },
+	{ RC_PROTO_RC5X_20, "rc-5x-20", 0x1f7f3f, "rc-5" },
+	{ RC_PROTO_RC5_SZ, "rc-5-sz", 0x2fff, "rc-5-sz" },
+	{ RC_PROTO_JVC, "jvc", 0xffff, "jvc" },
+	{ RC_PROTO_SONY12, "sony-12", 0x1f007f, "sony" },
+	{ RC_PROTO_SONY15, "sony-15", 0xff007f, "sony" },
+	{ RC_PROTO_SONY20, "sony-20", 0x1fff7f, "sony" },
+	{ RC_PROTO_NEC, "nec", 0xffff, "nec" },
+	{ RC_PROTO_NECX, "nec-x", 0xffffff, "nec" },
+	{ RC_PROTO_NEC32, "nec-32", 0xffffffff, "nec" },
+	{ RC_PROTO_SANYO, "sanyo", 0x1fffff, "sanyo" },
+	{ RC_PROTO_RC6_0, "rc-6-0", 0xffff, "rc-6" },
+	{ RC_PROTO_RC6_6A_20, "rc-6-6a-20", 0xfffff, "rc-6" },
+	{ RC_PROTO_RC6_6A_24, "rc-6-6a-24", 0xffffff, "rc-6" },
+	{ RC_PROTO_RC6_6A_32, "rc-6-6a-32", 0xffffffff, "rc-6" },
+	{ RC_PROTO_RC6_MCE, "rc-6-mce", 0x00007fff, "rc-6" },
+	{ RC_PROTO_SHARP, "sharp", 0x1fff, "sharp" },
+};
+
+int lirc_open(const char *rc)
+{
+	struct dirent *dent;
+	char buf[100];
+	DIR *d;
+	int fd;
+
+	snprintf(buf, sizeof(buf), "/sys/class/rc/%s", rc);
+
+	d = opendir(buf);
+	if (!d) {
+		printf("cannot open %s: %m\n", buf);
+		exit(1);
+	}
+
+	while ((dent = readdir(d)) != NULL) {
+		if (!strncmp(dent->d_name, "lirc", 4)) {
+			snprintf(buf, sizeof(buf), "/dev/%s", dent->d_name);
+			break;
+		}
+	}
+
+	if (!dent) {
+		printf("cannot find lirc device for %s\n", rc);
+		exit(1);
+	}
+
+	closedir(d);
+
+	fd = open(buf, O_RDWR | O_NONBLOCK);
+	if (fd == -1) {
+		printf("cannot open: %s: %m\n", buf);
+		exit(1);
+	}
+
+	return fd;
+}
+
+int main(int argc, char **argv)
+{
+	unsigned int mode;
+	char buf[100];
+	int rlircfd, wlircfd, protocolfd, i, n;
+	int errors = 0;
+
+	srand(time(NULL));
+
+	if (argc != 3) {
+		printf("Usage: %s <write rcN> <read rcN>n", argv[0]);
+		return 2;
+	}
+
+	rlircfd = lirc_open(argv[2]);
+	mode = LIRC_MODE_SCANCODE;
+	if (ioctl(rlircfd, LIRC_SET_REC_MODE, &mode)) {
+		printf("failed to set scancode rec mode %s: %m\n", argv[2]);
+		return 1;
+	}
+
+	wlircfd = lirc_open(argv[1]);
+	if (ioctl(wlircfd, LIRC_SET_SEND_MODE, &mode)) {
+		printf("failed to set scancode send mode %s: %m\n", argv[1]);
+		return 1;
+	}
+
+	snprintf(buf, sizeof(buf), "/sys/class/rc/%s/protocols", argv[2]);
+	protocolfd = open(buf, O_WRONLY);
+	if (protocolfd == -1) {
+		printf("failed to open %s: %m\n", buf);
+		return 1;
+	}
+
+	printf("Sending IR on %s and receiving IR on %s.\n", argv[1], argv[2]);
+
+	for (i=0; i<ARRAY_SIZE(protocols); i++) {
+		if (write(protocolfd, protocols[i].decoder,
+			 strlen(protocols[i].decoder)) == -1) {
+			printf("failed to set write decoder\n");
+			return 1;
+		}
+
+		printf("Testing protocol %s for decoder %s (%d/%d)...\n",
+		       protocols[i].name, protocols[i].decoder,
+		       i + 1, (int)ARRAY_SIZE(protocols));
+
+		for (n=0; n<TEST_SCANCODES; n++) {
+			unsigned scancode = rand() & protocols[i].mask;
+			unsigned rc_proto = protocols[i].proto;
+
+			if (rc_proto == RC_PROTO_RC6_MCE)
+				scancode |= 0x800f0000;
+
+			if (rc_proto == RC_PROTO_NECX &&
+			    (((scancode >> 16) ^ ~(scancode >> 8)) & 0xff) == 0)
+				continue;
+
+			if (rc_proto == RC_PROTO_NEC32 &&
+			    (((scancode >> 8) ^ ~scancode) & 0xff) == 0)
+				continue;
+
+			struct lirc_scancode lsc = {
+				.rc_proto = rc_proto,
+				.scancode = scancode
+			};
+
+			printf("Testing scancode:%x\n", scancode);
+
+			while (write(wlircfd, &lsc, sizeof(lsc)) < 0) {
+				if (errno == EINTR)
+					continue;
+
+				printf("failed to send ir: %m\n");
+				return 1;
+			}
+
+			struct pollfd pfd = { .fd = rlircfd, .events = POLLIN };
+			struct lirc_scancode lsc2;
+
+			poll(&pfd, 1, 1000);
+
+			bool decoded = true;
+
+			while (read(rlircfd, &lsc2, sizeof(lsc2)) < 0) {
+				if (errno == EINTR)
+					continue;
+
+				printf("no scancode decoded: %m\n");
+				errors++;
+				decoded = false;
+				break;
+			}
+
+			if (!decoded)
+				continue;
+
+			if (lsc.rc_proto != lsc2.rc_proto) {
+				printf("decoded protocol is different: %d\n", lsc2.rc_proto);
+				errors++;
+			}
+
+			if (lsc.scancode != lsc2.scancode) {
+				printf("decoded scancode is different: %llx\n", lsc2.scancode);
+				errors++;
+			}
+		}
+
+		printf("OK\n");
+	}
+
+	close(rlircfd);
+	close(wlircfd);
+	close(protocolfd);
+
+	return errors > 0;
+}
diff --git a/tools/testing/selftests/ir/ir-loopback.sh b/tools/testing/selftests/ir/ir-loopback.sh
new file mode 100755
index 000000000000..72be64a45cc5
--- /dev/null
+++ b/tools/testing/selftests/ir/ir-loopback.sh
@@ -0,0 +1,28 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+GREEN='\033[0;92m'
+RED='\033[0;31m'
+NC='\033[0m' # No Color
+
+modprobe rc-loopback
+
+for i in /sys/class/rc/rc*
+do
+	if grep -q DRV_NAME=rc-loopback $i/uevent
+	then
+		RCDEV=$(echo $i | sed sQ/sys/class/rc/QQ)
+	fi
+done
+
+if [ -n $RCDEV ];
+then
+	TYPE=ir-loopback
+	./ir-loopback $RCDEV $RCDEV
+	ret=$?
+	if [ $ret -ne 0 ]; then
+		echo -e ${RED}"FAIL: $TYPE"${NC}
+	else
+		echo -e ${GREEN}"PASS: $TYPE"${NC}
+	fi
+fi
-- 
2.17.1
