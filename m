Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44343 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760230Ab1CEBoB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Mar 2011 20:44:01 -0500
Received: by wyg36 with SMTP id 36so2682301wyg.19
        for <linux-media@vger.kernel.org>; Fri, 04 Mar 2011 17:44:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTimHa6XFwhvpLbhtRm7Vee-jYPkHpx+D8L2=+vQb@mail.gmail.com>
References: <AANLkTi=rcfL_pku9hhx68C_Fb_76KsW2Yy+Oys10a7+4@mail.gmail.com>
	<4D7163FD.9030604@iki.fi>
	<AANLkTimjC99zhJ=huHZiGgbENCoyHy5KT87iujjTT8w3@mail.gmail.com>
	<4D716ECA.4060900@iki.fi>
	<AANLkTimHa6XFwhvpLbhtRm7Vee-jYPkHpx+D8L2=+vQb@mail.gmail.com>
Date: Sat, 5 Mar 2011 01:43:59 +0000
Message-ID: <AANLkTik9cSnAFWNdTUv3NNU3K2SoeECDO2036Htx-OAi@mail.gmail.com>
Subject: Re: [patch] Fix AF9015 Dual tuner i2c write failures
From: adq <adq@lidskialf.net>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org
Content-Type: multipart/mixed; boundary=0016e6dd8a668832ca049db26508
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

--0016e6dd8a668832ca049db26508
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 4 March 2011 23:11, Andrew de Quincey <adq_dvb@lidskialf.net> wrote:
> On 4 March 2011 22:59, Antti Palosaari <crope@iki.fi> wrote:
>> On 03/05/2011 12:44 AM, Andrew de Quincey wrote:
>>>>>
>>>>> Adding a "bus lock" to af9015_i2c_xfer() will not work as demod/tuner
>>>>> accesses will take multiple i2c transactions.
>>>>>
>>>>> Therefore, the following patch overrides the dvb_frontend_ops
>>>>> functions to add a per-device lock around them: only one frontend can
>>>>> now use the i2c bus at a time. Testing with the scripts above shows
>>>>> this has eliminated the errors.
>>>>
>>>> This have annoyed me too, but since it does not broken functionality m=
uch
>>>> I
>>>> haven't put much effort for fixing it. I like that fix since it is in
>>>> AF9015
>>>> driver where it logically belongs to. But it looks still rather comple=
x.
>>>> I
>>>> see you have also considered "bus lock" to af9015_i2c_xfer() which cou=
ld
>>>> be
>>>> much smaller in code size (that's I have tried to implement long time
>>>> back).
>>>>
>>>> I would like to ask if it possible to check I2C gate open / close insi=
de
>>>> af9015_i2c_xfer() and lock according that? Something like:
>>>
>>> Hmm, I did think about that, but I felt overriding the functions was
>>> just cleaner: I felt it was more obvious what it was doing. Doing
>>> exactly this sort of tweaking was one of the main reasons we added
>>> that function overriding feature.
>>>
>>> I don't like the idea of returning "error locked by FE" since that'll
>>> mean the tuning will randomly fail sometimes in a way visible to
>>> userspace (unless we change the core dvb_frontend code), which was one
>>> of the things I was trying to avoid. Unless, of course, I've
>>> misunderstood your proposal.
>>
>> Not returning error, but waiting in lock like that:
>> if (mutex_lock_interruptible(&d->i2c_mutex) < 0)
>> =A0return -EAGAIN;
>
> Ah k, sorry
>
>>> However, looking at the code again, I realise it is possible to
>>> simplify it. Since its only the demod gates that cause a problem, we
>>> only /actually/ need to lock the get_frontend() and set_frontend()
>>> calls.
>>
>> I don't understand why .get_frontend() causes problem, since it does not
>> access tuner at all. It only reads demod registers. The main problem is
>> (like schema in af9015.c shows) that there is two tuners on same I2C bus
>> using same address. And demod gate is only way to open access for desire=
d
>> tuner only.
>
> AFAIR /some/ tuner code accesses the tuner hardware to read the exact
> tuned frequency back on a get_frontend(); was just being extra
> paranoid :)
>
>> You should block traffic based of tuner not demod. And I think those
>> callbacks which are needed for override are tuner driver callbacks. Cons=
ider
>> situation device goes it v4l-core calls same time both tuner .sleep() =
=3D=3D
>> problem.
>
> Hmm, yeah, you're right, let me have another look tomorrow.
>

Hi, must admit I misunderstood your diagram originally, I thought it
was the demods AND the tuners that had the same i2c addresses.

As you say though. its just the tuners, so adding the locking into the
gate ctrl as you suggested makes perfect sense. Attached is v3
implementing this; it seems to be working fine here.

