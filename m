Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:34535 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752393AbdDLT1I (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Apr 2017 15:27:08 -0400
Received: by mail-wr0-f193.google.com with SMTP id u18so5718545wrc.1
        for <linux-media@vger.kernel.org>; Wed, 12 Apr 2017 12:27:07 -0700 (PDT)
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH v2 0/5] media: rc: meson-ir: series with smaller improvements
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Sean Young <sean@mess.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Neil Armstrong <narmstrong@baylibre.com>
Cc: linux-media@vger.kernel.org, linux-amlogic@lists.infradead.org
Message-ID: <d5c18dbb-e86a-6b1c-1410-d6cc92dce711@gmail.com>
Date: Wed, 12 Apr 2017 21:26:59 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This series includes smaller improvements for the meson-ir driver.
Tested on a Odroid C2.

v2:
- minor change to patch 2
- added Reviewed-by to patch 2, 3, 4

Heiner Kallweit (5):
  media: rc: meson-ir: remove irq from struct meson_ir
  media: rc: meson-ir: make use of the bitfield macros
  media: rc: meson-ir: switch to managed rc device allocation / registration
  media: rc: meson-ir: use readl_relaxed in the interrupt handler
  media: rc: meson-ir: change irq name to to of node name

 drivers/media/rc/meson-ir.c | 64 ++++++++++++++++++---------------------------
 1 file changed, 26 insertions(+), 38 deletions(-)

-- 
2.12.2
