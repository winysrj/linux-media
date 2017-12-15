Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:57662 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753443AbdLOKu7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Dec 2017 05:50:59 -0500
Date: Fri, 15 Dec 2017 11:50:47 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Yong <yong.deng@magewell.com>
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
Message-ID: <20171215105047.ist7epuida2uao74@flea.lan>
References: <1501131697-1359-1-git-send-email-yong.deng@magewell.com>
 <1501131697-1359-2-git-send-email-yong.deng@magewell.com>
 <20171121154827.5a35xa6zlqrrvkxx@flea.lan>
 <20171122093306.d30fe641f269d62daa1f66b4@magewell.com>
 <20171122094526.nqxfy2e5jzxw7nl4@flea.lan>
 <20171123091444.4bed66dffeb36ecea8dfa706@magewell.com>
 <20171125160233.skefdpkjy4peh7et@flea.lan>
 <20171204174511.a5be3b521e9a7c7004d32d0d@magewell.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="qmbbh5qnbgzrxgdy"
Content-Disposition: inline
In-Reply-To: <20171204174511.a5be3b521e9a7c7004d32d0d@magewell.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--qmbbh5qnbgzrxgdy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Yong,

On Mon, Dec 04, 2017 at 05:45:11PM +0800, Yong wrote:
> I just noticed that you are using the second iteration?
> Have you received my third iteration?

Sorry for the late reply, and for not coming back to you yet about
that test. No, this is still in your v2. I've definitely received your
v3, I just didn't have time to update to it yet.

But don't worry, my mail was mostly to know if you had tested that
setup on your side to try to nail down the issue on my end, not really
a review or comment that would prevent your patch from going in.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--qmbbh5qnbgzrxgdy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlozqQMACgkQ0rTAlCFN
r3S5cA//dpYxk9jrpAC3W9fK+1dgEg70Fh1dOzOLnKddsyGVnMF0HekUbXzt47dk
bgjGxJC0dAdVgDwZ6D+VQUzQ+yGR0aFsUItRNnfTBpUiZ82MtVb9qBesRIxUb1ci
lrAyIauaY1wZhUCU9oFplEeOzojtCOU5mrYr0kF0qoiG/txocOMUszTD8ZlW5wZp
9bqX0wC/svEga8vtyjqHLevlkVZt0uGDZR4PDSDAMfE7VU1iOiKLR+sHes6PcxA/
EO1EA25SCqtjn9CMjFNdiIJLpGlu+5qj/7WZoSv/CAOmbCVvmZ/p/NHGVyf0gr2e
yhTBjrG+j4jQMxIwlfH39ejz/rIAuRke7NngOI8NNwJbWTm1usFesjsv5FUX6TeV
sQ8amBDRdayp33bg9VVDMHB9kINvA4TxgHJwBx1uX87IXSKDETTPfEA0XTaRdWZO
UkJVXnHW8r4kBEBot71TLAi1vuLC2T1X55wsMzhni3Qq0e0feHoH9aqABBDRaoUN
UUki1DeWIwV0n2CavZn3l2P2eXpj5NZZmuL1glzZemRXCmixnzE4RUGWQp7S7p64
R7b7l0+2nvtKqoQXlWjQ40t2wXvX9Xp+bV17+Wma2vh/aA8CYi6zH1Gbu7F179nZ
E7huH6X5dcmeZDYn7zCE3ipOoSFW/CYAgy4kRHxOC112u/x+ZdY=
=HKDT
-----END PGP SIGNATURE-----

--qmbbh5qnbgzrxgdy--
