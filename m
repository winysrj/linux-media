Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mailhost.okg-computer.de ([85.131.254.125])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <linux-dvb@okg-computer.de>) id 1JiRwq-0008Qd-LU
	for linux-dvb@linuxtv.org; Sun, 06 Apr 2008 12:18:15 +0200
Received: from [10.10.43.100] (e180064023.adsl.alicedsl.de [85.180.64.23])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mailhost.okg-computer.de (Postfix) with ESMTP id 26F08441F3
	for <linux-dvb@linuxtv.org>; Sun,  6 Apr 2008 12:17:53 +0200 (CEST)
Message-ID: <47F8A350.2020201@okg-computer.de>
Date: Sun, 06 Apr 2008 12:17:52 +0200
From: =?ISO-8859-1?Q?Jens_Krehbiel-Gr=E4ther?=
 <linux-dvb@okg-computer.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <3efb10970804051435y335c7af0xf5c0438988aaa325@mail.gmail.com>
In-Reply-To: <3efb10970804051435y335c7af0xf5c0438988aaa325@mail.gmail.com>
Content-Type: multipart/mixed; boundary="------------070001090706000100090108"
Subject: Re: [linux-dvb] scan does not work on latest multiproto drivers
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
--------------070001090706000100090108
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Remy Bohmer schrieb:
> Hello,
>
> I hope anybody can tell me what I do wrong here.
>
> I have a TT-3200 DVB-S2 board, and I am trying to get it up and
> running while using the latest multiproto drivers.
>
> I pulled the sources from "http://jusst.de/hg/multiproto", They
> compile properly against 2.6.24.4 (fedora 8), and seem to load
> properly, because the board is properly recognized.
>
> Then I pulled the dvb-apps tools from
> "http://linuxtv.org/hg/dvb-apps", and compiled towards the headers of
> the multiproto drivers.
> These compile properly but does not work when I start "./scan -v
> dvb-s/Astra-19.2E > ./my-channels.conf", I get this error:
> "stb0899_search: Unsupported delivery system" in dmesg
>
> Then I tried the sources from: "http://jusst.de/manu/scan.tar.bz2".
> These sources do not compile against the latest multiproto, I get these errors:
> scan.c: In function 'tune_to_transponder':
> scan.c:1682: error: 'struct dvbfe_info' has no member named 'delivery'
> scan.c:1684: error: 'struct dvbfe_info' has no member named 'delivery'
> scan.c:1693: error: 'struct dvbfe_info' has no member named 'delivery'
> scan.c:1704: error: 'struct dvbfe_info' has no member named 'delivery'
>
> So, I must be doing something wrong, but I have no idea what is wrong.
>
> Does anybody have some ideas/suggestions?
>   


That's because of the new API (v3.3) in current hg-tree.

Download

http://jusst.de/manu/scan.tar.bz2

and apply the attached patch on it. Then it should work.
You must also patch the szap-utility with the patch of Jlac, postet a 
few days ago (I attached it to this mail, too).

Jens

--------------070001090706000100090108
Content-Type: text/plain;
 name="scan-multiproto-3.3.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scan-multiproto-3.3.patch"

diff -Naur 1/scan.c 2/scan.c
--- 1/scan.c	2008-04-03 02:00:19.000000000 +0200
+++ 2/scan.c	2008-04-03 12:29:32.000000000 +0200
@@ -1674,15 +1674,18 @@
 	}
 
         struct dvbfe_info fe_info1;
+	enum dvbfe_delsys delivery;
 
         // a temporary hack, need to clean
         memset(&fe_info1, 0, sizeof (struct dvbfe_info));
             
         if(t->modulation_system == 0)
-            fe_info1.delivery = DVBFE_DELSYS_DVBS;
+            delivery = DVBFE_DELSYS_DVBS;
         else if(t->modulation_system == 1)
-            fe_info1.delivery = DVBFE_DELSYS_DVBS2;
-            
+            delivery = DVBFE_DELSYS_DVBS2;
+
+        ioctl(frontend_fd, DVBFE_SET_DELSYS, &delivery); //switch system 
+
         int result = ioctl(frontend_fd, DVBFE_GET_INFO, &fe_info1);
         if (result < 0) {
             perror("ioctl DVBFE_GET_INFO failed");
@@ -1690,7 +1693,7 @@
             return -1;
         }
         
-        switch (fe_info1.delivery) {
+        switch (delivery) {
             case DVBFE_DELSYS_DVBS:
                 info("----------------------------------> Using '%s' DVB-S\n", fe_info.name);
                 break;
@@ -1701,7 +1704,7 @@
                 info("----------------------------------> Using '%s' DVB-S2\n", fe_info.name);
                 break;
             default:
-                info("Unsupported Delivery system (%d)!\n", fe_info1.delivery);
+                info("Unsupported Delivery system (%d)!\n", delivery);
                 t->last_tuning_failed = 1;
                 return -1;
         }

--------------070001090706000100090108
Content-Type: text/x-patch;
 name="szap-multiproto-apiv33.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="szap-multiproto-apiv33.diff"

--- org/szap.c	2008-04-02 20:47:05.000000000 +0200
+++ new/szap.c	2008-04-02 20:46:30.000000000 +0200
@@ -351,6 +351,7 @@
 	uint32_t ifreq;
 	int hiband, result;
 	struct dvbfe_info fe_info;
+	enum dvbfe_delsys delivery;
 
 	// a temporary hack, need to clean
 	memset(&fe_info, 0, sizeof (&fe_info));
@@ -365,15 +366,15 @@
 	switch (delsys) {
 	case DVBS:
 		printf("Querying info .. Delivery system=DVB-S\n");
-		fe_info.delivery = DVBFE_DELSYS_DVBS;	
+		delivery = DVBFE_DELSYS_DVBS;
 		break;
 	case DSS:
 		printf("Querying info .. Delivery system=DSS\n");
-		fe_info.delivery = DVBFE_DELSYS_DSS;
+		delivery = DVBFE_DELSYS_DSS;
 		break;
 	case DVBS2:
 		printf("Querying info .. Delivery system=DVB-S2\n");
-		fe_info.delivery = DVBFE_DELSYS_DVBS2;
+		delivery = DVBFE_DELSYS_DVBS2;
 		break;
 	default:
 		printf("Unsupported delivery system\n");
@@ -391,6 +392,8 @@
 			return FALSE;
 		}
 
+		ioctl(fefd, DVBFE_SET_DELSYS, &delivery); //switch system
+
 		result = ioctl(fefd, DVBFE_GET_INFO, &fe_info);
 		if (result < 0) {
 			perror("ioctl DVBFE_GET_INFO failed");
@@ -398,7 +401,7 @@
 			return FALSE;
 		}
 		
-		switch (fe_info.delivery) {
+		switch (delivery) {
 		case DVBFE_DELSYS_DVBS:
 			printf("----------------------------------> Using '%s' DVB-S", fe_info.name);
 			break;
@@ -409,7 +412,7 @@
 			printf("----------------------------------> Using '%s' DVB-S2", fe_info.name);
 			break;
 		default:
-			printf("Unsupported Delivery system (%d)!\n", fe_info.delivery);
+			printf("Unsupported Delivery system (%d)!\n", delivery);
 			close(fefd);
 			return FALSE;
 		}

--------------070001090706000100090108
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------070001090706000100090108--
