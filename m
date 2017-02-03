Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34932 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752272AbdBCMfM (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 3 Feb 2017 07:35:12 -0500
Date: Fri, 3 Feb 2017 13:35:08 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>, robh+dt@kernel.org,
        devicetree@vger.kernel.org
Cc: ivo.g.dimitrov.75@gmail.com, sre@kernel.org, pali.rohar@gmail.com,
        linux-media@vger.kernel.org, galak@codeaurora.org,
        mchehab@osg.samsung.com, linux-kernel@vger.kernel.org
Subject: [PATCH] devicetree: Add video bus switch
Message-ID: <20170203123508.GA10286@amd>
References: <20161023200355.GA5391@amd>
 <20161119232943.GF13965@valkosipuli.retiisi.org.uk>
 <20161214122451.GB27011@amd>
 <20161222100104.GA30917@amd>
 <20161222133938.GA30259@amd>
 <20161224152031.GA8420@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="mP3DRpeJDSE+ciuQ"
Content-Disposition: inline
In-Reply-To: <20161224152031.GA8420@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


N900 contains front and back camera, with a switch between the
two. This adds support for the switch component, and it is now
possible to select between front and back cameras during runtime.

This adds documentation for the devicetree binding.

Signed-off-by: Sebastian Reichel <sre@kernel.org>
Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Signed-off-by: Pavel Machek <pavel@ucw.cz>


diff --git a/Documentation/devicetree/bindings/media/video-bus-switch.txt b=
/Documentation/devicetree/bindings/media/video-bus-switch.txt
new file mode 100644
index 0000000..1b9f8e0
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/video-bus-switch.txt
@@ -0,0 +1,63 @@
+Video Bus Switch Binding
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+This is a binding for a gpio controlled switch for camera interfaces. Such=
 a
+device is used on some embedded devices to connect two cameras to the same
+interface of a image signal processor.
+
+Required properties
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+compatible	: must contain "video-bus-switch"
+switch-gpios	: GPIO specifier for the gpio, which can toggle the
+		  selected camera. The GPIO should be configured, so
+		  that a disabled GPIO means, that the first port is
+		  selected.
+
+Required Port nodes
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+More documentation on these bindings is available in
+video-interfaces.txt in the same directory.
+
+reg		: The interface:
+		  0 - port for image signal processor
+		  1 - port for first camera sensor
+		  2 - port for second camera sensor
+
+Example
+=3D=3D=3D=3D=3D=3D=3D
+
+video-bus-switch {
+	compatible =3D "video-bus-switch"
+	switch-gpios =3D <&gpio1 1 GPIO_ACTIVE_HIGH>;
+
+	ports {
+		#address-cells =3D <1>;
+		#size-cells =3D <0>;
+
+		port@0 {
+			reg =3D <0>;
+
+			csi_switch_in: endpoint {
+				remote-endpoint =3D <&csi_isp>;
+			};
+		};
+
+		port@1 {
+			reg =3D <1>;
+
+			csi_switch_out1: endpoint {
+				remote-endpoint =3D <&csi_cam1>;
+			};
+		};
+
+		port@2 {
+			reg =3D <2>;
+
+			csi_switch_out2: endpoint {
+				remote-endpoint =3D <&csi_cam2>;
+			};
+		};
+	};
+};



--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--mP3DRpeJDSE+ciuQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAliUePwACgkQMOfwapXb+vKJTQCfQduvtz/0WVlKURllpoCZ5ftu
E7AAoJIJkHA98p8p88THy+Jhv7cCUu/q
=+2+b
-----END PGP SIGNATURE-----

--mP3DRpeJDSE+ciuQ--
