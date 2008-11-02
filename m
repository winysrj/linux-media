Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from vds2011.yellis.net ([79.170.233.11])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <alexis@via.ecp.fr>) id 1KwhmF-0002Tl-RI
	for linux-dvb@linuxtv.org; Sun, 02 Nov 2008 19:34:20 +0100
Received: from [192.168.0.2] (def92-11-88-170-64-159.fbx.proxad.net
	[88.170.64.159])
	by vds2011.yellis.net (Postfix) with ESMTP id DA3312FA8A2
	for <linux-dvb@linuxtv.org>; Sun,  2 Nov 2008 19:34:15 +0100 (CET)
Message-ID: <490DF2A8.9020603@via.ecp.fr>
Date: Sun, 02 Nov 2008 19:34:16 +0100
From: Alexis de Lattre <alexis@via.ecp.fr>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Content-Type: multipart/mixed; boundary="------------060303010501040903000001"
Subject: [linux-dvb] Fix for fr-Paris scan file
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
--------------060303010501040903000001
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Here is a small fix on the fr-Paris scan file for the new R5 multiplex 
which officially carries the new free-to-air HD channels since Thursday.

-- 
Alexis de Lattre

--------------060303010501040903000001
Content-Type: text/x-diff;
 name="patch-dvb-t-fr_Paris.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch-dvb-t-fr_Paris.diff"

--- util/scan/dvb-t/fr-Paris.old	2008-11-02 19:16:40.000000000 +0100
+++ util/scan/dvb-t/fr-Paris	2008-11-02 19:22:02.000000000 +0100
@@ -11,7 +11,7 @@
 T 538166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
 T 562166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
 T 586166000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
-T 714166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
+T 714166000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
 T 738166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
 T 754166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
 T 762166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE

--------------060303010501040903000001
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------060303010501040903000001--
