Return-path: <mchehab@pedra>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:59110 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757917Ab1DLQom (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Apr 2011 12:44:42 -0400
Received: by eydd26 with SMTP id d26so2655645eyd.2
        for <linux-media@vger.kernel.org>; Tue, 12 Apr 2011 09:44:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201104121833.01789.jkrzyszt@tis.icnet.pl>
References: <Pine.LNX.4.64.1104111054110.18511@axis700.grange>
 <201104112352.07808.jkrzyszt@tis.icnet.pl> <BANLkTik7YRvvthrSHwMuH_dcDaNzkN96NQ@mail.gmail.com>
 <201104121833.01789.jkrzyszt@tis.icnet.pl>
From: "Aguirre, Sergio" <saaguirre@ti.com>
Date: Tue, 12 Apr 2011 11:44:19 -0500
Message-ID: <BANLkTi=yU9VzXE0Yn-tAbx6G6XfSexNGeQ@mail.gmail.com>
Subject: Re: [PATCH] V4L: soc-camera: regression fix: calculate .sizeimage in soc_camera.c
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: multipart/mixed; boundary=00504502cc7f7da64904a0bb68ff
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

--00504502cc7f7da64904a0bb68ff
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: quoted-printable

2011/4/12 Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>:
> Dnia wtorek 12 kwiecie=F1 2011 o 17:39:35 Aguirre, Sergio napisa=B3(a):
>> On Mon, Apr 11, 2011 at 4:52 PM, Janusz Krzysztofik
>>
>> <jkrzyszt@tis.icnet.pl> wrote:
>> > Dnia poniedzia=B3ek 11 kwiecie=F1 2011 o 22:05:35 Aguirre, Sergio
>> >
>> > napisa=B3(a):
>> >> Please find below a refreshed patch, which should be based on
>> >
>> >> mainline commit:
>> > Hi,
>> > This version works for me, and fixes the regression.
>>
>> Ok, Thanks for testing.
>
> I forgot to mention: the patch didn't apply cleanly, I had to unwrap a
> few lines manually, so you may want to resend it unwrapped.

Hmm,

I think that's a problem with my mail servers :/

Anyways, I'm attaching it now. Hopefully that's unwrapped.

Regards,
Sergio
>
> Thanks,
> Janusz
>

--00504502cc7f7da64904a0bb68ff
Content-Type: text/x-patch; charset=US-ASCII;
	name="0001-V4L-soc-camera-regression-fix-calculate-.sizeimage-i.patch"
Content-Disposition: attachment;
	filename="0001-V4L-soc-camera-regression-fix-calculate-.sizeimage-i.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gmf28dnt0

RnJvbSBmNzY3MDU5YzEyYzc1NWViZTc5YzRiNzRkZTE3YzIzYTI1NzAwN2M3IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTZXJnaW8gQWd1aXJyZSA8c2FhZ3VpcnJlQHRpLmNvbT4KRGF0
ZTogTW9uLCAxMSBBcHIgMjAxMSAxMToxNDozMyAtMDUwMApTdWJqZWN0OiBbUEFUQ0hdIFY0TDog
c29jLWNhbWVyYTogcmVncmVzc2lvbiBmaXg6IGNhbGN1bGF0ZSAuc2l6ZWltYWdlIGluIHNvY19j
YW1lcmEuYwoKQSByZWNlbnQgcGF0Y2ggaGFzIGdpdmVuIGluZGl2aWR1YWwgc29jLWNhbWVyYSBo
b3N0IGRyaXZlcnMgYSBwb3NzaWJpbGl0eQp0byBjYWxjdWxhdGUgLnNpemVpbWFnZSBhbmQgLmJ5
dGVzcGVybGluZSBwaXhlbCBmb3JtYXQgZmllbGRzIGludGVybmFsbHksCmhvd2V2ZXIsIHNvbWUg
ZHJpdmVycyByZWxpZWQgb24gdGhlIGNvcmUgY2FsY3VsYXRpbmcgdGhlc2UgdmFsdWVzIGZvcgp0
aGVtLCBmb2xsb3dpbmcgYSBkZWZhdWx0IGFsZ29yaXRobS4gVGhpcyBwYXRjaCByZXN0b3JlcyB0
aGUgZGVmYXVsdApjYWxjdWxhdGlvbiBmb3Igc3VjaCBkcml2ZXJzLgoKQmFzZWQgb24gaW5pdGlh
bCBwYXRjaCBieSBHdWVubmFkaSBMaWFraG92ZXRza2ksIGZvdW5kIGhlcmU6CgpodHRwOi8vd3d3
LnNwaW5pY3MubmV0L2xpc3RzL2xpbnV4LW1lZGlhL21zZzMxMjgyLmh0bWwKCkV4Y2VwdCB0aGF0
IHRoaXMgY292ZXJzIHRyeV9mbXQgYXN3ZWxsLgoKU2lnbmVkLW9mZi1ieTogU2VyZ2lvIEFndWly
cmUgPHNhYWd1aXJyZUB0aS5jb20+Ci0tLQogZHJpdmVycy9tZWRpYS92aWRlby9zb2NfY2FtZXJh
LmMgfCAgIDQ4ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKy0tLS0KIDEgZmlsZXMg
Y2hhbmdlZCwgNDIgaW5zZXJ0aW9ucygrKSwgNiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9k
cml2ZXJzL21lZGlhL3ZpZGVvL3NvY19jYW1lcmEuYyBiL2RyaXZlcnMvbWVkaWEvdmlkZW8vc29j
X2NhbWVyYS5jCmluZGV4IDQ2Mjg0NDguLmRjYzY2MjMgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbWVk
aWEvdmlkZW8vc29jX2NhbWVyYS5jCisrKyBiL2RyaXZlcnMvbWVkaWEvdmlkZW8vc29jX2NhbWVy
YS5jCkBAIC0xMzYsMTEgKzEzNiw1MCBAQCB1bnNpZ25lZCBsb25nIHNvY19jYW1lcmFfYXBwbHlf
c2Vuc29yX2ZsYWdzKHN0cnVjdCBzb2NfY2FtZXJhX2xpbmsgKmljbCwKIH0KIEVYUE9SVF9TWU1C
T0woc29jX2NhbWVyYV9hcHBseV9zZW5zb3JfZmxhZ3MpOwogCisjZGVmaW5lIHBpeGZtdHN0cih4
KSAoeCkgJiAweGZmLCAoKHgpID4+IDgpICYgMHhmZiwgKCh4KSA+PiAxNikgJiAweGZmLCBcCisJ
KCh4KSA+PiAyNCkgJiAweGZmCisKK3N0YXRpYyBpbnQgc29jX2NhbWVyYV90cnlfZm10KHN0cnVj
dCBzb2NfY2FtZXJhX2RldmljZSAqaWNkLAorCQkJICAgICAgc3RydWN0IHY0bDJfZm9ybWF0ICpm
KQoreworCXN0cnVjdCBzb2NfY2FtZXJhX2hvc3QgKmljaSA9IHRvX3NvY19jYW1lcmFfaG9zdChp
Y2QtPmRldi5wYXJlbnQpOworCXN0cnVjdCB2NGwyX3BpeF9mb3JtYXQgKnBpeCA9ICZmLT5mbXQu
cGl4OworCWludCByZXQ7CisKKwlkZXZfZGJnKCZpY2QtPmRldiwgIlRSWV9GTVQoJWMlYyVjJWMs
ICV1eCV1KVxuIiwKKwkJcGl4Zm10c3RyKHBpeC0+cGl4ZWxmb3JtYXQpLCBwaXgtPndpZHRoLCBw
aXgtPmhlaWdodCk7CisKKwlwaXgtPmJ5dGVzcGVybGluZSA9IDA7CisJcGl4LT5zaXplaW1hZ2Ug
PSAwOworCisJcmV0ID0gaWNpLT5vcHMtPnRyeV9mbXQoaWNkLCBmKTsKKwlpZiAocmV0IDwgMCkK
KwkJcmV0dXJuIHJldDsKKworCWlmICghcGl4LT5zaXplaW1hZ2UpIHsKKwkJaWYgKCFwaXgtPmJ5
dGVzcGVybGluZSkgeworCQkJY29uc3Qgc3RydWN0IHNvY19jYW1lcmFfZm9ybWF0X3hsYXRlICp4
bGF0ZTsKKworCQkJeGxhdGUgPSBzb2NfY2FtZXJhX3hsYXRlX2J5X2ZvdXJjYyhpY2QsIHBpeC0+
cGl4ZWxmb3JtYXQpOworCQkJaWYgKCF4bGF0ZSkKKwkJCQlyZXR1cm4gLUVJTlZBTDsKKworCQkJ
cmV0ID0gc29jX21idXNfYnl0ZXNfcGVyX2xpbmUocGl4LT53aWR0aCwKKwkJCQkJCSAgICAgIHhs
YXRlLT5ob3N0X2ZtdCk7CisJCQlpZiAocmV0ID4gMCkKKwkJCQlwaXgtPmJ5dGVzcGVybGluZSA9
IHJldDsKKwkJfQorCQlpZiAocGl4LT5ieXRlc3BlcmxpbmUpCisJCQlwaXgtPnNpemVpbWFnZSA9
IHBpeC0+Ynl0ZXNwZXJsaW5lICogcGl4LT5oZWlnaHQ7CisJfQorCisJcmV0dXJuIDA7Cit9CisK
IHN0YXRpYyBpbnQgc29jX2NhbWVyYV90cnlfZm10X3ZpZF9jYXAoc3RydWN0IGZpbGUgKmZpbGUs
IHZvaWQgKnByaXYsCiAJCQkJICAgICAgc3RydWN0IHY0bDJfZm9ybWF0ICpmKQogewogCXN0cnVj
dCBzb2NfY2FtZXJhX2RldmljZSAqaWNkID0gZmlsZS0+cHJpdmF0ZV9kYXRhOwotCXN0cnVjdCBz
b2NfY2FtZXJhX2hvc3QgKmljaSA9IHRvX3NvY19jYW1lcmFfaG9zdChpY2QtPmRldi5wYXJlbnQp
OwogCiAJV0FSTl9PTihwcml2ICE9IGZpbGUtPnByaXZhdGVfZGF0YSk7CiAKQEAgLTE0OSw3ICsx
ODgsNyBAQCBzdGF0aWMgaW50IHNvY19jYW1lcmFfdHJ5X2ZtdF92aWRfY2FwKHN0cnVjdCBmaWxl
ICpmaWxlLCB2b2lkICpwcml2LAogCQlyZXR1cm4gLUVJTlZBTDsKIAogCS8qIGxpbWl0IGZvcm1h
dCB0byBoYXJkd2FyZSBjYXBhYmlsaXRpZXMgKi8KLQlyZXR1cm4gaWNpLT5vcHMtPnRyeV9mbXQo
aWNkLCBmKTsKKwlyZXR1cm4gc29jX2NhbWVyYV90cnlfZm10KGljZCwgZik7CiB9CiAKIHN0YXRp
YyBpbnQgc29jX2NhbWVyYV9lbnVtX2lucHV0KHN0cnVjdCBmaWxlICpmaWxlLCB2b2lkICpwcml2
LApAQCAtMzYyLDkgKzQwMSw2IEBAIHN0YXRpYyB2b2lkIHNvY19jYW1lcmFfZnJlZV91c2VyX2Zv
cm1hdHMoc3RydWN0IHNvY19jYW1lcmFfZGV2aWNlICppY2QpCiAJaWNkLT51c2VyX2Zvcm1hdHMg
PSBOVUxMOwogfQogCi0jZGVmaW5lIHBpeGZtdHN0cih4KSAoeCkgJiAweGZmLCAoKHgpID4+IDgp
ICYgMHhmZiwgKCh4KSA+PiAxNikgJiAweGZmLCBcCi0JKCh4KSA+PiAyNCkgJiAweGZmCi0KIC8q
IENhbGxlZCB3aXRoIC52Yl9sb2NrIGhlbGQsIG9yIGZyb20gdGhlIGZpcnN0IG9wZW4oMiksIHNl
ZSBjb21tZW50IHRoZXJlICovCiBzdGF0aWMgaW50IHNvY19jYW1lcmFfc2V0X2ZtdChzdHJ1Y3Qg
c29jX2NhbWVyYV9kZXZpY2UgKmljZCwKIAkJCSAgICAgIHN0cnVjdCB2NGwyX2Zvcm1hdCAqZikK
QEAgLTM3Nyw3ICs0MTMsNyBAQCBzdGF0aWMgaW50IHNvY19jYW1lcmFfc2V0X2ZtdChzdHJ1Y3Qg
c29jX2NhbWVyYV9kZXZpY2UgKmljZCwKIAkJcGl4Zm10c3RyKHBpeC0+cGl4ZWxmb3JtYXQpLCBw
aXgtPndpZHRoLCBwaXgtPmhlaWdodCk7CiAKIAkvKiBXZSBhbHdheXMgY2FsbCB0cnlfZm10KCkg
YmVmb3JlIHNldF9mbXQoKSBvciBzZXRfY3JvcCgpICovCi0JcmV0ID0gaWNpLT5vcHMtPnRyeV9m
bXQoaWNkLCBmKTsKKwlyZXQgPSBzb2NfY2FtZXJhX3RyeV9mbXQoaWNkLCBmKTsKIAlpZiAocmV0
IDwgMCkKIAkJcmV0dXJuIHJldDsKIAotLSAKMS43LjAuNAoK
--00504502cc7f7da64904a0bb68ff--
