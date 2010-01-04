Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:35241 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754098Ab0ADVBJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jan 2010 16:01:09 -0500
Date: Mon, 4 Jan 2010 22:01:07 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: =?ISO-8859-2?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] rj54n1cb0c: remove compiler warning
In-Reply-To: <4B40FF73.2060906@freemail.hu>
Message-ID: <Pine.LNX.4.64.1001042158350.9164@axis700.grange>
References: <201001031950.o03JoIjh012466@smtp-vbr4.xs4all.nl>
 <4B40FF73.2060906@freemail.hu>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-1214371903-1262638867=:9164"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1214371903-1262638867=:9164
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE

Hi M=E1rton

On Sun, 3 Jan 2010, N=E9meth M=E1rton wrote:

> From: M=E1rton N=E9meth <nm127@freemail.hu>
>=20
> Remove the following compiler warning: 'dummy' is used uninitialized in t=
his function.
> Although the result in the dummy variable is not used the program flow in
> soc_camera_limit_side() depends on the value in dummy. The program flow i=
s better
> to be deterministic.
>=20
> Signed-off-by: M=E1rton N=E9meth <nm127@freemail.hu>

The patch is good, the only slight problem - you have non-ASCII characters=
=20
in your name and you didn't use UTF-8 to send this mail, which, I think,=20
is the accepted encoding in the Linux kernel. I converted your patch to=20
utf8 and attached to this mail. Please verify that the result is correct.

> ---
> diff -r 62ee2b0f6556 linux/drivers/media/video/rj54n1cb0c.c
> --- a/linux/drivers/media/video/rj54n1cb0c.c=09Wed Dec 30 18:19:11 2009 +=
0100
> +++ b/linux/drivers/media/video/rj54n1cb0c.c=09Sun Jan 03 21:30:20 2010 +=
0100
> @@ -563,7 +563,7 @@
>  =09struct i2c_client *client =3D sd->priv;
>  =09struct rj54n1 *rj54n1 =3D to_rj54n1(client);
>  =09struct v4l2_rect *rect =3D &a->c;
> -=09unsigned int dummy, output_w, output_h,
> +=09unsigned int dummy =3D 0, output_w, output_h,
>  =09=09input_w =3D rect->width, input_h =3D rect->height;
>  =09int ret;
>=20

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
--8323329-1214371903-1262638867=:9164
Content-Type: TEXT/x-diff; charset=ISO-8859-15; name=rj54n1-utf8.patch
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.64.1001042201070.9164@axis700.grange>
Content-Description: 
Content-Disposition: attachment; filename=rj54n1-utf8.patch

RnJvbSBubTEyN0BmcmVlbWFpbC5odSBTdW4gSmFuICAzIDIxOjM4OjUxIDIw
MTANCkRhdGU6IFN1biwgMDMgSmFuIDIwMTAgMjE6MzQ6NTkgKzAxMDANCkZy
b206IE7DqW1ldGggTcOhcnRvbiA8bm0xMjdAZnJlZW1haWwuaHU+DQpUbzog
R3Vlbm5hZGkgTGlha2hvdmV0c2tpIDxnLmxpYWtob3ZldHNraUBnbXguZGU+
DQpDYzogSGFucyBWZXJrdWlsIDxodmVya3VpbEB4czRhbGwubmw+LCBWNEwg
TWFpbGluZyBMaXN0IDxsaW51eC1tZWRpYUB2Z2VyLmtlcm5lbC5vcmc+DQpT
dWJqZWN0OiBbUEFUQ0hdIHJqNTRuMWNiMGM6IHJlbW92ZSBjb21waWxlciB3
YXJuaW5nDQoNCkZyb206IE3DoXJ0b24gTsOpbWV0aCA8bm0xMjdAZnJlZW1h
aWwuaHU+DQoNClJlbW92ZSB0aGUgZm9sbG93aW5nIGNvbXBpbGVyIHdhcm5p
bmc6ICdkdW1teScgaXMgdXNlZCB1bmluaXRpYWxpemVkIGluIHRoaXMgZnVu
Y3Rpb24uDQpBbHRob3VnaCB0aGUgcmVzdWx0IGluIHRoZSBkdW1teSB2YXJp
YWJsZSBpcyBub3QgdXNlZCB0aGUgcHJvZ3JhbSBmbG93IGluDQpzb2NfY2Ft
ZXJhX2xpbWl0X3NpZGUoKSBkZXBlbmRzIG9uIHRoZSB2YWx1ZSBpbiBkdW1t
eS4gVGhlIHByb2dyYW0gZmxvdyBpcyBiZXR0ZXINCnRvIGJlIGRldGVybWlu
aXN0aWMuDQoNClNpZ25lZC1vZmYtYnk6IE3DoXJ0b24gTsOpbWV0aCA8bm0x
MjdAZnJlZW1haWwuaHU+DQotLS0NCmRpZmYgLXIgNjJlZTJiMGY2NTU2IGxp
bnV4L2RyaXZlcnMvbWVkaWEvdmlkZW8vcmo1NG4xY2IwYy5jDQotLS0gYS9s
aW51eC9kcml2ZXJzL21lZGlhL3ZpZGVvL3JqNTRuMWNiMGMuYwlXZWQgRGVj
IDMwIDE4OjE5OjExIDIwMDkgKzAxMDANCisrKyBiL2xpbnV4L2RyaXZlcnMv
bWVkaWEvdmlkZW8vcmo1NG4xY2IwYy5jCVN1biBKYW4gMDMgMjE6MzA6MjAg
MjAxMCArMDEwMA0KQEAgLTU2Myw3ICs1NjMsNyBAQA0KIAlzdHJ1Y3QgaTJj
X2NsaWVudCAqY2xpZW50ID0gc2QtPnByaXY7DQogCXN0cnVjdCByajU0bjEg
KnJqNTRuMSA9IHRvX3JqNTRuMShjbGllbnQpOw0KIAlzdHJ1Y3QgdjRsMl9y
ZWN0ICpyZWN0ID0gJmEtPmM7DQotCXVuc2lnbmVkIGludCBkdW1teSwgb3V0
cHV0X3csIG91dHB1dF9oLA0KKwl1bnNpZ25lZCBpbnQgZHVtbXkgPSAwLCBv
dXRwdXRfdywgb3V0cHV0X2gsDQogCQlpbnB1dF93ID0gcmVjdC0+d2lkdGgs
IGlucHV0X2ggPSByZWN0LT5oZWlnaHQ7DQogCWludCByZXQ7DQo=

--8323329-1214371903-1262638867=:9164--
