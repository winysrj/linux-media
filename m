Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:55025 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751348AbdJSJWX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Oct 2017 05:22:23 -0400
Date: Thu, 19 Oct 2017 11:22:19 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-tegra@vger.kernel.org,
        devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv4 1/4] dt-bindings: document the tegra CEC bindings
Message-ID: <20171019092219.GD9005@ulmo>
References: <20170911122952.33980-1-hverkuil@xs4all.nl>
 <20170911122952.33980-2-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="J5MfuwkIyy7RmF4Q"
Content-Disposition: inline
In-Reply-To: <20170911122952.33980-2-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--J5MfuwkIyy7RmF4Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 11, 2017 at 02:29:49PM +0200, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>=20
> This documents the binding for the Tegra CEC module.
>=20
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Acked-by: Rob Herring <robh@kernel.org>
> ---
>  .../devicetree/bindings/media/tegra-cec.txt        | 27 ++++++++++++++++=
++++++
>  1 file changed, 27 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/tegra-cec.txt
>=20
> diff --git a/Documentation/devicetree/bindings/media/tegra-cec.txt b/Docu=
mentation/devicetree/bindings/media/tegra-cec.txt
> new file mode 100644
> index 000000000000..c503f06f3b84
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/tegra-cec.txt
> @@ -0,0 +1,27 @@
> +* Tegra HDMI CEC hardware
> +
> +The HDMI CEC module is present in Tegra SoCs and its purpose is to
> +handle communication between HDMI connected devices over the CEC bus.
> +
> +Required properties:
> +  - compatible : value should be one of the following:
> +	"nvidia,tegra114-cec"
> +	"nvidia,tegra124-cec"
> +	"nvidia,tegra210-cec"
> +  - reg : Physical base address of the IP registers and length of memory
> +	  mapped region.
> +  - interrupts : HDMI CEC interrupt number to the CPU.
> +  - clocks : from common clock binding: handle to HDMI CEC clock.
> +  - clock-names : from common clock binding: must contain "cec",
> +		  corresponding to the entry in the clocks property.
> +  - hdmi-phandle : phandle to the HDMI controller, see also cec.txt.

I don't understand the need for the -phandle suffix. I would've probably
just gone with "hdmi", or "hdmi-controller". But I see that this is
already pretty standardized, so...

Acked-by: Thierry Reding <treding@nvidia.com>

--J5MfuwkIyy7RmF4Q
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAlnobssACgkQ3SOs138+
s6G7ug/8CcguPaMyiFjoMwMuWfF0Q9r/QS3QzsuAKftj7MnryvGk43oaVP7FgSb9
XBkRj5msH+eg10k0OAOusBdH/1dX81nqkoo+qE/o/GGD9MjIVhKE2QvxCS+lVyHN
VLly9NXcxXZTcOpaFpJU+xnydi9PXKyWyw+LCBS28UAc+lVuVy6BEYNApasrrNtf
GdefRPaX/AiavTqgzo5YOjpnXb+sge4H5LPQ8n8iUkFXb84DquYjzk2IEbHnPqWu
bXxqxuhQxDW3luE0GeETZsmP5Vh8xhdrN5GL/KEfiftSsbcxz4e45AVSILtCUnyD
k7YMB2rmZyculzpIElXI07gMT+YBRUxU7D65HC8egeiiWOFVn6GWIybFGHhj7jej
r5k3upv4bNq+LgXQZtWCqycpdDNKaOaIgoIqGL6wOqaoJ1XPUO9rEJFN0h60whYy
5LXZ7SaUnGWvhLTIPoEOreyO7flWS90ZtNRhy5h5iRIjarr4Q3XlD/H1lh3Hwmpv
JpXWsYyhb1+5sJJXaLoMavzAotpeyOBJYnQnHy/Z/33XOR4ALNb2cQeBzEJeXhLf
inKmwiWNGo4TOj/M1gIZWKiOdV+y7SJxr2F6QhB17Zcvl6Q4Qy8/M/fh/XSxtMNm
9tnHjHhF8TCp2Gc1hL3mIfD91NxnOwqGEb1SyxicPWDtf1Zgw1o=
=6R5L
-----END PGP SIGNATURE-----

--J5MfuwkIyy7RmF4Q--
