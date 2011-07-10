Return-path: <mchehab@localhost>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40658 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932065Ab1GJKnI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jul 2011 06:43:08 -0400
Received: by bwd5 with SMTP id 5so2633718bwd.19
        for <linux-media@vger.kernel.org>; Sun, 10 Jul 2011 03:43:06 -0700 (PDT)
Date: Sun, 10 Jul 2011 12:43:03 +0200
From: Stefan Seyfried <stefan.seyfried@googlemail.com>
To: linux-media@vger.kernel.org
Subject: [Patch] dvb-apps: add test tool for DMX_OUT_TSDEMUX_TAP
Message-ID: <20110710124303.26655303@susi.home.s3e.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/otR5yRpeBJcupAbuq86PzVT"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

--MP_/otR5yRpeBJcupAbuq86PzVT
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi all,

I patched test_dvr to use DMX_OUT_TSDEMUX_TAP and named it test_tapdmx.
Might be useful for others, too :-)
This is my first experience with mercurial, so bear with me if it's
totally wrong.

Best regards,

	Stefan

(attached in case the mailer screws it up)

# HG changeset patch
# User Stefan Seyfried <seife+dvb@b1-systems.com>
# Date 1310293978 -7200
# Node ID 0326ba8a015935abfd95f2909abd0d357a4be547
# Parent  148ede2a6809766a4ba4dd29bac896b3291b3efe
add test_tapdmx, like test_dvr but using DMX_OUT_TSDEMUX_TAP

diff --git a/test/Makefile b/test/Makefile
--- a/test/Makefile
+++ b/test/Makefile
@@ -10,6 +10,7 @@
            test_av         \
            test_av_play    \
            test_dvr        \
+           test_tapdmx     \
            test_dvr_play   \
            test_pes        \
            test_sec_ne     \
diff --git a/test/test_tapdmx.c b/test/test_tapdmx.c
new file mode 100644
--- /dev/null
+++ b/test/test_tapdmx.c
@@ -0,0 +1,160 @@
+/* test_tapdmx.c - Test recording a TS from the dmx device.
+ * very similar to test_dvr but using the new DMX_OUT_TSDEMUX_TAP
+ * usage: test_tapdmx PID [more PIDs...]
+ *
+ * test_dvr is
+ *   Copyright (C) 2003 convergence GmbH
+ *   Johannes Stezenbach <js@convergence.de>
+ * test_tapdmx conversion is
+ *   Copyright (C) 2011 B1 Systems GmbH
+ *   Stefan Seyfried <seife+dvb@b1-systems.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU Lesser General Public License
+ * as published by the Free Software Foundation; either version 2.1
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU Lesser General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA.
+ */
+
+//hm, I haven't tested writing large files yet... maybe it works
+#define _LARGEFILE64_SOURCE
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <sys/ioctl.h>
+#include <errno.h>
+#include <inttypes.h>
+
+#include <linux/dvb/dmx.h>
+
+static unsigned long BUF_SIZE = 64 * 1024;
+static unsigned long long total_bytes;
+
+static void usage(void)
+{
+	fprintf(stderr, "usage: test_tapdmx file PID [more PIDs...]\n"
+			"       record a partial TS stream consisting of TS packets\n"
+			"       with the selected PIDs to the given file.\n"
+			"       Use PID 0x2000 to record the full TS stream (if\n"
+			"       the hardware supports it).\n"
+			"       The demux device used can be changed by setting\n"
+			"       the environment variable DEMUX.\n"
+			"       You can override the input buffer size by setting BUF_SIZE to\n"
+			"       the number of bytes wanted.\n"
+			"       Note: There is no output buffering, so writing to stdout is\n"
+			"       not really supported, but you can try something like:\n"
+			"       BUF_SIZE=188 ./test_tapdmx /dev/stdout 0 2>/dev/null | xxd\n"
+			"       ./test_tapdmx /dev/stdout 0x100 0x110 2>/dev/null| xine stdin://mpeg2\n"
+			"\n");
+	exit(1);
+}
+
+
+static void process_data(int dvrfd, int tsfd)
+{
+	uint8_t buf[BUF_SIZE];
+	int bytes, b2;
+
+	bytes = read(dvrfd, buf, sizeof(buf));
+	if (bytes < 0) {
+		perror("read");
+		if (errno == EOVERFLOW)
+			return;
+		fprintf(stderr, "exiting due to read() error\n");
+		exit(1);
+	}
+	total_bytes += bytes;
+	b2 = write(tsfd, buf, bytes);
+	if (b2 == -1) {
+		perror("write");
+		exit(1);
+	} else if (b2 < bytes)
+		fprintf(stderr, "warning: read %d, but wrote only %d bytes\n", bytes, b2);
+	else
+		fprintf(stderr, "got %d bytes (%llu total)\n", bytes, total_bytes);
+}
+
+int main(int argc, char *argv[])
+{
+	int dmxfd, tsfd;
+	unsigned int pid;
+	struct dmx_pes_filter_params f;
+	char *dmxdev = "/dev/dvb/adapter0/demux0";
+	int i;
+	char *chkp;
+
+	if (argc < 3)
+		usage();
+
+	if (getenv("DEMUX"))
+		dmxdev = getenv("DEMUX");
+
+	fprintf(stderr, "using '%s'\n"
+		"writing to '%s'\n", dmxdev, argv[1]);
+	tsfd = open(argv[1], O_WRONLY | O_CREAT | O_TRUNC | O_LARGEFILE, 0664);
+	if (tsfd == -1) {
+		perror("cannot write output file");
+		return 1;
+	}
+
+	dmxfd = open(dmxdev, O_RDONLY);
+	if (dmxfd == -1) {
+		perror("cannot open dmx device");
+		return 1;
+	}
+
+	if (getenv("BUF_SIZE") && ((BUF_SIZE = strtoul(getenv("BUF_SIZE"), NULL, 0)) > 0))
+		fprintf(stderr, "BUF_SIZE = %lu\n", BUF_SIZE);
+
+	pid = strtoul(argv[2], &chkp, 0);
+	if (pid > 0x2000 || chkp == argv[2])
+		usage();
+	fprintf(stderr, "adding filter for PID 0x%04x\n", pid);
+
+	memset(&f, 0, sizeof(f));
+	f.pid = (uint16_t) pid;
+	f.input = DMX_IN_FRONTEND;
+	f.output = DMX_OUT_TSDEMUX_TAP;
+	f.pes_type = DMX_PES_OTHER;
+
+	if (ioctl(dmxfd, DMX_SET_PES_FILTER, &f) == -1) {
+		perror("DMX_SET_PES_FILTER");
+		return 1;
+	}
+
+	for (i = 3; i < argc; i++) {
+		pid = strtoul(argv[i], &chkp, 0);
+		if (pid > 0x2000 || chkp == argv[i])
+			usage();
+		fprintf(stderr, "adding filter for PID 0x%04x\n", pid);
+		if (ioctl(dmxfd, DMX_ADD_PID, &pid) == -1) {
+			perror("DMX_ADD_PID");
+			return 1;
+		}
+	}
+	if (ioctl(dmxfd, DMX_START) == -1) {
+		perror("DMX_START");
+		close(dmxfd);
+		return 1;
+	}
+
+	for (;;) {
+		process_data(dmxfd, tsfd);
+	}
+
+	close(dmxfd);
+	return 0;
+}

