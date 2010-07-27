Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46350 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377Ab0G0M6i (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Jul 2010 08:58:38 -0400
Received: by wyf19 with SMTP id 19so3018318wyf.19
        for <linux-media@vger.kernel.org>; Tue, 27 Jul 2010 05:58:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTinU8gO1gx+3wD4hqYp7O2U2RC2UQ597Jag=gMPw@mail.gmail.com>
References: <AANLkTinU8gO1gx+3wD4hqYp7O2U2RC2UQ597Jag=gMPw@mail.gmail.com>
Date: Tue, 27 Jul 2010 15:58:37 +0300
Message-ID: <AANLkTi=8GyE8-EdMfoL+MDXvFGi1V-ikvHc5m=h3Q9zt@mail.gmail.com>
Subject: Re: [PATCH] Fix possible memory leak in dvbca.c
From: Tomer Barletz <barletz@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: multipart/mixed; boundary=0016362849a83a082c048c5e0f93
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--0016362849a83a082c048c5e0f93
Content-Type: text/plain; charset=ISO-8859-1

2010/7/25 Tomer Barletz <barletz@gmail.com>:
> Allocated memory will never get free when read fails.
> See attached patch.
>
> Tomer
>

Attached a better patch... :)

--0016362849a83a082c048c5e0f93
Content-Type: text/x-patch; charset=US-ASCII; name="mem_leak.diff"
Content-Disposition: attachment; filename="mem_leak.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gc4r4vva1

ZGlmZiAtciBkMzUwOWQ2ZTk0OTkgbGliL2xpYmR2YmFwaS9kdmJjYS5jCi0tLSBhL2xpYi9saWJk
dmJhcGkvZHZiY2EuYwlTYXQgQXVnIDA4IDE5OjE3OjIxIDIwMDkgKzAyMDAKKysrIGIvbGliL2xp
YmR2YmFwaS9kdmJjYS5jCVR1ZSBKdWwgMjcgMTU6NTY6NDggMjAxMCArMDMwMApAQCAtODksOCAr
ODksMTAgQEAKIAkJICAgICB1aW50OF90ICpkYXRhLCB1aW50MTZfdCBkYXRhX2xlbmd0aCkKIHsK
IAl1aW50OF90ICpidWYgPSBtYWxsb2MoZGF0YV9sZW5ndGggKyAyKTsKLQlpZiAoYnVmID09IE5V
TEwpCisJaWYgKGJ1ZiA9PSBOVUxMKSB7CisJCWZyZWUoYnVmKTsKIAkJcmV0dXJuIC0xOworCX0K
IAogCWJ1ZlswXSA9IHNsb3Q7CiAJYnVmWzFdID0gY29ubmVjdGlvbl9pZDsKQEAgLTExMCw4ICsx
MTIsMTAgQEAKIAlpZiAoYnVmID09IE5VTEwpCiAJCXJldHVybiAtMTsKIAotCWlmICgoc2l6ZSA9
IHJlYWQoZmQsIGJ1ZiwgZGF0YV9sZW5ndGgrMikpIDwgMikKKwlpZiAoKHNpemUgPSByZWFkKGZk
LCBidWYsIGRhdGFfbGVuZ3RoKzIpKSA8IDIpIHsKKwkJZnJlZShidWYpOwogCQlyZXR1cm4gLTE7
CisJfQogCiAJKnNsb3QgPSBidWZbMF07CiAJKmNvbm5lY3Rpb25faWQgPSBidWZbMV07Cg==
--0016362849a83a082c048c5e0f93--
