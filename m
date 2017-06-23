Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.161]:20185 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754672AbdFWK20 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Jun 2017 06:28:26 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Subject: Re: [PATCH v1 1/6] DT bindings: add bindings for ov965x camera module
From: "H. Nikolaus Schaller" <hns@goldelico.com>
In-Reply-To: <1498143942-12682-2-git-send-email-hugues.fruchet@st.com>
Date: Fri, 23 Jun 2017 12:25:33 +0200
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-media@vger.kernel.org,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Yannick Fertre <yannick.fertre@st.com>,
        Discussions about the Letux Kernel
        <letux-kernel@openphoenux.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <D5629236-95D8-45B6-9719-E8B9796FEC90@goldelico.com>
References: <1498143942-12682-1-git-send-email-hugues.fruchet@st.com> <1498143942-12682-2-git-send-email-hugues.fruchet@st.com>
To: Hugues Fruchet <hugues.fruchet@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hugues,

> Am 22.06.2017 um 17:05 schrieb Hugues Fruchet <hugues.fruchet@st.com>:
>=20
> From: "H. Nikolaus Schaller" <hns@goldelico.com>
>=20
> This adds documentation of device tree bindings
> for the OV965X family camera sensor module.
>=20
> Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
> Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
> ---
> .../devicetree/bindings/media/i2c/ov965x.txt       | 37 =
++++++++++++++++++++++
> 1 file changed, 37 insertions(+)
> create mode 100644 =
Documentation/devicetree/bindings/media/i2c/ov965x.txt
>=20
> diff --git a/Documentation/devicetree/bindings/media/i2c/ov965x.txt =
b/Documentation/devicetree/bindings/media/i2c/ov965x.txt
> new file mode 100644
> index 0000000..0e0de1f
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/i2c/ov965x.txt
> @@ -0,0 +1,37 @@
> +* Omnivision OV9650/9652/9655 CMOS sensor
> +
> +The Omnivision OV965x sensor support multiple resolutions output, =
such as
> +CIF, SVGA, UXGA. It also can support YUV422/420, RGB565/555 or raw =
RGB
> +output format.
> +
> +Required Properties:
> +- compatible: should be one of
> +	"ovti,ov9650"
> +	"ovti,ov9652"
> +	"ovti,ov9655"
> +- clocks: reference to the mclk input clock.

I wonder why you have removed the clock-frequency property?

In some situations the camera driver must be able to tell the clock =
source
which frequency it wants to see.

For example we connect the camera to an OMAP3-ISP (image signal =
processor) and
there it is assumed that camera modules know the frequency and set the =
clock, e.g.:

=
http://elixir.free-electrons.com/linux/v4.4/source/Documentation/devicetre=
e/bindings/media/i2c/nokia,smia.txt#L52
=
http://elixir.free-electrons.com/linux/v3.14/source/Documentation/devicetr=
ee/bindings/media/i2c/mt9p031.txt

If your clock is constant and defined elsewhere we should make this
property optional instead of required. But it should not be missing.

Here is a hack to get it into your code:

=
http://git.goldelico.com/?p=3Dgta04-kernel.git;a=3Dblobdiff;f=3Ddrivers/me=
dia/i2c/ov9650.c;h=3Db7ab46c775b9e40087e427ae0777e9f7c283694a;hp=3D1846bcb=
b19ae71ce686dade320aa06ce2e429ca4;hb=3Dca85196f6fd9a77e5a0f796aeaf7aa2cde6=
0ce91;hpb=3D8a71f21b75543a6d99102be1ae4677b28c478ac9

> +
> +Optional Properties:
> +- resetb-gpios: reference to the GPIO connected to the resetb pin, if =
any.
> +- pwdn-gpios: reference to the GPIO connected to the pwdn pin, if =
any.

Here I wonder why you did split that up into two gpios. Each "*-gpios" =
can have
multiple entries and if one is not used, a 0 can be specified to make it =
being ignored.

But it is up to DT maintainers what they prefer: separate single gpios =
or a single gpio array.


What I am missing to support the GTA04 camera is the control of the =
optional "vana-supply".
So the driver does not power up the camera module when needed and =
therefore probing fails.

  - vana-supply: a regulator to power up the camera module.

Driver code is not complex to add:

=
http://git.goldelico.com/?p=3Dgta04-kernel.git;a=3Dblobdiff;f=3Ddrivers/me=
dia/i2c/ov9650.c;h=3D1846bcbb19ae71ce686dade320aa06ce2e429ca4;hp=3Dc0819af=
dcefcb19da351741d51dad00aaf909254;hb=3D8a71f21b75543a6d99102be1ae4677b28c4=
78ac9;hpb=3D6db55fc472eea2ec6db03833df027aecf6649f88

> +
> +The device node must contain one 'port' child node for its digital =
output
> +video port, in accordance with the video interface bindings defined =
in
> +Documentation/devicetree/bindings/media/video-interfaces.txt.
> +
> +Example:
> +
> +&i2c2 {
> +	ov9655: camera@30 {
> +		compatible =3D "ovti,ov9655";
> +		reg =3D <0x30>;
> +		pwdn-gpios =3D <&gpioh 13 GPIO_ACTIVE_HIGH>;
> +		clocks =3D <&clk_ext_camera>;
> +
> +		port {
> +			ov9655: endpoint {
> +				remote-endpoint =3D <&dcmi_0>;
> +			};
> +		};
> +	};
> +};
> --=20
> 1.9.1
>=20

BR and thanks,
Nikolaus
