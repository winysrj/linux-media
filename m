Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:37003 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755370AbdEDONr (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 4 May 2017 10:13:47 -0400
Date: Thu, 4 May 2017 16:13:41 +0200
From: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Peter Rosin <peda@axentia.se>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Pavel Machek <pavel@ucw.cz>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>,
        kernel@pengutronix.de, Sascha Hauer <s.hauer@pengutronix.de>,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: Re: [PATCH v3 1/2] [media] dt-bindings: Add bindings for
 video-multiplexer device
Message-ID: <20170504141341.uj4uvminlttnjhpe@earth>
References: <1493905137-27051-1-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="odjczrke3pxkanq7"
Content-Disposition: inline
In-Reply-To: <1493905137-27051-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--odjczrke3pxkanq7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, May 04, 2017 at 03:38:56PM +0200, Philipp Zabel wrote:
> Add bindings documentation for the video multiplexer device.
>=20
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> Acked-by: Peter Rosin <peda@axentia.se>
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>

-- Sebastian

> ---
> No changes since v2 [1].
>=20
> This was previously sent as part of Steve's i.MX media series [2].
>=20
> [1] https://patchwork.kernel.org/patch/9708235/
> [2] https://patchwork.kernel.org/patch/9647951/
> ---
>  .../devicetree/bindings/media/video-mux.txt        | 60 ++++++++++++++++=
++++++
>  1 file changed, 60 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/video-mux.txt
>=20
> diff --git a/Documentation/devicetree/bindings/media/video-mux.txt b/Docu=
mentation/devicetree/bindings/media/video-mux.txt
> new file mode 100644
> index 0000000000000..63b9dc913e456
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/video-mux.txt
> @@ -0,0 +1,60 @@
> +Video Multiplexer
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +Video multiplexers allow to select between multiple input ports. Video r=
eceived
> +on the active input port is passed through to the output port. Muxes des=
cribed
> +by this binding are controlled by a multiplexer controller that is descr=
ibed by
> +the bindings in Documentation/devicetree/bindings/mux/mux-controller.txt
> +
> +Required properties:
> +- compatible : should be "video-mux"
> +- mux-controls : mux controller node to use for operating the mux
> +- #address-cells: should be <1>
> +- #size-cells: should be <0>
> +- port@*: at least three port nodes containing endpoints connecting to t=
he
> +  source and sink devices according to of_graph bindings. The last port =
is
> +  the output port, all others are inputs.
> +
> +Optionally, #address-cells, #size-cells, and port nodes can be grouped u=
nder a
> +ports node as described in Documentation/devicetree/bindings/graph.txt.
> +
> +Example:
> +
> +	mux: mux-controller {
> +		compatible =3D "gpio-mux";
> +		#mux-control-cells =3D <0>;
> +
> +		mux-gpios =3D <&gpio1 15 GPIO_ACTIVE_HIGH>;
> +	};
> +
> +	video-mux {
> +		compatible =3D "video-mux";
> +		mux-controls =3D <&mux>;
> +		#address-cells =3D <1>;
> +		#size-cells =3D <0>;
> +
> +		port@0 {
> +			reg =3D <0>;
> +
> +			mux_in0: endpoint {
> +				remote-endpoint =3D <&video_source0_out>;
> +			};
> +		};
> +
> +		port@1 {
> +			reg =3D <1>;
> +
> +			mux_in1: endpoint {
> +				remote-endpoint =3D <&video_source1_out>;
> +			};
> +		};
> +
> +		port@2 {
> +			reg =3D <2>;
> +
> +			mux_out: endpoint {
> +				remote-endpoint =3D <&capture_interface_in>;
> +			};
> +		};
> +	};
> +};
> --=20
> 2.11.0
>=20

--odjczrke3pxkanq7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAlkLNxIACgkQ2O7X88g7
+prceQ//dWQYu5QUsU3YNoFm0EjEne5McWDLy+2m6BxgNY/mINVfwRcjNsTT7HAX
7oGr1eJUu8eRVQPv5PjNUoAQUeJmQ8v0cwZyd1X3VBIHXtMmEl+o0et7qaU/mkXQ
HnHviyRJ3P9So8SM1SeYsOa33BJra7185x3KhEGzw9bk88tHj5Krq2hUw6vYotEw
4qesMGPUPtf7aCzhnUQNtHfAhAiO6L8D8aG2Qvls1DKBjO/keixOSyrc02mgmPQA
GPZ7Wvf8H0s0By14QFtC4dqo7hAI+G8NFJz7wOsphmdP27kvuC0U6heK2HGZmCxv
eumz5WZYoQ0NcfQq3DIEaa1SOUvaUBakmgjrJ0UCbBAs8NKSWglb9uN9ayyjonOn
RXlinf433Q2JMZ7n4F29wwzwkeve+V8Qp94Oz9DfIhQopIJO/9nxshiJpxQSv4lW
kOpwsiGA9QHyuDOAJcoNLpbkFg3DTxeHiCtZnT6lrsIHKOMAo5jK1i+4lQrA+6y/
I7rjYmnWrU924L42Va9qShnxGx94SwN+PVwnz7e9Bo3E50vMOsa15j41bvHoV/6M
rXtMwmYx1zeMN0D9d5CiF5/72lL4eMShgkOHX/kIoRHWdPhdfF5wd1L6rzAZNTrX
ASv+wxE8DEBbqP7zIn2KyK0VWMdfMWU4k6mS/XPqFJztVqL705Q=
=/sYs
-----END PGP SIGNATURE-----

--odjczrke3pxkanq7--
