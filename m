Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:45058 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751695AbcEJMl5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 10 May 2016 08:41:57 -0400
Subject: Re: [RFC PATCH 2/3] omap4: add CEC support
To: Hans Verkuil <hverkuil@xs4all.nl>, <linux-media@vger.kernel.org>
References: <1461922746-17521-1-git-send-email-hverkuil@xs4all.nl>
 <1461922746-17521-3-git-send-email-hverkuil@xs4all.nl>
 <5731CD8E.8090509@ti.com> <5731D379.2050802@xs4all.nl>
CC: <dri-devel@lists.freedesktop.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
Message-ID: <5731D70B.4010802@ti.com>
Date: Tue, 10 May 2016 15:41:47 +0300
MIME-Version: 1.0
In-Reply-To: <5731D379.2050802@xs4all.nl>
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="Xpi7KPaD9N2KokQiMldDDPEfG8JTUcQEr"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Xpi7KPaD9N2KokQiMldDDPEfG8JTUcQEr
Content-Type: multipart/mixed; boundary="U1223RO4atXLv5vhcFnUP9Nj98TwfeGdV"
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, Hans Verkuil <hans.verkuil@cisco.com>
Message-ID: <5731D70B.4010802@ti.com>
Subject: Re: [RFC PATCH 2/3] omap4: add CEC support
References: <1461922746-17521-1-git-send-email-hverkuil@xs4all.nl>
 <1461922746-17521-3-git-send-email-hverkuil@xs4all.nl>
 <5731CD8E.8090509@ti.com> <5731D379.2050802@xs4all.nl>
In-Reply-To: <5731D379.2050802@xs4all.nl>

--U1223RO4atXLv5vhcFnUP9Nj98TwfeGdV
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 10/05/16 15:26, Hans Verkuil wrote:

>>> diff --git a/arch/arm/boot/dts/omap4.dtsi b/arch/arm/boot/dts/omap4.d=
tsi
>>> index 2bd9c83..1bb490f 100644
>>> --- a/arch/arm/boot/dts/omap4.dtsi
>>> +++ b/arch/arm/boot/dts/omap4.dtsi
>>> @@ -1006,8 +1006,9 @@
>>>  				reg =3D <0x58006000 0x200>,
>>>  				      <0x58006200 0x100>,
>>>  				      <0x58006300 0x100>,
>>> -				      <0x58006400 0x1000>;
>>> -				reg-names =3D "wp", "pll", "phy", "core";
>>> +				      <0x58006400 0x900>,
>>> +				      <0x58006D00 0x100>;
>>> +				reg-names =3D "wp", "pll", "phy", "core", "cec";
>>
>> "core" contains four blocks, all of which are currently included there=

>> in the "core" space. I'm not sure why they weren't split up properly
>> when the driver was written, but I think we should either keep the cor=
e
>> as one big block, or split it up to those four sections, instead of ju=
st
>> separating the CEC block.
>=20
> I don't entirely agree with that, partially because it would mean extra=
 work for
> me :-) and partially because CEC is different from the other blocks in =
that it
> is an optional HDMI feature.

I don't think it matters in this context if it's an optional HDMI
feature or not. This is about representing the HW memory areas, and I'd
like to keep it consistent, so either one big block, or if we want to
split it, split it up properly as shown in the TRM.

I'm fine with keeping one big "core" memory area there, that should work
fine for CEC, shouldn't it? And it would be the easiest option for you ;)=
=2E

>=20
>>
>>>  				interrupts =3D <GIC_SPI 101 IRQ_TYPE_LEVEL_HIGH>;
>>>  				status =3D "disabled";
>>>  				ti,hwmods =3D "dss_hdmi";
>>> diff --git a/drivers/gpu/drm/omapdrm/dss/Kconfig b/drivers/gpu/drm/om=
apdrm/dss/Kconfig
>>> index d1fa730..69638e9 100644
>>> --- a/drivers/gpu/drm/omapdrm/dss/Kconfig
>>> +++ b/drivers/gpu/drm/omapdrm/dss/Kconfig
>>> @@ -71,9 +71,17 @@ config OMAP4_DSS_HDMI
>>>  	bool "HDMI support for OMAP4"
>>>          default y
>>>  	select OMAP2_DSS_HDMI_COMMON
>>> +	select MEDIA_CEC_EDID
>>
>> Hmm, what's in MEDIA_CEC_EDID, why does OMAP4 HDMI need to select that=
?
>=20
> Helper functions that manipulate the physical address in an EDID. CEC m=
ay be
> optional, but the EDID isn't. These functions were just too big to make=
 them