--0016e6dd8a668832ca049db26508
Content-Type: text/x-patch; charset=US-ASCII; name="af9015-fix-dual-tuner-v3.patch"
Content-Disposition: attachment; filename="af9015-fix-dual-tuner-v3.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gkvvd0o10

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWVkaWEvZHZiL2R2Yi11c2IvYWY5MDE1LmMgYi9kcml2ZXJz
L21lZGlhL2R2Yi9kdmItdXNiL2FmOTAxNS5jCmluZGV4IDMxYzBhMGUuLmQ5ZjMyZmUgMTAwNjQ0
Ci0tLSBhL2RyaXZlcnMvbWVkaWEvZHZiL2R2Yi11c2IvYWY5MDE1LmMKKysrIGIvZHJpdmVycy9t
ZWRpYS9kdmIvZHZiLXVzYi9hZjkwMTUuYwpAQCAtMTA4Myw2ICsxMDgzLDI0IEBAIHN0YXRpYyBp
bnQgYWY5MDE1X2kyY19pbml0KHN0cnVjdCBkdmJfdXNiX2RldmljZSAqZCkKIAlyZXR1cm4gcmV0
OwogfQogCitzdGF0aWMgaW50IGFmOTAxNV9sb2NrX2kyY19nYXRlX2N0cmwoc3RydWN0IGR2Yl9m
cm9udGVuZCAqZmUsIGludCBlbmFibGUpCit7CisJaW50IHJlc3VsdDsKKwlzdHJ1Y3QgZHZiX3Vz
Yl9hZGFwdGVyICphZGFwID0gZmUtPmR2Yi0+cHJpdjsKKwlzdHJ1Y3QgYWY5MDE1X3N0YXRlICpz
dGF0ZSA9IGFkYXAtPmRldi0+cHJpdjsKKworCWlmIChlbmFibGUpCisJCWlmIChtdXRleF9sb2Nr
X2ludGVycnVwdGlibGUoJmFkYXAtPmRldi0+dXNiX211dGV4KSkKKwkJCXJldHVybiAtRUFHQUlO
OworCisJcmVzdWx0ID0gc3RhdGUtPmkyY19nYXRlX2N0cmxbYWRhcC0+aWRdKGZlLCBlbmFibGUp
OworCQorCWlmICghZW5hYmxlKQorCQltdXRleF91bmxvY2soJmFkYXAtPmRldi0+dXNiX211dGV4
KTsKKwkKKwlyZXR1cm4gcmVzdWx0OworfQorCiBzdGF0aWMgaW50IGFmOTAxNV9hZjkwMTNfZnJv
bnRlbmRfYXR0YWNoKHN0cnVjdCBkdmJfdXNiX2FkYXB0ZXIgKmFkYXApCiB7CiAJaW50IHJldDsK
QEAgLTExMTYsNiArMTEzNCwxMSBAQCBzdGF0aWMgaW50IGFmOTAxNV9hZjkwMTNfZnJvbnRlbmRf
YXR0YWNoKHN0cnVjdCBkdmJfdXNiX2FkYXB0ZXIgKmFkYXApCiAJLyogYXR0YWNoIGRlbW9kdWxh
dG9yICovCiAJYWRhcC0+ZmUgPSBkdmJfYXR0YWNoKGFmOTAxM19hdHRhY2gsICZhZjkwMTVfYWY5
MDEzX2NvbmZpZ1thZGFwLT5pZF0sCiAJCWkyY19hZGFwKTsKKwkKKwlpZiAoYWRhcC0+ZmUgJiYg
YWRhcC0+ZmUtPm9wcy5pMmNfZ2F0ZV9jdHJsKSB7CisJCXN0YXRlLT5pMmNfZ2F0ZV9jdHJsW2Fk
YXAtPmlkXSA9IGFkYXAtPmZlLT5vcHMuaTJjX2dhdGVfY3RybDsKKwkJYWRhcC0+ZmUtPm9wcy5p
MmNfZ2F0ZV9jdHJsID0gYWY5MDE1X2xvY2tfaTJjX2dhdGVfY3RybDsKKwl9CiAKIAlyZXR1cm4g
YWRhcC0+ZmUgPT0gTlVMTCA/IC1FTk9ERVYgOiAwOwogfQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9t
ZWRpYS9kdmIvZHZiLXVzYi9hZjkwMTUuaCBiL2RyaXZlcnMvbWVkaWEvZHZiL2R2Yi11c2IvYWY5
MDE1LmgKaW5kZXggZjIwY2ZhNi4uMDk0YjFlMyAxMDA2NDQKLS0tIGEvZHJpdmVycy9tZWRpYS9k
dmIvZHZiLXVzYi9hZjkwMTUuaAorKysgYi9kcml2ZXJzL21lZGlhL2R2Yi9kdmItdXNiL2FmOTAx
NS5oCkBAIC0xMDIsNiArMTAyLDcgQEAgc3RydWN0IGFmOTAxNV9zdGF0ZSB7CiAJc3RydWN0IGky
Y19hZGFwdGVyIGkyY19hZGFwOyAvKiBJMkMgYWRhcHRlciBmb3IgMm5kIEZFICovCiAJdTggcmNf
cmVwZWF0OwogCXUzMiByY19rZXljb2RlOworCWludCAoKmkyY19nYXRlX2N0cmxbMl0pKHN0cnVj
dCBkdmJfZnJvbnRlbmQgKmZlLCBpbnQgZW5hYmxlKTsKIH07CiAKIHN0cnVjdCBhZjkwMTVfY29u
ZmlnIHsK
--0016e6dd8a668832ca049db26508--
