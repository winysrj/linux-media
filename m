Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:35459 "EHLO
        mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755476AbdCGSno (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Mar 2017 13:43:44 -0500
Received: by mail-wm0-f42.google.com with SMTP id v186so97268126wmd.0
        for <linux-media@vger.kernel.org>; Tue, 07 Mar 2017 10:42:44 -0800 (PST)
From: Neil Armstrong <narmstrong@baylibre.com>
To: dri-devel@lists.freedesktop.org,
        laurent.pinchart+renesas@ideasonboard.com, architt@codeaurora.org,
        mchehab@kernel.org
Cc: Neil Armstrong <narmstrong@baylibre.com>, Jose.Abreu@synopsys.com,
        kieran.bingham@ideasonboard.com, linux-amlogic@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-media@vger.kernel.org, hans.verkuil@cisco.com,
        sakari.ailus@linux.intel.com
Subject: [PATCH v3 0/6] drm: bridge: dw-hdmi: Add support for Custom PHYs
Date: Tue,  7 Mar 2017 17:42:18 +0100
Message-Id: <1488904944-14285-1-git-send-email-narmstrong@baylibre.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Amlogic GX SoCs implements a Synopsys DesignWare HDMI TX Controller
in combination with a very custom PHY.

Thanks to Laurent Pinchart's changes, the HW report the following :
 Detected HDMI TX controller v2.01a with HDCP (Vendor PHY)

The following differs from common PHY integration as managed in the current
driver :
 - Amlogic PHY is not configured through the internal I2C link
 - Amlogic PHY do not use the ENTMDS, SVSRET, PDDQ, ... signals from the controller
 - Amlogic PHY do not export HPD ands RxSense signals to the controller

And finally, concerning the controller integration :
 - the Controller registers are not flat memory-mapped, and uses an
    addr+read/write register pair to write all registers.
 - Inputs only YUV444 pixel data

Most of these uses case are implemented in Laurent Pinchart v5.1 patchset at [3] :
 - Conversion to regmap for register access
 - Add more callbacks ops to handle Custom PHYs
 - Fixes a bug that considers the input to be always RBG and sends bad pixel
   format to a DVI sink by disabling CSC

This is why the following patchset implements :
 - Configure the Input format from the plat_data
 - Add PHY callback to handle HPD and RxSense out of the dw-hdmi driver

To implement the input format handling, the Synopsys HDMIT TX Controller input
V4L bus formats are used and missing formats + documentation are added.

This patchset makes the Amlogic GX SoCs HDMI output successfully work, and is
also tested on the RK3288 ACT8846 EVB Board.

Changes since v2 at [4] :
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
[3] http://lkml.kernel.org/r/20170303172007.26541-1-laurent.pinchart+renesas@ideasonboard.com
[4] http://lkml.kernel.org/r/1488468572-31971-1-git-send-email-narmstrong@baylibre.com

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

 Documentation/gpu/dw-hdmi.rst                   |   15 +
 Documentation/gpu/index.rst                     |    1 +
 Documentation/media/uapi/v4l/subdev-formats.rst | 4992 ++++++++++++++++++-----
 drivers/gpu/drm/bridge/synopsys/dw-hdmi.c       |  465 ++-
 include/drm/bridge/dw_hdmi.h                    |   68 +
 include/uapi/linux/media-bus-format.h           |   13 +-
 6 files changed, 4368 insertions(+), 1186 deletions(-)
 create mode 100644 Documentation/gpu/dw-hdmi.rst

-- 
1.9.1
