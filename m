Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:36559 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756443AbZLCPbe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Dec 2009 10:31:34 -0500
Received: by bwz27 with SMTP id 27so1190528bwz.21
        for <linux-media@vger.kernel.org>; Thu, 03 Dec 2009 07:31:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <751357790912030639l6ddcb4bar486fdea6b9aa1a8e@mail.gmail.com>
References: <751357790912030639l6ddcb4bar486fdea6b9aa1a8e@mail.gmail.com>
Date: Thu, 3 Dec 2009 15:31:39 +0000
Message-ID: <751357790912030731g5b09bac8w322f4c1754c3d87d@mail.gmail.com>
Subject: Fwd: DVB-APPS patch for uk-WinterHill
From: Justin Hornsby <justin0hornsby@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: multipart/mixed; boundary=00032555999e004b010479d4b0c6
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--00032555999e004b010479d4b0c6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Since 02 Dec 2009 the UK WinterHill transmitter site has been
broadcasting on different frequencies & in a different mode with
different modulation. =A0Channels have been re-arranged to occupy five
multiplexes and the original BBC 'B' mux is now broadcasting DVB-T2
for high definition services (which of course cannot yet be tuned by
mere mortals). The 'WinterHill B' transmitter stopped broadcasting on
02 Dec.

The attached file is a patch to reflect these changes.

NOTE: All UK DVB-T services will eventually be moving to 8k mode in
64QAM & other local frequencies will be changing once DSO (digital
switch over) is complete in each area.

Hope this info is of use to you folks :-)

Regards,
Justin

uk-WinterHill.patch

--- uk-WinterHill =A0 =A0 =A0 2009-12-03 14:30:32.000000000 +0000
+++ uk-WinterHill.new =A0 2009-12-03 14:26:05.000000000 +0000
@@ -1,13 +1,11 @@
=A0# UK, Winter Hill
-# Auto-generated from http://www.dtg.org.uk/retailer/dtt_channels.html
-# and http://www.ofcom.org.uk/static/reception_advice/index.asp.html
+# Populated by J. Hornsby from a scan of active multiplexes
=A0# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
-T 754167000 8MHz 3/4 NONE QAM16 2k 1/32 NONE
-T 834167000 8MHz 2/3 NONE QAM64 2k 1/32 NONE
-T 850167000 8MHz 2/3 NONE QAM64 2k 1/32 NONE
-T 842167000 8MHz 3/4 NONE QAM16 2k 1/32 NONE
-T 786167000 8MHz 3/4 NONE QAM16 2k 1/32 NONE
-T 810167000 8MHz 3/4 NONE QAM16 2k 1/32 NONE
-# UK, Winter Hill B
-T 650000000 8MHz 3/4 NONE QAM16 2k 1/32 NONE
-T 626000000 8MHz 3/4 NONE QAM16 2k 1/32 NONE
+T 746000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
+T 770000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
+T 778000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
+T 794000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
+T 801833000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
+
+# UK, Winter Hill B Ceased broadcasting on 02 December 2009
+

--00032555999e004b010479d4b0c6
Content-Type: text/x-patch; charset=US-ASCII; name="uk-WinterHill.patch"
Content-Disposition: attachment; filename="uk-WinterHill.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g2rmq0vb0

LS0tIHVrLVdpbnRlckhpbGwJMjAwOS0xMi0wMyAxNDozMDozMi4wMDAwMDAwMDAgKzAwMDAKKysr
IHVrLVdpbnRlckhpbGwubmV3CTIwMDktMTItMDMgMTQ6MjY6MDUuMDAwMDAwMDAwICswMDAwCkBA
IC0xLDEzICsxLDExIEBACiAjIFVLLCBXaW50ZXIgSGlsbAotIyBBdXRvLWdlbmVyYXRlZCBmcm9t
IGh0dHA6Ly93d3cuZHRnLm9yZy51ay9yZXRhaWxlci9kdHRfY2hhbm5lbHMuaHRtbAotIyBhbmQg
aHR0cDovL3d3dy5vZmNvbS5vcmcudWsvc3RhdGljL3JlY2VwdGlvbl9hZHZpY2UvaW5kZXguYXNw
Lmh0bWwKKyMgUG9wdWxhdGVkIGJ5IEouIEhvcm5zYnkgZnJvbSBhIHNjYW4gb2YgYWN0aXZlIG11
bHRpcGxleGVzCiAjIFQgZnJlcSBidyBmZWNfaGkgZmVjX2xvIG1vZCB0cmFuc21pc3Npb24tbW9k
ZSBndWFyZC1pbnRlcnZhbCBoaWVyYXJjaHkKLVQgNzU0MTY3MDAwIDhNSHogMy80IE5PTkUgUUFN
MTYgMmsgMS8zMiBOT05FCi1UIDgzNDE2NzAwMCA4TUh6IDIvMyBOT05FIFFBTTY0IDJrIDEvMzIg
Tk9ORQotVCA4NTAxNjcwMDAgOE1IeiAyLzMgTk9ORSBRQU02NCAyayAxLzMyIE5PTkUKLVQgODQy
MTY3MDAwIDhNSHogMy80IE5PTkUgUUFNMTYgMmsgMS8zMiBOT05FCi1UIDc4NjE2NzAwMCA4TUh6
IDMvNCBOT05FIFFBTTE2IDJrIDEvMzIgTk9ORQotVCA4MTAxNjcwMDAgOE1IeiAzLzQgTk9ORSBR
QU0xNiAyayAxLzMyIE5PTkUKLSMgVUssIFdpbnRlciBIaWxsIEIKLVQgNjUwMDAwMDAwIDhNSHog
My80IE5PTkUgUUFNMTYgMmsgMS8zMiBOT05FCi1UIDYyNjAwMDAwMCA4TUh6IDMvNCBOT05FIFFB
TTE2IDJrIDEvMzIgTk9ORQorVCA3NDYwMDAwMDAgOE1IeiAyLzMgTk9ORSBRQU02NCA4ayAxLzMy
IE5PTkUKK1QgNzcwMDAwMDAwIDhNSHogMi8zIE5PTkUgUUFNNjQgOGsgMS8zMiBOT05FCitUIDc3
ODAwMDAwMCA4TUh6IDIvMyBOT05FIFFBTTY0IDhrIDEvMzIgTk9ORQorVCA3OTQwMDAwMDAgOE1I
eiAyLzMgTk9ORSBRQU02NCA4ayAxLzMyIE5PTkUKK1QgODAxODMzMDAwIDhNSHogMi8zIE5PTkUg
UUFNNjQgOGsgMS8zMiBOT05FCisKKyMgVUssIFdpbnRlciBIaWxsIEIgQ2Vhc2VkIGJyb2FkY2Fz
dGluZyBvbiAwMiBEZWNlbWJlciAyMDA5CisK
--00032555999e004b010479d4b0c6--
