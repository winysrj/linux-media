Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:39281 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbaHMJEk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Aug 2014 05:04:40 -0400
Received: by mail-pa0-f42.google.com with SMTP id lf10so14705760pab.29
        for <linux-media@vger.kernel.org>; Wed, 13 Aug 2014 02:04:40 -0700 (PDT)
From: Zhangfei Gao <zhangfei.gao@linaro.org>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	haifeng.yan@linaro.org, jchxue@gmail.com
Cc: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
	linux-media@vger.kernel.org, Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: [PATCH 0/2] Introduce hix5hd2 IR transmitter driver
Date: Wed, 13 Aug 2014 17:03:24 +0800
Message-Id: <1407920606-18788-1-git-send-email-zhangfei.gao@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guoxiong Yan (2):
  [media] rc: Add DT bindings for hix5hd2
  [media] rc: Introduce hix5hd2 IR transmitter driver

 .../devicetree/bindings/media/hix5hd2-ir.txt       |   19 ++
 drivers/media/rc/Kconfig                           |   11 +
 drivers/media/rc/Makefile                          |    1 +
 drivers/media/rc/ir-hix5hd2.c                      |  347 ++++++++++++++++++++
 4 files changed, 378 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/hix5hd2-ir.txt
 create mode 100644 drivers/media/rc/ir-hix5hd2.c

-- 
1.7.9.5

