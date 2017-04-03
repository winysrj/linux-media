Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:49211 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751792AbdDCOL2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 3 Apr 2017 10:11:28 -0400
From: Todor Tomov <todor.tomov@linaro.org>
To: mchehab@kernel.org, laurent.pinchart@ideasonboard.com,
        hans.verkuil@cisco.com, sakari.ailus@iki.fi,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Todor Tomov <todor.tomov@linaro.org>
Subject: [PATCH v8 0/2] OV5645 camera sensor driver
Date: Mon,  3 Apr 2017 17:01:50 +0300
Message-Id: <1491228110-28464-1-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Resending the OV5645 camera sensor driver patchset to include
devicetree@vger.kernel.org too.
As there are two one-line changes (agreed on linux-media) I've also
increased the patchset version to 8th.

Changes since verion 7:
- "unsigned int i" changed to "int i" in ov5645_find_nearest_mode();
- unused varialbe removed from ov5645_entity_init_cfg().

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
 drivers/media/i2c/ov5645.c                         | 1351 ++++++++++++++++++++
 4 files changed, 1418 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ov5645.txt
 create mode 100644 drivers/media/i2c/ov5645.c

-- 
1.9.1
