Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:41351 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726280AbeKWGtP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Nov 2018 01:49:15 -0500
Date: Thu, 22 Nov 2018 21:08:08 +0100
From: jacopo mondi <jacopo@jmondi.org>
To: Lubomir Rintel <lkundrak@v3.sk>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-media@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        James Cameron <quozl@laptop.org>, Pavel Machek <pavel@ucw.cz>,
        Libin Yang <lbyang@marvell.com>,
        Albert Wang <twang13@marvell.com>
Subject: Re: [PATCH v3 05/14] media: dt-bindings: marvell,mmp2-ccic: Add
 Marvell MMP2 camera
Message-ID: <20181122200341.GA8279@w540>
References: <20181120100318.367987-1-lkundrak@v3.sk>
 <20181120100318.367987-6-lkundrak@v3.sk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="WYTEVAkct0FjGQmd"
Content-Disposition: inline
In-Reply-To: <20181120100318.367987-6-lkundrak@v3.sk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--WYTEVAkct0FjGQmd
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Lubomir,

On Tue, Nov 20, 2018 at 11:03:10AM +0100, Lubomir Rintel wrote:
> Add Marvell MMP2 camera host interface.
>
> Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
>
> ---
> Changes since v2:
> - Added #clock-cells, clock-names, port
>
>  .../bindings/media/marvell,mmp2-ccic.txt      | 37 +++++++++++++++++++
>  1 file changed, 37 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/marvell,mmp2-ccic.txt
>
> diff --git a/Documentation/devicetree/bindings/media/marvell,mmp2-ccic.txt b/Documentation/devicetree/bindings/media/marvell,mmp2-ccic.txt
> new file mode 100644
> index 000000000000..e5e8ca90e7f7
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/marvell,mmp2-ccic.txt
> @@ -0,0 +1,37 @@
> +Marvell MMP2 camera host interface
> +
> +Required properties:
> + - compatible: Should be "marvell,mmp2-ccic"
> + - reg: register base and size
> + - interrupts: the interrupt number
> + - #clock-cells: must be 0
> + - any required generic properties defined in video-interfaces.txt

I don't think video-interfaces applies here. It described bindings to
be used for endpoint and port nodes.

> +
> +Optional properties:
> + - clocks: input clock (see clock-bindings.txt)

What do you think of:
"reference to the input clock as specified by clock-bindings.txt"

> + - clock-names: names of the clocks used, may include "axi", "func" and
> +                "phy"

"may include" is abit vague. Which clock should the interface be
powered from, and in which case?

> + - clock-output-names: should contain the name of the clock driving the
> +                       sensor master clock MCLK

This is a property for the clock provider part, and I will just list
the only clock this interfaces provides here:

    - clock-output-names: Optional clock source for sensors. Shall be "mclk".

See a comment on patch 14 on the use of the clock provider part.

> +
> +Required subnodes:
> + - port: the parallel bus interface port with a single endpoint linked to
> +         the sensor's endpoint as described in video-interfaces.txt
> +
> +Example:
> +
> +	camera0: camera@d420a000 {
> +		compatible = "marvell,mmp2-ccic";
> +		reg = <0xd420a000 0x800>;
> +		interrupts = <42>;
> +		clocks = <&soc_clocks MMP2_CLK_CCIC0>;
> +		clock-names = "axi";
> +		#clock-cells = <0>;
> +		clock-output-names = "mclk";
> +
> +		port {
> +			camera0_0: endpoint {
> +				remote-endpoint = <&ov7670_0>;

I'm debated, your sensor does not support configuring the parallel bus,
that's fine, but as "bindings describe hardware" shouldn't you list
here the bus configurations the HW interface supports and list their default
values? Or there are none for real in this platform?

Thanks
  j


> +			};
> +		};
> +	};
> --
> 2.19.1
>

--WYTEVAkct0FjGQmd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJb9wyoAAoJEHI0Bo8WoVY8kNsQAMWdo1PGvEDT/0hXiQpdwfVn
ZRcLhIGbHMEWIhOO0brNQ01jGKgK2rthDmEL71J/GNraq9bKWE1HKMovALc1n7Il
QxHrjF82R4bB8zxc8LyMgTVd0Ak/YJ9MiGtqdkPK0Rsl/XorGdtIe690aEbghJ3e
4IFn7viugujDOsUFNoT5d61nkFe2mRtdgk+qMaZ+dWYQsRZtUKiqAkuZsJyeYgwD
L9MPwc9iVKHhS3cPMucQJtlcKKZ3VfCPm7QSPuZiOe5cEQ2VkUU8oejJ/mN4RBtM
WziB1B9OMVkd2d1JcyiLWMoTEqxyWSLO1xgKHwNvyumwQwDDQGIvi1Am2Uf7ni2r
1ooeECUrRGiKpSzAZ4zRfvYH52LYdJGy4sxy7VCtWkOL5ClvCzF0+rvYTGSgv/FA
+sRsDOwarGJAbDWzUNCHwIAhbE9vlO/xypO5wANdQgFil39K6pUmRhrCiytW5vlT
uR2l3E7Jp78B3/OuDdqM3HwMH8BNYnXvYCNFw5sTdom3OmkKadWmFXIEeRm5EKIY
TkAzIQ9NT7bGcxzGLC0ixts54SviFBI6+ULaQGd6YM9S1HuZ5GhNJYFgnU+5/y8O
dOE8JP+N8Mbkfida18JqXlbLLQBjgvR1uScqoIAndHiOc94YvZQNI/sDyaHtjy86
kSr2PJZTjspEOFreYT0s
=7rOK
-----END PGP SIGNATURE-----

--WYTEVAkct0FjGQmd--
