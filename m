Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f179.google.com ([209.85.128.179]:37969 "EHLO
        mail-wr0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751454AbdG0PUg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Jul 2017 11:20:36 -0400
Received: by mail-wr0-f179.google.com with SMTP id f21so88579516wrf.5
        for <linux-media@vger.kernel.org>; Thu, 27 Jul 2017 08:20:35 -0700 (PDT)
From: Neil Armstrong <narmstrong@baylibre.com>
To: mchehab@kernel.org, hans.verkuil@cisco.com
Cc: Neil Armstrong <narmstrong@baylibre.com>,
        linux-media@vger.kernel.org, linux-amlogic@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/2] media: Add Amlogic Meson AO CEC Controller support
Date: Thu, 27 Jul 2017 17:20:28 +0200
Message-Id: <1501168830-5308-1-git-send-email-narmstrong@baylibre.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Amlogic SoC embeds a standalone CEC controller, this patch adds a driver
for such controller.
The controller does not need HPD to be active, and could support up to max
5 logical addresses, but only 1 is handled since the Suspend firmware can
make use of this unique logical address to wake up the device.

The Suspend firmware configuration will be added in an other patchset.

Changes since v2 at [2] :
 - change meson_ao_cec_read/write prototype to simplify error handling

Changes since v1 at [1] :
 - add timeout to wait busy, with error return
 - handle busy error in all read/write operations
 - add CEC_CAP_PASSTHROUGH
 - add bindings ack

[1] https://lkml.kernel.org/r/1499336870-24118-1-git-send-email-narmstrong@baylibre.com
[2] https://lkml.kernel.org/r/1499673696-21372-1-git-send-email-narmstrong@baylibre.com

Neil Armstrong (2):
  platform: Add Amlogic Meson AO CEC Controller driver
  dt-bindings: media: Add Amlogic Meson AO-CEC bindings

 .../devicetree/bindings/media/meson-ao-cec.txt     |  28 +
 drivers/media/platform/Kconfig                     |  11 +
 drivers/media/platform/Makefile                    |   2 +
 drivers/media/platform/meson/Makefile              |   1 +
 drivers/media/platform/meson/ao-cec.c              | 744 +++++++++++++++++++++
 5 files changed, 786 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/meson-ao-cec.txt
 create mode 100644 drivers/media/platform/meson/Makefile
 create mode 100644 drivers/media/platform/meson/ao-cec.c

-- 
1.9.1
