Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:45039 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752463AbeENNVt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 May 2018 09:21:49 -0400
Date: Mon, 14 May 2018 15:21:43 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Niklas =?utf-8?Q?S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v15 1/2] rcar-csi2: add Renesas R-Car MIPI CSI-2 receiver
 documentation
Message-ID: <20180514132143.GJ5956@w540>
References: <20180513191917.20681-1-niklas.soderlund+renesas@ragnatech.se>
 <20180513191917.20681-2-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="HcXnUX77nabWBLF4"
Content-Disposition: inline
In-Reply-To: <20180513191917.20681-2-niklas.soderlund+renesas@ragnatech.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--HcXnUX77nabWBLF4
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Niklas,
    thanks for re-sending

On Sun, May 13, 2018 at 09:19:16PM +0200, Niklas S=C3=B6derlund wrote:
> Documentation for Renesas R-Car MIPI CSI-2 receiver. The CSI-2 receivers
> are located between the video sources (CSI-2 transmitters) and the video
> grabbers (VIN) on Gen3 of Renesas R-Car SoC.
>
> Each CSI-2 device is connected to more than one VIN device which
> simultaneously can receive video from the same CSI-2 device. Each VIN
> device can also be connected to more than one CSI-2 device. The routing
> of which links are used is controlled by the VIN devices. There are only
> a few possible routes which are set by hardware limitations, which are
> different for each SoC in the Gen3 family.
>
> Signed-off-by: Niklas S=C3=B6derlund <niklas.soderlund+renesas@ragnatech.=
se>
> Acked-by: Rob Herring <robh@kernel.org>
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>
> ---
>
> * Changes since v14.
> - Added compatible string for R8A77965 and R8A77970.
> - s/Port 0/port@0/
> - s/Port 1/port@1/
> - s/Endpoint 0/endpoint@0/
>
> * Changes since v13
> - Add Laurent's tag.
> ---
>  .../bindings/media/renesas,rcar-csi2.txt      | 101 ++++++++++++++++++
>  MAINTAINERS                                   |   1 +
>  2 files changed, 102 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/renesas,rcar-=
csi2.txt
>
> diff --git a/Documentation/devicetree/bindings/media/renesas,rcar-csi2.tx=
t b/Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt
> new file mode 100644
> index 0000000000000000..2d385b65b275bc58
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt
> @@ -0,0 +1,101 @@
> +Renesas R-Car MIPI CSI-2
> +------------------------
> +
> +The R-Car CSI-2 receiver device provides MIPI CSI-2 capabilities for the
> +Renesas R-Car family of devices. It is used in conjunction with the
> +R-Car VIN module, which provides the video capture capabilities.
> +
> +Mandatory properties
> +--------------------
> + - compatible: Must be one or more of the following
> +   - "renesas,r8a7795-csi2" for the R8A7795 device.
> +   - "renesas,r8a7796-csi2" for the R8A7796 device.
> +   - "renesas,r8a77965-csi2" for the R8A77965 device.
> +   - "renesas,r8a77970-csi2" for the R8A77970 device.
> +
> + - reg: the register base and size for the device registers
> + - interrupts: the interrupt for the device
> + - clocks: reference to the parent clock
> +
> +The device node shall contain two 'port' child nodes according to the

s/child nodes according/child nodes modeled accordingly/

but don't fully trust my English language skills here.

> +bindings defined in Documentation/devicetree/bindings/media/
> +video-interfaces.txt. port@0 shall connect to the CSI-2 source. port@1
> +shall connect to all the R-Car VIN modules that have a hardware
> +connection to the CSI-2 receiver.
> +
> +- port@0- Video source (mandatory)
> +	- endpoint@0 - sub-node describing the endpoint that is the video source
> +
> +- port@1 - VIN instances (optional)
> +	- One endpoint sub-node for every R-Car VIN instance which is connected
> +	  to the R-Car CSI-2 receiver.
> +
As commented on v14, I feel like there are some restrictions on the
accepted values for some endpoint properties in the hardware module,
and those should be described here.

Eg. the clock lane shall be fixed in position 0 (that's more an HW
design choice, I agree), and the number of supported data lanes is
either 1, 2 or 4 and 3 is not supported.

Apart from that, which I know you do not totally agree on and you're
free to ignore.

Reviewed-by Jacopo Mondi <jacopo+renesas@jmondi.org>

Thanks
   j

