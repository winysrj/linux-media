Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47977 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471Ab1LQA4v (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Dec 2011 19:56:51 -0500
Received: by eaaj10 with SMTP id j10so3359049eaa.19
        for <linux-media@vger.kernel.org>; Fri, 16 Dec 2011 16:56:49 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 17 Dec 2011 01:56:49 +0100
Message-ID: <CAEN_-SDCEA1Go3DQE4tyXdumrOfjirc3+4hD5Nbp5aEmJ76_rA@mail.gmail.com>
Subject: Fix mode mask setting in tuner_core for radio only tuners.
From: =?ISO-8859-2?Q?Miroslav_Sluge=F2?= <thunder.mmm@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: multipart/mixed; boundary=e0cb4efe30524c651c04b43f3187
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--e0cb4efe30524c651c04b43f3187
Content-Type: text/plain; charset=ISO-8859-1



--e0cb4efe30524c651c04b43f3187
Content-Type: text/x-patch; charset=UTF-8;
	name="0005-Fix-mode-mask-setting-in-tuner_core-for-radio-only-t.patch"
Content-Disposition: attachment;
	filename="0005-Fix-mode-mask-setting-in-tuner_core-for-radio-only-t.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gw9x2lt60

RnJvbSBlOGYyMjZiNjZkYzU4Mzk5YThkYWY4MDhiYTIwNGVjOTU2MmFiZDg1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNaXJvc2xhdiBTbHVnZcWIIDx0aHVuZGVyLm1AZW1haWwuY3o+
CkRhdGU6IE1vbiwgMTIgRGVjIDIwMTEgMDA6MTY6MjIgKzAxMDAKU3ViamVjdDogW1BBVENIXSBG
aXggbW9kZSBtYXNrIHNldHRpbmcgaW4gdHVuZXJfY29yZSBmb3IgcmFkaW8gb25seSB0dW5lcnMu
CgotLS0KIGRyaXZlcnMvbWVkaWEvdmlkZW8vdHVuZXItY29yZS5jIHwgICAgNCArKy0tCiAxIGZp
bGVzIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQg
YS9kcml2ZXJzL21lZGlhL3ZpZGVvL3R1bmVyLWNvcmUuYyBiL2RyaXZlcnMvbWVkaWEvdmlkZW8v
dHVuZXItY29yZS5jCmluZGV4IDExY2M5ODAuLjhlN2U3NjkgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMv
bWVkaWEvdmlkZW8vdHVuZXItY29yZS5jCisrKyBiL2RyaXZlcnMvbWVkaWEvdmlkZW8vdHVuZXIt
Y29yZS5jCkBAIC0zMTcsMTMgKzMxNywxMyBAQCBzdGF0aWMgdm9pZCBzZXRfdHlwZShzdHJ1Y3Qg
aTJjX2NsaWVudCAqYywgdW5zaWduZWQgaW50IHR5cGUsCiAJCWlmICghZHZiX2F0dGFjaCh0ZWE1
NzY3X2F0dGFjaCwgJnQtPmZlLAogCQkJCXQtPmkyYy0+YWRhcHRlciwgdC0+aTJjLT5hZGRyKSkK
IAkJCWdvdG8gYXR0YWNoX2ZhaWxlZDsKLQkJdC0+bW9kZV9tYXNrID0gVF9SQURJTzsKKwkJbmV3
X21vZGVfbWFzayA9IFRfUkFESU87CiAJCWJyZWFrOwogCWNhc2UgVFVORVJfVEVBNTc2MToKIAkJ
aWYgKCFkdmJfYXR0YWNoKHRlYTU3NjFfYXR0YWNoLCAmdC0+ZmUsCiAJCQkJdC0+aTJjLT5hZGFw
dGVyLCB0LT5pMmMtPmFkZHIpKQogCQkJZ290byBhdHRhY2hfZmFpbGVkOwotCQl0LT5tb2RlX21h
c2sgPSBUX1JBRElPOworCQluZXdfbW9kZV9tYXNrID0gVF9SQURJTzsKIAkJYnJlYWs7CiAJY2Fz
ZSBUVU5FUl9QSElMSVBTX0ZNRDEyMTZNRV9NSzM6CiAJCWJ1ZmZlclswXSA9IDB4MGI7Ci0tIAox
LjcuMi4zCgo=
--e0cb4efe30524c651c04b43f3187--