> static inlines, so instead it's a simple module.

Oh, I see, even if OMAP4's HDMI CEC is disabled, you use cec edid
functions in hdmi4.c.

>>> diff --git a/drivers/gpu/drm/omapdrm/dss/Makefile b/drivers/gpu/drm/o=
mapdrm/dss/Makefile
>>> index b651ec9..37eb597 100644
>>> --- a/drivers/gpu/drm/omapdrm/dss/Makefile
>>> +++ b/drivers/gpu/drm/omapdrm/dss/Makefile
>>> @@ -10,6 +10,9 @@ omapdss-$(CONFIG_OMAP2_DSS_SDI) +=3D sdi.o
>>>  omapdss-$(CONFIG_OMAP2_DSS_DSI) +=3D dsi.o
>>>  omapdss-$(CONFIG_OMAP2_DSS_HDMI_COMMON) +=3D hdmi_common.o hdmi_wp.o=
 hdmi_pll.o \
>>>  	hdmi_phy.o
>>> +ifeq ($(CONFIG_OMAP2_DSS_HDMI_CEC),y)
>>> +  omapdss-$(CONFIG_OMAP2_DSS_HDMI_COMMON) +=3D hdmi_cec.o
>>> +endif
>>
>> The file should be hdmi4_cec.o, as it's for omap4. And why the ifeq?
>> Isn't just
>>
>> omapdss-$(OMAP4_DSS_HDMI_CEC) +=3D hdmi4_cec.o
>=20
> OMAP4_DSS_HDMI_CEC is a bool, not a tristate.

Yes, and that's fine. You're not compiling hdmi4_cec.o as a module,
you're compiling it into omapdss.o. Objects are added with "omapdss-y +=3D=

xyz" to omapdss.o.

 Tomi


--U1223RO4atXLv5vhcFnUP9Nj98TwfeGdV--

--Xpi7KPaD9N2KokQiMldDDPEfG8JTUcQEr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXMdcLAAoJEPo9qoy8lh71qGwP/1aQvPSiRbgXYfaw9nOM5u3I
7ByyGVl+0a2YO7a79bA7gGJ5jFf8L/ygejW1/PpD2WSNe8Q3Sb0B/BzM+T8K/6eR
6b3pa59kBuMfoUW1Mo1R2C59XSMbwqZRJ+bKULPl+LnBpeiuKFPAMdO2M6WjtCym
UZE9LML7tJg9yDxvQdtOu0ll4YDs8cyW0LtFMe57lnnDOPp2cqmOzMNcUks3fNGO
ZzLVFvS5NtS/bo9ea2wnqDPe02c0XqdmZVp9wMKX0KAVjrGPUP+QrTwu93rclQVI
q0Pnyl2EU9FrDikrZuu+RGbKSXNTrTUiE02+PQmzq+7pdZlQKziC4kcM79AIlncm
PBMz6+rR+6boq6Y7ARaFn4Vt2mIBk4d4bdeEQohkLDtqlbjAnjuhLxCjHPPTBNbY
+YWKQ/BPCAwI0xrs9WgmnxjzsQMSkNIqm+yjzowSjCKCZ0bO6aZHCZvGunrBmFDv
/DUMdz0vM7c14BzM2bLdCtbfwGcn35CsvzybFs9fBkdlkYiB4d+Y0Hw2F3Fpw7Ra
mv30wOfWtgJkMNtIjGL/jpTvVgw1y+NKGe4Na0BDnqgNPYciRBh6bRZnfB7oc0DW
RxjK9pPfQE8Yyc7G5xmb+D581NKwc2b6dA9ndt7FJu3t/iCcgO9MvMCj0Zss8vzZ
WWYks95Rz3GiHr0ORN5k
=fvBc
-----END PGP SIGNATURE-----

--Xpi7KPaD9N2KokQiMldDDPEfG8JTUcQEr--
