Return-path: <linux-media-owner@vger.kernel.org>
Received: from regular1.263xmail.com ([211.150.99.137]:33044 "EHLO
        regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965377AbeCHGi7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Mar 2018 01:38:59 -0500
From: Wen Nuan <leo.wen@rock-chips.com>
To: mchehab@kernel.org, davem@davemloft.net,
        gregkh@linuxfoundation.org, linus.walleij@linaro.org,
        rdunlap@infradead.org, jacob2.chen@rock-chips.com
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        eddie.cai@rock-chips.com, Leo Wen <leo.wen@rock-chips.com>
Subject: [PATCH v4 0/2] Rockchip: Add RK1608 driver and DT-bindings
Date: Thu,  8 Mar 2018 14:38:40 +0800
Message-Id: <1520491122-5629-1-git-send-email-leo.wen@rock-chips.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Leo Wen <leo.wen@rock-chips.com>

You can use the v4l2-ctl command to capture frames for RK1608.
Add DT-bindings documentation for Rockchip RK1608.
Add the information of the MAINTAINERS.

Leo Wen (2):
  [media] Add Rockchip RK1608 driver
  dt-bindings: Document the Rockchip RK1608 bindings

 Documentation/devicetree/bindings/media/rk1608.txt |   95 ++
 MAINTAINERS                                        |    7 +
 drivers/media/spi/Makefile                         |    1 +
 drivers/media/spi/rk1608.c                         | 1374 ++++++++++++++++++++
 drivers/media/spi/rk1608.h                         |  442 +++++++
 5 files changed, 1919 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/rk1608.txt
 create mode 100644 drivers/media/spi/rk1608.c
 create mode 100644 drivers/media/spi/rk1608.h

-- 
2.7.4
