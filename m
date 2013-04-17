Return-path: <linux-media-owner@vger.kernel.org>
Received: from service87.mimecast.com ([91.220.42.44]:39063 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755489Ab3DQPSU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Apr 2013 11:18:20 -0400
From: Pawel Moll <pawel.moll@arm.com>
To: linux-fbdev@vger.kernel.org, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	devicetree-discuss@lists.ozlabs.org,
	linux-arm-kernel@lists.infradead.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Pawel Moll <pawel.moll@arm.com>
Subject: [RFC 10/10] ARM: vexpress: Add CLCD Device Tree properties
Date: Wed, 17 Apr 2013 16:17:22 +0100
Message-Id: <1366211842-21497-11-git-send-email-pawel.moll@arm.com>
In-Reply-To: <1366211842-21497-1-git-send-email-pawel.moll@arm.com>
References: <1366211842-21497-1-git-send-email-pawel.moll@arm.com>
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Pawel Moll <pawel.moll@arm.com>
---
 arch/arm/boot/dts/vexpress-v2m-rs1.dtsi |   17 +++++++++++++----
 arch/arm/boot/dts/vexpress-v2m.dtsi     |   17 +++++++++++++----
 arch/arm/boot/dts/vexpress-v2p-ca9.dts  |    5 +++++
 3 files changed, 31 insertions(+), 8 deletions(-)

diff --git a/arch/arm/boot/dts/vexpress-v2m-rs1.dtsi b/arch/arm/boot/dts/ve=
xpress-v2m-rs1.dtsi
index ac870fb..aac9459 100644
--- a/arch/arm/boot/dts/vexpress-v2m-rs1.dtsi
+++ b/arch/arm/boot/dts/vexpress-v2m-rs1.dtsi
@@ -41,7 +41,7 @@
 =09=09=09bank-width =3D <4>;
 =09=09};
=20
-=09=09vram@2,00000000 {
+=09=09v2m_vram: vram@2,00000000 {
 =09=09=09compatible =3D "arm,vexpress-vram";
 =09=09=09reg =3D <2 0x00000000 0x00800000>;
 =09=09};
@@ -233,6 +233,12 @@
 =09=09=09=09interrupts =3D <14>;
 =09=09=09=09clocks =3D <&v2m_oscclk1>, <&smbclk>;
 =09=09=09=09clock-names =3D "clcdclk", "apb_pclk";
+=09=09=09=09label =3D "IOFPGA CLCD";
+=09=09=09=09video-ram =3D <&v2m_vram>;
+=09=09=09=09display =3D <&v2m_muxfpga 0>;
+=09=09=09=09max-hactive =3D <640>;
+=09=09=09=09max-vactive =3D <480>;
+=09=09=09=09max-bpp =3D <16>;
 =09=09=09};
 =09=09};
=20
@@ -282,7 +288,7 @@
 =09=09=09=09/* CLCD clock */
 =09=09=09=09compatible =3D "arm,vexpress-osc";
 =09=09=09=09arm,vexpress-sysreg,func =3D <1 1>;
-=09=09=09=09freq-range =3D <23750000 63500000>;
+=09=09=09=09freq-range =3D <23750000 65000000>;
 =09=09=09=09#clock-cells =3D <0>;
 =09=09=09=09clock-output-names =3D "v2m:oscclk1";
 =09=09=09};
@@ -317,9 +323,11 @@
 =09=09=09=09arm,vexpress-sysreg,func =3D <5 0>;
 =09=09=09};
=20
-=09=09=09muxfpga@0 {
+=09=09=09v2m_muxfpga: muxfpga@0 {
 =09=09=09=09compatible =3D "arm,vexpress-muxfpga";
 =09=09=09=09arm,vexpress-sysreg,func =3D <7 0>;
+=09=09=09=09#display-cells =3D <1>;
+=09=09=09=09display =3D <&v2m_dvimode>;
 =09=09=09};
=20
 =09=09=09shutdown@0 {
@@ -332,9 +340,10 @@
 =09=09=09=09arm,vexpress-sysreg,func =3D <9 0>;
 =09=09=09};
=20
-=09=09=09dvimode@0 {
+=09=09=09v2m_dvimode: dvimode@0 {
 =09=09=09=09compatible =3D "arm,vexpress-dvimode";
 =09=09=09=09arm,vexpress-sysreg,func =3D <11 0>;
+=09=09=09=09#display-cells =3D <0>;
 =09=09=09};
 =09=09};
 =09};
