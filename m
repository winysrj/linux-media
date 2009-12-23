Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by mail.linuxtv.org with smtp (Exim 4.69)
	(envelope-from <max_seesslen@gmx.de>) id 1NNYh2-00045c-CE
	for linux-dvb@linuxtv.org; Wed, 23 Dec 2009 22:24:29 +0100
Received: from e179118144.adsl.alicedsl.de ([85.179.118.144]
	helo=mash.localnet)
	by sid with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32) (Exim 4.69)
	(envelope-from <max_seesslen@gmx.de>) id 1NNYgN-0005DP-87
	for linux-dvb@linuxtv.org; Wed, 23 Dec 2009 22:23:47 +0100
From: Maximilian Seesslen <mes@seesslen.net>
To: linux-dvb@linuxtv.org
Date: Wed, 23 Dec 2009 22:20:29 +0100
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_dmoMLxOs8pXChzM"
Message-Id: <200912232220.29626.mes@seesslen.net>
Subject: [linux-dvb] Acoustical mode for femon
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--Boundary-00=_dmoMLxOs8pXChzM
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi List,

find attached a patch that adds a "Acoustical mode" to femon.
The monitoring application produces a sound indicating the signal quality. =
The=20
higher the beep the better the signal quality.
This is useful while mounting the antenna for finding the best position wit=
hout=20
having to look at the monitor or without even having a monitor.


=2D-
Maximilian See=DFlen
Ludwigstrasse 9
D-87437 Kempten

+49 831 687 510 2
+49 174 233 644 3
seesslen.net

--Boundary-00=_dmoMLxOs8pXChzM
Content-Type: text/x-patch;
  charset="UTF-8";
  name="femon.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="femon.diff"

diff -r dd1b701fcacc util/femon/femon.c
--- a/util/femon/femon.c	Sat Dec 05 22:51:46 2009 +0100
+++ b/util/femon/femon.c	Wed Dec 23 22:17:40 2009 +0100
@@ -42,10 +42,17 @@
 static char *usage_str =
     "\nusage: femon [options]\n"
     "     -H        : human readable output\n"
+    "     -A        : Acoustical mode. A sound indicates the signal quality.\n"
+    "     -r        : If 'Acoustical mode' is active it tells the application\n"
+    "                 is called remotely via ssh. The sound is heard on the 'real'\n"
+    "                 machine but. The user has to be root.\n"
     "     -a number : use given adapter (default 0)\n"
     "     -f number : use given frontend (default 0)\n"
     "     -c number : samples to take (default 0 = infinite)\n\n";
 
+int sleep_time=1000000;
+int acoustical_mode=0;
+int remote=0;
 
 static void usage(void)
 {
@@ -59,6 +66,27 @@
 {
 	struct dvbfe_info fe_info;
 	unsigned int samples = 0;
+	FILE *ttyFile=NULL;
+	
+	// We dont write the "beep"-codes to stdout but to /dev/tty1.
+	// This is neccessary for Thin-Client-Systems or Streaming-Boxes
+	// where the computer does not have a monitor and femon is called via ssh.
+	if(acoustical_mode)
+	{
+	    if(remote)
+	    {
+		ttyFile=fopen("/dev/tty1","w");
+	        if(!ttyFile)
+		{
+		    fprintf(stderr, "Could not open /dev/tty1. No access rights?\n");
+		    exit(-1);
+		}
+	    }
+	    else
+	    {
+		ttyFile=stdout;
+	    }
+	}
 
 	do {
 		if (dvbfe_get_info(fe, FE_STATUS_PARAMS, &fe_info, DVBFE_INFO_QUERYTYPE_IMMEDIATE, 0) != FE_STATUS_PARAMS) {
@@ -94,12 +122,24 @@
 		if (fe_info.lock)
 			printf("FE_HAS_LOCK");
 
+		// create beep if acoustical_mode enabled
+		if(acoustical_mode)
+		{
+		    int signal=(fe_info.signal_strength * 100) / 0xffff;
+		    fprintf( ttyFile, "\033[10;%d]\a", 500+(signal*2));
+		    // printf("Variable : %d\n", signal);
+		    fflush(ttyFile);
+		}
+
 		printf("\n");
 		fflush(stdout);
-		usleep(1000000);
+		usleep(sleep_time);
 		samples++;
 	} while ((!count) || (count-samples));
-
+	
+	if(ttyFile)
+	    fclose(ttyFile);
+	
 	return 0;
 }
 
@@ -148,7 +188,7 @@
 	int human_readable = 0;
 	int opt;
 
-       while ((opt = getopt(argc, argv, "Ha:f:c:")) != -1) {
+       while ((opt = getopt(argc, argv, "rAHa:f:c:")) != -1) {
 		switch (opt)
 		{
 		default:
@@ -166,6 +206,15 @@
 		case 'H':
 			human_readable = 1;
 			break;
+		case 'A':
+			// Acoustical mode: we have to reduce the delay between
+			// checks in order to hear nice sound
+			sleep_time=5000;
+			acoustical_mode=1;
+			break;
+		case 'r':
+			remote=1;
+			break;
 		}
 	}
 

--Boundary-00=_dmoMLxOs8pXChzM
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--Boundary-00=_dmoMLxOs8pXChzM--
