Return-path: <mchehab@pedra>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:53420 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751596Ab1DKQTK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Apr 2011 12:19:10 -0400
Received: by mail-ey0-f182.google.com with SMTP id 7so1932087eyg.13
        for <linux-media@vger.kernel.org>; Mon, 11 Apr 2011 09:19:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1104111518140.20489@axis700.grange>
References: <Pine.LNX.4.64.1104111054110.18511@axis700.grange>
 <BANLkTin9gFK+StWvs6D7MeJixQ7E2AB=rA@mail.gmail.com> <Pine.LNX.4.64.1104111518140.20489@axis700.grange>
From: "Aguirre, Sergio" <saaguirre@ti.com>
Date: Mon, 11 Apr 2011 11:18:48 -0500
Message-ID: <BANLkTikQSaUKtNZCexhKeNEPM+id+J_2gw@mail.gmail.com>
Subject: Re: [PATCH] V4L: soc-camera: regression fix: calculate .sizeimage in soc_camera.c
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Content-Type: multipart/mixed; boundary=0015174c0daa65f9f204a0a6eff5
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

--0015174c0daa65f9f204a0a6eff5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Guennadi,

On Mon, Apr 11, 2011 at 8:23 AM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
>
> On Mon, 11 Apr 2011, Aguirre, Sergio wrote:
>
> > Hi Guennadi,
> >
> > On Mon, Apr 11, 2011 at 3:58 AM, Guennadi Liakhovetski <
> > g.liakhovetski@gmx.de> wrote:
> >
> > > A recent patch has given individual soc-camera host drivers a possibi=
lity
> > > to calculate .sizeimage and .bytesperline pixel format fields interna=
lly,
> > > however, some drivers relied on the core calculating these values for
> > > them, following a default algorithm. This patch restores the default
> > > calculation for such drivers.
> > >
> > > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > > ---
> > > diff --git a/drivers/media/video/soc_camera.c
> > > b/drivers/media/video/soc_camera.c
> > > index 4628448..0918c48 100644
> > > --- a/drivers/media/video/soc_camera.c
> > > +++ b/drivers/media/video/soc_camera.c
> > > @@ -376,6 +376,9 @@ static int soc_camera_set_fmt(struct soc_camera_d=
evice
> > > *icd,
> > > =A0 =A0 =A0 =A0dev_dbg(&icd->dev, "S_FMT(%c%c%c%c, %ux%u)\n",
> > > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pixfmtstr(pix->pixelformat), pix->widt=
h, pix->height);
> > >
> > > + =A0 =A0 =A0 pix->bytesperline =3D 0;
> > > + =A0 =A0 =A0 pix->sizeimage =3D 0;
> > > +
> > > =A0 =A0 =A0 =A0/* We always call try_fmt() before set_fmt() or set_cr=
op() */
> > > =A0 =A0 =A0 =A0ret =3D ici->ops->try_fmt(icd, f);
> > > =A0 =A0 =A0 =A0if (ret < 0)
> > > @@ -391,6 +394,17 @@ static int soc_camera_set_fmt(struct soc_camera_=
device
> > > *icd,
> > > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -EINVAL;
> > > =A0 =A0 =A0 =A0}
> > >
> > > + =A0 =A0 =A0 if (!pix->sizeimage) {
> > > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!pix->bytesperline) {
> > > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D soc_mbus_bytes_=
per_line(pix->width,
> > > +
> > > icd->current_fmt->host_fmt);
> > > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret > 0)
> > > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pix->by=
tesperline =3D ret;
> > > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> > > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (pix->bytesperline)
> > > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pix->sizeimage =3D pix-=
>bytesperline * pix->height;
> > > + =A0 =A0 =A0 }
> > > +
> > >
> >
> > Shouldn't all this be better done in try_fmt?
>
> Not _better_. We might choose to additionally do it for try_fmt too. But
>
> 1. we didn't do it before, applications don't seem to care.
> 2. you cannot store / reuse those .sizeimage & .bytesperline values - thi=
s
> is just a "try"
> 3. it would be a bit difficult to realise - we need a struct
> soc_mbus_pixelfmt to call soc_mbus_bytes_per_line(), which we don't have,
> so, we'd need to obtain it using soc_camera_xlate_by_fourcc().
>
> This all would work, but in any case it would be an enhancement, but not =
a
> regression fix.

Ok. And how about the attached patch? Would that work?

Regards,
Sergio

>
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/

--0015174c0daa65f9f204a0a6eff5
Content-Type: text/x-patch; charset=US-ASCII;
	name="0001-V4L-soc-camera-regression-fix-calculate-.sizeimage-i.patch"
Content-Disposition: attachment;
	filename="0001-V4L-soc-camera-regression-fix-calculate-.sizeimage-i.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gmdlvgbr0

