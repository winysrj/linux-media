Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59145 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754039AbdBNNkj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Feb 2017 08:40:39 -0500
Date: Tue, 14 Feb 2017 14:40:26 +0100
From: Pavel Machek <pavel@ucw.cz>
To: sakari.ailus@iki.fi
Cc: sre@kernel.org, pali.rohar@gmail.com, pavel@ucw.cz,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        laurent.pinchart@ideasonboard.com, mchehab@kernel.org,
        ivo.g.dimitrov.75@gmail.com
Subject: [RFC 12/13] Enable camera on N900.
Message-ID: <20170214134026.GA8651@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="x+6KMIRAuhnl3hBn"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

---
 arch/arm/boot/dts/omap3-n900.dts | 158 +++++++++++++++++++++++++++++++++++=
+++-
 1 file changed, 157 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/omap3-n900.dts b/arch/arm/boot/dts/omap3-n90=
0.dts
index 87ca50b..aa4170f9 100644
--- a/arch/arm/boot/dts/omap3-n900.dts
+++ b/arch/arm/boot/dts/omap3-n900.dts
@@ -144,6 +144,59 @@
 		io-channel-names =3D "temp", "bsi", "vbat";
 	};
=20
+	rear_camera: camera@0 {
+		compatible =3D "linux,camera";
+
+		module {
+			model =3D "TCM8341MD";
+			sensor =3D <&cam1>;
+		};
+	};
+
+	front_camera: camera@1 {
+		compatible =3D "linux,camera";
+
+		module {
+			model =3D "VS6555";
+			sensor =3D <&cam2>;
+		};
+	};
+
+	video-bus-switch {
+		compatible =3D "video-bus-switch-gpio";
+
+		switch-gpios =3D <&gpio4 1 GPIO_ACTIVE_HIGH>; /* 97 */
+
+		ports {
+			#address-cells =3D <1>;
+			#size-cells =3D <0>;
+
+			port@0 {
+				reg =3D <0>;
+
+				csi_switch_in: endpoint {
+					remote-endpoint =3D <&csi_isp>;
+				};
+			};
+
+			port@1 {
+				reg =3D <1>;
+
+				csi_switch_out1: endpoint {
+					remote-endpoint =3D <&csi_cam1>;
+				};
+			};
+
+			port@2 {
+				reg =3D <2>;
+
+				csi_switch_out2: endpoint {
+					remote-endpoint =3D <&csi_cam2>;
+				};
+			};
+		};
+	};
+
 	pwm9: dmtimer-pwm {
 		compatible =3D "ti,omap-dmtimer-pwm";
 		#pwm-cells =3D <3>;
@@ -157,6 +210,32 @@
 	};
 };
=20
+&isp {
+	vdds_csib-supply =3D <&vaux2>;
+
+	pinctrl-names =3D "default";
+	pinctrl-0 =3D <&camera_pins>;
+	ti,camera-flashes =3D <&adp1653 &cam1 &ad5820 &cam1>;
+
+	ports {
+		port@1 {
+			reg =3D <1>;
+
+			csi_isp: endpoint {
+				remote-endpoint =3D <&csi_switch_in>;
+				bus-type =3D <3>; /* CCP2 */
+				clock-lanes =3D <0>;
+				data-lanes =3D <1>;
+				lane-polarity =3D <0 0>;
+				clock-inv =3D <0>;
+				/* Select strobe =3D <1> for back camera, <0> for front camera */
+				strobe =3D <1>;
+				crc =3D <0>;
+			};
+		};
+	};
+};
+
 &omap3_pmx_core {
 	pinctrl-names =3D "default";
=20
@@ -319,6 +398,22 @@
 			OMAP3_CORE1_IOPAD(0x218e, PIN_OUTPUT | MUX_MODE4)		/* gpio 157 =3D> cmt=
_bsi */
 		>;
 	};
