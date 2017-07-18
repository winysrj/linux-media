Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:59930 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751584AbdGRTEE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Jul 2017 15:04:04 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: linux-leds@vger.kernel.org, laurent.pinchart@ideasonboard.com,
        niklas.soderlund@ragnatech.se, hverkuil@xs4all.nl
Subject: [RFC 00/19] Async sub-notifiers and how to use them
Date: Tue, 18 Jul 2017 22:03:42 +0300
Message-Id: <20170718190401.14797-1-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi folks,

This RFC patchset achieves a number of things which I've put to the same
patchset for they need to be show together to demonstrate the use cases.

I don't really intend this to compete with Niklas's patchset but much of
the problem area addressed by the two is the same.

Comments would be welcome.

- Add AS3645A LED flash class driver.

- Add async notifiers (by Niklas).

- V4L2 sub-device node registration is moved to take place at the same time
  with the registration of the sub-device itself. With this change,
  sub-device node registration behaviour is aligned with video node
  registration.

- The former is made possible by moving the bound() callback after
  sub-device registration.

- As all the device node registration and link creation is done as the
  respective devices are probed, there is no longer dependency to the
  notifier complete callback which as itself is seen problematic. The
  complete callback still exists but there's no need to use it, pending
  changes in individual drivers.

  See:
  <URL:http://www.spinics.net/lists/linux-media/msg118323.html>

  As a result, if a part of the media device fails to initialise because it
  is e.g. physically broken, it will be possible to use what works.

- Finally, the use of the async sub-notifier is hidden in the framework and
  all a driver (such as smiapp) needs to do is to call
  v4l2_subdev_fwnode_reference_parse_sensor_common() in its probe()
  function to find out the associated devices (lens and flash). This
  approach makes it possible to later on to rework the sub-notifier
  implementation without touching driver code. Endpoints can be parsed
  similarly by simply calling v4l2_subdev_fwnode_endpoints_parse() for
  driver's probe function.

The patches depend on this branch currently:

<URL:https://git.linuxtv.org/sailus/media_tree.git/log/?h=as3645a-leds-base>

It's essentially the V4L2 flash class patches I've posted earlier today and
a stash of fwnode property API improvements.


Niklas Söderlund (1):
  v4l: async: add subnotifier registration for subdevices

Sakari Ailus (18):
  device property: Introduce fwnode_property_get_reference_args
  dt: bindings: Add a binding for flash devices associated to a sensor
  dt: bindings: Add lens-focus binding for image sensors
  leds: as3645a: Add LED flash class driver
  leds: as3645a: Separate flash and indicator LED sub-devices
  v4l: fwnode: Support generic parsing of graph endpoints in V4L2
  arm: dts: omap3: N9/N950: Add AS3645A camera flash
  v4l2-fwnode: Add conveniences function for parsing generic references
  v4l2-fwnode: Add convenience function for parsing common external refs
  v4l2-async: Register sub-devices before calling bound callback
  v4l2-subdev: Support registering V4L2 sub-device nodes one by one
  v4l2-device: Register sub-device nodes at sub-device registration time
  omap3isp: Move sub-device link creation to notifier bound callback
  omap3isp: Initialise "crashed" media entity enum in probe
  omap3isp: Move media device registration to probe
  omap3isp: Drop the async notifier callback
  v4l2-fwnode: Add abstracted sub-device notifiers
  smiapp: Add support for flash and lens devices

 .../devicetree/bindings/media/video-interfaces.txt |  10 +
 Documentation/media/kapi/v4l2-subdev.rst           |  20 +
 MAINTAINERS                                        |   6 +
 arch/arm/boot/dts/omap3-n9.dts                     |   1 +
 arch/arm/boot/dts/omap3-n950-n9.dtsi               |  14 +
 arch/arm/boot/dts/omap3-n950.dts                   |   1 +
 drivers/acpi/property.c                            |  27 +
 drivers/base/property.c                            |  12 +
 drivers/leds/Kconfig                               |   8 +
 drivers/leds/Makefile                              |   1 +
 drivers/leds/leds-as3645a.c                        | 762 +++++++++++++++++++++
 drivers/media/i2c/smiapp/smiapp-core.c             |   5 +
 drivers/media/platform/omap3isp/isp.c              | 144 ++--
 drivers/media/platform/omap3isp/isp.h              |   3 -
 drivers/media/v4l2-core/v4l2-async.c               |  96 ++-
 drivers/media/v4l2-core/v4l2-device.c              | 139 ++--
 drivers/media/v4l2-core/v4l2-fwnode.c              | 174 +++++
 drivers/media/v4l2-core/v4l2-subdev.c              |  44 +-
 drivers/of/property.c                              |  31 +
 include/linux/fwnode.h                             |  19 +
 include/linux/property.h                           |   4 +
 include/media/v4l2-async.h                         |  26 +-
 include/media/v4l2-fwnode.h                        |  21 +
 include/media/v4l2-subdev.h                        |  11 +
 24 files changed, 1388 insertions(+), 191 deletions(-)
 create mode 100644 drivers/leds/leds-as3645a.c

-- 
2.11.0
