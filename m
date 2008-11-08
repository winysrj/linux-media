Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp-2.orange.nl ([193.252.22.242])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <michel@verbraak.org>) id 1Kyot9-0006De-BX
	for linux-dvb@linuxtv.org; Sat, 08 Nov 2008 15:34:13 +0100
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf6103.online.nl (SMTP Server) with ESMTP id 954751C00085
	for <linux-dvb@linuxtv.org>; Sat,  8 Nov 2008 15:33:37 +0100 (CET)
Received: from asterisk.verbraak.thuis (s55939d86.adsl.wanadoo.nl
	[85.147.157.134])
	by mwinf6103.online.nl (SMTP Server) with ESMTP id 681411C00082
	for <linux-dvb@linuxtv.org>; Sat,  8 Nov 2008 15:33:35 +0100 (CET)
Message-ID: <4915A33D.3050504@verbraak.org>
Date: Sat, 08 Nov 2008 15:33:33 +0100
From: Michel Verbraak <michel@verbraak.org>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Content-Type: multipart/mixed; boundary="------------010206090100010406050407"
Subject: [linux-dvb] [PATCH] duplicate define in frontend.h
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
--------------010206090100010406050407
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Found a duplicate define in frontend.h for DTV_API_VERSION

Signed-Off-By: M. Verbraak (michel@verbraak.org)

--------------010206090100010406050407
Content-Type: text/plain;
 name="frontend.h.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="frontend.h.diff"

*** linux/include/linux/dvb/frontend.h.orig	2008-11-08 15:28:29.000000000 +0100
--- linux/include/linux/dvb/frontend.h	2008-11-08 15:29:42.000000000 +0100
*************** struct dvb_frontend_event {
*** 300,306 ****
  #define DTV_ISDB_LAYERC_TIME_INTERLEAVING	34
  #endif
  #define DTV_API_VERSION				35
- #define DTV_API_VERSION				35
  #define DTV_CODE_RATE_HP			36
  #define DTV_CODE_RATE_LP			37
  #define DTV_GUARD_INTERVAL			38
--- 300,305 ----

--------------010206090100010406050407
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------010206090100010406050407--
