Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36985 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226Ab1LJEn2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Dec 2011 23:43:28 -0500
Received: by mail-ww0-f44.google.com with SMTP id dr13so6983961wgb.1
        for <linux-media@vger.kernel.org>; Fri, 09 Dec 2011 20:43:27 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 10 Dec 2011 10:13:27 +0530
Message-ID: <CAHFNz9+MM16waF0eLUKwFpX7fBistkb=9OgtXvo+ZOYkk67UQQ@mail.gmail.com>
Subject: v4 [PATCH 06/10] DVB: Use a unique delivery system identifier for DVBC_ANNEX_C
From: Manu Abraham <abraham.manu@gmail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: multipart/mixed; boundary=f46d0435c068e9e89804b3b58ac0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--f46d0435c068e9e89804b3b58ac0
Content-Type: text/plain; charset=ISO-8859-1



--f46d0435c068e9e89804b3b58ac0
Content-Type: text/x-patch; charset=US-ASCII;
	name="0006-DVB-Use-a-unique-delivery-system-identifier-for-DVBC.patch"
Content-Disposition: attachment;
	filename="0006-DVB-Use-a-unique-delivery-system-identifier-for-DVBC.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: file0

RnJvbSA5MmE3OWExZTBhMWI1NDAzZjA2ZjYwNjYxZjAwZWRlMzY1YjEwMTA4IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNYW51IEFicmFoYW0gPGFicmFoYW0ubWFudUBnbWFpbC5jb20+
CkRhdGU6IFRodSwgMjQgTm92IDIwMTEgMTc6MDk6MDkgKzA1MzAKU3ViamVjdDogW1BBVENIIDA2
LzEwXSBEVkI6IFVzZSBhIHVuaXF1ZSBkZWxpdmVyeSBzeXN0ZW0gaWRlbnRpZmllciBmb3IgRFZC
Q19BTk5FWF9DLAoganVzdCBsaWtlIGFueSBvdGhlci4gRFZCQ19BTk5FWF9BIGFuZCBEVkJDX0FO
TkVYX0MgaGF2ZSBzbGlnaHRseQogZGlmZmVyZW50IHBhcmFtZXRlcnMgYW5kIHVzZWQgaW4gMiBn
ZW9ncmFwaGljYWxseSBkaWZmZXJlbnQKIGxvY2F0aW9ucy4KClNpZ25lZC1vZmYtYnk6IE1hbnUg
QWJyYWhhbSA8YWJyYWhhbS5tYW51QGdtYWlsLmNvbT4KLS0tCiBpbmNsdWRlL2xpbnV4L2R2Yi9m
cm9udGVuZC5oIHwgICAgNyArKysrKystCiAxIGZpbGVzIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygr
KSwgMSBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L2R2Yi9mcm9udGVu
ZC5oIGIvaW5jbHVkZS9saW51eC9kdmIvZnJvbnRlbmQuaAppbmRleCBmODBiODYzLi5hM2M3NjIz
IDEwMDY0NAotLS0gYS9pbmNsdWRlL2xpbnV4L2R2Yi9mcm9udGVuZC5oCisrKyBiL2luY2x1ZGUv
bGludXgvZHZiL2Zyb250ZW5kLmgKQEAgLTMzNSw3ICszMzUsNyBAQCB0eXBlZGVmIGVudW0gZmVf
cm9sbG9mZiB7CiAKIHR5cGVkZWYgZW51bSBmZV9kZWxpdmVyeV9zeXN0ZW0gewogCVNZU19VTkRF
RklORUQsCi0JU1lTX0RWQkNfQU5ORVhfQUMsCisJU1lTX0RWQkNfQU5ORVhfQSwKIAlTWVNfRFZC
Q19BTk5FWF9CLAogCVNZU19EVkJULAogCVNZU19EU1MsCkBAIC0zNTIsOCArMzUyLDEzIEBAIHR5
cGVkZWYgZW51bSBmZV9kZWxpdmVyeV9zeXN0ZW0gewogCVNZU19EQUIsCiAJU1lTX0RWQlQyLAog
CVNZU19UVVJCTywKKwlTWVNfRFZCQ19BTk5FWF9DLAogfSBmZV9kZWxpdmVyeV9zeXN0ZW1fdDsK
IAorCisjZGVmaW5lIFNZU19EVkJDX0FOTkVYX0FDCVNZU19EVkJDX0FOTkVYX0EKKworCiBzdHJ1
Y3QgZHR2X2NtZHNfaCB7CiAJY2hhcgkqbmFtZTsJCS8qIEEgZGlzcGxheSBuYW1lIGZvciBkZWJ1
Z2dpbmcgcHVycG9zZXMgKi8KIAotLSAKMS43LjEKCg==
--f46d0435c068e9e89804b3b58ac0--
