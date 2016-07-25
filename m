Return-path: <linux-media-owner@vger.kernel.org>
Received: from 108-197-250-228.lightspeed.miamfl.sbcglobal.net ([108.197.250.228]:38376
	"EHLO usa.attlocal.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753224AbcGYSeq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jul 2016 14:34:46 -0400
From: Abylay Ospan <aospan@netup.ru>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Cc: Abylay Ospan <aospan@netup.ru>
Subject: [PATCHv3] [dvbv5-scan] New option 'timeout'. Wait no more than 'timeout' sec. when scanning
Date: Mon, 25 Jul 2016 14:34:30 -0400
Message-Id: <1469471670-25274-1-git-send-email-aospan@netup.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

some frontends (for example, lgdt3306a) wait timeout inside code like:
for (i = 20; i > 0; i--) {
  msleep(50);

If there is no-LOCK then dvbv5-scan spent a lot of time (doing 40x calls).
This patch introduce 'timeout' option which 1 sec. by default. So we do not wait more
than 1 sec (or so) if no-LOCK.
CLOCK_MONOTONIC is used so we don't care about timestamps "rollup".

Signed-off-by: Abylay Ospan <aospan@netup.ru>
---
 utils/dvb/dvbv5-scan.c | 26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/utils/dvb/dvbv5-scan.c b/utils/dvb/dvbv5-scan.c
index 689bc0b..bcdc71c 100644
--- a/utils/dvb/dvbv5-scan.c
+++ b/utils/dvb/dvbv5-scan.c
@@ -61,7 +61,7 @@ struct arguments {
 	char *confname, *lnb_name, *output, *demux_dev;
 	unsigned adapter, n_adapter, adapter_fe, adapter_dmx, frontend, demux, get_detected, get_nit;
 	int force_dvbv3, lna, lnb, sat_number, freq_bpf;
-	unsigned diseqc_wait, dont_add_new_freqs, timeout_multiply;
+	unsigned diseqc_wait, dont_add_new_freqs, timeout_multiply, timeout;
 	unsigned other_nit;
 	enum dvb_file_formats input_format, output_format;
 	const char *cc;
@@ -84,7 +84,8 @@ static const struct argp_option options[] = {
 	{"verbose",	'v',	NULL,			0, N_("be (very) verbose"), 0},
 	{"output",	'o',	N_("file"),		0, N_("output filename (default: ") DEFAULT_OUTPUT ")", 0},
 	{"file-freqs-only", 'F', NULL,			0, N_("don't use the other frequencies discovered during scan"), 0},
-	{"timeout-multiply", 'T', N_("factor"),		0, N_("Multiply scan timeouts by this factor"), 0},
+	{"timeout-multiply", 'T', N_("factor"),		0, N_("Multiply scan timeouts by this factor (default: 1)"), 0},
+	{"timeout", 't', N_("timeout"),		0, N_("individual frequency scan timeout in seconds (default: 1sec)"), 0},
 	{"parse-other-nit", 'p', NULL,			0, N_("Parse the other NIT/SDT tables"), 0},
 	{"input-format", 'I',	N_("format"),		0, N_("Input format: CHANNEL, DVBV5 (default: DVBV5)"), 0},
 	{"output-format", 'O',	N_("format"),		0, N_("Output format: VDR, CHANNEL, ZAP, DVBV5 (default: DVBV5)"), 0},
@@ -182,15 +183,25 @@ static int print_frontend_stats(struct arguments *args,
 	return 0;
 }
 
+/* return timestamp in msec */
+uint64_t get_timestamp()
+{
+	struct timespec now;
+	clock_gettime(CLOCK_MONOTONIC, &now);
+	return now.tv_sec * 1000 + now.tv_nsec/1000000;
+}
+
 static int check_frontend(void *__args,
 			  struct dvb_v5_fe_parms *parms)
 {
 	struct arguments *args = __args;
 	int rc, i;
 	fe_status_t status;
+	uint64_t start = get_timestamp();
+	uint64_t timeout = 1000 * args->timeout; /* sec -> msec */
 
 	args->n_status_lines = 0;
-	for (i = 0; i < args->timeout_multiply * 40; i++) {
+	while ((get_timestamp() - start) < timeout) {
 		if (parms->abort)
 			return 0;
 		rc = dvb_fe_get_stats(parms);
@@ -203,7 +214,7 @@ static int check_frontend(void *__args,
 		print_frontend_stats(args, parms);
 		if (status & FE_HAS_LOCK)
 			break;
-		usleep(100000);
+		usleep(50000);
 	};
 
 	if (isatty(STDERR_FILENO)) {
@@ -400,6 +411,9 @@ static error_t parse_opt(int k, char *optarg, struct argp_state *state)
 	case 'T':
 		args->timeout_multiply = strtoul(optarg, NULL, 0);
 		break;
+	case 't':
+		args->timeout = strtoul(optarg, NULL, 0);
+		break;
 	case 'I':
 		args->input_format = dvb_parse_format(optarg);
 		break;
@@ -473,6 +487,7 @@ int main(int argc, char **argv)
 	args.input_format = FILE_DVBV5;
 	args.output_format = FILE_DVBV5;
 	args.timeout_multiply = 1;
+	args.timeout = 1;
 	args.adapter = (unsigned)-1;
 	args.lna = LNA_AUTO;
 
@@ -480,6 +495,9 @@ int main(int argc, char **argv)
 	if (args.timeout_multiply == 0)
 		args.timeout_multiply = 1;
 
+	if (args.timeout == 0)
+		args.timeout = 1;
+
 	if (args.n_adapter == 1) {
 		args.adapter_fe = args.adapter;
 		args.adapter_dmx = args.adapter;
-- 
2.7.4

