Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:57593 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837Ab1KUVHq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Nov 2011 16:07:46 -0500
Received: by eye27 with SMTP id 27so5856546eye.19
        for <linux-media@vger.kernel.org>; Mon, 21 Nov 2011 13:07:45 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 22 Nov 2011 02:37:45 +0530
Message-ID: <CAHFNz9Kz8g6U_cHMZmpSDQ-QCvwwPY8wftn3dW-hprJ6DjE0sw@mail.gmail.com>
Subject: PATCH 07/13: 0007-CX24116-Query-DVB-frontend-delivery-capabilities
From: Manu Abraham <abraham.manu@gmail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Andreas Oberritter <obi@linuxtv.org>,
	Steven Toth <stoth@hauppauge.com>
Content-Type: multipart/mixed; boundary=f46d0435c06804870004b2451413
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--f46d0435c06804870004b2451413
Content-Type: text/plain; charset=ISO-8859-1



--f46d0435c06804870004b2451413
Content-Type: text/x-patch; charset=US-ASCII;
	name="0007-CX24116-Query-DVB-frontend-delivery-capabilities.patch"
Content-Disposition: attachment;
	filename="0007-CX24116-Query-DVB-frontend-delivery-capabilities.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: file0

RnJvbSBjMzE0Yjk1MDg1ZjQ1NjdkOTBiNGUwMjI3MmU2MGY4ZTE1Mzg1YWFjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNYW51IEFicmFoYW0gPGFicmFoYW0ubWFudUBnbWFpbC5jb20+
CkRhdGU6IFRodSwgMTcgTm92IDIwMTEgMDc6MDY6MjYgKzA1MzAKU3ViamVjdDogW1BBVENIIDA3
LzEzXSBDWDI0MTE2OiBRdWVyeSBEVkIgZnJvbnRlbmQgZGVsaXZlcnkgY2FwYWJpbGl0aWVzCgpP
dmVycmlkZSBkZWZhdWx0IGRlbGl2ZXJ5IHN5c3RlbSBpbmZvcm1hdGlvbiBwcm92aWRlZCBieSBG
RV9HRVRfSU5GTywgc28KdGhhdCBhcHBsaWNhdGlvbnMgY2FuIGVudW1lcmF0ZSBkZWxpdmVyeSBz
eXN0ZW1zIHByb3ZpZGVkIGJ5IHRoZSBmcm9udGVuZC4KVGhlIGhhcmR3YXJlIGFsc28gc3VwcG9y
dHMgRFNTLCBidXQgdGhlcmUgaXMgY3VycmVudGx5IG5vIGNvZGUgd2l0aGluIHRoZQpkcml2ZXIg
dG8gaGFuZGxlIHRoZSBkZWxpdmVyeSBzeXN0ZW0uIFdoZW4gY29kZSBleGlzdHMgdG8gaGFuZGxl
IERTUywgdGhlCmZyb250ZW5kIG5lZWRzIHRvIGFkdmVydGlzZSBpdCdzIERTUyBkZWxpdmVyeSBz
eXN0ZW0gY2FwYWJpbGl0eS4KClNpZ25lZC1vZmYtYnk6IE1hbnUgQWJyYWhhbSA8YWJyYWhhbS5t
YW51QGdtYWlsLmNvbT4KLS0tCiBkcml2ZXJzL21lZGlhL2R2Yi9mcm9udGVuZHMvY3gyNDExNi5j
IHwgICAgOSArKysrKysrKysKIDEgZmlsZXMgY2hhbmdlZCwgOSBpbnNlcnRpb25zKCspLCAwIGRl
bGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWVkaWEvZHZiL2Zyb250ZW5kcy9jeDI0
MTE2LmMgYi9kcml2ZXJzL21lZGlhL2R2Yi9mcm9udGVuZHMvY3gyNDExNi5jCmluZGV4IGNjZDA1
MjUuLjg4NjAyODUgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbWVkaWEvZHZiL2Zyb250ZW5kcy9jeDI0
MTE2LmMKKysrIGIvZHJpdmVycy9tZWRpYS9kdmIvZnJvbnRlbmRzL2N4MjQxMTYuYwpAQCAtMTIy
Myw2ICsxMjIzLDE1IEBAIHN0YXRpYyBpbnQgY3gyNDExNl9nZXRfcHJvcGVydHkoc3RydWN0IGR2
Yl9mcm9udGVuZCAqZmUsCiAJc3RydWN0IGR0dl9wcm9wZXJ0eSAqdHZwKQogewogCWRwcmludGso
IiVzKC4uKVxuIiwgX19mdW5jX18pOworCXN3aXRjaCAodHZwLT5jbWQpIHsKKwljYXNlIERUVl9F
TlVNX0RFTFNZUzoKKwkJdHZwLT51LmJ1ZmZlci5kYXRhWzBdID0gU1lTX0RWQlM7CisJCXR2cC0+
dS5idWZmZXIuZGF0YVsxXSA9IFNZU19EVkJTMjsKKwkJdHZwLT51LmJ1ZmZlci5sZW4gPSAyOwor
CQlicmVhazsKKwlkZWZhdWx0OgorCQlicmVhazsKKwl9CiAJcmV0dXJuIDA7CiB9CiAKLS0gCjEu
Ny4xCgo=
--f46d0435c06804870004b2451413--
