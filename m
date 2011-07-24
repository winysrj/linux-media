Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f171.google.com ([209.85.215.171]:56475 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516Ab1GXSoo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Jul 2011 14:44:44 -0400
Received: by eye22 with SMTP id 22so3133708eye.2
        for <linux-media@vger.kernel.org>; Sun, 24 Jul 2011 11:44:43 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 24 Jul 2011 14:44:43 -0400
Message-ID: <CAGoCfix0L_POhtmVi8qstEcQ5xNCb+dpP0zoQjCaL9LUmFZ10A@mail.gmail.com>
Subject: [PATCH] cx231xx: Fix power ramping issue
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Gerd Hoffmann <kraxel@redhat.com>
Content-Type: multipart/mixed; boundary=00504502c87388648d04a8d51700
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--00504502c87388648d04a8d51700
Content-Type: text/plain; charset=ISO-8859-1

Attached is a patch which addresses the issue discussed by Mauro and
Gerd for the "-32" errors seen with the Hauppauge USBLive 2.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com

--00504502c87388648d04a8d51700
Content-Type: text/x-patch; charset=US-ASCII; name="cx231xx_config_hz.patch"
Content-Disposition: attachment; filename="cx231xx_config_hz.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gqicvo9a0

Y3gyMzF4eDogRml4IHBvd2VyIHJhbXAgdGltZSB0byBiZSBjb25zaXN0ZW50IHJlZ2FyZGxlc3Mg
b2YgQ09ORklHX0haCgpGcm9tOiBEZXZpbiBIZWl0bXVlbGxlciA8ZGhlaXRtdWVsbGVyQGtlcm5l
bGxhYnMuY29tPgoKT24gcGxhdGZvcm1zIHRoYXQgaGF2ZSBDT05GSUdfSFogc2V0IHRvIDEwMCwg
dGhlIHBvd2VyIHJhbXAgdGltZSBlZmZlY3RpdmVseQplbmRzIHVwIGJlaW5nIDEwbXMuICBIb3dl
dmVyLCBvbiB0aG9zZSB0aGF0IGhhdmUgYSBoaWdoZXIgQ09ORklHX0haLCB0aGUgdGltZQplbmRz
IHVwICphY3R1YWxseSogYmVpbmcgNW1zLCB3aGljaCBkb2Vzbid0IGFsbG93IGVub3VnaCB0aW1l
IGZvciB0aGUgaGFyZHdhcmUKdG8gYmUgZnVsbHkgcG93ZXJlZCB1cCBiZWZvcmUgYXR0ZW1wdGlu
ZyB0byBhZGRyZXNzIGl0IHZpYSBpMmMuCgpDaGFuZ2UgdGhlIGNvbnN0YW50IHRvIDEwbXMsIHdo
aWNoIGlzIGxvbmcgZW5vdWdoIGZvciB0aGUgaGFyZHdhcmUgdG8gcG93ZXIKdXAsIGFuZCB3b24n
dCByZWFsbHkgYmUgYW55bW9yZSB0aW1lIHRoYW4gaXQgd2FzIHByZXZpb3VzbHkgb24gcGxhdGZv
cm1zCndpdGggQ09ORklHX0haIGJlaW5nIDEwMC4KCkNyZWRpdCBnb2VzIHRvIE1hdXJvIENhcnZh
bGhvIENoZWhhYiBhbmQgR2VyZCBIb2ZmbWFubiB3aG8gcHJldmlvdXNseQppbnZlc3RpZ2F0ZWQg
dGhpcyBpc3N1ZS4KClRlc3RlZCB3aXRoIHRoZSBIYXVwcGF1Z2UgVVNCTGl2ZSAyLCB3aXRoIHdo
aWNoIHRoZSBwcm9ibGVtIHdhcyByZWFkaWx5CnJlcHJvZHVjaWJsZSBhZnRlciBzZXR0aW5nIENP
TkZJR19IWiB0byAxMDAwLgoKU2lnbmVkLW9mZi1ieTogRGV2aW4gSGVpdG11ZWxsZXIgPGRoZWl0
bXVlbGxlckBrZXJuZWxsYWJzLmNvbT4KQ2M6IE1hdXJvIENhcnZhbGhvIENoZWhhYiA8bWNoZWhh
YkByZWRoYXQuY29tPgpDYzogR2VyZCBIb2ZmbWFubiA8a3JheGVsQHJlZGhhdC5jb20+CgpkaWZm
IC0tZ2l0IGEvZHJpdmVycy9tZWRpYS92aWRlby9jeDIzMXh4L2N4MjMxeHguaCBiL2RyaXZlcnMv
bWVkaWEvdmlkZW8vY3gyMzF4eC9jeDIzMXh4LmgKaW5kZXggYjM5Yjg1ZS4uNDcyZDE2OSAxMDA2
NDQKLS0tIGEvZHJpdmVycy9tZWRpYS92aWRlby9jeDIzMXh4L2N4MjMxeHguaAorKysgYi9kcml2
ZXJzL21lZGlhL3ZpZGVvL2N4MjMxeHgvY3gyMzF4eC5oCkBAIC00Myw3ICs0Myw3IEBACiAjaW5j
bHVkZSAiY3gyMzF4eC1jb25mLXJlZy5oIgogCiAjZGVmaW5lIERSSVZFUl9OQU1FICAgICAgICAg
ICAgICAgICAgICAgImN4MjMxeHgiCi0jZGVmaW5lIFBXUl9TTEVFUF9JTlRFUlZBTCAgICAgICAg
ICAgICAgNQorI2RlZmluZSBQV1JfU0xFRVBfSU5URVJWQUwgICAgICAgICAgICAgIDEwCiAKIC8q
IEkyQyBhZGRyZXNzZXMgZm9yIGNvbnRyb2wgYmxvY2sgaW4gQ3gyMzF4eCAqLwogI2RlZmluZSAg
ICAgQUZFX0RFVklDRV9BRERSRVNTCQkweDYwCg==
--00504502c87388648d04a8d51700--
