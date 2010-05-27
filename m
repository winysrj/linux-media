Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:38055 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757707Ab0E0On1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 May 2010 10:43:27 -0400
Received: by gwaa12 with SMTP id a12so11420gwa.19
        for <linux-media@vger.kernel.org>; Thu, 27 May 2010 07:43:27 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 27 May 2010 11:43:26 -0300
Message-ID: <AANLkTinXZL1jy8HF73WeWwCRjDIryevcag1yZUji5iy7@mail.gmail.com>
Subject: Re: [PATCH 3/4] tm6000: bugfix video image
From: Luis Henrique Fagundes <lhfagundes@hacklab.com.br>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Dmitri Belimov <d.belimov@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Bee Hock Goh <beehock@gmail.com>,
	Stefan Ringel <stefan.ringel@arcor.de>
Content-Type: multipart/mixed; boundary=001e680f1530cd820004879469e8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--001e680f1530cd820004879469e8
Content-Type: text/plain; charset=ISO-8859-1

Hi Stefan,

Looks like your patch sent on May 19th doesn't compile. I might be
missing something, but I needed the attached patch to make it compile.

Luis

--001e680f1530cd820004879469e8
Content-Type: text/x-patch; charset=US-ASCII; name="patch3-fix-bugfix_video_image.patch"
Content-Disposition: attachment;
	filename="patch3-fix-bugfix_video_image.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g9pp04fy0

LS0tIGEvZHJpdmVycy9zdGFnaW5nL3RtNjAwMC90bTYwMDAtdmlkZW8uYwkyMDEwLTA1LTI2IDA5
OjEzOjE5LjAwMDAwMDAwMCAtMDMwMAorKysgYi9kcml2ZXJzL3N0YWdpbmcvdG02MDAwL3RtNjAw
MC12aWRlby5jCTIwMTAtMDUtMjYgMDk6MTI6MjkuMDAwMDAwMDAwIC0wMzAwCkBAIC00MjMsNyAr
NDIzLDcgQEAKIAkJCQkJamlmZmllcyk7CiAJCQlyZXR1cm4gcmM7CiAJCX0KKwkJaWYgKCFidWYp
Ci0JCWlmICghKmJ1ZikKIAkJCXJldHVybiAwOwogCX0KIApAQCAtNDUyLDcgKzQ1Miw3IEBACiAJ
d2hpbGUgKGxlbj4wKSB7CiAJCWNweXNpemU9bWluKGxlbixidWYtPnZiLnNpemUtcG9zKTsKIAkJ
Ly9wcmludGsoIkNvcHlpbmcgJWQgYnl0ZXMgKG1heD0lbHUpIGZyb20gJXAgdG8gJXBbJXVdXG4i
LGNweXNpemUsKCpidWYpLT52Yi5zaXplLHB0cixvdXRfcCxwb3MpOwotCQltZW1jcHkoJm91dF9w
W3Bvc10sIHB0ciwgY3B5c2l6ZSk7CisJCW1lbWNweSgmb3V0cFtwb3NdLCBwdHIsIGNweXNpemUp
OwogCQlwb3MrPWNweXNpemU7CiAJCXB0cis9Y3B5c2l6ZTsKIAkJbGVuLT1jcHlzaXplOwpAQCAt
NDY0LDggKzQ2NCw4IEBACiAJCQlnZXRfbmV4dF9idWYgKGRtYV9xLCAmYnVmKTsKIAkJCWlmICgh
YnVmKQogCQkJCWJyZWFrOwotCQkJb3V0X3AgPSB2aWRlb2J1Zl90b192bWFsbG9jKCYoYnVmLT52
YikpOwotCQkJaWYgKCFvdXRfcCkKKwkJCW91dHAgPSB2aWRlb2J1Zl90b192bWFsbG9jKCYoYnVm
LT52YikpOworCQkJaWYgKCFvdXRwKQogCQkJCXJldHVybiByYzsKIAkJCXBvcyA9IDA7CiAJCX0K
--001e680f1530cd820004879469e8--
