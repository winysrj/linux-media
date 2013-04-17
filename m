Return-path: <linux-media-owner@vger.kernel.org>
Received: from service87.mimecast.com ([91.220.42.44]:33859 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966618Ab3DQPRj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Apr 2013 11:17:39 -0400
From: Pawel Moll <pawel.moll@arm.com>
To: linux-fbdev@vger.kernel.org, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	devicetree-discuss@lists.ozlabs.org,
	linux-arm-kernel@lists.infradead.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Pawel Moll <pawel.moll@arm.com>
Subject: [RFC 00/10] Versatile Express CLCD DVI output support
Date: Wed, 17 Apr 2013 16:17:12 +0100
Message-Id: <1366211842-21497-1-git-send-email-pawel.moll@arm.com>
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello All,

This series implements support for the Versatile Express
video output pipeline, which is not the simplest one available...

It is meant as a RFC only and I'm hoping to attract all possible
feedback (*including* naming ;-).

The VE's "MultiMedia Bus" [1] comprises three video signal sources
(motherboard's CLCD cell and a implementation-specific driver
on each of the daugtherboards) and a FPGA multiplexer routing
data from one of the sources to DVI/HDMI formatter chip (Sii9022).

+-----+
| DB1 |>--+                         DVI connector
+-----+   |   +------+                   +--+
          +-->|      |                   |oo|
+-----+       | mux  |    +---------+    |oo|
| DB2 |>----->|      |>-->| sii9022 |>-->|oo|
+-----+       | FPGA |    +---------+    |oo|
          +-->|      |                   |oo|
+-----+   |   +------+                   +--+
| MB  |>--+
+-----+

The series is based on Laurent Pinchart's Common Display Framework
patch (not in mainline yet, v2 discussed here: [2]) and extends it
by adding DT bindings and basic support for TFT panels.

The CLCD driver has been adapted to work with the framework and
the Device Tree information.

Also a set of drivers for the VE-specific components is included
(note that the sii9022 is now driven via the moterboard firmware;
this is intended to be replaced by a proper I2C driver for the
chip).

It is worth mentioning that the CDF caters for both fbdev and DRM
so the solution should be suitable for all potential DRM-driven
display controllers.

[1] http://infocenter.arm.com/help/topic/com.arm.doc.dui0447h/CHDEHEAA.html=
#CACGIGGC
[2] http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/=
57298


Laurent Pinchart (1):
  video: Add generic display entity core

Pawel Moll (9):
  video: display: Update the display with the video mode data
  video: display: Add Device Tree bindings
  video: display: Add generic TFT display type
  fbmon: Add extra video helper
  video: ARM CLCD: Add DT & CDF support
  mfd: vexpress: Allow external drivers to parse site ids
  video: Versatile Express MUXFPGA driver
  video: Versatile Express DVI mode driver
  ARM: vexpress: Add CLCD Device Tree properties

 .../testing/sysfs-driver-video-vexpress-muxfpga    |    5 +
 .../devicetree/bindings/video/arm,pl11x.txt        |   35 ++
 .../devicetree/bindings/video/display-bindings.txt |   75 ++++
 arch/arm/boot/dts/vexpress-v2m-rs1.dtsi            |   17 +-
 arch/arm/boot/dts/vexpress-v2m.dtsi                |   17 +-
 arch/arm/boot/dts/vexpress-v2p-ca9.dts             |    5 +
 drivers/mfd/vexpress-sysreg.c                      |    5 +
 drivers/video/Kconfig                              |    2 +
 drivers/video/Makefile                             |    5 +
 drivers/video/amba-clcd.c                          |  244 +++++++++++
 drivers/video/display/Kconfig                      |    4 +
 drivers/video/display/Makefile                     |    1 +
 drivers/video/display/display-core.c               |  447 ++++++++++++++++=
++++
 drivers/video/fbmon.c                              |   29 ++
 drivers/video/vexpress-dvimode.c                   |  158 +++++++
 drivers/video/vexpress-muxfpga.c                   |  228 ++++++++++
 include/linux/amba/clcd.h                          |    2 +
 include/linux/fb.h                                 |    3 +
 include/linux/vexpress.h                           |    2 +
 include/video/display.h                            |  172 ++++++++
 20 files changed, 1448 insertions(+), 8 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-video-vexpress-m=
uxfpga
 create mode 100644 Documentation/devicetree/bindings/video/arm,pl11x.txt
 create mode 100644 Documentation/devicetree/bindings/video/display-binding=
s.txt
 create mode 100644 drivers/video/display/Kconfig
 create mode 100644 drivers/video/display/Makefile
 create mode 100644 drivers/video/display/display-core.c
 create mode 100644 drivers/video/vexpress-dvimode.c
 create mode 100644 drivers/video/vexpress-muxfpga.c
 create mode 100644 include/video/display.h

--=20
1.7.10.4


