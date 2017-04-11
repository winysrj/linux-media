Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:33738 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752437AbdDKJlT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Apr 2017 05:41:19 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
Cc: robh+dt@kernel.org, mark.rutland@arm.com, mchehab@kernel.org,
        hverkuil@xs4all.nl, sakari.ailus@linux.intel.com, crope@iki.fi,
        chris.paterson2@renesas.com, geert+renesas@glider.be,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v3 2/7] dt-bindings: media: Add MAX2175 binding description
Date: Tue, 11 Apr 2017 12:42:10 +0300
Message-ID: <14921696.qIuO4easis@avalon>
In-Reply-To: <1486479757-32128-3-git-send-email-ramesh.shanmugasundaram@bp.renesas.com>
References: <1486479757-32128-1-git-send-email-ramesh.shanmugasundaram@bp.renesas.com> <1486479757-32128-3-git-send-email-ramesh.shanmugasundaram@bp.renesas.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ramesh,

Thank you for the patch.

On Tuesday 07 Feb 2017 15:02:32 Ramesh Shanmugasundaram wrote:
> Add device tree binding documentation for MAX2175 Rf to bits tuner
> device.
>=20
> Signed-off-by: Ramesh Shanmugasundaram
> <ramesh.shanmugasundaram@bp.renesas.com> ---
>  .../devicetree/bindings/media/i2c/max2175.txt      | 61 ++++++++++++=
+++++++
>  .../devicetree/bindings/property-units.txt         |  1 +
>  2 files changed, 62 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/max21=
75.txt
>=20
> diff --git a/Documentation/devicetree/bindings/media/i2c/max2175.txt
> b/Documentation/devicetree/bindings/media/i2c/max2175.txt new file mo=
de
> 100644
> index 0000000..f591ab4
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/i2c/max2175.txt
> @@ -0,0 +1,61 @@
> +Maxim Integrated MAX2175 RF to Bits tuner
> +-----------------------------------------
> +
> +The MAX2175 IC is an advanced analog/digital hybrid-radio receiver w=
ith
> +RF to Bits=AE front-end designed for software-defined radio solution=
s.
> +
> +Required properties:
> +--------------------
> +- compatible: "maxim,max2175" for MAX2175 RF-to-bits tuner.
> +- clocks: phandle to the fixed xtal clock.
> +- clock-names: name of the fixed xtal clock.

I would mention that the name has to be "xtal". Maybe something like

- clock-names: name of the fixed xtal clock, shall be "xtal".

> +- port: child port node of a tuner that defines the local and remote=

> +  endpoints. The remote endpoint is assumed to be an SDR device
> +  that is capable of receiving the digital samples from the tuner.

You should refer to the OF graphs bindings here. How about the followin=
g to=20
document the port node ?

- port: child port node corresponding to the I2S output, in accordance =
with=20
the video interface bindings defined in
Documentation/devicetree/bindings/media/video-interfaces.txt. The port =
node=20
must contain at least one endpoint.

> +Optional properties:
> +--------------------
> +- maxim,slave=09      : phandle to the master tuner if it is a slave=
.=20
This
> +=09=09=09is used to define two tuners in diversity mode
> +=09=09=09(1 master, 1 slave). By default each tuner is an
> +=09=09=09individual master.

It seems weird to me to name a property "slave" when it points to the m=
aster=20
tuner. Shouldn't it be named "maxim,master" ?

> +- maxim,refout-load-pF: load capacitance value (in pF) on reference
> +=09=09=09output drive level. The possible load values are
> +=09=09=09 0 (default - refout disabled)
> +=09=09=0910
> +=09=09=0920
> +=09=09=0930
> +=09=09=0940
> +=09=09=0960
> +=09=09=0970
> +- maxim,am-hiz=09      : empty property indicates AM Hi-Z filter pat=
h=20
is
> +=09=09=09selected for AM antenna input. By default this
> +=09=09=09filter path is not used.

Isn't this something that should be selected at runtime through a contr=
ol ? Or=20
does the hardware design dictate whether the filter has to be used or m=
ust not=20
be used ?

> +Example:
> +--------
> +
> +Board specific DTS file
> +
> +/* Fixed XTAL clock node */
> +maxim_xtal: clock {
> +=09compatible =3D "fixed-clock";
> +=09#clock-cells =3D <0>;
> +=09clock-frequency =3D <36864000>;
> +};
> +
> +/* A tuner device instance under i2c bus */
> +max2175_0: tuner@60 {
> +=09compatible =3D "maxim,max2175";
> +=09reg =3D <0x60>;
> +=09clocks =3D <&maxim_xtal>;
> +=09clock-names =3D "xtal";
> +=09maxim,refout-load-pF =3D <10>;
> +
> +=09port {
> +=09=09max2175_0_ep: endpoint {
> +=09=09=09remote-endpoint =3D <&slave_rx_device>;
> +=09=09};
> +=09};
> +
> +};
> diff --git a/Documentation/devicetree/bindings/property-units.txt
> b/Documentation/devicetree/bindings/property-units.txt index
> 12278d7..f1f1c22 100644
> --- a/Documentation/devicetree/bindings/property-units.txt
> +++ b/Documentation/devicetree/bindings/property-units.txt
> @@ -28,6 +28,7 @@ Electricity
>  -ohms=09=09: Ohms
>  -micro-ohms=09: micro Ohms
>  -microvolt=09: micro volts
> +-pF=09=09: pico farads
>=20
>  Temperature
>  ----------------------------------------

--=20
Regards,

Laurent Pinchart
