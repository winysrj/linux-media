Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34250 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750784AbdFOIhD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Jun 2017 04:37:03 -0400
Received: from valkosipuli.retiisi.org.uk (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id BFDA3600A3
        for <linux-media@vger.kernel.org>; Thu, 15 Jun 2017 11:36:59 +0300 (EEST)
Date: Thu, 15 Jun 2017 11:36:29 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.13] Add ov13858 and dw9714 drivers, digital gain
 control
Message-ID: <20170615083629.GZ12407@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here are new drivers for the ov13858 sensor and the dw9714 lens voice coil
driver, as well as the new V4L2_CID_DIGITAL_GAIN control. A small cleanup
for the as3645a driver is included as well.

Compared to the patches reviewed on the list, I've added MAINTAINERS entries
to the drivers:


diff --git a/MAINTAINERS b/MAINTAINERS
index 053c3bd..7b5c99d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4692,6 +4692,13 @@ S:	Maintained
 F:	drivers/media/usb/dvb-usb-v2/dvb_usb*
 F:	drivers/media/usb/dvb-usb-v2/usb_urb.c
 
+DONGWOON DW9714 LENS VOICE COIL DRIVER
+M:	Sakari Ailus <sakari.ailus@linux.intel.com>
+L:	linux-media@vger.kernel.org
+T:	git git://linuxtv.org/media_tree.git
+S:	Maintained
+F:	drivers/media/i2c/dw9714.c
+
 DYNAMIC DEBUG
 M:	Jason Baron <jbaron@akamai.com>
 S:	Maintained
@@ -9434,6 +9441,13 @@ S:	Maintained
 F:	drivers/media/i2c/ov7670.c
 F:	Documentation/devicetree/bindings/media/i2c/ov7670.txt
 
+OMNIVISION OV13858 SENSOR DRIVER
+M:	Sakari Ailus <sakari.ailus@linux.intel.com>
+L:	linux-media@vger.kernel.org
+T:	git git://linuxtv.org/media_tree.git
+S:	Maintained
+F:	drivers/media/i2c/ov13858.c
+
 ONENAND FLASH DRIVER
 M:	Kyungmin Park <kyungmin.park@samsung.com>
 L:	linux-mtd@lists.infradead.org

Please pull.


The following changes since commit acec3630155763c170c7ae6508cf973355464508:

  [media] s3c-camif: fix arguments position in a function call (2017-06-13 14:21:24 -0300)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git for-4.13

for you to fetch changes up to d092459a1bd864a24589cee6ed8de8bb9081797a:

  as3645a: Join string literals back (2017-06-15 11:16:48 +0300)

----------------------------------------------------------------
Andy Shevchenko (1):
      as3645a: Join string literals back

Hyungwoo Yang (1):
      ov13858: add support for OV13858 sensor

Rajmohan Mani (1):
      dw9714: Initial driver for dw9714 VCM

Sakari Ailus (2):
      v4l: ctrls: Add a control for digital gain
      v4l: controls: Improve documentation for V4L2_CID_GAIN

 Documentation/media/uapi/v4l/control.rst           |    6 +
 Documentation/media/uapi/v4l/extended-controls.rst |    7 +
 MAINTAINERS                                        |   14 +
 drivers/media/i2c/Kconfig                          |   18 +
 drivers/media/i2c/Makefile                         |    2 +
 drivers/media/i2c/as3645a.c                        |   12 +-
 drivers/media/i2c/dw9714.c                         |  291 ++++
 drivers/media/i2c/ov13858.c                        | 1816 ++++++++++++++++++++
 drivers/media/v4l2-core/v4l2-ctrls.c               |    1 +
 include/uapi/linux/v4l2-controls.h                 |    2 +-
 10 files changed, 2162 insertions(+), 7 deletions(-)
 create mode 100644 drivers/media/i2c/dw9714.c
 create mode 100644 drivers/media/i2c/ov13858.c

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
