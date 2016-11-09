Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:35435 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752932AbcKIQNi (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 9 Nov 2016 11:13:38 -0500
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: linux-media@vger.kernel.org
Subject: [PATCH v4l-utils 2/3] ir-ctl: add verbose option
Date: Wed,  9 Nov 2016 16:13:32 +0000
Message-Id: <1478708015-1164-2-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is useful to see what IR is actually being sent (e.g. after
scancode generation).

Signed-off-by: Sean Young <sean@mess.org>
---
 utils/ir-ctl/ir-ctl.1.in |  3 +++
 utils/ir-ctl/ir-ctl.c    | 15 ++++++++++++++-
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/utils/ir-ctl/ir-ctl.1.in b/utils/ir-ctl/ir-ctl.1.in
index 2efe293..a1d5aeb 100644
--- a/utils/ir-ctl/ir-ctl.1.in
+++ b/utils/ir-ctl/ir-ctl.1.in
@@ -99,6 +99,9 @@ Prints the help message
 \fB\-\-usage\fR
 Give a short usage message
 .TP
+\fB\-v\fR, \fB\-\-verbose\fR
+Verbose output; this prints the IR before sending.
+.TP
 \fB\-V\fR, \fB\-\-version\fR
 print the v4l2\-utils version
 .PP
diff --git a/utils/ir-ctl/ir-ctl.c b/utils/ir-ctl/ir-ctl.c
index bdea741..f19bd05 100644
--- a/utils/ir-ctl/ir-ctl.c
+++ b/utils/ir-ctl/ir-ctl.c
@@ -65,6 +65,7 @@ struct arguments {
 	char *device;
 	bool features;
 	bool record;
+	bool verbose;
 	struct file *send;
 	bool oneshot;
 	char *savetofile;
@@ -85,6 +86,7 @@ static const struct argp_option options[] = {
 	{ "record",	'r',	N_("FILE"),	OPTION_ARG_OPTIONAL,	N_("record IR to stdout or file") },
 	{ "send",	's',	N_("FILE"),	0,	N_("send IR pulse and space file") },
 	{ "scancode", 'S',	N_("SCANCODE"),	0,	N_("send IR scancode in protocol specified") },
+	{ "verbose",	'v',	0,		0,	N_("verbose output") },
 		{ .doc = N_("Recording options:") },
 	{ "one-shot",	'1',	0,		0,	N_("end recording after first message") },
 	{ "wideband",	'w',	0,		0,	N_("use wideband receiver aka learning mode") },
@@ -397,6 +399,9 @@ static error_t parse_opt(int k, char *arg, struct argp_state *state)
 	case '1':
 		arguments->oneshot = true;
 		break;
+	case 'v':
+		arguments->verbose = true;
+		break;
 	case 'm':
 		if (arguments->carrier_reports == 2)
 			argp_error(state, _("cannot enable and disable carrier reports"));
@@ -515,7 +520,7 @@ static error_t parse_opt(int k, char *arg, struct argp_state *state)
 		return ARGP_ERR_UNKNOWN;
 	}
 
-	if (k != '1' && k != 'd')
+	if (k != '1' && k != 'd' && k != 'v')
 		arguments->work_to_do = true;
 
 	return 0;
@@ -739,6 +744,12 @@ static int lirc_send(struct arguments *args, int fd, unsigned features, struct f
 		lirc_set_send_carrier(fd, dev, features, f->carrier);
 
 	size_t size = f->len * sizeof(unsigned);
+	if (args->verbose) {
+		int i;
+		printf("Sending:\n");
+		for (i=0; i<f->len; i++)
+			printf("%s %u\n", i & 1 ? "space" : "pulse", f->buf[i]);
+	}
 	ssize_t ret = TEMP_FAILURE_RETRY(write(fd, f->buf, size));
 	if (ret < 0) {
 		fprintf(stderr, _("%s: failed to send: %m\n"), dev);
@@ -752,6 +763,8 @@ static int lirc_send(struct arguments *args, int fd, unsigned features, struct f
 				size / sizeof(unsigned));
 		return EX_IOERR;
 	}
+	if (args->verbose)
+		printf("Successfully sent\n");
 
 	return 0;
 }
-- 
2.7.4