RnJvbSA1NDQyMDc0Yzc3NjA0MjljMDZmNjI5MTc1MDNjMWQ4YTJmNzljZDIxIE1vbiBTZXAgMTcg
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
LmMgfCAgIDQxICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKy0KIDEgZmlsZXMg
Y2hhbmdlZCwgMzkgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9k
cml2ZXJzL21lZGlhL3ZpZGVvL3NvY19jYW1lcmEuYyBiL2RyaXZlcnMvbWVkaWEvdmlkZW8vc29j
X2NhbWVyYS5jCmluZGV4IDQ2Mjg0NDguLjg3NTg0MmEgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbWVk
aWEvdmlkZW8vc29jX2NhbWVyYS5jCisrKyBiL2RyaXZlcnMvbWVkaWEvdmlkZW8vc29jX2NhbWVy
YS5jCkBAIC0xMzYsNiArMTM2LDQzIEBAIHVuc2lnbmVkIGxvbmcgc29jX2NhbWVyYV9hcHBseV9z
ZW5zb3JfZmxhZ3Moc3RydWN0IHNvY19jYW1lcmFfbGluayAqaWNsLAogfQogRVhQT1JUX1NZTUJP
TChzb2NfY2FtZXJhX2FwcGx5X3NlbnNvcl9mbGFncyk7CiAKK3N0YXRpYyBpbnQgc29jX2NhbWVy
YV90cnlfZm10KHN0cnVjdCBzb2NfY2FtZXJhX2RldmljZSAqaWNkLAorCQkJICAgICAgc3RydWN0
IHY0bDJfZm9ybWF0ICpmKQoreworCXN0cnVjdCBzb2NfY2FtZXJhX2hvc3QgKmljaSA9IHRvX3Nv
Y19jYW1lcmFfaG9zdChpY2QtPmRldi5wYXJlbnQpOworCXN0cnVjdCB2NGwyX3BpeF9mb3JtYXQg
KnBpeCA9ICZmLT5mbXQucGl4OworCWludCByZXQ7CisKKwlkZXZfZGJnKCZpY2QtPmRldiwgIlRS
WV9GTVQoJWMlYyVjJWMsICV1eCV1KVxuIiwKKwkJcGl4Zm10c3RyKHBpeC0+cGl4ZWxmb3JtYXQp
LCBwaXgtPndpZHRoLCBwaXgtPmhlaWdodCk7CisKKwlwaXgtPmJ5dGVzcGVybGluZSA9IDA7CisJ
cGl4LT5zaXplaW1hZ2UgPSAwOworCisJcmV0ID0gaWNpLT5vcHMtPnRyeV9mbXQoaWNkLCBmKTsK
KwlpZiAocmV0IDwgMCkKKwkJcmV0dXJuIHJldDsKKworCWlmICghcGl4LT5zaXplaW1hZ2UpIHsK
KwkJaWYgKCFwaXgtPmJ5dGVzcGVybGluZSkgeworCQkJY29uc3Qgc3RydWN0IHNvY19jYW1lcmFf
Zm9ybWF0X3hsYXRlICp4bGF0ZTsKKworCQkJeGxhdGUgPSBzb2NfY2FtZXJhX3hsYXRlX2J5X2Zv
dXJjYyhpY2QsIHBpeC0+cGl4ZWxmb3JtYXQpOworCQkJaWYgKCF4bGF0ZSkKKwkJCQlyZXR1cm4g
LUVJTlZBTDsKKworCQkJcmV0ID0gc29jX21idXNfYnl0ZXNfcGVyX2xpbmUocGl4LT53aWR0aCwK
KwkJCQkJCSAgICAgIHhsYXRlLT5ob3N0X2ZtdCk7CisJCQlpZiAocmV0ID4gMCkKKwkJCQlwaXgt
PmJ5dGVzcGVybGluZSA9IHJldDsKKwkJfQorCQlpZiAocGl4LT5ieXRlc3BlcmxpbmUpCisJCQlw
aXgtPnNpemVpbWFnZSA9IHBpeC0+Ynl0ZXNwZXJsaW5lICogcGl4LT5oZWlnaHQ7CisJfQorCisJ
cmV0dXJuIDA7Cit9CisKIHN0YXRpYyBpbnQgc29jX2NhbWVyYV90cnlfZm10X3ZpZF9jYXAoc3Ry
dWN0IGZpbGUgKmZpbGUsIHZvaWQgKnByaXYsCiAJCQkJICAgICAgc3RydWN0IHY0bDJfZm9ybWF0
ICpmKQogewpAQCAtMTQ5LDcgKzE4Niw3IEBAIHN0YXRpYyBpbnQgc29jX2NhbWVyYV90cnlfZm10
X3ZpZF9jYXAoc3RydWN0IGZpbGUgKmZpbGUsIHZvaWQgKnByaXYsCiAJCXJldHVybiAtRUlOVkFM
OwogCiAJLyogbGltaXQgZm9ybWF0IHRvIGhhcmR3YXJlIGNhcGFiaWxpdGllcyAqLwotCXJldHVy
biBpY2ktPm9wcy0+dHJ5X2ZtdChpY2QsIGYpOworCXJldHVybiBzb2NfY2FtZXJhX3RyeV9mbXQo
aWNkLCBmKTsKIH0KIAogc3RhdGljIGludCBzb2NfY2FtZXJhX2VudW1faW5wdXQoc3RydWN0IGZp
bGUgKmZpbGUsIHZvaWQgKnByaXYsCkBAIC0zNzcsNyArNDE0LDcgQEAgc3RhdGljIGludCBzb2Nf
Y2FtZXJhX3NldF9mbXQoc3RydWN0IHNvY19jYW1lcmFfZGV2aWNlICppY2QsCiAJCXBpeGZtdHN0
cihwaXgtPnBpeGVsZm9ybWF0KSwgcGl4LT53aWR0aCwgcGl4LT5oZWlnaHQpOwogCiAJLyogV2Ug
YWx3YXlzIGNhbGwgdHJ5X2ZtdCgpIGJlZm9yZSBzZXRfZm10KCkgb3Igc2V0X2Nyb3AoKSAqLwot
CXJldCA9IGljaS0+b3BzLT50cnlfZm10KGljZCwgZik7CisJcmV0ID0gc29jX2NhbWVyYV90cnlf
Zm10KGljZCwgZik7CiAJaWYgKHJldCA8IDApCiAJCXJldHVybiByZXQ7CiAKLS0gCjEuNy4wLjQK
Cg==
--0015174c0daa65f9f204a0a6eff5--
