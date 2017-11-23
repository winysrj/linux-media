Return-path: <linux-media-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37150 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751731AbdKWBqb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 22 Nov 2017 20:46:31 -0500
Message-ID: <1511401568.14687.13.camel@decadent.org.uk>
Subject: Re: [PATCH 1/1] s2255drv: f2255usb: firmware version 1.2.8
From: Ben Hutchings <ben@decadent.org.uk>
To: Dean Anderson <dean@sensoray.com>, linux-firmware@kernel.org,
        linux-dev@sensoray.com
Cc: linux-media <linux-media@vger.kernel.org>
Date: Thu, 23 Nov 2017 01:46:08 +0000
In-Reply-To: <20171103203339.GA23968@sensoray.com>
References: <20171103203339.GA23968@sensoray.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-vaqCLTB9985Saza0YLBs"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-vaqCLTB9985Saza0YLBs
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2017-11-03 at 13:33 -0700, Dean Anderson wrote:
> Updates the firmware for the s2255drv driver.
> Adds support for NTSC4.43, horizontal/vertical adjustments and
> Motion JPEG capture mode improvements.
>=20
> Signed-off-by: Dean Anderson <dean@sensoray.com>
> ---
>  f2255usb.bin | Bin 180776 -> 181312 bytes
>  1 file changed, 0 insertions(+), 0 deletions(-)
[...]

Applied, thanks.

Ben.

--=20
Ben Hutchings
When in doubt, use brute force. - Ken Thompson


--=-vaqCLTB9985Saza0YLBs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAloWKGAACgkQ57/I7JWG
EQkBUQ/9EJ0VR86Qiulh3PicwhTlsH/CLwNHJsrpneW+B7sfGvkqTZoM2UGTk9+Q
MQMygjFNeTuCHeIT7UAevzSgOoLNt40GoNjv1ZVcDIvJNEUcFp4QOpaONWTnmAX5
CC02SzzahgikUAh8fvpTdVmoBaPumr3ypxMTw3Xf3Y+1smA8QzknHxQPs8AmnlVR
SFTXGzK3ja0R/KK7cC8PcJSxnhuettny4SAWj34JeBgJddOXajkR6I0HYPu3CLRE
y1G/ty5St/3tH9Y5tGGyy1CgRstkvrslKPNP6EoDclgMbdpI2SI829tO62EfDXlr
3WpHvLeyd8HyMZBNap3eyvek314kon2TvMVce36LZUbgdI0qkS+5rT/7b0qXXyTM
hStjPDO/LxC43+OApvLFU0hZirbM6l8AnRGYc0nCsthgnAN0sYdxeH5cfWmO2NMI
BNvsvUcJxlR5aNtXL8Pyzmqzq7ISCSN6W/JQmt4wn5RHJ5S1WqWPhIjHTos8HeKZ
cAov9zw/bpsocNGACzb80J6DRPJZ8bTmrVrJR1jQDemQihO1RMeaP0LjA1KF5aU4
kFplTTxY0ZEobX+icG7bFdwB1oP1iw++g5Vp8RZucIplqn1DtrPyXtsKqOwUvCGh
8bPkDalCqqVFYf+WOW+G1D3zIynGbDN2v43WRT5lX03F5aNmNDI=
=yTbs
-----END PGP SIGNATURE-----

--=-vaqCLTB9985Saza0YLBs--
