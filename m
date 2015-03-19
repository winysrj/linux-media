Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:47124 "EHLO gofer.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751604AbbCSVvK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Mar 2015 17:51:10 -0400
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>
Subject: [RFC PATCH] ir: add tools for receiving and sending ir
Date: Thu, 19 Mar 2015 21:51:08 +0000
Message-Id: <1426801868-855-1-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Provide simple tools for displaying raw IR and received scancodes, and
sending them.

Todo:
 - ir-rec cannot enable protocol decoders
 - ir-send should accept scancode on commandline
 - long options

Signed-off-by: Sean Young <sean@mess.org>
---
 configure.ac          |   3 +
 utils/Makefile.am     |   1 +
 utils/ir/.gitignore   |   4 +
 utils/ir/Makefile.am  |   6 +
 utils/ir/ir-rec.1.in  |  68 +++++++++++
 utils/ir/ir-rec.c     | 224 ++++++++++++++++++++++++++++++++++
 utils/ir/ir-send.1.in |  48 ++++++++
 utils/ir/ir-send.c    | 329 ++++++++++++++++++++++++++++++++++++++++++++++++++
 utils/ir/lirc.h       | 163 +++++++++++++++++++++++++
 v4l-utils.spec.in     |   8 +-
 10 files changed, 852 insertions(+), 2 deletions(-)
 create mode 100644 utils/ir/.gitignore
 create mode 100644 utils/ir/Makefile.am
 create mode 100644 utils/ir/ir-rec.1.in
 create mode 100644 utils/ir/ir-rec.c
 create mode 100644 utils/ir/ir-send.1.in
 create mode 100644 utils/ir/ir-send.c
 create mode 100644 utils/ir/lirc.h

