Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:42909 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753237AbdFMA4D (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Jun 2017 20:56:03 -0400
From: Hyungwoo Yang <hyungwoo.yang@intel.com>
To: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com
Cc: jian.xu.zheng@intel.com, tfiga@chromium.org, cedric.hsu@intel.com,
        Hyungwoo Yang <hyungwoo.yang@intel.com>
Subject: [PATCH v10 0/1] [media] i2c: add support for OV13858 sensor
Date: Mon, 12 Jun 2017 17:55:59 -0700
Message-Id: <1497315360-29216-1-git-send-email-hyungwoo.yang@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v10 : moved data dependent on module input clock frequency into fwnode.
v9 : added HBLANK and CID_GAIN(for digital gain).
v8 : enabled ov13858 with basic functionalities.

Hyungwoo Yang (1):
  [media] i2c: add support for OV13858 sensor

 drivers/media/i2c/Kconfig   |    8 +
 drivers/media/i2c/Makefile  |    1 +
 drivers/media/i2c/ov13858.c | 1920 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 1929 insertions(+)
 create mode 100644 drivers/media/i2c/ov13858.c

-- 
1.9.1
