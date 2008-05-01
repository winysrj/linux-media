Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ug-out-1314.google.com ([66.249.92.172])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mariofutire@googlemail.com>) id 1Jrgp0-0007bi-JB
	for linux-dvb@linuxtv.org; Fri, 02 May 2008 00:00:14 +0200
Received: by ug-out-1314.google.com with SMTP id o29so115614ugd.20
	for <linux-dvb@linuxtv.org>; Thu, 01 May 2008 15:00:06 -0700 (PDT)
Message-ID: <481A3D61.7040508@googlemail.com>
Date: Thu, 01 May 2008 23:00:01 +0100
From: Andrea <mariofutire@googlemail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Content-Type: multipart/mixed; boundary="------------080501070209070501040809"
Subject: [linux-dvb] [PATCH] Synchronize dvb-apps with v4l-dvb
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--------------080501070209070501040809
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

This patch (posted for the 3rd times) keeps dvb-apps in line with recent (and not so recent) changes 
in v4l-dvb:

1) for 2 years it has not been possible to open the dvr more than once for read only.
After this change http://linuxtv.org/hg/v4l-dvb/rev/64edfcc88eeb the dvr can only be opened once.
The patch fixes a comment to the function dvbdemux_open_dvr

2) this changeset http://linuxtv.org/hg/v4l-dvb/rev/65699e8bc6f7 added the option 
DMX_OUT_TSDEMUX_TAP to send the TS to the demux.
The patch enhances dvbdemux.h to use the DMX_OUT_TSDEMUX_TAP

3) a recent changest http://linuxtv.org/hg/v4l-dvb/rev/8389fb4e774c implemented DMX_SET_BUFFER for 
the dvr.
tzap used to set the dvr buffer size to 1MB (this ioctl call used to be ignored) while the default 
size is actually double (~2MB). I think the aim of the code was to make the buffer bigger and not to 
shrink it. That buffer in my opinion should stay as it is.

I've posted this patch 3 times already with 0 (i.e. ZERO) replies.
Is there anybody taking care of dvb-apps?

Regards

Andrea

--------------080501070209070501040809
Content-Type: text/x-patch;
 name="dvb-apps.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dvb-apps.diff"

diff -r 3cde3460d120 lib/libdvbapi/dvbdemux.c
--- a/lib/libdvbapi/dvbdemux.c	Tue Mar 11 12:40:20 2008 +0100
+++ b/lib/libdvbapi/dvbdemux.c	Sat Mar 22 00:07:29 2008 +0000
@@ -128,6 +128,10 @@ int dvbdemux_set_pes_filter(int fd, int 
 		filter.output = DMX_OUT_TS_TAP;
 		break;
 
+	case DVBDEMUX_OUTPUT_TS_DEMUX:
+		filter.output = DMX_OUT_TSDEMUX_TAP;
+		break;
+
 	default:
 		return -EINVAL;
 	}
@@ -201,6 +205,10 @@ int dvbdemux_set_pid_filter(int fd, int 
 		filter.output = DMX_OUT_TS_TAP;
 		break;
 
+	case DVBDEMUX_OUTPUT_TS_DEMUX:
+		filter.output = DMX_OUT_TSDEMUX_TAP;
+		break;
+
 	default:
 		return -EINVAL;
 	}
diff -r 3cde3460d120 lib/libdvbapi/dvbdemux.h
--- a/lib/libdvbapi/dvbdemux.h	Tue Mar 11 12:40:20 2008 +0100
+++ b/lib/libdvbapi/dvbdemux.h	Sat Mar 22 00:07:29 2008 +0000
@@ -55,6 +55,7 @@ extern "C"
 #define DVBDEMUX_OUTPUT_DECODER 0
 #define DVBDEMUX_OUTPUT_DEMUX 1
 #define DVBDEMUX_OUTPUT_DVR 2
+#define DVBDEMUX_OUTPUT_TS_DEMUX 3
 
 /**
  * PES types.
@@ -65,6 +66,7 @@ extern "C"
 #define DVBDEMUX_PESTYPE_SUBTITLE 3
 #define DVBDEMUX_PESTYPE_PCR 4
 
+
 /**
  * Open a demux device. Can be called multiple times. These let you setup a
  * single filter per FD. It can can also be read() from if you use a section
@@ -78,8 +80,8 @@ extern int dvbdemux_open_demux(int adapt
 extern int dvbdemux_open_demux(int adapter, int demuxdevice, int nonblocking);
 
 /**
- * Open a DVR device. May be opened for writing once, or multiple times in readonly
- * mode. It is used to either write() transport stream data to be demuxed
+ * Open a DVR device. May be opened for writing or reading once.
+ * It is used to either write() transport stream data to be demuxed
  * (if input == DVBDEMUX_INPUT_DVR), or to read() a stream of demuxed data
  * (if output == DVBDEMUX_OUTPUT_DVR).
  *
diff -r 3cde3460d120 util/szap/tzap.c
--- a/util/szap/tzap.c	Tue Mar 11 12:40:20 2008 +0100
+++ b/util/szap/tzap.c	Sat Mar 22 00:07:29 2008 +0000
@@ -676,11 +676,6 @@ int main(int argc, char **argv)
 	                PERROR("failed opening '%s'", DVR_DEV);
 	                return -1;
 	        }
-		if (ioctl(dvr_fd, DMX_SET_BUFFER_SIZE, 1024 * 1024)<0)
-		{
-			PERROR("DMX_SET_BUFFER_SIZE failed");
-			return -1;
-		}
 		if (silent<2)
 			print_frontend_stats (frontend_fd, human_readable);
 


--------------080501070209070501040809
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------080501070209070501040809--
