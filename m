Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42087 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753577Ab1LVXnr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Dec 2011 18:43:47 -0500
Received: by mail-ey0-f174.google.com with SMTP id d14so2375701eaa.19
        for <linux-media@vger.kernel.org>; Thu, 22 Dec 2011 15:43:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAEN_-SD3ap9VM_9aP7L3fGzJT_EfApEP5o4-wUmcUcXe5JvQJw@mail.gmail.com>
References: <CAEN_-SD3ap9VM_9aP7L3fGzJT_EfApEP5o4-wUmcUcXe5JvQJw@mail.gmail.com>
Date: Fri, 23 Dec 2011 00:43:47 +0100
Message-ID: <CAEN_-SA45T2ga56qCyex+EU7WaCSav4+WwCJzw2kNv9_ALiXPA@mail.gmail.com>
Subject: Re: Read DVB signal information directly from xc4000 based tuners
From: =?ISO-8859-2?Q?Miroslav_Sluge=F2?= <thunder.mmm@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: multipart/mixed; boundary=0015175d020e1fcb6504b4b6dff6
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--0015175d020e1fcb6504b4b6dff6
Content-Type: text/plain; charset=ISO-8859-1

For xc4000 based tuners we can read signal directly from tuner even
for demodulator. This is updated patch of id 8933. This patch depends
on id 8926 (Add signal information to xc4000 tuner).

--0015175d020e1fcb6504b4b6dff6
Content-Type: text/x-patch; charset=US-ASCII;
	name="0001-Read-DVB-signal-information-directly-from-xc4000-bas.patch"
Content-Disposition: attachment;
	filename="0001-Read-DVB-signal-information-directly-from-xc4000-bas.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gwif3rpm0

RnJvbSA0ZTUxZDY2ZTUxZTU0OTgzYjM4ZWE1NTZjMzcwYTdiZjNkZDVlMjczIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNaXJvc2xhdiA8dGh1bmRlci5tQGVtYWlsLmN6PgpEYXRlOiBG
cmksIDIzIERlYyAyMDExIDAwOjM1OjE1ICswMTAwClN1YmplY3Q6IFtQQVRDSF0gUmVhZCBEVkIg
c2lnbmFsIGluZm9ybWF0aW9uIGRpcmVjdGx5IGZyb20geGM0MDAwIGJhc2VkIHR1bmVycy4KCi0t
LQogZHJpdmVycy9tZWRpYS92aWRlby9jeDIzODg1L2N4MjM4ODUtZHZiLmMgfCAgICAzICsrKwog
ZHJpdmVycy9tZWRpYS92aWRlby9jeDg4L2N4ODgtZHZiLmMgICAgICAgfCAgICAzICsrKwogMiBm
aWxlcyBjaGFuZ2VkLCA2IGluc2VydGlvbnMoKyksIDAgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0
IGEvZHJpdmVycy9tZWRpYS92aWRlby9jeDIzODg1L2N4MjM4ODUtZHZiLmMgYi9kcml2ZXJzL21l
ZGlhL3ZpZGVvL2N4MjM4ODUvY3gyMzg4NS1kdmIuYwppbmRleCBmMDQ4MmIyLi43MTk4MDcyIDEw
MDY0NAotLS0gYS9kcml2ZXJzL21lZGlhL3ZpZGVvL2N4MjM4ODUvY3gyMzg4NS1kdmIuYworKysg
Yi9kcml2ZXJzL21lZGlhL3ZpZGVvL2N4MjM4ODUvY3gyMzg4NS1kdmIuYwpAQCAtOTQ1LDYgKzk0
NSw5IEBAIHN0YXRpYyBpbnQgZHZiX3JlZ2lzdGVyKHN0cnVjdCBjeDIzODg1X3RzcG9ydCAqcG9y
dCkKIAkJCQkgICAgICAgZGV2LT5uYW1lKTsKIAkJCQlnb3RvIGZyb250ZW5kX2RldGFjaDsKIAkJ
CX0KKworCQkJLyogcmVhZCBzaWduYWwgZGlyZWN0bHkgZnJvbSB0dW5lciAqLworCQkJZmUtPm9w
cy5yZWFkX3NpZ25hbF9zdHJlbmd0aCA9IGZlLT5vcHMudHVuZXJfb3BzLmdldF9yZl9zdHJlbmd0
aDsKIAkJfQogCQlicmVhazsKIAljYXNlIENYMjM4ODVfQk9BUkRfVEJTXzY5MjA6CmRpZmYgLS1n
aXQgYS9kcml2ZXJzL21lZGlhL3ZpZGVvL2N4ODgvY3g4OC1kdmIuYyBiL2RyaXZlcnMvbWVkaWEv
dmlkZW8vY3g4OC9jeDg4LWR2Yi5jCmluZGV4IDU5MmYzYWEuLmMwMjNhNmMgMTAwNjQ0Ci0tLSBh
L2RyaXZlcnMvbWVkaWEvdmlkZW8vY3g4OC9jeDg4LWR2Yi5jCisrKyBiL2RyaXZlcnMvbWVkaWEv
dmlkZW8vY3g4OC9jeDg4LWR2Yi5jCkBAIC02MzUsNiArNjM1LDkgQEAgc3RhdGljIGludCBhdHRh
Y2hfeGM0MDAwKHN0cnVjdCBjeDg4MDJfZGV2ICpkZXYsIHN0cnVjdCB4YzQwMDBfY29uZmlnICpj
ZmcpCiAJCXJldHVybiAtRUlOVkFMOwogCX0KIAorCS8qIHJlYWQgc2lnbmFsIGRpcmVjdGx5IGZy
b20geGM0MDAwIHR1bmVyICovCisJZmUtPm9wcy5yZWFkX3NpZ25hbF9zdHJlbmd0aCA9IGZlLT5v
cHMudHVuZXJfb3BzLmdldF9yZl9zdHJlbmd0aDsKKwogCXByaW50ayhLRVJOX0lORk8gIiVzLzI6
IHhjNDAwMCBhdHRhY2hlZFxuIiwgZGV2LT5jb3JlLT5uYW1lKTsKIAogCXJldHVybiAwOwotLSAK
MS43LjIuMwoK
--0015175d020e1fcb6504b4b6dff6--
