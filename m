Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:57229 "EHLO
        lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752546AbdDDMqa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 4 Apr 2017 08:46:30 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.12] atmel-isi/ov7670/ov2640: convert to standalone
 drivers
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Songjun Wu <Songjun.Wu@microchip.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Message-ID: <e0f7f4df-baf0-f1f8-ef16-f3ea13329090@xs4all.nl>
Date: Tue, 4 Apr 2017 14:46:25 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Converts atmel-isi to a regular v4l2 driver instead of relying on soc-camera.

The ov2640 and ov7670 drivers are also converted to normal i2c drivers.

Tested with my sama5d3-Xplained board, the ov2640 sensor and two ov7670
sensors: one with and one without reset/pwdn pins. Also tested with my
em28xx-based webcam.

See here for the patch series' cover letter:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg110532.html

The only change since this patch series was posted is that last patch updating
the atmel-isi path in MAINTAINERS.

After this patch series the only platform driver still using soc-camera is the
sh_mobile_ceu_camera driver.

The (tentative) plan is to merge soc-camera into that sh driver, ensuring it
is no longer available as a stand-alone framework.

Regarding the other soc-camera i2c drivers: the following drivers are used
by sh board files: ov772x, tw9910, mt9t112, rj54n1cb0c.

All others are never used by a soc-camera in-tree device.

I am considering to make those four drivers depend on the sh_mobile_ceu_camera
driver. The other soc_camera i2c drivers can be moved to staging/media and
marked as BROKEN.

Are there any i2c soc_camera drivers that are also used by non-soc-camera
drivers? I'm not aware of that.

I have some of the i2c soc_camera sensors, so when time permits I'll try to
convert them over as standalone sensor drivers.

Regards,

	Hans

The following changes since commit 700ea5e0e0dd70420a04e703ff264cc133834cba:

  Merge tag 'v4.11-rc1' into patchwork (2017-03-06 06:49:34 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git sama5d3

for you to fetch changes up to 11498c0d43013f51e1041a6dcf8934d62df6f41b:

  MAINTAINERS: update atmel-isi.c path (2017-04-03 16:50:53 +0200)

----------------------------------------------------------------
Hans Verkuil (15):
      ov7670: document device tree bindings
      ov7670: call v4l2_async_register_subdev
      ov7670: fix g/s_parm
      ov7670: get xclk
      ov7670: add devicetree support
      atmel-isi: update device tree bindings documentation
      atmel-isi: remove dependency of the soc-camera framework
      atmel-isi: move out of soc_camera to atmel
      ov2640: fix colorspace handling
      ov2640: update bindings
      ov2640: convert from soc-camera to a standard subdev sensor driver.
      ov2640: use standard clk and enable it.
      ov2640: add MC support
      em28xx: drop last soc_camera link
      MAINTAINERS: update atmel-isi.c path

 Documentation/devicetree/bindings/media/atmel-isi.txt    |   91 ++++---
 Documentation/devicetree/bindings/media/i2c/ov2640.txt   |   23 +-
 Documentation/devicetree/bindings/media/i2c/ov7670.txt   |   43 +++
 MAINTAINERS                                              |    3 +-
 drivers/media/i2c/Kconfig                                |   11 +
 drivers/media/i2c/Makefile                               |    1 +
 drivers/media/i2c/{soc_camera => }/ov2640.c              |  153 ++++-------
 drivers/media/i2c/ov7670.c                               |   75 +++++-
 drivers/media/i2c/soc_camera/Kconfig                     |    6 -
 drivers/media/i2c/soc_camera/Makefile                    |    1 -
 drivers/media/platform/Makefile                          |    1 +
 drivers/media/platform/atmel/Kconfig                     |   11 +-
 drivers/media/platform/atmel/Makefile                    |    1 +
 drivers/media/platform/atmel/atmel-isi.c                 | 1368
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/media/platform/{soc_camera => atmel}/atmel-isi.h |    0
 drivers/media/platform/soc_camera/Kconfig                |   11 -
 drivers/media/platform/soc_camera/Makefile               |    1 -
 drivers/media/platform/soc_camera/atmel-isi.c            | 1167
--------------------------------------------------------------------------------
 drivers/media/usb/em28xx/em28xx-camera.c                 |    9 -
 19 files changed, 1615 insertions(+), 1361 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ov7670.txt
 rename drivers/media/i2c/{soc_camera => }/ov2640.c (92%)
 create mode 100644 drivers/media/platform/atmel/atmel-isi.c
 rename drivers/media/platform/{soc_camera => atmel}/atmel-isi.h (100%)
 delete mode 100644 drivers/media/platform/soc_camera/atmel-isi.c
