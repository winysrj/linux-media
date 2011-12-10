Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36985 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226Ab1LJEnI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Dec 2011 23:43:08 -0500
Received: by mail-ww0-f44.google.com with SMTP id dr13so6983961wgb.1
        for <linux-media@vger.kernel.org>; Fri, 09 Dec 2011 20:43:08 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 10 Dec 2011 10:13:08 +0530
Message-ID: <CAHFNz9+uLXBpZXM056=-NzX1=2BnTtpjW4QbE3mSYnwVbWystA@mail.gmail.com>
Subject: v4 [PATCH 05/10] STV0900: Query DVB frontend delivery capabilities
From: Manu Abraham <abraham.manu@gmail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: multipart/mixed; boundary=bcaec52c6233be784d04b3b5899b
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--bcaec52c6233be784d04b3b5899b
Content-Type: text/plain; charset=ISO-8859-1



--bcaec52c6233be784d04b3b5899b
Content-Type: text/x-patch; charset=US-ASCII;
	name="0005-STV0900-Query-DVB-frontend-delivery-capabilities.patch"
Content-Disposition: attachment;
	filename="0005-STV0900-Query-DVB-frontend-delivery-capabilities.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: file0

RnJvbSAzYTBlNzUzN2U5NDUzMmNiNGRmNTc4OWNlYmFjZmQ5OGNhNGZhMTgzIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNYW51IEFicmFoYW0gPGFicmFoYW0ubWFudUBnbWFpbC5jb20+
CkRhdGU6IFRodSwgMTcgTm92IDIwMTEgMTM6NDA6NDkgKzA1MzAKU3ViamVjdDogW1BBVENIIDA1
LzEwXSBTVFYwOTAwOiBRdWVyeSBEVkIgZnJvbnRlbmQgZGVsaXZlcnkgY2FwYWJpbGl0aWVzCgpP
dmVycmlkZSBkZWZhdWx0IGRlbGl2ZXJ5IHN5c3RlbSBpbmZvcm1hdGlvbiBwcm92aWRlZCBieSBG
RV9HRVRfSU5GTywgc28KdGhhdCBhcHBsaWNhdGlvbnMgY2FuIGVudW1lcmF0ZSBkZWxpdmVyeSBz
eXN0ZW1zIHByb3ZpZGVkIGJ5IHRoZSBmcm9udGVuZC4KClNpZ25lZC1vZmYtYnk6IE1hbnUgQWJy
YWhhbSA8YWJyYWhhbS5tYW51QGdtYWlsLmNvbT4KLS0tCiBkcml2ZXJzL21lZGlhL2R2Yi9mcm9u
dGVuZHMvc3R2MDkwMF9jb3JlLmMgfCAgIDExICsrKysrKysrKystCiAxIGZpbGVzIGNoYW5nZWQs
IDEwIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9t
ZWRpYS9kdmIvZnJvbnRlbmRzL3N0djA5MDBfY29yZS5jIGIvZHJpdmVycy9tZWRpYS9kdmIvZnJv
bnRlbmRzL3N0djA5MDBfY29yZS5jCmluZGV4IDBjYTMxNmQuLjJiOGQ3OGMgMTAwNjQ0Ci0tLSBh
L2RyaXZlcnMvbWVkaWEvZHZiL2Zyb250ZW5kcy9zdHYwOTAwX2NvcmUuYworKysgYi9kcml2ZXJz
L21lZGlhL2R2Yi9mcm9udGVuZHMvc3R2MDkwMF9jb3JlLmMKQEAgLTk4NSw3ICs5ODUsMTYgQEAg
c3RhdGljIGludCBzdGIwOTAwX2dldF9wcm9wZXJ0eShzdHJ1Y3QgZHZiX2Zyb250ZW5kICpmZSwK
IAkJCQlzdHJ1Y3QgZHR2X3Byb3BlcnR5ICp0dnApCiB7CiAJZHByaW50aygiJXMoLi4pXG4iLCBf
X2Z1bmNfXyk7Ci0KKwlzd2l0Y2ggKHR2cC0+Y21kKSB7CisJY2FzZSBEVFZfRU5VTV9ERUxTWVM6
CisJCXR2cC0+dS5idWZmZXIuZGF0YVswXSA9IFNZU19EU1M7CisJCXR2cC0+dS5idWZmZXIuZGF0
YVsxXSA9IFNZU19EVkJTOworCQl0dnAtPnUuYnVmZmVyLmRhdGFbMl0gPSBTWVNfRFZCUzI7CisJ
CXR2cC0+dS5idWZmZXIubGVuID0gMzsKKwkJYnJlYWs7CisJZGVmYXVsdDoKKwkJYnJlYWs7CisJ
fQogCXJldHVybiAwOwogfQogCi0tIAoxLjcuMQoK
--bcaec52c6233be784d04b3b5899b--
