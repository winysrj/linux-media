Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f49.google.com ([209.85.212.49]:50886 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385Ab3GMCoy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Jul 2013 22:44:54 -0400
Received: by mail-vb0-f49.google.com with SMTP id 12so2002206vbf.8
        for <linux-media@vger.kernel.org>; Fri, 12 Jul 2013 19:44:53 -0700 (PDT)
MIME-Version: 1.0
From: Huei-Horng Yo <hiroshiyui@gmail.com>
Date: Sat, 13 Jul 2013 10:44:22 +0800
Message-ID: <CAJNvB=z5YLBUuNy8-ozUDEFxrHwfr7jt=Cp3QOvqZn15DY8qqg@mail.gmail.com>
Subject: [PATCH][dvb-apps] Fix 'scan' utility region 0x14 encoding from BIG5
 to UTF-16BE
To: linux-media@vger.kernel.org
Content-Type: multipart/mixed; boundary=20cf307abe9fa43c0804e15b9c2d
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--20cf307abe9fa43c0804e15b9c2d
Content-Type: text/plain; charset=UTF-8

From: Huei-Horng Yo <hiroshiyui@gmail.com>


Signed-off-by: Huei-Horng Yo <hiroshiyui@gmail.com>
---

--20cf307abe9fa43c0804e15b9c2d
Content-Type: application/octet-stream; name="scan.patch"
Content-Disposition: attachment; filename="scan.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hj27ntqk0

ZGlmZiAtLWdpdCBhL3V0aWwvc2Nhbi9zY2FuLmMgYi91dGlsL3NjYW4vc2Nhbi5jCmluZGV4IDcx
YTIwZGIuLjk4MDkzZWUgMTAwNjQ0Ci0tLSBhL3V0aWwvc2Nhbi9zY2FuLmMKKysrIGIvdXRpbC9z
Y2FuL3NjYW4uYwpAQCAtODUwLDcgKzg1MCw3IEBAIHN0YXRpYyB2b2lkIGRlc2NyaXB0b3JjcHko
Y2hhciAqKmRlc3QsIGNvbnN0IHVuc2lnbmVkIGNoYXIgKnNyYywgc2l6ZV90IGxlbikKIAkJY2Fz
ZSAweDExOgl0eXBlID0gIklTTy0xMDY0NiI7CQlicmVhazsKIAkJY2FzZSAweDEyOgl0eXBlID0g
IklTTy0yMDIyLUtSIjsJCWJyZWFrOwogCQljYXNlIDB4MTM6CXR5cGUgPSAiR0IyMzEyIjsJCWJy
ZWFrOwotCQljYXNlIDB4MTQ6CXR5cGUgPSAiQklHNSI7CQkJYnJlYWs7CisJCWNhc2UgMHgxNDoJ
dHlwZSA9ICJVVEYtMTZCRSI7CQkJYnJlYWs7CiAJCWNhc2UgMHgxNToJdHlwZSA9ICJJU08tMTA2
NDYvVVRGLTgiOwlicmVhazsKIAkJY2FzZSAweDEwOiAvKiBJU084ODU5ICovCiAJCQlpZiAoKCoo
c3JjICsgMSkgIT0gMCkgfHwgKihzcmMgKyAyKSA+IDB4MGYpCg==
--20cf307abe9fa43c0804e15b9c2d--
