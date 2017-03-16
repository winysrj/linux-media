Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:50937
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750788AbdCPBJo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Mar 2017 21:09:44 -0400
Date: Wed, 15 Mar 2017 22:08:34 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Eric Anholt <eric@anholt.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-rpi-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] staging: BCM2835 MMAL V4L2 camera driver
Message-ID: <20170315220834.7019fd8b@vento.lan>
In-Reply-To: <87a88m19om.fsf@eliezer.anholt.net>
References: <20170127215503.13208-1-eric@anholt.net>
        <20170315110128.37e2bc5a@vento.lan>
        <87a88m19om.fsf@eliezer.anholt.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/eAGDnqE+IqO415lJvX.gacv"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/eAGDnqE+IqO415lJvX.gacv
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Em Wed, 15 Mar 2017 15:01:29 -0700
Eric Anholt <eric@anholt.net> escreveu:

> Mauro Carvalho Chehab <mchehab@s-opensource.com> writes:
>=20
> > Em Fri, 27 Jan 2017 13:54:57 -0800
> > Eric Anholt <eric@anholt.net> escreveu:
> > =20
> >> Here's my first pass at importing the camera driver.  There's a bunch
> >> of TODO left to it, most of which is documented, and the rest being
> >> standard checkpatch fare.
> >>=20
> >> Unfortunately, when I try modprobing it on my pi3, the USB network
> >> device dies, consistently.  I'm not sure what's going on here yet, but
> >> I'm going to keep working on some debug of it.  I've unfortunately
> >> changed a lot of variables (pi3 vs pi2, upstream vs downstream, vchi's
> >> updates while in staging, 4.9 vs 4.4), so I probably won't figure it
> >> out today.
> >>=20
> >> Note that the "Update the driver to the current VCHI API" patch will
> >> conflict with the outstanding "Add vchi_queue_kernel_message and
> >> vchi_queue_user_message" series, but the fix should be pretty obvious
> >> when that lands.
> >>=20
> >> I built this against 4.10-rc1, but a merge with staging-next was clean
> >> and still built fine. =20
> >
> > I'm trying it, building from the linux-next branch of the staging
> > tree. No joy.
> >
> > That's what happens when I modprobe it:
> >
> > [  991.841549] bcm2835_v4l2: module is from the staging directory, the =
quality is unknown, you have been warned.
> > [  991.842931] vchiq_get_state: g_state.remote =3D=3D NULL
> > [  991.843437] vchiq_get_state: g_state.remote =3D=3D NULL
> > [  991.843940] vchiq_get_state: g_state.remote =3D=3D NULL
> > [  991.844444] vchiq_get_state: g_state.remote =3D=3D NULL
> > [  991.844947] vchiq_get_state: g_state.remote =3D=3D NULL
> > [  991.845451] vchiq_get_state: g_state.remote =3D=3D NULL
> > [  991.845954] vchiq_get_state: g_state.remote =3D=3D NULL
> > [  991.846457] vchiq_get_state: g_state.remote =3D=3D NULL
> > [  991.846961] vchiq_get_state: g_state.remote =3D=3D NULL
> > [  991.847464] vchiq_get_state: g_state.remote =3D=3D NULL
> > [  991.847969] vchiq: vchiq_initialise: videocore not initialized
> >
> > [  991.847973] mmal_vchiq: Failed to initialise VCHI instance (status=
=3D-1) =20
>=20
> Yeah, this failure mode sucks.  I'm guessing you don't have a VCHI node
> in the DT?  Patch attached.

No, I didn't. Thanks! Applied it but, unfortunately, didn't work.
Perhaps I'm missing some other patch. I'm compiling it from
the Greg's staging tree (branch staging-next):
	https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/log/?h=
=3Dstaging-next

Btw, as I'm running Raspbian, and didn't want to use compat32 bits,=20
I'm compiling the Kernel as an arm32 bits Kernel.

I did a small trick to build the DTB on arm32:

	ln -sf ../../../arm64/boot/dts/broadcom/bcm2837-rpi-3-b.dts arch/arm/boot/=
