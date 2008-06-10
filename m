Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.kapsi.fi ([217.30.184.167] ident=Debian-exim)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1K6B1q-0002Qq-8J
	for linux-dvb@linuxtv.org; Tue, 10 Jun 2008 23:05:21 +0200
Message-ID: <484EEC89.3000105@iki.fi>
Date: Wed, 11 Jun 2008 00:05:13 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Christoph Pfister <christophpfister@gmail.com>
References: <4836F51E.7070403@iki.fi> <483AD86C.4030108@iki.fi>
	<200805301823.32295.christophpfister@gmail.com>
In-Reply-To: <200805301823.32295.christophpfister@gmail.com>
Content-Type: multipart/mixed; boundary="------------090208090403070702060703"
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
--------------090208090403070702060703
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

terve Christoph,
Channel lists are updated today and attached patch contains those updates.

Antti

Christoph Pfister wrote:
> Hi Antti,
> 
> [ hmm, took some time till I was able again to process my mails ]
> 
> Am Montag 26 Mai 2008 17:34:04 schrieb Antti Palosaari:
>> hello Christoph,
>> there is new try. Earlier patch didn't remove obsolete files. This one
>> does it. Use that updated patch instead the old one.
> 
> Applied. Thank you very much :)
> 
>> Files removed and the new one:
>> fi-Salla => fi-Salla_Sallatunturi
>> fi-SaloIsokyla => fi-Salo_Isokyla
>> fi-Uusikaupunki_Ruokola => fi-Uusikaupunki_Orivo
>>
>> Antti
> <snip>
> 
> Christoph
> 
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb


-- 
http://palosaari.fi/

--------------090208090403070702060703
Content-Type: text/x-patch;
 name="fi-update_2008-06-10.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="fi-update_2008-06-10.patch"

diff -r 9311c900f746 util/scan/dvb-t/fi-Kustavi_Viherlahti
--- a/util/scan/dvb-t/fi-Kustavi_Viherlahti	Fri May 30 18:16:51 2008 +0200
+++ b/util/scan/dvb-t/fi-Kustavi_Viherlahti	Wed Jun 11 00:01:36 2008 +0300
@@ -1,5 +1,5 @@
 # automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 T 714000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 698000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 738000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 786000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r 9311c900f746 util/scan/dvb-t/fi-Ylitornio_Ainiovaara
--- a/util/scan/dvb-t/fi-Ylitornio_Ainiovaara	Fri May 30 18:16:51 2008 +0200
+++ b/util/scan/dvb-t/fi-Ylitornio_Ainiovaara	Wed Jun 11 00:01:36 2008 +0300
@@ -2,3 +2,4 @@
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 T 546000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 602000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 762000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE

--------------090208090403070702060703
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------090208090403070702060703--
