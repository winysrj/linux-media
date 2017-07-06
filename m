Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f173.google.com ([209.85.128.173]:34515 "EHLO
        mail-wr0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751850AbdGFK2H (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 6 Jul 2017 06:28:07 -0400
Received: by mail-wr0-f173.google.com with SMTP id 77so22787118wrb.1
        for <linux-media@vger.kernel.org>; Thu, 06 Jul 2017 03:28:07 -0700 (PDT)
From: Neil Armstrong <narmstrong@baylibre.com>
To: mchehab@kernel.org, hans.verkuil@cisco.com
Cc: Neil Armstrong <narmstrong@baylibre.com>,
        linux-media@vger.kernel.org, linux-amlogic@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] media: Add Amlogic Meson AO CEC Controller support
Date: Thu,  6 Jul 2017 12:27:48 +0200
Message-Id: <1499336870-24118-1-git-send-email-narmstrong@baylibre.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Amlogic SoC embeds a standalone CEC controller, this patch adds a driver
for such controller.
The controller does not need HPD to be active, and could support up to max
5 logical addresses, but only 1 is handled since the Suspend firmware can
make use of this unique logical address to wake up the device.

The Suspend firmware configuration will be added in an other patchset.

Neil Armstrong (2):
  platform: Add Amlogic Meson AO CEC Controller driver
  dt-bindings: media: Add Amlogic Meson AO-CEC bindings

 .../devicetree/bindings/media/meson-ao-cec.txt     |  28 +
 drivers/media/platform/Kconfig                     |  11 +
 drivers/media/platform/Makefile                    |   2 +
 drivers/media/platform/meson/Makefile              |   1 +
 drivers/media/platform/meson/ao-cec.c              | 653 +++++++++++++++++++++
 5 files changed, 695 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/meson-ao-cec.txt
 create mode 100644 drivers/media/platform/meson/Makefile
 create mode 100644 drivers/media/platform/meson/ao-cec.c

-- 
1.9.1
