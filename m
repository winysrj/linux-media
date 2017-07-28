Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:53921 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752027AbdG1Qcc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Jul 2017 12:32:32 -0400
Date: Fri, 28 Jul 2017 18:03:53 +0200
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
Subject: Re: [PATCH v2 2/3] dt-bindings: media: Add Allwinner V3s Camera
 Sensor Interface (CSI)
Message-ID: <20170728160353.gqb2f47v6ujozvxz@flea.lan>
References: <1501131697-1359-1-git-send-email-yong.deng@magewell.com>
 <1501131697-1359-3-git-send-email-yong.deng@magewell.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="l4yhxtsyrl7uef4x"
Content-Disposition: inline
In-Reply-To: <1501131697-1359-3-git-send-email-yong.deng@magewell.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--l4yhxtsyrl7uef4x
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Jul 27, 2017 at 01:01:36PM +0800, Yong Deng wrote:
> Add binding documentation for Allwinner V3s CSI.
>=20
> Signed-off-by: Yong Deng <yong.deng@magewell.com>
> ---
>  .../devicetree/bindings/media/sun6i-csi.txt        | 49 ++++++++++++++++=
++++++
>  1 file changed, 49 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/sun6i-csi.txt
>=20
> diff --git a/Documentation/devicetree/bindings/media/sun6i-csi.txt b/Docu=
mentation/devicetree/bindings/media/sun6i-csi.txt
> new file mode 100644
> index 0000000..f8d83f6
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/sun6i-csi.txt
> @@ -0,0 +1,49 @@
> +Allwinner V3s Camera Sensor Interface
> +------------------------------
> +
> +Required properties:
> +  - compatible: value must be "allwinner,sun8i-v3s-csi"
> +  - reg: base address and size of the memory-mapped region.
> +  - interrupts: interrupt associated to this IP
> +  - clocks: phandles to the clocks feeding the CSI
> +    * ahb: the CSI interface clock

We've been bad at this, but we're trying to have the same clock name
here across all devices, and to use "bus" instead of "ahb".

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--l4yhxtsyrl7uef4x
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJZe2BpAAoJEBx+YmzsjxAgwt4P/ih9Y9bcu4IXwbKWesaz5mCE
/y6QgGIfJTcajWs70lmp/6Uk9ASw/RY13XUEvBUQulnhnrDfILLnlSkgHz8NZ7up
3n++OERZZwzhqb7GfP/UwM+0NZJlkGcHTbZksE2C9tfDWtImQALwH0k3xY/23o+G
v9SbfCNWp3g49YzV6BWcFq11z4Ml4y0DWM0kJW4IJTqcr4DX3SLDn0znpvYm7wto
rlB5QSk6c6K5Eg9F69NYSMxVfm9zQt4qANt249B00tmdgHXxoBwfRzw4i0KLeshv
gWoT8LO+9mjiYhtUZSTUPhocxns1WMihsi4qeWrr5ox6RX+TxO71Aol63hpdDzk/
RxwWh+8NXg4ww0Lygi02+Qy6I0nH/ZCBtUrd4hsMzvDByxArCbIQR9KVqShYgJnL
gtqnyfX5PYV87b38Mmf7C3n5h4Ua980Mucd4SCEDRObQGSAPvcy3etrRGCZXUJzy
YJCBiL5Mxx8T6HL6DWhDyckp5GzTX0Svmlf7W6aaSrML+yK2KXdZCQwDMHupJIuN
N7i3MqM767h1fU16fENP2wAr+OIpEZKlNEjvCMYUqzyss78G3JVONnhkZ4AKNZXy
LYM5yjN2meJgY/P9SrR1A5v1xSfaWZ0787Vb5X5j2qJSiGKAfWfsbuVEOsMVXh/d
73MLNH2a3Chc1Y2oDV42
=/q+Z
-----END PGP SIGNATURE-----

--l4yhxtsyrl7uef4x--
