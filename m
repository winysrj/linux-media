Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([88.99.104.3]:54952 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934279AbeE2N3b (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 May 2018 09:29:31 -0400
Date: Tue, 29 May 2018 15:29:29 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [PATCH v5 03/14] media: ov772x: allow i2c controllers without
 I2C_FUNC_PROTOCOL_MANGLING
Message-ID: <20180529132929.zthorwdp2axxogvd@ninjato>
References: <1525616369-8843-1-git-send-email-akinobu.mita@gmail.com>
 <1525616369-8843-4-git-send-email-akinobu.mita@gmail.com>
 <20180529095657.675a6f54@vento.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="pwpmbjybypmcd3dm"
Content-Disposition: inline
In-Reply-To: <20180529095657.675a6f54@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--pwpmbjybypmcd3dm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> It is a very bad idea to replace an i2c xfer by a pair of i2c
> send()/recv(), as, if are there any other device at the bus managed
> by an independent driver, you may end by mangling i2c transfers and
> eventually cause device malfunctions.

For I2C, this is true and a very important detail. Yet, we are talking
not I2C but SCCB here and SCCB demands a STOP between messages. So,
technically, to avoid what you describe one shouldn't mix I2C and SCCB
devices. I am quite aware the reality is very different, but still...

My preference would be to stop acting as SCCB was I2C but give it its
own set of functions so it becomes clear for everyone what protocol is
used for what device.

> So, IMO, the best is to push the patch you proposed that adds a
> new I2C flag:
>=20
> 	https://patchwork.linuxtv.org/patch/49396/

Sorry, but I don't like it. This makes the I2C core code very
unreadable. This is why I think SCCB should be exported to its own
realm. Which may live in i2c-core-sccb.c, no need for a seperate
subsystem.


--pwpmbjybypmcd3dm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAlsNVbgACgkQFA3kzBSg
Kba5JBAAi4g9h/VsyOu4z5VQ2zyIXoUZEQfUNZiKw/SlGHUETd7fLIeOM6L2Z/O9
htDkO8RTvqvEW4ex8h/pGhgGZK3Fff/rTSsjJkqJGMyiclcYAC7jleXkvHhRIxUM
IF2Le3RgqzAFZal5SWUoTTOTuLfjKEnIA2KqEwn4RuiKC7fl9dYLO5S3Dg8R10QD
lRhWD6opafEV1vgUPIWwURTkaIBPLRpL16yL6X3woshme9bwSui2CX/S+b2Wwz8i
0vuH4PytRYryAlDZLICaB55ggnBndaCMt7y5Ev5pktV0BUEK/Aybhsxa4zWedfFJ
hdTKAdzLXoHbRvc10HASe316Ti5JN03ulZ9okSrGMtWWTl2kexJVRs17GKkXDIwn
IYuGiOI8385KtjLu5JFSNEtVbZKFqskuZq90IIqA99CydWLwDjmmuNKYhFJAUdI0
Ioqo9NGd5gpPzGdEEGtg+WEjchiHC2rQTqS/6IknPwG2X+zP2horAxZP4k6qYKAx
DFDk8uGA+Ym7HvlC1dV9OZ8F3ESPZY3EUJE6i+KaNMkacCKACc2fcrwXE7jwT6S7
8oRSYQ4kFjUDQyY0MT48EwbeWr5jYT9Oq7p47ov4C6Z5wH2/mrqXRkOhyUG33eKr
HahxAtvorwAX6U+D2aGxSLD3v3asDXUY2wDVAfQVW3my5LtR82c=
=wr1c
-----END PGP SIGNATURE-----

--pwpmbjybypmcd3dm--
