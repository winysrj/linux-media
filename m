Return-path: <linux-media-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.244]:8623 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbZFKMix (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jun 2009 08:38:53 -0400
Received: by an-out-0708.google.com with SMTP id d40so2770837and.1
        for <linux-media@vger.kernel.org>; Thu, 11 Jun 2009 05:38:54 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 11 Jun 2009 20:38:54 +0800
Message-ID: <15ed362e0906110538n3a07a8b0va22b0c77e8a9f024@mail.gmail.com>
Subject: [PATCH 1/4] lgs8gxx: lgs8913 fake signal strength option default on
From: David Wong <davidtlwong@gmail.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: multipart/mixed; boundary=002215046b67f3c17c046c11df95
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--002215046b67f3c17c046c11df95
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

lgs8gxx: lgs8913 fake signal strength option default on. Original
calculation is too slow.

Signed-off-by: David T.L. Wong <davidtlwong <at> gmail.com>

--002215046b67f3c17c046c11df95
Content-Type: text/x-patch; charset=US-ASCII; name="lgs8gxx_fake_signal_option_on.patch"
Content-Disposition: attachment;
	filename="lgs8gxx_fake_signal_option_on.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fvtg9pdg0

ZGlmZiAtciBlZDM3ODFhNzljNzMgLXIgYjEzZGIxOTM1YzQ4IGxpbnV4L2RyaXZlcnMvbWVkaWEv
ZHZiL2Zyb250ZW5kcy9sZ3M4Z3h4LmMKLS0tIGEvbGludXgvZHJpdmVycy9tZWRpYS9kdmIvZnJv
bnRlbmRzL2xnczhneHguYwlTYXQgSnVuIDA2IDE2OjMxOjM0IDIwMDkgKzA0MDAKKysrIGIvbGlu
dXgvZHJpdmVycy9tZWRpYS9kdmIvZnJvbnRlbmRzL2xnczhneHguYwlUaHUgSnVuIDExIDE4OjU5
OjM0IDIwMDkgKzA4MDAKQEAgLTM3LDE0ICszNywxNCBAQAogCX0gd2hpbGUgKDApCiAKIHN0YXRp
YyBpbnQgZGVidWc7Ci1zdGF0aWMgaW50IGZha2Vfc2lnbmFsX3N0cjsKK3N0YXRpYyBpbnQgZmFr
ZV9zaWduYWxfc3RyID0gMTsKIAogbW9kdWxlX3BhcmFtKGRlYnVnLCBpbnQsIDA2NDQpOwogTU9E
VUxFX1BBUk1fREVTQyhkZWJ1ZywgIlR1cm4gb24vb2ZmIGZyb250ZW5kIGRlYnVnZ2luZyAoZGVm
YXVsdDpvZmYpLiIpOwogCiBtb2R1bGVfcGFyYW0oZmFrZV9zaWduYWxfc3RyLCBpbnQsIDA2NDQp
OwogTU9EVUxFX1BBUk1fREVTQyhmYWtlX3NpZ25hbF9zdHIsICJmYWtlIHNpZ25hbCBzdHJlbmd0
aCBmb3IgTEdTODkxMy4iCi0iU2lnbmFsIHN0cmVuZ3RoIGNhbGN1bGF0aW9uIGlzIHNsb3cuKGRl
ZmF1bHQ6b2ZmKS4iKTsKKyJTaWduYWwgc3RyZW5ndGggY2FsY3VsYXRpb24gaXMgc2xvdy4oZGVm
YXVsdDpvbikuIik7CiAKIC8qIExHUzhHWFggaW50ZXJuYWwgaGVscGVyIGZ1bmN0aW9ucyAqLwog
Cgo=
--002215046b67f3c17c046c11df95--