> +Example:
> +
> +	csi20: csi2@fea80000 {
> +		compatible =3D "renesas,r8a7796-csi2";
> +		reg =3D <0 0xfea80000 0 0x10000>;
> +		interrupts =3D <0 184 IRQ_TYPE_LEVEL_HIGH>;
> +		clocks =3D <&cpg CPG_MOD 714>;
> +		power-domains =3D <&sysc R8A7796_PD_ALWAYS_ON>;
> +		resets =3D <&cpg 714>;
> +
> +		ports {
> +			#address-cells =3D <1>;
> +			#size-cells =3D <0>;
> +
> +			port@0 {
> +				#address-cells =3D <1>;
> +				#size-cells =3D <0>;
> +
> +				reg =3D <0>;
> +
> +				csi20_in: endpoint@0 {
> +					reg =3D <0>;
> +					clock-lanes =3D <0>;
> +					data-lanes =3D <1>;
> +					remote-endpoint =3D <&adv7482_txb>;
> +				};
> +			};
> +
> +			port@1 {
> +				#address-cells =3D <1>;
> +				#size-cells =3D <0>;
> +
> +				reg =3D <1>;
> +
> +				csi20vin0: endpoint@0 {
> +					reg =3D <0>;
> +					remote-endpoint =3D <&vin0csi20>;
> +				};
> +				csi20vin1: endpoint@1 {
> +					reg =3D <1>;
> +					remote-endpoint =3D <&vin1csi20>;
> +				};
> +				csi20vin2: endpoint@2 {
> +					reg =3D <2>;
> +					remote-endpoint =3D <&vin2csi20>;
> +				};
> +				csi20vin3: endpoint@3 {
> +					reg =3D <3>;
> +					remote-endpoint =3D <&vin3csi20>;
> +				};
> +				csi20vin4: endpoint@4 {
> +					reg =3D <4>;
> +					remote-endpoint =3D <&vin4csi20>;
> +				};
> +				csi20vin5: endpoint@5 {
> +					reg =3D <5>;
> +					remote-endpoint =3D <&vin5csi20>;
> +				};
> +				csi20vin6: endpoint@6 {
> +					reg =3D <6>;
> +					remote-endpoint =3D <&vin6csi20>;
> +				};
> +				csi20vin7: endpoint@7 {
> +					reg =3D <7>;
> +					remote-endpoint =3D <&vin7csi20>;
> +				};
> +			};
> +		};
> +	};
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 49003f77cedd5d71..13d470d03269b765 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -8825,6 +8825,7 @@ L:	linux-media@vger.kernel.org
>  L:	linux-renesas-soc@vger.kernel.org
>  T:	git git://linuxtv.org/media_tree.git
>  S:	Supported
> +F:	Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt
>  F:	Documentation/devicetree/bindings/media/rcar_vin.txt
>  F:	drivers/media/platform/rcar-vin/
>
> --
> 2.17.0
>

--HcXnUX77nabWBLF4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJa+Y1nAAoJEHI0Bo8WoVY8BWUQALXLg0qD/fjMEp1db84VJ3XM
7Hbwek33uwnjVAgc9Rqigp3rMp/pOpI8idZ0UIfVzbZyLkMsdqql2WtXfpcDOelx
x1e9gQBdVoKNQFXE7eeggx8kFNcr0zcZc5BfShZJkkdNAoJhbdm61/WgN9FKUzFF
+E9NOhGZdYW6+4bxbPIHkwY61przj4ekrYaZXgbM5rsL/uiNT8sg55/gnRNpC6cT
xC4927Dn6LmoFeFIDX3y9mvCyppju+fZoLl7uSWDW1rpMjO9e2JfDTQXMlyCLbLH
Uavii8DfzbaqlSuJAtctkRutqUk28S3OUPyJAZFHcSTl685U7bm0C7MkJQD0OjW/
ZLahrRnF7VeP8TWGL0gYfzh39UCTk5mGDYTDFpNqV2MBD+bCSyK0PqglOHu8A5vF
IfJWKDpFQW766HjBiAF2//MWyR/m+Bcx95oITRI/XeoGLupmGp7xPIPmBd9V3OXZ
aBfT79WIGx39YBJ1hc+i6bClYlY4+uAORoLK9CWId5cpIiK33NYwxT8yt2q0zciR
IlyilRxyGXC6hGdN+mQFrFYcKuZxUonnVHn0r2pazXXEOlpR9RVxdRXjWdm6j+bq
meVA1QPQgka43zruHoePjuoUzeEhaBv43jW0SPZqvK0TC0BK5iTZ0NVQNyCtRpFi
90V8bc/haUTUOwyeU+L8
=FRAM
-----END PGP SIGNATURE-----

--HcXnUX77nabWBLF4--
