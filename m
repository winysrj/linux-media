Return-path: <linux-media-owner@vger.kernel.org>
Received: from tichy.grunau.be ([85.131.189.73]:49933 "EHLO tichy.grunau.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753069Ab0BJSe7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Feb 2010 13:34:59 -0500
Received: from localhost (p5DDC401F.dip0.t-ipconnect.de [93.220.64.31])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by tichy.grunau.be (Postfix) with ESMTPSA id 6321690076
	for <linux-media@vger.kernel.org>; Wed, 10 Feb 2010 19:35:00 +0100 (CET)
Date: Wed, 10 Feb 2010 19:36:35 +0100
From: Janne Grunau <j@jannau.net>
To: linux-media@vger.kernel.org
Subject: [PATCH 2 of 7] szap: move get_pmt_pid() to utils.c
Message-ID: <20100210183635.GM8026@aniel.lan>
References: <patchbomb.1265826616@aniel.lan>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="3uo+9/B/ebqu+fSQ"
Content-Disposition: inline
In-Reply-To: <patchbomb.1265826616@aniel.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--3uo+9/B/ebqu+fSQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

 util/szap/szap.c |  60 -------------------------------------------------------
 util/szap/util.c |  61 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 util/szap/util.h |   2 +
 3 files changed, 63 insertions(+), 60 deletions(-)



--3uo+9/B/ebqu+fSQ
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: inline; filename="dvb-apps-2.patch"

# HG changeset patch
# User Janne Grunau <j@jannau.net>
# Date 1265820330 -3600
# Node ID d79f9e2901a05fbee905998294d9cb1ae46a422d
# Parent  28369a87b6c7db2a5704be5dda8ed60a4cbf3397
szap: move get_pmt_pid() to utils.c

to be reused by the other zap implemetations

diff -r 28369a87b6c7 -r d79f9e2901a0 util/szap/szap.c
--- a/util/szap/szap.c	Wed Feb 10 17:40:41 2010 +0100
+++ b/util/szap/szap.c	Wed Feb 10 17:45:30 2010 +0100
@@ -93,66 +93,6 @@
     "     -p        : add pat and pmt to TS recording (implies -r)\n"
     "                 or -n numbers for zapping\n";
 
-int get_pmt_pid(char *dmxdev, int sid)
-{
-   int patfd, count;
-   int pmt_pid = 0;
-   int patread = 0;
-   int section_length;
-   unsigned char buft[4096];
-   unsigned char *buf = buft;
-   struct dmx_sct_filter_params f;
-
-   memset(&f, 0, sizeof(f));
-   f.pid = 0;
-   f.filter.filter[0] = 0x00;
-   f.filter.mask[0] = 0xff;
-   f.timeout = 0;
-   f.flags = DMX_IMMEDIATE_START | DMX_CHECK_CRC;
-
-   if ((patfd = open(dmxdev, O_RDWR)) < 0) {
-      perror("openening pat demux failed");
-      return -1;
-   }
-
-   if (ioctl(patfd, DMX_SET_FILTER, &f) == -1) {
-      perror("ioctl DMX_SET_FILTER failed");
-      close(patfd);
-      return -1;
-   }
-
-   while (!patread){
-      if (((count = read(patfd, buf, sizeof(buft))) < 0) && errno == EOVERFLOW)
-         count = read(patfd, buf, sizeof(buft));
-      if (count < 0) {
-         perror("read_sections: read error");
-         close(patfd);
-         return -1;
-      }
-
-      section_length = ((buf[1] & 0x0f) << 8) | buf[2];
-      if (count != section_length + 3)
-         continue;
-
-      buf += 8;
-      section_length -= 8;
-
-      patread = 1; /* assumes one section contains the whole pat */
-      while (section_length > 0) {
-         int service_id = (buf[0] << 8) | buf[1];
-         if (service_id == sid) {
-            pmt_pid = ((buf[2] & 0x1f) << 8) | buf[3];
-            section_length = 0;
-         }
-         buf += 4;
-         section_length -= 4;
-     }
-   }
-
-   close(patfd);
-   return pmt_pid;
-}
-
 struct diseqc_cmd {
    struct dvb_diseqc_master_cmd cmd;
    uint32_t wait;
diff -r 28369a87b6c7 -r d79f9e2901a0 util/szap/util.c
--- a/util/szap/util.c	Wed Feb 10 17:40:41 2010 +0100
+++ b/util/szap/util.c	Wed Feb 10 17:45:30 2010 +0100
@@ -63,3 +63,64 @@
 
     return 0;
 }
+
+
+int get_pmt_pid(char *dmxdev, int sid)
+{
+    int patfd, count;
+    int pmt_pid = 0;
+    int patread = 0;
+    int section_length;
+    unsigned char buft[4096];
+    unsigned char *buf = buft;
+    struct dmx_sct_filter_params f;
+
+    memset(&f, 0, sizeof(f));
+    f.pid = 0;
+    f.filter.filter[0] = 0x00;
+    f.filter.mask[0] = 0xff;
+    f.timeout = 0;
+    f.flags = DMX_IMMEDIATE_START | DMX_CHECK_CRC;
+
+    if ((patfd = open(dmxdev, O_RDWR)) < 0) {
+	perror("openening pat demux failed");
+	return -1;
+    }
+
+    if (ioctl(patfd, DMX_SET_FILTER, &f) == -1) {
+	perror("ioctl DMX_SET_FILTER failed");
+	close(patfd);
+	return -1;
+    }
+
+    while (!patread){
+	if (((count = read(patfd, buf, sizeof(buft))) < 0) && errno == EOVERFLOW)
+	    count = read(patfd, buf, sizeof(buft));
+	if (count < 0) {
+	    perror("read_sections: read error");
+	    close(patfd);
+	    return -1;
+	}
+	
+	section_length = ((buf[1] & 0x0f) << 8) | buf[2];
+	if (count != section_length + 3)
+	    continue;
+	
+	buf += 8;
+	section_length -= 8;
+	
+	patread = 1; /* assumes one section contains the whole pat */
+	while (section_length > 0) {
+	    int service_id = (buf[0] << 8) | buf[1];
+	    if (service_id == sid) {
+		pmt_pid = ((buf[2] & 0x1f) << 8) | buf[3];
+		section_length = 0;
+	    }
+	    buf += 4;
+	    section_length -= 4;
+	}
+    }
+
+    close(patfd);
+    return pmt_pid;
+}
diff -r 28369a87b6c7 -r d79f9e2901a0 util/szap/util.h
--- a/util/szap/util.h	Wed Feb 10 17:40:41 2010 +0100
+++ b/util/szap/util.h	Wed Feb 10 17:45:30 2010 +0100
@@ -20,3 +20,5 @@
  */
 
 int set_pesfilter(int dmxfd, int pid, int pes_type, int dvr);
+
+int get_pmt_pid(char *dmxdev, int sid);
\ No newline at end of file

--3uo+9/B/ebqu+fSQ--
