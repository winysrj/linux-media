Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:56705 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014Ab0GYM6p (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Jul 2010 08:58:45 -0400
Received: by eya25 with SMTP id 25so320633eya.19
        for <linux-media@vger.kernel.org>; Sun, 25 Jul 2010 05:58:44 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 25 Jul 2010 15:58:43 +0300
Message-ID: <AANLkTinU8gO1gx+3wD4hqYp7O2U2RC2UQ597Jag=gMPw@mail.gmail.com>
Subject: [PATCH] Fix possible memory leak in dvbca.c
From: Tomer Barletz <barletz@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: multipart/mixed; boundary=0015174c1704f15951048c35d31e
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--0015174c1704f15951048c35d31e
Content-Type: text/plain; charset=ISO-8859-1

Allocated memory will never get free when read fails.
See attached patch.

Tomer

--0015174c1704f15951048c35d31e
Content-Type: text/x-patch; charset=US-ASCII; name="dvbca_link_read.diff"
Content-Disposition: attachment; filename="dvbca_link_read.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gc1w6ly10

ZGlmZiAtciBkMzUwOWQ2ZTk0OTkgbGliL2xpYmR2YmFwaS9kdmJjYS5jCi0tLSBhL2xpYi9saWJk
dmJhcGkvZHZiY2EuYwlTYXQgQXVnIDA4IDE5OjE3OjIxIDIwMDkgKzAyMDAKKysrIGIvbGliL2xp
YmR2YmFwaS9kdmJjYS5jCVN1biBKdWwgMjUgMTU6NTA6MzAgMjAxMCArMDMwMApAQCAtMTEwLDgg
KzExMCwxMCBAQAogCWlmIChidWYgPT0gTlVMTCkKIAkJcmV0dXJuIC0xOwogCi0JaWYgKChzaXpl
ID0gcmVhZChmZCwgYnVmLCBkYXRhX2xlbmd0aCsyKSkgPCAyKQorCWlmICgoc2l6ZSA9IHJlYWQo
ZmQsIGJ1ZiwgZGF0YV9sZW5ndGgrMikpIDwgMikgeworCQlmcmVlKGJ1Zik7CiAJCXJldHVybiAt
MTsKKwl9CiAKIAkqc2xvdCA9IGJ1ZlswXTsKIAkqY29ubmVjdGlvbl9pZCA9IGJ1ZlsxXTsK
--0015174c1704f15951048c35d31e--