+
+	camera_pins: pinmux_camera {
+		pinctrl-single,pins =3D <
+			OMAP3_CORE1_IOPAD(0x210c, PIN_OUTPUT | MUX_MODE7)       /* cam_hs */
+			OMAP3_CORE1_IOPAD(0x210e, PIN_OUTPUT | MUX_MODE7)       /* cam_vs */
+			OMAP3_CORE1_IOPAD(0x2110, PIN_OUTPUT | MUX_MODE0)       /* cam_xclka */
+			OMAP3_CORE1_IOPAD(0x211e, PIN_OUTPUT | MUX_MODE7)       /* cam_d4 */
+			OMAP3_CORE1_IOPAD(0x2122, PIN_INPUT | MUX_MODE0)        /* cam_d6 */
+			OMAP3_CORE1_IOPAD(0x2124, PIN_INPUT | MUX_MODE0)        /* cam_d7 */
+			OMAP3_CORE1_IOPAD(0x2126, PIN_INPUT | MUX_MODE0)        /* cam_d8 */
+			OMAP3_CORE1_IOPAD(0x2128, PIN_INPUT | MUX_MODE0)        /* cam_d9 */
+			OMAP3_CORE1_IOPAD(0x212a, PIN_OUTPUT | MUX_MODE7)       /* cam_d10 */
+			OMAP3_CORE1_IOPAD(0x212e, PIN_OUTPUT | MUX_MODE7)       /* cam_xclkb */
+			OMAP3_CORE1_IOPAD(0x2132, PIN_OUTPUT | MUX_MODE0)       /* cam_strobe */
+		>;
+	};
 };
=20
 &i2c1 {
@@ -507,6 +602,28 @@
=20
 	clock-frequency =3D <100000>;
=20
+	cam2: camera@10 {
+		compatible =3D "nokia,smia";
+		reg =3D <0x10>;
+
+		vana-supply =3D <&vaux4>;
+
+		clocks =3D <&isp 0>;
+		clock-frequency =3D <9600000>;
+
+		port {
+			csi_cam2: endpoint {
+				link-frequencies =3D /bits/ 64 <60000000>;
+				bus-type =3D <3>; /* CCP2 */
+				strobe =3D <0>;
+				clock-inv =3D <0>;
+				crc =3D <0>;
+
+				remote-endpoint =3D <&csi_switch_out2>;
+			};
+		};
+	};
+
 	tlv320aic3x: tlv320aic3x@18 {
 		compatible =3D "ti,tlv320aic3x";
 		reg =3D <0x18>;
@@ -716,18 +833,57 @@
 		st,max-limit-y =3D <32>;
 		st,max-limit-z =3D <32>;
 	};
+
+	cam1: camera@3e {
+		compatible =3D "toshiba,et8ek8";
+		reg =3D <0x3e>;
+
+		vana-supply =3D <&vaux4>;
+
+		clocks =3D <&isp 0>;
+		clock-names =3D "extclk";
+		clock-frequency =3D <9600000>;
+
+		reset-gpio =3D <&gpio4 6 GPIO_ACTIVE_HIGH>; /* 102 */
+
+		port {
+			csi_cam1: endpoint {
+				bus-type =3D <3>; /* CCP2 */
+				strobe =3D <1>;
+				clock-inv =3D <0>;
+				crc =3D <1>;
+
+				remote-endpoint =3D <&csi_switch_out1>;
+			};
+		};
+	};
+
+	/* D/A converter for auto-focus */
+	ad5820: dac@0c {
+		compatible =3D "adi,ad5820";
+		reg =3D <0x0c>;
+
+		VANA-supply =3D <&vaux4>;
+
+		#io-channel-cells =3D <0>;
+	};
 };
=20
 &mmc1 {
+	slot-name =3D "external";
 	pinctrl-names =3D "default";
 	pinctrl-0 =3D <&mmc1_pins>;
 	vmmc-supply =3D <&vmmc1>;
 	bus-width =3D <4>;
-	cd-gpios =3D <&gpio6 0 GPIO_ACTIVE_HIGH>; /* 160 */
+	/* For debugging, it is often good idea to remove this GPIO.
+	   It means you can remove back cover (to reboot by removing
+	   battery) and still use the MMC card. */
+//	cd-gpios =3D <&gpio6 0 GPIO_ACTIVE_HIGH>; /* 160 */
 };
=20
 /* most boards use vaux3, only some old versions use vmmc2 instead */
 &mmc2 {
+	slot-name =3D "internal";
 	pinctrl-names =3D "default";
 	pinctrl-0 =3D <&mmc2_pins>;
 	vmmc-supply =3D <&vaux3>;
--=20
2.1.4


--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--x+6KMIRAuhnl3hBn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlijCMoACgkQMOfwapXb+vIcgwCdFaO6Wii/zjZiidTtX/+0I7fr
PLwAoLwx3Y88UjRwoh5BmpqVXynq0sqE
=APw3
-----END PGP SIGNATURE-----

--x+6KMIRAuhnl3hBn--
