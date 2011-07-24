Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f171.google.com ([209.85.215.171]:55245 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074Ab1GXUXL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Jul 2011 16:23:11 -0400
Received: by eye22 with SMTP id 22so3151795eye.2
        for <linux-media@vger.kernel.org>; Sun, 24 Jul 2011 13:23:10 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 24 Jul 2011 16:23:09 -0400
Message-ID: <CAGoCfizrzVgDpA_wjk84yWQFrYcH+8F4bbQ5gQ=mja5mgGZkaA@mail.gmail.com>
Subject: [PATCH] au8522: set signal field to 100% when signal present
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: multipart/mixed; boundary=00504502c8739a90bb04a8d67782
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--00504502c8739a90bb04a8d67782
Content-Type: text/plain; charset=ISO-8859-1

This patch makes the HVR-950q behave consistently with other drivers,
which is to show the signal level as 100% in cases where we have a
signal present but given we are unable to determine an actual signal
level.  The old code would set the value to "1", which divided by
65535 is rounded down to 0%.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com

--00504502c8739a90bb04a8d67782
Content-Type: text/x-patch; charset=US-ASCII; name="au8522_sig_scale.patch"
Content-Disposition: attachment; filename="au8522_sig_scale.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gqigd9zv0

YXU4NTIyOiBzZXQgc2lnbmFsIGZpZWxkIHRvIDEwMCUgd2hlbiBzaWduYWwgcHJlc2VudAoKRnJv
bTogRGV2aW4gSGVpdG11ZWxsZXIgPGRoZWl0bXVlbGxlckBrZXJuZWxsYWJzLmNvbT4KClRoZSBz
aWduYWwgc3RhdGUgZmllbGQgaW4gR19UVU5FUiBpcyB0eXBpY2FsbHkgc2NhbGVkIGZyb20gMC0x
MDAlLiAgU2luY2Ugd2UKZG9uJ3Qga25vdyB0aGUgc2lnbmFsIGxldmVsLCB3ZSByZWFsbHkgd291
bGQgcHJlZmVyIHRoZSBmaWVsZCB0byBjb250YWluIDEwMCUKdGhhbiAxLzI1Niwgd2hpY2ggaW4g
bWFueSB1dGlsaXRpZXMgKHN1Y2ggYXMgdjRsMi1jdGwpIHJvdW5kcyB0byAwJSBldmVuIHdoZW4K
YSBzaWduYWwgaXMgYWN0dWFsbHkgcHJlc2VudC4KClRoaXMgcGF0Y2ggbWFrZXMgdGhlIGJlaGF2
aW9yIGNvbnNpc3RlbnQgd2l0aCBvdGhlciBkcml2ZXJzLgoKU2lnbmVkLW9mZi1ieTogRGV2aW4g
SGVpdG11ZWxsZXIgPGRoZWl0bXVlbGxlckBrZXJuZWxsYWJzLmNvbT4KCmRpZmYgLS1naXQgYS9k
cml2ZXJzL21lZGlhL2R2Yi9mcm9udGVuZHMvYXU4NTIyX2RlY29kZXIuYyBiL2RyaXZlcnMvbWVk
aWEvZHZiL2Zyb250ZW5kcy9hdTg1MjJfZGVjb2Rlci5jCmluZGV4IGI1Mzc4OTEuLjJiMjQ4YzEg
MTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbWVkaWEvZHZiL2Zyb250ZW5kcy9hdTg1MjJfZGVjb2Rlci5j
CisrKyBiL2RyaXZlcnMvbWVkaWEvZHZiL2Zyb250ZW5kcy9hdTg1MjJfZGVjb2Rlci5jCkBAIC02
OTIsNyArNjkyLDcgQEAgc3RhdGljIGludCBhdTg1MjJfZ190dW5lcihzdHJ1Y3QgdjRsMl9zdWJk
ZXYgKnNkLCBzdHJ1Y3QgdjRsMl90dW5lciAqdnQpCiAJLyogSW50ZXJyb2dhdGUgdGhlIGRlY29k
ZXIgdG8gc2VlIGlmIHdlIGFyZSBnZXR0aW5nIGEgcmVhbCBzaWduYWwgKi8KIAlsb2NrX3N0YXR1
cyA9IGF1ODUyMl9yZWFkcmVnKHN0YXRlLCAweDAwKTsKIAlpZiAobG9ja19zdGF0dXMgPT0gMHhh
MikKLQkJdnQtPnNpZ25hbCA9IDB4MDE7CisJCXZ0LT5zaWduYWwgPSAweGZmZmY7CiAJZWxzZQog
CQl2dC0+c2lnbmFsID0gMHgwMDsKIAo=
--00504502c8739a90bb04a8d67782--
