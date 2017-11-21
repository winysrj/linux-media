Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:58621 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750794AbdKUPs3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Nov 2017 10:48:29 -0500
Date: Tue, 21 Nov 2017 16:48:27 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Yong Deng <yong.deng@magewell.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Arnd Bergmann <arnd@arndb.de>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Yannick Fertre <yannick.fertre@st.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Benoit Parrot <bparrot@ti.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Minghsiu Tsai <minghsiu.tsai@mediatek.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH v2 1/3] media: V3s: Add support for Allwinner CSI.
Message-ID: <20171121154827.5a35xa6zlqrrvkxx@flea.lan>
References: <1501131697-1359-1-git-send-email-yong.deng@magewell.com>
 <1501131697-1359-2-git-send-email-yong.deng@magewell.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="curnxkdqsfdlcs6k"
Content-Disposition: inline
In-Reply-To: <1501131697-1359-2-git-send-email-yong.deng@magewell.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--curnxkdqsfdlcs6k
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Jul 27, 2017 at 01:01:35PM +0800, Yong Deng wrote:
> Allwinner V3s SoC have two CSI module. CSI0 is used for MIPI interface
> and CSI1 is used for parallel interface. This is not documented in
> datasheet but by testing and guess.
>=20
> This patch implement a v4l2 framework driver for it.
>=20
> Currently, the driver only support the parallel interface. MIPI-CSI2,
> ISP's support are not included in this patch.
>=20
> Signed-off-by: Yong Deng <yong.deng@magewell.com>

Thanks again for this driver.

It seems like at least this iteration is behaving in a weird way with
DMA transfers for at least YU12 and NV12 (and I would assume YV12).

Starting a transfer of multiple frames in either of these formats,
using either ffmpeg (ffmpeg -f v4l2 -video_size 640x480 -framerate 30
-i /dev/video0 output.mkv) or yavta (yavta -c80 -p -F --skip 0 -f NV12
-s 640x480 $(media-c tl -e 'sun6i-csi')) will end up in a panic.

The panic seems to be generated with random data going into parts of
the kernel memory, the pattern being in my case something like
0x8287868a which is very odd (always around 0x88)

It turns out that when you cover the sensor, the values change to
around 0x28, so it really seems like it's pixels that have been copied
there.

I've looked quickly at the DMA setup, and it seems reasonable to
me. Do you have the same issue on your side? Have you been able to
test those formats using your hardware?

Given that they all are planar formats and YUYV and the likes work
just fine, maybe we can leave them aside for now?

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--curnxkdqsfdlcs6k
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJaFErLAAoJEBx+YmzsjxAgYvYP/1REuU2S0Dqz3CEpFOdHBXhi
jceyy0Q43KGFaC2oRJd1zfjGX0E1zl6u6QScxpPe3OD6Z+jU/nMRinYGnd8LFFuy
USCXwLi3k+a08alg/SFZa9hLOWBxqG2bXvCg4LUM9UKMVPwwUfTQjwHC2C+knIFA
JZeVWlstddXVYMh2DAuzAOCReUZ8Q3Gw8p6NFUWeVDDk6l6ZsPRGWp4zRDr6qe2X
fH/npI3UuCfoD2eoCYTbLP7KHI9pWH/VaC9+/kj9eBte2GCdd7k2hMjSQxmPByf5
OkknmcATR01AirAeOvLVkx4TIjKeXUXGysmJAb3BbJa69/gVQ2WTH06M0U3+3u0L
Ihh7cZVy7h02R2AnSVWvTptMAWY/4T7W4gbYjG7qYTcUWOGHFJ0RFPPmVr2j3ODj
RU3zDwtkF6cjaRB3EHP8VaxfJPG4ZUY37dgR//cF6TEjyV6aWKV7l+0JYLSdiWR9
IOGlZb6VKRTc3sjqTLEzb+jMQ1UgCvtCD97MjyBHa1TmloasLl4cIymDQglHvTKR
dJsM1YYddyqSn6S8AsJ4hJZgMpdyNEoZEKAYIs2vcavLlUHxeTiruxZUDlbRudtq
C1wrKo/A4lMBqUob6Zm/Ao4e5OCO8I4fw9rXyn+1CTt34IZfe4HAgfS2KQdzqgHD
M3yzWIwATcKhcvAbOanm
=DpOg
-----END PGP SIGNATURE-----

--curnxkdqsfdlcs6k--
