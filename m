Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750912AbdG2Gck (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 29 Jul 2017 02:32:40 -0400
From: Shawn Guo <shawnguo@kernel.org>
To: Sean Young <sean@mess.org>, Rob Herring <robh+dt@kernel.org>
Cc: Baoyou Xie <xie.baoyou@sanechips.com.cn>,
        Xin Zhou <zhou.xin8@sanechips.com.cn>,
        Jun Nie <jun.nie@linaro.org>, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH 0/2] Add ZTE zx-irdec remote control driver
Date: Sat, 29 Jul 2017 14:31:40 +0800
Message-Id: <1501309902-7559-1-git-send-email-shawnguo@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Shawn Guo <shawn.guo@linaro.org>

The series adds dt-bindings and remote control driver for IRDEC block
found on ZTE ZX family SoCs.

Shawn Guo (2):
  dt-bindings: add bindings document for zx-irdec
  rc: add zx-irdec remote control driver

 .../devicetree/bindings/media/zx-irdec.txt         |  14 ++
 drivers/media/rc/Kconfig                           |  11 ++
 drivers/media/rc/Makefile                          |   1 +
 drivers/media/rc/keymaps/Makefile                  |   3 +-
 drivers/media/rc/keymaps/rc-zx-irdec.c             |  79 ++++++++
 drivers/media/rc/zx-irdec.c                        | 198 +++++++++++++++++++++
 include/media/rc-map.h                             |   1 +
 7 files changed, 306 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/media/zx-irdec.txt
 create mode 100644 drivers/media/rc/keymaps/rc-zx-irdec.c
 create mode 100644 drivers/media/rc/zx-irdec.c

-- 
1.9.1
