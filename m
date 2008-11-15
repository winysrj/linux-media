Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ug-out-1314.google.com ([66.249.92.168])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <devin.heitmueller@gmail.com>) id 1L1Oko-0003bT-Om
	for linux-dvb@linuxtv.org; Sat, 15 Nov 2008 18:16:15 +0100
Received: by ug-out-1314.google.com with SMTP id x30so116929ugc.16
	for <linux-dvb@linuxtv.org>; Sat, 15 Nov 2008 09:16:11 -0800 (PST)
Message-ID: <412bdbff0811150916k4beb2bddo7542aad77597a665@mail.gmail.com>
Date: Sat, 15 Nov 2008 12:16:11 -0500
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: Linux-dvb <linux-dvb@linuxtv.org>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_9202_10271448.1226769371161"
Subject: [linux-dvb] [PATCH] make em28xx aux audio input work
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

------=_Part_9202_10271448.1226769371161
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

The attached patch makes the em28xx auxillary audio input work.
Tested with the HVR-950.

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

------=_Part_9202_10271448.1226769371161
Content-Type: text/x-diff; name=em28xx_auxaudio_in_fix.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fnkir4000
Content-Disposition: attachment; filename=em28xx_auxaudio_in_fix.patch

ZW0yOHh4OiBtYWtlIGF1eGlsbGFyeSBhdWRpbyBpbnB1dCB3b3JrCgpGcm9tOiBEZXZpbiBIZWl0
bXVlbGxlciA8ZGV2aW4uaGVpdG11ZWxsZXJAZ21haWwuY29tPgoKVGhlIHR1bmVyIGF1ZGlvIGlu
cHV0IHdhcyB3b3JraW5nIGJ1dCB0aGUgYXV4IGlucHV0IHdhc24ndC4gIFRlc3RlZCB3aXRoCnRo
ZSBIVlItOTUwLgoKU2lnbmVkLW9mZi1ieTogRGV2aW4gSGVpdG11ZWxsZXIgPGRldmluLmhlaXRt
dWVsbGVyQGdtYWlsLmNvbT4KSW5kZXg6IHY0bC1kdmIvbGludXgvZHJpdmVycy9tZWRpYS92aWRl
by9lbTI4eHgvZW0yOHh4LWNvcmUuYwo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09Ci0tLSB2NGwtZHZiLm9yaWcvbGludXgv
ZHJpdmVycy9tZWRpYS92aWRlby9lbTI4eHgvZW0yOHh4LWNvcmUuYwkyMDA4LTExLTE1IDExOjU4
OjI1LjAwMDAwMDAwMCAtMDUwMAorKysgdjRsLWR2Yi9saW51eC9kcml2ZXJzL21lZGlhL3ZpZGVv
L2VtMjh4eC9lbTI4eHgtY29yZS5jCTIwMDgtMTEtMTUgMTE6NTg6NDUuMDAwMDAwMDAwIC0wNTAw
CkBAIC0yNzAsNiArMjcwLDggQEAKIAkJCWJyZWFrOwogCQljYXNlIEVNMjhYWF9BTVVYX0xJTkVf
SU46CiAJCQlpbnB1dCA9IEVNMjhYWF9BVURJT19TUkNfTElORTsKKwkJCXZpZGVvID0gZGlzYWJs
ZTsKKwkJCWxpbmUgID0gZW5hYmxlOwogCQkJYnJlYWs7CiAJCWNhc2UgRU0yOFhYX0FNVVhfQUM5
N19WSURFTzoKIAkJCWlucHV0ID0gRU0yOFhYX0FVRElPX1NSQ19MSU5FOwo=
------=_Part_9202_10271448.1226769371161
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
------=_Part_9202_10271448.1226769371161--