dts/bcm2837-rpi-3-b.dts
	ln -sf ../../../arm64/boot/dts/broadcom/bcm2837.dtsi arch/arm/boot/dts/bcm=
2837.dtsi
	git checkout arch/arm/boot/dts/Makefile
	sed "s,bcm2835-rpi-zero.dtb,bcm2835-rpi-zero.dtb bcm2837-rpi-3-b.dtb," a &=
& mv a arch/arm/boot/dts/Makefile

> I haven't followed up on getting the DT documented so that it can be
> merged, and it sounds like Michael has some plans for changing how VCHI
> and VCHI's consumers get attached to each other so that it's not
> DT-based anyway.

I see.

>=20
> From 9488974b836b1fba7d32af34d612151872f9ce0d Mon Sep 17 00:00:00 2001
> From: Eric Anholt <eric@anholt.net>
> Date: Mon, 3 Oct 2016 11:23:34 -0700
> Subject: [PATCH] ARM: bcm2835: Add VCHIQ to the DT.
>=20
> Signed-off-by: Eric Anholt <eric@anholt.net>
> ---
>  arch/arm/boot/dts/bcm2835-rpi.dtsi | 8 ++++++++
>  1 file changed, 8 insertions(+)
>=20
> diff --git a/arch/arm/boot/dts/bcm2835-rpi.dtsi b/arch/arm/boot/dts/bcm28=
35-rpi.dtsi
> index caf2707680c1..f5fb5c5aa07a 100644
> --- a/arch/arm/boot/dts/bcm2835-rpi.dtsi
> +++ b/arch/arm/boot/dts/bcm2835-rpi.dtsi
> @@ -26,6 +26,14 @@
>  			firmware =3D <&firmware>;
>  			#power-domain-cells =3D <1>;
>  		};
> +
> +		vchiq {
> +			compatible =3D "brcm,bcm2835-vchiq";
> +			reg =3D <0x7e00b840 0xf>;
> +			interrupts =3D <0 2>;
> +			cache-line-size =3D <32>;
> +			firmware =3D <&firmware>;
> +		};
>  	};
>  };
> =20



Thanks,
Mauro

--Sig_/eAGDnqE+IqO415lJvX.gacv
Content-Type: application/pgp-signature
Content-Description: Assinatura digital OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJYyeWSAAoJEAhfPr2O5OEVcdUP/Runk2t9pg7Mg5j2fEknsEFU
SqhdVogzZTmQbDuIqjfHsvG26rQ5joV2ExlXh4gnSQJ5j8CpandYxuVMFfa9Ll3b
eWg6PFuW65dklikB0xt0Z6ghzuwA24Lf1LCzzvxRmlYHGJJMQ9otL3s69ui9pP6y
NXX15E20O4UNUPwgaVvMO7m3/5Q2oftpD85iWT7Yi4S+/bh9Liq7fK43QElT4JFz
ZQRYpY2s/KnX4qq4ySjDUfkRMfQw7Ii3yLOoT9BOuz6qOcuSJOVw2juDQZY04n1x
w9tRTofM08QdwCvLbncnFfh5g83RVnLjnUgLGPjbhKiM9r/kaYtkz1Uq2dwMHu1A
x0lbBM+QFhzAndz931aLshk+Z4RufAXNfgZ1TxwDuLvExxuj18xLQzOBp58ATzNH
8xmIbhwJTQvEYAhfpOisNJOJUQTcuxk9ourS/aHXOdk0+QqO0fcPY3f5D1U9kq4R
otDcH/612ugBM6oIPLMGM9kFzVQBNlm6Dz0l3B17m3eAnyGok74hmrmoGLis+aYs
ak0DxmP72MinnFb/A6o+gvg21KY1Ij2WLqjlhmkw8ItYcqAXNVWDm6/Vs7VUvQwP
7DhZ9NGctaleFEvmPRYE0YKc/TIQ0Rat/N0bcex8fGwwOSMrLYMYL6P352tA5LrH
cD4y8/XaSKv6yP2DeN1A
=jVA2
-----END PGP SIGNATURE-----

--Sig_/eAGDnqE+IqO415lJvX.gacv--
