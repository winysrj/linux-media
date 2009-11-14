Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:49264 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754788AbZKNJJs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Nov 2009 04:09:48 -0500
MIME-Version: 1.0
Date: Sat, 14 Nov 2009 17:09:53 +0800
Message-ID: <e5b1e8d40911140109k78721b1er7b167d05d6f2e26e@mail.gmail.com>
Subject: [stk-webcam] change constants to work better on FreeBSD
From: Buganini <buganini@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Content-Type: multipart/mixed; boundary=000e0cd5f6fab6ef62047851234e
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--000e0cd5f6fab6ef62047851234e
Content-Type: text/plain; charset=UTF-8

Suggested by hselasky@FreeBSD.org, tested by me on FreeBSD.
With original value it hangs a lot.

I dont fully understand background knowledge,
it's said that the default value is not enough for high speed transfer.


--Buganini

--000e0cd5f6fab6ef62047851234e
Content-Type: application/octet-stream; name="stk-webcam.h.patch"
Content-Disposition: attachment; filename="stk-webcam.h.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: file0

LS0tIGxpbnV4L2RyaXZlcnMvbWVkaWEvdmlkZW8vc3RrLXdlYmNhbS5oLm9yaWcJMjAwOS0xMS0x
MiAyMjoyMTowNS4wMDAwMDAwMDAgKzA4MDAKKysrIGxpbnV4L2RyaXZlcnMvbWVkaWEvdmlkZW8v
c3RrLXdlYmNhbS5oCTIwMDktMTEtMTIgMDI6NDI6NDUuNjE2NjAzMzc5ICswODAwCkBAIC0yOCw4
ICsyOCw4IEBACiAjZGVmaW5lIERSSVZFUl9WRVJTSU9OCQkidjAuMC4xIgogI2RlZmluZSBEUklW
RVJfVkVSU0lPTl9OVU0JMHgwMDAwMDEKIAotI2RlZmluZSBNQVhfSVNPX0JVRlMJCTMKLSNkZWZp
bmUgSVNPX0ZSQU1FU19QRVJfREVTQwkxNgorI2RlZmluZSBNQVhfSVNPX0JVRlMJCTIKKyNkZWZp
bmUgSVNPX0ZSQU1FU19QRVJfREVTQwk2NAogI2RlZmluZSBJU09fTUFYX0ZSQU1FX1NJWkUJMyAq
IDEwMjQKICNkZWZpbmUgSVNPX0JVRkZFUl9TSVpFCQkoSVNPX0ZSQU1FU19QRVJfREVTQyAqIElT
T19NQVhfRlJBTUVfU0laRSkKIAo=
--000e0cd5f6fab6ef62047851234e--
