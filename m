Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:55545 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932182Ab0APQqd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Jan 2010 11:46:33 -0500
Date: Sat, 16 Jan 2010 17:47:49 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Antonio Ospite <ospite@studenti.unina.it>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] ov534: allow enumerating supported framerates
Message-ID: <20100116174749.696dcb9d@tele>
In-Reply-To: <20100116153345.c54db7aa.ospite@studenti.unina.it>
References: <1262997691-20651-1-git-send-email-ospite@studenti.unina.it>
	<20100116153345.c54db7aa.ospite@studenti.unina.it>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/ZjyS_I/fU2n6bg8y3JpDL6n"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--MP_/ZjyS_I/fU2n6bg8y3JpDL6n
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Sat, 16 Jan 2010 15:33:45 +0100
Antonio Ospite <ospite@studenti.unina.it> wrote:

> > Index: gspca/linux/drivers/media/video/gspca/ov534.c
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > --- gspca.orig/linux/drivers/media/video/gspca/ov534.c
> > +++ gspca/linux/drivers/media/video/gspca/ov534.c
> > @@ -282,6 +282,21 @@
> >  	 .priv =3D 0},
> >  };
> > =20
> > +static const int qvga_rates[] =3D {125, 100, 75, 60, 50, 40, 30};
> > +static const int vga_rates[] =3D {60, 50, 40, 30, 15};
> > +
>=20
> Hmm, after double checking compilation messages, having these as
> 'const' produces two:
>   warning: initialization discards qualifiers from pointer target type
> in the assignments below.
>=20
> If I remove the 'const' qualifiers here, the messages go away, so I'd
> say we can do also without them. If that's ok I'll send a v2 soon,
> sorry.

Hi Antonio,

I recoded your patch with some changes, mainly in gspca.h. If it is
OK for you, may you sign it?

Best regards.

--=20
Ken ar c'henta=C3=B1	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/

--MP_/ZjyS_I/fU2n6bg8y3JpDL6n
Content-Type: application/octet-stream; name=patch.pat
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=patch.pat

ZGlmZiAtciA1YmNkY2MwNzJiNmQgbGludXgvZHJpdmVycy9tZWRpYS92aWRlby9nc3BjYS9nc3Bj
YS5oCi0tLSBhL2xpbnV4L2RyaXZlcnMvbWVkaWEvdmlkZW8vZ3NwY2EvZ3NwY2EuaAlTYXQgSmFu
IDE2IDA3OjI1OjQzIDIwMTAgKzAxMDAKKysrIGIvbGludXgvZHJpdmVycy9tZWRpYS92aWRlby9n
c3BjYS9nc3BjYS5oCVNhdCBKYW4gMTYgMTc6NDQ6NDYgMjAxMCArMDEwMApAQCAtNDksNyArNDks
NyBAQAogCiAvKiB1c2VkIHRvIGxpc3QgZnJhbWVyYXRlcyBzdXBwb3J0ZWQgYnkgYSBjYW1lcmEg
bW9kZSAocmVzb2x1dGlvbikgKi8KIHN0cnVjdCBmcmFtZXJhdGVzIHsKLQlpbnQgKnJhdGVzOwor
CWNvbnN0IHU4ICpyYXRlczsKIAlpbnQgbnJhdGVzOwogfTsKIApkaWZmIC1yIDViY2RjYzA3MmI2
ZCBsaW51eC9kcml2ZXJzL21lZGlhL3ZpZGVvL2dzcGNhL292NTM0LmMKLS0tIGEvbGludXgvZHJp
dmVycy9tZWRpYS92aWRlby9nc3BjYS9vdjUzNC5jCVNhdCBKYW4gMTYgMDc6MjU6NDMgMjAxMCAr
MDEwMAorKysgYi9saW51eC9kcml2ZXJzL21lZGlhL3ZpZGVvL2dzcGNhL292NTM0LmMJU2F0IEph
biAxNiAxNzo0NDo0NiAyMDEwICswMTAwCkBAIC0yODIsNiArMjgyLDIwIEBACiAJIC5wcml2ID0g
MH0sCiB9OwogCitzdGF0aWMgY29uc3QgdTggcXZnYV9yYXRlc1tdID0gezEyNSwgMTAwLCA3NSwg
NjAsIDUwLCA0MCwgMzB9Oworc3RhdGljIGNvbnN0IHU4IHZnYV9yYXRlc1tdID0gezYwLCA1MCwg
NDAsIDMwLCAxNX07CisKK3N0YXRpYyBjb25zdCBzdHJ1Y3QgZnJhbWVyYXRlcyBvdjc3MnhfZnJh
bWVyYXRlc1tdID0geworCXsgLyogMzIweDI0MCAqLworCQkucmF0ZXMgPSBxdmdhX3JhdGVzLAor
CQkubnJhdGVzID0gQVJSQVlfU0laRShxdmdhX3JhdGVzKSwKKwl9LAorCXsgLyogNjQweDQ4MCAq
LworCQkucmF0ZXMgPSB2Z2FfcmF0ZXMsCisJCS5ucmF0ZXMgPSBBUlJBWV9TSVpFKHZnYV9yYXRl
cyksCisJfSwKK307CisKIHN0YXRpYyBjb25zdCB1OCBicmlkZ2VfaW5pdFtdWzJdID0gewogCXsg
MHhjMiwgMHgwYyB9LAogCXsgMHg4OCwgMHhmOCB9LApAQCAtNzk5LDYgKzgxMyw3IEBACiAKIAlj
YW0tPmNhbV9tb2RlID0gb3Y3NzJ4X21vZGU7CiAJY2FtLT5ubW9kZXMgPSBBUlJBWV9TSVpFKG92
NzcyeF9tb2RlKTsKKwljYW0tPm1vZGVfZnJhbWVyYXRlcyA9IG92NzcyeF9mcmFtZXJhdGVzOwog
CiAJY2FtLT5idWxrID0gMTsKIAljYW0tPmJ1bGtfc2l6ZSA9IDE2Mzg0Owo=

--MP_/ZjyS_I/fU2n6bg8y3JpDL6n--
