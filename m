Return-path: <linux-media-owner@vger.kernel.org>
Received: from shell.v3.sk ([90.176.6.54]:50076 "EHLO shell.v3.sk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726620AbeKTUcR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Nov 2018 15:32:17 -0500
From: Lubomir Rintel <lkundrak@v3.sk>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-media@vger.kernel.org
Cc: Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lubomir Rintel <lkundrak@v3.sk>,
        James Cameron <quozl@laptop.org>, Pavel Machek <pavel@ucw.cz>,
        Libin Yang <lbyang@marvell.com>,
        Albert Wang <twang13@marvell.com>
Subject: [PATCH v3 05/14] media: dt-bindings: marvell,mmp2-ccic: Add Marvell MMP2 camera
Date: Tue, 20 Nov 2018 11:03:10 +0100
Message-Id: <20181120100318.367987-6-lkundrak@v3.sk>
In-Reply-To: <20181120100318.367987-1-lkundrak@v3.sk>
References: <20181120100318.367987-1-lkundrak@v3.sk>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add Marvell MMP2 camera host interface.

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>

---
Changes since v2:
- Added #clock-cells, clock-names, port

 .../bindings/media/marvell,mmp2-ccic.txt      | 37 +++++++++++++++++++
 1 file changed, 37 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/marvell,mmp2-=
ccic.txt

diff --git a/Documentation/devicetree/bindings/media/marvell,mmp2-ccic.tx=
t b/Documentation/devicetree/bindings/media/marvell,mmp2-ccic.txt
new file mode 100644
index 000000000000..e5e8ca90e7f7
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/marvell,mmp2-ccic.txt
@@ -0,0 +1,37 @@
+Marvell MMP2 camera host interface
+
+Required properties:
+ - compatible: Should be "marvell,mmp2-ccic"
+ - reg: register base and size
+ - interrupts: the interrupt number
+ - #clock-cells: must be 0
+ - any required generic properties defined in video-interfaces.txt
+
+Optional properties:
+ - clocks: input clock (see clock-bindings.txt)
+ - clock-names: names of the clocks used, may include "axi", "func" and
+                "phy"
+ - clock-output-names: should contain the name of the clock driving the
+                       sensor master clock MCLK
+
+Required subnodes:
+ - port: the parallel bus interface port with a single endpoint linked t=
o
+         the sensor's endpoint as described in video-interfaces.txt
+
+Example:
+
+	camera0: camera@d420a000 {
+		compatible =3D "marvell,mmp2-ccic";
+		reg =3D <0xd420a000 0x800>;
+		interrupts =3D <42>;
+		clocks =3D <&soc_clocks MMP2_CLK_CCIC0>;
+		clock-names =3D "axi";
+		#clock-cells =3D <0>;
+		clock-output-names =3D "mclk";
+
+		port {
+			camera0_0: endpoint {
+				remote-endpoint =3D <&ov7670_0>;
+			};
+		};
+	};
--=20
2.19.1
