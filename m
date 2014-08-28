Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:44123 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbaH1PQb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Aug 2014 11:16:31 -0400
Received: by mail-pa0-f50.google.com with SMTP id kq14so2909106pab.23
        for <linux-media@vger.kernel.org>; Thu, 28 Aug 2014 08:16:28 -0700 (PDT)
From: Zhangfei Gao <zhangfei.gao@linaro.org>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>, sean@mess.org,
	arnd@arndb.de, haifeng.yan@linaro.org, jchxue@gmail.com
Cc: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
	linux-media@vger.kernel.org, Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: [PATCH v3 0/3] Introduce hix5hd2 IR transmitter driver
Date: Thu, 28 Aug 2014 23:16:14 +0800
Message-Id: <1409238977-19444-1-git-send-email-zhangfei.gao@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v3:
Got info from Mauro, 3.17 disable all protocol by default, specific protocol
can be selected via ir-keytable and /sys/class/rc/rc0/protocols

Got suggestion from Sean, add rdev specific info, like timeout, resoluton.
Add optional property "linux,rc-map-name", if kernel keymap is used
otherwise user space keymap will be used.

v2:
Rebase to 3.17-rc1, solve two issues:
a) rc_set_allowed_protocols is deprecated
b) rc-ir-raw.c add empty change_protocol, which block using all protocol
For example, when rdev->map_name = RC_MAP_LIRC, ir-nec-decoder can not be used.

Guoxiong Yan (2):
  rc: Add DT bindings for hix5hd2
  rc: Introduce hix5hd2 IR transmitter driver

Zhangfei Gao (1):
  ARM: dts: hix5hd2: add ir node

 .../devicetree/bindings/media/hix5hd2-ir.txt       |   25 ++
 arch/arm/boot/dts/hisi-x5hd2.dtsi                  |   10 +-
 drivers/media/rc/Kconfig                           |   11 +
 drivers/media/rc/Makefile                          |    1 +
 drivers/media/rc/ir-hix5hd2.c                      |  351 ++++++++++++++++++++
 5 files changed, 397 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/media/hix5hd2-ir.txt
 create mode 100644 drivers/media/rc/ir-hix5hd2.c

-- 
1.7.9.5

