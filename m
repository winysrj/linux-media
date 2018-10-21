Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40118 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727688AbeJVBOK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 21 Oct 2018 21:14:10 -0400
From: ektor5 <ek5.chimenti@gmail.com>
Cc: hverkuil@xs4all.nl, luca.pisani@udoo.org, jose.abreu@synopsys.com,
        sean@mess.org, sakari.ailus@linux.intel.com,
        ektor5 <ek5.chimenti@gmail.com>, jacopo@jmondi.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Lee Jones <lee.jones@linaro.org>,
        Todor Tomov <todor.tomov@linaro.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCH v4 0/2] Add SECO Boards CEC device driver
Date: Sun, 21 Oct 2018 18:58:18 +0200
Message-Id: <cover.1539963738.git.ek5.chimenti@gmail.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This series of patches aims to add CEC functionalities to SECO
devices, in particular UDOO X86.

The communication is achieved via Braswell SMBus (i2c-i801) to the
onboard STM32 microcontroller that handles the CEC signals. The driver
use direct access to the PCI addresses, due to the limitations of the
specific driver in presence of ACPI calls.

The basic functionalities are tested with success with cec-ctl and
cec-compliance.

v4:
 - Reduced SMBus timeout
 - Removed/updated debug printouts
 - Removed useless return values
 - Update SECO denomination

v3:
 - Refactored rx/tx for loops
 - Removed more debug prints
 - Sorted headers 

v2:
 - Removed useless debug prints
 - Added DMI && PCI to dependences
 - Removed useless ifdefs
 - Renamed all irda references to ir
 - Fixed SPDX clause
 - Several style fixes

Ettore Chimenti (2):
  media: add SECO cec driver
  seco-cec: add Consumer-IR support

 MAINTAINERS                                |   6 +
 drivers/media/platform/Kconfig             |  22 +
 drivers/media/platform/Makefile            |   2 +
 drivers/media/platform/seco-cec/Makefile   |   1 +
 drivers/media/platform/seco-cec/seco-cec.c | 795 +++++++++++++++++++++
 drivers/media/platform/seco-cec/seco-cec.h | 141 ++++
 6 files changed, 967 insertions(+)
 create mode 100644 drivers/media/platform/seco-cec/Makefile
 create mode 100644 drivers/media/platform/seco-cec/seco-cec.c
 create mode 100644 drivers/media/platform/seco-cec/seco-cec.h

-- 
2.18.0
