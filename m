Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:58956 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758602AbcIHJWD (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Sep 2016 05:22:03 -0400
From: Todor Tomov <todor.tomov@linaro.org>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        mchehab@osg.samsung.com, hverkuil@xs4all.nl, geert@linux-m68k.org,
        matrandg@cisco.com, sakari.ailus@iki.fi,
        linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com,
        Todor Tomov <todor.tomov@linaro.org>
Subject: [PATCH v6 0/2] OV5645 camera sensor driver
Date: Thu,  8 Sep 2016 12:13:53 +0300
Message-Id: <1473326035-25228-1-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is the sixth version of the OV5645 camera sensor driver patchset.

Changes since version 5 include:
- external clock frequency set in DT;
- added v4l2_subdev_pad_ops.init_cfg function to initialize formats;
- current sensor mode not updated if set_fmt is TRY (not ACTIVE);
- other small changes - debug messages removed, register addresses defines
  renamed, redundant safety checks removed, unnecessary labels removed,
  mutex_destroy added.

Two one-line changes since version 4:
- return current format on set_format;
- return all frame sizes when enumerating them.

Only one change since version 3:
- build failure on kernel v4.7-rc1 fixed:
  s/media_entity_init/media_entity_pads_init/

Changes from version 2 include:
- external camera clock configuration is moved from DT to driver;
- pwdn-gpios renamed to enable-gpios;
- switched polarity of reset-gpios to the more intuitive active low;
- added Kconfig dependency to OF;
- return values checks;
- regulators and gpios are now required (not optional);
- regulators names renamed;
- power counter variable changed to a bool power state;
- ov5645_registered() is removed and sensor id reading moved to probe().

Changes from version 1 include:
- patch split to dt binding doc patch and driver patch;
- changes in power on/off logic - s_power is now not called on
  open/close;
- using assigned-clock-rates in dt for setting camera external
  clock rate;
- correct api for gpio handling;
- return values checks;
- style fixes.

Todor Tomov (2):
  media: i2c/ov5645: add the device tree binding document
  media: Add a driver for the ov5645 camera sensor.

 .../devicetree/bindings/media/i2c/ov5645.txt       |   52 +
 drivers/media/i2c/Kconfig                          |   12 +
 drivers/media/i2c/Makefile                         |    1 +
 drivers/media/i2c/ov5645.c                         | 1372 ++++++++++++++++++++
 4 files changed, 1437 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ov5645.txt
 create mode 100644 drivers/media/i2c/ov5645.c

-- 
1.9.1

