Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:54220 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797Ab1JIFJz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 Oct 2011 01:09:55 -0400
Received: by qyk30 with SMTP id 30so1605136qyk.19
        for <linux-media@vger.kernel.org>; Sat, 08 Oct 2011 22:09:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CABb1zhvkLYTZ4zUy7jPh1AH+1XGQRdhsHM7CxK5ADMuuzKHAzg@mail.gmail.com>
References: <CABb1zhvkLYTZ4zUy7jPh1AH+1XGQRdhsHM7CxK5ADMuuzKHAzg@mail.gmail.com>
Date: Sun, 9 Oct 2011 07:09:54 +0200
Message-ID: <CABb1zhvUMZ1bSqz1X5qCzOArKYsGG4EHthK-OrbAWRLn+q_+Sg@mail.gmail.com>
Subject: Support for Sveon STV22 (IT9137)
From: =?ISO-8859-1?Q?Leandro_Terr=E9s?= <imlordlt@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: multipart/mixed; boundary=001636d342e653d77404aed6af9f
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--001636d342e653d77404aed6af9f
Content-Type: text/plain; charset=ISO-8859-1

This device identifies has IdProduct 0xe411 and is a clone of KWorld
UB499-2T T09(IT9137).

This patch simply adds support for this device.

--001636d342e653d77404aed6af9f
Content-Type: text/x-patch; charset=US-ASCII; name="sveon-it913x.patch"
Content-Disposition: attachment; filename="sveon-it913x.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gtjkhzso0

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWVkaWEvZHZiL2R2Yi11c2IvZHZiLXVzYi1pZHMuaCBiL2Ry
aXZlcnMvbWVkaWEvZHZiL2R2Yi11c2IvZHZiLXVzYi1pZHMuaAotLS0gYS9kcml2ZXJzL21lZGlh
L2R2Yi9kdmItdXNiL2R2Yi11c2ItaWRzLmgJMjAxMS0wOS0yNCAwNTo0NToxNC4wMDAwMDAwMDAg
KzAyMDAKKysrIGIvZHJpdmVycy9tZWRpYS9kdmIvZHZiLXVzYi9kdmItdXNiLWlkcy5oCTIwMTEt
MTAtMDggMDg6MjM6MTUuNzg5ODgzODc3ICswMjAwCkBAIC0zMjAsNiArMzIwLDcgQEAKICNkZWZp
bmUgVVNCX1BJRF9UVldBWV9QTFVTCQkJCTB4MDAwMgogI2RlZmluZSBVU0JfUElEX1NWRU9OX1NU
VjIwCQkJCTB4ZTM5ZAogI2RlZmluZSBVU0JfUElEX1NWRU9OX1NUVjIyCQkJCTB4ZTQwMQorI2Rl
ZmluZSBVU0JfUElEX1NWRU9OX1NUVjIyX0lUOTEzNyAgICAgCQkweGU0MTEKICNkZWZpbmUgVVNC
X1BJRF9BWlVSRVdBVkVfQVo2MDI3CQkJMHgzMjc1CiAjZGVmaW5lIFVTQl9QSURfVEVSUkFURUNf
RFZCUzJDSV9WMQkJCTB4MTBhNAogI2RlZmluZSBVU0JfUElEX1RFUlJBVEVDX0RWQlMyQ0lfVjIJ
CQkweDEwYWMKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWVkaWEvZHZiL2R2Yi11c2IvaXQ5MTN4LmMg
Yi9kcml2ZXJzL21lZGlhL2R2Yi9kdmItdXNiL2l0OTEzeC5jCi0tLSBhL2RyaXZlcnMvbWVkaWEv
ZHZiL2R2Yi11c2IvaXQ5MTN4LmMJMjAxMS0wOS0yNCAwNTo0NToxNC4wMDAwMDAwMDAgKzAyMDAK
KysrIGIvZHJpdmVycy9tZWRpYS9kdmIvZHZiLXVzYi9pdDkxM3guYwkyMDExLTEwLTA4IDA4OjMy
OjAwLjM4ODE5MTk4NiArMDIwMApAQCAtNTMzLDYgKzUzMyw3IEBACiAKIHN0YXRpYyBzdHJ1Y3Qg
dXNiX2RldmljZV9pZCBpdDkxM3hfdGFibGVbXSA9IHsKIAl7IFVTQl9ERVZJQ0UoVVNCX1ZJRF9L
V09STERfMiwgVVNCX1BJRF9LV09STERfVUI0OTlfMlRfVDA5KSB9LAorCXsgVVNCX0RFVklDRShV
U0JfVklEX0tXT1JMRF8yLCBVU0JfUElEX1NWRU9OX1NUVjIyX0lUOTEzNykgfSwKIAl7fQkJLyog
VGVybWluYXRpbmcgZW50cnkgKi8KIH07CiAKQEAgLTYwOCwxMSArNjA5LDE0IEBACiAJCS5yY19j
b2Rlcwk9IFJDX01BUF9LV09STERfMzE1VSwKIAl9LAogCS5pMmNfYWxnbyAgICAgICAgID0gJml0
OTEzeF9pMmNfYWxnbywKLQkubnVtX2RldmljZV9kZXNjcyA9IDEsCisJLm51bV9kZXZpY2VfZGVz
Y3MgPSAyLAogCS5kZXZpY2VzID0gewogCQl7ICAgIkt3b3JsZCBVQjQ5OS0yVCBUMDkoSVQ5MTM3
KSIsCiAJCQl7ICZpdDkxM3hfdGFibGVbMF0sIE5VTEwgfSwKIAkJCX0sCisJCXsgICAiU3Zlb24g
U1RWMjIgRHVhbCBEVkItVCBIRFRWKElUOTEzNykiLAorCQkJeyAmaXQ5MTN4X3RhYmxlWzFdLCBO
VUxMIH0sCisJCQl9LAogCiAJfQogfTsK
--001636d342e653d77404aed6af9f--
