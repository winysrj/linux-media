Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:49175 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989AbaHUJZC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Aug 2014 05:25:02 -0400
Received: by mail-pa0-f41.google.com with SMTP id rd3so13908395pab.0
        for <linux-media@vger.kernel.org>; Thu, 21 Aug 2014 02:25:01 -0700 (PDT)
From: Zhangfei Gao <zhangfei.gao@linaro.org>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	=?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>,
	arnd@arndb.de, haifeng.yan@linaro.org, jchxue@gmail.com
Cc: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
	linux-media@vger.kernel.org, Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: [PATCH v2 0/3] Introduce hix5hd2 IR transmitter driver
Date: Thu, 21 Aug 2014 17:24:42 +0800
Message-Id: <1408613086-12538-1-git-send-email-zhangfei.gao@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v2:
Rebase to 3.17-rc1, solve two issues:
a) rc_set_allowed_protocols is deprecated
b) rc-ir-raw.c add empty change_protocol, which block using all protocol
For example, when rdev->map_name = RC_MAP_LIRC, ir-nec-decoder can not be used.

Guoxiong Yan (2):
  rc: Add DT bindings for hix5hd2
  rc: Introduce hix5hd2 IR transmitter driver

Zhangfei Gao (1):
  [media] rc: remove change_protocol in rc-ir-raw.c

 .../devicetree/bindings/media/hix5hd2-ir.txt       |   21 ++
 drivers/media/rc/Kconfig                           |   11 +
 drivers/media/rc/Makefile                          |    1 +
 drivers/media/rc/ir-hix5hd2.c                      |  347 ++++++++++++++++++++
 drivers/media/rc/rc-ir-raw.c                       |    7 -
 5 files changed, 380 insertions(+), 7 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/hix5hd2-ir.txt
 create mode 100644 drivers/media/rc/ir-hix5hd2.c

-- 
1.7.9.5

