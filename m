Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:44830 "EHLO
        homiemail-a58.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751139AbeECVUW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 3 May 2018 17:20:22 -0400
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH v2 0/9] cx231xx: House cleaning
Date: Thu,  3 May 2018 16:20:06 -0500
Message-Id: <1525382415-4049-1-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Included in this patch set is:
- Bugfix for a device not working
- Some clean up and value corrections
- Conversion to new dvb i2c helpers
- Update of device from old dvb attach to i2c device
- Dependency fixes
- Style fixes

Changes since v1:
- Style fixes in i2c helper patch
- Some comment cleanup
- Hardware validation of analog tuning

Brad Love (9):
  cx231xx: Fix several incorrect demod addresses
  cx231xx: Use board profile values for addresses
  cx231xx: Style fix for struct zero init
  cx231xx: [bug] Ignore an i2c mux adapter
  cx231xx: Switch to using new dvb i2c helpers
  cx231xx: Update 955Q from dvb attach to i2c device
  cx231xx: Remove unnecessary parameter clear
  cx231xx: Remove RC_CORE dependency
  cx231xx: Add I2C_MUX dependency

 drivers/media/usb/cx231xx/Kconfig         |   1 -
 drivers/media/usb/cx231xx/cx231xx-cards.c |   6 +-
 drivers/media/usb/cx231xx/cx231xx-dvb.c   | 365 ++++++++----------------------
 3 files changed, 94 insertions(+), 278 deletions(-)

-- 
2.7.4
