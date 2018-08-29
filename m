Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:58508 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727788AbeH2VF2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Aug 2018 17:05:28 -0400
Date: Wed, 29 Aug 2018 14:07:31 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org, Rob Herring <robh@kernel.org>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Pali =?UTF-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>,
        Pavel Machek <pavel@ucw.cz>,
        Timo Kokkonen <timo.t.kokkonen@iki.fi>,
        Tony Lindgren <tony@atomide.com>,
        Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH v3 1/2] media: dt-bindings: bind nokia,n900-ir to
 generic pwm-ir-tx driver
Message-ID: <20180829140731.1d6491c0@coco.lan>
In-Reply-To: <20180713122230.19278-1-sean@mess.org>
References: <20180713122230.19278-1-sean@mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 13 Jul 2018 13:22:29 +0100
Sean Young <sean@mess.org> escreveu:

> The generic pwm-ir-tx driver should work for the Nokia n900.
>=20
> Compile tested only.

It would be good to have some tests...

>=20
> Cc: Rob Herring <robh@kernel.org>
> Cc: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
> Cc: Pali Roh=C3=A1r <pali.rohar@gmail.com>
> Cc: Pavel Machek <pavel@ucw.cz>
> Cc: Timo Kokkonen <timo.t.kokkonen@iki.fi>
> Cc: Tony Lindgren <tony@atomide.com>

And some acks

Before merging it.

> Signed-off-by: Sean Young <sean@mess.org>
> ---
>  arch/arm/boot/dts/omap3-n900.dts | 2 +-
>  drivers/media/rc/pwm-ir-tx.c     | 1 +
>  2 files changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/arch/arm/boot/dts/omap3-n900.dts b/arch/arm/boot/dts/omap3-n=
900.dts
> index 182a53991c90..fd12dea15799 100644
> --- a/arch/arm/boot/dts/omap3-n900.dts
> +++ b/arch/arm/boot/dts/omap3-n900.dts
> @@ -154,7 +154,7 @@
>  	};
> =20
>  	ir: n900-ir {
> -		compatible =3D "nokia,n900-ir";
> +		compatible =3D "nokia,n900-ir", "pwm-ir-tx";
>  		pwms =3D <&pwm9 0 26316 0>; /* 38000 Hz */
>  	};
> =20
> diff --git a/drivers/media/rc/pwm-ir-tx.c b/drivers/media/rc/pwm-ir-tx.c
> index 27d0f5837a76..272947b430c8 100644
> --- a/drivers/media/rc/pwm-ir-tx.c
> +++ b/drivers/media/rc/pwm-ir-tx.c
> @@ -30,6 +30,7 @@ struct pwm_ir {
>  };
> =20
>  static const struct of_device_id pwm_ir_of_match[] =3D {
> +	{ .compatible =3D "nokia,n900-ir" },
>  	{ .compatible =3D "pwm-ir-tx", },
>  	{ },
>  };



Thanks,
Mauro
