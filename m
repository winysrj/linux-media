Return-path: <linux-media-owner@vger.kernel.org>
Received: from butterbrot.org ([176.9.106.16]:45390 "EHLO butterbrot.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752256AbeBFJSa (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Feb 2018 04:18:30 -0500
Subject: Re: [PATCH 5/5] add default control values as module parameters
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-input@vger.kernel.org, modin@yuri.at
References: <1517840981-12280-1-git-send-email-floe@butterbrot.org>
 <1517840981-12280-6-git-send-email-floe@butterbrot.org>
 <0be7b0ae-e0e0-7b25-fd76-8cf6387a4dd6@xs4all.nl>
From: Florian Echtler <floe@butterbrot.org>
Message-ID: <a7724625-de74-871f-7728-79b751481970@butterbrot.org>
Date: Tue, 6 Feb 2018 10:18:25 +0100
MIME-Version: 1.0
In-Reply-To: <0be7b0ae-e0e0-7b25-fd76-8cf6387a4dd6@xs4all.nl>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="Vq4OEuC6OZhnCNdvwzDnffhYppb2O2PCS"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Vq4OEuC6OZhnCNdvwzDnffhYppb2O2PCS
Content-Type: multipart/mixed; boundary="wEc2UAGF14PcTCjwPo6j2KzkslocR2Yd4";
 protected-headers="v1"
From: Florian Echtler <floe@butterbrot.org>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-input@vger.kernel.org, modin@yuri.at
Message-ID: <a7724625-de74-871f-7728-79b751481970@butterbrot.org>
Subject: Re: [PATCH 5/5] add default control values as module parameters
References: <1517840981-12280-1-git-send-email-floe@butterbrot.org>
 <1517840981-12280-6-git-send-email-floe@butterbrot.org>
 <0be7b0ae-e0e0-7b25-fd76-8cf6387a4dd6@xs4all.nl>
In-Reply-To: <0be7b0ae-e0e0-7b25-fd76-8cf6387a4dd6@xs4all.nl>

--wEc2UAGF14PcTCjwPo6j2KzkslocR2Yd4
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable

On 05.02.2018 15:56, Hans Verkuil wrote:
> Please add a change log when you make a patch.
> I for one would like to know why this has to be supplied as a module op=
tion.

The idea here was that each individual SUR40 device will likely have slig=
htly
different "ideal" settings for the parameters, and by using the module op=
tions,
you can set them right away at startup.

I'm aware that the usual way to do this would be from userspace using v4l=
2-ctl,
but the SUR40 is sort of a special case: the video settings will also inf=
luence
the internal touch detection, and in the worst case, starting the driver =
with
the default parameters from flash will immediately cause so many false-po=
sitive
touch points to be detected that the graphical shell becomes unusable. Th=
is has
actually happened several times during testing, so we considered a module=
 option
to be the easiest way for dealing with this.

> Some documentation in the code would be helpful as well (e.g. I have no=
 idea
> what a 'vsvideo' is).
Right - will do that, too.

Best regards, Florian
--=20
SENT FROM MY DEC VT50 TERMINAL


--wEc2UAGF14PcTCjwPo6j2KzkslocR2Yd4--

--Vq4OEuC6OZhnCNdvwzDnffhYppb2O2PCS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlp5cuEACgkQ7CzyshGvatjZcACeL0eqkiv3pcSCBOUVKpdNVvaW
GVAAoONHdLxcpy/RQuNTpnjHaqKDOuR/
=Rat+
-----END PGP SIGNATURE-----

--Vq4OEuC6OZhnCNdvwzDnffhYppb2O2PCS--
