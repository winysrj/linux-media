Return-path: <linux-media-owner@vger.kernel.org>
Received: from fllnx209.ext.ti.com ([198.47.19.16]:52864 "EHLO
        fllnx209.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751615AbdDJMAu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Apr 2017 08:00:50 -0400
Subject: Re: [RFC PATCH 3/3] encoder-tpd12s015: keep the ls_oe_gpio on while
 the phys_addr is valid
To: Hans Verkuil <hverkuil@xs4all.nl>, <linux-media@vger.kernel.org>
References: <1461922746-17521-1-git-send-email-hverkuil@xs4all.nl>
 <1461922746-17521-4-git-send-email-hverkuil@xs4all.nl>
 <5731C7D2.4090807@ti.com> <5b6f679c-69dd-78be-a398-30aa4b4da1db@xs4all.nl>
CC: <dri-devel@lists.freedesktop.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
Message-ID: <1d801302-388b-1d00-f0be-18aaef8cf80f@ti.com>
Date: Mon, 10 Apr 2017 14:59:58 +0300
MIME-Version: 1.0
In-Reply-To: <5b6f679c-69dd-78be-a398-30aa4b4da1db@xs4all.nl>
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature";
        boundary="pUkXW6bewUWiVtfobiNPACqHuQTvFSLKB"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--pUkXW6bewUWiVtfobiNPACqHuQTvFSLKB
Content-Type: multipart/mixed; boundary="EH0nmsPIkJxPxueJpVXAHwi31kVVWbjUF";
 protected-headers="v1"
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, Hans Verkuil <hans.verkuil@cisco.com>
Message-ID: <1d801302-388b-1d00-f0be-18aaef8cf80f@ti.com>
Subject: Re: [RFC PATCH 3/3] encoder-tpd12s015: keep the ls_oe_gpio on while
 the phys_addr is valid
References: <1461922746-17521-1-git-send-email-hverkuil@xs4all.nl>
 <1461922746-17521-4-git-send-email-hverkuil@xs4all.nl>
 <5731C7D2.4090807@ti.com> <5b6f679c-69dd-78be-a398-30aa4b4da1db@xs4all.nl>
In-Reply-To: <5b6f679c-69dd-78be-a398-30aa4b4da1db@xs4all.nl>

--EH0nmsPIkJxPxueJpVXAHwi31kVVWbjUF
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 08/04/17 13:11, Hans Verkuil wrote:

> So, this is a bit of a blast from the past since the omap4 CEC developm=
ent
> has been on hold for almost a year. But I am about to resume my work on=
 this
> now that the CEC framework was merged.
>=20
> The latest code is here, if you are interested:
>=20
> https://git.linuxtv.org/hverkuil/media_tree.git/log/?h=3Dpanda-cec
>=20
> It's pretty much unchanged from the version I posted a year ago, just r=
ebased.
>=20
> But before I continue with this I have one question for you. First some=

> background:
>=20
> There is a special corner case (and I wasn't aware of that a year ago!)=
 where
> it is allowed to send a CEC message when there is *no HPD*.
>=20
> The reason is that some displays turn off the hotplug detect pin when t=
hey go
> into standby or when another input is active. The only way to communica=
te with
> such displays is via CEC.
>=20
> The problem is that without a HPD there is no EDID and basically no way=
 for an
> HDMI transmitter to detect that something is connected at all, unless y=
ou are
> using CEC.
>=20
> What this means is that if we want to implement this on the omap4 the C=
EC support
> has to be on all the time.
>=20
> We have seen modern displays that behave like this, so this is a real i=
ssue. And
> this corner case is specifically allowed by the CEC specification: the =
Poll,
> Image/Text View On and the Active Source messages can be sent to a TV e=
ven when
> there is no HPD in order to turn on the display if it was in standby an=
d to make
> us the active input.
>=20
> The CEC framework in the kernel supports this starting with 4.12 (this =
code is
> in the panda-cec branch above).
>=20
> If this *can't* be supported by the omap4, then I will likely have to a=
dd a CEC
> capability to signal to the application that this specific corner case =
is not
> supported.
>=20
> I just did some tests with omap4 and I my impression is that this can't=
 be
> supported: when the HPD goes away it seems like most/all of the HDMI bl=
ocks are
> all powered off and any attempt to even access the CEC registers will f=
ail.
>=20
> Changing this looks to be non-trivial if not impossible.
>=20
> Can you confirm that that isn't possible? If you think this can be done=
, then
> I'd appreciate if you can give me a few pointers.

HPD doesn't control the HW, it's all in the SW. So while I don't know
much at all about CEC and haven't looked at this particular use case, I
believe it's doable. HPD going off will make the DRM connector to be in
"disconnected" state, which on omapdrm will cause everything about HDMI
to be turned off.

Does it work on some other DRM driver? I'm wondering if there's
something in the DRM framework side that also has to be changed, in
addition to omapdrm changes.

It could require larger SW redesigns, though... Which makes me think
that the work shouldn't be done until we have changed the omapdrm's
driver model to DRM's common bridge driver model, and then all this
could possibly be done in a more generic manner.

Well, then again, I think the hdmi driver's internal power state
handling could be improved even before that. Currently it's not very
versatile. We should have ways to partially enable the IP for just the
required parts.

 Tomi


--EH0nmsPIkJxPxueJpVXAHwi31kVVWbjUF--

--pUkXW6bewUWiVtfobiNPACqHuQTvFSLKB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJY63O+AAoJEPo9qoy8lh71WMAP/AtfHaiBrgyi0KWEV8x7m9sn
6XFkPTJtbVqmlfhk02joFM2C5bZhznlIIDhV5+Jkmg2+3hYDsS1SrXY4Dl1YYEuM
dGw7TBbFkwOEREBMC7xV3Y5szr7pYY2WQPFBoai5e4sotSVgMAKKdp022CVsohI1
isO5NVBjiHx1by5NgO8rDTARyZ8qjD+o8QYyGTfQsdJlivuDX4pN6KhHFGXCPDYH
ufkjBLJTzOV1M1g7gvpT+XMkRFPdbYpOOhO+jKwweZfKyi4/Y8rsYjyztoeHuIW+
U5FZN+IkW9TgoQx14Lvt/iiNKhipmePbTLk+SzCyobOAT/aZ2M4Ijbc6mrikIWPO
fDAmgHbh6HaBXpmCseWCuLXXDQnWx7aStJB3in+UnS+9mvomvKeYKbo7WYoxFyOz
TazY+6cA49TGsi5pTbqfc6wIm3h8vaMqP42gl96J6cEuFMQ3Js6O3EstnRG/G+3p
v8pGNqU54PY6U0Ho8Uq0Ud3SOhF92k4HVd3K2pBrHkJ1C2vfzJ6Jpt4WuZ0nXKmD
EUIbIRDUut8dhnVjXNmx5X0Lba7EAAyTueioQNZQHEUp0SQIz6zgQRYEm+NN7G+6
cmHXlKgrBzvdJDvjELrBm4nWf53qCIAKRnbzQoBJXkQBmKG8+HzFeQA05slIuPHW
ct/TjGM9SIlc/xyOxg1S
=KwIH
-----END PGP SIGNATURE-----

--pUkXW6bewUWiVtfobiNPACqHuQTvFSLKB--
