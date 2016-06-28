Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36680 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415AbcF1TTQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jun 2016 15:19:16 -0400
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To: linux-amlogic@lists.infradead.org, linux-media@vger.kernel.org
Cc: robh+dt@kernel.org, mark.rutland@arm.com, carlo@caione.org,
	khilman@baylibre.com, mchehab@kernel.org,
	devicetree@vger.kernel.org, narmstrong@baylibre.com,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v3 0/4] Add Meson 8b / GXBB support to the IR driver
Date: Tue, 28 Jun 2016 21:17:58 +0200
Message-Id: <20160628191802.21227-1-martin.blumenstingl@googlemail.com>
In-Reply-To: <20160626210622.5257-1-martin.blumenstingl@googlemail.com>
References: <20160626210622.5257-1-martin.blumenstingl@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Newer Amlogic platforms (Meson 8b and GXBB) use a slightly different
register layout for their Infrared Remoete Controller. The decoder mode
is now configured in another register. Without the changes to the
meson-ir driver we are simply getting incorrect "durations" reported
from the hardware (because the hardware is not in time measurement aka
software decode mode).

This problem was also noticed by some people trying to use this on an
ODROID-C1 and ODROID-C2 - the workaround there (probably because the
datasheets were not publicy available yet at that time) was to switch
to ir_raw_event_store_edge (which leaves it up to the kernel to measure
the duration of a pulse). See [0] and [1] for the corresponding
patches.


Changes in v3:
- based on the patches of Neil Armstrong
- depending on the platform either the old (default) or new registers
  (this has to be enabled explicitly by using "amlogic,meson8b-ir" or
  "amlogic,meson-gxbb-ir")
- the changes to arch/arm/boot/dts/meson.dtsi are not part of this
  series anymore, because the size specified there is valid for the
  Meson 6b version of the IR decoder
- Add the IR decoder to meson-gxbb.dtsi and enable it on the supported
  boards


[0] https://github.com/erdoukki/linux-amlogic-1/commit/969b2e2242fb14a13cb651f9a1cf771b599c958b
[1] http://forum.odroid.com/viewtopic.php?f=135&t=20504


Martin Blumenstingl (1):
  ARM64: dts: meson-gxbb: Enable the the IR decoder on supported boards

Neil Armstrong (3):
  dt-bindings: media: meson-ir: Add Meson8b and GXBB compatible strings
  media: rc: meson-ir: Add support for newer versions of the IR decoder
  ARM64: meson-gxbb: Add Infrared Remote Controller decoder

 .../devicetree/bindings/media/meson-ir.txt         |  5 +++-
 .../arm64/boot/dts/amlogic/meson-gxbb-odroidc2.dts |  4 +++
 arch/arm64/boot/dts/amlogic/meson-gxbb-p20x.dtsi   |  4 +++
 .../boot/dts/amlogic/meson-gxbb-vega-s95.dtsi      |  4 +++
 arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi        |  7 ++++++
 drivers/media/rc/meson-ir.c                        | 29 ++++++++++++++++++----
 6 files changed, 47 insertions(+), 6 deletions(-)

-- 
2.9.0

