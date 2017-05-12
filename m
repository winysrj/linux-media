Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.zeus03.de ([194.117.254.33]:56456 "EHLO mail.zeus03.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753373AbdELJ6v (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 12 May 2017 05:58:51 -0400
Date: Fri, 12 May 2017 11:58:48 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Jacopo Mondi <jacopo@jmondi.org>
Cc: laurent.pinchart@ideasonboard.com, mchehab@kernel.org,
        hans.verkuil@cisco.com, sakari.ailus@linux.intel.com,
        sre@kernel.org, magnus.damm@gmail.com,
        wsa+renesas@sang-engineering.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH] media: i2c: ov772x: Force use of SCCB protocol
Message-ID: <20170512095847.GA3147@katana>
References: <1494582763-22385-1-git-send-email-jacopo@jmondi.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="45Z9DzgjV8m4Oswq"
Content-Disposition: inline
In-Reply-To: <1494582763-22385-1-git-send-email-jacopo@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 12, 2017 at 11:52:43AM +0200, Jacopo Mondi wrote:
> Force use of Omnivision's SCCB protocol and make sure the I2c adapter
> supports protocol mangling during probe.
>=20
> Testing done on SH4 Migo-R board.
> As commit:
> [e789029761503f0cce03e8767a56ae099b88e1bd]
> "i2c: sh_mobile: don't send a stop condition by default inside transfers"
> makes the i2c adapter emit a stop bit between messages in a single
> transfer only when explicitly required, the ov772x driver fails to
> probe due to i2c transfer timeout without SCCB flag set.
>=20
> i2c-sh_mobile i2c-sh_mobile.0: Transfer request timed out
> ov772x 0-0021: Product ID error 92:92
>=20
> With this patch applied:
>=20
> soc-camera-pdrv soc-camera-pdrv.0: Probing soc-camera-pdrv.0
> ov772x 0-0021: ov7725 Product ID 77:21 Manufacturer ID 7f:a2
>=20
> Signed-off-by: Jacopo Mondi <jacopo@jmondi.org>

Acked-by: Wolfram Sang <wsa+renesas@sang-engineering.com>


--45Z9DzgjV8m4Oswq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAlkVh1MACgkQFA3kzBSg
KbYbAQ/9EC6+up+kTx9UT36PuggyStzsgqyupu5zceTHS7AnFsACPbALV+lUw2oA
wQ9zg4me3uma4r9YAqHGYZY5CZO5cKIgOhBo7ByxGRGa/RSw6T8NvJCgn1mr36NP
6JcWVEGenyDefpiePjgV5on5wZCDwtpuxIEqDQao/1bgXyoufkV4K/+7P8xoqG6w
+kOdTc7kB+PE0p+WM8647fZeilIIGJeQmQ7TiuRy9ORIZLseTmYQI0sq0xGnbi5E
SC6Oml0hBkU4tdPAGSITDL/Q39AbuO1+86Tvi5WcKAQWivj36RKx8KvtS/hrGmWT
dlB43GZMI7CeEm73yaY4Te04gZKUiXqsp013h0l4Ti8YINkg63aM2fFcQ+had8PB
FJE2nh3RQgkZR9wsQfCgrOWYfChKxuccw2gK6fQw4KO78exw3gUa1+cS5b+ZrvTY
FGUUtxHyf79FCHQgJTRDwjop1Qsmd5z4WkvFMQBX0lVDc4OjOeeOWNVnBH91JV+w
a16IkdQnx1OQ6J05YD2JidpiKBu0/HayUouY347ep5jhusFYiPTO04C86j8AdvWB
IUs3yc00NIE7KTWFQ1kZnORiLWlDPTZ2ydDErr4x/SNe5QK3nhqVtqp3ah+n0l6m
+W8xglo/WbTH4sd+5Gm74qidF/ov7YquwAITLAfzoeIz7FXHfsw=
=kjtD
-----END PGP SIGNATURE-----

--45Z9DzgjV8m4Oswq--
