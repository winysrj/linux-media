Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([69.46.227.141]:57786 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750902AbdAMHrn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 13 Jan 2017 02:47:43 -0500
From: <sean.wang@mediatek.com>
To: <mchehab@osg.samsung.com>, <hdegoede@redhat.com>,
        <hkallweit1@gmail.com>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <matthias.bgg@gmail.com>
CC: <andi.shyti@samsung.com>, <hverkuil@xs4all.nl>, <sean@mess.org>,
        <ivo.g.dimitrov.75@gmail.com>, <linux-media@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <keyhaede@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>
Subject: [PATCH v3 1/3] Documentation: devicetree: move shared property used by rc into a common place
Date: Fri, 13 Jan 2017 15:35:37 +0800
Message-ID: <1484292939-9454-2-git-send-email-sean.wang@mediatek.com>
In-Reply-To: <1484292939-9454-1-git-send-email-sean.wang@mediatek.com>
References: <1484292939-9454-1-git-send-email-sean.wang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sean Wang <sean.wang@mediatek.com>

Most IR drivers uses the same label to identify the
scancdoe/key table they used by multiple bindings and lack
explanation well. So move the shared property into a common
place and give better explanation.

Signed-off-by: Sean Wang <sean.wang@mediatek.com>
---
 .../devicetree/bindings/media/gpio-ir-receiver.txt |   3 +-
 .../devicetree/bindings/media/hix5hd2-ir.txt       |   2 +-
 Documentation/devicetree/bindings/media/rc.txt     | 116 +++++++++++++++++++++
 .../devicetree/bindings/media/sunxi-ir.txt         |   2 +-
 4 files changed, 120 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/rc.txt

diff --git a/Documentation/devicetree/bindings/media/gpio-ir-receiver.txt b/Documentation/devicetree/bindings/media/gpio-ir-receiver.txt
index 56e726e..58261fb 100644
--- a/Documentation/devicetree/bindings/media/gpio-ir-receiver.txt
+++ b/Documentation/devicetree/bindings/media/gpio-ir-receiver.txt
@@ -5,7 +5,8 @@ Required properties:
 	- gpios: specifies GPIO used for IR signal reception.
 
 Optional properties:
-	- linux,rc-map-name: Linux specific remote control map name.
+	- linux,rc-map-name: see rc.txt file in the same
+	  directory.
 
 Example node:
 
diff --git a/Documentation/devicetree/bindings/media/hix5hd2-ir.txt b/Documentation/devicetree/bindings/media/hix5hd2-ir.txt
index 54e1bed..13ebc0f 100644
--- a/Documentation/devicetree/bindings/media/hix5hd2-ir.txt
+++ b/Documentation/devicetree/bindings/media/hix5hd2-ir.txt
@@ -10,7 +10,7 @@ Required properties:
 	- clocks: clock phandle and specifier pair.
 
 Optional properties:
-	- linux,rc-map-name : Remote control map name.
+	- linux,rc-map-name: see rc.txt file in the same directory.
 	- hisilicon,power-syscon: DEPRECATED. Don't use this in new dts files.
 		Provide correct clocks instead.
 
diff --git a/Documentation/devicetree/bindings/media/rc.txt b/Documentation/devicetree/bindings/media/rc.txt
new file mode 100644
index 0000000..0d16d14
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/rc.txt
@@ -0,0 +1,116 @@
+The following properties are common to the infrared remote controllers:
+
+- linux,rc-map-name: string, specifies the scancode/key mapping table
+  defined in-kernel for the remote controller. Support values are:
+  * "rc-adstech-dvb-t-pci"
+  * "rc-alink-dtu-m"
+  * "rc-anysee"
+  * "rc-apac-viewcomp"
+  * "rc-asus-pc39"
+  * "rc-asus-ps3-100"
+  * "rc-ati-tv-wonder-hd-600"
+  * "rc-ati-x10"
+  * "rc-avermedia-a16d"
+  * "rc-avermedia-cardbus"
+  * "rc-avermedia-dvbt"
+  * "rc-avermedia-m135a"
+  * "rc-avermedia-m733a-rm-k6"
+  * "rc-avermedia-rm-ks"
+  * "rc-avermedia"
+  * "rc-avertv-303"
+  * "rc-azurewave-ad-tu700"
+  * "rc-behold-columbus"
+  * "rc-behold"
+  * "rc-budget-ci-old"
+  * "rc-cec"
+  * "rc-cinergy-1400"
+  * "rc-cinergy"
+  * "rc-delock-61959"
+  * "rc-dib0700-nec"
+  * "rc-dib0700-rc5"
+  * "rc-digitalnow-tinytwin"
+  * "rc-digittrade"
+  * "rc-dm1105-nec"
+  * "rc-dntv-live-dvbt-pro"
+  * "rc-dntv-live-dvb-t"
+  * "rc-dtt200u"
+  * "rc-dvbsky"
+  * "rc-empty"
+  * "rc-em-terratec"
+  * "rc-encore-enltv2"
+  * "rc-encore-enltv-fm53"
+  * "rc-encore-enltv"
+  * "rc-evga-indtube"
+  * "rc-eztv"
+  * "rc-flydvb"
+  * "rc-flyvideo"
+  * "rc-fusionhdtv-mce"
+  * "rc-gadmei-rm008z"
+  * "rc-genius-tvgo-a11mce"
+  * "rc-gotview7135"
+  * "rc-hauppauge"
+  * "rc-imon-mce"
+  * "rc-imon-pad"
+  * "rc-iodata-bctv7e"
+  * "rc-it913x-v1"
+  * "rc-it913x-v2"
+  * "rc-kaiomy"
+  * "rc-kworld-315u"
+  * "rc-kworld-pc150u"
+  * "rc-kworld-plus-tv-analog"
+  * "rc-leadtek-y04g0051"
+  * "rc-lirc"
+  * "rc-lme2510"
+  * "rc-manli"
+  * "rc-medion-x10"
+  * "rc-medion-x10-digitainer"
+  * "rc-medion-x10-or2x"
+  * "rc-msi-digivox-ii"
+  * "rc-msi-digivox-iii"
+  * "rc-msi-tvanywhere-plus"
+  * "rc-msi-tvanywhere"
+  * "rc-nebula"
+  * "rc-nec-terratec-cinergy-xs"
+  * "rc-norwood"
+  * "rc-npgtech"
+  * "rc-pctv-sedna"
+  * "rc-pinnacle-color"
+  * "rc-pinnacle-grey"
+  * "rc-pinnacle-pctv-hd"
+  * "rc-pixelview-new"
+  * "rc-pixelview"
+  * "rc-pixelview-002t"
+  * "rc-pixelview-mk12"
+  * "rc-powercolor-real-angel"
+  * "rc-proteus-2309"
+  * "rc-purpletv"
+  * "rc-pv951"
+  * "rc-hauppauge"
+  * "rc-rc5-tv"
+  * "rc-rc6-mce"
+  * "rc-real-audio-220-32-keys"
+  * "rc-reddo"
+  * "rc-snapstream-firefly"
+  * "rc-streamzap"
+  * "rc-tbs-nec"
+  * "rc-technisat-ts35"
+  * "rc-technisat-usb2"
+  * "rc-terratec-cinergy-c-pci"
+  * "rc-terratec-cinergy-s2-hd"
+  * "rc-terratec-cinergy-xs"
+  * "rc-terratec-slim"
+  * "rc-terratec-slim-2"
+  * "rc-tevii-nec"
+  * "rc-tivo"
+  * "rc-total-media-in-hand"
+  * "rc-total-media-in-hand-02"
+  * "rc-trekstor"
+  * "rc-tt-1500"
+  * "rc-twinhan-dtv-cab-ci"
+  * "rc-twinhan1027"
+  * "rc-videomate-k100"
+  * "rc-videomate-s350"
+  * "rc-videomate-tv-pvr"
+  * "rc-winfast"
+  * "rc-winfast-usbii-deluxe"
+  * "rc-su3000"
diff --git a/Documentation/devicetree/bindings/media/sunxi-ir.txt b/Documentation/devicetree/bindings/media/sunxi-ir.txt
index 1811a06..302a0b1 100644
--- a/Documentation/devicetree/bindings/media/sunxi-ir.txt
+++ b/Documentation/devicetree/bindings/media/sunxi-ir.txt
@@ -9,7 +9,7 @@ Required properties:
 - reg		    : should contain IO map address for IR.
 
 Optional properties:
-- linux,rc-map-name : Remote control map name.
+- linux,rc-map-name: see rc.txt file in the same directory.
 - resets : phandle + reset specifier pair
 
 Example:
-- 
1.9.1

