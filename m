Return-path: <linux-media-owner@vger.kernel.org>
Received: from tichy.grunau.be ([85.131.189.73]:49938 "EHLO tichy.grunau.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756322Ab0BJSfv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Feb 2010 13:35:51 -0500
Received: from localhost (p5DDC401F.dip0.t-ipconnect.de [93.220.64.31])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by tichy.grunau.be (Postfix) with ESMTPSA id C528190076
	for <linux-media@vger.kernel.org>; Wed, 10 Feb 2010 19:35:51 +0100 (CET)
Date: Wed, 10 Feb 2010 19:37:26 +0100
From: Janne Grunau <j@jannau.net>
To: linux-media@vger.kernel.org
Subject: [PATCH 7 of 7] azap: implement record program and service
 information with -p
Message-ID: <20100210183726.GR8026@aniel.lan>
References: <patchbomb.1265826616@aniel.lan>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="hcut4fGOf7Kh6EdG"
Content-Disposition: inline
In-Reply-To: <patchbomb.1265826616@aniel.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--hcut4fGOf7Kh6EdG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

 util/szap/azap.c |  45 ++++++++++++++++++++++++++++++++++++++-------
 1 files changed, 38 insertions(+), 7 deletions(-)



--hcut4fGOf7Kh6EdG
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: inline; filename="dvb-apps-7.patch"

# HG changeset patch
# User Janne Grunau <j@jannau.net>
# Date 1265824500 -3600
# Node ID eb8e295536aa230a2b5f1fbab777786ab4b99527
# Parent  c38dce87f96ab87a59c3565da978d3564ff438c3
azap: implement record program and service information with -p

diff -r c38dce87f96a -r eb8e295536aa util/szap/azap.c
--- a/util/szap/azap.c	Wed Feb 10 18:54:38 2010 +0100
+++ b/util/szap/azap.c	Wed Feb 10 18:55:00 2010 +0100
@@ -171,7 +171,8 @@
 
 
 int parse(const char *fname, const char *channel,
-	  struct dvb_frontend_parameters *frontend, int *vpid, int *apid)
+	  struct dvb_frontend_parameters *frontend, int *vpid, int *apid,
+	  int *pno)
 {
 	int fd;
 	int err;
@@ -202,7 +203,10 @@
 		return -5;
 
 	if ((err = try_parse_int(fd, apid, "Audio PID")))
-		return -6;
+	    return -6;
+
+	if ((err = try_parse_int(fd, pno, "MPEG Program Number")))
+	    return -7;
 
 	close(fd);
 
@@ -275,12 +279,12 @@
 	char *homedir = getenv ("HOME");
 	char *confname = NULL;
 	char *channel = NULL;
-	int adapter = 0, frontend = 0, demux = 0, dvr = 0;
-	int vpid, apid;
-	int frontend_fd, audio_fd, video_fd;
+	int adapter = 0, frontend = 0, demux = 0, dvr = 0, rec_psi = 0;
+	int vpid, apid, pno, pmtpid = 0;
+	int frontend_fd, audio_fd, video_fd, pat_fd, pmt_fd;
 	int opt;
 
-	while ((opt = getopt(argc, argv, "hrn:a:f:d:c:")) != -1) {
+	while ((opt = getopt(argc, argv, "hrpn:a:f:d:c:")) != -1) {
 		switch (opt) {
 		case 'a':
 			adapter = strtoul(optarg, NULL, 0);
@@ -294,6 +298,9 @@
 		case 'r':
 			dvr = 1;
 			break;
+		case 'p':
+			rec_psi = 1;
+			break;
 		case 'c':
 			confname = optarg;
 			break;
@@ -333,7 +340,7 @@
 
 	memset(&frontend_param, 0, sizeof(struct dvb_frontend_parameters));
 
-	if (parse (confname, channel, &frontend_param, &vpid, &apid))
+	if (parse (confname, channel, &frontend_param, &vpid, &apid, &pno))
 		return -1;
 
 	if ((frontend_fd = open(FRONTEND_DEV, O_RDWR)) < 0) {
@@ -344,6 +351,28 @@
 	if (setup_frontend (frontend_fd, &frontend_param) < 0)
 		return -1;
 
+	if (rec_psi) {
+	    pmtpid = get_pmt_pid(DEMUX_DEV, pno);
+	    if (pmtpid <= 0) {
+		fprintf(stderr,"couldn't find pmt-pid for program number %04x\n", pno);
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
@@ -363,6 +392,8 @@
 
 	check_frontend (frontend_fd);
 
+	close (pat_fd);
+	close (pmt_fd);
 	close (audio_fd);
 	close (video_fd);
 	close (frontend_fd);

--hcut4fGOf7Kh6EdG--
