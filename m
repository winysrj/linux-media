Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:34655 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752042AbdDKFvz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Apr 2017 01:51:55 -0400
Received: by mail-wr0-f196.google.com with SMTP id u18so23699608wrc.1
        for <linux-media@vger.kernel.org>; Mon, 10 Apr 2017 22:51:55 -0700 (PDT)
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Sean Young <sean@mess.org>, Kevin Hilman <khilman@baylibre.com>
Cc: linux-media@vger.kernel.org, linux-amlogic@lists.infradead.org
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 0/5] media: rc: meson-ir: series with smaller improvements
Message-ID: <f65a1465-14ba-8db2-7726-454dcfbee69d@gmail.com>
Date: Tue, 11 Apr 2017 07:51:47 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This series includes smaller improvements for the meson-ir driver.
Tested on a Odroid C2.

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
