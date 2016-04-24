Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35614 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176AbcDXVKO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Apr 2016 17:10:14 -0400
Received: by mail-wm0-f66.google.com with SMTP id e201so17586385wme.2
        for <linux-media@vger.kernel.org>; Sun, 24 Apr 2016 14:10:13 -0700 (PDT)
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
To: sakari.ailus@iki.fi
Cc: sre@kernel.org, pali.rohar@gmail.com, pavel@ucw.cz,
	linux-media@vger.kernel.org,
	Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Subject: [RFC PATCH 00/24] Make Nokia N900 cameras working
Date: Mon, 25 Apr 2016 00:08:00 +0300
Message-Id: <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
In-Reply-To: <20160420081427.GZ32125@valkosipuli.retiisi.org.uk>
References: <20160420081427.GZ32125@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Those patch series make cameras on Nokia N900 partially working.
Some more patches are needed, but I've already sent them for
upstreaming so they are not part of the series:

https://lkml.org/lkml/2016/4/16/14
https://lkml.org/lkml/2016/4/16/33

As omap3isp driver supports only one endpoint on ccp2 interface,
but cameras on N900 require different strobe settings, so far
it is not possible to have both cameras correctly working with
the same board DTS. DTS patch in the series has the correct
settings for the front camera. This is a problem still to be
solved.

The needed pipeline could be made with:

media-ctl -r
media-ctl -l '"vs6555 binner 2-0010":1 -> "video-bus-switch":2 [1]'
media-ctl -l '"video-bus-switch":0 -> "OMAP3 ISP CCP2":0 [1]'
media-ctl -l '"OMAP3 ISP CCP2":1 -> "OMAP3 ISP CCDC":0 [1]'
media-ctl -l '"OMAP3 ISP CCDC":2 -> "OMAP3 ISP preview":0 [1]'
media-ctl -l '"OMAP3 ISP preview":1 -> "OMAP3 ISP resizer":0 [1]'
media-ctl -l '"OMAP3 ISP resizer":1 -> "OMAP3 ISP resizer output":0 [1]'
media-ctl -V '"vs6555 pixel array 2-0010":0 [SGRBG10/648x488 (0,0)/648x488 (0,0)/648x488]'
media-ctl -V '"vs6555 binner 2-0010":1 [SGRBG10/648x488 (0,0)/648x488 (0,0)/648x488]'
media-ctl -V '"OMAP3 ISP CCP2":0 [SGRBG10 648x488]'
media-ctl -V '"OMAP3 ISP CCP2":1 [SGRBG10 648x488]'
media-ctl -V '"OMAP3 ISP CCDC":2 [SGRBG10 648x488]'
media-ctl -V '"OMAP3 ISP preview":1 [UYVY 648x488]'
media-ctl -V '"OMAP3 ISP resizer":1 [UYVY 656x488]'

and tested with:

mplayer -tv driver=v4l2:width=656:height=488:outfmt=uyvy:device=/dev/video6 -vo xv -vf screenshot tv://


Ivaylo Dimitrov (8):
  smiaregs: Generic i2c register writing
  et8ek8: Toshiba 5MP sensor driver
  v4l: of: Support CSI-1 and CCP2 busses
  media: video-bus-switch: new driver
  ARM: dts: omap3-n900: enable cameras
  [media] omap3isp: Correctly set IO_OUT_SEL and VP_CLK_POL for CCP2
    mode
  [media] omap3isp: Make sure CSI1 interface is enabled in CPP2 mode
  ARM: dts: omap3-n900: enable cameras - remove invalid entry

Sakari Ailus (10):
  smiapp-pll: Take existing divisor into account in minimum divisor
    check
  smiapp: Add smiapp_has_quirk() to tell whether a quirk is implemented
  smiapp: Add quirk control support
  v4l: of: Call CSI2 bus csi2, not csi
  v4l: of: Obtain data bus type from bus-type property
  v4l: Add CSI1 and CCP2 bus type to enum v4l2_mbus_type
  v4l: of: Separate lane parsing from CSI-2 bus parameter parsing
  dt: bindings: v4l: Add bus-type video interface property
  dt: bindings: Add CSI1/CCP2 related properties to video-interfaces.txt
  omap3isp: dt: Add support for CSI1/CCP2 busses

Sebastian Reichel (5):
  media: et8ek8: add device tree binding document
  media: add subdev type for bus switch
  smiapp: add CCP2 support
  v4l2-async: per notifier locking
  v4l2_device_register_subdev_nodes: allow calling multiple times

Tuukka.O Toivonen (1):
  V4L fixes

 .../bindings/media/i2c/toshiba,et8ek8.txt          |   56 +
 .../devicetree/bindings/media/video-interfaces.txt |   11 +-
 arch/arm/boot/dts/omap3-n900.dts                   |  139 ++
 drivers/media/i2c/Kconfig                          |    1 +
 drivers/media/i2c/Makefile                         |    1 +
 drivers/media/i2c/smia/Kconfig                     |   17 +
 drivers/media/i2c/smia/Makefile                    |    2 +
 drivers/media/i2c/smia/et8ek8.c                    | 1788 ++++++++++++++++++++
 drivers/media/i2c/smia/smiaregs.c                  |  724 ++++++++
 drivers/media/i2c/smiapp-pll.c                     |    3 +-
 drivers/media/i2c/smiapp/smiapp-core.c             |   18 +-
 drivers/media/i2c/smiapp/smiapp-quirk.h            |   10 +-
 drivers/media/platform/Kconfig                     |   10 +
 drivers/media/platform/Makefile                    |    2 +
 drivers/media/platform/omap3isp/isp.c              |  112 +-
 drivers/media/platform/omap3isp/ispccp2.c          |   34 +-
 drivers/media/platform/omap3isp/ispreg.h           |    4 +
 drivers/media/platform/omap3isp/omap3isp.h         |    1 +
 drivers/media/platform/video-bus-switch.c          |  366 ++++
 drivers/media/v4l2-core/v4l2-async.c               |   50 +-
 drivers/media/v4l2-core/v4l2-device.c              |    3 +
 drivers/media/v4l2-core/v4l2-of.c                  |  137 +-
 include/media/smiaregs.h                           |  143 ++
 include/media/v4l2-async.h                         |    2 +
 include/media/v4l2-mediabus.h                      |    4 +
 include/media/v4l2-of.h                            |   17 +
 include/uapi/linux/media.h                         |    1 +
 include/uapi/linux/v4l2-controls.h                 |   17 +
 28 files changed, 3579 insertions(+), 94 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/toshiba,et8ek8.txt
 create mode 100644 drivers/media/i2c/smia/Kconfig
 create mode 100644 drivers/media/i2c/smia/Makefile
 create mode 100644 drivers/media/i2c/smia/et8ek8.c
 create mode 100644 drivers/media/i2c/smia/smiaregs.c
 create mode 100644 drivers/media/platform/video-bus-switch.c
 create mode 100644 include/media/smiaregs.h

-- 
1.9.1

