Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nf-out-0910.google.com ([64.233.182.190])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mariofutire@googlemail.com>) id 1Jq2AL-00073r-Pa
	for linux-dvb@linuxtv.org; Sun, 27 Apr 2008 10:23:23 +0200
Received: by nf-out-0910.google.com with SMTP id d21so1567277nfb.11
	for <linux-dvb@linuxtv.org>; Sun, 27 Apr 2008 01:23:17 -0700 (PDT)
Message-ID: <481437F2.6040006@googlemail.com>
Date: Sun, 27 Apr 2008 09:23:14 +0100
From: Andrea <mariofutire@googlemail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Content-Type: multipart/mixed; boundary="------------080508040506090104020305"
Subject: [linux-dvb] [PATCH] preserve behavior of tzap (+ others)
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
--------------080508040506090104020305
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

After the recent implementation of DMX_SET_BUFFER_SIZE for the dvr, tzap has changed:
It used to resize the dvr's buffer to 1 MB, but the ioctl was ignored, so the buffer was always of 
the default size

#define DVR_BUFFER_SIZE (10*188*1024)

in dmxdev.h
I think the author of the code meant to *increase* the buffer (which, reading the documentation 
seems to be 8K: http://www.linuxtv.org/docs/dvbapi/DVB_Demux_Device.html).
The documentation does not apply to the dvr, but to the demux.

In thins patch:

1) tzap: removed the ioctl call to DMX_SET_BUFFER_SIZE on the dvr. This calls shrinks the size of 
the buffer, from about 2MB (#define DVR_BUFFER_SIZE (10*188*1024) in dmxdev.h) to 1MB.

2) in libdvbapi a change in a comment where it is stated that the dvr can be opened more that once 
in readonly. It can only be opened once.

3) in libdvbapi a new enum to support DMX_OUT_TSDEMUX_TAP

On top of that I would like to update the documentation of DMX_SET_BUFFER_SIZE, but I could not find 
the source.

Regards

Andrea


--------------080508040506090104020305
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
 


--------------080508040506090104020305
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------080508040506090104020305--
