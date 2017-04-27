Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:43018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1164040AbdD0S0M (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Apr 2017 14:26:12 -0400
From: Kieran Bingham <kbingham@kernel.org>
To: laurent.pinchart@ideasonboard.com, niklas.soderlund@ragnatech.se,
        sakari.ailus@iki.fi
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH 0/5] RFC: ADV748x HDMI/Analog video receiver
Date: Thu, 27 Apr 2017 19:25:59 +0100
Message-Id: <1493317564-18026-1-git-send-email-kbingham@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

This is an RFC for the Analog Devices ADV748x driver, and follows on from a
previous posting by Niklas Söderlund [0] of an earlier incarnation of this
driver.

This is an early posting of the driver following the release early, release
often method after quite a bit of refactoring in an attempt to bring it
closer to mainline.

Aside from a few bug fixes, and considerable refactoring this driver:
 - is refactored to multiple object files
 - defines multiple sub devices for the output paths.
 - has independant controls for both HDMI and Analog video paths
 - extends V4L2 async matching to support 'ports' on V4L2_ASYNC_MATCH_OF

The ADV7481 and ADV7482 support two video pipelines which can run independently
of each other, with each pipeline terminating in a CSI-2 output: TXA (4-Lane)
and TXB (1-Lane)

The ADV7480 (Not yet included here), ADV7481, and ADV7482 are all derivatives,
with the following features

            Analog   HDMI  MHL  4-Lane  1-Lane
              In      In         CSI     CSI
 ADV7480               X    X     X
 ADV7481      X        X    X     X       X
 ADV7482      X        X          X       X

This RFC statically routes the HDMI in through the TXA and the CVBS through the
TXB for early development, though I anticipate splitting the TXA/HDMI and 
TXB/AFE (Analog Front End) into distinct sub devices, allowing configurable
routing. This split is dependant upon on-going 'incremental binding' work being
done and thus is not yet included in this RFC.

Further potential development areas include:
 - ADV7480 Support (No AFE)
 - MHL support (Not present on ADV7482)
 - EDID support
 - CEC Support
 - Configurable I2C addressing
 - Interrupt handling for format changes and hotplug detect.

However, this driver and series is functional without the above, though if
there are mandatory areas which block mainline integration please let me know
and I will prioritise that in development.

Particular topics for discussion and review requested here include:

 - Device tree bindings specification and port listings review

 - Async Subdev port matching on V4L2_ASYNC_MATCH_OF

There are two implementations possible for the subdevice matching:
   A) Matching on a root dev-node, with a port specification
   B) Creating a new V4L2_ASYNC_MATCH_OF_ENDPOINT

This series posts an initial version utilising Method A.

Here we extend the subdevice and allow the drivers to assign defined 'port'
numbers to subdevices so that they can be distinguised against a common root
of_node.

This method involves the least change overall, and doesn't require the ADV7482
to parse it's device tree in advance.


Method B) is an option I have also considered, but requires as stated that the
driver must parse it's device tree, and instead of passing a root of_node, would
pass the endpoint for matching.

The difficulty here will be in communicating to the consumer / async-notifier
that instead of the V4L2_ASYNC_MATCH_OF, a V4L2_ASYNC_MATCH_OF_ENDPOINT should
be used. Thoughts on this would be appreciated.


This series presents the following patches:

 [PATCH 1/5] v4l2-subdev: Provide a port mapping for asynchronous
 [PATCH 2/5] rcar-vin: Match sources against ports if specified.
 [PATCH 3/5] media: i2c: adv748x: add adv748x driver
 [PATCH 4/5] arm64: dts: r8a7795: salvator-x: enable VIN, CSI and ADV7482
 [PATCH 5/5] arm64: dts: r8a7796: salvator-x: enable VIN, CSI and ADV7482

Patch 1 provides V4L2 support for the 'Method A' mentioned above.
Patch 2 is dependant upon Niklas' rcar-vin series [1], and adds support to the
 binding multiple subdevices from a single DT node.
Patch 3 is the new driver
Patch 4 and 5 add support to the Salvator-X platforms where this code has been
 tested

I appreciate that there are still some 'rough edges' in the driver, which is
still under development, but all comments are welcome.


[0] http://www.mail-archive.com/linux-renesas-soc@vger.kernel.org/msg05196.html
[1] https://git.ragnatech.se/linux rcar-vin-elinux-v7 


Kieran Bingham (5):
  v4l2-subdev: Provide a port mapping for asynchronous subdevs
  rcar-vin: Match sources against ports if specified.
  media: i2c: adv748x: add adv748x driver
  arm64: dts: r8a7795: salvator-x: enable VIN, CSI and ADV7482
  arm64: dts: r8a7796: salvator-x: enable VIN, CSI and ADV7482

 .../devicetree/bindings/media/i2c/adv748x.txt      |  63 ++
 MAINTAINERS                                        |   6 +
 arch/arm64/boot/dts/renesas/r8a7795-salvator-x.dts | 129 ++++
 arch/arm64/boot/dts/renesas/r8a7796-salvator-x.dts | 129 ++++
 drivers/media/i2c/Kconfig                          |  10 +
 drivers/media/i2c/Makefile                         |   1 +
 drivers/media/i2c/adv748x/Makefile                 |   6 +
 drivers/media/i2c/adv748x/adv748x-afe.c            | 614 ++++++++++++++++++
 drivers/media/i2c/adv748x/adv748x-core.c           | 573 +++++++++++++++++
 drivers/media/i2c/adv748x/adv748x-hdmi.c           | 690 +++++++++++++++++++++
 drivers/media/i2c/adv748x/adv748x.h                | 157 +++++
 drivers/media/platform/rcar-vin/rcar-core.c        |  15 +-
 drivers/media/v4l2-core/v4l2-async.c               |   7 +
 drivers/media/v4l2-core/v4l2-subdev.c              |   1 +
 include/media/v4l2-async.h                         |   1 +
 include/media/v4l2-subdev.h                        |   2 +
 16 files changed, 2397 insertions(+), 7 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/adv748x.txt
 create mode 100644 drivers/media/i2c/adv748x/Makefile
 create mode 100644 drivers/media/i2c/adv748x/adv748x-afe.c
 create mode 100644 drivers/media/i2c/adv748x/adv748x-core.c
 create mode 100644 drivers/media/i2c/adv748x/adv748x-hdmi.c
 create mode 100644 drivers/media/i2c/adv748x/adv748x.h

-- 
2.7.4
