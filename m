Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35127 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752583AbcHTKKn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 20 Aug 2016 06:10:43 -0400
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To: linux-media@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org,
        narmstrong@baylibre.com, linus.walleij@linaro.org,
        khilman@baylibre.com, carlo@caione.org
Cc: linux-arm-kernel@lists.infradead.org, mchehab@kernel.org,
        will.deacon@arm.com, catalin.marinas@arm.com, mark.rutland@arm.com,
        robh+dt@kernel.org, b.galvani@gmail.com,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v5 0/6] Add Meson 8b / GXBB support to the IR driver
Date: Sat, 20 Aug 2016 11:54:18 +0200
Message-Id: <20160820095424.636-1-martin.blumenstingl@googlemail.com>
In-Reply-To: <20160819215547.20063-1-martin.blumenstingl@googlemail.com>
References: <20160819215547.20063-1-martin.blumenstingl@googlemail.com>
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

Changes in v5:
- changed pin function and group names to remote_input_ao so they match
  with the datasheet


Tested-by: Neil Armstrong <narmstrong@baylibre.com>


[0] https://github.com/erdoukki/linux-amlogic-1/commit/969b2e2242fb14a13cb651f9a1cf771b599c958b
[1] http://forum.odroid.com/viewtopic.php?f=135&t=20504


Martin Blumenstingl (3):
  pinctrl: amlogic: gxbb: add the IR remote input pin
  ARM64: dts: amlogic: add the input pin for the IR remote
  ARM64: dts: meson-gxbb: Enable the the IR decoder on supported boards

Neil Armstrong (3):
  dt-bindings: media: meson-ir: Add Meson8b and GXBB compatible strings
  media: rc: meson-ir: Add support for newer versions of the IR decoder
  ARM64: dts: meson-gxbb: Add Infrared Remote Controller decoder

 .../devicetree/bindings/media/meson-ir.txt         |  5 +++-
 .../arm64/boot/dts/amlogic/meson-gxbb-odroidc2.dts |  6 +++++
 arch/arm64/boot/dts/amlogic/meson-gxbb-p20x.dtsi   |  6 +++++
 .../boot/dts/amlogic/meson-gxbb-vega-s95.dtsi      |  6 +++++
 arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi        | 14 +++++++++++
 drivers/media/rc/meson-ir.c                        | 29 ++++++++++++++++++----
 drivers/pinctrl/meson/pinctrl-meson-gxbb.c         |  8 ++++++
 7 files changed, 68 insertions(+), 6 deletions(-)

-- 
2.9.3

