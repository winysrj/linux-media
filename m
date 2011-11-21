Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:37251 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508Ab1KUVIX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Nov 2011 16:08:23 -0500
Received: by mail-ww0-f44.google.com with SMTP id 5so11147238wwe.1
        for <linux-media@vger.kernel.org>; Mon, 21 Nov 2011 13:08:22 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 22 Nov 2011 02:38:22 +0530
Message-ID: <CAHFNz9J1yO8iZkQi-=RsO=uNUSFpTWd-woV1atZA1U=kuMFcuw@mail.gmail.com>
Subject: PATCH 09/13: 0009-DS3000-Query-DVB-frontend-delivery-capabilities
From: Manu Abraham <abraham.manu@gmail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Andreas Oberritter <obi@linuxtv.org>,
	Konstantin Dimitrov <kosio.dimitrov@gmail.com>
Content-Type: multipart/mixed; boundary=000e0cd574ee3d683804b2451635
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--000e0cd574ee3d683804b2451635
Content-Type: text/plain; charset=ISO-8859-1



--000e0cd574ee3d683804b2451635
Content-Type: text/x-patch; charset=US-ASCII;
	name="0009-DS3000-Query-DVB-frontend-delivery-capabilities.patch"
Content-Disposition: attachment;
	filename="0009-DS3000-Query-DVB-frontend-delivery-capabilities.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: file0

RnJvbSBiZTY0NGNkN2RjNTg2NjIxMzM4YTljNGM0MTU2N2NjMzUxNzIzYzA1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNYW51IEFicmFoYW0gPGFicmFoYW0ubWFudUBnbWFpbC5jb20+
CkRhdGU6IFRodSwgMTcgTm92IDIwMTEgMTM6MDI6NDIgKzA1MzAKU3ViamVjdDogW1BBVENIIDA5
LzEzXSBEUzMwMDA6IFF1ZXJ5IERWQiBmcm9udGVuZCBkZWxpdmVyeSBjYXBhYmlsaXRpZXMKCk92
ZXJyaWRlIGRlZmF1bHQgZGVsaXZlcnkgc3lzdGVtIGluZm9ybWF0aW9uIHByb3ZpZGVkIGJ5IEZF
X0dFVF9JTkZPLCBzbwp0aGF0IGFwcGxpY2F0aW9ucyBjYW4gZW51bWVyYXRlIGRlbGl2ZXJ5IHN5
c3RlbXMgcHJvdmlkZWQgYnkgdGhlIGZyb250ZW5kLgoKU2lnbmVkLW9mZi1ieTogTWFudSBBYnJh
aGFtIDxhYnJhaGFtLm1hbnVAZ21haWwuY29tPgotLS0KIGRyaXZlcnMvbWVkaWEvZHZiL2Zyb250
ZW5kcy9kczMwMDAuYyB8ICAgMTIgKysrKysrKysrKy0tCiAxIGZpbGVzIGNoYW5nZWQsIDEwIGlu
c2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9tZWRpYS9k
dmIvZnJvbnRlbmRzL2RzMzAwMC5jIGIvZHJpdmVycy9tZWRpYS9kdmIvZnJvbnRlbmRzL2RzMzAw
MC5jCmluZGV4IDkwYmY1NzMuLjJmYzc2YzkgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbWVkaWEvZHZi
L2Zyb250ZW5kcy9kczMwMDAuYworKysgYi9kcml2ZXJzL21lZGlhL2R2Yi9mcm9udGVuZHMvZHMz
MDAwLmMKQEAgLTk0MSwxMCArOTQxLDE4IEBAIHN0YXRpYyBpbnQgZHMzMDAwX3NldF9wcm9wZXJ0
eShzdHJ1Y3QgZHZiX2Zyb250ZW5kICpmZSwKIAlyZXR1cm4gMDsKIH0KIAotc3RhdGljIGludCBk
czMwMDBfZ2V0X3Byb3BlcnR5KHN0cnVjdCBkdmJfZnJvbnRlbmQgKmZlLAotCXN0cnVjdCBkdHZf
cHJvcGVydHkgKnR2cCkKK3N0YXRpYyBpbnQgZHMzMDAwX2dldF9wcm9wZXJ0eShzdHJ1Y3QgZHZi
X2Zyb250ZW5kICpmZSwgc3RydWN0IGR0dl9wcm9wZXJ0eSAqcCkKIHsKIAlkcHJpbnRrKCIlcygu
LilcbiIsIF9fZnVuY19fKTsKKwlzd2l0Y2ggKHAtPmNtZCkgeworCWNhc2UgRFRWX0VOVU1fREVM
U1lTOgorCQlwLT51LmJ1ZmZlci5kYXRhWzBdID0gU1lTX0RWQlM7CisJCXAtPnUuYnVmZmVyLmRh
dGFbMV0gPSBTWVNfRFZCUzI7CisJCXAtPnUuYnVmZmVyLmxlbiA9IDI7CisJCWJyZWFrOworCWRl
ZmF1bHQ6CisJCWJyZWFrOworCX0KIAlyZXR1cm4gMDsKIH0KIAotLSAKMS43LjEKCg==
--000e0cd574ee3d683804b2451635--
