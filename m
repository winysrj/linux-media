Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38488 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508Ab1KUVI6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Nov 2011 16:08:58 -0500
Received: by fagn18 with SMTP id n18so6452002fag.19
        for <linux-media@vger.kernel.org>; Mon, 21 Nov 2011 13:08:57 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 22 Nov 2011 02:38:56 +0530
Message-ID: <CAHFNz9L_yuqQGR+X078=d2Zz4iQNJHzZKaXJYykM8iMiQk6eLw@mail.gmail.com>
Subject: PATCH 11/13: 0011-STV0900-Query-DVB-frontend-delivery-capabilities
From: Manu Abraham <abraham.manu@gmail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Andreas Oberritter <obi@linuxtv.org>,
	"Igor M. Liplianin" <liplianin@netup.ru>
Content-Type: multipart/mixed; boundary=f46d0435c0684acc9904b24518bf
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--f46d0435c0684acc9904b24518bf
Content-Type: text/plain; charset=ISO-8859-1



--f46d0435c0684acc9904b24518bf
Content-Type: text/x-patch; charset=US-ASCII;
	name="0011-STV0900-Query-DVB-frontend-delivery-capabilities.patch"
Content-Disposition: attachment;
	filename="0011-STV0900-Query-DVB-frontend-delivery-capabilities.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: file0

RnJvbSBlODNiZjViMDFiMWE1MDg0ZGYzYzFhOGY4YjE1YzUyMTliZTYxOGQyIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNYW51IEFicmFoYW0gPGFicmFoYW0ubWFudUBnbWFpbC5jb20+
CkRhdGU6IFRodSwgMTcgTm92IDIwMTEgMTM6NDA6NDkgKzA1MzAKU3ViamVjdDogW1BBVENIIDEx
LzEzXSBTVFYwOTAwOiBRdWVyeSBEVkIgZnJvbnRlbmQgZGVsaXZlcnkgY2FwYWJpbGl0aWVzCgpP
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
--f46d0435c0684acc9904b24518bf--
