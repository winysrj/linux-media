Return-path: <linux-media-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.224]:5290 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296AbZCQP47 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Mar 2009 11:56:59 -0400
Received: by rv-out-0506.google.com with SMTP id g37so61083rvb.1
        for <linux-media@vger.kernel.org>; Tue, 17 Mar 2009 08:56:57 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 17 Mar 2009 23:56:57 +0800
Message-ID: <15ed362e0903170856g17e5fa47i9fb3ac927c2d25a5@mail.gmail.com>
Subject: [PATCH] CXUSB D680 DMB using unified lgs8gxx driver
From: David Wong <davidtlwong@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: multipart/mixed; boundary=000e0cd25530e38d7f0465529d22
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--000e0cd25530e38d7f0465529d22
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

This patch replace the use of lgs8gl5 driver by unified lgs8gxx driver, for
CXUSB D680 DMB (MagicPro ProHDTV)

David T.L. Wong

--000e0cd25530e38d7f0465529d22
Content-Type: text/x-patch; charset=US-ASCII; name="cxusb_d680_lgs8gxx.patch"
Content-Disposition: attachment; filename="cxusb_d680_lgs8gxx.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fserohh90

ZGlmZiAtciA2MjZjMTM2ZWMyMjEgbGludXgvZHJpdmVycy9tZWRpYS9kdmIvZHZiLXVzYi9jeHVz
Yi5jCi0tLSBhL2xpbnV4L2RyaXZlcnMvbWVkaWEvZHZiL2R2Yi11c2IvY3h1c2IuYwlGcmkgTWFy
IDEzIDE0OjM1OjE0IDIwMDkgLTA3MDAKKysrIGIvbGludXgvZHJpdmVycy9tZWRpYS9kdmIvZHZi
LXVzYi9jeHVzYi5jCVR1ZSBNYXIgMTcgMjM6MTc6MTYgMjAwOSArMDgwMApAQCAtMzgsNyArMzgs
NyBAQAogI2luY2x1ZGUgIm14bDUwMDVzLmgiCiAjaW5jbHVkZSAiZGliNzAwMHAuaCIKICNpbmNs
dWRlICJkaWIwMDcwLmgiCi0jaW5jbHVkZSAibGdzOGdsNS5oIgorI2luY2x1ZGUgImxnczhneHgu
aCIKIAogLyogZGVidWcgKi8KIHN0YXRpYyBpbnQgZHZiX3VzYl9jeHVzYl9kZWJ1ZzsKQEAgLTEw
OTcsOCArMTA5NywxOCBAQAogCXJldHVybiAtRUlPOwogfQogCi1zdGF0aWMgc3RydWN0IGxnczhn
bDVfY29uZmlnIGxnczhnbDVfY2ZnID0geworc3RhdGljIHN0cnVjdCBsZ3M4Z3h4X2NvbmZpZyBk
NjgwX2xnczhnbDVfY2ZnID0geworCS5wcm9kID0gTEdTOEdYWF9QUk9EX0xHUzhHTDUsCiAJLmRl
bW9kX2FkZHJlc3MgPSAweDE5LAorCS5zZXJpYWxfdHMgPSAwLAorCS50c19jbGtfcG9sID0gMCwK
KwkudHNfY2xrX2dhdGVkID0gMSwKKwkuaWZfY2xrX2ZyZXEgPSAzMDQwMCwgLyogMzAuNCBNSHog
Ki8KKwkuaWZfZnJlcSA9IDU3MjUsIC8qIDUuNzI1IE1IeiAqLworCS5pZl9uZWdfY2VudGVyID0g
MCwKKwkuZXh0X2FkYyA9IDAsCisJLmFkY19zaWduZWQgPSAwLAorCS5pZl9uZWdfZWRnZSA9IDAs
CiB9OwogCiBzdGF0aWMgaW50IGN4dXNiX2Q2ODBfZG1iX2Zyb250ZW5kX2F0dGFjaChzdHJ1Y3Qg
ZHZiX3VzYl9hZGFwdGVyICphZGFwKQpAQCAtMTEzOCw3ICsxMTQ4LDcgQEAKIAltc2xlZXAoMTAw
KTsKIAogCS8qIEF0dGFjaCBmcm9udGVuZCAqLwotCWFkYXAtPmZlID0gZHZiX2F0dGFjaChsZ3M4
Z2w1X2F0dGFjaCwgJmxnczhnbDVfY2ZnLCAmZC0+aTJjX2FkYXApOworCWFkYXAtPmZlID0gZHZi
X2F0dGFjaChsZ3M4Z3h4X2F0dGFjaCwgJmQ2ODBfbGdzOGdsNV9jZmcsICZkLT5pMmNfYWRhcCk7
CiAJaWYgKGFkYXAtPmZlID09IE5VTEwpCiAJCXJldHVybiAtRUlPOwogCg==
--000e0cd25530e38d7f0465529d22--
