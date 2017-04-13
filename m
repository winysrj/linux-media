Return-path: <linux-media-owner@vger.kernel.org>
Received: from lelnx194.ext.ti.com ([198.47.27.80]:15706 "EHLO
        lelnx194.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756213AbdDMJ0V (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Apr 2017 05:26:21 -0400
Subject: Re: [RFC PATCH 3/3] encoder-tpd12s015: keep the ls_oe_gpio on while
 the phys_addr is valid
To: Hans Verkuil <hverkuil@xs4all.nl>, <linux-media@vger.kernel.org>
References: <1461922746-17521-1-git-send-email-hverkuil@xs4all.nl>
 <1461922746-17521-4-git-send-email-hverkuil@xs4all.nl>
 <5731C7D2.4090807@ti.com> <5b6f679c-69dd-78be-a398-30aa4b4da1db@xs4all.nl>
 <1d801302-388b-1d00-f0be-18aaef8cf80f@ti.com>
 <5d47b07d-1866-f832-0d06-e834e7e2aebb@xs4all.nl>
 <fc682c3d-3ab3-0d0f-3bb7-f6dc62f477f6@ti.com>
 <54a864cd-00b8-3e5f-94d6-ceee1248cd53@xs4all.nl>
 <d4b49cb9-7147-c2f4-7e14-99dce1a05708@ti.com>
 <f139d50e-c186-5f00-2a84-a09bf32ab5f6@xs4all.nl>
CC: <dri-devel@lists.freedesktop.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
Message-ID: <4bd89a0a-6505-f7b7-1d86-c83a3cf37e01@ti.com>
Date: Thu, 13 Apr 2017 12:26:17 +0300
MIME-Version: 1.0
In-Reply-To: <f139d50e-c186-5f00-2a84-a09bf32ab5f6@xs4all.nl>
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature";
        boundary="OqWQPhj6OnualJJHqqQrgaqgBhnd6eFD8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--OqWQPhj6OnualJJHqqQrgaqgBhnd6eFD8
Content-Type: multipart/mixed; boundary="GkQ4wE4vj9ur14GJCO8k3k4TvakMcXppS";
 protected-headers="v1"
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, Hans Verkuil <hans.verkuil@cisco.com>
Message-ID: <4bd89a0a-6505-f7b7-1d86-c83a3cf37e01@ti.com>
Subject: Re: [RFC PATCH 3/3] encoder-tpd12s015: keep the ls_oe_gpio on while
 the phys_addr is valid
References: <1461922746-17521-1-git-send-email-hverkuil@xs4all.nl>
 <1461922746-17521-4-git-send-email-hverkuil@xs4all.nl>
 <5731C7D2.4090807@ti.com> <5b6f679c-69dd-78be-a398-30aa4b4da1db@xs4all.nl>
 <1d801302-388b-1d00-f0be-18aaef8cf80f@ti.com>
 <5d47b07d-1866-f832-0d06-e834e7e2aebb@xs4all.nl>
 <fc682c3d-3ab3-0d0f-3bb7-f6dc62f477f6@ti.com>
 <54a864cd-00b8-3e5f-94d6-ceee1248cd53@xs4all.nl>
 <d4b49cb9-7147-c2f4-7e14-99dce1a05708@ti.com>
 <f139d50e-c186-5f00-2a84-a09bf32ab5f6@xs4all.nl>
In-Reply-To: <f139d50e-c186-5f00-2a84-a09bf32ab5f6@xs4all.nl>

--GkQ4wE4vj9ur14GJCO8k3k4TvakMcXppS
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 13/04/17 12:12, Hans Verkuil wrote:

>> Is there anything else CEC needs to access or control (besides the CEC=

>> IP itself)?
>=20
> The CEC framework needs to be informed about the physical address conta=
ined
> in the EDID (part of the CEA-861 block). And when the HPD goes down it =
needs
> to be informed as well (same call, but with CEC_PHYS_ADDR_INVALID as ar=
gument).

Ah, hmm... And currently that's (kind of) handled in
hdmi_power_off_full() by setting CEC_PHYS_ADDR_INVALID? That's not the
same thing as HPD off, though, but maybe it's enough (for now).

 Tomi


--GkQ4wE4vj9ur14GJCO8k3k4TvakMcXppS--

--OqWQPhj6OnualJJHqqQrgaqgBhnd6eFD8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJY70Q5AAoJEPo9qoy8lh71vZYP/1InYg6Ku6aU+5tvwcRubi5b
P8Uxinu528mQQqRV8XfeqU/oH6RAJT0Syw0fKF+aApEqAw/gvR513OgwBqoN5353
36mwahf/uYfCHZ7NfhKhsz2OSuxTNZis77DJc4HQN+udeLmzW/dDa5o6dnB/SdSH
YzLl5I+1MA+YdqKKC4d8G8Gk+WH+IJmHrk0Ckd100ULrJPxkCU/X1QL8xOYsUtZA
earv9HoPtUirZaCBbcR8i9zya3qHz5vaTMiEzneLa/P1Yet8PPtmwA5mZNz+lhbD
7pRV9nGwm2TwRYlRHg5wSfRVCiXOdsUy6B5iP5b+B/254Me/HDX9i2gQ11GjGj20
doD3aopRj4y5MQG4WYb6n9lPyQBJ7oYXVloJhpfqJgh6wf51MTCuIX2iJ2dI3YxA
VMdg+sAobjgkhCAwJzi0lekHexVFUdf8xc1YOETUMX/TgEA8afI8PlWgpncK0gcp
lB+mVWshsVmJdm87pdJe1OATh45/392moPMLZ+g5ePTLPBxTrscF9LzVlzTG+lRr
/czBeZEeuyD1CD3KxrrgcAnZiTAiA3yGGBsL5noZ5vZSErqmtMuB9ZguPxH2wZXZ
ETgaIlo/03mbSFIQBPrXsw5JEWlyAyb2HvwoPo3j/1GGfAAPGPEe0NH0/WKWQLy6
6pB416k5jzaSa+/yauMW
=fGvu
-----END PGP SIGNATURE-----

--OqWQPhj6OnualJJHqqQrgaqgBhnd6eFD8--
