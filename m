Return-path: <linux-media-owner@vger.kernel.org>
Received: from regular1.263xmail.com ([211.150.99.140]:40084 "EHLO
        regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751400AbdLLG3S (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Dec 2017 01:29:18 -0500
From: Leo Wen <leo.wen@rock-chips.com>
To: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        davem@davemloft.net, gregkh@linuxfoundation.org,
        rdunlap@infradead.org
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org,
        eddie.cai@rock-chips.com, Leo Wen <leo.wen@rock-chips.com>
Subject: [PATCH 0/2] Rockchip: Add rk1608 driver and DT-bindings
Date: Tue, 12 Dec 2017 14:28:13 +0800
Message-Id: <1513060095-29588-1-git-send-email-leo.wen@rock-chips.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For RK1608 driver ,you can use the v4l2-ctl command to capture frames.
Add DT bindings documentation for Rockchip RK1608.
Add the information of the maintainer.

Leo Wen (2):
  [media] Add Rockchip RK1608 driver
  dt-bindings: Document the Rockchip RK1608 bindings

 Documentation/devicetree/bindings/media/rk1608.txt |  143 +++
 MAINTAINERS                                        |    7 +
 drivers/media/spi/Makefile                         |    1 +
 drivers/media/spi/rk1608.c                         | 1165 ++++++++++++++++++++
 drivers/media/spi/rk1608.h                         |  366 ++++++
 5 files changed, 1682 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/rk1608.txt
 create mode 100644 drivers/media/spi/rk1608.c
 create mode 100644 drivers/media/spi/rk1608.h

-- 
2.7.4
