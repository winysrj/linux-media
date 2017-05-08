Return-path: <linux-media-owner@vger.kernel.org>
Received: from anholt.net ([50.246.234.109]:56172 "EHLO anholt.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750769AbdEHQdl (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 8 May 2017 12:33:41 -0400
From: Eric Anholt <eric@anholt.net>
To: Alexandru Gheorghe <Alexandru_Gheorghe@mentor.com>,
        Alexandru_Gheorghe@mentor.com, laurent.pinchart@ideasonboard.com,
        linux-renesas-soc@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-media@vger.kernel.org, geert@linux-m68k.org,
        sergei.shtylyov@cogentembedded.com
Subject: Re: [PATCH v2 0/2] rcar-du, vsp1: rcar-gen3: Add support for colorkey alpha blending
In-Reply-To: <1494152007-30094-1-git-send-email-Alexandru_Gheorghe@mentor.com>
References: <1494152007-30094-1-git-send-email-Alexandru_Gheorghe@mentor.com>
Date: Mon, 08 May 2017 09:33:37 -0700
Message-ID: <8737cf2tr2.fsf@eliezer.anholt.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Alexandru Gheorghe <Alexandru_Gheorghe@mentor.com> writes:

> Currently, rcar-du supports colorkeying  only for rcar-gen2 and it uses=20
> some hw capability of the display unit(DU) which is not available on gen3.
> In order to implement colorkeying for gen3 we need to use the colorkey
> capability of the VSPD, hence the need to change both drivers rcar-du and
> vsp1.
>
> This patchset had been developed and tested on top of v4.9/rcar-3.5.1 from
> git://git.kernel.org/pub/scm/linux/kernel/git/horms/renesas-bsp.git

A few questions:

Are other drivers interested in supporting this property?  VC4 has the
24-bit RGB colorkey, but I don't see YCBCR support.  Should it be
documented in a generic location?

Does your colorkey end up forcing alpha to 1 for the plane when it's not
matched?

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE/JuuFDWp9/ZkuCBXtdYpNtH8nugFAlkQneEACgkQtdYpNtH8
nujfPxAAsxDuMTj2LBzK2oQ+xOAqWJhCFP6qwtAA9RZsPDkBFfPcPahXuyZwqKy/
gGi86uVXJV/8oSN6il2X34UNGa1NPkyZ8Ar29US267pVWo/Pvdqil7wKW6/XCTxN
5MfKrhCb00TSPJXSUlSWYGHirQ4vqUrjSqeH+teq0HnxBNWemp82zbWzuYfQY+ia
AEriRxOB8a++M0pNbXHD/YzT/vJ5lejka8ubgnyhLr4c5FkRdI6NazL+77RUTzQI
7OTDTCembI9XQGFL6Wtg8KsUP93gjBbAHjHH4yXqEoqh/ZvYNJwCIkx50mqBGjZY
QR/hx7ysFz9CLofA9nR7DNFpe4F9CD7Ly2+zmorfrQ/k76FHuxVgXqDheHT3xof2
2y5sPYHiQ9WQM0blQWjMVr8IhHAuygKdEGe2ZhWbpoeWQRhyVYVu62/oEvDSdK76
pdhH7g/ttuK/50m7rjdCMOH0ebk3upEebOCc63wOePyofxM/QTYiyvfrhzOpYy+f
5fKhdo4y/Qr4CMRzLJ4KRWeKLvzMD+3Ve/BjrDqt9ERMQCc0+HBxPECRsN1LKpF5
3UoadsDtf3IsmlC9VEc5zQoszU7ZaUUda6OHO4JBXIGEjKd4SRgVqDwCYZe/77OZ
IG0z2N9PyoSBzC6FhE/BOGmfmpXhvtycy3K2tYx09++X7bQfyVE=
=E7/0
-----END PGP SIGNATURE-----
--=-=-=--
