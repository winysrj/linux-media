Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f42.google.com ([209.85.192.42]:34498 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485AbbFDMiZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Jun 2015 08:38:25 -0400
Received: by qgf75 with SMTP id 75so15241026qgf.1
        for <linux-media@vger.kernel.org>; Thu, 04 Jun 2015 05:38:24 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 4 Jun 2015 08:38:24 -0400
Message-ID: <CALzAhNW=Oei7_Nziozh3Mm+X_NNHvM5EdmPVPh9ajn5Aen9O2g@mail.gmail.com>
Subject: [PATCH][media] SI2168: Resolve unknown chip version errors with
 different HVR22x5 models
From: Steven Toth <stoth@kernellabs.com>
To: Linux-Media <linux-media@vger.kernel.org>
Cc: Antti Palosaari <crope@iki.fi>, Olli Salonen <olli.salonen@iki.fi>,
	Peter Faulkner-Ball <faulkner-ball@xtra.co.nz>
Content-Type: multipart/mixed; boundary=001a113a6f369472bc0517b073ed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--001a113a6f369472bc0517b073ed
Content-Type: text/plain; charset=UTF-8

We're seeing a mix of SI2168 demodulators appearing on HVR2205 and
HVR2215 cards, the chips are stamped with different build dates,
verified on my cards.

The si2168 driver detects some cards fine, others not at all. I can
reproduce the working and non-working case. The fix, if we detect a
newer card (D40) load the B firmware.

This fix works well for me and properly enables DVB-T tuning behavior
using tzap.

Thanks to Peter Faulkner-Ball for describing his workaround.

Signed-off-By: Steven Toth <stoth@kernellabs.com>

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com

--001a113a6f369472bc0517b073ed
Content-Type: application/octet-stream; name="d40.patch"
Content-Disposition: attachment; filename="d40.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_iai5uq7s0

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWVkaWEvZHZiLWZyb250ZW5kcy9zaTIxNjguYyBiL2RyaXZl
cnMvbWVkaWEvZHZiLWZyb250ZW5kcy9zaTIxNjguYwppbmRleCA1ZGI1ODhlLi42NjgyMzIzIDEw
MDY0NAotLS0gYS9kcml2ZXJzL21lZGlhL2R2Yi1mcm9udGVuZHMvc2kyMTY4LmMKKysrIGIvZHJp
dmVycy9tZWRpYS9kdmItZnJvbnRlbmRzL3NpMjE2OC5jCkBAIC00MDcsNiArNDA3LDcgQEAgc3Rh
dGljIGludCBzaTIxNjhfaW5pdChzdHJ1Y3QgZHZiX2Zyb250ZW5kICpmZSkKIAkjZGVmaW5lIFNJ
MjE2OF9BMjAgKCdBJyA8PCAyNCB8IDY4IDw8IDE2IHwgJzInIDw8IDggfCAnMCcgPDwgMCkKIAkj
ZGVmaW5lIFNJMjE2OF9BMzAgKCdBJyA8PCAyNCB8IDY4IDw8IDE2IHwgJzMnIDw8IDggfCAnMCcg
PDwgMCkKIAkjZGVmaW5lIFNJMjE2OF9CNDAgKCdCJyA8PCAyNCB8IDY4IDw8IDE2IHwgJzQnIDw8
IDggfCAnMCcgPDwgMCkKKwkjZGVmaW5lIFNJMjE2OF9ENDAgKCAgMCA8PCAyNCB8J0QnIDw8IDE2
IHwgJzQnIDw8IDggfCAnMCcgPDwgMCkKIAogCXN3aXRjaCAoY2hpcF9pZCkgewogCWNhc2UgU0ky
MTY4X0EyMDoKQEAgLTQxNiw2ICs0MTcsNyBAQCBzdGF0aWMgaW50IHNpMjE2OF9pbml0KHN0cnVj
dCBkdmJfZnJvbnRlbmQgKmZlKQogCQlmd19uYW1lID0gU0kyMTY4X0EzMF9GSVJNV0FSRTsKIAkJ
YnJlYWs7CiAJY2FzZSBTSTIxNjhfQjQwOgorCWNhc2UgU0kyMTY4X0Q0MDoKIAkJZndfbmFtZSA9
IFNJMjE2OF9CNDBfRklSTVdBUkU7CiAJCWJyZWFrOwogCWRlZmF1bHQ6Cg==
--001a113a6f369472bc0517b073ed--
