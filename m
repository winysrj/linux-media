Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from main.gmane.org ([80.91.229.2] helo=ciao.gmane.org)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <gldd-linux-dvb@m.gmane.org>) id 1KH4jE-00069d-Kz
	for linux-dvb@linuxtv.org; Fri, 11 Jul 2008 00:35:09 +0200
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1KH4j8-0004kA-MS
	for linux-dvb@linuxtv.org; Thu, 10 Jul 2008 22:35:02 +0000
Received: from 77-103-126-124.cable.ubr10.dals.blueyonder.co.uk
	([77.103.126.124]) by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-dvb@linuxtv.org>; Thu, 10 Jul 2008 22:35:02 +0000
Received: from mariofutire by 77-103-126-124.cable.ubr10.dals.blueyonder.co.uk
	with local (Gmexim 0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <linux-dvb@linuxtv.org>; Thu, 10 Jul 2008 22:35:02 +0000
To: linux-dvb@linuxtv.org
From: Andrea <mariofutire@googlemail.com>
Date: Thu, 10 Jul 2008 23:29:15 +0100
Message-ID: <g562is$ij9$2@ger.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------030107040508010204010004"
Subject: [linux-dvb] [PATCH 2/2] make gnutv more resilient to temporary slow
	reads.
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
--------------030107040508010204010004
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

This is the second patch to improve resilience of gnutv under heavy load or busy networks.

Recently a ioctl call (DMX_SET_BUFFER_SIZE) to resize the internal ring buffer of the dvr device has
been implemented.

The buffer has a default size of 1900000 bytes.
With the following patch it is possible to make it bigger, so that temporary slow networks, busy
systems, will not overflow the dvr's internal buffer.

Here is the patch

diff -r 73b910014d07 util/gnutv/gnutv.c
--- a/util/gnutv/gnutv.c        Sat Jul 05 16:38:32 2008 +0200
+++ b/util/gnutv/gnutv.c        Thu Jul 10 23:04:30 2008 +0100
@@ -66,6 +66,7 @@
                  "                        * C-MULTI - Big Dish - Multipoint LNBf, 3700 to 4200 MHz,\n"
                  "                                               Dual LO, H:5150MHz, V:5750MHz.\n"
                  "                        * One of the sec definitions from the secfile if supplied\n"
+               " -buffer <size>                DVR buffer size (default 0=>do no change)\n"
                  " -out decoder          Output to hardware decoder (default)\n"
                  "      decoderabypass   Output to hardware decoder using audio bypass\n"
                  "      dvr              Output stream to dvr device\n"
@@ -124,6 +125,7 @@
          struct gnutv_ca_params gnutv_ca_params;
          int ffaudiofd = -1;
          int usertp = 0;
+       int buffersize = 0;

          while(argpos != argc) {
                  if (!strcmp(argv[argpos], "-h")) {
@@ -166,6 +168,14 @@
                          if ((argc - argpos) < 2)
                                  usage();
                          secid = argv[argpos+1];
+                       argpos+=2;
+               } else if (!strcmp(argv[argpos], "-buffer")) {
+                       if ((argc - argpos) < 2)
+                               usage();
+                       if (sscanf(argv[argpos+1], "%i", &buffersize) != 1)
+                               usage();
+                       if (buffersize < 0)
+                               usage();
                          argpos+=2;
                  } else if (!strcmp(argv[argpos], "-out")) {
                          if ((argc - argpos) < 2)
@@ -320,7 +330,7 @@
                  gnutv_dvb_start(&gnutv_dvb_params);

                  // start the data stuff
-               gnutv_data_start(output_type, ffaudiofd, adapter_id, demux_id, outfile, outif,
outaddrs, usertp);
+               gnutv_data_start(output_type, ffaudiofd, adapter_id, demux_id, buffersize, outfile,
outif, outaddrs, usertp);
          }

          // the UI
diff -r 73b910014d07 util/gnutv/gnutv_data.c
--- a/util/gnutv/gnutv_data.c   Sat Jul 05 16:38:32 2008 +0200
+++ b/util/gnutv/gnutv_data.c   Thu Jul 10 23:04:30 2008 +0100
@@ -77,7 +77,7 @@
   static int pid_fds_count = 0;

   void gnutv_data_start(int _output_type,
-                   int ffaudiofd, int _adapter_id, int _demux_id,
+                   int ffaudiofd, int _adapter_id, int _demux_id, int buffer_size,
                      char *outfile,
                      char* outif, struct addrinfo *_outaddrs, int _usertp)
   {
@@ -114,6 +114,14 @@
                          exit(1);
                  }

+               // optionally set dvr buffer size
+               if (buffer_size > 0) {
+                       if (dvbdemux_set_buffer(dvrfd, buffer_size) != 0) {
+                               fprintf(stderr, "Failed to set DVR buffer size\n");
+                               exit(1);
+                       }
+               }
+
                  pthread_create(&outputthread, NULL, fileoutputthread_func, NULL);
                  break;

@@ -140,6 +148,14 @@
                  if (dvrfd < 0) {
                          fprintf(stderr, "Failed to open DVR device\n");
                          exit(1);
+               }
+
+               // optionally set dvr buffer size
+               if (buffer_size > 0) {
+                       if (dvbdemux_set_buffer(dvrfd, buffer_size) != 0) {
+                               fprintf(stderr, "Failed to set DVR buffer size\n");
+                               exit(1);
+                       }
                  }

                  pthread_create(&outputthread, NULL, udpoutputthread_func, NULL);
diff -r 73b910014d07 util/gnutv/gnutv_data.h
--- a/util/gnutv/gnutv_data.h   Sat Jul 05 16:38:32 2008 +0200
+++ b/util/gnutv/gnutv_data.h   Thu Jul 10 23:04:30 2008 +0100
@@ -26,7 +26,7 @@
   #include <netdb.h>

   extern void gnutv_data_start(int output_type,
-                          int ffaudiofd, int adapter_id, int demux_id,
+                          int ffaudiofd, int adapter_id, int demux_id, int buffer_size,
                             char *outfile,
                             char* outif, struct addrinfo *outaddrs, int usertp);
   extern void gnutv_data_stop(void);


--------------030107040508010204010004
Content-Type: text/plain;
 name="gnutv.diff1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="gnutv.diff1"

diff -r 73b910014d07 util/gnutv/gnutv.c
--- a/util/gnutv/gnutv.c	Sat Jul 05 16:38:32 2008 +0200
+++ b/util/gnutv/gnutv.c	Thu Jul 10 23:04:30 2008 +0100
@@ -66,6 +66,7 @@
 		"			 * C-MULTI - Big Dish - Multipoint LNBf, 3700 to 4200 MHz,\n"
 		"						Dual LO, H:5150MHz, V:5750MHz.\n"
 		"			 * One of the sec definitions from the secfile if supplied\n"
+		" -buffer <size>		DVR buffer size (default 0=>do no change)\n"
 		" -out decoder		Output to hardware decoder (default)\n"
 		"      decoderabypass	Output to hardware decoder using audio bypass\n"
 		"      dvr		Output stream to dvr device\n"
@@ -124,6 +125,7 @@
 	struct gnutv_ca_params gnutv_ca_params;
 	int ffaudiofd = -1;
 	int usertp = 0;
+	int buffersize = 0;
 
 	while(argpos != argc) {
 		if (!strcmp(argv[argpos], "-h")) {
@@ -166,6 +168,14 @@
 			if ((argc - argpos) < 2)
 				usage();
 			secid = argv[argpos+1];
+			argpos+=2;
+		} else if (!strcmp(argv[argpos], "-buffer")) {
+			if ((argc - argpos) < 2)
+				usage();
+			if (sscanf(argv[argpos+1], "%i", &buffersize) != 1)
+				usage();
+			if (buffersize < 0)
+				usage();
 			argpos+=2;
 		} else if (!strcmp(argv[argpos], "-out")) {
 			if ((argc - argpos) < 2)
@@ -320,7 +330,7 @@
 		gnutv_dvb_start(&gnutv_dvb_params);
 
 		// start the data stuff
-		gnutv_data_start(output_type, ffaudiofd, adapter_id, demux_id, outfile, outif, outaddrs, usertp);
+		gnutv_data_start(output_type, ffaudiofd, adapter_id, demux_id, buffersize, outfile, outif, outaddrs, usertp);
 	}
 
 	// the UI
diff -r 73b910014d07 util/gnutv/gnutv_data.c
--- a/util/gnutv/gnutv_data.c	Sat Jul 05 16:38:32 2008 +0200
+++ b/util/gnutv/gnutv_data.c	Thu Jul 10 23:04:30 2008 +0100
@@ -77,7 +77,7 @@
 static int pid_fds_count = 0;
 
 void gnutv_data_start(int _output_type,
-		    int ffaudiofd, int _adapter_id, int _demux_id,
+		    int ffaudiofd, int _adapter_id, int _demux_id, int buffer_size,
 		    char *outfile,
 		    char* outif, struct addrinfo *_outaddrs, int _usertp)
 {
@@ -114,6 +114,14 @@
 			exit(1);
 		}
 
+		// optionally set dvr buffer size
+		if (buffer_size > 0) {
+			if (dvbdemux_set_buffer(dvrfd, buffer_size) != 0) {
+				fprintf(stderr, "Failed to set DVR buffer size\n");
+				exit(1);
+			}
+		}
+
 		pthread_create(&outputthread, NULL, fileoutputthread_func, NULL);
 		break;
 
@@ -140,6 +148,14 @@
 		if (dvrfd < 0) {
 			fprintf(stderr, "Failed to open DVR device\n");
 			exit(1);
+		}
+
+		// optionally set dvr buffer size
+		if (buffer_size > 0) {
+			if (dvbdemux_set_buffer(dvrfd, buffer_size) != 0) {
+				fprintf(stderr, "Failed to set DVR buffer size\n");
+				exit(1);
+			}
 		}
 
 		pthread_create(&outputthread, NULL, udpoutputthread_func, NULL);
diff -r 73b910014d07 util/gnutv/gnutv_data.h
--- a/util/gnutv/gnutv_data.h	Sat Jul 05 16:38:32 2008 +0200
+++ b/util/gnutv/gnutv_data.h	Thu Jul 10 23:04:30 2008 +0100
@@ -26,7 +26,7 @@
 #include <netdb.h>
 
 extern void gnutv_data_start(int output_type,
-			   int ffaudiofd, int adapter_id, int demux_id,
+			   int ffaudiofd, int adapter_id, int demux_id, int buffer_size,
 			   char *outfile,
 			   char* outif, struct addrinfo *outaddrs, int usertp);
 extern void gnutv_data_stop(void);


--------------030107040508010204010004
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------030107040508010204010004--