diff --git a/configure.ac b/configure.ac
index de54d63..d941f33 100644
--- a/configure.ac
+++ b/configure.ac
@@ -23,6 +23,7 @@ AC_CONFIG_FILES([Makefile
 	utils/libmedia_dev/Makefile
 	utils/decode_tm6000/Makefile
 	utils/dvb/Makefile
+	utils/ir/Makefile
 	utils/keytable/Makefile
 	utils/media-ctl/Makefile
 	utils/rds/Makefile
@@ -53,6 +54,8 @@ AC_CONFIG_FILES([Makefile
 
 	utils/qv4l2/qv4l2.1
 	utils/v4l2-compliance/v4l2-compliance.1
+	utils/ir/ir-rec.1
+	utils/ir/ir-send.1
 	utils/keytable/ir-keytable.1
 	utils/dvb/dvb-fe-tool.1
 	utils/dvb/dvbv5-scan.1
diff --git a/utils/Makefile.am b/utils/Makefile.am
index 31b2979..f46b87b 100644
--- a/utils/Makefile.am
+++ b/utils/Makefile.am
@@ -3,6 +3,7 @@ SUBDIRS = \
 	libv4l2util \
 	libmedia_dev \
 	decode_tm6000 \
+	ir \
 	keytable \
 	media-ctl \
 	v4l2-compliance \
diff --git a/utils/ir/.gitignore b/utils/ir/.gitignore
new file mode 100644
index 0000000..bdecfc2
--- /dev/null
+++ b/utils/ir/.gitignore
@@ -0,0 +1,4 @@
+ir-rec
+ir-rec.1
+ir-send
+ir-send.1
diff --git a/utils/ir/Makefile.am b/utils/ir/Makefile.am
new file mode 100644
index 0000000..771f197
--- /dev/null
+++ b/utils/ir/Makefile.am
@@ -0,0 +1,6 @@
+bin_PROGRAMS = ir-rec ir-send
+man_MANS = ir-rec.1 ir-send.1
+
+ir_rec_SOURCES = ir-rec.c
+ir_send_SOURCES = ir-send.c
+
diff --git a/utils/ir/ir-rec.1.in b/utils/ir/ir-rec.1.in
new file mode 100644
index 0000000..36d1472
--- /dev/null
+++ b/utils/ir/ir-rec.1.in
@@ -0,0 +1,68 @@
+.TH "IR\-REC" "1" "Mon Mar 16 2015" "v4l-utils @PACKAGE_VERSION@" "User Commands"
+.SH NAME
+ir\-rec \- shows infrared signals
+.SH SYNOPSIS
+.B ir\-rec
+[\fIOPTION\fR]...
+.SH DESCRIPTION
+ir\-rec is a tool that shows infrared (IR) signals directly from the lirc 
+device on stdout.
+.PP 
+.SH OPTIONS
+.TP 
+\fB\-d\fR \fIDEV\fR
+lirc device, /dev/lirc0 by default.
+.TP 
+\fB\-c\fR
+Enable carrier detection if the hardware supports it.
+.TP 
+\fB\-r\fR
+Only display raw IR.
+.TP 
+\fB\-s\fR
+Only display decoded scancodes.
+.TP 
+\fB\-f\fR \fIFILE\fR
+Write the output to a file rather than stdout.
+.TP
+\fB\-h\fR
+Prints the help message
+.SH EXAMPLES
+Pressing \fBplay\fR on a Hauppauge rc5 remote results in:
+.PP
+.nf
+$ ir-rec
+pulse 950
+space 850
+pulse 1750
+space 1800
+pulse 850
+space 900
+pulse 900
+space 850
+pulse 900
+space 900
+pulse 1750
+space 1750
+pulse 900
+space 900
+pulse 1750
+space 1800
+pulse 1750
+space 1750
+pulse 900
+scancode rc5 7733
+.fi
+.SH EXIT STATUS
+On success, it returns 0. Otherwise, it will return the error code.
+.SH BUGS
+Report bugs to \fBLinux Media Mailing List <linux-media@vger.kernel.org>\fR
+.SH SEE ALSO
+\fBir-send\fR(1)
+.SH AUTHOR
+Copyright (C) 2015 Sean Young
+.PP 
+License GPLv2: GNU GPL version 2+ <http://gnu.org/licenses/gpl.html>.
+.br 
+This is free software: you are free to change and redistribute it.
+There is NO WARRANTY, to the extent permitted by law.
diff --git a/utils/ir/ir-rec.c b/utils/ir/ir-rec.c
new file mode 100644
index 0000000..5970549
--- /dev/null
+++ b/utils/ir/ir-rec.c
@@ -0,0 +1,224 @@
+/*
+ Copyright (C) 2015 Sean Young <sean@mess.org>
+ */
+#include <sys/types.h>
+#include <sys/ioctl.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include "lirc.h"
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <stdbool.h>
+#include <string.h>
+#include <errno.h>
+
+/*
+ TODO
+  - list devices and their properties including rx resolution
+  - wideband receiver
+  - receiver carrier range
+  - duty cycle
+*/
+#define DEFAULT_DEVICE "/dev/lirc0"
+
+const static char *protocols[] = {
+	"unknown",
+	"other",
+	"rc5",
+	"rc5x",
+	"rc5sz",
+	"jvc",
+	"sony12",
+	"sony15",
+	"sony20",
+	"nec",
+	"sanyo",
+	"mce_kbd",
+	"rc6_0",
+	"rc6_6a_20",
+	"rc6_6a_24",
+	"rc6_6a_32",
+	"rc6_mce",
+	"sharp",
+	"xmp"
+};
+
+#define MAX_PROTOCOL (sizeof(protocols)/sizeof(protocols[0]))
+
+static void usage(const char *name)
+{
+	printf("Usage:\n"
+		" %s [options]\n"
+		"\n"
+		"Options:\n"
+		" -d device\tlirc device (" DEFAULT_DEVICE " by default)\n"
+		" -c\t\tEnable carrier reports\n"
+		" -h\t\tThis help text\n"
+		" -r\t\tRaw IR only\n"
+		" -s\t\tscancodes only\n"
+		" -f file\tWrite to file rather than stdout\n", name);
+}
+
+int main(int argc, char *argv[])
+{
+	char *dev = DEFAULT_DEVICE, *output = NULL;
+	int rc, fd, last = 0, mode;
+	bool carrier_report = false;
+	unsigned features;
+	unsigned buf[4096];
+	bool raw = false, scancodes = false;
+	FILE *outfile;
+
+	while ((rc = getopt(argc, argv, "srf:hd:c")) != -1) {
+		switch (rc)
+		{
+		case 'r':
+			raw = true;
+			break;
+		case 's':
+			scancodes = true;
+			break;
+		case 'f':
+			output = strdupa(optarg);
+			break;
+		case 'c':
+			carrier_report = true;
+			break;
+		case 'd':
+			dev = strdupa(optarg);
+			break;
+		case 'h':
+			usage(argv[0]);
+			exit(EXIT_SUCCESS);
+		case '?':
+			fprintf(stderr, "error: invalid argument -%c\n",optopt);
+			exit(EXIT_FAILURE);
+		}
+	}
+
+	if (optind < argc) {
+		fprintf(stderr, "error: invalid argument '%s'\n", argv[optind]);
+		exit(EXIT_FAILURE);
+	}
+
+	fd = TEMP_FAILURE_RETRY(open(dev, O_RDONLY));
+	if (fd == -1) {
+		fprintf(stderr, "%s: error: cannot open: %m\n", dev);
+		exit(EXIT_FAILURE);
+	}
+
+	rc = ioctl(fd, LIRC_GET_FEATURES, &features);
+	if (rc) {
+		fprintf(stderr, "%s: error: failed to get features: %m\n", dev);
+		exit(EXIT_FAILURE);
+	}
+
+	if (raw && !(features & LIRC_CAN_REC_MODE2)) {
+		fprintf(stderr, "%s: error: device does not support raw mode\n",
+									 dev);
+		exit(EXIT_FAILURE);
+	}
+
+	if (scancodes && !(features & LIRC_CAN_REC_SCANCODE)) {
+		fprintf(stderr, "%s: error: device does not support key code\n",
+									 dev);
+		exit(EXIT_FAILURE);
+	}
+
+	if (!(features & LIRC_CAN_MEASURE_CARRIER)) {
+		if (carrier_report)
+			fprintf(stderr, "%s: warning: cannot measure carrier\n",
+				dev);
+	} else {
+		rc = ioctl(fd, LIRC_SET_MEASURE_CARRIER_MODE, &carrier_report);
+		if (rc)
+			fprintf(stderr, "%s: warning: failed to set "
+				"measure carrier: %m\n", dev);
+	}
+
+	mode = LIRC_REC2MODE(LIRC_CAN_REC(features));
+	if (!raw && scancodes)
+		mode &= ~LIRC_MODE_MODE2;
+	if (!scancodes && raw)
+		mode &= ~LIRC_MODE_SCANCODE;
+
+	/*
+	 * Note that kernels that do not support LIRC_CAN_REC_SCANCODE also
+	 * ignore LIRC_SET_REC_MODE
+	 */
+	rc = ioctl(fd, LIRC_SET_REC_MODE, &mode);
+	if (rc) {
+		fprintf(stderr, "%s: warning: failed to set record mode: %m\n",
+									dev);
+		exit(EXIT_FAILURE);
+	}
+
+	if (output) {
+		outfile = fopen(output, "w");
+		if (!outfile) {
+			fprintf(stderr, "%s: error: failed to open: %m\n",
+								output);
+			exit(EXIT_FAILURE);
+		}
+	} else {
+		outfile = stdout;
+	}
+
+	do {
+		int i;
+
+		rc = TEMP_FAILURE_RETRY(read(fd, buf, sizeof(buf)));
+		if (rc == -1) {
+			fprintf(stderr, "%s: error: failed to read: %m\n", dev);
+			exit(EXIT_FAILURE);
+		}
+
+		if (rc % sizeof(unsigned)) {
+			fprintf(stderr, "%s: error: unexpected return value\n", dev);
+			break;
+		}
+
+		for (i=0; i<rc/sizeof(unsigned); i++) {
+			if (last) {
+				fprintf(outfile, " %u %s\n", buf[i],
+					last & LIRC_SCANCODE_TOGGLE ? "toggle" :
+					last & LIRC_SCANCODE_REPEAT ? "repeat" :
+									"" );
+				last = 0;
+				continue;
+			}
+			fflush(outfile);
+			unsigned val = buf[i] & LIRC_VALUE_MASK;
+			switch (buf[i] & LIRC_MODE2_MASK) {
+			case LIRC_MODE2_PULSE:
+				fprintf(outfile, "pulse %u\n", val);
+				break;
+			case LIRC_MODE2_SPACE:
+				fprintf(outfile, "space %u\n", val);
+				break;
+			case LIRC_MODE2_FREQUENCY:
+				fprintf(outfile, "carrier %u\n", val);
+				break;
+			case LIRC_MODE2_TIMEOUT:
+				fprintf(outfile, "timeout %u\n", val);
+				break;
+			case LIRC_MODE2_SCANCODE:
+				last = buf[i];
+				val = buf[i] & LIRC_SCANCODE_PROTOCOL_MASK;
+				if (val >= MAX_PROTOCOL)
+					fprintf(outfile, "scancode %u", val);
+				else
+					fprintf(outfile, "scancode %s",
+								protocols[val]);
+				break;
+			}
+		}
+	}
+	while (rc > 0);
+
+	close(fd);
+	fclose(outfile);
+
+	return 0;
+}
diff --git a/utils/ir/ir-send.1.in b/utils/ir/ir-send.1.in
new file mode 100644
index 0000000..8bbcdb3
--- /dev/null
+++ b/utils/ir/ir-send.1.in
@@ -0,0 +1,48 @@
+.TH "IR\-SEND" "1" "Mon Mar 16 2015" "v4l-utils @PACKAGE_VERSION@" "User Commands"
+.SH NAME
+ir\-send \- emit infrared signals
+.SH SYNOPSIS
+.B ir\-send
+[\fIOPTION\fR]...\fIFILE\fR
+.SH DESCRIPTION
+ir\-send is a tool that emits (or "blasts") infrared (IR) signals, listed in
+FILE.
+.PP
+.SH OPTIONS
+.TP
+\fB\-d\fR \fIDEV\fR
+lirc device, /dev/lirc0 by default.
+.TP
+\fB\-c\fR \fIcarrier\fR
+Set the carrier if the hardware supports it.
+.TP
+\fB-t\fR \fIemitter[,emitter]...\fR
+A comma seperated list of physical emitters used on the hardware.
+.TP
+\fB\-h\fR
+Prints the help message
+.PP
+Any line starting with # is considered a comment and ignored. Either the
+IR is encoded raw IR, with alternating pulse/space lines following by a
+duration in nanoseconds.
+.PP
+The alternative is a scancode in a particular protocol, where the format
+is "scancode PROTO SCANCODE [repeat] [toggle]". Proto is one of: \fBunknown\fR,
+\fBother\fR, \fB rc5\fR, \fB rc5x\fR, \fB rc5sz\fR, \fB jvc\fR, \fB sony12\fR, \fB sony15\fR, \fB sony20\fR, \fB nec\fR, \fB sanyo\fR, \fB mce_kbd\fR, \fB
+rc6_0\fR, \fB rc6_6a_20\fR, \fB rc6_6a_24\fR, \fB rc6_6a_32\fR, \fB rc6_mce\fR, \fB sharp\fR, \fB xmp\fR.
+Add \fBrepeat\fR for nec repeats or \fBtoggle\fR for rc5/r6 protocols, if desired.
+.SH EXAMPLES
+\fBscancode nec 43031\fR
+.SH EXIT STATUS
+On success, it returns 0. Otherwise, it will return the error code.
+.SH BUGS
+Report bugs to \fBLinux Media Mailing List <linux-media@vger.kernel.org>\fR
+.SH SEE ALSO
+\fBir-rec\fR(1)
+.SH AUTHOR
+Copyright (C) 2015 Sean Young
+.PP
+License GPLv2: GNU GPL version 2+ <http://gnu.org/licenses/gpl.html>.
+.br
+This is free software: you are free to change and redistribute it.
+There is NO WARRANTY, to the extent permitted by law.
diff --git a/utils/ir/ir-send.c b/utils/ir/ir-send.c
new file mode 100644
index 0000000..34401f5
--- /dev/null
+++ b/utils/ir/ir-send.c
@@ -0,0 +1,329 @@
+/*
+ * Copyright (C) 2015 Sean Young <sean@mess.org>
+ */
+#include <stdio.h>
+#include <stdlib.h>
+#include <stdbool.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <limits.h>
+#include <string.h>
+#include <ctype.h>
+#include <getopt.h>
+
+#include <sys/ioctl.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+
+#include "lirc.h"
+
+static char *dev = "/dev/lirc0";
+#define LIRCBUF_SIZE 256
+static int line;
+static char *irdata;
+
+const static char *protocols[] = {
+	"unknown",
+	"other",
+	"rc5",
+	"rc5x",
+	"rc5sz",
+	"jvc",
+	"sony12",
+	"sony15",
+	"sony20",
+	"nec",
+	"sanyo",
+	"mce_kbd",
+	"rc6_0",
+	"rc6_6a_20",
+	"rc6_6a_24",
+	"rc6_6a_32",
+	"rc6_mce",
+	"sharp",
+	"xmp",
+	NULL
+};
+
+int proto_to_int(const char *proto)
+{
+	int i;
+	char *end;
+	long p;
+
+	for (i=0; protocols[i]; i++) {
+		if (!strcasecmp(protocols[i], proto))
+			return i;
+	}
+	
+	p = strtol(proto, &end, 10);
+
+	if (*end != 0 || p < 0 || p > INT_MAX) {
+		fprintf(stderr, "%s:%d: protocol `%s' invalid\n", irdata, 
+								line, proto);
+		exit(EXIT_FAILURE);
+	}
+
+	return p;
+}
+
+static int parse_emitters(const char *str)
+{
+	int emitters = 0;
+	const char *p = str;
+	char *q;
+
+	while (*p) {
+		long emitter;
+
+		emitter = strtol(p, &q, 10);
+		if (p == q)
+			return -1;
+
+		if (emitter < 1 || emitters > 32)
+			return -1;
+
+		emitters |= 1 << (emitter - 1);
+		p = q;
+		while (isspace(*p)) p++;
+		if (*p == ',') {
+			p++;
+			continue;
+		}
+		if (*p)
+			return -1;
+	}
+
+	return emitters == 0 ? -1 : emitters;
+}
+
+void parse_and_send_scancode(int fd, char *str)
+{
+	unsigned code[2];
+	long s;
+	char *end;
+
+	/* scancode PROTO scancode [repeat] [toggle] */
+	str += 8;
+	char *proto = strtok_r(str, " \t\n", &end);
+	char *scancode = strtok_r(NULL, " \t\n", &end);
+	char *option = strtok_r(NULL, " \t\n", &end);
+
+	if (!proto) {
+		fprintf(stderr, "%s:%d: missing protocol\n", irdata, line);
+		exit(EXIT_FAILURE);
+	}
+
+	if (!scancode) {
+		fprintf(stderr, "%s:%d: missing scancode\n", irdata, line);
+		exit(EXIT_FAILURE);
+	}
+
+	code[0] = LIRC_MODE2_SCANCODE | proto_to_int(proto);
+
+	s = strtol(scancode, &end, 10);
+	if (*end != 0 || s < 0 || s > UINT_MAX) {
+		fprintf(stderr, "%s:%d: scancode `%s' invalid\n", irdata, line,
+								scancode);
+		exit(EXIT_FAILURE);
+	}
+
+	code[1] = s;
+	if (option) {
+		if (strcasecmp(option, "repeat") == 0)
+			code[0] |= LIRC_SCANCODE_REPEAT;
+		else if (strcasecmp(option, "toggle") == 0)
+			code[0] |= LIRC_SCANCODE_TOGGLE;
+		else if (*option != '#') { // not a comment
+			fprintf(stderr, "%s:%d: `%s' not expected\n", irdata,
+								line, option);
+			exit(EXIT_FAILURE);
+		}
+	}
+
+	unsigned mode = LIRC_MODE_SCANCODE;
+
+	if (ioctl(fd, LIRC_SET_SEND_MODE, &mode)) {
+		fprintf(stderr, "%s: error: failed to set scancode send mode: %m\n", dev);
+		exit(EXIT_FAILURE);
+	}
+
+	if (write(fd, code, sizeof(code)) == -1) {
+		fprintf(stderr, "%s: error: failed to transmit: %m\n", dev);
+		exit(EXIT_FAILURE);
+	}
+}
+
+void send_rawir(int fd, unsigned *codes, unsigned count)
+{
+	if (count == 0)
+		return;
+
+	if (!(count % 2)) 
+		count--;
+
+	unsigned mode = LIRC_MODE_PULSE;
+
+	if (ioctl(fd, LIRC_SET_SEND_MODE, &mode)) {
+		fprintf(stderr, "%s: error: failed to set raw ir send mode: %m\n", dev);
+		exit(EXIT_FAILURE);
+	}
+
+	if (write(fd, codes, count * sizeof(unsigned)) == -1) {
+		fprintf(stderr, "%s: error: failed to transmit: %m\n", dev);
+		exit(EXIT_FAILURE);
+	}
+}
+
+int main(int argc, char *argv[])
+{
+	unsigned codes[LIRCBUF_SIZE], count = 0;
+	char buf[1000];
+	int fd, carrier = 0, rc;
+	bool pulse = true;
+	FILE *file;
+	unsigned features;
+	int emitters = 0;
+
+	while ((rc = getopt(argc, argv, "t:d:c:h")) != -1) {
+		switch (rc) {
+		case 'd':
+			dev = strdup(optarg);
+			break;
+		case 'c':
+			carrier = atoi(optarg);
+			break;
+		case 't':
+			emitters = parse_emitters(optarg);
+			if (emitters == -1) {
+				fprintf(stderr, "cannot parse emitters: %s\n", optarg);
+				exit(EXIT_SUCCESS);
+			}
+		case 'h':
+			printf("Usage: %s [-d device] [-c carrier] [-t transmitters] file\n", argv[0]);
+			exit(EXIT_SUCCESS);
+		case '?':
+			fprintf(stderr, "error: invalid argument -%c\n", optopt);
+			exit(EXIT_FAILURE);
+		}
+	}
+
+	if (optind >= argc) {
+		irdata = "<stdin>";
+		file = stdin;
+	} else {
+		irdata = argv[optind++];
+
+		if (optind < argc) {
+			fprintf(stderr, "error: unexpected argument `%s'\n", 
+								argv[optind]);
+			exit(EXIT_FAILURE);
+		}
+
+		if (strcmp(irdata, "-")) {
+			file = fopen(irdata, "rt");
+
+			if (!file) {
+				printf("%s: cannot open: %m\n", irdata);
+				exit(EXIT_FAILURE);
+			}
+		} else {
+			irdata = "<stdin>";
+			file = stdin;
+		}
+	}
+
+	fd = open(dev, O_WRONLY);
+	if (fd == -1) {
+		perror(dev);
+		exit(EXIT_FAILURE);
+	}
+
+	if (ioctl(fd, LIRC_GET_FEATURES, &features)) {
+		fprintf(stderr, "%s: failed to get features: %m\n",  dev);
+		exit(EXIT_FAILURE);
+	}
+
+	if (!(features & LIRC_CAN_SEND_MASK)) {
+		fprintf(stderr, "%s: device cannot transmit\n",  dev);
+		exit(EXIT_FAILURE);
+	}
+
+	if (carrier) {
+		if (features & LIRC_CAN_SET_SEND_CARRIER) {
+			if (ioctl(fd, LIRC_SET_SEND_CARRIER, &carrier))
+				fprintf(stderr, "%s: failed to set carrier: %m\n", dev);
+		} else 
+			fprintf(stderr, 
+				"%s: carrier cannot be set on device\n", dev);
+	}
+
+	if (emitters) {
+		if (features & LIRC_CAN_SET_TRANSMITTER_MASK) {
+			rc = ioctl(fd, LIRC_SET_TRANSMITTER_MASK, &emitters); 
+			if (rc < 0)
+				fprintf(stderr, "%s: failed to set transmitters: %m\n", dev);
+			if (rc > 0)
+				fprintf(stderr, "%s: failed to set transmitters, number of emitters %d\n", dev, rc);
+				
+		} else 
+			fprintf(stderr, 
+				"%s: transmitters cannot be set on device\n", dev);
+	}
+
+	while (fgets(buf, sizeof(buf), file)) {
+		char *q = buf;
+		while (*q && isspace(*q)) q++;
+		line++;
+
+		if (*q == '#' || !*q) continue;
+
+		if (strncmp(q, "space", 5) == 0) {
+			q += 5;
+			while (*q && isspace(*q)) q++;
+			if (pulse) { 
+				printf("%s:%d: space not expected\n", irdata, line);
+			} else {
+				codes[count++] = atoi(q);
+			}
+			pulse = true;
+		} else if (strncmp(q, "pulse", 5) == 0) {
+			if (!(features & LIRC_CAN_SEND_MODE2)) {
+				fprintf(stderr, "%s: device does not support raw IR transmit\n", dev);
+				exit(EXIT_FAILURE);
+			}
+				
+			q += 5;
+			while (*q && isspace(*q)) q++;
+			if (pulse == false) { 
+				printf("%s:%d: pulse not expected\n", irdata, line);
+			} else {
+				codes[count++] = atoi(q);
+			}
+			pulse = false;
+		} else if (strncmp(q, "scancode", 8) == 0) {
+			if (!(features & LIRC_CAN_SEND_SCANCODE)) {
+				fprintf(stderr, "%s: device or kernel does not support scancode IR transmit\n", dev);
+				exit(EXIT_FAILURE);
+			}
+			send_rawir(fd, codes, count);
+			count = 0;
+			parse_and_send_scancode(fd, q);
+		} else {
+			printf("%s:%d: unexpected\n", irdata, line);
+		}
+
+		if (count == LIRCBUF_SIZE) {
+			fprintf(stderr, "%s: ir data too long\n", irdata);
+			exit(EXIT_FAILURE);
+		}
+	}
+
+	send_rawir(fd, codes, count);
+	fclose(file);
+	close(fd);
+
+	return 0;
+}
diff --git a/utils/ir/lirc.h b/utils/ir/lirc.h
new file mode 100644
index 0000000..3807ded
--- /dev/null
+++ b/utils/ir/lirc.h
@@ -0,0 +1,163 @@
+/*
+ * lirc.h - linux infrared remote control header file
+ * last modified 2010/07/13 by Jarod Wilson
+ */
+
+#ifndef _LINUX_LIRC_H
+#define _LINUX_LIRC_H
+
+#include <linux/types.h>
+#include <linux/ioctl.h>
+
+#define PULSE_BIT       0x01000000
+#define PULSE_MASK      0x00FFFFFF
+
+#define LIRC_MODE2_SPACE     0x00000000
+#define LIRC_MODE2_PULSE     0x01000000
+#define LIRC_MODE2_FREQUENCY 0x02000000
+#define LIRC_MODE2_TIMEOUT   0x03000000
+#define LIRC_MODE2_SCANCODE  0x04000000
+
+#define LIRC_VALUE_MASK      0x00FFFFFF
+#define LIRC_MODE2_MASK      0xFF000000
+
+#define LIRC_SPACE(val) (((val)&LIRC_VALUE_MASK) | LIRC_MODE2_SPACE)
+#define LIRC_PULSE(val) (((val)&LIRC_VALUE_MASK) | LIRC_MODE2_PULSE)
+#define LIRC_FREQUENCY(val) (((val)&LIRC_VALUE_MASK) | LIRC_MODE2_FREQUENCY)
+#define LIRC_TIMEOUT(val) (((val)&LIRC_VALUE_MASK) | LIRC_MODE2_TIMEOUT)
+
+#define LIRC_VALUE(val) ((val)&LIRC_VALUE_MASK)
+#define LIRC_MODE2(val) ((val)&LIRC_MODE2_MASK)
+
+#define LIRC_IS_SPACE(val) (LIRC_MODE2(val) == LIRC_MODE2_SPACE)
+#define LIRC_IS_PULSE(val) (LIRC_MODE2(val) == LIRC_MODE2_PULSE)
+#define LIRC_IS_FREQUENCY(val) (LIRC_MODE2(val) == LIRC_MODE2_FREQUENCY)
+#define LIRC_IS_TIMEOUT(val) (LIRC_MODE2(val) == LIRC_MODE2_TIMEOUT)
+#define LIRC_IS_SCANCODE(val) (LIRC_MODE2(val) == LIRC_MODE2_SCANCODE)
+
+#define LIRC_SCANCODE_TOGGLE		0x00800000
+#define LIRC_SCANCODE_REPEAT		0x00400000
+#define LIRC_SCANCODE_PROTOCOL_MASK	0x000000ff
+
+/* used heavily by lirc userspace */
+#define lirc_t int
+
+/*** lirc compatible hardware features ***/
+
+#define LIRC_MODE2SEND(x) (x)
+#define LIRC_SEND2MODE(x) (x)
+#define LIRC_MODE2REC(x) ((x) << 16)
+#define LIRC_REC2MODE(x) ((x) >> 16)
+
+#define LIRC_MODE_RAW                  0x00000001
+#define LIRC_MODE_PULSE                0x00000002
+#define LIRC_MODE_MODE2                0x00000004
+#define LIRC_MODE_SCANCODE             0x00000008
+#define LIRC_MODE_LIRCCODE             0x00000010
+
+
+#define LIRC_CAN_SEND_RAW              LIRC_MODE2SEND(LIRC_MODE_RAW)
+#define LIRC_CAN_SEND_PULSE            LIRC_MODE2SEND(LIRC_MODE_PULSE)
+#define LIRC_CAN_SEND_MODE2            LIRC_MODE2SEND(LIRC_MODE_MODE2)
+#define LIRC_CAN_SEND_LIRCCODE         LIRC_MODE2SEND(LIRC_MODE_LIRCCODE)
+#define LIRC_CAN_SEND_SCANCODE         LIRC_MODE2SEND(LIRC_MODE_SCANCODE)
+
+#define LIRC_CAN_SEND_MASK             0x0000003f
+
+#define LIRC_CAN_SET_SEND_CARRIER      0x00000100
+#define LIRC_CAN_SET_SEND_DUTY_CYCLE   0x00000200
+#define LIRC_CAN_SET_TRANSMITTER_MASK  0x00000400
+
+#define LIRC_CAN_REC_RAW               LIRC_MODE2REC(LIRC_MODE_RAW)
+#define LIRC_CAN_REC_PULSE             LIRC_MODE2REC(LIRC_MODE_PULSE)
+#define LIRC_CAN_REC_MODE2             LIRC_MODE2REC(LIRC_MODE_MODE2)
+#define LIRC_CAN_REC_LIRCCODE          LIRC_MODE2REC(LIRC_MODE_LIRCCODE)
+#define LIRC_CAN_REC_SCANCODE          LIRC_MODE2REC(LIRC_MODE_SCANCODE)
+
+#define LIRC_CAN_REC_MASK              LIRC_MODE2REC(LIRC_CAN_SEND_MASK)
+
+#define LIRC_CAN_SET_REC_CARRIER_RANGE    0x80000000
+#define LIRC_CAN_GET_REC_RESOLUTION       0x20000000
+#define LIRC_CAN_SET_REC_TIMEOUT          0x10000000
+#define LIRC_CAN_SET_REC_FILTER           0x08000000
+#define LIRC_CAN_USE_WIDEBAND_RECEIVER    0x04000000
+#define LIRC_CAN_MEASURE_CARRIER          0x02000000
+#define LIRC_CAN_SET_REC_CARRIER          0x01000000
+
+#define LIRC_CAN_SEND(x) ((x)&LIRC_CAN_SEND_MASK)
+#define LIRC_CAN_REC(x) ((x)&LIRC_CAN_REC_MASK)
+
+/*** IOCTL commands for lirc driver ***/
+
+#define LIRC_GET_FEATURES              _IOR('i', 0x00000000, __u32)
+
+#define LIRC_GET_SEND_MODE             _IOR('i', 0x00000001, __u32)
+#define LIRC_GET_REC_MODE              _IOR('i', 0x00000002, __u32)
+#define LIRC_GET_SEND_CARRIER          _IOR('i', 0x00000003, __u32)
+#define LIRC_GET_REC_CARRIER           _IOR('i', 0x00000004, __u32)
+#define LIRC_GET_SEND_DUTY_CYCLE       _IOR('i', 0x00000005, __u32)
+#define LIRC_GET_REC_RESOLUTION        _IOR('i', 0x00000007, __u32)
+
+#define LIRC_GET_MIN_TIMEOUT           _IOR('i', 0x00000008, __u32)
+#define LIRC_GET_MAX_TIMEOUT           _IOR('i', 0x00000009, __u32)
+
+#define LIRC_GET_MIN_FILTER_PULSE      _IOR('i', 0x0000000a, __u32)
+#define LIRC_GET_MAX_FILTER_PULSE      _IOR('i', 0x0000000b, __u32)
+#define LIRC_GET_MIN_FILTER_SPACE      _IOR('i', 0x0000000c, __u32)
+#define LIRC_GET_MAX_FILTER_SPACE      _IOR('i', 0x0000000d, __u32)
+
+/* code length in bits, currently only for LIRC_MODE_LIRCCODE */
+#define LIRC_GET_LENGTH                _IOR('i', 0x0000000f, __u32)
+
+#define LIRC_SET_SEND_MODE             _IOW('i', 0x00000011, __u32)
+#define LIRC_SET_REC_MODE              _IOW('i', 0x00000012, __u32)
+/* Note: these can reset the according pulse_width */
+#define LIRC_SET_SEND_CARRIER          _IOW('i', 0x00000013, __u32)
+#define LIRC_SET_REC_CARRIER           _IOW('i', 0x00000014, __u32)
+#define LIRC_SET_SEND_DUTY_CYCLE       _IOW('i', 0x00000015, __u32)
+#define LIRC_SET_TRANSMITTER_MASK      _IOW('i', 0x00000017, __u32)
+
+/*
+ * when a timeout != 0 is set the driver will send a
+ * LIRC_MODE2_TIMEOUT data packet, otherwise LIRC_MODE2_TIMEOUT is
+ * never sent, timeout is disabled by default
+ */
+#define LIRC_SET_REC_TIMEOUT           _IOW('i', 0x00000018, __u32)
+
+/* 1 enables, 0 disables timeout reports in MODE2 */
+#define LIRC_SET_REC_TIMEOUT_REPORTS   _IOW('i', 0x00000019, __u32)
+
+/*
+ * pulses shorter than this are filtered out by hardware (software
+ * emulation in lirc_dev?)
+ */
+#define LIRC_SET_REC_FILTER_PULSE      _IOW('i', 0x0000001a, __u32)
+/*
+ * spaces shorter than this are filtered out by hardware (software
+ * emulation in lirc_dev?)
+ */
+#define LIRC_SET_REC_FILTER_SPACE      _IOW('i', 0x0000001b, __u32)
+/*
+ * if filter cannot be set independently for pulse/space, this should
+ * be used
+ */
+#define LIRC_SET_REC_FILTER            _IOW('i', 0x0000001c, __u32)
+
+/*
+ * if enabled from the next key press on the driver will send
+ * LIRC_MODE2_FREQUENCY packets
+ */
+#define LIRC_SET_MEASURE_CARRIER_MODE	_IOW('i', 0x0000001d, __u32)
+
+/*
+ * to set a range use LIRC_SET_REC_CARRIER_RANGE with the
+ * lower bound first and later LIRC_SET_REC_CARRIER with the upper bound
+ */
+#define LIRC_SET_REC_CARRIER_RANGE     _IOW('i', 0x0000001f, __u32)
+
+#define LIRC_SETUP_START               _IO('i', 0x00000021)
+#define LIRC_SETUP_END                 _IO('i', 0x00000022)
+
+#define LIRC_SET_WIDEBAND_RECEIVER     _IOW('i', 0x00000023, __u32)
+
+#endif
diff --git a/v4l-utils.spec.in b/v4l-utils.spec.in
index dd8959b..6eeca9c 100644
--- a/v4l-utils.spec.in
+++ b/v4l-utils.spec.in
@@ -17,8 +17,8 @@ Requires:       libv4l = %{version}-%{release}
 
 %description
 v4l-utils is a collection of various video4linux (V4L) and DVB utilities. The
-main v4l-utils package contains cx18-ctl, ir-keytable, ivtv-ctl, v4l2-ctl and
-v4l2-sysfs-path.
+main v4l-utils package contains cx18-ctl, ir-keytable, ir-rec, ir-send, 
+ivtv-ctl, v4l2-ctl and v4l2-sysfs-path.
 
 
 %package        devel-tools
@@ -129,10 +129,14 @@ gtk-update-icon-cache %{_datadir}/icons/hicolor &>/dev/null || :
 %config(noreplace) %{_sysconfdir}/udev/rules.d/70-infrared.rules
 %{_bindir}/cx18-ctl
 %{_bindir}/ir-keytable
+%{_bindir}/ir-rec
+%{_bindir}/ir-send
 %{_bindir}/ivtv-ctl
 %{_bindir}/v4l2-ctl
 %{_bindir}/v4l2-sysfs-path
 %{_mandir}/man1/ir-keytable.1*
+%{_mandir}/man1/ir-rec.1*
+%{_mandir}/man1/ir-send.1*
 
 %files devel-tools
 %defattr(-,root,root,-)
-- 
2.1.0

