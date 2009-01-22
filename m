Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f11.google.com ([209.85.221.11]:48325 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755639AbZAVEpK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Jan 2009 23:45:10 -0500
Received: by qyk4 with SMTP id 4so4409639qyk.13
        for <linux-media@vger.kernel.org>; Wed, 21 Jan 2009 20:45:02 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 21 Jan 2009 23:45:02 -0500
Message-ID: <412bdbff0901212045t1287a403h57ba05cbd71d5224@mail.gmail.com>
Subject: [RFC] Need testers for s5h1409 tuning fix
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: multipart/mixed; boundary=0015175ce05e83a4e504610aefe7
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--0015175ce05e83a4e504610aefe7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

The attached patch significantly improves tuning lock times for all
three s5h1409 based devices I have tested with so far.  However,
because of the large number of devices affected, I would like to
solicit people with products that use the s5h1409 to test the patch
and report back any problems before it gets committed.

To test the patch, check out the latest v4l-dvb and apply the patch:

hg clone http://linuxtv.org/hg/v4l-dvb
cd v4l-dvb
patch -p1 < s5h1409_tuning_speedup.patch
make
make install
make unload
reboot

Based on the data collected thus far, this patch should address some
long-standing issues with long times to reach tuning lock and
intermittent lock failures.

Comments welcome.

Thanks,

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

--0015175ce05e83a4e504610aefe7
Content-Type: text/x-diff; charset=US-ASCII; name="s5h1409_tuning_speedup.patch"
Content-Disposition: attachment; filename="s5h1409_tuning_speedup.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fq8xobfp0

czVoMTQwOTogUGVyZm9ybSBzNWgxNDA5IHNvZnQgcmVzZXQgYWZ0ZXIgdHVuaW5nCgpGcm9tOiBE
ZXZpbiBIZWl0bXVlbGxlciA8ZGhlaXRtdWVsbGVyQGxpbnV4dHYub3JnPgoKSnVzdCBsaWtlIHdp
dGggdGhlIHM1aDE0MTEsIHRoZSBzNWgxNDA5IG5lZWRzIGEgc29mdC1yZXNldCBpbiBvcmRlciBm
b3IgaXQKdG8ga25vdyB0aGF0IHRoZSB0dW5lciBoYXMgYmVlbiB0b2xkIHRvIGNoYW5nZSBmcmVx
dWVuY2llcy4gIFRoaXMgY2hhbmdlCmNoYW5nZXMgdGhlIGJlaGF2aW9yIGZyb20gInJhbmRvbSB0
dW5pbmcgdGltZXMgYmV0d2VlbiA1MDBtcyB0byBjb21wbGV0ZSAKdHVuaW5nIGxvY2sgZmFpbHVy
ZXMiIHRvICJ0dW5pbmcgbG9jayBjb25zaXN0ZW50bHkgd2l0aGluIDcwMG1zIi4KClRoYW5rcyB0
byBSb2JlcnQgS3Jha29yYSA8cm9iLmtyYWtvcmFAbWVzc2FnZW5ldHN5c3RlbXMuY29tPiBmb3Ig
ZG9pbmcgCmluaXRpYWwgdGVzdGluZyBvZiB0aGUgcGF0Y2ggb24gdGhlIEtXb3JsZCAzMzBVLgoK
U2lnbmVkLW9mZi1ieTogRGV2aW4gSGVpdG11ZWxsZXIgPGRoZWl0bXVlbGxlckBsaW51eHR2Lm9y
Zz4KZGlmZiAtciA0YTA2YjVjMzM0NGYgbGludXgvZHJpdmVycy9tZWRpYS9kdmIvZnJvbnRlbmRz
L3M1aDE0MDkuYwotLS0gYS9saW51eC9kcml2ZXJzL21lZGlhL2R2Yi9mcm9udGVuZHMvczVoMTQw
OS5jCU1vbiBEZWMgMjkgMjI6MTc6MDkgMjAwOCAtMDUwMAorKysgYi9saW51eC9kcml2ZXJzL21l
ZGlhL2R2Yi9mcm9udGVuZHMvczVoMTQwOS5jCU1vbiBKYW4gMTkgMTk6NTA6MjkgMjAwOSAtMDUw
MApAQCAtNTQ1LDkgKzU0NSw2IEBACiAKIAlzNWgxNDA5X2VuYWJsZV9tb2R1bGF0aW9uKGZlLCBw
LT51LnZzYi5tb2R1bGF0aW9uKTsKIAotCS8qIEFsbG93IHRoZSBkZW1vZCB0byBzZXR0bGUgKi8K
LQltc2xlZXAoMTAwKTsKLQogCWlmIChmZS0+b3BzLnR1bmVyX29wcy5zZXRfcGFyYW1zKSB7CiAJ
CWlmIChmZS0+b3BzLmkyY19nYXRlX2N0cmwpCiAJCQlmZS0+b3BzLmkyY19nYXRlX2N0cmwoZmUs
IDEpOwpAQCAtNTYxLDYgKzU1OCwxMCBAQAogCQlzNWgxNDA5X3NldF9xYW1fYW1odW1fbW9kZShm
ZSk7CiAJCXM1aDE0MDlfc2V0X3FhbV9pbnRlcmxlYXZlX21vZGUoZmUpOwogCX0KKworCS8qIElz
c3VlIGEgcmVzZXQgdG8gdGhlIGRlbW9kIHNvIGl0IGtub3dzIHRvIHJlc3luYyBhZ2FpbnN0IHRo
ZQorCSAgIG5ld2x5IHR1bmVkIGZyZXF1ZW5jeSAqLworCXM1aDE0MDlfc29mdHJlc2V0KGZlKTsK
IAogCXJldHVybiAwOwogfQo=
--0015175ce05e83a4e504610aefe7--
