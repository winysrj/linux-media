Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33948 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751233AbeEQKnH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 May 2018 06:43:07 -0400
Received: from lanttu.localdomain (unknown [IPv6:2001:1bc8:1a6:d3d5::e1:1001])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id E4D1E634C7E
        for <linux-media@vger.kernel.org>; Thu, 17 May 2018 13:43:04 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/3] dw9807 and imx258 drivers
Date: Thu, 17 May 2018 13:43:01 +0300
Message-Id: <20180517104304.10200-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Re-submitting with correct SoB lines. The removal of the unused retry
variable has been merged to the dw9807 driver patch.

Alan Chiang (2):
  media: dt-bindings: Add bindings for Dongwoon DW9807 voice coil
  media: dw9807: Add dw9807 vcm driver

Jason Chen (1):
  media: imx258: Add imx258 camera sensor driver

 .../bindings/media/i2c/dongwoon,dw9807.txt         |    9 +
 MAINTAINERS                                        |   14 +
 drivers/media/i2c/Kconfig                          |   21 +
 drivers/media/i2c/Makefile                         |    2 +
 drivers/media/i2c/dw9807.c                         |  329 +++++
 drivers/media/i2c/imx258.c                         | 1320 ++++++++++++++++++++
 6 files changed, 1695 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/dongwoon,dw9807.txt
 create mode 100644 drivers/media/i2c/dw9807.c
 create mode 100644 drivers/media/i2c/imx258.c

-- 
2.11.0
