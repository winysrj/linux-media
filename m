Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm1-f41.google.com ([209.85.128.41]:55658 "EHLO
        mail-wm1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726684AbeKHWZe (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Nov 2018 17:25:34 -0500
Received: by mail-wm1-f41.google.com with SMTP id s10-v6so1136511wmc.5
        for <linux-media@vger.kernel.org>; Thu, 08 Nov 2018 04:50:13 -0800 (PST)
From: Neil Armstrong <narmstrong@baylibre.com>
To: Yasunari.Takiguchi@sony.com
Cc: Neil Armstrong <narmstrong@baylibre.com>, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] sony-cxd2880: add optional vcc regulator
Date: Thu,  8 Nov 2018 13:50:08 +0100
Message-Id: <1541681410-8187-1-git-send-email-narmstrong@baylibre.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patchset adds an optional VCC regulator to the bindings and driver to
make sure power is enabled to the module before starting attaching to
the device.

Neil Armstrong (2):
  media: cxd2880-spi: Add optional vcc regulator
  media: sony-cxd2880: add optional vcc regulator to bindings

 .../devicetree/bindings/media/spi/sony-cxd2880.txt       |  4 ++++
 drivers/media/spi/cxd2880-spi.c                          | 16 ++++++++++++++++
 2 files changed, 20 insertions(+)

-- 
2.7.4
