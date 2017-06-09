Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:49219 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751527AbdFIIoN (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Jun 2017 04:44:13 -0400
From: Hyungwoo Yang <hyungwoo.yang@intel.com>
To: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com
Cc: jian.xu.zheng@intel.com, tfiga@chromium.org, cedric.hsu@intel.com,
        Hyungwoo Yang <hyungwoo.yang@intel.com>
Subject: [PATCH v9 0/1] [media] i2c: add support for OV13858 sensor
Date: Fri,  9 Jun 2017 01:43:39 -0700
Message-Id: <1496997820-978-1-git-send-email-hyungwoo.yang@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I added HBLANK v4l2 control and marked it as read-only since VBLANK is enough
to control FPS.

Sensor also support digital gain so I added digital gain support by
using V4L2_CID_GAIN control.

Hyungwoo Yang (1):
  [media] i2c: add support for OV13858 sensor

 drivers/media/i2c/Kconfig   |    8 +
 drivers/media/i2c/Makefile  |    1 +
 drivers/media/i2c/ov13858.c | 1811 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 1820 insertions(+)
 create mode 100644 drivers/media/i2c/ov13858.c

-- 
1.9.1
