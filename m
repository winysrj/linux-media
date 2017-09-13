Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00252a01.pphosted.com ([62.209.51.214]:19961 "EHLO
        mx07-00252a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751399AbdIMPIn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Sep 2017 11:08:43 -0400
Received: from pps.filterd (m0102628.ppops.net [127.0.0.1])
        by mx07-00252a01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v8DF3eNK022610
        for <linux-media@vger.kernel.org>; Wed, 13 Sep 2017 16:08:41 +0100
Received: from mail-wm0-f70.google.com (mail-wm0-f70.google.com [74.125.82.70])
        by mx07-00252a01.pphosted.com with ESMTP id 2cv5pysxk5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
        for <linux-media@vger.kernel.org>; Wed, 13 Sep 2017 16:08:41 +0100
Received: by mail-wm0-f70.google.com with SMTP id i192so1048874wme.5
        for <linux-media@vger.kernel.org>; Wed, 13 Sep 2017 08:08:41 -0700 (PDT)
From: Dave Stevenson <dave.stevenson@raspberrypi.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Eric Anholt <eric@anholt.net>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        linux-media@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
        devicetree@vger.kernel.org
Cc: Dave Stevenson <dave.stevenson@raspberrypi.org>
Subject: [PATCH v2 0/4] BCM283x Camera Receiver driver
Date: Wed, 13 Sep 2017 16:07:45 +0100
Message-Id: <cover.1505140980.git.dave.stevenson@raspberrypi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All.

This is v2 for adding a V4L2 subdevice driver for the CSI2/CCP2 camera
receiver peripheral on BCM283x, as used on Raspberry Pi.
Sorry for the delay since v1 - other tasks assigned, got sucked
into investigating why some devices were misbehaving, and
picking up on new features that had been added to the tree (eg CCP2).

v4l2-compliance results depend on the sensor subdevice connected to.
I have results for TC358743, ADV7282M, and OV5647 that I'll
send them as a follow up email.

OV647 and ADV7282M are now working with this driver, as well as TC358743.
v1 of the driver only supported continuous clock mode which Unicam was
failing to lock on to correctly.
The driver now checks the clock mode and adjusts termination accordingly.
Something is still a little off for OV5647, but I'll investigate that
later.

As per the v1 discussion with Hans, I have added text describing the
differences between this driver and the one in staging/vc04_service.
Addressing some of the issues in the bcm2835-camera driver is on my to-do
list, and I'll add similar text there when I'm dealing with that.

For those wanting to see the driver in context,
https://github.com/6by9/upstream-linux/tree/unicam is the linux-media
tree with my mods on top. It also includes a couple of TC358743 and
OV5647 driver updates that I'll send to the list in the next few days.

Thanks in advance.
  Dave

Changes from v1 to v2:
- Broken out a new helper function v4l2_fourcc2s as requested by Hans.
- Documented difference between this driver and the bcm2835-camera driver
  in staging/vc04_services.
- Corrected handling of s_dv_timings and s_std to update the current format
  but only if not streaming. This refactored some of the s_fmt code to
  remove duplication.
- Updated handling of sizeimage to include vertical padding. (Not updated
  the bytesperline calcs as the app can override).
- Added support for continuous clock mode (requires changes to lane
  termination configuration).
- Add support for CCP2 as Sakari's patches to support it have now been merged.
  I don't have a suitable sensor to test it with at present, but all settings
  have been taken from a known working configuration. If people would prefer
  I remove this until it has been proved against hardware then I'm happy to
  do so.
- Updated DT bindings to use <data-lanes> on the Unicam node to set the
  maximum number of lanes present instead of a having a custom property.
  Documents the mandatory endpoint properties.
- Removed RAW16 from the list of input formats as it isn't defined in the
  CSI-2 spec. The peripheral can still unpack the other Bayer formats to
  a 16 bit/pixel packing though.
- Added a log-status handler to get the status from the sensor.
- Automatically switch away from any interlaced formats reported via g_fmt,
  or that are attempted to be set via try/s_fmt.
- Addressed other more minor code review comments from v1.

Dave Stevenson (4):
  [media] v4l2-common: Add helper function for fourcc to string
  [media] dt-bindings: Document BCM283x CSI2/CCP2 receiver
  [media] bcm2835-unicam: Driver for CCP2/CSI2 camera interface
  MAINTAINERS: Add entry for BCM2835 camera driver

 .../devicetree/bindings/media/bcm2835-unicam.txt   |  107 +
 MAINTAINERS                                        |    7 +
 drivers/media/platform/Kconfig                     |    1 +
 drivers/media/platform/Makefile                    |    1 +
 drivers/media/platform/bcm2835/Kconfig             |   14 +
 drivers/media/platform/bcm2835/Makefile            |    3 +
 drivers/media/platform/bcm2835/bcm2835-unicam.c    | 2192 ++++++++++++++++++++
 drivers/media/platform/bcm2835/vc4-regs-unicam.h   |  264 +++
 drivers/media/v4l2-core/v4l2-common.c              |   18 +
 include/media/v4l2-common.h                        |    3 +
 10 files changed, 2610 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/bcm2835-unicam.txt
 create mode 100644 drivers/media/platform/bcm2835/Kconfig
 create mode 100644 drivers/media/platform/bcm2835/Makefile
 create mode 100644 drivers/media/platform/bcm2835/bcm2835-unicam.c
 create mode 100644 drivers/media/platform/bcm2835/vc4-regs-unicam.h

-- 
2.7.4
