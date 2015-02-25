Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:51660 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752305AbbBYH3e (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Feb 2015 02:29:34 -0500
From: Sudip JAIN <sudip.jain@st.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 25 Feb 2015 15:29:22 +0800
Subject: 0001-media-vb2-Fill-vb2_buffer-with-bytesused-from-user.patch
Message-ID: <AE3729EDFAD6D548827A31E3191F1E5B0138E8D7@EAPEX1MAIL1.st.com>
Content-Language: en-US
Content-Type: multipart/mixed;
	boundary="_002_AE3729EDFAD6D548827A31E3191F1E5B0138E8D7EAPEX1MAIL1stco_"
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--_002_AE3729EDFAD6D548827A31E3191F1E5B0138E8D7EAPEX1MAIL1stco_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Dear Maintainer,

PFA attached patch that prevents user from being returned garbage bytesused=
 value from vb2 framework.

Regards,
Sudip Jain
 =

--_002_AE3729EDFAD6D548827A31E3191F1E5B0138E8D7EAPEX1MAIL1stco_
Content-Type: text/x-patch;
	name="0001-media-vb2-Fill-vb2_buffer-with-bytesused-from-user.patch"
Content-Description: 0001-media-vb2-Fill-vb2_buffer-with-bytesused-from-user.patch
Content-Disposition: attachment;
	filename="0001-media-vb2-Fill-vb2_buffer-with-bytesused-from-user.patch";
	size=1634; creation-date="Wed, 25 Feb 2015 07:15:19 GMT";
	modification-date="Wed, 25 Feb 2015 07:15:19 GMT"
Content-Transfer-Encoding: base64

RnJvbSA4MDRlNzZmODlkNzNkMTBiOWZkN2IyNWE0OGE2ZWRjMzFmYWE0MGE5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdWRpcCBKYWluIDxzdWRpcC5qYWluQHN0LmNvbT4KRGF0ZTog
V2VkLCAyNSBGZWIgMjAxNSAxMjoyNDo1MyArMDUzMApTdWJqZWN0OiBbUEFUQ0hdIG1lZGlhOiB2
YjI6IEZpbGwgdmIyX2J1ZmZlciB3aXRoIGJ5dGVzdXNlZCBmcm9tIHVzZXIKCkluIHZiMl9xYnVm
IGZvciBkbWFidWYgbWVtb3J5IHR5cGUsIHVzZXJzaWRlIGJ5dGVzdXNlZCBpcyBub3QgY29waWVk
IGluCnZiMiBidWZmZXIuIFRoaXMgbGVhZHMgdG8gZ2FyYmFnZSB2YWx1ZSBiZWluZyBjb3BpZWQg
ZnJvbSBfX3FidWZfZG1hYnVmKCkKYmFjayB0byB1c2VyIGluIF9fZmlsbF92NGwyX2J1ZmZlcigp
LgoKQXMgYSBkZWZhdWx0IGNhc2UsIHRoZSB2YjIgZnJhbWV3b3JrIG11c3QgcmV0dXJuIHRoZSBk
ZWZhdWx0IHZhbHVlIHRvIHRoZSB1c2VyLAppZiB0aGUgZHJpdmVyJ3MgYnVmZmVyIHByZXBhcmUg
ZnVuY3Rpb24gcHJlZmVycyBub3QgdG8gbW9kaWZ5L3VwZGF0ZS4KCkNoYW5nZS1JZDogSWVkYTM4
OTQwMzg5ODkzNWY1OWMyZTI5OTQxMDZmM2U1MjM4Y2ZlZmQKU2lnbmVkLW9mZi1ieTogU3VkaXAg
SmFpbiA8c3VkaXAuamFpbkBzdC5jb20+Ci0tLQogZHJpdmVycy9tZWRpYS92NGwyLWNvcmUvdmlk
ZW9idWYyLWNvcmUuYyB8ICAgIDMgKysrCiAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCsp
CgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9tZWRpYS92NGwyLWNvcmUvdmlkZW9idWYyLWNvcmUuYyBi
L2RyaXZlcnMvbWVkaWEvdjRsMi1jb3JlL3ZpZGVvYnVmMi1jb3JlLmMKaW5kZXggNWU0N2JhNC4u
NTRmZTljOSAxMDA2NDQKLS0tIGEvZHJpdmVycy9tZWRpYS92NGwyLWNvcmUvdmlkZW9idWYyLWNv
cmUuYworKysgYi9kcml2ZXJzL21lZGlhL3Y0bDItY29yZS92aWRlb2J1ZjItY29yZS5jCkBAIC05
MTksNiArOTE5LDggQEAgc3RhdGljIHZvaWQgX19maWxsX3ZiMl9idWZmZXIoc3RydWN0IHZiMl9i
dWZmZXIgKnZiLCBjb25zdCBzdHJ1Y3QgdjRsMl9idWZmZXIgKmIKIAkJCQkJYi0+bS5wbGFuZXNb
cGxhbmVdLm0uZmQ7CiAJCQkJdjRsMl9wbGFuZXNbcGxhbmVdLmxlbmd0aCA9CiAJCQkJCWItPm0u
cGxhbmVzW3BsYW5lXS5sZW5ndGg7CisJCQkJdjRsMl9wbGFuZXNbcGxhbmVdLmJ5dGVzdXNlZCA9
CisJCQkJCWItPm0ucGxhbmVzW3BsYW5lXS5ieXRlc3VzZWQ7CiAJCQkJdjRsMl9wbGFuZXNbcGxh
bmVdLmRhdGFfb2Zmc2V0ID0KIAkJCQkJYi0+bS5wbGFuZXNbcGxhbmVdLmRhdGFfb2Zmc2V0Owog
CQkJfQpAQCAtOTQzLDYgKzk0NSw3IEBAIHN0YXRpYyB2b2lkIF9fZmlsbF92YjJfYnVmZmVyKHN0
cnVjdCB2YjJfYnVmZmVyICp2YiwgY29uc3Qgc3RydWN0IHY0bDJfYnVmZmVyICpiCiAJCWlmIChi
LT5tZW1vcnkgPT0gVjRMMl9NRU1PUllfRE1BQlVGKSB7CiAJCQl2NGwyX3BsYW5lc1swXS5tLmZk
ID0gYi0+bS5mZDsKIAkJCXY0bDJfcGxhbmVzWzBdLmxlbmd0aCA9IGItPmxlbmd0aDsKKwkJCXY0
bDJfcGxhbmVzWzBdLmJ5dGVzdXNlZCA9IGItPmJ5dGVzdXNlZDsKIAkJCXY0bDJfcGxhbmVzWzBd
LmRhdGFfb2Zmc2V0ID0gMDsKIAkJfQogCi0tIAoxLjcuOS41Cgo=

--_002_AE3729EDFAD6D548827A31E3191F1E5B0138E8D7EAPEX1MAIL1stco_--
