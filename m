Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750988AbdG3NYi (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 30 Jul 2017 09:24:38 -0400
From: Shawn Guo <shawnguo@kernel.org>
To: Sean Young <sean@mess.org>, Rob Herring <robh+dt@kernel.org>
Cc: Baoyou Xie <xie.baoyou@sanechips.com.cn>,
        Xin Zhou <zhou.xin8@sanechips.com.cn>,
        Jun Nie <jun.nie@linaro.org>, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH v2 0/3] Add ZTE zx-irdec remote control driver
Date: Sun, 30 Jul 2017 21:23:10 +0800
Message-Id: <1501420993-21977-1-git-send-email-shawnguo@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Shawn Guo <shawn.guo@linaro.org>

The series adds dt-bindings and remote control driver for IRDEC block
found on ZTE ZX family SoCs.

Changes for v2:
 - Add one patch to move generic NEC scancode composing and protocol
   type detection code from ir_nec_decode() into an inline shared
   function, which can be reused by zx-irdec driver.

Shawn Guo (3):
  rc: ir-nec-decoder: move scancode composing code into a shared
    function
  dt-bindings: add bindings document for zx-irdec
  rc: add zx-irdec remote control driver

 .../devicetree/bindings/media/zx-irdec.txt         |  14 ++
 drivers/media/rc/Kconfig                           |  11 ++
 drivers/media/rc/Makefile                          |   1 +
 drivers/media/rc/ir-nec-decoder.c                  |  32 +---
 drivers/media/rc/keymaps/Makefile                  |   3 +-
 drivers/media/rc/keymaps/rc-zx-irdec.c             |  79 +++++++++
 drivers/media/rc/zx-irdec.c                        | 183 +++++++++++++++++++++
 include/media/rc-core.h                            |  31 ++++
 include/media/rc-map.h                             |   1 +
 9 files changed, 325 insertions(+), 30 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/zx-irdec.txt
 create mode 100644 drivers/media/rc/keymaps/rc-zx-irdec.c
 create mode 100644 drivers/media/rc/zx-irdec.c

-- 
1.9.1
