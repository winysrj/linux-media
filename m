Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:60973 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753011AbdLMS0b (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Dec 2017 13:26:31 -0500
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: sakari.ailus@linux.intel.com
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        niklas.soderlund@ragnatech.se, kieran.bingham@ideasonboard.com,
        laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH 0/5] Add debug output to v4l2-async
Date: Wed, 13 Dec 2017 19:26:15 +0100
Message-Id: <1513189580-32202-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Sakari,
   while testing rcar-vin setup on top of your RFC (included in the series)
that moves the framework to perform endpoint matching, I realized how hard is
to follow what happens with asynchronous notifiers, sub-notifiers and
sub-devices.

In order to better understand what happens and ease debug of v4l2-async
operations I have introduced some dev_dbg() output, protected by a Kconfig
option.

Before being able to properly identify (sub-)notifiers and subdevices I had to
extend fwnode_* framework to support a new .get_name() operation, and modify
v4l2_async to make sure notifiers always have a valid fwnode_handle field to
be identified with.

I have tested this only with not yet mainlined drivers (rcar-vin, rcar-csi2,
max9286) each of them performing non-trivial endpoint matching. Also I only
tested this on OF based systems (not tested on ACPI).
This considered, I am copying linux-media anyhow for feedbacks.

Thanks
   j

Jacopo Mondi (4):
  device property: Add fwnode_get_name() operation
  include: v4l2_async: Add 'owner' field to notifier
  v4l2: async: Postpone subdev_notifier registration
  v4l2: async: Add debug output to v4l2-async module

Sakari Ailus (1):
  v4l: async: Use endpoint node, not device node, for fwnode match

 drivers/acpi/property.c                        |   6 +
 drivers/base/property.c                        |  12 ++
 drivers/media/platform/am437x/am437x-vpfe.c    |   2 +-
 drivers/media/platform/atmel/atmel-isc.c       |   2 +-
 drivers/media/platform/atmel/atmel-isi.c       |   2 +-
 drivers/media/platform/davinci/vpif_capture.c  |   2 +-
 drivers/media/platform/exynos4-is/media-dev.c  |  14 ++-
 drivers/media/platform/pxa_camera.c            |   2 +-
 drivers/media/platform/qcom/camss-8x16/camss.c |   2 +-
 drivers/media/platform/rcar_drif.c             |   2 +-
 drivers/media/platform/stm32/stm32-dcmi.c      |   2 +-
 drivers/media/platform/ti-vpe/cal.c            |   2 +-
 drivers/media/platform/xilinx/xilinx-vipp.c    |  16 ++-
 drivers/media/v4l2-core/Kconfig                |   8 ++
 drivers/media/v4l2-core/v4l2-async.c           | 152 +++++++++++++++++++++----
 drivers/media/v4l2-core/v4l2-fwnode.c          |   2 +-
 drivers/of/property.c                          |   6 +
 include/linux/fwnode.h                         |   2 +
 include/linux/property.h                       |   1 +
 include/media/v4l2-async.h                     |   4 +
 20 files changed, 200 insertions(+), 41 deletions(-)

--
2.7.4
