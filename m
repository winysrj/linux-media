Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37207 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727123AbeKHWZg (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Nov 2018 17:25:36 -0500
Received: by mail-wr1-f68.google.com with SMTP id o15-v6so17488362wrv.4
        for <linux-media@vger.kernel.org>; Thu, 08 Nov 2018 04:50:14 -0800 (PST)
From: Neil Armstrong <narmstrong@baylibre.com>
To: Yasunari.Takiguchi@sony.com, devicetree@vger.kernel.org
Cc: Neil Armstrong <narmstrong@baylibre.com>, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] media: sony-cxd2880: add optional vcc regulator to bindings
Date: Thu,  8 Nov 2018 13:50:10 +0100
Message-Id: <1541681410-8187-3-git-send-email-narmstrong@baylibre.com>
In-Reply-To: <1541681410-8187-1-git-send-email-narmstrong@baylibre.com>
References: <1541681410-8187-1-git-send-email-narmstrong@baylibre.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patchset adds an optional VCC regulator to the bindings of the Sony
CXD2880 DVB-T2/T tuner + demodulator adapter.

Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
---
 Documentation/devicetree/bindings/media/spi/sony-cxd2880.txt | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/media/spi/sony-cxd2880.txt b/Documentation/devicetree/bindings/media/spi/sony-cxd2880.txt
index fc5aa26..98a72c0 100644
--- a/Documentation/devicetree/bindings/media/spi/sony-cxd2880.txt
+++ b/Documentation/devicetree/bindings/media/spi/sony-cxd2880.txt
@@ -5,6 +5,10 @@ Required properties:
 - reg: SPI chip select number for the device.
 - spi-max-frequency: Maximum bus speed, should be set to <55000000> (55MHz).
 
+Optional properties:
+- vcc-supply: Optional phandle to the vcc regulator to power the adapter,
+  as described in the file ../regulator/regulator.txt
+
 Example:
 
 cxd2880@0 {
-- 
2.7.4
