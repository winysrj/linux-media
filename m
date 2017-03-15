Return-path: <linux-media-owner@vger.kernel.org>
Received: from anholt.net ([50.246.234.109]:50104 "EHLO anholt.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752493AbdCOWBi (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Mar 2017 18:01:38 -0400
From: Eric Anholt <eric@anholt.net>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-rpi-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] staging: BCM2835 MMAL V4L2 camera driver
In-Reply-To: <20170315110128.37e2bc5a@vento.lan>
References: <20170127215503.13208-1-eric@anholt.net> <20170315110128.37e2bc5a@vento.lan>
Date: Wed, 15 Mar 2017 15:01:29 -0700
Message-ID: <87a88m19om.fsf@eliezer.anholt.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Mauro Carvalho Chehab <mchehab@s-opensource.com> writes:

> Em Fri, 27 Jan 2017 13:54:57 -0800
> Eric Anholt <eric@anholt.net> escreveu:
>
>> Here's my first pass at importing the camera driver.  There's a bunch
>> of TODO left to it, most of which is documented, and the rest being
>> standard checkpatch fare.
>>=20
>> Unfortunately, when I try modprobing it on my pi3, the USB network
>> device dies, consistently.  I'm not sure what's going on here yet, but
>> I'm going to keep working on some debug of it.  I've unfortunately
>> changed a lot of variables (pi3 vs pi2, upstream vs downstream, vchi's
>> updates while in staging, 4.9 vs 4.4), so I probably won't figure it
>> out today.
>>=20
>> Note that the "Update the driver to the current VCHI API" patch will
>> conflict with the outstanding "Add vchi_queue_kernel_message and
>> vchi_queue_user_message" series, but the fix should be pretty obvious
>> when that lands.
>>=20
>> I built this against 4.10-rc1, but a merge with staging-next was clean
>> and still built fine.
>
> I'm trying it, building from the linux-next branch of the staging
> tree. No joy.
>
> That's what happens when I modprobe it:
>
> [  991.841549] bcm2835_v4l2: module is from the staging directory, the qu=
ality is unknown, you have been warned.
> [  991.842931] vchiq_get_state: g_state.remote =3D=3D NULL
> [  991.843437] vchiq_get_state: g_state.remote =3D=3D NULL
> [  991.843940] vchiq_get_state: g_state.remote =3D=3D NULL
> [  991.844444] vchiq_get_state: g_state.remote =3D=3D NULL
> [  991.844947] vchiq_get_state: g_state.remote =3D=3D NULL
> [  991.845451] vchiq_get_state: g_state.remote =3D=3D NULL
> [  991.845954] vchiq_get_state: g_state.remote =3D=3D NULL
> [  991.846457] vchiq_get_state: g_state.remote =3D=3D NULL
> [  991.846961] vchiq_get_state: g_state.remote =3D=3D NULL
> [  991.847464] vchiq_get_state: g_state.remote =3D=3D NULL
> [  991.847969] vchiq: vchiq_initialise: videocore not initialized
>
> [  991.847973] mmal_vchiq: Failed to initialise VCHI instance (status=3D-=
1)

Yeah, this failure mode sucks.  I'm guessing you don't have a VCHI node
in the DT?  Patch attached.

I haven't followed up on getting the DT documented so that it can be
merged, and it sounds like Michael has some plans for changing how VCHI
and VCHI's consumers get attached to each other so that it's not
DT-based anyway.

From=209488974b836b1fba7d32af34d612151872f9ce0d Mon Sep 17 00:00:00 2001
From: Eric Anholt <eric@anholt.net>
Date: Mon, 3 Oct 2016 11:23:34 -0700
Subject: [PATCH] ARM: bcm2835: Add VCHIQ to the DT.

Signed-off-by: Eric Anholt <eric@anholt.net>
=2D--
 arch/arm/boot/dts/bcm2835-rpi.dtsi | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm/boot/dts/bcm2835-rpi.dtsi b/arch/arm/boot/dts/bcm2835=
-rpi.dtsi
index caf2707680c1..f5fb5c5aa07a 100644
=2D-- a/arch/arm/boot/dts/bcm2835-rpi.dtsi
+++ b/arch/arm/boot/dts/bcm2835-rpi.dtsi
@@ -26,6 +26,14 @@
 			firmware =3D <&firmware>;
 			#power-domain-cells =3D <1>;
 		};
+
+		vchiq {
+			compatible =3D "brcm,bcm2835-vchiq";
+			reg =3D <0x7e00b840 0xf>;
+			interrupts =3D <0 2>;
+			cache-line-size =3D <32>;
+			firmware =3D <&firmware>;
+		};
 	};
 };
=20
=2D-=20
2.11.0


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE/JuuFDWp9/ZkuCBXtdYpNtH8nugFAljJubkACgkQtdYpNtH8
nujJtA/7Bx1a7mnS3Rd3xGAv7OtCIZu0plMwdCrOeQc45ShHVbMQxPSlevAhDHsm
EPI3pptGs5yFSVnKiS+v7gV4vv4MCyMFYR/lm0YX2Hbb/jZ/u7oYtsVeVyUDvUi2
4ut7vSCoH8jXFannpiha6mvVeFDTYdnOUS6p9+//muYvsFuG6t4Tb2s1oG0R025f
Yj9WXT+g3MngCJyFEUskpGXwR7JJpQ5Uoq/Z4bwF7/ekFVWcyvb1cY9XsNe8nP/F
9HeI69rxIwhJmJeExJM9Mzc8hOjFUpjecc54GLGu+039O/95xgqca5aEBHRMG2J5
4lCl0aE/vPkagDbvOXYzMN/OstWW0DsZQ2PKrnJw6i7FpJlkNLKVrBfgWOTc39Bi
vLjxoHK4yB/fqflJNC1fQrmeI3xDThf013emZT8Sxu/O/3i4sDRBioM5/YRxsQ/2
wJ1RfxIiOPWcgQvGHh582+InIIG+V76529IW3yfOdiJb93EyTZrefGE8mR3U/P8I
zUvdER7JrADzcWJsOJpXEZl0G5jnEyErZir8QJ8W27+WH/OrUbBbhbvT+DtAq/8+
89UdWDrZNBjGzxWK7kOtLWaxL6DrLvtEAm54HzhbBOzG1SGPJvjAVZ+zTa8QNpAR
jBb+05cHWKMX6khV5PmFLyISdjX4/xgwZYWpYrYQNnWxCVSuscs=
=3dtS
-----END PGP SIGNATURE-----
--=-=-=--
