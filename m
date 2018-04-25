Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:37696 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750841AbeDYCEQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Apr 2018 22:04:16 -0400
From: Andy Yeh <andy.yeh@intel.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@linux.intel.com, andy.yeh@intel.com,
        devicetree@vger.kernel.org, tfiga@chromium.org, jacopo@jmondi.org
Subject: [RESEND PATCH v8 0/2] DW9807 DT binding and driver patches
Date: Wed, 25 Apr 2018 10:12:06 +0800
Message-Id: <1524622328-30493-1-git-send-email-andy.yeh@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari and Tomasz,

The two patches are the DT binding and driver for DW9807 VCM controller.

Alan Chiang (2):
  media: dw9807: Add dw9807 vcm driver
  media: dt-bindings: Add bindings for Dongwoon DW9807 voice coil

 .../bindings/media/i2c/dongwoon,dw9807.txt         |   9 +
 MAINTAINERS                                        |   7 +
 drivers/media/i2c/Kconfig                          |  10 +
 drivers/media/i2c/Makefile                         |   1 +
 drivers/media/i2c/dw9807.c                         | 320 +++++++++++++++++++++
 5 files changed, 347 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/dongwoon,dw9807.txt
 create mode 100644 drivers/media/i2c/dw9807.c

-- 
2.7.4
