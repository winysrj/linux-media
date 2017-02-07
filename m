Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:38623 "EHLO
        mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755339AbdBGQlw (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Feb 2017 11:41:52 -0500
Received: by mail-wm0-f42.google.com with SMTP id r141so159362269wmg.1
        for <linux-media@vger.kernel.org>; Tue, 07 Feb 2017 08:41:47 -0800 (PST)
From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
To: Kevin Hilman <khilman@kernel.org>, Sekhar Nori <nsekhar@ti.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        Michael Turquette <mturquette@baylibre.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Russell King <linux@armlinux.org.uk>,
        Alexandre Bailon <abailon@baylibre.com>,
        David Lechner <david@lechnology.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Lad Prabhakar <prabhakar.csengg@gmail.com>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 00/10] ARM: davinci: add vpif display support
Date: Tue,  7 Feb 2017 17:41:13 +0100
Message-Id: <1486485683-11427-1-git-send-email-bgolaszewski@baylibre.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following series adds support for v4l2 display on da850-evm with
a UI board in device tree boot mode.

Patches 1/10 - 5/10 deal with the device tree: we fix whitespace
errors in dts files and bindings, extend the example and the dts for
da850-evm with the output port and address the pinmuxing.

Patch 6/10 enables the relevant modules in the defconfig file.

Patches 7/10 and 8/10 fix two already existing bugs encountered
during development.

Patch 9/10 make it possible to use a different i2c adapter in the
vpif display driver.

The last patch adds the pdata quirks necessary to enable v4l2 display.

Tested with a modified version of yavta[1] as gstreamer support for
v4l2 seems to be broken and results in picture artifacts.

[1] https://github.com/brgl/yavta davinci/vpif-display

Bartosz Golaszewski (10):
  media: dt-bindings: vpif: fix whitespace errors
  ARM: dts: da850-evm: fix whitespace errors
  media: dt-bindings: vpif: extend the example with an output port
  ARM: dts: da850-evm: add the output port to the vpif node
  ARM: dts: da850: add vpif video display pins
  ARM: davinci_all_defconfig: enable VPIF display modules
  ARM: davinci: fix a whitespace error
  ARM: davinci: fix the DT boot on da850-evm
  media: vpif: use a configurable i2c_adapter_id for vpif display
  ARM: davinci: add pdata-quirks for da850-evm vpif display

 .../devicetree/bindings/media/ti,da850-vpif.txt    | 45 ++++++++---
 arch/arm/boot/dts/da850-evm.dts                    | 26 +++---
 arch/arm/boot/dts/da850.dtsi                       | 25 +++++-
 arch/arm/configs/davinci_all_defconfig             |  2 +
 arch/arm/mach-davinci/board-da850-evm.c            |  1 +
 arch/arm/mach-davinci/pdata-quirks.c               | 92 ++++++++++++++++++++--
 drivers/media/platform/davinci/vpif_display.c      |  2 +-
 include/media/davinci/vpif_types.h                 |  1 +
 8 files changed, 164 insertions(+), 30 deletions(-)

-- 
2.9.3

