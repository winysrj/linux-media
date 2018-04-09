Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:39588 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751916AbeDIMPl (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 9 Apr 2018 08:15:41 -0400
Date: Mon, 9 Apr 2018 13:15:29 +0100
From: Russell King - ARM Linux <linux@armlinux.org.uk>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-media@vger.kernel.org
Subject: [PATCH v3 0/7] TDA998x CEC support
Message-ID: <20180409121529.GA31403@n2100.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This patch series adds CEC support to the DRM TDA998x driver.  The
TDA998x family of devices integrate a TDA9950 CEC at a separate I2C
address from the HDMI encoder.

Implementation of the CEC part is separate to allow independent CEC
implementations, or independent HDMI implementations (since the
TDA9950 may be a separate device.)

 .../devicetree/bindings/display/bridge/tda998x.txt |   3 +
 drivers/gpu/drm/i2c/Kconfig                        |   6 +
 drivers/gpu/drm/i2c/Makefile                       |   1 +
 drivers/gpu/drm/i2c/tda9950.c                      | 509 +++++++++++++++++++++
 drivers/gpu/drm/i2c/tda998x_drv.c                  | 242 ++++++++--
 include/linux/platform_data/tda9950.h              |  16 +
 6 files changed, 750 insertions(+), 27 deletions(-)
 create mode 100644 drivers/gpu/drm/i2c/tda9950.c
 create mode 100644 include/linux/platform_data/tda9950.h

v3: addressed most of Hans comments in v2
v2: updated DT property.
 
-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 8.8Mbps down 630kbps up
According to speedtest.net: 8.21Mbps down 510kbps up
