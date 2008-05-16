Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mailhost.okg-computer.de ([85.131.254.125])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <linux-dvb@okg-computer.de>) id 1JwtSl-0002jy-JL
	for linux-dvb@linuxtv.org; Fri, 16 May 2008 08:30:44 +0200
Received: from [10.10.42.2] (unknown [85.180.64.0])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mailhost.okg-computer.de (Postfix) with ESMTP id 7847287C1E
	for <linux-dvb@linuxtv.org>; Fri, 16 May 2008 08:30:38 +0200 (CEST)
Message-ID: <482D2A0E.1030307@okg-computer.de>
Date: Fri, 16 May 2008 08:30:38 +0200
From: =?ISO-8859-1?Q?Jens_Krehbiel-Gr=E4ther?=
 <linux-dvb@okg-computer.de>
MIME-Version: 1.0
To: linux-dvb <linux-dvb@linuxtv.org>
References: <482D1AB7.3070101@kipdola.com>
	<E1Jwsxt-000E0b-00.goga777-bk-ru@f151.mail.ru>
In-Reply-To: <E1Jwsxt-000E0b-00.goga777-bk-ru@f151.mail.ru>
Content-Type: multipart/mixed; boundary="------------020507020606040008080404"
Subject: Re: [linux-dvb] Technotrend S2-3200 Scanning
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
--------------020507020606040008080404
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Igor schrieb:
>> I've tried using a version from the repository, dvb-utils 1.1.1-3
>>
>> I also tried to compile the originals from the source tree, unpatched, 
>> http://linuxtv.org/hg/dvb-apps
>>     
>
> yes, you have to use szap2 in the TEST directory  with the latest multiproto
> http://linuxtv.org/hg/dvb-apps/file/31a6dd437b9a/test/szap2.c
>
>   
>> I tried to patch "scan" with this scan source: 
>> http://jusst.de/manu/scan.tar.bz2
>>
>> And I tried to patch szap with this file:  
>> http://abraham.manu.googlepages.com/szap.c
>>     
>
> imho, this versions are not actually. 
> It seems to me there's not any working scan's version for currently multiproto.
>   


I postet a patch a few weeks ago (here again).
These szap and scan patches prepare the apps for actual multiproto (well 
for multiproto a few weeks ago, if the api hasn't changed again, these 
should work).

you have to patch the szap and scan from this sources:

http://abraham.manu.googlepages.com/szap.c
http://abraham.manu.googlepages.com/szap.c


Jens

--------------020507020606040008080404
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

--------------020507020606040008080404
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

--------------020507020606040008080404
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------020507020606040008080404--
