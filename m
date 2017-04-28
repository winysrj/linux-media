Return-path: <linux-media-owner@vger.kernel.org>
Received: from fllnx209.ext.ti.com ([198.47.19.16]:20207 "EHLO
        fllnx209.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2992569AbdD1Lw5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Apr 2017 07:52:57 -0400
Subject: Re: [PATCH 0/8] omapdrm: add OMAP4 CEC support
To: Hans Verkuil <hverkuil@xs4all.nl>, <linux-media@vger.kernel.org>
References: <20170414102512.48834-1-hverkuil@xs4all.nl>
CC: <dri-devel@lists.freedesktop.org>
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
Message-ID: <15ba27fd-ed40-4bb4-ed7e-ebd3428ae7f4@ti.com>
Date: Fri, 28 Apr 2017 14:52:10 +0300
MIME-Version: 1.0
In-Reply-To: <20170414102512.48834-1-hverkuil@xs4all.nl>
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature";
        boundary="1S5MTVnMWiB707CMO4POu8v9UvpJLLT1x"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--1S5MTVnMWiB707CMO4POu8v9UvpJLLT1x
Content-Type: multipart/mixed; boundary="GW4kAEDsQoJLwKHREihrKg6W25ekXlLqF";
 protected-headers="v1"
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org
Message-ID: <15ba27fd-ed40-4bb4-ed7e-ebd3428ae7f4@ti.com>
Subject: Re: [PATCH 0/8] omapdrm: add OMAP4 CEC support
References: <20170414102512.48834-1-hverkuil@xs4all.nl>
In-Reply-To: <20170414102512.48834-1-hverkuil@xs4all.nl>

--GW4kAEDsQoJLwKHREihrKg6W25ekXlLqF
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 14/04/17 13:25, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>=20
> This patch series adds support for the OMAP4 HDMI CEC IP core.

What is this series based on? It doesn't apply to drm-next, and:
fatal: sha1 information is lacking or useless
(drivers/gpu/drm/omapdrm/dss/hdmi4.c).

 Tomi


--GW4kAEDsQoJLwKHREihrKg6W25ekXlLqF--

--1S5MTVnMWiB707CMO4POu8v9UvpJLLT1x
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJZAyzqAAoJEPo9qoy8lh71asYP/1VUFGHlL8sSyujgbuHIC90u
rzRlLO2S5oToP14QsA/hgYnv1BfbOFbmQDzfV7SKPF36N6bXcl+sYRxLxjUcrNJq
CFyrtqMxGzatbc/8Gk1nyrATj/iIg9N4GFzJ65wqHqesdDaWxqBSKId+g85fgThn
EL06039+ZRi/Q4oMLb9B3/uZBDRH/eXUz6flTn+6Ch5+3iV1qbouYKZOAAtGvcKr
pvvUskRCTZPGJPnPFu6jSOTc/KI/35HYGGQhLVIf4QDNzDY3xuXctaS9/PrFwYKS
9GPfqfj5Fbkpxml8C775KIZiNQsDQLtnrnfmt5FMgoXnMZvoXESALXXK+wC27JHp
53vgBX9vtWiseRq2clguerWe/lc6KiQUiXL3ANPbaBP/3tWMNOrcztFHcJ+/DuBe
WMAcb3b9HcSl8MDQMXFPA1EumkALJepkDNL9Lh+mnSxuyZENwUEcDaIro3RRG93c
OtqUpBxK1GYgfBzjF4UjkFAT/2eUbPFFdH6f8i9tRZ1M1UWEkYXI6JKI78y8yebM
lz6r2tytEpoRT0qH0/5ggsvsO4ORdhytpyzI7P0i3oNzjsmD9u7b+IgofFPdv1db
ru5ZbJ8qPxzzSaPraf/mYVTWVJwGdPPtCyU21vkXaGmYggNRXMKUI18xNUFp4sjE
IcOj1MCZnnm3d2KGAbP9
=rlsZ
-----END PGP SIGNATURE-----

--1S5MTVnMWiB707CMO4POu8v9UvpJLLT1x--
