Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:42026 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934661AbeBMMGV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Feb 2018 07:06:21 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kieran Bingham <kbingham@kernel.org>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
        <devicetree@vger.kernel.org>
Subject: Re: [PATCH v3 1/5] dt-bindings: media: adv7604: Add support for i2c_new_secondary_device
Date: Tue, 13 Feb 2018 14:06:51 +0200
Message-ID: <84376496.fPaZ5qpN3E@avalon>
In-Reply-To: <1518473273-6333-2-git-send-email-kbingham@kernel.org>
References: <1518473273-6333-1-git-send-email-kbingham@kernel.org> <1518473273-6333-2-git-send-email-kbingham@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

Thank you for the patch.

On Tuesday, 13 February 2018 00:07:49 EET Kieran Bingham wrote:
> From: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
>=20
> The ADV7604 has thirteen 256-byte maps that can be accessed via the main
> I=B2C ports. Each map has it own I=B2C address and acts as a standard sla=
ve
> device on the I=B2C bus.
>=20
> Extend the device tree node bindings to be able to override the default
> addresses so that address conflicts with other devices on the same bus
> may be resolved at the board description level.
>=20
> Signed-off-by: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
> [Kieran: Re-adapted for mainline]
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> Reviewed-by: Rob Herring <robh@kernel.org>

Nitpicking, I might not mention i2c_new_secondary_device in the subject, as=
=20
this is a DT bindings change. I don't mind too much though, as long as the=
=20
bindings themselves don't contain Linux-specific information, and they don'=
t,=20
so

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
> Based upon the original posting :
>   https://lkml.org/lkml/2014/10/22/469
>=20
> v2:
>  - DT Binding update separated from code change
>  - Minor reword to commit message to account for DT only change.
>  - Collected Rob's RB tag.
>=20
> v3:
>  - Split map register addresses into individual declarations.
>=20
>  .../devicetree/bindings/media/i2c/adv7604.txt          | 18
> ++++++++++++++++-- 1 file changed, 16 insertions(+), 2 deletions(-)
>=20
> diff --git a/Documentation/devicetree/bindings/media/i2c/adv7604.txt
> b/Documentation/devicetree/bindings/media/i2c/adv7604.txt index
> 9cbd92eb5d05..ebb5f070c05b 100644
> --- a/Documentation/devicetree/bindings/media/i2c/adv7604.txt
> +++ b/Documentation/devicetree/bindings/media/i2c/adv7604.txt
> @@ -13,7 +13,11 @@ Required Properties:
>      - "adi,adv7611" for the ADV7611
>      - "adi,adv7612" for the ADV7612
>=20
> -  - reg: I2C slave address
> +  - reg: I2C slave addresses
> +    The ADV76xx has up to thirteen 256-byte maps that can be accessed via
> the +    main I=B2C ports. Each map has it own I=B2C address and acts as a
> standard +    slave device on the I=B2C bus. The main address is mandator=
y,
> others are +    optional and revert to defaults if not specified.
>=20
>    - hpd-gpios: References to the GPIOs that control the HDMI hot-plug
>      detection pins, one per HDMI input. The active flag indicates the GP=
IO
> @@ -35,6 +39,11 @@ Optional Properties:
>=20
>    - reset-gpios: Reference to the GPIO connected to the device's reset p=
in.
> - default-input: Select which input is selected after reset.
> +  - reg-names : Names of maps with programmable addresses.
> +		It can contain any map needing a non-default address.
> +		Possible maps names are :
> +		  "main", "avlink", "cec", "infoframe", "esdp", "dpp", "afe",
> +		  "rep", "edid", "hdmi", "test", "cp", "vdp"
>=20
>  Optional Endpoint Properties:
>=20
> @@ -52,7 +61,12 @@ Example:
>=20
>  	hdmi_receiver@4c {
>  		compatible =3D "adi,adv7611";
> -		reg =3D <0x4c>;
> +		/*
> +		 * The edid page will be accessible @ 0x66 on the i2c bus. All
> +		 * other maps will retain their default addresses.
> +		 */
> +		reg =3D <0x4c>, <0x66>;
> +		reg-names "main", "edid";
>=20
>  		reset-gpios =3D <&ioexp 0 GPIO_ACTIVE_LOW>;
>  		hpd-gpios =3D <&ioexp 2 GPIO_ACTIVE_HIGH>;


=2D-=20
Regards,

Laurent Pinchart
