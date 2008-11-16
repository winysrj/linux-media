Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ug-out-1314.google.com ([66.249.92.171])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <devin.heitmueller@gmail.com>) id 1L1Vl1-0001FQ-HV
	for linux-dvb@linuxtv.org; Sun, 16 Nov 2008 01:44:56 +0100
Received: by ug-out-1314.google.com with SMTP id x30so162392ugc.16
	for <linux-dvb@linuxtv.org>; Sat, 15 Nov 2008 16:44:52 -0800 (PST)
Message-ID: <412bdbff0811151644t428cc7d0nce5039dafe278f16@mail.gmail.com>
Date: Sat, 15 Nov 2008 19:44:52 -0500
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: Linux-dvb <linux-dvb@linuxtv.org>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_11032_16171258.1226796292100"
Subject: [linux-dvb] [PATCH] Make sure the i2c gate is open before powering
	down tuner
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

------=_Part_11032_16171258.1226796292100
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

The following patch addresses an condition where the dvb_frontend
attempts to power down the tuner, but there is no guarantee that the
gate is open at that phase (in fact, in a properly written demod it
should have been closed at this phase).

Tested on the HVR-950Q.

Regards,

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

------=_Part_11032_16171258.1226796292100
Content-Type: text/x-diff; name=tuner_sleep_i2cgate.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fnkyt6xj0
Content-Disposition: attachment; filename=tuner_sleep_i2cgate.patch

T3BlbiB0aGUgaTJjIGdhdGUgYmVmb3JlIGlzc3VpbmcgYXR0ZW1wdGluZyB0byBwdXQgdGhlIHR1
bmVyIHRvIHNsZWVwCgpGcm9tOiBEZXZpbiBIZWl0bXVlbGxlciA8ZGV2aW4uaGVpdG11ZWxsZXJA
Z21haWwuY29tPgoKSXQgaXMgbm90IHNhZmUgdG8gYXNzdW1lIHRoYXQgdGhlIGkyYyBnYXRlIHdp
bGwgYmUgb3BlbiBiZWZvcmUgaXNzdWluZyB0aGUKY29tbWFuZCB0byBwb3dlciBkb3duIHRoZSB0
dW5lci4gIEluIGZhY3QsIG1hbnkgZGVtb2RzIG9ubHkgb3BlbiB0aGUgZ2F0ZQpsb25nIGVub3Vn
aCB0byBpc3N1ZSB0aGUgdHVuaW5nIGNvbW1hbmQuCgpUaGlzIGZpeCBhbGxvd3MgcG93ZXIgbWFu
YWdlbWVudCB0byB3b3JrIHByb3Blcmx5IGZvciB0aG9zZSB0dW5lcnMgYmVoaW5kIGFuCmkyYyBn
YXRlIChpbiBteSBjYXNlIHRoZSBwcm9ibGVtIHdhcyB3aXRoIHRoZSBIVlItOTUwUSkKClNpZ25l
ZC1vZmYtYnk6IERldmluIEhlaXRtdWVsbGVyIDxkZXZpbi5oZWl0bXVlbGxlckBnbWFpbC5jb20+
CkluZGV4OiB2NGwtZHZiL2xpbnV4L2RyaXZlcnMvbWVkaWEvZHZiL2R2Yi1jb3JlL2R2Yl9mcm9u
dGVuZC5jCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT0KLS0tIHY0bC1kdmIub3JpZy9saW51eC9kcml2ZXJzL21lZGlhL2R2
Yi9kdmItY29yZS9kdmJfZnJvbnRlbmQuYwkyMDA4LTExLTE1IDE5OjM3OjE1LjAwMDAwMDAwMCAt
MDUwMAorKysgdjRsLWR2Yi9saW51eC9kcml2ZXJzL21lZGlhL2R2Yi9kdmItY29yZS9kdmJfZnJv
bnRlbmQuYwkyMDA4LTExLTE1IDE5OjM3OjUxLjAwMDAwMDAwMCAtMDUwMApAQCAtNjU2LDYgKzY1
Niw4IEBACiAJCWlmIChmZS0+b3BzLnNldF92b2x0YWdlKQogCQkJZmUtPm9wcy5zZXRfdm9sdGFn
ZShmZSwgU0VDX1ZPTFRBR0VfT0ZGKTsKIAkJaWYgKGZlLT5vcHMudHVuZXJfb3BzLnNsZWVwKSB7
CisJCQlpZiAoZmUtPm9wcy5pMmNfZ2F0ZV9jdHJsKQorCQkJCWZlLT5vcHMuaTJjX2dhdGVfY3Ry
bChmZSwgMSk7CiAJCQlmZS0+b3BzLnR1bmVyX29wcy5zbGVlcChmZSk7CiAJCQlpZiAoZmUtPm9w
cy5pMmNfZ2F0ZV9jdHJsKQogCQkJCWZlLT5vcHMuaTJjX2dhdGVfY3RybChmZSwgMCk7Cg==
------=_Part_11032_16171258.1226796292100
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
------=_Part_11032_16171258.1226796292100--
