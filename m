Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:48903 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752508AbdK2URf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Nov 2017 15:17:35 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Cc: Matthias Reichl <hias@horus.com>
Subject: [PATCH 2/2] ir-ctl: specify the gap between scancodes or files
Date: Wed, 29 Nov 2017 20:17:32 +0000
Message-Id: <20171129201732.23797-2-sean@mess.org>
In-Reply-To: <20171129201732.23797-1-sean@mess.org>
References: <20171129200521.z4phw7kzcmf56qgi@gofer.mess.org>
 <20171129201732.23797-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When sending multiple scancodes, or pulse space files, by default there
is 125ms gap between them. Allow this to be specified.

Signed-off-by: Sean Young <sean@mess.org>
---
 utils/ir-ctl/ir-ctl.1.in |  5 +++++
 utils/ir-ctl/ir-ctl.c    | 18 +++++++++++++-----
 2 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/utils/ir-ctl/ir-ctl.1.in b/utils/ir-ctl/ir-ctl.1.in
index 05550fb1..89aa281f 100644
--- a/utils/ir-ctl/ir-ctl.1.in
+++ b/utils/ir-ctl/ir-ctl.1.in
@@ -93,6 +93,11 @@ Comma separated list of emitters to use for sending. The first emitter is
 number 1. Some devices only support enabling one emitter (the winbond-cir
 driver).
 .TP
+\fB\-g\fR, \fB\-\-gap\fR=\fIGAP\fR
+Set the gap time between scancodes, or the gap between files when
+multiple are specified on the command line. By default this is 125000
+microseconds.
+.TP
 \fB\-?\fR, \fB\-\-help\fR
 Prints the help message
 .TP
diff --git a/utils/ir-ctl/ir-ctl.c b/utils/ir-ctl/ir-ctl.c
index 8538ec5d..6fb05b1a 100644
--- a/utils/ir-ctl/ir-ctl.c
+++ b/utils/ir-ctl/ir-ctl.c
@@ -82,6 +82,7 @@ struct arguments {
 	int wideband;
 	unsigned carrier_low, carrier_high;
 	unsigned timeout;
+	unsigned gap;
 	int carrier_reports;
 	int timeout_reports;
 	unsigned carrier;
@@ -111,6 +112,7 @@ static const struct argp_option options[] = {
 	{ "carrier",	'c',	N_("CARRIER"),	0,	N_("set send carrier") },
 	{ "duty-cycle",	'D',	N_("DUTY"),	0,	N_("set duty cycle") },
 	{ "emitters",	'e',	N_("EMITTERS"),	0,	N_("set send emitters") },
+	{ "gap",	'g',	N_("GAP"),	0,	N_("set gap between files or scancodes") },
 	{ }
 };
 
@@ -130,6 +132,7 @@ static const char doc[] = N_(
 	"  CARRIER  - the carrier frequency to use for sending\n"
 	"  DUTY     - the duty cycle to use for sending\n"
 	"  EMITTERS - comma separated list of emitters to use for sending, e.g. 1,2\n"
+	"  GAP      - gap between pulse and files or scancodes in microseconds\n"
 	"  RANGE    - set range of accepted carrier frequencies, e.g. 20000-40000\n"
 	"  TIMEOUT  - set length of space before recording stops in microseconds\n"
 	"  SCANCODE - protocol:scancode, e.g. nec:0xa814\n\n"
@@ -185,7 +188,7 @@ static unsigned parse_emitters(char *p)
 	return emit;
 }
 
-static struct file *read_file(const char *fname)
+static struct file *read_file(struct arguments *args, const char *fname)
 {
 	bool expect_pulse = true;
 	int lineno = 0, lastspace = 0;
@@ -230,7 +233,7 @@ static struct file *read_file(const char *fname)
 			char *scancodestr;
 
 			if (!expect_pulse) {
-				f->buf[len++] = IR_DEFAULT_TIMEOUT;
+				f->buf[len++] = args->gap;
 				expect_pulse = true;
 			}
 
@@ -486,6 +489,11 @@ static error_t parse_opt(int k, char *arg, struct argp_state *state)
 		if (arguments->emitters == 0)
 			argp_error(state, _("cannot parse emitters `%s'"), arg);
 		break;
+	case 'g':
+		arguments->gap = strtoint(arg, "");
+		if (arguments->gap == 0)
+			argp_error(state, _("cannot parse gap `%s'"), arg);
+		break;
 	case 'D':
 		arguments->duty = strtoint(arg, "%");
 		if (arguments->duty == 0 || arguments->duty >= 100)
@@ -494,7 +502,7 @@ static error_t parse_opt(int k, char *arg, struct argp_state *state)
 	case 's':
 		if (arguments->record || arguments->features)
 			argp_error(state, _("send can not be combined with record or features option"));
-		s = read_file(arg);
+		s = read_file(arguments, arg);
 		if (s == NULL)
 			exit(EX_DATAERR);
 
@@ -884,7 +892,7 @@ err:
 
 int main(int argc, char *argv[])
 {
-	struct arguments args = {};
+	struct arguments args = { .gap = IR_DEFAULT_TIMEOUT };
 
 #ifdef ENABLE_NLS
         setlocale (LC_ALL, "");
@@ -912,7 +920,7 @@ int main(int argc, char *argv[])
 	while (s) {
 		struct file *next = s->next;
 		if (s != args.send)
-			usleep(IR_DEFAULT_TIMEOUT);
+			usleep(args.gap);
 
 		rc = lirc_send(&args, fd, features, s);
 		if (rc) {
-- 
2.14.3
