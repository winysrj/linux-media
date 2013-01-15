Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:49576 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756142Ab3AOOXw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Jan 2013 09:23:52 -0500
Received: by mail-ee0-f52.google.com with SMTP id b15so77701eek.25
        for <linux-media@vger.kernel.org>; Tue, 15 Jan 2013 06:23:50 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 15 Jan 2013 22:23:50 +0800
Message-ID: <CAPUZ0n-yTOsJK1QDyirnBWQZ-WzqD5LNXzj1-+ZDeLrvXjhA4w@mail.gmail.com>
Subject: [PATCH] cx23885: Add analog video input support for Compro E650F
From: =?UTF-8?B?55un55Ge5YWD?= <rueiyuan.lu@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: multipart/mixed; boundary=047d7b34413cb990e904d3548274
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--047d7b34413cb990e904d3548274
Content-Type: text/plain; charset=UTF-8

This patch enables all analog video inputs on Compro E650F cards.

However, it modifies "cx23885_initialize()" in "cx25840-core.c" that

may break other devices.

I'm seeking a way to avoid modifying "cx23885_initialize()",

any suggestions are appreciated.


Regards

--047d7b34413cb990e904d3548274
Content-Type: application/octet-stream;
	name="Add-analog-video-input-support-for-Compro-E650F.patch"
Content-Disposition: attachment;
	filename="Add-analog-video-input-support-for-Compro-E650F.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hbz3yiti0

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWVkaWEvdmlkZW8vY3gyMzg4NS9jeDIzODg1LWNhcmRzLmMg
Yi9kcml2ZXJzL21lZGlhL3ZpZGVvL2N4MjM4ODUvY3gyMzg4NS1jYXJkcy5jCmluZGV4IGMzY2Yw
ODkuLjI1MjQ4MzQgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbWVkaWEvdmlkZW8vY3gyMzg4NS9jeDIz
ODg1LWNhcmRzLmMKKysrIGIvZHJpdmVycy9tZWRpYS92aWRlby9jeDIzODg1L2N4MjM4ODUtY2Fy
ZHMuYwpAQCAtMjM3LDcgKzIzNywyOSBAQCBzdHJ1Y3QgY3gyMzg4NV9ib2FyZCBjeDIzODg1X2Jv
YXJkc1tdID0gewogCX0sCiAJW0NYMjM4ODVfQk9BUkRfQ09NUFJPX1ZJREVPTUFURV9FNjUwRl0g
PSB7CiAJCS5uYW1lCQk9ICJDb21wcm8gVmlkZW9NYXRlIEU2NTBGIiwKKwkJLnBvcnRhCQk9IENY
MjM4ODVfQU5BTE9HX1ZJREVPLAogCQkucG9ydGMJCT0gQ1gyMzg4NV9NUEVHX0RWQiwKKwkJLnR1
bmVyX3R5cGUJPSBUVU5FUl9YQzIwMjgsCisJCS50dW5lcl9hZGRyCT0gMHg2MSwKKwkJLmlucHV0
CQk9IHsKKwkJCXsKKwkJCQkudHlwZSAgID0gQ1gyMzg4NV9WTVVYX1RFTEVWSVNJT04sCisJCQkJ
LnZtdXggICA9IENYMjU4NDBfQ09NUE9TSVRFMgorCQkJfSwgeworCQkJCS50eXBlICAgPSBDWDIz
ODg1X1ZNVVhfQ09NUE9TSVRFMSwKKwkJCQkudm11eCAgID0gQ1gyNTg0MF9DT01QT1NJVEUxCisJ
CQl9LCB7CisJCQkJLnR5cGUgICA9IENYMjM4ODVfVk1VWF9TVklERU8sCisJCQkJLnZtdXggICA9
IENYMjU4NDBfU1ZJREVPX0xVTUE0fAorCQkJCQlDWDI1ODQwX1NWSURFT19DSFJPTUE3CisJCQl9
LCB7CisJCQkJLnR5cGUgICA9IENYMjM4ODVfVk1VWF9DT01QT05FTlQsCisJCQkJLnZtdXggICA9
IENYMjU4NDBfQ09NUE9ORU5UX09OfAorCQkJCQlDWDI1ODQwX1ZJTjNfQ0gxIHwKKwkJCQkJQ1gy
NTg0MF9WSU42X0NIMiB8CisJCQkJCUNYMjU4NDBfVklOOF9DSDMKKwkJCX0sCisJCX0sCiAJfSwK
IAlbQ1gyMzg4NV9CT0FSRF9UQlNfNjkyMF0gPSB7CiAJCS5uYW1lCQk9ICJUdXJib1NpZ2h0IFRC
UyA2OTIwIiwKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWVkaWEvdmlkZW8vY3gyNTg0MC9jeDI1ODQw
LWNvcmUuYyBiL2RyaXZlcnMvbWVkaWEvdmlkZW8vY3gyNTg0MC9jeDI1ODQwLWNvcmUuYwppbmRl
eCBjZDk5NzY0Li4xOWI1NjM0IDEwMDY0NAotLS0gYS9kcml2ZXJzL21lZGlhL3ZpZGVvL2N4MjU4
NDAvY3gyNTg0MC1jb3JlLmMKKysrIGIvZHJpdmVycy9tZWRpYS92aWRlby9jeDI1ODQwL2N4MjU4
NDAtY29yZS5jCkBAIC01ODEsNyArNTgxLDcgQEAgc3RhdGljIHZvaWQgY3gyMzg4NV9pbml0aWFs
aXplKHN0cnVjdCBpMmNfY2xpZW50ICpjbGllbnQpCiAJfTsKIAogCS8qIEFEQzIgaW5wdXQgc2Vs
ZWN0ICovCi0JY3gyNTg0MF93cml0ZShjbGllbnQsIDB4MTAyLCAweDEwKTsKKwljeDI1ODQwX3dy
aXRlKGNsaWVudCwgMHgxMDIsIDB4MDApOwogCiAJLyogVklOMSAmIFZJTjUgKi8KIAljeDI1ODQw
X3dyaXRlKGNsaWVudCwgMHgxMDMsIDB4MTEpOwo=
--047d7b34413cb990e904d3548274--
