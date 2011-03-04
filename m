Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46314 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932569Ab1CDWoM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Mar 2011 17:44:12 -0500
Received: by wwb22 with SMTP id 22so3286726wwb.1
        for <linux-media@vger.kernel.org>; Fri, 04 Mar 2011 14:44:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4D7163FD.9030604@iki.fi>
References: <AANLkTi=rcfL_pku9hhx68C_Fb_76KsW2Yy+Oys10a7+4@mail.gmail.com>
	<4D7163FD.9030604@iki.fi>
Date: Fri, 4 Mar 2011 22:44:11 +0000
Message-ID: <AANLkTimjC99zhJ=huHZiGgbENCoyHy5KT87iujjTT8w3@mail.gmail.com>
Subject: Re: [patch] Fix AF9015 Dual tuner i2c write failures
From: Andrew de Quincey <adq_dvb@lidskialf.net>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org
Content-Type: multipart/mixed; boundary=0016e6dab06b781824049dafe2ff
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

--0016e6dab06b781824049dafe2ff
Content-Type: text/plain; charset=ISO-8859-1

>> Adding a "bus lock" to af9015_i2c_xfer() will not work as demod/tuner
>> accesses will take multiple i2c transactions.
>>
>> Therefore, the following patch overrides the dvb_frontend_ops
>> functions to add a per-device lock around them: only one frontend can
>> now use the i2c bus at a time. Testing with the scripts above shows
>> this has eliminated the errors.
>
> This have annoyed me too, but since it does not broken functionality much I
> haven't put much effort for fixing it. I like that fix since it is in AF9015
> driver where it logically belongs to. But it looks still rather complex. I
> see you have also considered "bus lock" to af9015_i2c_xfer() which could be
> much smaller in code size (that's I have tried to implement long time back).
>
> I would like to ask if it possible to check I2C gate open / close inside
> af9015_i2c_xfer() and lock according that? Something like:

Hmm, I did think about that, but I felt overriding the functions was
just cleaner: I felt it was more obvious what it was doing. Doing
exactly this sort of tweaking was one of the main reasons we added
that function overriding feature.

I don't like the idea of returning "error locked by FE" since that'll
mean the tuning will randomly fail sometimes in a way visible to
userspace (unless we change the core dvb_frontend code), which was one
of the things I was trying to avoid. Unless, of course, I've
misunderstood your proposal.

However, looking at the code again, I realise it is possible to
simplify it. Since its only the demod gates that cause a problem, we
only /actually/ need to lock the get_frontend() and set_frontend()
calls.

Signed-off-by: Andrew de Quincey <adq_dvb@lidskialf.net>

--0016e6dab06b781824049dafe2ff
Content-Type: text/x-patch; charset=US-ASCII; name="af9015-fix-dual-tuner-v2.patch"
Content-Disposition: attachment; filename="af9015-fix-dual-tuner-v2.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gkvowtwh0

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWVkaWEvZHZiL2R2Yi11c2IvYWY5MDE1LmMgYi9kcml2ZXJz
L21lZGlhL2R2Yi9kdmItdXNiL2FmOTAxNS5jCmluZGV4IDMxYzBhMGUuLjUyYWM2ZWYgMTAwNjQ0
Ci0tLSBhL2RyaXZlcnMvbWVkaWEvZHZiL2R2Yi11c2IvYWY5MDE1LmMKKysrIGIvZHJpdmVycy9t
ZWRpYS9kdmIvZHZiLXVzYi9hZjkwMTUuYwpAQCAtMTA4Myw2ICsxMDgzLDM0IEBAIHN0YXRpYyBp
bnQgYWY5MDE1X2kyY19pbml0KHN0cnVjdCBkdmJfdXNiX2RldmljZSAqZCkKIAlyZXR1cm4gcmV0
OwogfQogCitzdGF0aWMgaW50IGFmOTAxNV9sb2NrX3NldF9mcm9udGVuZChzdHJ1Y3QgZHZiX2Zy
b250ZW5kKiBmZSwgc3RydWN0IGR2Yl9mcm9udGVuZF9wYXJhbWV0ZXJzKiBwYXJhbXMpCit7CisJ
aW50IHJlc3VsdDsKKwlzdHJ1Y3QgZHZiX3VzYl9hZGFwdGVyICphZGFwID0gZmUtPmR2Yi0+cHJp
djsKKwlzdHJ1Y3QgYWY5MDE1X3N0YXRlICpzdGF0ZSA9IGFkYXAtPmRldi0+cHJpdjsKKworCWlm
IChtdXRleF9sb2NrX2ludGVycnVwdGlibGUoJmFkYXAtPmRldi0+dXNiX211dGV4KSkKKwkJcmV0
dXJuIC1FQUdBSU47CisKKwlyZXN1bHQgPSBzdGF0ZS0+ZmVfb3BzW2FkYXAtPmlkXS5zZXRfZnJv
bnRlbmQoZmUsIHBhcmFtcyk7CisJbXV0ZXhfdW5sb2NrKCZhZGFwLT5kZXYtPnVzYl9tdXRleCk7
CisJcmV0dXJuIHJlc3VsdDsKK30KKyAgICAgICAgICAgICAgICAKK3N0YXRpYyBpbnQgYWY5MDE1
X2xvY2tfZ2V0X2Zyb250ZW5kKHN0cnVjdCBkdmJfZnJvbnRlbmQqIGZlLCBzdHJ1Y3QgZHZiX2Zy
b250ZW5kX3BhcmFtZXRlcnMqIHBhcmFtcykKK3sKKwlpbnQgcmVzdWx0OworCXN0cnVjdCBkdmJf
dXNiX2FkYXB0ZXIgKmFkYXAgPSBmZS0+ZHZiLT5wcml2OworCXN0cnVjdCBhZjkwMTVfc3RhdGUg
KnN0YXRlID0gYWRhcC0+ZGV2LT5wcml2OworCisJaWYgKG11dGV4X2xvY2tfaW50ZXJydXB0aWJs
ZSgmYWRhcC0+ZGV2LT51c2JfbXV0ZXgpKQorCQlyZXR1cm4gLUVBR0FJTjsKKworCXJlc3VsdCA9
IHN0YXRlLT5mZV9vcHNbYWRhcC0+aWRdLmdldF9mcm9udGVuZChmZSwgcGFyYW1zKTsKKwltdXRl
eF91bmxvY2soJmFkYXAtPmRldi0+dXNiX211dGV4KTsKKwlyZXR1cm4gcmVzdWx0OworfQorCiBz
dGF0aWMgaW50IGFmOTAxNV9hZjkwMTNfZnJvbnRlbmRfYXR0YWNoKHN0cnVjdCBkdmJfdXNiX2Fk
YXB0ZXIgKmFkYXApCiB7CiAJaW50IHJldDsKQEAgLTExMTYsNiArMTE0NCwxMiBAQCBzdGF0aWMg
aW50IGFmOTAxNV9hZjkwMTNfZnJvbnRlbmRfYXR0YWNoKHN0cnVjdCBkdmJfdXNiX2FkYXB0ZXIg
KmFkYXApCiAJLyogYXR0YWNoIGRlbW9kdWxhdG9yICovCiAJYWRhcC0+ZmUgPSBkdmJfYXR0YWNo
KGFmOTAxM19hdHRhY2gsICZhZjkwMTVfYWY5MDEzX2NvbmZpZ1thZGFwLT5pZF0sCiAJCWkyY19h
ZGFwKTsKKwkJCisJbWVtY3B5KCZzdGF0ZS0+ZmVfb3BzW2FkYXAtPmlkXSwgJmFkYXAtPmZlLT5v
cHMsIHNpemVvZihzdHJ1Y3QgZHZiX2Zyb250ZW5kX29wcykpOworCWlmIChhZGFwLT5mZS0+b3Bz
LnNldF9mcm9udGVuZCkKKwkJYWRhcC0+ZmUtPm9wcy5zZXRfZnJvbnRlbmQgPSBhZjkwMTVfbG9j
a19zZXRfZnJvbnRlbmQ7CisJaWYgKGFkYXAtPmZlLT5vcHMuZ2V0X2Zyb250ZW5kKQorCQlhZGFw
LT5mZS0+b3BzLmdldF9mcm9udGVuZCA9IGFmOTAxNV9sb2NrX2dldF9mcm9udGVuZDsKIAogCXJl
dHVybiBhZGFwLT5mZSA9PSBOVUxMID8gLUVOT0RFViA6IDA7CiB9CmRpZmYgLS1naXQgYS9kcml2
ZXJzL21lZGlhL2R2Yi9kdmItdXNiL2FmOTAxNS5oIGIvZHJpdmVycy9tZWRpYS9kdmIvZHZiLXVz
Yi9hZjkwMTUuaAppbmRleCBmMjBjZmE2Li43NTliYjNmIDEwMDY0NAotLS0gYS9kcml2ZXJzL21l
ZGlhL2R2Yi9kdmItdXNiL2FmOTAxNS5oCisrKyBiL2RyaXZlcnMvbWVkaWEvZHZiL2R2Yi11c2Iv
YWY5MDE1LmgKQEAgLTEwMiw2ICsxMDIsNyBAQCBzdHJ1Y3QgYWY5MDE1X3N0YXRlIHsKIAlzdHJ1
Y3QgaTJjX2FkYXB0ZXIgaTJjX2FkYXA7IC8qIEkyQyBhZGFwdGVyIGZvciAybmQgRkUgKi8KIAl1
OCByY19yZXBlYXQ7CiAJdTMyIHJjX2tleWNvZGU7CisJc3RydWN0IGR2Yl9mcm9udGVuZF9vcHMg
ZmVfb3BzWzJdOwogfTsKIAogc3RydWN0IGFmOTAxNV9jb25maWcgewo=
--0016e6dab06b781824049dafe2ff--
