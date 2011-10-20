Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:45246 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001Ab1JTPYl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Oct 2011 11:24:41 -0400
Received: by wwn22 with SMTP id 22so7971404wwn.1
        for <linux-media@vger.kernel.org>; Thu, 20 Oct 2011 08:24:39 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 20 Oct 2011 11:24:29 -0400
Message-ID: <CAOTqeXouWiYaRkKKO-1iQ5SJEb7RUXJpHdfe9-YeSzwXxdUVfg@mail.gmail.com>
Subject: [PATCH] [media] hdpvr: update picture controls to support firmware
 versions > 0.15
From: Taylor Ralph <taylor.ralph@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: multipart/mixed; boundary=0016e6dee805858dce04afbc8dc7
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--0016e6dee805858dce04afbc8dc7
Content-Type: text/plain; charset=ISO-8859-1

I've attached a patch that correctly sets the max/min/default values
for the hdpvr picture controls. The reason the current values didn't
cause a problem until now is because any firmware <= 0.15 didn't
support them. The latest firmware releases properly support picture
controls and the values in the patch are derived from the windows
driver using SniffUSB2.0.

Thanks to Devin Heitmueller for helping me.

Regards.
--
Taylor

--0016e6dee805858dce04afbc8dc7
Content-Type: text/x-diff; charset=US-ASCII; name="hdpvr.diff"
Content-Disposition: attachment; filename="hdpvr.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gtzw96us0

ZGlmZiAtciBhYmQzYWFjNjY0NGUgbGludXgvZHJpdmVycy9tZWRpYS92aWRlby9oZHB2ci9oZHB2
ci1jb3JlLmMKLS0tIGEvbGludXgvZHJpdmVycy9tZWRpYS92aWRlby9oZHB2ci9oZHB2ci1jb3Jl
LmMJRnJpIEp1bCAwMiAwMDozODo1NCAyMDEwIC0wMzAwCisrKyBiL2xpbnV4L2RyaXZlcnMvbWVk
aWEvdmlkZW8vaGRwdnIvaGRwdnItY29yZS5jCVRodSBPY3QgMjAgMTE6MTQ6MjUgMjAxMSAtMDQw
MApAQCAtMjYyLDEwICsyNjIsMTAgQEAKIAkuYml0cmF0ZV9tb2RlCT0gSERQVlJfQ09OU1RBTlQs
CiAJLmdvcF9tb2RlCT0gSERQVlJfU0lNUExFX0lEUl9HT1AsCiAJLmF1ZGlvX2NvZGVjCT0gVjRM
Ml9NUEVHX0FVRElPX0VOQ09ESU5HX0FBQywKLQkuYnJpZ2h0bmVzcwk9IDB4ODYsCi0JLmNvbnRy
YXN0CT0gMHg4MCwKLQkuaHVlCQk9IDB4ODAsCi0JLnNhdHVyYXRpb24JPSAweDgwLAorCS5icmln
aHRuZXNzCT0gMHg4MCwKKwkuY29udHJhc3QJPSAweDQwLAorCS5odWUJCT0gMHhmLAorCS5zYXR1
cmF0aW9uCT0gMHg0MCwKIAkuc2hhcnBuZXNzCT0gMHg4MCwKIH07CiAKZGlmZiAtciBhYmQzYWFj
NjY0NGUgbGludXgvZHJpdmVycy9tZWRpYS92aWRlby9oZHB2ci9oZHB2ci12aWRlby5jCi0tLSBh
L2xpbnV4L2RyaXZlcnMvbWVkaWEvdmlkZW8vaGRwdnIvaGRwdnItdmlkZW8uYwlGcmkgSnVsIDAy
IDAwOjM4OjU0IDIwMTAgLTAzMDAKKysrIGIvbGludXgvZHJpdmVycy9tZWRpYS92aWRlby9oZHB2
ci9oZHB2ci12aWRlby5jCVRodSBPY3QgMjAgMTE6MTQ6MjUgMjAxMSAtMDQwMApAQCAtNzMxLDEz
ICs3MzEsMTMgQEAKIAogCXN3aXRjaCAocWMtPmlkKSB7CiAJY2FzZSBWNEwyX0NJRF9CUklHSFRO
RVNTOgotCQlyZXR1cm4gdjRsMl9jdHJsX3F1ZXJ5X2ZpbGwocWMsIDB4MCwgMHhmZiwgMSwgMHg4
Nik7CisJCXJldHVybiB2NGwyX2N0cmxfcXVlcnlfZmlsbChxYywgMHgwLCAweGZmLCAxLCAweDgw
KTsKIAljYXNlIFY0TDJfQ0lEX0NPTlRSQVNUOgotCQlyZXR1cm4gdjRsMl9jdHJsX3F1ZXJ5X2Zp
bGwocWMsIDB4MCwgMHhmZiwgMSwgMHg4MCk7CisJCXJldHVybiB2NGwyX2N0cmxfcXVlcnlfZmls
bChxYywgMHgwLCAweGZmLCAxLCAweDQwKTsKIAljYXNlIFY0TDJfQ0lEX1NBVFVSQVRJT046Ci0J
CXJldHVybiB2NGwyX2N0cmxfcXVlcnlfZmlsbChxYywgMHgwLCAweGZmLCAxLCAweDgwKTsKKwkJ
cmV0dXJuIHY0bDJfY3RybF9xdWVyeV9maWxsKHFjLCAweDAsIDB4ZmYsIDEsIDB4NDApOwogCWNh
c2UgVjRMMl9DSURfSFVFOgotCQlyZXR1cm4gdjRsMl9jdHJsX3F1ZXJ5X2ZpbGwocWMsIDB4MCwg
MHhmZiwgMSwgMHg4MCk7CisJCXJldHVybiB2NGwyX2N0cmxfcXVlcnlfZmlsbChxYywgMHgwLCAw
eDFlLCAxLCAweGYpOwogCWNhc2UgVjRMMl9DSURfU0hBUlBORVNTOgogCQlyZXR1cm4gdjRsMl9j
dHJsX3F1ZXJ5X2ZpbGwocWMsIDB4MCwgMHhmZiwgMSwgMHg4MCk7CiAJY2FzZSBWNEwyX0NJRF9N
UEVHX0FVRElPX0VOQ09ESU5HOgo=
--0016e6dee805858dce04afbc8dc7--
