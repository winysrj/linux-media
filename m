Return-path: <linux-media-owner@vger.kernel.org>
Received: from tichy.grunau.be ([85.131.189.73]:49937 "EHLO tichy.grunau.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756291Ab0BJSfn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Feb 2010 13:35:43 -0500
Received: from localhost (p5DDC401F.dip0.t-ipconnect.de [93.220.64.31])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by tichy.grunau.be (Postfix) with ESMTPSA id F29F190076
	for <linux-media@vger.kernel.org>; Wed, 10 Feb 2010 19:35:43 +0100 (CET)
Date: Wed, 10 Feb 2010 19:37:19 +0100
From: Janne Grunau <j@jannau.net>
To: linux-media@vger.kernel.org
Subject: [PATCH 6 of 7] tzap: implement recording program and service
 information with -p
Message-ID: <20100210183719.GQ8026@aniel.lan>
References: <patchbomb.1265826616@aniel.lan>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="B0nZA57HJSoPbsHY"
Content-Disposition: inline
In-Reply-To: <patchbomb.1265826616@aniel.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--B0nZA57HJSoPbsHY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

 util/szap/tzap.c |  46 ++++++++++++++++++++++++++++++++++++++++------
 1 files changed, 40 insertions(+), 6 deletions(-)



--B0nZA57HJSoPbsHY
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: inline; filename="dvb-apps-6.patch"

# HG changeset patch
# User Janne Grunau <j@jannau.net>
# Date 1265824478 -3600
# Node ID c38dce87f96ab87a59c3565da978d3564ff438c3
# Parent  c46ead95be23c07b1c95329c713b4dfc649fd67d
tzap: implement recording program and service information with -p

diff -r c46ead95be23 -r c38dce87f96a util/szap/tzap.c
--- a/util/szap/tzap.c	Wed Feb 10 17:47:08 2010 +0100
+++ b/util/szap/tzap.c	Wed Feb 10 18:54:38 2010 +0100
@@ -271,7 +271,8 @@
 
 
 int parse(const char *fname, const char *channel,
-	  struct dvb_frontend_parameters *frontend, int *vpid, int *apid)
+	  struct dvb_frontend_parameters *frontend, int *vpid, int *apid,
+	  int *sid)
 {
 	int fd;
 	int err;
@@ -345,7 +346,11 @@
 
 	if ((err = try_parse_int(fd, apid, "Audio PID")))
 		return -13;
-
+	
+	if ((err = try_parse_int(fd, sid, "Service ID")))
+	    return -14;
+	
+	
 	close(fd);
 
 	return 0;
@@ -480,6 +485,7 @@
     "     -c file   : read channels list from 'file'\n"
     "     -x        : exit after tuning\n"
     "     -r        : set up /dev/dvb/adapterX/dvr0 for TS recording\n"
+    "     -p        : add pat and pmt to TS recording (implies -r)\n"
     "     -s        : only print summary\n"
     "     -S        : run silently (no output)\n"
     "     -H        : human readable output\n"
@@ -496,15 +502,16 @@
 	char *confname = NULL;
 	char *channel = NULL;
 	int adapter = 0, frontend = 0, demux = 0, dvr = 0;
-	int vpid, apid;
+	int vpid, apid, sid, pmtpid = 0;
+	int pat_fd, pmt_fd;
 	int frontend_fd, audio_fd = 0, video_fd = 0, dvr_fd, file_fd;
 	int opt;
 	int record = 0;
 	int frontend_only = 0;
 	char *filename = NULL;
-	int human_readable = 0;
+	int human_readable = 0, rec_psi = 0;
 
-	while ((opt = getopt(argc, argv, "H?hrxRsFSn:a:f:d:c:t:o:")) != -1) {
+	while ((opt = getopt(argc, argv, "H?hrpxRsFSn:a:f:d:c:t:o:")) != -1) {
 		switch (opt) {
 		case 'a':
 			adapter = strtoul(optarg, NULL, 0);
@@ -525,6 +532,9 @@
 		case 'r':
 			dvr = 1;
 			break;
+		case 'p':
+			rec_psi = 1;
+			break;
 		case 'x':
 			exit_after_tuning = 1;
 			break;
@@ -587,7 +597,7 @@
 
 	memset(&frontend_param, 0, sizeof(struct dvb_frontend_parameters));
 
-	if (parse (confname, channel, &frontend_param, &vpid, &apid))
+	if (parse (confname, channel, &frontend_param, &vpid, &apid, &sid))
 		return -1;
 
 	if ((frontend_fd = open(FRONTEND_DEV, O_RDWR)) < 0) {
@@ -601,6 +611,28 @@
 	if (frontend_only)
 		goto just_the_frontend_dude;
 
+	if (rec_psi) {
+	    pmtpid = get_pmt_pid(DEMUX_DEV, sid);
+	    if (pmtpid <= 0) {
+		fprintf(stderr,"couldn't find pmt-pid for sid %04x\n",sid);
+		return -1;
+	    }
+
+	    if ((pat_fd = open(DEMUX_DEV, O_RDWR)) < 0) {
+		perror("opening pat demux failed");
+		return -1;
+	    }
+	    if (set_pesfilter(pat_fd, 0, DMX_PES_OTHER, dvr) < 0)
+		return -1;
+
+	    if ((pmt_fd = open(DEMUX_DEV, O_RDWR)) < 0) {
+		perror("opening pmt demux failed");
+		return -1;
+	    }
+	    if (set_pesfilter(pmt_fd, pmtpid, DMX_PES_OTHER, dvr) < 0)
+		return -1;
+	}
+
         if ((video_fd = open(DEMUX_DEV, O_RDWR)) < 0) {
                 PERROR("failed opening '%s'", DEMUX_DEV);
                 return -1;
@@ -666,6 +698,8 @@
 		check_frontend (frontend_fd, human_readable);
 	}
 
+	close (pat_fd);
+	close (pmt_fd);
 	close (audio_fd);
 	close (video_fd);
 	close (frontend_fd);

--B0nZA57HJSoPbsHY--
