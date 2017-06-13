Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:49989 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751802AbdFMWBP (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Jun 2017 18:01:15 -0400
From: Hyungwoo Yang <hyungwoo.yang@intel.com>
To: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com
Cc: jian.xu.zheng@intel.com, tfiga@chromium.org, cedric.hsu@intel.com,
        Hyungwoo Yang <hyungwoo.yang@intel.com>
Subject: [PATCH v11 0/1] [media] i2c: add support for OV13858 sensor
Date: Tue, 13 Jun 2017 15:01:07 -0700
Message-Id: <1497391268-24558-1-git-send-email-hyungwoo.yang@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v11 : removed v10 and added checking if input clock frequency is 19.2Mhz
v10 : moved data dependent on module input clock frequency into fwnode.
v9 : added HBLANK and CID_GAIN(for digital gain).
v8 : enabled ov13858 with basic functionalities.

Hyungwoo Yang (1):
  [media] i2c: add support for OV13858 sensor

 drivers/media/i2c/Kconfig   |    8 +
 drivers/media/i2c/Makefile  |    1 +
 drivers/media/i2c/ov13858.c | 1816 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 1825 insertions(+)
 create mode 100644 drivers/media/i2c/ov13858.c

-- 
1.9.1
