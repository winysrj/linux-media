Return-path: <mchehab@localhost>
Received: from fallback2.mail.ru ([94.100.176.87]:48410 "EHLO
	fallback2.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754561Ab1GJQjr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jul 2011 12:39:47 -0400
Received: from smtp19.mail.ru (smtp19.mail.ru [94.100.176.156])
	by fallback2.mail.ru (mPOP.Fallback_MX) with ESMTP id 33FAE6483980
	for <linux-media@vger.kernel.org>; Sun, 10 Jul 2011 20:32:41 +0400 (MSD)
Message-ID: <4E19D2F7.6060803@list.ru>
Date: Sun, 10 Jul 2011 20:27:35 +0400
From: Stas Sergeev <stsp@list.ru>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: "Nickolay V. Shmyrev" <nshmyrev@yandex.ru>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [patch][saa7134] do not change mute state for capturing audio
Content-Type: multipart/mixed;
 boundary="------------090305090308040906020300"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

This is a multi-part message in MIME format.
--------------090305090308040906020300
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi.

When pulseaudio enables the audio capturing, the
driver unmutes the sound. But, if no app have properly
tuned the tuner yet, you get the white noise.
I think the capturing must not touch the mute state,
because, without tuning the tuner first, you can't capture
anything anyway.
Without this patch I am getting the white noise on every
xorg/pulseaudio startup, which made me to always think
that pulseaudio is a joke and will soon be removed. :)

Signed-off-by: Stas Sergeev <stsp@list.ru>

--------------090305090308040906020300
Content-Type: text/plain;
 name="saa_mute.diff"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="saa_mute.diff"

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWVkaWEvdmlkZW8vc2FhNzEzNC9zYWE3MTM0LWFsc2Eu
YyBiL2RyaXZlcnMvbWVkaWEvdmlkZW8vc2FhNzEzNC9zYWE3MTM0LWFsc2EuYwppbmRleCAx
MDQ2MGZkLi5kNTY2NDY4IDEwMDY0NAotLS0gYS9kcml2ZXJzL21lZGlhL3ZpZGVvL3NhYTcx
MzQvc2FhNzEzNC1hbHNhLmMKKysrIGIvZHJpdmVycy9tZWRpYS92aWRlby9zYWE3MTM0L3Nh
YTcxMzQtYWxzYS5jCkBAIC03Nyw3ICs3Nyw2IEBAIHR5cGVkZWYgc3RydWN0IHNuZF9jYXJk
X3NhYTcxMzQgewogCiAJdW5zaWduZWQgbG9uZyBpb2Jhc2U7CiAJczE2IGlycTsKLQl1MTYg
bXV0ZV93YXNfb247CiAKIAlzcGlubG9ja190IGxvY2s7CiB9IHNuZF9jYXJkX3NhYTcxMzRf
dDsKQEAgLTcxNSwxMyArNzE0LDYgQEAgc3RhdGljIGludCBzbmRfY2FyZF9zYWE3MTM0X2h3
X2ZyZWUoc3RydWN0IHNuZF9wY21fc3Vic3RyZWFtICogc3Vic3RyZWFtKQogCiBzdGF0aWMg
aW50IHNuZF9jYXJkX3NhYTcxMzRfY2FwdHVyZV9jbG9zZShzdHJ1Y3Qgc25kX3BjbV9zdWJz
dHJlYW0gKiBzdWJzdHJlYW0pCiB7Ci0Jc25kX2NhcmRfc2FhNzEzNF90ICpzYWE3MTM0ID0g
c25kX3BjbV9zdWJzdHJlYW1fY2hpcChzdWJzdHJlYW0pOwotCXN0cnVjdCBzYWE3MTM0X2Rl
diAqZGV2ID0gc2FhNzEzNC0+ZGV2OwotCi0JaWYgKHNhYTcxMzQtPm11dGVfd2FzX29uKSB7
Ci0JCWRldi0+Y3RsX211dGUgPSAxOwotCQlzYWE3MTM0X3R2YXVkaW9fc2V0bXV0ZShkZXYp
OwotCX0KIAlyZXR1cm4gMDsKIH0KIApAQCAtNzc0LDEyICs3NjYsNiBAQCBzdGF0aWMgaW50
IHNuZF9jYXJkX3NhYTcxMzRfY2FwdHVyZV9vcGVuKHN0cnVjdCBzbmRfcGNtX3N1YnN0cmVh
bSAqIHN1YnN0cmVhbSkKIAlydW50aW1lLT5wcml2YXRlX2ZyZWUgPSBzbmRfY2FyZF9zYWE3
MTM0X3J1bnRpbWVfZnJlZTsKIAlydW50aW1lLT5odyA9IHNuZF9jYXJkX3NhYTcxMzRfY2Fw
dHVyZTsKIAotCWlmIChkZXYtPmN0bF9tdXRlICE9IDApIHsKLQkJc2FhNzEzNC0+bXV0ZV93
YXNfb24gPSAxOwotCQlkZXYtPmN0bF9tdXRlID0gMDsKLQkJc2FhNzEzNF90dmF1ZGlvX3Nl
dG11dGUoZGV2KTsKLQl9Ci0KIAllcnIgPSBzbmRfcGNtX2h3X2NvbnN0cmFpbnRfaW50ZWdl
cihydW50aW1lLAogCQkJCQkJU05EUlZfUENNX0hXX1BBUkFNX1BFUklPRFMpOwogCWlmIChl
cnIgPCAwKQo=
--------------090305090308040906020300--
