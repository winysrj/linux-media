Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:47585 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119Ab2HCK1l (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Aug 2012 06:27:41 -0400
Received: by wibhm11 with SMTP id hm11so6042467wib.1
        for <linux-media@vger.kernel.org>; Fri, 03 Aug 2012 03:27:40 -0700 (PDT)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 2/6] libdvbv5: allow more options in set_pesfilter
Date: Fri,  3 Aug 2012 12:26:55 +0200
Message-Id: <1343989619-12928-2-git-send-email-neolynx@gmail.com>
In-Reply-To: <1343989619-12928-1-git-send-email-neolynx@gmail.com>
References: <1343989619-12928-1-git-send-email-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: André Roth <neolynx@gmail.com>
---
 lib/include/dvb-demux.h  |    4 +++-
 lib/libdvbv5/dvb-demux.c |   14 ++++++--------
 utils/dvb/dvbv5-zap.c    |   17 +++++++++++++----
 3 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/lib/include/dvb-demux.h b/lib/include/dvb-demux.h
index 240d471..25cd56c 100644
--- a/lib/include/dvb-demux.h
+++ b/lib/include/dvb-demux.h
@@ -29,6 +29,8 @@
 #ifndef _DVB_DEMUX_H
 #define _DVB_DEMUX_H
 
+#include <linux/dvb/dmx.h>
+
 #ifdef __cplusplus
 extern "C" {
 #endif
@@ -36,7 +38,7 @@ extern "C" {
 int dvb_dmx_open(int adapter, int demux, unsigned verbose);
 void dvb_dmx_close(int dmx_fd);
 
-int set_pesfilter(int dmxfd, int pid, int pes_type, int dvr);
+int dvb_set_pesfilter(int dmxfd, int pid, dmx_pes_type_t type, dmx_output_t output, int buffersize);
 
 int get_pmt_pid(const char *dmxdev, int sid);
 
diff --git a/lib/libdvbv5/dvb-demux.c b/lib/libdvbv5/dvb-demux.c
index 7ece976..138b58a 100644
--- a/lib/libdvbv5/dvb-demux.c
+++ b/lib/libdvbv5/dvb-demux.c
@@ -38,7 +38,6 @@
 #include <fcntl.h>
 #include <stdlib.h> /* free */
 
-#include <linux/dvb/dmx.h>
 #include "dvb-demux.h"
 
 int dvb_dmx_open(int adapter, int demux, unsigned verbose)
@@ -56,26 +55,25 @@ void dvb_dmx_close(int dmx_fd)
   close( dmx_fd);
 }
 
-int set_pesfilter(int dmxfd, int pid, int pes_type, int dvr)
+int dvb_set_pesfilter(int dmxfd, int pid, dmx_pes_type_t type, dmx_output_t output, int buffersize)
 {
 	struct dmx_pes_filter_params pesfilter;
 
 	/* ignore this pid to allow radio services */
 	if (pid < 0 ||
 		pid >= 0x1fff ||
-		(pid == 0 && pes_type != DMX_PES_OTHER))
+		(pid == 0 && type != DMX_PES_OTHER))
 		return 0;
 
-	if (dvr) {
-		int buffersize = 64 * 1024;
+	if (buffersize) {
 		if (ioctl(dmxfd, DMX_SET_BUFFER_SIZE, buffersize) == -1)
-		perror("DMX_SET_BUFFER_SIZE failed");
+			perror("DMX_SET_BUFFER_SIZE failed");
 	}
 
 	pesfilter.pid = pid;
 	pesfilter.input = DMX_IN_FRONTEND;
-	pesfilter.output = dvr ? DMX_OUT_TS_TAP : DMX_OUT_DECODER;
-	pesfilter.pes_type = pes_type;
+	pesfilter.output = output;
+	pesfilter.pes_type = type;
 	pesfilter.flags = DMX_IMMEDIATE_START;
 
 	if (ioctl(dmxfd, DMX_SET_PES_FILTER, &pesfilter) == -1) {
diff --git a/utils/dvb/dvbv5-zap.c b/utils/dvb/dvbv5-zap.c
index f7e3c4a..6445149 100644
--- a/utils/dvb/dvbv5-zap.c
+++ b/utils/dvb/dvbv5-zap.c
@@ -550,14 +550,18 @@ int main(int argc, char **argv)
 			perror("opening pat demux failed");
 			return -1;
 		}
-		if (set_pesfilter(pat_fd, 0, DMX_PES_OTHER, args.dvr) < 0)
+		if (dvb_set_pesfilter(pat_fd, 0, DMX_PES_OTHER,
+				args.dvr ? DMX_OUT_TS_TAP : DMX_OUT_DECODER,
+				args.dvr ? 64 * 1024 : 0) < 0)
 			return -1;
 
 		if ((pmt_fd = open(args.demux_dev, O_RDWR)) < 0) {
 			perror("opening pmt demux failed");
 			return -1;
 		}
-		if (set_pesfilter(pmt_fd, pmtpid, DMX_PES_OTHER, args.dvr) < 0)
+		if (dvb_set_pesfilter(pmt_fd, pmtpid, DMX_PES_OTHER,
+				args.dvr ? DMX_OUT_TS_TAP : DMX_OUT_DECODER,
+				args.dvr ? 64 * 1024 : 0) < 0)
 			return -1;
 	}
 
@@ -568,7 +572,10 @@ int main(int argc, char **argv)
 			PERROR("failed opening '%s'", args.demux_dev);
 			return -1;
 		}
-		if (set_pesfilter(video_fd, vpid, DMX_PES_VIDEO, args.dvr) < 0)
+		printf( "  dvb_set_pesfilter %d\n", vpid );
+		if (dvb_set_pesfilter(video_fd, vpid, DMX_PES_VIDEO,
+				args.dvr ? DMX_OUT_TS_TAP : DMX_OUT_DECODER,
+				args.dvr ? 64 * 1024 : 0) < 0)
 			return -1;
 	}
 
@@ -580,7 +587,9 @@ int main(int argc, char **argv)
 			return -1;
 		}
 
-		if (set_pesfilter(audio_fd, apid, DMX_PES_AUDIO, args.dvr) < 0)
+		if (dvb_set_pesfilter(audio_fd, apid, DMX_PES_AUDIO,
+				args.dvr ? DMX_OUT_TS_TAP : DMX_OUT_DECODER,
+				args.dvr ? 64 * 1024 : 0) < 0)
 			return -1;
 	}
 
-- 
1.7.2.5

