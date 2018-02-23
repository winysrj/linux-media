Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga18.intel.com ([134.134.136.126]:11780 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751351AbeBWQJD (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Feb 2018 11:09:03 -0500
From: Andy Yeh <andy.yeh@intel.com>
To: linux-media@vger.kernel.org
Cc: andy.yeh@intel.com, sakari.ailus@linux.intel.com, tfiga@google.com,
        devicetree@vger.kernel.org
Subject: [v5 0/2] DW9807 DT binding and driver patches
Date: Sat, 24 Feb 2018 00:13:40 +0800
Message-Id: <1519402422-9595-1-git-send-email-andy.yeh@intel.com>
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
