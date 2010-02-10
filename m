Return-path: <linux-media-owner@vger.kernel.org>
Received: from tichy.grunau.be ([85.131.189.73]:49932 "EHLO tichy.grunau.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753069Ab0BJSes (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Feb 2010 13:34:48 -0500
Received: from localhost (p5DDC401F.dip0.t-ipconnect.de [93.220.64.31])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by tichy.grunau.be (Postfix) with ESMTPSA id 464FB90076
	for <linux-media@vger.kernel.org>; Wed, 10 Feb 2010 19:34:49 +0100 (CET)
Date: Wed, 10 Feb 2010 19:36:24 +0100
From: Janne Grunau <j@jannau.net>
To: linux-media@vger.kernel.org
Subject: [PATCH 1 of 7] szap: move duplicate function set_pesfilter|demux
 to a common object
Message-ID: <20100210183624.GL8026@aniel.lan>
References: <patchbomb.1265826616@aniel.lan>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="BOKacYhQ+x31HxR3"
Content-Disposition: inline
In-Reply-To: <patchbomb.1265826616@aniel.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--BOKacYhQ+x31HxR3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

 util/szap/Makefile |   2 +-
 util/szap/azap.c   |  27 +--------------------
 util/szap/czap.c   |  27 +--------------------
 util/szap/szap.c   |  37 ++++--------------------------
 util/szap/tzap.c   |  27 +--------------------
 util/szap/util.c   |  65 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 util/szap/util.h   |  22 ++++++++++++++++++
 7 files changed, 99 insertions(+), 108 deletions(-)



--BOKacYhQ+x31HxR3
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: inline; filename="dvb-apps-1.patch"

# HG changeset patch
# User Janne Grunau <j@jannau.net>
# Date 1265820041 -3600
# Node ID 28369a87b6c7db2a5704be5dda8ed60a4cbf3397
# Parent  80e9da1c00934139c817b33430bf44836f51406e
szap: move duplicate function set_pesfilter|demux to a common object

diff -r 80e9da1c0093 -r 28369a87b6c7 util/szap/Makefile
--- a/util/szap/Makefile	Sun Feb 07 17:01:50 2010 +0100
+++ b/util/szap/Makefile	Wed Feb 10 17:40:41 2010 +0100
@@ -1,6 +1,6 @@
 # Makefile for linuxtv.org dvb-apps/util/szap
 
-objects  = lnb.o
+objects  = lnb.o util.o
 
 binaries = azap  \
            czap  \
diff -r 80e9da1c0093 -r 28369a87b6c7 util/szap/azap.c
--- a/util/szap/azap.c	Sun Feb 07 17:01:50 2010 +0100
+++ b/util/szap/azap.c	Wed Feb 10 17:40:41 2010 +0100
@@ -13,6 +13,8 @@
 #include <linux/dvb/frontend.h>
 #include <linux/dvb/dmx.h>
 
+#include "util.h"
+
 static char FRONTEND_DEV [80];
 static char DEMUX_DEV [80];
 
@@ -209,31 +211,6 @@
 
 
 static
-int set_pesfilter (int fd, int pid, dmx_pes_type_t type, int dvr)
-{
-        struct dmx_pes_filter_params pesfilter;
-
-        if (pid <= 0 || pid >= 0x1fff)
-                return 0;
-
-        pesfilter.pid = pid;
-        pesfilter.input = DMX_IN_FRONTEND;
-        pesfilter.output = dvr ? DMX_OUT_TS_TAP : DMX_OUT_DECODER;
-        pesfilter.pes_type = type;
-        pesfilter.flags = DMX_IMMEDIATE_START;
-
-        if (ioctl(fd, DMX_SET_PES_FILTER, &pesfilter) < 0) {
-                PERROR ("ioctl(DMX_SET_PES_FILTER) for %s PID failed",
-                        type == DMX_PES_AUDIO ? "Audio" :
-                        type == DMX_PES_VIDEO ? "Video" : "??");
-                return -1;
-        }
-
-        return 0;
-}
-
-
-static
 int setup_frontend (int fe_fd, struct dvb_frontend_parameters *frontend)
 {
 	struct dvb_frontend_info fe_info;
diff -r 80e9da1c0093 -r 28369a87b6c7 util/szap/czap.c
--- a/util/szap/czap.c	Sun Feb 07 17:01:50 2010 +0100
+++ b/util/szap/czap.c	Wed Feb 10 17:40:41 2010 +0100
@@ -13,6 +13,8 @@
 #include <linux/dvb/frontend.h>
 #include <linux/dvb/dmx.h>
 
+#include "util.h"
+
 
 static char FRONTEND_DEV [80];
 static char DEMUX_DEV [80];
@@ -178,31 +180,6 @@
 }
 
 
-
-static
-int set_pesfilter (int fd, int pid, dmx_pes_type_t type, int dvr)
-{
-	struct dmx_pes_filter_params pesfilter;
-
-	if (pid <= 0 || pid >= 0x1fff)
-		return 0;
-
-	pesfilter.pid = pid;
-	pesfilter.input = DMX_IN_FRONTEND;
-	pesfilter.output = dvr ? DMX_OUT_TS_TAP : DMX_OUT_DECODER;
-	pesfilter.pes_type = type;
-	pesfilter.flags = DMX_IMMEDIATE_START;
-
-	if (ioctl(fd, DMX_SET_PES_FILTER, &pesfilter) < 0) {
-		PERROR ("ioctl(DMX_SET_PES_FILTER) for %s PID failed",
-			type == DMX_PES_AUDIO ? "Audio" :
-			type == DMX_PES_VIDEO ? "Video" : "??");
-		return -1;
-	}
-
-	return 0;
-}
-
 static
 int setup_frontend(int fe_fd, struct dvb_frontend_parameters *frontend)
 {
diff -r 80e9da1c0093 -r 28369a87b6c7 util/szap/szap.c
--- a/util/szap/szap.c	Sun Feb 07 17:01:50 2010 +0100
+++ b/util/szap/szap.c	Wed Feb 10 17:40:41 2010 +0100
@@ -48,6 +48,7 @@
 #include <linux/dvb/dmx.h>
 #include <linux/dvb/audio.h>
 #include "lnb.h"
+#include "util.h"
 
 #ifndef TRUE
 #define TRUE (1==1)
@@ -92,34 +93,6 @@
     "     -p        : add pat and pmt to TS recording (implies -r)\n"
     "                 or -n numbers for zapping\n";
 
-static int set_demux(int dmxfd, int pid, int pes_type, int dvr)
-{
-   struct dmx_pes_filter_params pesfilter;
-
-   if (pid < 0 || pid >= 0x1fff) /* ignore this pid to allow radio services */
-	   return TRUE;
-
-   if (dvr) {
-      int buffersize = 64 * 1024;
-      if (ioctl(dmxfd, DMX_SET_BUFFER_SIZE, buffersize) == -1)
-        perror("DMX_SET_BUFFER_SIZE failed");
-   }
-
-   pesfilter.pid = pid;
-   pesfilter.input = DMX_IN_FRONTEND;
-   pesfilter.output = dvr ? DMX_OUT_TS_TAP : DMX_OUT_DECODER;
-   pesfilter.pes_type = pes_type;
-   pesfilter.flags = DMX_IMMEDIATE_START;
-
-   if (ioctl(dmxfd, DMX_SET_PES_FILTER, &pesfilter) == -1) {
-      fprintf(stderr, "DMX_SET_PES_FILTER failed "
-	      "(PID = 0x%04x): %d %m\n", pid, errno);
-      return FALSE;
-   }
-
-   return TRUE;
-}
-
 int get_pmt_pid(char *dmxdev, int sid)
 {
    int patfd, count;
@@ -390,10 +363,10 @@
 
    if (diseqc(fefd, sat_no, pol, hiband))
       if (do_tune(fefd, ifreq, sr))
-	 if (set_demux(dmxfdv, vpid, DMX_PES_VIDEO, dvr))
+	 if (set_pesfilter(dmxfdv, vpid, DMX_PES_VIDEO, dvr))
 	    if (audiofd >= 0)
 	       (void)ioctl(audiofd, AUDIO_SET_BYPASS_MODE, bypass);
-	    if (set_demux(dmxfda, apid, DMX_PES_AUDIO, dvr)) {
+	    if (set_pesfilter(dmxfda, apid, DMX_PES_AUDIO, dvr)) {
 	       if (rec_psi) {
 	          pmtpid = get_pmt_pid(dmxdev, sid);
 		  if (pmtpid < 0) {
@@ -403,8 +376,8 @@
 		     fprintf(stderr,"couldn't find pmt-pid for sid %04x\n",sid);
 		     result = FALSE;
 		  }
-		  if (set_demux(patfd, 0, DMX_PES_OTHER, dvr))
-	             if (set_demux(pmtfd, pmtpid, DMX_PES_OTHER, dvr))
+		  if (set_pesfilter(patfd, 0, DMX_PES_OTHER, dvr))
+	             if (set_pesfilter(pmtfd, pmtpid, DMX_PES_OTHER, dvr))
 	                result = TRUE;
 	          } else {
 		    result = TRUE;
diff -r 80e9da1c0093 -r 28369a87b6c7 util/szap/tzap.c
--- a/util/szap/tzap.c	Sun Feb 07 17:01:50 2010 +0100
+++ b/util/szap/tzap.c	Wed Feb 10 17:40:41 2010 +0100
@@ -35,6 +35,8 @@
 #include <linux/dvb/frontend.h>
 #include <linux/dvb/dmx.h>
 
+#include "util.h"
+
 static char FRONTEND_DEV [80];
 static char DEMUX_DEV [80];
 static char DVR_DEV [80];
@@ -351,31 +353,6 @@
 
 
 static
-int set_pesfilter (int fd, int pid, dmx_pes_type_t type, int dvr)
-{
-        struct dmx_pes_filter_params pesfilter;
-
-        if (pid <= 0 || pid >= 0x1fff)
-                return 0;
-
-        pesfilter.pid = pid;
-        pesfilter.input = DMX_IN_FRONTEND;
-        pesfilter.output = dvr ? DMX_OUT_TS_TAP : DMX_OUT_DECODER;
-        pesfilter.pes_type = type;
-        pesfilter.flags = DMX_IMMEDIATE_START;
-
-        if (ioctl(fd, DMX_SET_PES_FILTER, &pesfilter) < 0) {
-                PERROR ("ioctl(DMX_SET_PES_FILTER) for %s PID failed",
-                        type == DMX_PES_AUDIO ? "Audio" :
-                        type == DMX_PES_VIDEO ? "Video" : "??");
-                return -1;
-        }
-
-        return 0;
-}
-
-
-static
 int setup_frontend (int fe_fd, struct dvb_frontend_parameters *frontend)
 {
 	struct dvb_frontend_info fe_info;
diff -r 80e9da1c0093 -r 28369a87b6c7 util/szap/util.c
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/szap/util.c	Wed Feb 10 17:40:41 2010 +0100
@@ -0,0 +1,65 @@
+/*
+ * util functions for various ?zap implementations
+ *
+ * Copyright (C) 2001 Johannes Stezenbach (js@convergence.de)
+ * for convergence integrated media
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <string.h>
+#include <unistd.h>
+#include <stdio.h>
+#include <errno.h>
+
+#include <sys/ioctl.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+
+#include <linux/dvb/frontend.h>
+#include <linux/dvb/dmx.h>
+
+
+int set_pesfilter(int dmxfd, int pid, int pes_type, int dvr)
+{
+    struct dmx_pes_filter_params pesfilter;
+
+    /* ignore this pid to allow radio services */
+    if (pid < 0 ||
+	pid >= 0x1fff ||
+	(pid == 0 && pes_type != DMX_PES_OTHER))
+	return 0;
+
+    if (dvr) {
+	int buffersize = 64 * 1024;
+	if (ioctl(dmxfd, DMX_SET_BUFFER_SIZE, buffersize) == -1)
+	    perror("DMX_SET_BUFFER_SIZE failed");
+    }
+
+    pesfilter.pid = pid;
+    pesfilter.input = DMX_IN_FRONTEND;
+    pesfilter.output = dvr ? DMX_OUT_TS_TAP : DMX_OUT_DECODER;
+    pesfilter.pes_type = pes_type;
+    pesfilter.flags = DMX_IMMEDIATE_START;
+
+    if (ioctl(dmxfd, DMX_SET_PES_FILTER, &pesfilter) == -1) {
+	fprintf(stderr, "DMX_SET_PES_FILTER failed "
+	"(PID = 0x%04x): %d %m\n", pid, errno);
+	return -1;
+    }
+
+    return 0;
+}
diff -r 80e9da1c0093 -r 28369a87b6c7 util/szap/util.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/util/szap/util.h	Wed Feb 10 17:40:41 2010 +0100
@@ -0,0 +1,22 @@
+/*
+ * util functions for various ?zap implementations
+ *
+ * Copyright (C) 2001 Johannes Stezenbach (js@convergence.de)
+ * for convergence integrated media
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+int set_pesfilter(int dmxfd, int pid, int pes_type, int dvr);

--BOKacYhQ+x31HxR3--
