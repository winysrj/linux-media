Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:44118 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338Ab1JKK3l (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Oct 2011 06:29:41 -0400
Received: by gyg10 with SMTP id 10so6333548gyg.19
        for <linux-media@vger.kernel.org>; Tue, 11 Oct 2011 03:29:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAwP0s3tUUm+9S-MasWcp2HMLOW6xegQMTNbhxJ6355fW=hr0g@mail.gmail.com>
References: <CA+2YH7t+cHNoV_oNF6cOyTjr+OFbWAAoKCujFwfNHjvijoD8pw@mail.gmail.com>
	<CA+2YH7tv-VVnsoKe+C3es==hmKZw771YvVNL=_wwN=hz7JSKSQ@mail.gmail.com>
	<CAAwP0s0qUvCn+L+tx4NppZknNJ=6aMD5e8E+bLerTnBLLyGL8A@mail.gmail.com>
	<201110081751.38953.laurent.pinchart@ideasonboard.com>
	<CAAwP0s3K8D7-LyVUmbj1tMjU6UPESJPxWJu43P2THz4fDSF41A@mail.gmail.com>
	<CA+2YH7vat9iSAuZ4ztDvvo4Od+b4tCOsK6Y+grTE05YUZZEYPQ@mail.gmail.com>
	<CAAwP0s3NFvvUYd-0kwKLKXfYB4Zx1nXb0nd9+JM61JWtrVFfRg@mail.gmail.com>
	<CA+2YH7uFeHAmEpVqbd94qtCajb45pkr9YzeW+RDa5sf2bUG_wQ@mail.gmail.com>
	<CAAwP0s3GJ7-By=q_ADa6qcpaENK5kXvkTG8Hd=Y+qXs9dgXa0w@mail.gmail.com>
	<CA+2YH7subMzFAg7f7-uHXEmYBD+Kd1=E2nWKx7dgKCEpOu=zgQ@mail.gmail.com>
	<CA+2YH7ti4xz9zNby6O=3ZOKAB9=1hnYZr9cM8HSMrj0r4zi1=A@mail.gmail.com>
	<CAAwP0s3ZqDpMsF7mYYtM7twomREZTyO-uDhGPnfNsQcOTXQ_fw@mail.gmail.com>
	<CA+2YH7s6rhLsyJTdWwQVUCd2WBWiH2saSaZZw0tysRWsXw-6Cg@mail.gmail.com>
	<CA+2YH7tdMHNpJGyOhVJnR4UN5ZwCcspD0Nnj8xCvUs7RaERb_w@mail.gmail.com>
	<CA+2YH7uNvuRdWSoX25NvHryknExrfeew1heB5DNSf3Epz2LOUw@mail.gmail.com>
	<CAAwP0s1JDoSUqX2Fm7+L1HyNxAZkdenDfmy0M8U5nVLo2eSvOw@mail.gmail.com>
	<CA+2YH7votO73gQmdxhHkfLsc9sp8Z-S=wxxrJhsTYUzVqpiACA@mail.gmail.com>
	<CAAwP0s3tUUm+9S-MasWcp2HMLOW6xegQMTNbhxJ6355fW=hr0g@mail.gmail.com>
Date: Tue, 11 Oct 2011 12:29:41 +0200
Message-ID: <CA+2YH7v444zTDCV9Gmnkcj+mXB10RZE4KU2zDHFMqjzDmUXLzw@mail.gmail.com>
Subject: Re: omap3-isp status
From: Enrico <ebutera@users.berlios.de>
To: Javier Martinez Canillas <martinez.javier@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Deepthy Ravi <deepthy.ravi@ti.com>,
	Gary Thomas <gary@mlbassoc.com>,
	Adam Pledger <a.pledger@thermoteknix.com>,
	linux-media@vger.kernel.org,
	Enric Balletbo i Serra <eballetbo@iseebcn.com>
Content-Type: multipart/mixed; boundary=20cf300512349ef68f04af036248
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--20cf300512349ef68f04af036248
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 10, 2011 at 8:18 PM, Javier Martinez Canillas
<martinez.javier@gmail.com> wrote:
> On Mon, Oct 10, 2011 at 7:09 PM, Enrico <ebutera@users.berlios.de> wrote:
>> On Mon, Oct 10, 2011 at 6:53 PM, Javier Martinez Canillas
>> <martinez.javier@gmail.com> wrote:
>>> On Mon, Oct 10, 2011 at 6:34 PM, Enrico <ebutera@users.berlios.de> wrot=
e:
>>>> Ok, i made it work. It was missing just the config_outlineoffset i
>>>> wrote before and a missing FLDMODE in SYNC registers.
>>>>
>>>
>>> Great, do you get the ghosting effect or do you have a clean video?
>>
>>
>> Unfortunately i always get the ghosting effect. But this is something
>> we will try to fix later.
>>
>>
>
> Agree, we should try to get some code upstream to add interlaced video
> and bt.656 support and fix the artifact later.
>
>>>> Moreover it seems to me that the software-maintained field id
>>>> (interlaced_cnt in Javier patches, fldstat in Deepthy patches) is
>>>> useless, i've tried to only use the FLDSTAT bit from isp register
>>>> (fid) in vd0_isr:
>>>>
>>>> if (fid =3D=3D 0) {
>>>> =A0 =A0 restart =3D ccdc_isr_buffer(ccdc);
>>>> =A0 =A0 goto done;
>>>> }
>>>>
>>>> and it works. I've not tested very long frame sequences, only up to 16
>>>> frames. The only issue is that the first frame could be half-green
>>>> because a field is missing.
>>>>
>>>
>>> Yes, when I tried Deepthy patches I realized that the fldstat was not
>>> in sync with the frames, but probably I made something wrong.
>>
>>
>> I had noticed the same thing, but now i tested it and it is ok, maybe
>> my fault too.
>>
>>
>>> We had the same problem with the hal-green frame. Our solution was to
>>> synchronize the CCDC with the first even field looking at fdstat on
>>> the VD1 interrupt handler and forcing to start processing from an ODD
>>> sub-frame.
>>
>> Thinking more about it, it's ugly to have that half-green video frame
>> even if it's just one. It's better to keep your or Deepthy solution.
>>
>> Enrico
>>
>
> Well, that is something that can be fixed later also. Can you send to
> the list your patches? So, Laurent, Sakari and others than know more
> about the ISP can review it. I hope they can find the cause for the
> artifact.

I'm attaching some fixes (taken from Deepthy patches) to be applied on
top of your v2 patches, with those i can grab frames but i only get
garbage.

I think the problem is that it always hits this in ccdc_isr_buffer:

if (ccdc_sbl_wait_idle(ccdc, 1000)) {
                dev_info(isp->dev, "CCDC won't become idle!\n");
                goto done;
}

so the video buffer never gets updated.

At this point i think it is better to go on with my port of Deepthy
patches and try to solve the ghosting issues, maybe with your fixes
about buffer decoupling.

Laurent, what do you suggest to do?

Enrico

--20cf300512349ef68f04af036248
Content-Type: text/x-patch; charset=US-ASCII;
	name="0001-omap3isp-some-fixes-for-Javier-v2-patches.patch"
Content-Disposition: attachment;
	filename="0001-omap3isp-some-fixes-for-Javier-v2-patches.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gtmqzb4k0

RnJvbSAwNzhmMjg0M2JhOTRjZmJjMTUwZjZjMDFjYzYxNGMwZWQzYTM1ZmQ0IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBFbnJpY28gQnV0ZXJhIDxlYnV0ZXJhQHVzZXJzLmJlcmxpb3Mu
ZGU+CkRhdGU6IFR1ZSwgMTEgT2N0IDIwMTEgMTE6NTE6MzggKzAyMDAKU3ViamVjdDogW1BBVENI
XSBvbWFwM2lzcDogc29tZSBmaXhlcyBmb3IgSmF2aWVyIHYyIHBhdGNoZXMKClNpZ25lZC1vZmYt
Ynk6IEVucmljbyBCdXRlcmEgPGVidXRlcmFAdXNlcnMuYmVybGlvcy5kZT4KLS0tCiBkcml2ZXJz
L21lZGlhL3ZpZGVvL29tYXAzaXNwL2lzcGNjZGMuYyB8ICAgNDEgKysrKysrKysrKysrKysrKysr
KysrKystLS0tLS0tLQogMSBmaWxlcyBjaGFuZ2VkLCAzMCBpbnNlcnRpb25zKCspLCAxMSBkZWxl
dGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL21lZGlhL3ZpZGVvL29tYXAzaXNwL2lzcGNj
ZGMuYyBiL2RyaXZlcnMvbWVkaWEvdmlkZW8vb21hcDNpc3AvaXNwY2NkYy5jCmluZGV4IGYxZGE0
OWMuLjBjYjRlMzYgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbWVkaWEvdmlkZW8vb21hcDNpc3AvaXNw
Y2NkYy5jCisrKyBiL2RyaXZlcnMvbWVkaWEvdmlkZW8vb21hcDNpc3AvaXNwY2NkYy5jCkBAIC00
Myw2ICs0Myw3IEBAIF9fY2NkY19nZXRfZm9ybWF0KHN0cnVjdCBpc3BfY2NkY19kZXZpY2UgKmNj
ZGMsIHN0cnVjdCB2NGwyX3N1YmRldl9maCAqZmgsCiAJCSAgdW5zaWduZWQgaW50IHBhZCwgZW51
bSB2NGwyX3N1YmRldl9mb3JtYXRfd2hlbmNlIHdoaWNoKTsKIHN0YXRpYyBib29sIGNjZGNfaW5w
dXRfaXNfYnQ2NTYoc3RydWN0IGlzcF9jY2RjX2RldmljZSAqY2NkYyk7CiBzdGF0aWMgYm9vbCBj
Y2RjX2lucHV0X2lzX2ZsZG1vZGUoc3RydWN0IGlzcF9jY2RjX2RldmljZSAqY2NkYyk7CitzdGF0
aWMgaW50IF9fY2NkY19oYW5kbGVfc3RvcHBpbmcoc3RydWN0IGlzcF9jY2RjX2RldmljZSAqY2Nk
YywgdTMyIGV2ZW50KTsKIAogc3RhdGljIGNvbnN0IHVuc2lnbmVkIGludCBjY2RjX2ZtdHNbXSA9
IHsKIAlWNEwyX01CVVNfRk1UX1k4XzFYOCwKQEAgLTc5NSwxMSArNzk2LDE3IEBAIHN0YXRpYyB2
b2lkIGNjZGNfYXBwbHlfY29udHJvbHMoc3RydWN0IGlzcF9jY2RjX2RldmljZSAqY2NkYykKIHZv
aWQgb21hcDNpc3BfY2NkY19yZXN0b3JlX2NvbnRleHQoc3RydWN0IGlzcF9kZXZpY2UgKmlzcCkK
IHsKIAlzdHJ1Y3QgaXNwX2NjZGNfZGV2aWNlICpjY2RjID0gJmlzcC0+aXNwX2NjZGM7CisJc3Ry
dWN0IHY0bDJfbWJ1c19mcmFtZWZtdCAqZm9ybWF0OwogCiAJaXNwX3JlZ19zZXQoaXNwLCBPTUFQ
M19JU1BfSU9NRU1fQ0NEQywgSVNQQ0NEQ19DRkcsIElTUENDRENfQ0ZHX1ZETEMpOwogCi0JY2Nk
Yy0+dXBkYXRlID0gT01BUDNJU1BfQ0NEQ19BTEFXIHwgT01BUDNJU1BfQ0NEQ19MUEYKLQkJICAg
ICB8IE9NQVAzSVNQX0NDRENfQkxDTEFNUCB8IE9NQVAzSVNQX0NDRENfQkNPTVA7CisJLyogQ0NE
Q19QQURfU0lOSyAqLworCWZvcm1hdCA9ICZjY2RjLT5mb3JtYXRzW0NDRENfUEFEX1NJTktdOwor
CWlmICgoZm9ybWF0LT5jb2RlICE9IFY0TDJfTUJVU19GTVRfVVlWWThfMlg4KSAmJgorCQkJKGZv
cm1hdC0+Y29kZSAhPSBWNEwyX01CVVNfRk1UX1VZVlk4XzJYOCkpCisJCWNjZGMtPnVwZGF0ZSA9
IE9NQVAzSVNQX0NDRENfQUxBVyB8IE9NQVAzSVNQX0NDRENfTFBGCisJCQkJfCBPTUFQM0lTUF9D
Q0RDX0JMQ0xBTVAgfCBPTUFQM0lTUF9DQ0RDX0JDT01QOworCiAJY2NkY19hcHBseV9jb250cm9s
cyhjY2RjKTsKIAljY2RjX2NvbmZpZ3VyZV9mcGMoY2NkYyk7CiB9CkBAIC0xMDIxLDEwICsxMDI4
LDEwIEBAIHN0YXRpYyB2b2lkIGNjZGNfY29uZmlnX3N5bmNfaWYoc3RydWN0IGlzcF9jY2RjX2Rl
dmljZSAqY2NkYywKIAogCWlmIChwZGF0YSAmJiBwZGF0YS0+YnQ2NTYpCiAJCWlzcF9yZWdfc2V0
KGlzcCwgT01BUDNfSVNQX0lPTUVNX0NDREMsIElTUENDRENfUkVDNjU2SUYsCi0JCQkgICAgSVNQ
Q0NEQ19SRUM2NTZJRl9SNjU2T04pOworCQkJICAgIElTUENDRENfUkVDNjU2SUZfUjY1Nk9OIHwg
SVNQQ0NEQ19SRUM2NTZJRl9FQ0NGVkgpOwogCWVsc2UKIAkJaXNwX3JlZ19jbHIoaXNwLCBPTUFQ
M19JU1BfSU9NRU1fQ0NEQywgSVNQQ0NEQ19SRUM2NTZJRiwKLQkJCSAgICBJU1BDQ0RDX1JFQzY1
NklGX1I2NTZPTik7CisJCQkgICAgSVNQQ0NEQ19SRUM2NTZJRl9SNjU2T04gfCBJU1BDQ0RDX1JF
QzY1NklGX0VDQ0ZWSCk7CiB9CiAKIC8qIENDREMgZm9ybWF0cyBkZXNjcmlwdGlvbnMgKi8KQEAg
LTExODcsNyArMTE5NCw5IEBAIHN0YXRpYyB2b2lkIGNjZGNfY29uZmlndXJlKHN0cnVjdCBpc3Bf
Y2NkY19kZXZpY2UgKmNjZGMpCiAJCWNjZGNfcGF0dGVybiA9IGNjZGNfc2dyYmdfcGF0dGVybjsK
IAkJYnJlYWs7CiAJfQotCWNjZGNfY29uZmlnX2ltZ2F0dHIoY2NkYywgY2NkY19wYXR0ZXJuKTsK
KwlpZiAoKGZvcm1hdC0+Y29kZSAhPSBWNEwyX01CVVNfRk1UX1lVWVY4XzJYOCkgJiYKKwkJCShm
b3JtYXQtPmNvZGUgIT0gVjRMMl9NQlVTX0ZNVF9VWVZZOF8yWDgpKQorCQljY2RjX2NvbmZpZ19p
bWdhdHRyKGNjZGMsIGNjZGNfcGF0dGVybik7CiAKIAkvKiBJbiBCVC42NTYgYSBwaXhlbCBpcyBy
ZXByZXNlbnRkIHVzaW5nIHR3byBieXRlcyAqLwogCWlmIChwZGF0YS0+YnQ2NTYpCkBAIC0xMjE5
LDcgKzEyMjgsNyBAQCBzdGF0aWMgdm9pZCBjY2RjX2NvbmZpZ3VyZShzdHJ1Y3QgaXNwX2NjZGNf
ZGV2aWNlICpjY2RjKQogCQkgICAgICAgT01BUDNfSVNQX0lPTUVNX0NDREMsIElTUENDRENfSE9S
Wl9JTkZPKTsKIAlpc3BfcmVnX3dyaXRlbChpc3AsIDAgPDwgSVNQQ0NEQ19WRVJUX1NUQVJUX1NM
VjBfU0hJRlQsCiAJCSAgICAgICBPTUFQM19JU1BfSU9NRU1fQ0NEQywgSVNQQ0NEQ19WRVJUX1NU
QVJUKTsKLQlpc3BfcmVnX3dyaXRlbChpc3AsIG5sdiA8PCBJU1BDQ0RDX1ZFUlRfTElORVNfTkxW
X1NISUZULAorCWlzcF9yZWdfd3JpdGVsKGlzcCwgKCgoZm9ybWF0LT5oZWlnaHQgPj4gMSkgLSAx
KSAvKm5sdiovIDw8IElTUENDRENfVkVSVF9MSU5FU19OTFZfU0hJRlQpLAogCQkgICAgICAgT01B
UDNfSVNQX0lPTUVNX0NDREMsIElTUENDRENfVkVSVF9MSU5FUyk7CiAJaXNwX3JlZ193cml0ZWwo
aXNwLCAwIDw8IElTUENDRENfVkVSVF9TVEFSVF9TTFYxX1NISUZULAogCQkgICAgICAgT01BUDNf
SVNQX0lPTUVNX0NDREMsIElTUENDRENfVkVSVF9TVEFSVCk7CkBAIC0xMjc4LDYgKzEyODcsMTEg
QEAgc3RhdGljIHZvaWQgY2NkY19jb25maWd1cmUoc3RydWN0IGlzcF9jY2RjX2RldmljZSAqY2Nk
YykKIHVubG9jazoKIAlzcGluX3VubG9ja19pcnFyZXN0b3JlKCZjY2RjLT5sc2MucmVxX2xvY2ss
IGZsYWdzKTsKIAorCWlmIChwZGF0YS0+YnQ2NTYpCisJCWNjZGMtPnVwZGF0ZSA9IE9NQVAzSVNQ
X0NDRENfQkxDTEFNUDsKKwllbHNlCisJCWNjZGMtPnVwZGF0ZSA9IDA7CisKIAljY2RjX2FwcGx5
X2NvbnRyb2xzKGNjZGMpOwogfQogCkBAIC0xMjk5LDYgKzEzMTMsMTEgQEAgc3RhdGljIGludCBj
Y2RjX2Rpc2FibGUoc3RydWN0IGlzcF9jY2RjX2RldmljZSAqY2NkYykKIAkJY2NkYy0+c3RvcHBp
bmcgPSBDQ0RDX1NUT1BfUkVRVUVTVDsKIAlzcGluX3VubG9ja19pcnFyZXN0b3JlKCZjY2RjLT5s
b2NrLCBmbGFncyk7CiAKKwlfX2NjZGNfbHNjX2VuYWJsZShjY2RjLCAwKTsKKwlfX2NjZGNfZW5h
YmxlKGNjZGMsIDApOworCWNjZGMtPnN0b3BwaW5nID0gQ0NEQ19TVE9QX0VYRUNVVEVEOworCV9f
Y2NkY19oYW5kbGVfc3RvcHBpbmcoY2NkYywgQ0NEQ19TVE9QX0ZJTklTSEVEKTsKKwogCXJldCA9
IHdhaXRfZXZlbnRfdGltZW91dChjY2RjLT53YWl0LAogCQkJCSBjY2RjLT5zdG9wcGluZyA9PSBD
Q0RDX1NUT1BfRklOSVNIRUQsCiAJCQkJIG1zZWNzX3RvX2ppZmZpZXMoMjAwMCkpOwpAQCAtMTUy
Miw3ICsxNTQxLDcgQEAgc3RhdGljIGludCBjY2RjX2lzcl9idWZmZXIoc3RydWN0IGlzcF9jY2Rj
X2RldmljZSAqY2NkYykKIAkvKiBJbiBpbnRlcmxhY2VkIG1vZGUgYSBmcmFtZSBpcyBjb21wb3Nl
ZCBvZiB0d28gc3ViZnJhbWVzIHNvIHdlIGRvbid0IGhhdmUKIAkgKiB0byBjaGFuZ2UgdGhlIEND
REMgb3V0cHV0IG1lbW9yeSBvbiBldmVyeSBlbmQgb2YgZnJhbWUuCiAJICovCi0JaWYgKCFjY2Rj
X2lucHV0X2lzX2ZsZG1vZGUoY2NkYykpIHsKKwlpZiAoY2NkY19pbnB1dF9pc19mbGRtb2RlKGNj
ZGMpKSB7CiAJCWlmICghY2NkYy0+aW50ZXJsYWNlZF9jbnQpIHsKIAkJCWNjZGMtPmludGVybGFj
ZWRfY250ID0gMTsKIAkJCXJlc3RhcnQgPSAxOwpAQCAtMTY1Niw3ICsxNjc1LDcgQEAgaW50IG9t
YXAzaXNwX2NjZGNfaXNyKHN0cnVjdCBpc3BfY2NkY19kZXZpY2UgKmNjZGMsIHUzMiBldmVudHMp
CiAJaWYgKGNjZGMtPnN0YXRlID09IElTUF9QSVBFTElORV9TVFJFQU1fU1RPUFBFRCkKIAkJcmV0
dXJuIDA7CiAKLQlpZiAoZXZlbnRzICYgSVJRMFNUQVRVU19DQ0RDX1ZEMV9JUlEpCisJaWYgKChl
dmVudHMgJiBJUlEwU1RBVFVTX0NDRENfVkQxX0lSUSkgJiYgIWNjZGNfaW5wdXRfaXNfYnQ2NTYo
Y2NkYykpCiAJCWNjZGNfdmQxX2lzcihjY2RjKTsKIAogCWNjZGNfbHNjX2lzcihjY2RjLCBldmVu
dHMpOwpAQCAtMTY2NCw3ICsxNjgzLDcgQEAgaW50IG9tYXAzaXNwX2NjZGNfaXNyKHN0cnVjdCBp
c3BfY2NkY19kZXZpY2UgKmNjZGMsIHUzMiBldmVudHMpCiAJaWYgKGV2ZW50cyAmIElSUTBTVEFU
VVNfQ0NEQ19WRDBfSVJRKQogCQljY2RjX3ZkMF9pc3IoY2NkYyk7CiAKLQlpZiAoZXZlbnRzICYg
SVJRMFNUQVRVU19IU19WU19JUlEpCisJaWYgKChldmVudHMgJiBJUlEwU1RBVFVTX0hTX1ZTX0lS
USkgJiYgIWNjZGNfaW5wdXRfaXNfYnQ2NTYoY2NkYykpCiAJCWNjZGNfaHNfdnNfaXNyKGNjZGMp
OwogCiAJcmV0dXJuIDA7CkBAIC0xNzc0LDcgKzE3OTMsNyBAQCBzdGF0aWMgaW50IGNjZGNfc2V0
X3N0cmVhbShzdHJ1Y3QgdjRsMl9zdWJkZXYgKnNkLCBpbnQgZW5hYmxlKQogCQkgKiBsaW5rcyBh
cmUgaW5hY3RpdmUuCiAJCSAqLwogCQljY2RjX2NvbmZpZ192cChjY2RjKTsKLQkJY2NkY19lbmFi
bGVfdnAoY2NkYywgMSk7CisJCWNjZGNfZW5hYmxlX3ZwKGNjZGMsIDApOwogCQljY2RjLT5lcnJv
ciA9IDA7CiAJCWNjZGNfcHJpbnRfc3RhdHVzKGNjZGMpOwogCX0KQEAgLTIzNDQsNyArMjM2Myw3
IEBAIGludCBvbWFwM2lzcF9jY2RjX2luaXQoc3RydWN0IGlzcF9kZXZpY2UgKmlzcCkKIAogCWNj
ZGMtPnZwY2ZnLnBpeGVsY2xrID0gMDsKIAotCWNjZGMtPnVwZGF0ZSA9IE9NQVAzSVNQX0NDRENf
QkxDTEFNUDsKKwljY2RjLT51cGRhdGUgPSAwOwogCWNjZGNfYXBwbHlfY29udHJvbHMoY2NkYyk7
CiAKIAlyZXQgPSBjY2RjX2luaXRfZW50aXRpZXMoY2NkYyk7Ci0tIAoxLjcuNC4xCgo=
--20cf300512349ef68f04af036248--
