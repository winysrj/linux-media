Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nf-out-0910.google.com ([64.233.182.185])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <devin.heitmueller@gmail.com>) id 1L1YUM-0006r0-5f
	for linux-dvb@linuxtv.org; Sun, 16 Nov 2008 04:39:56 +0100
Received: by nf-out-0910.google.com with SMTP id g13so1056691nfb.11
	for <linux-dvb@linuxtv.org>; Sat, 15 Nov 2008 19:39:50 -0800 (PST)
Message-ID: <412bdbff0811151939n38cffce9q54848896e668bc6e@mail.gmail.com>
Date: Sat, 15 Nov 2008 22:39:50 -0500
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: Linux-dvb <linux-dvb@linuxtv.org>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_11451_6053486.1226806790805"
Subject: [linux-dvb] [PATCH] Put s5h1411 into low power mode at end of
	attach() call
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

------=_Part_11451_6053486.1226806790805
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

The following patch puts the s5h1411 into low power mode until first
use.  This means that the device won't be sucking an extra 44ma on the
USB port from the time the user plugs in the tuner until he/she
decides to watch some television.

Tested on the Pinnacle 801e.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

------=_Part_11451_6053486.1226806790805
Content-Type: text/x-diff; name=s5h1411_attach_powerdown.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fnl51qa70
Content-Disposition: attachment; filename=s5h1411_attach_powerdown.patch

UGxhY2UgczVoMTQxMSBpbnRvIGxvdyBwb3dlciBtb2RlIGF0IGVuZCBvZiBhdHRhY2ggcm91dGlu
ZSgpCgpGcm9tOiBEZXZpbiBIZWl0bXVlbGxlciA8ZGV2aW4uaGVpdG11ZWxsZXJAZ21haWwuY29t
PgoKUGxhY2UgdGhlIHM1aDE0MTEgaW50byBsb3cgcG93ZXIgbW9kZSB1bnRpbCBmaXJzdCB1c2Ug
KHRvIGhhbmRsZSB0aGUgY2FzZSB3aGVyZQp0aGUgdXNlciBwbHVncyBpbiB0aGUgZGV2aWNlIGFu
ZCB0aGVuIGRvZXNuJ3QgdXNlIGl0IGZvciBhIHdoaWxlKS4gIE9uIHRoZQpQaW5uYWNsZSA4MDFl
LCB0aGlzIGJyaW5ncyB0aGUgcG93ZXIgdXNhZ2UgZnJvbSAxMjZtYSBkb3duIHRvIDgybWEuCgpT
aWduZWQtb2ZmLWJ5OiBEZXZpbiBIZWl0bXVlbGxlciA8ZGV2aW4uaGVpdG11ZWxsZXJAZ21haWwu
Y29tPgpJbmRleDogdjRsLWR2Yi9saW51eC9kcml2ZXJzL21lZGlhL2R2Yi9mcm9udGVuZHMvczVo
MTQxMS5jCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT0KLS0tIHY0bC1kdmIub3JpZy9saW51eC9kcml2ZXJzL21lZGlhL2R2
Yi9mcm9udGVuZHMvczVoMTQxMS5jCTIwMDgtMTEtMTUgMjI6MzM6MDAuMDAwMDAwMDAwIC0wNTAw
CisrKyB2NGwtZHZiL2xpbnV4L2RyaXZlcnMvbWVkaWEvZHZiL2Zyb250ZW5kcy9zNWgxNDExLmMJ
MjAwOC0xMS0xNSAyMjozNDoxMC4wMDAwMDAwMDAgLTA1MDAKQEAgLTg3NCw2ICs4NzQsOSBAQAog
CS8qIE5vdGU6IExlYXZpbmcgdGhlIEkyQyBnYXRlIG9wZW4gaGVyZS4gKi8KIAlzNWgxNDExX3dy
aXRlcmVnKHN0YXRlLCBTNUgxNDExX0kyQ19UT1BfQUREUiwgMHhmNSwgMSk7CiAKKwkvKiBQdXQg
dGhlIGRldmljZSBpbnRvIGxvdy1wb3dlciBtb2RlIHVudGlsIGZpcnN0IHVzZSAqLworCXM1aDE0
MTFfc2V0X3Bvd2Vyc3RhdGUoJnN0YXRlLT5mcm9udGVuZCwgMSk7CisKIAlyZXR1cm4gJnN0YXRl
LT5mcm9udGVuZDsKIAogZXJyb3I6Cg==
------=_Part_11451_6053486.1226806790805
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
------=_Part_11451_6053486.1226806790805--
