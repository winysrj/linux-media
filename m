Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.kapsi.fi ([217.30.184.167] ident=Debian-exim)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1KNq1K-0005xL-9U
	for linux-dvb@linuxtv.org; Tue, 29 Jul 2008 16:17:50 +0200
Message-ID: <488F2684.2030809@iki.fi>
Date: Tue, 29 Jul 2008 17:17:40 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Christoph Pfister <christophpfister@gmail.com>
References: <4836F51E.7070403@iki.fi>	<200805301823.32295.christophpfister@gmail.com>	<484EEC89.3000105@iki.fi>
	<200806111910.06038.christophpfister@gmail.com>
In-Reply-To: <200806111910.06038.christophpfister@gmail.com>
Content-Type: multipart/mixed; boundary="------------080604000109010708050201"
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
--------------080604000109010708050201
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

terve,
It's time to update initial tuning files again :)

regards,
Antti
-- 
http://palosaari.fi/

--------------080604000109010708050201
Content-Type: text/plain;
 name="fi-update_2008-07-29.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="fi-update_2008-07-29.patch"

diff -r 0d255b4e0f09 util/scan/dvb-t/fi-Kuhmoinen
--- a/util/scan/dvb-t/fi-Kuhmoinen	Mon Jul 28 12:42:34 2008 +0200
+++ b/util/scan/dvb-t/fi-Kuhmoinen	Tue Jul 29 17:14:46 2008 +0300
@@ -2,4 +2,4 @@
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 T 594000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 666000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 786000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 754000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 0d255b4e0f09 util/scan/dvb-t/fi-Salo_Isokyla
--- a/util/scan/dvb-t/fi-Salo_Isokyla	Mon Jul 28 12:42:34 2008 +0200
+++ b/util/scan/dvb-t/fi-Salo_Isokyla	Tue Jul 29 17:14:46 2008 +0300
@@ -1,6 +1,6 @@
 # automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
-T 482000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 514000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 666000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 682000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 570000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE

--------------080604000109010708050201
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------080604000109010708050201--
