Return-path: <linux-media-owner@vger.kernel.org>
Received: from acorn.exetel.com.au ([220.233.0.21]:42019 "EHLO
	acorn.exetel.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754893AbZLOXtx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Dec 2009 18:49:53 -0500
Message-ID: <1328.64.213.30.2.1260920972.squirrel@webmail.exetel.com.au>
In-Reply-To: <36364.64.213.30.2.1260252173.squirrel@webmail.exetel.com.au>
References: <33305.64.213.30.2.1259216241.squirrel@webmail.exetel.com.au>
    <50104.115.70.135.213.1259224041.squirrel@webmail.exetel.com.au>
    <702870ef0911260137r35f1784exc27498d0db3769c2@mail.gmail.com>
    <56069.115.70.135.213.1259234530.squirrel@webmail.exetel.com.au>
    <46566.64.213.30.2.1259278557.squirrel@webmail.exetel.com.au>
    <702870ef0912010118r1e5e3been840726e6364d991a@mail.gmail.com>
    <829197380912020657v52e42690k46172f047ebd24b0@mail.gmail.com>
    <36364.64.213.30.2.1260252173.squirrel@webmail.exetel.com.au>
Date: Wed, 16 Dec 2009 10:49:32 +1100 (EST)
Subject: Re: [RESEND] Re: DViCO FusionHDTV DVB-T Dual Digital 4 (rev 1)
     tuning      regression
From: "Robert Lowery" <rglowery@exemail.com.au>
To: mchehab@redhat.com
Cc: "Devin Heitmueller" <dheitmueller@kernellabs.com>,
	"Vincent McIntyre" <vincent.mcintyre@gmail.com>,
	terrywu2009@gmail.com, awalls@radix.net,
	linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/mixed;boundary="----=_20091216104932_67007"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

------=_20091216104932_67007
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit

Mauro,

I've split the revert2.diff that I sent you previously to fix the tuning
regression on my DViCO Dual Digital 4 (rev 1) into three separate patches
that will hopefully allow you to review more easily.

The first two patches revert their respective changesets and nothing else,
fixing the issue for me.
12167:966ce12c444d tuner-xc2028: Fix 7 MHz DVB-T
11918:e6a8672631a0 tuner-xc2028: Fix offset frequencies for DVB @ 6MHz

The third patch does what I believe is the obvious equivalent fix to
e6a8672631a0 but without the cleanup that breaks tuning on my card.

Please review and merge

Signed-off-by: Robert Lowery <rglowery@exemail.com.au>

Thanks

-Rob

------=_20091216104932_67007
Content-Type: /; name="01_revert_966ce12c444d.diff"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="01_revert_966ce12c444d.diff"

ZGlmZiAtciAzMmIyYTE4NzU3NTIgbGludXgvZHJpdmVycy9tZWRpYS9jb21tb24vdHVuZXJzL3R1
bmVyLXhjMjAyOC5jCi0tLSBhL2xpbnV4L2RyaXZlcnMvbWVkaWEvY29tbW9uL3R1bmVycy90dW5l
ci14YzIwMjguYwlGcmkgTm92IDIwIDEyOjQ3OjQwIDIwMDkgKzAxMDAKKysrIGIvbGludXgvZHJp
dmVycy9tZWRpYS9jb21tb24vdHVuZXJzL3R1bmVyLXhjMjAyOC5jCUZyaSBOb3YgMjcgMTA6Mjk6
MjIgMjAwOSArMTEwMApAQCAtMTExNCwxOSArMTEwOCw4IEBACiAJfQogCiAJLyogQWxsIFMtY29k
ZSB0YWJsZXMgbmVlZCBhIDIwMGtIeiBzaGlmdCAqLwotCWlmIChwcml2LT5jdHJsLmRlbW9kKSB7
CisJaWYgKHByaXYtPmN0cmwuZGVtb2QpCiAJCWRlbW9kID0gcHJpdi0+Y3RybC5kZW1vZCArIDIw
MDsKLQkJLyoKLQkJICogVGhlIERUVjcgUy1jb2RlIHRhYmxlIG5lZWRzIGEgNzAwIGtIeiBzaGlm
dC4KLQkJICogVGhhbmtzIHRvIFRlcnJ5IFd1IDx0ZXJyeXd1MjAwOUBnbWFpbC5jb20+IGZvciBy
ZXBvcnRpbmcgdGhpcwotCQkgKgotCQkgKiBEVFY3IGlzIG9ubHkgdXNlZCBpbiBBdXN0cmFsaWEu
ICBHZXJtYW55IG9yIEl0YWx5IG1heSBhbHNvCi0JCSAqIHVzZSB0aGlzIGZpcm13YXJlIGFmdGVy
IGluaXRpYWxpemF0aW9uLCBidXQgYSB0dW5lIHRvIGEgVUhGCi0JCSAqIGNoYW5uZWwgc2hvdWxk
IHRoZW4gY2F1c2UgRFRWNzggdG8gYmUgdXNlZC4KLQkJICovCi0JCWlmICh0eXBlICYgRFRWNykK
LQkJCWRlbW9kICs9IDUwMDsKLQl9CiAKIAlyZXR1cm4gZ2VuZXJpY19zZXRfZnJlcShmZSwgcC0+
ZnJlcXVlbmN5LAogCQkJCVRfRElHSVRBTF9UViwgdHlwZSwgMCwgZGVtb2QpOwo=
------=_20091216104932_67007
Content-Type: /; name="02_revert_e6a8672631a0.diff"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="02_revert_e6a8672631a0.diff"

ZGlmZiAtciAzMmIyYTE4NzU3NTIgbGludXgvZHJpdmVycy9tZWRpYS9jb21tb24vdHVuZXJzL3R1
bmVyLXhjMjAyOC5jCi0tLSBhL2xpbnV4L2RyaXZlcnMvbWVkaWEvY29tbW9uL3R1bmVycy90dW5l
ci14YzIwMjguYwlGcmkgTm92IDIwIDEyOjQ3OjQwIDIwMDkgKzAxMDAKKysrIGIvbGludXgvZHJp
dmVycy9tZWRpYS9jb21tb24vdHVuZXJzL3R1bmVyLXhjMjAyOC5jCUZyaSBOb3YgMjcgMTA6Mjk6
MjIgMjAwOSArMTEwMApAQCAtOTM0LDI5ICs5MzQsMjMgQEAKIAkgKiB0aGF0IHhjMjAyOCB3aWxs
IGJlIGluIGEgc2FmZSBzdGF0ZS4KIAkgKiBNYXliZSB0aGlzIG1pZ2h0IGFsc28gYmUgbmVlZGVk
IGZvciBEVFYuCiAJICovCi0JaWYgKG5ld19tb2RlID09IFRfQU5BTE9HX1RWKQorCWlmIChuZXdf
bW9kZSA9PSBUX0FOQUxPR19UVikgewogCQlyYyA9IHNlbmRfc2VxKHByaXYsIHsweDAwLCAweDAw
fSk7Ci0KLQkvKgotCSAqIERpZ2l0YWwgbW9kZXMgcmVxdWlyZSBhbiBvZmZzZXQgdG8gYWRqdXN0
IHRvIHRoZQotCSAqIHByb3BlciBmcmVxdWVuY3kuCi0JICogQW5hbG9nIG1vZGVzIHJlcXVpcmUg
b2Zmc2V0ID0gMAotCSAqLwotCWlmIChuZXdfbW9kZSA9PSBUX0RJR0lUQUxfVFYpIHsKLQkJLyog
U2V0cyB0aGUgb2Zmc2V0IGFjY29yZGluZyB3aXRoIGZpcm13YXJlICovCi0JCWlmIChwcml2LT5j
dXJfZncudHlwZSAmIERUVjYpCi0JCQlvZmZzZXQgPSAxNzUwMDAwOwotCQllbHNlIGlmIChwcml2
LT5jdXJfZncudHlwZSAmIERUVjcpCi0JCQlvZmZzZXQgPSAyMjUwMDAwOwotCQllbHNlCS8qIERU
Vjggb3IgRFRWNzggKi8KLQkJCW9mZnNldCA9IDI3NTAwMDA7Ci0KKwl9IGVsc2UgaWYgKHByaXYt
PmN1cl9mdy50eXBlICYgQVRTQykgeworCQlvZmZzZXQgPSAxNzUwMDAwOworCX0gZWxzZSB7CisJ
CW9mZnNldCA9IDI3NTAwMDA7CisJCiAJCS8qCi0JCSAqIFdlIG11c3QgYWRqdXN0IHRoZSBvZmZz
ZXQgYnkgNTAwa0h6ICB3aGVuCi0JCSAqIHR1bmluZyBhIDdNSHogVkhGIGNoYW5uZWwgd2l0aCBE
VFY3OCBmaXJtd2FyZQotCQkgKiAodXNlZCBpbiBBdXN0cmFsaWEsIEl0YWx5IGFuZCBHZXJtYW55
KQorCQkgKiBXZSBtdXN0IGFkanVzdCB0aGUgb2Zmc2V0IGJ5IDUwMGtIeiBpbiB0d28gY2FzZXMg
aW4gb3JkZXIKKwkJICogdG8gY29ycmVjdGx5IGNlbnRlciB0aGUgSUYgb3V0cHV0OgorCQkgKiAx
KSBXaGVuIHRoZSBaQVJMSU5LNDU2IG9yIERJQkNPTTUyIHRhYmxlcyB3ZXJlIGV4cGxpY2l0bHkK
KwkJICogICAgc2VsZWN0ZWQgYW5kIGEgN01IeiBjaGFubmVsIGlzIHR1bmVkOworCQkgKiAyKSBX
aGVuIHR1bmluZyBhIFZIRiBjaGFubmVsIHdpdGggRFRWNzggZmlybXdhcmUuCiAJCSAqLwotCQlp
ZiAoKHByaXYtPmN1cl9mdy50eXBlICYgRFRWNzgpICYmIGZyZXEgPCA0NzAwMDAwMDApCisJCWlm
ICgoKHByaXYtPmN1cl9mdy50eXBlICYgRFRWNykgJiYKKwkJICAgICAocHJpdi0+Y3VyX2Z3LnNj
b2RlX3RhYmxlICYgKFpBUkxJTks0NTYgfCBESUJDT001MikpKSB8fAorCQkgICAgKChwcml2LT5j
dXJfZncudHlwZSAmIERUVjc4KSAmJiBmcmVxIDwgNDcwMDAwMDAwKSkKIAkJCW9mZnNldCAtPSA1
MDAwMDA7CiAJfQo=
------=_20091216104932_67007
Content-Type: /; name="03_refix_e6a8672631a0.diff"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="03_refix_e6a8672631a0.diff"

ZGlmZiAtciAzMmIyYTE4NzU3NTIgbGludXgvZHJpdmVycy9tZWRpYS9jb21tb24vdHVuZXJzL3R1
bmVyLXhjMjAyOC5jCi0tLSBhL2xpbnV4L2RyaXZlcnMvbWVkaWEvY29tbW9uL3R1bmVycy90dW5l
ci14YzIwMjguYwlGcmkgTm92IDIwIDEyOjQ3OjQwIDIwMDkgKzAxMDAKKysrIGIvbGludXgvZHJp
dmVycy9tZWRpYS9jb21tb24vdHVuZXJzL3R1bmVyLXhjMjAyOC5jCUZyaSBOb3YgMjcgMTA6Mjk6
MjIgMjAwOSArMTEwMApAQCAtOTM2LDcgKzkzNiw3IEBADQogCSAqLw0KIAlpZiAobmV3X21vZGUg
PT0gVF9BTkFMT0dfVFYpIHsNCiAJCXJjID0gc2VuZF9zZXEocHJpdiwgezB4MDAsIDB4MDB9KTsN
Ci0JfSBlbHNlIGlmIChwcml2LT5jdXJfZncudHlwZSAmIEFUU0MpIHsNCisJfSBlbHNlIGlmIChw
cml2LT5jdXJfZncudHlwZSAmIERUVjYpIHsNCiAJCW9mZnNldCA9IDE3NTAwMDA7DQogCX0gZWxz
ZSB7DQogCQlvZmZzZXQgPSAyNzUwMDAwOw0K
------=_20091216104932_67007--


