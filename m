Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f175.google.com ([209.85.128.175]:33304 "EHLO
        mail-wr0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932954AbdCUPUE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Mar 2017 11:20:04 -0400
Received: by mail-wr0-f175.google.com with SMTP id u48so114094033wrc.0
        for <linux-media@vger.kernel.org>; Tue, 21 Mar 2017 08:19:58 -0700 (PDT)
From: Neil Armstrong <narmstrong@baylibre.com>
To: dri-devel@lists.freedesktop.org,
        laurent.pinchart+renesas@ideasonboard.com, architt@codeaurora.org,
        mchehab@kernel.org
Cc: Neil Armstrong <narmstrong@baylibre.com>, Jose.Abreu@synopsys.com,
        kieran.bingham@ideasonboard.com, linux-amlogic@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-media@vger.kernel.org, hans.verkuil@cisco.com,
        sakari.ailus@linux.intel.com
Subject: [PATCH v4 0/6] drm: bridge: dw-hdmi: Add support for Custom PHYs
Date: Tue, 21 Mar 2017 16:12:35 +0100
Message-Id: <1490109161-20529-1-git-send-email-narmstrong@baylibre.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Amlogic GX SoCs implements a Synopsys DesignWare HDMI TX Controller
in combination with a very custom PHY.

Thanks to Laurent Pinchart's changes, the HW report the following :
 Detected HDMI TX controller v2.01a with HDCP (meson_dw_hdmi_phy)

The following differs from common PHY integration as managed in the current
driver :
 - Amlogic PHY is not configured through the internal I2C link
 - Amlogic PHY do not use the ENTMDS, SVSRET, PDDQ, ... signals from the controller
 - Amlogic PHY do not export HPD ands RxSense signals to the controller

And finally, concerning the controller integration :
 - the Controller registers are not flat memory-mapped, and uses an
    addr+read/write register pair to write all registers.
 - Inputs only YUV444 pixel data

Most of these uses case are implemented in Laurent Pinchart v5.1 patchset merged
in drm-misc-next branch.

This is why the following patchset implements :
 - Configure the Input format from the plat_data
 - Add PHY callback to handle HPD and RxSense out of the dw-hdmi driver

To implement the input format handling, the Synopsys HDMIT TX Controller input
V4L bus formats are used and missing formats + documentation are added.

This patchset makes the Amlogic GX SoCs HDMI output successfully work, and is
also tested on the RK3288 ACT8846 EVB Board.

Changes since v3 at [4] :
 - Fix 4:2:0 bus formats naming
 - Add separate 36bit and 48bit tables for bus formats documentation
 - Added 4:2:0 bus config in hdmi_video_sample
 - Moved dw_hdmi documentation in a "bridge" subdir
 - Rebase on drm-misc-next at 62c58af32c93

Changes since v2 at [3] :
 - Rebase on laurent patch "Extract PHY interrupt setup to a function"
 - Reduce phy operations
 - Switch the V4L bus formats and encodings instead of custom enum

Changes since v1 at [2] :
 - Drop patches submitted by laurent

Changes since RFC at [1] :
 - Regmap fixup for 4bytes register access, tested on RK3288 SoC
 - Move phy callbacks to phy_ops and move Synopsys PHY calls into default ops
 - Move HDMI link data into shared header
 - Move Pixel Encoding enum to shared header

[1] http://lkml.kernel.org/r/1484656294-6140-1-git-send-email-narmstrong@baylibre.com
[2] http://lkml.kernel.org/r/1485774318-21916-1-git-send-email-narmstrong@baylibre.com
[3] http://lkml.kernel.org/r/1488468572-31971-1-git-send-email-narmstrong@baylibre.com
[4] http://lkml.kernel.org/r/1488904944-14285-1-git-send-email-narmstrong@baylibre.com

Laurent Pinchart (1):
  drm: bridge: dw-hdmi: Extract PHY interrupt setup to a function

Neil Armstrong (5):
  media: uapi: Add RGB and YUV bus formats for Synopsys HDMI TX
    Controller
  documentation: media: Add documentation for new RGB and YUV bus
    formats
  drm: bridge: dw-hdmi: Switch to V4L bus format and encodings
  drm: bridge: dw-hdmi: Add Documentation on supported input formats
  drm: bridge: dw-hdmi: Move HPD handling to PHY operations

 Documentation/gpu/bridge/dw-hdmi.rst            |  15 +
 Documentation/gpu/index.rst                     |   1 +
 Documentation/media/uapi/v4l/subdev-formats.rst | 871 +++++++++++++++++++++++-
 drivers/gpu/drm/bridge/synopsys/dw-hdmi.c       | 469 ++++++++-----
 include/drm/bridge/dw_hdmi.h                    |  68 ++
 include/uapi/linux/media-bus-format.h           |  13 +-
 6 files changed, 1266 insertions(+), 171 deletions(-)
 create mode 100644 Documentation/gpu/bridge/dw-hdmi.rst

-- 
1.9.1
