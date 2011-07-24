Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f171.google.com ([209.85.215.171]:64170 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624Ab1GXUHJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Jul 2011 16:07:09 -0400
Received: by eye22 with SMTP id 22so3148865eye.2
        for <linux-media@vger.kernel.org>; Sun, 24 Jul 2011 13:07:07 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 24 Jul 2011 16:07:07 -0400
Message-ID: <CAGoCfiz4Ry27iYDZqMLwM_kK=6y0Wgu8kDeBPhsdQ_2txndwMA@mail.gmail.com>
Subject: [PATCH] cx231xx: Provide signal lock status in G_INPUT
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: multipart/mixed; boundary=0015174c3c8c391a1704a8d63e91
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--0015174c3c8c391a1704a8d63e91
Content-Type: text/plain; charset=ISO-8859-1

The attached patch reports the signal lock statistics to userland,
which allows apps to know if there is a signal present even in cases
where it cannot rely on G_TUNER since it won't make calls for such if
the device lacks a tuner.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com

--0015174c3c8c391a1704a8d63e91
Content-Type: text/x-patch; charset=US-ASCII; name="cx231xx_sigstate.patch"
Content-Disposition: attachment; filename="cx231xx_sigstate.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gqifv8570

Y3gyMzF4eDogc2hvdyByZWFsIHNpZ25hbCBzdGF0dXMgaW4gR19JTlBVVC9FTlVNX0lOUFVUIGlv
Y3RsIHJlc3VsdHMKCkZyb206IERldmluIEhlaXRtdWVsbGVyIDxkaGVpdG11ZWxsZXJAa2VybmVs
bGFicy5jb20+CgpNYWtlIHVzZSBvZiB0aGUgc2lnbmFsIHN0YXRlIHJlZ2lzdGVycyB0byBwcm9w
ZXJseSBwb3B1bGF0ZSB0aGUgc2lnbmFsIGxvY2sKcmVnaXN0ZXJzIGluIHRoZSBjeDIzMXh4IGRy
aXZlci4KClRoaXMgYWxsb3dzIGFwcGxpY2F0aW9ucyB0byBrbm93IHdoZXRoZXIgdGhlcmUgaXMg
YSBzaWduYWwgcHJlc2VudCBldmVuIGluCmRldmljZXMgd2hpY2ggbGFjayBhIHR1bmVyIChzaW5j
ZSBzdWNoIGFwcHMgdHlwaWNhbGx5IHdvbid0IGNhbGwgR19UVU5FUiBpZgpubyB0dW5lciBpcyBw
cmVzZW50KS4KClNpZ25lZC1vZmYtYnk6IERldmluIEhlaXRtdWVsbGVyIDxkaGVpdG11ZWxsZXJA
a2VybmVsbGFicy5jb20+CgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9tZWRpYS92aWRlby9jeDIzMXh4
L2N4MjMxeHgtdmlkZW8uYyBiL2RyaXZlcnMvbWVkaWEvdmlkZW8vY3gyMzF4eC9jeDIzMXh4LXZp
ZGVvLmMKaW5kZXggYTY5YzI0ZC4uOWVkNTZiNyAxMDA2NDQKLS0tIGEvZHJpdmVycy9tZWRpYS92
aWRlby9jeDIzMXh4L2N4MjMxeHgtdmlkZW8uYworKysgYi9kcml2ZXJzL21lZGlhL3ZpZGVvL2N4
MjMxeHgvY3gyMzF4eC12aWRlby5jCkBAIC0xMTc5LDcgKzExNzksOCBAQCBzdGF0aWMgaW50IHZp
ZGlvY19lbnVtX2lucHV0KHN0cnVjdCBmaWxlICpmaWxlLCB2b2lkICpwcml2LAogewogCXN0cnVj
dCBjeDIzMXh4X2ZoICpmaCA9IHByaXY7CiAJc3RydWN0IGN4MjMxeHggKmRldiA9IGZoLT5kZXY7
Ci0JdW5zaWduZWQgaW50IG47CisJdTMyIGdlbl9zdGF0OworCXVuc2lnbmVkIGludCByZXQsIG47
CiAKIAluID0gaS0+aW5kZXg7CiAJaWYgKG4gPj0gTUFYX0NYMjMxWFhfSU5QVVQpCkBAIC0xMTk4
LDYgKzExOTksMjAgQEAgc3RhdGljIGludCB2aWRpb2NfZW51bV9pbnB1dChzdHJ1Y3QgZmlsZSAq
ZmlsZSwgdm9pZCAqcHJpdiwKIAogCWktPnN0ZCA9IGRldi0+dmRldi0+dHZub3JtczsKIAorCS8q
IElmIHRoZXkgYXJlIGFza2luZyBhYm91dCB0aGUgYWN0aXZlIGlucHV0LCByZWFkIHNpZ25hbCBz
dGF0dXMgKi8KKwlpZiAobiA9PSBkZXYtPnZpZGVvX2lucHV0KSB7CisJCXJldCA9IGN4MjMxeHhf
cmVhZF9pMmNfZGF0YShkZXYsIFZJRF9CTEtfSTJDX0FERFJFU1MsCisJCQkJCSAgICBHRU5fU1RB
VCwgMiwgJmdlbl9zdGF0LCA0KTsKKwkJaWYgKHJldCA+IDApIHsKKwkJCWlmICgoZ2VuX3N0YXQg
JiBGTERfVlBSRVMpID09IDB4MDApIHsKKwkJCQlpLT5zdGF0dXMgfD0gVjRMMl9JTl9TVF9OT19T
SUdOQUw7CisJCQl9CisJCQlpZiAoKGdlbl9zdGF0ICYgRkxEX0hMT0NLKSA9PSAweDAwKSB7CisJ
CQkJaS0+c3RhdHVzIHw9IFY0TDJfSU5fU1RfTk9fSF9MT0NLOworCQkJfQorCQl9CisJfQorCiAJ
cmV0dXJuIDA7CiB9CiAK
--0015174c3c8c391a1704a8d63e91--
