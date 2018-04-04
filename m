Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:46598 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751251AbeDDOtu (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 4 Apr 2018 10:49:50 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH v13 1/2] rcar-csi2: add Renesas R-Car MIPI CSI-2 receiver documentation
Date: Wed, 04 Apr 2018 17:49:57 +0300
Message-ID: <2955834.42KICI0Tpx@avalon>
In-Reply-To: <20180212230132.5402-2-niklas.soderlund+renesas@ragnatech.se>
References: <20180212230132.5402-1-niklas.soderlund+renesas@ragnatech.se> <20180212230132.5402-2-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Tuesday, 13 February 2018 01:01:31 EEST Niklas S=F6derlund wrote:
> Documentation for Renesas R-Car MIPI CSI-2 receiver. The CSI-2 receivers
> are located between the video sources (CSI-2 transmitters) and the video
> grabbers (VIN) on Gen3 of Renesas R-Car SoC.
>=20
> Each CSI-2 device is connected to more than one VIN device which
> simultaneously can receive video from the same CSI-2 device. Each VIN
> device can also be connected to more than one CSI-2 device. The routing
> of which links are used is controlled by the VIN devices. There are only
> a few possible routes which are set by hardware limitations, which are
> different for each SoC in the Gen3 family.
>=20
> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>
> Acked-by: Rob Herring <robh@kernel.org>
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  .../bindings/media/renesas,rcar-csi2.txt           | 99 ++++++++++++++++=
+++
>  MAINTAINERS                                        |  1 +
>  2 files changed, 100 insertions(+)
>  create mode 100644
> Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt
>=20
> diff --git a/Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt
> b/Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt new file
> mode 100644
> index 0000000000000000..6f71f997dc48eee9
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt
> @@ -0,0 +1,99 @@
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
> +
> + - reg: the register base and size for the device registers
> + - interrupts: the interrupt for the device
> + - clocks: reference to the parent clock
> +
> +The device node shall contain two 'port' child nodes according to the
> +bindings defined in Documentation/devicetree/bindings/media/
> +video-interfaces.txt. Port 0 shall connect to the CSI-2 source. Port 1
> +shall connect to all the R-Car VIN modules that have a hardware
> +connection to the CSI-2 receiver.
> +
> +- Port 0 - Video source (mandatory)
> +	- Endpoint 0 - sub-node describing the endpoint that is the video source
> +
> +- Port 1 - VIN instances (optional)
> +	- One endpoint sub-node for every R-Car VIN instance which is connected
> +	  to the R-Car CSI-2 receiver.
> +
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
> index aee793bff977d413..a0ca030b6bf6b82c 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -8651,6 +8651,7 @@ L:	linux-media@vger.kernel.org
>  L:	linux-renesas-soc@vger.kernel.org
>  T:	git git://linuxtv.org/media_tree.git
>  S:	Supported
> +F:	Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt
>  F:	Documentation/devicetree/bindings/media/rcar_vin.txt
>  F:	drivers/media/platform/rcar-vin/


=2D-=20
Regards,

Laurent Pinchart
