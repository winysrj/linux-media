Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:57215 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753242AbcKNKZI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Nov 2016 05:25:08 -0500
From: Todor Tomov <todor.tomov@linaro.org>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        mchehab@osg.samsung.com, hverkuil@xs4all.nl, geert@linux-m68k.org,
        matrandg@cisco.com, sakari.ailus@iki.fi,
        linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com
Cc: Todor Tomov <todor.tomov@linaro.org>
Subject: [PATCH v7 0/2] OV5645 camera sensor driver
Date: Mon, 14 Nov 2016 12:24:34 +0200
Message-Id: <1479119076-26363-1-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is the seventh version of the OV5645 camera sensor driver patchset.

Changes since version 6 include:
- keep a pointer to the current sensor mode and remove enum ov5645_mode;
- do not keep v4l2 control values and xclk frequency in the main data struct;
- add caching variables in then main data struct for some of the register values
  to avoid i2c read commands;
- use reference counting for power state;
- enable xclk only after regulators are enabled;
- add check for xclk rate that it is supported;
- register v4l2 subdev only at the end of probe when the rest is succeeded;
- add hardware pin names in gpio descriptions in the dt binding document;
- other minor changes: uppercase to lowercase, add const modifier, remove
  unnecessary local variables, fix return values.

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

 .../devicetree/bindings/media/i2c/ov5645.txt       |   54 +
 drivers/media/i2c/Kconfig                          |   12 +
 drivers/media/i2c/Makefile                         |    1 +
 drivers/media/i2c/ov5645.c                         | 1354 ++++++++++++++++++++
 4 files changed, 1421 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ov5645.txt
 create mode 100644 drivers/media/i2c/ov5645.c

-- 
1.9.1

