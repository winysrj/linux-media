Return-path: <linux-media-owner@vger.kernel.org>
Received: from tichy.grunau.be ([85.131.189.73]:49936 "EHLO tichy.grunau.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753069Ab0BJSff (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Feb 2010 13:35:35 -0500
Received: from localhost (p5DDC401F.dip0.t-ipconnect.de [93.220.64.31])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by tichy.grunau.be (Postfix) with ESMTPSA id AC94990076
	for <linux-media@vger.kernel.org>; Wed, 10 Feb 2010 19:35:35 +0100 (CET)
Date: Wed, 10 Feb 2010 19:37:10 +0100
From: Janne Grunau <j@jannau.net>
To: linux-media@vger.kernel.org
Subject: [PATCH 5 of 7] czap: implement -p option to record PAT & PMT (PSI)
Message-ID: <20100210183710.GP8026@aniel.lan>
References: <patchbomb.1265826616@aniel.lan>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="d8Lz2Tf5e5STOWUP"
Content-Disposition: inline
In-Reply-To: <patchbomb.1265826616@aniel.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--d8Lz2Tf5e5STOWUP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

 util/szap/czap.c |  48 ++++++++++++++++++++++++++++++++++++++----------
 1 files changed, 38 insertions(+), 10 deletions(-)



--d8Lz2Tf5e5STOWUP
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: inline; filename="dvb-apps-5.patch"

# HG changeset patch
# User Janne Grunau <j@jannau.net>
# Date 1265820428 -3600
# Node ID c46ead95be23c07b1c95329c713b4dfc649fd67d
# Parent  0163e837905411bb9932bb65fecde5735e5bd7e9
czap: implement -p option to record PAT & PMT (PSI)

diff -r 0163e8379054 -r c46ead95be23 util/szap/czap.c
--- a/util/szap/czap.c	Wed Feb 10 18:43:05 2010 +0100
+++ b/util/szap/czap.c	Wed Feb 10 17:47:08 2010 +0100
@@ -120,7 +120,7 @@
 
 
 int parse(const char *fname, int list_channels, int chan_no, const char *channel,
-	  struct dvb_frontend_parameters *frontend, int *vpid, int *apid)
+	  struct dvb_frontend_parameters *frontend, int *vpid, int *apid, int *sid)
 {
 	FILE *f;
 	char *chan;
@@ -143,10 +143,10 @@
 	}
 	printf("%3d %s", chan_no, chan);
 
-	if ((sscanf(chan, "%m[^:]:%d:%m[^:]:%d:%m[^:]:%m[^:]:%d:%d\n",
+	if ((sscanf(chan, "%m[^:]:%d:%m[^:]:%d:%m[^:]:%m[^:]:%d:%d:%d\n",
 				&name, &frontend->frequency,
 				&inv, &frontend->u.qam.symbol_rate,
-				&fec, &mod, vpid, apid) != 8)
+				&fec, &mod, vpid, apid, sid) != 9)
 			|| !name || !inv || !fec | !mod) {
 		ERROR("cannot parse service data");
 		return -3;
@@ -167,10 +167,10 @@
 		ERROR("modulation field syntax '%s'", mod);
 		return -6;
 	}
-	printf("%3d %s: f %d, s %d, i %d, fec %d, qam %d, v %#x, a %#x\n",
+	printf("%3d %s: f %d, s %d, i %d, fec %d, qam %d, v %#x, a %#x, s %#x \n",
 			chan_no, name, frontend->frequency, frontend->u.qam.symbol_rate,
 			frontend->inversion, frontend->u.qam.fec_inner,
-			frontend->u.qam.modulation, *vpid, *apid);
+			frontend->u.qam.modulation, *vpid, *apid, *sid);
 	free(name);
 	free(inv);
 	free(fec);
@@ -253,6 +253,7 @@
     "     -x        : exit after tuning\n"
     "     -H        : human readable output\n"
     "     -r        : set up /dev/dvb/adapterX/dvr0 for TS recording\n"
+    "     -p        : add pat and pmt to TS recording (implies -r)\n"
 ;
 
 int main(int argc, char **argv)
@@ -262,12 +263,12 @@
 	char *confname = NULL;
 	char *channel = NULL;
 	int adapter = 0, frontend = 0, demux = 0, dvr = 0;
-	int vpid, apid;
-	int frontend_fd, video_fd, audio_fd;
+	int vpid, apid, sid, pmtpid = 0;
+	int frontend_fd, video_fd, audio_fd, pat_fd, pmt_fd;
 	int opt, list_channels = 0, chan_no = 0;
-	int human_readable = 0;
+	int human_readable = 0, rec_psi = 0;
 
-	while ((opt = getopt(argc, argv, "Hln:hrn:a:f:d:c:x")) != -1) {
+	while ((opt = getopt(argc, argv, "Hln:hrn:a:f:d:c:x:p")) != -1) {
 		switch (opt) {
 		case 'a':
 			adapter = strtoul(optarg, NULL, 0);
@@ -287,6 +288,9 @@
 		case 'n':
 			chan_no = strtoul(optarg, NULL, 0);
 			break;
+		case 'p':
+			rec_psi = 1;
+			break;
 		case 'x':
 			exit_after_tuning = 1;
 			break;
@@ -339,7 +343,7 @@
 
 	memset(&frontend_param, 0, sizeof(struct dvb_frontend_parameters));
 
-	if (parse(confname, list_channels, chan_no, channel, &frontend_param, &vpid, &apid))
+	if (parse(confname, list_channels, chan_no, channel, &frontend_param, &vpid, &apid, &sid))
 		return -1;
 	if (list_channels)
 		return 0;
@@ -352,6 +356,28 @@
 	if (setup_frontend(frontend_fd, &frontend_param) < 0)
 		return -1;
 
+	if (rec_psi) {
+		pmtpid = get_pmt_pid(DEMUX_DEV, sid);
+		if (pmtpid <= 0) {
+			fprintf(stderr,"couldn't find pmt-pid for sid %04x\n",sid);
+			return -1;
+		}
+
+		if ((pat_fd = open(DEMUX_DEV, O_RDWR)) < 0) {
+			perror("opening pat demux failed");
+			return -1;
+		}
+		if (set_pesfilter(pat_fd, 0, DMX_PES_OTHER, dvr) < 0)
+			return -1;
+
+		if ((pmt_fd = open(DEMUX_DEV, O_RDWR)) < 0) {
+			perror("opening pmt demux failed");
+			return -1;
+		}
+		if (set_pesfilter(pmt_fd, pmtpid, DMX_PES_OTHER, dvr) < 0)
+			return -1;
+	}
+
 	if ((video_fd = open(DEMUX_DEV, O_RDWR)) < 0) {
 		PERROR("failed opening '%s'", DEMUX_DEV);
 		return -1;
@@ -370,6 +396,8 @@
 
 	check_frontend (frontend_fd, human_readable);
 
+	close (pat_fd);
+	close (pmt_fd);
 	close (audio_fd);
 	close (video_fd);
 	close (frontend_fd);

--d8Lz2Tf5e5STOWUP--
