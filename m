Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm1-f65.google.com ([209.85.128.65]:36276 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726572AbeJBXvO (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 2 Oct 2018 19:51:14 -0400
From: ektor5 <ek5.chimenti@gmail.com>
Cc: hverkuil@xs4all.nl, luca.pisani@udoo.org, jose.abreu@synopsys.com,
        sean@mess.org, sakari.ailus@linux.intel.com,
        ektor5 <ek5.chimenti@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Jacob Chen <jacob-chen@iotwrt.com>,
        Todor Tomov <todor.tomov@linaro.org>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Neil Armstrong <narmstrong@baylibre.com>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCH 0/2] Add SECO Boards CEC device driver
Date: Tue,  2 Oct 2018 18:59:54 +0200
Message-Id: <cover.1538474121.git.ek5.chimenti@gmail.com>
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

Ettore Chimenti (2):
  media: add SECO cec driver
  seco-cec: add Consumer-IR support

 MAINTAINERS                                |   6 +
 drivers/media/platform/Kconfig             |  21 +
 drivers/media/platform/Makefile            |   4 +
 drivers/media/platform/seco-cec/Makefile   |   1 +
 drivers/media/platform/seco-cec/seco-cec.c | 859 +++++++++++++++++++++
 drivers/media/platform/seco-cec/seco-cec.h | 143 ++++
 6 files changed, 1034 insertions(+)
 create mode 100644 drivers/media/platform/seco-cec/Makefile
 create mode 100644 drivers/media/platform/seco-cec/seco-cec.c
 create mode 100644 drivers/media/platform/seco-cec/seco-cec.h

-- 
2.18.0
