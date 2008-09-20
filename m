Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.kapsi.fi ([217.30.184.167] ident=Debian-exim)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1Kh6Jk-00083V-Py
	for linux-dvb@linuxtv.org; Sat, 20 Sep 2008 19:32:25 +0200
Message-ID: <48D533A4.5060406@iki.fi>
Date: Sat, 20 Sep 2008 20:32:20 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Christoph Pfister <christophpfister@gmail.com>
References: <4836F51E.7070403@iki.fi>	<200806111910.06038.christophpfister@gmail.com>	<488F2684.2030809@iki.fi>
	<200808011115.38550.christophpfister@gmail.com>
In-Reply-To: <200808011115.38550.christophpfister@gmail.com>
Content-Type: multipart/mixed; boundary="------------090306080304020500060006"
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] update Finland initial DVB-T tuning files
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
--------------090306080304020500060006
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

hello,
updating DVB-T fi-* initial tuning files again!

regards
Antti
-- 
http://palosaari.fi/

--------------090306080304020500060006
Content-Type: text/plain;
 name="fi-update_2008-09-20.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="fi-update_2008-09-20.patch"

diff -r 07e6a86c9eba util/scan/dvb-t/fi-Salla_Ihistysjanka
--- a/util/scan/dvb-t/fi-Salla_Ihistysjanka	Sun Sep 14 18:03:01 2008 +0200
+++ b/util/scan/dvb-t/fi-Salla_Ihistysjanka	Sat Sep 20 20:29:48 2008 +0300
@@ -1,4 +1,4 @@
 # automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
-T 610000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 602000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 674000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 07e6a86c9eba util/scan/dvb-t/fi-Salla_Saija
--- a/util/scan/dvb-t/fi-Salla_Saija	Sun Sep 14 18:03:01 2008 +0200
+++ b/util/scan/dvb-t/fi-Salla_Saija	Sat Sep 20 20:29:48 2008 +0300
@@ -1,4 +1,4 @@
 # automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 T 514000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 602000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 610000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE

--------------090306080304020500060006
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------090306080304020500060006--
