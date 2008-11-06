Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <handygewinnspiel@gmx.de>) id 1Ky7n8-0002Sh-S3
	for linux-dvb@linuxtv.org; Thu, 06 Nov 2008 17:33:07 +0100
Message-ID: <49131C19.1080404@gmx.de>
Date: Thu, 06 Nov 2008 17:32:25 +0100
From: wk <handygewinnspiel@gmx.de>
MIME-Version: 1.0
To: Hans Werner <HWerner4@gmx.de>
References: <20081106124730.16840@gmx.net>
In-Reply-To: <20081106124730.16840@gmx.net>
Content-Type: multipart/mixed; boundary="------------000200060402010106020007"
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] wscan: improved frontend autodetection
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
--------------000200060402010106020007
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

Hans Werner wrote:
> Currently wscan will not autodetect frontends which which have frontend != 0,
> i.e. it only detects /dev/dvb/adapterN/frontend0 where N=0-3.
>
> Since multiple frontends per adapter are supported in 2.6.28, this means the correct
> frontend may not be found. For example with the HVR4000, DVB-T is always at frontend1.
>
> The attached patch fixes this, searching for frontend 0-3 for each adapter 0-3.
>
> Signed-off-by: Hans Werner <hwerner4@gmx.de>
Good idea. :)
But while testing your patch it seems that it doesn't work as expected. 
Here some example:

w_scan version 20081106
Info: using DVB adapter auto detection.
   Found DVB-C frontend. Using adapter /dev/dvb/adapter0/frontend0
   Found DVB-C frontend. Using adapter /dev/dvb/adapter1/frontend0
   Found DVB-C frontend. Using adapter /dev/dvb/adapter2/frontend0
Info: unable to open frontend /dev/dvb/adapter3/frontend1'
Info: unable to open frontend /dev/dvb/adapter3/frontend2'
Info: unable to open frontend /dev/dvb/adapter3/frontend3'
-_-_-_-_ Getting frontend capabilities-_-_-_-_

I'm using three dvb-c frontends.
The detection doesnt stop anymore with your patch if a matching frontend 
was found, because it doesnt leave the outer loop.
Normally this search has to stop at /dev/dvb/adapter0/frontend0.
That means we have to change your patch a little. I also increased the 
number of adapters to 8, since i use more than 4.

Can you please test the attached patch and give some feedback? If it 
works fine for you, i would apply to w_scan.

-Winfried

PS: What is actually the maximum number of adapters and frontends per 
adapter? Can anybody give some hint?



--------------000200060402010106020007
Content-Type: text/plain;
 name="patch_wscan_fixautodetection2.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch_wscan_fixautodetection2.diff"

--- w_scan-20080815/scan.c	2008-09-09 19:21:36.698571084 +0200
+++ w_scan-20081106/scan.c	2008-11-06 17:28:19.720159563 +0100
@@ -77,7 +77,7 @@
 	.type = -1
 };
 
-uint version = 20080815;
+uint version = 20081106;
 int verbosity = 2;
 
 #define ATSC_VSB	0x01
@@ -2579,7 +2579,7 @@
 {
 	char frontend_devname [80];
 	int adapter = 999, frontend = 0, demux = 0;
-	int opt, i;
+	int opt, i, j;
 	int frontend_fd;
 	int fe_open_mode;
 	int frontend_type = FE_OFDM;
@@ -2715,19 +2715,19 @@
 	if ( adapter == 999 ) {
 		info("Info: using DVB adapter auto detection.\n");
 		fe_open_mode = O_RDWR | O_NONBLOCK;
-		for (i=0; i < 4; i++) {
-		  snprintf (frontend_devname, sizeof(frontend_devname),  		"/dev/dvb/adapter%i/frontend0", i);
-		  if ((frontend_fd = open (frontend_devname, fe_open_mode)) < 0) {
-		  	info("Info: unable to open frontend %s'\n", frontend_devname);
+		for (i=0; i < 8; i++) {
+		  for (j=0; j < 4; j++) {
+		    snprintf (frontend_devname, sizeof(frontend_devname), "/dev/dvb/adapter%i/frontend%i", i, j);
+		    if ((frontend_fd = open (frontend_devname, fe_open_mode)) < 0) {
 			continue;
 			}
-		/* determine FE type and caps */
-		if (ioctl(frontend_fd, FE_GET_INFO, &fe_info) == -1) {
+		    /* determine FE type and caps */
+		    if (ioctl(frontend_fd, FE_GET_INFO, &fe_info) == -1) {
 			info("   ERROR: unable to determine frontend type\n");
 			close (frontend_fd);
 			continue;
-			}		  
-		if (fe_info.type==frontend_type) {
+			}
+		    if (fe_info.type == frontend_type) {
 			if (fe_info.type == FE_OFDM) 
 			  info("   Found DVB-T frontend. Using adapter %s\n",frontend_devname);
                         else if (fe_info.type == FE_ATSC)
@@ -2736,9 +2736,14 @@
 			  info("   Found DVB-C frontend. Using adapter %s\n",frontend_devname);                     
 			close (frontend_fd);
 			adapter=i;
+			frontend=j;
+			i=999;
 			break;
-			} 		
+			}
+                     else
+                        info("   Wrong type, ignoring frontend %s\n",frontend_devname);
 
+		  }
 		}
 	}
 	snprintf (frontend_devname, sizeof(frontend_devname),

--------------000200060402010106020007
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------000200060402010106020007--
