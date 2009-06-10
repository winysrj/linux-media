Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.25]:3615 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889AbZFJRQL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Jun 2009 13:16:11 -0400
Received: by qw-out-2122.google.com with SMTP id 5so607523qwd.37
        for <linux-media@vger.kernel.org>; Wed, 10 Jun 2009 10:16:13 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 11 Jun 2009 01:16:13 +0800
Message-ID: <15ed362e0906101016g13b81df6h1282e3bd410928b2@mail.gmail.com>
Subject: [PATCH] [Resend] cxusb, d680 dmbth use unified lgs8gxx code instead
	of lgs8gl5
From: David Wong <davidtlwong@gmail.com>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org
Content-Type: multipart/mixed; boundary=00221532cb88dd2b5b046c01a165
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--00221532cb88dd2b5b046c01a165
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Use unified lgs8gxx frontend instead of reverse engineered lgs8gl5 frontend.
After this patch, lgs8gl5 frontend could be mark as deprecated.
Future development should base on unified lgs8gxx frontend.

Signed-off-by: David T.L. Wong <davidtlwong <at> gmail.com>

--00221532cb88dd2b5b046c01a165
Content-Type: text/x-patch; charset=US-ASCII; name="d680_lgs8gxx.patch"
Content-Disposition: attachment; filename="d680_lgs8gxx.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fvsaurd70

Y2hhbmdlc2V0OiAgIDExODMxOjJmZTNlZjA2YThlMgp0YWc6ICAgICAgICAgdGlwCnVzZXI6ICAg
ICAgICBtYXJ2ZWxAREhNMjAwCmRhdGU6ICAgICAgICBNb24gTWF5IDE4IDE3OjAzOjM2IDIwMDkg
KzA4MDAKc3VtbWFyeTogICAgIGN4dXNiOiBkNjgwIHN3aXRjaCBmcm9tIGxnczhnbDUgdG8gdW5p
ZmllZCBsZ3M4Z3h4IGZyb250ZW5kIGRyaXZlcgoKZGlmZiAtciAzMmU2NmEyYmQ1NjggLXIgMmZl
M2VmMDZhOGUyIGxpbnV4L2RyaXZlcnMvbWVkaWEvZHZiL2R2Yi11c2IvY3h1c2IuYwotLS0gYS9s
aW51eC9kcml2ZXJzL21lZGlhL2R2Yi9kdmItdXNiL2N4dXNiLmMJTW9uIE1heSAxOCAxNjowMTox
NSAyMDA5ICswODAwCisrKyBiL2xpbnV4L2RyaXZlcnMvbWVkaWEvZHZiL2R2Yi11c2IvY3h1c2Iu
YwlNb24gTWF5IDE4IDE3OjAzOjM2IDIwMDkgKzA4MDAKQEAgLTM4LDcgKzM4LDcgQEAKICNpbmNs
dWRlICJteGw1MDA1cy5oIgogI2luY2x1ZGUgImRpYjcwMDBwLmgiCiAjaW5jbHVkZSAiZGliMDA3
MC5oIgotI2luY2x1ZGUgImxnczhnbDUuaCIKKyNpbmNsdWRlICJsZ3M4Z3h4LmgiCiAKIC8qIGRl
YnVnICovCiBzdGF0aWMgaW50IGR2Yl91c2JfY3h1c2JfZGVidWc7CkBAIC0xMDk3LDggKzEwOTcs
MTggQEAKIAlyZXR1cm4gLUVJTzsKIH0KIAotc3RhdGljIHN0cnVjdCBsZ3M4Z2w1X2NvbmZpZyBs
Z3M4Z2w1X2NmZyA9IHsKK3N0YXRpYyBzdHJ1Y3QgbGdzOGd4eF9jb25maWcgZDY4MF9sZ3M4Z2w1
X2NmZyA9IHsKKwkucHJvZCA9IExHUzhHWFhfUFJPRF9MR1M4R0w1LAogCS5kZW1vZF9hZGRyZXNz
ID0gMHgxOSwKKwkuc2VyaWFsX3RzID0gMCwKKwkudHNfY2xrX3BvbCA9IDAsCisJLnRzX2Nsa19n
YXRlZCA9IDEsCisJLmlmX2Nsa19mcmVxID0gMzA0MDAsIC8qIDMwLjQgTUh6ICovCisJLmlmX2Zy
ZXEgPSA1NzI1LCAvKiA1LjcyNSBNSHogKi8KKwkuaWZfbmVnX2NlbnRlciA9IDAsCisJLmV4dF9h
ZGMgPSAwLAorCS5hZGNfc2lnbmVkID0gMCwKKwkuaWZfbmVnX2VkZ2UgPSAwLAogfTsKIAogc3Rh
dGljIGludCBjeHVzYl9kNjgwX2RtYl9mcm9udGVuZF9hdHRhY2goc3RydWN0IGR2Yl91c2JfYWRh
cHRlciAqYWRhcCkKQEAgLTExMzgsNyArMTE0OCw3IEBACiAJbXNsZWVwKDEwMCk7CiAKIAkvKiBB
dHRhY2ggZnJvbnRlbmQgKi8KLQlhZGFwLT5mZSA9IGR2Yl9hdHRhY2gobGdzOGdsNV9hdHRhY2gs
ICZsZ3M4Z2w1X2NmZywgJmQtPmkyY19hZGFwKTsKKwlhZGFwLT5mZSA9IGR2Yl9hdHRhY2gobGdz
OGd4eF9hdHRhY2gsICZkNjgwX2xnczhnbDVfY2ZnLCAmZC0+aTJjX2FkYXApOwogCWlmIChhZGFw
LT5mZSA9PSBOVUxMKQogCQlyZXR1cm4gLUVJTzsKIAoK
--00221532cb88dd2b5b046c01a165--
