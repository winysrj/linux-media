Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <HWerner4@gmx.de>) id 1Ky4HN-00069Y-64
	for linux-dvb@linuxtv.org; Thu, 06 Nov 2008 13:48:06 +0100
Content-Type: multipart/mixed; boundary="========GMX16841225975650563989"
Date: Thu, 06 Nov 2008 13:47:30 +0100
From: "Hans Werner" <HWerner4@gmx.de>
Message-ID: <20081106124730.16840@gmx.net>
MIME-Version: 1.0
To: handygewinnspiel@gmx.de, linux-dvb@linuxtv.org
Subject: [linux-dvb] [PATCH] wscan: improved frontend autodetection
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

--========GMX16841225975650563989
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit

Currently wscan will not autodetect frontends which which have frontend != 0,
i.e. it only detects /dev/dvb/adapterN/frontend0 where N=0-3.

Since multiple frontends per adapter are supported in 2.6.28, this means the correct
frontend may not be found. For example with the HVR4000, DVB-T is always at frontend1.

The attached patch fixes this, searching for frontend 0-3 for each adapter 0-3.

Signed-off-by: Hans Werner <hwerner4@gmx.de>.


-- 
Release early, release often.

GMX Download-Spiele: Preizsturz! Alle Puzzle-Spiele Deluxe über 60% billiger.
http://games.entertainment.gmx.net/de/entertainment/games/download/puzzle/index.html

--========GMX16841225975650563989
Content-Type: text/x-patch;
 charset="iso-8859-15";
 name="patch_wscan_fixautodetection.diff"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="patch_wscan_fixautodetection.diff"

diff -Nur w_scan-20080815/scan.c w_scan-20080815_fixautodetection/scan.c
--- w_scan-20080815/scan.c	2008-08-16 09:02:01.000000000 +0100
+++ w_scan-20080815_fixautodetection/scan.c	2008-11-06 12:24:40.000000000 +0000
@@ -2579,7 +2579,7 @@
 {
 	char frontend_devname [80];
 	int adapter = 999, frontend = 0, demux = 0;
-	int opt, i;
+	int opt, i, j;
 	int frontend_fd;
 	int fe_open_mode;
 	int frontend_type = FE_OFDM;
@@ -2716,18 +2716,19 @@
 		info("Info: using DVB adapter auto detection.\n");
 		fe_open_mode = O_RDWR | O_NONBLOCK;
 		for (i=0; i < 4; i++) {
-		  snprintf (frontend_devname, sizeof(frontend_devname),  		"/dev/dvb/adapter%i/frontend0", i);
-		  if ((frontend_fd = open (frontend_devname, fe_open_mode)) < 0) {
+		  for (j=0; j < 4; j++) {
+		    snprintf (frontend_devname, sizeof(frontend_devname), "/dev/dvb/adapter%i/frontend%i", i, j);
+		    if ((frontend_fd = open (frontend_devname, fe_open_mode)) < 0) {
 		  	info("Info: unable to open frontend %s'\n", frontend_devname);
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
@@ -2736,9 +2737,11 @@
 			  info("   Found DVB-C frontend. Using adapter %s\n",frontend_devname);                     
 			close (frontend_fd);
 			adapter=i;
+			frontend=j;
 			break;
-			} 		
+			}
 
+		  }
 		}
 	}
 	snprintf (frontend_devname, sizeof(frontend_devname),

--========GMX16841225975650563989
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--========GMX16841225975650563989--
