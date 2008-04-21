Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from 78.218.95.91.static.ter-s.siw.siwnet.net ([91.95.218.78]
	helo=gw) by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <magnus@alefors.se>) id 1Jo1JX-0005uT-3e
	for linux-dvb@linuxtv.org; Mon, 21 Apr 2008 21:04:35 +0200
Received: from [192.168.0.10] (aria.alefors.se [192.168.0.10])
	by gw (Postfix) with ESMTP id CFD9B1586E
	for <linux-dvb@linuxtv.org>; Mon, 21 Apr 2008 20:40:09 +0200 (CEST)
Message-ID: <480CDF89.8010602@alefors.se>
Date: Mon, 21 Apr 2008 20:40:09 +0200
From: =?UTF-8?B?TWFnbnVzIEjDtnJsaW4=?= <magnus@alefors.se>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Content-Type: multipart/mixed; boundary="------------080201040502030806030801"
Subject: [linux-dvb] Patch to support VP-2040
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
--------------080201040502030806030801
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi. This patch adds support for Azurewave AD-CP400 (Mantis VP-2040).
/Magnus H

--------------080201040502030806030801
Content-Type: text/x-patch;
 name="mantis-vp2040.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="mantis-vp2040.diff"

diff -Nru mantis-b7b8a2a81f3e/linux/drivers/media/dvb/mantis/mantis_core.c mantis-new/linux/drivers/media/dvb/mantis/mantis_core.c
--- mantis-b7b8a2a81f3e/linux/drivers/media/dvb/mantis/mantis_core.c	2008-04-16 13:22:16.000000000 +0200
+++ mantis-new/linux/drivers/media/dvb/mantis/mantis_core.c	2008-04-21 11:45:18.000000000 +0200
@@ -119,6 +119,7 @@
 	case MANTIS_VP_2033_DVB_C:	// VP-2033
 		mantis->hwconfig = &vp2033_mantis_config;
 		break;
+	case MANTIS_VP_2040_DVB_C:	// VP-2040
 	case TERRATEC_CINERGY_C_PCI:	// VP-2040 clone
 		mantis->hwconfig = &vp2040_mantis_config;
 		break;
diff -Nru mantis-b7b8a2a81f3e/linux/drivers/media/dvb/mantis/mantis_dvb.c mantis-new/linux/drivers/media/dvb/mantis/mantis_dvb.c
--- mantis-b7b8a2a81f3e/linux/drivers/media/dvb/mantis/mantis_dvb.c	2008-04-16 13:22:16.000000000 +0200
+++ mantis-new/linux/drivers/media/dvb/mantis/mantis_dvb.c	2008-04-21 11:46:37.000000000 +0200
@@ -273,6 +273,7 @@
 
 		}
 		break;
+	case MANTIS_VP_2040_DVB_C:	// VP-2040
 	case TERRATEC_CINERGY_C_PCI:
 		dprintk(verbose, MANTIS_ERROR, 1, "Probing for CU1216 (DVB-C)");
 		mantis->fe = tda10023_attach(&tda10023_cu1216_config, &mantis->adapter, read_pwm(mantis));
diff -Nru mantis-b7b8a2a81f3e/linux/drivers/media/dvb/mantis/mantis_vp2040.h mantis-new/linux/drivers/media/dvb/mantis/mantis_vp2040.h
--- mantis-b7b8a2a81f3e/linux/drivers/media/dvb/mantis/mantis_vp2040.h	2008-04-21 11:56:49.000000000 +0200
+++ mantis-new/linux/drivers/media/dvb/mantis/mantis_vp2040.h	2008-04-21 12:29:28.000000000 +0200
@@ -25,6 +25,7 @@
 #include "mantis_common.h"
 #include "tda1002x.h"
 
+#define MANTIS_VP_2040_DVB_C    0x0043
 #define TERRATEC_CINERGY_C_PCI	0x1178
 
 extern struct tda1002x_config tda10023_cu1216_config;

--------------080201040502030806030801
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------080201040502030806030801--