-- 
Stefan Seyfried

"Dispatch war rocket Ajax to bring back his body!"
--MP_/otR5yRpeBJcupAbuq86PzVT
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=dvb-apps-test_tapdmx.diff

# HG changeset patch
# User Stefan Seyfried <seife+dvb@b1-systems.com>
# Date 1310293978 -7200
# Node ID 0326ba8a015935abfd95f2909abd0d357a4be547
# Parent  148ede2a6809766a4ba4dd29bac896b3291b3efe
add test_tapdmx, like test_dvr but using DMX_OUT_TSDEMUX_TAP

diff --git a/test/Makefile b/test/Makefile
--- a/test/Makefile
+++ b/test/Makefile
@@ -10,6 +10,7 @@
            test_av         \
            test_av_play    \
            test_dvr        \
+           test_tapdmx     \
            test_dvr_play   \
            test_pes        \
            test_sec_ne     \
diff --git a/test/test_tapdmx.c b/test/test_tapdmx.c
new file mode 100644
--- /dev/null
+++ b/test/test_tapdmx.c
@@ -0,0 +1,160 @@
+/* test_tapdmx.c - Test recording a TS from the dmx device.
+ * very similar to test_dvr but using the new DMX_OUT_TSDEMUX_TAP
+ * usage: test_tapdmx PID [more PIDs...]
+ *
+ * test_dvr is
+ *   Copyright (C) 2003 convergence GmbH
+ *   Johannes Stezenbach <js@convergence.de>
+ * test_tapdmx conversion is
+ *   Copyright (C) 2011 B1 Systems GmbH
+ *   Stefan Seyfried <seife+dvb@b1-systems.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU Lesser General Public License
+ * as published by the Free Software Foundation; either version 2.1
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU Lesser General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA.
+ */
+
+//hm, I haven't tested writing large files yet... maybe it works
+#define _LARGEFILE64_SOURCE
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <sys/ioctl.h>
+#include <errno.h>
+#include <inttypes.h>
+
+#include <linux/dvb/dmx.h>
+
+static unsigned long BUF_SIZE = 64 * 1024;
+static unsigned long long total_bytes;
+
+static void usage(void)
+{
+	fprintf(stderr, "usage: test_tapdmx file PID [more PIDs...]\n"
+			"       record a partial TS stream consisting of TS packets\n"
+			"       with the selected PIDs to the given file.\n"
+			"       Use PID 0x2000 to record the full TS stream (if\n"
+			"       the hardware supports it).\n"
+			"       The demux device used can be changed by setting\n"
+			"       the environment variable DEMUX.\n"
+			"       You can override the input buffer size by setting BUF_SIZE to\n"
+			"       the number of bytes wanted.\n"
+			"       Note: There is no output buffering, so writing to stdout is\n"
+			"       not really supported, but you can try something like:\n"
+			"       BUF_SIZE=188 ./test_tapdmx /dev/stdout 0 2>/dev/null | xxd\n"
+			"       ./test_tapdmx /dev/stdout 0x100 0x110 2>/dev/null| xine stdin://mpeg2\n"
+			"\n");
+	exit(1);
+}
+
+
+static void process_data(int dvrfd, int tsfd)
+{
+	uint8_t buf[BUF_SIZE];
+	int bytes, b2;
+
+	bytes = read(dvrfd, buf, sizeof(buf));
+	if (bytes < 0) {
+		perror("read");
+		if (errno == EOVERFLOW)
+			return;
+		fprintf(stderr, "exiting due to read() error\n");
+		exit(1);
+	}
+	total_bytes += bytes;
+	b2 = write(tsfd, buf, bytes);
+	if (b2 == -1) {
+		perror("write");
+		exit(1);
+	} else if (b2 < bytes)
+		fprintf(stderr, "warning: read %d, but wrote only %d bytes\n", bytes, b2);
+	else
+		fprintf(stderr, "got %d bytes (%llu total)\n", bytes, total_bytes);
+}
+
+int main(int argc, char *argv[])
+{
+	int dmxfd, tsfd;
+	unsigned int pid;
+	struct dmx_pes_filter_params f;
+	char *dmxdev = "/dev/dvb/adapter0/demux0";
+	int i;
+	char *chkp;
+
+	if (argc < 3)
+		usage();
+
+	if (getenv("DEMUX"))
+		dmxdev = getenv("DEMUX");
+
+	fprintf(stderr, "using '%s'\n"
+		"writing to '%s'\n", dmxdev, argv[1]);
+	tsfd = open(argv[1], O_WRONLY | O_CREAT | O_TRUNC | O_LARGEFILE, 0664);
+	if (tsfd == -1) {
+		perror("cannot write output file");
+		return 1;
+	}
+
+	dmxfd = open(dmxdev, O_RDONLY);
+	if (dmxfd == -1) {
+		perror("cannot open dmx device");
+		return 1;
+	}
+
+	if (getenv("BUF_SIZE") && ((BUF_SIZE = strtoul(getenv("BUF_SIZE"), NULL, 0)) > 0))
+		fprintf(stderr, "BUF_SIZE = %lu\n", BUF_SIZE);
+
+	pid = strtoul(argv[2], &chkp, 0);
+	if (pid > 0x2000 || chkp == argv[2])
+		usage();
+	fprintf(stderr, "adding filter for PID 0x%04x\n", pid);
+
+	memset(&f, 0, sizeof(f));
+	f.pid = (uint16_t) pid;
+	f.input = DMX_IN_FRONTEND;
+	f.output = DMX_OUT_TSDEMUX_TAP;
+	f.pes_type = DMX_PES_OTHER;
+
+	if (ioctl(dmxfd, DMX_SET_PES_FILTER, &f) == -1) {
+		perror("DMX_SET_PES_FILTER");
+		return 1;
+	}
+
+	for (i = 3; i < argc; i++) {
+		pid = strtoul(argv[i], &chkp, 0);
+		if (pid > 0x2000 || chkp == argv[i])
+			usage();
+		fprintf(stderr, "adding filter for PID 0x%04x\n", pid);
+		if (ioctl(dmxfd, DMX_ADD_PID, &pid) == -1) {
+			perror("DMX_ADD_PID");
+			return 1;
+		}
+	}
+	if (ioctl(dmxfd, DMX_START) == -1) {
+		perror("DMX_START");
+		close(dmxfd);
+		return 1;
+	}
+
+	for (;;) {
+		process_data(dmxfd, tsfd);
+	}
+
+	close(dmxfd);
+	return 0;
+}

--MP_/otR5yRpeBJcupAbuq86PzVT--