diff --git a/arch/arm/boot/dts/vexpress-v2m.dtsi b/arch/arm/boot/dts/vexpre=
ss-v2m.dtsi
index f142036..4d080d0 100644
--- a/arch/arm/boot/dts/vexpress-v2m.dtsi
+++ b/arch/arm/boot/dts/vexpress-v2m.dtsi
@@ -40,7 +40,7 @@
 =09=09=09bank-width =3D <4>;
 =09=09};
=20
-=09=09vram@3,00000000 {
+=09=09v2m_vram: vram@3,00000000 {
 =09=09=09compatible =3D "arm,vexpress-vram";
 =09=09=09reg =3D <3 0x00000000 0x00800000>;
 =09=09};
@@ -232,6 +232,12 @@
 =09=09=09=09interrupts =3D <14>;
 =09=09=09=09clocks =3D <&v2m_oscclk1>, <&smbclk>;
 =09=09=09=09clock-names =3D "clcdclk", "apb_pclk";
+=09=09=09=09label =3D "IOFPGA CLCD";
+=09=09=09=09video-ram =3D <&v2m_vram>;
+=09=09=09=09display =3D <&v2m_muxfpga 0>;
+=09=09=09=09max-hactive =3D <640>;
+=09=09=09=09max-vactive =3D <480>;
+=09=09=09=09max-bpp =3D <16>;
 =09=09=09};
 =09=09};
=20
@@ -281,7 +287,7 @@
 =09=09=09=09/* CLCD clock */
 =09=09=09=09compatible =3D "arm,vexpress-osc";
 =09=09=09=09arm,vexpress-sysreg,func =3D <1 1>;
-=09=09=09=09freq-range =3D <23750000 63500000>;
+=09=09=09=09freq-range =3D <23750000 65000000>;
 =09=09=09=09#clock-cells =3D <0>;
 =09=09=09=09clock-output-names =3D "v2m:oscclk1";
 =09=09=09};
@@ -316,9 +322,11 @@
 =09=09=09=09arm,vexpress-sysreg,func =3D <5 0>;
 =09=09=09};
=20
-=09=09=09muxfpga@0 {
+=09=09=09v2m_muxfpga: muxfpga@0 {
 =09=09=09=09compatible =3D "arm,vexpress-muxfpga";
 =09=09=09=09arm,vexpress-sysreg,func =3D <7 0>;
+=09=09=09=09#display-cells =3D <1>;
+=09=09=09=09display =3D <&v2m_dvimode>;
 =09=09=09};
=20
 =09=09=09shutdown@0 {
@@ -331,9 +339,10 @@
 =09=09=09=09arm,vexpress-sysreg,func =3D <9 0>;
 =09=09=09};
=20
-=09=09=09dvimode@0 {
+=09=09=09v2m_dvimode: dvimode@0 {
 =09=09=09=09compatible =3D "arm,vexpress-dvimode";
 =09=09=09=09arm,vexpress-sysreg,func =3D <11 0>;
+=09=09=09=09#display-cells =3D <0>;
 =09=09=09};
 =09=09};
 =09};
diff --git a/arch/arm/boot/dts/vexpress-v2p-ca9.dts b/arch/arm/boot/dts/vex=
press-v2p-ca9.dts
index 1420bb1..2a63510 100644
--- a/arch/arm/boot/dts/vexpress-v2p-ca9.dts
+++ b/arch/arm/boot/dts/vexpress-v2p-ca9.dts
@@ -73,6 +73,11 @@
 =09=09interrupts =3D <0 44 4>;
 =09=09clocks =3D <&oscclk1>, <&oscclk2>;
 =09=09clock-names =3D "clcdclk", "apb_pclk";
+=09=09label =3D "V2P-CA9 CLCD";
+=09=09display =3D <&v2m_muxfpga 0xf>;
+=09=09max-hactive =3D <1024>;
+=09=09max-vactive =3D <768>;
+=09=09max-bpp =3D <16>;
 =09};
=20
 =09memory-controller@100e0000 {
--=20
1.7.10.4


