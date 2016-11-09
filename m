Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:43699 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753047AbcKIQNi (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 9 Nov 2016 11:13:38 -0500
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: linux-media@vger.kernel.org
Subject: [PATCH v4l-utils 1/3] ir-ctl: add ability to send scancodes in most protocols
Date: Wed,  9 Nov 2016 16:13:31 +0000
Message-Id: <1478708015-1164-1-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Teach ir-ctl to send scancodes. This has a number of uses:

1. Controlling devices through IR transmission aka blasting
2. Testing the in-kernel software IR decoders (2 bugs uncovered so far)
3. Testing the capability of hardware IR decoders

All protocols supported by the kernel are supported except for XMP
and the MCE Keyboard.

Signed-off-by: Sean Young <sean@mess.org>
---
 utils/ir-ctl/Makefile.am |   2 +-
 utils/ir-ctl/ir-ctl.1.in |  82 ++++++---
 utils/ir-ctl/ir-ctl.c    | 130 ++++++++++++++-
 utils/ir-ctl/ir-encode.c | 427 +++++++++++++++++++++++++++++++++++++++++++++++
 utils/ir-ctl/ir-encode.h |  35 ++++
 5 files changed, 653 insertions(+), 23 deletions(-)
 create mode 100644 utils/ir-ctl/ir-encode.c
 create mode 100644 utils/ir-ctl/ir-encode.h

diff --git a/utils/ir-ctl/Makefile.am b/utils/ir-ctl/Makefile.am
index 9a1bfed..4c148e5 100644
--- a/utils/ir-ctl/Makefile.am
+++ b/utils/ir-ctl/Makefile.am
@@ -1,6 +1,6 @@
 bin_PROGRAMS = ir-ctl
 man_MANS = ir-ctl.1
 
-ir_ctl_SOURCES = ir-ctl.c
+ir_ctl_SOURCES = ir-ctl.c ir-encode.c
 ir_ctl_LDADD = @LIBINTL@
 ir_ctl_LDFLAGS = $(ARGP_LIBS)
diff --git a/utils/ir-ctl/ir-ctl.1.in b/utils/ir-ctl/ir-ctl.1.in
index 4bdf47e..2efe293 100644
--- a/utils/ir-ctl/ir-ctl.1.in
+++ b/utils/ir-ctl/ir-ctl.1.in
@@ -12,10 +12,13 @@ ir\-ctl \- a swiss\-knife tool to handle raw IR and to set lirc options
 [\fIOPTION\fR]... \fI\-\-send\fR [\fIpulse and space file to send\fR]
 .br
 .B ir\-ctl
+[\fIOPTION\fR]... \fI\-\-scancode\fR [\fIprotocol and scancode to send\fR]
+.br
+.B ir\-ctl
 [\fIOPTION\fR]... \fI\-\-record\fR [\fIsave to file\fR]
 .SH DESCRIPTION
 ir\-ctl is a tool that allows one to list the features of a lirc device,
-set its options, record raw IR and send raw IR.
+set its options, record raw IR, send raw IR or send complete IR scancodes.
 .PP
 Note: You need to have read or write permissions on the /dev/lirc device
 for options to work.
@@ -36,6 +39,10 @@ Send IR in text file. It must be in the format described below. If this
 option is specified multiple times, send all files in order with 125ms delay
 between them.
 .TP
+\fB-S\fR, \fB\-\-scancode\fR=\fIPROTOCOL:SCANCODE\fR
+Send the IR scancode in the protocol specified. The protocol must one of
+the protocols listed below, followed by a semicolon and the scancode number.
+.TP
 \fB\-1\fR, \fB\-\-oneshot\fR
 When recording, stop recording after the first message, i.e. after a space or
 timeout of more than 19ms is received.
@@ -106,43 +113,74 @@ by length in microseconds. The following is a rc-5 encoded message:
 .PP
 	carrier 36000
 .br
-	pulse 920
+	pulse 940
+.br
+	space 860
+.br
+	pulse 1790
+.br
+	space 1750
+.br
+	pulse 880
 .br
-	space 110
+	space 880
 .br
-	pulse 270
+	pulse 900
 .br
-	space 380
+	space 890
 .br
-	pulse 1800
+	pulse 870
 .br
-	space 1560
+	space 900
 .br
-	pulse 1730
+	pulse 1750
 .br
-	space 1630
+	space 900
 .br
-	pulse 1730
+	pulse 890
 .br
-	space 1640
+	space 910
 .br
-	pulse 850
+	pulse 840
 .br
-	space 830
+	space 920
 .br
-	pulse 1690
+	pulse 870
 .br
-	space 820
+	space 920
 .br
-	pulse 860
+	pulse 840
 .br
-	space 1660
+	space 920
 .br
-	pulse 1690
+	pulse 870
 .br
-	space 830
+	space 1810
 .br
-	pulse 850
+	pulse 840
+.PP
+Rather than specifying the raw IR, you can also specify the scancode and
+protocol you want to send. This will also automatically set the correct
+carrier. The above can be written as:
+.PP
+	scancode rc5:0x1e01
+.PP
+Do not specify scancodes with different protocols in one file, as the
+carrier might differ and the transmitter cannot send this. Multiple
+scancodes can be specified in one file but ensure that the rules for the
+protocol are met by inserting an appropriate space between them. Also,
+there are limits to what lirc devices can send in one go.
+.PP
+.SS Supported Protocols
+A scancode with protocol can be specified on the command line or in the
+pulse and space file. The following protocols are supported:
+\fBrc5\fR, \fBrc5x\fR, \fBrc5_sz\fR, \fBjvc\fR, \fBsony12\fR, \fBsony\fB15\fR,
+\fBsony20\fR, \fBnec\fR, \fBnecx\fR, \fBnec32\fR, \fBsanyo\fR, \fBrc6_0\fR,
+\fBrc6_6a_20\fR, \fBrc6_6a_24\fR, \fBrc6_6a_32\fR, \fBrc6_mce\fR, \fBsharp\fR.
+If the scancode starts with 0x it will be interpreted as a
+hexidecimal number, and if it starts with 0 it will be interpreted as an
+octal number.
+.PP
 .SS Wideband and narrowband receiver
 Most IR receivers have a narrowband and wideband receiver. The narrowband
 receiver can receive over longer distances (usually around 10 metres without
@@ -178,6 +216,10 @@ To send the pulse and space file \fBplay\fR on emitter 3:
 .br
 	\fBir\-ctl \-e 3 \-\-send=play\fR
 .PP
+To send the rc-5 hauppuage '1' scancode:
+.br
+	\fBir\-ctl \-S rc5:0x1e01
+.PP
 To restore the IR receiver on /dev/lirc2 to the default state:
 .br
 	\fBir\-ctl \-PMn \-\-timeout 125000 \-\-device=/dev/lirc2\fR
diff --git a/utils/ir-ctl/ir-ctl.c b/utils/ir-ctl/ir-ctl.c
index 2f85e6d..bdea741 100644
--- a/utils/ir-ctl/ir-ctl.c
+++ b/utils/ir-ctl/ir-ctl.c
@@ -26,6 +26,8 @@
 
 #include <config.h>
 
+#include "ir-encode.h"
+
 #include <linux/lirc.h>
 
 #ifdef ENABLE_NLS
@@ -82,6 +84,7 @@ static const struct argp_option options[] = {
 	{ "features",	'f',	0,		0,	N_("list lirc device features") },
 	{ "record",	'r',	N_("FILE"),	OPTION_ARG_OPTIONAL,	N_("record IR to stdout or file") },
 	{ "send",	's',	N_("FILE"),	0,	N_("send IR pulse and space file") },
+	{ "scancode", 'S',	N_("SCANCODE"),	0,	N_("send IR scancode in protocol specified") },
 		{ .doc = N_("Recording options:") },
 	{ "one-shot",	'1',	0,		0,	N_("end recording after first message") },
 	{ "wideband",	'w',	0,		0,	N_("use wideband receiver aka learning mode") },
@@ -103,6 +106,7 @@ static const char args_doc[] = N_(
 	"--features\n"
 	"--record [save to file]\n"
 	"--send [file to send]\n"
+	"--scancode [scancode to send]\n"
 	"[to set lirc option]");
 
 static const char doc[] = N_(
@@ -115,7 +119,8 @@ static const char doc[] = N_(
 	"  DUTY     - the duty cycle to use for sending\n"
 	"  EMITTERS - comma separated list of emitters to use for sending, e.g. 1,2\n"
 	"  RANGE    - set range of accepted carrier frequencies, e.g. 20000-40000\n"
-	"  TIMEOUT  - set length of space before recording stops in microseonds\n\n"
+	"  TIMEOUT  - set length of space before recording stops in microseconds\n"
+	"  SCANCODE - protocol:scancode, e.g. nec:0xa814\n\n"
 	"Note that most lirc setting have global state, i.e. the device will remain\n"
 	"in this state until set otherwise.");
 
@@ -132,6 +137,20 @@ static int strtoint(const char *p, const char *unit)
 	return arg;
 }
 
+static bool strtoscancode(const char *p, unsigned *ret)
+{
+	char *end;
+	long arg = strtol(p, &end, 0);
+	if (end == NULL || end[0] != 0)
+		return false;
+
+	if (arg <= 0 || arg >= 0xffffffff)
+		return false;
+
+	*ret = arg;
+	return true;
+}
+
 static unsigned parse_emitters(char *p)
 {
 	unsigned emit = 0;
@@ -193,6 +212,54 @@ static struct file *read_file(const char *fname)
 			continue;
 		}
 
+		if (strcmp(keyword, "scancode") == 0) {
+			enum rc_proto proto;
+			unsigned scancode, carrier;
+			char *scancodestr;
+
+			if (!expect_pulse) {
+				fprintf(stderr, _("error: %s:%d: space must precede scancode\n"), fname, lineno);
+				return NULL;
+			}
+
+			scancodestr = strchr(p, ':');
+			if (!scancodestr) {
+				fprintf(stderr, _("error: %s:%d: scancode argument '%s' should in protocol:scancode format\n"), fname, lineno, p);
+				return NULL;
+			}
+
+			*scancodestr++ = 0;
+
+			if (!protocol_match(p, &proto)) {
+				fprintf(stderr, _("error: %s:%d: protocol '%s' not found\n"), fname, lineno, p);
+				return NULL;
+			}
+
+			if (!strtoscancode(scancodestr, &scancode)) {
+				fprintf(stderr, _("error: %s:%d: invalid scancode '%s'\n"), fname, lineno, scancodestr);
+				return NULL;
+			}
+
+			if (scancode & ~protocol_scancode_mask(proto)) {
+				fprintf(stderr, _("error: %s:%d: invalid scancode '%s' for protocol '%s'\n"), fname, lineno, scancodestr, protocol_name(proto));
+				return NULL;
+			}
+
+			if (len + protocol_max_size(proto) >= LIRCBUF_SIZE) {
+				fprintf(stderr, _("error: %s:%d: too much IR for one transmit\n"), fname, lineno);
+				return NULL;
+			}
+
+			carrier = protocol_carrier(proto);
+			if (f->carrier && f->carrier != carrier)
+				fprintf(stderr, _("error: %s:%d: carrier already specified\n"), fname, lineno);
+			else
+				f->carrier = carrier;
+
+			len += protocol_encode(proto, scancode, f->buf);
+			continue;
+		}
+
 		int arg = strtoint(p, "");
 		if (arg == 0) {
 			fprintf(stderr, _("warning: %s:%d: invalid argument '%s'\n"), fname, lineno, p);
@@ -225,7 +292,7 @@ static struct file *read_file(const char *fname)
 				f->buf[len++] = arg;
 			expect_pulse = false;
 		} else if (strcmp(keyword, "carrier") == 0) {
-			if (f->carrier) {
+			if (f->carrier && f->carrier != arg) {
 				fprintf(stderr, _("warning: %s:%d: carrier already specified\n"), fname, lineno);
 			} else {
 				f->carrier = arg;
@@ -260,6 +327,48 @@ static struct file *read_file(const char *fname)
 	return f;
 }
 
+static struct file *read_scancode(const char *name)
+{
+	enum rc_proto proto;
+	struct file *f;
+	unsigned scancode;
+	char *pstr;
+	char *p = strchr(name, ':');
+
+	if (!p) {
+		fprintf(stderr, _("error: scancode '%s' most be in protocol:scancode format\n"), name);
+		return NULL;
+	}
+
+	pstr = strndupa(name, p - name);
+
+	if (!protocol_match(pstr, &proto)) {
+		fprintf(stderr, _("error: protocol '%s' not found\n"), pstr);
+		return NULL;
+	}
+
+	if (!strtoscancode(p + 1, &scancode)) {
+		fprintf(stderr, _("error: invalid scancode '%s'\n"), p + 1);
+		return NULL;
+	}
+
+	if (scancode & ~protocol_scancode_mask(proto)) {
+		fprintf(stderr, _("error: invalid scancode '%s' for protocol '%s'\n"), p + 1, protocol_name(proto));
+		return NULL;
+	}
+
+	f = malloc(sizeof(*f));
+	if (f == NULL) {
+		fprintf(stderr, _("Failed to allocate memory\n"));
+		return NULL;
+	}
+
+	f->carrier = protocol_carrier(proto);
+	f->fname = name;
+	f->len = protocol_encode(proto, scancode, f->buf);
+
+	return f;
+}
 
 static error_t parse_opt(int k, char *arg, struct argp_state *state)
 {
@@ -380,6 +489,23 @@ static error_t parse_opt(int k, char *arg, struct argp_state *state)
 			p->next = s;
 		}
 		break;
+	case 'S':
+		if (arguments->record || arguments->features)
+			argp_error(state, _("send can not be combined with record or features option"));
+		s = read_scancode(arg);
+		if (s == NULL)
+			exit(EX_DATAERR);
+
+		s->next = NULL;
+		if (arguments->send == NULL)
+			arguments->send = s;
+		else {
+			struct file *p = arguments->send;
+			while (p->next) p = p->next;
+			p->next = s;
+		}
+		break;
+
 	case ARGP_KEY_END:
 		if (!arguments->work_to_do)
 			argp_usage(state);
diff --git a/utils/ir-ctl/ir-encode.c b/utils/ir-ctl/ir-encode.c
new file mode 100644
index 0000000..a0d2f4c
--- /dev/null
+++ b/utils/ir-ctl/ir-encode.c
@@ -0,0 +1,427 @@
+/*
+ * ir-encode.c - encodes IR scancodes in different protocols
+ *
+ * Copyright (C) 2016 Sean Young <sean@mess.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, version 2 of the License.
+
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+/*
+ * TODO: XMP protocol and MCE keyboard
+ */
+
+#include <stdbool.h>
+#include <stdint.h>
+#include <ctype.h>
+
+#include "ir-encode.h"
+
+#define NS_TO_US(x) (((x)+500)/1000)
+
+static int nec_encode(enum rc_proto proto, unsigned scancode, unsigned *buf)
+{
+	const int nec_unit = 562500;
+	int n = 0;
+
+	void add_byte(unsigned bits)
+	{
+		int i;
+		for (i=0; i<8; i++) {
+			buf[n++] = NS_TO_US(nec_unit);
+			if (bits & (1 << i))
+				buf[n++] = NS_TO_US(nec_unit * 3);
+			else
+				buf[n++] = NS_TO_US(nec_unit);
+		}
+	}
+
+	buf[n++] = NS_TO_US(nec_unit * 16);
+	buf[n++] = NS_TO_US(nec_unit * 8);
+
+	switch (proto) {
+	default:
+		return 0;
+	case RC_PROTO_NEC:
+		add_byte(scancode >> 8);
+		add_byte(~(scancode >> 8));
+		add_byte(scancode);
+		add_byte(~scancode);
+		break;
+	case RC_PROTO_NECX:
+		add_byte(scancode >> 16);
+		add_byte(scancode >> 8);
+		add_byte(scancode);
+		add_byte(~scancode);
+		break;
+	case RC_PROTO_NEC32:
+		/*
+		 * At the time of writing kernel software nec decoder
+		 * reverses the bit order so it will not match. Hardware
+		 * decoders do not have this issue.
+		 */
+		add_byte(scancode >> 24);
+		add_byte(scancode >> 16);
+		add_byte(scancode >> 8);
+		add_byte(scancode);
+		break;
+	}
+
+	buf[n++] = NS_TO_US(nec_unit);
+
+	return n;
+}
+
+static int jvc_encode(enum rc_proto proto, unsigned scancode, unsigned *buf)
+{
+	const int jvc_unit = 525000;
+	int i;
+
+	/* swap bytes so address comes first */
+	scancode = ((scancode << 8) & 0xff00) | ((scancode >> 8) & 0x00ff);
+
+	*buf++ = NS_TO_US(jvc_unit * 16);
+	*buf++ = NS_TO_US(jvc_unit * 8);
+
+	for (i=0; i<16; i++) {
+		*buf++ = NS_TO_US(jvc_unit);
+
+		if (scancode & 1)
+			*buf++ = NS_TO_US(jvc_unit * 3);
+		else
+			*buf++ = NS_TO_US(jvc_unit);
+
+		scancode >>= 1;
+	}
+
+	*buf = NS_TO_US(jvc_unit);
+
+	return 35;
+}
+
+static int sanyo_encode(enum rc_proto proto, unsigned scancode, unsigned *buf)
+{
+	const int sanyo_unit = 562500;
+
+	void add_bits(int bits, int count)
+	{
+		int i;
+		for (i=0; i<count; i++) {
+			*buf++ = NS_TO_US(sanyo_unit);
+
+			if (bits & (1 << i))
+				*buf++ = NS_TO_US(sanyo_unit * 3);
+			else
+				*buf++ = NS_TO_US(sanyo_unit);
+		}
+	}
+
+	*buf++ = NS_TO_US(sanyo_unit * 16);
+	*buf++ = NS_TO_US(sanyo_unit * 8);
+
+	add_bits(scancode >> 8, 13);
+	add_bits(~(scancode >> 8), 13);
+	add_bits(scancode, 8);
+	add_bits(~scancode, 8);
+
+	*buf = NS_TO_US(sanyo_unit);
+
+	return 87;
+}
+
+static int sharp_encode(enum rc_proto proto, unsigned scancode, unsigned *buf)
+{
+	const int sharp_unit = 40000;
+
+	void add_bits(int bits, int count)
+	{
+		int i;
+		for (i=0; i<count; i++) {
+			*buf++ = NS_TO_US(sharp_unit * 8);
+
+			if (bits & (1 << i))
+				*buf++ = NS_TO_US(sharp_unit * 50);
+			else
+				*buf++ = NS_TO_US(sharp_unit * 25);
+		}
+	}
+
+	add_bits(scancode >> 8, 5);
+	add_bits(scancode, 8);
+	add_bits(1, 2);
+
+	*buf++ = NS_TO_US(sharp_unit * 8);
+	*buf++ = NS_TO_US(sharp_unit * 1000);
+
+	add_bits(scancode >> 8, 5);
+	add_bits(~scancode, 8);
+	add_bits(~1, 2);
+	*buf++ = NS_TO_US(sharp_unit * 8);
+
+	return (13 + 2) * 4 + 3;
+}
+
+static int sony_encode(enum rc_proto proto, unsigned scancode, unsigned *buf)
+{
+	const int sony_unit = 600000;
+	int n = 0;
+
+	void add_bits(int bits, int count)
+	{
+		int i;
+		for (i=0; i<count; i++) {
+			if (bits & (1 << i))
+				buf[n++] = NS_TO_US(sony_unit * 2);
+			else
+				buf[n++] = NS_TO_US(sony_unit);
+
+			buf[n++] = NS_TO_US(sony_unit);
+		}
+	}
+
+	buf[n++] = NS_TO_US(sony_unit * 4);
+	buf[n++] = NS_TO_US(sony_unit);
+
+	switch (proto) {
+	case RC_PROTO_SONY12:
+		add_bits(scancode, 7);
+		add_bits(scancode >> 16, 5);
+		break;
+	case RC_PROTO_SONY15:
+		add_bits(scancode, 7);
+		add_bits(scancode >> 16, 8);
+		break;
+	case RC_PROTO_SONY20:
+		add_bits(scancode, 7);
+		add_bits(scancode >> 16, 5);
+		add_bits(scancode >> 8, 8);
+		break;
+	default:
+		return 0;
+	}
+
+	/* ignore last space */
+	return n - 1;
+}
+
+static int rc5_encode(enum rc_proto proto, unsigned scancode, unsigned *buf)
+{
+	const unsigned int rc5_unit = 888888;
+	unsigned n = 0;
+
+	void advance_space(unsigned length)
+	{
+		if (n % 2)
+			buf[n] += length;
+		else
+			buf[++n] = length;
+	}
+
+	void advance_pulse(unsigned length)
+	{
+		if (n % 2)
+			buf[++n] = length;
+		else
+			buf[n] += length;
+	}
+
+	void add_bits(int bits, int count)
+	{
+		while (count--) {
+			if (bits & (1 << count)) {
+				advance_space(NS_TO_US(rc5_unit));
+				advance_pulse(NS_TO_US(rc5_unit));
+			} else {
+				advance_pulse(NS_TO_US(rc5_unit));
+				advance_space(NS_TO_US(rc5_unit));
+			}
+		}
+	}
+
+	buf[n] = NS_TO_US(rc5_unit);
+
+	switch (proto) {
+	default:
+		return 0;
+	case RC_PROTO_RC5:
+		add_bits(2, 2);
+		add_bits(scancode >> 8, 5);
+		add_bits(scancode, 6);
+		break;
+	case RC_PROTO_RC5_SZ:
+		add_bits(!!(scancode & 0x2000), 1);
+		add_bits(0, 1);
+		add_bits(scancode >> 6, 6);
+		add_bits(scancode, 6);
+		break;
+	case RC_PROTO_RC5X:
+		add_bits(!!(scancode & 0x4000), 1);
+		add_bits(0, 1);
+		add_bits(scancode >> 16, 5);
+		advance_space(NS_TO_US(rc5_unit * 4));
+		add_bits(scancode >> 8, 6);
+		add_bits(scancode, 6);
+		break;
+	}
+
+	/* drop any trailing pulse */
+	return (n % 2) ? n : n + 1;
+}
+
+static int rc6_encode(enum rc_proto proto, unsigned scancode, unsigned *buf)
+{
+	const unsigned int rc6_unit = 444444;
+	unsigned n = 0;
+
+	void advance_space(unsigned length)
+	{
+		if (n % 2)
+			buf[n] += length;
+		else
+			buf[++n] = length;
+	}
+
+	void advance_pulse(unsigned length)
+	{
+		if (n % 2)
+			buf[++n] = length;
+		else
+			buf[n] += length;
+	}
+
+	void add_bits(unsigned bits, unsigned count, unsigned length)
+	{
+		while (count--) {
+			if (bits & (1 << count)) {
+				advance_pulse(length);
+				advance_space(length);
+			} else {
+				advance_space(length);
+				advance_pulse(length);
+			}
+		}
+	}
+
+	buf[n++] = NS_TO_US(rc6_unit * 6);
+	buf[n++] = NS_TO_US(rc6_unit * 2);
+
+	switch (proto) {
+	default:
+		return 0;
+	case RC_PROTO_RC6_0:
+		add_bits(8, 4, NS_TO_US(rc6_unit));
+		add_bits(0, 1, NS_TO_US(rc6_unit * 2));
+		add_bits(scancode, 16, NS_TO_US(rc6_unit));
+		break;
+	case RC_PROTO_RC6_6A_20:
+		add_bits(14, 4, NS_TO_US(rc6_unit));
+		add_bits(0, 1, NS_TO_US(rc6_unit * 2));
+		add_bits(scancode, 20, NS_TO_US(rc6_unit));
+		break;
+	case RC_PROTO_RC6_6A_24:
+		add_bits(14, 4, NS_TO_US(rc6_unit));
+		add_bits(0, 1, NS_TO_US(rc6_unit * 2));
+		add_bits(scancode, 24, NS_TO_US(rc6_unit));
+		break;
+	case RC_PROTO_RC6_6A_32:
+	case RC_PROTO_RC6_MCE:
+		add_bits(14, 4, NS_TO_US(rc6_unit));
+		add_bits(0, 1, NS_TO_US(rc6_unit * 2));
+		add_bits(scancode, 32, NS_TO_US(rc6_unit));
+		break;
+	}
+
+	/* drop any trailing pulse */
+	return (n % 2) ? n : n + 1;
+}
+
+static const struct {
+	char name[10];
+	unsigned scancode_mask;
+	unsigned max_edges;
+	unsigned carrier;
+	int (*encode)(enum rc_proto proto, unsigned scancode, unsigned *buf);
+} encoders[RC_PROTO_COUNT] = {
+	[RC_PROTO_RC5] = { "rc5", 0x1f3f, 24, 36000, rc5_encode },
+	[RC_PROTO_RC5X] = { "rc5x", 0x1f3f3f, 40, 36000, rc5_encode },
+	[RC_PROTO_RC5_SZ] = { "rc5_sz", 0x2fff, 26, 36000, rc5_encode },
+	[RC_PROTO_SONY12] = { "sony12", 0x1f007f, 25, 40000, sony_encode },
+	[RC_PROTO_SONY15] = { "sony15", 0xff007f, 31, 40000, sony_encode },
+	[RC_PROTO_SONY20] = { "sony20", 0x1fff7f, 41, 40000, sony_encode },
+	[RC_PROTO_JVC] = { "jvc", 0xffff, 35, 38000, jvc_encode },
+	[RC_PROTO_NEC] = { "nec", 0xffff, 67, 38000, nec_encode },
+	[RC_PROTO_NECX] = { "necx", 0xffffff, 67, 38000, nec_encode },
+	[RC_PROTO_NEC32] = { "nec32", 0xffffffff, 67, 38000, nec_encode },
+	[RC_PROTO_SANYO] = { "sanyo", 0x1fffff, 87, 38000, sanyo_encode },
+	[RC_PROTO_RC6_0] = { "rc6_0", 0xffff, 24, 36000, rc6_encode },
+	[RC_PROTO_RC6_6A_20] = { "rc6_6a_20", 0xfffff, 52, 36000, rc6_encode },
+	[RC_PROTO_RC6_6A_24] = { "rc6_6a_24", 0xffffff, 60, 36000, rc6_encode },
+	[RC_PROTO_RC6_6A_32] = { "rc6_6a_32", 0xffffffff, 76, 36000, rc6_encode },
+	[RC_PROTO_RC6_MCE] = { "rc6_mce", 0xffff7fff, 76, 36000, rc6_encode },
+	[RC_PROTO_SHARP] = { "sharp", 0x1fff, 63, 38000, sharp_encode },
+};
+
+static bool str_like(const char *a, const char *b)
+{
+	while (*a && *b) {
+		while (*a == ' ' || *a == '-' || *a == '_')
+			a++;
+		while (*b == ' ' || *b == '-' || *b == '_')
+			b++;
+
+		if (*a >= 0x7f || *b >= 0x7f)
+			return false;
+
+		if (tolower(*a) != tolower(*b))
+			return false;
+
+		a++; b++;
+	}
+
+	return !*a && !*b;
+}
+
+bool protocol_match(const char *name, enum rc_proto *proto)
+{
+	enum rc_proto p;
+
+	for (p=0; p<RC_PROTO_COUNT; p++) {
+		if (str_like(encoders[p].name, name)) {
+			*proto = p;
+			return true;
+		}
+	}
+
+	return false;
+}
+
+unsigned protocol_carrier(enum rc_proto proto)
+{
+	return encoders[proto].carrier;
+}
+
+unsigned protocol_max_size(enum rc_proto proto)
+{
+	return encoders[proto].max_edges;
+}
+
+unsigned protocol_scancode_mask(enum rc_proto proto)
+{
+	return encoders[proto].scancode_mask;
+}
+
+unsigned protocol_encode(enum rc_proto proto, unsigned scancode, unsigned *buf)
+{
+	return encoders[proto].encode(proto, scancode, buf);
+}
+
+const char* protocol_name(enum rc_proto proto)
+{
+	return encoders[proto].name;
+}
diff --git a/utils/ir-ctl/ir-encode.h b/utils/ir-ctl/ir-encode.h
new file mode 100644
index 0000000..b2542ec
--- /dev/null
+++ b/utils/ir-ctl/ir-encode.h
@@ -0,0 +1,35 @@
+
+#ifndef __IR_ENCODE_H__
+#define __IR_ENCODE_H__
+
+enum rc_proto {
+	RC_PROTO_RC5,
+	RC_PROTO_RC5X,
+	RC_PROTO_RC5_SZ,
+	RC_PROTO_JVC,
+	RC_PROTO_SONY12,
+	RC_PROTO_SONY15,
+	RC_PROTO_SONY20,
+	RC_PROTO_NEC,
+	RC_PROTO_NECX,
+	RC_PROTO_NEC32,
+	RC_PROTO_SANYO,
+	RC_PROTO_MCE_KBD,
+	RC_PROTO_RC6_0,
+	RC_PROTO_RC6_6A_20,
+	RC_PROTO_RC6_6A_24,
+	RC_PROTO_RC6_6A_32,
+	RC_PROTO_RC6_MCE,
+	RC_PROTO_SHARP,
+	RC_PROTO_XMP,
+	RC_PROTO_COUNT
+};
+
+bool protocol_match(const char *name, enum rc_proto *proto);
+unsigned protocol_carrier(enum rc_proto proto);
+unsigned protocol_max_size(enum rc_proto proto);
+unsigned protocol_scancode_mask(enum rc_proto proto);
+unsigned protocol_encode(enum rc_proto proto, unsigned scancode, unsigned *buf);
+const char *protocol_name(enum rc_proto proto);
+
+#endif
-- 
2.7.4

